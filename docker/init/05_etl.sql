-- =============================================================
-- Renewable Assets Database - ETL Pipeline
-- Implements the data pipeline described in the README
-- that was absent from the original SQL Server export
-- =============================================================

-- update_consolidated_data()
-- Extracts from daily_cash_flows, enriches with asset/location
-- context, loads into consolidated_data.
-- Idempotent: deletes existing rows for the date window first.
CREATE OR REPLACE PROCEDURE update_consolidated_data(
    p_from_date DATE DEFAULT (CURRENT_DATE - INTERVAL '30 days')::DATE,
    p_to_date   DATE DEFAULT CURRENT_DATE
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Step 1: Remove existing rows for this window
    DELETE FROM consolidated_data
    WHERE flow_date BETWEEN p_from_date AND p_to_date;

    -- Step 2: Extract, transform, load
    INSERT INTO consolidated_data (
        asset_id, asset_type, location, flow_date,
        transaction_type, cash_flow_amount, trade_details, consolidated_at
    )
    SELECT
        cf.asset_id, t.type_name, l.county, cf.flow_date,
        cf.transaction_type, cf.amount, cf.trade_details, NOW()
    FROM daily_cash_flows cf
    INNER JOIN assets          a ON a.id  = cf.asset_id
    INNER JOIN asset_types     t ON t.id  = a.asset_type_id
    INNER JOIN (
        SELECT DISTINCT ON (asset_id) asset_id, asset_location_id
        FROM asset_registrations
        ORDER BY asset_id, id DESC
    ) r ON r.asset_id = cf.asset_id
    INNER JOIN asset_locations l ON l.id = r.asset_location_id
    WHERE cf.flow_date BETWEEN p_from_date AND p_to_date;

    RAISE NOTICE 'Consolidated: % to %', p_from_date, p_to_date;
END;
$$;

-- Seed consolidated_data from existing cash flow rows
CALL update_consolidated_data('2024-01-01', '2024-12-31');

-- PowerBI-compatible view (original: dbo.PowerBI_Report from README)
CREATE OR REPLACE VIEW vw_consolidated_report AS
SELECT asset_type, location, flow_date, transaction_type,
       SUM(cash_flow_amount) AS total_cash_flow,
       COUNT(*)              AS transaction_count
FROM consolidated_data
GROUP BY asset_type, location, flow_date, transaction_type
ORDER BY flow_date, asset_type;

-- Maintenance-enriched view (original: dbo.PowerBI_Report_With_Maintenance)
CREATE OR REPLACE VIEW vw_consolidated_with_maintenance AS
SELECT cd.asset_type, cd.location, cd.flow_date, cd.transaction_type,
       SUM(cd.cash_flow_amount)            AS total_cash_flow,
       COALESCE(SUM(mr.cost), 0)           AS total_maintenance_cost,
       SUM(cd.cash_flow_amount)
           + COALESCE(SUM(mr.cost), 0)     AS net_cash_flow
FROM consolidated_data cd
LEFT JOIN maintenance_records mr
       ON mr.asset_id = cd.asset_id
      AND mr.maintenance_date = cd.flow_date
GROUP BY cd.asset_type, cd.location, cd.flow_date, cd.transaction_type
ORDER BY cd.flow_date, cd.asset_type;
