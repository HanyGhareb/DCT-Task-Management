# Freelancers (App 203) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** FREELANCERS · **ORDS base path:** `/ords/admin/fl/` · **Brand:** `#7C4DBE` (Violet)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.5.4`) — cache key for requirejs + i18n; mandatory per deploy.
- **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").
- Deploy `final apps/shared/` alongside (`../shared/`). If shared/ changed, bump APP_VERSION in **all 7 apps**.
- `js/services/config.js` → live `apiBase`, never `null`.
- 17 views; FL appears in the module switcher (flipped live in Phase 4).

## 2. Database deployment (PROD schema, via SQLcl)

Run order = `db/install.sql`:

| Script | Contents |
|---|---|
| `01_fl_ddl.sql` → `04_fl_pkg.sql` | FL tables, views, seed, base package |
| `05_fl_alter_audit_cols.sql` | Audit columns |
| `06_fl_unified_adoption.sql` | ⚠ **One-way migration** — drops FL's private doc/attachment/line tables; FL uses unified `DCT_DOCUMENTS`/`DCT_BUDGET_CODING_LINES`/`DCT_REQUEST_STATUS_HISTORY` natively. Never re-create the dropped tables. |
| `07_fl_pkg_workflow.sql` | `DCT_FL_PKG` workflow engine (registration → contract → voucher lifecycle) |
| `08_fl_ords.sql` | ORDS module — run in a **fresh SQLcl session** (synonym ORA-01471 gotcha) |
| `10_fl_reg_documents.sql` | Registration required-documents: `DOCS_REQUIRED_FOR_SUBMIT` setting + `DCT_DOC_REQUIREMENTS` rows (context `REGISTRATION`). Data-only + idempotent (MERGE); own session. |

Platform SQLcl rules apply (see `final apps/Admin/docs/deployment-notes.md` §2).

FL-specific DB notes:

- **Convention:** `dct_documents.reference_id` carries the `freelancer_id` for FL rows.
- FL is lookup-first — status value sets live in `DCT_LOOKUP_VALUES`; no status CHECK constraints on new tables. Handlers call `DCT_LOOKUP_PKG.validate_lookup`.
- Approval routing: FL Manager, FL Admin joins above AED 50,000 (contract submit).

## 3. ORDS deployment

- Module `fl.rest` under ADMIN schema at `/ords/admin/fl/`; ADMIN synonyms; fresh session for the ORDS script.
- `validate_session` first in every protected handler; CGI `'AUTHORIZATION'` key (no `HTTP_` prefix).
- `:body` may only be dereferenced ONCE per handler — assign to a local first.

## 4. Post-deploy smoke test

1. Open FL from the Admin module switcher; violet brand loads from `THEME_BRAND_COLOR`.
2. Registration → Save Draft → Submit for Approval; unified inbox (Admin + FL approvals page) shows the pending step, delegation-aware (`actingFor`).
3. Contract amendment/renewal modals create drafts; voucher Confirm Payment (admin) works.

## 5. Deployment history

