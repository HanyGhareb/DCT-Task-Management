# Phase 2 — Converge the Data Model (Approved Plan)

**Status:** 📋 Approved 2026-06-11 — not yet executed. Execution artifacts (scripts run, test evidence, report) will be added to this folder as Phase 2 proceeds, like [../phase1/](../phase1/).

## Context

Phase 1 (backend unblock) is deployed and tested ([../phase1/](../phase1/)). Phase 2 of the approved action plan ([../06-action-plan.md](../06-action-plan.md)) converges the five modules onto three shared structures — unified documents, unified budget-coding lines, request status history — plus missing FKs and lookup migrations, adopting **CC first (greenfield), then FL**, with PC getting cheap wiring (we own its new ORDS file). DT/HR data-model adoption stays deferred (opportunistic).

**Decisive finding (read-only DB check, 2026-06-11):** every FL and CC transactional table has **0 rows** (`dct_fl_documents`, `dct_fl_contracts`, `dct_fl_payment_vouchers`, `dct_cc_attachments`, `dct_credit_cards`, `dct_cc_requests`, `dct_cc_replenishments`, `dct_pc_attachments`). Only seeds exist: 11 rows `dct_cc_doc_requirements`, 18 `dct_document_types`, 20 `dct_expenditure_types`. **Therefore: no data backfill anywhere — adoption is schema + package repointing only.** Superseded empty tables are dropped outright (no `_bak` dance).

**Corrections the plan handles:**
1. Draft DDL `../03-database/ddl/01` references `dct_document_types(document_type_id)` — actual PK is **`doc_type_id`** (`db/v2/12_dct_master_data.sql:370`).
2. FL documents type-reference **`dct_lookup_values.value_id`**, not `dct_document_types` (`DCT_FL_DOCUMENT_V`, `final apps/FL/db/02_fl_views.sql:231`) — FL doc types must be mapped/created in `dct_document_types`.
3. FL coding columns exist on **three** tables: `dct_fl_contracts`, `dct_fl_payment_vouchers`, `dct_fl_contract_renewals`.
4. CC's `dct_cc_reimb_lines` has `expense_date` — the unified lines table needs it as a nullable extension column.
5. **DT module_code bug confirmed:** seed registers `'DUTY_TRAVEL'`; `final apps/DT/db/06_dt_ords.sql` queries `'DT'` in 8 handlers → DT settings/notifications/approval-list endpoints silently return empty today. DT notifications rows also have NULL module_code (DT pkg never passes `p_module_code`).
6. **User directive (2026-06-11): the project-costing masters move to natural primary keys** (Phase 2.1a). All three masters are empty, so restructuring is free.

## Execution conventions (unchanged from Phase 1)

SQLcl `sql -name prod_mcp` via runner files in `c:\tmp` (no BOM/em-dash in .ps1), `SET DEFINE OFF`, objects as `prod.<name>`, individual INSERTs, ADMIN synonyms for anything ORDS touches, `RETURNING` only with `INSERT…VALUES`. Deployment of **shared/platform objects and any PROD write-tests pause for user approval** (same gates as Phase 1).

---

## Phase 2.0 — Carried-over Phase 1 fixes (small, do first)

| Task | Files |
|---|---|
| Patch DT ORDS: 8× `module_code = 'DT'` → `'DUTY_TRAVEL'`; notifications filter becomes `(module_code = 'DUTY_TRAVEL' OR module_code IS NULL)`; add the PC-style secret-masking CASE to the DT settings GET; redeploy `dt.rest` | `final apps/DT/db/06_dt_ords.sql` |
| DT package: pass `p_module_code => 'DUTY_TRAVEL'` in every `dct_notify.send` call; redeploy | `final apps/DT/db/04_dct_dt_pkg.sql` |
| HR ORDS: verify whole file for settings/notifications handlers; apply masking/module_code hygiene only if present | `final apps/HR/db/06_hr_ords.sql` |
| (User, outside this plan: rotate the exposed ANTHROPIC_API_KEY) | — |

## Phase 2.1a — Restructure project-costing masters to natural keys (user directive)

All three are empty (0 rows) → drop & recreate in `db/v2/15_dct_unified_structures.sql` (and update the source of truth `db/v2/12_dct_master_data.sql`):

