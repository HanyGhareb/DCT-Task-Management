# Business Requirements Document — Freelancers Module (App 203)
**Version:** 1.0 | **Status:** Approved | **Date:** 2026-05-14
**Schema:** PROD | **App ID:** 203 | **App Alias:** FL

---

## 1. Overview

The Freelancers module manages the full lifecycle of freelancer engagements for the Finance Division: registration and vetting, contract issuance, payment scheduling, voucher generation, deliverable tracking, document expiry, contract renewals, and a self-service portal for freelancers.

---

## 2. Functions

| # | Function | Tables |
|---|---|---|
| 1 | Registration | DCT_NATIONALITY, DCT_FL_REGISTRATIONS, DCT_FL_FREELANCERS, DCT_FL_BANK_ACCOUNTS, DCT_FL_DOCUMENTS |
| 2 | Contract Management | DCT_FL_CONTRACTS, DCT_FL_CONTRACT_AMENDMENTS, DCT_FL_PAYMENT_SCHEDULE |
| 3 | Payment Vouchers | DCT_FL_PAYMENT_VOUCHERS |
| 4 | Deliverable Tracking | DCT_FL_DELIVERABLES |
| 5 | Document Expiry | DCT_FL_DOC_EXPIRY_ALERTS (extends DCT_FL_DOCUMENTS) |
| 6 | Contract Renewals | DCT_FL_CONTRACT_RENEWALS |
| 7 | Self-Service Portal | DCT_FL_PROFILE_CHANGE_REQUESTS |

---

## 3. Roles

| Role Code | Description |
|---|---|
| `FL_ADMIN` | Full module access — manages all freelancers, contracts, vouchers, proxies |
| `FL_MANAGER` | Approves registrations, contracts, amendments, vouchers, renewals |
| `FL_USER` | Staff who submit registrations/contracts on behalf of a freelancer |
| `FL_FREELANCER` | Freelancer portal access — view own data, submit deliverables |

---

## 4. Function 1 — Registration

### 4.1 `DCT_NATIONALITY`
Standalone platform-level lookup for nationalities (shared across modules).

| Column | Type | Notes |
|---|---|---|
| `nationality_id` | NUMBER IDENTITY PK | |
| `nationality_code` | VARCHAR2(3) NOT NULL | ISO alpha-2 (AE, IN, PK…) |
| `nationality_name_en` | VARCHAR2(100) NOT NULL | |
| `nationality_name_ar` | VARCHAR2(100) | |
| `is_active` | VARCHAR2(1) DEFAULT 'Y' | |
| `display_seq` | NUMBER DEFAULT 99 | |
| `created_at` | TIMESTAMP | |
| `updated_at` | TIMESTAMP | |

### 4.2 `DCT_FL_REGISTRATIONS`
Registration request submitted before a freelancer profile is created.

| Column | Type | Notes |
|---|---|---|
| `registration_id` | NUMBER IDENTITY PK | |
| `registration_number` | VARCHAR2(50) UNIQUE NOT NULL | Sequence-generated |
| `first_name_en` | VARCHAR2(100) NOT NULL | |
| `last_name_en` | VARCHAR2(100) NOT NULL | |
| `first_name_ar` | VARCHAR2(100) | |
| `last_name_ar` | VARCHAR2(100) | |
| `date_of_birth` | DATE NOT NULL | |
| `nationality_code` | VARCHAR2(3) NOT NULL | FK → DCT_NATIONALITY |
| `national_id` | VARCHAR2(50) | Required when nationality_code = 'AE' |
| `passport_number` | VARCHAR2(50) | |
| `email` | VARCHAR2(200) NOT NULL | |
| `mobile` | VARCHAR2(20) | |
| `specialization` | VARCHAR2(200) | |
| `photo_mime_type` | VARCHAR2(100) | |
| `photo_filename` | VARCHAR2(200) | |
| `photo_blob` | BLOB | Required if PHOTO_REQUIRED = Y |
| `first_deal_with_dct` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `submitted_by` | VARCHAR2(10) DEFAULT 'SELF' NOT NULL | SELF / STAFF |
| `submitted_by_user_id` | NUMBER | FK → DCT_USERS (if submitted_by = STAFF) |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | DRAFT / SUBMITTED / APPROVED / REJECTED / RETURNED |
| `approval_instance_id` | NUMBER | FK → DCT_APPROVAL_INSTANCES |
| `notes` | VARCHAR2(4000) | |
| `created_by` | NUMBER | FK → DCT_USERS |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | FK → DCT_USERS |
| `updated_at` | TIMESTAMP | |

