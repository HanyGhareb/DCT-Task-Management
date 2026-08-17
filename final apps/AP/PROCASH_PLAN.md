# Procash Transactions — Implementation Plan (App 212 / AP)

**Status:** APPROVED 2026-08-17 — ALL PHASES COMPLETE — built, deployed and verified on PROD
**Date:** 2026-08-17
**Owner app:** Accounts Payable (App 212), `ap.rest` at `/ords/admin/ap/`
**Author:** i-Finance platform team

---

## 1. What this is

A **Procash transaction** records a **manual payment made outside Fusion Payables** — the payment
instruction is pushed through the bank portal directly. It is captured in i-Finance as a
master–detail record with full budget coding, attachments and an audit trail, and is later
**reconciled to the Fusion payable invoice** once that invoice is created.

It is a **record of a payment that already happened** (or is about to be pushed), not a payment
engine: i-Finance never sends anything to the bank.

### Decisions taken (user, 2026-08-17)

| # | Decision |
|---|---|
| Host app | **AP (App 212)** — new pages; first WRITE tables in AP (read-only analytics today) |
| Lifecycle | **Configurable**: ship the simple lifecycle + module setting `PROCASH_APPROVAL_MODE = NONE\|WORKFLOW` that inserts a DWP approval chain |
| Excel | **VBAFE add-in only** — Oracle Visual Builder Add-in for Excel over new `/xl/` routes (same pattern as `BUDGET_OVERRIDE`) |
| Invoice link | **Validated pick from the AP extract** (`AP_INVOICES_HEADER_V`) — stores invoice id/number/supplier/date/amount + mismatch flag |
| Payment number | System-generated `PCH-#####`; `bank_reference` is the unique business key |
| Paying bank account | **Manual free-text for now** (no picker, no validation) — upgradeable later |
| Payee | Optional supplier reference validated vs `ATD_SUPPLIERS` + free-text payee name |
| Currency | `amount` in transaction currency; `exchange_rate` defaults from `DCT_CURRENCY_CODES`, overridable; `amount_aed` derived; AED forces rate 1 |
| Date | **`payment_date`** = the bank **value date** (the user corrected "amount date") |
| Business Unit | Required; stores the **exact** Fusion BU name |
| Coding | **Either/or per line**: project/task/expenditure-type **or** GL combination, both validated against the masters |
| Line sum | Lines must sum to the header amount — **hard block on submit**, warn while DRAFT |
| Line number | Auto-assigned, resequenced on save |
| Invoice cardinality | **One invoice per transaction** |
| Post-link | Record **locked** except attachments/comments; `PROCASH_ADMIN` can unlink |
| Roles | `PROCASH_USER` / `PROCASH_PROCESSOR` / `PROCASH_ADMIN` |
| Visibility | All AP users read; edit restricted to owner + admin |
| Approval chain | Line manager → Finance Director (when mode = WORKFLOW), editable in the BPM designer |
| Attachments | Shared `DCT_DOCUMENTS`, checklist offered, **not mandatory** |
| Reporting | **Yes** — Reporting-Platform register (XLSX + PDF book) in scope |
| GL/budget effect | **None** — a procash transaction is a record only; consumption happens when the Fusion invoice lands |

---

## 2. Data model (PROD schema)

Lookup-first: **no status CHECK constraints**; value sets live in `DCT_LOOKUP_VALUES` and are
validated by `DCT_LOOKUP_PKG.validate_lookup`.

### 2.1 `DCT_AP_PROCASH` — header

