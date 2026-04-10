/*=============================================================================
  CATHAY BANK INTELLIGENCE AGENT
  File: 03_Financial_Industry_Business_Ontology.sql
  Description: FIBO (Financial Industry Business Ontology) tables and data
  Execution Order: 3 of 10

  This implements a banking ontology based on FIBO standards to provide
  deterministic concept resolution for the Cortex Agent. The ontology maps
  banking domain concepts, regulatory frameworks, and their relationships.
=============================================================================*/

USE DATABASE CATHAY_BANK_DB;
USE SCHEMA ONTOLOGY;
USE WAREHOUSE CATHAY_BANK_WH;

CREATE OR REPLACE TABLE FIBO_CLASSES (
    CLASS_ID            NUMBER(38,0) AUTOINCREMENT PRIMARY KEY,
    CLASS_URI           VARCHAR(500) NOT NULL,
    CLASS_NAME          VARCHAR(200) NOT NULL,
    PARENT_CLASS_URI    VARCHAR(500),
    DOMAIN              VARCHAR(100) NOT NULL,
    SUBDOMAIN           VARCHAR(100),
    DEFINITION          VARCHAR(4000) NOT NULL,
    EXAMPLES            VARCHAR(2000),
    SYNONYMS            VARCHAR(1000),
    ISO_STANDARD        VARCHAR(100),
    REGULATORY_CONTEXT  VARCHAR(1000),
    DATA_ELEMENTS       VARCHAR(2000),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE FIBO_PROPERTIES (
    PROPERTY_ID         NUMBER(38,0) AUTOINCREMENT PRIMARY KEY,
    PROPERTY_URI        VARCHAR(500) NOT NULL,
    PROPERTY_NAME       VARCHAR(200) NOT NULL,
    DOMAIN_CLASS_URI    VARCHAR(500) NOT NULL,
    RANGE_CLASS_URI     VARCHAR(500),
    PROPERTY_TYPE       VARCHAR(50) NOT NULL,
    DEFINITION          VARCHAR(4000),
    DATA_TYPE           VARCHAR(50),
    IS_REQUIRED         BOOLEAN DEFAULT FALSE,
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE FIBO_RELATIONSHIPS (
    RELATIONSHIP_ID     NUMBER(38,0) AUTOINCREMENT PRIMARY KEY,
    SOURCE_CLASS_URI    VARCHAR(500) NOT NULL,
    TARGET_CLASS_URI    VARCHAR(500) NOT NULL,
    RELATIONSHIP_TYPE   VARCHAR(100) NOT NULL,
    RELATIONSHIP_NAME   VARCHAR(200),
    DESCRIPTION         VARCHAR(2000),
    CARDINALITY         VARCHAR(20),
    IS_BIDIRECTIONAL    BOOLEAN DEFAULT FALSE,
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE FIBO_REGULATORY_MAPPINGS (
    MAPPING_ID          NUMBER(38,0) AUTOINCREMENT PRIMARY KEY,
    REGULATION_NAME     VARCHAR(200) NOT NULL,
    REGULATION_BODY     VARCHAR(200) NOT NULL,
    CLASS_URI           VARCHAR(500) NOT NULL,
    REQUIREMENT_TYPE    VARCHAR(100),
    DESCRIPTION         VARCHAR(4000),
    COMPLIANCE_METRICS  VARCHAR(2000),
    DATA_ELEMENTS       VARCHAR(2000),
    REPORTING_FREQUENCY VARCHAR(50),
    PENALTY_CONTEXT     VARCHAR(1000),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE FIBO_CONCEPT_MAPPINGS (
    MAPPING_ID          NUMBER(38,0) AUTOINCREMENT PRIMARY KEY,
    CONCEPT_TERM        VARCHAR(200) NOT NULL,
    CLASS_URI           VARCHAR(500) NOT NULL,
    TABLE_NAME          VARCHAR(200),
    COLUMN_MAPPINGS     VARCHAR(2000),
    QUERY_CONTEXT       VARCHAR(2000),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO FIBO_CLASSES (CLASS_URI, CLASS_NAME, PARENT_CLASS_URI, DOMAIN, SUBDOMAIN, DEFINITION, EXAMPLES, SYNONYMS, ISO_STANDARD, REGULATORY_CONTEXT, DATA_ELEMENTS)
VALUES
('fibo:FinancialInstrument', 'Financial Instrument', NULL, 'Financial Instruments', 'Core', 'A contract that gives rise to a financial asset of one entity and a financial liability or equity instrument of another entity.', 'Loans, Bonds, Derivatives, Equities', 'security, instrument, contract', 'ISO 10962 (CFI)', 'SEC, FINRA, OCC regulations', 'instrument_type, notional_value, currency, maturity_date'),
('fibo:DepositAccount', 'Deposit Account', 'fibo:FinancialInstrument', 'Banking', 'Deposits', 'An account held at a financial institution that allows deposits and withdrawals by the account holder.', 'Checking, Savings, Money Market, CD', 'bank account, deposit, savings account', 'ISO 13616 (IBAN)', 'FDIC insurance, Regulation D, Regulation CC', 'account_number, account_type, balance, interest_rate, status'),
('fibo:LoanContract', 'Loan Contract', 'fibo:FinancialInstrument', 'Banking', 'Lending', 'A debt instrument where a lender provides funds to a borrower who agrees to repay with interest over a specified period.', 'Mortgage, Auto Loan, Personal Loan, Commercial Loan, Home Equity', 'credit, lending, debt, mortgage, financing', 'ISO 20022', 'TILA, RESPA, ECOA, HMDA, CRA', 'loan_type, original_amount, interest_rate, term, collateral, ltv_ratio, dti_ratio'),
('fibo:PaymentTransaction', 'Payment Transaction', 'fibo:FinancialInstrument', 'Banking', 'Payments', 'A transfer of monetary value from one party to another through a payment system or instrument.', 'Wire Transfer, ACH, Check, Card Payment, Bill Pay', 'payment, transfer, remittance, transaction', 'ISO 20022 (pacs/pain)', 'Regulation E, UCC Article 4A, EFTA', 'transaction_type, amount, currency, channel, merchant, date'),
('fibo:Customer', 'Customer', NULL, 'Clients', 'Retail', 'A person or organization that has a relationship with a financial institution and uses its products or services.', 'Individual, Joint, Business, Trust', 'client, account holder, borrower, depositor', NULL, 'KYC, CDD, CIP requirements', 'name, dob, ssn, address, segment, risk_rating, kyc_status'),
('fibo:CorporateCustomer', 'Corporate Customer', 'fibo:Customer', 'Clients', 'Commercial', 'A business entity that maintains a banking relationship for commercial purposes.', 'Corporation, LLC, Partnership, Non-profit', 'business client, commercial client, corporate account', NULL, 'EDD for high-risk entities, beneficial ownership', 'entity_type, ein, authorized_signers, beneficial_owners'),
('fibo:KYC', 'Know Your Customer', NULL, 'Compliance', 'Customer Due Diligence', 'The process of verifying the identity of customers and assessing the risk they pose for money laundering or terrorist financing.', 'CDD, EDD, SDD, Ongoing Monitoring', 'customer due diligence, identity verification, CDD, EDD', NULL, 'BSA/AML, USA PATRIOT Act Section 326, FinCEN CDD Rule', 'identity_documents, verification_status, risk_level, pep_check, sanctions_check, review_date'),
('fibo:AML', 'Anti-Money Laundering', NULL, 'Compliance', 'Financial Crime', 'Programs, policies, and procedures designed to prevent, detect, and report money laundering activities.', 'Transaction Monitoring, SAR Filing, CTR Filing, Sanctions Screening', 'money laundering prevention, BSA compliance, financial crime', NULL, 'BSA, USA PATRIOT Act, FinCEN regulations, OFAC', 'suspicious_activity, transaction_patterns, sar_filed, ctr_filed, investigation_status'),
('fibo:BSA', 'Bank Secrecy Act', 'fibo:AML', 'Compliance', 'Regulatory', 'U.S. legislation requiring financial institutions to assist government agencies in detecting and preventing money laundering.', 'CTR filing, SAR filing, Record keeping, Travel Rule', 'BSA compliance, currency transaction reporting', NULL, 'FinCEN, Federal banking regulators', 'ctr_threshold, sar_criteria, record_retention, reporting_deadlines'),
('fibo:OFAC', 'OFAC Compliance', 'fibo:AML', 'Compliance', 'Sanctions', 'Compliance with the Office of Foreign Assets Control sanctions programs and screening requirements.', 'SDN List screening, Country sanctions, Sectoral sanctions', 'sanctions screening, SDN check, embargo compliance', NULL, 'OFAC, Treasury Department', 'screening_results, match_status, escalation_required, false_positive_rate'),
('fibo:CreditRisk', 'Credit Risk', NULL, 'Risk Management', 'Credit', 'The risk of loss arising from a borrower failing to meet their contractual obligations to repay debt.', 'Default Risk, Concentration Risk, Country Risk, Settlement Risk', 'default risk, counterparty risk, loan loss', 'ISO 22739', 'Basel III Pillar 1, CECL, IFRS 9', 'pd, lgd, ead, risk_grade, expected_loss, provision_amount'),
('fibo:OperationalRisk', 'Operational Risk', NULL, 'Risk Management', 'Operations', 'The risk of loss resulting from inadequate or failed internal processes, people, systems, or external events.', 'Fraud, System Failure, Process Error, Cyber Risk', 'process risk, system risk, people risk', NULL, 'Basel III Pillar 1, OCC guidance', 'risk_event_type, loss_amount, frequency, controls_effectiveness'),
('fibo:MarketRisk', 'Market Risk', NULL, 'Risk Management', 'Market', 'The risk of losses in financial instruments arising from movements in market prices.', 'Interest Rate Risk, Foreign Exchange Risk, Equity Risk', 'price risk, rate risk, FX risk', NULL, 'Basel III Pillar 1, FRTB', 'var, sensitivity, stress_test_results, duration_gap'),
('fibo:LiquidityRisk', 'Liquidity Risk', NULL, 'Risk Management', 'Treasury', 'The risk that an institution cannot meet its financial obligations as they come due without incurring unacceptable losses.', 'Funding Liquidity Risk, Market Liquidity Risk', 'funding risk, cash flow risk', NULL, 'Basel III LCR/NSFR, Regulation YY', 'lcr, nsfr, cash_flow_projections, contingency_funding'),
('fibo:BaselIII', 'Basel III Framework', NULL, 'Regulatory', 'Capital', 'International regulatory framework for banks covering capital adequacy, stress testing, and market liquidity risk.', 'CET1, Tier 1, Total Capital, Leverage Ratio, LCR, NSFR', 'capital requirements, regulatory capital, Basel accords', NULL, 'BCBS, Federal Reserve, OCC, FDIC', 'cet1_ratio, tier1_ratio, total_capital_ratio, leverage_ratio, risk_weighted_assets'),
('fibo:IRBApproach', 'Internal Ratings-Based Approach', 'fibo:BaselIII', 'Regulatory', 'Credit Risk Capital', 'Basel approach where banks use their internal models to estimate credit risk parameters for regulatory capital calculation.', 'Foundation IRB, Advanced IRB', 'internal ratings, PD models, LGD models', NULL, 'Basel III Pillar 1, OCC 2011-12', 'pd_model, lgd_model, ead_model, risk_weight_function'),
('fibo:HMDA', 'Home Mortgage Disclosure Act', NULL, 'Compliance', 'Fair Lending', 'Federal law requiring financial institutions to maintain, report, and publicly disclose information about mortgages.', 'HMDA LAR, Rate Spread, HOEPA', 'mortgage disclosure, fair lending data', NULL, 'CFPB Regulation C', 'application_data, action_taken, rate_spread, loan_purpose, property_type'),
('fibo:CRA', 'Community Reinvestment Act', NULL, 'Compliance', 'Fair Lending', 'Federal law encouraging financial institutions to meet the credit needs of the communities in which they operate.', 'CRA Exam, Assessment Area, Community Development', 'community lending, CRA rating', NULL, 'OCC, FDIC, Federal Reserve', 'assessment_area, lending_test, investment_test, service_test, cra_rating'),
('fibo:WholesaleBanking', 'Wholesale Banking', NULL, 'Banking', 'Commercial', 'Banking services provided to large corporate clients, institutions, and government entities.', 'Commercial Lending, Treasury Services, Trade Finance, Capital Markets', 'commercial banking, corporate banking, institutional banking', NULL, 'Multiple regulatory frameworks', 'corporate_loans, treasury_products, trade_finance_volume'),
('fibo:CorrespondentBanking', 'Correspondent Banking', 'fibo:WholesaleBanking', 'Banking', 'Interbank', 'Arrangement where one bank provides services on behalf of another bank, particularly for cross-border transactions.', 'Nostro/Vostro accounts, Payment clearing, FX services', 'correspondent account, interbank relationship', NULL, 'BSA/AML enhanced due diligence, Wolfsberg Principles', 'correspondent_bank, nostro_balance, transaction_volume, due_diligence_level');

INSERT INTO FIBO_RELATIONSHIPS (SOURCE_CLASS_URI, TARGET_CLASS_URI, RELATIONSHIP_TYPE, RELATIONSHIP_NAME, DESCRIPTION, CARDINALITY, IS_BIDIRECTIONAL)
VALUES
('fibo:Customer', 'fibo:DepositAccount', 'HAS', 'hasAccount', 'A customer holds one or more deposit accounts', '1:N', FALSE),
('fibo:Customer', 'fibo:LoanContract', 'HAS', 'hasLoan', 'A customer has one or more loan contracts', '1:N', FALSE),
('fibo:Customer', 'fibo:KYC', 'SUBJECT_OF', 'subjectOfKYC', 'A customer is subject to KYC requirements', '1:1', FALSE),
('fibo:DepositAccount', 'fibo:PaymentTransaction', 'GENERATES', 'generatesTransaction', 'An account generates payment transactions', '1:N', FALSE),
('fibo:LoanContract', 'fibo:CreditRisk', 'ASSESSED_BY', 'assessedForCreditRisk', 'A loan is assessed for credit risk', '1:N', FALSE),
('fibo:KYC', 'fibo:AML', 'SUPPORTS', 'supportsAML', 'KYC processes support AML compliance programs', 'N:N', TRUE),
('fibo:KYC', 'fibo:BSA', 'REQUIRED_BY', 'requiredByBSA', 'KYC is required under the Bank Secrecy Act', 'N:1', FALSE),
('fibo:AML', 'fibo:BSA', 'GOVERNED_BY', 'governedByBSA', 'AML programs are governed by BSA requirements', 'N:1', FALSE),
('fibo:AML', 'fibo:OFAC', 'INCLUDES', 'includesOFAC', 'AML programs include OFAC sanctions screening', '1:1', FALSE),
('fibo:CreditRisk', 'fibo:BaselIII', 'REGULATED_BY', 'regulatedByBasel', 'Credit risk measurement is regulated by Basel III', 'N:1', FALSE),
('fibo:CreditRisk', 'fibo:IRBApproach', 'MEASURED_BY', 'measuredByIRB', 'Credit risk can be measured using the IRB approach', '1:1', FALSE),
('fibo:OperationalRisk', 'fibo:BaselIII', 'REGULATED_BY', 'regulatedByBasel', 'Operational risk is part of Basel III Pillar 1', 'N:1', FALSE),
('fibo:MarketRisk', 'fibo:BaselIII', 'REGULATED_BY', 'regulatedByBasel', 'Market risk is regulated under Basel III FRTB', 'N:1', FALSE),
('fibo:LiquidityRisk', 'fibo:BaselIII', 'REGULATED_BY', 'regulatedByBasel', 'Liquidity risk is governed by Basel III LCR/NSFR', 'N:1', FALSE),
('fibo:LoanContract', 'fibo:HMDA', 'REPORTED_UNDER', 'reportedUnderHMDA', 'Mortgage loans are reported under HMDA', 'N:1', FALSE),
('fibo:LoanContract', 'fibo:CRA', 'EVALUATED_UNDER', 'evaluatedUnderCRA', 'Lending activity is evaluated under CRA', 'N:1', FALSE),
('fibo:WholesaleBanking', 'fibo:CorrespondentBanking', 'INCLUDES', 'includesCorrespondent', 'Wholesale banking includes correspondent banking services', '1:N', FALSE),
('fibo:CorrespondentBanking', 'fibo:AML', 'SUBJECT_TO', 'subjectToAML', 'Correspondent banking relationships require enhanced AML due diligence', '1:1', FALSE);

INSERT INTO FIBO_REGULATORY_MAPPINGS (REGULATION_NAME, REGULATION_BODY, CLASS_URI, REQUIREMENT_TYPE, DESCRIPTION, COMPLIANCE_METRICS, DATA_ELEMENTS, REPORTING_FREQUENCY, PENALTY_CONTEXT)
VALUES
('Bank Secrecy Act (BSA)', 'FinCEN', 'fibo:AML', 'Reporting', 'Requires filing of CTRs for cash transactions over $10,000 and SARs for suspicious activity.', 'CTR filing rate, SAR filing timeliness, investigation closure rate', 'transaction_amount, cash_indicator, customer_id, filing_date', 'Ongoing / As Required', 'Civil penalties up to $1M per violation; criminal penalties include imprisonment'),
('USA PATRIOT Act Section 326', 'FinCEN', 'fibo:KYC', 'Customer Identification', 'Requires banks to implement a Customer Identification Program (CIP) to verify customer identity.', 'CIP completion rate, identity verification success rate, document collection rate', 'customer_name, dob, address, id_number, verification_method', 'At Account Opening', 'Enforcement actions, consent orders, civil money penalties'),
('FinCEN CDD Rule', 'FinCEN', 'fibo:KYC', 'Due Diligence', 'Requires banks to identify and verify beneficial owners of legal entity customers and conduct ongoing monitoring.', 'Beneficial ownership collection rate, ongoing monitoring coverage, risk review completion', 'beneficial_owners, ownership_percentage, risk_rating, review_date', 'At Onboarding + Ongoing', 'Civil money penalties, enforcement actions, MRAs'),
('OFAC Sanctions', 'Treasury/OFAC', 'fibo:OFAC', 'Screening', 'Requires screening of all customers and transactions against OFAC sanctions lists.', 'Screening coverage, false positive rate, match resolution time, blocked transaction count', 'screening_result, match_score, sdn_match, country_sanctions, resolution', 'Real-time', 'Strict liability; penalties up to $20M or 20 years imprisonment'),
('Basel III Capital Requirements', 'BCBS/Federal Reserve', 'fibo:BaselIII', 'Capital Adequacy', 'Requires banks to maintain minimum capital ratios including CET1, Tier 1, and Total Capital.', 'CET1 ratio (min 4.5%), Tier 1 ratio (min 6%), Total capital ratio (min 8%), Leverage ratio (min 3%)', 'risk_weighted_assets, cet1_capital, tier1_capital, total_capital', 'Quarterly', 'Capital distribution restrictions, supervisory action'),
('Basel III LCR', 'BCBS/Federal Reserve', 'fibo:LiquidityRisk', 'Liquidity', 'Requires banks to hold sufficient HQLA to cover net cash outflows over a 30-day stress period.', 'LCR ratio (min 100%), HQLA composition, net cash outflow', 'hqla_level1, hqla_level2, cash_outflows, cash_inflows', 'Monthly', 'Supervisory restrictions on capital distributions'),
('HMDA Regulation C', 'CFPB', 'fibo:HMDA', 'Reporting', 'Requires collection and reporting of mortgage lending data to identify discriminatory lending patterns.', 'Data completeness rate, timely submission, accuracy rate', 'application_date, action_taken, loan_amount, rate_spread, demographics', 'Annually (March 1)', 'Civil money penalties, enforcement actions, public disclosure'),
('Community Reinvestment Act', 'OCC/FDIC/Fed', 'fibo:CRA', 'Community Investment', 'Requires banks to meet credit needs of their communities including low and moderate income neighborhoods.', 'CRA rating, lending test score, investment test score, service test score', 'assessment_area, lmi_lending, community_development, branch_distribution', 'Exam Cycle (3-5 years)', 'Denial of expansion applications, public disclosure of ratings'),
('TILA (Regulation Z)', 'CFPB', 'fibo:LoanContract', 'Disclosure', 'Requires clear disclosure of loan terms, APR, and total cost of credit to borrowers.', 'Disclosure accuracy, timing compliance, APR calculation accuracy', 'apr, finance_charge, total_payments, payment_schedule', 'At Origination + Periodic', 'Statutory damages, class action liability, regulatory penalties'),
('ECOA (Regulation B)', 'CFPB', 'fibo:LoanContract', 'Fair Lending', 'Prohibits discrimination in credit transactions on the basis of protected characteristics.', 'Denial rate disparities, pricing disparities, application processing time', 'applicant_demographics, action_taken, reasons_for_denial, pricing', 'Ongoing', 'Actual damages, punitive damages up to $10K individual / $500K class'),
('Regulation E', 'CFPB', 'fibo:PaymentTransaction', 'Consumer Protection', 'Establishes rights and liabilities of consumers in electronic fund transfers.', 'Error resolution timeliness, provisional credit compliance, disclosure completeness', 'transfer_type, error_type, resolution_date, provisional_credit', 'Ongoing / Per Event', 'Actual damages, statutory damages up to $1K individual'),
('FDIC Insurance', 'FDIC', 'fibo:DepositAccount', 'Deposit Insurance', 'Provides insurance coverage for deposits up to $250,000 per depositor per institution.', 'Insurance coverage accuracy, depositor notification compliance', 'account_ownership, insurance_category, aggregate_balance', 'Ongoing', 'Loss of insured status, enforcement actions');

INSERT INTO FIBO_PROPERTIES (PROPERTY_URI, PROPERTY_NAME, DOMAIN_CLASS_URI, RANGE_CLASS_URI, PROPERTY_TYPE, DEFINITION, DATA_TYPE, IS_REQUIRED)
VALUES
('fibo:hasBalance', 'Account Balance', 'fibo:DepositAccount', NULL, 'DataProperty', 'Current balance of the deposit account', 'NUMBER', TRUE),
('fibo:hasAccountType', 'Account Type', 'fibo:DepositAccount', NULL, 'DataProperty', 'Classification of the account (checking, savings, etc.)', 'VARCHAR', TRUE),
('fibo:hasInterestRate', 'Interest Rate', 'fibo:LoanContract', NULL, 'DataProperty', 'Annual interest rate of the loan', 'NUMBER', TRUE),
('fibo:hasOriginalAmount', 'Original Loan Amount', 'fibo:LoanContract', NULL, 'DataProperty', 'Original principal amount of the loan', 'NUMBER', TRUE),
('fibo:hasLTV', 'Loan to Value Ratio', 'fibo:LoanContract', NULL, 'DataProperty', 'Ratio of loan amount to collateral value', 'NUMBER', FALSE),
('fibo:hasDTI', 'Debt to Income Ratio', 'fibo:LoanContract', NULL, 'DataProperty', 'Ratio of total debt payments to gross income', 'NUMBER', FALSE),
('fibo:hasRiskGrade', 'Risk Grade', 'fibo:CreditRisk', NULL, 'DataProperty', 'Internal risk grade assigned to the credit exposure', 'VARCHAR', TRUE),
('fibo:hasPD', 'Probability of Default', 'fibo:CreditRisk', NULL, 'DataProperty', 'Estimated probability that the borrower will default', 'NUMBER', FALSE),
('fibo:hasLGD', 'Loss Given Default', 'fibo:CreditRisk', NULL, 'DataProperty', 'Estimated loss percentage if default occurs', 'NUMBER', FALSE),
('fibo:hasKYCStatus', 'KYC Status', 'fibo:KYC', NULL, 'DataProperty', 'Current status of KYC review (Verified, Pending, Expired)', 'VARCHAR', TRUE),
('fibo:hasRiskRating', 'Customer Risk Rating', 'fibo:Customer', NULL, 'DataProperty', 'AML/BSA risk rating for the customer', 'VARCHAR', TRUE),
('fibo:hasCreditScore', 'Credit Score', 'fibo:Customer', NULL, 'DataProperty', 'External credit bureau score', 'NUMBER', FALSE),
('fibo:hasTransactionAmount', 'Transaction Amount', 'fibo:PaymentTransaction', NULL, 'DataProperty', 'Monetary value of the payment transaction', 'NUMBER', TRUE),
('fibo:hasCET1Ratio', 'CET1 Capital Ratio', 'fibo:BaselIII', NULL, 'DataProperty', 'Common Equity Tier 1 capital as percentage of RWA', 'NUMBER', TRUE),
('fibo:hasLCR', 'Liquidity Coverage Ratio', 'fibo:LiquidityRisk', NULL, 'DataProperty', 'HQLA divided by total net cash outflows over 30 days', 'NUMBER', TRUE);

INSERT INTO FIBO_CONCEPT_MAPPINGS (CONCEPT_TERM, CLASS_URI, TABLE_NAME, COLUMN_MAPPINGS, QUERY_CONTEXT)
VALUES
('customer', 'fibo:Customer', 'CATHAY_BANK_DB.RAW.CUSTOMERS', 'CUSTOMER_ID, FIRST_NAME, LAST_NAME, CUSTOMER_SEGMENT, RISK_RATING, KYC_STATUS, CREDIT_SCORE, ANNUAL_INCOME', 'Use for questions about customers, clients, account holders, demographics, and customer segments'),
('account', 'fibo:DepositAccount', 'CATHAY_BANK_DB.RAW.ACCOUNTS', 'ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, CURRENT_BALANCE, STATUS, BRANCH_NAME', 'Use for questions about bank accounts, balances, checking, savings, deposits'),
('transaction', 'fibo:PaymentTransaction', 'CATHAY_BANK_DB.RAW.TRANSACTIONS', 'TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_TYPE, AMOUNT, TRANSACTION_DATE, CHANNEL, MERCHANT_NAME', 'Use for questions about payments, transfers, deposits, withdrawals, spending patterns'),
('loan', 'fibo:LoanContract', 'CATHAY_BANK_DB.RAW.LOANS', 'LOAN_ID, CUSTOMER_ID, LOAN_TYPE, ORIGINAL_AMOUNT, CURRENT_BALANCE, INTEREST_RATE, DELINQUENCY_STATUS, RISK_GRADE', 'Use for questions about loans, mortgages, credit, lending, delinquency, LTV, DTI'),
('compliance', 'fibo:AML', 'CATHAY_BANK_DB.RAW.COMPLIANCE_EVENTS', 'EVENT_ID, EVENT_TYPE, REGULATORY_FRAMEWORK, SEVERITY, STATUS, SAR_FILED', 'Use for questions about compliance events, AML, BSA, KYC, regulatory issues, SARs, CTRs'),
('risk', 'fibo:CreditRisk', 'CATHAY_BANK_DB.RAW.RISK_ASSESSMENTS', 'ASSESSMENT_ID, ASSESSMENT_TYPE, RISK_CATEGORY, RISK_SCORE, RISK_RATING', 'Use for questions about risk assessments, credit risk, operational risk, risk scores'),
('support', 'fibo:Customer', 'CATHAY_BANK_DB.RAW.SUPPORT_CASES', 'CASE_ID, CUSTOMER_ID, CATEGORY, PRIORITY, STATUS, SATISFACTION_SCORE', 'Use for questions about customer service, support cases, complaints, satisfaction'),
('KYC', 'fibo:KYC', 'CATHAY_BANK_DB.RAW.CUSTOMERS', 'CUSTOMER_ID, KYC_STATUS, KYC_LAST_REVIEWED, RISK_RATING', 'Use for questions about Know Your Customer, identity verification, due diligence'),
('AML', 'fibo:AML', 'CATHAY_BANK_DB.RAW.COMPLIANCE_EVENTS', 'EVENT_ID, EVENT_TYPE, REGULATORY_FRAMEWORK, SAR_FILED, CTR_FILED', 'Use for questions about anti-money laundering, suspicious activity, transaction monitoring'),
('mortgage', 'fibo:LoanContract', 'CATHAY_BANK_DB.RAW.LOANS', 'LOAN_ID, LOAN_TYPE, ORIGINAL_AMOUNT, INTEREST_RATE, LTV_RATIO, COLLATERAL_VALUE', 'Use for questions about home loans, mortgages, HMDA, refinancing. Filter LOAN_TYPE for mortgage types'),
('branch', 'fibo:Customer', 'CATHAY_BANK_DB.RAW.BRANCHES', 'BRANCH_ID, BRANCH_NAME, STATE, REGION, IS_ACTIVE', 'Use for questions about branch locations, regional performance, branch operations'),
('regulation', 'fibo:BSA', 'CATHAY_BANK_DB.ONTOLOGY.FIBO_REGULATORY_MAPPINGS', 'REGULATION_NAME, REGULATION_BODY, REQUIREMENT_TYPE, COMPLIANCE_METRICS', 'Use for questions about regulations, regulatory requirements, compliance frameworks');
