# Snowflake Intelligence Agent Project Template

## Purpose
Your financial journey is our business
More than half a century ago, we opened our doors at Cathay Bank to serve the growing Chinese American community in Los Angeles. Then, as now, we helped our customers put down new roots with loans to purchase homes. We supported their businesses, which continue to sustain generations. We worked with them to cultivate communities united by a shared drive to create and build lives in Southern California.
Over time, we have expanded along with our customers. Today, we’re a subsidiary of Cathay General Bancorp (Nasdaq: CATY). We have over 60 branches across the United States, a branch in Hong Kong, and three representative offices in Beijing, Shanghai and Taipei.

While the people we serve have evolved and changed, the spirit that makes up our customers remains the same. Every one believes in the power of initiative and perseverance. Each aims to achieve what’s possible. All strive to live their best lives. And we’re happy to work alongside them — providing the tools and services to get them where they want to go.

Helping our customers flourish
Personal banking. Home loans. Commercial financing. Every customer is on a journey, ready to achieve what’s next.

Cathay Bank is here to support these dreams with hard work and heart. Customer experience remains our priority, as it has for more than 60 years. Powered by well-trained and motivated employees, Cathay Bank works closely with customers, providing the financial tools and services to get them where they want to go.

## Customer details
Inspiring Confidence, Enabling Dreams.
We take pride in our American roots, where quality meets diversity and opportunity, innovation thrives, and community matters most.

Cathay Bank celebrated its 25th anniversary at the Los Angeles Chinatown headquarters in 1987.
The iconic Cathay Bank Headquarter building in Chinatown, Los Angeles
In 1962, when we first opened our doors in Los Angeles Chinatown, we set out with the purpose of providing the Chinese American community with access to our nation’s banking system for the first time.

We are the oldest operating American bank founded by Chinese Americans. We take great pride in fostering financial security, supporting local communities, and upholding the values of trust and integrity that define America’s financial landscape.

A black and white photo from 1960 shows the founders of Cathay Bank standing outside of the first branch in Los Angeles’ Chinatown in California.
Founding Members of Cathay Bank
(from left to right) John R. MacFaden, Lun Hong Quan, F. Chow Chan, Gerald T. Deal, George T.M. Ching, John F. Varela; absent from picture: Dr. T.Y. Kwong
Mr. George T.M. Ching was the founding visionary for Cathay Bank. Born in Berkeley, California in 1914, George earned his master's degree from Stanford in economics with a focus on banking at the height of the Great Depression. Having settled with his wife in Los Angeles in the 1950s, he noticed that few financial services were made available to Chinese immigrants. With a career in banking, George envisioned a future where there exists a bank to aid Chinese immigrants in fulfilling their financial needs, offering them the same opportunities as their fellow Americans, and to build a future in this country. George set out to rally like-minded individuals who shared his vision of inclusivity and opportunity. Together, seven community members pooled their resources and founded Cathay Bank in 1962.

As we witnessed our community grow, Cathay Bank grew alongside them. Through the years, our U.S. presence has grown tremendously. We expanded from Southern California to Northern California, then to New York and Texas in 1999, Washington in 2000, Massachusetts in 2003, Illinois in 2006, New Jersey in 2007, Nevada in 2013, and Maryland in 2015. Today, we continue to expand through over 60 branches across nine states. Internationally, we have one branch in Hong Kong, and representative offices in Taipei, Shanghai, and Beijing.

Growth, as a company, goes beyond just brick-and-mortar. It is reflected in our performance and our ability to earn the public’s trust. After we went public in 1990 (Nasdaq: CATY), we grew to become one of the 100 largest financial companies listed on the Nasdaq based on market capitalization in 2000.

Cathay General Bancorp virtually rang the Nasdaq opening bell to celebrate the 30th anniversary of its Nasdaq listing.
Today, we continue to be recognized as a top performing U.S. bank. Since 2016, we have been consistently named by Forbes as one of the top 20 “Best Banks in America.”