| Table | Primary key | Notes |
|---|---|---|
| `dct_projects` | **`project_number VARCHAR2(12)`** (natural PK — no project_id) | retain existing attribute columns (name_en/ar, project_type, org_id, manager, dates, budget_amount, currency, status, is_active) |
| `dct_tasks` (**new**, replaces `dct_project_tasks`) | **composite (`project_number VARCHAR2(12)` FK → dct_projects, `task_number VARCHAR2(30)`)** | task attributes (name, parent task via task_number self-ref within project, level, dates, budget, is_chargeable, is_active) |
| `dct_expenditure_types` | **`expenditure_type VARCHAR2(255)`** (natural PK code) | retain name_en/ar, exp_category (lookup-driven per 2.1 §6), applies_to_gl/project |

Re-seed the 20 expenditure types onto the new shape. Drop `dct_project_tasks`. Benefit: module free-text columns (`project_number`, `task_number`, `expenditure_type` on PC/FL tables) take **direct FKs to these natural keys** — no ID-conversion mapping anywhere. Matches the Oracle Fusion projects model (the eventual sync source) and the PC budget view's natural-key joins (`dct_project_budget_v`).

## Phase 2.1 — Deploy unified structures

New deployable `db/v2/15_dct_unified_structures.sql` — the three draft scripts ([../03-database/ddl/](../03-database/ddl/)) finalized; drafts stay untouched as assessment artifacts:

1. **`dct_documents`** — per draft `01` with fixes: FK → `dct_document_types(doc_type_id)`; add FL's `status` (ACTIVE|SUPERSEDED) and `is_required` columns.
2. **`dct_doc_requirements`** — `(source_module, context_code, doc_type_id, is_mandatory, display_seq)`; re-seed CC's 11 rows as `context_code = 'NEW_CARD'|'INCREASE_LIMIT'|…`, mapping each `document_name` to a `dct_document_types` row (create missing types with `applies_to_modules` including `CC`).
3. **`dct_doc_expiry_alerts`** — generalized from FL's richer shape: `(alert_id, doc_id FK, alert_type, days_remaining, notified_user_id, sent_at)`; once-per-day semantics preserved via the existing NOT EXISTS pattern.
4. **`dct_budget_coding_lines`** — per draft `02` **amended to natural keys**: PROJECT branch stores `project_number VARCHAR2(12)` FK → `dct_projects`, `(project_number, task_number VARCHAR2(30))` composite FK → `dct_tasks`, `expenditure_type VARCHAR2(255)` FK → `dct_expenditure_types` — **no project_id/task_id/exp_type_id columns**. Plus nullable `expense_date` (CC). Other FKs: `dct_currency_codes(currency_code)`, `dct_gl_code_combinations(cc_id)`. GL/PROJECT exclusivity CHECK stays (structural rule, not a business enum).
5. **`dct_request_status_history`** + `REQUEST_STATUS` lookup category/values — per draft `03`. Verify `dct_lookup_categories` actual column names (`user_tab_columns`) before running.
6. **Lookup-first rule for ALL status-like columns in the new tables** (user requirement; HR grade-category precedent `final apps/HR/db/_archive/patch_grade_category_lookup.sql`):
   - Seed one lookup category per status family: `REQUEST_STATUS`, `DOC_STATUS` (ACTIVE|SUPERSEDED), `DOC_ALERT_TYPE` (EXPIRING_SOON|EXPIRED), `CODING_TYPE` (GL|PROJECT), `SOURCE_MODULE` (PC|DT|HR|FL|CC|ADMIN), `DOC_SOURCE_TYPE` per module context.
   - New unified tables get **no hardcoded status CHECK constraints**; validation via a small `validate_lookup(p_category, p_code)` helper (new, in `db/v2/15`) called by packages/handlers; all LOVs/UI read `dct_lookup_values`. Manageable through Admin `lookups.html` immediately.
7. ADMIN synonyms for all five objects.

## Phase 2.2 — CC adopts natively (zero migration — tables empty)