| Column | Type | Notes |
|---|---|---|
| `procash_id` | NUMBER IDENTITY PK | |
| `payment_number` | VARCHAR2(30) UNIQUE | auto `PCH-#####` (`dct_ap_procash_num_seq` + setting `PROCASH_NUMBER_PREFIX`) |
| `bank_reference` | VARCHAR2(100) NOT NULL UNIQUE | the bank portal reference — the business key, also the Excel join key |
| `bank_account` | VARCHAR2(200) | **free text** (paying account / portal) |
| `business_unit` | VARCHAR2(240) NOT NULL | exact Fusion BU name |
| `supplier_number` | VARCHAR2(30) | optional, validated vs `ATD_SUPPLIERS` (`TO_CHAR` — it is NUMBER there) |
| `supplier_name` | VARCHAR2(400) | snapshot at pick time |
| `payee_name` | VARCHAR2(400) | free text (when no supplier) |
| `amount` | NUMBER(18,2) NOT NULL | transaction currency |
| `currency_code` | VARCHAR2(3) NOT NULL | FK `DCT_CURRENCY_CODES` |
| `exchange_rate` | NUMBER(18,8) NOT NULL | defaulted from the currency snapshot; forced 1 for AED |
| `amount_aed` | virtual `ROUND(amount*exchange_rate,2)` | |
| `payment_date` | DATE NOT NULL | **bank value date** |
| `description` | VARCHAR2(1000) | |
| `comments` | VARCHAR2(4000) | |
| `status` | VARCHAR2(30) NOT NULL | lookup `PROCASH_STATUS` |
| `wf_instance_id` | NUMBER | DWP convention — nullable, **no FK** |
| `processed_by` / `processed_on` | NUMBER / TIMESTAMP | stamped by `PROCASH_PROCESSOR` |
| `invoice_id` | NUMBER | Fusion invoice id from the extract (deep-linkable) |
| `invoice_number` | VARCHAR2(100) | |
| `invoice_supplier` | VARCHAR2(400) | |
| `invoice_date` | DATE | |
| `invoice_amount` | NUMBER(18,2) | |
| `invoice_currency` | VARCHAR2(3) | |
| `invoice_linked_by` / `invoice_linked_on` | NUMBER / TIMESTAMP | |
| `amount_mismatch` | virtual `'Y'/'N'` | `ABS(invoice_amount - amount) > 0.005` |
| `created_by` / `created_on` / `updated_by` / `updated_on` | | audit (the "create/update by + timestamp" fields) |

Indexes: `status`, `payment_date`, `business_unit`, `invoice_number`, `created_by`.

### 2.2 `DCT_AP_PROCASH_LINE` — detail

| Column | Type | Notes |
|---|---|---|
| `line_id` | NUMBER IDENTITY PK | the VBAFE row identity for the lines object |
| `procash_id` | NUMBER NOT NULL | FK → header, **ON DELETE CASCADE** |
| `line_num` | NUMBER NOT NULL | auto, unique per header, resequenced on save |
| `coding_basis` | VARCHAR2(10) NOT NULL | lookup `PROCASH_CODING_BASIS` = `PROJECT` \| `GL` |
| `project_number` | VARCHAR2(12) | FK `DCT_PROJECTS` |
| `task_number` | VARCHAR2(30) | FK `(project_number, task_number)` → `DCT_TASKS` |
| `expenditure_type` | VARCHAR2(255) | FK `DCT_EXPENDITURE_TYPES` |
| `gl_combination` | VARCHAR2(320) | canonical 10-segment, normalised through `prod.dct_cc_canon`, validated vs `DCT_GL_CODE_COMBINATIONS` |
| `amount` | NUMBER(18,2) NOT NULL | header currency |
| `comments` | VARCHAR2(1000) | |
| audit cols | | |

Package-enforced: `PROJECT` basis ⇒ project+task+etype required and GL blank; `GL` basis ⇒ combination
required and project trio blank.

### 2.3 Shared structures reused (no private tables)

- **Attachments** → `DCT_DOCUMENTS` with `source_module='AP'`, `source_type='PROCASH'`, `source_id=procash_id`; raw-binary upload (`:body`, `MAX_UPLOAD_MB` → 413). Checklist seeded in `DCT_DOC_REQUIREMENTS` as **optional** (Payment advice, Bank confirmation, Supporting invoice, Approval email).
- **Status history** → `DCT_REQUEST_STATUS_HISTORY` (`changed_by` is a numeric user id, NOT NULL).
- **Audit diffs** → `DCT_AUDIT_PKG` snapshots under the existing `FEATURE_AUDIT_SNAPSHOTS_AP` switch.

### 2.4 Lookups (`DCT_LOOKUP_VALUES`, EN+AR)

- `PROCASH_STATUS` — DRAFT · SUBMITTED · IN_APPROVAL · APPROVED · PROCESSED · INVOICED · REJECTED · CANCELLED
- `PROCASH_CODING_BASIS` — PROJECT · GL
- `PROCASH_DOC_TYPE` — the four optional attachment types

### 2.5 Module settings (`DCT_MODULE_SETTINGS`, module AP)

| Key | Default | Meaning |
|---|---|---|
| `PROCASH_APPROVAL_MODE` | `NONE` | `NONE` \| `WORKFLOW` |
| `PROCASH_NUMBER_AUTO` | `Y` | |
| `PROCASH_NUMBER_PREFIX` | `PCH-` | |
| `PROCASH_LINE_SUM_ENFORCE` | `Y` | block submit when lines ≠ header |
| `PROCASH_ATTACH_REQUIRED` | `N` | per decision — attachments optional |

