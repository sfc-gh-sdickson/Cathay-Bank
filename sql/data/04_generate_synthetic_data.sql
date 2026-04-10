/*=============================================================================
  CATHAY BANK INTELLIGENCE AGENT
  File: 04_generate_synthetic_data.sql
  Description: Generate synthetic banking data for all tables
  Execution Order: 4 of 10
=============================================================================*/

USE DATABASE CATHAY_BANK_DB;
USE SCHEMA RAW;
USE WAREHOUSE CATHAY_BANK_WH;

INSERT INTO BRANCHES (BRANCH_NAME, BRANCH_CODE, ADDRESS_LINE1, CITY, STATE, ZIP_CODE, COUNTRY, PHONE, MANAGER_NAME, REGION, OPENED_DATE, IS_ACTIVE)
VALUES
('Los Angeles Chinatown HQ', 'LA001', '777 N Broadway', 'Los Angeles', 'CA', '90012', 'US', '213-625-2900', 'Michael Chen', 'Southern California', '1962-04-16', TRUE),
('Monterey Park', 'LA002', '500 N Atlantic Blvd', 'Monterey Park', 'CA', '91754', 'US', '626-282-6888', 'Sarah Wong', 'Southern California', '1975-03-01', TRUE),
('San Gabriel', 'LA003', '300 W Valley Blvd', 'San Gabriel', 'CA', '91776', 'US', '626-308-1233', 'David Liu', 'Southern California', '1980-06-15', TRUE),
('Arcadia', 'LA004', '1 E Duarte Rd', 'Arcadia', 'CA', '91006', 'US', '626-445-8899', 'Jennifer Huang', 'Southern California', '1985-09-20', TRUE),
('Rowland Heights', 'LA005', '18425 Colima Rd', 'Rowland Heights', 'CA', '91748', 'US', '626-964-8838', 'Robert Chang', 'Southern California', '1990-01-10', TRUE),
('Irvine', 'OC001', '4250 Barranca Pkwy', 'Irvine', 'CA', '92604', 'US', '949-552-8868', 'Grace Lee', 'Southern California', '1995-04-05', TRUE),
('San Francisco Chinatown', 'SF001', '838 Grant Ave', 'San Francisco', 'CA', '94108', 'US', '415-982-3838', 'Kevin Tam', 'Northern California', '1988-11-01', TRUE),
('Cupertino', 'SF002', '10745 S De Anza Blvd', 'Cupertino', 'CA', '95014', 'US', '408-996-8838', 'Linda Wu', 'Northern California', '1998-07-15', TRUE),
('Milpitas', 'SF003', '168 Barber Ln', 'Milpitas', 'CA', '95035', 'US', '408-942-8838', 'Peter Lau', 'Northern California', '2002-03-20', TRUE),
('Flushing', 'NY001', '135-11 Roosevelt Ave', 'Flushing', 'NY', '11354', 'US', '718-886-8838', 'Amy Zhang', 'New York', '1999-08-01', TRUE),
('Manhattan Chinatown', 'NY002', '45 Bowery', 'New York', 'NY', '10002', 'US', '212-966-8838', 'Henry Chow', 'New York', '2001-05-15', TRUE),
('Brooklyn', 'NY003', '5923 8th Ave', 'Brooklyn', 'NY', '11220', 'US', '718-492-8838', 'Wendy Tsai', 'New York', '2005-02-01', TRUE),
('Houston Bellaire', 'TX001', '9788 Bellaire Blvd', 'Houston', 'TX', '77036', 'US', '713-271-8838', 'James Ng', 'Texas', '1999-10-01', TRUE),
('Plano', 'TX002', '3945 Legacy Dr', 'Plano', 'TX', '75023', 'US', '972-312-8838', 'Michelle Hsu', 'Texas', '2008-06-01', TRUE),
('Bellevue', 'WA001', '1515 145th Pl SE', 'Bellevue', 'WA', '98007', 'US', '425-562-8838', 'Tony Lin', 'Pacific Northwest', '2000-09-15', TRUE),
('Boston Quincy', 'MA001', '236 Quincy Ave', 'Quincy', 'MA', '02169', 'US', '617-471-8838', 'Christina Fung', 'New England', '2003-04-01', TRUE),
('Chicago Chinatown', 'IL001', '2216 S Wentworth Ave', 'Chicago', 'IL', '60616', 'US', '312-225-8838', 'Edward Yee', 'Midwest', '2006-01-15', TRUE),
('Edison', 'NJ001', '1665 Oak Tree Rd', 'Edison', 'NJ', '08820', 'US', '732-549-8838', 'Sophia Kim', 'New Jersey', '2007-03-01', TRUE),
('Las Vegas', 'NV001', '5348 Spring Mountain Rd', 'Las Vegas', 'NV', '89146', 'US', '702-364-8838', 'Raymond Ho', 'Nevada', '2013-08-01', TRUE),
('Rockville', 'MD001', '255 N Washington St', 'Rockville', 'MD', '20850', 'US', '301-424-8838', 'Nancy Lim', 'Mid-Atlantic', '2015-02-15', TRUE);

INSERT INTO PRODUCTS (PRODUCT_NAME, PRODUCT_CATEGORY, PRODUCT_TYPE, DESCRIPTION, INTEREST_RATE_MIN, INTEREST_RATE_MAX, MIN_BALANCE, MONTHLY_FEE, IS_ACTIVE, EFFECTIVE_DATE)
VALUES
('Cathay Checking', 'Deposits', 'Checking', 'Standard checking account with online and mobile banking access, no minimum balance requirement', 0, 0, 0, 0, TRUE, '2020-01-01'),
('Cathay Premium Checking', 'Deposits', 'Checking', 'Premium checking with interest earnings and waived fees with $10,000 minimum daily balance', 0.01, 0.05, 10000, 15, TRUE, '2020-01-01'),
('Cathay Savings', 'Deposits', 'Savings', 'Traditional savings account with competitive interest rates and easy access to funds', 0.10, 0.50, 300, 5, TRUE, '2020-01-01'),
('Cathay Money Market', 'Deposits', 'Money Market', 'Higher yield money market account with tiered interest rates based on balance', 0.50, 2.50, 2500, 12, TRUE, '2020-01-01'),
('Cathay CD 12-Month', 'Deposits', 'Certificate of Deposit', 'Fixed-rate 12-month certificate of deposit with guaranteed returns', 3.00, 4.50, 1000, 0, TRUE, '2023-01-01'),
('Cathay CD 24-Month', 'Deposits', 'Certificate of Deposit', 'Fixed-rate 24-month certificate of deposit with higher yields for longer term', 3.50, 5.00, 1000, 0, TRUE, '2023-01-01'),
('Cathay Home Mortgage', 'Lending', 'Mortgage', 'Residential mortgage loans for home purchase with competitive rates and flexible terms', 5.50, 7.50, NULL, NULL, TRUE, '2020-01-01'),
('Cathay Home Equity', 'Lending', 'Home Equity', 'Home equity line of credit for homeowners to access their home equity', 7.00, 9.00, NULL, NULL, TRUE, '2020-01-01'),
('Cathay Auto Loan', 'Lending', 'Auto Loan', 'Financing for new and used vehicle purchases with competitive rates', 4.50, 8.00, NULL, NULL, TRUE, '2020-01-01'),
('Cathay Personal Loan', 'Lending', 'Personal Loan', 'Unsecured personal loan for various purposes including debt consolidation', 6.50, 12.00, NULL, NULL, TRUE, '2020-01-01'),
('Cathay Commercial Mortgage', 'Lending', 'Commercial Mortgage', 'Commercial real estate loans for business property acquisition or refinancing', 5.75, 8.50, NULL, NULL, TRUE, '2020-01-01'),
('Cathay SBA Loan', 'Lending', 'SBA Loan', 'Small Business Administration backed loans for qualified small businesses', 5.00, 8.00, NULL, NULL, TRUE, '2020-01-01'),
('Cathay Business Line of Credit', 'Lending', 'Business LOC', 'Revolving credit line for business working capital needs', 6.00, 10.00, NULL, NULL, TRUE, '2020-01-01'),
('Cathay Construction Loan', 'Lending', 'Construction Loan', 'Short-term financing for residential or commercial construction projects', 6.50, 9.50, NULL, NULL, TRUE, '2020-01-01');

