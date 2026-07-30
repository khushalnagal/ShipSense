-- Cleans deliveries_staging and loads the result into deliveries.
-- Logic below is based on CONFIRMED findings from the Step 1 Excel pass
-- on the actual raw file, not assumptions:
--
--   * delivery_id: exactly two junk values, 250.99 and 24750.01, each
--     repeated 250 times (500 junk rows). Every other id is a clean,
--     already-unique whole number from 251 to 24750.
--   * delivery_time_hours / expected_time_hours: '00:00.0' on all 25,000
--     rows, no exceptions. Nothing to recover, so these columns are
--     dropped rather than cast.
--   * delayed: disagrees with delivery_status (6,669 'yes' vs 5,341
--     'delayed' status), so it's dropped in favor of delivery_status.
--   * No nulls anywhere in the raw file, so no null-filtering needed.

USE trekly;

INSERT INTO deliveries (
    delivery_id, delivery_partner, package_type, vehicle_type, delivery_mode,
    region, weather_condition, distance_km, package_weight_kg,
    delivery_status, delivery_rating, delivery_cost
)
SELECT
    CAST(delivery_id AS UNSIGNED),
    delivery_partner,
    package_type,
    vehicle_type,
    delivery_mode,
    region,
    weather_condition,
    CAST(distance_km AS DECIMAL(6,2)),
    CAST(package_weight_kg AS DECIMAL(6,2)),
    delivery_status,
    CAST(delivery_rating AS UNSIGNED),
    CAST(delivery_cost AS DECIMAL(8,2))
FROM deliveries_staging
WHERE delivery_id NOT IN (250.99, 24750.01);

-- Sanity check: should be 24,500 (25,000 raw rows minus the 500 junk-id rows)
SELECT COUNT(*) AS rows_loaded FROM deliveries;