`value_type` must be one of BOOLEAN/NUMBER/TEXT/SELECT/COLOR.

### 2.6 Roles

`PROCASH_USER`, `PROCASH_PROCESSOR`, `PROCASH_ADMIN` in `DCT_ROLES` (category `JOB`).
AP is already in the `db/v2/50` CASE map, so module access is unchanged — a procash user still needs
AP module access.

---

## 3. Lifecycle

```
DRAFT ──submit──►  SUBMITTED ────────────────────────────┐   (approval mode NONE)
      └─submit──►  IN_APPROVAL ──approve──► APPROVED ────┤   (approval mode WORKFLOW)
                        │  reject/return                 │
                        └────────► DRAFT                 ▼
                                                    PROCESSED ──link invoice──► INVOICED
                                                  (processed_by/on)
```

- `CANCELLED` reachable from DRAFT/SUBMITTED/IN_APPROVAL by owner or admin.
- Edits allowed in DRAFT (owner/admin) and, for admins only, up to PROCESSED.
- After `INVOICED`: locked except attachments and comments; `PROCASH_ADMIN` may unlink → back to PROCESSED.

---

## 4. PL/SQL — `DCT_AP_PROCASH_PKG`

| Routine | Purpose |
|---|---|
| `create_header` / `update_header` / `delete_draft` | header CRUD, number generation, rate defaulting |
| `save_line` / `delete_line` / `renumber_lines` | detail CRUD with coding validation |
| `validate` | mandatory fields, coding basis, line-sum rule, currency/rate sanity — returns a findings list |
| `submit` | applies `PROCASH_APPROVAL_MODE`; starts the DWP instance when WORKFLOW |
| `mark_processed` | `PROCASH_PROCESSOR`; stamps `processed_by`/`processed_on` |
| `link_invoice` / `unlink_invoice` | validated against the AP extract; sets the mismatch flag |
| `add_doc` | shared `DCT_DOCUMENTS` writer |
| `bulk_upsert` | ≤500 rows, per-row `CREATED/UPDATED/ERROR` — **shared by the VBAFE routes**, matching on `bank_reference` |
| `on_wf_complete` / `on_wf_reject` / `on_wf_return` | 4-arg CTX hooks for the DWP action registry |

Oracle rules honoured: individual `INSERT`s (never `INSERT ALL` with IDENTITY); helpers used in SQL DML
published in the spec (PLS-00231); `TO_NUMBER(... ON CONVERSION ERROR)` only in SQL, never in a
declaration initializer.

---

## 5. Approval (only when `PROCASH_APPROVAL_MODE = WORKFLOW`)

- DWP process **`PROCASH_APPROVAL`**: `LINE_MANAGER` resolver (fallback `ANY_ROLE_HOLDER` `PROCASH_ADMIN`, since the employee/manager extract is still thin) → `ROLE` `FIN_DIRECTOR` (fallback `BUSINESS_ADMIN`), outcome set `APPROVE_REJECT_RETURN`.
- **Route uses its own module code `AP_PROCASH`** in `DCT_WF_ROUTE`, *not* `AP` — so nothing else in the AP module is entangled with the workflow engine, and rollback stays a one-row UPDATE.
- Fact view `DCT_AP_PROCASH_WF_FACT_V` for step conditions (amount thresholds, BU, coding basis).
- Hooks `ON_COMPLETE` → `APPROVED`, `ON_REJECT` → `REJECTED`, `ON_RETURN` → `DRAFT`.
- UI uses the shared `<wf-action-bar>` / `<wf-timeline>` — **no hard-coded Approve/Reject verbs anywhere**.
- The seed script rebuilds the definition only while 0 instances exist; after that, edits go through the BPM designer.

---

## 6. ORDS — additive on `ap.rest`

New script `AP/db/10_procash_ords.sql` (**additive; `03` rebuilds `ap.rest` from scratch**).

