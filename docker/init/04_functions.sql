-- =============================================================
-- Renewable Assets Database - Functions
-- PostgreSQL equivalents of original T-SQL UDFs
-- =============================================================

CREATE OR REPLACE FUNCTION get_highest_review_score()
RETURNS NUMERIC AS $$
    SELECT MAX(review_score) FROM asset_registrations;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_lowest_review_score()
RETURNS NUMERIC AS $$
    SELECT MIN(review_score) FROM asset_registrations;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_location_name_by_id(p_location_id INT)
RETURNS VARCHAR AS $$
    SELECT county FROM asset_locations WHERE id = p_location_id;
$$ LANGUAGE SQL STABLE;

-- Returns reviews in range enriched with asset and manager context
CREATE OR REPLACE FUNCTION get_reviews_in_range(p_min NUMERIC, p_max NUMERIC)
RETURNS TABLE (asset_name VARCHAR, manager_name VARCHAR, review_score NUMERIC) AS $$
    SELECT a.asset_name,
           m.first_name || ' ' || m.last_name AS manager_name,
           r.review_score
    FROM asset_registrations r
    INNER JOIN assets         a ON a.id = r.asset_id
    INNER JOIN asset_managers m ON m.id = r.asset_manager_id
    WHERE r.review_score BETWEEN p_min AND p_max
    ORDER BY r.review_score DESC;
$$ LANGUAGE SQL STABLE;

-- Union of managers and assets (original: dbo.allManagersAndAssets)
-- Note: ORDER BY wraps the UNION in a subquery so column aliases are visible
CREATE OR REPLACE FUNCTION get_all_managers_and_assets()
RETURNS TABLE (first_name VARCHAR, last_name VARCHAR, date_registered DATE, record_type VARCHAR) AS $$
    SELECT * FROM (
        SELECT first_name, last_name, date_registered, 'Manager'::VARCHAR AS record_type
        FROM asset_managers
        UNION ALL
        SELECT asset_name, site_name, date_created, 'Asset'::VARCHAR AS record_type
        FROM assets
    ) combined
    ORDER BY record_type, first_name;
$$ LANGUAGE SQL STABLE;

-- Insert a new asset and return its ID (original: dbo.InsertAsset procedure)
CREATE OR REPLACE FUNCTION insert_asset(
    p_asset_name     VARCHAR,
    p_site_name      VARCHAR,
    p_asset_type_id  INT,
    p_capacity_mw    NUMERIC,
    p_annual_revenue NUMERIC
) RETURNS INT AS $$
DECLARE new_id INT;
BEGIN
    INSERT INTO assets (asset_name, site_name, asset_type_id, capacity_mw, date_created, annual_revenue)
    VALUES (p_asset_name, p_site_name, p_asset_type_id, p_capacity_mw, CURRENT_DATE, p_annual_revenue)
    RETURNING id INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;
