# CSCU9B3 Assignment 1 — Proof of Process

Student ID: 30068298

This repository holds the working material behind the hospital internal control
database report submitted for CSCU9B3 Assignment 1. It is the evidence of the
process, not a second copy of the deliverable.

## What is here

- `sql/schema.sql` — the final DDL: six tables with primary keys, foreign keys,
  CHECK constraints and the indexes added after the execution-plan review.
- `sql/queries.sql` — the six required queries, each written against the schema
  above and tested on the sample data.
- `data/` — the four CSV files used as the import source for every entity
  (each entity has at least ten rows, as required by the brief).
- `report/report_main.tex` — the LaTeX source of the report, in IEEEtran format.
- `report/report_30068298.pdf` — the compiled report.
- `README_workbuddy.md` — the working notes kept while building the schema and
  the queries: what was tried, what changed and why.

## Order of work

1. Read the brief and listed the required entities and the six query patterns.
2. Wrote the ER model, normalised to third normal form, and checked each table
   against the ten-row rule before writing any SQL.
3. Wrote the DDL, imported the sample CSVs, and ran the six queries one at a
   time, fixing the schema whenever a query needed a join that was not modelled.
4. Reviewed the execution plans and added the indexes described in the report.
5. Wrote the report, then revised it after feedback: the mean-visits query was
   rewritten because the first version silently dropped a row with a NULL value,
   and the department names in one result table were truncated and had to be
   re-run against the real data.

## Notes on the sample data

The CSV files are hand-built to satisfy the constraints rather than invented at
random: every foreign key resolves, the maintenance log includes a NULL
completion date for open jobs, and one supplier has no assets so that the outer
join in the third query returns a row.
