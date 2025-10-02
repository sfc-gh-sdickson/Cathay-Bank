/*
  _____ _   _____ _   _   ___   __   ____    _   _   _ _  __
 / ____| | |_   _| | | | / \ \ / /  |  _ \  / \ | \ | | |/ /
| |    | |   | | | |_| |/ _ \ V /   | |_) |/ _ \|  \| | ' / 
| |    | |   | | |  _  / ___ \| |    |  _ </ ___ \ |\  | . \ 
| |____| |___| |_| | |/_/   \_\_|    |_| \_\_/   \_| \_|_|\_\
 \_____|_____|_|_|_|                                          

Snowflake Intelligence Demo - Cathay Bank
Semantic Views and Analytics Creation Script

This script creates:
1. Analytics views that aggregate and transform raw data
2. A comprehensive semantic view for Snowflake Intelligence

Run Time: < 2 minutes
*/

-- Ensure we're in the right context
-- USE ROLE CATHAY_DEMO_ROLE;
USE WAREHOUSE CATHAY_DEMO_WH;
USE DATABASE CATHAY_BANK_DEMO;
USE SCHEMA ANALYTICS;

-- ============================================================================
-- ANALYTICS VIEWS
-- ============================================================================

-- Customer 360 View
CREATE OR REPLACE VIEW V_CUSTOMER_360 AS
SELECT 
    c.customer_id,
    c.customer_type,
    c.first_name,
    c.last_name,
    c.business_name,
    COALESCE(c.business_name, c.first_name || ' ' || c.last_name) AS full_name,
    c.date_of_birth,
    DATEDIFF('year', c.date_of_birth, CURRENT_DATE()) AS age,
    CASE 
        WHEN age < 25 THEN 'Gen Z'
        WHEN age < 40 THEN 'Millennial'
        WHEN age < 55 THEN 'Gen X'
        WHEN age < 75 THEN 'Boomer'
        ELSE 'Silent'
    END AS generation,
    c.email,
    c.phone_primary,
    c.city,
    c.state,
    c.zip_code,
    c.primary_branch_id,
    b.branch_name,
    c.customer_since,
    DATEDIFF('month', c.customer_since, CURRENT_DATE()) AS tenure_months,
    c.preferred_language,
    c.annual_income_range,
    c.credit_score_range,
    c.risk_rating,
    c.is_vip,
    c.marketing_consent,
    -- Account metrics
    COUNT(DISTINCT a.account_id) AS num_accounts,
    COUNT(DISTINCT CASE WHEN a.account_status = 'Active' THEN a.account_id END) AS num_active_accounts,
    SUM(CASE WHEN a.account_status = 'Active' THEN a.current_balance ELSE 0 END) AS total_deposit_balance,
    -- Loan metrics
    COUNT(DISTINCT l.loan_id) AS num_loans,
    COUNT(DISTINCT CASE WHEN l.loan_status = 'Current' THEN l.loan_id END) AS num_active_loans,
    SUM(CASE WHEN l.loan_status IN ('Current', 'Late') THEN l.current_balance ELSE 0 END) AS total_loan_balance,
    -- Credit card metrics
    COUNT(DISTINCT cc.card_id) AS num_credit_cards,
    COUNT(DISTINCT CASE WHEN cc.card_status = 'Active' THEN cc.card_id END) AS num_active_cards,
    SUM(CASE WHEN cc.card_status = 'Active' THEN cc.current_balance ELSE 0 END) AS total_credit_balance,
    SUM(CASE WHEN cc.card_status = 'Active' THEN cc.credit_limit ELSE 0 END) AS total_credit_limit,
    -- Digital engagement
    MAX(du.is_mobile_enrolled) AS is_digital_user,
    MAX(du.is_mobile_enrolled) AS is_mobile_user,
    MAX(du.last_login_timestamp) AS last_digital_login,
    -- Lifetime value
    total_deposit_balance - total_loan_balance - total_credit_balance AS net_balance,
    CASE 
        WHEN num_active_accounts + num_active_loans + num_active_cards >= 4 THEN 'Full Relationship'
        WHEN num_active_accounts + num_active_loans + num_active_cards >= 2 THEN 'Growing Relationship'
        WHEN num_active_accounts + num_active_loans + num_active_cards = 1 THEN 'Single Product'
        ELSE 'Inactive'
    END AS relationship_depth
FROM RAW.CUSTOMERS c
LEFT JOIN RAW.BRANCHES b ON c.primary_branch_id = b.branch_id
LEFT JOIN RAW.ACCOUNTS a ON c.customer_id = a.customer_id
LEFT JOIN RAW.LOANS l ON c.customer_id = l.customer_id
LEFT JOIN RAW.CREDIT_CARDS cc ON c.customer_id = cc.customer_id
LEFT JOIN RAW.DIGITAL_USERS du ON c.customer_id = du.customer_id
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24;

