-- Staging table: mirrors the RAW CSV exactly, no type enforcement. Everything that's known to be dirty (delivery_id, the two time columns,
-- the redundant 'delayed' flag) is loaded as VARCHAR so a bad row can't fail the load. Cleaning/casting happens in 04_clean_and_load.sql.

CREATE DATABASE IF NOT EXISTS trekly;
USE trekly;

CREATE TABLE deliveries_staging (
    delivery_id          VARCHAR(50),
    delivery_partner      VARCHAR(50),
    package_type          VARCHAR(50),
    vehicle_type          VARCHAR(50),
    delivery_mode         VARCHAR(50),
    region                VARCHAR(50),
    weather_condition     VARCHAR(50),
    distance_km           VARCHAR(50),
    package_weight_kg     VARCHAR(50),
    delivery_status       VARCHAR(50),
    delivery_rating       VARCHAR(50),
    delivery_cost         VARCHAR(50),
    delivery_time_hours   VARCHAR(50),
    expected_time_hours   VARCHAR(50),
	is_delayed_flag       VARCHAR(50)
);

