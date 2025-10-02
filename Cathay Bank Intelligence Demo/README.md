<img src="../Snowflake_Logo.svg" width="200">

# 🏦 Snowflake Intelligence Demo: Cathay Bank

A comprehensive, end-to-end demo showcasing Snowflake Intelligence capabilities with natural language queries over Cathay Bank's banking data model. This demo simulates a full-service bank's operations including retail banking, commercial banking, lending, credit cards, and digital banking services.

<p align="center">
  <img src="cathay-bank-logo.svg" alt="Cathay Bank Logo" width="300"/>
</p>

## 🎯 Business Value

This demo helps Cathay Bank stakeholders understand how Snowflake Intelligence can:

* **Democratize Data Access** - Enable business users to query data using natural language without SQL knowledge
* **Accelerate Decision Making** - Get instant insights into customer behavior, product performance, and risk metrics
* **Improve Customer Experience** - Identify opportunities for personalization and proactive service
* **Enhance Risk Management** - Monitor credit risk, fraud patterns, and compliance in real-time
* **Optimize Operations** - Track branch performance, digital adoption, and operational efficiency
* **Drive Revenue Growth** - Identify cross-sell opportunities and optimize marketing spend

## 📊 Data Model Overview

The demo includes comprehensive synthetic data representing Cathay Bank's operations:

### Scale and Scope

* **50,000 Customers** - Individual, Business, and Trust accounts
* **120,000 Accounts** - Checking, Savings, Money Market, CDs
* **5 Million Transactions** - 2 years of transaction history
* **30,000 Loans** - Mortgages, Auto, Personal, Business, HELOC
* **20,000 Credit Cards** - Multiple tiers and reward programs
* **40,000 Digital Users** - Online and mobile banking adoption
* **100,000 Service Requests** - Multi-channel customer interactions
* **65 Branches** - California-focused network
* **250 ATMs** - Branch and standalone locations
* **500 Employees** - Branch staff, loan officers, support teams

### Key Business Entities

#### Customer Management
- Customer profiles with demographics and segmentation
- Relationship depth tracking
- VIP and high-net-worth identification
- Risk ratings and compliance flags

#### Product Portfolio
- Deposit products (Checking, Savings, CDs)
- Lending products (Mortgages, Auto, Personal, Business)
- Credit cards with reward programs
- Digital banking services

#### Operational Data
- Branch and ATM network
- Employee hierarchy
- Service request tracking
- Marketing campaign management

## 🚀 Quick Start

### Prerequisites

* Snowflake account with appropriate privileges
* Access to create warehouses, databases, and roles
* Ability to create semantic views

