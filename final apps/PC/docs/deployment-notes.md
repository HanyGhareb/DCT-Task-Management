# Petty Cash (App 201) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** PETTY_CASH · **ORDS base path:** `/ords/admin/pc/` · **Brand:** `#2E7D32` (Green)
- Depends on Admin (App 200) for auth — deploy/verify Admin first. PC only reads the shared `ifinance_jet_session`.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.4.0`) — drives requirejs + i18n cache key; deployed browsers serve stale files without it.
- **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").
- Deploy `final apps/shared/` alongside (referenced at `../shared/`). If shared/ changed, bump APP_VERSION in **all 7 apps**.
- `js/services/config.js` → `apiBase` must point at the live `/ords/admin/pc` path (plus `/ords/admin/dct` for shared endpoints), never `null` (mock).
- Chart.js via requirejs `chartjs` path only (dashboard has 2 charts) — never `<script>`-tag it.

## 2. Database deployment (PROD schema, via SQLcl)

Run order = `db/install.sql`:

| Script | Contents |
|---|---|
| `00_shared_alterations.sql` | Alters shared DCT tables — **run first; coordinate with other modules** |
| `01_pc_ddl.sql` → `05_pc_alter.sql` | PC tables, views, seed, `DCT_PC_PKG`, alterations |
| `06_pc_ords.sql` | ORDS module — run in a **fresh SQLcl session** (synonym ORA-01471 gotcha) |

Platform SQLcl rules apply (see `final apps/Admin/docs/deployment-notes.md` §2): SQLcl only via `sql -name prod_mcp`, `prod.` prefix, `SET DEFINE OFF`, CRLF files, keyword-free `--` banners, one INSERT per row for IDENTITY tables.

PC-specific DB notes:

- **Legacy status CHECK constraints are intentionally retained** as safety nets until PC adopts the lookup-first rule (`DCT_LOOKUP_VALUES` + `DCT_LOOKUP_PKG.validate_lookup`). Don't drop them as "cleanup".
- PC ORDS writes to the unified `DCT_REQUEST_STATUS_HISTORY` (Phase 2) — keep `(source_module, source_type, source_id)` discriminators intact.
- **PCH AI Clearing** (`PROD.DCT_PC_AI_PKG`, phases 1–3 deployed, VALID): API key was pending at build time; APEX pages 70/71/72/75 still pending in Builder. Latent bug: `APEX_JSON.STRINGIFY` has no CLOB overload — large CSV inputs (>32k) raise ORA-06502; use a CLOB-safe escaper (see `dct_ar_ai_pkg.json_escape_clob` for the pattern).

## 3. ORDS deployment

- Module under ADMIN schema at `/ords/admin/pc/`; ADMIN synonyms required for every PROD object used in handlers; fresh SQLcl session for the ORDS script.
- All protected handlers call `dct_rest.validate_session(:body)` first; Bearer token arrives in CGI `'AUTHORIZATION'` (no `HTTP_` prefix).
- ORDS base URL from OCI Console only.

## 4. Post-deploy smoke test

1. Open PC via the Admin module switcher — shared session carries over (no separate login).
2. Dashboard loads stats + 2 charts; brand green applied from `THEME_BRAND_COLOR`.
3. Create a draft request → appears in My Petty Cash; approver path: AYESHA (AP_PETTY_CASH_ADMIN) sees it in Pending Approvals.

## 5. Deployment history

- **2026-06-15 — Region header flush (PC APP_VERSION 4.5.3→4.5.4; shared/ change → all 8 apps bumped):** shared `platform.css` flush rule (see Admin/FL notes) removes the gap between every in-card header and the border. No PC markup change — pcRequest/pcDetail/clearDetail/reimbDetail main cards already use a first-child `.section-heading`, so they flush automatically; version bumped for the shared/ change. Frontend/CSS only.
- 2026-06 (Phase 1): PC ORDS live, JET switched to live mode.
- 2026-06-11: UAT seed data (PC 00005-00008, RMB-00100); approvals modal + lifecycle UAT-tested.
- 2026-06-13: UI sweep — Quick Actions moved to right rail on Home; all Save/Back/Cancel actions moved to top-right (platform rule). Frontend-only; requires APP_VERSION bump on next deploy.
- 2026-06-13: **Region appearance theme** — region/modal/table headers + card borders themed via `THEME_REGION_*` (db/v2/22 seeds PC override rows, NULL = inherit platform default; editable in Module Settings). Boots via `shell.initRegionTheme` in appController. APP_VERSION **4.3.0** (shared/ change, all 7 apps). Also fixed two pre-existing bugs found during verification: Module Settings rendered only 2 of 16 rows (APEX_JSON omits NULL fields → bare KO bindings threw on row 2; `_toObs` now defaults the bound keys) and `settingService.getValue(...).then` threw at boot (getValue is sync/mock-only — new `getValueAsync` used by the initBrand getter).
- **2026-06-13 — Module Settings redesign (APP_VERSION 4.4.0):** settings page restyled to match Admin System Settings — top-right Save, category cards, switch-row toggles, dirty tracking, alert banners, and a **Region Appearance** palette picker (module-level `THEME_REGION_*` override with live preview + AA-contrast check). New shared helper `shared/js/regionPicker.js` (used by all 7 apps → APP_VERSION bumped 4.3.0→4.4.0 everywhere). Region keys are read/written through this module's existing `/settings` endpoint.
- PC keeps its effective-date input + per-row reset-to-default, adapted into the new switch-row layout.
