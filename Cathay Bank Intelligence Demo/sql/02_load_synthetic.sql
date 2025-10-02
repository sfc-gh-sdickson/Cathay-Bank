/*
  _____ _   _____ _   _   ___   __   ____    _   _   _ _  __
 / ____| | |_   _| | | | / \ \ / /  |  _ \  / \ | \ | | |/ /
| |    | |   | | | |_| |/ _ \ V /   | |_) |/ _ \|  \| | ' / 
| |    | |   | | |  _  / ___ \| |    |  _ </ ___ \ |\  | . \ 
| |____| |___| |_| | |/_/   \_\_|    |_| \_\_/   \_| \_|_|\_\
 \_____|_____|_|_|_|                                          

Snowflake Intelligence Demo - Cathay Bank
Synthetic Data Generation Script

This script generates realistic synthetic banking data including:
- 50,000 customers across different segments
- 120,000 accounts with realistic balances
- 5 million transactions over 2 years
- 30,000 loans with payment history
- 20,000 credit cards
- Digital banking activity
- Customer service interactions

Run Time: 5-10 minutes depending on warehouse size
*/

-- Ensure we're in the right context
-- USE ROLE CATHAY_DEMO_ROLE;
USE WAREHOUSE CATHAY_DEMO_WH;
USE DATABASE CATHAY_BANK_DEMO;
USE SCHEMA RAW;

-- ============================================================================
-- TRUNCATE TABLES TO PREVENT DUPLICATE DATA
-- ============================================================================

-- IMPORTANT: Truncate in correct order to respect foreign key constraints
-- Child tables must be truncated before parent tables

-- Truncate dependent tables first
TRUNCATE TABLE IF EXISTS CAMPAIGN_RESPONSES;
TRUNCATE TABLE IF EXISTS MARKETING_CAMPAIGNS;
TRUNCATE TABLE IF EXISTS SERVICE_REQUESTS;
TRUNCATE TABLE IF EXISTS DIGITAL_SESSIONS;
TRUNCATE TABLE IF EXISTS DIGITAL_USERS;
TRUNCATE TABLE IF EXISTS CARD_TRANSACTIONS;
TRUNCATE TABLE IF EXISTS CREDIT_CARDS;
TRUNCATE TABLE IF EXISTS LOAN_PAYMENTS;
TRUNCATE TABLE IF EXISTS LOANS;
TRUNCATE TABLE IF EXISTS TRANSACTIONS;
TRUNCATE TABLE IF EXISTS ACCOUNT_RELATIONSHIPS;
TRUNCATE TABLE IF EXISTS ACCOUNTS;
TRUNCATE TABLE IF EXISTS CUSTOMER_SEGMENTS;
TRUNCATE TABLE IF EXISTS CUSTOMERS;
TRUNCATE TABLE IF EXISTS EMPLOYEES;
TRUNCATE TABLE IF EXISTS PRODUCTS;
TRUNCATE TABLE IF EXISTS ATMS;
TRUNCATE TABLE IF EXISTS BRANCHES;

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Set session parameters
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 3600;

-- Note: For faster execution, consider using a LARGE warehouse:
-- ALTER WAREHOUSE CATHAY_DEMO_WH SET WAREHOUSE_SIZE = 'LARGE';

-- ============================================================================
-- LOAD REFERENCE DATA IN DEPENDENCY ORDER
-- ============================================================================

-- Step 1: Load Products (no dependencies)
INSERT INTO PRODUCTS
WITH product_data AS (
    SELECT * FROM (
        VALUES
        -- Checking accounts
        ('PROD001', 'Deposit', 'Checking', 'Essential Checking', 'CHK-ESS', 100, 5, 0.0001, NULL),
        ('PROD002', 'Deposit', 'Checking', 'Premium Checking', 'CHK-PREM', 2500, 0, 0.0005, NULL),
        ('PROD003', 'Deposit', 'Checking', 'Business Checking', 'CHK-BUS', 1000, 15, 0.0001, NULL),
        ('PROD004', 'Deposit', 'Checking', 'Student Checking', 'CHK-STU', 0, 0, 0.0001, NULL),
        -- Savings accounts
        ('PROD005', 'Deposit', 'Savings', 'Basic Savings', 'SAV-BAS', 300, 3, 0.0100, NULL),
        ('PROD006', 'Deposit', 'Savings', 'High Yield Savings', 'SAV-HY', 10000, 0, 0.0450, NULL),
        ('PROD007', 'Deposit', 'Money Market', 'Money Market Account', 'MM-STD', 2500, 0, 0.0350, NULL),
        -- CDs
        ('PROD008', 'Deposit', 'CD', '6 Month CD', 'CD-6M', 1000, 0, 0.0400, 6),
        ('PROD009', 'Deposit', 'CD', '12 Month CD', 'CD-12M', 1000, 0, 0.0450, 12),
        ('PROD010', 'Deposit', 'CD', '24 Month CD', 'CD-24M', 1000, 0, 0.0475, 24),
        ('PROD011', 'Deposit', 'CD', '60 Month CD', 'CD-60M', 1000, 0, 0.0500, 60),
        -- Loans
        ('PROD012', 'Loan', 'Mortgage', '30-Year Fixed Mortgage', 'MTG-30F', NULL, NULL, 0.0650, 360),
        ('PROD013', 'Loan', 'Mortgage', '15-Year Fixed Mortgage', 'MTG-15F', NULL, NULL, 0.0575, 180),
        ('PROD014', 'Loan', 'Mortgage', '5/1 ARM Mortgage', 'MTG-ARM', NULL, NULL, 0.0550, 360),
        ('PROD015', 'Loan', 'Auto', 'New Auto Loan', 'AUTO-NEW', NULL, NULL, 0.0450, 72),
        ('PROD016', 'Loan', 'Auto', 'Used Auto Loan', 'AUTO-USED', NULL, NULL, 0.0550, 60),
        ('PROD017', 'Loan', 'Personal', 'Personal Loan', 'PER-STD', NULL, NULL, 0.0899, 60),
        ('PROD018', 'Loan', 'Business', 'Small Business Loan', 'BUS-SML', NULL, NULL, 0.0650, 120),
        ('PROD019', 'Loan', 'HELOC', 'Home Equity Line of Credit', 'HELOC', NULL, NULL, 0.0725, 240),
        -- Credit Cards
        ('PROD020', 'Credit', 'Credit Card', 'Cathay Rewards Visa', 'CC-RWD', NULL, 0, 0.1699, NULL),
        ('PROD021', 'Credit', 'Credit Card', 'Cathay Platinum Mastercard', 'CC-PLAT', NULL, 95, 0.1499, NULL),
        ('PROD022', 'Credit', 'Credit Card', 'Business Credit Card', 'CC-BUS', NULL, 0, 0.1799, NULL)
    ) AS t(product_id, product_category, product_type, product_name, product_code, minimum_balance, monthly_fee, interest_rate, term_months)
)
SELECT 
    product_id,
    product_category,
    product_type,
    product_name,
    product_code,
    minimum_balance,
    monthly_fee,
    interest_rate,
    term_months,
    CASE product_type
        WHEN 'Checking' THEN ARRAY_CONSTRUCT('Online Banking', 'Mobile Banking', 'Bill Pay', 'Debit Card')
        WHEN 'Savings' THEN ARRAY_CONSTRUCT('Online Banking', 'Mobile Banking', 'ATM Access')
        WHEN 'Credit Card' THEN ARRAY_CONSTRUCT('Rewards Program', 'Mobile App', 'Fraud Protection', 'Zero Liability')
        ELSE ARRAY_CONSTRUCT()
    END AS features,
    OBJECT_CONSTRUCT('min_age', 18, 'min_credit_score', 
        CASE 
            WHEN product_category = 'Loan' THEN 620
            WHEN product_category = 'Credit' THEN 650
            ELSE NULL
        END
    ) AS eligibility_criteria,
    TRUE AS is_active,
    DATEADD('year', -(1 + (ABS(RANDOM()) % 10)), CURRENT_DATE()) AS launch_date,
    NULL AS sunset_date,
    CURRENT_TIMESTAMP() AS created_at
FROM product_data;

-- Step 2: Load Employees (no dependencies)
INSERT INTO EMPLOYEES
WITH departments AS (
    SELECT * FROM (
        VALUES
        ('Branch Operations', 'Branch'),
        ('Lending', 'Loan Officer'),
        ('Lending', 'Underwriter'),
        ('Customer Service', 'Customer Service Representative'),
        ('Management', 'Branch Manager'),
        ('Management', 'Regional Manager'),
        ('IT', 'Systems Administrator'),
        ('Marketing', 'Marketing Specialist'),
        ('Finance', 'Financial Analyst'),
        ('Compliance', 'Compliance Officer')
    ) AS t(department, job_title)
)
SELECT
    emp_id AS employee_id,
    ARRAY_CONSTRUCT('John', 'Jane', 'Michael', 'Sarah', 'David', 'Lisa', 'Robert', 'Jennifer')[UNIFORM(0, 7, RANDOM())] AS first_name,
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Chen', 'Wang', 'Kim', 'Lee', 'Garcia', 'Williams')[UNIFORM(0, 7, RANDOM())] AS last_name,
    LOWER(first_name || '.' || last_name || '@cathaybank.com') AS email,
    job_title,
    department,
    NULL AS branch_id,  -- Will be updated after branches are created  
    CASE 
        WHEN job_title = 'Branch Manager' THEN NULL
        WHEN job_title LIKE '%Representative%' THEN 'EMP0001'
        ELSE 'EMP0001'
    END AS manager_id,
    DATEADD('day', -(90 + (ABS(RANDOM()) % 3561)), CURRENT_DATE()) AS hire_date,
    TRUE AS is_active,
    job_title = 'Loan Officer' AS is_loan_officer,
    CASE WHEN job_title = 'Loan Officer' THEN 'NMLS' || LPAD((100000 + ABS(RANDOM()) % 900000)::VARCHAR, 6, '0') ELSE NULL END AS nmls_id,
    CURRENT_TIMESTAMP() AS created_at
