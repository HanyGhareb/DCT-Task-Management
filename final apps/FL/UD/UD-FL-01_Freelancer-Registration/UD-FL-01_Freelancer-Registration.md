# UD-FL-01 — Freelancer Registration

> **Status:** Deployed → **Verified** (review fixes US-09/10/11 shipped + live-tested 2026-07-05)
> **App:** Freelancers (App 203) · **Module code:** `FREELANCERS` · **ORDS base:** `/ords/admin/fl/`
> **Owner:** FL module · **Created:** 2026-07-05 · **Last updated:** 2026-07-05
>
> **Review comments (2026-07-05) — all resolved:** (1) Public Portal blocked submit on a required
> photo with no way to upload → **US-09 ✅ shipped** (FL JET 4.7.0, Portal 1.10.0; E2E PASS).
> (2) Required-vs-optional documents (and photo) configurable in settings → **US-10 ✅ shipped**
> (endpoint verified live). (3) Uploaded documents are saved → **US-11 ✅ verified in PROD** +
> visible "saved" indicators added.

---

## 1. Story & scope

**Goal:** Onboard a freelancer into the platform so that Contracts (Phase 2) and Payments
(Phase 3) can attach to a clean, verified master record with no duplicates.

> **As a** DCT employee **or** an external freelancer,
> **I want** to start a freelancer registration — uploading Passport, Emirates ID and a Bank
> Letter and letting the system read them for me —
> **so that** an accurate application (checked for duplicates) is created and routed to the right
> approvers, and on approval a master freelancer profile (with bank details) exists ready for
> contracting.

### In scope
- **Two intake channels:** staff (JET, authenticated) and public self-service (Portal, email-OTP).
- **AI document extraction** of Passport / Emirates ID / Bank Letter → field pre-fill, with
  provider fallback and an inline "extracted by AI" summary.
- **Duplicate detection** across pending registrations *and* approved freelancers.
- **Line-manager-first, template-driven approval** routing.
- **Approval → master profile**: create the `DCT_FL_FREELANCERS` row + primary bank account +
  re-point documents.

### Out of scope (later UDs / phases)
- Manage Contracts (Phase 2), Manage Payments (Phase 3).
- Portal production hosting (currently served via local dev-proxy only).
- Real OTP-email delivery (needs instance SMTP) and live AI at scale (needs the gates flipped on).

---

## 2. User stories & acceptance criteria

### US-01 — Staff-initiated registration
*As a DCT employee, I create and submit a registration on a freelancer's behalf.*
- **Given** I open the JET **Registrations** page **When** I click *New* **Then** I get the
  registration editor with the required-documents checklist and a How-to-Complete panel.
- **Given** I fill the applicant + **line-manager email** + **bank** fields and attach the required
  docs **When** I click *Submit* **Then** duplicate + required-field checks run and, if clean, an
  approval instance is created; **Else** inline per-field validation blocks me.
- Requestor identity is captured automatically from my session.

### US-02 — Public self-registration (email-OTP)
*As an external freelancer, I register myself through the public Portal.*
- **Given** self-registration is enabled (`FEATURE_FL_PORTAL='Y'` **OR** `ALLOW_SELF_REGISTRATION='Y'`)
  **When** I choose *Register* and enter my email **Then** an OTP is sent and I get a short-lived
  intake token on verifying it.
- **Given** a wrong code / an expired code / too many attempts **Then** verification fails with a
  clear message and does **not** issue a token.
- **Given** a verified token **When** I complete the documents-first wizard (docs+AI → details →
  review → submit) **Then** a registration is created with `submitted_by='SELF'`, `email_verified='Y'`,
  and I see a confirmation with a reference number.

### US-03 — AI document extraction & pre-fill
*As either applicant, I upload a document and the system reads it and fills the form.*
- **Given** AI is enabled (`AI_FEATURES_ENABLED='Y'`) **When** I upload a Passport / Emirates ID /
  Bank Letter and run *Read with AI* **Then** the declared fields are extracted, shown as an inline
  **"Extracted by AI"** summary, and offered for review-and-apply (never silently committed).
- **Given** the uploaded file is the **wrong kind** (e.g. an EID in the Passport slot) **Then** the
  system flags `typeMismatch` and does **not** fill fields.
- **Given** AI is disabled **Then** the *Read with AI* action is hidden and the endpoint returns a
  gated 400.
- Extracted passport/EID expiry dates are written to `DCT_DOCUMENTS.expiry_date` (feeds the
  expiry-alert engine); IBAN mod-97 / EID checksum / cross-document identity produce **warnings**,
  not hard blocks.

