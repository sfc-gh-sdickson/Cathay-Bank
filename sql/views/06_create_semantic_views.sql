/*=============================================================================
  CATHAY BANK INTELLIGENCE AGENT
  File: 06_create_semantic_views.sql
  Description: Semantic views for Cortex Analyst text-to-SQL
  Execution Order: 6 of 10
=============================================================================*/

USE DATABASE CATHAY_BANK_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE CATHAY_BANK_WH;

CREATE OR REPLACE SEMANTIC VIEW CATHAY_BANK_SEMANTIC_VIEW

  TABLES (
    customers AS CATHAY_BANK_DB.RAW.CUSTOMERS
      PRIMARY KEY (CUSTOMER_ID)
      WITH SYNONYMS ('clients', 'account holders', 'depositors', 'borrowers')
      COMMENT = 'Core customer data including demographics, KYC status, and financial profile',

    accounts AS CATHAY_BANK_DB.RAW.ACCOUNTS
      PRIMARY KEY (ACCOUNT_ID)
      WITH SYNONYMS ('bank accounts', 'deposit accounts', 'checking accounts', 'savings accounts')
      COMMENT = 'Customer deposit accounts including checking, savings, money market, and CDs',

    transactions AS CATHAY_BANK_DB.RAW.TRANSACTIONS
      PRIMARY KEY (TRANSACTION_ID)
      WITH SYNONYMS ('payments', 'transfers', 'deposits', 'withdrawals')
      COMMENT = 'Financial transactions including deposits, withdrawals, transfers, and payments',

    loans AS CATHAY_BANK_DB.RAW.LOANS
      PRIMARY KEY (LOAN_ID)
      WITH SYNONYMS ('credit', 'lending', 'mortgages', 'financing')
      COMMENT = 'Loan portfolio including residential mortgages, commercial loans, auto loans, and personal loans',

    loan_payments AS CATHAY_BANK_DB.RAW.LOAN_PAYMENTS
      PRIMARY KEY (PAYMENT_ID)
      WITH SYNONYMS ('loan installments', 'repayments')
      COMMENT = 'Loan payment history and schedule',

    compliance_events AS CATHAY_BANK_DB.RAW.COMPLIANCE_EVENTS
      PRIMARY KEY (EVENT_ID)
      WITH SYNONYMS ('regulatory events', 'AML alerts', 'BSA events', 'KYC reviews')
      COMMENT = 'Compliance and regulatory events including AML alerts, KYC reviews, and OFAC screening',

    risk_assessments AS CATHAY_BANK_DB.RAW.RISK_ASSESSMENTS
      PRIMARY KEY (ASSESSMENT_ID)
      WITH SYNONYMS ('risk reviews', 'risk evaluations', 'risk scores')
      COMMENT = 'Risk assessments covering credit risk, AML risk, operational risk, and customer risk profiles',

    support_cases AS CATHAY_BANK_DB.RAW.SUPPORT_CASES
      PRIMARY KEY (CASE_ID)
      WITH SYNONYMS ('customer service', 'help tickets', 'complaints', 'inquiries')
      COMMENT = 'Customer support cases including service requests, complaints, and inquiries',

    branches AS CATHAY_BANK_DB.RAW.BRANCHES
      PRIMARY KEY (BRANCH_ID)
      WITH SYNONYMS ('locations', 'offices', 'bank branches')
      COMMENT = 'Branch locations across nine US states and international offices'
  )

  RELATIONSHIPS (
    accounts_to_customers AS
      accounts (CUSTOMER_ID) REFERENCES customers,
    transactions_to_accounts AS
      transactions (ACCOUNT_ID) REFERENCES accounts,
    loans_to_customers AS
      loans (CUSTOMER_ID) REFERENCES customers,
    loans_to_accounts AS
      loans (ACCOUNT_ID) REFERENCES accounts,
    loan_payments_to_loans AS
      loan_payments (LOAN_ID) REFERENCES loans,
    compliance_to_customers AS
      compliance_events (CUSTOMER_ID) REFERENCES customers,
    compliance_to_accounts AS
      compliance_events (ACCOUNT_ID) REFERENCES accounts,
    risk_to_customers AS
      risk_assessments (CUSTOMER_ID) REFERENCES customers,
    risk_to_loans AS
      risk_assessments (LOAN_ID) REFERENCES loans,
    support_to_customers AS
      support_cases (CUSTOMER_ID) REFERENCES customers,
    support_to_accounts AS
      support_cases (ACCOUNT_ID) REFERENCES accounts,
    accounts_to_branches AS
      accounts (BRANCH_ID) REFERENCES branches
  )

  FACTS (
    transactions.absolute_amount AS ABS(AMOUNT)
      COMMENT = 'Absolute value of transaction amount',
    transactions.is_credit AS CASE WHEN AMOUNT > 0 THEN 1 ELSE 0 END
      COMMENT = 'Flag indicating credit (deposit) transaction',
    transactions.is_debit AS CASE WHEN AMOUNT < 0 THEN 1 ELSE 0 END
      COMMENT = 'Flag indicating debit (withdrawal) transaction',
    loans.principal_paid AS ORIGINAL_AMOUNT - CURRENT_BALANCE
      COMMENT = 'Total principal amount repaid on the loan',
    loans.paydown_pct AS (ORIGINAL_AMOUNT - CURRENT_BALANCE) / NULLIF(ORIGINAL_AMOUNT, 0) * 100
      COMMENT = 'Percentage of original loan amount that has been paid down',
    customers.tenure_years AS DATEDIFF('year', CUSTOMER_SINCE, CURRENT_DATE())
      COMMENT = 'Number of years the customer has been with Cathay Bank',
    customers.age AS DATEDIFF('year', DATE_OF_BIRTH, CURRENT_DATE())
      COMMENT = 'Current age of the customer in years'
  )

  DIMENSIONS (
    customers.customer_name AS FIRST_NAME || ' ' || LAST_NAME
      WITH SYNONYMS = ('client name', 'full name', 'name')
      COMMENT = 'Full name of the customer',
    customers.customer_segment AS CUSTOMER_SEGMENT
      WITH SYNONYMS = ('segment', 'tier', 'client tier')
      COMMENT = 'Customer segment: Premier, Preferred, Standard, Business, or Private Banking',
    customers.customer_state AS STATE
      WITH SYNONYMS = ('state', 'location')
      COMMENT = 'US state where customer resides',
    customers.customer_city AS CITY
      COMMENT = 'City where customer resides',
    customers.customer_risk_rating AS RISK_RATING
      WITH SYNONYMS = ('customer risk', 'AML risk level')
      COMMENT = 'Customer risk rating for AML/BSA purposes: Low, Medium, or High',
    customers.customer_kyc_status AS KYC_STATUS
      WITH SYNONYMS = ('KYC', 'know your customer status', 'verification status')
      COMMENT = 'KYC verification status: Verified, Pending, or Expired',
    customers.customer_employment_status AS EMPLOYMENT_STATUS
      COMMENT = 'Employment status of the customer',
    customers.customer_preferred_language AS PREFERRED_LANGUAGE
      WITH SYNONYMS = ('language', 'language preference')
      COMMENT = 'Customer preferred language: English, Mandarin, or Cantonese',
    customers.customer_since_date AS CUSTOMER_SINCE
      COMMENT = 'Date when customer first joined Cathay Bank',
    customers.customer_is_active AS IS_ACTIVE
      COMMENT = 'Whether the customer is currently active',

    accounts.account_type AS ACCOUNT_TYPE
      WITH SYNONYMS = ('type of account', 'product type')
      COMMENT = 'Type of account: Checking, Savings, Money Market, or Certificate of Deposit',
    accounts.account_status AS STATUS
      WITH SYNONYMS = ('account status')
      COMMENT = 'Account status: ACTIVE, DORMANT, or CLOSED',
    accounts.account_branch_name AS BRANCH_NAME
      WITH SYNONYMS = ('branch', 'office', 'location')
      COMMENT = 'Name of the branch where the account was opened',
    accounts.account_branch_state AS BRANCH_STATE
      COMMENT = 'State where the branch is located',
    accounts.account_opened_date AS OPENED_DATE
      COMMENT = 'Date when the account was opened',

    transactions.transaction_type AS TRANSACTION_TYPE
      WITH SYNONYMS = ('type of transaction', 'payment type')
      COMMENT = 'Type of transaction: Deposit, Withdrawal, Transfer, Payment, Direct Deposit, ACH, Wire, Check',
    transactions.transaction_category AS TRANSACTION_CATEGORY
      WITH SYNONYMS = ('spending category', 'expense category')
      COMMENT = 'Category: Payroll, Groceries, Dining, Utilities, Rent/Mortgage, Insurance, etc.',
    transactions.transaction_date AS TRANSACTION_DATE
      COMMENT = 'Date and time when the transaction occurred',
    transactions.transaction_month AS DATE_TRUNC('month', TRANSACTION_DATE)
      COMMENT = 'Month of the transaction',
    transactions.transaction_channel AS CHANNEL
      WITH SYNONYMS = ('banking channel', 'transaction channel')
      COMMENT = 'Channel: Online Banking, Mobile App, Branch, ATM, ACH, Wire',
    transactions.transaction_merchant_name AS MERCHANT_NAME
      COMMENT = 'Name of the merchant for payment transactions',
    transactions.transaction_is_flagged AS IS_FLAGGED
      COMMENT = 'Whether the transaction has been flagged for review',

    loans.loan_type AS LOAN_TYPE
      WITH SYNONYMS = ('type of loan', 'credit product', 'lending product')
      COMMENT = 'Type of loan: Residential Mortgage, Commercial Mortgage, Home Equity, Auto Loan, Personal Loan, SBA Loan',
    loans.loan_purpose AS LOAN_PURPOSE
      COMMENT = 'Purpose of the loan: Home Purchase, Refinance, Business Expansion, etc.',
    loans.loan_rate_type AS RATE_TYPE
      COMMENT = 'Interest rate type: Fixed or Variable',
    loans.loan_delinquency_status AS DELINQUENCY_STATUS
      WITH SYNONYMS = ('payment status', 'past due status')
      COMMENT = 'Delinquency status: Current, 30 Days Past Due, 60 Days Past Due, 90+ Days Past Due',
    loans.loan_risk_grade AS RISK_GRADE
      WITH SYNONYMS = ('loan grade', 'credit grade')
      COMMENT = 'Internal risk grade: A+, A, B+, B, C+, C, D, E',
    loans.loan_status AS STATUS
      WITH SYNONYMS = ('loan status')
      COMMENT = 'Loan status: ACTIVE, PAID OFF, or DEFAULT',
    loans.loan_collateral_type AS COLLATERAL_TYPE
      COMMENT = 'Type of collateral securing the loan',
    loans.loan_origination_date AS ORIGINATION_DATE
      COMMENT = 'Date when the loan was originated',

    compliance_events.compliance_event_type AS EVENT_TYPE
      WITH SYNONYMS = ('compliance alert type', 'regulatory event type')
      COMMENT = 'Type of compliance event: SAR, CTR, KYC Review, OFAC Alert, etc.',
    compliance_events.compliance_event_category AS EVENT_CATEGORY
      WITH SYNONYMS = ('compliance category')
      COMMENT = 'Category: AML/BSA, BSA Reporting, KYC/CDD, Sanctions, Regulatory',
    compliance_events.compliance_severity AS SEVERITY
      COMMENT = 'Severity level: Critical, High, Medium, Low',
    compliance_events.compliance_status AS STATUS
      WITH SYNONYMS = ('compliance status', 'investigation status')
      COMMENT = 'Status: Open, Under Investigation, Resolved, Escalated',
    compliance_events.compliance_regulatory_framework AS REGULATORY_FRAMEWORK
      COMMENT = 'Applicable regulatory framework: BSA, FinCEN CDD Rule, OFAC, etc.',
    compliance_events.compliance_detected_date AS DETECTED_DATE
      COMMENT = 'Date the compliance event was detected',
    compliance_events.compliance_sar_filed AS SAR_FILED
      WITH SYNONYMS = ('suspicious activity report filed')
      COMMENT = 'Whether a Suspicious Activity Report was filed with FinCEN',

    risk_assessments.risk_assessment_type AS ASSESSMENT_TYPE
      WITH SYNONYMS = ('type of risk assessment')
      COMMENT = 'Type of assessment: Credit Risk, AML Risk, Operational Risk, Concentration Risk, Customer Risk',
    risk_assessments.risk_assessment_category AS RISK_CATEGORY
      COMMENT = 'Risk category: Credit Risk, Compliance Risk, Operational Risk, Market Risk, Enterprise Risk',
    risk_assessments.risk_rating_level AS RISK_RATING
      WITH SYNONYMS = ('risk level')
      COMMENT = 'Risk rating: Very Low, Low, Medium, High, Critical',
    risk_assessments.risk_assessment_status AS STATUS
      COMMENT = 'Assessment status: Completed, Pending Review, In Progress',

    support_cases.case_category AS CATEGORY
      WITH SYNONYMS = ('support category', 'service category')
      COMMENT = 'Support case category: Account Services, Online Banking, Loan Services, Fraud Report, etc.',
    support_cases.case_priority AS PRIORITY
      WITH SYNONYMS = ('urgency', 'importance')
      COMMENT = 'Priority level: Low, Medium, High, Critical',
    support_cases.case_status AS STATUS
      WITH SYNONYMS = ('case status', 'ticket status')
      COMMENT = 'Case status: Open, In Progress, Resolved, Closed, Pending Customer',
    support_cases.case_channel AS CHANNEL
      WITH SYNONYMS = ('contact channel')
      COMMENT = 'Support channel: Phone, Branch, Online Chat, Email, Mobile App',
    support_cases.case_opened_date AS OPENED_DATE
      COMMENT = 'Date when the support case was opened',

    branches.branch_region AS REGION
      WITH SYNONYMS = ('geographic region')
      COMMENT = 'Geographic region: Southern California, Northern California, New York, Texas, etc.',
    branches.branch_city AS CITY
      COMMENT = 'City where the branch is located',
    branches.branch_state AS STATE
      COMMENT = 'State where the branch is located'
  )

  METRICS (
    customers.total_customers AS COUNT(CUSTOMER_ID)
      WITH SYNONYMS = ('customer count', 'number of customers', 'how many customers')
      COMMENT = 'Total number of customers',
    customers.avg_credit_score AS AVG(CREDIT_SCORE)
      WITH SYNONYMS = ('average credit score', 'mean credit score')
      COMMENT = 'Average credit score across customers',
    customers.avg_annual_income AS AVG(ANNUAL_INCOME)
      COMMENT = 'Average annual income of customers',
    customers.avg_tenure AS AVG(customers.tenure_years)
      COMMENT = 'Average customer tenure in years',

    accounts.total_accounts AS COUNT(ACCOUNT_ID)
      WITH SYNONYMS = ('account count', 'number of accounts')
      COMMENT = 'Total number of accounts',
    accounts.total_deposits AS SUM(CURRENT_BALANCE)
      WITH SYNONYMS = ('total balances', 'deposit volume', 'AUM')
      COMMENT = 'Total current balance across all accounts',
    accounts.avg_account_balance AS AVG(CURRENT_BALANCE)
      WITH SYNONYMS = ('average balance', 'mean balance')
      COMMENT = 'Average account balance',

    transactions.total_transaction_count AS COUNT(TRANSACTION_ID)
      WITH SYNONYMS = ('number of transactions', 'transaction volume')
      COMMENT = 'Total number of transactions',
    transactions.total_transaction_amount AS SUM(AMOUNT)
      WITH SYNONYMS = ('total amount', 'transaction value')
      COMMENT = 'Sum of all transaction amounts (positive for credits, negative for debits)',
    transactions.total_credits AS SUM(CASE WHEN AMOUNT > 0 THEN AMOUNT ELSE 0 END)
      WITH SYNONYMS = ('total deposits', 'total inflows')
      COMMENT = 'Total credit (deposit) amount',
    transactions.total_debits AS SUM(CASE WHEN AMOUNT < 0 THEN ABS(AMOUNT) ELSE 0 END)
      WITH SYNONYMS = ('total withdrawals', 'total outflows')
      COMMENT = 'Total debit (withdrawal) amount',
    transactions.avg_transaction_amount AS AVG(ABS(AMOUNT))
      COMMENT = 'Average absolute transaction amount',
    transactions.flagged_transaction_count AS SUM(CASE WHEN IS_FLAGGED THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('suspicious transactions', 'flagged count')
      COMMENT = 'Number of flagged/suspicious transactions',

    loans.total_loans AS COUNT(LOAN_ID)
      WITH SYNONYMS = ('loan count', 'number of loans')
      COMMENT = 'Total number of loans',
    loans.total_loan_origination AS SUM(ORIGINAL_AMOUNT)
      WITH SYNONYMS = ('total originated', 'origination volume')
      COMMENT = 'Total original loan amount originated',
    loans.total_outstanding_balance AS SUM(CURRENT_BALANCE)
      WITH SYNONYMS = ('outstanding loans', 'loan portfolio balance')
      COMMENT = 'Total current outstanding loan balance',
    loans.avg_interest_rate AS AVG(INTEREST_RATE)
      WITH SYNONYMS = ('average rate', 'mean interest rate')
      COMMENT = 'Average loan interest rate',
    loans.avg_ltv AS AVG(LTV_RATIO)
      WITH SYNONYMS = ('average loan to value', 'mean LTV')
      COMMENT = 'Average loan-to-value ratio',
    loans.avg_dti AS AVG(DTI_RATIO)
      WITH SYNONYMS = ('average debt to income', 'mean DTI')
      COMMENT = 'Average debt-to-income ratio',
    loans.delinquent_loan_count AS SUM(CASE WHEN DELINQUENCY_STATUS != 'Current' THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('past due loans', 'delinquent loans')
      COMMENT = 'Number of loans that are past due',
    loans.delinquency_rate AS AVG(CASE WHEN DELINQUENCY_STATUS != 'Current' THEN 1.0 ELSE 0.0 END) * 100
      WITH SYNONYMS = ('past due rate', 'delinquency percentage')
      COMMENT = 'Percentage of loans that are delinquent',
    loans.default_count AS SUM(CASE WHEN STATUS = 'DEFAULT' THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('defaulted loans', 'number of defaults')
      COMMENT = 'Number of loans in default status',

    loan_payments.total_payments AS COUNT(PAYMENT_ID)
      COMMENT = 'Total number of loan payments made',
    loan_payments.total_payment_amount AS SUM(PAYMENT_AMOUNT)
      COMMENT = 'Total dollar amount of loan payments',
    loan_payments.total_late_fees AS SUM(LATE_FEE)
      COMMENT = 'Total late fees charged',

    compliance_events.total_compliance_events AS COUNT(EVENT_ID)
      WITH SYNONYMS = ('compliance event count', 'regulatory events')
      COMMENT = 'Total number of compliance events',
    compliance_events.open_compliance_events AS SUM(CASE WHEN STATUS IN ('Open', 'Escalated', 'Under Investigation') THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('active compliance events', 'unresolved events')
      COMMENT = 'Number of compliance events not yet resolved',
    compliance_events.sar_count AS SUM(CASE WHEN SAR_FILED THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('SARs filed', 'suspicious activity reports')
      COMMENT = 'Number of Suspicious Activity Reports filed',
    compliance_events.ctr_count AS SUM(CASE WHEN CTR_FILED THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('CTRs filed', 'currency transaction reports')
      COMMENT = 'Number of Currency Transaction Reports filed',
    compliance_events.critical_events AS SUM(CASE WHEN SEVERITY IN ('Critical', 'High') THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('high severity events', 'urgent compliance events')
      COMMENT = 'Number of Critical or High severity compliance events',

    risk_assessments.total_assessments AS COUNT(ASSESSMENT_ID)
      COMMENT = 'Total number of risk assessments performed',
    risk_assessments.avg_risk_score AS AVG(RISK_SCORE)
      WITH SYNONYMS = ('average risk score', 'mean risk score')
      COMMENT = 'Average risk score across all assessments',
    risk_assessments.high_risk_count AS SUM(CASE WHEN RISK_RATING IN ('High', 'Critical') THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('high risk assessments', 'elevated risk count')
      COMMENT = 'Number of assessments rated High or Critical',

    support_cases.total_cases AS COUNT(CASE_ID)
      WITH SYNONYMS = ('case count', 'ticket count', 'number of cases')
      COMMENT = 'Total number of support cases',
    support_cases.open_cases AS SUM(CASE WHEN STATUS IN ('Open', 'In Progress', 'Pending Customer') THEN 1 ELSE 0 END)
      WITH SYNONYMS = ('active cases', 'unresolved cases')
      COMMENT = 'Number of support cases not yet resolved',
    support_cases.avg_satisfaction AS AVG(SATISFACTION_SCORE)
      WITH SYNONYMS = ('CSAT', 'customer satisfaction', 'satisfaction rating')
      COMMENT = 'Average customer satisfaction score (1-5 scale)',

    branches.total_branches AS COUNT(BRANCH_ID)
      COMMENT = 'Total number of bank branches'
  )

  COMMENT = 'Cathay Bank comprehensive semantic view for banking operations, compliance, risk management, and customer analytics'

  AI_SQL_GENERATION 'You are a banking data analyst for Cathay Bank, the oldest operating American bank founded by Chinese Americans. When generating SQL: 1) Always use fully qualified table names (CATHAY_BANK_DB.RAW.TABLE_NAME). 2) Round all monetary values to 2 decimal places. 3) Round percentages to 2 decimal places. 4) Format dates as YYYY-MM-DD. 5) For time-based analysis, use TRANSACTION_DATE for transactions and ORIGINATION_DATE for loans. 6) When asked about compliance, include regulatory framework context. 7) When asked about risk, include both the risk score and risk rating.'

  AI_QUESTION_CATEGORIZATION 'This semantic view covers Cathay Bank banking operations including customer management, deposit accounts, loans and lending, transaction processing, compliance and regulatory events (AML/BSA/KYC/OFAC), risk assessments, customer support, and branch operations. If the question is about specific regulatory requirements or legal advice, respond that you can provide data insights but recommend consulting the compliance department for regulatory guidance. If the question asks about specific customer personal information like SSN or account numbers, ask the user to verify they have appropriate access authorization.';