**Validation:** `national_id` NOT NULL when `nationality_code = 'AE'` (enforced by PL/SQL validation + check constraint).

**On approval:** `DCT_FL_PKG.CREATE_FREELANCER_PROFILE(p_registration_id)` auto-creates DCT_FL_FREELANCERS + DCT_FL_BANK_ACCOUNTS records.

### 4.3 `DCT_FL_FREELANCERS`
Approved freelancer profile — created automatically on registration approval.

| Column | Type | Notes |
|---|---|---|
| `freelancer_id` | NUMBER IDENTITY PK | |
| `registration_id` | NUMBER NOT NULL | FK → DCT_FL_REGISTRATIONS |
| `vendor_number` | VARCHAR2(50) | Auto-generated if AUTO_GENERATE_VENDOR_NUM = Y |
| `first_name_en` | VARCHAR2(100) NOT NULL | |
| `last_name_en` | VARCHAR2(100) NOT NULL | |
| `first_name_ar` | VARCHAR2(100) | |
| `last_name_ar` | VARCHAR2(100) | |
| `date_of_birth` | DATE | |
| `nationality_code` | VARCHAR2(3) | FK → DCT_NATIONALITY |
| `national_id` | VARCHAR2(50) | |
| `passport_number` | VARCHAR2(50) | |
| `email` | VARCHAR2(200) NOT NULL | Used for portal login |
| `mobile` | VARCHAR2(20) | |
| `specialization` | VARCHAR2(200) | |
| `photo_mime_type` | VARCHAR2(100) | |
| `photo_filename` | VARCHAR2(200) | |
| `photo_blob` | BLOB | |
| `status` | VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL | ACTIVE / INACTIVE / BLACKLISTED |
| `blacklist_reason` | VARCHAR2(1000) | |
| `notes` | VARCHAR2(4000) | |
| `created_by` | NUMBER | FK → DCT_USERS |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | FK → DCT_USERS |
| `updated_at` | TIMESTAMP | |

### 4.4 `DCT_FL_BANK_ACCOUNTS`

| Column | Type | Notes |
|---|---|---|
| `bank_account_id` | NUMBER IDENTITY PK | |
| `freelancer_id` | NUMBER NOT NULL | FK → DCT_FL_FREELANCERS |
| `bank_name` | VARCHAR2(100) NOT NULL | |
| `account_number` | VARCHAR2(50) NOT NULL | |
| `iban` | VARCHAR2(34) | |
| `account_name` | VARCHAR2(200) NOT NULL | |
| `currency_code` | VARCHAR2(3) DEFAULT 'AED' NOT NULL | |
| `is_primary` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `is_active` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `notes` | VARCHAR2(1000) | |
| `created_by` | NUMBER | |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | |
| `updated_at` | TIMESTAMP | |

### 4.5 `DCT_FL_DOCUMENTS`
Unified document store for all module functions.

