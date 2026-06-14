# Accounts Receivable / Event P&L (App 206) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** ACCOUNTS_RECEIVABLE · **ORDS base path:** `/ords/admin/ar/` · **Brand:** `#6C4AB6` (Violet)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.4.0`) — cache key for requirejs + i18n; mandatory per deploy.
- **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").
- Deploy `final apps/shared/` alongside (`../shared/`). If shared/ changed, bump APP_VERSION in **all 7 apps**.
- `js/services/config.js` → live `apiBase`, never `null`.
- Dev note: multiple stale `dev-proxy.py` instances can stack on :8080 (SO_REUSEADDR) — kill all python proxies before restarting.

## 2. Database deployment (PROD schema, via SQLcl)

| Script | Status | Contents |
|---|---|---|
| `01_ar_ddl.sql` | ✅ | 11 DCT_AR_* tables — dedicated `file_blob` (deliberately NOT the shared DCT_DOCUMENTS) |
| `02_ar_seed.sql` | ✅ | Real "P&L Automation.xlsx" taxonomy — 18 cost + 16 revenue categories |
| `03_ar_ai_pkg.sql` | ✅ | `DCT_AR_AI_PKG` — AI classification/extraction via DBMS_CLOUD, provider dispatch, `json_escape_clob`, repair_json |
| `04_ar_views.sql`, `05_ar_ords.sql` | ✅ | Views + `ar.rest` module at `/ar/` |
| `06_ar_patch_gemini.sql` | ⛔ **SUPERSEDED — do not re-run** | Replaced by the provider registry (07); its setting rows were deleted |
| `07_ar_ai_providers.sql` | ✅ 2026-06-13 | `DCT_AR_AI_PROVIDERS` registry (api_format, base_url, write-only api_key, `AR_API_FORMAT` lookup); `AI_PROVIDER` setting = selected provider_code |

Platform SQLcl rules apply (see `final apps/Admin/docs/deployment-notes.md` §2).

AR-specific DB/AI notes:

- **PROD lacks CREATE JOB** — AI scheduler jobs are created by the ORDS handler (ADMIN context) with `job_action` calling `prod.dct_ar_ai_pkg.process_event`. Don't try to create them from a PROD session.
- AI keys live in the provider registry, **write-only** (`hasKey` flag); ORDS masks any `%API_KEY%` value. The Anthropic key is a copy of the PETTY_CASH key (authorized 2026-06-12). Gemini: key-only auth (`x-goog-api-key`).
- `DBMS_CLOUD` raises **ORA-20429** directly on HTTP 429 (not the -20002 wrapper) — `call_ai` retries once after 30s. `process_file` + `POST /files/:id/process` give a per-file Retry.
- `APEX_JSON.STRINGIFY` has no CLOB overload — use `dct_ar_ai_pkg.json_escape_clob` for >32k payloads.
- `chk_dct_modset_valtype` now includes `'COLOR'` (platform-wide change shipped with the settings redesign).

## 3. ORDS deployment

- Module `ar.rest` under ADMIN schema at `/ords/admin/ar/`; ADMIN synonyms; fresh SQLcl session for the ORDS script (ORA-01471).
- **`:body` may only be dereferenced ONCE** — assign to a local BLOB first (caused silent-empty JSON + ORA-01400). `:body_blob` is NOT an implicit param on this ADB ORDS (binds VARCHAR2 → PLS-00382/555).
- Raw-binary handlers must respond via `:status_code` only — any OWA output there → 555.
- `q'[...]'` literals break on `]'` sequences (e.g. `'lineIds[%d]'`) — use `q'!...!'`; but `ESCAPE '!'` inside `q'!...!'` terminates the literal — use `ESCAPE '\'`.
- Bodyless requests must NOT carry `Content-Type: application/json` (ADB ORDS 400s before the handler) — handled in `shared/js/api.js`.

## 4. Post-deploy smoke test

1. Open AR from the Admin module switcher; violet brand + Event P&L dashboard KPIs load.
2. Settings page: 17 ORDS endpoints green (grouped regions, per-region save); Manage Providers popup lists registry rows with masked keys.
3. Upload wizard → AI classification job visible on the event's Files tab; per-file Retry works.
4. Reference numbers: test events EVT-TEST-0001 (Power Slap 16 — expected 303,888 gross / 4 findings / 47,500 loss), EVT-2026-0001, EVT-2026-0002.

## 5. Deployment history

- 2026-06-12: module built + deployed (DB, DCT_AR_AI_PKG, ar.rest, JET SPA). Round 2 same day: Gemini support.
- 2026-06-13: settings redesign deployed (grouped regions, provider registry db/07, 17/17 ORDS + 22/22 E2E green); `06_ar_patch_gemini.sql` superseded.
- 2026-06-13: eventForm/categories/settings/uploadWizard actions moved to top-right (platform rule). Frontend-only; bump APP_VERSION on next deploy.
- 2026-06-13: **Region appearance theme** — headers + borders themed via `THEME_REGION_*` (db/v2/22 seeds AR override rows, NULL = inherit; the 5 keys added to the Settings page "Defaults & Appearance" group). Boots via `shell.initRegionTheme` + `settingService.getAll`. APP_VERSION **4.3.0** (shared/ change, all 7 apps).
- **2026-06-13 — Module Settings redesign (APP_VERSION 4.4.0):** settings page restyled to match Admin System Settings — top-right Save, category cards, switch-row toggles, dirty tracking, alert banners, and a **Region Appearance** palette picker (module-level `THEME_REGION_*` override with live preview + AA-contrast check). New shared helper `shared/js/regionPicker.js` (used by all 7 apps → APP_VERSION bumped 4.3.0→4.4.0 everywhere). Region keys are read/written through this module's existing `/settings` endpoint.
- AR keeps its `set-*` design + AI-provider section; the five `THEME_REGION_*` keys now render in the palette panel inside the Defaults & Appearance region instead of as plain rows.
