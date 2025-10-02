# 🤖 Cathay Bank Intelligence Agent Setup Guide

This guide provides detailed instructions for configuring the Snowflake Intelligence Agent to work with the Cathay Bank semantic model.

## 📋 Prerequisites

Before starting the agent setup:

1. ✅ Ensure all SQL scripts have been executed successfully:
   - `00_setup.sql` - Environment setup
   - `01_tables.sql` - Table creation
   - `02_load_synthetic.sql` - Data generation
   - `03_semantics.sql` - Analytics views and semantic model

2. ✅ Verify you have the following privileges:
   - CREATE CORTEX SEARCH SERVICE
   - CREATE SNOWFLAKE.ML.ANOMALY_DETECTION
   - CREATE SNOWFLAKE.ML.FORECAST

3. ✅ Confirm the semantic view exists:
   ```sql
   USE DATABASE CATHAY_BANK_DEMO;
   USE SCHEMA ANALYTICS;
   SHOW SEMANTIC VIEWS;
   ```

## 🚀 Step 1: Navigate to Snowsight

1. Log into your Snowflake account
2. Open Snowsight (the Snowflake web interface)
3. Ensure you're using the `CATHAY_DEMO_ROLE` role

## 🧠 Step 2: Create the Intelligence Agent

1. In Snowsight, navigate to **AI & ML** → **Intelligence**
2. Click **"+ Create Agent"**
3. Configure the agent with these settings:

### Basic Configuration

```
Name: CATHAY_BANK_INTELLIGENCE_AGENT
Description: Natural language interface for Cathay Bank's banking operations data
Database: CATHAY_BANK_DEMO
Schema: ANALYTICS
Warehouse: CATHAY_DEMO_WH
```

### Select Semantic View

1. In the "Semantic View" dropdown, select: `CATHAY_BANK_SEMANTIC_MODEL`
2. The agent will automatically detect all tables, relationships, dimensions, and metrics from the semantic view

### Configure Agent Capabilities

Enable the following capabilities:

- ✅ **Natural Language Queries** - Allow users to ask questions in plain English
- ✅ **Multi-turn Conversations** - Enable follow-up questions
- ✅ **Aggregations & Calculations** - Support for complex analytics
- ✅ **Time Intelligence** - Enable time-based analysis
- ✅ **Comparative Analysis** - Support for period-over-period comparisons

## 📝 Step 3: Configure Agent Instructions

Add these custom instructions to help the agent understand banking context:

```
You are an intelligent assistant for Cathay Bank's data analytics. You help users understand:

1. Customer insights and segmentation
2. Account and deposit trends
3. Loan portfolio performance
4. Credit card utilization
5. Digital banking adoption
6. Branch performance metrics
7. Risk and compliance indicators
8. Marketing campaign effectiveness

When answering questions:
- Provide specific numbers and percentages
- Include relevant time periods
- Highlight significant trends or anomalies
- Suggest related insights when appropriate
- Use banking terminology appropriately

Common abbreviations:
- APR: Annual Percentage Rate
- CD: Certificate of Deposit
- HELOC: Home Equity Line of Credit
- LTV: Loan to Value
- DDA: Demand Deposit Account
- NIM: Net Interest Margin
```

## 🎯 Step 4: Define Example Queries

Add these example queries to help users get started:

### Customer Analytics
- "Who are our top 20 customers by total deposit balance?"
- "What percentage of our customers are using digital banking?"
- "Show me customer acquisition trends over the past 12 months"
- "Which customer segments have the highest lifetime value?"

### Deposit Analytics
- "What is our total deposit balance across all branches?"
- "Show me month-over-month deposit growth for this year"
- "Which account types have the highest average balance?"
- "What percentage of accounts are dormant?"

### Loan Portfolio
- "What is our current loan portfolio composition by product type?"
- "Show me delinquency rates by loan type"
- "What is the average loan-to-value ratio for our mortgages?"
- "Which branches have the highest loan origination volume?"

### Credit Cards
- "What is the average credit utilization rate across all cards?"
- "Show me credit card activation trends"
- "Which card tiers generate the most revenue?"
- "What percentage of cards are inactive?"

### Digital Banking
- "How many customers are enrolled in mobile banking?"
- "What is the trend in digital vs branch transactions?"
- "Show me login frequency by customer generation"
- "Which digital channels are most popular?"

