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
| Bump `window.APP_VERSION` | In `Jet/index.html` (currently `4.4.0`). Drives the requirejs `urlArgs` + i18n cache key. Localhost auto-busts; deployed browsers serve stale JS/HTML forever if you forget. |
| Deploy `final apps/shared/` | The shared layer (`platform.css`, `shell.js`, `i18n.js`, `chartLoader.js`, components) is referenced at `../shared/` by ALL apps. Any change to it requires an APP_VERSION bump in **all 7 apps'** index.html (precedent: the 4.1.1 wave bump). |
| Check `js/services/config.js` | `apiBase: '/ords/admin/dct'` (live). Never ship `apiBase: null` (mock) to production. |
| Chart.js | Never `<script>`-tag it — loaded via requirejs `chartjs` path, created via `shared/chartLoader.makeChart`. |
| Update `docs/functions_list.md` | If this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint, reflect it in the functional inventory (see root `CLAUDE.md` → "Functions List"). |

## 2. Database deployment (PROD schema, via SQLcl)

Platform-wide SQLcl rules (apply to every script):

- Run via SQLcl only: `sql -name prod_mcp` — **never** the MCP `run-sql` tool (silently swallows errors).
- `prod_mcp` connects as ADMIN — prefix all objects: `CREATE OR REPLACE PACKAGE prod.x …`.
- `SET DEFINE OFF` at the top of every script (`&` in literals hangs SQLcl).
- Deploy scripts must be **CRLF** — SQLcl 26.1 silently skips ALL statements in LF-only files run via `@`.
- **Any script containing Arabic (or non-ASCII) literals MUST be run with `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8`** (PowerShell: `$env:JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"`). Without it SQLcl reads the file as the Windows code page and the Arabic is **silently destroyed** before it reaches the AL32UTF8 column — either as literal `?` or as lossy mojibake. The DB/ORDS/JET write paths are all UTF-8-clean; this is purely a SQLcl file-read issue. Diagnose with `SELECT DUMP(col,1016)` (clean Arabic = `d8`/`d9` lead bytes; corruption = `3f` repeated, or Latin-1 bytes). This destroyed 31 reference values once — see `db/v2/25`.
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
| `22` region theme | ✅ 2026-06-13 | Five `THEME_REGION_*` settings (header fill/font + border color/width/style): system rows (APPEARANCE), override rows in ALL `dct_modules` (26 × 5, NULL = inherit), `chk_dct_set_type` widened (+COLOR/SELECT), `/dct/boot` whitelist + `THEME_REGION_%`. Rerunnable. |
| `24` audit snapshots | ✅ 2026-06-13 | `DCT_AUDIT_PKG` (`snapshots_on` ×2 / `snap` / `log`) + ADMIN synonym + `FEATURE_AUDIT_SNAPSHOTS` (global default) **and 7 per-module switches** `FEATURE_AUDIT_SNAPSHOTS_<ADMIN\|PC\|DT\|HR\|FL\|CC\|AR>` (all BOOLEAN, default **N**). Powers the audit-diff modal. Rerunnable; run in its own fresh session. After deploy, **re-run every module's ORDS script** (11 + PC/DT/HR/FL/CC/AR) so their write handlers capture before/after snapshots. |
| `25` Arabic encoding repair | ✅ 2026-06-13 | One-time data repair: re-supplies correct Arabic for 31 values destroyed by earlier seed runs (SQLcl read the .sql as the Windows code page, not UTF-8). Fixed: `DCT_USERS.display_name_ar` (ADMIN, was literal `?`), `DCT_ROLES.role_name_ar` ×6, `DCT_LOOKUP_CATEGORIES.category_name_ar` ×4, `DCT_LOOKUP_VALUES.value_name_ar` ×20 (all FL). The stored corruption was **unrecoverable** (mojibake collapsed every Arabic letter whose UTF-8 trailing byte was 0x80–0x9F to one char), so values were re-keyed by business code. Idempotent/rerunnable. **MUST run with `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8`** or it re-corrupts. |

