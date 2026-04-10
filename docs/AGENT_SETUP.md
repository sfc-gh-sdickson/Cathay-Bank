<img src="Snowflake_Logo.svg" width="200">

# Cathay Bank Intelligence Agent - Setup Guide

## Prerequisites

<table>
<tr><th>Requirement</th><th>Details</th></tr>
<tr><td>Snowflake Account</td><td>Enterprise Edition or higher with Cortex AI features enabled</td></tr>
<tr><td>Role</td><td>ACCOUNTADMIN (for initial setup) or role with CREATE DATABASE, CREATE WAREHOUSE, CREATE AGENT privileges</td></tr>
<tr><td>Warehouse</td><td>X-SMALL or larger (created by script 01)</td></tr>
<tr><td>Cortex Region</td><td>Agent, Analyst, and Search require Cortex-enabled regions. Script 01 sets CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION'</td></tr>
</table>

---

## Step-by-Step Deployment

### Step 1: Infrastructure Setup
**File:** `sql/setup/01_database_and_schema.sql`

Creates:
- `CATHAY_BANK_DB` database
- Schemas: `RAW`, `ANALYTICS`, `ONTOLOGY`, `SEARCH`, `ML`
- `CATHAY_BANK_WH` warehouse (X-SMALL, auto-suspend 300s)
- Grants and Cortex cross-region setting

```sql
-- Run in a Snowflake worksheet
-- Copy and execute the full contents of 01_database_and_schema.sql
```

### Step 2: Create Tables
**File:** `sql/setup/02_create_tables.sql`

Creates 10 core tables in `CATHAY_BANK_DB.RAW`:

<table>
<tr><th>Table</th><th>Description</th></tr>
<tr><td>CUSTOMERS</td><td>Customer demographics, KYC, credit score, income</td></tr>
<tr><td>ACCOUNTS</td><td>Deposit accounts (Checking, Savings, MM, CD)</td></tr>
<tr><td>TRANSACTIONS</td><td>Financial transactions with merchant data</td></tr>
<tr><td>LOANS</td><td>Loan portfolio with risk grades and delinquency</td></tr>
<tr><td>LOAN_PAYMENTS</td><td>Loan payment history</td></tr>
<tr><td>COMPLIANCE_EVENTS</td><td>AML/BSA events, SAR/CTR filings</td></tr>
<tr><td>RISK_ASSESSMENTS</td><td>Credit, AML, operational risk assessments</td></tr>
<tr><td>SUPPORT_CASES</td><td>Customer service cases with CSAT scores</td></tr>
<tr><td>BRANCHES</td><td>20 branch locations across 9 US states</td></tr>
<tr><td>PRODUCTS</td><td>Banking products catalog</td></tr>
<tr><td>REGULATORY_DOCUMENTS</td><td>Compliance policies and regulatory documents</td></tr>
</table>

### Step 3: Load FIBO Ontology
**File:** `sql/setup/03_Financial_Industry_Business_Ontology.sql`

Creates ontology tables in `CATHAY_BANK_DB.ONTOLOGY` and loads:
- 20 FIBO classes covering Banking, Compliance, Risk, Regulatory domains
- 15 properties mapping data types and requirements
- 18 relationships linking concepts (HAS, GOVERNED_BY, REGULATED_BY, etc.)
- 12 regulatory mappings (BSA, OFAC, Basel III, HMDA, CRA, TILA, etc.)
- 12 concept-to-table mappings for agent query routing

### Step 4: Generate Synthetic Data
**File:** `sql/data/04_generate_synthetic_data.sql`

Generates realistic banking data:
- 2,000 customers with diverse demographics reflecting Cathay Bank's community
- 20 branches matching Cathay Bank's real locations
- 14 banking products
- Accounts, transactions, loans, compliance events, risk assessments, support cases
- 8 regulatory documents (BSA manual, CRA plan, Basel III report, etc.)

### Step 5: Create Analytical Views
**File:** `sql/views/05_create_views.sql`

Creates 7 views in `CATHAY_BANK_DB.ANALYTICS`:
- `CUSTOMER_360` - Complete customer profile with all relationships
- `LOAN_PORTFOLIO_ANALYSIS` - Loan metrics with risk classification
- `COMPLIANCE_DASHBOARD` - Compliance events with action priority
- `TRANSACTION_ANALYTICS` - Transaction metrics with flow direction
- `BRANCH_PERFORMANCE` - Branch-level KPIs
- `RISK_OVERVIEW` - Risk assessments with review status
- `SUPPORT_ANALYTICS` - Support case metrics with resolution times