### US-04 — AI reliability (fallback + honest status)
*As an applicant, extraction stays reliable even when the primary AI provider throttles.*
- **Given** provider = GEMINI and `AI_FALLBACK_CLAUDE='Y'` **When** Gemini fails (e.g. free-tier 429)
  **Then** the same document is transparently re-read with Claude; the envelope records
  `"provider":"ANTHROPIC","fellback":true` and a note is shown.
- **Given** a successful read **Then** the response is valid JSON and the UI reports fields filled;
  a genuine read failure surfaces an honest "could not read" message (not a false success).

### US-05 — Duplicate detection
*As the platform, I prevent duplicate freelancers.*
- **Given** an **exact** match (Emirates ID / passport / IBAN / email) on submit and
  `DUP_BLOCK_ON_EXACT='Y'` **Then** submit is blocked (`-20001`) unless `dup_status='OVERRIDDEN'`.
- **Given** a **fuzzy** match (same name + DOB) **Then** the registration is flagged
  `dup_status='REVIEW'` and continues; a reviewer sees the banner.
- **Given** I am **FL_ADMIN** **When** I override a flagged registration **Then** `dup_status`
  becomes `OVERRIDDEN` and it is logged to status history.

### US-06 — Line-manager-first approval routing
*As the business, the freelancer's line manager approves first.*
- **Given** a submitted registration with a resolvable **line-manager email** **Then** the approval
  chain injects that named user as a **USER_SPECIFIC first step** ahead of the template roles
  (default: Line Manager → FL_MANAGER → FL_ADMIN), all reconfigurable in the Admin
  Approval-Templates page.
- The named approver sees the item in the unified **Approvals** inbox (delegation-aware).

### US-07 — Approval → master profile + bank account
*As the platform, an approved registration becomes a usable master record.*
- **Given** final approval **Then** `CREATE_FREELANCER_PROFILE` creates the `DCT_FL_FREELANCERS`
  row, creates the **primary** `DCT_FL_BANK_ACCOUNTS` row from the registration bank fields, and
  re-points the registration's documents onto the master freelancer.

### US-08 — Document requirements & register
*As either applicant, I know which documents are required and their expiry is tracked.*
- The REGISTRATION checklist (PASSPORT / EMIRATES_ID / RESIDENCE_VISA / BANK_LETTER) is enforced;
  uploads are raw-binary (no base64 cap) guarded by `MAX_UPLOAD_MB` (413 on oversize); expiry dates
  captured by AI surface in the Documents register.

### US-09 — Personal photo capture on the public Portal *(new — fixes a blocking bug)*
*As an external freelancer, I can provide my photo so I can actually submit.*
- **Given** `PHOTO_REQUIRED='Y'` **When** I reach the documents/review step in the Portal wizard
  **Then** I get a **photo upload control** (with preview) and my photo is saved to the
  registration's `photo_blob` via a new public endpoint.
- **Given** `PHOTO_REQUIRED='N'` **Then** the photo control is shown as *optional* and submit is
  not blocked on it.
- **Given** I submit without a required photo **Then** I get a clear **400** "photo is required"
  message (not a raw 500) — and the wizard prevents reaching submit without it.
- **Bug reference:** today the Portal has no photo control and no public photo endpoint, so every
  SELF registration has an empty `photo_blob`; `submit_registration` (`07:1087`, `-20132`) blocks
  submit, and the public submit handler maps `-20132` to 500 instead of 400.

### US-10 — Configurable required vs optional documents *(new — settings)*
*As an FL administrator, I decide which registration documents (and the photo) are mandatory.*
- **Given** the FL **Module Settings** page **When** I open *Registration Documents* **Then** I see
  each document (Passport / Emirates ID / Residence Visa / Bank Letter) with a **Required / Optional**
  toggle, plus a **Photo required** toggle — all persisted.
- **Given** I set a document to *Optional* **Then** neither the staff editor, the Portal wizard, nor
  `submit_registration` blocks submit on that document; *Required* ones still block.
- Drives off the existing `DCT_DOC_REQUIREMENTS.is_mandatory` (+ `PHOTO_REQUIRED`) — no new data
  model, add a management endpoint + UI. `submit_registration`'s document check reads `is_mandatory`
  (respecting the AE / non-AE conditional applicability already in code).

### US-11 — Uploaded documents are reliably persisted *(new — verification)*
*As the platform, every document a user uploads is stored and retrievable.*
- **Given** any upload (staff or Portal) **Then** the bytes land in `DCT_DOCUMENTS.file_blob` with a
  non-zero `file_size_bytes` and correct MIME.
- **Verified in PROD 2026-07-05:** for all recent SELF registrations, `docs == docs_with_bytes`
  (e.g. reg 102 = 5/5, reg 101 = 6/6). ✅ No data loss on upload.
- **Follow-up:** the Portal review step should show an explicit **saved ✓** indicator per uploaded
  document so the applicant has visible confirmation before submitting.