INSERT INTO CUSTOMERS (FIRST_NAME, LAST_NAME, EMAIL, PHONE, DATE_OF_BIRTH, SSN_LAST_FOUR, ADDRESS_LINE1, CITY, STATE, ZIP_CODE, COUNTRY, CUSTOMER_SEGMENT, CUSTOMER_SINCE, PREFERRED_LANGUAGE, RISK_RATING, KYC_STATUS, KYC_LAST_REVIEWED, ANNUAL_INCOME, EMPLOYMENT_STATUS, EMPLOYER_NAME, CREDIT_SCORE, IS_ACTIVE)
SELECT
    CASE UNIFORM(1, 40, RANDOM())
        WHEN 1 THEN 'Wei' WHEN 2 THEN 'Ming' WHEN 3 THEN 'Li' WHEN 4 THEN 'Xin'
        WHEN 5 THEN 'Hui' WHEN 6 THEN 'Jing' WHEN 7 THEN 'Chen' WHEN 8 THEN 'Ying'
        WHEN 9 THEN 'Jun' WHEN 10 THEN 'Fang' WHEN 11 THEN 'David' WHEN 12 THEN 'Jennifer'
        WHEN 13 THEN 'Michael' WHEN 14 THEN 'Sarah' WHEN 15 THEN 'Kevin' WHEN 16 THEN 'Amy'
        WHEN 17 THEN 'Jason' WHEN 18 THEN 'Michelle' WHEN 19 THEN 'Brian' WHEN 20 THEN 'Lisa'
        WHEN 21 THEN 'Andrew' WHEN 22 THEN 'Grace' WHEN 23 THEN 'Steven' WHEN 24 THEN 'Nancy'
        WHEN 25 THEN 'Daniel' WHEN 26 THEN 'Angela' WHEN 27 THEN 'James' WHEN 28 THEN 'Linda'
        WHEN 29 THEN 'Robert' WHEN 30 THEN 'Sophia' WHEN 31 THEN 'Tao' WHEN 32 THEN 'Mei'
        WHEN 33 THEN 'Rui' WHEN 34 THEN 'Lan' WHEN 35 THEN 'Hong' WHEN 36 THEN 'Yan'
        WHEN 37 THEN 'Peter' WHEN 38 THEN 'Susan' WHEN 39 THEN 'Tony' ELSE 'Emily'
    END AS FIRST_NAME,
    CASE UNIFORM(1, 30, RANDOM())
        WHEN 1 THEN 'Chen' WHEN 2 THEN 'Wang' WHEN 3 THEN 'Li' WHEN 4 THEN 'Zhang'
        WHEN 5 THEN 'Liu' WHEN 6 THEN 'Huang' WHEN 7 THEN 'Wu' WHEN 8 THEN 'Yang'
        WHEN 9 THEN 'Lin' WHEN 10 THEN 'Xu' WHEN 11 THEN 'Chang' WHEN 12 THEN 'Tsai'
        WHEN 13 THEN 'Lee' WHEN 14 THEN 'Wong' WHEN 15 THEN 'Ng' WHEN 16 THEN 'Tam'
        WHEN 17 THEN 'Chow' WHEN 18 THEN 'Ho' WHEN 19 THEN 'Fung' WHEN 20 THEN 'Lau'
        WHEN 21 THEN 'Cheng' WHEN 22 THEN 'Lim' WHEN 23 THEN 'Tang' WHEN 24 THEN 'Kwong'
        WHEN 25 THEN 'Yee' WHEN 26 THEN 'Hsu' WHEN 27 THEN 'Pan' WHEN 28 THEN 'Ching'
        WHEN 29 THEN 'Guo' ELSE 'Zhao'
    END AS LAST_NAME,
    LOWER(FIRST_NAME) || '.' || LOWER(LAST_NAME) || UNIFORM(100, 999, RANDOM()) || '@email.com' AS EMAIL,
    '(' || LPAD(UNIFORM(200, 999, RANDOM())::VARCHAR, 3, '0') || ') ' || LPAD(UNIFORM(100, 999, RANDOM())::VARCHAR, 3, '0') || '-' || LPAD(UNIFORM(1000, 9999, RANDOM())::VARCHAR, 4, '0') AS PHONE,
    DATEADD('day', -UNIFORM(7300, 29200, RANDOM()), CURRENT_DATE()) AS DATE_OF_BIRTH,
    LPAD(UNIFORM(1000, 9999, RANDOM())::VARCHAR, 4, '0') AS SSN_LAST_FOUR,
    UNIFORM(100, 9999, RANDOM())::VARCHAR || ' ' ||
        CASE UNIFORM(1,8,RANDOM()) WHEN 1 THEN 'Main St' WHEN 2 THEN 'Oak Ave' WHEN 3 THEN 'Valley Blvd' WHEN 4 THEN 'Broadway'
        WHEN 5 THEN 'Atlantic Blvd' WHEN 6 THEN 'Garvey Ave' WHEN 7 THEN 'Colima Rd' ELSE 'Garfield Ave' END AS ADDRESS_LINE1,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'Los Angeles' WHEN 2 THEN 'Monterey Park' WHEN 3 THEN 'San Gabriel'
        WHEN 4 THEN 'Arcadia' WHEN 5 THEN 'Alhambra' WHEN 6 THEN 'Irvine'
        WHEN 7 THEN 'San Francisco' WHEN 8 THEN 'Cupertino' WHEN 9 THEN 'Flushing'
        WHEN 10 THEN 'New York' WHEN 11 THEN 'Houston' WHEN 12 THEN 'Plano'
        WHEN 13 THEN 'Bellevue' WHEN 14 THEN 'Quincy' WHEN 15 THEN 'Chicago'
        WHEN 16 THEN 'Edison' WHEN 17 THEN 'Las Vegas' WHEN 18 THEN 'Rockville'
        WHEN 19 THEN 'Brooklyn' ELSE 'Rowland Heights'
    END AS CITY,
    CASE CITY
        WHEN 'Los Angeles' THEN 'CA' WHEN 'Monterey Park' THEN 'CA' WHEN 'San Gabriel' THEN 'CA'
        WHEN 'Arcadia' THEN 'CA' WHEN 'Alhambra' THEN 'CA' WHEN 'Irvine' THEN 'CA'
        WHEN 'San Francisco' THEN 'CA' WHEN 'Cupertino' THEN 'CA' WHEN 'Flushing' THEN 'NY'
        WHEN 'New York' THEN 'NY' WHEN 'Houston' THEN 'TX' WHEN 'Plano' THEN 'TX'
        WHEN 'Bellevue' THEN 'WA' WHEN 'Quincy' THEN 'MA' WHEN 'Chicago' THEN 'IL'
        WHEN 'Edison' THEN 'NJ' WHEN 'Las Vegas' THEN 'NV' WHEN 'Rockville' THEN 'MD'
        WHEN 'Brooklyn' THEN 'NY' ELSE 'CA'
    END AS STATE,
    LPAD(UNIFORM(10000, 99999, RANDOM())::VARCHAR, 5, '0') AS ZIP_CODE,
    'US' AS COUNTRY,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Premier' WHEN 2 THEN 'Preferred' WHEN 3 THEN 'Standard'
        WHEN 4 THEN 'Business' ELSE 'Private Banking'
    END AS CUSTOMER_SEGMENT,
    DATEADD('day', -UNIFORM(30, 22000, RANDOM()), CURRENT_DATE()) AS CUSTOMER_SINCE,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'English' WHEN 2 THEN 'Mandarin' WHEN 3 THEN 'Cantonese' ELSE 'English'
    END AS PREFERRED_LANGUAGE,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Low' WHEN 3 THEN 'Medium' WHEN 4 THEN 'Medium' ELSE 'High'
    END AS RISK_RATING,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Pending' WHEN 2 THEN 'Expired' ELSE 'Verified'
    END AS KYC_STATUS,
    DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS KYC_LAST_REVIEWED,
    ROUND(UNIFORM(25000, 500000, RANDOM()), -3) AS ANNUAL_INCOME,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Employed' WHEN 2 THEN 'Self-Employed' WHEN 3 THEN 'Employed'
        WHEN 4 THEN 'Retired' WHEN 5 THEN 'Employed' ELSE 'Business Owner'
    END AS EMPLOYMENT_STATUS,
    CASE UNIFORM(1, 15, RANDOM())
        WHEN 1 THEN 'Google' WHEN 2 THEN 'Apple' WHEN 3 THEN 'Meta' WHEN 4 THEN 'Amazon'
        WHEN 5 THEN 'Self' WHEN 6 THEN 'UC System' WHEN 7 THEN 'Kaiser Permanente'
        WHEN 8 THEN 'Boeing' WHEN 9 THEN 'Microsoft' WHEN 10 THEN 'JP Morgan'
        WHEN 11 THEN 'Deloitte' WHEN 12 THEN 'City of LA' WHEN 13 THEN 'Costco'
        WHEN 14 THEN 'Toyota' ELSE 'Wells Fargo'
    END AS EMPLOYER_NAME,
    UNIFORM(580, 850, RANDOM()) AS CREDIT_SCORE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN TRUE ELSE FALSE END AS IS_ACTIVE
