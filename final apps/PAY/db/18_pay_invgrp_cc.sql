-- =============================================================================
-- Outsource Payroll Module (App 215) -- Invoice groups on COST CENTERS
-- File    : 18_pay_invgrp_cc.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp   (run BEFORE re-running 16 and 17)
-- Notes   : User change requests 2026-08-09:
--           1) invoice grouping basis = cost centers, not sectors
--           2) group code becomes a NUMBER + new "short code" attribute
--           3) per-employee add/exclude overrides at group level
--           Re-runnable: every step is guarded. The sector map table stays
--           in place for history but the engine no longer reads it.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR CONTINUE

-- Step A: short_code column (takes over the old mnemonic codes)
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tab_columns
  WHERE owner = 'PROD' AND table_name = 'DCT_PAY_INVOICE_GROUP' AND column_name = 'SHORT_CODE';
  IF n = 0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group ADD (short_code VARCHAR2(30))';
    EXECUTE IMMEDIATE 'UPDATE prod.dct_pay_invoice_group SET short_code = group_code WHERE short_code IS NULL';
    COMMIT;
    DBMS_OUTPUT.put_line('A: short_code added + backfilled');
  ELSE
    DBMS_OUTPUT.put_line('A: short_code already present');
  END IF;
END;
/

-- Step B1: cost-center map table (one group per cost center per company)
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables
  WHERE owner = 'PROD' AND table_name = 'DCT_PAY_INVOICE_GROUP_CC';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE prod.dct_pay_invoice_group_cc (
      gcc_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      group_id          NUMBER NOT NULL,
      cost_center_code  VARCHAR2(30) NOT NULL,
      created_by        VARCHAR2(100),
      created_at        DATE DEFAULT SYSDATE,
      CONSTRAINT uq_pay_invgrp_cc UNIQUE (group_id, cost_center_code),
      CONSTRAINT fk_pay_invgrp_cc FOREIGN KEY (group_id)
        REFERENCES prod.dct_pay_invoice_group (group_id) ON DELETE CASCADE)]';
    DBMS_OUTPUT.put_line('B1: dct_pay_invoice_group_cc created');
  ELSE
    DBMS_OUTPUT.put_line('B1: dct_pay_invoice_group_cc already present');
  END IF;
END;
/

-- Step B2: per-employee override table (INCLUDE or EXCLUDE per group)
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables
  WHERE owner = 'PROD' AND table_name = 'DCT_PAY_INVOICE_GROUP_EMP';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE prod.dct_pay_invoice_group_emp (
      govr_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      group_id    NUMBER NOT NULL,
      person_id   NUMBER NOT NULL,
      ovr_mode    VARCHAR2(10) DEFAULT 'INCLUDE' NOT NULL,
      notes       VARCHAR2(400),
      created_by  VARCHAR2(100),
      created_at  DATE DEFAULT SYSDATE,
      CONSTRAINT uq_pay_invgrp_emp UNIQUE (group_id, person_id),
      CONSTRAINT fk_pay_invgrp_emp FOREIGN KEY (group_id)
        REFERENCES prod.dct_pay_invoice_group (group_id) ON DELETE CASCADE)]';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_pay_invgrpemp_person ON prod.dct_pay_invoice_group_emp (person_id)';
    DBMS_OUTPUT.put_line('B2: dct_pay_invoice_group_emp created');
  ELSE
    DBMS_OUTPUT.put_line('B2: dct_pay_invoice_group_emp already present');
  END IF;
END;
/

