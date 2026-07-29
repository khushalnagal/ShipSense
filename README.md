# Trekly: Delivery Performance Analysis

Trekly analyzes delivery performance and financial cost exposure across
logistics partners, regions and vehicle types. It is built end-to-end in
three tools, each doing one job:

| Tool     | Job                                                        |
|----------|-------------------------------------------------------------|
| Excel    | First look at the raw file - observe obvious issues            |
| SQL      | Cleaning + all analytical logic (dedupe, rates, rankings)   |
| Power BI | Dashboard, connected straight to the SQL output              |

---

## 1. The Business Problem

Logistics operations are usually monitored using **delay rate** - the
percentage of deliveries that are late or failed per partner/region/vehicle
combination. This project starts from a simple question: **is delay rate
actually the right metric to prioritize action on?**

A delayed low-value package and a failed high-value package are not
equally costly to the business, even if they show up the same way in a
delay-rate report. Trekly instead estimates the **financial cost
exposure** of each lane and compares that ranking against the traditional
delay-rate ranking.

## 2. Dataset

- 25,000 raw delivery records, cleaned down to 24,500 (see Step 1 and
  Methodology below).
- Fields include delivery partner, region, vehicle type, delivery mode,
  weather condition, distance, package weight, delivery status, rating
  and delivery cost.

## 3. Step 1 - Excel Quick Pass Findings

Full notes in `excel/quick_pass_notes.md`. Summary:

- **`delivery_id`**: two corrupted placeholder values (`250.99` and
  `24750.01`), each repeated exactly 250 times - 500 junk rows total.
  Every other id was already unique.
- **`delivery_time_hours` / `expected_time_hours`**: `00:00.0` on all
  25,000 rows, no real data present. Dropped entirely.
- **`delayed` flag**: disagreed with `delivery_status` (6,669 "yes" vs
  5,341 "delayed" status). Dropped in favor of `delivery_status`.
- No nulls anywhere in the raw file.

## 4. Methodology

**Cost exposure model.** Since real financial/return-logistics cost data
wasn't available, cost impact is estimated using two weights, chosen to
mirror real logistics cost mechanisms rather than picked arbitrarily:

- **Delayed delivery** → 10% of delivery cost (single-tier SLA-style
  penalty)
- **Failed delivery** → delivery cost × 1.5 (original cost + estimated
  reverse logistics / re-delivery overhead)

These weights are still estimates, not sourced financial data - stated
explicitly rather than presented as fact.

**Lane definition.** A "lane" is a combination of delivery partner, region
and vehicle type. Lanes with fewer than 20 deliveries are excluded from
ranking to avoid noisy small-sample results.

## 5. Key Finding

Comparing lanes ranked by cost exposure against the same lanes ranked by
delay rate shows a significant mismatch. For example, `blue dart / south /
truck` ranks #1 by cost exposure (₹19,922) but only 37th by delay rate
(32.2% problem rate) - a lane a delay-rate-only report would never flag,
despite carrying the highest financial risk in the dataset.

This means a delay-rate-only monitoring approach would miss most of the
lanes actually responsible for the highest financial impact.

## 6. Project Structure

```
Trekly/
├── excel/
│   └── quick_pass_notes.md            # Step 1 findings from the raw file
├── sql/
│   ├── 01_create_staging_table.sql    # Loose-typed table for the raw CSV
│   ├── 02_load_raw_data.sql           # Load raw CSV into staging
│   ├── 03_create_deliveries_table.sql # Final, typed schema
│   ├── 04_clean_and_load.sql          # Dedupe, drop dead columns, filter, load
│   ├── 05_delay_rate_by_lane.sql      # Delay/failure rate by lane, saved as view
│   ├── 06_cost_exposure_by_lane.sql   # Cost exposure by lane
│   └── 07_priority_lanes.sql          # Worst lanes missed by delay-rate-only view
├── powerbi/
│   └── Trekly_DB.pdf                  # Final dashboard export
├── .gitignore
└── README.md
```

## 7. How to Run

```
1. Open the raw CSV in Excel, do a quick pass (Step 1) - see excel/quick_pass_notes.md
2. Run sql/01 -> 02 -> 03 -> 04 in order in MySQL Workbench to clean and load the data
3. Run sql/05, 06, 07 to build the analysis views
4. Connect Power BI to the MySQL database, load deliveries / delay_rate_by_lane / priority_lanes
```

## 8. Assumptions & Limitations

- Cost weights (10% delay, ×1.5 failure) are estimates modeled on typical
  SLA penalty and reverse-logistics structures, not sourced financial
  data - see Methodology.
- Single flat table with no separate time dimension - the two raw time
  columns contained no usable data (see Step 1).
- Lane rankings use a minimum sample size of 20 deliveries to avoid
  small-sample noise.
