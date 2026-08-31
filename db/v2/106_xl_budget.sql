-- =============================================================================
-- i-Finance V2 - Excel integration layer (part 1 of 2): budget CHANGE (+/-)
-- File    : 106_xl_budget.sql
-- Schema  : PROD (run as ADMIN, objects schema-qualified)
-- Date    : 2026-07-27 / reworked 2026-08-17 (v2 - signed change amounts)
-- =============================================================================
-- Purpose : end users post a signed BUDGET CHANGE (+/-) against a project
--           budget line at a chosen accounting period, directly from Microsoft
--           Excel via the Oracle Visual Builder Add-in for Excel over the
--           xl.rest ORDS module (107_xl_budget_ords.sql).
--
-- v2 semantics (2026-08-17, user decision):
--           * the stored figure is a CHANGE, not a replacement. It is ADDED to
--             the Fusion budget (a negative value subtracts). The old
--             BUDGET_USER "replace the budget" model is gone.
--           * the Excel sheet is LINE grain - one row per project + task +
--             expenditure type for the budget year - carrying the ANNUAL and
--             the YTD budget (YTD = periods on/before the selected period),
--             the change already saved, and the adjusted figures.
--           * the download is scoped by Business Unit and Project Type, which
--             default to the exact names 'Department of Culture and Tourism'
--             and 'DCT OPEX Project Type'.
--
-- Storage rule (IMPORTANT): the figure does NOT live on ATD_PROJECTS_BUDGET.
--           That table is reloaded from Fusion - the daily "Projects Budget
--           Full" job is TRUNCATE_INSERT with the real table as stage, so any
--           column value typed by a user there would be wiped every day.
--           The change lives in PROD.DCT_PROJECT_BUDGET_USER, keyed on the
--           extract natural key (project_id, task_id, expenditure_type,
--           accounting_period). Reload-proof by construction; matches the
--           platform split "extract tables are disposable, DCT_* tables are
--           authoritative".
--
-- Un-phased budget (load-bearing): the Fusion budget is NOT cashflow-phased -
--           1,736 of 1,779 FY2026 lines carry exactly ONE period row and most
--           sit in 01-2026. A change booked at 08-2026 therefore usually has NO
--           matching ATD_PROJECTS_BUDGET row, so save_item validates the LINE
--           within the budget year (not the exact period row) and every
--           consumer counts change rows INDEPENDENTLY of the Fusion rows.
--
-- Auth    : the xl.rest handlers are Excel-facing and use HTTP Basic (the only
--           scheme the VB add-in supports for ORDS). DCT_XL_PKG validates the
--           Basic credentials against DCT_USERS itself (auth_method DB only,
--           silent on success, audit-logged on failure via dct_auth) - no
--           database accounts are ever handed to end users.
--
-- Order   : table -> package spec -> view (uses spec function) -> package body
-- Rerunnable. No MERGE keyword anywhere (Linux SQLcl swallowing gotcha).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 106.1 table DCT_PROJECT_BUDGET_USER ===

DECLARE
    l_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_cnt
    FROM   all_tables
    WHERE  owner = 'PROD' AND table_name = 'DCT_PROJECT_BUDGET_USER';
    IF l_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE prod.dct_project_budget_user (
                project_id        NUMBER         NOT NULL,
                task_id           NUMBER         NOT NULL,
                expenditure_type  VARCHAR2(150)  NOT NULL,
                accounting_period VARCHAR2(20)   NOT NULL,
                budget_change     NUMBER         NOT NULL,
                updated_by_id     NUMBER         NOT NULL,
                updated_by        VARCHAR2(100),
                updated_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
                CONSTRAINT pk_dct_pb_user
                    PRIMARY KEY (project_id, task_id, expenditure_type, accounting_period)
            )]';
    END IF;
    -- 2026-07-28: classification of the change (lookup-first) + free-text
    -- justification. Both editable from the Excel VB template AND the GL
    -- Budget Change drawer.
    SELECT COUNT(*) INTO l_cnt FROM all_tab_columns
    WHERE  owner = 'PROD' AND table_name = 'DCT_PROJECT_BUDGET_USER'
      AND  column_name = 'REASON_CATEGORY';
    IF l_cnt = 0 THEN
        EXECUTE IMMEDIATE
            'ALTER TABLE prod.dct_project_budget_user ADD (reason_category VARCHAR2(100), comments VARCHAR2(1000))';
    END IF;
END;
/

PROMPT === 106.1a one-time migration to the signed change model ===

-- Runs EXACTLY ONCE - guarded on the old column name, a no-op on every later
-- re-run. The stored BUDGET_USER figures were ABSOLUTE replacements and are
-- meaningless as change amounts (they were ADMIN replay rows: exact copies of
-- the Fusion figure, or 0 meaning "zero this line out"), so they are removed
-- rather than converted (user decision 2026-08-17).
DECLARE
    l_cnt NUMBER;
    l_del NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO l_cnt FROM all_tab_columns
    WHERE  owner = 'PROD' AND table_name = 'DCT_PROJECT_BUDGET_USER'
      AND  column_name = 'BUDGET_USER';
    IF l_cnt = 1 THEN
        EXECUTE IMMEDIATE 'DELETE FROM prod.dct_project_budget_user';
        l_del := SQL%ROWCOUNT;
        COMMIT;
        EXECUTE IMMEDIATE
            'ALTER TABLE prod.dct_project_budget_user RENAME COLUMN budget_user TO budget_change';
        DBMS_OUTPUT.put_line('migrated to budget_change; legacy rows removed: ' || l_del);
    ELSE
        DBMS_OUTPUT.put_line('budget_change already in place - migration skipped');
    END IF;
END;
/

PROMPT === 106.1b lookup category XL_OVERRIDE_REASON ===

DECLARE
    l_cat NUMBER;
    PROCEDURE val (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
        l_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_n FROM prod.dct_lookup_values
        WHERE  category_id = l_cat AND value_code = p_code;
        IF l_n = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_active, created_by)
            VALUES (l_cat, p_code, p_en, p_ar, p_ord, 'Y', 'SYSTEM');
        END IF;
    END;
BEGIN
    BEGIN
        SELECT category_id INTO l_cat FROM prod.dct_lookup_categories
        WHERE  category_code = 'XL_OVERRIDE_REASON';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO prod.dct_lookup_categories
               (category_code, category_name_en, category_name_ar, is_system, is_active, created_by)
        VALUES ('XL_OVERRIDE_REASON', 'Budget Change Reason',
                UNISTR('\0633\0628\0628 \062A\0639\062F\064A\0644 \0627\0644\0645\0648\0627\0632\0646\0629'),
                'N', 'Y', 'SYSTEM')
        RETURNING category_id INTO l_cat;
    END;
    val('SYSTEM_ISSUES',        'System issues',        UNISTR('\0645\0634\0627\0643\0644 \0641\064A \0627\0644\0646\0638\0627\0645'), 10);
    val('REQUEST_NOT_RECEIVED', 'Request not received', UNISTR('\0644\0645 \064A\062A\0645 \0627\0633\062A\0644\0627\0645 \0627\0644\0637\0644\0628'), 20);
    val('BUDGET_REALLOCATION',  'Budget reallocation',  UNISTR('\0625\0639\0627\062F\0629 \062A\0648\0632\064A\0639 \0627\0644\0645\0648\0627\0632\0646\0629'), 30);
    val('DATA_CORRECTION',      'Data correction',      UNISTR('\062A\0635\062D\064A\062D \0627\0644\0628\064A\0627\0646\0627\062A'), 40);
    val('OTHER',                'Other',                UNISTR('\0623\062E\0631\0649'), 50);
    COMMIT;
