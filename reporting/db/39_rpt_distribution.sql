-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 39 Report Distributions (To/Cc/Bcc)
-- File   : reporting/db/39_rpt_distribution.sql
-- Run as : sql -name prod_mcp   (FRESH session -- synonym rule, ORA-01471)
-- Purpose: scoped report distribution lists for the GL "Generate and Send"
--          feature (Budget Utilization): one row per Sector / Cost Centre with
--          its own To / Cc / Bcc recipient set, an optional subject template,
--          and a batch header grouping the runs of one send action. A run
--          carrying dist_id is emailed by the Python worker as ONE message
--          (To + Cc headers, Bcc envelope-only) instead of the legacy
--          one-message-per-recipient loop.
-- Safety : config key EMAIL_TEST_MODE ships 'Y' (test mode ON) -- while ON the
--          worker sends ONLY to EMAIL_TEST_TO, never the defined recipients,
--          and stamps the run is_test='Y'. With no test address configured the
--          delivery is skipped entirely. Real recipients need a deliberate
--          admin flip of BOTH EMAIL_ENABLED and EMAIL_TEST_MODE.
-- Objects: DCT_RPT_DIST, DCT_RPT_DIST_RECIP, DCT_RPT_DIST_BATCH,
--          columns on DCT_RPT_RUN (dist_id, batch_id, is_test, email_subject)
--          and DCT_RPT_DELIVERY (disposition), lookups, config keys,
--          privilege GL_MANAGE_REPORT_DIST, ADMIN synonyms.
-- Idempotent: guarded creates/alters, count-then-insert seeds (no MERGE --
--          Linux SQLcl swallows MERGE-bearing blocks).
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RPT_DIST (one row per distribution scope) ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_dist (
      dist_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      dist_group    VARCHAR2(40)  DEFAULT 'GL_BUTIL' NOT NULL,
      scope_type    VARCHAR2(20)  NOT NULL,
      scope_value   VARCHAR2(240) NOT NULL,
      scope_label   VARCHAR2(240),
      sector_name   VARCHAR2(240),
      subject_tpl   VARCHAR2(400),
      enabled       CHAR(1)       DEFAULT 'Y' NOT NULL,
      created_by    VARCHAR2(100),
      created_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by    VARCHAR2(100),
      updated_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT ck_dct_rpt_dist_enab CHECK (enabled IN ('Y','N')),
      CONSTRAINT uq_dct_rpt_dist UNIQUE (dist_group, scope_type, scope_value)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. DCT_RPT_DIST_RECIP (To/Cc/Bcc addresses per distribution) ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_dist_recip (
      recip_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      dist_id       NUMBER        NOT NULL,
      disposition   VARCHAR2(10)  NOT NULL,
      email         VARCHAR2(320) NOT NULL,
      display_name  VARCHAR2(240),
      enabled       CHAR(1)       DEFAULT 'Y' NOT NULL,
      created_by    VARCHAR2(100),
      created_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by    VARCHAR2(100),
      updated_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_dct_rpt_dr_dist FOREIGN KEY (dist_id)
        REFERENCES prod.dct_rpt_dist (dist_id) ON DELETE CASCADE,
      CONSTRAINT ck_dct_rpt_dr_enab CHECK (enabled IN ('Y','N'))
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_dr_dist ON prod.dct_rpt_dist_recip (dist_id)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 3. DCT_RPT_DIST_BATCH (one Generate-and-Send action) ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_dist_batch (
      batch_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      dist_group    VARCHAR2(40)  DEFAULT 'GL_BUTIL' NOT NULL,
      level_code    VARCHAR2(20)  NOT NULL,
      criteria_json CLOB,
      formats       VARCHAR2(40),
      requested_by  VARCHAR2(100),
      created_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT ck_dct_rpt_db_cjson CHECK (criteria_json IS NULL OR criteria_json IS JSON)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 4. Columns on DCT_RPT_RUN + DCT_RPT_DELIVERY (guarded) ===
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_run ADD (dist_id NUMBER)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_run ADD (batch_id NUMBER)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_rpt_run ADD (is_test VARCHAR2(1) DEFAULT 'N')]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_run ADD (email_subject VARCHAR2(400))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_delivery ADD (disposition VARCHAR2(10))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_run_batch ON prod.dct_rpt_run (batch_id)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 5. ADMIN synonyms (fresh-session rule applies) ===
CREATE OR REPLACE SYNONYM dct_rpt_dist FOR prod.dct_rpt_dist;
CREATE OR REPLACE SYNONYM dct_rpt_dist_recip FOR prod.dct_rpt_dist_recip;
CREATE OR REPLACE SYNONYM dct_rpt_dist_batch FOR prod.dct_rpt_dist_batch;

PROMPT === 6. Lookup vocabularies (count-then-insert, no MERGE) ===
DECLARE
  l_cat NUMBER;
  v     NUMBER;

  PROCEDURE up_cat(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
  BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_lookup_categories WHERE category_code = p_code;
    IF v = 0 THEN
      INSERT INTO prod.dct_lookup_categories
        (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
      VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y');
    END IF;
    SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
  END;

  PROCEDURE up_val(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                   p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
  BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_lookup_values
     WHERE category_id = p_cat AND value_code = p_code;
    IF v = 0 THEN
      INSERT INTO prod.dct_lookup_values
        (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y');
    END IF;
  END;
BEGIN
  up_cat('RPT_DIST_SCOPE', 'Report Distribution Scope',
         UNISTR('\0646\0637\0627\0642 \062A\0648\0632\064A\0639 \0627\0644\062A\0642\0631\064A\0631'), l_cat);
  up_val(l_cat, 'SECTOR',     'Sector',      UNISTR('\0627\0644\0642\0637\0627\0639'), 10, 'Y');
  up_val(l_cat, 'COSTCENTER', 'Cost Centre', UNISTR('\0645\0631\0643\0632 \0627\0644\062A\0643\0644\0641\0629'), 20);

  up_cat('RPT_DISPOSITION', 'Email Disposition',
         UNISTR('\0646\0648\0639 \0627\0644\0645\0631\0633\0644 \0625\0644\064A\0647'), l_cat);
  up_val(l_cat, 'TO',  'To',  UNISTR('\0625\0644\0649'), 10, 'Y');
  up_val(l_cat, 'CC',  'Cc',  UNISTR('\0646\0633\062E\0629'), 20);
  up_val(l_cat, 'BCC', 'Bcc', UNISTR('\0646\0633\062E\0629 \0645\062E\0641\064A\0629'), 30);

  up_cat('RPT_DIST_LEVEL', 'Report Distribution Level',
         UNISTR('\0645\0633\062A\0648\0649 \062A\0648\0632\064A\0639 \0627\0644\062A\0642\0631\064A\0631'), l_cat);
  up_val(l_cat, 'SECTOR',     'Sector Level',     UNISTR('\0645\0633\062A\0648\0649 \0627\0644\0642\0637\0627\0639'), 10, 'Y');
  up_val(l_cat, 'DEPARTMENT', 'Department Level', UNISTR('\0645\0633\062A\0648\0649 \0627\0644\0625\062F\0627\0631\0629'), 20);
  up_val(l_cat, 'PROJECT',    'Project Level',    UNISTR('\0645\0633\062A\0648\0649 \0627\0644\0645\0634\0631\0648\0639'), 30);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('RPT_DIST_* lookups seeded.');
END;
/

PROMPT === 7. Config keys (count-then-insert; test mode ships ON) ===
DECLARE
  v NUMBER;
  PROCEDURE c(p_key VARCHAR2, p_val VARCHAR2, p_type VARCHAR2, p_secret VARCHAR2,
              p_enum VARCHAR2, p_desc VARCHAR2, p_ord NUMBER) IS
  BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_rpt_config WHERE config_key = p_key;
    IF v = 0 THEN
      INSERT INTO prod.dct_rpt_config
        (config_key, config_value, value_type, is_secret, enum_values, description, display_order)
      VALUES (p_key, p_val, p_type, p_secret, p_enum, p_desc, p_ord);
    END IF;
  END;
BEGIN
  c('EMAIL_TEST_MODE', 'Y', 'BOOL', 'N', NULL,
    'Distribution test mode -- Y routes EVERY distribution email to EMAIL_TEST_TO only (never the defined To/Cc/Bcc) and stamps the run as TEST', 62);
  c('EMAIL_TEST_TO', '', 'STRING', 'N', NULL,
    'Test mailbox(es) for distribution test mode, comma-separated. Empty while test mode is ON = distribution emails are skipped entirely', 64);
  COMMIT;
END;
/

PROMPT === 8. Privilege seed (Security Console) ===
DECLARE
  l_gl NUMBER;
  v    NUMBER;
BEGIN
  SELECT MAX(module_id) INTO l_gl FROM prod.dct_modules WHERE module_code = 'GL';
  SELECT COUNT(*) INTO v FROM prod.dct_permissions WHERE permission_code = 'GL_MANAGE_REPORT_DIST';
  IF v = 0 THEN
    INSERT INTO prod.dct_permissions
      (permission_code, permission_name, permission_name_ar,
       module_id, action_type, verb, created_by)
    VALUES ('GL_MANAGE_REPORT_DIST', 'Manage Report Recipient Lists',
      UNISTR('\0625\062F\0627\0631\0629 \0642\0648\0627\0626\0645 \0645\0633\062A\0644\0645\064A \0627\0644\062A\0642\0627\0631\064A\0631'),
      l_gl, 'CONFIGURE', 'MANAGE', 'SEED');
  END IF;
  COMMIT;
END;
/

PROMPT === 9. Verification ===
SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD'
   AND object_name IN ('DCT_RPT_DIST', 'DCT_RPT_DIST_RECIP', 'DCT_RPT_DIST_BATCH')
 ORDER BY object_name;

SELECT column_name FROM all_tab_columns
 WHERE owner = 'PROD' AND table_name = 'DCT_RPT_RUN'
   AND column_name IN ('DIST_ID', 'BATCH_ID', 'IS_TEST', 'EMAIL_SUBJECT');

SELECT column_name FROM all_tab_columns
 WHERE owner = 'PROD' AND table_name = 'DCT_RPT_DELIVERY' AND column_name = 'DISPOSITION';

SELECT config_key, config_value FROM prod.dct_rpt_config
 WHERE config_key IN ('EMAIL_TEST_MODE', 'EMAIL_TEST_TO');

SELECT c.category_code, COUNT(*) AS vals
  FROM prod.dct_lookup_categories c
  JOIN prod.dct_lookup_values v ON v.category_id = c.category_id
 WHERE c.category_code IN ('RPT_DIST_SCOPE', 'RPT_DISPOSITION', 'RPT_DIST_LEVEL')
 GROUP BY c.category_code ORDER BY c.category_code;

PROMPT === 39_rpt_distribution.sql complete ===
