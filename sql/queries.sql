-- =====================================================================
-- Six queries for the Hospital Asset & Maintenance Internal Control
-- System. Each query answers a real internal-control question:
-- finding unusual spending, tracing purchases, and closing audits.
-- Run after schema.sql.
-- =====================================================================

USE hospital_ic;

-- ---------------------------------------------------------------------
-- Query 1: LIKE on an alphanumeric field.
-- Control question: which devices bought in the 2024 purchasing cycle
-- are currently on the books? Asset tags are coded AST-<year>-<serial>,
-- so a simple prefix match extracts one procurement year.
-- ---------------------------------------------------------------------
SELECT asset_tag, asset_name, category, price
FROM asset
WHERE asset_tag LIKE 'AST-2024-%'
ORDER BY price DESC;

-- ---------------------------------------------------------------------
-- Query 2: JOIN across three tables.
-- Control question: for every device, who supplied it and which unit
-- owns it? This is the accountability trail an auditor walks when a
-- device fails: from the asset to the vendor to the responsible unit.
-- ---------------------------------------------------------------------
SELECT a.asset_tag, a.asset_name, s.supplier_name, s.city,
       d.dept_name, a.purchase_date
FROM asset a
JOIN supplier s  ON s.supplier_id = a.supplier_id
JOIN department d ON d.dept_id = a.dept_id
ORDER BY d.dept_name, a.asset_tag;

-- ---------------------------------------------------------------------
-- Query 3: the > operator with a subquery.
-- Control question: which repair visits cost unusually much? A visit
-- above the average repair cost is a red flag worth a second look
-- before the audit is signed off.
-- ---------------------------------------------------------------------
SELECT asset_tag, service_no, service_date, cost, issue_desc
FROM maintenance_log
WHERE cost > (SELECT AVG(cost) FROM maintenance_log)
ORDER BY cost DESC;

-- ---------------------------------------------------------------------
-- Query 4: GROUP BY with SUM and AVG.
-- Control question: how much maintenance money does each unit burn
-- per repair visit, and in total? Units whose repair spend runs far
-- ahead of their peers are either underfunded or sitting on ageing
-- equipment -- both matter for next year's budget review.
-- ---------------------------------------------------------------------
SELECT d.dept_name,
       COUNT(*)              AS visits,
       SUM(m.cost)           AS total_spend,
       AVG(m.cost)           AS avg_visit_cost
FROM maintenance_log m
JOIN asset a        ON a.asset_tag = m.asset_tag
JOIN department d   ON d.dept_id = a.dept_id
GROUP BY d.dept_name
ORDER BY total_spend DESC;

-- ---------------------------------------------------------------------
-- Query 5: IN on a single entity (critical-care equipment categories).
-- Control question: list every device in the four critical-care
-- categories where an equipment failure endangers patients directly.
-- These categories get a mandatory quarterly inspection, so this
-- single-entity subset drives the engineering inspection plan.
-- ---------------------------------------------------------------------
SELECT asset_tag, asset_name, category, price, dept_id
FROM asset
WHERE category IN ('Emergency', 'Respiratory', 'Infusion', 'Anaesthesia')
ORDER BY category, asset_tag;

-- ---------------------------------------------------------------------
-- Query 6: UPDATE affecting at least three rows.
-- Control action: once the junior auditor has reviewed a repair
-- record it still needs the final AUDITED stamp. This bulk-closes
-- every REVIEWED record (6 rows with the sample data), which is the
-- month-end step of the audit workflow.
-- ---------------------------------------------------------------------
START TRANSACTION;

UPDATE maintenance_log
SET audit_status = 'AUDITED'
WHERE audit_status = 'REVIEWED';

COMMIT;

SELECT asset_tag, service_no, service_date, cost, issue_desc, audit_status
FROM maintenance_log
ORDER BY audit_status, asset_tag, service_no;
