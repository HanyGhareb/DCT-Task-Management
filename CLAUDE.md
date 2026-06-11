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
  FL/db/             ← Freelancers — DB only (no Jet/ folder yet)
  CC/db/             ← Credit Cards — DB only (no Jet/ folder yet)
  SHARED_JET_ARCHITECTURE.md   ← session contract, module checklist
  SHARED_APEX_ARCHITECTURE.md  ← APEX auth scheme, app items, LOVs
  DT/STATUS.md       ← per-module status tracking (replicated per module)

db/v2/               ← All DCT_* DDL, packages, ORDS setup (source of truth)
  install.sql        ← master script: runs 01→12 in order
  01_dct_ddl.sql     ← 24 DCT_* tables
  03_dct_auth_pkg.sql← DCT_AUTH package
  11_dct_ords.sql    ← all ORDS module definitions (Admin /dct/ path)
  12_dct_master_data.sql ← reference tables (grades, countries, GL codes…)
  15_dct_unified_structures.sql ← Phase 2: natural-key masters + unified
                       documents / coding-lines / status-history + DCT_LOOKUP_PKG
  16_dct_missing_fks.sql ← Phase 2: natural-key FKs + lookup-first migration
  17_dct_user_photo.sql  ← DCT_USERS photo_blob/photo_mime_type (profile photos via /dct/users/:id/photo)

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

**Services are ORDS-only (Admin JET).** All 8 Admin JET services (`authService`, `userService`, `roleService`, `orgService`, `moduleService`, `settingService`, `notificationService`, `auditService`) call ORDS directly — no mock branches, no `mockData` imports, no localStorage fallback. `mockData.js` is present but unused. Module apps (PC, DT, HR …) may still have `apiBase: null` in their `config.js` and remain in mock mode until their ORDS endpoints are wired.

**`roleService.getPermissionMatrix()` return shape** is `{ roles: [...], matrix: [...] }` — not a flat array. The `matrix` array contains rows with `permId`, `permCode`, `permName`, `module`, and a `role_<roleId>: boolean` key per role. VMs must destructure: `result.roles` and `result.matrix`.

**`roleService.setRolePermissions(roleId, permIds)`** — added alongside `update()`. Sends `PUT /roles/:id` with `{ permIds }`. Used by both `permissions.js` and `roleEdit.js` VMs.

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
- `DCT_LOOKUP_PKG` — `is_valid` / `validate_lookup` (raises -20090). **Lookup-first rule:** status/enum value sets live in `DCT_LOOKUP_VALUES` (managed in Admin lookups.html), not CHECK constraints. New/refactored tables get no status CHECKs; packages and handlers call `validate_lookup`. PC/DT keep their legacy CHECKs as safety nets until those modules adopt.

**Unified shared structures (Phase 2, 2026-06-11):** `DCT_DOCUMENTS` (+ `DCT_DOC_REQUIREMENTS`, `DCT_DOC_EXPIRY_ALERTS`), `DCT_BUDGET_CODING_LINES`, `DCT_REQUEST_STATUS_HISTORY` — discriminated by `(source_module, source_type, source_id)`. CC and FL use them natively (their private doc/attachment/line tables are dropped); PC ORDS writes status history. FL convention: `dct_documents.reference_id` carries the freelancer_id.