### Audit snapshots (db/v2/24) — how it works
- **Per-module control.** Each module has its own switch `FEATURE_AUDIT_SNAPSHOTS_<CODE>` (CODE = the audit module code ADMIN/PC/DT/HR/FL/CC/AR), default **N**, on System Settings → FEATURES. `FEATURE_AUDIT_SNAPSHOTS` (no suffix) is the **default applied to any module without its own switch** (none today — it's a safety net for future modules). Resolution: module switch (Y/N) wins; else the global default; else off.
- `snapshots_on(module_code)` does that resolution (used by `log` to decide whether to store). The no-arg `snapshots_on` is TRUE if **any** `FEATURE_AUDIT_SNAPSHOTS%` key is `Y` (used by `snap` to skip work when snapshots are off everywhere). All keys match `FEATURE\_%` so they flow to `GET /dct/boot` automatically.
- Write handlers call `dct_audit_pkg.snap(table, pk_col, pk_val)` before/after the write and `dct_audit_pkg.log(user, action, type, id, module_code, p_old=>, p_new=>)`. `log` is autonomous + swallows exceptions — auditing can never fail a business write. `snap` excludes BLOB/CLOB/LONG/RAW columns and `PASSWORD_HASH`; settings PUT additionally skips snapshots for `%API_KEY%/%SECRET%/%PASSWORD%/%TOKEN%` keys.
- **Coverage = core entity create/update per module** (Admin users/roles/settings/modules/orgs/lookups/delegations/announcements; PC pc/reimb/clearing; DT requests/settlements; HR employees/contracts/salary; FL registrations/contracts/vouchers; CC cards/requests/replenishments; AR events). Pure workflow actions (approve/submit/etc.) and reference-data sub-endpoints are not yet instrumented — they have their own status-history trails and can adopt the helper incrementally.

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

## 5. Deployment history

- 2026-06-13: **Audit before/after snapshots** deployed (db/v2/24 + all 7 ORDS scripts re-run). New `DCT_AUDIT_PKG` captures JSON old/new of changed rows into `dct_audit_log`, **gated per module** by `FEATURE_AUDIT_SNAPSHOTS_<CODE>` switches (+ `FEATURE_AUDIT_SNAPSHOTS` global default), all default OFF. No frontend change — the audit-diff modal already reads `/dct/audit/:id`; the 8 switches render in System Settings → FEATURES automatically. Verified in PROD: snap NULL when OFF / full JSON when ON, `password_hash`+`photo_blob` excluded, `snap` resolves for all 23 instrumented tables, and per-module resolution (enable PC only → PC captures, DT does not; explicit N overrides global Y).
- 2026-06-13: **Region appearance theme** deployed (db/v2/22 + shared layer). Region/modal/table headers + card borders themed via `THEME_REGION_*` (module → system → CSS fallback); System Settings page gained the Region Appearance palette picker (live preview, AA-contrast badge); module apps boot via `shell.initRegionTheme` (HR has no settings endpoint — system default only). APP_VERSION **4.3.0** in all 7 apps. Verified: `/dct/boot` returns the 5 keys; Playwright on Admin systemSettings/users + PC dashboard.

## 6. Known gaps / cautions

- Audit snapshots (`dct_audit_log.old_values/new_values`) are populated by `DCT_AUDIT_PKG` (db/v2/24) **per module** via the `FEATURE_AUDIT_SNAPSHOTS_<CODE>` switches — all default OFF, so the diff modal shows "no snapshot" until an admin enables a module. Coverage is core entity create/update per module (see §2); workflow actions and reference-data writes are not yet instrumented.
- ADB ORDS returns a 400 HTML error page for **body-less requests carrying `Content-Type: application/json`** (e.g. DELETE). Fixed in `shared/js/api.js` (Content-Type only when a body exists) — don't regress.
- Rotate any leaked keys immediately (an ANTHROPIC_API_KEY leak was rotated during Phase 1).
- **2026-06-13 — Settings palette picker extracted to shared (APP_VERSION 4.4.0):** `Admin/Jet/js/viewModels/systemSettings.js` refactored to consume the new `shared/js/regionPicker.js` (PALETTE/contrast/pickers/live-preview) — no behaviour change. Same helper now powers the Region Appearance panel on every module's settings page. Shared/ change → APP_VERSION bumped to 4.4.0 in all 7 apps.
