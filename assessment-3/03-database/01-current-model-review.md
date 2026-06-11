# Database Assessment — Current Model Review

**Sources:** `db/v2/01_dct_ddl.sql` (25 core tables), `db/v2/12_dct_master_data.sql` (11 reference tables), `final apps/PC/db/01_pc_ddl.sql` (8), `final apps/DT/db/01_dt_ddl.sql` (8), `final apps/HR/db/01_hr_ddl.sql` (8), `final apps/FL/db/01_fl_ddl.sql` (13), `final apps/CC/db/01_cc_ddl.sql` (8). **~67 tables total**, all in PROD schema on ADB 23ai/26ai.

---

## 1. What is genuinely good (keep, don't touch)

| Strength | Where |
|---|---|
| **Generic approval engine** — templates/steps/instances/actions with conditional firing (amount thresholds, type filters, custom PL/SQL), escalation fields, delegation hooks. One engine serves all 5 domain modules. | `dct_approval_*` in `db/v2/01_dct_ddl.sql` |
| **Month-partitioned audit log** (INTERVAL partitioning) with JSON old/new snapshots | `dct_audit_log` |
| **9-segment GL chart of accounts** with `cc_code` as a virtual column, FK'd from every budget module | `dct_gl_code_combinations`, `db/v2/12_dct_master_data.sql` |
| **Time-bounded, org-scoped RBAC** (`dct_user_roles.start_date/end_date`, `org_scope_id`) | `db/v2/01_dct_ddl.sql` |
| **FL document pattern** — single doc table with `source_type` discriminator + `document_type_id` FK + expiry alerts + duplicate-alert suppression | `dct_fl_documents`, `dct_fl_doc_expiry_alerts` |
| Per-module typed settings with effective dates | `dct_module_settings` |

The core platform (25 tables) is production-grade. The problems are almost entirely in **how the 5 domain modules repeated each other differently**.

## 2. Issue catalog

### 2.1 HIGH — Five attachment/document patterns for one concept

| Module | Table | Doc-type FK | Expiry | Discriminator |
|---|---|---|---|---|
| PC | `dct_pc_attachments` | ❌ none | ❌ | `request_type` (PC\|REIMB\|CLEAR) |
| DT | `dt_documents` | ✅ | ✅ | `source_type` |
| CC | `dct_cc_attachments` | via `doc_req_id` | ❌ | `source_type` + `reference_id` |
| FL | `dct_fl_documents` | ✅ | ✅ + alert log | `source_type` (5 values) |
| HR | `hr_employee_documents` | ✅ | ✅ | (employee-only) |

Five upload implementations, five retrieval APIs, five expiry-handling behaviors (three of them: none). Every new module re-decides this.

### 2.2 HIGH — Duplicated budget-coding line tables

`dct_pc_budget_lines`, `dct_pc_reimb_budget_lines`, `dct_pc_clear_budget_lines`, `dct_cc_reimb_lines` are structurally the same row: *(parent, line_num, coding_type, GL cc or project/task/exp-type, amount)*. DT and FL store the same coding inline on the header instead. Validation logic (GL vs PROJECT exclusivity, segment checks) is reimplemented per table in each module package.

### 2.3 HIGH — Free-text references to real master tables

`project_number VARCHAR2(50)`, `task_number VARCHAR2(50)`, `expenditure_type VARCHAR2(100)` appear in PC/CC line tables and DT/FL coding columns with **no FK** to `dct_projects`, `dct_project_tasks`, `dct_expenditure_types` — even though those masters exist and are seeded (`db/v2/12_dct_master_data.sql`). Same for `dct_fl_bank_accounts.bank_name` vs `dct_bank_codes`. Orphans are possible today; renames in masters silently break history.

### 2.4 MEDIUM — Status fragmentation, no status history

Each module hard-codes its own status enum in CHECK constraints (7 distinct vocabularies). The same word means different things (`ACTIVE` = "advance open" in PC, "engaged" in FL, "card usable" in CC). No module records status transitions — only the approval engine's actions are historized, and DRAFT→SUBMITTED or ADVANCE_PAID→TRAVELLED transitions bypass it. Cross-module dashboards ("everything waiting on Finance") require a UNION of 10+ tables.

### 2.5 MEDIUM — Denormalized totals without protection

`dt_requests.total_per_diem_aed` / `total_advance_aed` must equal sums over `dt_destinations` + allowances, but are only recomputed when `DCT_DT_PKG.CALC_PER_DIEM` is explicitly called. Any direct DML on destinations leaves stale totals. (`total_days` is fine — virtual column.)

### 2.6 MEDIUM — Domain codes trapped in CHECK constraints

`pc_type`, `mission_type`, `trip_type`, `replacement_reason`, `billing_method` etc. are CHECK-constraint literals, while the platform has a lookup framework (`dct_lookup_categories/values`) and HR already migrated grade categories out of a CHECK into lookups (`final apps/HR/db/_archive/patch_grade_category_lookup.sql` — the proven pattern). Consequence today: adding a mission type is a DDL change + redeploy instead of a row insert.

### 2.7 LOW — Naming inconsistency

`dt_*` and `hr_*` vs `dct_pc_*` / `dct_fl_*` / `dct_cc_*`. Cosmetic, but it breaks `dct_%` wildcard maintenance queries and the ADMIN-synonym generation script pattern used for ORDS.

### 2.8 LOW — CC card status encodes in-flight operations

`dct_credit_cards.status` mixes state (ACTIVE/INACTIVE) with operations (INCREASING_IN_PROGRESS…). The open request in `dct_cc_requests` already says the same thing; two sources of truth that can disagree.

### 2.9 LOW — Settings keys undocumented

~30 module-setting keys (FISCAL_YEAR_START_MONTH, RATE_STRUCTURE, DOC_EXPIRY_ALERT_DAYS…) are discoverable only by reading seed scripts. No catalog, no validation that a key a package reads was ever seeded.

### 2.10 LOW — Delegation not consistently honored in approvals

`dct_delegations` exists with scoping, but approval-step resolution does not consistently call `dct_auth.get_effective_user()`; behavior when a delegate acts (who is recorded?) is untested/undocumented.

## 3. Approval engine — specific review

The engine is the platform's best asset, with three dormant capabilities:
1. **Escalation** (`escalation_days`, `escalate_role_id`) — columns populated by seeds, no scheduler job evaluates them.
2. **Auto-approve** (`auto_approve_days`) — same.
3. **Parallel approval** (`is_sequential='N'`) — no module uses it; untested path.

Recommendation: one daily `JOB_DCT_APPROVAL_SWEEP` implementing 1+2, plus a test template exercising 3 before any module relies on it.

## 4. Verdict

The model does not need a redesign — it needs **convergence**. The core is solid; the five modules should stop owning five private copies of three cross-cutting concepts (documents, budget coding lines, status lifecycle). The proposed model in [02-proposed-model.md](02-proposed-model.md) removes ~6 tables, adds 2 shared ones, and adds the missing FKs — a net simplification that mostly *deletes* structure rather than adding it.