FROM (
    -- Generate specific counts of each role to ensure we have what we need
    SELECT 'EMP' || LPAD(ROW_NUMBER() OVER (ORDER BY seq_num, seq4()), 4, '0') AS emp_id, 
           department, job_title
    FROM (
        -- 70 Branch Managers (more than 65 branches)
        SELECT 1 AS seq_num, * FROM TABLE(GENERATOR(ROWCOUNT => 70))
        CROSS JOIN (SELECT * FROM departments WHERE job_title = 'Branch Manager') d
        UNION ALL
        -- 150 Loan Officers 
        SELECT 2 AS seq_num, * FROM TABLE(GENERATOR(ROWCOUNT => 150))
        CROSS JOIN (SELECT * FROM departments WHERE job_title = 'Loan Officer') d
        UNION ALL
        -- 150 Underwriters
        SELECT 3 AS seq_num, * FROM TABLE(GENERATOR(ROWCOUNT => 150))
        CROSS JOIN (SELECT * FROM departments WHERE job_title = 'Underwriter') d
        UNION ALL
        -- 50 Customer Service Representatives
        SELECT 4 AS seq_num, * FROM TABLE(GENERATOR(ROWCOUNT => 50))
        CROSS JOIN (SELECT * FROM departments WHERE job_title = 'Customer Service Representative') d
        UNION ALL
        -- 180 Other roles
        SELECT 5 AS seq_num, * FROM TABLE(GENERATOR(ROWCOUNT => 180))
        CROSS JOIN (SELECT * FROM departments WHERE job_title NOT IN ('Branch Manager', 'Loan Officer', 'Underwriter', 'Customer Service Representative')) d
    )
) base;

-- Step 3: Load Branches (depends on Employees)
INSERT INTO BRANCHES
SELECT
    'BR' || LPAD(ROW_NUMBER() OVER (ORDER BY seq4()), 4, '0') AS branch_id,
    CASE 
        WHEN UNIFORM(1, 10, RANDOM()) <= 7 THEN 
            ARRAY_CONSTRUCT('Main Branch', 'Downtown Branch', 'Chinatown Branch', 'Financial District', 
                          'West LA Branch', 'Valley Branch', 'South Bay Branch', 'East LA Branch')[UNIFORM(0, 7, RANDOM())]
        ELSE 
            ARRAY_CONSTRUCT('International Banking Center', 'Commercial Banking Center', 'Wealth Management Center')[UNIFORM(0, 2, RANDOM())]
    END || ' - ' || 
    ARRAY_CONSTRUCT('Los Angeles', 'San Francisco', 'San Diego', 'San Jose', 'Oakland', 
                    'Irvine', 'Fremont', 'Sacramento', 'Long Beach', 'Anaheim')[UNIFORM(0, 9, RANDOM())] AS branch_name,
    ARRAY_CONSTRUCT('Full Service', 'Limited Service', 'International')[UNIFORM(0, 2, RANDOM())] AS branch_type,
    (100 + (ABS(RANDOM()) % 9900))::VARCHAR || ' ' || 
    ARRAY_CONSTRUCT('Main', 'Market', 'Broadway', 'First', 'Second', 'Park', 'Ocean', 'Hill')[UNIFORM(0, 7, RANDOM())] || ' Street' AS address,
    ARRAY_CONSTRUCT('Los Angeles', 'San Francisco', 'San Diego', 'San Jose', 'Oakland', 
                    'Irvine', 'Fremont', 'Sacramento', 'Long Beach', 'Anaheim')[UNIFORM(0, 9, RANDOM())] AS city,
    'CA' AS state,
    LPAD((90001 + ABS(RANDOM()) % 6162)::VARCHAR, 5, '0') AS zip_code,
    'USA' AS country,
    '(' || (213 + ABS(RANDOM()) % 713)::VARCHAR || ') ' || (100 + ABS(RANDOM()) % 900)::VARCHAR || '-' || (1000 + ABS(RANDOM()) % 9000)::VARCHAR AS phone,
    (SELECT employee_id FROM EMPLOYEES WHERE job_title = 'Branch Manager' ORDER BY RANDOM() LIMIT 1) AS manager_employee_id,
    DATEADD('day', -(365 + (ABS(RANDOM()) % 6936)), CURRENT_DATE()) AS opening_date,
    TRUE AS is_active,
    UNIFORM(0, 1, RANDOM()) > 0.2 AS has_safe_deposit,
    TRUE AS has_notary,
    TRUE AS has_wire_service,
    '9:00 AM - 5:00 PM' AS lobby_hours_weekday,
    CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN '9:00 AM - 1:00 PM' ELSE 'Closed' END AS lobby_hours_weekend,
    CURRENT_TIMESTAMP() AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 65));

-- Step 4: Load ATMs (depends on Branches)
INSERT INTO ATMS
SELECT
    'ATM' || LPAD(ROW_NUMBER() OVER (ORDER BY seq4()), 5, '0') AS atm_id,
    CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN b.branch_id ELSE NULL END AS branch_id,
    CASE 
        WHEN b.branch_id IS NOT NULL THEN 'Branch'
        WHEN UNIFORM(0, 1, RANDOM()) > 0.5 THEN 'Standalone'
        ELSE 'Partner'
    END AS location_type,
    CASE 
        WHEN b.branch_id IS NOT NULL THEN b.address
        ELSE (100 + (ABS(RANDOM()) % 9900))::VARCHAR || ' ' || 
             ARRAY_CONSTRUCT('Main', 'Market', 'Broadway', 'First', 'Second')[UNIFORM(0, 4, RANDOM())] || ' Street'
    END AS address,
    COALESCE(b.city, ARRAY_CONSTRUCT('Los Angeles', 'San Francisco', 'San Diego')[UNIFORM(0, 2, RANDOM())]) AS city,
    'CA' AS state,
    COALESCE(b.zip_code, LPAD((90001 + ABS(RANDOM()) % 6162)::VARCHAR, 5, '0')) AS zip_code,
    UNIFORM(0, 1, RANDOM()) > 0.1 AS is_deposit_enabled,
    TRUE AS is_24_hours,
    ARRAY_CONSTRUCT('English', 'Chinese', 'Spanish') AS languages_supported,
    CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.8 THEN 500 ELSE 1000 END AS daily_withdrawal_limit,
    DATEADD('day', -(1 + (ABS(RANDOM()) % 2555)), CURRENT_DATE()) AS installation_date,
    DATEADD('day', -(1 + (ABS(RANDOM()) % 90)), CURRENT_DATE()) AS last_service_date,
    CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 'MAINTENANCE' ELSE 'ACTIVE' END AS status,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 250)) g
LEFT JOIN (SELECT branch_id, address, city, zip_code FROM BRANCHES ORDER BY RANDOM() LIMIT 150) b
    ON seq4() <= 150;

-- Products already loaded at the beginning

-- ============================================================================
-- Step 5: GENERATE CUSTOMERS (depends on Branches)
-- ============================================================================

-- Generate 50,000 customers with realistic demographics
INSERT INTO CUSTOMERS
WITH name_data AS (
    SELECT 
        ARRAY_CONSTRUCT('James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Joseph', 'Charles', 'Thomas',
                       'Wei', 'Jun', 'Jie', 'Ming', 'Chen', 'Li', 'Yang', 'Zhang', 'Liu', 'Wang') AS first_names_m,
        ARRAY_CONSTRUCT('Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan', 'Jessica', 'Sarah', 'Karen',
                       'Mei', 'Ling', 'Yan', 'Hong', 'Hui', 'Fang', 'Xiao', 'Yun', 'Jing', 'Min') AS first_names_f,
        ARRAY_CONSTRUCT('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
                       'Chen', 'Li', 'Wang', 'Zhang', 'Liu', 'Yang', 'Huang', 'Wu', 'Zhou', 'Xu', 'Lin', 'Ma') AS last_names
),
income_ranges AS (
    SELECT * FROM (VALUES
        ('0-25k', 0.10),
        ('25k-50k', 0.20),
        ('50k-75k', 0.25),
        ('75k-100k', 0.20),
        ('100k-150k', 0.15),
        ('150k-250k', 0.07),
        ('250k+', 0.03)
    ) AS t(range, probability)
)
SELECT
    customer_id,
    customer_type,
    first_name,
    last_name,
    business_name,
    date_of_birth,
    ssn_tin_hash,
    email,
    phone_primary,
    phone_secondary,
    address_line1,
    address_line2,
    city,
    state,
    zip_code,
    country,
    primary_branch_id,
    customer_since,
    preferred_language,
    occupation,
    annual_income_range,
    CASE 
        WHEN annual_income_range = '250k+' THEN '800-850'
        WHEN annual_income_range = '150k-250k' THEN '750-799'
        WHEN annual_income_range = '100k-150k' THEN '700-749'
        WHEN annual_income_range = '75k-100k' THEN '650-699'
        WHEN annual_income_range = '50k-75k' THEN '600-649'
        ELSE '550-599'
    END AS credit_score_range,
    kyc_status,
    CASE 
        WHEN annual_income_range IN ('250k+', '150k-250k') THEN 
            CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.9 THEN 'HIGH' ELSE 'MEDIUM' END
        WHEN annual_income_range IN ('0-25k', '25k-50k') THEN 
            CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'HIGH' ELSE 'MEDIUM' END
        ELSE 'LOW'
    END AS risk_rating,
    is_employee,
    annual_income_range IN ('250k+', '150k-250k') AND UNIFORM(0, 1, RANDOM()) > 0.7 AS is_vip,
    marketing_consent,
    created_at,
    updated_at