FROM TABLE(GENERATOR(ROWCOUNT => 2000));

INSERT INTO ACCOUNTS (CUSTOMER_ID, ACCOUNT_NUMBER, ACCOUNT_TYPE, ACCOUNT_SUBTYPE, CURRENCY, CURRENT_BALANCE, AVAILABLE_BALANCE, INTEREST_RATE, OVERDRAFT_LIMIT, STATUS, OPENED_DATE, BRANCH_ID, BRANCH_NAME, BRANCH_STATE)
SELECT
    C.CUSTOMER_ID,
    'CB' || LPAD(SEQ4()::VARCHAR, 10, '0') AS ACCOUNT_NUMBER,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Checking' WHEN 2 THEN 'Savings' WHEN 3 THEN 'Checking'
        WHEN 4 THEN 'Money Market' WHEN 5 THEN 'Certificate of Deposit' ELSE 'Savings'
    END AS ACCOUNT_TYPE,
    CASE ACCOUNT_TYPE
        WHEN 'Checking' THEN CASE WHEN C.ANNUAL_INCOME > 150000 THEN 'Premium Checking' ELSE 'Standard Checking' END
        WHEN 'Savings' THEN 'Regular Savings'
        WHEN 'Money Market' THEN 'High Yield Money Market'
        WHEN 'Certificate of Deposit' THEN '12-Month CD'
        ELSE NULL
    END AS ACCOUNT_SUBTYPE,
    'USD' AS CURRENCY,
    CASE ACCOUNT_TYPE
        WHEN 'Checking' THEN ROUND(UNIFORM(500, 150000, RANDOM()), 2)
        WHEN 'Savings' THEN ROUND(UNIFORM(1000, 500000, RANDOM()), 2)
        WHEN 'Money Market' THEN ROUND(UNIFORM(5000, 1000000, RANDOM()), 2)
        WHEN 'Certificate of Deposit' THEN ROUND(UNIFORM(10000, 500000, RANDOM()), 2)
        ELSE ROUND(UNIFORM(100, 50000, RANDOM()), 2)
    END AS CURRENT_BALANCE,
    CURRENT_BALANCE * UNIFORM(85, 100, RANDOM()) / 100.0 AS AVAILABLE_BALANCE,
    CASE ACCOUNT_TYPE
        WHEN 'Checking' THEN ROUND(UNIFORM(0, 5, RANDOM()) / 100.0, 5)
        WHEN 'Savings' THEN ROUND(UNIFORM(10, 50, RANDOM()) / 100.0, 5)
        WHEN 'Money Market' THEN ROUND(UNIFORM(50, 250, RANDOM()) / 100.0, 5)
        WHEN 'Certificate of Deposit' THEN ROUND(UNIFORM(300, 500, RANDOM()) / 100.0, 5)
        ELSE 0
    END AS INTEREST_RATE,
    CASE ACCOUNT_TYPE WHEN 'Checking' THEN UNIFORM(0, 5000, RANDOM()) ELSE 0 END AS OVERDRAFT_LIMIT,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN 'ACTIVE'
         WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'DORMANT' ELSE 'CLOSED' END AS STATUS,
    DATEADD('day', -UNIFORM(30, 15000, RANDOM()), CURRENT_DATE()) AS OPENED_DATE,
    B.BRANCH_ID,
    B.BRANCH_NAME,
    B.STATE
FROM CATHAY_BANK_DB.RAW.CUSTOMERS C
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2)) G
JOIN CATHAY_BANK_DB.RAW.BRANCHES B ON B.BRANCH_ID = UNIFORM(1, 20, RANDOM())
WHERE UNIFORM(1, 10, RANDOM()) <= 8;

