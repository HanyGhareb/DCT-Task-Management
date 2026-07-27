-- =============================================================================
-- i-Finance V2 - Excel integration layer (part 2 of 2): xl.rest ORDS module
-- File    : 107_xl_budget_ords.sql
-- Schema  : ADMIN (module + synonyms) over PROD objects from 106_xl_budget.sql
-- Date    : 2026-07-27
-- =============================================================================
-- MUST run in a FRESH SQLcl session (never after ALTER SESSION SET
-- CURRENT_SCHEMA = PROD - the synonyms would self-reference, ORA-01471).
--
-- Module  : xl.rest at /ords/admin/xl/ - the Excel-facing API consumed by the
--           Oracle Visual Builder Add-in for Excel (Basic auth; DCT_XL_PKG
--           validates the credentials against DCT_USERS itself, so the module
--           carries NO ORDS privilege and the handlers never call
--           dct_rest.validate_session - the db/v2/50 module gate therefore
--           does not apply to the xl segment by design).
--
-- Routes  : GET budget/        all budget rows + user override (one page)
--           GET budget/[COLON]id     one row
--           PUT budget/[COLON]id     set/clear budget_user (the ONLY writable field)
--           There is intentionally NO POST and NO DELETE handler - the Excel
--           add-in cannot create or delete budget rows.
--
-- OpenAPI : the add-in reads the service description from GET openapi
--           (public, metadata only). The built-in ORDS open-api-catalog is
--           USELESS for the add-in here - a custom module's auto-generated
--           document has no field schemas, so the add-in finds the business
--           object but lists no fields and hides it ("nothing to select").
--           DCT_XL_PKG.emit_openapi serves the full hand-authored document
--           (BudgetRow schema, readOnly flags, PUT body).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 107.1 ADMIN synonyms ===

CREATE OR REPLACE SYNONYM dct_xl_pkg FOR prod.dct_xl_pkg;
CREATE OR REPLACE SYNONYM dct_xl_tpl FOR prod.dct_xl_tpl;
CREATE OR REPLACE SYNONYM dct_project_budget_xl_v FOR prod.dct_project_budget_xl_v;

PROMPT === 107.2 module xl.rest ===

DECLARE
    c_mod CONSTANT VARCHAR2(30) := 'xl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58))
        );
    END;

    PROCEDURE def_handler(
        p_pattern  VARCHAR2,
        p_method   VARCHAR2,
        p_source   CLOB
    ) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name    => c_mod,
            p_pattern        => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method         => p_method,
            p_source_type    => ORDS.source_type_plsql,
            p_source         => REPLACE(p_source, '[COLON]', CHR(58))
        );
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/xl/',
        p_items_per_page => 0,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance Excel integration API (Visual Builder Add-in, Basic auth)'
    );

    def_template('openapi');
    def_handler('openapi', 'GET', q'!
BEGIN
  dct_xl_pkg.emit_openapi;
END;
!');

    def_template('budget/');
    def_handler('budget/', 'GET', q'!
DECLARE
  l_uid NUMBER;
BEGIN
  dct_xl_pkg.require_user(l_uid);
  IF l_uid IS NULL THEN RETURN; END IF;
  -- Accept both namings: budget_year/accounting_period (the field-matching
  -- names the Excel add-in's Search form uses, and what the OpenAPI declares)
  -- and the short year/period fallbacks.
  dct_xl_pkg.emit_list(l_uid, [COLON]limit, [COLON]offset,
                       NVL([COLON]budget_year, [COLON]year),
                       NVL([COLON]accounting_period, [COLON]period),
                       [COLON]search);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('budget/[COLON]id');
    def_handler('budget/[COLON]id', 'GET', q'!
DECLARE
  l_uid NUMBER;
BEGIN
  dct_xl_pkg.require_user(l_uid);
  IF l_uid IS NULL THEN RETURN; END IF;
  dct_xl_pkg.emit_item(l_uid, [COLON]id);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('budget/[COLON]id', 'PUT', q'!
DECLARE
  l_uid NUMBER;
BEGIN
  dct_xl_pkg.require_user(l_uid);
  IF l_uid IS NULL THEN RETURN; END IF;
  dct_xl_pkg.save_item(l_uid, [COLON]id, [COLON]body);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- ------------------------------------------------------------------
    -- VB template repository (108_xl_templates.sql) - BEARER-session auth
    -- (these routes serve the JET apps, not Excel). Management = SYS_ADMIN;
    -- the download of the ACTIVE version's PUBLISHED file = any valid
    -- session (requirement: end users download the active template only).
    -- ------------------------------------------------------------------
    def_template('templates/');
    def_handler('templates/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.emit_list;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    def_handler('templates/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.save_template(l_user, [COLON]body);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('templates/version');
    def_handler('templates/version', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.new_version(l_user, [COLON]body);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('templates/activate');
    def_handler('templates/activate', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.activate(l_user, [COLON]body);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('templates/delete-version');
    def_handler('templates/delete-version', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.delete_version(l_user, [COLON]body);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('templates/file');
    def_handler('templates/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.stream_file([COLON]templateid, [COLON]ver, [COLON]kind);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    def_handler('templates/file', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Forbidden'); RETURN; END IF;
  dct_xl_tpl.upload_file(l_user, [COLON]templateid, [COLON]ver, [COLON]kind,
                         [COLON]filename, [COLON]body);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('templates/download');
    def_handler('templates/download', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_xl_tpl.stream_active([COLON]code);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END;
/

PROMPT === 107.3 verify ===
SELECT name, uri_prefix, status FROM user_ords_modules WHERE name = 'xl.rest';
SELECT m.name, t.uri_template, h.method
FROM   user_ords_handlers h
JOIN   user_ords_templates t ON t.id = h.template_id
JOIN   user_ords_modules m ON m.id = t.module_id
WHERE  m.name = 'xl.rest'
ORDER  BY t.uri_template, h.method;
