# Human Resources Module (App 205) — Status

**Last updated:** 2026-06-10  
**App alias:** HR | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | 8 HR_* tables + DCT_EMPLOYEES/ORG alterations |
| DCT Alterations | ✅ Complete | 02_hr_dct_alterations.sql — grade, org, employee extensions |
| Views | ✅ Complete | HR views deployed |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, job families, grades |
| PL/SQL Package | ✅ Complete | DCT_HR_PKG spec + body |
| ORDS Module | ✅ Complete | `/ords/admin/hr/` — all endpoints live |
| JET SPA | ✅ Complete | 13 VMs, dual mock/ORDS mode |
| APEX App Shell | ⬜ Not started | Must be built in APEX Builder |
| APEX Pages | ⬜ Not started | Must be built in APEX Builder |

---

## DB Files (`final apps/HR/db/`)

| File | Status | Contents |
|---|---|---|
| `install.sql` | ✅ | Master install — runs 01→02→03→04→05→06 |
| `01_hr_ddl.sql` | ✅ Deployed | DDL: HR_JOB_FAMILIES, HR_JOBS, HR_POSITIONS, HR_CONTRACTS, HR_SALARY_GRADES, HR_SALARY_HISTORY, HR_DOCUMENTS, HR_DOCUMENT_TYPES |
| `02_hr_dct_alterations.sql` | ✅ Deployed | Alterations to DCT_EMPLOYEES (grade_id, org extensions), DCT_ORGANIZATIONS |
| `03_hr_views.sql` | ✅ Deployed | HR views: employee full view, org hierarchy, positions |
| `04_hr_seed.sql` | ✅ Deployed | Module registration, roles, permissions, settings, job families, grade seeding |
| `05_hr_pkg.sql` | ✅ Deployed | DCT_HR_PKG spec + body |
| `06_hr_ords.sql` | ✅ Deployed | ORDS module `hr.rest` at `/ords/admin/hr/` |
| `_archive/install_continue.sql` | Archive | Historical split-run artifact — use install.sql |
| `_archive/patch_grade_category_lookup.sql` | Archive | Applied to PROD — grade category constraint migration |

---

## APEX App 205 — Setup Checklist

| Component | Status | Notes |
|---|---|---|
| App shell (App 205) | ⬜ Not started | Create in APEX Builder |
| Subscribe DCT Auth scheme | ⬜ Not started | Shared Components → Auth Schemes → Subscribe from App 200 |
| Standard app items | ⬜ Not started | APP_USER_ID, APP_EMP_NUM, APP_EMP_NAME, APP_ORG_ID, APP_IS_ADMIN, APP_IS_MANAGER, APP_PENDING_APPROVAL_COUNT |
| HR-specific app items | ⬜ Not started | APP_IS_HR_ADMIN, APP_IS_HR_MANAGER |
| SET_APP_ITEMS process | ⬜ Not started | On New Session, standard block + HR extension |
| Common LOVs (9) | ⬜ Not started | Subscribe from App 200 |
| HR-specific LOVs | ⬜ Not started | LOV_HR_JOB_FAMILIES, LOV_HR_JOBS, LOV_HR_POSITIONS, LOV_HR_SALARY_GRADES, LOV_HR_DOCUMENT_TYPES, LOV_HR_CONTRACT_TYPES |
| Authorization schemes | ⬜ Not started | Subscribe standard from App 200; add IS_HR_ADMIN, IS_HR_MANAGER locally |

---

## JET SPA — `final apps/HR/Jet/`

| Service | ORDS Live | Notes |
|---|---|---|
| authService.js | ✅ | Reads/writes ifinance_jet_session |
| employeeService.js | ✅ | Full ORDS mode |
| orgService.js | ✅ | |
| jobService.js | ✅ | |
| hrDocService.js | ✅ | |
| All other services | ✅ | |

Config: `js/services/config.js` — set `apiBase: '/ords/admin/hr'` for live mode; run via `python dev-proxy.py`.

Note: `js/mock-assets/photos/` contains mock employee photos used by `mockData.js` in development only.

---

## Immediate Next Steps

1. **APEX Builder — create App 205 shell:**
   - New app: ID 205, alias `HR`, schema PROD, Theme 42
   - Subscribe to App 200's `DCT Auth` scheme → set as current
   - Add standard + HR-specific app items
   - Create `SET_APP_ITEMS` process (On New Session)
   - Subscribe common LOVs from App 200; define HR-specific LOVs locally

2. **Create APEX_PAGE_PLAN.md** in `docs/` — HR is the only module with a JET SPA but no APEX page plan. Document the page list before building in Builder.

3. **Build page content in APEX Builder** (recommended order):
   9999 → 1 → 10 → 11 → 12 → 20 → 21 → 30 → 40 → 50 → 60 → 70

---

## Key API Gotchas (learned during build)

| Issue | Fix |
|---|---|
| `dct_user_roles` date column | `end_date` (not `valid_to`) |
| `dct_auth.has_role` | Takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |
| HR photo upload | `PHOTO_URL` stores a relative ORDS path; serve via `/ords/admin/hr/employees/:id/photo` |
| Grade category | Stored in `DCT_LOOKUP_VALUES` as `LOOKUP_TYPE = 'GRADE_CATEGORY'`; no longer a CHECK constraint |
| Org chart | Uses adjacency list model (`parent_org_id` on DCT_ORGANIZATIONS); recursive CTE needed for tree |
| DCT_EMPLOYEES alterations | `grade_id` FK added by `02_hr_dct_alterations.sql`; must run before HR seed |
| APEX `WHENEVER SQLERROR ROLLBACK` | Rolls back ALL uncommitted blocks — fix all errors before running |