-- Step B3: override mode vocabulary (lookup-first rule)
DECLARE
  l_cat NUMBER;
  n NUMBER;
  PROCEDURE val (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
    m NUMBER;
  BEGIN
    SELECT COUNT(*) INTO m FROM prod.dct_lookup_values
    WHERE category_id = l_cat AND value_code = p_code;
    IF m = 0 THEN
      INSERT INTO prod.dct_lookup_values
             (category_id, value_code, value_name_en, value_name_ar, display_order, is_active)
      VALUES (l_cat, p_code, p_en, p_ar, p_ord, 'Y');
    END IF;
  END;
BEGIN
  SELECT COUNT(*) INTO n FROM prod.dct_lookup_categories WHERE category_code = 'PAY_GROUP_OVR_MODE';
  IF n = 0 THEN
    INSERT INTO prod.dct_lookup_categories (category_code, category_name_en, category_name_ar, is_active)
    VALUES ('PAY_GROUP_OVR_MODE', 'PAY Invoice Group Override Mode',
            UNISTR('\0646\0645\0637 \062A\062C\0627\0648\0632 \0645\062C\0645\0648\0639\0629 \0627\0644\0641\0627\062A\0648\0631\0629'), 'Y');
  END IF;
  SELECT category_id INTO l_cat FROM prod.dct_lookup_categories WHERE category_code = 'PAY_GROUP_OVR_MODE';
  val('INCLUDE', 'Include employee in this group', UNISTR('\0625\062F\0631\0627\062C \0627\0644\0645\0648\0638\0641 \0641\064A \0647\0630\0647 \0627\0644\0645\062C\0645\0648\0639\0629'), 10);
  val('EXCLUDE', 'Exclude employee from this group', UNISTR('\0627\0633\062A\0628\0639\0627\062F \0627\0644\0645\0648\0638\0641 \0645\0646 \0647\0630\0647 \0627\0644\0645\062C\0645\0648\0639\0629'), 20);
  COMMIT;
  DBMS_OUTPUT.put_line('B3: PAY_GROUP_OVR_MODE vocabulary ready');
END;
/

-- Step C: seed the cost-center map from the observed sector assignments.
-- A cost center spanning two sectors goes to the group holding MOST of its
-- people (lowest group_id on ties); step D preserves the minority employees.
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group_cc;
  IF n = 0 THEN
    INSERT INTO prod.dct_pay_invoice_group_cc (group_id, cost_center_code, created_by)
    SELECT group_id, cc, 'SYSTEM'
    FROM (SELECT g.group_id, a.cost_center_code cc,
                 ROW_NUMBER() OVER (PARTITION BY g.company_id, a.cost_center_code
                                    ORDER BY COUNT(*) DESC, g.group_id) rn
          FROM prod.dct_pay_assignment a
          JOIN prod.dct_pay_payroll p ON p.payroll_code = a.payroll_code
          JOIN prod.dct_pay_invoice_group g
            ON g.company_id = p.company_id AND g.is_active = 'Y'
          JOIN prod.dct_pay_invoice_group_sector s
            ON s.group_id = g.group_id AND s.sector_name = a.sector_name
          WHERE a.status = 'ACTIVE' AND a.assignment_type = 'PRIMARY'
            AND a.cost_center_code IS NOT NULL
          GROUP BY g.company_id, g.group_id, a.cost_center_code)
    WHERE rn = 1;
    COMMIT;
    DBMS_OUTPUT.put_line('C: cost-center map seeded, rows = ' || SQL%ROWCOUNT);
  ELSE
    DBMS_OUTPUT.put_line('C: cost-center map already seeded (' || n || ' rows)');
  END IF;
END;
/

-- Step D: seed employee overrides so the latest run of every company keeps
-- its exact grouping under the new cost-center resolution
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group_emp;
  IF n = 0 THEN
    INSERT INTO prod.dct_pay_invoice_group_emp (group_id, person_id, ovr_mode, notes, created_by)
    SELECT x.stored_gid, x.person_id, 'INCLUDE',
           'Migration 2026-08-09: keeps the sector-era grouping', 'SYSTEM'
    FROM (SELECT gs.group_id stored_gid, re.person_id,
                 COALESCE((SELECT c.group_id
                           FROM prod.dct_pay_invoice_group_cc c
                           JOIN prod.dct_pay_invoice_group g2 ON g2.group_id = c.group_id
                           WHERE g2.company_id = lr.company_id
                             AND c.cost_center_code = a.cost_center_code
                           FETCH FIRST 1 ROWS ONLY),
                          (SELECT MIN(g3.group_id)
                           FROM prod.dct_pay_invoice_group g3
                           WHERE g3.company_id = lr.company_id
                             AND g3.is_default = 'Y' AND g3.is_active = 'Y')) resolved_gid
          FROM prod.dct_pay_run_emp re
          JOIN (SELECT r.run_id, p.company_id,
                       ROW_NUMBER() OVER (PARTITION BY p.company_id ORDER BY r.run_id DESC) rn
                FROM prod.dct_pay_run r
                JOIN prod.dct_pay_payroll p ON p.payroll_id = r.payroll_id) lr
            ON lr.run_id = re.run_id AND lr.rn = 1
          JOIN prod.dct_pay_invoice_group gs
            ON gs.company_id = lr.company_id AND gs.group_code = re.invoice_group_code
          LEFT JOIN prod.dct_pay_assignment a ON a.assignment_id = re.assignment_id) x
    WHERE x.stored_gid <> NVL(x.resolved_gid, -1);
    COMMIT;
    DBMS_OUTPUT.put_line('D: preservation overrides seeded, rows = ' || SQL%ROWCOUNT);
  ELSE
    DBMS_OUTPUT.put_line('D: overrides already present (' || n || ' rows)');
  END IF;
END;
/

-- Step E: group_code becomes a NUMBER (per-company sequence by display order);
-- the run snapshot and charge tables convert with it
DECLARE
  l_type VARCHAR2(30);
BEGIN
  SELECT data_type INTO l_type FROM all_tab_columns
  WHERE owner = 'PROD' AND table_name = 'DCT_PAY_INVOICE_GROUP' AND column_name = 'GROUP_CODE';
  IF l_type = 'VARCHAR2' THEN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group ADD (group_no NUMBER)';
    EXECUTE IMMEDIATE q'[UPDATE prod.dct_pay_invoice_group g
      SET group_no = (SELECT t.rn
                      FROM (SELECT group_id,
                                   ROW_NUMBER() OVER (PARTITION BY company_id
                                                      ORDER BY display_order, group_id) rn
                            FROM prod.dct_pay_invoice_group) t
                      WHERE t.group_id = g.group_id)]';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_run_emp ADD (grp_no NUMBER)';
    EXECUTE IMMEDIATE q'[UPDATE prod.dct_pay_run_emp re
      SET grp_no = (SELECT g.group_no
                    FROM prod.dct_pay_invoice_group g
                    JOIN prod.dct_pay_payroll p ON p.company_id = g.company_id
                    JOIN prod.dct_pay_run r ON r.payroll_id = p.payroll_id
                    WHERE r.run_id = re.run_id AND g.group_code = re.invoice_group_code)
      WHERE re.invoice_group_code IS NOT NULL]';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_run_charge ADD (grp_no NUMBER)';
    EXECUTE IMMEDIATE q'[UPDATE prod.dct_pay_run_charge rc
      SET grp_no = (SELECT g.group_no
                    FROM prod.dct_pay_invoice_group g
                    JOIN prod.dct_pay_payroll p ON p.company_id = g.company_id
                    JOIN prod.dct_pay_run r ON r.payroll_id = p.payroll_id
                    WHERE r.run_id = rc.run_id AND g.group_code = rc.invoice_group_code)
      WHERE rc.invoice_group_code IS NOT NULL]';
    COMMIT;
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group DROP CONSTRAINT uq_pay_invgrp';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group DROP COLUMN group_code';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group RENAME COLUMN group_no TO group_code';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group MODIFY (group_code NOT NULL, short_code NOT NULL)';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group ADD CONSTRAINT uq_pay_invgrp UNIQUE (company_id, group_code)';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_invoice_group ADD CONSTRAINT uq_pay_invgrp_short UNIQUE (company_id, short_code)';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_run_emp DROP COLUMN invoice_group_code';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_run_emp RENAME COLUMN grp_no TO invoice_group_code';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_run_charge DROP COLUMN invoice_group_code';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_pay_run_charge RENAME COLUMN grp_no TO invoice_group_code';
    DBMS_OUTPUT.put_line('E: group_code is now NUMBER across group, run snapshot and charges');
  ELSE
    DBMS_OUTPUT.put_line('E: group_code already NUMBER');
  END IF;
