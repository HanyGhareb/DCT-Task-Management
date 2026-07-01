-- ===========================================================================
-- otbi-atd : 41 Job Sets ORDS  (additive handlers on the live atd.rest module)
--   CRUD for ATD_JOB_SET + membership, Run Set Now, pause/resume, set-scoped run
--   history, and a candidate-jobs picker. Additive only (DEFINE_TEMPLATE /
--   DEFINE_HANDLER) -> NO DELETE_MODULE, so the rest of atd.rest is untouched.
--   Every handler: validate_session + SYS_ADMIN gate; APEX_JSON output; partial
--   PUT via APEX_JSON.does_exist. Depends on db/40 objects (+ their ADMIN synonyms).
--
-- Window semantics: start_at/end_at/daily_*/dow_mask are LOCAL Asia/Dubai wall
-- clock (see db/40). created_at/updated_at + run-log times are UTC -> dct_to_local.
--
-- Run in a FRESH SQLcl session (must NOT follow ALTER SESSION SET CURRENT_SCHEMA
-- =PROD, or ORA-01471). [COLON] -> ':' at define. Schema-qualified. CRLF/UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- Synonyms the handlers touch (idempotent; also created by db/40)
CREATE OR REPLACE SYNONYM atd_job_set        FOR prod.atd_job_set;
CREATE OR REPLACE SYNONYM atd_job_set_member FOR prod.atd_job_set_member;
CREATE OR REPLACE SYNONYM atd_set_pkg        FOR prod.atd_set_pkg;
CREATE OR REPLACE SYNONYM atd_set_next_run   FOR prod.atd_set_next_run;

