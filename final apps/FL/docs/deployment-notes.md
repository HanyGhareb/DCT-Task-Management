# Freelancers (App 203) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** FREELANCERS · **ORDS base path:** `/ords/admin/fl/` · **Brand:** `#7C4DBE` (Violet)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.3.0`) — cache key for requirejs + i18n; mandatory per deploy.
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