- 2026-06-12 (Phase 4): `fl.rest` + 17-view JET app deployed live; Stage 6 seed (roles + 84k contract); UAT 35 cases (34P/1PARTIAL automated run).
- dct_auth delegation made ADDITIVE; registrationEdit lookup race fixed (UAT round).
- 2026-06-13: Save Draft/Submit moved to page headers; 5 modal footers moved into modal headers (platform top-right rule). Frontend-only; bump APP_VERSION on next deploy.
- 2026-06-13 (APP_VERSION 4.2.1): FL-CMP-02 fix (compliance doc row deep-links to Documents tab via one-shot `flDetailTab` sessionStorage key); `formGuard.track()` adopted in registrationEdit/contractEdit/voucherDetail; bulk voucher generation — new `POST /fl/schedule/bulk-generate` handler in `08_fl_ords.sql` (403 unless `ALLOW_BULK_VOUCHER_GENERATION=Y`; ≤100 rows/run; skips rows with open vouchers) + "Generate All Due" page action on Payment Schedule. ⚠ Requires rerun of `08_fl_ords.sql` (fresh SQLcl session).
- 2026-06-13: **Region appearance theme** — headers + borders themed via `THEME_REGION_*` (db/v2/22 seeds FL override rows, NULL = inherit; rows listed in Module Settings). Boots via `shell.initRegionTheme` + `flService.getSettings`. APP_VERSION **4.3.0** (shared/ change, all 7 apps). Module Settings SELECT options now split on `|` as well as `,` (seeded `allowed_values` are pipe-separated). Note: the new `Portal/` SPA has its own styling and is NOT covered by the region theme.
- 2026-06-13 (deployed): FL-CMP-02 fix + formGuard + bulk voucher generation live — `08_fl_ords.sql` rerun, UAT extended to **40 cases, 40/40 PASS** (`UAT/UAT_FL_Results_13-Jun-2026-01.docx`). FL UAT data cleanup script at `db/v2/23_fl_uat_cleanup.sql` (run after UAT passes; preserves seeded samples).
- 2026-06-13 (deployed): **Freelancer Self-Service Portal Phase 1** — new SPA at `Portal/` (plain KO, no requirejs, EN/AR; own `ifinance_portal_session` key, APP_VERSION 1.0.0 in `Portal/index.html`). DB: `09_fl_portal.sql` (portal columns on freelancers, `DCT_FL_PORTAL_INVITES`/`DCT_FL_PORTAL_SESSIONS`, `DCT_FL_PORTAL_PKG`, `FL_PORTAL_STATUS` lookup, `FEATURE_FL_PORTAL`/`PORTAL_SESSION_HOURS`/`PORTAL_INVITE_EXPIRY_HOURS` settings). ORDS: `/fl/portal/*` handlers + staff `POST /fl/freelancers/:id/portal-invite` (FL_ADMIN). **Security model: portal identities are NOT DCT_USERS** — portal tokens only open `/fl/portal/*`; staff tokens are refused there (verified both ways). Kill switch `FEATURE_FL_PORTAL` (currently Y for demo). Dev URL: `http://localhost:8080/FL/Portal/index.html` via the FL dev-proxy (proxy now also serves `/<App>/Portal/`).
- **2026-06-13 — Module Settings redesign (APP_VERSION 4.4.0):** settings page restyled to match Admin System Settings — top-right Save, category cards, switch-row toggles, dirty tracking, alert banners, and a **Region Appearance** palette picker (module-level `THEME_REGION_*` override with live preview + AA-contrast check). New shared helper `shared/js/regionPicker.js` (used by all 7 apps → APP_VERSION bumped 4.3.0→4.4.0 everywhere). Region keys are read/written through this module's existing `/settings` endpoint.
- **2026-06-15 — Registration field validation (FL APP_VERSION 4.5.1):** new-registration form had NO format validation (only presence of name/DOB/nationality/email). Added two-layer validation: **client** (`Jet/js/viewModels/registrationEdit.js`) and **server** (`db/07_fl_pkg_workflow.sql` `submit_registration`, errors `-20133…-20139`, recompiled in PROD — spec+body VALID). Rules: email format (becomes portal login), DOB not future + age ≥ 18, Emirates ID `784`+15 digits (required for AE nationals — pre-existing `-20131`), passport 6–12 alnum, at least one of Emirates ID/passport, mobile 7–15 digits intl-friendly.
  - **Client UX = inline per-field validation:** field validators in a `V` map + a `self.err.<field>` observable each; fired on **blur** (`change` for the nationality select) via `self.checkField(name)`, showing a red border (`.form-control--error`) and a message under the field (`.field-error`). `validate(opts)` has two modes: **Submit = full** (required + format + at-least-one-ID); **Save Draft = `{draft:true}`** = format-only (blank fields allowed, but any value entered must be well-formed). Both block on error (FL 4.5.3; 4.5.1 left Save fully lenient, 4.5.2 gated Save completely, 4.5.3 settled on format-only for drafts).
  - **Shared CSS:** added `.form-control--error` / `.field-error` to `final apps/shared/css/platform.css` (additive, no existing page uses them) → per convention bumped **APP_VERSION in all apps**: FL 4.5.0→4.5.1, AR/PC/HR/Admin/CC/DT 4.5.0→4.5.1, TM 4.6.1→4.6.2 (FL Portal excluded — separate SPA, doesn't load platform.css).
  - DB recompile only (no ORDS/synonym change). Note: submit ORDS handler still returns these as HTTP 500 with message (same as existing `-2013x`); 400-mapping not added.
- **2026-06-15 — Registration required documents (FL APP_VERSION 4.5.4):** registration page now collects the **required documents** (passport always; Emirates ID if AE or ID entered; residence visa for non-AE; bank letter) before Submit, with a right-side **How to Complete** instructions panel. All layers deployed + verified in PROD:
  - **DB:** `db/10_fl_reg_documents.sql` (NEW, idempotent) seeds setting `DOCS_REQUIRED_FOR_SUBMIT=Y` + 4 `DCT_DOC_REQUIREMENTS` rows (context `REGISTRATION`). `db/07_fl_pkg_workflow.sql` recompiled: `submit_registration` raises **`-20142`** listing any missing mandatory docs (gated by the setting; conditional applicability for Emirates ID / visa applied in code); `create_freelancer_profile` (also mirrored in `04_fl_pkg.sql`) re-points the registration's docs to the new freelancer on approval (source_type REGISTRATION→FREELANCER). Spec+body VALID.
  - **ORDS (`08_fl_ords.sql`, rerun fresh session):** `GET /registrations/:id/documents`, `GET /doc-requirements?context=…`, `DELETE /documents/:id` (soft delete `is_active='N'`). Synonyms `DCT_DOC_REQUIREMENTS`/`DCT_DOCUMENTS`/`DCT_DOCUMENT_TYPES` already existed.
  - **Frontend (FL-only, no shared/ change):** registrationEdit two-column layout (`.reg-layout` in `css/app.css`) — left form, right `<aside>` with the document checklist (upload/replace/remove/view per item, ✓/missing status, conditional rows by nationality) + instructions. flService: `getDocRequirements`/`getRegistrationDocuments`/`deleteDocument`. Submit blocked until mandatory applicable docs attached (mirrors server). ⚠ **Document file size cap ~24 KB** (the shared `documents/:id/file` PUT binds `VARCHAR2(32767)`): images are auto-downscaled; larger PDFs are rejected client-side. Lift later by switching that handler to a CLOB bind if real scans are needed.