FROM (
    SELECT
        'CUST' || LPAD(ROW_NUMBER() OVER (ORDER BY seq4()), 8, '0') AS customer_id,
        customer_type,
        CASE 
            WHEN customer_type = 'Individual' THEN 
                CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.5 
                    THEN first_names_m[UNIFORM(0, 19, RANDOM())]
                    ELSE first_names_f[UNIFORM(0, 19, RANDOM())]
                END
            ELSE NULL
        END AS first_name,
        CASE 
            WHEN customer_type = 'Individual' THEN last_names[UNIFORM(0, 21, RANDOM())]
            ELSE NULL
        END AS last_name,
        CASE 
            WHEN customer_type != 'Individual' THEN 
                ARRAY_CONSTRUCT('Pacific ', 'Golden ', 'Summit ', 'Premier ', 'Dynasty ', 'Jade ', '')[UNIFORM(0, 6, RANDOM())] ||
                ARRAY_CONSTRUCT('Trading', 'Imports', 'Enterprises', 'Holdings', 'Ventures', 'International', 'Group')[UNIFORM(0, 6, RANDOM())] ||
                ARRAY_CONSTRUCT(' LLC', ' Inc', ' Corp', '')[UNIFORM(0, 3, RANDOM())]
            ELSE NULL
        END AS business_name,
        CASE 
            WHEN customer_type = 'Individual' THEN 
                DATEADD('year', -(18 + (ABS(RANDOM()) % 68)), DATEADD('day', -(1 + (ABS(RANDOM()) % 365)), CURRENT_DATE()))
            ELSE NULL
        END AS date_of_birth,
        MD5((100000000 + (ABS(RANDOM()) % 900000000))::VARCHAR) AS ssn_tin_hash,
        CASE 
            WHEN customer_type = 'Individual' THEN
                LOWER(COALESCE(
                    CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.5 
                        THEN first_names_m[UNIFORM(0, 19, RANDOM())]
                        ELSE first_names_f[UNIFORM(0, 19, RANDOM())]
                    END, '') || '.' || 
                    COALESCE(last_names[UNIFORM(0, 21, RANDOM())], LPAD((1 + ABS(RANDOM()) % 9999)::VARCHAR, 4, '0')) || 
                    '@' || ARRAY_CONSTRUCT('gmail.com', 'yahoo.com', 'hotmail.com', 'cathaybank.com')[UNIFORM(0, 3, RANDOM())])
            ELSE 
                LOWER(SPLIT(ARRAY_CONSTRUCT('Pacific ', 'Golden ', 'Summit ', 'Premier ', 'Dynasty ', 'Jade ', '')[UNIFORM(0, 6, RANDOM())] ||
                    ARRAY_CONSTRUCT('Trading', 'Imports', 'Enterprises', 'Holdings', 'Ventures', 'International', 'Group')[UNIFORM(0, 6, RANDOM())], ' ')[0] || 
                    LPAD((1 + ABS(RANDOM()) % 9999)::VARCHAR, 4, '0') || 
                    '@' || ARRAY_CONSTRUCT('gmail.com', 'yahoo.com', 'hotmail.com', 'cathaybank.com')[UNIFORM(0, 3, RANDOM())])
        END AS email,
        '(' || ARRAY_CONSTRUCT('213', '310', '626', '818', '714', '949', '415', '510', '408', '916')[UNIFORM(0, 9, RANDOM())] || 
        ') ' || (200 + ABS(RANDOM()) % 800)::VARCHAR || '-' || (1000 + ABS(RANDOM()) % 9000)::VARCHAR AS phone_primary,
        CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN 
            '(' || ARRAY_CONSTRUCT('213', '310', '626', '818', '714')[UNIFORM(0, 4, RANDOM())] || 
            ') ' || (200 + ABS(RANDOM()) % 800)::VARCHAR || '-' || (1000 + ABS(RANDOM()) % 9000)::VARCHAR
        ELSE NULL END AS phone_secondary,
        (100 + ABS(RANDOM()) % 9900)::VARCHAR || ' ' || 
        ARRAY_CONSTRUCT('Main', 'Oak', 'Elm', 'Park', 'Market', 'Spring', 'Hill', 'Valley')[UNIFORM(0, 7, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('Street', 'Avenue', 'Boulevard', 'Drive', 'Road', 'Lane')[UNIFORM(0, 5, RANDOM())] AS address_line1,
        CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.7 THEN 
            ARRAY_CONSTRUCT('Apt ', 'Suite ', 'Unit ')[UNIFORM(0, 2, RANDOM())] || (1 + ABS(RANDOM()) % 999)::VARCHAR
        ELSE NULL END AS address_line2,
        ARRAY_CONSTRUCT('Los Angeles', 'San Francisco', 'San Diego', 'San Jose', 'Irvine', 
                        'Long Beach', 'Oakland', 'Sacramento', 'Anaheim', 'Riverside')[UNIFORM(0, 9, RANDOM())] AS city,
        'CA' AS state,
        LPAD((90001 + ABS(RANDOM()) % 6162)::VARCHAR, 5, '0') AS zip_code,
        'USA' AS country,
        (SELECT branch_id FROM BRANCHES ORDER BY RANDOM() LIMIT 1) AS primary_branch_id,
        DATEADD('day', -(1 + (ABS(RANDOM()) % 5475)), CURRENT_DATE()) AS customer_since,
        CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'Chinese' ELSE 'English' END AS preferred_language,
        ARRAY_CONSTRUCT('Professional', 'Business Owner', 'Executive', 'Manager', 'Retired', 
                        'Student', 'Healthcare', 'Education', 'Technology', 'Other')[UNIFORM(0, 9, RANDOM())] AS occupation,
        (SELECT range FROM income_ranges ORDER BY RANDOM() * probability DESC LIMIT 1) AS annual_income_range,
        'VERIFIED' AS kyc_status,
        UNIFORM(0, 1, RANDOM()) > 0.98 AS is_employee,
        UNIFORM(0, 1, RANDOM()) > 0.2 AS marketing_consent,
        CURRENT_TIMESTAMP() AS created_at,
        CURRENT_TIMESTAMP() AS updated_at
    FROM (
        SELECT 
            CASE 
                WHEN rnd < 0.90 THEN 'Individual'
                WHEN rnd < 0.98 THEN 'Business'
                ELSE 'Trust'
            END AS customer_type,
            first_names_m,
            first_names_f,
            last_names
        FROM (
            SELECT 
                first_names_m,
                first_names_f,
                last_names,
                UNIFORM(0, 1, RANDOM()) AS rnd
            FROM TABLE(GENERATOR(ROWCOUNT => 50000))
            CROSS JOIN name_data
        ) t
    ) base
);

-- ============================================================================
-- GENERATE ACCOUNTS
-- ============================================================================

-- Generate 120,000 accounts (average 2.4 per customer)
INSERT INTO ACCOUNTS
WITH customer_products AS (
    SELECT 
        c.customer_id,
        c.customer_type,
        c.annual_income_range,
        c.customer_since,
        c.primary_branch_id,
        CASE 
            -- Individuals typically have checking + savings
            WHEN c.customer_type = 'Individual' THEN
                CASE 
                    WHEN c.annual_income_range IN ('250k+', '150k-250k') THEN 2 + (ABS(RANDOM()) % 4)
                    WHEN c.annual_income_range IN ('100k-150k', '75k-100k') THEN 2 + (ABS(RANDOM()) % 3)
                    ELSE 1 + (ABS(RANDOM()) % 3)
                END
            -- Businesses have more accounts
            WHEN c.customer_type = 'Business' THEN 2 + (ABS(RANDOM()) % 5)
            -- Trusts
            ELSE 1 + (ABS(RANDOM()) % 3)
        END AS num_accounts
    FROM CUSTOMERS c
)
SELECT
    account_id,
    account_number,
    customer_id,
    product_id,
    account_type,
    account_subtype,
    account_status,
    opening_date,
    closing_date,
    branch_id,
    current_balance,
    current_balance AS available_balance,
    hold_amount,
    interest_rate,
    last_statement_date,
    last_activity_date,
    overdraft_protection,
    CASE WHEN overdraft_protection THEN 100 + (ABS(RANDOM()) % 901) ELSE NULL END AS overdraft_limit,
    CASE WHEN account_type = 'CD' THEN DATEADD('month', term_months, opening_date) ELSE NULL END AS maturity_date,
    is_primary_account,
    created_at,
    updated_at
FROM (
    SELECT
        'ACC' || LPAD(ROW_NUMBER() OVER (ORDER BY c.customer_id, p.product_id), 10, '0') AS account_id,
        '1234' || LPAD((100000 + ABS(RANDOM()) % 900000)::VARCHAR, 6, '0') || LPAD(ROW_NUMBER() OVER (ORDER BY c.customer_id), 4, '0') AS account_number,
        c.customer_id,
        p.product_id,
        p.product_type AS account_type,
        CASE 
            WHEN c.customer_type = 'Business' THEN 'Business'
            WHEN c.customer_type = 'Trust' THEN 'Trust'
            WHEN p.product_type = 'Checking' AND c.annual_income_range = '0-25k' THEN 'Basic'
            WHEN p.product_type = 'Checking' AND c.annual_income_range IN ('250k+', '150k-250k') THEN 'Premium'
            ELSE 'Personal'
        END AS account_subtype,
        'Active' AS account_status,
        DATEADD('day', ABS(RANDOM()) % GREATEST(DATEDIFF('day', c.customer_since, CURRENT_DATE()), 1), c.customer_since) AS opening_date,
        NULL AS closing_date,
        c.primary_branch_id AS branch_id,
        CASE p.product_type
            WHEN 'Checking' THEN 
                CASE 
                    WHEN c.annual_income_range = '250k+' THEN 10000 + (ABS(RANDOM()) % 240001)
                    WHEN c.annual_income_range = '150k-250k' THEN 5000 + (ABS(RANDOM()) % 95001)
                    WHEN c.annual_income_range = '100k-150k' THEN 2500 + (ABS(RANDOM()) % 47501)
                    WHEN c.annual_income_range = '75k-100k' THEN 1000 + (ABS(RANDOM()) % 24001)
                    WHEN c.annual_income_range = '50k-75k' THEN 500 + (ABS(RANDOM()) % 9501)
                    ELSE 100 + (ABS(RANDOM()) % 4901)
                END
            WHEN 'Savings' THEN 
                CASE 
                    WHEN c.annual_income_range = '250k+' THEN 25000 + (ABS(RANDOM()) % 475001)
                    WHEN c.annual_income_range = '150k-250k' THEN 10000 + (ABS(RANDOM()) % 240001)
                    WHEN c.annual_income_range = '100k-150k' THEN 5000 + (ABS(RANDOM()) % 95001)
                    ELSE 300 + (ABS(RANDOM()) % 24701)
                END
            WHEN 'Money Market' THEN 2500 + (ABS(RANDOM()) % 97501)
            WHEN 'CD' THEN 1000 + (ABS(RANDOM()) % 249001)
            ELSE 0
        END AS current_balance,
        0 AS hold_amount,
        p.interest_rate,
        p.term_months,
        LAST_DAY(DATEADD('month', -1, CURRENT_DATE())) AS last_statement_date,
        DATEADD('day', -(ABS(RANDOM()) % 31), CURRENT_DATE()) AS last_activity_date,
        p.product_type = 'Checking' AND UNIFORM(0, 1, RANDOM()) > 0.6 AS overdraft_protection,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY 
            CASE p.product_type WHEN 'Checking' THEN 1 WHEN 'Savings' THEN 2 ELSE 3 END) = 1 AS is_primary_account,
        CURRENT_TIMESTAMP() AS created_at,
        CURRENT_TIMESTAMP() AS updated_at
    FROM (
    SELECT 
        cp.customer_id,
        cp.customer_type,
        cp.annual_income_range,
        cp.customer_since,
        cp.primary_branch_id,
        g.seq AS account_num
    FROM customer_products cp
    CROSS JOIN (
        SELECT ROW_NUMBER() OVER (ORDER BY seq4()) AS seq 
        FROM TABLE(GENERATOR(ROWCOUNT => 10))  -- Max accounts per customer
    ) g
    WHERE g.seq <= cp.num_accounts
) c
CROSS JOIN (
    SELECT product_id, product_type, interest_rate, term_months 
    FROM PRODUCTS 
    WHERE product_category = 'Deposit'
    ) p
    WHERE 
        -- Ensure customers get appropriate products
        (c.account_num = 1 AND p.product_type = 'Checking') OR
        (c.account_num = 2 AND p.product_type = 'Savings' AND UNIFORM(0, 1, RANDOM()) > 0.2) OR
        (c.account_num > 2 AND p.product_type IN ('Money Market', 'CD') AND UNIFORM(0, 1, RANDOM()) > 0.7) OR
        (c.account_num > 2 AND p.product_type IN ('Checking', 'Savings') AND UNIFORM(0, 1, RANDOM()) > 0.5)
)
LIMIT 120000;

-- ============================================================================
-- GENERATE TRANSACTIONS
-- ============================================================================

-- Generate 5 million transactions over 2 years
INSERT INTO TRANSACTIONS
WITH date_series AS (
    SELECT DATEADD('day', -seq4(), CURRENT_DATE()) AS transaction_date
    FROM TABLE(GENERATOR(ROWCOUNT => 730)) -- 2 years
),
daily_transactions AS (
    SELECT 
        d.transaction_date,
        a.account_id,
        a.account_type,
        a.current_balance,
        CASE 
            WHEN DAYOFWEEK(d.transaction_date) IN (1, 7) THEN ABS(RANDOM()) % 4 -- Weekends (0-3)
            ELSE 1 + (ABS(RANDOM()) % 10) -- Weekdays (1-10)
        END AS num_transactions
    FROM date_series d
    CROSS JOIN (SELECT * FROM ACCOUNTS ORDER BY RANDOM() LIMIT 50000) a -- Active accounts
    WHERE d.transaction_date >= a.opening_date
),
transaction_types AS (
    SELECT * FROM (VALUES
        ('Deposit', 'Branch', 'Cash', 0.10),
        ('Deposit', 'ATM', 'Cash', 0.08),
        ('Deposit', 'Mobile', 'Check', 0.15),
        ('Deposit', 'ACH', 'Direct Deposit', 0.20),
        ('Withdrawal', 'ATM', 'Cash', 0.15),
        ('Withdrawal', 'Branch', 'Cash', 0.05),
        ('Withdrawal', 'Online', 'ACH', 0.10),
        ('Purchase', 'POS', 'Debit Card', 0.25),
        ('Purchase', 'Online', 'Debit Card', 0.10),
        ('Transfer', 'Online', 'Internal', 0.05),
        ('Fee', 'System', 'Monthly Fee', 0.01),
        ('Interest', 'System', 'Credit', 0.01)
    ) AS t(type, category, subcategory, probability)
)
SELECT
    transaction_id,
    account_id,
    transaction_date,
    transaction_timestamp,
    transaction_type,
    transaction_category,
    transaction_subcategory,
    amount,
    balance_after,
    description,
    CASE transaction_type
        WHEN 'Purchase' THEN description
        ELSE NULL
    END AS merchant_name,
    CASE 
        WHEN transaction_type = 'Purchase' AND description = 'Amazon' THEN 'Online Shopping'
        WHEN transaction_type = 'Purchase' AND description IN ('Shell', 'Chevron') THEN 'Gas Station'
        WHEN transaction_type = 'Purchase' AND description IN ('Walmart', 'Target', 'Costco', 'Trader Joes') THEN 'Grocery'
        WHEN transaction_type = 'Purchase' AND description = 'Starbucks' THEN 'Restaurant'
        WHEN transaction_type = 'Purchase' AND description IN ('CVS', 'Walgreens') THEN 'Pharmacy'
        WHEN transaction_type = 'Purchase' THEN 'Retail'
        ELSE NULL
    END AS merchant_category,
    CASE 
        WHEN transaction_category IN ('ATM', 'Branch') THEN 'Cathay Bank ' || transaction_category || ' - ' || 
            ARRAY_CONSTRUCT('Downtown LA', 'Chinatown', 'San Gabriel', 'Irvine')[UNIFORM(0, 3, RANDOM())]
        WHEN transaction_type = 'Purchase' AND description != 'Amazon' THEN 
            description || ' - ' || ARRAY_CONSTRUCT('Los Angeles', 'San Francisco', 'San Diego')[UNIFORM(0, 2, RANDOM())]
        ELSE NULL
    END AS location,
    channel,
    device_id,
    ip_address,
    'REF' || TO_CHAR(transaction_timestamp, 'YYYYMMDDHH24MISS') || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 4, '0') AS reference_number,
    counterparty_account,
    counterparty_bank,
    is_international,
    currency_code,
    exchange_rate,
    status,
    CASE 
        WHEN amount > 5000 THEN UNIFORM(0.1, 0.3, RANDOM())
        WHEN transaction_category = 'Online' AND HOUR(transaction_timestamp) BETWEEN 0 AND 5 THEN UNIFORM(0.2, 0.4, RANDOM())
        ELSE UNIFORM(0.01, 0.1, RANDOM())
    END AS fraud_score,
    created_at