| Column | Type | Notes |
|---|---|---|
| `document_id` | NUMBER IDENTITY PK | |
| `freelancer_id` | NUMBER | FK → DCT_FL_FREELANCERS (for person-level docs) |
| `source_type` | VARCHAR2(20) NOT NULL | REGISTRATION / FREELANCER / CONTRACT / DELIVERABLE / VOUCHER |
| `source_id` | NUMBER NOT NULL | PK of the parent record |
| `document_type_id` | NUMBER NOT NULL | FK → DCT_LOOKUP_VALUES (FL_DOCUMENT_TYPE) |
| `document_name` | VARCHAR2(200) NOT NULL | |
| `file_mime_type` | VARCHAR2(100) | |
| `file_size` | NUMBER | Bytes |
| `file_blob` | BLOB | |
| `expiry_date` | DATE | NULL = no expiry |
| `alert_days_before` | NUMBER | Populated from DOC_EXPIRY_ALERT_DAYS module setting on insert |
| `is_required` | VARCHAR2(1) DEFAULT 'N' NOT NULL | Y/N |
| `status` | VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL | ACTIVE / SUPERSEDED |
| `notes` | VARCHAR2(1000) | |
| `created_by` | NUMBER | |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | |
| `updated_at` | TIMESTAMP | |

### 4.6 Module Settings (Function 1)

| Setting Code | Default | Description |
|---|---|---|
| `ALLOW_SELF_REGISTRATION` | Y | Enable public self-registration page (P9998) |
| `NATIONAL_ID_REQUIRED_FOR_AE` | Y | Mandatory Emirates ID for UAE nationals |
| `PHOTO_REQUIRED` | Y | Photo mandatory on registration |
| `AUTO_GENERATE_VENDOR_NUM` | Y | Auto-generate vendor number on freelancer creation |

### 4.7 Approval Template (Function 1)
- `FL_REGISTRATION_APPROVAL`: Step 1 — FL_MANAGER (ALWAYS) → Step 2 — FL_ADMIN (ALWAYS)

---

## 5. Function 2 — Contract Management

### 5.1 `DCT_FL_CONTRACTS`

| Column | Type | Notes |
|---|---|---|
| `contract_id` | NUMBER IDENTITY PK | |
| `contract_number` | VARCHAR2(50) UNIQUE NOT NULL | Sequence-generated |
| `version_number` | NUMBER DEFAULT 1 NOT NULL | Increments on direct edit if ALLOW_DIRECT_CONTRACT_EDIT = Y |
| `freelancer_id` | NUMBER NOT NULL | FK → DCT_FL_FREELANCERS |
| `renewed_from_contract_id` | NUMBER | FK → DCT_FL_CONTRACTS (self-ref, NULL for originals) |
| `title` | VARCHAR2(200) NOT NULL | |
| `start_date` | DATE NOT NULL | |
| `end_date` | DATE | NULL = open-ended |
| `total_amount` | NUMBER(15,2) NOT NULL | Contract value in AED |
| `currency_code` | VARCHAR2(3) DEFAULT 'AED' NOT NULL | |
| `billing_method` | VARCHAR2(20) NOT NULL | WEEKLY / MONTHLY / PER_COUNT |
| `billing_unit_id` | NUMBER | FK → DCT_LOOKUP_VALUES (FL_BILLING_UNIT); used when PER_COUNT |
| `billing_unit_amount` | NUMBER(15,2) | Amount per period or unit |
| `org_id` | NUMBER NOT NULL | FK → DCT_ORGANIZATIONS |
| `coding_type` | VARCHAR2(10) NOT NULL | GL / PROJECT |
| `cc_id_gl` | NUMBER | FK → DCT_GL_CODE_COMBINATIONS (when coding_type = GL) |
| `project_number` | VARCHAR2(50) | When coding_type = PROJECT |
| `task_number` | VARCHAR2(50) | |
| `expenditure_type` | VARCHAR2(100) | |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | DRAFT / SUBMITTED / APPROVED / ACTIVE / COMPLETED / CANCELLED |
| `approval_instance_id` | NUMBER | |
| `notes` | VARCHAR2(4000) | |
| `created_by / at / updated_by / at` | | |

**Status flow:** DRAFT → SUBMITTED → APPROVED → ACTIVE → COMPLETED / CANCELLED