### Risk & Compliance
- "How many high-risk transactions were flagged this month?"
- "Show me customers with multiple delinquent loans"
- "What is our exposure to commercial real estate?"
- "Which customers have suspicious transaction patterns?"

### Branch Performance
- "Which branches have the highest customer satisfaction scores?"
- "Compare deposit growth across our top 10 branches"
- "What is the average wait time for service requests by branch?"
- "Show me branch efficiency metrics"

### Marketing ROI
- "What was the ROI of our last credit card campaign?"
- "Which marketing channels have the best conversion rates?"
- "Show me customer response rates by campaign type"
- "What is our cost per acquisition by product?"

## 🔧 Step 5: Advanced Configuration

### Set Data Freshness Expectations (Optional)

Configure how the agent handles data currency:

```
Data Refresh Schedule: Daily at 2:00 AM PST
Acceptable Data Lag: 24 hours
Real-time Metrics: Transaction counts, fraud alerts
```

### Configure Access Controls

Set appropriate access levels:

1. **Public Access**: Basic metrics, aggregated data
2. **Restricted Access**: Customer-level details, PII
3. **Executive Access**: All data including sensitive metrics

### Performance Optimization

1. Enable query result caching
2. Set timeout to 60 seconds for complex queries
3. Enable automatic query optimization

## 🧪 Step 6: Test the Agent

Run these test queries to verify functionality:

### Basic Tests
1. "How many customers do we have?"
2. "What is our total deposit balance?"
3. "Show me the number of active loans"

### Intermediate Tests
1. "What is the month-over-month growth in new accounts?"
2. "Which products have the highest cross-sell rate?"
3. "Show me average transaction volume by day of week"

### Advanced Tests
1. "Compare loan delinquency rates between branches for customers with credit scores above 700"
2. "What is the correlation between digital banking usage and product adoption?"
3. "Identify customers with decreasing deposit balances who might be at risk of churning"

## 📊 Step 7: Create Dashboards (Optional)

Consider creating pre-built dashboards for common use cases:

1. **Executive Dashboard**
   - Total customers and growth
   - Deposit and loan balances
   - Revenue metrics
   - Risk indicators

2. **Branch Manager Dashboard**
   - Branch performance metrics
   - Customer satisfaction
   - Staff productivity
   - Local market share

3. **Risk & Compliance Dashboard**
   - Delinquency rates
   - High-risk transactions
   - Compliance violations
   - Audit findings

## 🔍 Step 8: Monitor and Optimize

### Monitor Usage
- Track most common queries
- Identify slow-performing queries
- Monitor user satisfaction

### Optimize Performance
- Add indexes for frequently filtered columns
- Create materialized views for complex aggregations
- Adjust warehouse size based on usage

### Continuous Improvement
- Regularly update example queries
- Refine agent instructions based on user feedback
- Add new metrics as business needs evolve

## ⚠️ Troubleshooting

### Common Issues and Solutions

**Agent returns no results:**
- Verify the semantic view has SELECT permissions
- Check that data was loaded successfully
- Ensure warehouse is running

**Queries time out:**
- Increase warehouse size temporarily
- Simplify complex queries
- Check for missing indexes

**Incorrect results:**
- Verify relationship definitions in semantic view
- Check dimension and metric definitions
- Review data quality in source tables

**Access denied errors:**
- Confirm user has CATHAY_DEMO_ROLE
- Verify role has necessary grants
- Check schema and database permissions

## 📚 Additional Resources

- [Snowflake Intelligence Documentation](https://docs.snowflake.com/en/user-guide/snowflake-intelligence)
- [Semantic Modeling Best Practices](https://docs.snowflake.com/en/user-guide/semantic-modeling)
- [Natural Language Query Tips](https://docs.snowflake.com/en/user-guide/nlq-tips)

## 🎉 Completion

Once setup is complete, your Cathay Bank Intelligence Agent is ready to:

- Answer complex business questions in natural language
- Provide insights across all banking operations
- Support data-driven decision making
- Enable self-service analytics for business users

Start by asking: **"Give me an overview of Cathay Bank's current performance"**

---

For support or questions, contact your Snowflake administrator or refer to the main README.
