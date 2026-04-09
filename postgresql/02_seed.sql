-- =============================================================
-- Renewable Assets Database - Seed Data
-- Clean replacement for original ad-hoc test data
-- Capacity in MW; revenue in SEK
-- =============================================================

INSERT INTO asset_types (type_name, description) VALUES
  ('Solar',      'Photovoltaic solar panel installations'),
  ('Wind',       'Onshore and offshore wind turbine farms'),
  ('Hydro',      'Hydroelectric power stations'),
  ('Geothermal', 'Geothermal heat and power plants'),
  ('Biomass',    'Biomass combustion and biogas facilities');

INSERT INTO asset_locations (county, county_code, number_of_assets) VALUES
  ('Uppsala',      'AB01', 3),
  ('Stockholm',    'AB02', 4),
  ('Gavle',        'X01',  2),
  ('Koping',       'U01',  5),
  ('Malmo',        'M01',  2),
  ('Finland',      'FI01', 1),
  ('Norrkoping',   'E01',  3),
  ('Kiruna',       'BD01', 6),
  ('Ystad',        'M02',  1),
  ('Vastmanland',  'U02',  4),
  ('Sodermanland', 'D01',  3);

INSERT INTO asset_managers (first_name, last_name, date_registered) VALUES
  ('Kenneth', 'Okalang',   '2019-03-03'),
  ('Bjorn',   'Andersson', '2022-02-02'),
  ('Alice',   'Bjorklund', '1999-03-03'),
  ('Ann',     'Marie',     '1983-01-23'),
  ('Kacey',   'Ryan',      '2012-04-03'),
  ('Keisha',  'Umurungi',  '2008-07-29');

-- asset_type_id: 1=Solar 2=Wind 3=Hydro 4=Geothermal 5=Biomass
INSERT INTO assets (asset_name, site_name, asset_type_id, capacity_mw, date_created, annual_revenue) VALUES
  ('Upplands Solpark',     'Uppsala',    1, 12.50, '1999-05-30', 970000.00),
  ('Dalalven Vattenkraft', 'Gavle',      3, 28.00, '1965-01-15', 654000.00),
  ('Uppsalafjarden Vind',  'Uppsala',    2, 18.75, '1989-01-15', 321000.00),
  ('Kiruna Solcell II',    'Kiruna',     1,  8.00, '1985-01-15', 164000.00),
  ('Lund Geotermisk',      'Malmo',      4,  5.50, '1981-01-15', 154000.00),
  ('Norrkoping Vindpark',  'Norrkoping', 2, 32.00, '2001-02-03', 480000.00),
  ('Koping Biogas',        'Koping',     5, 11.20, '2000-02-06', 221000.00),
  ('Stockholm Soltak',     'Stockholm',  1,  6.40, '1999-03-04', 195000.00),
  ('Angermalven Kraft',    'Vastmanland',3, 45.00, '2002-03-03', 820000.00),
  ('Bodensol',             'Kiruna',     1,  9.80, '2022-09-21', 265000.00);

INSERT INTO asset_registrations (asset_id, asset_manager_id, asset_location_id, review_score) VALUES
  (1, 1, 1, 8.5),(1, 2, 2, 7.0),(2, 3, 1, 9.0),(3, 2, 3, 6.0),
  (4, 1, 8, 7.5),(5, 3, 4, 8.0),(6, 4, 7, 9.5),(7, 5, 4, 7.0),
  (8, 1, 5, 6.5),(9, 6,10, 9.0),(10,2, 8, 8.0);

INSERT INTO daily_cash_flows (asset_id, flow_date, transaction_type, amount, trade_details) VALUES
  (1,'2024-01-15','Revenue',        95000.00,'Grid export Jan'),
  (1,'2024-01-15','Operating Cost', -8200.00,'Maintenance contract Q1'),
  (1,'2024-02-15','Revenue',        88000.00,'Grid export Feb'),
  (1,'2024-03-15','Revenue',       102000.00,'Grid export Mar'),
  (2,'2024-01-15','Revenue',        62000.00,'Hydro output Jan'),
  (2,'2024-01-15','Operating Cost', -5500.00,'Operations Q1'),
  (2,'2024-02-15','Revenue',        58000.00,'Hydro output Feb'),
  (2,'2024-03-15','Revenue',        71000.00,'Hydro output Mar'),
  (3,'2024-01-15','Revenue',        28000.00,'Wind export Jan'),
  (3,'2024-02-15','Revenue',        31000.00,'Wind export Feb'),
  (3,'2024-02-15','Operating Cost', -4100.00,'Turbine servicing'),
  (3,'2024-03-15','Revenue',        35000.00,'Wind export Mar'),
  (6,'2024-01-15','Revenue',        41000.00,'Wind park Jan'),
  (6,'2024-02-15','Revenue',        44000.00,'Wind park Feb'),
  (6,'2024-03-15','Revenue',        48000.00,'Wind park Mar'),
  (9,'2024-01-15','Revenue',        75000.00,'Hydro output Jan'),
  (9,'2024-02-15','Revenue',        69000.00,'Hydro output Feb'),
  (9,'2024-03-15','Revenue',        82000.00,'Hydro output Mar');

INSERT INTO maintenance_records (asset_id, maintenance_date, activity, cost, performed_by) VALUES
  (1, '2024-01-10','Panel cleaning and inspection',    12500.00,'SolarTech AB'),
  (2, '2024-02-05','Turbine bearing replacement',      48000.00,'HydroService Nord'),
  (3, '2024-02-12','Blade inspection and rebalancing', 22000.00,'Vindkraft Service'),
  (6, '2024-03-01','Gearbox oil change',                8500.00,'Vindkraft Service'),
  (9, '2024-01-20','Generator winding inspection',     31000.00,'HydroService Nord'),
  (10,'2024-03-15','Inverter firmware update',          3200.00,'SolarTech AB');