END;
/

-- Recompile sweep: the column swap invalidates dependent bodies
BEGIN
  FOR o IN (SELECT object_name, object_type FROM all_objects
            WHERE owner = 'PROD' AND status = 'INVALID'
              AND object_type IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'VIEW', 'TRIGGER')) LOOP
    BEGIN
      IF o.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || o.object_name || ' COMPILE BODY';
      ELSE
        EXECUTE IMMEDIATE 'ALTER ' || o.object_type || ' prod.' || o.object_name || ' COMPILE';
      END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  END LOOP;
END;
/

PROMPT === verification ===
SELECT group_id, company_id, group_code, short_code, is_default, is_active
FROM prod.dct_pay_invoice_group ORDER BY company_id, group_code;

SELECT g.group_id, g.short_code, COUNT(c.gcc_id) cc_count
FROM prod.dct_pay_invoice_group g
LEFT JOIN prod.dct_pay_invoice_group_cc c ON c.group_id = g.group_id
GROUP BY g.group_id, g.short_code ORDER BY g.group_id;

SELECT o.group_id, o.person_id, o.ovr_mode, o.notes
FROM prod.dct_pay_invoice_group_emp o ORDER BY o.group_id, o.person_id;

SELECT re.run_id, re.invoice_group_code, COUNT(*) cnt
FROM prod.dct_pay_run_emp re GROUP BY re.run_id, re.invoice_group_code ORDER BY 1, 2;

SELECT COUNT(*) invalid_after FROM all_objects
WHERE owner = 'PROD' AND status = 'INVALID';