**Amendment validations (before save):**
- `new_total_amount ≥ SUM(PAID schedule amounts)` — cannot reduce below paid
- `new_start_date` editable only if NO PAID schedule rows
- `new_end_date ≥ MAX(due_date) of PAID rows`
- `SUM(all schedule amounts) ≤ total_amount` — schedule total cap
- `billing_method` locked if any PAID rows exist
- Warning if VOUCHER_GENERATED rows exist (will be cancelled on approval)

### 5.2 `DCT_FL_CONTRACT_AMENDMENTS`

| Column | Type | Notes |
|---|---|---|
| `amendment_id` | NUMBER IDENTITY PK | |
| `contract_id` | NUMBER NOT NULL | FK → DCT_FL_CONTRACTS |
| `amendment_number` | NUMBER NOT NULL | Sequential per contract |
| `reason` | VARCHAR2(1000) NOT NULL | |
| `change_summary` | VARCHAR2(4000) | |
| `new_total_amount` | NUMBER(15,2) | |
| `new_start_date` | DATE | Editable only if no PAID rows on contract |
| `new_end_date` | DATE | |
| `new_billing_method` | VARCHAR2(20) | Locked if any PAID rows exist |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | DRAFT / SUBMITTED / APPROVED / REJECTED / CANCELLED |
| `approval_instance_id` | NUMBER | |
| `created_by / at / updated_by / at` | | |

**On amendment approval:** calls `DCT_FL_PKG.REBUILD_PAYMENT_SCHEDULE` — preserves PAID/SKIPPED rows, deletes PENDING rows, regenerates from first unpaid period using new dates/amounts. `version_number` incremented on contracts.

### 5.3 `DCT_FL_PAYMENT_SCHEDULE`

| Column | Type | Notes |
|---|---|---|
| `schedule_id` | NUMBER IDENTITY PK | |
| `contract_id` | NUMBER NOT NULL | FK → DCT_FL_CONTRACTS |
| `period_label` | VARCHAR2(100) NOT NULL | "May 2026", "Week 1", "Unit 3" |
| `due_date` | DATE NOT NULL | |
| `amount` | NUMBER(15,2) NOT NULL | |
| `voucher_id` | NUMBER | FK → DCT_FL_PAYMENT_VOUCHERS (added via ALTER after vouchers table) |
| `status` | VARCHAR2(20) DEFAULT 'PENDING' NOT NULL | PENDING / VOUCHER_GENERATED / PAID / SKIPPED |
| `created_at` | TIMESTAMP | |
| `updated_at` | TIMESTAMP | |

**Generation rules:**
- MONTHLY → one row per calendar month
- WEEKLY → one row per ISO week
- PER_COUNT → rows added manually per delivered unit

### 5.4 Module Settings (Function 2)

| Setting Code | Default | Description |
|---|---|---|
| `AUTO_GENERATE_PAYMENT_SCHEDULE` | Y | Auto-generate schedule on contract approval |
| `ALLOW_DIRECT_CONTRACT_EDIT` | N | Y = version increment on direct edit; N = formal amendment required |
| `CONTRACT_DIRECTOR_APPROVAL_THRESHOLD` | 50000 | AED amount requiring Finance Director approval |

### 5.5 Approval Templates (Function 2)
- `FL_CONTRACT_APPROVAL`: Step 1 — FL_MANAGER (ALWAYS) → Step 2 — FL_ADMIN if amount ≥ threshold (AMOUNT_GTE)
- `FL_AMENDMENT_APPROVAL`: Step 1 — FL_MANAGER (ALWAYS) → Step 2 — FL_ADMIN if amount ≥ threshold (AMOUNT_GTE)

---

## 6. Function 3 — Payment Vouchers

### 6.1 `DCT_FL_PAYMENT_VOUCHERS`

