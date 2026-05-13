import os
import streamlit as st

st.set_page_config(page_title="Cathay Bank Docs Viewer", page_icon=":page_facing_up:", layout="wide")

conn = st.connection("snowflake", ttl=os.getenv("SNOWFLAKE_CONNECTION_TTL"))
session = conn.session()

WORKSPACE_STAGE = '@"USER$".PUBLIC."Cathay-Bank"/versions/live'

@st.cache_data(ttl=300)
def list_workspace_files():
    rows = session.sql(f"LIST {WORKSPACE_STAGE}").collect()
    files = [r["name"] for r in rows]
    svg_files = sorted([f for f in files if f.lower().endswith(".svg")])
    md_files = sorted([f for f in files if f.lower().endswith(".md")])
    return svg_files, md_files

@st.cache_data(ttl=300)
def read_file_content(stage_path):
    import tempfile
    local_dir = tempfile.mkdtemp()
    session.sql(f"GET {WORKSPACE_STAGE}/{stage_path} file://{local_dir}/").collect()
    filename = os.path.basename(stage_path)
    local_path = os.path.join(local_dir, filename)
    if not os.path.exists(local_path):
        local_path_gz = local_path + ".gz"
        if os.path.exists(local_path_gz):
            import gzip
            import shutil
            with gzip.open(local_path_gz, "rb") as f_in, open(local_path, "wb") as f_out:
                shutil.copyfileobj(f_in, f_out)
    with open(local_path, "r", encoding="utf-8") as f:
        return f.read()

def strip_stage_prefix(full_path):
    parts = full_path.split("/versions/live/", 1)
    if len(parts) == 2:
        return parts[1]
    return full_path

def display_name(stage_path):
    return strip_stage_prefix(stage_path)

svg_files, md_files = list_workspace_files()

st.sidebar.title(":page_facing_up: Doc Viewer")
st.sidebar.caption("Browse workspace SVG and Markdown files")

if st.sidebar.button("Refresh file list"):
    list_workspace_files.clear()
    read_file_content.clear()
    st.rerun()

file_type = st.sidebar.radio("File type", ["SVG Images", "Markdown Files"])

if file_type == "SVG Images":
    if not svg_files:
        st.warning("No SVG files found in workspace.")
    else:
        names = [display_name(f) for f in svg_files]
        selected_idx = st.sidebar.selectbox("Select SVG", range(len(names)), format_func=lambda i: names[i])
        selected = svg_files[selected_idx]
        rel = strip_stage_prefix(selected)
        st.header(rel)
        with st.spinner("Loading SVG..."):
            content = read_file_content(rel)
        st.html(f'<div style="width:100%;overflow:auto;background:#fff;padding:16px;border-radius:8px;">{content}</div>')

else:
    if not md_files:
        st.warning("No Markdown files found in workspace.")
    else:
        names = [display_name(f) for f in md_files]
        selected_idx = st.sidebar.selectbox("Select Markdown", range(len(names)), format_func=lambda i: names[i])
        selected = md_files[selected_idx]
        rel = strip_stage_prefix(selected)
        st.header(rel)
        with st.spinner("Loading Markdown..."):
            content = read_file_content(rel)
        st.markdown(content, unsafe_allow_html=True)
