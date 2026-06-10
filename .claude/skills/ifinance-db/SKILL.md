# /ifinance-db — Oracle DB Objects & ORDS Skill

You are creating Oracle database objects (tables, packages, views, seed data) and ORDS REST endpoints for an i-Finance style application running on Oracle Autonomous Database (ADB) 23ai/26ai with managed ORDS.

When this skill is invoked, apply ALL rules below without exception. These are hard-won lessons — every rule has caused a real production failure at least once.

---

## 1. Tool Execution — Always SQLcl, Never MCP run-sql

**Run all DB scripts via SQLcl in PowerShell:**
```powershell
& "C:\claude\tools\sqlcl\sqlcl\bin\sql.exe" -name prod_mcp "@C:\path\to\script.sql" 2>&1
```

**Never use the MCP `run-sql` tool for deployments.** It silently swallows errors — it returns "completed with no output" for both success and failure. It may also use a different DB session per call, losing `import_begin` context mid-script.

Reserve MCP tools only for read-only verification (e.g. checking row counts or object status after deployment).

---

## 2. Schema Qualification — ADMIN connects, PROD owns objects

The wallet connection `sql -name prod_mcp` connects as **ADMIN**, not PROD. All application tables and packages live in the **PROD** schema.

**Every `CREATE OR REPLACE PACKAGE` and `CREATE OR REPLACE PACKAGE BODY` must be prefixed with `prod.`:**
```sql
CREATE OR REPLACE PACKAGE prod.my_pkg AS ...
CREATE OR REPLACE PACKAGE BODY prod.my_pkg AS ...
```

Without the `prod.` prefix the object is silently created in ADMIN where the tables don't exist, causing ORA-00942 / PLS-00201 at runtime.

**Inside a package body**, once it is owned by PROD, Oracle resolves all unqualified names against the PROD schema automatically — no `prod.` prefixes needed inside the body.

**DDL scripts** (tables, sequences, indexes) use `ALTER SESSION SET CURRENT_SCHEMA = PROD` at the top so unqualified `CREATE TABLE` creates in PROD:
```sql
ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF;
```

---

## 3. Script Header — Always SET DEFINE OFF

Place `SET DEFINE OFF` near the top of **every** SQL script — DDL, DML, or ORDS setup:
```sql
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
```

Without this, SQLcl treats `&` in string literals as a substitution variable prompt and **hangs** the script. This hits seed data containing names like `'Department of Culture & Tourism'`.

---

## 4. DDL Patterns

### Table structure
```sql
CREATE TABLE prefix_entity (
    entity_id       NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    entity_code     VARCHAR2(50)   NOT NULL,
    name_en         VARCHAR2(200)  NOT NULL,
    name_ar         VARCHAR2(200),
    is_active       VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    display_order   NUMBER         DEFAULT 0,
    created_by      VARCHAR2(100),
    created_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      VARCHAR2(100),
    updated_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_prefix_code   UNIQUE (entity_code),
    CONSTRAINT chk_prefix_active CHECK (is_active IN ('Y','N'))
);
CREATE INDEX ix_prefix_active ON prefix_entity(is_active);
```

### Circular FK pattern (org ↔ user head)
When two tables reference each other, create the FK after both tables exist:
```sql
ALTER TABLE dct_organizations ADD CONSTRAINT fk_org_head
    FOREIGN KEY (head_user_id) REFERENCES dct_users(user_id);
```

### Clean-reinstall block
Always include a commented-out DROP block at the top:
```sql
/*
DROP TABLE child_table CASCADE CONSTRAINTS PURGE;
DROP TABLE parent_table CASCADE CONSTRAINTS PURGE;
*/
```

### Audit trigger pattern
```sql
CREATE OR REPLACE TRIGGER trg_prefix_entity_bi
BEFORE INSERT ON prefix_entity FOR EACH ROW
BEGIN
    :NEW.created_at := SYSTIMESTAMP;
    :NEW.created_by := SYS_CONTEXT('USERENV','SESSION_USER');
    :NEW.updated_at := SYSTIMESTAMP;
END;
/
CREATE OR REPLACE TRIGGER trg_prefix_entity_bu
BEFORE UPDATE ON prefix_entity FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := SYS_CONTEXT('USERENV','SESSION_USER');
END;
/
```

---

## 5. Seed Data — INSERT ALL is Forbidden for IDENTITY Tables

**Never use `INSERT ALL` on tables with `GENERATED ALWAYS AS IDENTITY` columns on Oracle 23ai.**

Oracle 23ai has a bug where `INSERT ALL ... SELECT 1 FROM dual` generates duplicate sequence values, causing ORA-00001 on the second row even on an empty table.

