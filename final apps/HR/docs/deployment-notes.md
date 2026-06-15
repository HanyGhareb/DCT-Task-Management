# HR (App 205) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** HR · **ORDS base path:** `/ords/admin/hr/` · **Brand:** `#00695C` (Teal)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.4.0`) — cache key for requirejs + i18n; mandatory per deploy.
- **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").
- Deploy `final apps/shared/` alongside (`../shared/`). If shared/ changed, bump APP_VERSION in **all 7 apps**.
- `js/services/config.js` → live `apiBase`, never `null`.

## 2. Database deployment (PROD schema, via SQLcl)

Run order = `db/install.sql`:

| Script | Contents |
|---|---|
| `01_hr_ddl.sql` | 8 HR_* tables |
| `02_hr_dct_alterations.sql` | ⚠ **Alters shared tables** (`DCT_EMPLOYEES`, `DCT_ORG`) used by PC/DT/FL — coordinate before re-running; never run blindly on a refresh |
| `03_hr_views.sql` → `05_hr_pkg.sql` | Views, seed, `DCT_HR_PKG` |
| `06_hr_ords.sql` | ORDS module — run in a **fresh SQLcl session** (synonym ORA-01471 gotcha) |

Platform SQLcl rules apply (see `final apps/Admin/docs/deployment-notes.md` §2).

HR-specific DB notes:

- Employee photos use the base64/media pattern (b64 payload ≤ 30k) — same as DCT_USERS photos (db/v2/17).
- Salary history is an **immutable ledger** — no UPDATE/DELETE handlers; don't add them.

## 3. ORDS deployment

- Module under ADMIN schema at `/ords/admin/hr/`; ADMIN synonyms; fresh session for the ORDS script.
- `validate_session` first in every protected handler; CGI `'AUTHORIZATION'` key (no `HTTP_` prefix).
- ⚠ **Latent bug:** HR's `documents/file` PUT dereferences `:body` more than once. On ADB ORDS, `:body` may only be dereferenced ONCE (assign to a local BLOB first) — the AR module hit this as silent-empty JSON + ORA-01400. Fix before relying on HR document file upload.

## 4. Post-deploy smoke test

1. Open HR from the Admin module switcher; brand teal loads from `THEME_BRAND_COLOR`.
2. Employee directory paginates (server-side, Phase 3); employee detail tabs render (Overview/Assignments/Contracts/Salary/Documents).
3. Add/Edit Employee modal saves; photo upload round-trips.

## 5. Deployment history

- **2026-06-15 — Region header flush + missing region headers (HR APP_VERSION 4.5.3→4.5.4; shared/ change → all 8 apps bumped):** shared `platform.css` flush rule (see Admin/FL notes) removes the gap between every in-card header and the border. Normalized the four employeeDetail tab faux-headers (Assignment History / Employment Contracts / Salary History / Employee Documents) into themed `.section-heading-row`s with the add-buttons in `.region-actions`; the Overview tab's existing `.section-heading` flushes automatically. Frontend/CSS only — no DB/ORDS change.
- DB + ORDS 100% deployed (`hr.rest` at `/ords/admin/hr/`); JET SPA live; APEX pages pending in Builder.
- 2026-06-11: UAT lifecycle data E1101-03; hr-employees server pagination (Phase 3).
- 2026-06-13: all modal Save/Cancel actions moved into modal headers, employeeDetail + 7 setup pages (platform top-right rule). Frontend-only; bump APP_VERSION on next deploy.
- 2026-06-13: **Region appearance theme** — headers + borders themed via `THEME_REGION_*` (db/v2/22). HR has **no module-settings endpoint** → system default only (`shell.initRegionTheme` without a module getter); wiring a `/hr/settings` GET later enables the per-module override automatically. APP_VERSION **4.3.0** (shared/ change, all 7 apps).
- **2026-06-13 — Module Settings redesign (APP_VERSION 4.4.0):** settings page restyled to match Admin System Settings — top-right Save, category cards, switch-row toggles, dirty tracking, alert banners, and a **Region Appearance** palette picker (module-level `THEME_REGION_*` override with live preview + AA-contrast check). New shared helper `shared/js/regionPicker.js` (used by all 7 apps → APP_VERSION bumped 4.3.0→4.4.0 everywhere). Region keys are read/written through this module's existing `/settings` endpoint.
- **2026-06-13 — HR `/settings` ORDS added:** `06_hr_ords.sql` now defines `GET /settings` + `PUT /settings/:id` (HR_ADMIN/SYS_ADMIN only) over `DCT_MODULE_SETTINGS` for module_code `HR`, plus ADMIN synonyms `dct_module_settings`/`dct_modules`/`dct_rest`/`dct_auth`. **Redeploy `06_hr_ords.sql` in a fresh SQLcl session** (it DELETE_MODULEs + recreates `hr.rest`). `hrService.getSettings/updateSetting` added. THEME_REGION rows come from `db/v2/22`.
- **2026-06-15 — Document upload bind standardized to `:body` (HR APP_VERSION 4.5.3; shared/ change bump only):** `documents/file/:id` PUT was using **`:body_blob`**, which binds as VARCHAR2 on this ADB's ORDS version (PLS-00382 / silent truncation risk per the AR note). Rewritten to `l_blob := :body` (deref ONCE) + a `MAX_UPLOAD_MB` size guard (default 10 → HTTP 413; seeded for HR by `db/v2/27_max_upload_mb.sql`) + 404 on missing row. **HR was already binary** (`hrService.uploadDocFile` sends `file.arrayBuffer()` raw with `file_name`/`file_mime_type` query params) so NO frontend change — the handler fix is the only HR change. Redeploy `06_hr_ords.sql` in a fresh SQLcl session. Verified handler source = binary `:body`.
