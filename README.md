# Renewable Assets Database

A rehabilitated SQL database for managing renewable energy assets across Swedish counties. Originally a SQL Server SSMS export (2022); this version ports the schema to **PostgreSQL 16**, fixes structural issues in the original, and implements the ETL pipeline and reporting views the README described but never delivered.

**[Live Demo](https://okalangkenneth.github.io/renewable_assets_database/demo/)** &nbsp;|&nbsp; **[GitHub](https://github.com/okalangkenneth/renewable_assets_database)**

---

## What it covers

- Normalised schema for five renewable energy types: Solar, Wind, Hydro, Geothermal, Biomass
- Asset registration linking assets, managers, and Swedish county locations
- Daily cash flow tracking with a stored-procedure ETL pipeline (`update_consolidated_data`)
- Eight reporting views ready for Power BI or any BI tool
- `docker-compose up` spins up a fully seeded PostgreSQL 16 instance — no manual steps

---

## Quick start

```bash
cd docker
cp .env.example .env        # adjust credentials if needed
docker-compose up -d
```

The database is seeded automatically on first start via the numbered init scripts in `docker/init/`.

```
Host:     localhost:5432
Database: renewable_assets
User:     ra_user
Password: changeme
```

---

## Schema

| Table | Purpose |
|---|---|
| `asset_types` | Lookup: Solar / Wind / Hydro / Geothermal / Biomass |
| `asset_locations` | Swedish counties and county codes |
| `asset_managers` | Portfolio managers |
| `assets` | Installations with capacity (MW) and annual revenue (SEK) |
| `asset_registrations` | Manager ↔ Asset ↔ Location with review score (1–10) |
| `daily_cash_flows` | Daily trade and cash flow records (ETL source) |
| `maintenance_records` | Scheduled and corrective maintenance log |
| `consolidated_data` | ETL target populated by `update_consolidated_data()` |

---

## Running the ETL procedure

```sql
-- Consolidate the last 30 days (default)
CALL update_consolidated_data();

-- Consolidate a specific date range
CALL update_consolidated_data('2024-01-01', '2024-03-31');
```

The procedure is idempotent — safe to run repeatedly.

---

## Reporting views

| View | Purpose |
|---|---|
| `vw_asset_locations` | Assets with location and type context |
| `vw_asset_site_managers` | Manager ↔ Asset ↔ Location join with review score |
| `vw_revenue_by_asset_type` | Total and average revenue by energy type |
| `vw_revenue_by_location` | Revenue and review scores by county |
| `vw_cash_flow_summary` | Daily cash flows enriched with asset type |
| `vw_maintenance_summary` | Maintenance cost and frequency by asset |
| `vw_consolidated_report` | Power BI-ready summary from consolidated_data |
| `vw_consolidated_with_maintenance` | Cash flow netted against maintenance costs |

---

## Repository layout

```
sqlserver/      Original SQL Server SSMS export (preserved for reference)
postgresql/     Clean PostgreSQL DDL — schema, seed, views, functions, ETL
docker/         docker-compose.yml + .env.example + init scripts
demo/           Static Chart.js dashboard (GitHub Pages)
```

---

## What was rehabilitated

Ten issues identified during discovery of the original SSMS export:

| # | Issue | Fix |
|---|---|---|
| 1 | **Wrong join** in `Asset_Locations` view — matched location ID directly to asset ID, bypassing `AssetRegistrations` | Fixed to join through `asset_registrations` |
| 2 | **`nchar(50)` padding** on manager names — silently stored 50 trailing spaces per value | Changed to `VARCHAR(50)` |
| 3 | **No `AssetType` column** — type lived in free-text strings (`"Solar2"`, `"Geotherma4"`) | Added `asset_types` lookup table with FK |
| 4 | **No capacity unit** — `capacity INT` with no label | Changed to `capacity_mw NUMERIC(10,2)` |
| 5 | **Dirty seed data** — `testSite1`–`testsite6` rows, NULL managers, NULL reviews throughout | Replaced with realistic Swedish renewable energy data |
| 6 | **Hardcoded SQL Server paths** — `C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\...` | Removed; schema is now portable |
| 7 | **SSMS boilerplate** — 40+ `ALTER DATABASE` statements and `MS_DiagramPane1` metadata | Removed entirely |
| 8 | **Missing ETL objects** — `ConsolidatedData` table and `update_consolidated_data` procedure described in README but absent | Implemented in `05_etl.sql` |
| 9 | **Missing `MaintenanceData`** — described in README, not present | Implemented as `maintenance_records` |
| 10 | **Unfilled function templates** — `<Author,,Name>`, `<Create Date,,>` in every function header | Cleaned and documented |

---

## What I would add for production

- **Row-level security** so each manager sees only their assigned assets
- **Table partitioning** on `daily_cash_flows` by year — this table grows fast in production
- **Scheduled ETL** via `pg_cron` or an external orchestrator (Airflow / Prefect)
- **Audit log** tracking INSERT/UPDATE/DELETE on assets and registrations with timestamps
- **CI pipeline** running init scripts against a throwaway container to catch regressions

---

## Background

This project draws on a background in agricultural and renewable resource economics. The schema reflects a real operational challenge: multiple asset types, geographically distributed, managed by different people, with daily cash flows that must be reconciled into a consolidated view for reporting. The ETL layer turns raw registrations into the kind of structured output that actually drives investment decisions.

---

*Kenneth Okalang &nbsp;·&nbsp; [GitHub](https://github.com/okalangkenneth) &nbsp;·&nbsp; [LinkedIn](https://www.linkedin.com/in/kenneth-okalang)*
