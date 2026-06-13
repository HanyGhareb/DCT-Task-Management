# Admin (App 200) — Deployment Notes

> Central identity provider — all module apps authenticate through Admin. A bad Admin deploy breaks login for every app, so deploy Admin first and smoke-test login before touching module apps.
>
> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** ADMIN · **ORDS base path:** `/ords/admin/dct/` · **Brand:** `#C74634` (Oracle Red, App 200 only)
- **DB source of truth:** `db/v2/` at repo root (NOT under `final apps/Admin/` — Admin owns the platform schema)

---

## 1. Frontend (JET SPA) deployment

| Step | Detail |
|---|---|
| Bump `window.APP_VERSION` | In `Jet/index.html` (currently `4.2.0`). Drives the requirejs `urlArgs` + i18n cache key. Localhost auto-busts; deployed browsers serve stale JS/HTML forever if you forget. |
| Deploy `final apps/shared/` | The shared layer (`platform.css`, `shell.js`, `i18n.js`, `chartLoader.js`, components) is referenced at `../shared/` by ALL apps. Any change to it requires an APP_VERSION bump in **all 7 apps'** index.html (precedent: the 4.1.1 wave bump). |
| Check `js/services/config.js` | `apiBase: '/ords/admin/dct'` (live). Never ship `apiBase: null` (mock) to production. |
| Chart.js | Never `<script>`-tag it — loaded via requirejs `chartjs` path, created via `shared/chartLoader.makeChart`. |

## 2. Database deployment (PROD schema, via SQLcl)

Platform-wide SQLcl rules (apply to every script):

- Run via SQLcl only: `sql -name prod_mcp` — **never** the MCP `run-sql` tool (silently swallows errors).
- `prod_mcp` connects as ADMIN — prefix all objects: `CREATE OR REPLACE PACKAGE prod.x …`.
- `SET DEFINE OFF` at the top of every script (`&` in literals hangs SQLcl).
- Deploy scripts must be **CRLF** — SQLcl 26.1 silently skips ALL statements in LF-only files run via `@`.
- No SQL keywords (MERGE/DECLARE/CREATE PROCEDURE) in leading `--` banner comments — SQLcl silently skips the following statement. Diagnose with `SET ECHO ON`.
- `INSERT ALL` + IDENTITY columns → ORA-00001. Use one `INSERT INTO` per row.
- Never close date ranges with `TRUNC(SYSDATE)` when `start_date` defaults to SYSDATE-with-time (ORA-02290) — use `GREATEST(SYSDATE, start_date)`.
- `q'[...]'` literals break on `]'` sequences — use `q'!...!'` there, but `ESCAPE '!'` inside `q'!...!'` terminates the literal — use `ESCAPE '\'`.

Script inventory (`db/v2/`, run order = `install.sql` 01→12, then numbered patches):

| Script | Deployed | Contents |
|---|---|---|
| `01`–`12` (install.sql) | ✅ | 24 DCT_* tables, DCT_AUTH/DCT_REST/DCT_NOTIFY, ORDS module (11), master data (12) |
| `14` approval sweep | ✅ | `DCT_APPROVAL_PKG` escalation/auto-approve scheduler job, daily **07:10** — verify the job is still enabled after redeploys |
| `15`/`16` Phase 2 | ✅ 2026-06-11 | Natural-key masters, unified documents/coding-lines/status-history, DCT_LOOKUP_PKG lookup-first, 22 FKs |
| `17` user photo | ✅ | DCT_USERS photo_blob (base64 ≤ 30k via `/dct/users/:id/photo`) |
| `18` user PUT date fix | ✅ | GREATEST(SYSDATE, start_date) fix for role end-dating |
| `19` wave enhancements | ✅ 2026-06-13 | Template draft lifecycle, `/dct/boot`, `/dct/notifications/count`, `/dct/audit/:id` snapshots, FEATURE_*/LANDING_* seeds, validate_session inactivity timeout |
| `20` enhancements 2 | ✅ 2026-06-13 | Settings PUT upsert, audit fromdt/todt + `/dct/audit/export` CSV, `/dct/sessions/` + revoke, approval-templates restore, INTEGRATION_API_KEY secret seed |
| `21` UAT cleanup | rerunnable | Parks `uat.auto.*` users, closes their sessions, drops `UAT_WAVE_FLOW~V%` archives |

## 3. ORDS deployment

- Module lives under **ADMIN** schema at `/ords/admin/dct/` — `ORDS.ENABLE_SCHEMA('PROD')` does not make `/ords/prod/...` routable on ADB.
- Every PROD object referenced in handler PL/SQL needs an ADMIN synonym (`CREATE OR REPLACE SYNONYM dct_rest FOR prod.dct_rest;`).
- **Run ORDS/synonym scripts in their own fresh SQLcl session** — if an earlier script set `CURRENT_SCHEMA = PROD`, synonyms become self-referencing (ORA-01471).
- Bearer token arrives in CGI env `'AUTHORIZATION'` (no `HTTP_` prefix) on ADB — `DCT_REST.VALIDATE_SESSION` handles the fallback; do not regress it.
- `GET /dct/branding` is the ONLY unauthenticated handler — exposes just APP_NAME/APP_NAME_AR/APP_TAGLINE/APP_TAGLINE_AR. Never add secrets to it.
- ORDS masks any `%API_KEY%` setting value in GET responses; api keys are write-only.
- ORDS base URL comes from OCI Console — never guess from tnsnames (JDBC ≠ HTTPS hostname).

## 4. Post-deploy smoke test

1. Login at the deployed Admin URL (200 from `POST /dct/auth/login`).
2. Module switcher lists all live apps; brand colors load from each module's `THEME_BRAND_COLOR`.
3. `GET /dct/boot` returns feature flags; notifications badge populates.
4. Verify `DCT_APPROVAL_PKG` sweep job exists and is `ENABLED`.

## 5. Known gaps / cautions

- Nothing populates `dct_audit_log.old_values/new_values` yet — the audit diff modal shows "no snapshot" until handlers write snapshots.
- ADB ORDS returns a 400 HTML error page for **body-less requests carrying `Content-Type: application/json`** (e.g. DELETE). Fixed in `shared/js/api.js` (Content-Type only when a body exists) — don't regress.
- Rotate any leaked keys immediately (an ANTHROPIC_API_KEY leak was rotated during Phase 1).