INSERT INTO TRANSACTIONS (ACCOUNT_ID, TRANSACTION_DATE, POSTED_DATE, TRANSACTION_TYPE, TRANSACTION_CATEGORY, AMOUNT, CURRENCY, DESCRIPTION, MERCHANT_NAME, MERCHANT_CATEGORY, CHANNEL, REFERENCE_NUMBER, IS_RECURRING, IS_FLAGGED, FLAG_REASON, BALANCE_AFTER)
SELECT
    A.ACCOUNT_ID,
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()) AS TRANSACTION_DATE,
    TRANSACTION_DATE::DATE AS POSTED_DATE,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'Deposit' WHEN 2 THEN 'Withdrawal' WHEN 3 THEN 'Transfer'
        WHEN 4 THEN 'Payment' WHEN 5 THEN 'Direct Deposit' WHEN 6 THEN 'ACH Debit'
        WHEN 7 THEN 'Wire Transfer' ELSE 'Check'
    END AS TRANSACTION_TYPE,
    CASE UNIFORM(1, 12, RANDOM())
        WHEN 1 THEN 'Payroll' WHEN 2 THEN 'Groceries' WHEN 3 THEN 'Dining'
        WHEN 4 THEN 'Utilities' WHEN 5 THEN 'Rent/Mortgage' WHEN 6 THEN 'Insurance'
        WHEN 7 THEN 'Healthcare' WHEN 8 THEN 'Shopping' WHEN 9 THEN 'Transportation'
        WHEN 10 THEN 'Entertainment' WHEN 11 THEN 'Investment' ELSE 'Other'
    END AS TRANSACTION_CATEGORY,
    CASE TRANSACTION_TYPE
        WHEN 'Deposit' THEN ROUND(UNIFORM(100, 25000, RANDOM()), 2)
        WHEN 'Direct Deposit' THEN ROUND(UNIFORM(1500, 15000, RANDOM()), 2)
        WHEN 'Wire Transfer' THEN ROUND(UNIFORM(500, 100000, RANDOM()), 2)
        ELSE -1 * ROUND(UNIFORM(5, 5000, RANDOM()), 2)
    END AS AMOUNT,
    'USD' AS CURRENCY,
    CASE TRANSACTION_TYPE
        WHEN 'Direct Deposit' THEN 'PAYROLL - ' || CASE UNIFORM(1,5,RANDOM()) WHEN 1 THEN 'GOOGLE INC' WHEN 2 THEN 'APPLE INC' WHEN 3 THEN 'AMAZON' WHEN 4 THEN 'MICROSOFT' ELSE 'META PLATFORMS' END
        WHEN 'Payment' THEN 'POS PURCHASE - ' || CASE UNIFORM(1,6,RANDOM()) WHEN 1 THEN '99 RANCH MARKET' WHEN 2 THEN 'DIN TAI FUNG' WHEN 3 THEN 'HMART' WHEN 4 THEN 'COSTCO' WHEN 5 THEN 'AMAZON.COM' ELSE 'TARGET' END
        WHEN 'ACH Debit' THEN 'ACH - ' || CASE UNIFORM(1,4,RANDOM()) WHEN 1 THEN 'SOCAL EDISON' WHEN 2 THEN 'AT&T WIRELESS' WHEN 3 THEN 'STATE FARM INS' ELSE 'SPECTRUM CABLE' END
        WHEN 'Wire Transfer' THEN 'WIRE - ' || CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'INTL TRANSFER' WHEN 2 THEN 'PROPERTY PURCHASE' ELSE 'BUSINESS PAYMENT' END
        ELSE TRANSACTION_TYPE || ' transaction'
    END AS DESCRIPTION,
    CASE WHEN TRANSACTION_TYPE IN ('Payment', 'ACH Debit') THEN
        CASE UNIFORM(1,8,RANDOM()) WHEN 1 THEN '99 Ranch Market' WHEN 2 THEN 'Din Tai Fung' WHEN 3 THEN 'H Mart' WHEN 4 THEN 'Costco' WHEN 5 THEN 'Amazon' WHEN 6 THEN 'Target' WHEN 7 THEN 'Southern California Edison' ELSE 'AT&T' END
    ELSE NULL END AS MERCHANT_NAME,
    CASE WHEN MERCHANT_NAME IS NOT NULL THEN
        CASE UNIFORM(1,6,RANDOM()) WHEN 1 THEN 'Grocery' WHEN 2 THEN 'Restaurant' WHEN 3 THEN 'Retail' WHEN 4 THEN 'Utility' WHEN 5 THEN 'Insurance' ELSE 'Telecom' END
    ELSE NULL END AS MERCHANT_CATEGORY,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Online Banking' WHEN 2 THEN 'Mobile App' WHEN 3 THEN 'Branch'
        WHEN 4 THEN 'ATM' WHEN 5 THEN 'ACH' ELSE 'Wire'
    END AS CHANNEL,
    'REF' || LPAD(UNIFORM(100000000, 999999999, RANDOM())::VARCHAR, 9, '0') AS REFERENCE_NUMBER,
    CASE WHEN TRANSACTION_CATEGORY IN ('Rent/Mortgage', 'Utilities', 'Insurance', 'Payroll') THEN TRUE ELSE FALSE END AS IS_RECURRING,
    CASE WHEN UNIFORM(1, 200, RANDOM()) = 1 THEN TRUE ELSE FALSE END AS IS_FLAGGED,
    CASE WHEN IS_FLAGGED THEN
        CASE UNIFORM(1,4,RANDOM()) WHEN 1 THEN 'Large cash transaction' WHEN 2 THEN 'Unusual pattern' WHEN 3 THEN 'High-risk jurisdiction' ELSE 'Structuring concern' END
    ELSE NULL END AS FLAG_REASON,
    A.CURRENT_BALANCE + AMOUNT AS BALANCE_AFTER
FROM CATHAY_BANK_DB.RAW.ACCOUNTS A
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 15)) G
WHERE A.STATUS = 'ACTIVE'
  AND UNIFORM(1, 10, RANDOM()) <= 7;

INSERT INTO LOANS (CUSTOMER_ID, ACCOUNT_ID, LOAN_TYPE, LOAN_PURPOSE, ORIGINAL_AMOUNT, CURRENT_BALANCE, INTEREST_RATE, RATE_TYPE, TERM_MONTHS, MONTHLY_PAYMENT, ORIGINATION_DATE, MATURITY_DATE, COLLATERAL_TYPE, COLLATERAL_VALUE, LTV_RATIO, DTI_RATIO, DELINQUENCY_STATUS, DAYS_PAST_DUE, RISK_GRADE, STATUS)
SELECT
    C.CUSTOMER_ID,
    A.ACCOUNT_ID,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'Residential Mortgage' WHEN 2 THEN 'Residential Mortgage'
        WHEN 3 THEN 'Commercial Mortgage' WHEN 4 THEN 'Home Equity'
        WHEN 5 THEN 'Auto Loan' WHEN 6 THEN 'Personal Loan'
        WHEN 7 THEN 'SBA Loan' ELSE 'Business Line of Credit'
    END AS LOAN_TYPE,
    CASE LOAN_TYPE
        WHEN 'Residential Mortgage' THEN CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'Home Purchase' WHEN 2 THEN 'Refinance' ELSE 'Construction' END
        WHEN 'Commercial Mortgage' THEN 'Business Property'
        WHEN 'Home Equity' THEN 'Home Improvement'
        WHEN 'Auto Loan' THEN 'Vehicle Purchase'
        WHEN 'Personal Loan' THEN 'Debt Consolidation'
        WHEN 'SBA Loan' THEN 'Business Expansion'
        ELSE 'Working Capital'
    END AS LOAN_PURPOSE,
    CASE LOAN_TYPE
        WHEN 'Residential Mortgage' THEN ROUND(UNIFORM(200000, 2000000, RANDOM()), -3)
        WHEN 'Commercial Mortgage' THEN ROUND(UNIFORM(500000, 10000000, RANDOM()), -3)
        WHEN 'Home Equity' THEN ROUND(UNIFORM(50000, 500000, RANDOM()), -3)
        WHEN 'Auto Loan' THEN ROUND(UNIFORM(15000, 80000, RANDOM()), -3)
        WHEN 'Personal Loan' THEN ROUND(UNIFORM(5000, 50000, RANDOM()), -3)
        WHEN 'SBA Loan' THEN ROUND(UNIFORM(50000, 5000000, RANDOM()), -3)
        ELSE ROUND(UNIFORM(25000, 1000000, RANDOM()), -3)
    END AS ORIGINAL_AMOUNT,
    ROUND(ORIGINAL_AMOUNT * UNIFORM(30, 95, RANDOM()) / 100.0, 2) AS CURRENT_BALANCE,
    ROUND(UNIFORM(350, 850, RANDOM()) / 100.0, 3) AS INTEREST_RATE,
    CASE WHEN UNIFORM(1, 3, RANDOM()) = 1 THEN 'Variable' ELSE 'Fixed' END AS RATE_TYPE,
    CASE LOAN_TYPE
        WHEN 'Residential Mortgage' THEN CASE UNIFORM(1,2,RANDOM()) WHEN 1 THEN 360 ELSE 180 END
        WHEN 'Commercial Mortgage' THEN CASE UNIFORM(1,2,RANDOM()) WHEN 1 THEN 240 ELSE 120 END
        WHEN 'Home Equity' THEN 120
        WHEN 'Auto Loan' THEN CASE UNIFORM(1,2,RANDOM()) WHEN 1 THEN 60 ELSE 72 END
        WHEN 'Personal Loan' THEN CASE UNIFORM(1,2,RANDOM()) WHEN 1 THEN 36 ELSE 60 END
        WHEN 'SBA Loan' THEN 120
        ELSE 60
    END AS TERM_MONTHS,
    COALESCE(
        ROUND(ORIGINAL_AMOUNT * (INTEREST_RATE/100.0/12) / NULLIF(1 - POWER(1 + INTEREST_RATE/100.0/12, -TERM_MONTHS), 0), 2),
        ROUND(ORIGINAL_AMOUNT / TERM_MONTHS, 2)
    ) AS MONTHLY_PAYMENT,
    DATEADD('day', -UNIFORM(30, 7300, RANDOM()), CURRENT_DATE()) AS ORIGINATION_DATE,
    DATEADD('month', TERM_MONTHS, ORIGINATION_DATE) AS MATURITY_DATE,
    CASE LOAN_TYPE
        WHEN 'Residential Mortgage' THEN 'Residential Real Estate'
        WHEN 'Commercial Mortgage' THEN 'Commercial Real Estate'
        WHEN 'Home Equity' THEN 'Residential Real Estate'
        WHEN 'Auto Loan' THEN 'Vehicle'
        WHEN 'SBA Loan' THEN 'Business Assets'
        ELSE NULL
    END AS COLLATERAL_TYPE,
    CASE WHEN COLLATERAL_TYPE IS NOT NULL THEN ROUND(ORIGINAL_AMOUNT * UNIFORM(110, 200, RANDOM()) / 100.0, -3) ELSE NULL END AS COLLATERAL_VALUE,
    CASE WHEN COLLATERAL_VALUE IS NOT NULL THEN ROUND(ORIGINAL_AMOUNT / COLLATERAL_VALUE, 4) ELSE NULL END AS LTV_RATIO,
    ROUND(MONTHLY_PAYMENT / (C.ANNUAL_INCOME / 12.0), 4) AS DTI_RATIO,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN '30 Days Past Due' WHEN 2 THEN '60 Days Past Due'
        WHEN 3 THEN '90+ Days Past Due' ELSE 'Current'
    END AS DELINQUENCY_STATUS,
    CASE DELINQUENCY_STATUS
        WHEN '30 Days Past Due' THEN UNIFORM(30, 59, RANDOM())
        WHEN '60 Days Past Due' THEN UNIFORM(60, 89, RANDOM())
        WHEN '90+ Days Past Due' THEN UNIFORM(90, 180, RANDOM())
        ELSE 0
    END AS DAYS_PAST_DUE,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'A+' WHEN 2 THEN 'A' WHEN 3 THEN 'A' WHEN 4 THEN 'B+'
        WHEN 5 THEN 'B' WHEN 6 THEN 'B' WHEN 7 THEN 'C+' WHEN 8 THEN 'C'
        WHEN 9 THEN 'D' ELSE 'E'
    END AS RISK_GRADE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACTIVE'
         WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'PAID OFF' ELSE 'DEFAULT' END AS STATUS
