# Freelancers Module (App 203) — Status

**Last updated:** 2026-06-12 (Phase 4)  
**App alias:** FL | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | FL_* tables, sequences, triggers |
| Views | ✅ Complete | 02_fl_views.sql deployed (created_by joins on username) |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, lookups |
| PL/SQL Package | ✅ Complete | DCT_FL_PKG incl. Phase 4 workflow engine (6 submit_* + act_on_approval) |
| Audit Column Alterations | ✅ Complete | 05_fl_alter_audit_cols.sql |
| ORDS REST | ✅ Complete | `fl.rest` live at `/ords/admin/fl/` (~52 handlers); smoke 27/27 |
| JET SPA | ✅ Complete | `Jet/` live, 17 views, brand #7C4DBE, browser check clean |
| UAT workbook | ✅ Generated | `UAT/UAT_FL_TestScript.xlsx` — 35 cases / 10 areas |
| APEX App Shell | ⬜ Not started | Must be built in APEX Builder |
| APEX Pages | ⬜ Not started | Must be built in APEX Builder |

---

## DB Files (`final apps/FL/db/`)

| File | Status | Contents |
|---|---|---|
| `install.sql` | ✅ | Master install — runs 01→08 (07/08 in fresh sessions) |
| `01_fl_ddl.sql` | ✅ Deployed | DDL: FL_* tables, sequences, triggers |
| `02_fl_views.sql` | ✅ Deployed | FL views |
| `03_fl_seed.sql` | ✅ Deployed | Module registration, roles, permissions, settings, lookups |
| `04_fl_pkg.sql` | ✅ Deployed | DCT_FL_PKG spec + body |
| `05_fl_alter_audit_cols.sql` | ✅ Deployed | Added audit columns (created_by/at, updated_by/at) |
| `07_fl_pkg_workflow.sql` | ✅ Deployed | Phase 4: submit_registration/contract/amendment/voucher/renewal/profile_change + act_on_approval (50k AMOUNT step) |
| `08_fl_ords.sql` | ✅ Deployed | Phase 4: `fl.rest` module + ADMIN synonyms (run in a FRESH session) |

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

## JET SPA — Live (Phase 4, 2026-06-12)

`final apps/FL/Jet/` — 17 view/VM pairs on the Phase 3 shared layer, brand
#7C4DBE (live from THEME_BRAND_COLOR): dashboard (committed-vs-paid +
doc-expiry charts), registrations (+photo-gated submit), freelancers
(+4-tab detail: profile/bank/contracts/documents), contracts (+GL/PROJECT
edit, schedule/amendments/renewals detail, generate voucher), payment
schedule worklist, vouchers (invoice→submit→mark-paid), deliverables
(accept/reject), compliance documents (expiry filter + badge), approvals
(comment-mandatory, delegation `actingFor`), module settings, notifications.
Run locally: `python Jet/dev-proxy.py` → http://localhost:8080 (or enter via
the Admin module switcher — FL is live there).

UAT: `UAT/UAT_FL_TestScript.xlsx` (35 cases). Test scripts:
`assessment-3/phase4/tests/` (smoke + Playwright + seed).

---

## Immediate Next Steps

1. **UAT round** with the seeded personas (AYESHA = FL_ADMIN, NASER =
   FL_MANAGER, SHAIKHA.GALAMERI = FL_USER).
2. **APEX Builder — create App 203 shell** (unchanged checklist above).
3. **Deferred:** freelancer self-service portal (FL_FREELANCER) — Phase 4.5/5.

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

## Automated UAT (2026-06-12) - assessment-3/phase4/tests/uat_run_fl.py
- All 35 workbook cases (UAT_FL_*.xlsx) executed by Playwright against the live app; result 34 PASS / 1 PARTIAL / 0 FAIL.
- Word report with one evidence screenshot per case: UAT/UAT_FL_Results_12-Jun-2026-04.docx (+ evidence_12-Jun-2026-04/).
- Defects found and FIXED during the run:
  - DCT_AUTH delegation substitution: an active delegation made the delegate LOSE their own roles in has_role/has_permission/has_module_access (AYESHA lost FL_ADMIN while covering NASER). Now additive - own authority first, delegator fallback (db/v2/03 redeployed, user-approved).
  - registrationEdit.js lookup race: nationalities options arriving after the record bound reset the Nationality select to the caption, silently dropping the value and blocking submit. Lookups now load before the record (contractEdit pattern).
- Open minor finding (PARTIAL FL-CMP-02): Compliance > Documents row click opens the freelancer on the Profile tab, not the Documents tab.
- Run data note: the seeded 84k FL-CON-000002 was consumed (approved) by pass 1; the runner now self-seeds a >=50k contract when needed. A dangling DRAFT voucher FL-VCH-000002 (FL-CON-000001, July) remains from pass 1.