With our headquarters in Los Angeles, we continue to serve our communities across nine states with an open door. And we remain committed to our founding promise: We open up financial opportunities for all to build a future in this country.

## Customer Configuration

**To create a new project, replace these variables throughout:**

| Variable | Description | Example (Cathay Bank) |
|----------|-------------|-------------------|
| `{CUSTOMER_NAME}` | Customer name | Cathay Bank |
| `{CUSTOMER_NAME_UPPER}` | Uppercase for SQL objects | CATHAY_BANK |
| `{DATABASE_NAME}` | Main database name | CATHAY_BANK_DB |
| `{WAREHOUSE_NAME}` | Warehouse name | CATHAY_BANK_WH |
| `{AGENT_NAME}` | Agent identifier | CATHAY_BNK_AGENT |
| `{BUSINESS_DOMAIN}` | Customer's business focus | Financial Banking Systems |
| `{WEB_PRESENCE}`  | Web Address | https://www.CATHAYBANK.com/

---

## Project Instructions

```Build a complete Snowflake Intelligence architecture and implementation plan for Early Warning.

The proposed architecture is a modern, streaming-first Scalable ELT Pipeline designed for near real-time data availability, scalability, and maintainability.  All of the financial data will stream data into Snowflake and they have the desire to be able to ask questions of their data with Natural Language Queries.

(Note: All project images should be SVG graphics)
 This Project should encompass all aspects of the details identified on their website. The Agent Project Structure directories should be created in the root github repo directory.

 ```

## Build the Ontology
```
Build a formal ontology, for banking, and integrate into the Snowflake Agentic Framework to provide a more exacting nature or structure to the platform.

The Snowflake agentic framework is architecturally ready to integrate a formal ontology today, even though it doesn't natively provide one. Here's how it could work for banking:

🏗️ How a Banking Ontology Could Plug Into the Cortex Agent Framework
The Cortex Agent supports five tool types1, and a formal ontology could leverage several of them simultaneously:

1. Custom Tools — The Primary Integration Point
Use the banking ontology (e.g., FIBO — the Financial Industry Business Ontology) load into Snowflake tables you create representing classes, properties, and relationships. A stored procedure or UDF could then serve as the reasoning engine:

Agent receives: "What are our AML compliance exposures for correspondent banking relationships?"
Custom tool queries the ontology graph to resolve that "correspondent banking" is a subclass of "Wholesale Banking," that AML is linked to BSA/OFAC/FinCEN regulations, and that "exposure" maps to specific risk metrics
This deterministic resolution then feeds precise parameters to the Semantic View query — no LLM guessing required
2. Cortex Search — Ontology as a Knowledge Base
The ontology's class definitions, relationship descriptions, and regulatory mappings could be indexed via Cortex Search, giving the agent a searchable reference for domain concepts it encounters in user questions.

3. Enriched Semantic Views — Ontology-Informed Descriptions
The semantic view definitions (metrics, dimensions, facts) could be annotated with ontology terms, making the tool descriptions more precise. Instead of:

"This table contains transaction data"

You have:

"This table contains payment transactions as defined by ISO 20022, linked to counterparty entities classified under FIBO's Financial Instrument Ontology"

🎯 What This Will Solve for Banking
Challenge Today (LLM-only)	With Formal Ontology
LLM guesses that "KYC" relates to customer onboarding	Ontology knows KYC → CDD/EDD → BSA requirements → specific data elements
Agent probabilistically routes to the right tool	Ontology provides deterministic concept resolution before routing
Ambiguous terms get inconsistent treatment	Formal definitions ensure "exposure" always means the same thing
Regulatory hierarchies are implicit	Explicit: Basel III → Pillar 1 → Credit Risk → IRB Approach → specific metrics
Cross-domain questions break down	Ontology formally links Risk ↔ Compliance ↔ Finance ↔ Operations
🔧 A Practical Architecture Pattern
User Question
    ↓
Cortex Agent (Orchestrator)
    ↓
┌─────────────────────────────────────────────┐
│  Step 1: Ontology Resolution (Custom Tool)  │
│  - Resolve domain concepts                  │
│  - Identify regulatory frameworks           │
│  - Map to specific data entities            │
│  - Return structured context to agent       │
├─────────────────────────────────────────────┤
│  Step 2: Informed Data Retrieval            │
│  - Cortex Analyst + Semantic Views          │
│    (now with precise ontology context)      │
│  - Cortex Search (regulatory documents)     │
├─────────────────────────────────────────────┤
│  Step 3: Validated Response                 │
│  - Agent composes answer with ontology-     │
│    grounded terminology and relationships   │
└─────────────────────────────────────────────┘
The key insight: the ontology acts as a deterministic pre-processing layer that constrains and informs the LLM's probabilistic reasoning — giving you the precision of formal logic with the flexibility of natural language interaction.

```