FROM CATHAY_BANK_DB.RAW.CUSTOMERS C
JOIN CATHAY_BANK_DB.RAW.ACCOUNTS A ON C.CUSTOMER_ID = A.CUSTOMER_ID
WHERE UNIFORM(1, 10, RANDOM()) <= 3
QUALIFY ROW_NUMBER() OVER (PARTITION BY C.CUSTOMER_ID ORDER BY RANDOM()) = 1;

INSERT INTO LOAN_PAYMENTS (LOAN_ID, PAYMENT_DATE, DUE_DATE, PAYMENT_AMOUNT, PRINCIPAL_AMOUNT, INTEREST_AMOUNT, ESCROW_AMOUNT, LATE_FEE, PAYMENT_METHOD, STATUS)
SELECT
    L.LOAN_ID,
    DATEADD('day', -UNIFORM(0, 5, RANDOM()), DUE.DUE_DATE) AS PAYMENT_DATE,
    DUE.DUE_DATE,
    L.MONTHLY_PAYMENT AS PAYMENT_AMOUNT,
    ROUND(L.MONTHLY_PAYMENT * 0.6, 2) AS PRINCIPAL_AMOUNT,
    ROUND(L.MONTHLY_PAYMENT * 0.35, 2) AS INTEREST_AMOUNT,
    ROUND(L.MONTHLY_PAYMENT * 0.05, 2) AS ESCROW_AMOUNT,
    CASE WHEN UNIFORM(1, 20, RANDOM()) = 1 THEN 35.00 ELSE 0 END AS LATE_FEE,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Auto Pay' WHEN 2 THEN 'Online Banking' WHEN 3 THEN 'ACH' ELSE 'Check'
    END AS PAYMENT_METHOD,
    CASE WHEN UNIFORM(1, 50, RANDOM()) = 1 THEN 'Late' ELSE 'On Time' END AS STATUS
FROM CATHAY_BANK_DB.RAW.LOANS L
CROSS JOIN (
    SELECT DATEADD('month', -SEQ4(), CURRENT_DATE())::DATE AS DUE_DATE
    FROM TABLE(GENERATOR(ROWCOUNT => 12))
) DUE
WHERE L.STATUS = 'ACTIVE';

INSERT INTO COMPLIANCE_EVENTS (CUSTOMER_ID, ACCOUNT_ID, EVENT_TYPE, EVENT_CATEGORY, REGULATORY_FRAMEWORK, SEVERITY, STATUS, DESCRIPTION, DETECTION_METHOD, DETECTED_DATE, RESOLVED_DATE, ASSIGNED_TO, RESOLUTION_NOTES, SAR_FILED, SAR_FILING_DATE, CTR_FILED, REGULATORY_REPORT_ID)
SELECT
    C.CUSTOMER_ID,
    A.ACCOUNT_ID,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Suspicious Activity Detected'
        WHEN 2 THEN 'Currency Transaction Report'
        WHEN 3 THEN 'KYC Review Required'
        WHEN 4 THEN 'OFAC Screening Alert'
        WHEN 5 THEN 'Unusual Wire Activity'
        WHEN 6 THEN 'Structuring Suspicion'
        WHEN 7 THEN 'High-Risk Country Transaction'
        WHEN 8 THEN 'Beneficial Ownership Update'
        WHEN 9 THEN 'Enhanced Due Diligence Trigger'
        ELSE 'Regulatory Examination Finding'
    END AS EVENT_TYPE,
    CASE
        WHEN EVENT_TYPE IN ('Suspicious Activity Detected', 'Structuring Suspicion', 'Unusual Wire Activity') THEN 'AML/BSA'
        WHEN EVENT_TYPE IN ('Currency Transaction Report') THEN 'BSA Reporting'
        WHEN EVENT_TYPE IN ('KYC Review Required', 'Beneficial Ownership Update', 'Enhanced Due Diligence Trigger') THEN 'KYC/CDD'
        WHEN EVENT_TYPE IN ('OFAC Screening Alert', 'High-Risk Country Transaction') THEN 'Sanctions'
        ELSE 'Regulatory'
    END AS EVENT_CATEGORY,
    CASE EVENT_CATEGORY
        WHEN 'AML/BSA' THEN 'Bank Secrecy Act'
        WHEN 'BSA Reporting' THEN 'Bank Secrecy Act'
        WHEN 'KYC/CDD' THEN 'FinCEN CDD Rule'
        WHEN 'Sanctions' THEN 'OFAC'
        ELSE 'Federal Banking Regulations'
    END AS REGULATORY_FRAMEWORK,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Critical' WHEN 2 THEN 'High' WHEN 3 THEN 'Medium'
        WHEN 4 THEN 'Medium' ELSE 'Low'
    END AS SEVERITY,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Open' WHEN 2 THEN 'Under Investigation' WHEN 3 THEN 'Resolved'
        WHEN 4 THEN 'Resolved' ELSE 'Escalated'
    END AS STATUS,
    'Compliance event: ' || EVENT_TYPE || ' detected for customer ' || C.FIRST_NAME || ' ' || C.LAST_NAME ||
    '. Investigation initiated per ' || REGULATORY_FRAMEWORK || ' requirements.' AS DESCRIPTION,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Automated Transaction Monitoring' WHEN 2 THEN 'Manual Review'
        WHEN 3 THEN 'Sanctions Screening System' ELSE 'Regulatory Examination'
    END AS DETECTION_METHOD,
    DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_TIMESTAMP()) AS DETECTED_DATE,
    CASE WHEN STATUS IN ('Resolved') THEN DATEADD('day', UNIFORM(1, 90, RANDOM()), DETECTED_DATE) ELSE NULL END AS RESOLVED_DATE,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Compliance Team A' WHEN 2 THEN 'BSA Officer' WHEN 3 THEN 'OFAC Analyst'
        WHEN 4 THEN 'KYC Team' WHEN 5 THEN 'Risk Management' ELSE 'External Counsel'
    END AS ASSIGNED_TO,
    CASE WHEN STATUS = 'Resolved' THEN 'Investigation completed. ' ||
        CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'No suspicious activity confirmed. Case closed.' WHEN 2 THEN 'SAR filed with FinCEN. Monitoring continues.' ELSE 'Enhanced monitoring applied. Customer risk rating updated.' END
    ELSE NULL END AS RESOLUTION_NOTES,
    CASE WHEN EVENT_TYPE IN ('Suspicious Activity Detected', 'Structuring Suspicion') AND STATUS = 'Resolved' AND UNIFORM(1,3,RANDOM()) <= 2 THEN TRUE ELSE FALSE END AS SAR_FILED,
    CASE WHEN SAR_FILED THEN DATEADD('day', UNIFORM(5, 30, RANDOM()), DETECTED_DATE)::DATE ELSE NULL END AS SAR_FILING_DATE,
    CASE WHEN EVENT_TYPE = 'Currency Transaction Report' THEN TRUE ELSE FALSE END AS CTR_FILED,
    CASE WHEN SAR_FILED OR CTR_FILED THEN 'REG-' || LPAD(UNIFORM(100000, 999999, RANDOM())::VARCHAR, 6, '0') ELSE NULL END AS REGULATORY_REPORT_ID
