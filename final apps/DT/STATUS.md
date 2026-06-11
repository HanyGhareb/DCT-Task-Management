# Duty Travel Module (App 204) — Status

**Last updated:** 2026-05-17  
**App alias:** DUTY-TRAVEL | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | 8 tables, 2 sequences, 6 triggers |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, lookups, rates, templates, doc requirements |
| Views | ✅ Complete | 6 views |
| PL/SQL Package | ✅ Complete | DCT_DT_PKG — 12 public procs/funcs + 3 scheduler jobs |
| APEX App Shell | ✅ Complete | App 204 deployed; 17 items, 10 LOVs, 5 auth schemes, 18 page shells |
| APEX Pages | ⬜ Not started | Must be built in APEX Builder |

---

## DB Files (`final apps/DT/db/`)

| File | Status | Contents |
|---|---|---|
| `install.sql` | ✅ | Master install — runs 01→02→03→04 |
| `01_dt_ddl.sql` | ✅ Deployed | DDL: DT_PER_DIEM_RATES, DT_COUNTRY_GROUPS, DT_REQUESTS, DT_DESTINATIONS, DT_DOC_REQUIREMENTS, DT_DOCUMENTS, DT_SETTLEMENT, DT_SETTLEMENT_LINES + seqs + triggers |
| `02_dt_seed.sql` | ✅ Deployed | DT module registration, 9 roles, 17 permissions, 19 settings, DT_EMPLOYEE_GRADE (5), DT_DOCUMENT_TYPE (8), 2 approval templates, 12 doc requirement rules, 15 per diem rates, 249 country groups |
| `03_dt_views.sql` | ✅ Deployed | DT_REQUESTS_V, DT_DESTINATIONS_V, DT_SETTLEMENT_V, DT_PENDING_APPROVALS_V, DT_RATE_MASTER_V, DT_DOC_REQUIREMENTS_V |
| `04_dct_dt_pkg.sql` | ✅ Deployed | Package spec + body + JOB_DT_SET_TRAVELLED, JOB_DT_AUTO_CLOSE, JOB_DT_STL_ALERTS |
| `05_apex_204_setup.sql` | ✅ Deployed | APEX App 204 full shell |
| `05b_apex_204_cont.sql` | Reference | Superseded by corrected 05_ — keep for reference |

---

## APEX App 204 — Shared Components Deployed

| Component | Count | Names |
|---|---|---|
| App Items | 17 | USER_ID, USER_DISPLAY_NAME, USER_DISPLAY_NAME_AR, USER_EMAIL, USER_LANGUAGE, USER_COLOR, USER_PHOTO_URL, USER_ORG_ID, USER_ORG_IDS, USER_ROLES, IS_ADMIN, IS_EXTERNAL, UNREAD_NOTIFICATIONS, ACTIVE_DELEGATION_FOR + APP_IS_DT_ADMIN, APP_IS_DT_FINANCE, APP_IS_DT_MANAGER |
| Computations | 3 | APP_IS_DT_ADMIN, APP_IS_DT_FINANCE, APP_IS_DT_MANAGER (ON_NEW_INSTANCE, FUNCTION_BODY) |
| Auth Schemes | 5 | IS_DT_ADMIN, IS_DT_FINANCE, IS_DT_MANAGER, IS_DT_ADMIN_OR_FINANCE, IS_DT_ADMIN_OR_MANAGER |
| Shared LOVs | 10 | LOV_DT_MISSION_TYPE, LOV_DT_TRIP_TYPE, LOV_DT_STATUS, LOV_DT_EMPLOYEE_GRADE, LOV_DT_DOCUMENT_TYPE, LOV_DT_EXPENSE_CATEGORY, LOV_DT_BUDGET_TYPE, LOV_DT_RATE_STRUCTURE, LOV_DT_HALF_DAY_POLICY, LOV_DT_COUNTRIES |
| Global Processes | 2 | Touch Session (seq 10), Refresh Notification Count (seq 20) |
| Page Shells | 18 | See table below |

---

## APEX Pages — Shell Only (content not yet built)