| Method | Path | Notes |
|---|---|---|
| GET | `procash/` | register: status / BU / date range / supplier / invoice-linked / search, server-paged |
| POST | `procash` | create header (+ optional lines) — **no trailing slash on POST collections** |
| GET | `procash/:id` | header + lines + documents + status history + workflow timeline |
| PUT | `procash/:id` | partial update, guarded with `APEX_JSON.does_exist` (no blind wipes) |
| DELETE | `procash/:id` | DRAFT only |
| POST | `procash/:id/submit` · `/process` | lifecycle transitions |
| POST/DELETE | `procash/:id/invoice` | link / unlink |
| GET/POST | `procash/:id/lines` | line list / add |
| PUT/DELETE | `procash/:id/lines/:lineId` | |
| GET | `procash/lovs` | statuses, currencies, BUs, coding basis, doc types |
| GET | `procash/coding/projects\|tasks\|etypes\|gl` | type-ahead pickers (**`q` is ORDS-reserved → use `search`**) |
| GET | `procash/invoice-search` | validated pick from `AP_INVOICES_HEADER_V` |
| GET/POST/DELETE | `procash/:id/documents` (+ `documents/:docId/file`) | raw-binary `:body`, dereferenced **once** |
| GET | `procash/export` | CSV, UTF-8 BOM |
| POST | `procash/report` (+ status/file) | Reporting-Platform bridge — in `AP/db/12` |

Standard handler contract: `dct_rest.validate_session` at the top (no argument — `:body` must be
dereferenced separately as BLOB), `q'[...]'` literals, `APEX_JSON` output, error map
`-20401→401, -20403→403, -20404→404, -20001/-20090→400, else 500`, 404 decided **before** `json_header`,
every displayed timestamp through `prod.dct_to_local` with `HH:MI AM` formats.

**AP post-03 re-run list becomes: 04, 06, 07, 10, 12.**

---

## 7. VBAFE — Excel templates (Visual Builder Add-in)

New package `DCT_XL_PROCASH_PKG` (`db/v2/121_xl_procash.sql`), routes **added into `db/v2/107`**
(that script `DELETE_MODULE`s `xl.rest`, so a separate additive script would be wiped by any re-run —
the routes must live in 107 itself, the same lesson as `db/v2/66`).

Auth reuses `dct_xl_pkg.require_user` (HTTP Basic validated against `DCT_USERS` in-handler; `/xl/` is
ORDS-public and therefore outside the `db/v2/50` gate by design).

### Business objects / sheets

| # | Object | Route | Sheet | Purpose |
|---|---|---|---|---|
| 1 | `ProcashSingle` | `xl/procash/single[/:id]` | **default sheet** | **one header + one detail line in one row** — the one-shot entry |
| 2 | `ProcashHeader` | `xl/procash/headers[/:id]` | sheet "Headers" | header fields for the multi-line template |
| 3 | `ProcashLine` | `xl/procash/lines[/:id]` | sheet "Lines" | N lines joined to their header by `bank_reference` |
| 4 | `ProcashInvoice` | `xl/procash/invoices[/:id]` | sheet "Invoice Update" | bulk-fill invoice details on PROCESSED transactions (writable: invoice fields only) |

Rules:
- **Row identity field is `id`**, matching the `{id}` path param (BUDGET_OVERRIDE lesson).
- **Create + update, DRAFT rows only** — a non-DRAFT row rejects writes by field, not by route.
- The invoice sheet is the exception: it writes invoice fields on PROCESSED rows.
- OpenAPI is **hand-authored** in `emit_openapi` (the auto open-api-catalog of a custom module carries no field schemas → the add-in "finds the object" but lists no fields).
- Template workbook registered in the **VB Template Repository** (`DCT_XL_TEMPLATE` code `PROCASH_ENTRY`, one ACTIVE version, master + published files) so the AP page can offer a download via `GET /xl/templates/download?code=PROCASH_ENTRY`.
- Guide: `docs/excel-integration/VBAFE_PROCASH_GUIDE.md`.

---

## 8. Frontend — AP JET app

New nav group **Procash** with two views (shared shell, platform classes only — no bespoke markup):

**`procash` (register)**
- Filter region (status / BU / date range / supplier / invoice-linked / mismatch / search) + KPI tiles (count & AED by status, awaiting invoice, amount mismatches).
- Results on the shared `<interactive-report>` (code `AP_PROCASH`) with **tinted status pills**, row click → detail.
- New / Export CSV / Export Excel / Download Excel template / Generate Report buttons, top-right.

**`procashEntry` (create / edit / view)**
- Header form on `.form-grid`; actions top-right (Save · Submit · Process · Link Invoice · Back).
- **Lines grid** with add/edit/delete, coding-basis radio per line, type-ahead project/task/etype datalists and a cascading GL picker (the FL contract Budget-Allocation pattern), live **lines-total vs header-amount** indicator that turns red when out of balance.
- Tabs: Lines · Documents (`<doc-upload>`) · Approval (`<wf-timeline>` + `<wf-action-bar>`, shown only in WORKFLOW mode) · History.
- Invoice-link drawer: search the AP extract, pick, mismatch warning, Fusion deep-link via shared `fusionLinks.js`.