FROM CATHAY_BANK_DB.RAW.CUSTOMERS C
JOIN CATHAY_BANK_DB.RAW.ACCOUNTS A ON C.CUSTOMER_ID = A.CUSTOMER_ID
WHERE UNIFORM(1, 10, RANDOM()) <= 2
QUALIFY ROW_NUMBER() OVER (PARTITION BY C.CUSTOMER_ID ORDER BY RANDOM()) <= 2;

INSERT INTO RISK_ASSESSMENTS (CUSTOMER_ID, ACCOUNT_ID, LOAN_ID, ASSESSMENT_TYPE, RISK_CATEGORY, RISK_SCORE, RISK_RATING, RISK_FACTORS, ASSESSMENT_DATE, NEXT_REVIEW_DATE, ASSESSOR, MODEL_VERSION, STATUS, NOTES)
SELECT
    C.CUSTOMER_ID,
    A.ACCOUNT_ID,
    L.LOAN_ID,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Credit Risk Assessment'
        WHEN 2 THEN 'AML Risk Assessment'
        WHEN 3 THEN 'Operational Risk Review'
        WHEN 4 THEN 'Concentration Risk Analysis'
        ELSE 'Customer Risk Profiling'
    END AS ASSESSMENT_TYPE,
    CASE ASSESSMENT_TYPE
        WHEN 'Credit Risk Assessment' THEN 'Credit Risk'
        WHEN 'AML Risk Assessment' THEN 'Compliance Risk'
        WHEN 'Operational Risk Review' THEN 'Operational Risk'
        WHEN 'Concentration Risk Analysis' THEN 'Market Risk'
        ELSE 'Enterprise Risk'
    END AS RISK_CATEGORY,
    ROUND(UNIFORM(1, 100, RANDOM()), 2) AS RISK_SCORE,
    CASE
        WHEN RISK_SCORE <= 20 THEN 'Very Low'
        WHEN RISK_SCORE <= 40 THEN 'Low'
        WHEN RISK_SCORE <= 60 THEN 'Medium'
        WHEN RISK_SCORE <= 80 THEN 'High'
        ELSE 'Critical'
    END AS RISK_RATING,
    CASE ASSESSMENT_TYPE
        WHEN 'Credit Risk Assessment' THEN 'Credit score: ' || C.CREDIT_SCORE || ', DTI: ' || COALESCE(L.DTI_RATIO::VARCHAR, 'N/A') || ', Payment history, Collateral adequacy'
        WHEN 'AML Risk Assessment' THEN 'Transaction patterns, Geographic risk, Customer profile, Source of funds, PEP status'
        WHEN 'Operational Risk Review' THEN 'System availability, Process controls, Staff training, Fraud detection, Business continuity'
        WHEN 'Concentration Risk Analysis' THEN 'Industry concentration, Geographic concentration, Single borrower limits, Product mix'
        ELSE 'Overall customer profile, Relationship depth, Product usage, Behavioral patterns'
    END AS RISK_FACTORS,
    DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) AS ASSESSMENT_DATE,
    DATEADD('month', CASE RISK_RATING WHEN 'Critical' THEN 3 WHEN 'High' THEN 6 ELSE 12 END, ASSESSMENT_DATE) AS NEXT_REVIEW_DATE,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Credit Risk Model v3.2' WHEN 2 THEN 'AML Analyst Team' WHEN 3 THEN 'Risk Committee' ELSE 'Automated Assessment'
    END AS ASSESSOR,
    'v' || UNIFORM(1, 5, RANDOM()) || '.' || UNIFORM(0, 9, RANDOM()) AS MODEL_VERSION,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Completed' WHEN 2 THEN 'Completed' WHEN 3 THEN 'Pending Review' ELSE 'In Progress'
    END AS STATUS,
    'Assessment performed per ' || RISK_CATEGORY || ' framework. ' ||
    CASE WHEN RISK_RATING IN ('High', 'Critical') THEN 'Elevated risk identified - enhanced monitoring recommended.' ELSE 'Within acceptable risk parameters.' END AS NOTES
FROM CATHAY_BANK_DB.RAW.CUSTOMERS C
JOIN CATHAY_BANK_DB.RAW.ACCOUNTS A ON C.CUSTOMER_ID = A.CUSTOMER_ID
LEFT JOIN CATHAY_BANK_DB.RAW.LOANS L ON C.CUSTOMER_ID = L.CUSTOMER_ID
WHERE UNIFORM(1, 5, RANDOM()) <= 2
QUALIFY ROW_NUMBER() OVER (PARTITION BY C.CUSTOMER_ID ORDER BY RANDOM()) = 1;