FROM (
    SELECT
        'TXN' || TO_CHAR(dt.transaction_date, 'YYYYMMDD') || LPAD(ROW_NUMBER() OVER (ORDER BY dt.transaction_date, dt.account_id), 8, '0') AS transaction_id,
        dt.account_id,
        dt.transaction_date,
        DATEADD('second', ABS(RANDOM()) % 86400, dt.transaction_date::TIMESTAMP_NTZ) AS transaction_timestamp,
        tt.type AS transaction_type,
        tt.category AS transaction_category,
        tt.subcategory AS transaction_subcategory,
        CASE 
            WHEN tt.type = 'Deposit' THEN
                CASE 
                    WHEN tt.subcategory = 'Direct Deposit' THEN 1000 + (ABS(RANDOM()) % 9001)
                    WHEN tt.subcategory = 'Cash' THEN 20 + (ABS(RANDOM()) % 1981)
                    WHEN tt.subcategory = 'Check' THEN 50 + (ABS(RANDOM()) % 4951)
                    ELSE 10 + (ABS(RANDOM()) % 991)
                END
            WHEN tt.type = 'Withdrawal' THEN
                -1 * CASE 
                    WHEN tt.subcategory = 'Cash' THEN FLOOR((20 + (ABS(RANDOM()) % 481)) / 20) * 20
                    ELSE 10 + (ABS(RANDOM()) % 1991)
                END
            WHEN tt.type = 'Purchase' THEN
                -1 * CASE 
                    WHEN UNIFORM(0, 1, RANDOM()) > 0.8 THEN 100 + (ABS(RANDOM()) % 901)
                    ELSE 5 + (ABS(RANDOM()) % 96)
                END
            WHEN tt.type = 'Transfer' THEN
                CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.5 THEN -1 ELSE 1 END * (50 + (ABS(RANDOM()) % 4951))
            WHEN tt.type = 'Fee' THEN
                -1 * CASE dt.account_type
                    WHEN 'Checking' THEN 5
                    WHEN 'Savings' THEN 3
                    ELSE 0
                END
            WHEN tt.type = 'Interest' THEN
                ROUND(dt.current_balance * 0.0001, 2)
        END AS amount,
        dt.current_balance + SUM(amount) OVER (PARTITION BY dt.account_id ORDER BY transaction_timestamp) AS balance_after,
        CASE tt.type
            WHEN 'Purchase' THEN 
                ARRAY_CONSTRUCT('Walmart', 'Target', 'Amazon', 'Costco', 'Trader Joes', 'Starbucks', 
                              'Shell', 'Chevron', 'CVS', 'Walgreens', 'Home Depot', 'Best Buy')[UNIFORM(0, 11, RANDOM())]
            WHEN 'Deposit' THEN 
                CASE tt.subcategory 
                    WHEN 'Direct Deposit' THEN 'Employer Payroll'
                    ELSE 'Cash/Check Deposit'
                END
            ELSE tt.subcategory || ' Transaction'
        END AS description,
        tt.category AS channel,
        CASE 
            WHEN tt.category = 'Mobile' THEN 'MOB' || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 4, '0')
            WHEN tt.category = 'Online' THEN 'WEB' || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 4, '0')
            WHEN tt.category = 'ATM' THEN 'ATM' || LPAD((1 + ABS(RANDOM()) % 250)::VARCHAR, 5, '0')
            ELSE NULL
        END AS device_id,
        CASE 
            WHEN tt.category IN ('Online', 'Mobile') THEN 
                (1 + ABS(RANDOM()) % 255)::VARCHAR || '.' || (ABS(RANDOM()) % 256)::VARCHAR || '.' || 
                (ABS(RANDOM()) % 256)::VARCHAR || '.' || (ABS(RANDOM()) % 256)::VARCHAR
            ELSE NULL
        END AS ip_address,
        NULL AS counterparty_account,
        CASE 
            WHEN tt.type = 'Transfer' AND UNIFORM(0, 1, RANDOM()) > 0.8 THEN 
                ARRAY_CONSTRUCT('Bank of America', 'Wells Fargo', 'Chase', 'Citibank')[UNIFORM(0, 3, RANDOM())]
            ELSE NULL
        END AS counterparty_bank,
        FALSE AS is_international,
        'USD' AS currency_code,
        NULL AS exchange_rate,
        'COMPLETED' AS status,
        CURRENT_TIMESTAMP() AS created_at
    FROM (
        SELECT 
            dt.*,
            g.seq AS txn_num
        FROM daily_transactions dt
        CROSS JOIN (
            SELECT ROW_NUMBER() OVER (ORDER BY seq4()) AS seq 
            FROM TABLE(GENERATOR(ROWCOUNT => 15))  -- Max transactions per day
        ) g
        WHERE g.seq <= dt.num_transactions
    ) dt
    CROSS JOIN transaction_types tt
    WHERE UNIFORM(0, 1, RANDOM()) <= tt.probability
)
LIMIT 5000000;

-- ============================================================================
-- GENERATE LOANS
-- ============================================================================

