-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 12 Interactive Report foundation
-- File   : reporting/db/12_rpt_ir.sql
-- Schema : PROD objects + ADMIN synonym
-- Run as : sql -name prod_mcp  with -Dfile.encoding=UTF-8 (Arabic seed text)
--          FRESH session -- must NOT follow an ALTER SESSION current-schema
--          switch, or the synonym self-references (ORA-01471).
-- Purpose: foundation for the browser Interactive Report (APEX-IR-like grid in
--          the BI app, App 211):
--            a. DCT_RPT_IR_LAYOUT  -- named saved layouts per report per user
--               (visible columns/order, filters, sorts, calculated columns)
--            b. REPORTING module row + BI_USER role -- business-user access to
--               the viewer (assignment happens in the Admin roles UI)
--            c. IR_MAX_ROWS config key -- server row cap for the one-shot
--               capped data fetch the grid works on client-side
-- Idempotent: guarded creates (ORA-00955) + upserts; safe to re-run.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RPT_IR_LAYOUT ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_rpt_ir_layout (
      layout_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      report_code     VARCHAR2(60)  NOT NULL,
      layout_name     VARCHAR2(120) NOT NULL,
      owner_username  VARCHAR2(100) NOT NULL,
      is_shared       CHAR(1)       DEFAULT 'N' NOT NULL,
      is_default      CHAR(1)       DEFAULT 'N' NOT NULL,
      layout_json     CLOB          NOT NULL,
      created_by      VARCHAR2(100),
      created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by      VARCHAR2(100),
      updated_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_dct_rpt_irl_def   FOREIGN KEY (report_code)
        REFERENCES prod.dct_rpt_definition (report_code) ON DELETE CASCADE,
      CONSTRAINT uq_dct_rpt_irl_name  UNIQUE (report_code, owner_username, layout_name),
      CONSTRAINT ck_dct_rpt_irl_shar  CHECK (is_shared IN ('Y','N')),
      CONSTRAINT ck_dct_rpt_irl_defl  CHECK (is_default IN ('Y','N')),
      CONSTRAINT ck_dct_rpt_irl_json  CHECK (layout_json IS JSON)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_rpt_irl_rep ON prod.dct_rpt_ir_layout (report_code, is_shared)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. REPORTING module row (upsert) ===
MERGE INTO prod.dct_modules tgt
USING (
    SELECT 'REPORTING'                AS module_code,
           'Reporting / BI'           AS module_name_en,
           'التقارير وذكاء الأعمال'    AS module_name_ar,
           'APEX_APP'                 AS module_type,
           211                        AS apex_app_id,
           1                          AS apex_page_id,
           'fa-chart-column'          AS icon_class,
           '#1F6F8B'                  AS icon_color,
           '#E8F1F4'                  AS bg_color,
           'Scheduled report distribution and interactive browser reporting over the shared reporting control plane.' AS description_en,
           'توزيع التقارير المجدولة والتقارير التفاعلية عبر المتصفح فوق منصة التقارير المشتركة.' AS description_ar,
           'OPERATIONS'               AS category,
           75                         AS display_order,
           'Y'                        AS is_active,
           'N'                        AS is_new_tab,
           'N'                        AS is_admin_only
    FROM dual
) src ON (tgt.module_code = src.module_code)
WHEN NOT MATCHED THEN
    INSERT (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
            apex_page_id, icon_class, icon_color, bg_color,
            description_en, description_ar, category, display_order,
            is_active, is_new_tab, is_admin_only)
    VALUES (src.module_code, src.module_name_en, src.module_name_ar, src.module_type,
            src.apex_app_id, src.apex_page_id, src.icon_class, src.icon_color, src.bg_color,
            src.description_en, src.description_ar, src.category, src.display_order,
            src.is_active, src.is_new_tab, src.is_admin_only)
WHEN MATCHED THEN
    UPDATE SET module_name_en = src.module_name_en,
               module_name_ar = src.module_name_ar,
               apex_app_id    = src.apex_app_id,
               icon_class     = src.icon_class,
               icon_color     = src.icon_color,
               is_active      = src.is_active;
COMMIT;

PROMPT === 3. BI_USER role (upsert) ===
DECLARE
    v_module_id  prod.dct_modules.module_id%TYPE;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'REPORTING';
    MERGE INTO prod.dct_roles t
    USING (SELECT 'BI_USER' AS role_code FROM dual) s
    ON (t.role_code = s.role_code)
    WHEN NOT MATCHED THEN
        INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
                description_en, is_active, is_system_role, display_order)
        VALUES ('BI_USER', 'BI Report User', 'مستخدم التقارير',
                'MODULE', v_module_id,
                'Business user of the Reporting/BI app: dashboard + interactive report viewer (no admin functions).',
                'Y', 'N', 90)
    WHEN MATCHED THEN
        UPDATE SET role_name_en = 'BI Report User',
                   role_name_ar = 'مستخدم التقارير',
                   module_id    = v_module_id,
                   is_active    = 'Y';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('BI_USER role upserted (module_id=' || v_module_id || ')');
END;
/

PROMPT === 4. IR_MAX_ROWS config key (upsert, never clobbers UI edits) ===
MERGE INTO prod.dct_rpt_config t
USING (SELECT 'IR_MAX_ROWS' AS k FROM dual) s ON (t.config_key = s.k)
WHEN NOT MATCHED THEN
    INSERT (config_key, config_value, value_type, is_secret, enum_values, description, display_order)
    VALUES ('IR_MAX_ROWS', '10000', 'NUMBER', 'N', NULL,
            'Interactive Report row cap -- max rows a browser data fetch returns (grid works client-side on this set)', 130);
COMMIT;

PROMPT === 5. ADMIN synonym (fresh-session rule applies) ===
CREATE OR REPLACE SYNONYM dct_rpt_ir_layout FOR prod.dct_rpt_ir_layout;

PROMPT ============================================================
PROMPT  12_rpt_ir.sql complete.
PROMPT  Layout table + REPORTING module + BI_USER role + IR_MAX_ROWS.
PROMPT ============================================================
