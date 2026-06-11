# Phase 2 — Execution + Test Report

**Executed:** 2026-06-11 · Plan: [00-phase2-plan.md](00-phase2-plan.md) (approved with two user directives: natural-key masters, lookup-first statuses everywhere) · Test evidence: [tests/](tests/)

**Result: ✅ all phases deployed, all tests passing.** Zero data migration was needed — every FL/CC transactional table was verified empty before its drop, and the only seed data (11 CC doc requirements, 20 expenditure types) was re-seeded onto the new shapes inside the deploy scripts.

---

## 1. What was deployed

### 2.0 — Carried-over DT fixes
| Change | File | Verified |
|---|---|---|
| 8× `module_code = 'DT'` → `'DUTY_TRAVEL'` in ORDS handlers (settings/notifications/approval-templates/number-prefixes returned empty before) | `final apps/DT/db/06_dt_ords.sql` | `GET /dt/settings/` now returns **19 rows** (was 0); `GET /dt/approval-templates/` returns both templates |
| Notifications filter accepts legacy NULL `module_code` rows | same | `GET /dt/notifications/` count=1 |
| Secret masking (`%API_KEY%/%SECRET%/%PASSWORD%/%TOKEN%` → `********`) on DT settings GET + PUT mask-guard (PC pattern) | same | smoke asserts no clear-text secret-like values |
| `p_module_code => 'DUTY_TRAVEL'` added to all 5 `dct_notify.send` calls | `final apps/DT/db/04_dct_dt_pkg.sql` | package VALID |
| HR ORDS checked — has **no** settings/notifications handlers, nothing to patch | — | — |

### 2.1a + 2.1 — `db/v2/15_dct_unified_structures.sql` (platform)
- **Natural-key masters** (user directive; old masters verified empty, the 20 expenditure-type seeds re-seeded):
  - `DCT_PROJECTS` — `project_number VARCHAR2(12)` natural PK (no `project_id`)
  - `DCT_TASKS` — composite PK `(project_number, task_number VARCHAR2(30))`, replaces `DCT_PROJECT_TASKS` (dropped); WBS parent via composite self-FK
  - `DCT_EXPENDITURE_TYPES` — `expenditure_type VARCHAR2(255)` natural PK