-- Generate 30,000 loans  
INSERT INTO LOANS
WITH eligible_customers AS (
    SELECT 
        c.customer_id,
        c.annual_income_range,
        c.credit_score_range,
        c.primary_branch_id,
        CASE 
            WHEN c.credit_score_range >= '750-799' THEN 1 + (ABS(RANDOM()) % 3)
            WHEN c.credit_score_range >= '650-699' THEN ABS(RANDOM()) % 3
            ELSE ABS(RANDOM()) % 2
        END AS num_loans
    FROM CUSTOMERS c
    WHERE c.customer_type IN ('Individual', 'Business')
      AND c.credit_score_range >= '600-649'
    ORDER BY RANDOM()
    LIMIT 20000
),
loan_base AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ec.customer_id, g.seq) AS seq_num,
        ec.customer_id,
        ec.credit_score_range,
        ec.primary_branch_id,
        p.product_id,
        p.product_type,
        p.interest_rate AS base_rate,
        p.term_months
    FROM eligible_customers ec
    CROSS JOIN (
        SELECT ROW_NUMBER() OVER (ORDER BY seq4()) AS seq 
        FROM TABLE(GENERATOR(ROWCOUNT => 5))  -- Max loans per customer
    ) g
    CROSS JOIN (
        SELECT product_id, product_type, interest_rate, term_months 
        FROM PRODUCTS 
        WHERE product_category = 'Loan'
    ) p
    WHERE g.seq <= ec.num_loans
      AND UNIFORM(0, 1, RANDOM()) > 0.3
    LIMIT 30000
),
loan_details AS (
    SELECT 
        'LOAN' || LPAD(seq_num, 8, '0') AS loan_id,
        'LN' || LPAD((100000 + ABS(RANDOM()) % 900000)::VARCHAR, 6, '0') || LPAD(seq_num, 4, '0') AS loan_number,
        customer_id,
        product_id,
        product_type AS loan_type,
        CASE product_type
            WHEN 'Mortgage' THEN ARRAY_CONSTRUCT('Purchase', 'Refinance', 'Cash-Out Refinance')[UNIFORM(0, 2, RANDOM())]
            WHEN 'Auto' THEN ARRAY_CONSTRUCT('New Vehicle', 'Used Vehicle', 'Refinance')[UNIFORM(0, 2, RANDOM())]
            WHEN 'Personal' THEN ARRAY_CONSTRUCT('Debt Consolidation', 'Home Improvement', 'Major Purchase', 'Other')[UNIFORM(0, 3, RANDOM())]
            WHEN 'Business' THEN ARRAY_CONSTRUCT('Working Capital', 'Equipment', 'Expansion', 'Real Estate')[UNIFORM(0, 3, RANDOM())]
            WHEN 'HELOC' THEN 'Home Equity'
        END AS loan_purpose,
        CASE product_type
            WHEN 'Mortgage' THEN FLOOR((200000 + (ABS(RANDOM()) % 1800001)) / 1000) * 1000
            WHEN 'Auto' THEN FLOOR((15000 + (ABS(RANDOM()) % 60001)) / 1000) * 1000
            WHEN 'Personal' THEN FLOOR((5000 + (ABS(RANDOM()) % 45001)) / 1000) * 1000
            WHEN 'Business' THEN FLOOR((25000 + (ABS(RANDOM()) % 475001)) / 5000) * 5000
            WHEN 'HELOC' THEN FLOOR((25000 + (ABS(RANDOM()) % 225001)) / 5000) * 5000
        END AS original_amount,
        base_rate + CASE 
            WHEN credit_score_range = '800-850' THEN -0.005
            WHEN credit_score_range = '750-799' THEN 0
            WHEN credit_score_range = '700-749' THEN 0.005
            WHEN credit_score_range = '650-699' THEN 0.010
            ELSE 0.015
        END AS interest_rate,
        term_months,
        DATEADD('month', -(1 + (ABS(RANDOM()) % (LEAST(term_months, 60) - 1))), CURRENT_DATE()) AS origination_date,
        primary_branch_id,
        credit_score_range
    FROM loan_base
)
SELECT 
    loan_id,
    loan_number,
    customer_id,
    product_id,
    loan_type,
    loan_purpose,
    original_amount,
    GREATEST(0, original_amount - (original_amount / term_months * (ABS(RANDOM()) % FLOOR(term_months * 0.3 + 1)))) AS current_balance,
    interest_rate,
    term_months,
    ROUND((original_amount * (interest_rate/12)) / (1 - POWER(1 + interest_rate/12, -term_months)), 2) AS monthly_payment,
    origination_date,
    DATEADD('month', 1, origination_date) AS first_payment_date,
    DATEADD('month', term_months, origination_date) AS maturity_date,
    CASE 
        WHEN GREATEST(0, original_amount - (original_amount / term_months * (ABS(RANDOM()) % FLOOR(term_months * 0.3 + 1)))) > 0 
        THEN DATEADD('month', 1, LAST_DAY(CURRENT_DATE()))
        ELSE NULL
    END AS next_payment_date,
    CASE 
        WHEN GREATEST(0, original_amount - (original_amount / term_months * (ABS(RANDOM()) % FLOOR(term_months * 0.3 + 1)))) > 0 
        THEN DATEADD('month', -1, CURRENT_DATE())
        ELSE DATEADD('month', term_months, origination_date)
    END AS last_payment_date,
    CASE 
        WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30)
        ELSE 0
    END AS days_past_due,
    CASE 
        WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END > 0 THEN 1 + (ABS(RANDOM()) % 3)
        WHEN UNIFORM(0, 1, RANDOM()) > 0.9 THEN 1
        ELSE 0
    END AS times_30_days_late,
    CASE 
        WHEN CASE 
                WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END > 0 THEN 1 + (ABS(RANDOM()) % 3)
                WHEN UNIFORM(0, 1, RANDOM()) > 0.9 THEN 1
                ELSE 0
             END > 0 AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 1
        ELSE 0
    END AS times_60_days_late,
    CASE 
        WHEN CASE 
                WHEN CASE 
                        WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END > 0 THEN 1 + (ABS(RANDOM()) % 3)
                        WHEN UNIFORM(0, 1, RANDOM()) > 0.9 THEN 1
                        ELSE 0
                     END > 0 AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 1
                ELSE 0
             END > 0 AND UNIFORM(0, 1, RANDOM()) > 0.8 THEN 1
        ELSE 0
    END AS times_90_days_late,
    CASE 
        WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END = 0 
             AND GREATEST(0, original_amount - (original_amount / term_months * (ABS(RANDOM()) % FLOOR(term_months * 0.3 + 1)))) > 0 THEN 'Current'
        WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END > 0 
             AND CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END <= 30 THEN 'Late'
        WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END > 30 
             AND CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END <= 90 THEN 'Delinquent'
        WHEN CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 1 + (ABS(RANDOM()) % 30) ELSE 0 END > 90 THEN 'Default'
        WHEN GREATEST(0, original_amount - (original_amount / term_months * (ABS(RANDOM()) % FLOOR(term_months * 0.3 + 1)))) = 0 THEN 'Paid Off'
        ELSE 'Current'
    END AS loan_status,
    CASE loan_type
        WHEN 'Mortgage' THEN 'Real Estate'
        WHEN 'Auto' THEN 'Vehicle'
        WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
        WHEN 'HELOC' THEN 'Real Estate'
        ELSE 'None'
    END AS collateral_type,
    CASE 
        WHEN CASE loan_type
                WHEN 'Mortgage' THEN 'Real Estate'
                WHEN 'Auto' THEN 'Vehicle'
                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                WHEN 'HELOC' THEN 'Real Estate'
                ELSE 'None'
             END = 'Real Estate' THEN original_amount * (1.2 + (ABS(RANDOM()) % 100) * 0.003)
        WHEN CASE loan_type
                WHEN 'Mortgage' THEN 'Real Estate'
                WHEN 'Auto' THEN 'Vehicle'
                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                WHEN 'HELOC' THEN 'Real Estate'
                ELSE 'None'
             END = 'Vehicle' THEN original_amount * (1.1 + (ABS(RANDOM()) % 100) * 0.002)
        WHEN CASE loan_type
                WHEN 'Mortgage' THEN 'Real Estate'
                WHEN 'Auto' THEN 'Vehicle'
                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                WHEN 'HELOC' THEN 'Real Estate'
                ELSE 'None'
             END = 'Equipment' THEN original_amount * (0.8 + (ABS(RANDOM()) % 100) * 0.004)
        ELSE NULL
    END AS collateral_value,
    CASE 
        WHEN CASE loan_type
                WHEN 'Mortgage' THEN 'Real Estate'
                WHEN 'Auto' THEN 'Vehicle'
                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                WHEN 'HELOC' THEN 'Real Estate'
                ELSE 'None'
             END IN ('Real Estate', 'Vehicle', 'Equipment')
        THEN ROUND((GREATEST(0, original_amount - (original_amount / term_months * (ABS(RANDOM()) % FLOOR(term_months * 0.3 + 1)))) / 
                    NULLIF(CASE 
                        WHEN CASE loan_type
                                WHEN 'Mortgage' THEN 'Real Estate'
                                WHEN 'Auto' THEN 'Vehicle'
                                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                                WHEN 'HELOC' THEN 'Real Estate'
                                ELSE 'None'
                             END = 'Real Estate' THEN original_amount * (1.2 + (ABS(RANDOM()) % 100) * 0.003)
                        WHEN CASE loan_type
                                WHEN 'Mortgage' THEN 'Real Estate'
                                WHEN 'Auto' THEN 'Vehicle'
                                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                                WHEN 'HELOC' THEN 'Real Estate'
                                ELSE 'None'
                             END = 'Vehicle' THEN original_amount * (1.1 + (ABS(RANDOM()) % 100) * 0.002)
                        WHEN CASE loan_type
                                WHEN 'Mortgage' THEN 'Real Estate'
                                WHEN 'Auto' THEN 'Vehicle'
                                WHEN 'Business' THEN ARRAY_CONSTRUCT('Equipment', 'Real Estate', 'None')[UNIFORM(0, 2, RANDOM())]
                                WHEN 'HELOC' THEN 'Real Estate'
                                ELSE 'None'
                             END = 'Equipment' THEN original_amount * (0.8 + (ABS(RANDOM()) % 100) * 0.004)
                        ELSE NULL
                    END, 0)) * 100, 2)
        ELSE NULL
    END AS ltv_ratio,
    primary_branch_id AS branch_id,
    (SELECT employee_id FROM EMPLOYEES WHERE job_title = 'Loan Officer' ORDER BY RANDOM() LIMIT 1) AS loan_officer_id,
    (SELECT employee_id FROM EMPLOYEES WHERE job_title = 'Underwriter' ORDER BY RANDOM() LIMIT 1) AS underwriter_id,
    CURRENT_TIMESTAMP() AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM loan_details;

