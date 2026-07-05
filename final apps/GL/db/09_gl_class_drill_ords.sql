-- =============================================================================
-- General Ledger (App 210) -- Classification assignments drill (ADDITIVE)
-- File    : 09_gl_class_drill_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @09_gl_class_drill_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07, 08 AND this script right after it. The same handler
--            source is ALSO synced into 05 (GET mappings), so a full 05 re-run
--            already carries it; this script exists to deploy the change
--            additively without republishing the module.
-- Change  : UPGRADES the existing GET /gl/mappings handler (upsert):
--   + ?valueid=  filter (all assignments of ONE classification value -- the
--     Classifications page row-click drawer)
--   + segmentDesc per row (cost-centre / appropriation / program description
--     from the GL_SRC_* dimension, matched on the normalized segment value)
-- No new synonyms (class tables + gl_src_* dims already synonymed in 05).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_clsdrill_ords_tmp AS
BEGIN

    ORDS.DEFINE_HANDLER(
        p_module_name => 'gl.rest',
        p_pattern     => 'mappings',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30)  := UPPER([COLON]type);
  l_seg  VARCHAR2(60)  := [COLON]segment;
  l_vid  NUMBER        := TO_NUMBER([COLON]valueid DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT m.map_id, m.class_type_code, m.segment_value, m.class_value_id,
           v.value_code, v.name_en, m.notes,
           TO_CHAR(m.start_date,'YYYY-MM-DD') start_d,
           TO_CHAR(m.end_date,'YYYY-MM-DD')   end_d,
           CASE WHEN TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '4000-01-01')
                THEN 'Y' ELSE 'N' END is_current,
           sd.descr AS seg_desc
    FROM dct_gl_seg_class_map m
    JOIN dct_gl_class_value v ON v.class_value_id = m.class_value_id
    JOIN dct_gl_class_type  t ON t.class_type_code = m.class_type_code
    LEFT JOIN (
      SELECT 'COST_CENTER' AS seg_key, dct_gl_class_pkg.norm(cost_center,7) AS sv,
             MAX(cost_center_description) AS descr
        FROM gl_src_cost_centers GROUP BY dct_gl_class_pkg.norm(cost_center,7)
      UNION ALL
      SELECT 'APPROPRIATION', dct_gl_class_pkg.norm(appropriation_code,6),
             MAX(appropriation_description)
        FROM gl_src_appropriation GROUP BY dct_gl_class_pkg.norm(appropriation_code,6)
      UNION ALL
      SELECT 'PROGRAM_CODE', dct_gl_class_pkg.norm(program_code,6),
             MAX(program_description)
        FROM gl_src_program GROUP BY dct_gl_class_pkg.norm(program_code,6)
    ) sd ON sd.seg_key = t.segment_key AND sd.sv = m.segment_value
    WHERE (l_type IS NULL OR m.class_type_code = l_type)
      AND (l_seg  IS NULL OR m.segment_value = l_seg)
      AND (l_vid  IS NULL OR m.class_value_id = l_vid)
    ORDER BY m.class_type_code, m.segment_value, m.start_date DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('mapId', r.map_id); APEX_JSON.write('type', r.class_type_code);
    APEX_JSON.write('segmentValue', r.segment_value); APEX_JSON.write('segmentDesc', NVL(r.seg_desc,''));
    APEX_JSON.write('classValueId', r.class_value_id);
    APEX_JSON.write('valueCode', r.value_code); APEX_JSON.write('valueName', r.name_en);
    APEX_JSON.write('startDate', r.start_d); APEX_JSON.write('endDate', NVL(r.end_d,''));
    APEX_JSON.write('notes', NVL(r.notes,'')); APEX_JSON.write('isCurrent', r.is_current);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));

    COMMIT;
END setup_gl_clsdrill_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_clsdrill_ords_tmp
DROP PROCEDURE setup_gl_clsdrill_ords_tmp;

PROMPT gl.rest GET /mappings upgraded (valueid filter + segmentDesc).
EXIT