- **Unified tables:** `DCT_DOC_REQUIREMENTS` (11 CC rows re-seeded, mapped to `dct_document_types`), `DCT_DOCUMENTS` (adds FL's `status`/`is_required`), `DCT_DOC_EXPIRY_ALERTS`, `DCT_BUDGET_CODING_LINES` (natural-key PROJECT branch + nullable `expense_date` + CC merchant columns; GL/PROJECT exclusivity CHECK kept as structural rule), `DCT_REQUEST_STATUS_HISTORY`
- **Lookup-first rule:** no status CHECK constraints on any new table; `DCT_LOOKUP_PKG` (`is_valid` / `validate_lookup`, raises ‑20090) is the runtime validator; 10 platform categories seeded (REQUEST_STATUS, DOC_STATUS, DOC_ALERT_TYPE, CODING_TYPE, BCL_SOURCE_TYPE, SOURCE_MODULE, DOC_SOURCE_TYPE, PROJECT_STATUS, PROJECT_TYPE, EXP_CATEGORY) with EN/AR names — all manageable from Admin `lookups.html`
- 8 new doc types (HR_AUTH_LETTER, JUSTIFICATION, CLEARANCE_LTR, POLICE_REPORT, DAMAGED_CARD, TRADE_LICENSE, QUALIFICATION, DELIVERABLE_DOC) + 4 `applies_to_modules` extensions; ADMIN synonyms for everything

### 2.2 — CC adopts natively (`final apps/CC/db/08_cc_unified_adoption.sql` + reworked `02_cc_views.sql`, `04_cc_pkg.sql`)
- Card statuses simplified to **ACTIVE | INACTIVE | CLOSED** (default INACTIVE); all 7 status/type CHECKs dropped; 6 `CC_*` lookup categories seeded
- `*_IN_PROGRESS` pseudo-statuses retired — `DCT_CC_CARD_V` derives `pending_operation` from open requests; `revert_request_effects` is now a documented no-op
- `DCT_CC_PKG` rewired: doc validation reads unified `dct_doc_requirements`+`dct_documents`; replenishment lines read `dct_budget_coding_lines` (`source_type='CC_REPL'`); every transition appends to `dct_request_status_history`; `CLOSE_CARD` → card `CLOSED`; enum writes validated via `DCT_LOOKUP_PKG`
- Fixed a latent bug: the REPLACEMENT branch read `v_card.notes` without ever selecting the card row
- **Dropped:** `DCT_CC_ATTACHMENTS`, `DCT_CC_REIMB_LINES` (0 rows each), `DCT_CC_DOC_REQUIREMENTS` (11 seed rows, only after confirming the unified copy held ≥ 11 CC rows)

### 2.3 — FL adopts (`final apps/FL/db/06_fl_unified_adoption.sql` + reworked `02_fl_views.sql`, `04_fl_pkg.sql`)
- Convention: **`dct_documents.reference_id` carries `freelancer_id`** for every FL document
- `DCT_FL_DOCUMENT_V` + freelancer expired-doc count repointed to `dct_documents`; doc-type names resolve from `dct_document_types` (FL_DOCUMENT_TYPE lookup category deactivated)
- `send_expiry_alerts` repointed to unified tables, once-per-day NOT EXISTS guard preserved
- New `mirror_contract_coding(p_contract_id)` mirrors header GL/PROJECT coding into `dct_budget_coding_lines` (`FL_CONTRACT`, line 1); called from `create_renewed_contract` and by future contract-approval flows
- **Dropped:** `DCT_FL_DOCUMENTS`, `DCT_FL_DOC_EXPIRY_ALERTS` (0 rows each)

### 2.4 — `db/v2/16_dct_missing_fks.sql` + PC wiring
- **22 FKs added** NOVALIDATE → orphan report **CLEAN** → all **VALIDATED**: 3× (project/task/exp-type) on each of `dct_pc_budget_lines`, `dct_pc_reimb_budget_lines`, `dct_pc_clear_budget_lines`, `dct_fl_contracts`, `dct_fl_contract_renewals`, `dct_fl_payment_vouchers`, `dct_cc_replenishments` + new `dct_fl_bank_accounts.bank_code` → `dct_bank_codes` (DT inline columns deferred with DT adoption, per plan)
- **23 more lookup categories** (PC 6, DT 5, FL 12) matching live CHECK values exactly, EN/AR
- CHECK-drop policy applied: **17 FL status/type CHECKs dropped** (empty tables, adopted this phase); PC/DT CHECKs retained as safety nets until those modules adopt
- `pc.rest` redeployed with status-history wiring: create/disburse handlers + approval-action handler (mid-chain, final, reject/return, clearing-closes-PC) + reimbursement/clearing creates

---

## 2. Test results

### Read-only verification ([tests/verify_phase2.sql](tests/verify_phase2.sql))
| Check | Result |
|---|---|
| 8 unified/master tables exist; 6 superseded tables gone | ✅ |
| All key packages VALID (CC, FL, DT, LOOKUP, REST, AUTH, NOTIFY, APPROVAL, PC_AI) | ✅ 18/18 |
| 22 natural-key FKs ENABLED + VALIDATED | ✅ 22/22 |
| 40 Phase-2 lookup categories active | ✅ |
| Zero status/type CHECKs left on CC + FL tables | ✅ |
| Seeds: 20 exp types, 11 CC doc reqs, 26 doc types | ✅ |
| `DCT_LOOKUP_PKG.is_valid` → Y for real value, N for bogus | ✅ |
| 4 ORDS modules PUBLISHED (dct.admin, dt, hr, pc) · 6 scheduler jobs SCHEDULED | ✅ |
| INVALID objects | Only `DCT_PROJECT_BUDGET_V` — **by design** (FORCE view over external Fusion tables not present on ADB) |

### HTTP smoke ([tests/phase2_smoke.ps1](tests/phase2_smoke.ps1) + [tests/phase2_smoke_fix.ps1](tests/phase2_smoke_fix.ps1)) — 13/13 after retry
DT: 401 without token · settings **19 rows** (was 0) · secrets masked · 2 approval templates · notifications include legacy NULL-module rows · requests list works (DT_REQUESTS_V fixed, see §3). PC: settings masked (`ANTHROPIC_API_KEY` = exactly `********`; the one "FAIL" in the first run was a PowerShell array-comparison artifact, proven by the diagnostic), stats/lists/gl-codes OK. **Write test:** `PC-2026-00004` created via `POST /pc/` → rejected via approvals action → **2 status-history rows** (NULL→SUBMITTED, SUBMITTED→REJECTED).

### CC package exercise ([tests/cc_exercise.sql](tests/cc_exercise.sql)) — all PASS
1. Submit without docs → blocked with "Missing mandatory documents: Emirates ID, Passport, HR Authorisation Letter" (unified requirements working)
2. Attach unified `dct_documents` rows → submit OK → 2-step approval chain (CUSTOM bank step evaluated) → APPROVED
3. `register_card` → card `CC-2026-00001` ACTIVE, 1 INITIAL limit-history row
4. CLOSE_CARD rejected → request REJECTED, **card stays ACTIVE** (no pseudo-status to revert)
5. Second CLOSE_CARD approved → card **CLOSED** (terminal — no replenishment-reminder noise)
6. `validate_lookup` rejects a bogus enum with ‑20090
7. **9 status-history rows** captured (REQUEST and CARD source types, full old→new chains)

### Test artifacts left in PROD (all labelled, all terminal)
| Artifact | Status |
|---|---|
| `PC-2026-00004` "PHASE2 SMOKE TEST - safe to ignore" | REJECTED |
| `CCR-2026-00001` (NEW_CARD) / `CCR-2026-00002` / `CCR-2026-00003` | APPROVED / REJECTED / APPROVED |
| Card `CC-2026-00001` (holder ADMIN, "PHASE2 TEST MOTHER") | CLOSED |

---

## 3. Drift discovered and fixed along the way

These were broken in PROD **before** Phase 2 started and were repaired because the work surfaced them:

1. **`DT_REQUESTS_V` was INVALID in PROD** — it concatenated GL segments using column names that don't exist on `dct_gl_code_combinations` (`gl.account` vs `account_code`). The live DT request list endpoint would have returned 500. Fixed in `final apps/DT/db/03_dt_views.sql` by using the `cc_code` virtual column; all 6 DT views redeployed.
2. **`DCT_FL_REGISTRATION_V` / `DCT_FL_CONTRACT_V` were INVALID in PROD** — repo script referenced `dct_nationality.nationality_name_en`; the real column is `nationality_en`. Fixed and redeployed; all 9 FL objects now VALID.
3. **`DCT_AUDIT` and `DCT_APPROVAL` package bodies + 2 org views** were stale-INVALID; recompiled clean. (`DCT_FL_PKG` calls `dct_audit.log` — this would have failed at runtime.)
4. Running a module ORDS script in the same SQLcl session after a script that sets `CURRENT_SCHEMA=PROD` makes its ADMIN synonyms self-referencing (ORA-01471) — ORDS/synonym scripts now documented to require a fresh session.

## 4. Follow-ups / notes

- `DCT_PROJECT_BUDGET_V` stays INVALID until the external Fusion tables (`projects`, `project_balances`, …) are provisioned or the view is repointed to the new local masters — decide at Fusion-integration time (Phase 6 #9).
- PC/DT status CHECKs are still in place (live data, safety net). Drop them when those modules adopt the unified model; the lookup categories are already seeded so their UIs can switch LOVs to lookups now.
- DT inline coding columns get their natural-key FKs when DT adopts (plan §2.4.1).
- Masters are empty: load real projects/tasks (12/30-char natural keys) and confirm `expenditure_type` codes against Oracle Fusion before PROJECT-coded entry is used in anger.
- User-side from Phase 1, still open: rotate the exposed `ANTHROPIC_API_KEY`; browser acceptance pass of PC live mode.

## 5. Files changed/created

**New:** `db/v2/15_dct_unified_structures.sql`, `db/v2/16_dct_missing_fks.sql`, `final apps/CC/db/08_cc_unified_adoption.sql`, `final apps/FL/db/06_fl_unified_adoption.sql`, `assessment-3/phase2/tests/` (5 scripts).
**Modified:** `final apps/DT/db/06_dt_ords.sql`, `04_dct_dt_pkg.sql`, `03_dt_views.sql` · `final apps/CC/db/02_cc_views.sql`, `04_cc_pkg.sql`, `install.sql` · `final apps/FL/db/02_fl_views.sql`, `04_fl_pkg.sql`, `install.sql` · `final apps/PC/db/06_pc_ords.sql` · `db/v2/12_dct_master_data.sql` (superseded-note), `db/v2/install.sql` · `CLAUDE.md`, STATUS.md files, action plan.