| Column | Type | Notes |
|---|---|---|
| `voucher_id` | NUMBER IDENTITY PK | |
| `voucher_number` | VARCHAR2(50) UNIQUE NOT NULL | Sequence-generated |
| `contract_id` | NUMBER NOT NULL | FK → DCT_FL_CONTRACTS |
| `freelancer_id` | NUMBER NOT NULL | FK → DCT_FL_FREELANCERS |
| `schedule_id` | NUMBER | FK → DCT_FL_PAYMENT_SCHEDULE |
| `period_label` | VARCHAR2(100) | Copied from schedule |
| `due_date` | DATE | Copied from schedule |
| `amount` | NUMBER(15,2) NOT NULL | |
| `invoice_number` | VARCHAR2(100) | Required if VOUCHER_REQUIRE_INVOICE = Y |
| `invoice_date` | DATE | |
| `payment_method` | VARCHAR2(50) NOT NULL | Lookup FL_PAYMENT_METHOD; defaults from DEFAULT_PAYMENT_METHOD |
| `pay_group` | VARCHAR2(50) NOT NULL | Lookup FL_PAY_GROUP; defaults from DEFAULT_PAY_GROUP |
| `description` | VARCHAR2(1000) | Defaults from VOUCHER_DEFAULT_DESCRIPTION (token-substituted) |
| `coding_type` | VARCHAR2(10) NOT NULL | GL / PROJECT — inherited from contract |
| `cc_id_gl` | NUMBER | FK → DCT_GL_CODE_COMBINATIONS |
| `project_number` | VARCHAR2(50) | |
| `task_number` | VARCHAR2(50) | |
| `expenditure_type` | VARCHAR2(100) | |
| `post_to_fusion` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y = push to Fusion Payables on approval |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | DRAFT / SUBMITTED / APPROVED / REJECTED / CANCELLED |
| `payment_status` | VARCHAR2(20) DEFAULT 'PENDING' NOT NULL | PENDING / PAID / CANCELLED |
| `payment_date` | DATE | Set by Fusion callback or manual admin entry |
| `payment_reference` | VARCHAR2(100) | Bank/ERP reference |
| `approval_instance_id` | NUMBER | |
| `notes` | VARCHAR2(4000) | |
| `created_by / at / updated_by / at` | | |

**Status flow:** DRAFT → SUBMITTED → APPROVED → (payment_status: PENDING → PAID)

**Fusion flow:** On APPROVED + post_to_fusion = Y → `DCT_FL_PKG.PUSH_TO_FUSION(p_voucher_id)` → Fusion Payables invoice → callback sets payment_status = PAID + payment_date + payment_reference → DCT_FL_PAYMENT_SCHEDULE.status = PAID.

**Validations:**
- No duplicate voucher per schedule row (excluding CANCELLED/REJECTED)
- `SUM(vouchers) ≤ contract.total_amount`
- Contract must be ACTIVE
- Invoice required if VOUCHER_REQUIRE_INVOICE = Y

### 6.2 Module Settings (Function 3)

| Setting Code | Default | Description |
|---|---|---|
| `ALLOW_BULK_VOUCHER_GENERATION` | N | Admin can generate all PENDING schedule rows at once |
| `VOUCHER_REQUIRE_INVOICE` | Y | Mandatory invoice_number + date before submission |
| `ALLOW_VOUCHER_AMOUNT_OVERRIDE` | N | Allow changing voucher amount from scheduled amount |
| `DEFAULT_PAYMENT_METHOD` | BANK_TRANSFER | Default payment_method on new vouchers |
| `DEFAULT_PAY_GROUP` | FREELANCER | Default pay_group on new vouchers |
| `VOUCHER_DEFAULT_DESCRIPTION` | `Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}` | Token-substituted on voucher generation |

### 6.3 Approval Template (Function 3)
- `FL_VOUCHER_APPROVAL`: Step 1 — FL_MANAGER (ALWAYS) → Step 2 — FL_ADMIN if amount ≥ threshold (AMOUNT_GTE)

---