1. **Status simplification** (`final apps/CC/db/08_cc_unified_adoption.sql`, new): card statuses become `ACTIVE|INACTIVE|CLOSED`, DEFAULT `INACTIVE` — values in the `CC_CARD_STATUS` lookup category (no CHECK constraint; same for `CC_REQUEST_STATUS`/`CC_REPL_STATUS` — all CC tables empty, CHECKs drop cleanly); rewrite `DCT_CC_CARD_V` (`02_cc_views.sql`) to derive `pending_operation` from open `dct_cc_requests` (`status IN ('SUBMITTED','UNDER_REVIEW')`).
2. **Refactor `DCT_CC_PKG`** (`04_cc_pkg.sql`, deployed in Phase 1 — still uncalled by any UI, safe to change):
   - Remove all `*_IN_PROGRESS` status writes (`submit_request`; `revert_request_effects` becomes a no-op on card status; `apply_approved_request` sets only ACTIVE/INACTIVE). The "no other open request per card" guard already provides the exclusivity.
   - `validate_docs` reads unified `dct_doc_requirements` + `dct_documents` (`source_module='CC'`, `source_type='REQUEST'`).
   - Write `dct_request_status_history` rows on every transition (submit, withdraw, approve-step, final, reject/return, register_card).
   - Replenishment validation/recalc read `dct_budget_coding_lines` (`source_type='CC_REPL'`) instead of `dct_cc_reimb_lines`.
3. **Drop empty superseded CC tables**: `dct_cc_attachments`, `dct_cc_reimb_lines`, `dct_cc_doc_requirements` (after `DCT_CC_REPLENISHMENT_V` line-count subquery is repointed in `02_cc_views.sql`). Update `01_cc_ddl.sql` source-of-truth + `install.sql` order + `STATUS.md`.

## Phase 2.3 — FL adopts (package + views; zero migration)

1. **Doc types mapping**: ensure every FL document type used by seeds/LOVs exists in `dct_document_types` with `FL` in `applies_to_modules`; FL views/pkg resolve names from `dct_document_types` instead of `dct_lookup_values`.
2. **Repoint `DCT_FL_PKG.send_expiry_alerts`** (`final apps/FL/db/04_fl_pkg.sql:741`) to `dct_documents` (`source_module='FL'`) + unified `dct_doc_expiry_alerts`; preserve the freelancer join via `source_type`/`source_id` and the once-per-day NOT EXISTS guard.
3. **Repoint `DCT_FL_DOCUMENT_V`** (`02_fl_views.sql:231`) to the unified table.
4. **Coding**: keep the header coding columns on contracts/vouchers/renewals (the planned APEX form surface); `DCT_FL_PKG` mirrors them into `dct_budget_coding_lines` (`source_type='FL_CONTRACT'`, line_num 1) on contract approval and in `CREATE_RENEWED_CONTRACT` — one read path for cross-module spend reporting without redesigning FL forms.
5. **Drop empty** `dct_fl_documents` + `dct_fl_doc_expiry_alerts`; update `01_fl_ddl.sql` source + `install.sql` + `STATUS.md`. New script `final apps/FL/db/06_fl_unified_adoption.sql`.

## Phase 2.4 — Missing FKs, lookup migration, PC wiring

1. **FKs** (finalize draft `04` → `db/v2/16_dct_missing_fks.sql`): `dct_fl_bank_accounts.bank_code` (new column + FK to `dct_bank_codes`); NOVALIDATE FKs from PC line tables and FL coding columns **directly to the natural-key masters** — `project_number` → `dct_projects(project_number)`, `(project_number, task_number)` → `dct_tasks`, `expenditure_type` → `dct_expenditure_types(expenditure_type)` — then orphan report → VALIDATE (PC has 2 GL-coded records, FL is empty; expected clean). Module column lengths (50/50/100) stay as-is; data must simply fit the master keys (12/30/255). DT inline columns deferred with DT adoption.
2. **Lookup migration — ALL status-like columns across ALL module tables** (user requirement). Seed one lookup category per status family, individual INSERTs:
   - **Type/reason enums:** `PC_TYPE`, `DT_MISSION_TYPE`, `DT_TRIP_TYPE`, `CC_REQUEST_TYPE`, `CC_REPLACEMENT_REASON`, `CC_LIMIT_CHANGE_TYPE`, `FL_BILLING_METHOD`, `FL_SUBMITTED_BY`, `PC_ATTACH_REQUEST_TYPE`.
   - **Status enums per table family:** `PC_STATUS`, `PC_REIMB_STATUS`, `PC_CLEARING_STATUS`, `DT_REQUEST_STATUS`, `DT_SETTLEMENT_STATUS`, `CC_CARD_STATUS` (simplified ACTIVE|INACTIVE|CLOSED), `CC_REQUEST_STATUS`, `CC_REPL_STATUS`, `FL_REGISTRATION_STATUS`, `FL_FREELANCER_STATUS`, `FL_CONTRACT_STATUS`, `FL_DELIVERABLE_STATUS`, `FL_VOUCHER_STATUS`, `FL_PAYMENT_STATUS`.
   - Each value row carries `value_name_en` (+ `value_name_ar` where known) so Admin `lookups.html` manages them and module LOVs/JET dropdowns read them.
   - **CHECK-constraint removal policy** (HR precedent): drop CHECKs immediately on zero-row tables being refactored this phase (**CC tables, new unified tables**); live-data tables (PC, DT) keep CHECKs as safety net until their module adopts. Statuses written by packages/handlers validate against lookups via the `validate_lookup` helper.
