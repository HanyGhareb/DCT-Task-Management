# Freelancers (App 203) — Requirements & Feature Assessment

**Purpose:** Full freelancer engagement lifecycle: registration & vetting → approved profile with bank accounts → contracts (with amendments/renewals) → deliverables acceptance → payment schedule → payment vouchers pushed to Oracle Fusion. The most table-rich module (13 tables) and the only one integrating with an external ERP.

**Primary sources:** `final apps/FL/STATUS.md`, `final apps/FL/db/01_fl_ddl.sql` (13 tables), `final apps/FL/db/04_fl_pkg.sql` (DCT_FL_PKG — complete).

---

## 1. Actors

| Actor | Capabilities |
|---|---|
| Freelancer (external, `is_external='Y'`) | Self-register, upload documents, view contracts/payments, request profile changes |
| Staff submitter | Register a freelancer on their behalf (`submitted_by` SELF \| STAFF) |
| FL Admin (`IS_FL_ADMIN`) | Vet registrations, manage contracts, blacklist |
| FL Finance (`IS_FL_FINANCE`) | Payment schedules, vouchers, Fusion push |

## 2. Functional requirements

### 2.1 Registration & vetting (implemented at DB/PLSQL level)
- Pre-approval registration with photo, nationality (national ID mandatory when nationality = AE), first-deal flag — `dct_fl_registrations`, statuses DRAFT → SUBMITTED → APPROVED/REJECTED/RETURNED.
- On approval, `DCT_FL_PKG` creates the freelancer profile (`dct_fl_freelancers`, vendor_number) **and an external user account** — the only module that provisions users.
- Blacklisting with reason (`status = BLACKLISTED`).

### 2.2 Bank accounts (implemented)
- Multiple accounts per freelancer, exactly one primary, IBAN + currency — `dct_fl_bank_accounts`.

### 2.3 Contracts (implemented — richest workflow in the platform)
- Versioned contracts with renewal chain (`renewed_from_contract_id`), billing method/unit, GL or PROJECT coding, statuses through AMENDED / RENEWAL_IN_PROGRESS — `dct_fl_contracts` (28 cols) + `dct_fl_contract_amendments` + `dct_fl_contract_renewals`.
- On contract approval the package generates the payment schedule; amendments rebuild it.

### 2.4 Deliverables (implemented)
- Per-contract deliverables with acceptance workflow (PENDING → SUBMITTED → ACCEPTED/REJECTED/SUPERSEDED) — `dct_fl_deliverables`.

### 2.5 Payments & Fusion integration (implemented as stub)
- Payment schedule rows (milestones) → vouchers with statuses PENDING → SUBMITTED_TO_FUSION → FUSION_ACKNOWLEDGED → PAID/FAILED — `dct_fl_payment_schedule`, `dct_fl_payment_vouchers`.
- `DCT_FL_PKG` contains the push-to-Fusion REST call (stub) and a Fusion callback receiver.

### 2.6 Documents & compliance (implemented)
- Unified store across REGISTRATION | FREELANCER | CONTRACT | DELIVERABLE | VOUCHER sources with `document_type_id` FK and expiry alerts; duplicate-alert prevention via `dct_fl_doc_expiry_alerts`; daily dispatcher job. **This is the best document pattern in the platform — the DB proposal generalizes it.**

### 2.7 Profile change control (implemented)
- Post-approval changes to email/phone/bank account require an approval-routed request — `dct_fl_profile_change_requests`.

## 3. Current status (verified 2026-06-11)

| Layer | Status | Evidence |
|---|---|---|
| DB + views + seed + package + audit cols | ✅ Deployed | `final apps/FL/db/` 01→05 |
| ORDS | ⬜ Not started | no `06_fl_ords.sql` |
| JET SPA | ⬜ **No `Jet/` folder** (CLAUDE.md status table says complete — stale) | `final apps/FL/STATUS.md` §JET |
| APEX | ⬜ Not started | STATUS.md checklist |

## 4. Gaps & recommendations

| # | Gap | Recommendation | Effort |
|---|---|---|---|
| F1 | No UI at all (no JET, no APEX) despite complete backend | Scaffold `final apps/FL/Jet/` from the HR template per STATUS.md §JET; ORDS module `/ords/admin/fl/` first | L |
| F2 | Freelancer self-service portal undefined — external users have accounts but nothing to log into | Decide: dedicated external-facing JET app (reduced nav, registration wizard, contract/payment view) vs APEX public-facing app. The registration wizard mockup (`04-uiux/mockups/request-wizard-concept.html`) shows the suggested direction | L |
| F3 | Fusion push is a stub | Implement against Fusion AP invoice REST; add retry + FAILED reprocessing queue | L |
| F4 | Bank account uses free-text `bank_name` although `dct_bank_codes` master exists | FK to `dct_bank_codes` (DB proposal §4) | S |
| F5 | Vendor-number generation rules undocumented | Document format + sequence ownership in STATUS.md | S |
| F6 | Contract expiry / renewal reminders rely on doc-expiry job only | Add contract end-date alerts to the daily dispatcher | S |
