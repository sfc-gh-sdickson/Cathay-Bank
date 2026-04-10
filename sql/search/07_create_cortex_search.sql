/*=============================================================================
  CATHAY BANK INTELLIGENCE AGENT
  File: 07_create_cortex_search.sql
  Description: Cortex Search services for unstructured data retrieval
  Execution Order: 7 of 10
=============================================================================*/

USE DATABASE CATHAY_BANK_DB;
USE SCHEMA SEARCH;
USE WAREHOUSE CATHAY_BANK_WH;

CREATE OR REPLACE CORTEX SEARCH SERVICE CATHAY_REGULATORY_SEARCH
  ON CONTENT
  ATTRIBUTES TITLE, DOCUMENT_TYPE, REGULATORY_BODY, FRAMEWORK, TAGS
  WAREHOUSE = CATHAY_BANK_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for regulatory documents, compliance policies, and banking frameworks'
AS
  SELECT
    DOCUMENT_ID,
    TITLE,
    DOCUMENT_TYPE,
    REGULATORY_BODY,
    FRAMEWORK,
    CONTENT,
    SUMMARY,
    TAGS,
    VERSION,
    STATUS,
    EFFECTIVE_DATE
  FROM CATHAY_BANK_DB.RAW.REGULATORY_DOCUMENTS
  WHERE STATUS = 'Active';

CREATE OR REPLACE CORTEX SEARCH SERVICE CATHAY_COMPLIANCE_SEARCH
  ON SEARCH_CONTENT
  ATTRIBUTES EVENT_TYPE, EVENT_CATEGORY, REGULATORY_FRAMEWORK, SEVERITY, STATUS
  WAREHOUSE = CATHAY_BANK_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for compliance events, investigations, and regulatory findings'
AS
  SELECT
    ce.EVENT_ID,
    ce.EVENT_TYPE,
    ce.EVENT_CATEGORY,
    ce.REGULATORY_FRAMEWORK,
    ce.SEVERITY,
    ce.STATUS,
    ce.DETECTION_METHOD,
    ce.DESCRIPTION || ' ' ||
      COALESCE('Resolution: ' || ce.RESOLUTION_NOTES, '') || ' ' ||
      COALESCE('SAR Filed: ' || ce.SAR_FILED::VARCHAR, '') || ' ' ||
      COALESCE('Assigned To: ' || ce.ASSIGNED_TO, '') AS SEARCH_CONTENT,
    ce.DETECTED_DATE,
    c.FIRST_NAME || ' ' || c.LAST_NAME AS CUSTOMER_NAME,
    c.RISK_RATING AS CUSTOMER_RISK_RATING
  FROM CATHAY_BANK_DB.RAW.COMPLIANCE_EVENTS ce
  LEFT JOIN CATHAY_BANK_DB.RAW.CUSTOMERS c ON ce.CUSTOMER_ID = c.CUSTOMER_ID;

CREATE OR REPLACE CORTEX SEARCH SERVICE CATHAY_SUPPORT_SEARCH
  ON SEARCH_CONTENT
  ATTRIBUTES CATEGORY, SUBCATEGORY, PRIORITY, STATUS, CHANNEL
  WAREHOUSE = CATHAY_BANK_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for customer support cases, resolutions, and service interactions'
AS
  SELECT
    sc.CASE_ID,
    sc.CASE_NUMBER,
    sc.CATEGORY,
    sc.SUBCATEGORY,
    sc.PRIORITY,
    sc.STATUS,
    sc.CHANNEL,
    sc.SUBJECT || ' ' || sc.DESCRIPTION || ' ' ||
      COALESCE('Resolution: ' || sc.RESOLUTION, '') AS SEARCH_CONTENT,
    sc.OPENED_DATE,
    sc.SATISFACTION_SCORE,
    c.FIRST_NAME || ' ' || c.LAST_NAME AS CUSTOMER_NAME,
    c.CUSTOMER_SEGMENT
  FROM CATHAY_BANK_DB.RAW.SUPPORT_CASES sc
  LEFT JOIN CATHAY_BANK_DB.RAW.CUSTOMERS c ON sc.CUSTOMER_ID = c.CUSTOMER_ID;

CREATE OR REPLACE CORTEX SEARCH SERVICE CATHAY_ONTOLOGY_SEARCH
  ON SEARCH_CONTENT
  ATTRIBUTES DOMAIN, SUBDOMAIN, CLASS_NAME
  WAREHOUSE = CATHAY_BANK_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for FIBO banking ontology concepts, definitions, and regulatory mappings'
AS
  SELECT
    fc.CLASS_ID,
    fc.CLASS_NAME,
    fc.DOMAIN,
    fc.SUBDOMAIN,
    fc.CLASS_NAME || ': ' || fc.DEFINITION || ' ' ||
      COALESCE('Examples: ' || fc.EXAMPLES, '') || ' ' ||
      COALESCE('Synonyms: ' || fc.SYNONYMS, '') || ' ' ||
      COALESCE('Regulatory Context: ' || fc.REGULATORY_CONTEXT, '') || ' ' ||
      COALESCE('ISO Standard: ' || fc.ISO_STANDARD, '') || ' ' ||
      COALESCE('Data Elements: ' || fc.DATA_ELEMENTS, '') AS SEARCH_CONTENT
  FROM CATHAY_BANK_DB.ONTOLOGY.FIBO_CLASSES fc;