**Use individual `INSERT INTO` per row:**
```sql
-- WRONG on 23ai IDENTITY tables:
INSERT ALL
  INTO my_table (col1, col2) VALUES ('A', 'Alpha')
  INTO my_table (col1, col2) VALUES ('B', 'Beta')
SELECT 1 FROM dual;

-- CORRECT:
INSERT INTO my_table (col1, col2) VALUES ('A', 'Alpha');
INSERT INTO my_table (col1, col2) VALUES ('B', 'Beta');
COMMIT;
```

Tables with **VARCHAR2 primary keys** (countries, currencies, grades, lookup categories) are safe to use `INSERT ALL`.

---

## 6. PL/SQL — No SELECT * + %ROWTYPE + Scalar in Same INTO

**Never write:**
```sql
SELECT t.*, o.other_col
INTO   l_row,         -- %ROWTYPE
       l_other_col    -- scalar
FROM   t JOIN o ON ...
```

This causes `PLS-00494: coercion into multiple record targets not supported`. Oracle cannot split a JOIN select-star into a %ROWTYPE + scalar pair.

**Fix — split into two queries:**
```sql
SELECT * INTO l_row FROM my_table WHERE pk = val;
SELECT other_col INTO l_scalar FROM other_table WHERE fk = l_row.fk_col;
```

Or list columns explicitly in a single SELECT INTO.

---

## 7. Package Structure

Every package file: spec first, then body, both in the same `.sql` file, both with `prod.` prefix:

```sql
CREATE OR REPLACE PACKAGE prod.my_pkg AS

    FUNCTION  validate_something(p_token VARCHAR2) RETURN VARCHAR2;
    PROCEDURE do_work(p_id NUMBER);

END my_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.my_pkg AS

    FUNCTION validate_something(p_token VARCHAR2) RETURN VARCHAR2 IS
        l_result VARCHAR2(100);
    BEGIN
        ...
        RETURN l_result;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END validate_something;

    PROCEDURE do_work(p_id NUMBER) IS
    BEGIN
        ...
        COMMIT;
    END do_work;

END my_pkg;
/
```

**Key packages to reuse across projects:**
- `dct_auth` — authenticate, validate_session, has_role, has_permission, open/close session
- `dct_rest` — validate_session (reads Authorization header), json_header, err(), parse_body()
- `dct_notify` — send, mark_read, get_count, purge

---

## 8. ORDS on ADB — Critical Rules

### Rule 1: Module MUST be registered under ADMIN schema

`ORDS.ENABLE_SCHEMA('PROD')` from an ADMIN session succeeds but does **not** make `/ords/prod/...` routable in ADB managed ORDS. Only ADMIN schema is routable at `/ords/admin/...`.

**Create the ORDS setup procedure without a schema prefix (ADMIN schema):**
```sql
CREATE OR REPLACE PROCEDURE setup_ords_tmp AS
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'myapp',
        p_base_path      => '/myapp/',
        p_is_published   => TRUE,
        p_origins_allowed => '*'   -- required for CORS preflight
    );
    ...
END;
/
EXEC setup_ords_tmp;
DROP PROCEDURE setup_ords_tmp;
COMMIT;
```

This makes endpoints live at `/ords/admin/myapp/...`.

### Rule 2: Create ADMIN synonyms for every PROD object

ORDS handlers execute with ADMIN as the parsing schema. Every PROD table and package referenced in handler PL/SQL needs an ADMIN synonym:

```sql
CREATE OR REPLACE SYNONYM my_table     FOR prod.my_table;
CREATE OR REPLACE SYNONYM my_pkg       FOR prod.my_pkg;
CREATE OR REPLACE SYNONYM dct_rest     FOR prod.dct_rest;
CREATE OR REPLACE SYNONYM dct_auth     FOR prod.dct_auth;
```

Without synonyms, handlers fail with ORA-00942 (table not found) or PLS-00201 (identifier not declared) — **silently at runtime**, not at compile time.

### Rule 3: Authorization header key on ADB

ADB managed ORDS passes the `Authorization` request header under the CGI env key `AUTHORIZATION` (no `HTTP_` prefix). Using `HTTP_AUTHORIZATION` returns NULL, causing all token validation to silently fail.

**Always try both, `AUTHORIZATION` first:**
```sql
l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
IF l_hdr IS NULL THEN
    l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
END IF;
```

### Rule 4: ORDS URL comes from OCI Console — never guess

The tnsnames.ora only contains the JDBC host (`adb.<region>.oraclecloud.com`). The HTTPS ORDS URL is completely different:
```
https://<db-unique-prefix>-<db-name>.adb.<region>.oraclecloudapps.com
```
Get it from **OCI Console → ADB instance → Database Actions button**. Never derive from tnsnames.

### ORDS handler template