## 7. Function 4 — Deliverable Tracking

### 7.1 `DCT_FL_DELIVERABLES`

| Column | Type | Notes |
|---|---|---|
| `deliverable_id` | NUMBER IDENTITY PK | |
| `contract_id` | NUMBER NOT NULL | FK → DCT_FL_CONTRACTS |
| `schedule_id` | NUMBER | FK → DCT_FL_PAYMENT_SCHEDULE (optional — links to justified period) |
| `title` | VARCHAR2(200) NOT NULL | |
| `description` | VARCHAR2(4000) | |
| `deliverable_date` | DATE NOT NULL | Date submitted by freelancer |
| `quantity` | NUMBER(10,2) DEFAULT 1 NOT NULL | Units delivered (for PER_COUNT) |
| `unit_id` | NUMBER | FK → DCT_LOOKUP_VALUES (FL_BILLING_UNIT) |
| `accepted_by` | NUMBER | FK → DCT_USERS |
| `accepted_date` | DATE | |
| `status` | VARCHAR2(20) DEFAULT 'SUBMITTED' NOT NULL | SUBMITTED / ACCEPTED / REJECTED |
| `rejection_reason` | VARCHAR2(1000) | |
| `notes` | VARCHAR2(4000) | |
| `created_by / at / updated_by / at` | | |

**Documents:** Uses DCT_FL_DOCUMENTS with source_type = 'DELIVERABLE'.

**Voucher gate:** If `VOUCHER_REQUIRE_ACCEPTED_DELIVERABLE = Y`, voucher cannot be submitted unless an ACCEPTED deliverable exists for the schedule row.

### 7.2 Module Setting (Function 4)

| Setting Code | Default | Description |
|---|---|---|
| `VOUCHER_REQUIRE_ACCEPTED_DELIVERABLE` | N | Y = ACCEPTED deliverable required before voucher submission |

---

## 8. Function 5 — Document Expiry Management

Extends `DCT_FL_DOCUMENTS` with expiry tracking. New table for alert history.

**Virtual column on DCT_FL_DOCUMENTS:**
- `is_expired` — GENERATED: `CASE WHEN expiry_date < SYSDATE THEN 'Y' ELSE 'N' END`

**Expiry status (computed in DCT_FL_DOCUMENT_V):**
- `VALID` — `expiry_date IS NULL OR expiry_date > SYSDATE + alert_days_before`
- `EXPIRING_SOON` — `expiry_date BETWEEN SYSDATE AND SYSDATE + alert_days_before`
- `EXPIRED` — `expiry_date < SYSDATE`

### 8.1 `DCT_FL_DOC_EXPIRY_ALERTS`

| Column | Type | Notes |
|---|---|---|
| `alert_id` | NUMBER IDENTITY PK | |
| `document_id` | NUMBER NOT NULL | FK → DCT_FL_DOCUMENTS |
| `freelancer_id` | NUMBER NOT NULL | FK → DCT_FL_FREELANCERS |
| `alert_type` | VARCHAR2(20) NOT NULL | EXPIRING_SOON / EXPIRED |
| `days_remaining` | NUMBER | Snapshot at time of alert |
| `notified_user_id` | NUMBER | FK → DCT_USERS (admin notified) |
| `sent_at` | TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL | |

**Scheduled process:** `DCT_FL_PKG.SEND_EXPIRY_ALERTS` — daily via DBMS_SCHEDULER. Skips if alert already sent today for same document + type.

### 8.2 Module Settings (Function 5)

| Setting Code | Default | Description |
|---|---|---|
| `DOC_EXPIRY_ALERT_DAYS` | 30 | Default days before expiry to alert; also default for `alert_days_before` on insert |
| `BLOCK_CONTRACT_ON_EXPIRED_DOC` | Y | Block new contract submission if freelancer has expired docs |
| `BLOCK_VOUCHER_ON_EXPIRED_DOC` | N | Block voucher submission if freelancer has expired docs |