### Installation Steps

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd "Cathay Bank Intelligence Demo"
   ```

2. **Execute SQL scripts in order**
   
   Open Snowsight and run each script sequentially:
   
   ```sql
   -- Step 1: Environment Setup (< 1 minute)
   sql/00_setup.sql
   
   -- Step 2: Create Tables (< 1 minute)
   sql/01_tables.sql
   
   -- Step 3: Generate Synthetic Data (5-10 minutes)
   sql/02_load_synthetic.sql
   
   -- Step 4: Create Analytics Views & Semantic Model (< 2 minutes)
   sql/03_semantics.sql
   ```

3. **Configure Intelligence Agent**
   
   Follow the detailed instructions in [`AGENT_SETUP.md`](AGENT_SETUP.md)

4. **Start exploring with natural language!**

## 💬 Sample Natural Language Queries

### Executive Dashboard Queries

* "What are our key performance metrics for this quarter?"
* "Show me year-over-year growth in deposits and loans"
* "What is our current market share in Southern California?"
* "Which products are driving the most revenue?"

### Customer Analytics

* "Who are our most valuable customers by total relationship?"
* "Show me customer segmentation by generation and income"
* "Which customers are at risk of churning?"
* "What percentage of customers use multiple products?"

### Deposit Analysis

* "What is our deposit growth trend over the past 12 months?"
* "Show me average balances by account type and customer segment"
* "Which branches have the highest deposit concentration?"
* "What is our cost of funds by product type?"

### Lending Portfolio

* "What is our loan portfolio composition and performance?"
* "Show me delinquency rates by loan type and vintage"
* "Which branches have the best loan quality?"
* "What is our average loan yield by product?"

### Credit Card Business

* "What is the utilization rate across our card portfolio?"
* "Show me spending patterns by merchant category"
* "Which card products have the highest profitability?"
* "What percentage of cards are inactive?"

### Digital Banking

* "What is our digital adoption rate by customer segment?"
* "Show me the trend in mobile vs online banking usage"
* "Which features drive the most digital engagement?"
* "How does digital adoption correlate with product usage?"

### Risk Management

* "Show me our credit exposure by risk rating"
* "Which customers have multiple delinquent accounts?"
* "What are our top fraud risk indicators?"
* "Display concentration risk by industry and geography"

### Operational Efficiency

* "Which branches have the highest efficiency ratios?"
* "Show me average transaction processing times"
* "What is our cost per account by branch?"
* "Compare staffing levels to transaction volumes"

### Marketing Effectiveness

* "What is the ROI of our recent marketing campaigns?"
* "Which channels have the best customer acquisition cost?"
* "Show me conversion rates by product and segment"
* "What is the lifetime value of customers by acquisition channel?"

### Compliance & Regulatory

* "Show me all high-risk transactions requiring review"
* "Which accounts show potential structuring activity?"
* "Display our CRA lending by census tract"
* "What is our BSA/AML alert resolution rate?"

## 📁 Repository Structure

```
Cathay Bank Intelligence Demo/
├── sql/
│   ├── 00_setup.sql          # Environment setup
│   ├── 01_tables.sql         # Table definitions
│   ├── 02_load_synthetic.sql # Data generation
│   ├── 03_semantics.sql      # Analytics views & semantic model
│   └── 99_cleanup.sql        # Teardown script
├── AGENT_SETUP.md            # Intelligence Agent configuration
└── README.md                 # This file
```

## 🏗️ Architecture

### Data Flow

```
Raw Tables (Operational Data)
    ↓
Analytics Views (Business Logic)
    ↓
Semantic Model (Intelligence Layer)
    ↓
