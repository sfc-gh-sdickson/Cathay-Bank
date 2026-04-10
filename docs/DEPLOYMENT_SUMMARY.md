<img src="Snowflake_Logo.svg" width="200">

# Cathay Bank Intelligence Agent - Deployment Summary

**Project:** Cathay Bank Snowflake Intelligence Agent
**Date:** April 2026
**Status:** Ready for Deployment

---

## Deployment Overview

<table>
<tr><th>Component</th><th>Object</th><th>Status</th></tr>
<tr><td>Database</td><td>CATHAY_BANK_DB</td><td>Ready</td></tr>
<tr><td>Schemas</td><td>RAW, ANALYTICS, ONTOLOGY, SEARCH, ML</td><td>Ready</td></tr>
<tr><td>Warehouse</td><td>CATHAY_BANK_WH (X-SMALL)</td><td>Ready</td></tr>
<tr><td>Core Tables</td><td>10 tables in RAW schema</td><td>Ready</td></tr>
<tr><td>FIBO Ontology</td><td>5 tables in ONTOLOGY schema</td><td>Ready</td></tr>
<tr><td>Synthetic Data</td><td>2K customers + related data</td><td>Ready</td></tr>
<tr><td>Analytical Views</td><td>7 views in ANALYTICS schema</td><td>Ready</td></tr>
<tr><td>Semantic View</td><td>CATHAY_BANK_SEMANTIC_VIEW</td><td>Ready</td></tr>
<tr><td>Cortex Search</td><td>4 services in SEARCH schema</td><td>Ready</td></tr>
<tr><td>ML Models</td><td>3 models in ML schema</td><td>Ready (requires notebook run)</td></tr>
<tr><td>SQL UDFs</td><td>6 functions in ANALYTICS schema</td><td>Ready</td></tr>
<tr><td>Agent</td><td>CATHAY_BNK_AGENT</td><td>Ready</td></tr>
</table>

---

## Data Summary

<table>
<tr><th>Table</th><th>Approx. Records</th><th>Schema</th></tr>
<tr><td>CUSTOMERS</td><td>2,000</td><td>RAW</td></tr>
<tr><td>ACCOUNTS</td><td>~3,200</td><td>RAW</td></tr>
<tr><td>TRANSACTIONS</td><td>~25,000</td><td>RAW</td></tr>
<tr><td>LOANS</td><td>~600</td><td>RAW</td></tr>
<tr><td>LOAN_PAYMENTS</td><td>~6,500</td><td>RAW</td></tr>
<tr><td>COMPLIANCE_EVENTS</td><td>~800</td><td>RAW</td></tr>
<tr><td>RISK_ASSESSMENTS</td><td>~800</td><td>RAW</td></tr>
<tr><td>SUPPORT_CASES</td><td>~1,000</td><td>RAW</td></tr>
<tr><td>BRANCHES</td><td>20</td><td>RAW</td></tr>
<tr><td>PRODUCTS</td><td>14</td><td>RAW</td></tr>
<tr><td>REGULATORY_DOCUMENTS</td><td>8</td><td>RAW</td></tr>
</table>

---

## FIBO Ontology Coverage

<table>
<tr><th>Domain</th><th>Classes</th><th>Key Concepts</th></tr>
<tr><td>Banking</td><td>5</td><td>Deposit Account, Loan Contract, Payment Transaction, Wholesale Banking, Correspondent Banking</td></tr>
<tr><td>Clients</td><td>2</td><td>Customer, Corporate Customer</td></tr>
<tr><td>Compliance</td><td>5</td><td>KYC, AML, BSA, OFAC, HMDA, CRA</td></tr>
<tr><td>Risk Management</td><td>4</td><td>Credit Risk, Operational Risk, Market Risk, Liquidity Risk</td></tr>
<tr><td>Regulatory</td><td>3</td><td>Basel III, IRB Approach, Financial Instrument</td></tr>
</table>

---

## Agent Tool Summary

<table>
<tr><th>Tool Name</th><th>Type</th><th>Resource</th></tr>
<tr><td>CathayBankAnalyst</td><td>cortex_analyst_text_to_sql</td><td>CATHAY_BANK_SEMANTIC_VIEW</td></tr>
<tr><td>RegulatorySearch</td><td>cortex_search</td><td>CATHAY_REGULATORY_SEARCH</td></tr>
<tr><td>ComplianceSearch</td><td>cortex_search</td><td>CATHAY_COMPLIANCE_SEARCH</td></tr>
<tr><td>SupportSearch</td><td>cortex_search</td><td>CATHAY_SUPPORT_SEARCH</td></tr>
<tr><td>OntologySearch</td><td>cortex_search</td><td>CATHAY_ONTOLOGY_SEARCH</td></tr>
<tr><td>FIBOResolveConcept</td><td>custom_tool (function)</td><td>FIBO_RESOLVE_CONCEPT</td></tr>
<tr><td>FIBORegulatoryRequirements</td><td>custom_tool (function)</td><td>FIBO_GET_REGULATORY_REQUIREMENTS</td></tr>
<tr><td>FIBONavigateRelationships</td><td>custom_tool (function)</td><td>FIBO_NAVIGATE_RELATIONSHIPS</td></tr>
<tr><td>CustomerRiskProfile</td><td>custom_tool (function)</td><td>GET_CUSTOMER_RISK_PROFILE</td></tr>
<tr><td>PortfolioSummary</td><td>custom_tool (function)</td><td>GET_PORTFOLIO_SUMMARY</td></tr>
<tr><td>ComplianceSummary</td><td>custom_tool (function)</td><td>GET_COMPLIANCE_SUMMARY</td></tr>
</table>

---

## ML Model Registry

<table>
<tr><th>Model</th><th>Algorithm</th><th>Features</th><th>Target</th><th>Version</th></tr>
<tr><td>cathay_churn_model</td><td>GradientBoostingClassifier</td><td>18</td><td>Customer Attrition</td><td>v1</td></tr>
<tr><td>cathay_credit_risk_model</td><td>GradientBoostingClassifier</td><td>16</td><td>Loan Default</td><td>v1</td></tr>
<tr><td>cathay_ltv_model</td><td>GradientBoostingRegressor</td><td>15</td><td>Relationship Value</td><td>v1</td></tr>
</table>

---

## Execution Checklist

<table>
<tr><th>#</th><th>File</th><th>Status</th></tr>
<tr><td>1</td><td>sql/setup/01_database_and_schema.sql</td><td>Pending</td></tr>
<tr><td>2</td><td>sql/setup/02_create_tables.sql</td><td>Pending</td></tr>
<tr><td>3</td><td>sql/setup/03_Financial_Industry_Business_Ontology.sql</td><td>Pending</td></tr>
<tr><td>4</td><td>sql/data/04_generate_synthetic_data.sql</td><td>Pending</td></tr>
<tr><td>5</td><td>sql/views/05_create_views.sql</td><td>Pending</td></tr>
<tr><td>6</td><td>sql/views/06_create_semantic_views.sql</td><td>Pending</td></tr>
<tr><td>7</td><td>sql/search/07_create_cortex_search.sql</td><td>Pending</td></tr>
<tr><td>8</td><td>notebooks/08_ml_models.ipynb</td><td>Pending</td></tr>
<tr><td>9</td><td>sql/models/09_ml_model_functions.sql</td><td>Pending</td></tr>
<tr><td>10</td><td>sql/agent/10_create_agent.sql</td><td>Pending</td></tr>
</table>
