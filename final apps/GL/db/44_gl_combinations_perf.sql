-- =============================================================================
-- GL combinations current-snapshot performance
-- Replaces only GET /gl/combinations. Current-date requests read the hourly
-- refreshed DCT_GL_COA_SNAP; explicit historical as-of requests retain the
-- effective-dated DCT_GL_COA_V path. No financial result cache is introduced.
-- Re-run after 05_gl_ords.sql. Deploy as ADMIN.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PROCEDURE setup_gl_combinations_perf_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'gl.rest',p_pattern=>'combinations');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'gl.rest',p_pattern=>'combinations',p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>REPLACE(q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
  l_sector VARCHAR2(60)  := [COLON]sector;
  l_chap   VARCHAR2(60)  := [COLON]chapter;
  l_prog   VARCHAR2(60)  := [COLON]program;
  l_asof   VARCHAR2(20)  := [COLON]asof;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR),50),500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0),0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_asof IS NOT NULL THEN dct_gl_class_pkg.set_asof(TO_DATE(l_asof,'YYYY-MM-DD'));
  ELSE dct_gl_class_pkg.clear_asof; END IF;

  WITH coa AS (
    SELECT * FROM dct_gl_coa_snap WHERE l_asof IS NULL
    UNION ALL
    SELECT * FROM dct_gl_coa_v WHERE l_asof IS NOT NULL
  )
  SELECT COUNT(*) INTO l_total FROM coa v
   WHERE (l_search IS NULL OR UPPER(v.cc_string||' '||v.cost_center_desc||' '||v.account_desc) LIKE '%'||UPPER(l_search)||'%')
     AND (l_sector IS NULL OR v.sector_code=l_sector)
     AND (l_chap IS NULL OR v.chapter_code=l_chap)
     AND (l_prog IS NULL OR v.program_class_code=l_prog);

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total',l_total); APEX_JSON.write('limit',l_limit); APEX_JSON.write('offset',l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH coa AS (
      SELECT * FROM dct_gl_coa_snap WHERE l_asof IS NULL
      UNION ALL
      SELECT * FROM dct_gl_coa_v WHERE l_asof IS NOT NULL
    )
    SELECT * FROM coa v
     WHERE (l_search IS NULL OR UPPER(v.cc_string||' '||v.cost_center_desc||' '||v.account_desc) LIKE '%'||UPPER(l_search)||'%')
       AND (l_sector IS NULL OR v.sector_code=l_sector)
       AND (l_chap IS NULL OR v.chapter_code=l_chap)
       AND (l_prog IS NULL OR v.program_class_code=l_prog)
     ORDER BY v.cc_id OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',r.cc_id); APEX_JSON.write('ccString',r.cc_string);
    APEX_JSON.write('entityCode',r.entity_code); APEX_JSON.write('entityDesc',NVL(r.entity_desc,''));
    APEX_JSON.write('costCenterCode',r.cost_center_code); APEX_JSON.write('costCenterDesc',NVL(r.cost_center_desc,''));
    APEX_JSON.write('accountCode',r.account_code); APEX_JSON.write('accountDesc',NVL(r.account_desc,''));
    APEX_JSON.write('appropriationCode',r.appropriation_code); APEX_JSON.write('appropriationDesc',NVL(r.appropriation_desc,''));
    APEX_JSON.write('budgetGroupCode',r.budget_group_code); APEX_JSON.write('budgetGroupDesc',NVL(r.budget_group_desc,''));
    APEX_JSON.write('entitySpecificCode',r.entity_specific_code); APEX_JSON.write('entitySpecificDesc',NVL(r.entity_specific_desc,''));
    APEX_JSON.write('future1Code',r.future1_code); APEX_JSON.write('future1Desc',NVL(r.future1_desc,''));
    APEX_JSON.write('future2Code',r.future2_code); APEX_JSON.write('future2Desc',NVL(r.future2_desc,''));
    APEX_JSON.write('intercompanyCode',r.intercompany_code); APEX_JSON.write('intercompanyDesc',NVL(r.intercompany_desc,''));
    APEX_JSON.write('programCode',r.program_code); APEX_JSON.write('programDesc',NVL(r.program_desc,''));
    APEX_JSON.write('sectorCode',NVL(r.sector_code,'')); APEX_JSON.write('sectorName',NVL(r.sector_name,''));
    APEX_JSON.write('chapterCode',NVL(r.chapter_code,'')); APEX_JSON.write('chapterName',NVL(r.chapter_name,''));
    APEX_JSON.write('programClassCode',NVL(r.program_class_code,'')); APEX_JSON.write('programName',NVL(r.program_name,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_asof;
EXCEPTION WHEN OTHERS THEN
  dct_gl_class_pkg.clear_asof; dct_rest.err(500,SQLERRM);
END;
!','[COLON]',CHR(58)));
END;
/
SHOW ERRORS
BEGIN setup_gl_combinations_perf_tmp; COMMIT; END;
/
DROP PROCEDURE setup_gl_combinations_perf_tmp;

SELECT t.uri_template,h.method,LENGTH(h.source) source_length
  FROM user_ords_templates t JOIN user_ords_handlers h ON h.template_id=t.id
 WHERE t.uri_template='combinations' AND h.method='GET';
PROMPT GL/db/44 combinations performance complete.
EXIT