INSERT INTO SUPPORT_CASES (CUSTOMER_ID, ACCOUNT_ID, CASE_NUMBER, CATEGORY, SUBCATEGORY, PRIORITY, STATUS, CHANNEL, SUBJECT, DESCRIPTION, RESOLUTION, ASSIGNED_TO, OPENED_DATE, FIRST_RESPONSE_DATE, RESOLVED_DATE, CLOSED_DATE, SATISFACTION_SCORE)
SELECT
    C.CUSTOMER_ID,
    A.ACCOUNT_ID,
    'CS-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS CASE_NUMBER,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'Account Services' WHEN 2 THEN 'Online Banking' WHEN 3 THEN 'Loan Services'
        WHEN 4 THEN 'Card Services' WHEN 5 THEN 'Wire Transfer' WHEN 6 THEN 'Fraud Report'
        WHEN 7 THEN 'Fee Dispute' ELSE 'General Inquiry'
    END AS CATEGORY,
    CASE CATEGORY
        WHEN 'Account Services' THEN CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'Balance Inquiry' WHEN 2 THEN 'Statement Request' ELSE 'Account Update' END
        WHEN 'Online Banking' THEN CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'Login Issue' WHEN 2 THEN 'Mobile App' ELSE 'Bill Pay' END
        WHEN 'Loan Services' THEN CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'Payment Question' WHEN 2 THEN 'Rate Inquiry' ELSE 'Payoff Request' END
        WHEN 'Wire Transfer' THEN CASE UNIFORM(1,2,RANDOM()) WHEN 1 THEN 'International Wire' ELSE 'Domestic Wire' END
        WHEN 'Fraud Report' THEN CASE UNIFORM(1,2,RANDOM()) WHEN 1 THEN 'Unauthorized Transaction' ELSE 'Identity Theft' END
        WHEN 'Fee Dispute' THEN 'Overdraft Fee'
        ELSE 'Product Information'
    END AS SUBCATEGORY,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' WHEN 3 THEN 'High' ELSE 'Critical'
    END AS PRIORITY,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Open' WHEN 2 THEN 'In Progress' WHEN 3 THEN 'Resolved'
        WHEN 4 THEN 'Closed' ELSE 'Pending Customer'
    END AS STATUS,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Phone' WHEN 2 THEN 'Branch' WHEN 3 THEN 'Online Chat'
        WHEN 4 THEN 'Email' ELSE 'Mobile App'
    END AS CHANNEL,
    CATEGORY || ' - ' || SUBCATEGORY || ' inquiry' AS SUBJECT,
    'Customer ' || C.FIRST_NAME || ' ' || C.LAST_NAME || ' contacted via ' || CHANNEL || ' regarding ' || LOWER(SUBCATEGORY) ||
    '. Account: ' || A.ACCOUNT_NUMBER || '. ' ||
    CASE PRIORITY WHEN 'Critical' THEN 'Requires immediate attention.' WHEN 'High' THEN 'Escalated priority case.' ELSE 'Standard handling.' END AS DESCRIPTION,
    CASE WHEN STATUS IN ('Resolved', 'Closed') THEN
        'Issue addressed. ' || CASE UNIFORM(1,3,RANDOM()) WHEN 1 THEN 'Customer confirmed resolution.' WHEN 2 THEN 'Fee credited to account.' ELSE 'Information provided to customer satisfaction.' END
    ELSE NULL END AS RESOLUTION,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'CS Team Alpha' WHEN 2 THEN 'CS Team Beta' WHEN 3 THEN 'Branch Manager'
        WHEN 4 THEN 'Digital Support' WHEN 5 THEN 'Fraud Team' ELSE 'Loan Servicing'
    END AS ASSIGNED_TO,
    DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_TIMESTAMP()) AS OPENED_DATE,
    DATEADD('hour', UNIFORM(1, 48, RANDOM()), OPENED_DATE) AS FIRST_RESPONSE_DATE,
    CASE WHEN STATUS IN ('Resolved', 'Closed') THEN DATEADD('day', UNIFORM(1, 14, RANDOM()), OPENED_DATE) ELSE NULL END AS RESOLVED_DATE,
    CASE WHEN STATUS = 'Closed' THEN DATEADD('day', UNIFORM(0, 3, RANDOM()), RESOLVED_DATE) ELSE NULL END AS CLOSED_DATE,
    CASE WHEN STATUS IN ('Resolved', 'Closed') THEN ROUND(UNIFORM(1, 5, RANDOM()) + UNIFORM(0, 9, RANDOM()) / 10.0, 1) ELSE NULL END AS SATISFACTION_SCORE
FROM CATHAY_BANK_DB.RAW.CUSTOMERS C
JOIN CATHAY_BANK_DB.RAW.ACCOUNTS A ON C.CUSTOMER_ID = A.CUSTOMER_ID
WHERE UNIFORM(1, 8, RANDOM()) <= 2
QUALIFY ROW_NUMBER() OVER (PARTITION BY C.CUSTOMER_ID ORDER BY RANDOM()) <= 2;

INSERT INTO REGULATORY_DOCUMENTS (TITLE, DOCUMENT_TYPE, REGULATORY_BODY, FRAMEWORK, CONTENT, SUMMARY, EFFECTIVE_DATE, VERSION, STATUS, TAGS)
VALUES
('BSA/AML Compliance Program Manual', 'Policy Manual', 'FinCEN', 'Bank Secrecy Act',
 'Cathay Bank BSA/AML Compliance Program\n\n1. PROGRAM OVERVIEW\nCathay Bank maintains a comprehensive BSA/AML compliance program designed to detect and prevent money laundering, terrorist financing, and other financial crimes. This program complies with the Bank Secrecy Act (BSA), USA PATRIOT Act, and all FinCEN regulations.\n\n2. CUSTOMER IDENTIFICATION PROGRAM (CIP)\nAll new customers must be verified through our CIP process, which includes: collection of name, date of birth, address, and identification number; verification through documentary and non-documentary methods; screening against government lists.\n\n3. CUSTOMER DUE DILIGENCE (CDD)\nRisk-based CDD procedures include: Standard Due Diligence for low-risk customers, Enhanced Due Diligence (EDD) for high-risk customers and PEPs, Simplified Due Diligence for clearly low-risk accounts.\n\n4. TRANSACTION MONITORING\nAutomated monitoring systems screen all transactions for: cash transactions exceeding $10,000 (CTR filing), suspicious patterns indicating structuring, unusual wire transfer activity, transactions involving high-risk jurisdictions.\n\n5. SUSPICIOUS ACTIVITY REPORTING\nSARs must be filed within 30 calendar days of initial detection for transactions of $5,000 or more that are known or suspected to involve funds from illegal activity.\n\n6. OFAC COMPLIANCE\nAll customers and transactions are screened against OFAC SDN and other sanctions lists in real-time.\n\n7. RECORD RETENTION\nAll BSA records must be maintained for a minimum of 5 years.',
 'Comprehensive BSA/AML compliance program covering CIP, CDD, transaction monitoring, SAR filing, OFAC screening, and record retention requirements.', '2024-01-01', '4.0', 'Active', 'BSA,AML,KYC,CDD,SAR,CTR,OFAC,Compliance'),

('Community Reinvestment Act Performance Plan', 'Compliance Plan', 'OCC', 'Community Reinvestment Act',
 'Cathay Bank CRA Performance Plan\n\n1. ASSESSMENT AREAS\nCathay Bank has defined assessment areas across its nine-state footprint: Los Angeles-Long Beach MSA, San Francisco-Oakland MSA, New York-Newark MSA, Houston-The Woodlands MSA, Seattle-Tacoma MSA, Boston-Cambridge MSA, Chicago-Naperville MSA.\n\n2. LENDING TEST\nThe Bank evaluates its lending performance through: distribution of loans among borrowers of different income levels, geographic distribution within assessment areas, community development loans, innovative lending products for LMI borrowers.\n\n3. INVESTMENT TEST\nQualified investments include: Low Income Housing Tax Credits (LIHTC), Small Business Investment Company (SBIC) investments, community development financial institution (CDFI) investments, municipal bonds for affordable housing.\n\n4. SERVICE TEST\nBranch distribution and services are evaluated for accessibility to LMI geographies and individuals. Alternative delivery systems including online and mobile banking serve underbanked populations.\n\n5. PERFORMANCE CONTEXT\nCathay Bank serves a unique demographic with specialized language and cultural needs. The bank provides multilingual services in English, Mandarin, and Cantonese across all branches.',
 'CRA performance plan covering assessment areas, lending test metrics, qualified investments, and service test criteria across Cathay Bank nine-state footprint.', '2024-01-01', '3.0', 'Active', 'CRA,Community,Lending,Investment,LMI'),

('Basel III Capital Adequacy Framework', 'Regulatory Report', 'Federal Reserve', 'Basel III',
 'Cathay General Bancorp - Basel III Capital Adequacy Report\n\n1. CAPITAL COMPOSITION\nCET1 Capital: Common stock, retained earnings, AOCI (with opt-out election)\nAdditional Tier 1: Qualifying non-cumulative perpetual preferred stock\nTier 2 Capital: Qualifying subordinated debt, allowance for loan losses (up to 1.25% of RWA)\n\n2. MINIMUM CAPITAL REQUIREMENTS\nCET1 Ratio: 4.5% minimum + 2.5% capital conservation buffer = 7.0%\nTier 1 Ratio: 6.0% minimum + 2.5% buffer = 8.5%\nTotal Capital Ratio: 8.0% minimum + 2.5% buffer = 10.5%\nLeverage Ratio: 4.0% minimum\n\n3. RISK-WEIGHTED ASSETS\nCredit Risk RWA calculated using Standardized Approach: Residential mortgages: 50% risk weight, Commercial real estate: 100-150% risk weight, Consumer loans: 75-100% risk weight, Cash and US Treasuries: 0% risk weight.\n\n4. STRESS TESTING\nCathay General Bancorp conducts annual company-run stress tests under baseline, adverse, and severely adverse scenarios per Dodd-Frank Act requirements.\n\n5. CAPITAL PLANNING\nThe bank maintains capital levels well above regulatory minimums with target ratios: CET1: >10%, Tier 1: >11%, Total Capital: >13%.',
 'Basel III capital adequacy framework covering capital composition, minimum requirements, risk-weighted asset calculations, and stress testing for Cathay General Bancorp.', '2024-03-31', '2024-Q1', 'Active', 'Basel III,Capital,CET1,RWA,Stress Test'),