-- ============================================================================
-- GENERATE CREDIT CARDS
-- ============================================================================

-- Generate 20,000 credit cards
INSERT INTO CREDIT_CARDS
WITH eligible_customers AS (
    SELECT 
        c.customer_id,
        c.annual_income_range,
        c.credit_score_range,
        CASE 
            WHEN c.credit_score_range >= '700-749' AND c.annual_income_range IN ('100k-150k', '150k-250k', '250k+') THEN 2
            WHEN c.credit_score_range >= '650-699' THEN 1
            ELSE 0
        END AS num_cards
    FROM CUSTOMERS c
    WHERE c.customer_type = 'Individual'
      AND c.credit_score_range >= '650-699'
    ORDER BY RANDOM()
    LIMIT 15000
)
SELECT
    card_id,
    account_id,
    customer_id,
    card_number_masked,
    card_type,
    card_tier,
    credit_limit,
    current_balance,
    credit_limit - current_balance AS available_credit,
    credit_limit * 0.3 AS cash_advance_limit,
    interest_rate_purchase,
    interest_rate_cash,
    annual_fee,
    reward_program,
    issue_date,
    expiration_date,
    last_used_date,
    card_status,
    created_at
FROM (
    SELECT
        card_id,
        account_id,
        customer_id,
        card_number_masked,
        card_type,
        card_tier,
        credit_limit,
        ABS(RANDOM()) % FLOOR(credit_limit * 0.7 + 1) AS current_balance,
        interest_rate_purchase,
        interest_rate_cash,
        annual_fee,
        reward_program,
        issue_date,
        expiration_date,
        last_used_date,
        card_status,
        created_at
    FROM (
        SELECT
            'CARD' || LPAD(ROW_NUMBER() OVER (ORDER BY ec.customer_id), 8, '0') AS card_id,
            a.account_id,
            ec.customer_id,
            '****-****-****-' || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 4, '0') AS card_number_masked,
            ARRAY_CONSTRUCT('Visa', 'Mastercard')[UNIFORM(0, 1, RANDOM())] AS card_type,
            CASE 
                WHEN p.product_name LIKE '%Platinum%' THEN 'Platinum'
                WHEN p.product_name LIKE '%Rewards%' THEN 'Rewards'
                ELSE 'Classic'
            END AS card_tier,
            CASE 
                WHEN ec.credit_score_range = '800-850' THEN FLOOR((10000 + (ABS(RANDOM()) % 40001)) / 1000) * 1000
                WHEN ec.credit_score_range = '750-799' THEN FLOOR((5000 + (ABS(RANDOM()) % 20001)) / 1000) * 1000
                WHEN ec.credit_score_range = '700-749' THEN FLOOR((2500 + (ABS(RANDOM()) % 12501)) / 500) * 500
                ELSE FLOOR((1000 + (ABS(RANDOM()) % 6501)) / 500) * 500
            END AS credit_limit,
            p.interest_rate AS interest_rate_purchase,
            p.interest_rate + 0.05 AS interest_rate_cash,
            CASE p.monthly_fee WHEN 0 THEN 0 ELSE p.monthly_fee * 12 END AS annual_fee,
            CASE 
                WHEN p.product_name LIKE '%Platinum%' THEN '2% Cash Back'
                WHEN p.product_name LIKE '%Rewards%' THEN '1.5% Cash Back'
                ELSE '1% Cash Back'
            END AS reward_program,
            DATEADD('month', -(1 + (ABS(RANDOM()) % 60)), CURRENT_DATE()) AS issue_date,
            DATEADD('year', 3, DATEADD('month', -(1 + (ABS(RANDOM()) % 60)), CURRENT_DATE())) AS expiration_date,
            DATEADD('day', -(ABS(RANDOM()) % 31), CURRENT_DATE()) AS last_used_date,
            CASE 
                WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 'Blocked'
                WHEN DATEADD('year', 3, DATEADD('month', -(1 + (ABS(RANDOM()) % 60)), CURRENT_DATE())) < CURRENT_DATE() THEN 'Expired'
                ELSE 'Active'
            END AS card_status,
            CURRENT_TIMESTAMP() AS created_at
        FROM (
            SELECT 
                ec.*,
                g.seq AS card_num
            FROM eligible_customers ec
            CROSS JOIN (
                SELECT ROW_NUMBER() OVER (ORDER BY seq4()) AS seq 
                FROM TABLE(GENERATOR(ROWCOUNT => 3))  -- Max cards per customer
            ) g
            WHERE g.seq <= ec.num_cards AND ec.num_cards > 0
        ) ec
        LEFT JOIN (
            SELECT customer_id, account_id
            FROM ACCOUNTS
            WHERE account_type = 'Checking'
            QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY opening_date) = 1
        ) a ON a.customer_id = ec.customer_id
        CROSS JOIN (
            SELECT product_id, product_name, interest_rate, monthly_fee
            FROM PRODUCTS 
            WHERE product_category = 'Credit'
            ORDER BY RANDOM()
            LIMIT 1
        ) p
    ) inner_subq
) subq
LIMIT 20000;

-- ============================================================================
-- GENERATE DIGITAL BANKING USERS
-- ============================================================================

-- Generate 40,000 digital users (80% of customers)
INSERT INTO DIGITAL_USERS
SELECT
    user_id,
    customer_id,
    username,
    email,
    phone_number,
    enrollment_date,
    last_login_timestamp,
    CASE 
        WHEN DATEDIFF('day', enrollment_date, CURRENT_DATE()) > 365 THEN 50 + (ABS(RANDOM()) % 451)
        WHEN DATEDIFF('day', enrollment_date, CURRENT_DATE()) > 90 THEN 10 + (ABS(RANDOM()) % 91)
        ELSE 1 + (ABS(RANDOM()) % 20)
    END AS login_count,
    preferred_channel,
    preferred_channel IN ('Mobile', 'Both') AS is_mobile_enrolled,
    UNIFORM(0, 1, RANDOM()) > 0.3 AS is_text_banking_enrolled,
    UNIFORM(0, 1, RANDOM()) > 0.4 AS is_paperless,
    TRUE AS security_questions_set,
    UNIFORM(0, 1, RANDOM()) > 0.2 AS two_factor_enabled,
    preferred_channel IN ('Mobile', 'Both') AND UNIFORM(0, 1, RANDOM()) > 0.5 AS biometric_enabled,
    'ACTIVE' AS status,
    CURRENT_TIMESTAMP() AS created_at
FROM (
    SELECT
        'DU' || LPAD(ROW_NUMBER() OVER (ORDER BY c.customer_id), 8, '0') AS user_id,
        c.customer_id,
        LOWER(COALESCE(c.first_name, SPLIT(c.business_name, ' ')[0])) || 
        LPAD((100 + ABS(RANDOM()) % 9900)::VARCHAR, 4, '0') AS username,
        c.email,
        c.phone_primary AS phone_number,
        DATEADD('day', ABS(RANDOM()) % GREATEST(DATEDIFF('day', c.customer_since, CURRENT_DATE()), 1), c.customer_since) AS enrollment_date,
        DATEADD('hour', -(ABS(RANDOM()) % 721), CURRENT_TIMESTAMP()) AS last_login_timestamp,
        CASE 
            WHEN YEAR(c.date_of_birth) > 1990 THEN 'Mobile'
            WHEN YEAR(c.date_of_birth) > 1980 THEN 'Both'
            ELSE 'Web'
        END AS preferred_channel
    FROM CUSTOMERS c
    WHERE UNIFORM(0, 1, RANDOM()) > 0.2  -- 80% of customers
    ORDER BY c.customer_id
    LIMIT 40000
);

-- ============================================================================
-- GENERATE CUSTOMER SEGMENTS
-- ============================================================================

-- Segment customers based on behavior and demographics
INSERT INTO CUSTOMER_SEGMENTS
WITH segment_rules AS (
    SELECT 
        c.customer_id,
        c.annual_income_range,
        c.customer_type,
        COUNT(DISTINCT a.account_id) AS num_accounts,
        SUM(a.current_balance) AS total_balance,
        COUNT(DISTINCT l.loan_id) AS num_loans,
        COUNT(DISTINCT cc.card_id) AS num_cards
    FROM CUSTOMERS c
    LEFT JOIN ACCOUNTS a ON c.customer_id = a.customer_id
    LEFT JOIN LOANS l ON c.customer_id = l.customer_id
    LEFT JOIN CREDIT_CARDS cc ON c.customer_id = cc.customer_id
    GROUP BY 1, 2, 3
)
SELECT
    customer_id,
    'Value' AS segment_type,
    CASE 
        WHEN total_balance > 250000 OR annual_income_range = '250k+' THEN 'High Net Worth'
        WHEN total_balance > 100000 OR annual_income_range IN ('150k-250k', '100k-150k') THEN 'Mass Affluent'
        WHEN total_balance > 25000 THEN 'Core'
        ELSE 'Basic'
    END AS segment_name,
    segment_name AS segment_value,
    CURRENT_DATE() AS effective_date,
    NULL AS expiration_date,
    0.85 AS confidence_score,
    CURRENT_TIMESTAMP() AS created_at
FROM segment_rules
UNION ALL
SELECT
    customer_id,
    'Behavioral' AS segment_type,
    CASE 
        WHEN num_accounts >= 4 AND num_loans >= 1 AND num_cards >= 1 THEN 'Full Relationship'
        WHEN num_accounts >= 2 AND (num_loans >= 1 OR num_cards >= 1) THEN 'Growing Relationship'
        WHEN num_accounts = 1 THEN 'Single Product'
        ELSE 'New Customer'
    END AS segment_name,
    segment_name AS segment_value,
    CURRENT_DATE() AS effective_date,
    NULL AS expiration_date,
    0.90 AS confidence_score,
    CURRENT_TIMESTAMP() AS created_at
FROM segment_rules;

-- ============================================================================
-- GENERATE SERVICE REQUESTS
-- ============================================================================

