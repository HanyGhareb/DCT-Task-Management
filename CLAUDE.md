# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**i-Finance** is a suite of Oracle APEX + Oracle JET SPA applications for the Finance Division of a UAE government organisation. The platform runs on Oracle Autonomous Database (ADB) 23ai/26ai in OCI.

**App 200 (Admin)** is the central identity provider. All other module apps authenticate through it.

---

## Repository Layout

```
final apps/          ← ALL live production code lives here
  Admin/Jet/         ← App 200 — JET SPA (auth, users, roles, settings)
  PC/Jet/            ← App 201 — Petty Cash JET SPA
  DT/Jet/            ← App 204 — Duty Travel JET SPA
  HR/Jet/            ← App 205 — HR JET SPA
  FL/Jet/            ← Freelancers JET SPA
  CC/Jet/            ← Credit Cards JET SPA
  SHARED_JET_ARCHITECTURE.md   ← session contract, module checklist
  SHARED_APEX_ARCHITECTURE.md  ← APEX auth scheme, app items, LOVs
  DT/STATUS.md       ← per-module status tracking (replicated per module)

db/v2/               ← All DCT_* DDL, packages, ORDS setup (source of truth)
  install.sql        ← master script: runs 01→12 in order
  01_dct_ddl.sql     ← 24 DCT_* tables
  03_dct_auth_pkg.sql← DCT_AUTH package
  11_dct_ords.sql    ← all ORDS module definitions (Admin /dct/ path)
  12_dct_master_data.sql ← reference tables (grades, countries, GL codes…)

apps/ifinance-v2/    ← LEGACY: vanilla JS task management prototype (localStorage only)
                       Superseded by final apps/ — do not add features here

docs/                ← proposals, APEX setup guides, analysis
myDoc/               ← Oracle Wallet + tnsnames for ADB connection
```

---

## Running the JET SPA Locally

Every JET app has `dev-proxy.py` in its root. It serves static files on port 8080 and proxies `/ords/` requests to ADB (adds CORS headers).

```bash
# From final apps/Admin/Jet/
python dev-proxy.py
# Open http://localhost:8080
```

The Admin app is the only one that needs to run for full auth. Module apps redirect to `../Admin/Jet/index.html` when no session is found.

Toggle between mock (localStorage) and live ORDS in `js/services/config.js`:
```js
// apiBase: null,            // mock mode — no network calls
apiBase: '/ords/admin/dct',  // live via dev-proxy
```

---

## Database Connection

Use SQLcl at `C:\claude\tools\sqlcl\sqlcl\bin\sql.exe`.

```powershell
sql -name prod_mcp
```

**Always use SQLcl for DB scripts — never the MCP `run-sql` tool**, which silently swallows errors.

All packages and objects must be created in PROD schema. When running from an ADMIN session prefix with schema:
```sql
CREATE OR REPLACE PACKAGE prod.package_name AS ...
```

Add `SET DEFINE OFF` at the top of every seed script — `&` in string literals triggers a substitution variable prompt that hangs SQLcl.

---

## JET SPA Architecture

All JET apps share the same pattern. Full contract is in `final apps/SHARED_JET_ARCHITECTURE.md`. Key points:

**Custom router — no ojs/* CDN imports.** `main.js` wires a `ko.bindingHandlers.module` that swaps view HTML + ViewModel into a container element. Never import `ojs/*` paths in `define([])` — they 404 on the CDN config used here.

**All services return Promises.** VMs initialise observables empty (`ko.observableArray([])`) then populate in `.then()`. Never store a Promise directly in a `ko.observableArray()`.

**Session key** is always `'ifinance_jet_session'` in every app. Module apps only read it; only Admin JET writes it on login/logout.

**`api.js`** injects `Authorization: Bearer <token>` on every request and auto-navigates to `login` on 401.

**KO binding patterns in views:**
- Use `<!-- ko if: --> / <!-- /ko -->` and `data-bind="text: ..."` — the existing codebase uses raw KO, not JET's `<oj-if>` / `<oj-bind-text>`. The IDE shows advisory warnings; ignore them.
- Never wrap KO-bound `<input>` in `<label>` — causes double-toggle. Use `<div>` + `pointer-events:none` on the input.
- Use `$root.method()` (not `$parent`) when calling VM methods inside nested `foreach`.
- Never call `ko.cleanNode(element)` on an element's own binding — only clean child nodes.

**Services are ORDS-only.** `mockData.js` is present in each module but not imported by any service. The `config.apiBase` toggle switches between mock (null) and live ORDS (string).

---

## APEX Module Architecture

Full checklist in `final apps/SHARED_APEX_ARCHITECTURE.md`. Key rules:

- **Build pages in APEX Builder (24.2) first**, then export via `apex_export.get_application`. Never hand-author page SQL scripts.
- Every new module app subscribes to App 200's `DCT Auth` scheme, standard app items, and common LOVs — never create standalone copies.
- `SET_APP_ITEMS` (On New Session) is the standard process body that populates `APP_USER_ID`, `APP_ORG_ID`, `APP_IS_ADMIN`, etc.

---

## ORDS on ADB — Critical Rules

**Module path:** All ORDS modules must be registered under ADMIN schema at `/ords/admin/<module>/`. `ORDS.ENABLE_SCHEMA('PROD')` does not make `/ords/prod/...` routable on ADB managed ORDS.

**Authorization header:** ADB managed ORDS passes the Bearer token under CGI env key `'AUTHORIZATION'` (no `HTTP_` prefix). `OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION')` returns NULL on ADB. `DCT_REST.VALIDATE_SESSION` already handles this with a fallback — do not regress it.

**Synonyms:** ORDS handlers execute as ADMIN. Every PROD object referenced in handler PL/SQL needs an ADMIN synonym:
```sql
CREATE OR REPLACE SYNONYM dct_rest FOR prod.dct_rest;
```

**Handler pattern:** Use `q'[...]'` for string literals containing special characters. Call `dct_rest.validate_session(:body)` at the top of every protected handler. Return JSON via `APEX_JSON` package.

---

## Database Layer

**Key packages in PROD schema:**
- `DCT_AUTH` — authenticate, validate_session, has_role, has_permission, open/close session
- `DCT_REST` — validate_session (reads Authorization header), parse_body, err()
- `DCT_NOTIFY` — send, mark_read, get_count, purge

**Non-obvious column names (bitten us before):**
| Table | Gotcha |
|---|---|
| `DCT_USER_ROLES` | date column is `end_date`, not `valid_to` |
| `DCT_APPROVAL_INSTANCES` | status column is `overall_status`; join steps via `template_id + current_step_seq` |
| `DCT_LOOKUP_VALUES` | columns are `value_code` / `value_name_en` / `display_order` |
| `DCT_GL_CODE_COMBINATIONS` | no `cc_concat_segments` column; `cc_code` is a virtual column — concatenate 9 segment codes manually |
| `DCT_AUTH.HAS_ROLE` | takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |

**INSERT ALL + IDENTITY columns:** Raises ORA-00001. Use individual `INSERT INTO` per row instead.

**Shared tables used across modules:** `DCT_EMPLOYEES`, `DCT_DATA_ACCESS_ASSIGNMENT`, `DCT_LOOKUP_VALUES`, `DCT_GL_CODE_COMBINATIONS`. See `db/v2/12_dct_master_data.sql` for reference table details (countries, grades, currencies, banks, document types).

---

## Module Status

| Module | DB + ORDS | JET SPA | APEX Pages |
|--------|-----------|---------|------------|
| Admin (App 200) | ✅ Complete | ✅ Live ORDS | ✅ Users/Roles built |
| Petty Cash (App 201) | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |
| Duty Travel (App 204) | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |
| HR (App 205) | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |
| Freelancers | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |

---

## Available Skills

Two skills are configured in `skills-lock.json`:
- `/apex` — Oracle APEX 24.2 page creation workflow
- `/frontend-design` — production-grade frontend design (distinctive aesthetics, avoids generic AI-slop styling)

---

## Conventions

**CSS:** `final apps/Admin/Jet/css/app.css` is the master stylesheet. All module apps clone it and change only the brand colour variable. The `rm-*` / `re-*` Vault dark-theme classes in Admin's CSS apply only to the roles/permissions pages.

**ORDS URL:** `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com` — always get from OCI Console, never guess from tnsnames (JDBC and HTTPS use different hostnames on ADB).

**Legacy app conventions** (apps/ifinance-v2/ only): Global controller objects `Manager`, `Director`, `Auth`, `DataStore`, `Charts`, `Utils`. ISO week: use `Utils.getISOWeek()` / `Utils.getWeekDates()`. Status/priority values are uppercase string constants.
