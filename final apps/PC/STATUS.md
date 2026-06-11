# Petty Cash Module (App 201) — Status

**Last updated:** 2026-06-11  
**App alias:** PC | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | PC_* tables, shared alterations to DCT_* tables |
| Views | ✅ Complete | 02_pc_views.sql deployed |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, lookups |
| PL/SQL Package | ✅ Complete | DCT_PC_PKG + DCT_PC_AI_PKG (AI clearing) |
| Alterations | ✅ Complete | 05_pc_alter.sql — added audit cols |
| ORDS Module | ✅ Complete | 06_pc_ords.sql — pc.rest at `/ords/admin/pc/` (deployed 2026-06-11, smoke-tested 15/15) |
| APEX App Shell | ⬜ Not started | Must be built in APEX Builder |
| JET SPA | ✅ **LIVE** | All VMs; config points at ADB ORDS (`apiBase`/`authBase`, DT convention) |
| APEX Pages | ⬜ Not started | Must be built in APEX Builder |

---

## DB Files (`final apps/PC/db/`)

| File | Status | Contents |
|---|---|---|
| `install.sql` | ✅ | Master install — runs 00→01→02→03→04→05 |
| `00_shared_alterations.sql` | ✅ Deployed | Shared DCT_* table alterations required by PC module |
| `01_pc_ddl.sql` | ✅ Deployed | DDL: PC_* tables, sequences, triggers |
| `02_pc_views.sql` | ✅ Deployed | PC views |
| `03_pc_seed.sql` | ✅ Deployed | Module registration, roles, permissions, settings, lookups |
| `04_pc_pkg.sql` | ✅ Deployed | DCT_PC_PKG spec + body; DCT_PC_AI_PKG (AI expense clearing) |
| `05_pc_alter.sql` | ✅ Deployed | Audit column additions |
| `06_pc_ords.sql` | ✅ Deployed | ORDS module `pc.rest` at `/ords/admin/pc/` — 26 handlers; secrets masked in settings; login/logout live on Admin `/dct` module |

---

## APEX App 201 — Setup Checklist

| Component | Status | Notes |
|---|---|---|
| App shell (App 201) | ⬜ Not started | Create in APEX Builder |
| Subscribe DCT Auth scheme | ⬜ Not started | Shared Components → Auth Schemes → Subscribe from App 200 |
| Standard app items | ⬜ Not started | APP_USER_ID, APP_EMP_NUM, APP_EMP_NAME, APP_ORG_ID, APP_IS_ADMIN, APP_IS_MANAGER, APP_PENDING_APPROVAL_COUNT |
| PC-specific app items | ⬜ Not started | APP_IS_PC_ADMIN, APP_ACTIVE_PC_ID |
| SET_APP_ITEMS process | ⬜ Not started | On New Session, standard block + PC extension |
| Common LOVs (9) | ⬜ Not started | Subscribe from App 200 |
| PC-specific LOVs | ⬜ Not started | LOV_GL_ENTITY_CODE, LOV_GL_APPROPRIATION, LOV_PROJECT_NUMBER, LOV_TASK_NUMBER, LOV_EXPENDITURE_TYPE |
| Authorization schemes | ⬜ Not started | Subscribe standard from App 200; add IS_PC_ADMIN, IS_OWN_PC locally |

---

## JET SPA — `final apps/PC/Jet/`

| Service | ORDS Live | Notes |
|---|---|---|
| authService.js | ✅ | Reads/writes ifinance_jet_session |
| pcService.js | ✅ | Full ORDS mode |
| userService.js | ✅ | |
| All other services | ✅ | |

Config: `js/services/config.js` — set `apiBase: '/ords/admin/pc'` for live mode; run via `python dev-proxy.py`.

---

## Immediate Next Steps

1. **APEX Builder — create App 201 shell:**
   - New app: ID 201, alias `PC`, schema PROD, Theme 42
   - Subscribe to App 200's `DCT Auth` scheme → set as current
   - Add standard + PC-specific app items
   - Create `SET_APP_ITEMS` process (On New Session)
   - Subscribe common LOVs from App 200; define PC-specific LOVs locally

2. **Build page content in APEX Builder** (recommended order):
   9999 → 1 → 10 → 11 → 12 → 20 → 30 → 40 → 50 → 60 → 70

3. **Navigation menu** — Shared Components → Navigation Menu

---

## Key API Gotchas (learned during build)

| Issue | Fix |
|---|---|
| `dct_user_roles` date column | `end_date` (not `valid_to`) |
| `dct_auth.has_role` | Takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |
| `dct_lookup_values` columns | `value_code` / `value_name_en` / `display_order` |
| `dct_gl_code_combinations` | No `cc_concat_segments` — concatenate 9 segment codes manually |
| PC install order | Views (step 2) before seed (step 3) — reverse of other modules |
| AI clearing (DCT_PC_AI_PKG) | API key must be set in DCT_SYSTEM_SETTINGS before AI features work |
| APEX `WHENEVER SQLERROR ROLLBACK` | Rolls back ALL uncommitted blocks — fix all errors before running |

## Phase 2 update (2026-06-11) - status history wiring (assessment-3/phase2/)
- pc.rest redeployed: create (PC/reimb/clearing), disburse, and approval-action handlers now append rows to the unified DCT_REQUEST_STATUS_HISTORY (source_module 'PC'; source_type PC / PC_REIMB / PC_CLEAR). Verified live with PC-2026-00004 (SUBMITTED -> REJECTED, 2 history rows).
- Natural-key FKs validated on all 3 budget-line tables (project_number/task_number -> DCT_PROJECTS/DCT_TASKS, expenditure_type -> DCT_EXPENDITURE_TYPES).
- 6 PC_* lookup categories seeded (lookup-first); table CHECKs retained as safety nets until PC fully adopts.
