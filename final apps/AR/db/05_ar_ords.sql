-- =============================================================================
-- i-Finance V2 — Accounts Receivable Module: ORDS REST API
-- File    : 05_ar_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp) — FRESH SESSION
--           (never after ALTER SESSION SET CURRENT_SCHEMA = PROD → ORA-01471)
-- Base URL: /ords/admin/ar/
-- Pattern : Matches PC/DT/HR — own module 'ar.rest', synonyms in ADMIN,
--           dct_rest.validate_session at the top of every protected handler.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = ADMIN;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. ADMIN synonyms (ORDS executes as ADMIN; objects live in PROD)
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_ar_events          FOR prod.dct_ar_events;
CREATE OR REPLACE SYNONYM dct_ar_event_files     FOR prod.dct_ar_event_files;
CREATE OR REPLACE SYNONYM dct_ar_doc_categories  FOR prod.dct_ar_doc_categories;
CREATE OR REPLACE SYNONYM dct_ar_pnl_categories  FOR prod.dct_ar_pnl_categories;
CREATE OR REPLACE SYNONYM dct_ar_pnl_lines       FOR prod.dct_ar_pnl_lines;
CREATE OR REPLACE SYNONYM dct_ar_category_map    FOR prod.dct_ar_category_map;
CREATE OR REPLACE SYNONYM dct_ar_event_findings  FOR prod.dct_ar_event_findings;
CREATE OR REPLACE SYNONYM dct_ar_event_kpis      FOR prod.dct_ar_event_kpis;
CREATE OR REPLACE SYNONYM dct_ar_extract_log     FOR prod.dct_ar_extract_log;
CREATE OR REPLACE SYNONYM dct_ar_scenarios       FOR prod.dct_ar_scenarios;
CREATE OR REPLACE SYNONYM dct_ar_scenario_adj    FOR prod.dct_ar_scenario_adj;
CREATE OR REPLACE SYNONYM dct_ar_ai_providers    FOR prod.dct_ar_ai_providers;
CREATE OR REPLACE SYNONYM dct_ar_event_pnl_v     FOR prod.dct_ar_event_pnl_v;
CREATE OR REPLACE SYNONYM dct_ar_category_pnl_v  FOR prod.dct_ar_category_pnl_v;
CREATE OR REPLACE SYNONYM dct_ar_file_status_v   FOR prod.dct_ar_file_status_v;
CREATE OR REPLACE SYNONYM dct_ar_completeness_v  FOR prod.dct_ar_completeness_v;
CREATE OR REPLACE SYNONYM dct_ar_ai_pkg          FOR prod.dct_ar_ai_pkg;

-- Platform objects (idempotent re-creates; most exist from other modules)
CREATE OR REPLACE SYNONYM dct_rest                   FOR prod.dct_rest;
CREATE OR REPLACE SYNONYM dct_auth                   FOR prod.dct_auth;
CREATE OR REPLACE SYNONYM dct_users                  FOR prod.dct_users;
CREATE OR REPLACE SYNONYM dct_organizations          FOR prod.dct_organizations;
CREATE OR REPLACE SYNONYM dct_modules                FOR prod.dct_modules;
CREATE OR REPLACE SYNONYM dct_module_settings        FOR prod.dct_module_settings;
CREATE OR REPLACE SYNONYM dct_lookup_values          FOR prod.dct_lookup_values;
CREATE OR REPLACE SYNONYM dct_lookup_categories      FOR prod.dct_lookup_categories;
CREATE OR REPLACE SYNONYM dct_currency_codes         FOR prod.dct_currency_codes;
CREATE OR REPLACE SYNONYM dct_request_status_history FOR prod.dct_request_status_history;
CREATE OR REPLACE SYNONYM dct_lookup_pkg             FOR prod.dct_lookup_pkg;

-- =============================================================================
-- 2. Module + templates + handlers
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_ar_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';

    PROCEDURE def_tpl (p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => p_pattern);
    END;

    PROCEDURE def_plsql (p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => p_pattern,
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => p_source
        );
    END;

