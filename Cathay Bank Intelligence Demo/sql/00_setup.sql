/*
  _____ _   _____ _   _   ___   __   ____    _   _   _ _  __
 / ____| | |_   _| | | | / \ \ / /  |  _ \  / \ | \ | | |/ /
| |    | |   | | | |_| |/ _ \ V /   | |_) |/ _ \|  \| | ' / 
| |    | |   | | |  _  / ___ \| |    |  _ </ ___ \ |\  | . \ 
| |____| |___| |_| | |/_/   \_\_|    |_| \_\_/   \_| \_|_|\_\
 \_____|_____|_|_|_|                                          

Snowflake Intelligence Demo - Cathay Bank
Environment Setup Script

This script creates the foundational Snowflake objects for the Cathay Bank Intelligence demo:
- Warehouse for compute resources
- Database and schemas for data organization
- Roles for access control
- Initial privileges

Run Time: < 1 minute
*/

-- ============================================================================
-- WAREHOUSE SETUP
-- ============================================================================

-- Create a dedicated warehouse for the demo
CREATE WAREHOUSE IF NOT EXISTS CATHAY_DEMO_WH 
  WITH 
  WAREHOUSE_SIZE = 'MEDIUM'
  WAREHOUSE_TYPE = 'STANDARD'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 2
  SCALING_POLICY = 'STANDARD'
  COMMENT = 'Warehouse for Cathay Bank Intelligence Demo';

-- Use the warehouse
USE WAREHOUSE CATHAY_DEMO_WH;

-- ============================================================================
-- DATABASE SETUP
-- ============================================================================

-- Create the demo database
CREATE DATABASE IF NOT EXISTS CATHAY_BANK_DEMO
  COMMENT = 'Database for Cathay Bank Intelligence Demo - Banking Data Model';

-- Use the database
USE DATABASE CATHAY_BANK_DEMO;

-- ============================================================================
-- SCHEMA SETUP
-- ============================================================================

-- Create schemas for organizing different data layers
CREATE SCHEMA IF NOT EXISTS RAW
  COMMENT = 'Raw tables representing core banking entities';

CREATE SCHEMA IF NOT EXISTS ANALYTICS
  COMMENT = 'Analytics views and semantic models for Intelligence queries';

CREATE SCHEMA IF NOT EXISTS STAGING
  COMMENT = 'Staging area for data transformations';

-- ============================================================================
-- ROLE SETUP
-- ============================================================================

-- Create a demo role for the Intelligence agent
-- CREATE ROLE IF NOT EXISTS CATHAY_DEMO_ROLE
  COMMENT = 'Role for Cathay Bank Intelligence Demo with appropriate permissions';

-- Grant database and schema privileges
-- GRANT USAGE ON DATABASE CATHAY_BANK_DEMO TO ROLE CATHAY_DEMO_ROLE;
-- GRANT USAGE ON ALL SCHEMAS IN DATABASE CATHAY_BANK_DEMO TO ROLE CATHAY_DEMO_ROLE;
-- GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE CATHAY_BANK_DEMO TO ROLE CATHAY_DEMO_ROLE;
-- GRANT CREATE VIEW ON ALL SCHEMAS IN DATABASE CATHAY_BANK_DEMO TO ROLE CATHAY_DEMO_ROLE;
-- GRANT CREATE SEMANTIC VIEW ON ALL SCHEMAS IN DATABASE CATHAY_BANK_DEMO TO ROLE CATHAY_DEMO_ROLE;

-- Grant warehouse privileges
-- GRANT USAGE ON WAREHOUSE CATHAY_DEMO_WH TO ROLE CATHAY_DEMO_ROLE;

-- Grant role to current user (adjust as needed)
-- GRANT ROLE CATHAY_DEMO_ROLE TO USER IDENTIFIER($current_user);

-- ============================================================================
-- SET CONTEXT
-- ============================================================================

-- Set the context for subsequent operations
-- USE ROLE CATHAY_DEMO_ROLE;
USE WAREHOUSE CATHAY_DEMO_WH;
USE DATABASE CATHAY_BANK_DEMO;
USE SCHEMA RAW;

-- ============================================================================
-- CONFIRMATION
-- ============================================================================

-- Show created objects
SHOW WAREHOUSES LIKE 'CATHAY_DEMO_WH';
SHOW DATABASES LIKE 'CATHAY_BANK_DEMO';
SHOW SCHEMAS IN DATABASE CATHAY_BANK_DEMO;
-- SHOW ROLES LIKE 'CATHAY_DEMO_ROLE';

-- Display completion message
SELECT 'Cathay Bank Intelligence Demo environment setup completed successfully!' AS STATUS,
       CURRENT_TIMESTAMP() AS COMPLETED_AT;
