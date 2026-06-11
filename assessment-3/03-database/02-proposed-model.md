# Proposed Target Data Model — Unify, Normalize, Simplify

**Principle:** keep the core platform untouched; converge the five domain modules onto three shared structures and real FKs. Net effect: **−6 tables, +2 tables**, every module package gets smaller, and any future module (Prepaid Cards, Payment Requests…) inherits documents/coding/status for free.

Draft DDL for everything below is in [ddl/](ddl/) — **draft only, nothing deployed**.

---

## 1. Summary of changes

| # | Change | Replaces | Draft DDL |
|---|---|---|---|
| 1 | Unified `dct_documents` | `dct_pc_attachments`, `dt_documents`, `dct_cc_attachments`, `dct_fl_documents`, `hr_employee_documents` (5 → 1) | `ddl/01_dct_documents_unified.sql` |
| 2 | Unified `dct_budget_coding_lines` | `dct_pc_budget_lines`, `dct_pc_reimb_budget_lines`, `dct_pc_clear_budget_lines`, `dct_cc_reimb_lines` + inline DT/FL coding (4 tables + 2 inline → 1) | `ddl/02_dct_budget_coding_lines.sql` |
| 3 | Shared `dct_request_status_history` + standard status vocabulary | nothing (new capability) | `ddl/03_dct_request_status_history.sql` |
| 4 | Missing FKs + lookup migration | free-text refs, CHECK-constraint enums | `ddl/04_missing_fks_and_lookups.sql` |
| 5 | Migration mapping old → new | — | `ddl/05_migration_notes.sql` |

## 2. Unified documents — `dct_documents`

Generalize the FL pattern (the best of the five) to the whole platform:

```
dct_documents
  doc_id            IDENTITY PK
  source_module     VARCHAR2(10)   -- PC | DT | HR | FL | CC | ADMIN
  source_type       VARCHAR2(30)   -- module-defined: REQUEST, CLEARING, CONTRACT, EMPLOYEE…
  source_id         NUMBER         -- PK of the owning row
  reference_id      NUMBER NULL    -- optional line-level anchor (CC pattern)
  document_type_id  FK → dct_document_types
  doc_req_id        NUMBER NULL    -- optional link to a requirements rule
  file_name / mime_type / file_blob (or OCI Object Storage URL later)
  expiry_date DATE NULL, alert_days_before NUMBER NULL
  + standard audit columns
```

- `dct_document_types.applies_to_modules` already exists to validate `source_module` (`db/v2/12_dct_master_data.sql`).
- `dct_doc_expiry_alerts` (generalized from `dct_fl_doc_expiry_alerts`) gives **every** module expiry alerting from one daily job — PC and CC gain expiry support they currently lack.
- Document requirements (`dt_doc_requirements`, `dct_cc_doc_requirements`) likewise merge into one `dct_doc_requirements` keyed by (source_module, context_code).
- One ORDS upload/download endpoint pair under `/ords/admin/dct/documents/` replaces five per-module implementations.

## 3. Unified budget coding — `dct_budget_coding_lines`

```
dct_budget_coding_lines
  line_id        IDENTITY PK
  source_module  VARCHAR2(10)
  source_type    VARCHAR2(30)    -- PC | PC_REIMB | PC_CLEAR | CC_REPL | DT_REQ | DT_STL | FL_CONTRACT
  source_id      NUMBER
  line_num       NUMBER
  coding_type    VARCHAR2(10)    -- GL | PROJECT
  cc_id          FK → dct_gl_code_combinations   (required when GL)
  project_id     FK → dct_projects               (required when PROJECT)
  task_id        FK → dct_project_tasks
  exp_type_id    FK → dct_expenditure_types
  amount         NUMBER(15,2)
  description    VARCHAR2(500)
  + merchant_name / receipt_attached as nullable extension cols (CC) — or a CC-specific
    satellite table if more card-only fields appear
  + standard audit columns
  CHECK: (coding_type='GL' AND cc_id IS NOT NULL AND project_id IS NULL)
      OR (coding_type='PROJECT' AND project_id IS NOT NULL AND cc_id IS NULL)
```

- The GL-vs-PROJECT exclusivity rule is enforced **once** in the schema instead of in four packages.
- DT/FL header-level coding becomes a single line row — uniform read path for reporting ("all spend by GL account across modules" becomes one query).
- ID-based FKs replace `project_number`/`task_number`/`expenditure_type` free text (issue 2.3).

## 4. Standard request lifecycle — `dct_request_status_history` + vocabulary

New shared table (append-only, trigger- or package-fed):

```
dct_request_status_history
  hist_id, source_module, source_type, source_id,
  old_status, new_status, changed_by FK → dct_users, changed_at, comments
```

Plus a **standard status vocabulary** seeded as a lookup category `REQUEST_STATUS`:

`DRAFT, SUBMITTED, PENDING_APPROVAL, RETURNED, APPROVED, REJECTED, CANCELLED, IN_PROGRESS, CLOSED`

Module-specific states map onto it with a module qualifier kept in the module's own column (e.g. DT keeps ADVANCE_PAID/TRAVELLED as sub-states of IN_PROGRESS). Rule for new modules: **only** vocabulary statuses. Benefit: one cross-module "everything pending finance" query, full transition audit independent of the approval engine.

## 5. DT totals — protect the denormalization

Keep the columns (APEX reports want them) but make staleness impossible: compound trigger on `dt_destinations` recomputing `dt_requests.total_per_diem_aed` (+ a `dt_requests_v` that computes live totals for verification). Alternative considered and rejected: dropping the columns — would break the deployed `DT_REQUESTS_V` and JET dashboard contracts.

## 6. CC status simplification

`dct_credit_cards.status` shrinks to `ACTIVE | INACTIVE | CLOSED`; in-flight operations derive from open rows in `dct_cc_requests` (a view `dct_cc_cards_v` exposes `pending_operation`). Removes the dual-source-of-truth risk before DCT_CC_PKG is written — **do this first, it's free while the package is still a stub.**

## 7. Naming — pragmatic recommendation

Do **not** mass-rename `dt_*`/`hr_*` to `dct_*`: both modules are deployed with live ORDS endpoints, views, packages and JET contracts; the churn outweighs the cosmetic gain. Instead: (a) freeze the rule "all new tables use `dct_<mod>_`", (b) add compatibility synonyms `dct_dt_requests → dt_requests` etc. so maintenance scripts can rely on the `dct_%` pattern.

## 8. Migration strategy (phased, zero big-bang)

1. **Create new shared tables empty** (scripts 01–03). No module touched.
2. **Adopt module-by-module at the moment each module is next opened for work**:
   - CC first (package not yet written — adopts unified tables natively, zero migration).
   - FL next (no UI yet — only package changes).
   - PC when flipping mock→live ORDS (its services are being touched anyway).
   - DT last (most deployed surface).
3. Per module: backfill INSERT-SELECT (mapping in `ddl/05_migration_notes.sql`), repoint package + ORDS handlers, keep old table as a renamed `_bak` for one release, then drop.
4. FKs from script 04 are added `NOVALIDATE` first (same approach already used in `db/v2/12_dct_master_data.sql`), orphans reported and fixed, then `VALIDATE`.

**Execution conventions** (per `CLAUDE.md`): run via SQLcl `sql -name prod_mcp`, `SET DEFINE OFF`, objects created as `prod.<name>`, individual INSERTs (never INSERT ALL with identity columns), ADMIN synonyms for any object referenced from ORDS handlers.