Natural Language Interface
```

### Key Components

1. **Raw Tables** - Normalized tables representing operational systems
2. **Analytics Views** - Pre-aggregated views with business logic
3. **Semantic Model** - Comprehensive model defining relationships and metrics
4. **Intelligence Agent** - Natural language processing and query generation

## 🎨 Customization Options

### Adjust Data Volume

Modify the `ROWCOUNT` parameters in `02_load_synthetic.sql`:

```sql
-- Increase customer count to 100,000
FROM TABLE(GENERATOR(ROWCOUNT => 100000))
```

### Add Custom Metrics

Extend the semantic model in `03_semantics.sql`:

```sql
-- Add custom metric for net interest margin
METRICS (
    ...
    (SUM(loan_interest_income) - SUM(deposit_interest_expense)) / 
    SUM(earning_assets) AS net_interest_margin
)
```

### Industry-Specific Modifications

Customize for specific banking segments:
* **Community Banking** - Add local business focus
* **Private Banking** - Enhance wealth management features
* **Commercial Banking** - Add treasury management
* **International Banking** - Include foreign exchange

## 🧹 Cleanup

To remove all demo objects:

```sql
-- Run the cleanup script
sql/99_cleanup.sql
```

This will:
- Drop the demo database and all objects
- Remove the demo role
- Delete the demo warehouse

## 📈 Demo Scenarios

### 1. Executive Review (15 minutes)

**Objective**: Show high-level insights and KPIs

**Questions to ask**:
- "Give me an executive summary of our current performance"
- "What are our growth trends across key metrics?"
- "Which areas of the business need attention?"
- "How do we compare to last year?"

### 2. Customer Deep Dive (20 minutes)

**Objective**: Demonstrate customer analytics capabilities

**Questions to ask**:
- "Profile our high-value customer segments"
- "Which customers have the most products?"
- "Show me customer lifetime value distribution"
- "What drives customer attrition?"

### 3. Risk Assessment (20 minutes)

**Objective**: Highlight risk management features

**Questions to ask**:
- "What is our current credit risk exposure?"
- "Show me early warning indicators for loan defaults"
- "Which accounts have suspicious activity?"
- "What is our operational risk profile?"

### 4. Digital Transformation (15 minutes)

**Objective**: Analyze digital banking adoption

**Questions to ask**:
- "What is our digital adoption trajectory?"
- "Which features drive digital engagement?"
- "How does digital usage impact profitability?"
- "Show me the digital divide by demographics"

### 5. Branch Strategy (15 minutes)

**Objective**: Evaluate branch network performance

**Questions to ask**:
- "Which branches are most profitable?"
- "How does foot traffic correlate with revenue?"
- "Should we consolidate any locations?"
- "Where should we open new branches?"

## 🔍 Troubleshooting

### Common Issues

1. **"Table not found" errors**
   - Ensure scripts were run in order
   - Verify you're using `CATHAY_DEMO_ROLE`
   - Check current database context

2. **Agent not returning results**
   - Verify semantic model was created successfully
   - Check role permissions on views
   - Ensure warehouse is running

3. **Slow query performance**
   - Consider using a larger warehouse for initial data load
   - Check if statistics need updating
   - Review query complexity

4. **Data generation timeouts**
   - Increase `STATEMENT_TIMEOUT_IN_SECONDS`
   - Use a larger warehouse (LARGE or XL)
   - Run data generation in batches

### Getting Help

1. Check Snowflake query history for error details
2. Verify all objects exist in the correct schemas
3. Review agent configuration in Intelligence UI
4. Consult Snowflake documentation

## 📊 Performance Optimization

### Best Practices

1. **Clustering Keys** - Add for large tables with common filter patterns
2. **Materialized Views** - Create for complex aggregations
3. **Query Optimization** - Use appropriate warehouse sizes
4. **Caching** - Enable result caching for common queries

### Monitoring

Track performance with:
```sql
-- View long-running queries
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE DATABASE_NAME = 'CATHAY_BANK_DEMO'
  AND EXECUTION_TIME > 5000
ORDER BY START_TIME DESC;
```

## 🎓 Learning Resources

* [Snowflake Intelligence Documentation](https://docs.snowflake.com/en/user-guide/snowflake-intelligence)
* [Semantic Modeling Guide](https://docs.snowflake.com/en/user-guide/semantic-modeling)
* [Natural Language Query Best Practices](https://docs.snowflake.com/en/user-guide/nlq-best-practices)
* [Banking Data Model Patterns](https://www.snowflake.com/blog/banking-data-models)

## 🤝 Contributing

To enhance this demo:

1. **Add new analytics views** for specific use cases
2. **Extend the data model** with additional banking products
3. **Create query templates** for common analyses
4. **Improve data generation** for more realistic patterns
5. **Add international banking** features

## 📝 Notes

* All data is synthetic and randomly generated
* No real Cathay Bank data is used or represented
* Designed for demonstration purposes only
* Optimized for Snowflake Intelligence features
* California geography focus reflects Cathay Bank's market

## ⚡ Advanced Features

### Multi-Language Support
The demo includes Chinese language preferences for ~30% of customers, reflecting Cathay Bank's diverse customer base.

### Seasonal Patterns
Transaction data includes realistic patterns:
- Higher transaction volumes on weekdays
- Seasonal spending patterns
- End-of-month salary deposits

### Risk Indicators
Built-in risk scoring for:
- Transaction fraud detection
- Credit risk assessment
- AML pattern recognition

## 🏆 Success Metrics

Measure demo effectiveness by:
- Query response time (target: < 3 seconds)
- Natural language understanding accuracy
- Business insight generation
- User adoption rates

---

**Built with ❄️ by Snowflake Solution Engineering**

*Empowering Cathay Bank with intelligent data insights*

For questions or support, contact your Snowflake account team.