```sql
ORDS.DEFINE_HANDLER(
    p_module_name    => 'myapp',
    p_pattern        => 'items/',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => q'[
DECLARE
    l_user VARCHAR2(100);
BEGIN
    l_user := dct_rest.validate_session;
    IF l_user IS NULL THEN
        dct_rest.err(401, 'Unauthorized');
        RETURN;
    END IF;

    dct_rest.json_header;
    APEX_JSON.open_object;
    APEX_JSON.open_array('items');
    FOR r IN (SELECT item_id, item_name FROM my_items WHERE is_active = 'Y') LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('id',   r.item_id);
        APEX_JSON.write('name', r.item_name);
        APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
END;
    ]'
);
```

**Always call `dct_rest.validate_session` at the top of every protected handler** and return 401 immediately if NULL.

Use `q'[...]'` (alternative quoting) for handler source — it handles single quotes without escaping.

---

## 9. CORS — Add Origins Allowed to Module Definition

Always include `p_origins_allowed => '*'` in `ORDS.DEFINE_MODULE` to allow browser preflight OPTIONS requests from JET SPA running on localhost or a different domain:

```sql
ORDS.DEFINE_MODULE(
    p_module_name     => 'myapp',
    p_base_path       => '/myapp/',
    p_is_published    => TRUE,
    p_origins_allowed => '*'
);
```

Also define an OPTIONS handler for each path pattern that requires CORS:
```sql
ORDS.DEFINE_HANDLER(
    p_module_name => 'myapp',
    p_pattern     => 'items/',
    p_method      => 'OPTIONS',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'[BEGIN dct_rest.json_header; END;]'
);
```

---

## 10. Grants Required Before Any Object Creation

Run these grants as ADMIN before creating PROD objects:

```sql
GRANT EXECUTE ON DBMS_CRYPTO    TO PROD;   -- for dct_auth password hashing
GRANT EXECUTE ON APEX_JSON      TO PROD;   -- for ORDS JSON responses
GRANT EXECUTE ON OWA_UTIL       TO PROD;   -- for CGI env + HTTP headers
GRANT EXECUTE ON HTP            TO PROD;   -- for HTP.p() in CORS headers
GRANT CREATE TABLE              TO PROD;
GRANT CREATE VIEW               TO PROD;
GRANT CREATE TRIGGER            TO PROD;
GRANT CREATE PROCEDURE          TO PROD;
GRANT CREATE SEQUENCE           TO PROD;
```

---

## 11. Deployment Order

Always deploy in this order — each step depends on the previous:

```
1. Grants (ADMIN → PROD)
2. DDL — tables, indexes, triggers        (01_*.sql)
3. Views                                   (02_*.sql)
4. Core packages — dct_auth, dct_rest     (03_*.sql)
5. Seed data — roles, modules, lookups    (04_*.sql)
6. Domain packages — notify, users_api   (06_*.sql, 07_*.sql)
7. Master/reference data                  (12_*.sql)
8. ORDS setup (run separately, not in install.sql)  (11_*.sql)
```

ORDS setup is **always run separately** from the main install — it depends on all packages being compiled first.

---

## 12. Verification After Deployment

After running any script, verify with MCP (read-only queries are fine):

```sql
-- Check object validity
SELECT object_name, object_type, status
FROM   all_objects
WHERE  owner = 'PROD'
  AND  object_type IN ('PACKAGE','PACKAGE BODY','TABLE','VIEW')
ORDER BY object_type, object_name;

-- Check ORDS modules
SELECT name, uri_prefix, is_published
FROM   ords_metadata.user_ords_modules;

-- Check synonyms exist in ADMIN
SELECT synonym_name, table_owner, table_name
FROM   all_synonyms
WHERE  owner = 'ADMIN'
ORDER BY synonym_name;
```

Any `INVALID` package status means a compilation error — run `SHOW ERRORS PACKAGE BODY prod.pkg_name` in SQLcl to see details.

---

## 13. Column Naming Gotchas (DCT Tables)

Non-obvious column names that have caused bugs:

| Table | Gotcha |
|---|---|
| `DCT_USER_ROLES` | date column is `end_date`, not `valid_to` |
| `DCT_APPROVAL_INSTANCES` | status column is `overall_status`; join steps via `template_id + current_step_seq` |
| `DCT_LOOKUP_VALUES` | columns are `value_code` / `value_name_en` / `display_order` |
| `DCT_GL_CODE_COMBINATIONS` | no `cc_concat_segments` virtual column — concatenate 9 segment codes manually |
| `DCT_AUTH.HAS_ROLE` | takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |

---

## 14. Common Non-obvious table gotchas

- `DCT_EMPLOYEES` and `DCT_DATA_ACCESS_ASSIGNMENT` are **shared across all modules** (PC, DT, HR, FL). Never create per-module copies.
- Reference tables (`DCT_LOOKUP_VALUES`, `DCT_GL_CODE_COMBINATIONS`) are populated by `12_dct_master_data.sql` — check there before adding duplicate seed rows.
- `DCT_GL_CODE_COMBINATIONS` has 9 segment columns (`cc_seg1`…`cc_seg9`) — build the display string by concatenating them with `.` separator, not from a virtual column.