('HMDA Fair Lending Analysis Report', 'Analysis Report', 'CFPB', 'Home Mortgage Disclosure Act',
 'Cathay Bank HMDA Fair Lending Analysis\n\n1. OVERVIEW\nAnnual analysis of mortgage lending data per HMDA requirements (Regulation C). This report examines lending patterns across protected classes to ensure fair lending compliance.\n\n2. APPLICATION VOLUME\nTotal applications processed in the reporting period by type: Home Purchase (45%), Refinance (35%), Home Improvement (10%), Other (10%).\n\n3. APPROVAL RATES\nOverall approval rate: 72%. Analysis by applicant characteristics shows no statistically significant disparities after controlling for creditworthiness factors including credit score, DTI ratio, LTV ratio, and employment stability.\n\n4. PRICING ANALYSIS\nRate spread analysis shows pricing decisions are driven by risk-based factors. No evidence of disparate pricing based on prohibited characteristics.\n\n5. GEOGRAPHIC DISTRIBUTION\nLending activity distribution across assessment areas with particular focus on LMI census tracts. Cathay Bank maintains strong lending presence in majority-minority neighborhoods consistent with its community-focused mission.\n\n6. MONITORING PROGRAM\nOngoing fair lending monitoring includes: statistical regression analysis, matched-pair testing, complaint tracking, training and awareness programs.',
 'HMDA fair lending analysis covering application volumes, approval rates, pricing analysis, and geographic distribution for Cathay Bank mortgage lending.', '2024-03-31', '2024', 'Active', 'HMDA,Fair Lending,Mortgage,Discrimination,ECOA'),

('Enterprise Risk Management Framework', 'Framework', 'OCC/Federal Reserve', 'Enterprise Risk',
 'Cathay Bank Enterprise Risk Management Framework\n\n1. RISK GOVERNANCE\nThree lines of defense model: First Line - Business units own and manage risks, Second Line - Risk Management and Compliance provide oversight, Third Line - Internal Audit provides independent assurance.\n\n2. RISK APPETITE STATEMENT\nCathay Bank maintains a moderate risk appetite focused on relationship banking within its core markets. Key risk appetite metrics: Credit losses < 0.50% of average loans, Capital ratios > regulatory minimums + 200bps buffer, Liquidity coverage ratio > 120%, Operational loss events < $5M annually.\n\n3. CREDIT RISK MANAGEMENT\nLoan portfolio managed through: concentration limits by industry, geography, and borrower, stress testing of major portfolio segments, independent loan review function, early warning indicator monitoring.\n\n4. MARKET RISK MANAGEMENT\nInterest rate risk managed through: asset-liability committee (ALCO) oversight, EVE and NII sensitivity analysis, investment portfolio duration management.\n\n5. OPERATIONAL RISK MANAGEMENT\nOperational risk events tracked and reported through: loss event database, key risk indicators (KRIs), risk and control self-assessments (RCSAs), business continuity and disaster recovery plans.\n\n6. COMPLIANCE RISK\nCompliance risk program covers: regulatory change management, compliance testing and monitoring, regulatory examination management, compliance training programs.\n\n7. CYBER AND INFORMATION SECURITY\nInformation security program includes: multi-layered defense architecture, 24/7 security operations center monitoring, regular penetration testing, vendor risk management, employee security awareness training.',
 'Enterprise risk management framework covering governance, risk appetite, credit risk, market risk, operational risk, compliance risk, and cybersecurity for Cathay Bank.', '2024-01-01', '5.0', 'Active', 'ERM,Credit Risk,Market Risk,Operational Risk,Cyber,Governance'),

('Regulation E Consumer Protection Procedures', 'Procedure Manual', 'CFPB', 'Regulation E',
 'Cathay Bank Regulation E Compliance Procedures\n\n1. ELECTRONIC FUND TRANSFER DISCLOSURES\nInitial disclosures provided at account opening covering: types of EFTs available, fees and charges, consumer liability for unauthorized transfers, error resolution procedures, right to stop payment on preauthorized transfers.\n\n2. ERROR RESOLUTION\nUpon receipt of error notice: Investigate within 10 business days (20 for new accounts), provide provisional credit within 10 business days if investigation extends to 45 days, resolve and notify consumer within 45 days (90 days for new accounts, POS transactions, and foreign-initiated transfers).\n\n3. UNAUTHORIZED TRANSFER LIABILITY\nConsumer liability limits: $0 if reported before transfer, $50 if reported within 2 business days, $500 if reported within 60 days of statement, unlimited if not reported within 60 days.\n\n4. REMITTANCE TRANSFERS\nFor international remittances over $15: provide pre-payment disclosure with exchange rate and fees, provide receipt with cancellation rights, error resolution within 90 days.',
 'Regulation E compliance procedures covering EFT disclosures, error resolution timelines, unauthorized transfer liability limits, and remittance transfer requirements.', '2024-01-01', '3.0', 'Active', 'Reg E,EFT,Consumer Protection,Error Resolution,Remittance'),

('Interest Rate Risk Management Policy', 'Policy', 'OCC', 'Interest Rate Risk',
 'Cathay Bank Interest Rate Risk Management Policy\n\n1. POLICY OBJECTIVE\nManage interest rate risk within established limits to protect net interest income (NII) and economic value of equity (EVE) from adverse interest rate movements.\n\n2. RISK MEASUREMENT\nIRR measured using: NII sensitivity (+/-100, 200, 300, 400 bps), EVE sensitivity (+/-100, 200, 300, 400 bps), gap analysis by repricing bucket, option risk assessment (caps, floors, prepayments).\n\n3. RISK LIMITS\nBoard-approved limits: NII change < +/-10% for +/-200 bps shock, EVE change < +/-15% for +/-200 bps shock, investment portfolio duration: 2-5 years.\n\n4. ALCO OVERSIGHT\nAsset-Liability Committee meets monthly to review: current IRR position, balance sheet composition trends, pricing strategies, hedging recommendations, economic and rate outlook.',
 'Interest rate risk management policy covering measurement methodology, risk limits, ALCO oversight, and hedging strategies for Cathay Bank.', '2024-01-01', '4.0', 'Active', 'IRR,ALCO,NII,EVE,Interest Rate'),

('Vendor Risk Management Program', 'Program Manual', 'OCC', 'Third-Party Risk',
 'Cathay Bank Vendor Risk Management Program\n\n1. VENDOR CLASSIFICATION\nVendors classified by criticality: Critical - core banking, payment processing, cloud infrastructure; High - data analytics, cybersecurity tools, loan origination; Medium - office supplies, marketing services; Low - incidental services.\n\n2. DUE DILIGENCE REQUIREMENTS\nCritical vendors: full financial review, SOC 2 Type II audit, on-site assessment, BCP review, information security assessment. High vendors: financial review, SOC 2 report, security questionnaire. Medium/Low: basic financial and reference checks.\n\n3. ONGOING MONITORING\nCritical vendors reviewed annually. Performance metrics tracked quarterly. Contractual SLAs monitored monthly.\n\n4. CONCENTRATION RISK\nConcentration limits for critical services. Business continuity plans for vendor failure scenarios. Exit strategies documented for all critical vendor relationships.',
 'Vendor risk management program covering classification, due diligence requirements, ongoing monitoring, and concentration risk for Cathay Bank third-party relationships.', '2024-01-01', '3.0', 'Active', 'Vendor,Third-Party,Due Diligence,SOC 2,Concentration');
