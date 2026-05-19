-- =================================================================
-- Phase 3: ORDS Endpoints — AI Clearing & Reimbursement
-- Adds 5 new templates to the existing 'dct.admin' module
-- Run as ADMIN
-- =================================================================
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

BEGIN

    -- ---------------------------------------------------------------
    -- 1. POST pch/ai/extract/:request_type/:request_id
    --    Accepts raw file as POST body (BLOB).
    --    MIME type read from Content-Type header.
    --    File name read from X-File-Name header.
    -- ---------------------------------------------------------------
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'dct.admin',
        p_pattern     => 'pch/ai/extract/:request_type/:request_id',
        p_priority    => 0,
        p_etag_type   => 'HASH',
        p_comments    => 'AI extract expense lines from uploaded file'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name   => 'dct.admin',
        p_pattern       => 'pch/ai/extract/:request_type/:request_id',
        p_method        => 'POST',
        p_source_type   => ORDS.source_type_plsql,
        p_mimes_allowed => 'application/pdf,text/csv,text/plain,application/octet-stream',
        p_comments      => 'Extract expense lines via Claude AI',
        p_source        => q'[
DECLARE
    l_user  VARCHAR2(100) := dct_rest.validate_session;
    l_rtype VARCHAR2(10)  := UPPER(:request_type);
    l_rid   NUMBER        := TO_NUMBER(:request_id);
    l_mime  VARCHAR2(200);
    l_fname VARCHAR2(500);
BEGIN
    IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
    IF :body  IS NULL THEN dct_rest.err(400, 'File body required'); RETURN; END IF;
    IF l_rtype NOT IN ('CLEARING','REIMB') THEN
        dct_rest.err(400, 'request_type must be CLEARING or REIMB'); RETURN;
    END IF;

    l_mime  := TRIM(REGEXP_SUBSTR(
                   NVL(OWA_UTIL.GET_CGI_ENV('CONTENT_TYPE'), 'application/octet-stream'),
                   '[^;]+', 1, 1));
    l_fname := NVL(OWA_UTIL.GET_CGI_ENV('HTTP_X_FILE_NAME'), 'uploaded_file');

    prod.dct_pc_ai_pkg.extract_from_file(
        p_file_blob    => :body,
        p_mime_type    => l_mime,
        p_file_name    => l_fname,
        p_request_type => l_rtype,
        p_request_id   => l_rid
    );

    dct_rest.json_header;
    HTP.P('{"status":"ok","message":"Extraction complete"}');
EXCEPTION
    WHEN OTHERS THEN dct_rest.err(500, SUBSTR(SQLERRM, 1, 500));
END;
]'
    );

    -- ---------------------------------------------------------------
    -- 2. POST pch/ai/validate/:request_type/:request_id
    --    Runs both validation rules on all AI-extracted lines.
    --    Returns total + valid counts.
    -- ---------------------------------------------------------------
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'dct.admin',
        p_pattern     => 'pch/ai/validate/:request_type/:request_id',
        p_priority    => 0,
        p_etag_type   => 'HASH',
        p_comments    => 'Validate AI-extracted expense lines'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name   => 'dct.admin',
        p_pattern       => 'pch/ai/validate/:request_type/:request_id',
        p_method        => 'POST',
        p_source_type   => ORDS.source_type_plsql,
        p_comments      => 'Run duplicate-ref + date rules on all AI lines',
        p_source        => q'[
DECLARE
    l_user  VARCHAR2(100) := dct_rest.validate_session;
    l_rtype VARCHAR2(10)  := UPPER(:request_type);
    l_rid   NUMBER        := TO_NUMBER(:request_id);
    l_total NUMBER := 0;
    l_valid NUMBER := 0;
BEGIN
    IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
    IF l_rtype NOT IN ('CLEARING','REIMB') THEN
        dct_rest.err(400, 'request_type must be CLEARING or REIMB'); RETURN;
    END IF;

    prod.dct_pc_ai_pkg.validate_lines(l_rtype, l_rid);

    IF l_rtype = 'CLEARING' THEN
        SELECT ai_total_lines, ai_valid_lines INTO l_total, l_valid
        FROM   prod.dct_pc_clearing WHERE clearing_id = l_rid;
    ELSE
        SELECT ai_total_lines, ai_valid_lines INTO l_total, l_valid
        FROM   prod.dct_pc_reimbursements WHERE reimb_id = l_rid;
    END IF;

    dct_rest.json_header;
    HTP.P('{"status":"ok","total":' || l_total || ',"valid":' || l_valid
          || ',"invalid":' || (l_total - l_valid) || '}');
EXCEPTION
    WHEN NO_DATA_FOUND THEN dct_rest.err(404, 'Request not found');
    WHEN OTHERS        THEN dct_rest.err(500, SUBSTR(SQLERRM, 1, 500));