**Natural-key project-costing masters (no surrogate IDs):** `DCT_PROJECTS` (`project_number VARCHAR2(12)` PK), `DCT_TASKS` (`(project_number, task_number VARCHAR2(30))` PK — replaced `DCT_PROJECT_TASKS`), `DCT_EXPENDITURE_TYPES` (`expenditure_type VARCHAR2(255)` PK). Module project/task/exp-type columns FK directly to them (22 validated FKs; DT's inline columns pending DT adoption).

**Non-obvious column names (bitten us before):**
| Table | Gotcha |
|---|---|
| `DCT_USER_ROLES` | date column is `end_date`, not `valid_to` |
| `DCT_APPROVAL_INSTANCES` | status column is `overall_status`; join steps via `template_id + current_step_seq` |
| `DCT_LOOKUP_VALUES` | columns are `value_code` / `value_name_en` / `display_order` |
| `DCT_GL_CODE_COMBINATIONS` | segment columns end in `_code` (`account_code`, not `account`); `cc_code` is a virtual column with the full 9-segment concatenation — use it for display |
| `DCT_NATIONALITY` | name columns are `nationality_en` / `nationality_ar`, not `nationality_name_en` |
| `DCT_AUTH.HAS_ROLE` | takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |

**INSERT ALL + IDENTITY columns:** Raises ORA-00001. Use individual `INSERT INTO` per row instead.

**ADMIN synonyms need a fresh session:** scripts that `CREATE OR REPLACE SYNONYM x FOR prod.x` must NOT run in a SQLcl session where an earlier script set `ALTER SESSION SET CURRENT_SCHEMA = PROD` — the synonym becomes self-referencing (ORA-01471). Run ORDS/synonym scripts in their own `sql -name prod_mcp` invocation.

**Shared tables used across modules:** `DCT_EMPLOYEES`, `DCT_DATA_ACCESS_ASSIGNMENT`, `DCT_LOOKUP_VALUES`, `DCT_GL_CODE_COMBINATIONS`. See `db/v2/12_dct_master_data.sql` for reference table details (countries, grades, currencies, banks, document types).

---

## Module Status

| Module | DB + ORDS | JET SPA | APEX Pages |
|--------|-----------|---------|------------|
| Admin (App 200) | ✅ Complete | ✅ Live ORDS | ✅ Users/Roles built |
| Petty Cash (App 201) | ✅ Complete (ORDS live `/pc/`) | ✅ Complete (live) | ⬜ Pending in Builder |
| Duty Travel (App 204) | ✅ Complete (ORDS live) | ✅ Complete (live) | ⬜ Pending in Builder |
| HR (App 205) | ✅ Complete (ORDS live) | ✅ Complete (live) | ⬜ Pending in Builder |
| Freelancers (App 203) | ✅ DB + PL/SQL (unified-adopted); ⬜ no ORDS | ⬜ Not started (no Jet/ folder) | ⬜ Not started |
| Credit Cards (App 202) | ✅ DB + PL/SQL (DCT_CC_PKG, unified-adopted); ⬜ no ORDS | ⬜ Not started (no Jet/ folder) | ⬜ Not started |

Full evaluation + phased action plan: `assessment-3/` (2026-06-11). Phase 1 executed + tested — report in `assessment-3/phase1/`. Phase 2 (data-model convergence: natural-key masters, unified tables, lookup-first, 22 FKs, CC+FL adoption) executed + tested 2026-06-11 — report in `assessment-3/phase2/`. Phase 3 (frontend foundation: `final apps/shared/` layer, page-level shell with module switcher, EN/AR i18n+RTL, tri-state lists, server pagination on users/audit/pc-all/dt-requests/hr-employees, Chart.js dashboards ×4, new `/dct/stats/` + `/dct/prefs/` endpoints) executed + tested 2026-06-11 — report in `assessment-3/phase3/`. Platform sweep job `DCT_APPROVAL_PKG` (db/v2/14) activates approval escalation/auto-approve daily 07:10.

---

## Available Skills

Two skills are configured in `skills-lock.json`:
- `/apex` — Oracle APEX 24.2 page creation workflow
- `/frontend-design` — production-grade frontend design (distinctive aesthetics, avoids generic AI-slop styling). The skill instructs: commit to a bold conceptual direction before coding; pick distinctive fonts (never Inter/Roboto/Arial); use CSS variables for theming; animate high-impact moments (load reveals, toggles) rather than scattering micro-interactions. Used to create the Vault dark theme for the roles/permissions pages.

---

## Conventions

**CSS (Phase 3):** `final apps/shared/css/platform.css` is the ONE structural stylesheet for all JET apps — edit it once; never copy styles into a module app. Each app's `css/app.css` holds only brand tokens (`--brand`/`--brand-rgb`/`--brand-dark`/`--brand-soft` + legacy aliases); the live brand color loads from the module's `THEME_BRAND_COLOR` setting at boot (`shared/js/shell.js`). Full contract incl. the shared shell (top bar + module switcher + side-nav), i18n (`t()`, EN/AR, Latin digits), tri-state lists (`<list-skeleton>`/`<list-pager>`/toast) and the Chart.js rule (**never `<script>`-tag it — load via requirejs `chartjs` path; create via `shared/chartLoader.makeChart`**) is in `final apps/SHARED_JET_ARCHITECTURE.md`. KO+ORDS gotcha: APEX_JSON skips NULLs — bind optional fields as `$data.field || ''`, never bare `text: field`.

**Vault design system** (`rm-*` / `re-*` classes, defined at the bottom of Admin's `app.css`) applies only to the roles/permissions pages (`roles.html`, `permissions.html`, `roleEdit.html`). Key design tokens:

| Variable | Value | Usage |
|---|---|---|
| `--vault-bg` | `#0D1117` | Page background |
| `--vault-surface` | `#161B22` | Card / panel surface |
| `--vault-border` | `#30363D` | Borders |
| `--vault-text` | `#E6EDF3` | Primary text |
| `--vault-muted` | `#7D8590` | Secondary text |
| `--vault-amber` | `#F0883E` | Accent / active states |
| `--vault-green` | `#3FB950` | Success / active status |
| `--vault-red` | `#F85149` | Error / danger |
| `--vault-blue` | `#58A6FF` | Code badges / info |
| `--vault-font` | `'Outfit'` | UI text (Google Fonts) |
| `--vault-mono` | `'Fira Code'` | Role codes, permission codes |

The permission matrix toggle (`rm-toggle-wrap` / `rm-toggle--on`) and permission checkbox items (`re-perm-item` / `re-perm-item--on`) use amber dot animations with `cubic-bezier(.34,1.56,.64,1)` spring timing. Use the same pattern for any new security-section pages.

**ORDS URL:** `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com` — always get from OCI Console, never guess from tnsnames (JDBC and HTTPS use different hostnames on ADB).

**Legacy app conventions** (apps/ifinance-v2/ only): Global controller objects `Manager`, `Director`, `Auth`, `DataStore`, `Charts`, `Utils`. ISO week: use `Utils.getISOWeek()` / `Utils.getWeekDates()`. Status/priority values are uppercase string constants.
