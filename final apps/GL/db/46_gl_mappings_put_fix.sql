-- =============================================================================
-- General Ledger (App 210) -- Chart of Accounts -- classification ASSIGNMENT update FIX
-- File    : 46_gl_mappings_put_fix.sql
-- Adds to : gl.rest (does NOT delete/redefine the module; DEFINE_HANDLER only --
--           never DEFINE_TEMPLATE on the existing 'mappings/:id' template, that
--           drops its DELETE handler)
-- Run     : sql -name prod_mcp @46_gl_mappings_put_fix.sql  (fresh session, ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- the same fix is synced into
--            05, so a 05 re-run reproduces it; the GL post-05 re-run list now ends at 46.
-- Bug     : PUT /gl/mappings/:id (edit an assignment's dates / notes / value from
--           the Classification-values row drawer or the Manage CoA Mapping modal)
--           returned an uncatchable ORDS 555 on EVERY call since the route was
--           born: the handler used a scalar subquery INSIDE a PL/SQL expression
--           (l_cv := NVL(json, (SELECT class_value_id FROM ... WHERE map_id=:id)))
--           which is PLS-00405 at compile time -- never reaches the EXCEPTION
--           block, so the client saw "HTTP 555" and nothing was saved. Reported by
--           the user 2026-09-04 ("i update with end date").
-- Fix     : read the current row ONCE into locals (class value + start date) and
--           NVL against those. Behaviour otherwise unchanged: validate_map still
--           enforces end >= start, dimension membership and the no-overlap rule
--           (400), unknown id = 404.
-- Verify  : tests/mappings_api_smoke.py (self-cleaning throwaway value + mapping).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_mappings_put_fix_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58)), p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dh('mappings/[COLON]id','PUT',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30); l_seg VARCHAR2(60); l_cv NUMBER; l_s DATE; l_e DATE;
  l_cur_cv NUMBER; l_cur_s DATE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT class_type_code, segment_value, class_value_id, start_date
    INTO l_type, l_seg, l_cur_cv, l_cur_s
    FROM dct_gl_seg_class_map WHERE map_id=[COLON]id;
  l_cv := NVL(APEX_JSON.get_number(p_path=>'classValueId'), l_cur_cv);
  l_s  := NVL(TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD'), l_cur_s);
  l_e  := TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD');
  dct_gl_class_pkg.validate_map([COLON]id, l_type, l_seg, l_cv, l_s, l_e);
  UPDATE dct_gl_seg_class_map SET class_value_id=l_cv, start_date=l_s, end_date=l_e,
         notes=APEX_JSON.get_varchar2(p_path=>'notes'), updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE map_id=[COLON]id;
  IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Assignment not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Assignment not found');
  WHEN OTHERS THEN IF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

  COMMIT;
END setup_gl_mappings_put_fix_tmp;
/

BEGIN setup_gl_mappings_put_fix_tmp; END;
/
DROP PROCEDURE setup_gl_mappings_put_fix_tmp;

PROMPT == GL/db/46 mappings/:id PUT handler ==
SELECT h.method, t.uri_template, LENGTH(h.source) src_len,
       CASE WHEN INSTR(h.source,'l_cur_cv')>0 THEN 'FIXED' ELSE 'OLD' END state
  FROM user_ords_handlers h JOIN user_ords_templates t ON t.id = h.template_id
 WHERE t.uri_template = 'mappings/:id' ORDER BY 1;