END;
]'
    );

    -- ---------------------------------------------------------------
    -- 3. GET pch/lines/:request_type/:request_id
    --    Returns all AI-extracted lines for a request as JSON array.
    -- ---------------------------------------------------------------
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'dct.admin',
        p_pattern     => 'pch/lines/:request_type/:request_id',
        p_priority    => 0,
        p_etag_type   => 'HASH',
        p_comments    => 'Get AI-extracted expense lines'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name   => 'dct.admin',
        p_pattern       => 'pch/lines/:request_type/:request_id',
        p_method        => 'GET',
        p_source_type   => ORDS.source_type_plsql,
        p_comments      => 'Return AI lines as JSON array',
        p_source        => q'[
DECLARE
    l_user  VARCHAR2(100) := dct_rest.validate_session;
    l_rtype VARCHAR2(10)  := UPPER(:request_type);
    l_rid   NUMBER        := TO_NUMBER(:request_id);
    l_json  CLOB;
BEGIN
    IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
    IF l_rtype NOT IN ('CLEARING','REIMB') THEN
        dct_rest.err(400, 'request_type must be CLEARING or REIMB'); RETURN;
    END IF;

    l_json := prod.dct_pc_ai_pkg.get_lines_json(l_rtype, l_rid);

    dct_rest.json_header;
    HTP.P(l_json);
EXCEPTION
    WHEN OTHERS THEN dct_rest.err(500, SUBSTR(SQLERRM, 1, 500));
END;
]'
    );

    -- ---------------------------------------------------------------
    -- 4. DELETE pch/lines/:request_type/:request_id/:line_id
    --    Remove a single AI-extracted line from a DRAFT request.
    -- ---------------------------------------------------------------
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'dct.admin',
        p_pattern     => 'pch/lines/:request_type/:request_id/:line_id',
        p_priority    => 0,
        p_etag_type   => 'HASH',
        p_comments    => 'Delete a single AI-extracted expense line'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name   => 'dct.admin',
        p_pattern       => 'pch/lines/:request_type/:request_id/:line_id',
        p_method        => 'DELETE',
        p_source_type   => ORDS.source_type_plsql,
        p_comments      => 'Remove AI line from DRAFT request',
        p_source        => q'[
DECLARE
    l_user  VARCHAR2(100) := dct_rest.validate_session;
    l_rtype VARCHAR2(10)  := UPPER(:request_type);
    l_lid   NUMBER        := TO_NUMBER(:line_id);
BEGIN
    IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
    IF l_rtype NOT IN ('CLEARING','REIMB') THEN
        dct_rest.err(400, 'request_type must be CLEARING or REIMB'); RETURN;
    END IF;

    prod.dct_pc_ai_pkg.delete_line(l_lid, l_rtype);

    dct_rest.json_header;
    HTP.P('{"status":"ok"}');
EXCEPTION
    WHEN OTHERS THEN dct_rest.err(500, SUBSTR(SQLERRM, 1, 500));
END;
]'
    );

    -- ---------------------------------------------------------------
    -- 5. POST pch/refs/:request_type/:request_id
    --    Register all VALID+included reference numbers on submit.
    --    Looks up employee_number from the session user.
    -- ---------------------------------------------------------------
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'dct.admin',
        p_pattern     => 'pch/refs/:request_type/:request_id',
        p_priority    => 0,
        p_etag_type   => 'HASH',
        p_comments    => 'Register reference numbers on request submit'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name   => 'dct.admin',
        p_pattern       => 'pch/refs/:request_type/:request_id',
        p_method        => 'POST',
        p_source_type   => ORDS.source_type_plsql,
        p_comments      => 'Lock in ref#s so they cannot be reused company-wide',
        p_source        => q'[
DECLARE
    l_user   VARCHAR2(100) := dct_rest.validate_session;
    l_rtype  VARCHAR2(10)  := UPPER(:request_type);
    l_rid    NUMBER        := TO_NUMBER(:request_id);
    l_empnum VARCHAR2(50);
BEGIN
    IF l_user IS NULL THEN dct_rest.err(401, 'Unauthorized'); RETURN; END IF;
    IF l_rtype NOT IN ('CLEARING','REIMB') THEN
        dct_rest.err(400, 'request_type must be CLEARING or REIMB'); RETURN;
    END IF;

    BEGIN
        SELECT employee_number INTO l_empnum
        FROM   prod.dct_users
        WHERE  username = l_user;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN l_empnum := l_user;
    END;

    prod.dct_pc_ai_pkg.register_references(l_rtype, l_rid, l_empnum);

    dct_rest.json_header;
    HTP.P('{"status":"ok"}');
EXCEPTION
    WHEN OTHERS THEN dct_rest.err(500, SUBSTR(SQLERRM, 1, 500));
END;
]'
    );

    COMMIT;
END;
/

PROMPT Phase 3 complete.
