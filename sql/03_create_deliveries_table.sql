-- Final, typed table that 04_clean_and_load.sql populates from staging.
-- This is what the analysis queries (05-07) and Power BI both read from.
--
-- delivery_time_hours, expected_time_hours, and delayed are NOT included here.
-- Confirmed via the Step 1 Excel pass: the two time columns are '00:00.0' on
-- all 25,000 raw rows (no real data to recover), and 'delayed' disagrees with
-- delivery_status (6,669 'yes' vs 5,341 'delayed' status) so it isn't trustworthy.

USE trekly;

DROP TABLE IF EXISTS deliveries;	

CREATE TABLE deliveries (
    delivery_id          INT PRIMARY KEY,
    delivery_partner      VARCHAR(50),
    package_type          VARCHAR(50),
    vehicle_type          VARCHAR(50),
    delivery_mode         VARCHAR(50),
    region                 VARCHAR(50),
    weather_condition     VARCHAR(50),
    distance_km           DECIMAL(6,2),
    package_weight_kg     DECIMAL(6,2),
    delivery_status       VARCHAR(20),
    delivery_rating       INT,
    delivery_cost         DECIMAL(8,2)
);