## Agent Project Structure

```
/
├── README.md                           # Project overview and setup instructions
├── docs/
│   ├── AGENT_SETUP.md                 # Step-by-step agent configuration guide
│   ├── DEPLOYMENT_SUMMARY.md          # Current deployment status
│   ├── questions.md                   # 30+ complex test questions
│   └── images/
│       ├── architecture.svg           # System architecture diagram
│       ├── deployment_flow.svg        # Deployment workflow diagram
│       └── ml_models.svg              # ML pipeline visualization
├── notebooks/
│   └── 08_ml_models.ipynb      # ML model training (optional)
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql # Database, schemas, warehouse
    │   └── 02_create_tables.sql       # All table definitions
    |   └── 03_Financial_Industry_Business_Ontology.sql # Create all tables and load the FIBO Ontology
    ├── data/
    │   └── 04_generate_synthetic_data.sql # Test data generation
    ├── views/
    │   ├── 05_create_views.sql        # Analytical views
    │   └── 06_create_semantic_views.sql # Semantic views for Cortex Analyst
    ├── search/
    │   └── 07_create_cortex_search.sql # Cortex Search services
    ├── models/
    │   └── 09_ml_model_functions.sql  # ML prediction views and agent functions
    └── agent/
        └── 10_create_agent.sql # Agent creation script
```

---

## File Execution Order

**MUST be executed in this exact order:**

These are examples of what is required.  You may need to add more project defined project.  The documentation should have an SVG image showing the project flow.

1. `sql/setup/01_database_and_schema.sql`
2. `sql/setup/02_create_tables.sql`
3. `sql/data/03_Financial_Industry_Business_Ontology.sql`
4. `sql/data/04_generate_synthetic_data.sql`
5. `sql/views/05_create_views.sql`
6. `sql/views/06_create_semantic_views.sql`
7. `sql/search/07_create_cortex_search.sql`
8. `notebooks/08_ml_models.ipynb`
9. `sql/models/09_ml_model_functions.sql`
10. `sql/agent/10_create_agent.sql`

---

## Critical Syntax Reference

### Snowflake Agent YAML Specification (VERIFIED WORKING)