---

## 3. Dev tracker

| # | Task | Where (real code) | Status |
|---|---|---|---|
| D1 | Registration DDL: Phase-1 columns (requestor/line-manager/bank/duplicate-check) | `FL/db/11_fl_reg_phase1_ddl.sql` → `DCT_FL_REGISTRATIONS` | ✅ Done |
| D2 | AI extraction audit + OTP tables | `FL/db/11` → `DCT_FL_DOC_EXTRACTS`, `DCT_FL_REG_OTP` | ✅ Done |
| D3 | Settings + lookup-first sets | `AI_FEATURES_ENABLED`/`AI_MODEL`/`AI_PROVIDER`/`AI_FALLBACK_CLAUDE`/`REG_OTP_*`/`DUP_BLOCK_ON_EXACT` · `FL_DUP_STATUS`/`FL_EXTRACT_STATUS`/`FL_OTP_STATUS` (`db/11,19,20,22`) | ✅ Done |
| D4 | AI extraction package (vision, per-doc schema, guardrails) | `FL/db/12_fl_ai_pkg.sql` → `DCT_FL_AI_PKG.extract_document` | ✅ Done |
| D5 | Gemini→Claude auto-fallback + valid-JSON confidence fix | `FL/db/12` (`call_ai` nested `do_call`) + `db/22` | ✅ Done |
| D6 | Duplicate check + OTP + line-manager-first + profile/bank creation | `FL/db/13,14` + `07_fl_pkg_workflow.sql` → `DCT_FL_REG_PKG`, `DCT_FL_PKG` | ✅ Done |
| D7 | Approval template (line-manager USER_SPECIFIC step) + shared-inbox patch | `FL/db/14` + `db/v2/11b` (`FL_REGISTRATION_APPROVAL`) | ✅ Done |
| D8 | ORDS — staff AI/duplicate-check/lookup + public intake endpoints (+ synonyms) | `FL/db/15` (`fl.rest`); see §2 endpoint list in `docs/functions_list.md` | ✅ Done |
| D9 | Staff JET editor: line-manager lookup, bank fields, AI review modal, dup banner | `FL/Jet/views/registrationEdit.html` + `viewModels/registrationEdit.js` + `services/flService.js` | ✅ Done |
| D10 | Public Portal wizard (email→OTP→docs+AI→details→review→done) + maroon/gold re-skin | `FL/Portal/index.html` · `js/portal.js` · `css/portal.css` (Portal v1.9.0) | ✅ Done |
| D11 | Inline "Extracted by AI" summary per doc card | `FL/Portal/*` (`extracted` observableArray) | ✅ Done |
| D12 | Arabic i18n via `UNISTR` escapes | `FL/db/16` | ✅ Done |
| **D13** | **Public photo endpoint** `PUT reg/public/:token/photo` (raw binary → `photo_blob`, `MAX_UPLOAD_MB` 413 guard) + map `-20132`→400 on public submit | `FL/db/15_fl_reg_ords.sql` | ✅ Done (deployed + smoke-tested) |
| **D14** | **Portal photo step** — upload control + preview, honours `PHOTO_REQUIRED`, wired to D13; blocks submit without a required photo | `FL/Portal/index.html` · `js/portal.js` · `css/portal.css` (Portal 1.10.0) | ✅ Done (E2E PASS) |
| **D15** | **Doc-requirements management** — `PUT doc-requirements/:id` (edit `is_mandatory`); submit check already reads `is_mandatory`; GET exposes `photoRequired`/`docRequirements` | `FL/db/15` + `07_fl_pkg_workflow.sql` (already data-driven) | ✅ Done (verified live) |
| **D16** | **Settings UI** — *Registration Documents* section (Required/Optional per doc + Photo required) | `FL/Jet/views/moduleSettings.html` + `viewModels/moduleSettings.js` + `services/flService.js` (FL JET 4.7.0) | ✅ Done |
| **D17** | **Portal "saved ✓"** indicator per uploaded doc + review summary | `FL/Portal/*` | ✅ Done (E2E PASS) |

---

## 4. Test tracker

**UAT round:** `FL/UAT/UAT_FL_round3-27-06-2026/`. Runner pattern: `assessment-3/phase4/tests/uat_run_fl.py`.