| Page | Alias | Title | Auth Required |
|---|---|---|---|
| 9999 | LOGIN | Duty Travel — Login | Public |
| 1 | DASHBOARD | Duty Travel Dashboard | Authenticated |
| 10 | MY-REQUESTS | My Travel Requests | Authenticated |
| 11 | NEW-REQUEST | Travel Request | Authenticated |
| 12 | VIEW-REQUEST | Request Detail | Authenticated |
| 13 | EDIT-REQUEST | Edit Travel Request | Authenticated |
| 14 | DESTINATIONS | Destination Legs | Authenticated |
| 20 | PENDING-APPROVALS | Pending Approvals | IS_DT_MANAGER or IS_DT_ADMIN |
| 21 | REVIEW-APPROVE | Review & Approve Request | IS_DT_MANAGER or IS_DT_ADMIN |
| 30 | SETTLEMENT | Travel Settlement | Authenticated |
| 40 | RATE-MASTER | Per Diem Rate Master | IS_DT_ADMIN |
| 41 | RATE-EDIT | Edit Per Diem Rate | IS_DT_ADMIN |
| 42 | COUNTRY-GROUPS | Country & Region Groups | IS_DT_ADMIN |
| 50 | ADVANCE-PAYMENT | Advance Payment Queue | IS_DT_FINANCE or IS_DT_ADMIN |
| 60 | CLOSURE-QUEUE | Request Closure Queue | IS_DT_FINANCE or IS_DT_ADMIN |
| 70 | CONFIG | Duty Travel Configuration | IS_DT_ADMIN |
| 71 | DOC-REQUIREMENTS | Document Requirements | IS_DT_ADMIN |
| 80 | AUDIT-LOG | Audit Log | IS_DT_ADMIN or IS_DT_FINANCE |

---

## Immediate Next Steps

1. **APEX Builder — Manual step (5 min):**  
   Shared Components → Authentication Schemes → select "DCT Custom Auth" → click **Make Current Scheme**

2. **Build page content in APEX Builder** following `docs/APEX_PAGE_PLAN.md`:  
   Suggested order: 9999 → 1 → 10 → 11 → 12 → 20 → 21 → 30 → 40 → 50 → 60 → 70 → 71 → 80

3. **Navigation menu** — create list entries in Shared Components → Navigation Menu:
   - Dashboard → `f?p=204:1`
   - My Requests → `f?p=204:10`
   - Pending Approvals → `f?p=204:20` (IS_DT_MANAGER / IS_DT_ADMIN)
   - Rate Master → `f?p=204:40` (IS_DT_ADMIN)
   - Advance Payment → `f?p=204:50` (IS_DT_FINANCE / IS_DT_ADMIN)
   - Closure Queue → `f?p=204:60` (IS_DT_FINANCE / IS_DT_ADMIN)
   - Config → `f?p=204:70` (IS_DT_ADMIN)
   - Doc Requirements → `f?p=204:71` (IS_DT_ADMIN)
   - Audit Log → `f?p=204:80` (IS_DT_ADMIN / IS_DT_FINANCE)

---

## Key API Gotchas (learned during build)

| Issue | Fix |
|---|---|
| `dct_user_roles` date column | `end_date` (not `valid_to`) |
| `dct_notify.send` params | `p_recipient_user_id`, `p_notification_type`, `p_title_en`, `p_body_en` |
| `dct_auth.has_role` | Takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |
| `dct_lookup_values` columns | `value_code` / `value_name_en` / `display_order` |
| `dct_approval_instances` | `overall_status` (not `status`); join steps via `template_id + current_step_seq` |
| `dct_gl_code_combinations` | No `cc_concat_segments` — concatenate segments individually |
| APEX `create_flow_computation` | `p_computation_item` (not `p_flow_item_name`) |
| APEX `create_list_of_values` | `p_lov_name` / `p_lov_query` (not `p_name` / `p_query`) |
| APEX PL/SQL BOOLEAN in SQL | Use `FUNCTION_BODY` computation type, not `QUERY` |
| APEX `WHENEVER SQLERROR ROLLBACK` | Rolls back ALL uncommitted blocks — fix all errors before running |
| DBMS_SCHEDULER job DROP | Use `all_scheduler_jobs WHERE owner='PROD'` not `user_scheduler_jobs` |
| PL/SQL `IF (SELECT ...)` | Illegal — must SELECT INTO variable first |
| `MEMBER OF` local collection in SQL | Illegal — rewrite as cursor loop |

## Phase 2 update (2026-06-11) - fixes (assessment-3/phase2/)
- FIXED: 8 ORDS handlers queried module_code 'DT' instead of 'DUTY_TRAVEL' - settings/approval-templates/notifications endpoints returned empty. GET /dt/settings/ now returns 19 rows (verified live).
- Secret masking added to DT settings GET (+ PUT refuses the '********' mask); dct_notify.send calls now pass p_module_code => 'DUTY_TRAVEL'.
- FIXED: DT_REQUESTS_V was INVALID in PROD (referenced gl.account etc.; real columns are *_code) - now uses the cc_code virtual column; all 6 DT views redeployed VALID.
- Deferred to DT adoption: natural-key FKs on dt_requests inline coding columns; status CHECKs retained as safety nets (DT_* lookup categories already seeded).
