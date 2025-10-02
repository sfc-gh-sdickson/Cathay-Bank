# 🔍 Complex Banking Queries for Cathay Bank Intelligence Agent

This document contains 10 sophisticated natural language queries designed to test the full capabilities of the Cathay Bank Snowflake Intelligence Agent. Each query tests different aspects of the semantic model and requires complex data analysis.

## 1. 🎯 Cross-Product Customer Profitability Analysis

**Natural Language Query:**
> "Show me the top 100 most profitable customers who have at least one checking account, one active loan, and one credit card. Include their total deposit balance, loan exposure, credit utilization rate, and estimated annual revenue contribution. Group them by customer segment and show the average profitability by segment."

**What This Tests:**
- Multi-table joins across customers, accounts, loans, and credit cards
- Complex filtering conditions
- Revenue calculations
- Segmentation analysis
- Aggregations at multiple levels

**Expected Insights:**
- Identifies high-value multi-product relationships
- Shows profitability distribution across segments
- Highlights cross-sell success stories

## 2. 📊 Branch Network Optimization Analysis

**Natural Language Query:**
> "Compare branch performance metrics for the past 12 months including new customer acquisition, deposit growth rate, loan origination volume, cost-to-income ratio, and digital adoption rate. Identify branches that are underperforming in at least 3 of these metrics and show their distance to the nearest high-performing branch. Also show the demographic profile of their service areas."

**What This Tests:**
- Time-based analysis
- Multiple performance metrics
- Comparative analysis
- Geographic calculations
- Demographic integration

**Expected Insights:**
- Branch consolidation opportunities
- Performance improvement targets
- Market coverage gaps

## 3. 💳 Credit Risk Early Warning System

**Natural Language Query:**
> "Identify customers who have shown signs of financial stress in the last 90 days, including: decrease in average deposit balance by more than 30%, increase in credit utilization above 80%, any loan payment delays, or unusual transaction patterns. For these customers, show their current exposure across all products, risk rating changes, and predict the probability of default in the next 6 months."

**What This Tests:**
- Temporal pattern analysis
- Multiple risk indicators
- Predictive analytics
- Cross-product exposure calculation
- Behavioral change detection

**Expected Insights:**
- Early intervention opportunities
- Portfolio risk concentration
- Preventive action priorities

## 4. 🚀 Digital Banking Adoption and Revenue Impact

**Natural Language Query:**
> "Analyze the correlation between digital banking adoption and customer lifetime value. Compare customers who enrolled in digital banking within their first 90 days versus those who enrolled later or haven't enrolled. Show differences in product holdings, transaction volume, service costs, and attrition rates. Break this down by generation and income bracket."

**What This Tests:**
- Cohort analysis
- Correlation calculations
- Multi-dimensional segmentation
- Cost-benefit analysis
- Behavioral economics

**Expected Insights:**
- Digital channel ROI
- Adoption barrier identification
- Targeted marketing opportunities

## 5. 🏠 Mortgage Portfolio Stress Testing

**Natural Language Query:**
> "For our mortgage portfolio, simulate the impact of a 2% interest rate increase on payment affordability. Show how many loans would have debt-to-income ratios exceeding 45%, grouped by original LTV bands, property location, and customer credit score ranges. Also identify which customers have sufficient deposits with us to cover 6 months of increased payments."

**What This Tests:**
- Scenario analysis
- Complex calculations (DTI ratios)
- Multi-criteria grouping
- Cross-product analysis (loans + deposits)
- Risk stratification

**Expected Insights:**
- Portfolio vulnerability assessment
- Proactive customer support targets
- Capital planning requirements

## 6. 💰 Deposit Pricing Optimization

**Natural Language Query:**
> "Analyze our deposit portfolio's interest rate sensitivity by comparing account balances, customer tenure, and competitive rates. Show which accounts are paying above-market rates, which high-balance accounts are receiving below-market rates, and estimate the annual cost of repricing to market rates. Include the likelihood of customer attrition based on historical behavior when rates were adjusted."

