/*
  _____ _   _____ _   _   ___   __   ____    _   _   _ _  __
 / ____| | |_   _| | | | / \ \ / /  |  _ \  / \ | \ | | |/ /
| |    | |   | | | |_| |/ _ \ V /   | |_) |/ _ \|  \| | ' / 
| |    | |   | | |  _  / ___ \| |    |  _ </ ___ \ |\  | . \ 
| |____| |___| |_| | |/_/   \_\_|    |_| \_\_/   \_| \_|_|\_\
 \_____|_____|_|_|_|                                          

Snowflake Intelligence Demo - Cathay Bank
Table Creation Script

This script creates all core banking tables representing:
- Customers and their demographics
- Accounts (checking, savings, money market, CDs)
- Transactions
- Loans and credit products
- Branches and ATMs
- Employee and service data
- Digital banking activity

Run Time: < 1 minute
*/

-- Ensure we're in the right context
-- USE ROLE CATHAY_DEMO_ROLE;
USE WAREHOUSE CATHAY_DEMO_WH;
USE DATABASE CATHAY_BANK_DEMO;
USE SCHEMA RAW;

-- ============================================================================
-- REFERENCE DATA TABLES
-- ============================================================================

-- Branch locations
CREATE OR REPLACE TABLE BRANCHES (
    branch_id VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_type VARCHAR(50), -- Full Service, Limited Service, International
    address VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(50) DEFAULT 'USA',
    phone VARCHAR(20),
    manager_employee_id VARCHAR(10),
    opening_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    has_safe_deposit BOOLEAN DEFAULT TRUE,
    has_notary BOOLEAN DEFAULT TRUE,
    has_wire_service BOOLEAN DEFAULT TRUE,
    lobby_hours_weekday VARCHAR(50),
    lobby_hours_weekend VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ATM locations
CREATE OR REPLACE TABLE ATMS (
    atm_id VARCHAR(10) PRIMARY KEY,
    branch_id VARCHAR(10),
    location_type VARCHAR(50), -- Branch, Standalone, Partner
    address VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    is_deposit_enabled BOOLEAN DEFAULT TRUE,
    is_24_hours BOOLEAN DEFAULT TRUE,
    languages_supported ARRAY,
    daily_withdrawal_limit DECIMAL(10,2) DEFAULT 1000.00,
    installation_date DATE,
    last_service_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Product catalog
CREATE OR REPLACE TABLE PRODUCTS (
    product_id VARCHAR(20) PRIMARY KEY,
    product_category VARCHAR(50), -- Deposit, Loan, Investment, Service
    product_type VARCHAR(50), -- Checking, Savings, CD, Mortgage, etc.
    product_name VARCHAR(100),
    product_code VARCHAR(20),
    minimum_balance DECIMAL(10,2),
    monthly_fee DECIMAL(10,2),
    interest_rate DECIMAL(5,4),
    term_months INTEGER,
    features ARRAY,
    eligibility_criteria VARIANT,
    is_active BOOLEAN DEFAULT TRUE,
    launch_date DATE,
    sunset_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- CUSTOMER DATA TABLES
-- ============================================================================

-- Customer master
CREATE OR REPLACE TABLE CUSTOMERS (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_type VARCHAR(20), -- Individual, Business, Trust
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    business_name VARCHAR(200),
    date_of_birth DATE,
    ssn_tin_hash VARCHAR(100), -- Hashed for security
    email VARCHAR(200),
    phone_primary VARCHAR(20),
    phone_secondary VARCHAR(20),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(50) DEFAULT 'USA',
    primary_branch_id VARCHAR(10),
    customer_since DATE,
    preferred_language VARCHAR(20) DEFAULT 'English',
    occupation VARCHAR(100),
    annual_income_range VARCHAR(50),
    credit_score_range VARCHAR(20),
    kyc_status VARCHAR(20) DEFAULT 'VERIFIED',
    risk_rating VARCHAR(20) DEFAULT 'LOW',
    is_employee BOOLEAN DEFAULT FALSE,
    is_vip BOOLEAN DEFAULT FALSE,
    marketing_consent BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Customer segments for analytics
CREATE OR REPLACE TABLE CUSTOMER_SEGMENTS (
    customer_id VARCHAR(20),
    segment_type VARCHAR(50), -- Demographic, Behavioral, Value
    segment_name VARCHAR(100), -- High Net Worth, Digital Native, Small Business
    segment_value VARCHAR(100),
    effective_date DATE,
    expiration_date DATE,
    confidence_score DECIMAL(3,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- ACCOUNT TABLES
-- ============================================================================

-- Account master
CREATE OR REPLACE TABLE ACCOUNTS (
    account_id VARCHAR(20) PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20),
    account_type VARCHAR(50), -- Checking, Savings, Money Market, CD
    account_subtype VARCHAR(50), -- Personal, Business, Student, etc.
    account_status VARCHAR(20), -- Active, Dormant, Closed, Frozen
    opening_date DATE,
    closing_date DATE,
    branch_id VARCHAR(10),
    current_balance DECIMAL(18,2),
    available_balance DECIMAL(18,2),
    hold_amount DECIMAL(18,2) DEFAULT 0,
    interest_rate DECIMAL(5,4),
    last_statement_date DATE,
    last_activity_date DATE,
    overdraft_protection BOOLEAN DEFAULT FALSE,
    overdraft_limit DECIMAL(10,2),
    maturity_date DATE, -- For CDs
    is_primary_account BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Joint account relationships
CREATE OR REPLACE TABLE ACCOUNT_RELATIONSHIPS (
    account_id VARCHAR(20),
    customer_id VARCHAR(20),
    relationship_type VARCHAR(50), -- Primary, Joint, Beneficiary, Authorized User
    ownership_percentage DECIMAL(5,2),
    signing_authority BOOLEAN DEFAULT TRUE,
    effective_date DATE,
    end_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- TRANSACTION TABLES
-- ============================================================================

-- Transaction master
CREATE OR REPLACE TABLE TRANSACTIONS (
    transaction_id VARCHAR(30) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_timestamp TIMESTAMP_NTZ NOT NULL,
    transaction_type VARCHAR(50), -- Deposit, Withdrawal, Transfer, Fee, Interest
    transaction_category VARCHAR(50), -- ATM, Branch, Online, Mobile, Wire
    transaction_subcategory VARCHAR(50), -- Cash, Check, ACH, etc.
    amount DECIMAL(18,2) NOT NULL,
    balance_after DECIMAL(18,2),
    description VARCHAR(500),
    merchant_name VARCHAR(200),
    merchant_category VARCHAR(100),
    location VARCHAR(200),
    channel VARCHAR(50), -- ATM, Branch, Online, Mobile, Phone
    device_id VARCHAR(50),
    ip_address VARCHAR(50),
    reference_number VARCHAR(50),
    counterparty_account VARCHAR(20),
    counterparty_bank VARCHAR(100),
    is_international BOOLEAN DEFAULT FALSE,
    currency_code VARCHAR(3) DEFAULT 'USD',
    exchange_rate DECIMAL(10,6),
    status VARCHAR(20) DEFAULT 'COMPLETED', -- Pending, Completed, Failed, Reversed
    fraud_score DECIMAL(3,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Card transactions
CREATE OR REPLACE TABLE CARD_TRANSACTIONS (
    card_transaction_id VARCHAR(30) PRIMARY KEY,
    transaction_id VARCHAR(30),
    card_id VARCHAR(20),
    card_number_masked VARCHAR(20),
    merchant_id VARCHAR(50),
    mcc_code VARCHAR(10),
    authorization_code VARCHAR(20),
    pos_entry_mode VARCHAR(20),
    is_chip_transaction BOOLEAN,
    is_contactless BOOLEAN,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- LENDING TABLES
-- ============================================================================

-- Loan master
CREATE OR REPLACE TABLE LOANS (
    loan_id VARCHAR(20) PRIMARY KEY,
    loan_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20),
    loan_type VARCHAR(50), -- Mortgage, Auto, Personal, Business, HELOC
    loan_purpose VARCHAR(100),
    original_amount DECIMAL(18,2),
    current_balance DECIMAL(18,2),
    interest_rate DECIMAL(5,4),
    term_months INTEGER,
    monthly_payment DECIMAL(10,2),
    origination_date DATE,
    first_payment_date DATE,
    maturity_date DATE,
    next_payment_date DATE,
    last_payment_date DATE,
    days_past_due INTEGER DEFAULT 0,
    times_30_days_late INTEGER DEFAULT 0,
    times_60_days_late INTEGER DEFAULT 0,
    times_90_days_late INTEGER DEFAULT 0,
    loan_status VARCHAR(20), -- Current, Delinquent, Default, Paid Off
    collateral_type VARCHAR(50),
    collateral_value DECIMAL(18,2),
    ltv_ratio DECIMAL(5,2), -- Loan to Value
    branch_id VARCHAR(10),
    loan_officer_id VARCHAR(10),
    underwriter_id VARCHAR(10),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Loan payments
CREATE OR REPLACE TABLE LOAN_PAYMENTS (
    payment_id VARCHAR(30) PRIMARY KEY,
    loan_id VARCHAR(20) NOT NULL,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    principal_amount DECIMAL(10,2),
    interest_amount DECIMAL(10,2),
    escrow_amount DECIMAL(10,2),
    late_fee_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Credit cards
CREATE OR REPLACE TABLE CREDIT_CARDS (
    card_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20),
    customer_id VARCHAR(20) NOT NULL,
    card_number_masked VARCHAR(20),
    card_type VARCHAR(50), -- Visa, Mastercard, etc.
    card_tier VARCHAR(50), -- Classic, Gold, Platinum
    credit_limit DECIMAL(10,2),
    current_balance DECIMAL(10,2),
    available_credit DECIMAL(10,2),
    cash_advance_limit DECIMAL(10,2),
    interest_rate_purchase DECIMAL(5,4),
    interest_rate_cash DECIMAL(5,4),
    annual_fee DECIMAL(10,2),
    reward_program VARCHAR(100),
    issue_date DATE,
    expiration_date DATE,
    last_used_date DATE,
    card_status VARCHAR(20), -- Active, Blocked, Expired, Cancelled
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- DIGITAL BANKING TABLES
-- ============================================================================

-- Online banking users
CREATE OR REPLACE TABLE DIGITAL_USERS (
    user_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(200),
    phone_number VARCHAR(20),
    enrollment_date DATE,
    last_login_timestamp TIMESTAMP_NTZ,
    login_count INTEGER DEFAULT 0,
    preferred_channel VARCHAR(20), -- Web, Mobile, Both
    is_mobile_enrolled BOOLEAN DEFAULT FALSE,
    is_text_banking_enrolled BOOLEAN DEFAULT FALSE,
    is_paperless BOOLEAN DEFAULT FALSE,
    security_questions_set BOOLEAN DEFAULT TRUE,
    two_factor_enabled BOOLEAN DEFAULT TRUE,
    biometric_enabled BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Digital banking sessions
CREATE OR REPLACE TABLE DIGITAL_SESSIONS (
    session_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(20),
    channel VARCHAR(20), -- Web, Mobile App, Mobile Web
    device_type VARCHAR(50),
    device_id VARCHAR(100),
    ip_address VARCHAR(50),
    location_city VARCHAR(100),
    location_state VARCHAR(50),
    session_start TIMESTAMP_NTZ,
    session_end TIMESTAMP_NTZ,
    duration_seconds INTEGER,
    pages_viewed INTEGER,
    actions_performed ARRAY,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- CUSTOMER SERVICE TABLES
-- ============================================================================

-- Service requests
CREATE OR REPLACE TABLE SERVICE_REQUESTS (
    request_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20),
    request_type VARCHAR(50), -- Account Service, Card Service, Dispute, etc.
    request_category VARCHAR(100),
    channel VARCHAR(50), -- Branch, Phone, Online, Mobile
    priority VARCHAR(20), -- Low, Medium, High, Critical
    status VARCHAR(20), -- Open, In Progress, Resolved, Closed
    branch_id VARCHAR(10),
    assigned_to VARCHAR(10),
    description TEXT,
    resolution_notes TEXT,
    created_date DATE,
    created_timestamp TIMESTAMP_NTZ,
    resolved_timestamp TIMESTAMP_NTZ,
    satisfaction_score INTEGER,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Marketing campaigns
CREATE OR REPLACE TABLE MARKETING_CAMPAIGNS (
    campaign_id VARCHAR(20) PRIMARY KEY,
    campaign_name VARCHAR(200),
    campaign_type VARCHAR(50), -- Email, Direct Mail, Digital, Branch
    product_id VARCHAR(20),
    target_segment VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    expected_response_rate DECIMAL(5,2),
    actual_response_rate DECIMAL(5,2),
    status VARCHAR(20),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Campaign responses
CREATE OR REPLACE TABLE CAMPAIGN_RESPONSES (
    response_id VARCHAR(30) PRIMARY KEY,
    campaign_id VARCHAR(20),
    customer_id VARCHAR(20),
    response_date DATE,
    response_type VARCHAR(50), -- Click, Call, Visit, Purchase
    conversion_flag BOOLEAN DEFAULT FALSE,
    conversion_amount DECIMAL(10,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- EMPLOYEE TABLES
-- ============================================================================

-- Employee master
CREATE OR REPLACE TABLE EMPLOYEES (
    employee_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(200),
    job_title VARCHAR(100),
    department VARCHAR(100),
    branch_id VARCHAR(10),
    manager_id VARCHAR(10),
    hire_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    is_loan_officer BOOLEAN DEFAULT FALSE,
    nmls_id VARCHAR(20), -- For loan officers
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- INDEXES AND CONSTRAINTS
-- ============================================================================

-- Add foreign key constraints
ALTER TABLE ACCOUNTS ADD CONSTRAINT fk_accounts_customer 
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id);

ALTER TABLE TRANSACTIONS ADD CONSTRAINT fk_transactions_account 
    FOREIGN KEY (account_id) REFERENCES ACCOUNTS(account_id);

ALTER TABLE LOANS ADD CONSTRAINT fk_loans_customer 
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id);

ALTER TABLE CREDIT_CARDS ADD CONSTRAINT fk_cards_customer 
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id);

-- ============================================================================
-- CONFIRMATION
-- ============================================================================

-- Show created tables
SHOW TABLES IN SCHEMA RAW;

-- Display completion message
SELECT 'Cathay Bank table creation completed successfully!' AS STATUS,
       COUNT(*) AS TABLES_CREATED,
       CURRENT_TIMESTAMP() AS COMPLETED_AT
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'RAW'
  AND TABLE_CATALOG = 'CATHAY_BANK_DEMO';
