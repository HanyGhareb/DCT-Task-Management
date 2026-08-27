-- =============================================================================
-- General Ledger (App 210) -- Generate-and-Send report distributions (ADDITIVE)
-- File    : 27_gl_report_dist_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @27_gl_report_dist_ords.sql  (fresh session)
-- Requires: reporting/db/39_rpt_distribution.sql deployed FIRST (tables,
--           lookups, config keys, GL_MANAGE_REPORT_DIST privilege).
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..26 + THIS script right after it (post-05 list = 07..27).
-- Purpose : the Budget Utilization "Generate and Send" flow -- recipient lists
--           (To/Cc/Bcc) per Sector / Cost Centre, the selection tree, recipient
--           preview, the batch send (one scoped report run + ONE email per
--           selected node via the Reporting Platform worker), and the email
--           history register. Non-id actions sit under butil/dist/meta/* so
--           they can never collide with butil/dist/:id (AP procash pattern).
-- Endpoints (all under /ords/admin/gl/):
--   GET    butil/dist                 recipient-list register (counts per row)
--   POST   butil/dist                 create list row + recipients      [manage]
--   GET    butil/dist/:id             one row + recipients
--   PUT    butil/dist/:id             partial update (+recipients swap) [manage]
--   DELETE butil/dist/:id             delete (409 while email history)  [manage]
--   GET    butil/dist/meta/tree       ?level=SECTOR|DEPARTMENT|PROJECT&year=
--   POST   butil/dist/meta/preview    {level,nodes[]} -> To/Cc/Bcc per node
--   POST   butil/dist/meta/import     {rows[]} <=500 Excel-sourced upsert [manage]
--   POST   butil/dist/meta/send       {level,formats[],criteria{},nodes[]} [book priv]
--   GET    butil/dist/batch/:bid      batch poll (runs + delivery counts)
--   GET    butil/emails               email history register (filters)
--   GET    butil/emails/:rid          one email drill (recipients + files)
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_rptdist_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    -- ------------------------------------------------------------------
    -- recipient-list register + create
    -- ------------------------------------------------------------------
    def_template('butil/dist');
    def_handler('butil/dist', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT d.dist_id, d.scope_type, d.scope_value, d.scope_label, d.sector_name,
           d.subject_tpl, d.enabled, d.updated_by,
           TO_CHAR(dct_to_local(d.updated_at),'YYYY-MM-DD HH[COLON]MI AM') upd,
           SUM(CASE WHEN r.disposition='TO'  AND r.enabled='Y' THEN 1 ELSE 0 END) to_cnt,
           SUM(CASE WHEN r.disposition='CC'  AND r.enabled='Y' THEN 1 ELSE 0 END) cc_cnt,
           SUM(CASE WHEN r.disposition='BCC' AND r.enabled='Y' THEN 1 ELSE 0 END) bcc_cnt
      FROM dct_rpt_dist d
      LEFT JOIN dct_rpt_dist_recip r ON r.dist_id = d.dist_id
     WHERE d.dist_group = 'GL_BUTIL'
     GROUP BY d.dist_id, d.scope_type, d.scope_value, d.scope_label, d.sector_name,
              d.subject_tpl, d.enabled, d.updated_by, d.updated_at
     ORDER BY d.scope_type, NVL(d.sector_name, d.scope_value), NVL(d.scope_label, d.scope_value))
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('distId', c.dist_id);
    APEX_JSON.write('scopeType', c.scope_type);
    APEX_JSON.write('scopeValue', c.scope_value);
    APEX_JSON.write('scopeLabel', NVL(c.scope_label, c.scope_value));
    APEX_JSON.write('sectorName', NVL(c.sector_name,''));
    APEX_JSON.write('subjectTpl', NVL(c.subject_tpl,''));
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.write('toCount', c.to_cnt);
    APEX_JSON.write('ccCount', c.cc_cnt);
    APEX_JSON.write('bccCount', c.bcc_cnt);
    APEX_JSON.write('updatedBy', NVL(c.updated_by,''));
    APEX_JSON.write('updatedAt', NVL(c.upd,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butil/dist', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_id    NUMBER;
  l_cnt   NUMBER;
  l_disp  VARCHAR2(10);
  l_email VARCHAR2(320);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_REPORT_DIST', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_REPORT_DIST required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  IF APEX_JSON.get_varchar2(p_path=>'scopeType') IS NULL
     OR APEX_JSON.get_varchar2(p_path=>'scopeValue') IS NULL THEN
    dct_rest.err(400,'scopeType and scopeValue are required'); RETURN;
  END IF;
  prod.dct_lookup_pkg.validate_lookup('RPT_DIST_SCOPE', APEX_JSON.get_varchar2(p_path=>'scopeType'));
  BEGIN
    INSERT INTO dct_rpt_dist
      (dist_group, scope_type, scope_value, scope_label, sector_name, subject_tpl, enabled, created_by, updated_by)
    VALUES
      ('GL_BUTIL',
       APEX_JSON.get_varchar2(p_path=>'scopeType'),
       APEX_JSON.get_varchar2(p_path=>'scopeValue'),
       APEX_JSON.get_varchar2(p_path=>'scopeLabel'),
       APEX_JSON.get_varchar2(p_path=>'sectorName'),
       APEX_JSON.get_varchar2(p_path=>'subjectTpl'),
       NVL(APEX_JSON.get_varchar2(p_path=>'enabled'),'Y'),
       l_user, l_user)
    RETURNING dist_id INTO l_id;
  EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    dct_rest.err(400,'A recipient list for this scope already exists'); RETURN;
  END;
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'recipients'), 0);
  FOR i IN 1..l_cnt LOOP
    l_disp  := UPPER(APEX_JSON.get_varchar2(p_path=>'recipients[%d].disposition', p0=>i));
    l_email := TRIM(APEX_JSON.get_varchar2(p_path=>'recipients[%d].email', p0=>i));
    IF l_email IS NOT NULL THEN
      prod.dct_lookup_pkg.validate_lookup('RPT_DISPOSITION', l_disp);
      INSERT INTO dct_rpt_dist_recip (dist_id, disposition, email, display_name, created_by, updated_by)
      VALUES (l_id, l_disp, l_email,
              APEX_JSON.get_varchar2(p_path=>'recipients[%d].name', p0=>i), l_user, l_user);
    END IF;
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('distId', l_id); APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- ------------------------------------------------------------------
    -- one list row
    -- ------------------------------------------------------------------
    def_template('butil/dist/[COLON]id');
    def_handler('butil/dist/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_hit  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  FOR c IN (SELECT * FROM dct_rpt_dist WHERE dist_id = [COLON]id AND dist_group = 'GL_BUTIL') LOOP
    l_hit := 1;
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('distId', c.dist_id);
    APEX_JSON.write('scopeType', c.scope_type);
    APEX_JSON.write('scopeValue', c.scope_value);
    APEX_JSON.write('scopeLabel', NVL(c.scope_label, c.scope_value));
    APEX_JSON.write('sectorName', NVL(c.sector_name,''));
    APEX_JSON.write('subjectTpl', NVL(c.subject_tpl,''));
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.open_array('recipients');
    FOR r IN (SELECT recip_id, disposition, email, display_name, enabled
                FROM dct_rpt_dist_recip WHERE dist_id = c.dist_id
               ORDER BY DECODE(disposition,'TO',1,'CC',2,3), recip_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('recipId', r.recip_id);
      APEX_JSON.write('disposition', r.disposition);
      APEX_JSON.write('email', r.email);
      APEX_JSON.write('name', NVL(r.display_name,''));
      APEX_JSON.write('enabled', r.enabled);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF l_hit = 0 THEN dct_rest.err(404,'Recipient list not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butil/dist/[COLON]id', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cnt   NUMBER;
  l_disp  VARCHAR2(10);
  l_email VARCHAR2(320);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_REPORT_DIST', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_REPORT_DIST required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  SELECT COUNT(*) INTO l_cnt FROM dct_rpt_dist WHERE dist_id = [COLON]id AND dist_group = 'GL_BUTIL';
  IF l_cnt = 0 THEN dct_rest.err(404,'Recipient list not found'); RETURN; END IF;
  IF APEX_JSON.does_exist(p_path=>'scopeLabel') THEN
    UPDATE dct_rpt_dist SET scope_label = APEX_JSON.get_varchar2(p_path=>'scopeLabel') WHERE dist_id = [COLON]id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'sectorName') THEN
    UPDATE dct_rpt_dist SET sector_name = APEX_JSON.get_varchar2(p_path=>'sectorName') WHERE dist_id = [COLON]id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'subjectTpl') THEN
    UPDATE dct_rpt_dist SET subject_tpl = APEX_JSON.get_varchar2(p_path=>'subjectTpl') WHERE dist_id = [COLON]id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'enabled') THEN
    UPDATE dct_rpt_dist SET enabled = NVL(APEX_JSON.get_varchar2(p_path=>'enabled'),'Y') WHERE dist_id = [COLON]id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'recipients') THEN
    DELETE FROM dct_rpt_dist_recip WHERE dist_id = [COLON]id;
    l_cnt := NVL(APEX_JSON.get_count(p_path=>'recipients'), 0);
    FOR i IN 1..l_cnt LOOP
      l_disp  := UPPER(APEX_JSON.get_varchar2(p_path=>'recipients[%d].disposition', p0=>i));
      l_email := TRIM(APEX_JSON.get_varchar2(p_path=>'recipients[%d].email', p0=>i));
      IF l_email IS NOT NULL THEN
        prod.dct_lookup_pkg.validate_lookup('RPT_DISPOSITION', l_disp);
        INSERT INTO dct_rpt_dist_recip (dist_id, disposition, email, display_name, created_by, updated_by)
        VALUES ([COLON]id, l_disp, l_email,
                APEX_JSON.get_varchar2(p_path=>'recipients[%d].name', p0=>i), l_user, l_user);
      END IF;
    END LOOP;
  END IF;
  UPDATE dct_rpt_dist SET updated_by = l_user, updated_at = SYSTIMESTAMP WHERE dist_id = [COLON]id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_handler('butil/dist/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_REPORT_DIST', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_REPORT_DIST required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_rpt_run WHERE dist_id = [COLON]id;
  IF l_cnt > 0 THEN
    dct_rest.err(409,'Referenced by email history -- disable the list instead of deleting it'); RETURN;
  END IF;
  DELETE FROM dct_rpt_dist WHERE dist_id = [COLON]id AND dist_group = 'GL_BUTIL';
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Recipient list not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- selection tree (sector -> cost centre -> project, per budget year)
    -- ------------------------------------------------------------------
    def_template('butil/dist/meta/tree');
    def_handler('butil/dist/meta/tree', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_level  VARCHAR2(20) := UPPER(NVL([COLON]level,'SECTOR'));
  l_year   NUMBER := [COLON]year;
  l_sec    VARCHAR2(240) := CHR(1);
  l_cc     VARCHAR2(40) := CHR(1);
  l_open_s BOOLEAN := FALSE;
  l_open_c BOOLEAN := FALSE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_level NOT IN ('SECTOR','DEPARTMENT','PROJECT') THEN
    dct_rest.err(400,'level must be SECTOR, DEPARTMENT or PROJECT'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('level', l_level);
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('sectors');
  FOR c IN (
    SELECT k.sector,
           CASE WHEN l_level IN ('DEPARTMENT','PROJECT') THEN k.cost_centre END cost_centre,
           CASE WHEN l_level IN ('DEPARTMENT','PROJECT') THEN MAX(k.department) END department,
           CASE WHEN l_level = 'PROJECT' THEN k.project_number END project_number,
           CASE WHEN l_level = 'PROJECT' THEN MAX(k.project_name) END project_name,
           MAX(CASE WHEN d.dist_id IS NOT NULL THEN 1 ELSE 0 END) has_rcpt
      FROM prod.dct_butil_key_cache k
      LEFT JOIN (SELECT dd.dist_id, dd.scope_type, dd.scope_value
                   FROM dct_rpt_dist dd
                  WHERE dd.dist_group = 'GL_BUTIL' AND dd.enabled = 'Y'
                    AND EXISTS (SELECT 1 FROM dct_rpt_dist_recip x
                                 WHERE x.dist_id = dd.dist_id
                                   AND x.enabled = 'Y' AND x.disposition = 'TO')) d
        ON ((l_level = 'SECTOR' AND d.scope_type = 'SECTOR' AND d.scope_value = k.sector)
         OR (l_level IN ('DEPARTMENT','PROJECT') AND d.scope_type = 'COSTCENTER'
             AND d.scope_value = k.cost_centre))
     WHERE k.budget_year = l_year AND k.sector IS NOT NULL
     GROUP BY k.sector,
           CASE WHEN l_level IN ('DEPARTMENT','PROJECT') THEN k.cost_centre END,
           CASE WHEN l_level = 'PROJECT' THEN k.project_number END
     ORDER BY 1, 2 NULLS FIRST, 4 NULLS FIRST)
  LOOP
    IF c.sector <> l_sec THEN
      IF l_open_c THEN APEX_JSON.close_array; APEX_JSON.close_object; l_open_c := FALSE; END IF;
      IF l_open_s THEN APEX_JSON.close_array; APEX_JSON.close_object; END IF;
      APEX_JSON.open_object;
      APEX_JSON.write('sector', c.sector);
      IF l_level = 'SECTOR' THEN
        APEX_JSON.write('hasRecipients', c.has_rcpt = 1);
      END IF;
      APEX_JSON.open_array('children');
      l_open_s := TRUE; l_sec := c.sector; l_cc := CHR(1);
    END IF;
    IF l_level IN ('DEPARTMENT','PROJECT') AND NVL(c.cost_centre, CHR(2)) <> l_cc THEN
      IF l_open_c THEN APEX_JSON.close_array; APEX_JSON.close_object; l_open_c := FALSE; END IF;
      APEX_JSON.open_object;
      APEX_JSON.write('costCenter', NVL(c.cost_centre,''));
      APEX_JSON.write('department', NVL(c.department,''));
      APEX_JSON.write('hasRecipients', c.has_rcpt = 1);
      APEX_JSON.open_array('children');
      l_open_c := TRUE; l_cc := NVL(c.cost_centre, CHR(2));
    END IF;
    IF l_level = 'PROJECT' AND c.project_number IS NOT NULL THEN
      APEX_JSON.open_object;
      APEX_JSON.write('project', c.project_number);
      APEX_JSON.write('projectName', NVL(c.project_name,''));
      APEX_JSON.write('hasRecipients', c.has_rcpt = 1);
      APEX_JSON.close_object;
    END IF;
  END LOOP;
  IF l_open_c THEN APEX_JSON.close_array; APEX_JSON.close_object; END IF;
  IF l_open_s THEN APEX_JSON.close_array; APEX_JSON.close_object; END IF;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- recipient preview for the confirmation screen
    -- ------------------------------------------------------------------
    def_template('butil/dist/meta/preview');
    def_handler('butil/dist/meta/preview', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_level VARCHAR2(20);
  l_cnt   NUMBER;
  l_key   VARCHAR2(240);
  l_styp  VARCHAR2(20);
  l_id    NUMBER;
  l_lbl   VARCHAR2(240);
  l_sec   VARCHAR2(240);
  l_bcc   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_level := UPPER(APEX_JSON.get_varchar2(p_path=>'level'));
  IF l_level NOT IN ('SECTOR','DEPARTMENT','PROJECT') THEN
    dct_rest.err(400,'level must be SECTOR, DEPARTMENT or PROJECT'); RETURN;
  END IF;
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'nodes'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'nodes is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('emailEnabled', NVL(dct_rpt_pkg.cfg('EMAIL_ENABLED','N'),'N'));
  APEX_JSON.write('testMode', NVL(dct_rpt_pkg.cfg('EMAIL_TEST_MODE','Y'),'Y'));
  APEX_JSON.write('testTo', NVL(dct_rpt_pkg.cfg('EMAIL_TEST_TO',''),''));
  APEX_JSON.open_array('items');
  FOR i IN 1..LEAST(l_cnt, 500) LOOP
    IF l_level = 'SECTOR' THEN
      l_styp := 'SECTOR';
      l_key  := APEX_JSON.get_varchar2(p_path=>'nodes[%d].sector', p0=>i);
    ELSE
      l_styp := 'COSTCENTER';
      l_key  := APEX_JSON.get_varchar2(p_path=>'nodes[%d].costcenter', p0=>i);
    END IF;
    APEX_JSON.open_object;
    APEX_JSON.write('label', NVL(APEX_JSON.get_varchar2(p_path=>'nodes[%d].label', p0=>i), NVL(l_key,'')));
    APEX_JSON.write('scopeType', l_styp);
    APEX_JSON.write('scopeValue', NVL(l_key,''));
    APEX_JSON.write('project', NVL(APEX_JSON.get_varchar2(p_path=>'nodes[%d].project', p0=>i),''));
    l_id := NULL;
    BEGIN
      SELECT dist_id, NVL(scope_label, scope_value), sector_name
        INTO l_id, l_lbl, l_sec
        FROM dct_rpt_dist
       WHERE dist_group = 'GL_BUTIL' AND enabled = 'Y'
         AND scope_type = l_styp AND scope_value = l_key;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
    IF l_id IS NULL THEN
      APEX_JSON.write('found', FALSE);
      APEX_JSON.open_array('toList'); APEX_JSON.close_array;
      APEX_JSON.open_array('ccList'); APEX_JSON.close_array;
      APEX_JSON.write('bccCount', 0);
    ELSE
      APEX_JSON.write('found', TRUE);
      APEX_JSON.write('distId', l_id);
      APEX_JSON.write('listLabel', l_lbl);
      APEX_JSON.write('sectorName', NVL(l_sec,''));
      APEX_JSON.open_array('toList');
      FOR r IN (SELECT email FROM dct_rpt_dist_recip
                 WHERE dist_id = l_id AND enabled='Y' AND disposition='TO' ORDER BY recip_id) LOOP
        APEX_JSON.write(r.email);
      END LOOP;
      APEX_JSON.close_array;
      APEX_JSON.open_array('ccList');
      FOR r IN (SELECT email FROM dct_rpt_dist_recip
                 WHERE dist_id = l_id AND enabled='Y' AND disposition='CC' ORDER BY recip_id) LOOP
        APEX_JSON.write(r.email);
      END LOOP;
      APEX_JSON.close_array;
      SELECT COUNT(*) INTO l_bcc FROM dct_rpt_dist_recip
       WHERE dist_id = l_id AND enabled='Y' AND disposition='BCC';
      APEX_JSON.write('bccCount', l_bcc);
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- Excel-sourced bulk upsert (rows parsed client-side, <=500 per call)
    -- ------------------------------------------------------------------
    def_template('butil/dist/meta/import');
    def_handler('butil/dist/meta/import', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_rows  NUMBER;
  l_id    NUMBER;
  l_styp  VARCHAR2(20);
  l_key   VARCHAR2(240);
  l_rc    NUMBER;
  l_disp  VARCHAR2(10);
  l_email VARCHAR2(320);
  l_new   NUMBER := 0;
  l_upd   NUMBER := 0;
  l_err   NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_REPORT_DIST', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_REPORT_DIST required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_rows := NVL(APEX_JSON.get_count(p_path=>'rows'), 0);
  IF l_rows = 0 THEN dct_rest.err(400,'rows is required'); RETURN; END IF;
  IF l_rows > 500 THEN dct_rest.err(400,'maximum 500 rows per request'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('results');
  FOR i IN 1..l_rows LOOP
    BEGIN
      SAVEPOINT row_sp;
      l_styp := UPPER(APEX_JSON.get_varchar2(p_path=>'rows[%d].scopeType', p0=>i));
      l_key  := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].scopeValue', p0=>i));
      prod.dct_lookup_pkg.validate_lookup('RPT_DIST_SCOPE', l_styp);
      IF l_key IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'scopeValue is required'); END IF;
      l_id := NULL;
      BEGIN
        SELECT dist_id INTO l_id FROM dct_rpt_dist
         WHERE dist_group='GL_BUTIL' AND scope_type=l_styp AND scope_value=l_key;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
      IF l_id IS NULL THEN
        INSERT INTO dct_rpt_dist
          (dist_group, scope_type, scope_value, scope_label, sector_name, subject_tpl, enabled, created_by, updated_by)
        VALUES ('GL_BUTIL', l_styp, l_key,
          APEX_JSON.get_varchar2(p_path=>'rows[%d].scopeLabel', p0=>i),
          APEX_JSON.get_varchar2(p_path=>'rows[%d].sectorName', p0=>i),
          APEX_JSON.get_varchar2(p_path=>'rows[%d].subjectTpl', p0=>i),
          'Y', l_user, l_user)
        RETURNING dist_id INTO l_id;
        l_new := l_new + 1;
      ELSE
        UPDATE dct_rpt_dist
           SET scope_label = NVL(APEX_JSON.get_varchar2(p_path=>'rows[%d].scopeLabel', p0=>i), scope_label),
               sector_name = NVL(APEX_JSON.get_varchar2(p_path=>'rows[%d].sectorName', p0=>i), sector_name),
               enabled = 'Y', updated_by = l_user, updated_at = SYSTIMESTAMP
         WHERE dist_id = l_id;
        l_upd := l_upd + 1;
      END IF;
      DELETE FROM dct_rpt_dist_recip WHERE dist_id = l_id;
      l_rc := NVL(APEX_JSON.get_count(p_path=>'rows[%d].recipients', p0=>i), 0);
      FOR j IN 1..l_rc LOOP
        l_disp  := UPPER(APEX_JSON.get_varchar2(p_path=>'rows[%d].recipients[%d].disposition', p0=>i, p1=>j));
        l_email := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].recipients[%d].email', p0=>i, p1=>j));
        IF l_email IS NOT NULL THEN
          prod.dct_lookup_pkg.validate_lookup('RPT_DISPOSITION', l_disp);
          INSERT INTO dct_rpt_dist_recip (dist_id, disposition, email, display_name, created_by, updated_by)
          VALUES (l_id, l_disp, l_email,
                  APEX_JSON.get_varchar2(p_path=>'rows[%d].recipients[%d].name', p0=>i, p1=>j),
                  l_user, l_user);
        END IF;
      END LOOP;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('scopeValue', l_key);
      APEX_JSON.write('status', CASE WHEN l_id IS NULL THEN 'ERROR' ELSE 'OK' END);
      APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN
      ROLLBACK TO row_sp;
      l_err := l_err + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('scopeValue', NVL(l_key,''));
      APEX_JSON.write('status', 'ERROR');
      APEX_JSON.write('error', SUBSTR(SQLERRM, 1, 300));
      APEX_JSON.close_object;
    END;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('created', l_new);
  APEX_JSON.write('updated', l_upd);
  APEX_JSON.write('errors', l_err);
  APEX_JSON.close_object;
  COMMIT;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- batch send: one scoped run (+ ONE email) per node x report format
    -- ------------------------------------------------------------------
    def_template('butil/dist/meta/send');
    def_handler('butil/dist/meta/send', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_level   VARCHAR2(20);
  l_year    NUMBER;
  l_period  VARCHAR2(10);
  l_ncnt    NUMBER;
  l_fcnt    NUMBER;
  l_batch   NUMBER;
  l_pdf     NUMBER := 0;
  l_xlsx    NUMBER := 0;
  l_fmts    VARCHAR2(20);
  l_fmt     VARCHAR2(10);
  l_styp    VARCHAR2(20);
  l_key     VARCHAR2(240);
  l_proj    VARCHAR2(40);
  l_id      NUMBER;
  l_params  CLOB;
  l_run     NUMBER;
  l_crit    CLOB;
  l_chapter VARCHAR2(2000);
  l_ptype   VARCHAR2(2000);
  l_task    VARCHAR2(400);
  l_etype   VARCHAR2(400);
  l_search  VARCHAR2(400);
  l_bu      VARCHAR2(2000);
  l_ovr     VARCHAR2(10);
  l_cmtmode VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_RUN_BRIEFING_BOOK', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_RUN_BRIEFING_BOOK required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_level := UPPER(APEX_JSON.get_varchar2(p_path=>'level'));
  IF l_level NOT IN ('SECTOR','DEPARTMENT','PROJECT') THEN
    dct_rest.err(400,'level must be SECTOR, DEPARTMENT or PROJECT'); RETURN;
  END IF;
  l_year := APEX_JSON.get_number(p_path=>'criteria.year');
  IF l_year IS NULL THEN dct_rest.err(400,'criteria.year is required'); RETURN; END IF;
  l_period := APEX_JSON.get_varchar2(p_path=>'criteria.period');
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'criteria.period must be MM-YYYY within the selected year'); RETURN;
    END IF;
  END IF;
  l_ncnt := NVL(APEX_JSON.get_count(p_path=>'nodes'), 0);
  IF l_ncnt = 0 THEN dct_rest.err(400,'nodes is required'); RETURN; END IF;
  IF l_ncnt > 100 THEN dct_rest.err(400,'maximum 100 nodes per send'); RETURN; END IF;
  l_fcnt := NVL(APEX_JSON.get_count(p_path=>'formats'), 0);
  FOR f IN 1..l_fcnt LOOP
    l_fmt := UPPER(APEX_JSON.get_varchar2(p_path=>'formats[%d]', p0=>f));
    IF l_fmt = 'PDF' THEN l_pdf := 1; ELSIF l_fmt = 'XLSX' THEN l_xlsx := 1; END IF;
  END LOOP;
  IF l_pdf = 0 AND l_xlsx = 0 THEN
    dct_rest.err(400,'formats must include PDF and/or XLSX'); RETURN;
  END IF;
  l_fmts    := CASE WHEN l_pdf=1 AND l_xlsx=1 THEN 'PDF,XLSX' WHEN l_pdf=1 THEN 'PDF' ELSE 'XLSX' END;
  l_chapter := APEX_JSON.get_varchar2(p_path=>'criteria.chapter');
  l_ptype   := APEX_JSON.get_varchar2(p_path=>'criteria.projecttype');
  l_task    := APEX_JSON.get_varchar2(p_path=>'criteria.task');
  l_etype   := APEX_JSON.get_varchar2(p_path=>'criteria.etype');
  l_search  := APEX_JSON.get_varchar2(p_path=>'criteria.search');
  l_bu      := APEX_JSON.get_varchar2(p_path=>'criteria.bu');
  l_ovr     := APEX_JSON.get_varchar2(p_path=>'criteria.ovr');
  l_cmtmode := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'criteria.cmtmode')),'NONE');
  SELECT JSON_OBJECT(
           'level' VALUE l_level, 'formats' VALUE l_fmts,
           'year' VALUE l_year, 'period' VALUE l_period
           ABSENT ON NULL)
    INTO l_crit FROM dual;
  INSERT INTO dct_rpt_dist_batch (dist_group, level_code, criteria_json, formats, requested_by)
  VALUES ('GL_BUTIL', l_level, l_crit, l_fmts, l_user)
  RETURNING batch_id INTO l_batch;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('batchId', l_batch);
  APEX_JSON.open_array('items');
  FOR i IN 1..l_ncnt LOOP
    IF l_level = 'SECTOR' THEN
      l_styp := 'SECTOR';
      l_key  := APEX_JSON.get_varchar2(p_path=>'nodes[%d].sector', p0=>i);
      l_proj := NULL;
    ELSE
      l_styp := 'COSTCENTER';
      l_key  := APEX_JSON.get_varchar2(p_path=>'nodes[%d].costcenter', p0=>i);
      l_proj := CASE WHEN l_level = 'PROJECT'
                     THEN APEX_JSON.get_varchar2(p_path=>'nodes[%d].project', p0=>i) END;
    END IF;
    APEX_JSON.open_object;
    APEX_JSON.write('label', NVL(APEX_JSON.get_varchar2(p_path=>'nodes[%d].label', p0=>i), NVL(l_key,'')));
    APEX_JSON.write('scopeValue', NVL(l_key,''));
    l_id := NULL;
    BEGIN
      SELECT d.dist_id INTO l_id FROM dct_rpt_dist d
       WHERE d.dist_group='GL_BUTIL' AND d.enabled='Y'
         AND d.scope_type = l_styp AND d.scope_value = l_key
         AND EXISTS (SELECT 1 FROM dct_rpt_dist_recip x
                      WHERE x.dist_id = d.dist_id AND x.enabled='Y' AND x.disposition='TO');
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
    IF l_id IS NULL THEN
      APEX_JSON.write('status', 'NO_RECIPIENTS');
      APEX_JSON.open_array('runs'); APEX_JSON.close_array;
    ELSE
      APEX_JSON.write('status', 'QUEUED');
      APEX_JSON.write('distId', l_id);
      APEX_JSON.open_array('runs');
      FOR f IN 1..2 LOOP
        IF (f = 1 AND l_pdf = 1) OR (f = 2 AND l_xlsx = 1) THEN
          SELECT JSON_OBJECT(
                   'year'        VALUE l_year,
                   'period'      VALUE l_period,
                   'sector'      VALUE CASE WHEN l_styp = 'SECTOR' THEN l_key END,
                   'costcenter'  VALUE CASE WHEN l_styp = 'COSTCENTER' THEN l_key END,
                   'project'     VALUE l_proj,
                   'chapter'     VALUE l_chapter,
                   'projecttype' VALUE l_ptype,
                   'task'        VALUE l_task,
                   'etype'       VALUE l_etype,
                   'search'      VALUE l_search,
                   'bu'          VALUE l_bu,
                   'ovr'         VALUE l_ovr,
                   'cmtmode'     VALUE l_cmtmode
                   ABSENT ON NULL)
            INTO l_params FROM dual;
          l_run := dct_rpt_pkg.enqueue(
                     p_report_code  => CASE WHEN f = 1 THEN 'BUDGET_UTIL_BOOK' ELSE 'BUDGET_UTIL_REGISTER' END,
                     p_params       => l_params,
                     p_trigger      => 'ONDEMAND',
                     p_requested_by => l_user,
                     p_formats      => CASE WHEN f = 1 THEN 'PDF' ELSE 'XLSX' END);
          UPDATE dct_rpt_run SET dist_id = l_id, batch_id = l_batch WHERE run_id = l_run;
          APEX_JSON.open_object;
          APEX_JSON.write('report', CASE WHEN f = 1 THEN 'BUDGET_UTIL_BOOK' ELSE 'BUDGET_UTIL_REGISTER' END);
          APEX_JSON.write('format', CASE WHEN f = 1 THEN 'PDF' ELSE 'XLSX' END);
          APEX_JSON.write('runId', l_run);
          APEX_JSON.close_object;
        END IF;
      END LOOP;
      APEX_JSON.close_array;
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- ------------------------------------------------------------------
    -- batch poll
    -- ------------------------------------------------------------------
    def_template('butil/dist/batch/[COLON]bid');
    def_handler('butil/dist/batch/[COLON]bid', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_hit  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  FOR b IN (SELECT batch_id, level_code, formats, requested_by,
                   TO_CHAR(dct_to_local(created_at),'YYYY-MM-DD HH[COLON]MI AM') created
              FROM dct_rpt_dist_batch WHERE batch_id = [COLON]bid) LOOP
    l_hit := 1;
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('batchId', b.batch_id);
    APEX_JSON.write('level', b.level_code);
    APEX_JSON.write('formats', NVL(b.formats,''));
    APEX_JSON.write('requestedBy', NVL(b.requested_by,''));
    APEX_JSON.write('createdAt', NVL(b.created,''));
    APEX_JSON.open_array('runs');
    FOR c IN (
      SELECT r.run_id, r.report_code, r.status, r.is_test, r.email_subject,
             NVL(DBMS_LOB.SUBSTR(r.error_msg, 300, 1), '') err,
             NVL(d.scope_label, d.scope_value) scope_label, d.scope_type,
             (SELECT COUNT(*) FROM dct_rpt_delivery x WHERE x.run_id = r.run_id AND x.status='SENT') sent_cnt,
             (SELECT COUNT(*) FROM dct_rpt_delivery x WHERE x.run_id = r.run_id AND x.status='FAILED') fail_cnt,
             (SELECT COUNT(*) FROM dct_rpt_delivery x WHERE x.run_id = r.run_id AND x.status='SKIPPED') skip_cnt
        FROM dct_rpt_run r
        LEFT JOIN dct_rpt_dist d ON d.dist_id = r.dist_id
       WHERE r.batch_id = b.batch_id
       ORDER BY r.run_id)
    LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('runId', c.run_id);
      APEX_JSON.write('report', c.report_code);
      APEX_JSON.write('status', c.status);
      APEX_JSON.write('isTest', NVL(c.is_test,'N'));
      APEX_JSON.write('subject', NVL(c.email_subject,''));
      APEX_JSON.write('scopeLabel', NVL(c.scope_label,''));
      APEX_JSON.write('sentCount', c.sent_cnt);
      APEX_JSON.write('failedCount', c.fail_cnt);
      APEX_JSON.write('skippedCount', c.skip_cnt);
      APEX_JSON.write('error', c.err);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF l_hit = 0 THEN dct_rest.err(404,'Batch not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- email history register
    -- ------------------------------------------------------------------
    def_template('butil/emails');
    def_handler('butil/emails', 'GET', q'!
DECLARE
  -- ON CONVERSION ERROR is SQL-only: parsing the date params must happen
  -- inside the cursor SQL, never in a DECLARE initializer (ORA-03066 -> 555)
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_n     NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT * FROM (
      SELECT r.run_id, r.report_code, r.status, NVL(r.is_test,'N') is_test,
             r.email_subject, r.requested_by, r.batch_id, r.row_count,
             NVL(DBMS_LOB.SUBSTR(r.error_msg, 300, 1), '') err,
             TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH[COLON]MI AM') created,
             b.level_code,
             d.scope_type, d.scope_value, NVL(d.scope_label, d.scope_value) scope_label,
             d.sector_name,
             JSON_VALUE(r.params_json, '$.project') proj,
             JSON_VALUE(r.params_json, '$.period') period,
             (SELECT COUNT(*) FROM dct_rpt_delivery x WHERE x.run_id = r.run_id AND x.status='SENT') sent_cnt,
             (SELECT COUNT(*) FROM dct_rpt_delivery x WHERE x.run_id = r.run_id AND x.status='FAILED') fail_cnt,
             (SELECT COUNT(*) FROM dct_rpt_delivery x WHERE x.run_id = r.run_id AND x.status='SKIPPED') skip_cnt
        FROM dct_rpt_run r
        JOIN dct_rpt_dist d ON d.dist_id = r.dist_id
        LEFT JOIN dct_rpt_dist_batch b ON b.batch_id = r.batch_id
       WHERE r.dist_id IS NOT NULL
         AND d.dist_group = 'GL_BUTIL'
         AND ([COLON]datefrom IS NULL OR r.created_at >=
              CASE WHEN REGEXP_LIKE([COLON]datefrom, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
                   THEN TO_DATE([COLON]datefrom, 'YYYY-MM-DD') END)
         AND ([COLON]dateto IS NULL OR r.created_at <
              CASE WHEN REGEXP_LIKE([COLON]dateto, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
                   THEN TO_DATE([COLON]dateto, 'YYYY-MM-DD') + 1 END)
         AND ([COLON]level IS NULL OR b.level_code = UPPER([COLON]level))
         AND ([COLON]report IS NULL OR r.report_code = UPPER([COLON]report))
         AND ([COLON]status IS NULL OR r.status = UPPER([COLON]status))
         AND ([COLON]istest IS NULL OR NVL(r.is_test,'N') = UPPER([COLON]istest))
         AND ([COLON]batch IS NULL OR TO_CHAR(r.batch_id) = TRIM([COLON]batch))
         AND ([COLON]sector IS NULL OR
              UPPER(NVL(d.sector_name, CASE WHEN d.scope_type='SECTOR' THEN d.scope_value END))
                LIKE '%'||UPPER([COLON]sector)||'%')
         AND ([COLON]costcenter IS NULL OR
              (d.scope_type = 'COSTCENTER' AND d.scope_value LIKE '%'||[COLON]costcenter||'%'))
         AND ([COLON]project IS NULL OR
              JSON_VALUE(r.params_json, '$.project') LIKE '%'||[COLON]project||'%')
         AND ([COLON]recipient IS NULL OR EXISTS (
              SELECT 1 FROM dct_rpt_delivery x
               WHERE x.run_id = r.run_id
                 AND LOWER(x.recipient) LIKE '%'||LOWER([COLON]recipient)||'%'))
         AND ([COLON]emailstatus IS NULL OR EXISTS (
              SELECT 1 FROM dct_rpt_delivery x
               WHERE x.run_id = r.run_id AND x.status = UPPER([COLON]emailstatus)))
       ORDER BY r.run_id DESC)
     WHERE ROWNUM <= 500)
  LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('batchId', c.batch_id);
    APEX_JSON.write('report', c.report_code);
    APEX_JSON.write('level', NVL(c.level_code,''));
    APEX_JSON.write('scopeType', NVL(c.scope_type,''));
    APEX_JSON.write('scopeLabel', NVL(c.scope_label,''));
    APEX_JSON.write('sectorName', NVL(c.sector_name,''));
    APEX_JSON.write('project', NVL(c.proj,''));
    APEX_JSON.write('period', NVL(c.period,''));
    APEX_JSON.write('subject', NVL(c.email_subject,''));
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('isTest', c.is_test);
    APEX_JSON.write('sentCount', c.sent_cnt);
    APEX_JSON.write('failedCount', c.fail_cnt);
    APEX_JSON.write('skippedCount', c.skip_cnt);
    APEX_JSON.write('rowCount', NVL(c.row_count, 0));
    APEX_JSON.write('requestedBy', NVL(c.requested_by,''));
    APEX_JSON.write('createdAt', NVL(c.created,''));
    APEX_JSON.write('error', c.err);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butil/emails/[COLON]rid');
    def_handler('butil/emails/[COLON]rid', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_hit  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  FOR c IN (
    SELECT r.run_id, r.report_code, r.status, NVL(r.is_test,'N') is_test,
           r.email_subject, r.requested_by, r.batch_id, r.row_count,
           NVL(DBMS_LOB.SUBSTR(r.error_msg, 500, 1), '') err,
           NVL(DBMS_LOB.SUBSTR(r.params_json, 3000, 1), '') params,
           TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH[COLON]MI AM') created,
           TO_CHAR(dct_to_local(r.finished_at),'YYYY-MM-DD HH[COLON]MI AM') finished,
           b.level_code,
           d.scope_type, d.scope_value, NVL(d.scope_label, d.scope_value) scope_label,
           d.sector_name
      FROM dct_rpt_run r
      JOIN dct_rpt_dist d ON d.dist_id = r.dist_id
      LEFT JOIN dct_rpt_dist_batch b ON b.batch_id = r.batch_id
     WHERE r.run_id = [COLON]rid AND d.dist_group = 'GL_BUTIL')
  LOOP
    l_hit := 1;
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('batchId', c.batch_id);
    APEX_JSON.write('report', c.report_code);
    APEX_JSON.write('level', NVL(c.level_code,''));
    APEX_JSON.write('scopeType', NVL(c.scope_type,''));
    APEX_JSON.write('scopeValue', NVL(c.scope_value,''));
    APEX_JSON.write('scopeLabel', NVL(c.scope_label,''));
    APEX_JSON.write('sectorName', NVL(c.sector_name,''));
    APEX_JSON.write('subject', NVL(c.email_subject,''));
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('isTest', c.is_test);
    APEX_JSON.write('rowCount', NVL(c.row_count, 0));
    APEX_JSON.write('requestedBy', NVL(c.requested_by,''));
    APEX_JSON.write('createdAt', NVL(c.created,''));
    APEX_JSON.write('finishedAt', NVL(c.finished,''));
    APEX_JSON.write('error', c.err);
    APEX_JSON.write('params', c.params);
    APEX_JSON.open_array('recipients');
    FOR r IN (SELECT recipient, disposition, status,
                     TO_CHAR(dct_to_local(sent_at),'YYYY-MM-DD HH[COLON]MI AM') sent,
                     NVL(error_msg,'') err
                FROM dct_rpt_delivery WHERE run_id = c.run_id
               ORDER BY DECODE(disposition,'TO',1,'CC',2,'BCC',3,4), delivery_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('email', NVL(r.recipient,''));
      APEX_JSON.write('disposition', NVL(r.disposition,''));
      APEX_JSON.write('status', r.status);
      APEX_JSON.write('sentAt', NVL(r.sent,''));
      APEX_JSON.write('error', r.err);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('files');
    FOR o IN (SELECT format, file_name FROM dct_rpt_output
               WHERE run_id = c.run_id ORDER BY output_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('format', o.format);
      APEX_JSON.write('fileName', NVL(o.file_name,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF l_hit = 0 THEN dct_rest.err(404,'Email run not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_rptdist_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_rptdist_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method, LENGTH(h.source) src_len
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest'
  AND (t.uri_template LIKE 'butil/dist%' OR t.uri_template LIKE 'butil/emails%')
ORDER BY t.uri_template, h.method;

PROMPT gl.rest Generate-and-Send routes published (butil/dist* + butil/emails*).
