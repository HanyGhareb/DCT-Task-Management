# Credit Cards (App 202) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** CREDIT_CARDS · **ORDS base path:** `/ords/admin/cc/` · **Brand:** `#B0721E` (Amber)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.4.0`) — cache key for requirejs + i18n; mandatory per deploy.
- **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").
- Deploy `final apps/shared/` alongside (`../shared/`). If shared/ changed, bump APP_VERSION in **all 7 apps**.
- `js/services/config.js` → live `apiBase`, never `null`.
- 13 views; CC appears in the module switcher (flipped live in Phase 4).

## 2. Database deployment (PROD schema, via SQLcl)

Run order = `db/install.sql`:

| Script | Contents |
|---|---|
| `01_cc_ddl.sql` → `04_cc_pkg.sql` | CC tables, views, seed, `DCT_CC_PKG` (all business logic lives here) |
| `05_cc_alter_audit_cols.sql` → `07_cc_consolidate_delegation.sql` | Audit cols, card-limit history, delegation consolidation |
| `08_cc_unified_adoption.sql` | ⚠ **One-way migration** — drops CC's private doc/line tables; CC uses unified `DCT_DOCUMENTS`/`DCT_BUDGET_CODING_LINES`/`DCT_REQUEST_STATUS_HISTORY` natively. Never re-create the dropped tables. |
| `09_cc_ords.sql` | ORDS module — run in a **fresh SQLcl session** (synonym ORA-01471 gotcha) |

Platform SQLcl rules apply (see `final apps/Admin/docs/deployment-notes.md` §2).

CC-specific DB notes:

- ORDS handlers are **thin wrappers over `DCT_CC_PKG`** — put new logic in the package, not in handler PL/SQL.
- CC is lookup-first — no status CHECK constraints; handlers/package call `DCT_LOOKUP_PKG.validate_lookup`.
- Card registration consumes an approved NEW_CARD request; doc requirements drive the mandatory-upload gate before submit.

## 3. ORDS deployment

- Module `cc.rest` under ADMIN schema at `/ords/admin/cc/`; ADMIN synonyms; fresh session for the ORDS script.
- `validate_session` first in every protected handler; CGI `'AUTHORIZATION'` key (no `HTTP_` prefix).
- `:body` may only be dereferenced ONCE per handler — assign to a local first.
- Document file PUTs use base64 (`file_data_b64`) — raw-binary handlers must respond via `:status_code` only.

## 4. Post-deploy smoke test

1. Open CC from the Admin module switcher; amber brand loads from `THEME_BRAND_COLOR`.
2. New Request wizard: type → details → Save Draft & Continue → docs gate → Submit for Approval (button disabled until mandatory docs uploaded).
3. Replenishment draft + lines save; unified inbox shows pending CC steps (delegation-aware).

## 5. Deployment history

- **2026-06-15 — Region header flush + missing region headers (CC APP_VERSION 4.5.3→4.5.4; shared/ change → all 8 apps bumped):** shared `platform.css` flush rule (see Admin/FL notes) removes the gap between every in-card header and the border. Added/normalized themed headers: requestDetail (Request Details; flushed Documents), requestNew (Request Details on step 2; flushed doc step), replenishmentDetail (normalized Merchant Expense Lines into `.section-heading-row` + Submission Details), myCard (Card Details — new `card.details` i18n key EN+AR). Frontend/CSS only — no DB/ORDS change.
- 2026-06-12 (Phase 4): `cc.rest` + 13-view JET app deployed live; seeded cards incl. CC-2026-00002 (20,000 AED, SHAIKHA.ALSUWAIDI); UAT 29 cases (29P automated run).
- 2026-06-13: wizard step buttons moved into the page header; register/proxy/replenishment modal footers moved into modal headers; inline approval confirm moved beside its label (platform top-right rule). Frontend-only; bump APP_VERSION on next deploy.
- 2026-06-13: **Region appearance theme** — headers + borders themed via `THEME_REGION_*` (db/v2/22 seeds CC override rows, NULL = inherit; rows listed in Module Settings). Boots via `shell.initRegionTheme` + `ccService.getSettings`. APP_VERSION **4.3.0** (shared/ change, all 7 apps). Module Settings SELECT options now split on `|` as well as `,` (seeded `allowed_values` are pipe-separated).
- **2026-06-13 — Module Settings redesign (APP_VERSION 4.4.0):** settings page restyled to match Admin System Settings — top-right Save, category cards, switch-row toggles, dirty tracking, alert banners, and a **Region Appearance** palette picker (module-level `THEME_REGION_*` override with live preview + AA-contrast check). New shared helper `shared/js/regionPicker.js` (used by all 7 apps → APP_VERSION bumped 4.3.0→4.4.0 everywhere). Region keys are read/written through this module's existing `/settings` endpoint.
- **2026-06-15 — Binary document upload, ~24 KB cap REMOVED (CC APP_VERSION 4.5.3; shared/ change):** `documents/:id/file` PUT rewritten from base64-in-`VARCHAR2(32767)` to **raw bytes from `:body`** (deref ONCE), guarded by new **`MAX_UPLOAD_MB`** setting (default 10 → HTTP 413). `requestNew.js` `pickFile` now uses shared `docUpload.choose()` → `ccService.uploadDocumentFile(id, file)` (`putBinary`; signature `(id,b64,mime)`→`(id,file)`). Shared layer: `api.putBinary`/`fetchBlobUrl`, `shared/js/docUpload.js` `<doc-upload>`, `.docup-*`, `docup.*` i18n; registered `shared/docUpload` in `main.js`. DB: `db/v2/27_max_upload_mb.sql` (seeds CREDIT_CARDS) + `09_cc_ords.sql` rerun (fresh session). **Verified live: 1.2 MB round-trip OK.**