-- Account Summary View
CREATE OR REPLACE VIEW V_ACCOUNT_SUMMARY AS
SELECT 
    a.account_id,
    a.account_number,
    a.customer_id,
    c.full_name AS customer_name,
    a.product_id,
    p.product_name,
    a.account_type,
    a.account_subtype,
    a.account_status,
    a.opening_date,
    a.branch_id,
    b.branch_name,
    a.current_balance,
    a.available_balance,
    a.interest_rate,
    a.last_activity_date,
    DATEDIFF('day', a.last_activity_date, CURRENT_DATE()) AS days_since_activity,
    CASE 
        WHEN days_since_activity > 180 THEN 'Dormant'
        WHEN days_since_activity > 90 THEN 'Low Activity'
        WHEN days_since_activity > 30 THEN 'Moderate Activity'
        ELSE 'High Activity'
    END AS activity_level,
    a.is_primary_account,
    -- Monthly averages
    AVG(a.current_balance) OVER (
        PARTITION BY a.account_id 
        ORDER BY CURRENT_DATE() 
        ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
    ) AS avg_balance_30d,
    -- Year over year growth
    LAG(a.current_balance, 365) OVER (
        PARTITION BY a.account_id 
        ORDER BY CURRENT_DATE()
    ) AS balance_1y_ago,
    CASE 
        WHEN balance_1y_ago > 0 THEN 
            ((a.current_balance - balance_1y_ago) / balance_1y_ago) * 100
        ELSE NULL 
    END AS balance_growth_pct
FROM RAW.ACCOUNTS a
JOIN ANALYTICS.V_CUSTOMER_360 c ON a.customer_id = c.customer_id
LEFT JOIN RAW.PRODUCTS p ON a.product_id = p.product_id
LEFT JOIN RAW.BRANCHES b ON a.branch_id = b.branch_id;

-- Transaction Analytics View
CREATE OR REPLACE VIEW V_TRANSACTION_ANALYTICS AS
SELECT 
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.transaction_timestamp,
    DATE_TRUNC('month', t.transaction_date) AS transaction_month,
    DATE_TRUNC('quarter', t.transaction_date) AS transaction_quarter,
    YEAR(t.transaction_date) AS transaction_year,
    t.transaction_type,
    t.transaction_category,
    t.transaction_subcategory,
    t.amount,
    ABS(t.amount) AS amount_absolute,
    t.balance_after,
    t.description,
    t.merchant_name,
    t.merchant_category,
    t.channel,
    t.is_international,
    t.fraud_score,
    CASE 
        WHEN t.fraud_score > 0.8 THEN 'High Risk'
        WHEN t.fraud_score > 0.5 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS fraud_risk_level,
    -- Time-based features
    HOUR(t.transaction_timestamp) AS transaction_hour,
    DAYOFWEEK(t.transaction_date) AS transaction_dow,
    CASE 
        WHEN transaction_dow IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    CASE 
        WHEN transaction_hour BETWEEN 6 AND 11 THEN 'Morning'
        WHEN transaction_hour BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN transaction_hour BETWEEN 18 AND 22 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    -- Running totals
    SUM(t.amount) OVER (
        PARTITION BY t.account_id 
        ORDER BY t.transaction_timestamp
    ) AS running_balance,
    COUNT(*) OVER (
        PARTITION BY t.account_id, DATE_TRUNC('month', t.transaction_date)
    ) AS monthly_transaction_count,
    SUM(CASE WHEN t.amount > 0 THEN t.amount ELSE 0 END) OVER (
        PARTITION BY t.account_id, DATE_TRUNC('month', t.transaction_date)
    ) AS monthly_deposits,
    SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) OVER (
        PARTITION BY t.account_id, DATE_TRUNC('month', t.transaction_date)
    ) AS monthly_withdrawals
FROM RAW.TRANSACTIONS t;

-- Loan Portfolio View
CREATE OR REPLACE VIEW V_LOAN_PORTFOLIO AS
SELECT 
    l.loan_id,
    l.loan_number,
    l.customer_id,
    c.full_name AS customer_name,
    c.credit_score_range,
    c.annual_income_range,
    l.product_id,
    p.product_name,
    l.loan_type,
    l.loan_purpose,
    l.original_amount,
    l.current_balance,
    l.interest_rate,
    l.term_months,
    l.monthly_payment,
    l.origination_date,
    l.maturity_date,
    l.next_payment_date,
    l.days_past_due,
    l.loan_status,
    l.collateral_type,
    l.collateral_value,
    l.ltv_ratio,
    l.branch_id,
    b.branch_name,
    -- Calculated metrics
    l.original_amount - l.current_balance AS amount_paid,
    CASE 
        WHEN l.original_amount > 0 THEN 
            ((l.original_amount - l.current_balance) / l.original_amount) * 100
        ELSE 0 
    END AS percent_paid,
    DATEDIFF('month', l.origination_date, CURRENT_DATE()) AS loan_age_months,
    DATEDIFF('month', CURRENT_DATE(), l.maturity_date) AS months_to_maturity,
    l.monthly_payment * l.term_months AS total_expected_payments,
    (l.monthly_payment * l.term_months) - l.original_amount AS total_expected_interest,
    -- Risk indicators
    CASE 
        WHEN l.days_past_due = 0 THEN 'Performing'
        WHEN l.days_past_due <= 30 THEN 'Watch'
        WHEN l.days_past_due <= 90 THEN 'Substandard'
        ELSE 'Doubtful'
    END AS risk_classification,
    l.times_30_days_late + l.times_60_days_late + l.times_90_days_late AS total_late_payments,
    -- Profitability estimate
    CASE 
        WHEN l.loan_status = 'Current' THEN l.current_balance * (l.interest_rate / 12)
        ELSE 0 
    END AS estimated_monthly_interest_income