---

## 9. Function 6 — Contract Renewals

### 9.1 `DCT_FL_CONTRACT_RENEWALS`

| Column | Type | Notes |
|---|---|---|
| `renewal_id` | NUMBER IDENTITY PK | |
| `original_contract_id` | NUMBER NOT NULL | FK → DCT_FL_CONTRACTS |
| `new_contract_id` | NUMBER | FK → DCT_FL_CONTRACTS (populated on approval) |
| `renewal_number` | VARCHAR2(50) UNIQUE NOT NULL | Sequence-generated |
| `new_start_date` | DATE NOT NULL | Must be ≥ original end_date |
| `new_end_date` | DATE | |
| `new_total_amount` | NUMBER(15,2) NOT NULL | |
| `new_billing_method` | VARCHAR2(20) | Defaults from original |
| `new_billing_unit_id` | NUMBER | FK → DCT_LOOKUP_VALUES (FL_BILLING_UNIT) |
| `new_billing_unit_amount` | NUMBER(15,2) | |
| `coding_type` | VARCHAR2(10) NOT NULL | GL / PROJECT |
| `cc_id_gl` | NUMBER | |
| `project_number` | VARCHAR2(50) | |
| `task_number` | VARCHAR2(50) | |
| `expenditure_type` | VARCHAR2(100) | |
| `reason` | VARCHAR2(1000) NOT NULL | |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | DRAFT / SUBMITTED / APPROVED / REJECTED / CANCELLED |
| `approval_instance_id` | NUMBER | |
| `created_by / at / updated_by / at` | | |

**DCT_FL_CONTRACTS** gets additional column: `renewed_from_contract_id NUMBER` (already included in Function 2 table).

**On renewal approval:** `DCT_FL_PKG.CREATE_RENEWED_CONTRACT` — inserts new contract with `renewed_from_contract_id`, sets original to COMPLETED, auto-generates schedule if setting = Y.

**Validations:** Freelancer ACTIVE, no duplicate pending renewal, `new_start_date ≥ original.end_date`, no expired docs (if setting = Y), warn on unpaid vouchers.

### 9.2 Approval Template (Function 6)
- `FL_RENEWAL_APPROVAL`: Step 1 — FL_MANAGER (ALWAYS) → Step 2 — FL_ADMIN if amount ≥ threshold (AMOUNT_GTE)

---

## 10. Function 7 — Self-Service Portal

### 10.1 `DCT_FL_PROFILE_CHANGE_REQUESTS`

| Column | Type | Notes |
|---|---|---|
| `change_request_id` | NUMBER IDENTITY PK | |
| `freelancer_id` | NUMBER NOT NULL | FK → DCT_FL_FREELANCERS |
| `change_type` | VARCHAR2(30) NOT NULL | BANK_ACCOUNT / EMAIL / PHONE / OTHER |
| `current_value` | VARCHAR2(1000) | Snapshot of what's changing |
| `requested_value` | VARCHAR2(1000) | New value |
| `reason` | VARCHAR2(1000) | |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | DRAFT / SUBMITTED / APPROVED / REJECTED |
| `approval_instance_id` | NUMBER | |
| `created_by / at / updated_by / at` | | |

**On approval:** `DCT_FL_PKG.APPLY_PROFILE_CHANGE(p_change_request_id)` updates the relevant field.

**App Items (App 203):**
- `APP_FL_FREELANCER_ID` — Restricted; populated on login if user is a freelancer
- `APP_IS_FL_ADMIN` — Restricted; Y if user has FL_ADMIN role

**Authorization Schemes:**
- `IS_FREELANCER` — `RETURN :APP_FL_FREELANCER_ID IS NOT NULL;`
- `IS_FL_ADMIN` — `RETURN :APP_IS_FL_ADMIN = 'Y';`

### 10.2 Module Settings (Function 7)