CREATE OR REPLACE PROCEDURE setup_atd_jobset_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- =========================================================================
    -- GET /job-sets  -- list sets + member counts
    -- =========================================================================
    def_template('job-sets');
    def_handler('job-sets', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT s.set_code, s.name_en, s.name_ar, s.active, s.paused,
                   s.interval_preset, s.frequency_minutes, s.notify_on_failure,
                   TO_CHAR(s.start_at,'YYYY-MM-DD HH:MI AM') AS start_disp,
                   TO_CHAR(s.end_at,'YYYY-MM-DD HH:MI AM')   AS end_disp,
                   (SELECT COUNT(*) FROM atd_job_set_member m WHERE m.set_code=s.set_code) AS members,
                   (SELECT COUNT(*) FROM atd_job_set_member m WHERE m.set_code=s.set_code AND m.enabled_in_set='Y') AS enabled_members
              FROM atd_job_set s ORDER BY s.name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('setCode', r.set_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('active', r.active);
    APEX_JSON.write('paused', r.paused);
    APEX_JSON.write('intervalPreset', NVL(r.interval_preset,''));
    IF r.frequency_minutes IS NULL THEN APEX_JSON.write('frequencyMinutes','');
    ELSE APEX_JSON.write('frequencyMinutes', r.frequency_minutes); END IF;
    APEX_JSON.write('notifyOnFailure', r.notify_on_failure);
    APEX_JSON.write('startAtDisp', NVL(r.start_disp,''));
    APEX_JSON.write('endAtDisp', NVL(r.end_disp,''));
    APEX_JSON.write('members', r.members);
    APEX_JSON.write('enabledMembers', r.enabled_members);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- POST /job-sets  -- create
    -- =========================================================================
    def_handler('job-sets', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(30);
  l_name VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_code := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'setCode')));
  l_name := APEX_JSON.get_varchar2(p_path=>'nameEn');
  IF l_code IS NULL OR l_name IS NULL THEN dct_rest.err(400,'setCode and nameEn are required'); RETURN; END IF;
  INSERT INTO atd_job_set (set_code, name_en, name_ar, comments, active, paused,
    interval_preset, frequency_minutes, start_at, end_at, daily_start, daily_end,
    dow_mask, notify_on_failure, created_by)
  VALUES (l_code, l_name,
    APEX_JSON.get_varchar2(p_path=>'nameAr'),
    APEX_JSON.get_varchar2(p_path=>'comments'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'active')),'Y'),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'paused')),'N'),
    APEX_JSON.get_varchar2(p_path=>'intervalPreset'),
    APEX_JSON.get_number(p_path=>'frequencyMinutes'),
    TO_TIMESTAMP(REPLACE(SUBSTR(APEX_JSON.get_varchar2(p_path=>'startAt'),1,16),'T',' '),'YYYY-MM-DD HH24:MI'),
    TO_TIMESTAMP(REPLACE(SUBSTR(APEX_JSON.get_varchar2(p_path=>'endAt'),1,16),'T',' '),'YYYY-MM-DD HH24:MI'),
    APEX_JSON.get_varchar2(p_path=>'dailyStart'),
    APEX_JSON.get_varchar2(p_path=>'dailyEnd'),
    UPPER(APEX_JSON.get_varchar2(p_path=>'dowMask')),
    NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'notifyOnFailure')),'N'),
    l_user);
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('setCode', l_code); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'A set with that code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET /job-sets/:code  -- detail: set + members (+ nextRun) + recent runs
    -- =========================================================================
    def_template('job-sets/[COLON]code');
    def_handler('job-sets/[COLON]code', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_job_set WHERE set_code = UPPER([COLON]code);
  IF l_found = 0 THEN dct_rest.err(404,'Set not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR s IN (SELECT * FROM atd_job_set WHERE set_code = UPPER([COLON]code)) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('setCode', s.set_code);
    APEX_JSON.write('nameEn', s.name_en);
    APEX_JSON.write('nameAr', NVL(s.name_ar,''));
    APEX_JSON.write('comments', NVL(s.comments,''));
    APEX_JSON.write('active', s.active);
    APEX_JSON.write('paused', s.paused);
    APEX_JSON.write('intervalPreset', NVL(s.interval_preset,''));
    IF s.frequency_minutes IS NULL THEN APEX_JSON.write('frequencyMinutes','');
    ELSE APEX_JSON.write('frequencyMinutes', s.frequency_minutes); END IF;
    APEX_JSON.write('startAt', TO_CHAR(s.start_at,'YYYY-MM-DD"T"HH24:MI'));
    APEX_JSON.write('endAt', TO_CHAR(s.end_at,'YYYY-MM-DD"T"HH24:MI'));
    APEX_JSON.write('startAtDisp', TO_CHAR(s.start_at,'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('endAtDisp', TO_CHAR(s.end_at,'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('dailyStart', NVL(s.daily_start,''));
    APEX_JSON.write('dailyEnd', NVL(s.daily_end,''));
    APEX_JSON.write('dowMask', NVL(s.dow_mask,''));
    APEX_JSON.write('notifyOnFailure', s.notify_on_failure);
    APEX_JSON.write('createdBy', NVL(s.created_by,''));
    APEX_JSON.write('createdAt', TO_CHAR( dct_to_local(s.created_at),'YYYY-MM-DD HH:MI AM'));
    -- members
    APEX_JSON.open_array('members');
    FOR m IN (SELECT mm.job_name, mm.enabled_in_set, mm.member_order,
                     j.enabled AS job_enabled, j.run_status,
                     TO_CHAR( dct_to_local(atd_set_next_run(mm.job_name)),'YYYY-MM-DD HH:MI AM') AS next_run,
                     (SELECT TO_CHAR( dct_to_local(MAX(l.finished)),'YYYY-MM-DD HH:MI AM')
                        FROM atd_load_run_log l WHERE l.job_name=mm.job_name) AS last_finished
                FROM atd_job_set_member mm
                JOIN atd_otbi_jobs j ON j.job_name = mm.job_name
               WHERE mm.set_code = UPPER([COLON]code)
               ORDER BY mm.member_order, mm.job_name) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('jobName', m.job_name);
      APEX_JSON.write('enabledInSet', m.enabled_in_set);
      APEX_JSON.write('memberOrder', m.member_order);
      APEX_JSON.write('jobEnabled', m.job_enabled);
      APEX_JSON.write('runStatus', NVL(m.run_status,''));
      APEX_JSON.write('nextRun', NVL(m.next_run,''));
      APEX_JSON.write('lastFinished', NVL(m.last_finished,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    -- recent set-scoped runs
    APEX_JSON.open_array('runs');
    FOR h IN (SELECT * FROM (
                SELECT l.run_id, l.job_name, l.status, l.row_count, NVL(l.host_id,'') AS host_id,
                       TO_CHAR( dct_to_local(l.started),'YYYY-MM-DD HH:MI AM')  AS started_s,
                       TO_CHAR( dct_to_local(l.finished),'YYYY-MM-DD HH:MI AM') AS finished_s
                  FROM atd_load_run_log l
                 WHERE l.job_name IN (SELECT job_name FROM atd_job_set_member WHERE set_code = UPPER([COLON]code))
                 ORDER BY l.run_id DESC) WHERE ROWNUM <= 20) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('runId', h.run_id);
      APEX_JSON.write('jobName', h.job_name);
      APEX_JSON.write('status', h.status);
      APEX_JSON.write('rowCount', NVL(h.row_count,0));
      APEX_JSON.write('host', h.host_id);
      APEX_JSON.write('started', NVL(h.started_s,''));
      APEX_JSON.write('finished', NVL(h.finished_s,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PUT /job-sets/:code  -- partial update
    -- =========================================================================
    def_handler('job-sets/[COLON]code', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE atd_job_set SET
    name_en           = CASE WHEN APEX_JSON.does_exist(p_path=>'nameEn')           THEN APEX_JSON.get_varchar2(p_path=>'nameEn')           ELSE name_en END,
    name_ar           = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')           THEN APEX_JSON.get_varchar2(p_path=>'nameAr')           ELSE name_ar END,
    comments          = CASE WHEN APEX_JSON.does_exist(p_path=>'comments')         THEN APEX_JSON.get_varchar2(p_path=>'comments')         ELSE comments END,
    active            = CASE WHEN APEX_JSON.does_exist(p_path=>'active')           THEN UPPER(APEX_JSON.get_varchar2(p_path=>'active'))    ELSE active END,
    paused            = CASE WHEN APEX_JSON.does_exist(p_path=>'paused')           THEN UPPER(APEX_JSON.get_varchar2(p_path=>'paused'))    ELSE paused END,
    interval_preset   = CASE WHEN APEX_JSON.does_exist(p_path=>'intervalPreset')   THEN APEX_JSON.get_varchar2(p_path=>'intervalPreset')   ELSE interval_preset END,
    frequency_minutes = CASE WHEN APEX_JSON.does_exist(p_path=>'frequencyMinutes') THEN APEX_JSON.get_number(p_path=>'frequencyMinutes')   ELSE frequency_minutes END,
    start_at          = CASE WHEN APEX_JSON.does_exist(p_path=>'startAt')          THEN TO_TIMESTAMP(REPLACE(SUBSTR(APEX_JSON.get_varchar2(p_path=>'startAt'),1,16),'T',' '),'YYYY-MM-DD HH24:MI') ELSE start_at END,
    end_at            = CASE WHEN APEX_JSON.does_exist(p_path=>'endAt')            THEN TO_TIMESTAMP(REPLACE(SUBSTR(APEX_JSON.get_varchar2(p_path=>'endAt'),1,16),'T',' '),'YYYY-MM-DD HH24:MI') ELSE end_at END,
    daily_start       = CASE WHEN APEX_JSON.does_exist(p_path=>'dailyStart')       THEN APEX_JSON.get_varchar2(p_path=>'dailyStart')       ELSE daily_start END,
    daily_end         = CASE WHEN APEX_JSON.does_exist(p_path=>'dailyEnd')         THEN APEX_JSON.get_varchar2(p_path=>'dailyEnd')         ELSE daily_end END,
    dow_mask          = CASE WHEN APEX_JSON.does_exist(p_path=>'dowMask')          THEN UPPER(APEX_JSON.get_varchar2(p_path=>'dowMask'))   ELSE dow_mask END,
    notify_on_failure = CASE WHEN APEX_JSON.does_exist(p_path=>'notifyOnFailure')  THEN UPPER(APEX_JSON.get_varchar2(p_path=>'notifyOnFailure')) ELSE notify_on_failure END,
    updated_at        = SYSTIMESTAMP, updated_by = l_user
  WHERE set_code = UPPER([COLON]code);
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Set not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DELETE /job-sets/:code  -- delete (cascades membership)
    -- =========================================================================
    def_handler('job-sets/[COLON]code', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM atd_job_set WHERE set_code = UPPER([COLON]code);
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Set not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- POST /job-sets/:code/members  -- add member(s): {jobName} or {jobNames:[...]}
    --   A job may belong to at most ONE set (member PK). Jobs already in a set are
    --   skipped and reported (never 500).
    -- =========================================================================
    def_template('job-sets/[COLON]code/members');
    def_handler('job-sets/[COLON]code/members', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
  l_added NUMBER := 0;
  l_cnt   NUMBER;
  l_job   VARCHAR2(80);
  l_inset VARCHAR2(30);
  PROCEDURE add_one(p_job VARCHAR2) IS
  BEGIN
    IF p_job IS NULL OR TRIM(p_job) IS NULL THEN RETURN; END IF;
    BEGIN
      SELECT set_code INTO l_inset FROM atd_job_set_member WHERE job_name = p_job;
      APEX_JSON.open_object;
      APEX_JSON.write('jobName', p_job); APEX_JSON.write('inSet', l_inset);
      APEX_JSON.close_object;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      INSERT INTO atd_job_set_member (job_name, set_code, added_by)
      VALUES (p_job, UPPER([COLON]code), l_user);
      l_added := l_added + 1;
    END;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_job_set WHERE set_code = UPPER([COLON]code);
  IF l_found = 0 THEN dct_rest.err(404,'Set not found'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('skipped');
  IF APEX_JSON.does_exist(p_path=>'jobNames') THEN
    l_cnt := NVL(APEX_JSON.get_count(p_path=>'jobNames'),0);
    FOR i IN 1 .. l_cnt LOOP
      add_one(APEX_JSON.get_varchar2(p_path=>'jobNames[%d]', p0=>i));
    END LOOP;
  ELSE
    add_one(APEX_JSON.get_varchar2(p_path=>'jobName'));
  END IF;
  COMMIT;
  APEX_JSON.close_array;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('added', l_added);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PUT /job-sets/:code/members/:job  -- toggle enabledInSet / memberOrder
    -- =========================================================================
    def_template('job-sets/[COLON]code/members/[COLON]job');
    def_handler('job-sets/[COLON]code/members/[COLON]job', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE atd_job_set_member SET
    enabled_in_set = CASE WHEN APEX_JSON.does_exist(p_path=>'enabledInSet') THEN UPPER(APEX_JSON.get_varchar2(p_path=>'enabledInSet')) ELSE enabled_in_set END,
    member_order   = CASE WHEN APEX_JSON.does_exist(p_path=>'memberOrder')  THEN APEX_JSON.get_number(p_path=>'memberOrder')          ELSE member_order END
  WHERE set_code = UPPER([COLON]code) AND job_name = [COLON]job;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Member not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DELETE /job-sets/:code/members/:job  -- remove a member
    -- =========================================================================
    def_handler('job-sets/[COLON]code/members/[COLON]job', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  DELETE FROM atd_job_set_member WHERE set_code = UPPER([COLON]code) AND job_name = [COLON]job;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Member not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- POST /job-sets/:code/run  -- Run Set Now (top-priority enqueue enabled members)
    -- =========================================================================
    def_template('job-sets/[COLON]code/run');
    def_handler('job-sets/[COLON]code/run', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_job_set WHERE set_code = UPPER([COLON]code);
  IF l_found = 0 THEN dct_rest.err(404,'Set not found'); RETURN; END IF;
  l_n := atd_set_pkg.run_now(UPPER([COLON]code));
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('queued', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PUT /job-sets/:code/pause  -- {paused:'Y'/'N'}
    -- =========================================================================
    def_template('job-sets/[COLON]code/pause');
    def_handler('job-sets/[COLON]code/pause', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
  l_flag VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_flag := CASE WHEN UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'paused'),'Y')) IN ('Y','TRUE','1','ON') THEN 'Y' ELSE 'N' END;
  UPDATE atd_job_set SET paused = l_flag, updated_at = SYSTIMESTAMP, updated_by = l_user
   WHERE set_code = UPPER([COLON]code);
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Set not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('paused', l_flag); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET /job-set-jobs  -- candidate picker: every job + its current set (if any)
    -- =========================================================================
    def_template('job-set-jobs');
    def_handler('job-set-jobs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT j.job_name, j.enabled, m.set_code, s.name_en AS set_name
              FROM atd_otbi_jobs j
              LEFT JOIN atd_job_set_member m ON m.job_name = j.job_name
              LEFT JOIN atd_job_set s ON s.set_code = m.set_code
             ORDER BY j.job_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('jobName', r.job_name);
    APEX_JSON.write('enabled', r.enabled);
    APEX_JSON.write('setCode', NVL(r.set_code,''));
    APEX_JSON.write('setName', NVL(r.set_name,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_jobset_ords_tmp;
/
SHOW ERRORS PROCEDURE setup_atd_jobset_ords_tmp

BEGIN
  setup_atd_jobset_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_jobset_ords_tmp;

SET ECHO OFF
PROMPT otbi-atd 41 job set ORDS : done
