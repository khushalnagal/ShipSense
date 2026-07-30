-- Load the RAW CSV (before any pandas/Excel cleaning) into the staging table.
-- Run via MySQL CLI with --local-infile=1 (Workbench 8.0.46 GUI doesn't
-- expose this client-side setting).

USE trekly;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/Trekly/Data/Delivery_Logistics.csv'
INTO TABLE deliveries_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(delivery_id, delivery_partner, package_type, vehicle_type, delivery_mode,
 region, weather_condition, distance_km, package_weight_kg,
 delivery_time_hours, expected_time_hours, is_delayed_flag,
 delivery_status, delivery_rating, delivery_cost);	