```yaml
CREATE OR REPLACE AGENT {AGENT_NAME}
  COMMENT = '{Customer} intelligence agent'
  PROFILE = '{"display_name": "{Customer} Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 360
      tokens: 32000

  instructions:
    response: "Response instructions..."
    orchestration: "Tool routing instructions..."
    system: "System role description..."
    sample_questions:
      - question: "Sample question?"
        answer: "How the agent should respond."

  tools:
    # Cortex Analyst (text-to-SQL)
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ToolName"
        description: "Description of what this tool does"

    # Cortex Search
    - tool_spec:
        type: "cortex_search"
        name: "SearchName"
        description: "Description of search capability"

    # Custom Function (generic)
    - tool_spec:
        type: "generic"
        name: "FunctionName"
        description: "Description of function output"

  tool_resources:
    # Cortex Analyst resource
    ToolName:
      semantic_view: "{DATABASE}.{SCHEMA}.{SEMANTIC_VIEW_NAME}"

    # Cortex Search resource
    SearchName:
      name: "{DATABASE}.{SCHEMA}.{SEARCH_SERVICE_NAME}"
      max_results: "10"
      title_column: "column_name"
      id_column: "id_column"

    # Custom Function resource
    FunctionName:
      type: "function"
      identifier: "{DATABASE}.{SCHEMA}.{FUNCTION_NAME}"
      execution_environment:
        type: "warehouse"
        warehouse: "{WAREHOUSE_NAME}"
  $$;
```

### SQL UDF Return Types (VERIFIED)

| Function Returns | Correct Return Type |
|------------------|---------------------|
| `ARRAY_AGG(...)` | `RETURNS ARRAY` |
| `OBJECT_CONSTRUCT(...)` | `RETURNS OBJECT` |
| Single scalar value | `RETURNS VARCHAR/NUMBER/etc` |

**DO NOT USE:**
- `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
- `LANGUAGE SQL` clause in SQL UDFs

### SQL UDF Syntax (VERIFIED)

```sql
-- Correct syntax for scalar UDF returning ARRAY
CREATE OR REPLACE FUNCTION AGENT_GET_DATA()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'key1', COLUMN1,
    'key2', COLUMN2
)) FROM (SELECT * FROM TABLE LIMIT 50)
$$;

-- Correct syntax for scalar UDF returning OBJECT
CREATE OR REPLACE FUNCTION AGENT_GET_SUMMARY()
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'metric1', (SELECT COUNT(*) FROM TABLE1),
    'metric2', (SELECT AVG(COLUMN) FROM TABLE2)
)
$$;
```

---

## Lessons Learned (CRITICAL)

### 1. ALWAYS VERIFY SNOWFLAKE SYNTAX BEFORE WRITING CODE

**What went wrong:** Multiple syntax errors because I guessed at syntax instead of verifying against Snowflake documentation.

**Correct approach:**
- Use `snowflake_product_docs` tool to look up syntax BEFORE writing any SQL
- Use `system_instructions` tool for Cortex Agent, Analyst, and other Snowflake products
- Reference working examples

**Specific errors made:**
- Used `RETURNS VARIANT` instead of `RETURNS ARRAY` for `ARRAY_AGG`
- Used `RETURNS VARIANT` instead of `RETURNS OBJECT` for `OBJECT_CONSTRUCT`
- Used `LANGUAGE SQL` clause which is invalid for SQL UDFs
- Used `type: "procedure"` instead of `type: "function"` for agent tools
- Used `search_service:` instead of `name:` for Cortex Search resources
- Used JSON format instead of YAML for agent specification

### 2. COMPLETE ALL FILES BEFORE STOPPING

**What went wrong:** Generated partial files and stopped without completing the project, leaving merge conflicts and incomplete code.

**Correct approach:**
- Review ALL files in the project at the start
- Create a TODO list for every file that needs to be created/modified
- Do not mark a task complete until the file is verified to compile/run
- Verify file completeness before moving to the next task

### 3. NEVER GUESS - ASK OR RESEARCH

**What went wrong:** Made assumptions about:
- Agent YAML syntax
- SQL UDF return types
- Function naming conventions
- Tool resource configuration

**Correct approach:**
- If unsure about syntax, use documentation tools first
- If documentation is unclear, ask the user for clarification
- Reference working examples from similar projects
- Test small pieces of code before combining them

### 4. ASK QUESTIONS WHEN UNCLEAR

**What went wrong:** Proceeded with assumptions instead of asking for clarification on requirements.

**Questions to ask upfront:**
- What business domain/industry is this for?
- What specific ML models or predictions are needed?
- What data sources exist or need to be created?
- What sample questions should the agent answer?
- Are there any existing working examples to reference?

### 5. VERIFY GIT MERGE CONFLICTS

**What went wrong:** Left merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in SQL files.

**Correct approach:**
- After any file operations, verify no merge conflicts exist
- Search for conflict markers before marking files complete
- Test SQL files compile before considering them done

---

## Component Templates

### Database Setup (01_database_and_schema.sql)

```sql
CREATE DATABASE IF NOT EXISTS {DATABASE_NAME};
USE DATABASE {DATABASE_NAME};

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