### Step 6: Create Semantic View
**File:** `sql/views/06_create_semantic_views.sql`

Creates `CATHAY_BANK_SEMANTIC_VIEW` with:
- 9 logical tables with primary keys and synonyms
- 12 relationships for table joins
- 7 computed facts
- 50+ dimensions with synonyms and comments
- 30+ metrics with business definitions
- AI SQL generation and question categorization instructions

### Step 7: Create Cortex Search Services
**File:** `sql/search/07_create_cortex_search.sql`

Creates 4 search services in `CATHAY_BANK_DB.SEARCH`:

<table>
<tr><th>Service</th><th>Content</th><th>Use Case</th></tr>
<tr><td>CATHAY_REGULATORY_SEARCH</td><td>Regulatory documents</td><td>BSA, Basel III, CRA, HMDA policies</td></tr>
<tr><td>CATHAY_COMPLIANCE_SEARCH</td><td>Compliance events</td><td>SAR/CTR records, investigation details</td></tr>
<tr><td>CATHAY_SUPPORT_SEARCH</td><td>Support cases</td><td>Customer service history, resolutions</td></tr>
<tr><td>CATHAY_ONTOLOGY_SEARCH</td><td>FIBO ontology</td><td>Banking concept definitions, relationships</td></tr>
</table>

### Step 8: Train ML Models (Optional)
**File:** `notebooks/08_ml_models.ipynb`

Open in Snowflake Notebooks and run all cells. Trains 3 models:
1. **Churn Prediction** - GradientBoostingClassifier, 18 features
2. **Credit Risk** - GradientBoostingClassifier, 16 features
3. **Customer LTV** - GradientBoostingRegressor, 15 features

Models are registered in `CATHAY_BANK_DB.ML`.

### Step 9: Create UDFs
**File:** `sql/models/09_ml_model_functions.sql`

Creates 6 SQL UDFs in `CATHAY_BANK_DB.ANALYTICS`:
- `FIBO_RESOLVE_CONCEPT` - Ontology concept resolution
- `FIBO_GET_REGULATORY_REQUIREMENTS` - Regulatory framework lookup
- `FIBO_NAVIGATE_RELATIONSHIPS` - Ontology graph navigation
- `GET_CUSTOMER_RISK_PROFILE` - Customer risk profile
- `GET_PORTFOLIO_SUMMARY` - Executive portfolio summary
- `GET_COMPLIANCE_SUMMARY` - Compliance officer summary

### Step 10: Create the Agent
**File:** `sql/agent/10_create_agent.sql`

Creates `CATHAY_BNK_AGENT` with:
- 1 Cortex Analyst tool (semantic view)
- 4 Cortex Search tools (regulatory, compliance, support, ontology)
- 6 custom tools (FIBO resolution, risk profiles, summaries)
- 1 data-to-chart visualization tool
- Comprehensive instructions for banking-specific responses

---

## Post-Deployment Verification

After running all 10 scripts, verify:

```sql
-- Check agent exists
SHOW AGENTS IN SCHEMA CATHAY_BANK_DB.ANALYTICS;

-- Check semantic view
SHOW SEMANTIC VIEWS IN SCHEMA CATHAY_BANK_DB.ANALYTICS;

-- Check search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA CATHAY_BANK_DB.SEARCH;

-- Check UDFs
SHOW FUNCTIONS IN SCHEMA CATHAY_BANK_DB.ANALYTICS;

-- Test a UDF
SELECT CATHAY_BANK_DB.ANALYTICS.GET_PORTFOLIO_SUMMARY();

-- Test ontology resolution
SELECT CATHAY_BANK_DB.ANALYTICS.FIBO_RESOLVE_CONCEPT('KYC');
```

---

## Using the Agent

1. Navigate to **Snowflake Intelligence** in Snowsight
2. Select **Cathay Bank Assistant**
3. Ask questions like:
   - "What is our total deposit base?"
   - "Show me the delinquency rate by loan type"
   - "What are our BSA/AML obligations?"
   - "Give me the risk profile for customer 42"

See `docs/questions.md` for 30+ test questions.
