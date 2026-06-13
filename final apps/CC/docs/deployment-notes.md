# Credit Cards (App 202) — Deployment Notes

> **Keep this file current: every deployment (frontend, DB, ORDS) must be recorded here.**

- **Module code:** CREDIT_CARDS · **ORDS base path:** `/ords/admin/cc/` · **Brand:** `#B0721E` (Amber)
- Depends on Admin (App 200) for auth — deploy/verify Admin first.

---

## 1. Frontend (JET SPA) deployment

- Bump `window.APP_VERSION` in `Jet/index.html` (currently `4.3.0`) — cache key for requirejs + i18n; mandatory per deploy.
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

- 2026-06-12 (Phase 4): `cc.rest` + 13-view JET app deployed live; seeded cards incl. CC-2026-00002 (20,000 AED, SHAIKHA.ALSUWAIDI); UAT 29 cases (29P automated run).
- 2026-06-13: wizard step buttons moved into the page header; register/proxy/replenishment modal footers moved into modal headers; inline approval confirm moved beside its label (platform top-right rule). Frontend-only; bump APP_VERSION on next deploy.
- 2026-06-13: **Region appearance theme** — headers + borders themed via `THEME_REGION_*` (db/v2/22 seeds CC override rows, NULL = inherit; rows listed in Module Settings). Boots via `shell.initRegionTheme` + `ccService.getSettings`. APP_VERSION **4.3.0** (shared/ change, all 7 apps). Module Settings SELECT options now split on `|` as well as `,` (seeded `allowed_values` are pipe-separated).
