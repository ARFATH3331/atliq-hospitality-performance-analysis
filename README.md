# AtliQ Hospitality Performance Analysis

An end-to-end hospitality analytics project using SQL, Excel, and Power BI to review booking outcomes, realized revenue, and room occupancy across four cities.

## Project summary

The analysis covers May–July 2022 and 134,590 bookings.

| Measure | Result |
| --- | ---: |
| Revenue generated | ₹2,007,546,215 |
| Revenue realized | ₹1,708,771,229 |
| Overall occupancy | 57.9% |
| Cancelled bookings | 33,420 (24.8%) |
| Checked out | 94,411 (70.1%) |
| No shows | 6,759 (5.0%) |

Mumbai generated the highest realized revenue at approximately ₹668.6M. Delhi had the highest occupancy at 60.5%, while Bangalore had the lowest at 55.8%.

## Recommendations

1. Test confirmation reminders and clearer cancellation terms, then measure cancellation rate and realized revenue by city and booking platform.
2. Test targeted offers on lower-demand dates in Bangalore. Track occupied room nights and revenue after discounts.
3. Test room upgrades and bundles in Mumbai while monitoring occupancy and revenue per available room.

## Files

- `Hospitality_project.sql` — SQL queries for city revenue, booking outcomes, occupancy, monthly revenue, booking platforms, cancellation rates, room categories, and daily trends.
- `Hospitality_project.xlsx` — workbook with summary pivots, charts, and dashboard. The source-table tabs are empty in this copy; `Sheet4` contains a 1,000-row query extract.
- `AtliQ_Hospitality_Performance.pbix.pbix` — Power BI report with a Hospitality Dashboard page, KPI cards, and city, month, platform, occupancy, and booking-outcome visuals.

## Tools

- Microsoft SQL Server
- Microsoft Excel
- Microsoft Power BI

## Reproduce the analysis

1. Load the hospitality source tables into SQL Server using the table structure expected by `Hospitality_project.sql`.
2. Run the queries in `Hospitality_project.sql` to reproduce the analysis results.
3. Open the workbook and Power BI report to review the summaries and dashboard.

The workbook's data tabs are not populated in this project copy, so reproducing the full results requires access to the source tables.