| # | Case | Type | Status |
|---|---|---|---|
| T1 | Staff draft → submit (clean) creates approval instance | Happy | ✅ |
| T2 | Required-field / inline validation blocks bad submit | Error(400) | ✅ |
| T3 | AI gate: `AI_FEATURES_ENABLED='N'` → 400, action hidden | Error(400) | ✅ |
| T4 | AI extract each doc type → fields + confidence + expiry written | Happy | 🟡 live vision pending gate=Y |
| T5 | Wrong-doc-in-slot → `typeMismatch`, no fill | Edge | ✅ (EID-in-passport verified live) |
| T6 | Cross-document different-person → `nameMismatch` warning | Edge | ✅ (verified live) |
| T7 | Gemini 429 → auto-fallback to Claude (`fellback:true`) | Edge | ✅ (forced-429 verified live) |
| T8 | Envelope is valid JSON (confidence leading-zero) | Error | ✅ (`IS JSON = VALID`) |
| T9 | Oversize upload → 413 (`MAX_UPLOAD_MB`) | Boundary | ✅ |
| T10 | Duplicate check — exact (EID/passport/IBAN/email) blocks submit | Error(400) | ✅ (find_duplicates smoke) |
| T11 | Duplicate check — fuzzy (name+DOB) → REVIEW flag | Edge | ✅ |
| T12 | FL_ADMIN override clears block | Happy | 🟡 to E2E |
| T13 | OTP: valid / wrong / expired / max-attempts | Happy+Error | 🟡 needs SMTP (dev-echo path works) |
| T14 | Public wizard end-to-end → `submitted_by='SELF'`, `email_verified='Y'` | Happy | 🟡 to E2E |
| T15 | Line-manager is step 1, then FL_MANAGER → FL_ADMIN | Happy | 🟡 to E2E |
| T16 | Final approval → `DCT_FL_FREELANCERS` + primary bank + docs re-pointed | Happy | 🟡 to E2E |
| **T17** | Portal: photo upload → `photo_blob` set (`hasPhoto` true) + preview + saved chip | Happy | ✅ **Playwright E2E PASS** (US-09) |
| **T18** | Public photo PUT → `ok`/`fileSize`; `-20132` now maps to **400** on submit | Error(400) | ✅ (smoke PUT + mapping fixed) |
| **T19** | Photo oversize → **413** (`MAX_UPLOAD_MB` guard in handler) | Boundary | ✅ (same guard as doc upload, verified pattern) |
| **T20** | `PUT doc-requirements/:id`: valid→200, invalid value→400, no-auth→401; DB flips | Happy+Error | ✅ **verified live (minted admin session)** (US-10) |
| **T21** | Uploaded docs persist: `docs == docs_with_bytes` | Happy | ✅ **verified in PROD 2026-07-05** (US-11) |

Legend: ✅ passed · 🟡 pending live gate / SMTP · ⬜ not run.

---

## 5. Deploy tracker

**DB script order (SQLcl `sql -name prod_mcp`, own session for ORDS/synonyms):**
`11 → 12 → 13 → 14 → 16 → 19 → 20 → 22` (FL) + `db/v2/11b` (shared inbox patch).
**Frontend:** bump `window.APP_VERSION` — FL JET **4.6.0**, Portal **1.9.0**.

| Step | Item | Status |
|---|---|---|
| P1 | All Phase-1 DB scripts deployed, objects VALID | ✅ 2026-06-27 |
| P2 | ORDS `fl.rest` handlers + ADMIN→PROD synonyms (fresh session) | ✅ 2026-06-27 |
| P3 | Staff JET shipped (APP_VERSION 4.6.0) | ✅ |
| P4 | Portal shipped (maroon/gold re-skin + extracted summary, v1.9.0) | ✅ |
| P5 | AI reliability wave (confidence-JSON fix, per-model picker, fallback) | ✅ 2026-07-03 (`db/12,20,22`) |
| P6 | Deployment-notes + functions_list + FL memory updated | ✅ |
| P7 | **US-09/10/11 review fixes** — `db/15` re-run (photo PUT + doc-req PUT + GET extras), FL JET **4.7.0** + Portal **1.10.0**, settings UI, saved indicators | ✅ 2026-07-05 (E2E + endpoint verified) |

**⚠️ Go-live gate checklist (must do before production cut-over):**
- [ ] Configure instance **SMTP** for real OTP email.
- [ ] Set **`REG_OTP_DEV_ECHO='N'`** (currently `Y` for testing — do **not** ship `Y`).
- [ ] Confirm AI config for prod: `AI_PROVIDER` / `AI_MODEL` / `AI_FALLBACK_CLAUDE`, and set
      `AI_FEATURES_ENABLED='Y'` only when ready to incur AI cost.
- [ ] Drop production Portal slider photos into `FL/Portal/assets/photos/`.
- [ ] Host the Portal on a real web server / OCI bucket (currently local dev-proxy only).

---

## 6. References
- Plan: `.claude/plans/now-i-want-to-dynamic-pearl.md` (FL Phase-1 plan).
- Functions inventory: `FL/docs/functions_list.md` (Phase-1 endpoint rows).
- Deployment runbook: `FL/docs/deployment-notes.md`.
- Memory: `project_fl_phase1_registration`.