-- Generate 100,000 service requests over the past year
INSERT INTO SERVICE_REQUESTS
WITH request_types AS (
    SELECT * FROM (VALUES
        ('Account Service', 'Address Change', 'Low'),
        ('Account Service', 'Statement Request', 'Low'),
        ('Account Service', 'Account Closure', 'Medium'),
        ('Card Service', 'Lost/Stolen Card', 'High'),
        ('Card Service', 'Dispute Transaction', 'High'),
        ('Card Service', 'Credit Limit Increase', 'Medium'),
        ('Loan Service', 'Payment Arrangement', 'High'),
        ('Loan Service', 'Payoff Quote', 'Low'),
        ('Technical Support', 'Online Banking Issue', 'Medium'),
        ('Technical Support', 'Mobile App Issue', 'Medium'),
        ('General Inquiry', 'Account Balance', 'Low'),
        ('General Inquiry', 'Product Information', 'Low')
    ) AS t(request_category, request_type, priority)
)
SELECT
    'SR' || LPAD(ROW_NUMBER() OVER (ORDER BY request_date, c.customer_id), 10, '0') AS request_id,
    c.customer_id,
    rt.request_category,
    rt.request_type,
    ARRAY_CONSTRUCT('Phone', 'Online', 'Mobile', 'Branch', 'Email')[UNIFORM(0, 4, RANDOM())] AS channel,
    rt.priority,
    CASE 
        WHEN request_date = CURRENT_DATE() AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'Open'
        WHEN DATEDIFF('day', request_date, CURRENT_DATE()) > 7 THEN 'Closed'
        WHEN rt.priority = 'High' AND UNIFORM(0, 1, RANDOM()) > 0.1 THEN 'Resolved'
        WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN 'Resolved'
        ELSE 'Open'
    END AS status,
    CASE WHEN ARRAY_CONSTRUCT('Phone', 'Online', 'Mobile', 'Branch', 'Email')[UNIFORM(0, 4, RANDOM())] = 'Branch' THEN 
        (SELECT branch_id FROM BRANCHES ORDER BY RANDOM() LIMIT 1)
    ELSE NULL END AS branch_id,
    (SELECT employee_id FROM EMPLOYEES WHERE job_title = 'Customer Service Representative' ORDER BY RANDOM() LIMIT 1) AS assigned_to,
    'Customer requested ' || LOWER(rt.request_category) AS description,
    CASE WHEN CASE 
        WHEN request_date = CURRENT_DATE() AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'Open'
        WHEN DATEDIFF('day', request_date, CURRENT_DATE()) > 7 THEN 'Closed'
        WHEN rt.priority = 'High' AND UNIFORM(0, 1, RANDOM()) > 0.1 THEN 'Resolved'
        WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN 'Resolved'
        ELSE 'Open'
    END IN ('Resolved', 'Closed') THEN 
        'Request completed successfully. ' || 
        CASE rt.request_category
            WHEN 'Address Change' THEN 'Address updated in system.'
            WHEN 'Lost/Stolen Card' THEN 'Card blocked and replacement issued.'
            WHEN 'Dispute Transaction' THEN 'Transaction reversed pending investigation.'
            ELSE 'Customer satisfied with resolution.'
        END
    ELSE NULL END AS resolution_notes,
    request_date AS created_date,
    request_date::TIMESTAMP_NTZ AS created_timestamp,
    CASE WHEN CASE 
        WHEN request_date = CURRENT_DATE() AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'Open'
        WHEN DATEDIFF('day', request_date, CURRENT_DATE()) > 7 THEN 'Closed'
        WHEN rt.priority = 'High' AND UNIFORM(0, 1, RANDOM()) > 0.1 THEN 'Resolved'
        WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN 'Resolved'
        ELSE 'Open'
    END = 'Resolved' THEN 
        DATEADD('hour', 1 + (ABS(RANDOM()) % 72), request_date::TIMESTAMP_NTZ)
    WHEN CASE 
        WHEN request_date = CURRENT_DATE() AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'Open'
        WHEN DATEDIFF('day', request_date, CURRENT_DATE()) > 7 THEN 'Closed'
        WHEN rt.priority = 'High' AND UNIFORM(0, 1, RANDOM()) > 0.1 THEN 'Resolved'
        WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN 'Resolved'
        ELSE 'Open'
    END = 'Closed' THEN 
        DATEADD('hour', 24 + (ABS(RANDOM()) % 145), request_date::TIMESTAMP_NTZ)
    ELSE NULL END AS resolved_timestamp,
    CASE WHEN CASE 
        WHEN request_date = CURRENT_DATE() AND UNIFORM(0, 1, RANDOM()) > 0.7 THEN 'Open'
        WHEN DATEDIFF('day', request_date, CURRENT_DATE()) > 7 THEN 'Closed'
        WHEN rt.priority = 'High' AND UNIFORM(0, 1, RANDOM()) > 0.1 THEN 'Resolved'
        WHEN UNIFORM(0, 1, RANDOM()) > 0.3 THEN 'Resolved'
        ELSE 'Open'
    END IN ('Resolved', 'Closed') AND UNIFORM(0, 1, RANDOM()) > 0.3 THEN 
        1 + (ABS(RANDOM()) % 5)
    ELSE NULL END AS satisfaction_score,
    CURRENT_TIMESTAMP() AS created_at
FROM (
    SELECT 
        c.customer_id,
        DATEADD('day', -(ABS(RANDOM()) % 366), CURRENT_DATE()) AS request_date
    FROM CUSTOMERS c
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2))  -- Average 2 requests per customer
    WHERE UNIFORM(0, 1, RANDOM()) > 0.5  -- 50% chance
) c
CROSS JOIN request_types rt
WHERE UNIFORM(0, 1, RANDOM()) > 0.6  -- 40% chance for each combination
LIMIT 100000;

-- ============================================================================
-- GENERATE MARKETING CAMPAIGNS
-- ============================================================================

-- Generate marketing campaigns
INSERT INTO MARKETING_CAMPAIGNS
SELECT
    'CAMP' || LPAD(ROW_NUMBER() OVER (ORDER BY seq4()), 4, '0') AS campaign_id,
    ARRAY_CONSTRUCT(
        'Summer Savings Promotion',
        'Credit Card Welcome Offer',
        'Mortgage Rate Special',
        'Small Business Week',
        'Holiday Cash Back',
        'New Year Financial Wellness',
        'Auto Loan Spring Event',
        'CD Rate Promotion',
        'Digital Banking Adoption',
        'Refer a Friend Program'
    )[UNIFORM(0, 9, RANDOM())] AS campaign_name,
    ARRAY_CONSTRUCT('Email', 'Direct Mail', 'Digital', 'Branch')[UNIFORM(0, 3, RANDOM())] AS campaign_type,
    (SELECT product_id FROM PRODUCTS ORDER BY RANDOM() LIMIT 1) AS product_id,
    ARRAY_CONSTRUCT('High Net Worth', 'Mass Affluent', 'Core', 'Small Business', 'All Customers')[UNIFORM(0, 4, RANDOM())] AS target_segment,
    DATEADD('month', -(ABS(RANDOM()) % 13), CURRENT_DATE()) AS start_date,
    DATEADD('month', 1, start_date) AS end_date,
    FLOOR((5000 + (ABS(RANDOM()) % 45001)) / 1000) * 1000 AS budget,
    ROUND(2.0 + (ABS(RANDOM()) % 100) * 0.08, 2) AS expected_response_rate,
    ROUND((2.0 + (ABS(RANDOM()) % 100) * 0.08) * (0.8 + (ABS(RANDOM()) % 100) * 0.004), 2) AS actual_response_rate,
    CASE 
        WHEN end_date < CURRENT_DATE() THEN 'Completed'
        WHEN start_date > CURRENT_DATE() THEN 'Planned'
        ELSE 'Active'
    END AS status,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 50));

-- Generate campaign responses (10% response rate)
INSERT INTO CAMPAIGN_RESPONSES
SELECT 
    response_id,
    campaign_id,
    customer_id,
    response_date,
    response_type,
    converted AS conversion_flag,
    CASE 
        WHEN converted THEN FLOOR(100 + (ABS(RANDOM()) % 9901))
        ELSE NULL
    END AS conversion_amount,
    created_at
FROM (
    SELECT 
        'RESP' || LPAD(ROW_NUMBER() OVER (ORDER BY c.customer_id, m.campaign_id), 10, '0') AS response_id,
        m.campaign_id,
        c.customer_id,
        DATEADD('day', 1 + (ABS(RANDOM()) % 30), m.start_date) AS response_date,
        ARRAY_CONSTRUCT('Click', 'Call', 'Visit Branch', 'Online Application')[UNIFORM(0, 3, RANDOM())] AS response_type,
        CASE 
            WHEN UNIFORM(0, 1, RANDOM()) > 0.7 THEN TRUE
            ELSE FALSE
        END AS converted,
        CURRENT_TIMESTAMP() AS created_at
    FROM MARKETING_CAMPAIGNS m
    CROSS JOIN (
        SELECT customer_id 
        FROM CUSTOMERS 
        WHERE UNIFORM(0, 1, RANDOM()) > 0.9  -- 10% of customers
        LIMIT 10000
    ) c
    WHERE m.status = 'Completed'
      AND UNIFORM(0, 1, RANDOM()) > 0.5
);

-- ============================================================================
-- ADD PERFORMANCE OPTIMIZATIONS
-- ============================================================================

-- Add clustering keys for better query performance
ALTER TABLE TRANSACTIONS CLUSTER BY (account_id, transaction_date);
ALTER TABLE ACCOUNTS CLUSTER BY (customer_id);
ALTER TABLE LOANS CLUSTER BY (customer_id);
ALTER TABLE CREDIT_CARDS CLUSTER BY (customer_id);
ALTER TABLE DIGITAL_SESSIONS CLUSTER BY (user_id, session_start);

-- ============================================================================
-- VERIFY DATA GENERATION
-- ============================================================================

-- Display summary of generated data
SELECT 'Data Generation Summary' AS report_section, '' AS details
UNION ALL
SELECT '========================', ''
UNION ALL
SELECT 'Customers', COUNT(*)::STRING || ' records' FROM CUSTOMERS
UNION ALL
SELECT 'Accounts', COUNT(*)::STRING || ' records' FROM ACCOUNTS
UNION ALL
SELECT 'Transactions', COUNT(*)::STRING || ' records' FROM TRANSACTIONS
UNION ALL
SELECT 'Loans', COUNT(*)::STRING || ' records' FROM LOANS
UNION ALL
SELECT 'Credit Cards', COUNT(*)::STRING || ' records' FROM CREDIT_CARDS
UNION ALL
SELECT 'Digital Users', COUNT(*)::STRING || ' records' FROM DIGITAL_USERS
UNION ALL
SELECT 'Service Requests', COUNT(*)::STRING || ' records' FROM SERVICE_REQUESTS
UNION ALL
SELECT 'Branches', COUNT(*)::STRING || ' records' FROM BRANCHES
UNION ALL
SELECT 'ATMs', COUNT(*)::STRING || ' records' FROM ATMS
UNION ALL
SELECT 'Employees', COUNT(*)::STRING || ' records' FROM EMPLOYEES
UNION ALL
SELECT '', ''
UNION ALL
SELECT 'Cathay Bank synthetic data generation completed successfully!', CURRENT_TIMESTAMP()::STRING;

