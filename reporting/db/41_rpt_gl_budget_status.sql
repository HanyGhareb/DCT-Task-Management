-- Budget Status report definition. No recipients: Print generates downloadable files only.
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
DECLARE
  l_n NUMBER;
  l_entity_handlers NUMBER;
  l_src CLOB := q'~{"required": ["period"], "orientation": "landscape", "sections": [{"key": "cube", "title": "Budget Status", "layout": "table", "sql": "SELECT NVL(p.sector_code,'UNCLASSIFIED') sector, MAX(NVL(p.sector_name,'Unclassified')) sector_name, MAX(s.name_ar) sector_name_ar, NVL(p.cost_center_code,'UNKNOWN') department, MAX(NVL(p.cost_center_desc,NVL(p.cost_center_code,'Unknown'))) department_name, p.chapter_code chapter, SUM(p.budget_ytd) budget, SUM(p.gl_actual_ytd) actual, SUM(p.encumbrance_ytd) encumbrance, SUM(p.funds_available_ytd) funds_available FROM prod.dct_budget_actual_period_v p LEFT JOIN prod.dct_gl_class_value s ON s.class_type_code='SECTOR' AND s.value_code=p.sector_code WHERE p.period_name=:period AND (p.chapter_code IN ('CH1','CH2','CH3') AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4)='1' OR p.chapter_code='CH4' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4)='3' OR p.chapter_code='CH5' AND REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4)='5') AND (NVL(:entity,'ALL')='ALL' OR :entity=NVL(p.entity_class_code,'UNCLASSIFIED')) GROUP BY NVL(p.sector_code,'UNCLASSIFIED'), NVL(p.cost_center_code,'UNKNOWN'), p.chapter_code"}, {"key": "thresholds", "title": "Thresholds", "layout": "table", "sql": "SELECT setting_key, setting_value FROM prod.dct_module_settings WHERE module_id=(SELECT module_id FROM prod.dct_modules WHERE module_code='GL') AND setting_key IN ('BUD_UTIL_NEAR_PCT','BUD_UTIL_OVER_PCT')"}, {"key": "excluded", "title": "Excluded balances", "layout": "table", "sql": "SELECT NVL(SUM(budget_ytd),0) budget, NVL(SUM(gl_actual_ytd),0) actual, NVL(SUM(encumbrance_ytd),0) encumbrance, NVL(SUM(funds_available_ytd),0) funds_available FROM prod.dct_budget_actual_period_v WHERE period_name=:period AND REGEXP_SUBSTR(cc_string,'[^.]+',1,4)='1' AND (chapter_code IS NULL OR chapter_code NOT IN ('CH1','CH2','CH3'))"}]}~';
BEGIN
  -- Match the currently deployed dashboard during the independent ENTITY rollout.
  -- Run in a fresh ADMIN session; re-run after replacing fd/status with GL/db/42.
  SELECT COUNT(*) INTO l_entity_handlers FROM user_ords_handlers h
    JOIN user_ords_templates t ON t.id=h.template_id
    JOIN user_ords_modules m ON m.id=t.module_id
    WHERE m.name='gl.rest' AND t.uri_template='fd/status'
      AND INSTR(LOWER(h.source),'entity_class_code') > 0;
  IF l_entity_handlers = 0 THEN
    l_src := REPLACE(l_src, q'!NVL(p.entity_class_code,'UNCLASSIFIED')!',
      q'!CASE WHEN p.appropriation_code='301439' THEN 'MASTERPIECES' WHEN REGEXP_SUBSTR(p.cc_string,'[^.]+',1,6)='4510700' THEN 'MUSEUMS' WHEN REGEXP_SUBSTR(p.cc_string,'[^.]+',1,6)='4510600' THEN 'ALC' ELSE 'DCT' END!');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Entity classification handlers: '||l_entity_handlers);
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition WHERE report_code='GL_BUDGET_STATUS';
  IF l_n > 0 THEN
    UPDATE prod.dct_rpt_definition SET source_ref=l_src, source_type='MULTI',
      pdf_template='gl_budget_status.html.j2', engine='PYTHON', default_formats='PDF',
      updated_by='SETUP', updated_at=SYSTIMESTAMP
      WHERE report_code='GL_BUDGET_STATUS';
  ELSE
    INSERT INTO prod.dct_rpt_definition
    (report_code,name_en,name_ar,description,category,source_type,source_ref,engine,
     default_formats,pdf_template,params_json,param_spec_json,enabled,created_by,updated_by)
  VALUES ('GL_BUDGET_STATUS','Budget Status','حالة الموازنة',
    'Budget Status dashboard: chapters, sectors and departments, current filters and presentation.',
    'General Ledger','MULTI',l_src,'PYTHON','PDF','gl_budget_status.html.j2','{}',
    '{"period":{"label":"Accounting period","required":true},"entity":{"label":"Entity"}}',
    'Y','SETUP','SETUP');
  END IF;
  COMMIT;
END;
/
SELECT report_code, CASE WHEN source_ref IS JSON THEN 'OK' ELSE 'INVALID' END source_json
 FROM prod.dct_rpt_definition WHERE report_code='GL_BUDGET_STATUS';
