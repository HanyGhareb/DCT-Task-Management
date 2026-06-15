# Duty Travel (App 204) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** DUTY_TRAVEL · **ORDS base path:** `/ords/admin/dt/` · **Brand:** `#0572CE` (Blue)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.4.0`) — cache key for requirejs + i18n; mandatory per deploy.
- **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").
- Deploy `final apps/shared/` alongside (`../shared/`). If shared/ changed, bump APP_VERSION in **all 7 apps**.
- `js/services/config.js` → live `apiBase`, never `null`.
- DT API-mode patterns: submit goes through the `/submit` endpoint (not a status-field PUT); use `_norm()` where mock/ORDS field names differ.

## 2. Database deployment (PROD schema, via SQLcl)

Run order = `db/install.sql`:

| Script | Contents |
|---|---|
| `01_dt_ddl.sql` → `04_dct_dt_pkg.sql` | DT tables, seed, views, `DCT_DT_PKG` |
| `05_apex_204_setup.sql` | APEX App 204 wiring (subscribes to App 200 auth scheme/items/LOVs — never standalone copies) |
| `06_dt_ords.sql` | ORDS module — run in a **fresh SQLcl session** (synonym ORA-01471 gotcha) |

Platform SQLcl rules apply (see `final apps/Admin/docs/deployment-notes.md` §2).

DT-specific DB notes:

- DT keeps its legacy status CHECK constraints until it adopts the lookup-first rule — don't drop them.
- Natural-key project-costing masters (Phase 2): DT's **inline project/task/exp-type columns are NOT yet FK'd** to `DCT_PROJECTS`/`DCT_TASKS` — pending DT adoption. Migrate before adding new costing features.
- DT `module_code` was fixed during Phase 2 — seeds must use `DUTY_TRAVEL`.

## 3. ORDS deployment

- Module under ADMIN schema at `/ords/admin/dt/`; ADMIN synonyms; fresh session for the ORDS script.
- ⚠ **`dt.rest` once vanished from ADB and had to be restored** (discovered in Phase 1). After ANY platform-wide ORDS work, verify the module is still registered: `SELECT name FROM user_ords_modules` as ADMIN, and smoke `GET /ords/admin/dt/…`.
- `validate_session` first in every protected handler; CGI `'AUTHORIZATION'` key (no `HTTP_` prefix).

## 4. Post-deploy smoke test

1. Open DT from the Admin module switcher; brand blue loads from `THEME_BRAND_COLOR`.
2. New Travel Request → Save as Draft → Submit for Approval; approval action modal works.
3. Per-diem rates and doc requirements config pages load (CONFIGURATION group).

## 5. Deployment history

- **2026-06-15 — Region header flush + missing region headers (DT APP_VERSION 4.5.3→4.5.4; shared/ change → all 8 apps bumped):** shared `platform.css` flush rule (see Admin/FL notes) removes the gap between every in-card header and the border. Normalized the bold-div faux-headers in requestForm (Destination Legs) and settlementForm (Additional Expenses) into themed `.section-heading-row`s; requestForm/requestDetail/settlementForm cards that already had a first-child `.section-heading` now flush automatically. Frontend/CSS only — no DB/ORDS change.
- DB + ORDS + JET SPA complete and live (all 19 VMs dual-mode); APEX pages pending in Builder.
- 2026-06-11: server pagination on dt-requests (Phase 3); dashboard charts.
- 2026-06-13: Save/Back/Cancel actions moved to top-right of page/region/modal (platform rule). Frontend-only; bump APP_VERSION on next deploy.
- 2026-06-13: **Region appearance theme** — headers + borders themed via `THEME_REGION_*` (db/v2/22 seeds DT override rows, NULL = inherit; editable in Module Settings). Boots via `shell.initRegionTheme`. APP_VERSION **4.3.0** (shared/ change, all 7 apps). Module Settings VM now defaults JSON keys APEX_JSON omits for NULLs (the new no-default rows would otherwise kill the rows after them).
- **2026-06-13 — Module Settings redesign (APP_VERSION 4.4.0):** settings page restyled to match Admin System Settings — top-right Save, category cards, switch-row toggles, dirty tracking, alert banners, and a **Region Appearance** palette picker (module-level `THEME_REGION_*` override with live preview + AA-contrast check). New shared helper `shared/js/regionPicker.js` (used by all 7 apps → APP_VERSION bumped 4.3.0→4.4.0 everywhere). Region keys are read/written through this module's existing `/settings` endpoint.
- DT keeps its Reset-to-Defaults button (now in the page-header actions).
