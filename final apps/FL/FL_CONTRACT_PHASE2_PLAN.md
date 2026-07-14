# Freelancers Module — Phase 2 Plan: Contract Phase

**Status:** IMPLEMENTED & DEPLOYED (2026-07-14) — all layers live in PROD (db/25–29 + db/v2/11c + reporting/db/22 + FL JET 4.10.0 + webtier release 20260714195221; tests 19/19 + 15/15 + 11/11 + 7/7). Remaining: Admin data setup (role grants + approver-map rows) and a formal UAT round.
**Date:** 2026-07-14 (v3 — D1–D8 resolved; APEX-workflow direction noted as separate topic)

> **Platform direction note (user, 2026-07-14 — SEPARATE TOPIC, not this phase):** the long-term intent is to adopt the **Oracle APEX Workflow engine** as ONE common, flexible workflow solution for ALL i-Finance workflow requirements, with intuitive end-user UI pages (inbox, task detail, diagram/progress). That is a platform-level initiative to be designed and planned on its own (migration path for the existing DCT approval templates/instances across Admin/PC/DT/HR/FL/CC/AR/TM included). **This phase deliberately keeps the workflow STATIC on the existing custom DCT approval engine** — the 7-step chain below — so the contract process ships now; it will be a migration candidate when the APEX workflow platform lands.
**Basis:** the manual **"New Contract / New MOU Approval Form and Termsheet" (Legal Affairs Department)** currently uploaded to Mersal, provided by the user 2026-07-14.
**Prerequisite phase:** Phase 1 — Registration revamp (deployed 2026-06-27, see `docs/deployment-notes.md`).

---

## 1. Where the Freelancer process stands today

The freelancer lifecycle in i-Finance is: **Registration → Contract → Payment (schedule/vouchers) → Deliverables → Renewal/Amendment**.

| Process | Status |
|---|---|
| **1. Registration** | ✅ **Phase 1 revamp LIVE** (2026-06-27): dual-channel intake (staff JET + public Portal with email OTP), AI document extraction (Passport/EID/Bank letter, Gemini↔Claude fallback), duplicate block/flag engine, **line-manager-first approval** (per-instance dynamic approver), bank capture → account on approval. Portal v1.9.0, FL JET 4.6.x. |
| **2. Contract** | ⚙️ **Basic build only** (original Phase 4, 2026-06-12): CRUD + versioning, GL/PROJECT coding, auto payment schedule, amendments, renewals. Approval = generic 2-step (FL Manager → FL Admin when ≥ 50k). **Does NOT reflect the real Legal-Affairs termsheet process** — this phase closes that gap. |
| 3. Vouchers / payment | ✅ Working (invoice → submit → approve → mark paid); untouched by this phase except where new contract fields flow through. |
| 4. Deliverables / compliance docs | ✅ Working (accept/reject, expiry alerts). |
| 5. Renewals / amendments | ✅ Working on the old field set — will be extended to carry the new termsheet fields. |

Open ops items from Phase 1 (not blockers for this plan): instance SMTP for OTP email, `REG_OTP_DEV_ECHO` must be reset to `N` before go-live, `AI_FEATURES_ENABLED` currently toggled per demo.

---

## 2. The manual process being digitized

The current paper/Mersal process for a new freelancer contract:

1. Requestor fills the **New Contract/MOU Approval Form & Termsheet** (Legal Affairs layout: service provider, contract type, initiative/project, contract manager, description, amount, payment terms, advance/retention/bond/PCG/insurance, dates, procurement involvement, FTE-conversion question, services summary, comments).
2. Form is **endorsed by an Administrative Officer** (signature block).
3. Uploaded to **Mersal** — From: *Department Director* → To: *Executive Director* (same sector), CC: *Talent Acquisition Manager*.
4. **Distribution plan** (sequential endorsements): Line Manager → Finance Business Partner → AP Operations Manager → Finance Director → Organization Development Head (**only for 6-month+ contracts**) → TA Manager → **HR Director (final Approve)**.
5. **Attachments:** Passport photo, Passport copy, Family Book, Emirates ID, Certificate, Identification form.

**Phase 2 goal (per D3 — REPLACE Mersal):** run this entire flow inside i-Finance — structured termsheet on the contract record, the real approval chain, enforced attachments — with the filled Legal-Affairs form **generated as a PDF for legal filing/archive**. i-Finance becomes the system of record; no Mersal upload step remains in the process.

---

## 3. Gap analysis — form field → current data model

