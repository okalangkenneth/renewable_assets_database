-- =============================================================
-- Renewable Assets Database - PostgreSQL Schema
-- Rehabilitated from SQL Server (SSMS export, 2022)
-- Author: Kenneth Okalang
-- https://github.com/okalangkenneth/renewable_assets_database
-- =============================================================

-- Asset type lookup (replaces free-text assetname like "Solar2","Geotherma4")
CREATE TABLE asset_types (
    id          SERIAL PRIMARY KEY,
    type_name   VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Locations (Swedish counties)
CREATE TABLE asset_locations (
    id               SERIAL PRIMARY KEY,
    county           VARCHAR(50) NOT NULL,
    county_code      VARCHAR(10),
    number_of_assets INT DEFAULT 0
);

-- Asset managers
-- Fixed: was nchar(50) with 50-char trailing-space padding
CREATE TABLE asset_managers (
    id              SERIAL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    date_registered DATE        NOT NULL
);

-- Assets
-- Fixed: capacity now NUMERIC with explicit MW unit; type via FK not free text
CREATE TABLE assets (
    id             SERIAL PRIMARY KEY,
    asset_name     VARCHAR(100)   NOT NULL,
    site_name      VARCHAR(100)   NOT NULL,
    asset_type_id  INT            NOT NULL REFERENCES asset_types(id),
    capacity_mw    NUMERIC(10, 2),
    date_created   DATE           NOT NULL,
    annual_revenue NUMERIC(14, 2) NOT NULL
);

-- Registrations (manager <-> asset <-> location)
-- Fixed: all FKs are NOT NULL; review_score constrained to 1-10
CREATE TABLE asset_registrations (
    id                SERIAL PRIMARY KEY,
    asset_id          INT           NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
    asset_manager_id  INT           NOT NULL REFERENCES asset_managers(id),
    asset_location_id INT           NOT NULL REFERENCES asset_locations(id),
    review_score      NUMERIC(4, 1) CHECK (review_score BETWEEN 1 AND 10)
);

-- Daily cash flows (ETL source described in README, was missing from original)
CREATE TABLE daily_cash_flows (
    id               SERIAL PRIMARY KEY,
    asset_id         INT            NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
    flow_date        DATE           NOT NULL,
    transaction_type VARCHAR(50)    NOT NULL,
    amount           NUMERIC(14, 2) NOT NULL,
    trade_details    TEXT,
    UNIQUE (asset_id, flow_date, transaction_type)
);

-- Maintenance records (MaintenanceData from README, was missing)
CREATE TABLE maintenance_records (
    id               SERIAL PRIMARY KEY,
    asset_id         INT            NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
    maintenance_date DATE           NOT NULL,
    activity         VARCHAR(255)   NOT NULL,
    cost             NUMERIC(12, 2),
    performed_by     VARCHAR(100)
);

-- Consolidated reporting table (ETL target, was missing from original)
CREATE TABLE consolidated_data (
    id               SERIAL PRIMARY KEY,
    asset_id         INT            NOT NULL REFERENCES assets(id),
    asset_type       VARCHAR(50),
    location         VARCHAR(50),
    flow_date        DATE           NOT NULL,
    transaction_type VARCHAR(50),
    cash_flow_amount NUMERIC(14, 2),
    trade_details    TEXT,
    consolidated_at  TIMESTAMP      DEFAULT NOW()
);
