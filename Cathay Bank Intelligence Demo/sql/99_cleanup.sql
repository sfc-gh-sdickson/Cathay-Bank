/*
  _____ _   _____ _   _   ___   __   ____    _   _   _ _  __
 / ____| | |_   _| | | | / \ \ / /  |  _ \  / \ | \ | | |/ /
| |    | |   | | | |_| |/ _ \ V /   | |_) |/ _ \|  \| | ' / 
| |    | |   | | |  _  / ___ \| |    |  _ </ ___ \ |\  | . \ 
| |____| |___| |_| | |/_/   \_\_|    |_| \_\_/   \_| \_|_|\_\
 \_____|_____|_|_|_|                                          

Snowflake Intelligence Demo - Cathay Bank
Cleanup Script

This script removes all objects created by the demo:
- Drops the database and all contained objects
- Removes the demo role
- Drops the demo warehouse

Run Time: < 1 minute

WARNING: This will permanently delete all demo data and objects!
*/

-- ============================================================================
-- CONFIRMATION PROMPT
-- ============================================================================

-- Uncomment the following line to proceed with cleanup
-- SELECT 'I understand this will delete all Cathay Bank demo objects' AS confirmation;

-- ============================================================================
-- DROP DATABASE AND ALL OBJECTS
-- ============================================================================

-- Drop the database (this cascades to all schemas, tables, views, etc.)
DROP DATABASE IF EXISTS CATHAY_BANK_DEMO CASCADE;

-- ============================================================================
-- DROP ROLE
-- ============================================================================

-- First revoke the role from all users
-- Note: You may need to adjust this based on who has been granted the role
REVOKE ROLE CATHAY_DEMO_ROLE FROM USER IDENTIFIER($current_user);

-- Drop the role
DROP ROLE IF EXISTS CATHAY_DEMO_ROLE;

-- ============================================================================
-- DROP WAREHOUSE
-- ============================================================================

-- Drop the warehouse
DROP WAREHOUSE IF EXISTS CATHAY_DEMO_WH;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify cleanup
SELECT 'Cleanup Status Report' AS report_section, '' AS details
UNION ALL
SELECT '=====================', ''
UNION ALL
SELECT 'Database Check', 
       CASE 
           WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.DATABASES WHERE DATABASE_NAME = 'CATHAY_BANK_DEMO') 
           THEN '❌ Database still exists' 
           ELSE '✅ Database removed' 
       END
UNION ALL
SELECT 'Role Check', 
       CASE 
           WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROLES WHERE ROLE_NAME = 'CATHAY_DEMO_ROLE') 
           THEN '❌ Role still exists' 
           ELSE '✅ Role removed' 
       END
UNION ALL
SELECT 'Warehouse Check', 
       CASE 
           WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.WAREHOUSES WHERE WAREHOUSE_NAME = 'CATHAY_DEMO_WH') 
           THEN '❌ Warehouse still exists' 
           ELSE '✅ Warehouse removed' 
       END
UNION ALL
SELECT '', ''
UNION ALL
SELECT 'Cathay Bank demo cleanup completed!', CURRENT_TIMESTAMP()::STRING;

-- ============================================================================
-- OPTIONAL: CLEANUP QUERY HISTORY
-- ============================================================================

-- If you want to also clean up query history related to this demo,
-- you would need ACCOUNTADMIN role and could run:
-- Note: This is commented out by default as it requires elevated privileges

/*
USE ROLE ACCOUNTADMIN;

-- Mark queries for deletion (Snowflake doesn't allow direct deletion)
-- This helps identify demo-related queries in history
UPDATE SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
SET QUERY_TAG = 'CATHAY_DEMO_CLEANUP'
WHERE DATABASE_NAME = 'CATHAY_BANK_DEMO'
  AND START_TIME >= DATEADD('day', -30, CURRENT_TIMESTAMP());
*/