| Termsheet field | Today in `DCT_FL_CONTRACTS` | Plan |
|---|---|---|
| Date / Ref | `created_at`; no ref | NEW `termsheet_ref` auto (`FL-TS-000123`) stamped on submit |
| Name of Service Provider | ✅ via `freelancer_id` | reuse |
| Contract type (Contractor/Consultant/Supplier/Other) | ❌ | NEW `contract_type` + lookup `FL_CONTRACT_TYPE` (lookup-first, no CHECK) |
| Initiative/Project | only coding `project_number` | NEW `initiative` VARCHAR2(400) (free text; coding block unchanged) |
| Contract Manager / End user | ❌ | NEW `contract_manager_user_id` (DCT user picker, FK `dct_users`) |
| Contract description | `title` only | NEW `description` VARCHAR2(2000) |
| Contract Amount | ✅ `total_amount` + currency | reuse |
| Terms of Payment | `billing_method` (structural) | NEW `payment_terms` VARCHAR2(1000) (narrative; billing fields still drive the schedule) |
| Advance Payment | ❌ | NEW `advance_payment` VARCHAR2(400) |
| Retention (if applicable) | ❌ | NEW `retention_terms` VARCHAR2(400) |
| Performance Bond (if applicable) | ❌ | NEW `performance_bond` VARCHAR2(400) |
| Parent Company Guarantee (if applicable) | ❌ | NEW `parent_co_guarantee` VARCHAR2(400) |
| Details of insurance required | ❌ | NEW `insurance_details` VARCHAR2(1000) |
| Expected start & completion date | ✅ `start_date`/`end_date` | reuse; **`end_date` becomes required** for new termsheet contracts (drives the 6-month approval rule) |
| Procurement Dept involvement YES/NO + why | ❌ | NEW `procurement_involved` (Y/N) + `procurement_why` VARCHAR2(1000) (required when N) |
| FTE-conversion question (Yes-direct / Yes-outsourced / No) | ❌ | NEW `fte_conversion` + lookup `FL_FTE_CONVERSION` |
| Summary of services / key deliverables | deliverables table exists but free | NEW `services_summary` VARCHAR2(2000); deliverable rows stay the operational tracking |
| Comments | `notes` | reuse |
| Endorsement by (Admin Officer) | ❌ | captured by the approval chain itself (see §4, decision D6) |

**Attachments matrix (reuses unified `DCT_DOCUMENTS` + `DCT_DOC_REQUIREMENTS`, `source_module='FL'`, `source_type='CONTRACT'`):**

| Required doc | Source |
|---|---|
| Passport photo, Passport copy, Emirates ID | usually already on the freelancer profile from Registration — the contract submit gate **auto-satisfies from profile docs** (valid/unexpired) and only demands upload when missing/expired |
| Family Book, Certificate, Identification form | NEW `DCT_DOCUMENT_TYPES` entries; uploaded on the contract |

---

## 4. Approval chain design

Replace the generic 2-step `FL_CONTRACT_APPROVAL` template with the real distribution plan:

| Seq | Step | Routing | Condition |
|---|---|---|---|
| 10 | Line Manager — Endorse | **USER_SPECIFIC** dynamic approver (Phase-1 mechanism: `dynamic_approver_user_id`; captured on the contract, defaulted from the freelancer's registration line manager) | ALWAYS |
| 20 | Finance Business Partner — Endorse | role `FL_FIN_BP` — **SCOPED: dept → sector → any holder** (see §4.1) | ALWAYS |
| 30 | AP Operations Manager — Endorse | role `FL_AP_OPS_MGR` (scoped-capable, org-wide by default) | ALWAYS |
| 40 | Finance Director — Endorse | role `FIN_DIRECTOR` (new, platform-reusable) | ALWAYS |
| 50 | Organization Development Head — Endorse | role `ORG_DEV_HEAD` (new) | **duration ≥ 6 months** (new condition — see engine note) |
| 60 | TA Manager — Endorse | role `TA_MANAGER` (new) | ALWAYS |
| 70 | HR Director — **Approve** (final) | role `HR_DIRECTOR` (new) | ALWAYS |

- **Engine note:** `DCT_APPROVAL_STEPS.condition_type` already allows `CUSTOM` in its CHECK constraint, but the FL engine (`07_fl_pkg_workflow`) only evaluates `ALWAYS`/`AMOUNT`. Plan: extend the **FL engine only** to evaluate `CUSTOM` with a named evaluator (`FL_DURATION_GE_6M` computed from start/end dates at submit time). No shared DDL change; other modules unaffected.
- Steps remain editable in Admin → Approval Templates (roles, order, conditions), so org changes never need code.
- The Mersal memo routing (**CC TA Manager**) is represented as a notification to the TA Manager role at submit; the From/To parties (Dept Director / Exec Director) are captured as fields on the termsheet and printed on the PDF (**D5 = Yes**).
- "Endorse" vs "Approve": engine-wise every step is an approval; the UI labels steps 10–60 **Endorse** and step 70 **Approve** (template step names carry it).

### 4.1 Scoped approver resolution (D2 answer: per Department/Cost Center, fallback per Sector)

The endorsers (FBP in particular) differ by organizational unit, so role-wide routing is not enough. Design:

- **New table `DCT_FL_APPROVER_MAP`** — `(role_code, scope_type DEPT|SECTOR, org_id, user_id, active flags, audit)`. One row assigns a named user as that role's approver for a department (cost center) or a sector.
- **Resolution at submit time** (per scoped step): ① exact **department** (the contract's `org_id`) match → ② the department's parent **sector** match → ③ **fallback: any holder of the role** (fail-safe so a missing mapping never strands a contract). The resolved user is stamped as that step's per-instance approver (extends the Phase-1 `dynamic_approver_user_id` mechanism from one column to a per-step value in `DCT_APPROVAL_STEP_ACTIONS`/instance-step context — exact vehicle decided at build; additive either way).
- Sector = the department org's parent in `DCT_ORGANIZATIONS` (walk up the hierarchy; verified during Layer 1).
- **Admin UI**: a small "Contract Approver Assignments" management page in the FL app (FL_ADMIN-gated) — role × org picker × user picker, list + CRUD. This is where HR/Finance maintain who the FBP for each department/sector is.
- Applies to any step flagged scoped; initially only FBP (step 20) is seeded scoped, the mechanism supports scoping others later without code.

---

## 5. Work breakdown — layer by layer (deploy + verify each before the next)

### Layer 1 — DB DDL & seed (`FL/db/25_fl_contract_phase2_ddl.sql`, `26_fl_contract_phase2_seed.sql`)
- Additive `ALTER TABLE dct_fl_contracts` — the ~14 new columns above plus the memo parties (`memo_from_user_id` Dept Director / `memo_to_user_id` Exec Director — user pickers, printed on the PDF; D5) (all nullable; enforcement at submit, mirroring the Phase-1 documents-first pattern). `termsheet_ref` + sequence.
- **New `DCT_FL_APPROVER_MAP`** (scoped approver assignments, §4.1) + indexes; verify the dept→sector walk in `DCT_ORGANIZATIONS`.
- Lookup seeds: `FL_CONTRACT_TYPE` (CONTRACTOR/CONSULTANT/SUPPLIER/OTHER), `FL_FTE_CONVERSION` (DIRECT_HIRE/OUTSOURCED/NO) — EN+AR via UNISTR.
- New roles seeded (`FL_FIN_BP`, `FL_AP_OPS_MGR`, `FIN_DIRECTOR`, `ORG_DEV_HEAD`, `TA_MANAGER`, `HR_DIRECTOR`) + permissions; assignments done in Admin UI.
- `DCT_DOCUMENT_TYPES`: FAMILY_BOOK, CERTIFICATE, IDENTIFICATION_FORM (+ verify PASSPORT_PHOTO exists); `DCT_DOC_REQUIREMENTS` rows for `FL/CONTRACT`.
- Approval template rebuild seed (idempotent upsert, same pattern as `03`/`14`).
- Idempotent guards throughout (`all_tab_columns` owner=PROD), SET DEFINE OFF, CRLF, keyword-free banners.

### Layer 2 — Package (`FL/db/27_fl_contract_phase2_pkg.sql`, canonical edit of the `07` workflow body)
- `submit_contract` revamp: field-completeness validation (required termsheet fields incl. `end_date`, procurement-why-when-No), **document gate** (requirements matrix, auto-satisfy from profile docs), line-manager resolution (`-20140/-20141` reuse), **scoped-approver resolution** (§4.1), stamp `termsheet_ref`, create instance with per-step dynamic approvers + duration context, CC-notification to TA Manager.
- `CUSTOM` condition evaluation (duration ≥ 6 months) in the step-selection cursor.
- **Amendments & renewals adopt the same 7-step chain NOW (D7):** `FL_AMENDMENT_APPROVAL` and `FL_RENEWAL_APPROVAL` templates rebuilt to the §4 chain; duration basis = the resulting contract term (renewal: new start→end; amendment: amended end − start). `submit_amendment`/`submit_renewal` gain the same scoped resolution. `create_renewed_contract` copies the termsheet fields.
- Status history writes to unified `DCT_REQUEST_STATUS_HISTORY` at each transition (already the FL convention).

### Layer 3 — ORDS (`FL/db/28_fl_contract_phase2_ords.sql` — fresh session, synonyms; re-runs the affected `fl.rest` handlers)
- Contract GET/POST/PUT extended with all new fields (guard clearable columns with `APEX_JSON.does_exist` — partial-PUT rule).
- `GET contracts/:id/requirements` — doc checklist state (required / satisfied-from-profile / uploaded / missing).
- `GET contracts/:id/termsheet` — the filled termsheet payload (for the PDF/print view).
- Approval endpoints unchanged (shared inbox already handles USER_SPECIFIC since Phase 1 `db/v2/11b`).

### Layer 4 — Frontend (FL JET; `contractEdit` is the centrepiece)
- **`contractEdit` → sectioned termsheet form** (platform classes + `.fl-*` form-layout block; model = AR's 67-field sectioned form): Parties & Type / Scope (initiative, description, services summary) / Commercials (amount, payment terms, advance, retention, bond, PCG, insurance) / Dates / Procurement / FTE conversion / Coding (existing GL/PROJECT block) / **Documents checklist** (`<doc-upload>`, auto-satisfied rows badged "from profile") / Comments. Review mode (`.fl-review`) for submitted+.
- **Approval progress timeline** on `contractDetail` — the 7 steps with Endorse/Approve labels, conditional step shown/hidden by duration, resolved approver names shown, current step highlighted (reuse the registration approval-history pattern from `db/24`).
- **"Contract Approver Assignments" page** (FL_ADMIN-gated) — CRUD over `DCT_FL_APPROVER_MAP`: role × Department/Sector × user, with an unmapped-departments hint (§4.1).
- **"Generate Termsheet (PDF)"** button on contractDetail (see Layer 5).
- Contracts list: contract type + termsheet ref columns/filters.
- i18n EN+AR for every new key; `functions_list.md` updated in the same change; `APP_VERSION` bump.

### Layer 5 — Termsheet PDF output (D1 = Word template)
**Word template via the Reporting Platform** (App 211 infra already live: docxtpl → LibreOffice on the vm180-182 fleet) — `fl_contract_termsheet.docx` reproducing the Legal Affairs layout (DCT logo header, red titles, the two-column table, memo From/To parties, preparer identity per D6, endorsement block showing the actual approval chain + decision timestamps), definition `FL_CONTRACT_TERMSHEET` (PYTHON engine, params `contract_id`), run via a small GL-bridge-style FL-gated `POST /fl/contracts/:id/termsheet-pdf` (same pattern as `GL/db/11` butil book bridge); the produced PDF is auto-attached to the contract's documents (`DCT_DOCUMENTS`, `source_type='CONTRACT'`) as the filed record (D3).

### Layer 6 — Tests, UAT, docs
- PL/SQL unit harness (submit validation matrix, duration condition, doc gate), API pytest (happy/edge/error 400-401-403-404/boundary — amount 0/huge, 5m29d vs 6m contracts, missing docs, procurement-No-without-why), Playwright E2E (full chain with 7 seeded persona users), regression on vouchers/renewals.
- UAT package per the Admin convention: round folder `UAT/UAT_FL_round<N>-dd-mm-yyyy/`, workbook + Word results + evidence; runner extends `uat_run_fl.py`.
- `docs/deployment-notes.md`, `STATUS.md`, `functions_list.md`, CLAUDE.md Module Status row, memory update.

**Deploy order:** 25 → 26 → 27 (re-run 07-canonical body) → 28 (fresh session) → frontend → smoke. All additive; existing contracts keep working (old rows have NULL termsheet fields and render on the legacy layout until edited).

---

## 6. Decisions — RESOLVED (user, 2026-07-14)

| # | Question | **Decision** |
|---|---|---|
| **D1** | Termsheet PDF output | **Word template** via the Reporting Platform (App 211, docxtpl) |
| **D2** | Endorser routing (FBP etc.) | **Per Department (Cost Center); if no department assignment, per Sector**; fail-safe fallback to any role holder — design in §4.1 |
| **D3** | Mersal | **Replace** — i-Finance becomes the system of record for the freelancer contract approval; the generated PDF is for legal filing/archive, not a Mersal round-trip |
| **D4** | Advance/retention/bond/PCG fields | **Free text now**, to be structured in a later phase |
| **D5** | Memo parties (From: Dept Director / To: Exec Director) | **Yes — capture** as fields on the termsheet, printed on the PDF |
| **D6** | Administrative Officer endorsement block | **Preparer only** — the creator's identity printed on the PDF; no extra approval step |
| **D7** | Amendments/renewals chain | **Adopt the new 7-step chain NOW** (this phase) |
| **D8** | Scope | **Freelancer contracts only** — MOUs/supplier contracts out of FL scope |

---

## 7. Out of scope (this phase)

- MOUs / non-freelancer supplier contracts (D8).
- Structuring the commercial free-text fields (advance/retention/bond/PCG) into numeric/percentage columns (D4 — later phase).
- Voucher/payment changes, portal-side contract visibility for freelancers (candidate for Phase 3).
- HR-module handoff for the FTE-conversion answer (data is captured; integration later).