**What This Tests:**
- Competitive analysis
- Price elasticity modeling
- Attrition prediction
- Cost-benefit calculations
- Historical pattern matching

**Expected Insights:**
- Pricing optimization opportunities
- Margin improvement potential
- Retention risk assessment

## 7. 🔄 Customer Journey and Cross-Sell Analysis

**Natural Language Query:**
> "Map the typical customer journey from account opening to becoming a full-relationship client. Show the average time between product adoptions, the most common product sequences, and identify where customers typically stop adding products. For customers who've been with us 2-5 years and only have one product, what's their next best product based on similar customer behaviors?"

**What This Tests:**
- Sequential pattern mining
- Time-series analysis
- Predictive modeling
- Similarity matching
- Journey visualization

**Expected Insights:**
- Optimal product sequencing
- Cross-sell timing optimization
- Personalized recommendations

## 8. 🚨 Anti-Money Laundering Pattern Detection

**Natural Language Query:**
> "Identify potentially suspicious transaction patterns in the last 30 days including: rapid movement of funds (deposits followed by withdrawals within 48 hours), structured transactions just below $10,000, unusual international wire activity, or transaction patterns inconsistent with stated customer occupation and income. Rank these by risk score and show any connections between flagged accounts."

**What This Tests:**
- Complex pattern recognition
- Time-window analysis
- Network analysis
- Risk scoring algorithms
- Regulatory compliance logic

**Expected Insights:**
- AML investigation priorities
- Pattern identification improvement
- Network risk exposure

## 9. 📈 Market Share and Competitive Analysis

**Natural Language Query:**
> "Estimate our market share in each city we operate in by comparing our deposit totals to Federal Reserve data for those markets. Show where we're gaining or losing share year-over-year, which products are driving share changes, and identify cities where our share is below 5% despite having branches. Also show the correlation between our marketing spend and share growth by market."

**What This Tests:**
- External data integration concepts
- Market-level aggregations
- Trend analysis
- Marketing effectiveness
- Strategic planning metrics

**Expected Insights:**
- Growth market identification
- Investment prioritization
- Marketing ROI by geography

## 10. 🎭 Fraud Detection and Loss Prevention

**Natural Language Query:**
> "Analyze fraud patterns across channels and payment types to identify the top 10 fraud risk factors. For each factor, show the detection rate, false positive rate, and average loss amount. Create a fraud risk score for all active debit and credit cards based on these factors, and estimate the annual loss prevention if we blocked transactions for the top 5% highest risk scores. Include the impact on customer experience metrics."

**What This Tests:**
- Machine learning concepts
- Multi-channel analysis
- Cost-benefit optimization
- Predictive scoring
- Customer impact assessment

**Expected Insights:**
- Fraud rule optimization
- Technology investment priorities
- Customer friction reduction

---

## 📋 Testing Guidelines

When testing these queries with the Intelligence Agent:

1. **Start Simple** - Try simpler versions first, then add complexity
2. **Iterate** - If the agent struggles, break down into smaller queries
3. **Verify Results** - Check a sample of results against the raw data
4. **Note Limitations** - Document any queries the agent cannot fully handle
5. **Measure Performance** - Track query execution time

## 🎯 Success Criteria

A successful implementation should be able to:
- Understand the business intent of each query
- Access all necessary tables and relationships
- Perform required calculations
- Present results in a business-friendly format
- Execute within reasonable time limits (< 30 seconds)

## 💡 Tips for Natural Language Queries

1. **Be Specific** - Include specific metrics and criteria
2. **Use Business Terms** - The agent should understand banking terminology
3. **Specify Time Frames** - Always include relevant date ranges
4. **Request Groupings** - Explicitly ask for breakdowns by dimensions
5. **Ask for Insights** - Request interpretations, not just data

---

These complex queries demonstrate the full power of Snowflake Intelligence for banking analytics, enabling business users to perform sophisticated analysis without writing SQL.
