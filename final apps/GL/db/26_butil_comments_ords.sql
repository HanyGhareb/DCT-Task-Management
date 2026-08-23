-- =============================================================================
-- General Ledger (App 210) -- Budget Utilization COMMENTS endpoints (ADDITIVE)
-- File    : 26_butil_comments_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp (fresh session, as ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            the GL post-05 re-run list is now 07..26.
-- Needs   : db/v2/125_gl_butil_comments.sql deployed first.
-- Purpose : threaded business-justification comments on the Budget Utilization
--           report at 8 levels (SECTOR / COST_CENTER / PROJECT / TASK /
--           BUTIL_LINE / PO / PR / AP_INVOICE), per budget year + accounting
--           period, with attachments on the shared dct_documents and a
--           reporting-period close that freezes everything in the period.
-- Endpoints:
--   GET    /gl/butilcmt                thread mode (level+keys) or register
--   POST   /gl/butilcmt                create root (ADD priv) / reply (REPLY)
--   PUT    /gl/butilcmt/:id            edit own comment text (period open)
--   DELETE /gl/butilcmt/:id            soft delete own (roots: no replies)
--   GET    /gl/butilcmt/meta/caps      caller capability flags
--   GET    /gl/butilcmt/:id/docs       attachment list
--   PUT    /gl/butilcmt/:id/docs       raw-binary upload (MAX_UPLOAD_MB->413)
--   GET    /gl/butilcmt/docs/:docid    attachment download (media)
--   DELETE /gl/butilcmt/docs/:docid    soft delete attachment
--   GET    /gl/butilcmt/admin/roles    role x capability grants (manage gate)
--   POST   /gl/butilcmt/admin/roles    grant/revoke a capability (common
--                                      dct_role_permissions + refresh_flat)
--   GET    /gl/butilcmt/admin/periods  12 periods of a year + status + counts
--   POST   /gl/butilcmt/admin/periods  {year, period, action CLOSE|REOPEN}
-- Gates   : reads  GL_VIEW_BUDGET_UTILIZATION (NULL legacy = any valid session)
--           writes dct_sec.has_priv on GL_ADD_BUTIL_COMMENT /
--           GL_REPLY_BUTIL_COMMENT / GL_CLOSE_BUTIL_PERIOD (SYS_ADMIN always
--           passes has_priv); role-grant admin = GL_MANAGE_CMT_ROLES/SYS_ADMIN
-- CLOSED period rule: every write touching a CLOSED (year, period) returns 403.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_butilcmt_ords AS

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

    PROCEDURE def_media(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_media,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    def_template('butilcmt');
    def_handler('butilcmt', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_level  VARCHAR2(20)  := UPPER(TRIM([COLON]level));
  l_year   NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_period VARCHAR2(10)  := TRIM([COLON]period);
  l_proj   VARCHAR2(50)  := TRIM([COLON]project);
  l_task   VARCHAR2(100) := TRIM([COLON]task);
  l_et     VARCHAR2(255) := TRIM([COLON]etype);
  l_key    VARCHAR2(240) := TRIM([COLON]ekey);
  l_search VARCHAR2(200) := TRIM([COLON]search);
  l_n      NUMBER := 0;
  PROCEDURE emit_section(p_level VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object;
    APEX_JSON.write('level', p_level);
    APEX_JSON.open_array('items');
    FOR r IN (
      SELECT c.comment_id, c.comment_ref, c.accounting_period, c.comment_text,
             c.created_by, c.updated_at, NVL(u.display_name, c.created_by) AS author,
             u.user_id AS author_uid,
             CASE WHEN u.photo_blob IS NOT NULL THEN 'Y' ELSE 'N' END AS has_photo,
             CASE WHEN UPPER(c.created_by) = UPPER(l_user) THEN 'Y' ELSE 'N' END AS mine,
             (SELECT COUNT(*) FROM prod.dct_documents d
               WHERE d.source_module = 'GL' AND d.source_type = 'BUTIL_COMMENT'
                 AND d.source_id = c.comment_id AND d.is_active = 'Y') AS doc_n,
             TO_CHAR(dct_to_local(c.created_at),'YYYY-MM-DD HH[COLON]MI AM') AS created_disp,
             TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH[COLON]MI AM') AS updated_disp
        FROM prod.dct_gl_butil_comment c
        LEFT JOIN prod.dct_users u ON UPPER(u.username) = UPPER(c.created_by)
       WHERE c.status = 'ACTIVE' AND c.parent_comment_id IS NULL
         AND c.entity_level = p_level
         AND c.budget_year = l_year
         AND (l_period IS NULL OR c.accounting_period = l_period)
         AND (p_level <> 'BUTIL_LINE' OR (c.project_number = l_proj AND c.task_number = l_task AND c.expenditure_type = l_et))
         AND (p_level <> 'TASK'       OR (c.project_number = l_proj AND c.task_number = l_task))
         AND (p_level <> 'PROJECT'    OR c.project_number = l_proj)
         AND (p_level NOT IN ('SECTOR','COST_CENTER','PO','PR','AP_INVOICE') OR c.entity_key = l_key)
       ORDER BY c.created_at DESC) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('id', r.comment_id);
      APEX_JSON.write('ref', r.comment_ref);
      APEX_JSON.write('period', r.accounting_period);
      APEX_JSON.write('text', r.comment_text);
      APEX_JSON.write('mine', r.mine);
      APEX_JSON.write('docCount', r.doc_n);
      APEX_JSON.write('author', r.author);
      APEX_JSON.write('authorId', r.author_uid);
      APEX_JSON.write('hasPhoto', r.has_photo);
      APEX_JSON.write('createdBy', r.created_by);
      APEX_JSON.write('createdAt', NVL(r.created_disp,''));
      APEX_JSON.write('updatedAt', NVL(r.updated_disp,''));
      APEX_JSON.open_array('replies');
      FOR p IN (
        SELECT c2.comment_id, c2.comment_ref, c2.comment_text, c2.created_by,
               NVL(u2.display_name, c2.created_by) AS author,
               u2.user_id AS author_uid,
               CASE WHEN u2.photo_blob IS NOT NULL THEN 'Y' ELSE 'N' END AS has_photo,
               CASE WHEN UPPER(c2.created_by) = UPPER(l_user) THEN 'Y' ELSE 'N' END AS mine,
               (SELECT COUNT(*) FROM prod.dct_documents d
                 WHERE d.source_module = 'GL' AND d.source_type = 'BUTIL_COMMENT'
                   AND d.source_id = c2.comment_id AND d.is_active = 'Y') AS doc_n,
               TO_CHAR(dct_to_local(c2.created_at),'YYYY-MM-DD HH[COLON]MI AM') AS created_disp,
               TO_CHAR(dct_to_local(c2.updated_at),'YYYY-MM-DD HH[COLON]MI AM') AS updated_disp
          FROM prod.dct_gl_butil_comment c2
          LEFT JOIN prod.dct_users u2 ON UPPER(u2.username) = UPPER(c2.created_by)
         WHERE c2.status = 'ACTIVE' AND c2.parent_comment_id = r.comment_id
         ORDER BY c2.created_at) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('id', p.comment_id);
        APEX_JSON.write('ref', p.comment_ref);
        APEX_JSON.write('text', p.comment_text);
        APEX_JSON.write('mine', p.mine);
        APEX_JSON.write('docCount', p.doc_n);
        APEX_JSON.write('author', p.author);
        APEX_JSON.write('authorId', p.author_uid);
        APEX_JSON.write('hasPhoto', p.has_photo);
        APEX_JSON.write('createdBy', p.created_by);
        APEX_JSON.write('createdAt', NVL(p.created_disp,''));
        APEX_JSON.write('updatedAt', NVL(p.updated_disp,''));
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_period IS NOT NULL AND NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$') THEN
    dct_rest.err(400,'period must be MM-YYYY'); RETURN;
  END IF;
  IF l_level IS NOT NULL THEN
    -- THREAD MODE: the comment drawer of one entity
    IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
    IF l_level = 'BUTIL_LINE' AND (l_proj IS NULL OR l_task IS NULL OR l_et IS NULL) THEN
      dct_rest.err(400,'project, task and etype are required for BUTIL_LINE'); RETURN;
    END IF;
    IF l_level IN ('SECTOR','COST_CENTER','PO','PR','AP_INVOICE') AND l_key IS NULL THEN
      dct_rest.err(400,'ekey is required for this level'); RETURN;
    END IF;
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.write('year', l_year);
    IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
    APEX_JSON.open_array('closedPeriods');
    FOR cp IN (SELECT accounting_period FROM prod.dct_gl_butil_period
                WHERE budget_year = l_year AND status = 'CLOSED'
                ORDER BY accounting_period) LOOP
      APEX_JSON.write(cp.accounting_period);
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('sections');
    emit_section(l_level);
    IF l_level = 'BUTIL_LINE' THEN
      emit_section('TASK');
      emit_section('PROJECT');
    END IF;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  ELSE
    -- REGISTER MODE: paged review list of all root comments
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.open_array('items');
    FOR r IN (
      SELECT c.comment_id, c.comment_ref, c.entity_level, c.budget_year, c.accounting_period,
             c.project_number, c.task_number, c.expenditure_type, c.entity_key, c.entity_name,
             c.comment_text, c.created_by, NVL(u.display_name, c.created_by) AS author,
             (SELECT COUNT(*) FROM prod.dct_gl_butil_comment c2
               WHERE c2.parent_comment_id = c.comment_id AND c2.status = 'ACTIVE') AS reply_n,
             (SELECT COUNT(*) FROM prod.dct_documents d
               WHERE d.source_module = 'GL' AND d.source_type = 'BUTIL_COMMENT'
                 AND d.source_id = c.comment_id AND d.is_active = 'Y') AS doc_n,
             TO_CHAR(dct_to_local(c.created_at),'YYYY-MM-DD HH[COLON]MI AM') AS created_disp,
             TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH[COLON]MI AM') AS updated_disp
        FROM prod.dct_gl_butil_comment c
        LEFT JOIN prod.dct_users u ON UPPER(u.username) = UPPER(c.created_by)
       WHERE c.status = 'ACTIVE' AND c.parent_comment_id IS NULL
         AND (l_year   IS NULL OR c.budget_year = l_year)
         AND (l_period IS NULL OR c.accounting_period = l_period)
         AND (l_search IS NULL OR UPPER(c.comment_ref||' '||NVL(c.project_number,' ')||' '||NVL(c.task_number,' ')||' '
                  ||NVL(c.expenditure_type,' ')||' '||NVL(c.entity_key,' ')||' '||NVL(c.entity_name,' ')||' '
                  ||c.comment_text||' '||c.created_by) LIKE '%'||UPPER(l_search)||'%')
       ORDER BY c.comment_id DESC
       FETCH FIRST 2000 ROWS ONLY) LOOP
      l_n := l_n + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('id', r.comment_id);
      APEX_JSON.write('ref', r.comment_ref);
      APEX_JSON.write('level', r.entity_level);
      APEX_JSON.write('budgetYear', r.budget_year);
      APEX_JSON.write('period', r.accounting_period);
      APEX_JSON.write('projectNumber', NVL(r.project_number,''));
      APEX_JSON.write('taskNumber', NVL(r.task_number,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('entityKey', NVL(r.entity_key,''));
      APEX_JSON.write('entityName', NVL(r.entity_name,''));
      APEX_JSON.write('text', r.comment_text);
      APEX_JSON.write('replyCount', r.reply_n);
      APEX_JSON.write('docCount', r.doc_n);
      APEX_JSON.write('author', r.author);
      APEX_JSON.write('createdBy', r.created_by);
      APEX_JSON.write('createdAt', NVL(r.created_disp,''));
      APEX_JSON.write('updatedAt', NVL(r.updated_disp,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.write('total', l_n);
    APEX_JSON.close_object;
  END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butilcmt', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_level  VARCHAR2(20); l_year NUMBER; l_period VARCHAR2(7);
  l_proj   VARCHAR2(50); l_task VARCHAR2(100); l_et VARCHAR2(255);
  l_key    VARCHAR2(240); l_kname VARCHAR2(400);
  l_parent NUMBER; l_text VARCHAR2(4000 CHAR);
  l_pstat  VARCHAR2(20);
  l_id     NUMBER; l_ref VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_parent := APEX_JSON.get_number(p_path=>'parentId');
  l_text   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'text')),1,4000);
  IF l_text IS NULL THEN dct_rest.err(400,'text is required'); RETURN; END IF;
  IF l_parent IS NOT NULL THEN
    -- REPLY: level/keys/period are inherited from the root comment
    IF NOT prod.dct_sec.has_priv(l_user, 'GL_REPLY_BUTIL_COMMENT') THEN
      dct_rest.err(403,'GL_REPLY_BUTIL_COMMENT required'); RETURN;
    END IF;
    BEGIN
      SELECT entity_level, budget_year, accounting_period,
             project_number, task_number, expenditure_type, entity_key, entity_name,
             parent_comment_id, status
        INTO l_level, l_year, l_period, l_proj, l_task, l_et, l_key, l_kname,
             l_id, l_pstat
        FROM prod.dct_gl_butil_comment WHERE comment_id = l_parent;
    EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Parent comment not found'); RETURN;
    END;
    IF l_pstat <> 'ACTIVE' THEN dct_rest.err(400,'Parent comment is deleted'); RETURN; END IF;
    IF l_id IS NOT NULL THEN dct_rest.err(400,'Replies can only be added to a root comment'); RETURN; END IF;
  ELSE
    -- ROOT comment
    IF NOT prod.dct_sec.has_priv(l_user, 'GL_ADD_BUTIL_COMMENT') THEN
      dct_rest.err(403,'GL_ADD_BUTIL_COMMENT required'); RETURN;
    END IF;
    l_level := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'level')));
    l_year  := APEX_JSON.get_number(p_path=>'budgetYear');
    l_period:= TRIM(APEX_JSON.get_varchar2(p_path=>'period'));
    l_proj  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'projectNumber')),1,50);
    l_task  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'taskNumber')),1,100);
    l_et    := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'expenditureType')),1,255);
    l_key   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'entityKey')),1,240);
    l_kname := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'entityName')),1,400);
    IF l_level IS NULL OR l_year IS NULL THEN
      dct_rest.err(400,'level and budgetYear are required'); RETURN;
    END IF;
    prod.dct_lookup_pkg.validate_lookup('GL_CMT_LEVEL', l_level);
    IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the budget year'); RETURN;
    END IF;
    IF l_level = 'BUTIL_LINE' AND (l_proj IS NULL OR l_task IS NULL OR l_et IS NULL) THEN
      dct_rest.err(400,'projectNumber, taskNumber and expenditureType are required for BUTIL_LINE'); RETURN;
    END IF;
    IF l_level = 'TASK' AND (l_proj IS NULL OR l_task IS NULL) THEN
      dct_rest.err(400,'projectNumber and taskNumber are required for TASK'); RETURN;
    END IF;
    IF l_level = 'PROJECT' AND l_proj IS NULL THEN
      dct_rest.err(400,'projectNumber is required for PROJECT'); RETURN;
    END IF;
    IF l_level IN ('SECTOR','COST_CENTER','PO','PR','AP_INVOICE') AND l_key IS NULL THEN
      dct_rest.err(400,'entityKey is required for level '||l_level); RETURN;
    END IF;
  END IF;
  -- CLOSED reporting period freezes everything in it
  SELECT MAX(status) INTO l_pstat FROM prod.dct_gl_butil_period
   WHERE budget_year = l_year AND accounting_period = l_period;
  IF NVL(l_pstat,'OPEN') = 'CLOSED' THEN
    dct_rest.err(403,'Reporting period '||l_period||' is closed'); RETURN;
  END IF;
  l_ref := 'BUC-' || LPAD(TO_CHAR(prod.dct_gl_butil_cmt_seq.NEXTVAL), 5, '0');
  INSERT INTO prod.dct_gl_butil_comment
        (comment_ref, entity_level, budget_year, accounting_period,
         project_number, task_number, expenditure_type, entity_key, entity_name,
         parent_comment_id, comment_text, status, created_by)
  VALUES (l_ref, l_level, l_year, l_period,
         l_proj, l_task, l_et, l_key, l_kname,
         l_parent, l_text, 'ACTIVE', l_user);
  COMMIT;
  SELECT comment_id INTO l_id FROM prod.dct_gl_butil_comment WHERE comment_ref = l_ref;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('ref', l_ref);
  APEX_JSON.write('status', 'CREATED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('butilcmt/[COLON]id');
    def_handler('butilcmt/[COLON]id', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_id    NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_text  VARCHAR2(4000 CHAR);
  l_by    VARCHAR2(100); l_status VARCHAR2(20);
  l_year  NUMBER; l_period VARCHAR2(7); l_pstat VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT created_by, status, budget_year, accounting_period
      INTO l_by, l_status, l_year, l_period
      FROM prod.dct_gl_butil_comment WHERE comment_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Comment not found'); RETURN;
  END;
  IF l_status <> 'ACTIVE' THEN dct_rest.err(400,'Comment is deleted'); RETURN; END IF;
  IF UPPER(l_by) <> UPPER(l_user) AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only the author can edit a comment'); RETURN;
  END IF;
  SELECT MAX(status) INTO l_pstat FROM prod.dct_gl_butil_period
   WHERE budget_year = l_year AND accounting_period = l_period;
  IF NVL(l_pstat,'OPEN') = 'CLOSED' THEN
    dct_rest.err(403,'Reporting period '||l_period||' is closed'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_text := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'text')),1,4000);
  IF l_text IS NULL THEN dct_rest.err(400,'text is required'); RETURN; END IF;
  UPDATE prod.dct_gl_butil_comment
     SET comment_text = l_text, updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE comment_id = l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('status', 'UPDATED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butilcmt/[COLON]id', 'DELETE', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_id    NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_by    VARCHAR2(100); l_status VARCHAR2(20); l_parent NUMBER;
  l_year  NUMBER; l_period VARCHAR2(7); l_pstat VARCHAR2(20);
  l_kids  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT created_by, status, parent_comment_id, budget_year, accounting_period
      INTO l_by, l_status, l_parent, l_year, l_period
      FROM prod.dct_gl_butil_comment WHERE comment_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Comment not found'); RETURN;
  END;
  IF l_status <> 'ACTIVE' THEN dct_rest.err(400,'Comment is already deleted'); RETURN; END IF;
  IF UPPER(l_by) <> UPPER(l_user) AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only the author can delete a comment'); RETURN;
  END IF;
  SELECT MAX(status) INTO l_pstat FROM prod.dct_gl_butil_period
   WHERE budget_year = l_year AND accounting_period = l_period;
  IF NVL(l_pstat,'OPEN') = 'CLOSED' THEN
    dct_rest.err(403,'Reporting period '||l_period||' is closed'); RETURN;
  END IF;
  IF l_parent IS NULL THEN
    SELECT COUNT(*) INTO l_kids FROM prod.dct_gl_butil_comment
     WHERE parent_comment_id = l_id AND status = 'ACTIVE';
    IF l_kids > 0 THEN
      dct_rest.err(400,'This comment has replies and cannot be deleted'); RETURN;
    END IF;
  END IF;
  UPDATE prod.dct_gl_butil_comment
     SET status = 'DELETED', updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE comment_id = l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('status', 'DELETED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butilcmt/meta/caps');
    def_handler('butilcmt/meta/caps', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('canAdd',   CASE WHEN prod.dct_sec.has_priv(l_user,'GL_ADD_BUTIL_COMMENT')   THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('canReply', CASE WHEN prod.dct_sec.has_priv(l_user,'GL_REPLY_BUTIL_COMMENT') THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('canClosePeriod', CASE WHEN prod.dct_sec.has_priv(l_user,'GL_CLOSE_BUTIL_PERIOD') THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('canManageRoles',
    CASE WHEN prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_CMT_ROLES','SYS_ADMIN','GL') THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butilcmt/[COLON]id/docs');
    def_handler('butilcmt/[COLON]id/docs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT d.doc_id, d.file_name, d.mime_type, d.file_size_bytes,
                   NVL(u.display_name, u.username) AS uploaded_by,
                   TO_CHAR(dct_to_local(d.created_at),'YYYY-MM-DD HH[COLON]MI AM') AS uploaded_disp
              FROM prod.dct_documents d
              LEFT JOIN prod.dct_users u ON u.user_id = d.created_by
             WHERE d.source_module = 'GL' AND d.source_type = 'BUTIL_COMMENT'
               AND d.source_id = TO_NUMBER([COLON]id) AND d.is_active = 'Y'
             ORDER BY d.created_at DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docId', r.doc_id);
    APEX_JSON.write('fileName', r.file_name);
    APEX_JSON.write('mimeType', NVL(r.mime_type,''));
    APEX_JSON.write('fileSize', NVL(r.file_size_bytes,0));
    APEX_JSON.write('uploadedBy', NVL(r.uploaded_by,''));
    APEX_JSON.write('uploadedAt', NVL(r.uploaded_disp,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butilcmt/[COLON]id/docs', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_uid  NUMBER;
  v_blob BLOB;
  v_len  NUMBER;
  v_max  NUMBER;
  l_id   NUMBER;
  l_by   VARCHAR2(100); l_status VARCHAR2(20);
  l_year NUMBER; l_period VARCHAR2(7); l_pstat VARCHAR2(20);
  l_type NUMBER;
  l_doc  NUMBER;
BEGIN
  v_blob := [COLON]body;
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_id := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  BEGIN
    SELECT created_by, status, budget_year, accounting_period
      INTO l_by, l_status, l_year, l_period
      FROM prod.dct_gl_butil_comment WHERE comment_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Comment not found'); RETURN;
  END;
  IF l_status <> 'ACTIVE' THEN dct_rest.err(400,'Comment is deleted'); RETURN; END IF;
  IF UPPER(l_by) <> UPPER(l_user) AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only the author can attach files to a comment'); RETURN;
  END IF;
  SELECT MAX(status) INTO l_pstat FROM prod.dct_gl_butil_period
   WHERE budget_year = l_year AND accounting_period = l_period;
  IF NVL(l_pstat,'OPEN') = 'CLOSED' THEN
    dct_rest.err(403,'Reporting period '||l_period||' is closed'); RETURN;
  END IF;
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
    dct_rest.err(400,'Request body (file bytes) is required'); RETURN;
  END IF;
  v_len := DBMS_LOB.GETLENGTH(v_blob);
  BEGIN
    SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO v_max
      FROM prod.dct_module_settings ms JOIN prod.dct_modules m ON m.module_id = ms.module_id
     WHERE m.module_code = 'GL' AND ms.setting_key = 'MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN v_max := NULL; END;
  v_max := NVL(v_max, 10);
  IF v_len > v_max * 1024 * 1024 THEN
    dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT MAX(doc_type_id) INTO l_type FROM prod.dct_document_types
   WHERE doc_type_code = 'GL_CMT_ATTACH';
  IF l_type IS NULL THEN dct_rest.err(500,'Document type GL_CMT_ATTACH is not seeded'); RETURN; END IF;
  INSERT INTO prod.dct_documents
        (source_module, source_type, source_id, doc_type_id,
         file_name, mime_type, file_size_bytes, file_blob, created_by, created_at)
  VALUES ('GL', 'BUTIL_COMMENT', l_id, l_type,
         SUBSTR(NVL([COLON]file_name,'attachment'),1,255),
         NVL([COLON]mime_type,'application/octet-stream'),
         v_len, v_blob, l_uid, SYSTIMESTAMP)
  RETURNING doc_id INTO l_doc;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('docId', l_doc); APEX_JSON.write('fileSize', v_len);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('butilcmt/docs/[COLON]docid');
    def_media('butilcmt/docs/[COLON]docid',
      q'!SELECT mime_type, file_blob FROM prod.dct_documents
         WHERE doc_id = [COLON]docid AND source_module = 'GL'
           AND source_type = 'BUTIL_COMMENT' AND is_active = 'Y'!');

    def_handler('butilcmt/docs/[COLON]docid', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_doc  NUMBER := TO_NUMBER([COLON]docid DEFAULT NULL ON CONVERSION ERROR);
  l_uploader NUMBER; l_cmt NUMBER;
  l_year NUMBER; l_period VARCHAR2(7); l_pstat VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT d.created_by, d.source_id INTO l_uploader, l_cmt
      FROM prod.dct_documents d
     WHERE d.doc_id = l_doc AND d.source_module = 'GL'
       AND d.source_type = 'BUTIL_COMMENT' AND d.is_active = 'Y';
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Attachment not found'); RETURN;
  END;
  IF l_uploader <> dct_auth.get_user_id(l_user) AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only the uploader can remove an attachment'); RETURN;
  END IF;
  SELECT budget_year, accounting_period INTO l_year, l_period
    FROM prod.dct_gl_butil_comment WHERE comment_id = l_cmt;
  SELECT MAX(status) INTO l_pstat FROM prod.dct_gl_butil_period
   WHERE budget_year = l_year AND accounting_period = l_period;
  IF NVL(l_pstat,'OPEN') = 'CLOSED' THEN
    dct_rest.err(403,'Reporting period '||l_period||' is closed'); RETURN;
  END IF;
  UPDATE prod.dct_documents SET is_active = 'N' WHERE doc_id = l_doc;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('docId', l_doc); APEX_JSON.write('status', 'DELETED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butilcmt/admin/roles');
    def_handler('butilcmt/admin/roles', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_CMT_ROLES', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_CMT_ROLES required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT r.role_id, r.role_code, r.role_name_en, r.role_name_ar,
           (SELECT COUNT(*) FROM prod.dct_user_roles ur
             WHERE ur.role_id = r.role_id
               AND (ur.end_date IS NULL OR ur.end_date > SYSDATE)) AS member_n,
           NVL(g.can_add, 0) AS can_add, NVL(g.can_reply, 0) AS can_reply,
           NVL(g.can_close, 0) AS can_close
      FROM prod.dct_roles r
      LEFT JOIN (SELECT rp.role_id,
                        MAX(CASE WHEN p.permission_code = 'GL_ADD_BUTIL_COMMENT'   THEN 1 ELSE 0 END) AS can_add,
                        MAX(CASE WHEN p.permission_code = 'GL_REPLY_BUTIL_COMMENT' THEN 1 ELSE 0 END) AS can_reply,
                        MAX(CASE WHEN p.permission_code = 'GL_CLOSE_BUTIL_PERIOD'  THEN 1 ELSE 0 END) AS can_close
                   FROM prod.dct_role_permissions rp
                   JOIN prod.dct_permissions p ON p.permission_id = rp.permission_id
                  WHERE p.permission_code IN ('GL_ADD_BUTIL_COMMENT','GL_REPLY_BUTIL_COMMENT','GL_CLOSE_BUTIL_PERIOD')
                  GROUP BY rp.role_id) g ON g.role_id = r.role_id
     WHERE r.is_active = 'Y'
       AND NVL(r.role_category,'JOB') <> 'DUTY'
     ORDER BY CASE WHEN NVL(g.can_add,0) + NVL(g.can_reply,0) + NVL(g.can_close,0) > 0 THEN 0 ELSE 1 END,
              r.role_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('roleId', r.role_id);
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('roleName', r.role_name_en);
    APEX_JSON.write('roleNameAr', NVL(r.role_name_ar,''));
    APEX_JSON.write('memberCount', r.member_n);
    APEX_JSON.write('canAdd',   CASE WHEN r.can_add   = 1 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('canReply', CASE WHEN r.can_reply = 1 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('canClose', CASE WHEN r.can_close = 1 THEN 'Y' ELSE 'N' END);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butilcmt/admin/roles', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_role NUMBER; l_cap VARCHAR2(20); l_grant VARCHAR2(4);
  l_code VARCHAR2(64); l_perm NUMBER; v NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_CMT_ROLES', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_CMT_ROLES required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_role  := APEX_JSON.get_number(p_path=>'roleId');
  l_cap   := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'capability')));
  l_grant := UPPER(NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'granted')),'Y'));
  IF l_role IS NULL OR l_cap IS NULL THEN
    dct_rest.err(400,'roleId and capability are required'); RETURN;
  END IF;
  l_code := CASE l_cap
              WHEN 'ADD'          THEN 'GL_ADD_BUTIL_COMMENT'
              WHEN 'REPLY'        THEN 'GL_REPLY_BUTIL_COMMENT'
              WHEN 'CLOSE_PERIOD' THEN 'GL_CLOSE_BUTIL_PERIOD'
            END;
  IF l_code IS NULL THEN
    dct_rest.err(400,'capability must be ADD, REPLY or CLOSE_PERIOD'); RETURN;
  END IF;
  SELECT COUNT(*) INTO v FROM prod.dct_roles
   WHERE role_id = l_role AND NVL(role_category,'JOB') <> 'DUTY';
  IF v = 0 THEN dct_rest.err(404,'Role not found'); RETURN; END IF;
  SELECT MAX(permission_id) INTO l_perm FROM prod.dct_permissions
   WHERE permission_code = l_code;
  IF l_grant = 'Y' THEN
    BEGIN
      INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
      VALUES (l_role, l_perm, l_user);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;
  ELSE
    DELETE FROM prod.dct_role_permissions
     WHERE role_id = l_role AND permission_id = l_perm;
  END IF;
  COMMIT;
  prod.dct_sec.refresh_flat;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('roleId', l_role); APEX_JSON.write('capability', l_cap);
  APEX_JSON.write('granted', l_grant); APEX_JSON.write('status', 'SAVED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('butilcmt/admin/periods');
    def_handler('butilcmt/admin/periods', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT prod.dct_sec.has_priv(l_user,'GL_CLOSE_BUTIL_PERIOD') THEN
    dct_rest.err(403,'GL_CLOSE_BUTIL_PERIOD required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT mm.period_key,
           NVL(p.status,'OPEN') AS status,
           p.remarks, p.closed_by, p.reopened_by,
           TO_CHAR(dct_to_local(p.closed_at),'YYYY-MM-DD HH[COLON]MI AM')   AS closed_disp,
           TO_CHAR(dct_to_local(p.reopened_at),'YYYY-MM-DD HH[COLON]MI AM') AS reopened_disp,
           (SELECT COUNT(*) FROM prod.dct_gl_butil_comment c
             WHERE c.budget_year = l_year AND c.accounting_period = mm.period_key
               AND c.status = 'ACTIVE') AS cmt_n
      FROM (SELECT LPAD(TO_CHAR(LEVEL),2,'0')||'-'||TO_CHAR(l_year) AS period_key, LEVEL AS mth
              FROM dual CONNECT BY LEVEL <= 12) mm
      LEFT JOIN prod.dct_gl_butil_period p
             ON p.budget_year = l_year AND p.accounting_period = mm.period_key
     ORDER BY mm.mth) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('period', r.period_key);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('remarks', NVL(r.remarks,''));
    APEX_JSON.write('closedBy', NVL(r.closed_by,''));
    APEX_JSON.write('closedAt', NVL(r.closed_disp,''));
    APEX_JSON.write('reopenedBy', NVL(r.reopened_by,''));
    APEX_JSON.write('reopenedAt', NVL(r.reopened_disp,''));
    APEX_JSON.write('commentCount', r.cmt_n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('butilcmt/admin/periods', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER; l_period VARCHAR2(7);
  l_action VARCHAR2(20); l_remarks VARCHAR2(2000);
  l_cur    VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT prod.dct_sec.has_priv(l_user,'GL_CLOSE_BUTIL_PERIOD') THEN
    dct_rest.err(403,'GL_CLOSE_BUTIL_PERIOD required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year    := APEX_JSON.get_number(p_path=>'year');
  l_period  := TRIM(APEX_JSON.get_varchar2(p_path=>'period'));
  l_action  := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'action')));
  l_remarks := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'remarks')),1,2000);
  IF l_year IS NULL OR l_period IS NULL OR l_action IS NULL THEN
    dct_rest.err(400,'year, period and action are required'); RETURN;
  END IF;
  IF l_action NOT IN ('CLOSE','REOPEN') THEN
    dct_rest.err(400,'action must be CLOSE or REOPEN'); RETURN;
  END IF;
  IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
     OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
    dct_rest.err(400,'period must be MM-YYYY within the year'); RETURN;
  END IF;
  SELECT MAX(status) INTO l_cur FROM prod.dct_gl_butil_period
   WHERE budget_year = l_year AND accounting_period = l_period;
  IF l_action = 'CLOSE' THEN
    IF NVL(l_cur,'OPEN') = 'CLOSED' THEN
      dct_rest.err(400,'Period '||l_period||' is already closed'); RETURN;
    END IF;
    UPDATE prod.dct_gl_butil_period
       SET status = 'CLOSED', remarks = NVL(l_remarks, remarks),
           closed_by = l_user, closed_at = SYSTIMESTAMP,
           updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE budget_year = l_year AND accounting_period = l_period;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_gl_butil_period
            (budget_year, accounting_period, status, remarks,
             closed_by, closed_at, created_by)
      VALUES (l_year, l_period, 'CLOSED', l_remarks, l_user, SYSTIMESTAMP, l_user);
    END IF;
  ELSE
    IF NVL(l_cur,'OPEN') <> 'CLOSED' THEN
      dct_rest.err(400,'Period '||l_period||' is not closed'); RETURN;
    END IF;
    UPDATE prod.dct_gl_butil_period
       SET status = 'OPEN', remarks = NVL(l_remarks, remarks),
           reopened_by = l_user, reopened_at = SYSTIMESTAMP,
           updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE budget_year = l_year AND accounting_period = l_period;
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  APEX_JSON.write('status', CASE l_action WHEN 'CLOSE' THEN 'CLOSED' ELSE 'OPEN' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    COMMIT;
END setup_gl_butilcmt_ords;
/

BEGIN setup_gl_butilcmt_ords; END;
/
DROP PROCEDURE setup_gl_butilcmt_ords;

PROMPT === verification ===
SELECT t.uri_template, h.method, LENGTH(h.source) AS chars
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'butilcmt%'
 ORDER BY t.uri_template, h.method;