-- ============================================================================
-- ADDITIONAL TABLE INSERTS (Previously Missing)
-- ============================================================================

-- ============================================================================
-- ACCOUNT_RELATIONSHIPS
-- ============================================================================

INSERT INTO ACCOUNT_RELATIONSHIPS
SELECT
    a.account_id,
    a.customer_id,
    'Primary' AS relationship_type,
    100.00 AS ownership_percentage,
    TRUE AS signing_authority,
    a.opening_date AS effective_date,
    NULL AS end_date,
    CURRENT_TIMESTAMP() AS created_at
FROM ACCOUNTS a;

-- Add some joint account relationships (10% of accounts)
INSERT INTO ACCOUNT_RELATIONSHIPS
SELECT
    a.account_id,
    c.customer_id,
    'Joint' AS relationship_type,
    50.00 AS ownership_percentage,
    TRUE AS signing_authority,
    a.opening_date AS effective_date,
    NULL AS end_date,
    CURRENT_TIMESTAMP() AS created_at
FROM ACCOUNTS a
CROSS JOIN (
    SELECT customer_id 
    FROM CUSTOMERS 
    ORDER BY RANDOM() 
    LIMIT 100
) c
WHERE c.customer_id != a.customer_id
  AND UNIFORM(0, 1, RANDOM()) > 0.9  -- 10% of accounts
LIMIT 12000;

-- ============================================================================
-- CARD_TRANSACTIONS (subset of TRANSACTIONS)
-- ============================================================================

INSERT INTO CARD_TRANSACTIONS
SELECT
    'CTXN' || LPAD(ROW_NUMBER() OVER (ORDER BY t.transaction_id), 12, '0') AS card_transaction_id,
    t.transaction_id,
    cc.card_id,
    cc.card_number_masked,
    'MERCH' || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 6, '0') AS merchant_id,
    CASE 
        WHEN t.merchant_category = 'Grocery' THEN '5411'
        WHEN t.merchant_category = 'Gas Station' THEN '5542'
        WHEN t.merchant_category = 'Restaurant' THEN '5812'
        WHEN t.merchant_category = 'Pharmacy' THEN '5912'
        WHEN t.merchant_category = 'Retail' THEN '5999'
        ELSE '0000'
    END AS mcc_code,
    'AUTH' || LPAD((100000 + ABS(RANDOM()) % 900000)::VARCHAR, 6, '0') AS authorization_code,
    ARRAY_CONSTRUCT('Chip', 'Contactless', 'Swipe', 'Manual')[UNIFORM(0, 3, RANDOM())] AS pos_entry_mode,
    UNIFORM(0, 1, RANDOM()) > 0.2 AS is_chip_transaction,
    UNIFORM(0, 1, RANDOM()) > 0.6 AS is_contactless,
    CURRENT_TIMESTAMP() AS created_at
FROM TRANSACTIONS t
JOIN CREDIT_CARDS cc ON cc.account_id = t.account_id
WHERE t.transaction_type = 'Purchase'
  AND UNIFORM(0, 1, RANDOM()) > 0.3  -- 70% of purchase transactions are card transactions
LIMIT 500000;

-- ============================================================================
-- DIGITAL_SESSIONS
-- ============================================================================

INSERT INTO DIGITAL_SESSIONS
SELECT
    'SESS' || LPAD(ROW_NUMBER() OVER (ORDER BY session_start), 12, '0') AS session_id,
    du.user_id,
    CASE 
        WHEN du.preferred_channel = 'Mobile' THEN 'Mobile App'
        WHEN du.preferred_channel = 'Both' THEN ARRAY_CONSTRUCT('Web', 'Mobile App', 'Mobile Web')[UNIFORM(0, 2, RANDOM())]
        ELSE 'Web'
    END AS channel,
    CASE 
        WHEN du.preferred_channel = 'Mobile' THEN ARRAY_CONSTRUCT('iPhone', 'Android Phone', 'iPad', 'Android Tablet')[UNIFORM(0, 3, RANDOM())]
        ELSE ARRAY_CONSTRUCT('Desktop', 'Laptop', 'Tablet')[UNIFORM(0, 2, RANDOM())]
    END AS device_type,
    CASE 
        WHEN du.preferred_channel = 'Mobile' THEN 'MOB' || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 4, '0')
        ELSE 'WEB' || LPAD((1000 + ABS(RANDOM()) % 9000)::VARCHAR, 4, '0')
    END AS device_id,
    (1 + ABS(RANDOM()) % 255)::VARCHAR || '.' || (ABS(RANDOM()) % 256)::VARCHAR || '.' || 
    (ABS(RANDOM()) % 256)::VARCHAR || '.' || (ABS(RANDOM()) % 256)::VARCHAR AS ip_address,
    ARRAY_CONSTRUCT('Los Angeles', 'San Francisco', 'San Diego', 'Irvine', 'Sacramento')[UNIFORM(0, 4, RANDOM())] AS location_city,
    'CA' AS location_state,
    session_start,
    DATEADD('second', 60 + (ABS(RANDOM()) % 3540), session_start) AS session_end,
    60 + (ABS(RANDOM()) % 3540) AS duration_seconds,
    1 + (ABS(RANDOM()) % 20) AS pages_viewed,
    ARRAY_CONSTRUCT(
        'Login',
        ARRAY_CONSTRUCT('Check Balance', 'View Transactions', 'Transfer Funds', 'Pay Bill', 'View Statements')[UNIFORM(0, 4, RANDOM())],
        ARRAY_CONSTRUCT('Account Summary', 'Transaction History', 'Profile Settings')[UNIFORM(0, 2, RANDOM())]
    ) AS actions_performed,
    CURRENT_TIMESTAMP() AS created_at
FROM (
    SELECT 
        du.user_id,
        du.preferred_channel,
        DATEADD('second', ABS(RANDOM()) % 86400, 
            DATEADD('day', -(ABS(RANDOM()) % 90), CURRENT_DATE())::TIMESTAMP_NTZ
        ) AS session_start
    FROM DIGITAL_USERS du
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 10))  -- 10 sessions per user on average
    WHERE UNIFORM(0, 1, RANDOM()) > 0.3  -- 70% chance of session
) du
LIMIT 500000;

-- ============================================================================
-- LOAN_PAYMENTS
-- ============================================================================

INSERT INTO LOAN_PAYMENTS
SELECT
    payment_id,
    loan_id,
    payment_date,
    payment_amount,
    payment_amount - interest_amount AS principal_amount,
    interest_amount,
    escrow_amount,
    late_fee_amount,
    payment_method,
    payment_status,
    created_at
FROM (
    SELECT
        'PMT' || LPAD(ROW_NUMBER() OVER (ORDER BY l.loan_id, payment_seq), 12, '0') AS payment_id,
        l.loan_id,
        DATEADD('month', payment_seq, l.origination_date) AS payment_date,
        l.monthly_payment AS payment_amount,
        ROUND((l.current_balance / l.term_months) * (l.interest_rate / 12), 2) AS interest_amount,
        CASE WHEN l.loan_type = 'Mortgage' THEN ROUND(l.monthly_payment * 0.15, 2) ELSE 0 END AS escrow_amount,
        CASE WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 25.00 ELSE 0 END AS late_fee_amount,
        ARRAY_CONSTRUCT('ACH', 'Check', 'Online', 'Auto-Pay')[UNIFORM(0, 3, RANDOM())] AS payment_method,
        CASE 
            WHEN UNIFORM(0, 1, RANDOM()) > 0.98 THEN 'Failed'
            WHEN UNIFORM(0, 1, RANDOM()) > 0.95 THEN 'Pending'
            ELSE 'Completed'
        END AS payment_status,
        CURRENT_TIMESTAMP() AS created_at,
        payment_seq
    FROM LOANS l
    CROSS JOIN (
        SELECT ROW_NUMBER() OVER (ORDER BY seq4()) - 1 AS payment_seq
        FROM TABLE(GENERATOR(ROWCOUNT => 60))
    ) g
    WHERE payment_seq <= DATEDIFF('month', l.origination_date, CURRENT_DATE())
      AND DATEADD('month', payment_seq, l.origination_date) <= CURRENT_DATE()
      AND l.loan_status IN ('Current', 'Late', 'Paid Off')
)
WHERE payment_date >= (SELECT MIN(origination_date) FROM LOANS)
LIMIT 500000;

-- ============================================================================
-- DATA VALIDATION QUERIES
-- ============================================================================

-- Validate no NULL values in critical fields
SELECT 'Data Validation Results' AS check_type, '' AS details
UNION ALL
SELECT 'NULL Check - Branches', 
    'Manager IDs: ' || COUNT(*) || ' records' 
FROM BRANCHES WHERE manager_employee_id IS NULL
UNION ALL
SELECT 'NULL Check - Accounts',
    'Linked to customers: ' || COUNT(*) || ' records' 
FROM ACCOUNTS WHERE customer_id NOT IN (SELECT customer_id FROM CUSTOMERS)
UNION ALL
SELECT 'NULL Check - Transactions',
    'Linked to accounts: ' || COUNT(*) || ' records' 
FROM TRANSACTIONS WHERE account_id NOT IN (SELECT account_id FROM ACCOUNTS)
UNION ALL
SELECT 'Employee Reference Check',
    'Branches with valid managers: ' || COUNT(*) || ' records' 
FROM BRANCHES WHERE manager_employee_id IN (SELECT employee_id FROM EMPLOYEES)
UNION ALL
SELECT 'Additional Tables Check', ''
UNION ALL
SELECT 'ACCOUNT_RELATIONSHIPS', COUNT(*)::STRING || ' records' FROM ACCOUNT_RELATIONSHIPS
UNION ALL
SELECT 'CARD_TRANSACTIONS', COUNT(*)::STRING || ' records' FROM CARD_TRANSACTIONS
UNION ALL
SELECT 'DIGITAL_SESSIONS', COUNT(*)::STRING || ' records' FROM DIGITAL_SESSIONS
UNION ALL
SELECT 'LOAN_PAYMENTS', COUNT(*)::STRING || ' records' FROM LOAN_PAYMENTS;