FROM RAW.LOANS l
JOIN ANALYTICS.V_CUSTOMER_360 c ON l.customer_id = c.customer_id
LEFT JOIN RAW.PRODUCTS p ON l.product_id = p.product_id
LEFT JOIN RAW.BRANCHES b ON l.branch_id = b.branch_id;

-- Credit Card Analytics View
CREATE OR REPLACE VIEW V_CREDIT_CARD_ANALYTICS AS
SELECT 
    cc.card_id,
    cc.account_id,
    cc.customer_id,
    c.full_name AS customer_name,
    c.credit_score_range,
    cc.card_type,
    cc.card_tier,
    cc.credit_limit,
    cc.current_balance,
    cc.available_credit,
    cc.interest_rate_purchase,
    cc.annual_fee,
    cc.reward_program,
    cc.issue_date,
    cc.last_used_date,
    cc.card_status,
    -- Utilization metrics
    CASE 
        WHEN cc.credit_limit > 0 THEN (cc.current_balance / cc.credit_limit) * 100
        ELSE 0 
    END AS utilization_rate,
    CASE 
        WHEN utilization_rate > 90 THEN 'Over Limit'
        WHEN utilization_rate > 70 THEN 'High'
        WHEN utilization_rate > 30 THEN 'Moderate'
        ELSE 'Low'
    END AS utilization_category,
    -- Age and activity
    DATEDIFF('month', cc.issue_date, CURRENT_DATE()) AS card_age_months,
    DATEDIFF('day', cc.last_used_date, CURRENT_DATE()) AS days_since_last_use,
    -- Revenue estimation
    CASE 
        WHEN cc.current_balance > 0 THEN 
            (cc.current_balance * cc.interest_rate_purchase / 12) + (cc.annual_fee / 12)
        ELSE cc.annual_fee / 12
    END AS estimated_monthly_revenue,
    -- Spend analysis (from transactions)
    t.monthly_purchase_volume,
    t.monthly_transaction_count,
    t.avg_transaction_amount
FROM RAW.CREDIT_CARDS cc
JOIN ANALYTICS.V_CUSTOMER_360 c ON cc.customer_id = c.customer_id
LEFT JOIN (
    SELECT 
        ct.card_id,
        AVG(ABS(t.amount)) AS avg_transaction_amount,
        COUNT(*) / COUNT(DISTINCT DATE_TRUNC('month', t.transaction_date)) AS monthly_transaction_count,
        SUM(ABS(t.amount)) / COUNT(DISTINCT DATE_TRUNC('month', t.transaction_date)) AS monthly_purchase_volume
    FROM RAW.CARD_TRANSACTIONS ct
    JOIN RAW.TRANSACTIONS t ON ct.transaction_id = t.transaction_id
    WHERE t.transaction_type = 'Purchase'
      AND t.transaction_date >= DATEADD('month', -12, CURRENT_DATE())
    GROUP BY ct.card_id
) t ON cc.card_id = t.card_id;

-- Branch Performance View
CREATE OR REPLACE VIEW V_BRANCH_PERFORMANCE AS
SELECT 
    b.branch_id,
    b.branch_name,
    b.branch_type,
    b.city,
    b.state,
    b.opening_date,
    DATEDIFF('year', b.opening_date, CURRENT_DATE()) AS branch_age_years,
    -- Customer metrics
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN c.customer_since >= DATEADD('month', -12, CURRENT_DATE()) THEN c.customer_id END) AS new_customers_12m,
    -- Account metrics
    COUNT(DISTINCT a.account_id) AS total_accounts,
    SUM(a.current_balance) AS total_deposits,
    AVG(a.current_balance) AS avg_account_balance,
    -- Loan metrics
    COUNT(DISTINCT l.loan_id) AS total_loans,
    SUM(l.original_amount) AS total_loan_originations,
    SUM(l.current_balance) AS total_loan_balance,
    AVG(l.interest_rate) AS avg_loan_rate,
    -- Service metrics
    COUNT(DISTINCT sr.request_id) AS total_service_requests,
    AVG(sr.satisfaction_score) AS avg_satisfaction_score,
    -- Transaction activity
    t.monthly_transaction_volume,
    t.monthly_transaction_count,
    -- Efficiency metrics
    total_deposits / NULLIF(total_customers, 0) AS deposits_per_customer,
    total_loan_balance / NULLIF(total_customers, 0) AS loans_per_customer,
    -- Growth metrics
    (new_customers_12m / NULLIF(total_customers, 0)) * 100 AS customer_growth_rate
FROM RAW.BRANCHES b
LEFT JOIN RAW.CUSTOMERS c ON b.branch_id = c.primary_branch_id
LEFT JOIN RAW.ACCOUNTS a ON b.branch_id = a.branch_id AND a.account_status = 'Active'
LEFT JOIN RAW.LOANS l ON b.branch_id = l.branch_id AND l.loan_status IN ('Current', 'Late')
LEFT JOIN RAW.SERVICE_REQUESTS sr ON b.branch_id = sr.branch_id
LEFT JOIN (
    SELECT 
        a.branch_id,
        COUNT(*) / 12 AS monthly_transaction_count,
        SUM(ABS(t.amount)) / 12 AS monthly_transaction_volume
    FROM RAW.TRANSACTIONS t
    JOIN RAW.ACCOUNTS a ON t.account_id = a.account_id
    WHERE t.transaction_date >= DATEADD('month', -12, CURRENT_DATE())
    GROUP BY a.branch_id
) t ON b.branch_id = t.branch_id
GROUP BY 1,2,3,4,5,6,7,19,20;

