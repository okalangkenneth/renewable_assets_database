-- =============================================================
-- Renewable Assets Database - Views
-- =============================================================

-- vw_asset_locations
-- Fixed: original joined AssetLocations.id = Assets.id directly
-- (location 1 matched only asset 1 etc. - logically wrong)
-- Correct path goes through asset_registrations
CREATE OR REPLACE VIEW vw_asset_locations AS
SELECT l.county AS location, l.county_code, a.asset_name, a.site_name,
       t.type_name AS asset_type, a.capacity_mw
FROM asset_registrations r
INNER JOIN asset_locations l ON l.id = r.asset_location_id
INNER JOIN assets          a ON a.id = r.asset_id
INNER JOIN asset_types     t ON t.id = a.asset_type_id;

-- vw_asset_site_managers (logic was correct in original)
CREATE OR REPLACE VIEW vw_asset_site_managers AS
SELECT m.first_name AS manager_first_name, m.last_name AS manager_last_name,
       a.asset_name, a.site_name, t.type_name AS asset_type,
       l.county AS location, l.county_code, r.review_score
FROM asset_registrations r
INNER JOIN asset_managers  m ON m.id = r.asset_manager_id
INNER JOIN assets          a ON a.id = r.asset_id
INNER JOIN asset_types     t ON t.id = a.asset_type_id
INNER JOIN asset_locations l ON l.id = r.asset_location_id;

-- Revenue by asset type
CREATE OR REPLACE VIEW vw_revenue_by_asset_type AS
SELECT t.type_name AS asset_type, COUNT(a.id) AS asset_count,
       SUM(a.capacity_mw) AS total_capacity_mw,
       SUM(a.annual_revenue) AS total_annual_revenue,
       ROUND(AVG(a.annual_revenue), 2) AS avg_annual_revenue
FROM assets a
INNER JOIN asset_types t ON t.id = a.asset_type_id
GROUP BY t.type_name ORDER BY total_annual_revenue DESC;

-- Revenue by location
CREATE OR REPLACE VIEW vw_revenue_by_location AS
SELECT l.county AS location, COUNT(DISTINCT r.asset_id) AS asset_count,
       SUM(a.annual_revenue) AS total_annual_revenue,
       ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM asset_registrations r
INNER JOIN asset_locations l ON l.id = r.asset_location_id
INNER JOIN assets          a ON a.id = r.asset_id
GROUP BY l.county ORDER BY total_annual_revenue DESC;

-- Cash flow summary (ETL reporting view)
CREATE OR REPLACE VIEW vw_cash_flow_summary AS
SELECT a.asset_name, t.type_name AS asset_type, cf.flow_date,
       cf.transaction_type, SUM(cf.amount) AS total_amount
FROM daily_cash_flows cf
INNER JOIN assets      a ON a.id = cf.asset_id
INNER JOIN asset_types t ON t.id = a.asset_type_id
GROUP BY a.asset_name, t.type_name, cf.flow_date, cf.transaction_type
ORDER BY cf.flow_date, a.asset_name;

-- Maintenance cost summary
CREATE OR REPLACE VIEW vw_maintenance_summary AS
SELECT a.asset_name, t.type_name AS asset_type,
       COUNT(mr.id) AS maintenance_count,
       SUM(mr.cost) AS total_maintenance_cost,
       MAX(mr.maintenance_date) AS last_maintenance_date
FROM maintenance_records mr
INNER JOIN assets      a ON a.id = mr.asset_id
INNER JOIN asset_types t ON t.id = a.asset_type_id
GROUP BY a.asset_name, t.type_name ORDER BY total_maintenance_cost DESC;
