-- =====================================================================
-- Hospital Asset & Maintenance Internal Control System
-- CSCU9B3 Database Assignment - Schema, data load and sample inserts
-- Target: MySQL 8.0, engine InnoDB, charset utf8mb4
-- =====================================================================

CREATE DATABASE IF NOT EXISTS hospital_ic
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospital_ic;

-- ---------------------------------------------------------------------
-- 1. DEPARTMENT: hospital units that own and use assets.
-- ---------------------------------------------------------------------
CREATE TABLE department (
  dept_id       INT           NOT NULL,
  dept_name     VARCHAR(60)   NOT NULL,
  floor         INT           NOT NULL,
  budget_annual DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (dept_id),
  UNIQUE (dept_name)
);

-- ---------------------------------------------------------------------
-- 2. SUPPLIER: external vendors that sell and service equipment.
-- ---------------------------------------------------------------------
CREATE TABLE supplier (
  supplier_id   INT         NOT NULL,
  supplier_name VARCHAR(80) NOT NULL,
  contact_phone VARCHAR(30) NOT NULL,
  city          VARCHAR(40) NOT NULL,
  rating        INT         NOT NULL CHECK (rating BETWEEN 1 AND 5),
  PRIMARY KEY (supplier_id),
  UNIQUE (supplier_name)
);

-- ---------------------------------------------------------------------
-- 3. ASSET: a medical device owned by the hospital.
--    asset_tag is a business key (e.g. AST-2024-002) chosen as PK
--    so that maintenance records can reference it directly.
-- ---------------------------------------------------------------------
CREATE TABLE asset (
  asset_tag    VARCHAR(12)   NOT NULL,
  asset_name   VARCHAR(80)   NOT NULL,
  category     VARCHAR(30)   NOT NULL,
  purchase_date DATE         NOT NULL,
  price        DECIMAL(12,2) NOT NULL,
  dept_id      INT           NOT NULL,
  supplier_id  INT           NOT NULL,
  PRIMARY KEY (asset_tag),
  FOREIGN KEY (dept_id)     REFERENCES department(dept_id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- ---------------------------------------------------------------------
-- 4. MAINTENANCE_LOG: one row per repair visit.
--    COMPOSITE PRIMARY KEY: (asset_tag, service_no).
--    service_no restarts at 1 for every asset, so the pair
--    identifies each visit uniquely. audit_status supports the
--    internal-control workflow: PENDING -> REVIEWED -> AUDITED.
-- ---------------------------------------------------------------------
CREATE TABLE maintenance_log (
  asset_tag     VARCHAR(12)   NOT NULL,
  service_no    INT           NOT NULL,
  service_date  DATE          NOT NULL,
  cost          DECIMAL(10,2) NOT NULL,
  technician    VARCHAR(60)   NOT NULL,
  issue_desc    VARCHAR(200)  NOT NULL,
  audit_status  VARCHAR(10)   NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (asset_tag, service_no),
  FOREIGN KEY (asset_tag) REFERENCES asset(asset_tag),
  CHECK (audit_status IN ('PENDING', 'REVIEWED', 'AUDITED'))
);

-- =====================================================================
-- BULK LOAD FROM CSV FILES
-- If MySQL refuses with "secure_file_priv", run the client with
--   --local-infile=1  and execute   SET GLOBAL local_infile = 1;
-- Adjust the paths below to the folder containing the CSVs.
-- =====================================================================

LOAD DATA LOCAL INFILE 'department.csv'
  INTO TABLE department
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'supplier.csv'
  INTO TABLE supplier
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'asset.csv'
  INTO TABLE asset
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'maintenance_log.csv'
  INTO TABLE maintenance_log
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

-- =====================================================================
-- SAMPLE INSERTS (one per entity, as required by the brief)
-- =====================================================================

INSERT INTO department VALUES (11, 'Physiotherapy', 5, 180000);

INSERT INTO supplier VALUES (11, 'Wuxi Heart Systems', '+86-510-82713390', 'Wuxi', 3);

INSERT INTO asset VALUES ('AST-2025-002', 'Infant Warmer IW1', 'Neonatal', '2025-05-09', 74000.00, 10, 7);

INSERT INTO maintenance_log VALUES ('AST-2025-002', 1, '2025-11-20', 880.00, 'Li Na', 'Heater element check', 'PENDING');