-- Digital Banking Analytics View
CREATE OR REPLACE VIEW V_DIGITAL_BANKING_ANALYTICS AS
SELECT 
    du.user_id,
    du.customer_id,
    c.full_name AS customer_name,
    c.age,
    c.generation,
    du.enrollment_date,
    DATEDIFF('month', du.enrollment_date, CURRENT_DATE()) AS digital_tenure_months,
    du.last_login_timestamp,
    DATEDIFF('day', du.last_login_timestamp, CURRENT_DATE()) AS days_since_login,
    du.login_count,
    du.login_count / NULLIF(digital_tenure_months, 0) AS avg_monthly_logins,
    du.preferred_channel,
    du.is_mobile_enrolled,
    du.is_text_banking_enrolled,
    du.is_paperless,
    du.two_factor_enabled,
    du.biometric_enabled,
    -- Engagement level
    CASE 
        WHEN days_since_login <= 7 AND avg_monthly_logins > 10 THEN 'Highly Engaged'
        WHEN days_since_login <= 30 AND avg_monthly_logins > 4 THEN 'Engaged'
        WHEN days_since_login <= 90 THEN 'Moderate'
        ELSE 'Low Engagement'
    END AS engagement_level,
    -- Digital transaction metrics
    dt.digital_transaction_count,
    dt.digital_transaction_volume,
    dt.pct_digital_transactions
FROM RAW.DIGITAL_USERS du
JOIN ANALYTICS.V_CUSTOMER_360 c ON du.customer_id = c.customer_id
LEFT JOIN (
    SELECT 
        c.customer_id,
        COUNT(CASE WHEN t.channel IN ('Online', 'Mobile') THEN 1 END) AS digital_transaction_count,
        SUM(CASE WHEN t.channel IN ('Online', 'Mobile') THEN ABS(t.amount) END) AS digital_transaction_volume,
        COUNT(CASE WHEN t.channel IN ('Online', 'Mobile') THEN 1 END) * 100.0 / 
            NULLIF(COUNT(*), 0) AS pct_digital_transactions
    FROM RAW.TRANSACTIONS t
    JOIN RAW.ACCOUNTS a ON t.account_id = a.account_id
    JOIN RAW.CUSTOMERS c ON a.customer_id = c.customer_id
    WHERE t.transaction_date >= DATEADD('month', -12, CURRENT_DATE())
    GROUP BY c.customer_id
) dt ON du.customer_id = dt.customer_id;

