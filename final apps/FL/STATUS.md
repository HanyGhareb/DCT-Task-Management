# Freelancers Module (App 203) — Status

**Last updated:** 2026-06-10  
**App alias:** FL | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | FL_* tables, sequences, triggers |
| Views | ✅ Complete | 02_fl_views.sql deployed |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, lookups |
| PL/SQL Package | ✅ Complete | DCT_FL_PKG spec + body |
| Audit Column Alterations | ✅ Complete | 05_fl_alter_audit_cols.sql |
| JET SPA | ⬜ Not started | No Jet/ folder yet |
| APEX App Shell | ⬜ Not started | Must be built in APEX Builder |
| APEX Pages | ⬜ Not started | Must be built in APEX Builder |

---

## DB Files (`final apps/FL/db/`)

| File | Status | Contents |
|---|---|---|
| `install.sql` | ✅ | Master install — runs 01→02→03→04→05 |
| `01_fl_ddl.sql` | ✅ Deployed | DDL: FL_* tables, sequences, triggers |
| `02_fl_views.sql` | ✅ Deployed | FL views |
| `03_fl_seed.sql` | ✅ Deployed | Module registration, roles, permissions, settings, lookups |
| `04_fl_pkg.sql` | ✅ Deployed | DCT_FL_PKG spec + body |
| `05_fl_alter_audit_cols.sql` | ✅ Deployed | Added audit columns (created_by/at, updated_by/at) |

---

## APEX App 203 — Setup Checklist

| Component | Status | Notes |
|---|---|---|
| App shell (App 203) | ⬜ Not started | Create in APEX Builder |
| Subscribe DCT Auth scheme | ⬜ Not started | Shared Components → Auth Schemes → Subscribe from App 200 |
| Standard app items | ⬜ Not started | APP_USER_ID, APP_EMP_NUM, APP_EMP_NAME, APP_ORG_ID, APP_IS_ADMIN, APP_IS_MANAGER, APP_PENDING_APPROVAL_COUNT |
| FL-specific app items | ⬜ Not started | APP_IS_FL_ADMIN, APP_IS_FL_FINANCE |
| SET_APP_ITEMS process | ⬜ Not started | On New Session, standard block + FL extension |
| Common LOVs (9) | ⬜ Not started | Subscribe from App 200 |
| FL-specific LOVs | ⬜ Not started | LOV_FL_CONTRACT_TYPE, LOV_FL_PAYMENT_METHOD, LOV_FL_STATUS |
| Authorization schemes | ⬜ Not started | Subscribe standard from App 200; add IS_FL_ADMIN, IS_FL_FINANCE locally |

---

## JET SPA — Not Started

No `Jet/` folder exists. Freelancers module is currently APEX-only.

To start the JET SPA:
1. Create `final apps/FL/Jet/` by copying the HR module structure as a template
2. Update branding (brand-cube `FL`, title, brand-name)
3. Add `apiBase: '/ords/admin/fl'` in `config.js`
4. Scaffold VMs following `final apps/SHARED_JET_ARCHITECTURE.md`

---

## Immediate Next Steps

1. **APEX Builder — create App 203 shell:**
   - New app: ID 203, alias `FL`, schema PROD, Theme 42
   - Subscribe to App 200's `DCT Auth` scheme → set as current
   - Add standard + FL-specific app items
   - Create `SET_APP_ITEMS` process (On New Session)
   - Subscribe common LOVs from App 200; define FL-specific LOVs locally

2. **Build page content in APEX Builder** — document page list in `docs/` first.

3. **JET SPA** — decide whether to build JET SPA or remain APEX-only. If JET, scaffold `Jet/` from HR template.

---

## Key API Gotchas (learned during build)

| Issue | Fix |
|---|---|
| `dct_user_roles` date column | `end_date` (not `valid_to`) |
| `dct_auth.has_role` | Takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |
| `dct_lookup_values` columns | `value_code` / `value_name_en` / `display_order` |
| FL audit columns | Added in step 5 (after package) — run 05 before testing package procs that set audit cols |
| APEX `WHENEVER SQLERROR ROLLBACK` | Rolls back ALL uncommitted blocks — fix all errors before running |
| ORDS handlers | All execute as ADMIN; every PROD object needs an `ADMIN` synonym if not already present |

## Phase 2 update (2026-06-11) - unified-structure adoption (assessment-3/phase2/)
- Documents -> unified DCT_DOCUMENTS (convention: reference_id = freelancer_id); expiry alerts -> DCT_DOC_EXPIRY_ALERTS; doc types now resolve from DCT_DOCUMENT_TYPES (FL_DOCUMENT_TYPE lookup deactivated; TRADE_LICENSE/QUALIFICATION/DELIVERABLE_DOC added to the master).
- Dropped: DCT_FL_DOCUMENTS, DCT_FL_DOC_EXPIRY_ALERTS (both empty). New script: 06_fl_unified_adoption.sql (run after db/v2/15, then re-run 02 + 04).
- New DCT_FL_PKG.MIRROR_CONTRACT_CODING mirrors header coding into DCT_BUDGET_CODING_LINES (FL_CONTRACT, line 1); called from CREATE_RENEWED_CONTRACT and by future contract-approval flows.
- All 17 FL status/type CHECKs dropped (lookup-first); 12 FL_* lookup categories seeded; natural-key FKs added on contracts/renewals/vouchers + bank_code FK on bank accounts.
- Drift fixed: DCT_FL_REGISTRATION_V / DCT_FL_CONTRACT_V were INVALID in PROD (nationality_en column name) - repaired; all 9 FL objects VALID.