BEGIN
    BEGIN ORDS.DELETE_MODULE(p_module_name => c_mod); EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/ar/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'Accounts Receivable Module — Event P&L Analysis REST API'
    );

    -- =========================================================================
    -- EVENTS — list / create
    -- =========================================================================
    def_tpl('events/');
    def_plsql('events/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER(:limit DEFAULT NULL ON CONVERSION ERROR), 25), 200);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER(:offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_ar_events e
  WHERE  e.is_active = 'Y'
  AND    (:status IS NULL OR e.status = :status)
  AND    (:type   IS NULL OR e.event_type = :type)
  AND    (:search IS NULL OR UPPER(e.event_code || ' ' || e.event_name_en || ' ' ||
                                   NVL(e.organizer_name,'') || ' ' || NVL(e.venue,''))
                             LIKE '%' || UPPER(:search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT e.event_id, e.event_code, e.event_name_en, e.event_name_ar, e.event_type,
           e.venue, e.organizer_name, e.start_date, e.end_date, e.status,
           e.currency_code, e.dct_revenue_share_pct,
           (SELECT COUNT(*) FROM dct_ar_event_files f
            WHERE f.event_id = e.event_id AND f.is_active = 'Y')            AS files_count,
           (SELECT COUNT(*) FROM dct_ar_pnl_lines l
            WHERE l.event_id = e.event_id)                                  AS lines_count,
           (SELECT NVL(SUM(CASE WHEN l.line_type='REVENUE' THEN l.base_amount
                                ELSE -l.base_amount END),0)
            FROM dct_ar_pnl_lines l
            WHERE l.event_id = e.event_id AND l.basis = 'ACTUAL'
            AND   l.review_status = 'CONFIRMED' AND l.is_included = 'Y')    AS actual_net
    FROM   dct_ar_events e
    WHERE  e.is_active = 'Y'
    AND    (:status IS NULL OR e.status = :status)
    AND    (:type   IS NULL OR e.event_type = :type)
    AND    (:search IS NULL OR UPPER(e.event_code || ' ' || e.event_name_en || ' ' ||
                                     NVL(e.organizer_name,'') || ' ' || NVL(e.venue,''))
                               LIKE '%' || UPPER(:search) || '%')
    ORDER  BY e.start_date DESC NULLS LAST, e.event_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('eventId',        r.event_id);
    APEX_JSON.write('eventCode',      r.event_code);
    APEX_JSON.write('nameEn',         r.event_name_en);
    APEX_JSON.write('nameAr',         r.event_name_ar);
    APEX_JSON.write('eventType',      r.event_type);
    APEX_JSON.write('venue',          r.venue);
    APEX_JSON.write('organizer',      r.organizer_name);
    APEX_JSON.write('startDate',      TO_CHAR(r.start_date,'YYYY-MM-DD'));
    APEX_JSON.write('endDate',        TO_CHAR(r.end_date,'YYYY-MM-DD'));
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('currency',       r.currency_code);
    APEX_JSON.write('revSharePct',    r.dct_revenue_share_pct);
    APEX_JSON.write('filesCount',     r.files_count);
    APEX_JSON.write('linesCount',     r.lines_count);
    APEX_JSON.write('actualNet',      r.actual_net);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('events/', 'POST', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_id     NUMBER;
  l_code   VARCHAR2(50);
  l_prefix VARCHAR2(20);
  l_seq    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body(:body);

  l_code := APEX_JSON.get_varchar2(p_path => 'eventCode');
  IF l_code IS NULL THEN
    BEGIN
      SELECT ms.setting_value INTO l_prefix
      FROM   dct_module_settings ms
      JOIN   dct_modules m ON m.module_id = ms.module_id
      WHERE  m.module_code = 'ACCOUNTS_RECEIVABLE' AND ms.setting_key = 'EVENT_CODE_PREFIX';
    EXCEPTION WHEN NO_DATA_FOUND THEN l_prefix := 'EVT'; END;
    l_prefix := NVL(l_prefix,'EVT') || '-' || TO_CHAR(SYSDATE,'YYYY') || '-';
    SELECT NVL(MAX(TO_NUMBER(SUBSTR(event_code, LENGTH(l_prefix)+1)
                   DEFAULT 0 ON CONVERSION ERROR)), 0) + 1
    INTO   l_seq
    FROM   dct_ar_events WHERE event_code LIKE l_prefix || '%';
    l_code := l_prefix || LPAD(l_seq, 4, '0');
  END IF;

  INSERT INTO dct_ar_events (
    event_code, event_name_en, event_name_ar, event_type, venue, organizer_name,
    contract_number, start_date, end_date, expected_attendance,
    dct_revenue_share_pct, org_id, owner_user_id, currency_code,
    status, description, created_by
  ) VALUES (
    l_code,
    APEX_JSON.get_varchar2(p_path => 'nameEn'),
    APEX_JSON.get_varchar2(p_path => 'nameAr'),
    APEX_JSON.get_varchar2(p_path => 'eventType'),
    APEX_JSON.get_varchar2(p_path => 'venue'),
    APEX_JSON.get_varchar2(p_path => 'organizer'),
    APEX_JSON.get_varchar2(p_path => 'contractNumber'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'),'YYYY-MM-DD'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'),'YYYY-MM-DD'),
    APEX_JSON.get_number(p_path => 'expectedAttendance'),
    APEX_JSON.get_number(p_path => 'revSharePct'),
    APEX_JSON.get_number(p_path => 'orgId'),
    l_uid,
    NVL(APEX_JSON.get_varchar2(p_path => 'currency'), 'AED'),
    'NEW',
    APEX_JSON.get_varchar2(p_path => 'description'),
    l_user
  ) RETURNING event_id INTO l_id;

  INSERT INTO dct_request_status_history
    (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('AR', 'EVENT', l_id, NULL, 'NEW', l_uid, 'Event created');
  COMMIT;

  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('eventId', l_id);
  APEX_JSON.write('eventCode', l_code);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409, 'Event code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- EVENTS — single
    -- =========================================================================
    def_tpl('events/:id');
    def_plsql('events/:id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  r      dct_ar_events%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT * INTO r FROM dct_ar_events WHERE event_id = :id;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('eventId',        r.event_id);
  APEX_JSON.write('eventCode',      r.event_code);
  APEX_JSON.write('nameEn',         r.event_name_en);
  APEX_JSON.write('nameAr',         r.event_name_ar);
  APEX_JSON.write('eventType',      r.event_type);
  APEX_JSON.write('venue',          r.venue);
  APEX_JSON.write('organizer',      r.organizer_name);
  APEX_JSON.write('contractNumber', r.contract_number);
  APEX_JSON.write('startDate',      TO_CHAR(r.start_date,'YYYY-MM-DD'));
  APEX_JSON.write('endDate',        TO_CHAR(r.end_date,'YYYY-MM-DD'));
  APEX_JSON.write('expectedAttendance', r.expected_attendance);
  APEX_JSON.write('actualAttendance',   r.actual_attendance);
  APEX_JSON.write('revSharePct',    r.dct_revenue_share_pct);
  APEX_JSON.write('orgId',          r.org_id);
  APEX_JSON.write('ownerUserId',    r.owner_user_id);
  APEX_JSON.write('currency',       r.currency_code);
  APEX_JSON.write('status',         r.status);
  APEX_JSON.write('description',    r.description);

  APEX_JSON.open_array('pnlSummary');
  FOR s IN (SELECT basis, total_revenue, total_expense, net_result, margin_pct, line_count
            FROM dct_ar_event_pnl_v WHERE event_id = r.event_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('basis',     s.basis);
    APEX_JSON.write('revenue',   s.total_revenue);
    APEX_JSON.write('expense',   s.total_expense);
    APEX_JSON.write('net',       s.net_result);
    APEX_JSON.write('marginPct', s.margin_pct);
    APEX_JSON.write('lineCount', s.line_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('completeness');
  FOR c IN (SELECT doc_cat_code, doc_cat_name_en, is_present
            FROM dct_ar_completeness_v WHERE event_id = r.event_id
            ORDER BY doc_cat_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',      c.doc_cat_code);
    APEX_JSON.write('nameEn',    c.doc_cat_name_en);
    APEX_JSON.write('present',   c.is_present = 'Y');
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'Event not found');
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('events/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_old  VARCHAR2(30);
  l_new  VARCHAR2(30);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body(:body);

  SELECT status INTO l_old FROM dct_ar_events WHERE event_id = :id FOR UPDATE;

  UPDATE dct_ar_events SET
    event_name_en   = CASE WHEN APEX_JSON.does_exist(p_path=>'nameEn')
                           THEN APEX_JSON.get_varchar2(p_path=>'nameEn') ELSE event_name_en END,
    event_name_ar   = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                           THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE event_name_ar END,
    event_type      = CASE WHEN APEX_JSON.does_exist(p_path=>'eventType')
                           THEN APEX_JSON.get_varchar2(p_path=>'eventType') ELSE event_type END,
    venue           = CASE WHEN APEX_JSON.does_exist(p_path=>'venue')
                           THEN APEX_JSON.get_varchar2(p_path=>'venue') ELSE venue END,
    organizer_name  = CASE WHEN APEX_JSON.does_exist(p_path=>'organizer')
                           THEN APEX_JSON.get_varchar2(p_path=>'organizer') ELSE organizer_name END,
    contract_number = CASE WHEN APEX_JSON.does_exist(p_path=>'contractNumber')
                           THEN APEX_JSON.get_varchar2(p_path=>'contractNumber') ELSE contract_number END,
    start_date      = CASE WHEN APEX_JSON.does_exist(p_path=>'startDate')
                           THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD') ELSE start_date END,
    end_date        = CASE WHEN APEX_JSON.does_exist(p_path=>'endDate')
                           THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD') ELSE end_date END,
    expected_attendance = CASE WHEN APEX_JSON.does_exist(p_path=>'expectedAttendance')
                           THEN APEX_JSON.get_number(p_path=>'expectedAttendance') ELSE expected_attendance END,
    actual_attendance   = CASE WHEN APEX_JSON.does_exist(p_path=>'actualAttendance')
                           THEN APEX_JSON.get_number(p_path=>'actualAttendance') ELSE actual_attendance END,
    dct_revenue_share_pct = CASE WHEN APEX_JSON.does_exist(p_path=>'revSharePct')
                           THEN APEX_JSON.get_number(p_path=>'revSharePct') ELSE dct_revenue_share_pct END,
    currency_code   = CASE WHEN APEX_JSON.does_exist(p_path=>'currency')
                           THEN APEX_JSON.get_varchar2(p_path=>'currency') ELSE currency_code END,
    description     = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                           THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description END,
    status          = CASE WHEN APEX_JSON.does_exist(p_path=>'status')
                           THEN APEX_JSON.get_varchar2(p_path=>'status') ELSE status END,
    is_active       = CASE WHEN APEX_JSON.does_exist(p_path=>'isActive')
                           THEN APEX_JSON.get_varchar2(p_path=>'isActive') ELSE is_active END,
    updated_by      = l_user
  WHERE event_id = :id;

  IF APEX_JSON.does_exist(p_path=>'status') THEN
    l_new := APEX_JSON.get_varchar2(p_path=>'status');
    IF l_new != l_old THEN
      INSERT INTO dct_request_status_history
        (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
      VALUES ('AR', 'EVENT', :id, l_old, l_new, l_uid,
              APEX_JSON.get_varchar2(p_path=>'statusComment'));
    END IF;
  END IF;
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404, 'Event not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- FILES — list / metadata create
    -- =========================================================================
    def_tpl('events/:id/files');
    def_plsql('events/:id/files', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT f.file_id, f.folder_path, f.original_file_name, f.alt_file_name,
           f.file_ext, f.mime_type, f.file_size_bytes, f.file_hash,
           f.classification_status, f.ai_confidence, f.ai_reason,
           f.extraction_status, f.lines_extracted, f.error_message,
           f.doc_cat_id, dc.doc_cat_code, dc.doc_cat_name_en,
           f.ai_doc_cat_id, ai.doc_cat_code AS ai_doc_cat_code,
           ai.doc_cat_name_en AS ai_doc_cat_name
    FROM   dct_ar_event_files f
    LEFT   JOIN dct_ar_doc_categories dc ON dc.doc_cat_id = f.doc_cat_id
    LEFT   JOIN dct_ar_doc_categories ai ON ai.doc_cat_id = f.ai_doc_cat_id
    WHERE  f.event_id = :id AND f.is_active = 'Y'
    ORDER  BY f.folder_path NULLS FIRST, f.original_file_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('fileId',        r.file_id);
    APEX_JSON.write('folderPath',    NVL(r.folder_path,''));
    APEX_JSON.write('fileName',      r.original_file_name);
    APEX_JSON.write('altFileName',   r.alt_file_name);
    APEX_JSON.write('ext',           r.file_ext);
    APEX_JSON.write('mimeType',      r.mime_type);
    APEX_JSON.write('sizeBytes',     r.file_size_bytes);
    APEX_JSON.write('hash',          r.file_hash);
    APEX_JSON.write('classStatus',   r.classification_status);
    APEX_JSON.write('aiConfidence',  r.ai_confidence);
    APEX_JSON.write('aiReason',      r.ai_reason);
    APEX_JSON.write('extractStatus', r.extraction_status);
    APEX_JSON.write('linesExtracted',r.lines_extracted);
    APEX_JSON.write('errorMessage',  r.error_message);
    APEX_JSON.write('docCatId',      r.doc_cat_id);
    APEX_JSON.write('docCatCode',    r.doc_cat_code);
    APEX_JSON.write('docCatName',    r.doc_cat_name_en);
    APEX_JSON.write('aiDocCatId',    r.ai_doc_cat_id);
    APEX_JSON.write('aiDocCatCode',  r.ai_doc_cat_code);
    APEX_JSON.write('aiDocCatName',  r.ai_doc_cat_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- POST: metadata + optional content_text (body may exceed 32k → CLOB parse)
    def_plsql('events/:id/files', 'POST', q'[
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_body    BLOB := :body;   -- ORDS: :body may only be dereferenced ONCE
  l_clob    CLOB;
  l_doffset INTEGER := 1; l_soffset INTEGER := 1;
  l_langctx INTEGER := DBMS_LOB.DEFAULT_LANG_CTX; l_warn INTEGER;
  l_fid     NUMBER;
  l_hash    VARCHAR2(64);
  l_dup     NUMBER := 0;
  l_text    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  DBMS_LOB.CREATETEMPORARY(l_clob, TRUE);
  IF l_body IS NOT NULL AND DBMS_LOB.GETLENGTH(l_body) > 0 THEN
    DBMS_LOB.CONVERTTOCLOB(l_clob, l_body, DBMS_LOB.GETLENGTH(l_body),
                           l_doffset, l_soffset, DBMS_LOB.DEFAULT_CSID, l_langctx, l_warn);
  END IF;
  APEX_JSON.parse(l_clob);

  l_hash := APEX_JSON.get_varchar2(p_path => 'hash');
  IF l_hash IS NOT NULL THEN
    SELECT COUNT(*) INTO l_dup FROM dct_ar_event_files
    WHERE event_id = :id AND file_hash = l_hash AND is_active = 'Y';
  END IF;

  l_text := APEX_JSON.get_clob(p_path => 'contentText');

  INSERT INTO dct_ar_event_files (
    event_id, folder_path, original_file_name, file_ext, mime_type,
    file_size_bytes, file_hash, content_text, created_by
  ) VALUES (
    :id,
    APEX_JSON.get_varchar2(p_path => 'folderPath'),
    APEX_JSON.get_varchar2(p_path => 'fileName'),
    APEX_JSON.get_varchar2(p_path => 'ext'),
    APEX_JSON.get_varchar2(p_path => 'mimeType'),
    APEX_JSON.get_number(p_path => 'sizeBytes'),
    l_hash, l_text, l_user
  ) RETURNING file_id INTO l_fid;

  UPDATE dct_ar_events SET status = 'FILES_UPLOADED', updated_by = l_user
  WHERE  event_id = :id AND status = 'NEW';
  COMMIT;
  DBMS_LOB.FREETEMPORARY(l_clob);

  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('fileId', l_fid);
  APEX_JSON.write('duplicate', l_dup > 0);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- FILE CONTENT — raw binary upload / authenticated download
    -- =========================================================================
    def_tpl('files/:id/content');
    -- NOTE: raw-binary PUT — respond via :status_code only. Use :body (BLOB);
    -- :body_blob is NOT an implicit param on this ORDS version (binds as
    -- VARCHAR2 → PLS-00382 wrong type).
    def_plsql('files/:id/content', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100);
  l_blob BLOB;
BEGIN
  l_blob := :body;             -- ORDS: body bind may only be dereferenced ONCE
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN :status_code := 401; RETURN; END IF;
  UPDATE dct_ar_event_files
  SET    file_blob       = l_blob,
         file_size_bytes = NVL(DBMS_LOB.GETLENGTH(l_blob), file_size_bytes),
         updated_by      = l_user
  WHERE  file_id = :id;
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; :status_code := 404; RETURN; END IF;
  COMMIT;
  :status_code := 200;
EXCEPTION WHEN OTHERS THEN ROLLBACK; :status_code := 500;
END;
]');

    def_plsql('files/:id/content', 'GET', q'[
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_blob  BLOB;
  l_mime  VARCHAR2(100);
  l_name  VARCHAR2(600);
  l_alt   VARCHAR2(600);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT file_blob, NVL(mime_type,'application/octet-stream'),
         original_file_name, alt_file_name
  INTO   l_blob, l_mime, l_name, l_alt
  FROM   dct_ar_event_files WHERE file_id = :id;
  IF l_blob IS NULL THEN dct_rest.err(404, 'No content uploaded'); RETURN; END IF;

  OWA_UTIL.mime_header(l_mime, FALSE);
  HTP.p('Access-Control-Allow-Origin: *');
  HTP.p('Content-Disposition: inline; filename="' ||
        REPLACE(NVL(l_alt, l_name), '"', '') || '"');
  HTP.p('Content-Length: ' || DBMS_LOB.GETLENGTH(l_blob));
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'File not found');
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- FILE — classification confirm / soft delete
    -- =========================================================================
    def_tpl('files/:id/classification');
    def_plsql('files/:id/classification', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cat  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_cat := APEX_JSON.get_number(p_path => 'docCatId');
  IF l_cat IS NULL THEN dct_rest.err(400, 'docCatId required'); RETURN; END IF;
  dct_ar_ai_pkg.confirm_classification(:id, l_cat, l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('files/:id');
    def_plsql('files/:id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_ar_event_files SET is_active = 'N', updated_by = l_user WHERE file_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- AI PROCESSING — trigger + progress
    -- =========================================================================
    def_tpl('events/:id/process');
    def_plsql('events/:id/process', 'POST', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_action VARCHAR2(10);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_action := UPPER(NVL(APEX_JSON.get_varchar2(p_path => 'action'), 'BOTH'));
  IF l_action NOT IN ('CLASSIFY','EXTRACT','BOTH') THEN l_action := 'BOTH'; END IF;
  -- job created here (ADMIN has CREATE JOB; PROD does not need the privilege)
  DBMS_SCHEDULER.CREATE_JOB(
    job_name   => 'AR_PROC_' || :id || '_' || TO_CHAR(SYSTIMESTAMP, 'HH24MISSFF3'),
    job_type   => 'PLSQL_BLOCK',
    job_action => 'BEGIN prod.dct_ar_ai_pkg.process_event(' || :id ||
                  ', ''' || l_action || '''); END;',
    start_date => SYSTIMESTAMP,
    enabled    => TRUE,
    auto_drop  => TRUE,
    comments   => 'AR AI processing requested by ' || l_user
  );
  UPDATE dct_ar_events SET status = 'AI_PROCESSING', updated_by = l_user
  WHERE  event_id = :id;
  COMMIT;
  OWA_UTIL.status_line(202, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('action', l_action);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- single-file retry (per-file Retry button in the Files tab)
    def_tpl('files/:id/process');
    def_plsql('files/:id/process', 'POST', q'[
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_event_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT event_id INTO l_event_id
  FROM   dct_ar_event_files WHERE file_id = :id AND is_active = 'Y';
  -- job created here (ADMIN has CREATE JOB; PROD does not need the privilege)
  DBMS_SCHEDULER.CREATE_JOB(
    job_name   => 'AR_FILE_' || :id || '_' || TO_CHAR(SYSTIMESTAMP, 'HH24MISSFF3'),
    job_type   => 'PLSQL_BLOCK',
    job_action => 'BEGIN prod.dct_ar_ai_pkg.process_file(' || :id || '); END;',
    start_date => SYSTIMESTAMP,
    enabled    => TRUE,
    auto_drop  => TRUE,
    comments   => 'AR single-file AI retry requested by ' || l_user
  );
  UPDATE dct_ar_events SET status = 'AI_PROCESSING', updated_by = l_user
  WHERE  event_id = l_event_id;
  COMMIT;
  OWA_UTIL.status_line(202, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'File not found');
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('events/:id/progress');
    def_plsql('events/:id/progress', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(30);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_ar_events WHERE event_id = :id;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('eventStatus', l_status);
  FOR r IN (SELECT * FROM dct_ar_file_status_v WHERE event_id = :id) LOOP
    APEX_JSON.write('totalFiles',      r.total_files);
    APEX_JSON.write('classPending',    r.class_pending);
    APEX_JSON.write('classAiDone',     r.class_ai_done);
    APEX_JSON.write('classConfirmed',  r.class_confirmed);
    APEX_JSON.write('classFailed',     r.class_failed);
    APEX_JSON.write('extractPending',  r.extract_pending);
    APEX_JSON.write('extractDone',     r.extract_done);
    APEX_JSON.write('extractConfirmed',r.extract_confirmed);
    APEX_JSON.write('extractFailed',   r.extract_failed);
    APEX_JSON.write('totalLines',      r.total_lines_extracted);
  END LOOP;
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'Event not found');
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- P&L LINES
    -- =========================================================================
    def_tpl('events/:id/pnl');
    def_plsql('events/:id/pnl', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER(:limit DEFAULT NULL ON CONVERSION ERROR), 100), 500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER(:offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_ar_pnl_lines l
  WHERE  l.event_id = :id
  AND    (:type    IS NULL OR l.line_type     = :type)
  AND    (:basis   IS NULL OR l.basis         = :basis)
  AND    (:rstatus IS NULL OR l.review_status = :rstatus)
  AND    (:fileId  IS NULL OR l.file_id       = TO_NUMBER(:fileId DEFAULT NULL ON CONVERSION ERROR));

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT l.line_id, l.file_id, l.source_file_name, l.line_type, l.basis,
           l.item_name, l.category_id, c.category_code, c.category_name_en,
           l.raw_category, l.item_date, l.quantity, l.unit_cost,
           l.amount, l.reported_amount, l.variance_amount,
           l.currency_code, l.exchange_rate, l.base_amount,
           l.vendor_or_payer, l.reference_number, l.comments,
           l.is_ai_extracted, l.ai_confidence, l.review_status, l.is_included
    FROM   dct_ar_pnl_lines l
    LEFT   JOIN dct_ar_pnl_categories c ON c.category_id = l.category_id
    WHERE  l.event_id = :id
    AND    (:type    IS NULL OR l.line_type     = :type)
    AND    (:basis   IS NULL OR l.basis         = :basis)
    AND    (:rstatus IS NULL OR l.review_status = :rstatus)
    AND    (:fileId  IS NULL OR l.file_id       = TO_NUMBER(:fileId DEFAULT NULL ON CONVERSION ERROR))
    ORDER  BY l.line_type, l.basis, l.line_id
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineId',       r.line_id);
    APEX_JSON.write('fileId',       r.file_id);
    APEX_JSON.write('sourceFile',   r.source_file_name);
    APEX_JSON.write('lineType',     r.line_type);
    APEX_JSON.write('basis',        r.basis);
    APEX_JSON.write('itemName',     r.item_name);
    APEX_JSON.write('categoryId',   r.category_id);
    APEX_JSON.write('categoryCode', r.category_code);
    APEX_JSON.write('categoryName', r.category_name_en);
    APEX_JSON.write('rawCategory',  r.raw_category);
    APEX_JSON.write('itemDate',     TO_CHAR(r.item_date,'YYYY-MM-DD'));
    APEX_JSON.write('quantity',     r.quantity);
    APEX_JSON.write('unitCost',     r.unit_cost);
    APEX_JSON.write('amount',       r.amount);
    APEX_JSON.write('reportedAmount', r.reported_amount);
    APEX_JSON.write('varianceAmount', r.variance_amount);
    APEX_JSON.write('currency',     r.currency_code);
    APEX_JSON.write('exchangeRate', r.exchange_rate);
    APEX_JSON.write('baseAmount',   r.base_amount);
    APEX_JSON.write('vendor',       r.vendor_or_payer);
    APEX_JSON.write('reference',    r.reference_number);
    APEX_JSON.write('comments',     r.comments);
    APEX_JSON.write('isAi',         r.is_ai_extracted = 'Y');
    APEX_JSON.write('aiConfidence', r.ai_confidence);
    APEX_JSON.write('reviewStatus', r.review_status);
    APEX_JSON.write('isIncluded',   r.is_included = 'Y');
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('events/:id/pnl', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  INSERT INTO dct_ar_pnl_lines (
    event_id, line_type, basis, item_name, category_id, raw_category,
    item_date, quantity, unit_cost, amount, reported_amount,
    currency_code, exchange_rate, vendor_or_payer, reference_number, comments,
    is_ai_extracted, review_status, is_included, created_by
  ) VALUES (
    :id,
    NVL(APEX_JSON.get_varchar2(p_path=>'lineType'), 'EXPENSE'),
    NVL(APEX_JSON.get_varchar2(p_path=>'basis'), 'ACTUAL'),
    APEX_JSON.get_varchar2(p_path=>'itemName'),
    APEX_JSON.get_number(p_path=>'categoryId'),
    APEX_JSON.get_varchar2(p_path=>'rawCategory'),
    TO_DATE(APEX_JSON.get_varchar2(p_path=>'itemDate'),'YYYY-MM-DD'),
    APEX_JSON.get_number(p_path=>'quantity'),
    APEX_JSON.get_number(p_path=>'unitCost'),
    NVL(APEX_JSON.get_number(p_path=>'amount'), 0),
    APEX_JSON.get_number(p_path=>'reportedAmount'),
    NVL(APEX_JSON.get_varchar2(p_path=>'currency'), 'AED'),
    NVL(APEX_JSON.get_number(p_path=>'exchangeRate'), 1),
    APEX_JSON.get_varchar2(p_path=>'vendor'),
    APEX_JSON.get_varchar2(p_path=>'reference'),
    APEX_JSON.get_varchar2(p_path=>'comments'),
    'N', 'CONFIRMED', 'Y', l_user
  ) RETURNING line_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('lineId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('pnl/:id');
    def_plsql('pnl/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw  VARCHAR2(500);
  l_type VARCHAR2(20);
  l_cat  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);

  UPDATE dct_ar_pnl_lines SET
    line_type     = CASE WHEN APEX_JSON.does_exist(p_path=>'lineType')
                         THEN APEX_JSON.get_varchar2(p_path=>'lineType') ELSE line_type END,
    basis         = CASE WHEN APEX_JSON.does_exist(p_path=>'basis')
                         THEN APEX_JSON.get_varchar2(p_path=>'basis') ELSE basis END,
    item_name     = CASE WHEN APEX_JSON.does_exist(p_path=>'itemName')
                         THEN APEX_JSON.get_varchar2(p_path=>'itemName') ELSE item_name END,
    category_id   = CASE WHEN APEX_JSON.does_exist(p_path=>'categoryId')
                         THEN APEX_JSON.get_number(p_path=>'categoryId') ELSE category_id END,
    item_date     = CASE WHEN APEX_JSON.does_exist(p_path=>'itemDate')
                         THEN TO_DATE(APEX_JSON.get_varchar2(p_path=>'itemDate'),'YYYY-MM-DD') ELSE item_date END,
    quantity      = CASE WHEN APEX_JSON.does_exist(p_path=>'quantity')
                         THEN APEX_JSON.get_number(p_path=>'quantity') ELSE quantity END,
    unit_cost     = CASE WHEN APEX_JSON.does_exist(p_path=>'unitCost')
                         THEN APEX_JSON.get_number(p_path=>'unitCost') ELSE unit_cost END,
    amount        = CASE WHEN APEX_JSON.does_exist(p_path=>'amount')
                         THEN APEX_JSON.get_number(p_path=>'amount') ELSE amount END,
    reported_amount = CASE WHEN APEX_JSON.does_exist(p_path=>'reportedAmount')
                         THEN APEX_JSON.get_number(p_path=>'reportedAmount') ELSE reported_amount END,
    currency_code = CASE WHEN APEX_JSON.does_exist(p_path=>'currency')
                         THEN APEX_JSON.get_varchar2(p_path=>'currency') ELSE currency_code END,
    exchange_rate = CASE WHEN APEX_JSON.does_exist(p_path=>'exchangeRate')
                         THEN NVL(APEX_JSON.get_number(p_path=>'exchangeRate'),1) ELSE exchange_rate END,
    vendor_or_payer  = CASE WHEN APEX_JSON.does_exist(p_path=>'vendor')
                         THEN APEX_JSON.get_varchar2(p_path=>'vendor') ELSE vendor_or_payer END,
    reference_number = CASE WHEN APEX_JSON.does_exist(p_path=>'reference')
                         THEN APEX_JSON.get_varchar2(p_path=>'reference') ELSE reference_number END,
    comments      = CASE WHEN APEX_JSON.does_exist(p_path=>'comments')
                         THEN APEX_JSON.get_varchar2(p_path=>'comments') ELSE comments END,
    review_status = CASE WHEN APEX_JSON.does_exist(p_path=>'reviewStatus')
                         THEN APEX_JSON.get_varchar2(p_path=>'reviewStatus') ELSE review_status END,
    is_included   = CASE WHEN APEX_JSON.does_exist(p_path=>'isIncluded')
                         THEN CASE WHEN APEX_JSON.get_boolean(p_path=>'isIncluded') THEN 'Y' ELSE 'N' END
                         ELSE is_included END,
    updated_by    = l_user
  WHERE line_id = :id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404, 'Line not found'); RETURN; END IF;

  -- learn the category mapping from a user correction
  IF APEX_JSON.does_exist(p_path=>'categoryId') THEN
    SELECT raw_category, line_type, category_id
    INTO   l_raw, l_type, l_cat
    FROM   dct_ar_pnl_lines WHERE line_id = :id;
    IF l_raw IS NOT NULL AND l_cat IS NOT NULL THEN
      MERGE INTO dct_ar_category_map m
      USING (SELECT UPPER(TRIM(SUBSTR(l_raw,1,500))) AS raw_text, l_type AS line_type FROM dual) s
      ON (m.raw_text = s.raw_text AND m.line_type = s.line_type)
      WHEN NOT MATCHED THEN
        INSERT (raw_text, line_type, category_id, source, created_by)
        VALUES (s.raw_text, s.line_type, l_cat, 'USER', l_user)
      WHEN MATCHED THEN
        UPDATE SET m.category_id = l_cat, m.source = 'USER',
                   m.hit_count = m.hit_count + 1, m.updated_by = l_user;
    END IF;
  END IF;
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('pnl/:id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  DELETE FROM dct_ar_pnl_lines WHERE line_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('events/:id/pnl/confirm');
    def_plsql('events/:id/pnl/confirm', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER := 0;
  l_cnt  PLS_INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_cnt := NVL(APEX_JSON.get_count(p_path => 'lineIds'), 0);
  IF l_cnt > 0 THEN
    FOR i IN 1 .. l_cnt LOOP
      UPDATE dct_ar_pnl_lines
      SET    review_status = 'CONFIRMED', updated_by = l_user
      WHERE  line_id = APEX_JSON.get_number(p_path => 'lineIds[%d]', p0 => i)
      AND    event_id = :id AND review_status = 'DRAFT';
      l_n := l_n + SQL%ROWCOUNT;
    END LOOP;
  ELSE
    UPDATE dct_ar_pnl_lines
    SET    review_status = 'CONFIRMED', updated_by = l_user
    WHERE  event_id = :id AND review_status = 'DRAFT';
    l_n := SQL%ROWCOUNT;
  END IF;
  UPDATE dct_ar_events SET status = 'CONFIRMED', updated_by = l_user
  WHERE  event_id = :id AND status = 'UNDER_REVIEW'
  AND    NOT EXISTS (SELECT 1 FROM dct_ar_pnl_lines
                     WHERE event_id = :id AND review_status = 'DRAFT');
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('confirmed', l_n); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- FINDINGS + KPIS
    -- =========================================================================
    def_tpl('events/:id/findings');
    def_plsql('events/:id/findings', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT f.finding_id, f.file_id, ef.original_file_name, f.finding_seq,
                   f.title, f.observation, f.recommendation, f.potential_loss_amount,
                   f.is_ai_extracted, f.review_status
            FROM   dct_ar_event_findings f
            LEFT   JOIN dct_ar_event_files ef ON ef.file_id = f.file_id
            WHERE  f.event_id = :id
            ORDER  BY f.finding_seq, f.finding_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('findingId',     r.finding_id);
    APEX_JSON.write('fileId',        r.file_id);
    APEX_JSON.write('sourceFile',    r.original_file_name);
    APEX_JSON.write('seq',           r.finding_seq);
    APEX_JSON.write('title',         r.title);
    APEX_JSON.write('observation',   r.observation);
    APEX_JSON.write('recommendation',r.recommendation);
    APEX_JSON.write('potentialLoss', r.potential_loss_amount);
    APEX_JSON.write('isAi',          r.is_ai_extracted = 'Y');
    APEX_JSON.write('reviewStatus',  r.review_status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('findings/:id');
    def_plsql('findings/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  UPDATE dct_ar_event_findings SET
    title          = CASE WHEN APEX_JSON.does_exist(p_path=>'title')
                          THEN APEX_JSON.get_varchar2(p_path=>'title') ELSE title END,
    observation    = CASE WHEN APEX_JSON.does_exist(p_path=>'observation')
                          THEN APEX_JSON.get_varchar2(p_path=>'observation') ELSE observation END,
    recommendation = CASE WHEN APEX_JSON.does_exist(p_path=>'recommendation')
                          THEN APEX_JSON.get_varchar2(p_path=>'recommendation') ELSE recommendation END,
    potential_loss_amount = CASE WHEN APEX_JSON.does_exist(p_path=>'potentialLoss')
                          THEN APEX_JSON.get_number(p_path=>'potentialLoss') ELSE potential_loss_amount END,
    review_status  = CASE WHEN APEX_JSON.does_exist(p_path=>'reviewStatus')
                          THEN APEX_JSON.get_varchar2(p_path=>'reviewStatus') ELSE review_status END,
    updated_by     = l_user
  WHERE finding_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('events/:id/kpis');
    def_plsql('events/:id/kpis', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT k.kpi_id, k.file_id, ef.original_file_name, k.kpi_code,
                   NVL(lv.value_name_en, k.kpi_name) AS kpi_label,
                   k.kpi_name, k.kpi_value, k.kpi_unit, k.kpi_text,
                   k.is_ai_extracted, k.review_status
            FROM   dct_ar_event_kpis k
            LEFT   JOIN dct_ar_event_files ef ON ef.file_id = k.file_id
            LEFT   JOIN dct_lookup_categories lc ON lc.category_code = 'AR_KPI_CODE'
            LEFT   JOIN dct_lookup_values lv
                   ON lv.category_id = lc.category_id AND lv.value_code = k.kpi_code
            WHERE  k.event_id = :id
            ORDER  BY k.kpi_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('kpiId',      r.kpi_id);
    APEX_JSON.write('fileId',     r.file_id);
    APEX_JSON.write('sourceFile', r.original_file_name);
    APEX_JSON.write('code',       r.kpi_code);
    APEX_JSON.write('label',      r.kpi_label);
    APEX_JSON.write('name',       r.kpi_name);
    APEX_JSON.write('value',      r.kpi_value);
    APEX_JSON.write('unit',       r.kpi_unit);
    APEX_JSON.write('text',       r.kpi_text);
    APEX_JSON.write('isAi',       r.is_ai_extracted = 'Y');
    APEX_JSON.write('reviewStatus', r.review_status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('events/:id/kpis', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  INSERT INTO dct_ar_event_kpis (
    event_id, kpi_code, kpi_name, kpi_value, kpi_unit, kpi_text,
    is_ai_extracted, review_status, created_by
  ) VALUES (
    :id,
    NVL(APEX_JSON.get_varchar2(p_path=>'code'), 'OTHER'),
    APEX_JSON.get_varchar2(p_path=>'name'),
    APEX_JSON.get_number(p_path=>'value'),
    APEX_JSON.get_varchar2(p_path=>'unit'),
    APEX_JSON.get_varchar2(p_path=>'text'),
    'N', 'CONFIRMED', l_user
  ) RETURNING kpi_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('kpiId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('kpis/:id');
    def_plsql('kpis/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  UPDATE dct_ar_event_kpis SET
    kpi_value     = CASE WHEN APEX_JSON.does_exist(p_path=>'value')
                         THEN APEX_JSON.get_number(p_path=>'value') ELSE kpi_value END,
    kpi_unit      = CASE WHEN APEX_JSON.does_exist(p_path=>'unit')
                         THEN APEX_JSON.get_varchar2(p_path=>'unit') ELSE kpi_unit END,
    kpi_text      = CASE WHEN APEX_JSON.does_exist(p_path=>'text')
                         THEN APEX_JSON.get_varchar2(p_path=>'text') ELSE kpi_text END,
    review_status = CASE WHEN APEX_JSON.does_exist(p_path=>'reviewStatus')
                         THEN APEX_JSON.get_varchar2(p_path=>'reviewStatus') ELSE review_status END,
    updated_by    = l_user
  WHERE kpi_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('kpis/:id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  DELETE FROM dct_ar_event_kpis WHERE kpi_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- MASTERS — P&L categories + document categories
    -- =========================================================================
    def_tpl('categories/');
    def_plsql('categories/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT category_id, category_code, category_name_en, category_name_ar,
                   category_type, description, display_order, is_active
            FROM   dct_ar_pnl_categories
            WHERE  (:type IS NULL OR category_type = :type)
            AND    (:all IS NOT NULL OR is_active = 'Y')
            ORDER  BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('categoryId',  r.category_id);
    APEX_JSON.write('code',        r.category_code);
    APEX_JSON.write('nameEn',      r.category_name_en);
    APEX_JSON.write('nameAr',      r.category_name_ar);
    APEX_JSON.write('type',        r.category_type);
    APEX_JSON.write('description', r.description);
    APEX_JSON.write('displayOrder',r.display_order);
    APEX_JSON.write('isActive',    r.is_active = 'Y');
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('categories/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  INSERT INTO dct_ar_pnl_categories (
    category_code, category_name_en, category_name_ar, category_type,
    description, display_order, created_by
  ) VALUES (
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code'))),
    APEX_JSON.get_varchar2(p_path=>'nameEn'),
    APEX_JSON.get_varchar2(p_path=>'nameAr'),
    NVL(APEX_JSON.get_varchar2(p_path=>'type'), 'EXPENSE'),
    APEX_JSON.get_varchar2(p_path=>'description'),
    NVL(APEX_JSON.get_number(p_path=>'displayOrder'), 500),
    l_user
  ) RETURNING category_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('categoryId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409, 'Category code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('categories/:id');
    def_plsql('categories/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  UPDATE dct_ar_pnl_categories SET
    category_name_en = CASE WHEN APEX_JSON.does_exist(p_path=>'nameEn')
                            THEN APEX_JSON.get_varchar2(p_path=>'nameEn') ELSE category_name_en END,
    category_name_ar = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                            THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE category_name_ar END,
    category_type    = CASE WHEN APEX_JSON.does_exist(p_path=>'type')
                            THEN APEX_JSON.get_varchar2(p_path=>'type') ELSE category_type END,
    description      = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                            THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description END,
    display_order    = CASE WHEN APEX_JSON.does_exist(p_path=>'displayOrder')
                            THEN APEX_JSON.get_number(p_path=>'displayOrder') ELSE display_order END,
    is_active        = CASE WHEN APEX_JSON.does_exist(p_path=>'isActive')
                            THEN CASE WHEN APEX_JSON.get_boolean(p_path=>'isActive') THEN 'Y' ELSE 'N' END
                            ELSE is_active END,
    updated_by       = l_user
  WHERE category_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('doc-categories/');
    def_plsql('doc-categories/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_ar_doc_categories
            WHERE (:all IS NOT NULL OR is_active = 'Y')
            ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docCatId',    r.doc_cat_id);
    APEX_JSON.write('code',        r.doc_cat_code);
    APEX_JSON.write('nameEn',      r.doc_cat_name_en);
    APEX_JSON.write('nameAr',      r.doc_cat_name_ar);
    APEX_JSON.write('description', r.description);
    APEX_JSON.write('isPnlSource', r.is_pnl_source = 'Y');
    APEX_JSON.write('pnlBasis',    r.pnl_basis);
    APEX_JSON.write('extractLines',    r.extract_lines = 'Y');
    APEX_JSON.write('extractKpis',     r.extract_kpis = 'Y');
    APEX_JSON.write('extractFindings', r.extract_findings = 'Y');
    APEX_JSON.write('extractMeta',     r.extract_event_meta = 'Y');
    APEX_JSON.write('hints',           r.extraction_hints);
    APEX_JSON.write('requiredFor',     r.required_for_event_types);
    APEX_JSON.write('displayOrder',    r.display_order);
    APEX_JSON.write('isActive',        r.is_active = 'Y');
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('doc-categories/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  FUNCTION yn (p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN CASE WHEN APEX_JSON.get_boolean(p_path => p) THEN 'Y' ELSE 'N' END;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  INSERT INTO dct_ar_doc_categories (
    doc_cat_code, doc_cat_name_en, doc_cat_name_ar, description,
    is_pnl_source, pnl_basis, extract_lines, extract_kpis,
    extract_findings, extract_event_meta, extraction_hints,
    required_for_event_types, display_order, created_by
  ) VALUES (
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code'))),
    APEX_JSON.get_varchar2(p_path=>'nameEn'),
    APEX_JSON.get_varchar2(p_path=>'nameAr'),
    APEX_JSON.get_varchar2(p_path=>'description'),
    yn('isPnlSource'),
    APEX_JSON.get_varchar2(p_path=>'pnlBasis'),
    yn('extractLines'), yn('extractKpis'),
    yn('extractFindings'), yn('extractMeta'),
    APEX_JSON.get_varchar2(p_path=>'hints'),
    APEX_JSON.get_varchar2(p_path=>'requiredFor'),
    NVL(APEX_JSON.get_number(p_path=>'displayOrder'), 500),
    l_user
  ) RETURNING doc_cat_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('docCatId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409, 'Document category code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('doc-categories/:id');
    def_plsql('doc-categories/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  FUNCTION ynx (p VARCHAR2, p_cur VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF NOT APEX_JSON.does_exist(p_path => p) THEN RETURN p_cur; END IF;
    RETURN CASE WHEN APEX_JSON.get_boolean(p_path => p) THEN 'Y' ELSE 'N' END;
  END;
  r dct_ar_doc_categories%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  SELECT * INTO r FROM dct_ar_doc_categories WHERE doc_cat_id = :id FOR UPDATE;

  UPDATE dct_ar_doc_categories SET
    doc_cat_name_en  = CASE WHEN APEX_JSON.does_exist(p_path=>'nameEn')
                            THEN APEX_JSON.get_varchar2(p_path=>'nameEn') ELSE doc_cat_name_en END,
    doc_cat_name_ar  = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                            THEN APEX_JSON.get_varchar2(p_path=>'nameAr') ELSE doc_cat_name_ar END,
    description      = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                            THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description END,
    is_pnl_source    = ynx('isPnlSource', r.is_pnl_source),
    pnl_basis        = CASE WHEN APEX_JSON.does_exist(p_path=>'pnlBasis')
                            THEN APEX_JSON.get_varchar2(p_path=>'pnlBasis') ELSE pnl_basis END,
    extract_lines    = ynx('extractLines',    r.extract_lines),
    extract_kpis     = ynx('extractKpis',     r.extract_kpis),
    extract_findings = ynx('extractFindings', r.extract_findings),
    extract_event_meta = ynx('extractMeta',   r.extract_event_meta),
    extraction_hints = CASE WHEN APEX_JSON.does_exist(p_path=>'hints')
                            THEN APEX_JSON.get_varchar2(p_path=>'hints') ELSE extraction_hints END,
    required_for_event_types = CASE WHEN APEX_JSON.does_exist(p_path=>'requiredFor')
                            THEN APEX_JSON.get_varchar2(p_path=>'requiredFor') ELSE required_for_event_types END,
    display_order    = CASE WHEN APEX_JSON.does_exist(p_path=>'displayOrder')
                            THEN APEX_JSON.get_number(p_path=>'displayOrder') ELSE display_order END,
    is_active        = ynx('isActive', r.is_active),
    updated_by       = l_user
  WHERE doc_cat_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ROLLBACK; dct_rest.err(404, 'Document category not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- SCENARIOS (what-if)
    -- =========================================================================
    def_tpl('scenarios/');
    def_plsql('scenarios/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT s.scenario_id, s.event_id, s.scenario_name, s.description, s.created_by
            FROM   dct_ar_scenarios s
            WHERE  s.is_active = 'Y'
            AND    (:eventId IS NULL OR s.event_id = TO_NUMBER(:eventId DEFAULT NULL ON CONVERSION ERROR))
            ORDER  BY s.scenario_id DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('scenarioId', r.scenario_id);
    APEX_JSON.write('eventId',    r.event_id);
    APEX_JSON.write('name',       r.scenario_name);
    APEX_JSON.write('description',r.description);
    APEX_JSON.write('createdBy',  r.created_by);
    APEX_JSON.open_array('adjustments');
    FOR a IN (SELECT adj_id, line_type, category_id, adjustment_type, adjustment_value, comments
              FROM dct_ar_scenario_adj WHERE scenario_id = r.scenario_id ORDER BY adj_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('adjId',      a.adj_id);
      APEX_JSON.write('lineType',   a.line_type);
      APEX_JSON.write('categoryId', a.category_id);
      APEX_JSON.write('adjType',    a.adjustment_type);
      APEX_JSON.write('value',      a.adjustment_value);
      APEX_JSON.write('comments',   a.comments);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('scenarios/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_cnt  PLS_INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  INSERT INTO dct_ar_scenarios (event_id, scenario_name, description, created_by)
  VALUES (
    APEX_JSON.get_number(p_path=>'eventId'),
    NVL(APEX_JSON.get_varchar2(p_path=>'name'), 'Scenario'),
    APEX_JSON.get_varchar2(p_path=>'description'),
    l_user
  ) RETURNING scenario_id INTO l_id;

  l_cnt := NVL(APEX_JSON.get_count(p_path=>'adjustments'), 0);
  FOR i IN 1 .. l_cnt LOOP
    INSERT INTO dct_ar_scenario_adj (
      scenario_id, line_type, category_id, adjustment_type, adjustment_value, comments, created_by
    ) VALUES (
      l_id,
      NVL(APEX_JSON.get_varchar2(p_path=>'adjustments[%d].lineType', p0=>i), 'EXPENSE'),
      APEX_JSON.get_number(p_path=>'adjustments[%d].categoryId', p0=>i),
      NVL(APEX_JSON.get_varchar2(p_path=>'adjustments[%d].adjType', p0=>i), 'PCT'),
      NVL(APEX_JSON.get_number(p_path=>'adjustments[%d].value', p0=>i), 0),
      APEX_JSON.get_varchar2(p_path=>'adjustments[%d].comments', p0=>i),
      l_user
    );
  END LOOP;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('scenarioId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('scenarios/:id');
    def_plsql('scenarios/:id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cnt  PLS_INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  UPDATE dct_ar_scenarios SET
    scenario_name = CASE WHEN APEX_JSON.does_exist(p_path=>'name')
                         THEN APEX_JSON.get_varchar2(p_path=>'name') ELSE scenario_name END,
    description   = CASE WHEN APEX_JSON.does_exist(p_path=>'description')
                         THEN APEX_JSON.get_varchar2(p_path=>'description') ELSE description END,
    updated_by    = l_user
  WHERE scenario_id = :id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404, 'Scenario not found'); RETURN; END IF;

  IF APEX_JSON.does_exist(p_path=>'adjustments') THEN
    DELETE FROM dct_ar_scenario_adj WHERE scenario_id = :id;
    l_cnt := NVL(APEX_JSON.get_count(p_path=>'adjustments'), 0);
    FOR i IN 1 .. l_cnt LOOP
      INSERT INTO dct_ar_scenario_adj (
        scenario_id, line_type, category_id, adjustment_type, adjustment_value, comments, created_by
      ) VALUES (
        :id,
        NVL(APEX_JSON.get_varchar2(p_path=>'adjustments[%d].lineType', p0=>i), 'EXPENSE'),
        APEX_JSON.get_number(p_path=>'adjustments[%d].categoryId', p0=>i),
        NVL(APEX_JSON.get_varchar2(p_path=>'adjustments[%d].adjType', p0=>i), 'PCT'),
        NVL(APEX_JSON.get_number(p_path=>'adjustments[%d].value', p0=>i), 0),
        APEX_JSON.get_varchar2(p_path=>'adjustments[%d].comments', p0=>i),
        l_user
      );
    END LOOP;
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('scenarios/:id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_ar_scenarios SET is_active = 'N', updated_by = l_user WHERE scenario_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- STATS — dashboard + per event
    -- =========================================================================
    def_tpl('stats/dashboard');
    def_plsql('stats/dashboard', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_events_ytd NUMBER; l_rev NUMBER; l_exp NUMBER;
  l_pending NUMBER; l_loss NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_events_ytd
  FROM dct_ar_events
  WHERE is_active = 'Y' AND start_date >= TRUNC(SYSDATE,'YYYY');

  SELECT NVL(SUM(total_revenue),0), NVL(SUM(total_expense),0)
  INTO   l_rev, l_exp
  FROM   dct_ar_event_pnl_v WHERE basis = 'ACTUAL';

  SELECT (SELECT COUNT(*) FROM dct_ar_pnl_lines WHERE review_status = 'DRAFT')
       + (SELECT COUNT(*) FROM dct_ar_event_files
          WHERE classification_status = 'AI_CLASSIFIED' AND is_active = 'Y')
  INTO   l_pending FROM dual;

  SELECT NVL(SUM(potential_loss_amount),0) INTO l_loss
  FROM   dct_ar_event_findings WHERE review_status != 'REJECTED';

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('eventsYtd',     l_events_ytd);
  APEX_JSON.write('totalRevenue',  l_rev);
  APEX_JSON.write('totalExpense',  l_exp);
  APEX_JSON.write('netResult',     l_rev - l_exp);
  APEX_JSON.write('pendingReviews',l_pending);
  APEX_JSON.write('potentialLoss', l_loss);

  APEX_JSON.open_array('revExpByEvent');
  FOR r IN (SELECT event_code, event_name_en, total_revenue, total_expense, net_result
            FROM   dct_ar_event_pnl_v WHERE basis = 'ACTUAL'
            ORDER  BY total_revenue DESC FETCH FIRST 10 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('event',   r.event_code);
    APEX_JSON.write('name',    r.event_name_en);
    APEX_JSON.write('revenue', r.total_revenue);
    APEX_JSON.write('expense', r.total_expense);
    APEX_JSON.write('net',     r.net_result);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('marginTrend');
  FOR r IN (SELECT TO_CHAR(TRUNC(e.start_date,'MM'),'YYYY-MM') AS mth,
                   SUM(v.total_revenue) rev, SUM(v.total_expense) exp
            FROM   dct_ar_event_pnl_v v
            JOIN   dct_ar_events e ON e.event_id = v.event_id
            WHERE  v.basis = 'ACTUAL' AND e.start_date IS NOT NULL
            GROUP  BY TRUNC(e.start_date,'MM')
            ORDER  BY TRUNC(e.start_date,'MM')) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('month',   r.mth);
    APEX_JSON.write('revenue', r.rev);
    APEX_JSON.write('expense', r.exp);
    APEX_JSON.write('net',     r.rev - r.exp);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('expenseByCategory');
  FOR r IN (SELECT category_name_en, SUM(total_amount) amt
            FROM   dct_ar_category_pnl_v
            WHERE  line_type = 'EXPENSE' AND basis = 'ACTUAL'
            GROUP  BY category_name_en
            ORDER  BY SUM(total_amount) DESC FETCH FIRST 8 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('category', r.category_name_en);
    APEX_JSON.write('amount',   r.amt);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('budgetVsActual');
  FOR r IN (SELECT e.event_code,
                   NVL(SUM(CASE WHEN v.basis='BUDGET' THEN v.total_expense END),0) budget_exp,
                   NVL(SUM(CASE WHEN v.basis='ACTUAL' THEN v.total_expense END),0) actual_exp
            FROM   dct_ar_event_pnl_v v
            JOIN   dct_ar_events e ON e.event_id = v.event_id
            GROUP  BY e.event_code
            HAVING SUM(CASE WHEN v.basis='BUDGET' THEN v.total_expense END) IS NOT NULL
                OR SUM(CASE WHEN v.basis='ACTUAL' THEN v.total_expense END) IS NOT NULL
            ORDER  BY 3 DESC FETCH FIRST 10 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('event',     r.event_code);
    APEX_JSON.write('budget',    r.budget_exp);
    APEX_JSON.write('actual',    r.actual_exp);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('stats/events/:id');
    def_plsql('stats/events/:id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  APEX_JSON.open_array('summary');
  FOR r IN (SELECT basis, total_revenue, total_expense, net_result, margin_pct
            FROM dct_ar_event_pnl_v WHERE event_id = :id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('basis',     r.basis);
    APEX_JSON.write('revenue',   r.total_revenue);
    APEX_JSON.write('expense',   r.total_expense);
    APEX_JSON.write('net',       r.net_result);
    APEX_JSON.write('marginPct', r.margin_pct);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('byCategory');
  FOR r IN (SELECT line_type, basis, category_code, category_name_en, total_amount, line_count
            FROM   dct_ar_category_pnl_v WHERE event_id = :id
            ORDER  BY line_type, total_amount DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineType', r.line_type);
    APEX_JSON.write('basis',    r.basis);
    APEX_JSON.write('code',     r.category_code);
    APEX_JSON.write('name',     r.category_name_en);
    APEX_JSON.write('amount',   r.total_amount);
    APEX_JSON.write('count',    r.line_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- SETTINGS + LOOKUPS
    -- =========================================================================
    def_tpl('settings/');
    def_plsql('settings/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT ms.setting_key, ms.setting_value, ms.setting_label,
                   ms.setting_description, ms.value_type, ms.allowed_values, ms.default_value,
                   ms.updated_by, ms.updated_at
            FROM   dct_module_settings ms
            JOIN   dct_modules m ON m.module_id = ms.module_id
            WHERE  m.module_code = 'ACCOUNTS_RECEIVABLE'
            ORDER  BY ms.setting_key) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('key',         r.setting_key);
    APEX_JSON.write('value',       CASE WHEN r.setting_key LIKE '%API_KEY'
                                        THEN CASE WHEN r.setting_value IS NULL THEN '' ELSE '********' END
                                        ELSE r.setting_value END);
    APEX_JSON.write('label',       r.setting_label);
    APEX_JSON.write('description', r.setting_description);
    APEX_JSON.write('type',        r.value_type);
    APEX_JSON.write('allowed',     r.allowed_values);
    APEX_JSON.write('default',     r.default_value);
    APEX_JSON.write('updatedBy',   r.updated_by);
    APEX_JSON.write('updatedAt',   TO_CHAR(r.updated_at, 'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('settings/', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_key  VARCHAR2(100);
  l_val  VARCHAR2(1000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_key := APEX_JSON.get_varchar2(p_path=>'key');
  l_val := APEX_JSON.get_varchar2(p_path=>'value');
  IF l_key IS NULL THEN dct_rest.err(400,'key required'); RETURN; END IF;
  -- AI_PROVIDER must point at an active row in the provider registry
  IF l_key = 'AI_PROVIDER' THEN
    DECLARE l_n NUMBER;
    BEGIN
      SELECT COUNT(*) INTO l_n FROM dct_ar_ai_providers
      WHERE  UPPER(provider_code) = UPPER(TRIM(l_val)) AND is_active = 'Y';
      IF l_n = 0 THEN dct_rest.err(400,'Unknown or inactive AI provider: ' || l_val); RETURN; END IF;
    END;
  END IF;
  -- never overwrite an API key with the mask or blank
  IF l_key LIKE '%API_KEY' AND (l_val IS NULL OR l_val = '********') THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object; APEX_JSON.write('ok', TRUE);
    APEX_JSON.write('skipped', TRUE); APEX_JSON.close_object;
    RETURN;
  END IF;
  UPDATE dct_module_settings ms
  SET    ms.setting_value = l_val, ms.updated_by = l_user, ms.updated_at = SYSTIMESTAMP
  WHERE  ms.setting_key = l_key
  AND    ms.module_id = (SELECT module_id FROM dct_modules
                         WHERE module_code = 'ACCOUNTS_RECEIVABLE');
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Setting not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- AI PROVIDERS — registry behind the Manage Providers popup.
    -- api_key is WRITE-ONLY: list returns hasKey Y/N, never the key itself.
    -- =========================================================================
    def_tpl('providers/');
    def_plsql('providers/', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT provider_id, provider_code, provider_name, api_format, base_url,
                   model_id,
                   CASE WHEN api_key IS NULL THEN 'N' ELSE 'Y' END AS has_key,
                   is_active, created_by, created_at, updated_by, updated_at
            FROM   dct_ar_ai_providers
            ORDER  BY provider_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id',        r.provider_id);
    APEX_JSON.write('code',      r.provider_code);
    APEX_JSON.write('name',      r.provider_name);
    APEX_JSON.write('apiFormat', r.api_format);
    APEX_JSON.write('baseUrl',   r.base_url);
    APEX_JSON.write('model',     r.model_id);
    APEX_JSON.write('hasKey',    r.has_key);
    APEX_JSON.write('isActive',  r.is_active);
    APEX_JSON.write('createdBy', r.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(r.created_at, 'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('updatedBy', r.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(r.updated_at, 'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('providers/', 'POST', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_code   VARCHAR2(30);
  l_name   VARCHAR2(100);
  l_format VARCHAR2(20);
  l_url    VARCHAR2(300);
  l_model  VARCHAR2(100);
  l_key    VARCHAR2(200);
  l_active VARCHAR2(1);
  l_id     NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_code   := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code')));
  l_name   := TRIM(APEX_JSON.get_varchar2(p_path=>'name'));
  l_format := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'apiFormat')));
  l_url    := TRIM(APEX_JSON.get_varchar2(p_path=>'baseUrl'));
  l_model  := TRIM(APEX_JSON.get_varchar2(p_path=>'model'));
  l_key    := APEX_JSON.get_varchar2(p_path=>'apiKey');
  l_active := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isActive')), 'Y');
  IF l_code IS NULL OR l_name IS NULL OR l_format IS NULL OR l_model IS NULL THEN
    dct_rest.err(400,'code, name, apiFormat and model are required'); RETURN;
  END IF;
  IF l_active NOT IN ('Y','N') THEN l_active := 'Y'; END IF;
  IF l_key = '********' THEN l_key := NULL; END IF;
  dct_lookup_pkg.validate_lookup('AR_API_FORMAT', l_format);
  INSERT INTO dct_ar_ai_providers
    (provider_code, provider_name, api_format, base_url, model_id, api_key, is_active, created_by)
  VALUES
    (l_code, l_name, l_format, l_url, l_model, l_key, l_active, l_user)
  RETURNING provider_id INTO l_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('id', l_id);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409,'Provider code already exists: ' || l_code);
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('providers/:id');
    def_plsql('providers/:id', 'PUT', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_format VARCHAR2(20);
  l_key    VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body(:body);
  l_format := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'apiFormat')));
  IF l_format IS NOT NULL THEN
    dct_lookup_pkg.validate_lookup('AR_API_FORMAT', l_format);
  END IF;
  UPDATE dct_ar_ai_providers p
  SET    p.provider_name = CASE WHEN APEX_JSON.does_exist(p_path=>'name')
                                THEN NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'name')), p.provider_name)
                                ELSE p.provider_name END,
         p.api_format    = NVL(l_format, p.api_format),
         p.base_url      = CASE WHEN APEX_JSON.does_exist(p_path=>'baseUrl')
                                THEN TRIM(APEX_JSON.get_varchar2(p_path=>'baseUrl'))
                                ELSE p.base_url END,
         p.model_id      = CASE WHEN APEX_JSON.does_exist(p_path=>'model')
                                THEN NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'model')), p.model_id)
                                ELSE p.model_id END,
         p.is_active     = CASE WHEN UPPER(APEX_JSON.get_varchar2(p_path=>'isActive')) IN ('Y','N')
                                THEN UPPER(APEX_JSON.get_varchar2(p_path=>'isActive'))
                                ELSE p.is_active END,
         p.updated_by    = l_user,
         p.updated_at    = SYSTIMESTAMP
  WHERE  p.provider_id = :id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Provider not found'); RETURN; END IF;
  -- api_key is replace-only: absent / blank / mask means keep the stored key
  l_key := APEX_JSON.get_varchar2(p_path=>'apiKey');
  IF APEX_JSON.does_exist(p_path=>'apiKey')
     AND l_key IS NOT NULL AND l_key != '********' THEN
    UPDATE dct_ar_ai_providers SET api_key = l_key WHERE provider_id = :id;
  END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_plsql('providers/:id', 'DELETE', q'[
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_code     VARCHAR2(30);
  l_active   VARCHAR2(1);
  l_selected VARCHAR2(1000);
  l_others   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT provider_code, is_active INTO l_code, l_active
    FROM   dct_ar_ai_providers WHERE provider_id = :id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404,'Provider not found'); RETURN;
  END;
  SELECT MAX(ms.setting_value) INTO l_selected
  FROM   dct_module_settings ms
  JOIN   dct_modules m ON m.module_id = ms.module_id
  WHERE  m.module_code = 'ACCOUNTS_RECEIVABLE' AND ms.setting_key = 'AI_PROVIDER';
  IF UPPER(NVL(l_selected,'-')) = UPPER(l_code) THEN
    dct_rest.err(400,'Cannot delete the currently selected AI provider — switch AI Provider first');
    RETURN;
  END IF;
  SELECT COUNT(*) INTO l_others FROM dct_ar_ai_providers
  WHERE  provider_id != :id AND is_active = 'Y';
  IF l_active = 'Y' AND l_others = 0 THEN
    dct_rest.err(400,'Cannot delete the only active AI provider');
    RETURN;
  END IF;
  DELETE FROM dct_ar_ai_providers WHERE provider_id = :id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

    def_tpl('meta/lookups');
    def_plsql('meta/lookups', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_first BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR cat IN (SELECT lc.category_id, lc.category_code
              FROM   dct_lookup_categories lc
              WHERE  lc.category_code IN ('AR_EVENT_TYPE','AR_EVENT_STATUS','AR_LINE_TYPE',
                                          'AR_PNL_BASIS','AR_REVIEW_STATUS','AR_CATEGORY_TYPE',
                                          'AR_ADJ_TYPE','AR_KPI_CODE','AR_CLASS_STATUS',
                                          'AR_EXTRACT_STATUS')) LOOP
    APEX_JSON.open_array(cat.category_code);
    FOR v IN (SELECT value_code, value_name_en, value_name_ar
              FROM   dct_lookup_values
              WHERE  category_id = cat.category_id AND is_active = 'Y'
              ORDER  BY display_order) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code',   v.value_code);
      APEX_JSON.write('nameEn', v.value_name_en);
      APEX_JSON.write('nameAr', v.value_name_ar);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END LOOP;

  APEX_JSON.open_array('currencies');
  FOR c IN (SELECT currency_code FROM dct_currency_codes
            WHERE is_active = 'Y' ORDER BY currency_code) LOOP
    APEX_JSON.write(c.currency_code);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AR ORDS module ar.rest published at /ords/admin/ar/');
END;
/

BEGIN
    setup_ar_ords_tmp;
END;
/

DROP PROCEDURE setup_ar_ords_tmp;

PROMPT === AR ORDS complete: module ar.rest at /ords/admin/ar/ ===