-- Service Quality View
CREATE OR REPLACE VIEW V_SERVICE_QUALITY AS
SELECT 
    sr.request_id,
    sr.customer_id,
    c.full_name AS customer_name,
    c.is_vip,
    sr.request_type,
    sr.request_category,
    sr.channel,
    sr.priority,
    sr.status,
    sr.branch_id,
    b.branch_name,
    sr.created_date,
    sr.created_timestamp,
    sr.resolved_timestamp,
    -- Resolution metrics
    DATEDIFF('hour', sr.created_timestamp, sr.resolved_timestamp) AS resolution_hours,
    CASE 
        WHEN sr.priority = 'Critical' AND resolution_hours <= 4 THEN TRUE
        WHEN sr.priority = 'High' AND resolution_hours <= 24 THEN TRUE
        WHEN sr.priority = 'Medium' AND resolution_hours <= 48 THEN TRUE
        WHEN sr.priority = 'Low' AND resolution_hours <= 72 THEN TRUE
        ELSE FALSE
    END AS within_sla,
    sr.satisfaction_score,
    -- Time-based groupings
    DATE_TRUNC('week', sr.created_date) AS week_created,
    DATE_TRUNC('month', sr.created_date) AS month_created,
    HOUR(sr.created_timestamp) AS hour_created,
    CASE 
        WHEN DAYOFWEEK(sr.created_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM RAW.SERVICE_REQUESTS sr
JOIN ANALYTICS.V_CUSTOMER_360 c ON sr.customer_id = c.customer_id
LEFT JOIN RAW.BRANCHES b ON sr.branch_id = b.branch_id;

-- Marketing Campaign Performance View
CREATE OR REPLACE VIEW V_MARKETING_PERFORMANCE AS
SELECT 
    mc.campaign_id,
    mc.campaign_name,
    mc.campaign_type,
    mc.product_id,
    p.product_name,
    mc.target_segment,
    mc.start_date,
    mc.end_date,
    mc.budget,
    mc.status,
    -- Response metrics
    COUNT(cr.response_id) AS total_responses,
    COUNT(DISTINCT cr.customer_id) AS unique_responders,
    COUNT(CASE WHEN cr.response_type = 'Click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN cr.response_type = 'Call' THEN 1 END) AS calls,
    COUNT(CASE WHEN cr.response_type = 'Visit' THEN 1 END) AS visits,
    COUNT(CASE WHEN cr.conversion_flag THEN 1 END) AS conversions,
    SUM(cr.conversion_amount) AS total_conversion_value,
    -- Performance metrics
    unique_responders * 100.0 / NULLIF(mc.budget / 10, 0) AS response_rate, -- Assuming $10 per target
    conversions * 100.0 / NULLIF(unique_responders, 0) AS conversion_rate,
    total_conversion_value / NULLIF(mc.budget, 0) AS roi,
    mc.budget / NULLIF(conversions, 0) AS cost_per_acquisition,
    total_conversion_value / NULLIF(conversions, 0) AS avg_conversion_value
FROM RAW.MARKETING_CAMPAIGNS mc
LEFT JOIN RAW.CAMPAIGN_RESPONSES cr ON mc.campaign_id = cr.campaign_id
LEFT JOIN RAW.PRODUCTS p ON mc.product_id = p.product_id
GROUP BY 1,2,3,4,5,6,7,8,9,10;

-- Risk Analytics View
CREATE OR REPLACE VIEW V_RISK_ANALYTICS AS
SELECT 
    c.customer_id,
    COALESCE(c.business_name, c.first_name || ' ' || c.last_name) AS customer_name,
    c.customer_type,
    c.risk_rating AS kyc_risk_rating,
    c.credit_score_range,
    c.annual_income_range,
    -- Deposit risk indicators
    a.total_deposit_balance,
    a.large_deposit_concentration,
    a.dormant_account_count,
    -- Loan risk indicators
    l.total_loan_exposure,
    l.weighted_avg_days_past_due,
    l.delinquent_loan_count,
    l.total_late_payments,
    -- Transaction risk indicators
    t.high_risk_transaction_count,
    t.unusual_activity_score,
    t.international_transaction_volume,
    -- Overall risk score
    CASE 
        WHEN c.risk_rating = 'HIGH' OR l.weighted_avg_days_past_due > 30 OR t.unusual_activity_score > 0.7 THEN 'High'
        WHEN c.risk_rating = 'MEDIUM' OR l.weighted_avg_days_past_due > 0 OR t.unusual_activity_score > 0.4 THEN 'Medium'
        ELSE 'Low'
    END AS overall_risk_level,
    -- Compliance flags
    t.large_cash_transaction_flag,
    t.structuring_alert_flag,
    a.pep_flag
FROM RAW.CUSTOMERS c
LEFT JOIN (
    SELECT 
        customer_id,
        SUM(current_balance) AS total_deposit_balance,
        MAX(current_balance) / NULLIF(SUM(current_balance), 0) AS large_deposit_concentration,
        COUNT(CASE WHEN DATEDIFF('day', last_activity_date, CURRENT_DATE()) > 180 THEN 1 END) AS dormant_account_count,
        MAX(CASE WHEN current_balance > 250000 THEN TRUE ELSE FALSE END) AS pep_flag
    FROM RAW.ACCOUNTS
    WHERE account_status = 'Active'
    GROUP BY customer_id
) a ON c.customer_id = a.customer_id
LEFT JOIN (
    SELECT 
        customer_id,
        SUM(current_balance) AS total_loan_exposure,
        SUM(current_balance * days_past_due) / NULLIF(SUM(current_balance), 0) AS weighted_avg_days_past_due,
        COUNT(CASE WHEN loan_status IN ('Delinquent', 'Default') THEN 1 END) AS delinquent_loan_count,
        SUM(times_30_days_late + times_60_days_late + times_90_days_late) AS total_late_payments
    FROM RAW.LOANS
    WHERE loan_status != 'Paid Off'
    GROUP BY customer_id
) l ON c.customer_id = l.customer_id
LEFT JOIN (
    SELECT 
        c.customer_id,
        COUNT(CASE WHEN t.fraud_score > 0.5 THEN 1 END) AS high_risk_transaction_count,
        AVG(t.fraud_score) AS unusual_activity_score,
        SUM(CASE WHEN t.is_international THEN ABS(t.amount) END) AS international_transaction_volume,
        MAX(CASE WHEN t.transaction_subcategory = 'Cash' AND ABS(t.amount) > 10000 THEN TRUE ELSE FALSE END) AS large_cash_transaction_flag,
        MAX(CASE WHEN cash_transactions.structured_flag THEN TRUE ELSE FALSE END) AS structuring_alert_flag
    FROM RAW.TRANSACTIONS t
    JOIN RAW.ACCOUNTS a ON t.account_id = a.account_id
    JOIN RAW.CUSTOMERS c ON a.customer_id = c.customer_id
    LEFT JOIN (
        SELECT 
            a.customer_id,
            DATE_TRUNC('day', t.transaction_date) AS transaction_day,
            SUM(CASE WHEN t.transaction_subcategory = 'Cash' THEN ABS(t.amount) END) AS daily_cash_total,
            CASE WHEN daily_cash_total BETWEEN 9000 AND 10000 THEN TRUE ELSE FALSE END AS structured_flag
        FROM RAW.TRANSACTIONS t
        JOIN RAW.ACCOUNTS a ON t.account_id = a.account_id
        WHERE t.transaction_date >= DATEADD('month', -12, CURRENT_DATE())
        GROUP BY 1, 2
    ) cash_transactions ON c.customer_id = cash_transactions.customer_id
    WHERE t.transaction_date >= DATEADD('month', -12, CURRENT_DATE())
    GROUP BY c.customer_id
) t ON c.customer_id = t.customer_id;

-- ============================================================================
-- GRANT PERMISSIONS ON ANALYTICS VIEWS
-- ============================================================================

-- Grant SELECT on all views to the demo role
-- GRANT SELECT ON ALL VIEWS IN SCHEMA ANALYTICS TO ROLE CATHAY_DEMO_ROLE;

-- ============================================================================
-- CREATE SEMANTIC VIEW FOR SNOWFLAKE INTELLIGENCE
-- ============================================================================

-- Switch to analytics schema
USE SCHEMA ANALYTICS;

-- Create comprehensive semantic view
CREATE OR REPLACE SEMANTIC VIEW CATHAY_BANK_SEMANTIC_MODEL
  TABLES (
    -- Customer entities
    customers AS CATHAY_BANK_DEMO.RAW.CUSTOMERS PRIMARY KEY (customer_id),
    customer_segments AS CATHAY_BANK_DEMO.RAW.CUSTOMER_SEGMENTS PRIMARY KEY (customer_id, segment_type, effective_date),
    
    -- Account entities
    accounts AS CATHAY_BANK_DEMO.RAW.ACCOUNTS PRIMARY KEY (account_id),
    account_relationships AS CATHAY_BANK_DEMO.RAW.ACCOUNT_RELATIONSHIPS PRIMARY KEY (account_id, customer_id),
    
    -- Transaction entities
    transactions AS CATHAY_BANK_DEMO.RAW.TRANSACTIONS PRIMARY KEY (transaction_id),
    card_transactions AS CATHAY_BANK_DEMO.RAW.CARD_TRANSACTIONS PRIMARY KEY (card_transaction_id),
    
    -- Loan entities
    loans AS CATHAY_BANK_DEMO.RAW.LOANS PRIMARY KEY (loan_id),
    loan_payments AS CATHAY_BANK_DEMO.RAW.LOAN_PAYMENTS PRIMARY KEY (payment_id),
    
    -- Credit card entities
    credit_cards AS CATHAY_BANK_DEMO.RAW.CREDIT_CARDS PRIMARY KEY (card_id),
    
    -- Digital banking entities
    digital_users AS CATHAY_BANK_DEMO.RAW.DIGITAL_USERS PRIMARY KEY (user_id),
    digital_sessions AS CATHAY_BANK_DEMO.RAW.DIGITAL_SESSIONS PRIMARY KEY (session_id),
    
    -- Service entities
    service_requests AS CATHAY_BANK_DEMO.RAW.SERVICE_REQUESTS PRIMARY KEY (request_id),
    
    -- Marketing entities
    marketing_campaigns AS CATHAY_BANK_DEMO.RAW.MARKETING_CAMPAIGNS PRIMARY KEY (campaign_id),
    campaign_responses AS CATHAY_BANK_DEMO.RAW.CAMPAIGN_RESPONSES PRIMARY KEY (response_id),
    
    -- Reference entities
    branches AS CATHAY_BANK_DEMO.RAW.BRANCHES PRIMARY KEY (branch_id),
    atms AS CATHAY_BANK_DEMO.RAW.ATMS PRIMARY KEY (atm_id),
    products AS CATHAY_BANK_DEMO.RAW.PRODUCTS PRIMARY KEY (product_id),
    employees AS CATHAY_BANK_DEMO.RAW.EMPLOYEES PRIMARY KEY (employee_id),
    
    -- Analytics views
    customer_360 AS CATHAY_BANK_DEMO.ANALYTICS.V_CUSTOMER_360 PRIMARY KEY (customer_id),
    account_summary AS CATHAY_BANK_DEMO.ANALYTICS.V_ACCOUNT_SUMMARY PRIMARY KEY (account_id),
    transaction_analytics AS CATHAY_BANK_DEMO.ANALYTICS.V_TRANSACTION_ANALYTICS PRIMARY KEY (transaction_id),
    loan_portfolio AS CATHAY_BANK_DEMO.ANALYTICS.V_LOAN_PORTFOLIO PRIMARY KEY (loan_id),
    credit_card_analytics AS CATHAY_BANK_DEMO.ANALYTICS.V_CREDIT_CARD_ANALYTICS PRIMARY KEY (card_id),
    branch_performance AS CATHAY_BANK_DEMO.ANALYTICS.V_BRANCH_PERFORMANCE PRIMARY KEY (branch_id),
    digital_banking_analytics AS CATHAY_BANK_DEMO.ANALYTICS.V_DIGITAL_BANKING_ANALYTICS PRIMARY KEY (user_id),
    service_quality AS CATHAY_BANK_DEMO.ANALYTICS.V_SERVICE_QUALITY PRIMARY KEY (request_id),
    marketing_performance AS CATHAY_BANK_DEMO.ANALYTICS.V_MARKETING_PERFORMANCE PRIMARY KEY (campaign_id),
    risk_analytics AS CATHAY_BANK_DEMO.ANALYTICS.V_RISK_ANALYTICS PRIMARY KEY (customer_id)
  )
  RELATIONSHIPS (
    -- Customer relationships
    accounts_to_customers AS accounts(customer_id) REFERENCES customers(customer_id),
    loans_to_customers AS loans(customer_id) REFERENCES customers(customer_id),
    credit_cards_to_customers AS credit_cards(customer_id) REFERENCES customers(customer_id),
    digital_users_to_customers AS digital_users(customer_id) REFERENCES customers(customer_id),
    service_requests_to_customers AS service_requests(customer_id) REFERENCES customers(customer_id),
    campaign_responses_to_customers AS campaign_responses(customer_id) REFERENCES customers(customer_id),
    customer_segments_to_customers AS customer_segments(customer_id) REFERENCES customers(customer_id),
    
    -- Account relationships
    transactions_to_accounts AS transactions(account_id) REFERENCES accounts(account_id),
    account_relationships_to_accounts AS account_relationships(account_id) REFERENCES accounts(account_id),
    account_relationships_to_customers AS account_relationships(customer_id) REFERENCES customers(customer_id),
    credit_cards_to_accounts AS credit_cards(account_id) REFERENCES accounts(account_id),
    
    -- Product relationships
    accounts_to_products AS accounts(product_id) REFERENCES products(product_id),
    loans_to_products AS loans(product_id) REFERENCES products(product_id),
    marketing_campaigns_to_products AS marketing_campaigns(product_id) REFERENCES products(product_id),
    
    -- Branch relationships
    customers_to_branches AS customers(primary_branch_id) REFERENCES branches(branch_id),
    accounts_to_branches AS accounts(branch_id) REFERENCES branches(branch_id),
    loans_to_branches AS loans(branch_id) REFERENCES branches(branch_id),
    service_requests_to_branches AS service_requests(branch_id) REFERENCES branches(branch_id),
    atms_to_branches AS atms(branch_id) REFERENCES branches(branch_id),
    
    -- Transaction relationships
    card_transactions_to_transactions AS card_transactions(transaction_id) REFERENCES transactions(transaction_id),
    card_transactions_to_cards AS card_transactions(card_id) REFERENCES credit_cards(card_id),
    
    -- Loan relationships
    loan_payments_to_loans AS loan_payments(loan_id) REFERENCES loans(loan_id),
    
    -- Digital relationships
    digital_sessions_to_users AS digital_sessions(user_id) REFERENCES digital_users(user_id),
    
    -- Campaign relationships
    campaign_responses_to_campaigns AS campaign_responses(campaign_id) REFERENCES marketing_campaigns(campaign_id),
    
    -- Employee relationships
    branches_to_managers AS branches(manager_employee_id) REFERENCES employees(employee_id),
    service_requests_to_employees AS service_requests(assigned_to) REFERENCES employees(employee_id),
    loans_to_officers AS loans(loan_officer_id) REFERENCES employees(employee_id),
    loans_to_underwriters AS loans(underwriter_id) REFERENCES employees(employee_id),
    
    -- Analytics view relationships
    customer_360_to_customers AS customer_360(customer_id) REFERENCES customers(customer_id),
    account_summary_to_accounts AS account_summary(account_id) REFERENCES accounts(account_id),
    transaction_analytics_to_transactions AS transaction_analytics(transaction_id) REFERENCES transactions(transaction_id),
    loan_portfolio_to_loans AS loan_portfolio(loan_id) REFERENCES loans(loan_id),
    credit_card_analytics_to_cards AS credit_card_analytics(card_id) REFERENCES credit_cards(card_id),
    branch_performance_to_branches AS branch_performance(branch_id) REFERENCES branches(branch_id),
    digital_banking_analytics_to_users AS digital_banking_analytics(user_id) REFERENCES digital_users(user_id),
    service_quality_to_requests AS service_quality(request_id) REFERENCES service_requests(request_id),
    marketing_performance_to_campaigns AS marketing_performance(campaign_id) REFERENCES marketing_campaigns(campaign_id),
    risk_analytics_to_customers AS risk_analytics(customer_id) REFERENCES customers(customer_id)
  )
  DIMENSIONS (
    -- Customer dimensions
    customers.customer_type AS customer_type,
    customers.customer_first_name AS first_name,
    customers.customer_last_name AS last_name,
    customers.business_name AS business_name,
    customers.customer_city AS city,
    customers.customer_state AS state,
    customers.preferred_language AS preferred_language,
    customers.income_range AS annual_income_range,
    customers.credit_score_range AS credit_score_range,
    customers.risk_rating AS risk_rating,
    customers.is_vip_customer AS is_vip,
    
    -- Account dimensions
    accounts.account_type AS account_type,
    accounts.account_subtype AS account_subtype,
    accounts.account_status AS account_status,
    
    -- Transaction dimensions
    transactions.transaction_type AS transaction_type,
    transactions.transaction_category AS transaction_category,
    transactions.transaction_channel AS channel,
    transactions.merchant_category AS merchant_category,
    
    -- Loan dimensions
    loans.loan_type AS loan_type,
    loans.loan_purpose AS loan_purpose,
    loans.loan_status AS loan_status,
    loans.collateral_type AS collateral_type,
    
    -- Credit card dimensions
    credit_cards.card_type AS card_type,
    credit_cards.card_tier AS card_tier,
    credit_cards.card_status AS card_status,
    
    -- Branch dimensions
    branches.branch_name AS branch_name,
    branches.branch_type AS branch_type,
    branches.branch_city AS city,
    branches.branch_state AS state,
    
    -- Product dimensions
    products.product_category AS product_category,
    products.product_type AS product_type,
    products.product_name AS product_name,
    
    -- Service dimensions
    service_requests.service_request_type AS request_type,
    service_requests.service_priority AS priority,
    service_requests.service_status AS status,
    
    -- Marketing dimensions
    marketing_campaigns.campaign_type AS campaign_type,
    marketing_campaigns.campaign_target_segment AS target_segment,
    
    -- Time dimensions
    transactions.transaction_date AS transaction_date,
    accounts.account_opening_date AS opening_date,
    loans.loan_origination_date AS origination_date,
    customers.customer_since_date AS customer_since,
    
    -- Financial amounts (as dimensions for filtering/grouping)
    accounts.account_balance AS current_balance,
    accounts.available_balance AS available_balance,
    transactions.transaction_amount AS amount,
    loans.loan_original_amount AS original_amount,
    loans.loan_current_balance AS current_balance,
    loans.loan_monthly_payment AS monthly_payment,
    credit_cards.credit_limit AS credit_limit,
    credit_cards.credit_card_balance AS current_balance,
    
    -- Rates and ratios
    accounts.account_interest_rate AS interest_rate,
    loans.loan_interest_rate AS interest_rate,
    loans.loan_to_value_ratio AS ltv_ratio,
    credit_cards.credit_card_apr AS interest_rate_purchase,
    
    -- Scores and indicators  
    transactions.transaction_fraud_score AS fraud_score,
    service_requests.service_satisfaction_score AS satisfaction_score,
    loans.loan_days_past_due AS days_past_due,
    digital_users.digital_login_count AS login_count
  )
  METRICS (
    -- Customer metrics
    customers.total_customers AS COUNT(DISTINCT customer_id),
    customers.vip_customers AS COUNT(DISTINCT CASE WHEN is_vip THEN customer_id END),
    customers.business_customers AS COUNT(DISTINCT CASE WHEN customer_type = 'Business' THEN customer_id END),
    
    -- Account metrics
    accounts.total_accounts AS COUNT(DISTINCT account_id),
    accounts.total_deposit_balance AS SUM(current_balance),
    accounts.average_account_balance AS AVG(current_balance),
    
    -- Transaction metrics
    transactions.total_transactions AS COUNT(transaction_id),
    transactions.total_transaction_volume AS SUM(ABS(amount)),
    transactions.average_transaction_amount AS AVG(ABS(amount)),
    transactions.high_risk_transactions AS COUNT(CASE WHEN fraud_score > 0.5 THEN 1 END),
    
    -- Loan metrics
    loans.total_loans AS COUNT(DISTINCT loan_id),
    loans.total_loan_originations AS SUM(original_amount),
    loans.total_loan_balance AS SUM(current_balance),
    loans.average_loan_rate AS AVG(interest_rate),
    loans.problem_loans AS COUNT(CASE WHEN loan_status IN ('Delinquent', 'Default') THEN 1 END),
    
    -- Credit card metrics
    credit_cards.total_credit_cards AS COUNT(DISTINCT card_id),
    credit_cards.total_credit_limit AS SUM(credit_limit),
    credit_cards.total_credit_balance AS SUM(current_balance),
    credit_cards.average_utilization_rate AS AVG(CASE WHEN credit_limit > 0 THEN current_balance / credit_limit END),
    
    -- Service metrics
    service_requests.total_service_requests AS COUNT(request_id),
    service_requests.average_satisfaction_score AS AVG(satisfaction_score),
    service_requests.open_service_requests AS COUNT(CASE WHEN status = 'Open' THEN 1 END),
    
    -- Digital metrics
    digital_users.total_digital_users AS COUNT(DISTINCT user_id),
    digital_users.mobile_users AS COUNT(DISTINCT CASE WHEN is_mobile_enrolled THEN user_id END),
    digital_users.average_login_count AS AVG(login_count),
    
    -- Branch metrics
    branches.total_branches AS COUNT(DISTINCT branch_id),
    atms.total_atms AS COUNT(DISTINCT atm_id),
    
    -- Revenue metrics
    loans.estimated_loan_interest_income AS SUM(monthly_payment * interest_rate / 12),
    credit_cards.monthly_credit_card_fees AS SUM(annual_fee / 12),
    
    -- Risk metrics
    loans.delinquent_loan_balance AS SUM(CASE WHEN days_past_due > 0 THEN current_balance END),
    customers.high_risk_customers AS COUNT(DISTINCT CASE WHEN risk_rating = 'HIGH' THEN customer_id END)
  )
  COMMENT = 'Comprehensive semantic model for Cathay Bank Intelligence Agent';

-- Grant usage on the semantic view
--GRANT USAGE ON SEMANTIC VIEW CATHAY_BANK_SEMANTIC_MODEL TO ROLE CATHAY_DEMO_ROLE;

-- ============================================================================
-- CONFIRMATION
-- ============================================================================

-- Show created views
SELECT 'Analytics Views Created' AS status, COUNT(*) AS view_count
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND TABLE_CATALOG = 'CATHAY_BANK_DEMO';

-- Verify semantic view
SHOW SEMANTIC VIEWS IN SCHEMA ANALYTICS;

-- Display completion message
SELECT 'Cathay Bank semantic views and analytics creation completed successfully!' AS STATUS,
       CURRENT_TIMESTAMP() AS COMPLETED_AT;