EN/AR + RTL, every `t()` key in **both** `app.en.json` and `app.ar.json`, Latin digits.
Bind every nullable field as `$data.field` (APEX_JSON omits NULL keys). `APP_VERSION` 1.18.1 → **1.19.0**.

---

## 9. Reporting

`PROCASH_REGISTER` in `reporting/db/37_rpt_procash_register.sql` — MULTI / PYTHON:
- **XLSX**: sheet per section — Headers · Lines · Invoice linkage · Exceptions (unlinked, mismatched, out-of-balance).
- **PDF book** via a DB-stored template `procash_book.html.j2` (**the default `report.html.j2` has no sections loop — a MULTI PDF needs its own template**).
- Params mirror the page filters; `param_spec_json` via `JSON_MERGEPATCH` on an existing definition.
- Bridge routes in `AP/db/12` (`POST procash/report`, status, file).
- **37 is MERGE-bearing → deploy via python-oracledb on a worker VM, never Linux SQLcl.**

---

## 10. Build order (deploy + verify each layer before the next)

| Phase | Deliverable | Verify | Result |
|---|---|---|---|
| **P0** | This plan | your approval | ✅ approved 2026-08-17 |
| **P1** | `AP/db/08_procash_ddl.sql` (tables, sequence, lookups, settings, roles, doc requirements) + `09_procash_pkg.sql` | PL/SQL unit harness (standalone asserts — utPLSQL is not installed), 0 INVALID | ✅ **45/45** (`tests/procash_unit.sql`), 0 INVALID |
| **P2** | `AP/db/10_procash_ords.sql` | pytest API suite: happy path, 400/401/403/404, boundary (line sum, 500-row bulk, currency/rate) | ✅ **81/81** (`tests/procash_api_smoke.py`), 19 templates |
| **P3** | AP JET register + entry views, i18n EN/AR | Playwright browser smoke EN + AR/RTL | ✅ **36/36** (`tests/procash_browser_smoke.py`), APP_VERSION 1.19.0 |
| **P4** | `AP/db/11_procash_wf.sql` (DWP process, fact view, route `AP_PROCASH`) | submit → approve → approve → APPROVED via `/wf/`; reject and return paths | ✅ **22/22** (`tests/procash_wf_smoke.py`), mode restored to NONE |
| **P5** | `db/v2/121_xl_procash.sql` + `107` route/OpenAPI edit + template workbook + guide | add-in round trip: download → edit → publish (single, multi-line, invoice-update) | ✅ **17/17** (`tests/procash_xl_test.sql`); OpenAPI + Basic-auth challenge verified over HTTP; workbook registered as `PROCASH_ENTRY` |
| **P6** | `reporting/db/37` + `AP/db/12` bridge | XLSX + PDF render, totals reconcile to the page | ✅ rendered live: XLSX 5 sheets, PDF 3 pages |
| **P7** | `AP/docs/deployment-notes.md`, `AP/docs/functions_list.md`, CLAUDE.md Module Status, UAT round under `AP/UAT/UAT_AP_round<N>-dd-mm-yyyy/` | UAT workbook + Word results + evidence screenshots | ✅ docs updated; **UAT round 1 = 22/22** (`UAT/UAT_AP_round1-17-08-2026/`) |

Script numbering confirmed free: `AP/db/08–12`, `db/v2/121`, `reporting/db/37`.

---

## 11. Risks / open items

1. **Bank account is free text** — no validation against any bank master. If procash volume grows,
   this becomes the first thing users ask to be a picker; the column is sized to take a code later.
2. **`LINE_MANAGER` resolver** depends on manager data that is still thin platform-wide — the
   `ANY_ROLE_HOLDER PROCASH_ADMIN` fallback is load-bearing until the employee extract lands.
3. **Invoice pick lags the extract** — an invoice created in Fusion today is only pickable after the
   ATD AP extract runs. Users linking same-day will see nothing; the page states this explicitly.
4. **No budget effect** — a procash payment consumes nothing until its Fusion invoice posts, so
   between payment and invoice the spend is invisible to Budget Utilization. Confirmed acceptable;
   the register's "awaiting invoice" KPI is the compensating control.
5. **VBAFE requires the add-in** on each user's Excel; there is no in-page upload fallback by decision.
6. `03_ap_ords.sql` rebuilds `ap.rest` — the re-run list (04, 06, 07, 10, 12) must be respected on every deploy.
