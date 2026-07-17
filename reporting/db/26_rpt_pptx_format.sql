-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 26 add PPTX to the RPT_FORMAT lookup
-- File   : reporting/db/26_rpt_pptx_format.sql
-- Purpose: register PowerPoint (PPTX) as a valid report output format so
--          DCT_RPT_PKG.record_output (which calls
--          DCT_LOOKUP_PKG.validate_lookup('RPT_FORMAT', p_format)) accepts a
--          PPTX output. Without this row a PPTX run FAILS with ORA-20090.
-- Data   : additive MERGE into prod.dct_lookup_values under the RPT_FORMAT
--          category (mirrors db/02_rpt_lookups.sql; also added there at source).
-- Idempotent: MERGE upsert; safe to re-run. Standalone (no dependency on 04).
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_cat NUMBER;
BEGIN
  SELECT category_id INTO v_cat
    FROM prod.dct_lookup_categories
   WHERE category_code = 'RPT_FORMAT';

  MERGE INTO prod.dct_lookup_values t
  USING (SELECT v_cat AS category_id, 'PPTX' AS value_code FROM dual) s
  ON (t.category_id = s.category_id AND t.value_code = s.value_code)
  WHEN NOT MATCHED THEN
    INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
    VALUES (v_cat, 'PPTX', 'PowerPoint',
            UNISTR('\0628\0627\0648\0631\0628\0648\064A\0646\062A'), 25, 'N', 'Y')
  WHEN MATCHED THEN
    UPDATE SET t.value_name_en = 'PowerPoint',
               t.value_name_ar = UNISTR('\0628\0627\0648\0631\0628\0648\064A\0646\062A'),
               t.is_active = 'Y';
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('RPT_FORMAT: PPTX registered.');
END;
/

PROMPT === verify ===
SELECT value_code, value_name_en, display_order, is_active
FROM prod.dct_lookup_values v
JOIN prod.dct_lookup_categories c ON c.category_id = v.category_id
WHERE c.category_code = 'RPT_FORMAT'
ORDER BY v.display_order;

PROMPT 26_rpt_pptx_format.sql complete (PPTX is now a valid RPT_FORMAT).