END;
/

PROMPT === 106.2 package spec DCT_XL_PKG ===

CREATE OR REPLACE PACKAGE prod.dct_xl_pkg AS

    -- Exact default download scope (user rule 2026-08-17): the names are the
    -- stored ATD_PROJECTS values, matched with = (never a contains-match).
    c_default_bu    CONSTANT VARCHAR2(60) := 'Department of Culture and Tourism';
    c_default_ptype CONSTANT VARCHAR2(40) := 'DCT OPEX Project Type';

    -- Resolve the HTTP Basic credentials in the AUTHORIZATION CGI header to a
    -- DCT_USERS user_id. NULL when absent or invalid. DB-auth users only.
    FUNCTION basic_user_id RETURN NUMBER;

    -- Handler guard: p_uid is set on success; on failure the 401 response
    -- (including the WWW-Authenticate challenge the Excel add-in needs to
    -- prompt for credentials) is written and p_uid returns NULL.
    PROCEDURE require_user (p_uid OUT NUMBER);

    -- Opaque url-safe row id over the extract natural key (etype LAST so a
    -- delimiter inside the expenditure type name can never break decoding).
    -- The period carried in the id is the period the CHANGE is booked to.
    FUNCTION encode_id (
        p_project_id IN NUMBER,
        p_task_id    IN NUMBER,
        p_period     IN VARCHAR2,
        p_etype      IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC;

    PROCEDURE decode_id (
        p_id          IN  VARCHAR2,
        o_project_id  OUT NUMBER,
        o_task_id     OUT NUMBER,
        o_period      OUT VARCHAR2,
        o_etype       OUT VARCHAR2
    );

    -- GET budget/ - one row per budget LINE (project + task + expenditure
    -- type) of the budget year, with annual + YTD budget, the change saved at
    -- the selected period and the adjusted figures.
    -- year and period are MANDATORY (400 without them). Business Unit and
    -- Project Type fall back to the c_default_* names above.
    PROCEDURE emit_list (
        p_uid    IN NUMBER,
        p_limit  IN VARCHAR2,
        p_offset IN VARCHAR2,
        p_year   IN VARCHAR2,
        p_period IN VARCHAR2,
        p_bu     IN VARCHAR2 DEFAULT NULL,
        p_ptype  IN VARCHAR2 DEFAULT NULL,
        p_search IN VARCHAR2 DEFAULT NULL
    );

    -- GET budget/:id - one line row (the id carries the period).
    PROCEDURE emit_item (p_uid IN NUMBER, p_id IN VARCHAR2);

    -- PUT budget/:id - set or clear the signed change at the id's period.
    -- ONLY budget_change (plus reason_category / comments) is writable; every
    -- other field is display-only and ignored even if the client sends it.
    PROCEDURE save_item (p_uid IN NUMBER, p_id IN VARCHAR2, p_body IN BLOB);

    -- GET lov/:kind - pick lists for the download parameters:
    -- business-units | project-types | periods | budget-years | reasons.
    PROCEDURE emit_lov (p_kind IN VARCHAR2, p_year IN VARCHAR2 DEFAULT NULL);

    -- GET openapi - hand-authored OpenAPI 3.0 description served to the Excel
    -- add-in. The ORDS auto-generated open-api-catalog for a CUSTOM module has
    -- NO field schemas (ORDS cannot know what a PL/SQL handler emits), so the
    -- add-in finds the business object but lists no fields and hides it. This
    -- document carries the full BudgetRow schema, readOnly flags on every
    -- field except the three writable ones, the download parameters with their
    -- value lists, and the PUT request body.
    PROCEDURE emit_openapi;

END dct_xl_pkg;
/

PROMPT === 106.3 view DCT_PROJECT_BUDGET_XL_V ===

-- Period-grain convenience view (SQL / reporting). The Excel API itself queries
-- the base tables so it can aggregate to LINE grain against the period bind.
CREATE OR REPLACE VIEW prod.dct_project_budget_xl_v AS
SELECT prod.dct_xl_pkg.encode_id(b.project_id, b.task_id,
                                 b.accounting_period, b.expenditure_type) AS row_id,
       b.budget_year,
       b.project_id,
       p.project_number,
       p.project_name,
       p.business_unit_name AS business_unit,
       p.project_type,
       b.task_id,
       t.task_number,
       t.task_name,
       b.expenditure_type,
       b.accounting_period,
       b.budget,
       u.budget_change,
       b.budget + NVL(u.budget_change, 0) AS budget_adjusted,
       u.updated_by  AS budget_change_updated_by,
       u.updated_at  AS budget_change_updated_at,
       u.reason_category,
       u.comments
FROM   prod.atd_projects_budget b
JOIN   prod.atd_projects p ON p.project_id = b.project_id
JOIN   prod.atd_tasks    t ON t.task_id    = b.task_id
LEFT   JOIN prod.dct_project_budget_user u
       ON  u.project_id        = b.project_id
       AND u.task_id           = b.task_id
       AND u.expenditure_type  = b.expenditure_type
       AND u.accounting_period = b.accounting_period;

COMMENT ON TABLE prod.dct_project_budget_user IS
'End-user signed budget CHANGE (+/-) entered from Excel (VB add-in via xl.rest ORDS) or the GL Budget Change drawer. Added to the Fusion budget when the GL page/report runs with the Budget Override flag. Keyed on the ATD_PROJECTS_BUDGET extract natural key so it survives the daily full reload.';

PROMPT === 106.4 package body DCT_XL_PKG ===

CREATE OR REPLACE PACKAGE BODY prod.dct_xl_pkg AS

    c_sep CONSTANT VARCHAR2(1) := '|';

    -- -------------------------------------------------------------------
    -- basic_user_id
    -- Silent on success (a spreadsheet upload fires one request per row -
    -- logging each as a LOGIN would flood the audit trail); failures are
    -- logged through dct_auth.authenticate, which records the reason.
    -- Only auth_method = DB users may authenticate here: dct_auth lets
    -- LDAP/SAML/OCI_IAM placeholders pass without a password check, which
    -- would be an open door under Basic.
    -- -------------------------------------------------------------------
    FUNCTION basic_user_id RETURN NUMBER IS
        l_hdr    VARCHAR2(4000);
        l_dec    VARCHAR2(4000);
        l_pos    PLS_INTEGER;
        l_user   VARCHAR2(200);
        l_pass   VARCHAR2(200);
        l_uid    NUMBER;
        l_hash   VARCHAR2(200);
        l_active VARCHAR2(1);
        l_meth   VARCHAR2(20);
        l_ignore BOOLEAN;
    BEGIN
        l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
        IF l_hdr IS NULL THEN
            l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
        END IF;
        IF l_hdr IS NULL OR UPPER(SUBSTR(l_hdr, 1, 6)) <> 'BASIC ' THEN
            RETURN NULL;
        END IF;

        l_dec := UTL_RAW.cast_to_varchar2(
                     UTL_ENCODE.base64_decode(
                         UTL_RAW.cast_to_raw(TRIM(SUBSTR(l_hdr, 7)))));
        l_pos := INSTR(l_dec, ':');
        IF NVL(l_pos, 0) < 2 THEN
            RETURN NULL;
        END IF;
        l_user := SUBSTR(l_dec, 1, l_pos - 1);
        l_pass := SUBSTR(l_dec, l_pos + 1);
        IF l_pass IS NULL THEN
            RETURN NULL;
        END IF;

        BEGIN
            SELECT user_id, password_hash, is_active, auth_method
            INTO   l_uid, l_hash, l_active, l_meth
            FROM   dct_users
            WHERE  UPPER(username) = UPPER(l_user)
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_ignore := dct_auth.authenticate(l_user, l_pass);
                RETURN NULL;
        END;

        IF l_active <> 'Y' OR l_meth <> 'DB' OR l_hash IS NULL THEN
            RETURN NULL;
        END IF;

        IF l_hash = dct_auth.hash_password(l_pass) THEN
            RETURN l_uid;
        END IF;

        l_ignore := dct_auth.authenticate(l_user, l_pass);
        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END basic_user_id;

    PROCEDURE require_user (p_uid OUT NUMBER) IS
    BEGIN
        p_uid := basic_user_id;
        IF p_uid IS NULL THEN
            OWA_UTIL.status_line(401, NULL, FALSE);
            OWA_UTIL.mime_header('application/json', FALSE);
            HTP.p('WWW-Authenticate: Basic realm="i-Finance Excel"');
            OWA_UTIL.http_header_close;
            HTP.p('{"error": "Unauthorized"}');
        END IF;
    END require_user;

    -- -------------------------------------------------------------------
    -- Opaque row id: url-safe base64 of pid|tid|period|etype.
    -- -------------------------------------------------------------------
    FUNCTION encode_id (
        p_project_id IN NUMBER,
        p_task_id    IN NUMBER,
        p_period     IN VARCHAR2,
        p_etype      IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC IS
        l_key VARCHAR2(500);
        l_b64 VARCHAR2(1000);
    BEGIN
        l_key := TO_CHAR(p_project_id) || c_sep || TO_CHAR(p_task_id) || c_sep ||
                 p_period || c_sep || p_etype;
        l_b64 := UTL_RAW.cast_to_varchar2(
                     UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(l_key)));
        l_b64 := REPLACE(REPLACE(l_b64, CHR(13)), CHR(10));
        l_b64 := TRANSLATE(l_b64, '+/', '-_');
        RETURN RTRIM(l_b64, '=');
    END encode_id;

    PROCEDURE decode_id (
        p_id          IN  VARCHAR2,
        o_project_id  OUT NUMBER,
        o_task_id     OUT NUMBER,
        o_period      OUT VARCHAR2,
        o_etype       OUT VARCHAR2
    ) IS
        l_b64 VARCHAR2(1000);
        l_key VARCHAR2(500);
        l_pad PLS_INTEGER;
        l_p1  PLS_INTEGER;
        l_p2  PLS_INTEGER;
        l_p3  PLS_INTEGER;
    BEGIN
        l_b64 := TRANSLATE(p_id, '-_', '+/');
        l_pad := MOD(LENGTH(l_b64), 4);
        IF l_pad = 2 THEN
            l_b64 := l_b64 || '==';
        ELSIF l_pad = 3 THEN
            l_b64 := l_b64 || '=';
        END IF;
        l_key := UTL_RAW.cast_to_varchar2(
                     UTL_ENCODE.base64_decode(UTL_RAW.cast_to_raw(l_b64)));
        l_p1 := INSTR(l_key, c_sep, 1, 1);
        l_p2 := INSTR(l_key, c_sep, 1, 2);
        l_p3 := INSTR(l_key, c_sep, 1, 3);
        o_project_id := TO_NUMBER(SUBSTR(l_key, 1, l_p1 - 1));
        o_task_id    := TO_NUMBER(SUBSTR(l_key, l_p1 + 1, l_p2 - l_p1 - 1));
        o_period     := SUBSTR(l_key, l_p2 + 1, l_p3 - l_p2 - 1);
        o_etype      := SUBSTR(l_key, l_p3 + 1);
    END decode_id;

    -- MM-YYYY -> the last day of that month (NULL when unparseable).
    -- FX = exact format: lenient TO_DATE turns 'JAN-25' into year 0025 (the
    -- platform period-parse gotcha). ON CONVERSION ERROR is SQL-only, hence
    -- the exception block.
    FUNCTION period_end (p_period IN VARCHAR2) RETURN DATE IS
    BEGIN
        RETURN LAST_DAY(TO_DATE(TRIM(p_period), 'FXMM-YYYY'));
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END period_end;

    -- MM-YYYY -> the budget year it belongs to (NULL when unparseable).
    FUNCTION period_year (p_period IN VARCHAR2) RETURN NUMBER IS
    BEGIN
        IF period_end(p_period) IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN TO_NUMBER(SUBSTR(TRIM(p_period), 4, 4));
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END period_year;

    -- -------------------------------------------------------------------
    -- One JSON object per budget LINE. Nullable fields are written with
    -- p_write_null so the Excel add-in always sees every column.
    -- -------------------------------------------------------------------
    PROCEDURE write_row (
        p_row_id   VARCHAR2, p_year     NUMBER,   p_bu      VARCHAR2,
        p_ptype    VARCHAR2, p_pnum     VARCHAR2, p_pname   VARCHAR2,
        p_tnum     VARCHAR2, p_tname    VARCHAR2, p_etype   VARCHAR2,
        p_period   VARCHAR2, p_annual   NUMBER,   p_ytd     NUMBER,
        p_change   NUMBER,   p_line_chg NUMBER,   p_adj_ann NUMBER,
        p_adj_ytd  NUMBER,   p_reason   VARCHAR2, p_comments VARCHAR2,
        p_uby      VARCHAR2, p_uat      TIMESTAMP
    ) IS
    BEGIN
        APEX_JSON.open_object;
        APEX_JSON.write('id',                p_row_id);
        APEX_JSON.write('budget_year',       p_year,   p_write_null => TRUE);
        APEX_JSON.write('business_unit',     p_bu,     p_write_null => TRUE);
        APEX_JSON.write('project_type',      p_ptype,  p_write_null => TRUE);
        APEX_JSON.write('project_number',    p_pnum,   p_write_null => TRUE);
        APEX_JSON.write('project_name',      p_pname,  p_write_null => TRUE);
        APEX_JSON.write('task_number',       p_tnum,   p_write_null => TRUE);
        APEX_JSON.write('task_name',         p_tname,  p_write_null => TRUE);
        APEX_JSON.write('expenditure_type',  p_etype,  p_write_null => TRUE);
        APEX_JSON.write('accounting_period', p_period, p_write_null => TRUE);
        APEX_JSON.write('budget_annual',     p_annual, p_write_null => TRUE);
        APEX_JSON.write('budget_ytd',        p_ytd,    p_write_null => TRUE);
        APEX_JSON.write('budget_change',     p_change, p_write_null => TRUE);
        APEX_JSON.write('line_change_total', p_line_chg, p_write_null => TRUE);
        APEX_JSON.write('adjusted_annual',   p_adj_ann,  p_write_null => TRUE);
        APEX_JSON.write('adjusted_ytd',      p_adj_ytd,  p_write_null => TRUE);
        APEX_JSON.write('reason_category',   p_reason,   p_write_null => TRUE);
        APEX_JSON.write('comments',          p_comments, p_write_null => TRUE);
        APEX_JSON.write('budget_change_updated_by', p_uby, p_write_null => TRUE);
        APEX_JSON.write('budget_change_updated_at',
            CASE WHEN p_uat IS NULL THEN NULL
                 ELSE TO_CHAR(dct_to_local(p_uat), 'YYYY-MM-DD HH:MI AM')
            END,
            p_write_null => TRUE);
        APEX_JSON.close_object;
    END write_row;

    -- -------------------------------------------------------------------
    -- The Excel add-in's Search form does NOT send named query parameters:
    -- for an ORDS-hosted service it transmits the ORDS FilterObject syntax,
    -- e.g. q={"budget_year":{"$eq":2026},"accounting_period":{"$eq":"01-2026"}}
    -- (optionally wrapped in "$and":[...]). The q name is ORDS-reserved and
    -- cannot be bound in handler source, so it is read from the raw
    -- QUERY_STRING CGI variable instead. Every download filter is honoured.
    -- -------------------------------------------------------------------
    FUNCTION jget (
        p_vals IN APEX_JSON.t_values,
        p_path IN VARCHAR2,
        p_i    IN PLS_INTEGER DEFAULT NULL
    ) RETURN VARCHAR2 IS
        l_n NUMBER;
        l_s VARCHAR2(200);
    BEGIN
        BEGIN
            IF p_i IS NULL THEN
                l_n := APEX_JSON.get_number(p_values => p_vals, p_path => p_path);
            ELSE
                l_n := APEX_JSON.get_number(p_values => p_vals, p_path => p_path, p0 => p_i);
            END IF;
        EXCEPTION WHEN OTHERS THEN l_n := NULL; END;
        IF l_n IS NOT NULL THEN
            RETURN TO_CHAR(l_n);
        END IF;
        BEGIN
            IF p_i IS NULL THEN
                l_s := APEX_JSON.get_varchar2(p_values => p_vals, p_path => p_path);
            ELSE
                l_s := APEX_JSON.get_varchar2(p_values => p_vals, p_path => p_path, p0 => p_i);
            END IF;
        EXCEPTION WHEN OTHERS THEN l_s := NULL; END;
        RETURN l_s;
    END jget;

    FUNCTION q_filter_val (p_name IN VARCHAR2) RETURN VARCHAR2 IS
        l_qs   VARCHAR2(32767);
        l_raw  VARCHAR2(4000);
        l_json VARCHAR2(4000);
        l_pos  PLS_INTEGER;
        l_amp  PLS_INTEGER;
        l_vals APEX_JSON.t_values;
        l_v    VARCHAR2(200);
        l_cnt  PLS_INTEGER;
    BEGIN
        l_qs := OWA_UTIL.get_cgi_env('QUERY_STRING');
        IF l_qs IS NULL THEN
            RETURN NULL;
        END IF;
        l_pos := INSTR('&' || l_qs, '&q=');
        IF l_pos = 0 THEN
            RETURN NULL;
        END IF;
        l_raw := SUBSTR('&' || l_qs, l_pos + 3);
        l_amp := INSTR(l_raw, '&');
        IF l_amp > 0 THEN
            l_raw := SUBSTR(l_raw, 1, l_amp - 1);
        END IF;
        l_json := UTL_URL.unescape(REPLACE(l_raw, '+', ' '));
        -- APEX_JSON paths cannot address member names starting with a dollar
        -- sign, so neutralise the FilterObject operator prefix before parsing
        -- ("$eq" -> "opeq", "$and" -> "opand").
        l_json := REPLACE(l_json, '"$', '"op');
        APEX_JSON.parse(l_vals, l_json);
        l_v := jget(l_vals, p_name);
        IF l_v IS NULL THEN
            l_v := jget(l_vals, p_name || '.opeq');
        END IF;
        IF l_v IS NULL THEN
            BEGIN
                l_cnt := APEX_JSON.get_count(p_values => l_vals, p_path => 'opand');
            EXCEPTION WHEN OTHERS THEN l_cnt := NULL; END;
            FOR i IN 1 .. NVL(l_cnt, 0) LOOP
                l_v := NVL(l_v, jget(l_vals, 'opand[%d].' || p_name, i));
                l_v := NVL(l_v, jget(l_vals, 'opand[%d].' || p_name || '.opeq', i));
                EXIT WHEN l_v IS NOT NULL;
            END LOOP;
        END IF;
        RETURN l_v;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END q_filter_val;

    -- -------------------------------------------------------------------
    -- emit_core - the ONE line-grain query behind both GET routes.
    -- p_pid/p_tid/p_etype set  => single-row mode (no envelope, 404 when the
    -- line does not exist); otherwise the list envelope is written.
    -- Change rows are aggregated INDEPENDENTLY of the Fusion period rows, so a
    -- change booked at a period the un-phased budget never spread to is still
    -- reported (see the header note).
    -- -------------------------------------------------------------------
    PROCEDURE emit_core (
        p_year     IN NUMBER,
        p_period   IN VARCHAR2,
        p_bu       IN VARCHAR2,
        p_ptype    IN VARCHAR2,
        p_search   IN VARCHAR2,
        p_pid      IN NUMBER,
        p_tid      IN NUMBER,
        p_etype    IN VARCHAR2,
        p_limit    IN NUMBER,
        p_offset   IN NUMBER,
        p_envelope IN BOOLEAN
    ) IS
        l_end   DATE := period_end(p_period);
        l_like  VARCHAR2(200) := '%' || UPPER(p_search) || '%';
        l_fetch NUMBER := NVL(p_limit, 1) + 1;
        l_count PLS_INTEGER := 0;
        l_more  BOOLEAN := FALSE;
    BEGIN
        IF p_envelope THEN
            dct_rest.json_header;
            APEX_JSON.initialize_output;
            APEX_JSON.open_object;
            APEX_JSON.open_array('items');
        END IF;

        FOR r IN (
            WITH pj AS (
                SELECT project_id,
                       MAX(project_number)     AS project_number,
                       MAX(project_name)       AS project_name,
                       MAX(business_unit_name) AS business_unit,
                       MAX(project_type)       AS project_type
                FROM   atd_projects
                GROUP  BY project_id
            ),
            tk AS (
                SELECT task_id,
                       MAX(task_number) AS task_number,
                       MAX(task_name)   AS task_name
                FROM   atd_tasks
                GROUP  BY task_id
            ),
            bl AS (
                SELECT b.project_id, b.task_id, b.expenditure_type,
                       SUM(b.budget) AS budget_annual,
                       SUM(CASE WHEN NVL(TO_DATE(b.accounting_period DEFAULT NULL ON CONVERSION ERROR,
                                                 'MM-YYYY'), DATE '1900-01-01') <= l_end
                                THEN b.budget END) AS budget_ytd
                FROM   atd_projects_budget b
                WHERE  b.budget_year = p_year
                GROUP  BY b.project_id, b.task_id, b.expenditure_type
            ),
            ch AS (
                SELECT u.project_id, u.task_id, u.expenditure_type,
                       SUM(u.budget_change) AS line_change_total,
                       SUM(CASE WHEN NVL(TO_DATE(u.accounting_period DEFAULT NULL ON CONVERSION ERROR,
                                                 'MM-YYYY'), DATE '1900-01-01') <= l_end
                                THEN u.budget_change END) AS change_ytd,
                       SUM(CASE WHEN u.accounting_period = p_period
                                THEN u.budget_change END) AS budget_change,
                       MAX(CASE WHEN u.accounting_period = p_period
                                THEN u.reason_category END) AS reason_category,
                       MAX(CASE WHEN u.accounting_period = p_period
                                THEN u.comments END) AS comments,
                       MAX(CASE WHEN u.accounting_period = p_period
                                THEN u.updated_by END) AS updated_by,
                       MAX(CASE WHEN u.accounting_period = p_period
                                THEN u.updated_at END) AS updated_at
                FROM   dct_project_budget_user u
                WHERE  TO_NUMBER(SUBSTR(u.accounting_period, 4, 4)
                                 DEFAULT NULL ON CONVERSION ERROR) = p_year
                GROUP  BY u.project_id, u.task_id, u.expenditure_type
            )
            SELECT dct_xl_pkg.encode_id(bl.project_id, bl.task_id, p_period,
                                        bl.expenditure_type) AS row_id,
                   TO_CHAR(pj.project_number)  AS project_number,
                   pj.project_name,
                   pj.business_unit,
                   pj.project_type,
                   tk.task_number,
                   tk.task_name,
                   bl.expenditure_type,
                   NVL(bl.budget_annual, 0)                         AS budget_annual,
                   NVL(bl.budget_ytd, 0)                            AS budget_ytd,
                   ch.budget_change,
                   ch.line_change_total,
                   NVL(bl.budget_annual,0) + NVL(ch.line_change_total,0) AS adjusted_annual,
                   NVL(bl.budget_ytd,0)    + NVL(ch.change_ytd,0)        AS adjusted_ytd,
                   ch.reason_category,
                   ch.comments,
                   ch.updated_by,
                   ch.updated_at
            FROM   bl
            JOIN   pj ON pj.project_id = bl.project_id
            JOIN   tk ON tk.task_id    = bl.task_id
            LEFT   JOIN ch ON  ch.project_id       = bl.project_id
                          AND  ch.task_id          = bl.task_id
                          AND  ch.expenditure_type = bl.expenditure_type
            WHERE  (p_pid   IS NULL OR (bl.project_id = p_pid
                                        AND bl.task_id = p_tid
                                        AND bl.expenditure_type = p_etype))
              AND  (p_bu    IS NULL OR pj.business_unit = p_bu)
              AND  (p_ptype IS NULL OR pj.project_type  = p_ptype)
              AND  (p_search IS NULL
                    OR UPPER(pj.project_number)   LIKE l_like
                    OR UPPER(pj.project_name)     LIKE l_like
                    OR UPPER(tk.task_number)      LIKE l_like
                    OR UPPER(tk.task_name)        LIKE l_like
                    OR UPPER(bl.expenditure_type) LIKE l_like)
            ORDER  BY pj.project_number, tk.task_number, bl.expenditure_type
            OFFSET NVL(p_offset, 0) ROWS FETCH NEXT l_fetch ROWS ONLY
        ) LOOP
            l_count := l_count + 1;
            IF p_envelope AND l_count > p_limit THEN
                l_more := TRUE;
            ELSE
                IF NOT p_envelope THEN
                    dct_rest.json_header;
                    APEX_JSON.initialize_output;
                END IF;
                write_row(r.row_id, p_year, r.business_unit, r.project_type,
                          r.project_number, r.project_name, r.task_number,
                          r.task_name, r.expenditure_type, p_period,
                          r.budget_annual, r.budget_ytd, r.budget_change,
                          r.line_change_total, r.adjusted_annual, r.adjusted_ytd,
                          r.reason_category, r.comments, r.updated_by, r.updated_at);
            END IF;
            EXIT WHEN NOT p_envelope;
        END LOOP;

        IF p_envelope THEN
            APEX_JSON.close_array;
            APEX_JSON.write('hasMore', l_more);
            APEX_JSON.write('limit',   p_limit);
            APEX_JSON.write('offset',  NVL(p_offset, 0));
            APEX_JSON.write('count',   LEAST(l_count, p_limit));
            APEX_JSON.write('budget_year',       p_year);
            APEX_JSON.write('accounting_period', p_period);
            APEX_JSON.write('business_unit',     p_bu,    p_write_null => TRUE);
            APEX_JSON.write('project_type',      p_ptype, p_write_null => TRUE);
            APEX_JSON.close_object;
        ELSIF l_count = 0 THEN
            dct_rest.err(404, 'Budget line not found');
        END IF;
    END emit_core;

    PROCEDURE emit_list (
        p_uid    IN NUMBER,
        p_limit  IN VARCHAR2,
        p_offset IN VARCHAR2,
        p_year   IN VARCHAR2,
        p_period IN VARCHAR2,
        p_bu     IN VARCHAR2 DEFAULT NULL,
        p_ptype  IN VARCHAR2 DEFAULT NULL,
        p_search IN VARCHAR2 DEFAULT NULL
    ) IS
        l_limit  NUMBER;
        l_offset NUMBER;
        l_year   NUMBER;
        l_period VARCHAR2(20);
        l_bu     VARCHAR2(200);
        l_ptype  VARCHAR2(200);
    BEGIN
        BEGIN l_limit := TO_NUMBER(p_limit); EXCEPTION WHEN OTHERS THEN l_limit := NULL; END;
        BEGIN l_offset := TO_NUMBER(p_offset); EXCEPTION WHEN OTHERS THEN l_offset := NULL; END;
        BEGIN l_year := TO_NUMBER(p_year); EXCEPTION WHEN OTHERS THEN l_year := NULL; END;
        l_period := TRIM(p_period);
        l_bu     := TRIM(p_bu);
        l_ptype  := TRIM(p_ptype);

        -- Search-form (FilterObject) fallbacks for every download filter
        IF l_year IS NULL THEN
            BEGIN
                l_year := TO_NUMBER(q_filter_val('budget_year'));
            EXCEPTION WHEN OTHERS THEN l_year := NULL; END;
        END IF;
        IF l_period IS NULL THEN
            l_period := TRIM(q_filter_val('accounting_period'));
        END IF;
        IF l_bu IS NULL THEN
            l_bu := TRIM(q_filter_val('business_unit'));
        END IF;
        IF l_ptype IS NULL THEN
            l_ptype := TRIM(q_filter_val('project_type'));
        END IF;

        IF l_year IS NULL OR l_period IS NULL THEN
            dct_rest.err(400, 'budget_year and accounting_period are required (period format MM-YYYY, e.g. 08-2026)');
            RETURN;
        END IF;
        IF period_end(l_period) IS NULL THEN
            dct_rest.err(400, 'accounting_period must be MM-YYYY, e.g. 08-2026');
            RETURN;
        END IF;
        IF period_year(l_period) <> l_year THEN
            dct_rest.err(400, 'accounting_period must belong to budget_year ' || l_year);
            RETURN;
        END IF;

        -- Exact default scope (user rule): the stored names, matched with =.
        l_bu    := NVL(l_bu,    c_default_bu);
        l_ptype := NVL(l_ptype, c_default_ptype);

        -- The scoped register is well under 10k lines; a paramless GET (which
        -- is what the Excel add-in issues) must return everything in one page.
        l_limit  := LEAST(NVL(l_limit, 10000), 10000);
        l_offset := GREATEST(NVL(l_offset, 0), 0);

        emit_core(l_year, l_period, l_bu, l_ptype, p_search,
                  NULL, NULL, NULL, l_limit, l_offset, TRUE);
    END emit_list;

    PROCEDURE emit_item (p_uid IN NUMBER, p_id IN VARCHAR2) IS
        l_pid    NUMBER;
        l_tid    NUMBER;
        l_period VARCHAR2(20);
        l_etype  VARCHAR2(150);
        l_year   NUMBER;
    BEGIN
        BEGIN
            decode_id(p_id, l_pid, l_tid, l_period, l_etype);
        EXCEPTION WHEN OTHERS THEN
            dct_rest.err(400, 'Invalid row id');
            RETURN;
        END;
        l_year := period_year(l_period);
        IF l_year IS NULL THEN
            dct_rest.err(400, 'Invalid row id');
            RETURN;
        END IF;
        emit_core(l_year, l_period, NULL, NULL, NULL,
                  l_pid, l_tid, l_etype, 1, 0, FALSE);
    END emit_item;

    PROCEDURE save_item (p_uid IN NUMBER, p_id IN VARCHAR2, p_body IN BLOB) IS
        l_pid    NUMBER;
        l_tid    NUMBER;
        l_period VARCHAR2(20);
        l_etype  VARCHAR2(150);
        l_year   NUMBER;
        l_cnt    NUMBER;
        l_val    NUMBER;
        l_raw    VARCHAR2(200);
        l_uname  VARCHAR2(100);
        l_reason VARCHAR2(100);
        l_comm   VARCHAR2(1000);
        l_has_r  VARCHAR2(1) := 'N';
        l_has_c  VARCHAR2(1) := 'N';
    BEGIN
        BEGIN
            decode_id(p_id, l_pid, l_tid, l_period, l_etype);
        EXCEPTION WHEN OTHERS THEN
            dct_rest.err(400, 'Invalid row id');
            RETURN;
        END;
        l_year := period_year(l_period);
        IF l_year IS NULL THEN
            dct_rest.err(400, 'Invalid row id');
            RETURN;
        END IF;

        -- The LINE must exist in the budget year - NOT a budget row at this
        -- exact period: the Fusion budget is un-phased, so a change booked at
        -- 08-2026 normally has no period row of its own (header note).
        SELECT COUNT(*) INTO l_cnt
        FROM   atd_projects_budget
        WHERE  project_id = l_pid AND task_id = l_tid
          AND  expenditure_type = l_etype AND budget_year = l_year;
        IF l_cnt = 0 THEN
            dct_rest.err(404, 'Budget line not found');
            RETURN;
        END IF;

        dct_rest.parse_body(p_body);
        IF NOT APEX_JSON.does_exist('budget_change') THEN
            IF APEX_JSON.does_exist('budget_user') THEN
                dct_rest.err(400, 'budget_user is no longer accepted - the override is now a signed budget_change (+/-). Download the current Budget Change workbook from the GL Budget Utilization page.');
            ELSE
                dct_rest.err(400, 'budget_change is required');
            END IF;
            RETURN;
        END IF;
        BEGIN
            l_val := APEX_JSON.get_number('budget_change');
        EXCEPTION WHEN OTHERS THEN
            BEGIN
                l_raw := TRIM(APEX_JSON.get_varchar2('budget_change'));
                l_val := CASE WHEN l_raw IS NULL THEN NULL ELSE TO_NUMBER(l_raw) END;
            EXCEPTION WHEN OTHERS THEN
                dct_rest.err(400, 'budget_change must be a number (positive to add, negative to subtract)');
                RETURN;
            END;
        END;

        -- optional classification fields (2026-07-28) - partial semantics:
        -- only keys present in the body are applied
        IF APEX_JSON.does_exist('reason_category') THEN
            l_has_r  := 'Y';
            l_reason := SUBSTR(TRIM(APEX_JSON.get_varchar2('reason_category')), 1, 100);
            IF l_reason IS NOT NULL
               AND dct_lookup_pkg.is_valid('XL_OVERRIDE_REASON', l_reason) = 'N' THEN
                dct_rest.err(400, 'reason_category is not a valid active XL_OVERRIDE_REASON lookup value');
                RETURN;
            END IF;
        END IF;
        IF APEX_JSON.does_exist('comments') THEN
            l_has_c := 'Y';
            l_comm  := SUBSTR(APEX_JSON.get_varchar2('comments'), 1, 1000);
        END IF;

        -- blank or zero clears the change (a zero change is not a change)
        IF l_val IS NULL OR l_val = 0 THEN
            DELETE FROM dct_project_budget_user
            WHERE  project_id = l_pid AND task_id = l_tid
              AND  expenditure_type = l_etype AND accounting_period = l_period;
        ELSE
            SELECT MAX(username) INTO l_uname FROM dct_users WHERE user_id = p_uid;
            UPDATE dct_project_budget_user
            SET    budget_change = l_val,
                   reason_category = CASE WHEN l_has_r = 'Y' THEN l_reason ELSE reason_category END,
                   comments     = CASE WHEN l_has_c = 'Y' THEN l_comm ELSE comments END,
                   updated_by_id = p_uid,
                   updated_by   = l_uname,
                   updated_at   = SYSTIMESTAMP
            WHERE  project_id = l_pid AND task_id = l_tid
              AND  expenditure_type = l_etype AND accounting_period = l_period;
            IF SQL%ROWCOUNT = 0 THEN
                INSERT INTO dct_project_budget_user
                       (project_id, task_id, expenditure_type, accounting_period,
                        budget_change, reason_category, comments,
                        updated_by_id, updated_by, updated_at)
                VALUES (l_pid, l_tid, l_etype, l_period,
                        l_val, l_reason, l_comm, p_uid, l_uname, SYSTIMESTAMP);
            END IF;
        END IF;
        COMMIT;

        emit_item(p_uid, p_id);
    END save_item;

    -- -------------------------------------------------------------------
    -- emit_lov - pick lists for the download parameters. Same {value,label}
    -- shape for every kind so one Excel LOV binding pattern fits all; id is
    -- emitted as the add-in's identity field.
    -- -------------------------------------------------------------------
    PROCEDURE emit_lov (p_kind IN VARCHAR2, p_year IN VARCHAR2 DEFAULT NULL) IS
        l_kind VARCHAR2(40) := LOWER(TRIM(p_kind));
        l_year NUMBER;
        l_n    PLS_INTEGER := 0;

        PROCEDURE item (p_value VARCHAR2, p_label VARCHAR2) IS
        BEGIN
            APEX_JSON.open_object;
            APEX_JSON.write('id',    p_value);
            APEX_JSON.write('value', p_value);
            APEX_JSON.write('label', p_label, p_write_null => TRUE);
            APEX_JSON.close_object;
            l_n := l_n + 1;
        END;
    BEGIN
        BEGIN l_year := TO_NUMBER(p_year); EXCEPTION WHEN OTHERS THEN l_year := NULL; END;
        IF l_kind NOT IN ('business-units', 'project-types', 'periods',
                          'budget-years', 'reasons') THEN
            dct_rest.err(400, 'kind must be business-units, project-types, periods, budget-years or reasons');
            RETURN;
        END IF;

        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.open_array('items');

        IF l_kind = 'business-units' THEN
            FOR r IN (SELECT DISTINCT business_unit_name AS v
                      FROM   atd_projects
                      WHERE  business_unit_name IS NOT NULL
                      ORDER  BY 1) LOOP
                item(r.v, r.v);
            END LOOP;
        ELSIF l_kind = 'project-types' THEN
            FOR r IN (SELECT DISTINCT project_type AS v
                      FROM   atd_projects
                      WHERE  project_type IS NOT NULL
                      ORDER  BY 1) LOOP
                item(r.v, r.v);
            END LOOP;
        ELSIF l_kind = 'periods' THEN
            FOR r IN (SELECT accounting_period AS v
                      FROM   atd_projects_budget
                      WHERE  (l_year IS NULL OR budget_year = l_year)
                        AND  accounting_period IS NOT NULL
                      GROUP  BY accounting_period
                      ORDER  BY NVL(TO_DATE(accounting_period DEFAULT NULL ON CONVERSION ERROR,
                                            'MM-YYYY'), DATE '1900-01-01')) LOOP
                item(r.v, r.v);
            END LOOP;
        ELSIF l_kind = 'budget-years' THEN
            FOR r IN (SELECT DISTINCT budget_year AS v
                      FROM   atd_projects_budget
                      WHERE  budget_year IS NOT NULL
                      ORDER  BY 1 DESC) LOOP
                item(TO_CHAR(r.v), TO_CHAR(r.v));
            END LOOP;
        ELSE
            FOR r IN (SELECT lv.value_code, lv.value_name_en
                      FROM   dct_lookup_values lv
                      JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
                      WHERE  lc.category_code = 'XL_OVERRIDE_REASON'
                        AND  lv.is_active = 'Y'
                      ORDER  BY lv.display_order) LOOP
                item(r.value_code, r.value_name_en);
            END LOOP;
        END IF;

        APEX_JSON.close_array;
        APEX_JSON.write('count', l_n);
        APEX_JSON.close_object;
    END emit_lov;

    -- -------------------------------------------------------------------
    -- emit_openapi
    -- Metadata only (no data, no secrets) - served without authentication,
    -- like the built-in ORDS open-api-catalog. Assembled inside the package
    -- so the ORDS handler source never carries colon-letter sequences.
    -- The download parameters carry live enum lists so the add-in's Search
    -- form renders drop-downs; the lov/ collections give the Layout Designer
    -- a proper LOV source for the same values.
    -- -------------------------------------------------------------------
    PROCEDURE emit_openapi IS
        l_doc   VARCHAR2(32767);
        l_pos   PLS_INTEGER := 1;
        l_enum  VARCHAR2(2000);
        l_bu    VARCHAR2(2000);
        l_ptype VARCHAR2(2000);
        l_per   VARCHAR2(2000);
        l_yr    VARCHAR2(500);
        l_maxy  NUMBER;
        c_base  CONSTANT VARCHAR2(200) :=
            'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl';

        PROCEDURE app (p_buf IN OUT VARCHAR2, p_val VARCHAR2, p_quote BOOLEAN DEFAULT TRUE) IS
        BEGIN
            p_buf := p_buf || CASE WHEN p_buf IS NOT NULL THEN ', ' END
                     || CASE WHEN p_quote THEN '"' || REPLACE(p_val, '"', '') || '"'
                             ELSE p_val END;
        END;
    BEGIN
        -- reason enum from the lookup so the add-in offers the valid choices
        FOR r IN (SELECT lv.value_code
                  FROM   dct_lookup_values lv
                  JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
                  WHERE  lc.category_code = 'XL_OVERRIDE_REASON'
                    AND  lv.is_active = 'Y'
                  ORDER  BY lv.display_order) LOOP
            app(l_enum, r.value_code);
        END LOOP;
        FOR r IN (SELECT DISTINCT business_unit_name v FROM atd_projects
                  WHERE business_unit_name IS NOT NULL ORDER BY 1) LOOP
            app(l_bu, r.v);
        END LOOP;
        FOR r IN (SELECT DISTINCT project_type v FROM atd_projects
                  WHERE project_type IS NOT NULL ORDER BY 1) LOOP
            app(l_ptype, r.v);
        END LOOP;
        SELECT MAX(budget_year) INTO l_maxy FROM atd_projects_budget;
        FOR r IN (SELECT accounting_period v FROM atd_projects_budget
                  WHERE budget_year = l_maxy AND accounting_period IS NOT NULL
                  GROUP BY accounting_period
                  ORDER BY NVL(TO_DATE(accounting_period DEFAULT NULL ON CONVERSION ERROR,
                                       'MM-YYYY'), DATE '1900-01-01')) LOOP
            app(l_per, r.v);
        END LOOP;
        FOR r IN (SELECT DISTINCT budget_year v FROM atd_projects_budget
                  WHERE budget_year IS NOT NULL ORDER BY 1 DESC) LOOP
            app(l_yr, TO_CHAR(r.v), FALSE);
        END LOOP;

        l_doc := q'!{
"openapi": "3.0.0",
"info": {
  "title": "i-Finance Excel Budget Change API",
  "version": "2.0.0",
  "description": "Project budget lines with the end-user BUDGET CHANGE. One row per project + task + expenditure type of the budget year, carrying the annual and YTD budget. budget_change is a SIGNED amount added to the budget at the selected accounting period (negative subtracts); zero or blank clears it. Rows cannot be created or deleted."
},
"servers": [ { "url": "!' || c_base || q'!" } ],
"security": [ { "basicAuth": [] } ],
"paths": {
  "/budget/": {
    "get": {
      "operationId": "listBudget",
      "summary": "Budget lines for a year, period and scope",
      "parameters": [
        { "name": "budget_year", "in": "query", "required": true,
          "schema": { "type": "integer", "enum": [ !' || l_yr || q'! ] },
          "description": "Budget Year (mandatory)" },
        { "name": "accounting_period", "in": "query", "required": true,
          "schema": { "type": "string", "enum": [ !' || l_per || q'! ] },
          "description": "Accounting Period MM-YYYY (mandatory). YTD budget covers periods up to and including it, and a change is booked to it." },
        { "name": "business_unit", "in": "query", "required": false,
          "schema": { "type": "string", "enum": [ !' || l_bu || q'! ] },
          "description": "Business Unit (exact name). Defaults to Department of Culture and Tourism." },
        { "name": "project_type", "in": "query", "required": false,
          "schema": { "type": "string", "enum": [ !' || l_ptype || q'! ] },
          "description": "Project Type (exact name). Defaults to DCT OPEX Project Type." },
        { "name": "search", "in": "query", "required": false, "schema": { "type": "string" },
          "description": "Optional filter on project number/name, task number/name or expenditure type" },
        { "name": "limit",  "in": "query", "required": false, "schema": { "type": "integer" } },
        { "name": "offset", "in": "query", "required": false, "schema": { "type": "integer" } }
      ],
      "responses": {
        "200": {
          "description": "Budget lines",
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "items":   { "type": "array", "items": { "$ref": "#/components/schemas/BudgetRow" } },
                  "hasMore": { "type": "boolean" },
                  "limit":   { "type": "integer" },
                  "offset":  { "type": "integer" },
                  "count":   { "type": "integer" }
                }
              }
            }
          }
        }
      }
    }
  },
  "/budget/{id}": {
    "get": {
      "operationId": "getBudgetRow",
      "summary": "One budget line",
      "parameters": [
        { "name": "id", "in": "path", "required": true, "schema": { "type": "string" } }
      ],
      "responses": {
        "200": {
          "description": "Budget line",
          "content": { "application/json": { "schema": { "$ref": "#/components/schemas/BudgetRow" } } }
        }
      }
    },
    "put": {
      "operationId": "updateBudgetRow",
      "summary": "Set or clear the signed budget change (only budget_change, reason_category and comments are writable)",
      "parameters": [
        { "name": "id", "in": "path", "required": true, "schema": { "type": "string" } }
      ],
      "requestBody": {
        "required": true,
        "content": {
          "application/json": {
            "schema": {
              "type": "object",
              "properties": {
                "budget_change":   { "type": "number", "nullable": true },
                "reason_category": { "type": "string", "nullable": true },
                "comments":        { "type": "string", "nullable": true, "maxLength": 1000 }
              }
            }
          }
        }
      },
      "responses": {
        "200": {
          "description": "Updated budget line",
          "content": { "application/json": { "schema": { "$ref": "#/components/schemas/BudgetRow" } } }
        }
      }
    }
  },
  "/lov/{kind}": {
    "get": {
      "operationId": "listValues",
      "summary": "Pick list for a download parameter",
      "parameters": [
        { "name": "kind", "in": "path", "required": true,
          "schema": { "type": "string", "enum": [ "business-units", "project-types", "periods", "budget-years", "reasons" ] } },
        { "name": "budget_year", "in": "query", "required": false, "schema": { "type": "integer" },
          "description": "Scopes the periods list to one budget year" }
      ],
      "responses": {
        "200": {
          "description": "Values",
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "items": { "type": "array", "items": { "$ref": "#/components/schemas/LovItem" } },
                  "count": { "type": "integer" }
                }
              }
            }
          }
        }
      }
    }
  }
},
"components": {
  "securitySchemes": {
    "basicAuth": { "type": "http", "scheme": "basic" }
  },
  "schemas": {
    "LovItem": {
      "type": "object",
      "required": [ "id" ],
      "properties": {
        "id":    { "type": "string", "readOnly": true, "title": "Value" },
        "value": { "type": "string", "readOnly": true, "title": "Value" },
        "label": { "type": "string", "readOnly": true, "title": "Label" }
      }
    },
    "BudgetRow": {
      "type": "object",
      "required": [ "id" ],
      "properties": {
        "id":                     { "type": "string",  "readOnly": true,  "title": "Row Id" },
!' || '        "budget_year":            { "type": "integer", "readOnly": true,  "title": "Budget Year", "enum": [ ' || l_yr || ' ] },' || q'!
!' || '        "business_unit":          { "type": "string",  "readOnly": true,  "title": "Business Unit", "enum": [ ' || l_bu || ' ] },' || q'!
!' || '        "project_type":           { "type": "string",  "readOnly": true,  "title": "Project Type", "enum": [ ' || l_ptype || ' ] },' || q'!
        "project_number":         { "type": "string",  "readOnly": true,  "title": "Project Number" },
        "project_name":           { "type": "string",  "readOnly": true,  "title": "Project Name" },
        "task_number":            { "type": "string",  "readOnly": true,  "title": "Task Number" },
        "task_name":              { "type": "string",  "readOnly": true,  "title": "Task Name" },
        "expenditure_type":       { "type": "string",  "readOnly": true,  "title": "Expenditure Type" },
!' || '        "accounting_period":      { "type": "string",  "readOnly": true,  "title": "Accounting Period", "enum": [ ' || l_per || ' ] },' || q'!
        "budget_annual":          { "type": "number",  "readOnly": true,  "title": "Annual Budget (Fusion)" },
        "budget_ytd":             { "type": "number",  "readOnly": true,  "title": "YTD Budget (Fusion)" },
        "budget_change":          { "type": "number",  "nullable": true,  "title": "Budget Change (+/-)" },
!' || '        "reason_category":        { "type": "string",  "nullable": true,  "title": "Reason Category", "enum": [ '
   || l_enum || ' ] },' || q'!
        "comments":               { "type": "string",  "nullable": true, "maxLength": 1000, "title": "Comments" },
        "line_change_total":      { "type": "number",  "readOnly": true,  "title": "Total Change on Line" },
        "adjusted_annual":        { "type": "number",  "readOnly": true,  "title": "Adjusted Annual Budget" },
        "adjusted_ytd":           { "type": "number",  "readOnly": true,  "title": "Adjusted YTD Budget" },
        "budget_change_updated_by": { "type": "string", "readOnly": true, "title": "Change Updated By" },
        "budget_change_updated_at": { "type": "string", "readOnly": true, "title": "Change Updated At" }
      }
    }
  }
}
}!';
        OWA_UTIL.mime_header('application/json', TRUE);
        WHILE l_pos <= LENGTH(l_doc) LOOP
            HTP.prn(SUBSTR(l_doc, l_pos, 4000));
            l_pos := l_pos + 4000;
        END LOOP;
    END emit_openapi;

END dct_xl_pkg;
/

PROMPT === 106.5 compile check ===
SELECT object_name, object_type, status
FROM   all_objects
WHERE  owner = 'PROD'
  AND  object_name IN ('DCT_XL_PKG', 'DCT_PROJECT_BUDGET_XL_V', 'DCT_PROJECT_BUDGET_USER')
ORDER  BY object_name, object_type;