| Setting Code | Default | Description |
|---|---|---|
| `ALLOW_PROFILE_CHANGE_REQUEST` | Y | Freelancer can request profile updates via portal |

### 10.3 Approval Template (Function 7)
- `FL_PROFILE_CHANGE_APPROVAL`: Step 1 — FL_ADMIN (ALWAYS)

---

## 11. System Lookups

### In DCT_LOOKUP_CATEGORIES + DCT_LOOKUP_VALUES

| Category Code | Values |
|---|---|
| `FL_BILLING_UNIT` | REPORT (Per Report), VISIT (Per Visit), DELIVERABLE (Per Deliverable), HOUR (Per Hour), UNIT (Per Unit) |
| `FL_PAYMENT_METHOD` | BANK_TRANSFER (Bank Transfer), CHEQUE (Cheque), CASH (Cash) |
| `FL_PAY_GROUP` | FREELANCER (Freelancer), CONTRACTOR (Contractor), VENDOR (Vendor) |
| `FL_DOCUMENT_TYPE` | EMIRATES_ID (Emirates ID), PASSPORT (Passport), VISA (Visa/Residency), TRADE_LICENSE (Trade License), QUALIFICATION (Qualification Certificate), OTHER (Other) |

---

## 12. APEX Pages

| Page | Type | Purpose | Auth |
|---|---|---|---|
| 9999 | Login | Login | Public |
| 9998 | Form | Self-Registration (public) | Public |
| 0 | Global | Notification badge | — |
| 1 | Dashboard | Home — KPIs for admin/manager | IS_FL_ADMIN or IS_MANAGER |
| 10 | Form | My Profile (freelancer portal) | IS_FREELANCER |
| 11 | IR | My Contracts (freelancer) | IS_FREELANCER |
| 12 | IR | My Vouchers (freelancer) | IS_FREELANCER |
| 13 | IR | My Deliverables (freelancer) | IS_FREELANCER |
| 14 | IR | My Documents (freelancer) | IS_FREELANCER |
| 20 | IR | All Freelancers | IS_FL_ADMIN |
| 21 | Form | Freelancer Detail / Edit | IS_FL_ADMIN |
| 22 | IR | Registration Requests | IS_FL_ADMIN or IS_MANAGER |
| 23 | Form | Registration Form | IS_FL_ADMIN or Public |
| 30 | IR | All Contracts | IS_FL_ADMIN |
| 31 | Form | Contract Form | IS_FL_ADMIN |
| 32 | IR | Contract Detail + Schedule | IS_FL_ADMIN or IS_MANAGER |
| 33 | Form | Amendment Form | IS_FL_ADMIN |
| 34 | IR | Renewal Requests | IS_FL_ADMIN or IS_MANAGER |
| 35 | Form | Renewal Form | IS_FL_ADMIN |
| 40 | IR | All Vouchers | IS_FL_ADMIN |
| 41 | Form | Voucher Form | IS_FL_ADMIN |
| 42 | IR | Pending Approvals | IS_FL_ADMIN or IS_MANAGER |
| 50 | IR | Deliverables — Accept/Reject | IS_FL_ADMIN or IS_MANAGER |
| 60 | IR | Document Expiry Dashboard | IS_FL_ADMIN |
| 70 | IG | Module Settings | IS_ADMIN |
| 71 | Master-Detail | Approval Rules | IS_ADMIN |

---

## 13. Sequences

| Sequence | Purpose | Format |
|---|---|---|
| `SEQ_FL_REG_NUMBER` | Registration numbers | FL-REG-{n} |
| `SEQ_FL_VENDOR_NUMBER` | Vendor numbers | FL-VND-{n} |
| `SEQ_FL_CONTRACT_NUMBER` | Contract numbers | FL-CON-{n} |
| `SEQ_FL_RENEWAL_NUMBER` | Renewal numbers | FL-RNW-{n} |
| `SEQ_FL_VOUCHER_NUMBER` | Voucher numbers | FL-VCH-{n} |
