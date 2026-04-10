/*=============================================================================
  CATHAY BANK INTELLIGENCE AGENT
  File: 10_create_agent.sql
  Description: Snowflake Intelligence Agent creation with YAML specification
  Execution Order: 10 of 10
=============================================================================*/

USE DATABASE CATHAY_BANK_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE CATHAY_BANK_WH;

CREATE OR REPLACE AGENT CATHAY_BANK_AGENT
  COMMENT = 'Cathay Bank Intelligence Agent - Banking operations, compliance, risk, and customer analytics'
  PROFILE = '{"display_name": "Cathay Bank Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 360
      tokens: 32000

  instructions:
    response: >
      You are the Cathay Bank Intelligence Assistant, supporting the oldest operating American bank
      founded by Chinese Americans. Respond professionally, concisely, and accurately.
      When presenting financial data, always include dollar signs and proper formatting.
      Round monetary values to 2 decimal places and percentages to 2 decimal places.
      When discussing compliance or regulatory matters, reference the applicable regulatory framework
      (BSA, OFAC, HMDA, CRA, Basel III, etc.) and recommend consulting the Compliance department
      for formal guidance. When presenting risk data, include both the risk score and rating.
      For multilingual customers, note their preferred language when relevant.
      Always protect customer PII - never expose full SSN, account numbers, or other sensitive data.

    orchestration: >
      Route questions as follows:
      - For quantitative questions about customers, accounts, transactions, loans, deposits, balances,
        counts, averages, trends, or any structured data analysis: use CathayBankAnalyst.
      - For questions about regulatory documents, compliance policies, BSA/AML procedures,
        Basel III framework, CRA plans, or any regulatory knowledge: use RegulatorySearch.
      - For questions about specific compliance events, investigations, SAR filings, or compliance
        case details: use ComplianceSearch.
      - For questions about customer service cases, resolutions, or support history: use SupportSearch.
      - For questions about banking domain concepts, FIBO ontology, regulatory definitions,
        or concept relationships: use OntologySearch.
      - For questions about a specific customer's complete risk profile including deposits, loans,
        compliance events, and risk assessments: use CustomerRiskProfile.
      - For high-level portfolio summaries including total deposits, loans, delinquency rates,
        and compliance status: use PortfolioSummary.
      - For compliance-specific summaries including open events, SARs, CTRs, and KYC status: use ComplianceSummary.
      - For ontology concept resolution, regulatory framework lookup, or domain relationship
        navigation: use FIBOResolveConcept, FIBORegulatoryRequirements, or FIBONavigateRelationships.
      - When a question spans multiple domains, use multiple tools and synthesize the results.

    system: >
      You are the Cathay Bank Intelligence Assistant, an AI-powered banking analyst supporting
      Cathay Bank operations. Cathay Bank is the oldest operating American bank founded by Chinese
      Americans, established in 1962 in Los Angeles Chinatown. Today it operates over 60 branches
      across nine US states with a branch in Hong Kong and representative offices in Asia.
      You have access to comprehensive banking data including customer profiles, deposit accounts,
      loan portfolios, transaction history, compliance events, risk assessments, and support cases.
      You also have access to the FIBO (Financial Industry Business Ontology) for precise domain
      concept resolution and regulatory framework mapping. Always provide data-driven insights
      and reference specific metrics when answering questions.

    sample_questions:
      - question: "What is our total deposit base and how is it distributed across account types?"
        answer: "I'll query our deposit data to provide a breakdown by account type including checking, savings, money market, and CD balances."
      - question: "How many compliance events are currently open and what are the highest severity issues?"
        answer: "I'll check our compliance event data for open cases and highlight critical and high-severity items that need attention."
      - question: "What is the current delinquency rate across our loan portfolio?"
        answer: "I'll analyze our loan portfolio to calculate delinquency rates by loan type and risk grade."
      - question: "What are our BSA/AML obligations for correspondent banking?"
        answer: "I'll search our regulatory documents and FIBO ontology to explain BSA/AML requirements for correspondent banking relationships."
      - question: "Show me the risk profile for customer 42."
        answer: "I'll pull the complete risk profile including deposit balances, loan status, compliance events, and risk assessments for that customer."

  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "CathayBankAnalyst"
        description: >
          Converts natural language questions into SQL queries for Cathay Bank structured data analysis.
          Use this tool for ANY quantitative question about: customer counts, demographics, segments,
          account balances, deposit totals, transaction volumes, loan portfolio metrics, delinquency rates,
          interest rates, compliance event counts, risk assessment scores, support case statistics,
          branch performance, trends over time, comparisons, rankings, and aggregations.
          This tool accesses customers, accounts, transactions, loans, loan payments, compliance events,
          risk assessments, support cases, and branch data.

    - tool_spec:
        type: "cortex_search"
        name: "RegulatorySearch"
        description: >
          Searches Cathay Bank regulatory documents, compliance policies, and banking framework documentation.
          Use for questions about BSA/AML compliance program, CRA performance plan, Basel III capital
          adequacy, HMDA fair lending, enterprise risk management, Regulation E procedures, interest
          rate risk policy, vendor risk management, or any regulatory/policy knowledge base questions.

    - tool_spec:
        type: "cortex_search"
        name: "ComplianceSearch"
        description: >
          Searches compliance event records and investigation details. Use for finding specific
          compliance events, SAR filings, CTR reports, KYC reviews, OFAC screening alerts,
          investigation details, resolution notes, and compliance case narratives.

    - tool_spec:
        type: "cortex_search"
        name: "SupportSearch"
        description: >
          Searches customer support case records. Use for finding support case details, resolutions,
          customer complaints, service issues, and support interaction history.

    - tool_spec:
        type: "cortex_search"
        name: "OntologySearch"
        description: >
          Searches the FIBO (Financial Industry Business Ontology) knowledge base for banking domain
          concepts, definitions, regulatory contexts, and relationships between financial concepts.
          Use when the user asks about banking terminology, regulatory frameworks, or domain concepts.

    - tool_spec:
        type: "generic"
        name: "FIBOResolveConcept"
        description: >
          Resolves a banking domain concept using the FIBO ontology. Returns the formal definition,
          regulatory context, related data elements, ISO standards, and mapped Snowflake tables.
          Input: a banking concept term like 'KYC', 'AML', 'credit risk', 'mortgage', 'Basel III'.
        input_schema:
          type: "object"
          properties:
            CONCEPT_TERM:
              type: "string"
              description: "The banking concept to resolve, e.g. 'KYC', 'AML', 'credit risk', 'Basel III'"
          required:
            - "CONCEPT_TERM"

    - tool_spec:
        type: "generic"
        name: "FIBORegulatoryRequirements"
        description: >
          Retrieves regulatory requirements for a given framework or regulatory body.
          Returns regulation details, compliance metrics, data elements, reporting frequency, and penalties.
          Input: a regulatory framework name like 'BSA', 'OFAC', 'Basel', 'HMDA', 'CRA', 'TILA'.
        input_schema:
          type: "object"
          properties:
            FRAMEWORK_NAME:
              type: "string"
              description: "The regulatory framework name, e.g. 'BSA', 'OFAC', 'Basel III', 'HMDA'"
          required:
            - "FRAMEWORK_NAME"

    - tool_spec:
        type: "generic"
        name: "FIBONavigateRelationships"
        description: >
          Navigates FIBO ontology relationships for a given banking concept.
          Returns all related concepts, relationship types, and descriptions.
          Input: a class name like 'KYC', 'Anti-Money Laundering', 'Credit Risk', 'Basel III Framework'.
        input_schema:
          type: "object"
          properties:
            CLASS_NAME_INPUT:
              type: "string"
              description: "The FIBO class name to navigate relationships for"
          required:
            - "CLASS_NAME_INPUT"

    - tool_spec:
        type: "generic"
        name: "CustomerRiskProfile"
        description: >
          Retrieves a comprehensive risk profile for a specific customer including their demographics,
          deposit balances, loan status, compliance events, risk assessments, and support history.
          Input: a numeric customer ID.
        input_schema:
          type: "object"
          properties:
            CUST_ID:
              type: "number"
              description: "The numeric customer ID to retrieve the risk profile for"
          required:
            - "CUST_ID"

    - tool_spec:
        type: "generic"
        name: "PortfolioSummary"
        description: >
          Returns a high-level summary of the entire Cathay Bank portfolio including total customers,
          accounts, deposit balances, loan portfolio, delinquency rate, default counts, average credit
          score, open compliance events, YTD SARs, support cases, and branch count.
          Use for executive dashboard or overview questions. No input required.

    - tool_spec:
        type: "generic"
        name: "ComplianceSummary"
        description: >
          Returns a detailed compliance summary including total events, open events by severity,
          SARs and CTRs filed, events by category, average resolution time, KYC status counts,
          and high-risk customer counts. Use for compliance officer or audit questions. No input required.

    - tool_spec:
        type: "data_to_chart"
        name: "data_to_chart"
        description: "Generates visualizations and charts from data results"

  tool_resources:
    CathayBankAnalyst:
      semantic_view: "CATHAY_BANK_DB.ANALYTICS.CATHAY_BANK_SEMANTIC_VIEW"

    RegulatorySearch:
      name: "CATHAY_BANK_DB.SEARCH.CATHAY_REGULATORY_SEARCH"
      max_results: "10"
      title_column: "TITLE"
      id_column: "DOCUMENT_ID"

    ComplianceSearch:
      name: "CATHAY_BANK_DB.SEARCH.CATHAY_COMPLIANCE_SEARCH"
      max_results: "10"
      title_column: "EVENT_TYPE"
      id_column: "EVENT_ID"

    SupportSearch:
      name: "CATHAY_BANK_DB.SEARCH.CATHAY_SUPPORT_SEARCH"
      max_results: "10"
      title_column: "CATEGORY"
      id_column: "CASE_ID"

    OntologySearch:
      name: "CATHAY_BANK_DB.SEARCH.CATHAY_ONTOLOGY_SEARCH"
      max_results: "10"
      title_column: "CLASS_NAME"
      id_column: "CLASS_ID"

    FIBOResolveConcept:
      type: "function"
      identifier: "CATHAY_BANK_DB.ANALYTICS.FIBO_RESOLVE_CONCEPT"
      execution_environment:
        type: "warehouse"
        warehouse: "CATHAY_BANK_WH"

    FIBORegulatoryRequirements:
      type: "function"
      identifier: "CATHAY_BANK_DB.ANALYTICS.FIBO_GET_REGULATORY_REQUIREMENTS"
      execution_environment:
        type: "warehouse"
        warehouse: "CATHAY_BANK_WH"

    FIBONavigateRelationships:
      type: "function"
      identifier: "CATHAY_BANK_DB.ANALYTICS.FIBO_NAVIGATE_RELATIONSHIPS"
      execution_environment:
        type: "warehouse"
        warehouse: "CATHAY_BANK_WH"

    CustomerRiskProfile:
      type: "function"
      identifier: "CATHAY_BANK_DB.ANALYTICS.GET_CUSTOMER_RISK_PROFILE"
      execution_environment:
        type: "warehouse"
        warehouse: "CATHAY_BANK_WH"

    PortfolioSummary:
      type: "function"
      identifier: "CATHAY_BANK_DB.ANALYTICS.GET_PORTFOLIO_SUMMARY"
      execution_environment:
        type: "warehouse"
        warehouse: "CATHAY_BANK_WH"

    ComplianceSummary:
      type: "function"
      identifier: "CATHAY_BANK_DB.ANALYTICS.GET_COMPLIANCE_SUMMARY"
      execution_environment:
        type: "warehouse"
        warehouse: "CATHAY_BANK_WH"
  $$;