3. **PC status-history wiring**: `final apps/PC/db/06_pc_ords.sql` create/action/disburse handlers insert `dct_request_status_history` rows; redeploy `pc.rest`.

## Phase 2.5 — Test + report (gates like Phase 1)

1. Object validity + ORDS module checks (`verify_phase2.sql`, extending [../phase1/tests/verify_phase1.sql](../phase1/tests/verify_phase1.sql)).
2. **DT endpoint re-test**: after 2.0, `GET /dt/settings/` must return rows (empty today) and notifications must list rows; reuse the Phase-1 PowerShell harness.
3. **PC re-smoke**: rerun [../phase1/tests/pc_smoke_readonly.ps1](../phase1/tests/pc_smoke_readonly.ps1) + verify a new status-history row appears for a (user-approved) write test.
4. **CC package exercise** (needs user approval — PROD writes): SQLcl anonymous-block test: DRAFT card request → `submit_request` (expect doc-requirement error → attach unified doc rows → success) → `act_on_approval` chain incl. the CUSTOM bank step → `register_card` → verify limit + status history → close-card request → reject → verify revert. Test rows clearly labelled, left as REJECTED/INACTIVE.
5. Orphan report output (expected empty) archived with the report.
6. **Report** → `assessment-3/phase2/README.md` (+ test scripts in `phase2/tests/`); update `CLAUDE.md`, [../06-action-plan.md](../06-action-plan.md) (mark Phase 2), [../03-database/02-proposed-model.md](../03-database/02-proposed-model.md) (note deltas: natural-key masters, FL lookup-based doc types, expense_date extension), STATUS.md files, and memory.

## Files summary

**New:** `db/v2/15_dct_unified_structures.sql` (incl. master restructure + `dct_tasks`), `db/v2/16_dct_missing_fks.sql`, `final apps/CC/db/08_cc_unified_adoption.sql`, `final apps/FL/db/06_fl_unified_adoption.sql`, `assessment-3/phase2/` artifacts.
**Modified:** `db/v2/12_dct_master_data.sql` (restructured masters' source of truth), `final apps/DT/db/06_dt_ords.sql` + `04_dct_dt_pkg.sql` (2.0), `final apps/CC/db/04_cc_pkg.sql` + `02_cc_views.sql` + `01_cc_ddl.sql` + `install.sql` + `STATUS.md`, `final apps/FL/db/04_fl_pkg.sql` + `02_fl_views.sql` + `01_fl_ddl.sql` + `install.sql` + `STATUS.md`, `final apps/PC/db/06_pc_ords.sql`, `CLAUDE.md`, action plan.

## Approval gates during execution

- Deploying `db/v2/15` + `16` (new shared platform tables/FKs): **ask before running**.
- Redeploying `dt.rest` and DT package (live module): **ask before running**.
- CC/FL/PC module scripts: same class as Phase 1 module deploys (proceed, report results).
- Any PROD write-test: **ask first** (as in Phase 1).

## Exit criteria

DT settings/notifications endpoints return data · all packages VALID · unified tables live with CC+FL pointed at them · zero rows in (now-dropped) superseded tables confirmed before drop · **every status-like column's value set manageable from Admin `lookups.html` (lookup categories seeded for all status families; no CHECK constraints on new/CC tables)** · orphan report empty · PC smoke still 15/15 · phase2 report delivered.