CREATE OR REPLACE WAREHOUSE {WAREHOUSE_NAME} WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for {CUSTOMER_NAME} Intelligence Agent';

USE WAREHOUSE {WAREHOUSE_NAME};
```

### Cortex Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE {SEARCH_SERVICE_NAME}
  ON {text_column}
  ATTRIBUTES {attr1}, {attr2}, {attr3}
  WAREHOUSE = {WAREHOUSE_NAME}
  TARGET_LAG = '1 hour'
  COMMENT = 'Description of search service'
AS
  SELECT
    {columns}
  FROM {TABLE};
```

### Semantic View

```sql
CREATE OR REPLACE SEMANTIC VIEW {SEMANTIC_VIEW_NAME}
  COMMENT = 'Semantic view description'
AS
  SELECT
    {table}.{column} AS {alias}
      WITH SYNONYMS ('{synonym1}', '{synonym2}')
      COMMENT = '{Column description}',
    ...
  FROM {database}.{schema}.{table}
  ...;
```

---

## Checklist for New Projects

### Before Starting
- [ ] Confirm customer name and business domain
- [ ] Identify data sources (existing tables or need synthetic data)
- [ ] Determine ML models needed (LTV, churn, risk, etc.)
- [ ] Collect sample questions the agent should answer
- [ ] Get working example project for reference

### During Development
- [ ] Verify ALL SQL syntax against Snowflake docs before writing
- [ ] Test each SQL file compiles before moving to next
- [ ] Check for merge conflicts after any file operations
- [ ] Complete TODO list for every component

### Before Delivery
- [ ] Run all SQL files in order (01-08)
- [ ] Test agent creation succeeds
- [ ] Verify agent responds to sample questions
- [ ] Update documentation with customer-specific details
- [ ] Remove any placeholder values

---

## Reference Links

- Snowflake Agent Docs: `snowflake_product_docs` → "Cortex Agent"
- SQL UDF Reference: `snowflake_product_docs` → "CREATE FUNCTION SQL"
- Cortex Search: `snowflake_product_docs` → "CREATE CORTEX SEARCH SERVICE"
- Semantic Views: `snowflake_product_docs` → "CREATE SEMANTIC VIEW"

---

## Version History

- **v1.0** - Initial template based on previous Intelligence Agent project
- **Created:** March 2026
- **Lessons Learned:** Documented from previous project issues

---

## DO NOT:
1. Guess at syntax - VERIFY FIRST
2. Use `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
3. Use `LANGUAGE SQL` in SQL UDFs
4. Use JSON format for Agent specification (use YAML)
5. Leave merge conflicts in files
6. Mark tasks complete before verifying they work
7. Assume you know Snowflake syntax without checking
8. Use text based graphic

## DO:
1. Use `snowflake_product_docs` before writing SQL
2. Use `system_instructions` for Cortex products
3. Reference working examples
4. Ask questions when requirements are unclear
5. Test each file compiles before moving on
6. Complete ALL files before stopping
7. Verify no merge conflicts exist
8. Always generate documentation
9. Always generate SVG images for the documentation.
10. Always use html for tables when generating documentation
11. Always generate all files and never placeholders
12. Always put this line of code at the top of all documentation files: <img src="Snowflake_Logo.svg" width="200">
