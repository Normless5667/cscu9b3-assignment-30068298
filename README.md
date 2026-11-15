# CSCU9B3 Assignment 1 — Hospital Asset & Maintenance Internal Control Database

Student ID: `30068298`

This repository contains the SQL scripts, sample data files, and LaTeX report source for **CSCU9B3 Relational Database Systems — Assignment 1**.

## Repository Structure

- `sql/schema.sql` — DDL script creating the four relations (`department`, `supplier`, `asset`, `maintenance_log`) with primary keys, foreign keys, `UNIQUE` and `CHECK` constraints, `LOAD DATA LOCAL INFILE` bulk-load statements, and one sample `INSERT` per entity.
- `sql/queries.sql` — The six required SQL queries (`LIKE`, three-table `JOIN`, `>` with subquery, `GROUP BY` with `SUM`/`AVG`, `IN` on a single entity, and multi-row `UPDATE` with verification `SELECT`).
- `data/` — Comma-separated sample data files (`department.csv` 10 rows, `supplier.csv` 10 rows, `asset.csv` 12 rows, `maintenance_log.csv` 15 rows).
- `report/report_main.tex` — LaTeX source of the IEEE-format report (`IEEEtran`).
- `report/figures/erd.png` — Conceptual ER diagram in Chen notation referenced by `report_main.tex`.
- `report/report_30068298.pdf` — Compiled PDF report.
