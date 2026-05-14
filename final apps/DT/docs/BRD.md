# Business Requirements Document — Duty Travel Module (App 204)
**Version:** 1.2 | **Status:** DB Complete — APEX pending | **Date:** 2026-05-14
**Schema:** PROD | **App ID:** 204 | **App Alias:** DT

---

## 1. Overview

The Duty Travel module manages the full lifecycle of DCT employee requests for **Business Missions** and **Training** trips — both internal (within the UAE) and external (international). It auto-calculates a single all-in-one per diem allowance based on destination, duration, and employee grade; captures optional additional allowances (ticket, accommodation, visa, local transport) enabled per deployment via module settings; routes requests through a configurable approval workflow; and optionally handles post-travel settlement once the employee returns.

---

## 2. Functions

| # | Function | Tables |
|---|---|---|
| 1 | Travel Request | `DT_REQUESTS` |
| 2 | Destinations & Per Diem | `DT_DESTINATIONS`, `DT_PER_DIEM_RATES`, `DT_COUNTRY_GROUPS` |
| 3 | Document Management | `DT_DOCUMENTS`, `DT_DOC_REQUIREMENTS` |
| 4 | Post-Travel Settlement | `DT_SETTLEMENT`, `DT_SETTLEMENT_LINES` |
| 5 | Reports & Dashboard | — (views / APEX reports) |

---

## 3. Roles

| Role Code | Description |
|---|---|
| `DT_ADMIN` | Full module access — all requests, settlements, rate master, country groups, settings |
| `DT_MANAGER` | Approves travel requests and settlements for their organisational unit |
| `DT_FINANCE` | Finance review: verifies budget coding, disburses advances, closes requests |
| `DT_EMPLOYEE` | Any DCT employee — submits own travel requests and settlements |

---

## 4. Function 1 — Travel Request

### 4.1 `DT_REQUESTS`
Master record for a single travel event (one trip, one employee). May contain multiple destination legs (see Function 2). Optional allowance fields are shown/hidden based on module settings — they are always stored in the table but are zero when the corresponding setting is disabled.

| Column | Type | Notes |
|---|---|---|
| `request_id` | NUMBER IDENTITY PK | |
| `request_number` | VARCHAR2(30) UNIQUE NOT NULL | Sequence-generated — `DT-REQ-YYYY-NNNNN` |
| `employee_user_id` | NUMBER NOT NULL | FK → DCT_USERS |
| `employee_grade_code` | VARCHAR2(20) NOT NULL | Snapped from employee profile at request creation — used by `CALC_PER_DIEM` for rate lookup |
| `org_id` | NUMBER NOT NULL | FK → DCT_ORGANIZATIONS |
| `mission_type` | VARCHAR2(20) NOT NULL | `BUSINESS_MISSION` / `TRAINING` |
| `trip_type` | VARCHAR2(10) NOT NULL | `INTERNAL` / `EXTERNAL` |
| `purpose` | VARCHAR2(1000) NOT NULL | Trip objective |
| `hosted_by` | VARCHAR2(200) | Inviting org / conference / training provider |
| `departure_date` | DATE NOT NULL | Overall trip start date |
| `return_date` | DATE NOT NULL | Overall trip end date |
| `total_days` | NUMBER GENERATED ALWAYS AS (return_date - departure_date + 1) VIRTUAL | Inclusive days |
| `total_per_diem_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | Sum of per diem across all destination legs — set by `DT_PKG.CALC_PER_DIEM` |
| `ticket_amount_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | Manual entry — visible only when `INCLUDE_TICKET_ALLOWANCE = Y` |
| `accommodation_amount_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | Manual entry — visible only when `INCLUDE_ACCOMMODATION_ALLOWANCE = Y` |
| `visa_fees_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | Manual entry — visible only when `INCLUDE_VISA_ALLOWANCE = Y` |
| `local_transport_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | Manual entry — visible only when `INCLUDE_LOCAL_TRANSPORT_ALLOWANCE = Y` |
| `other_allowances_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | Any other pre-approved allowances — always visible |
| `total_advance_aed` | NUMBER(15,2) DEFAULT 0 NOT NULL | `total_per_diem_aed` + all enabled allowances — set by `DT_PKG.CALC_PER_DIEM` |
| `budget_type` | VARCHAR2(10) NOT NULL | `GL` / `PROJECT` |
| `cc_id_gl` | NUMBER | FK → DCT_GL_CODE_COMBINATIONS (when `budget_type = GL`) |
| `project_number` | VARCHAR2(50) | When `budget_type = PROJECT` |
| `task_number` | VARCHAR2(50) | |
| `expenditure_type` | VARCHAR2(100) | |
| `status` | VARCHAR2(25) DEFAULT 'DRAFT' NOT NULL | See §4.3 |
| `approval_instance_id` | NUMBER | FK → DCT_APPROVAL_INSTANCES |
| `finance_disbursed_yn` | VARCHAR2(1) DEFAULT 'N' NOT NULL | Y/N — Finance marks when advance is paid out |
| `disbursed_date` | DATE | |
| `disbursed_by_user_id` | NUMBER | FK → DCT_USERS |
| `closed_date` | DATE | Populated when status → CLOSED |
| `closed_by_user_id` | NUMBER | FK → DCT_USERS |
| `notes` | VARCHAR2(4000) | |
| `created_by` | NUMBER | FK → DCT_USERS |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | FK → DCT_USERS |
| `updated_at` | TIMESTAMP | |

### 4.2 Validations (Function 1)

- `return_date ≥ departure_date`
- `departure_date ≥ SYSDATE` at submission time (unless `ALLOW_PAST_TRAVEL_REQUEST = Y`)
- At least one destination row must exist before submission
- Budget coding (`budget_type` + relevant fields) required before submission
- `total_advance_aed` and `total_per_diem_aed` are read-only — always set by `DT_PKG.CALC_PER_DIEM`

### 4.3 Status Flow

```
DRAFT → SUBMITTED → APPROVED → ADVANCE_PAID → TRAVELLED → CLOSED
              ↘ REJECTED
              ↘ RETURNED  (back to requester for correction)
              ↘ CANCELLED
```

| Status | Description |
|---|---|
| `DRAFT` | Created, not yet submitted |
| `SUBMITTED` | Submitted for approval — read-only to employee |
| `APPROVED` | Fully approved — pending finance disbursement |
| `ADVANCE_PAID` | Finance has disbursed the advance; employee may travel |
| `TRAVELLED` | Employee has returned; settlement window open (if enabled) |
| `CLOSED` | Terminal — request fully complete |
| `REJECTED` | Rejected by an approver |
| `RETURNED` | Returned to employee for amendments |
| `CANCELLED` | Cancelled before approval |

**Transition rules:**

- `APPROVED → ADVANCE_PAID` — Finance action via `MARK_ADVANCE_PAID`. Required before travel only if `ADVANCE_PAYMENT_REQUIRED = Y`; if N, system skips this step and moves directly to TRAVELLED when return date passes.
- `ADVANCE_PAID → TRAVELLED` — fired automatically by daily scheduler when `return_date < SYSDATE`.
- `TRAVELLED → CLOSED`:
  - If `SETTLEMENT_REQUIRED = Y` → only allowed after a settlement record reaches `APPROVED` status; `CLOSE_REQUEST` is called automatically.
  - If `SETTLEMENT_REQUIRED = N` → Finance/DT_ADMIN can close directly; or system auto-closes after `AUTO_CLOSE_DAYS` days post-return.

### 4.4 Module Settings (Function 1)

| Setting Code | Default | Description |
|---|---|---|
| `ALLOW_PAST_TRAVEL_REQUEST` | N | Allow submitting when departure_date is in the past |
| `ADVANCE_PAYMENT_REQUIRED` | Y | Y = Finance must mark advance paid before TRAVELLED fires |
| `SETTLEMENT_REQUIRED` | Y | Y = settlement submission mandatory; N = Finance can close directly |
| `AUTO_CLOSE_DAYS` | 0 | Days after return_date to auto-close (0 = disabled); applies only when `SETTLEMENT_REQUIRED = N` |
| `SETTLEMENT_DEADLINE_DAYS` | 7 | Days after return_date by which settlement must be submitted (if `SETTLEMENT_REQUIRED = Y`) |
| `SETTLEMENT_LATE_ALERT_DAYS` | 5 | Alert Finance/DT_ADMIN when settlement is overdue this many days |
| `INCLUDE_TICKET_ALLOWANCE` | Y | Show and include ticket_amount_aed in total advance |
| `INCLUDE_ACCOMMODATION_ALLOWANCE` | Y | Show and include accommodation_amount_aed in total advance |
| `INCLUDE_VISA_ALLOWANCE` | Y | Show and include visa_fees_aed in total advance |
| `INCLUDE_LOCAL_TRANSPORT_ALLOWANCE` | N | Show and include local_transport_aed in total advance |
| `MAX_TICKET_AMOUNT_AED` | null | Hard cap on ticket_amount_aed (null = no cap) |
| `DT_FINANCE_APPROVAL_THRESHOLD_AED` | 5000 | Requests with total_advance_aed ≥ this value require DT_FINANCE approval step |
| `REQUEST_NUMBER_PREFIX` | `DT-REQ` | Prefix for auto-generated request numbers. Format: `{PREFIX}-{YYYY}-{00001}` |
| `SETTLEMENT_NUMBER_PREFIX` | `DT-STL` | Prefix for auto-generated settlement numbers. Format: `{PREFIX}-{YYYY}-{00001}` |

---

## 5. Function 2 — Destinations & Per Diem

### 5.1 `DT_DESTINATIONS`
One row per destination leg within a trip. Per diem for each leg is calculated using the daily rate for the leg's country (or its mapped group, depending on `RATE_STRUCTURE` setting) and the employee's grade.

| Column | Type | Notes |
|---|---|---|
| `destination_id` | NUMBER IDENTITY PK | |
| `request_id` | NUMBER NOT NULL | FK → DT_REQUESTS (cascade delete) |
| `seq_num` | NUMBER NOT NULL | Display order |
| `country_code` | VARCHAR2(3) NOT NULL | ISO alpha-2; `AE` for internal UAE destinations |
| `city` | VARCHAR2(100) NOT NULL | City or emirate name |
| `arrival_date` | DATE NOT NULL | Date employee arrives at this destination |
| `departure_date` | DATE NOT NULL | Date employee leaves this destination |
| `duration_days` | NUMBER GENERATED ALWAYS AS (departure_date - arrival_date + 1) VIRTUAL | Inclusive days at this leg |
| `rate_id` | NUMBER | FK → DT_PER_DIEM_RATES — resolved and snapped at calc time |
| `per_diem_daily_rate_aed` | NUMBER(15,2) | Snapshot of rate at time of calculation |
| `per_diem_total_aed` | NUMBER(15,2) | `duration_days × per_diem_daily_rate_aed` (adjusted by half-day policy if applicable) |
| `notes` | VARCHAR2(1000) | |
| `created_at` | TIMESTAMP | |
| `updated_at` | TIMESTAMP | |

**Validations:**
- `departure_date ≥ arrival_date` per leg
- Leg dates must fall within `DT_REQUESTS.departure_date` … `return_date`

**Recalculation:** `DT_PKG.CALC_PER_DIEM(p_request_id)` fires on every insert, update, or delete of a destination row. It re-resolves and re-snaps the rate, recomputes leg totals, and rolls up `total_per_diem_aed` and `total_advance_aed` on the parent request.

---

### 5.2 `DT_PER_DIEM_RATES`
Admin-maintained rate master. Each row defines a single all-in-one daily per diem allowance for a given `rate_key` and employee grade. `rate_key` meaning depends on the `RATE_STRUCTURE` module setting:

| `RATE_STRUCTURE` | `rate_key` holds |
|---|---|
| `PER_COUNTRY` | ISO country code (e.g. `GB`, `AE`, `IN`) |
| `TIER_BASED` | Tier code (e.g. `TIER1`, `TIER2`, `TIER3`) |
| `REGION_BASED` | Region code (e.g. `GCC`, `MENA`, `EUROPE`, `ASIA`) |

| Column | Type | Notes |
|---|---|---|
| `rate_id` | NUMBER IDENTITY PK | |
| `rate_key` | VARCHAR2(20) NOT NULL | Country code, tier code, or region code — depends on `RATE_STRUCTURE` setting |
| `rate_key_name_en` | VARCHAR2(100) NOT NULL | Display label (e.g. "United Kingdom", "Tier 1 — Western Europe", "Europe") |
| `rate_key_name_ar` | VARCHAR2(100) | |
| `grade_code` | VARCHAR2(20) NOT NULL | FK → DCT_LOOKUP_VALUES (`DT_EMPLOYEE_GRADE`); `ALL` = applies to all grades |
| `per_diem_daily_aed` | NUMBER(15,2) NOT NULL | All-in-one daily allowance (meals + subsistence) |
| `effective_from` | DATE NOT NULL | Rate is valid from this date |
| `effective_to` | DATE | NULL = no expiry (current rate) |
| `is_active` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `notes` | VARCHAR2(1000) | |
| `created_by` | NUMBER | FK → DCT_USERS |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | FK → DCT_USERS |
| `updated_at` | TIMESTAMP | |

**Unique constraint:** `(rate_key, grade_code, effective_from)` — no duplicate active rates for the same key + grade.

**Rate lookup — `DT_PKG.GET_RATE(p_country_code, p_grade_code, p_travel_date)`:**
1. Read `RATE_STRUCTURE` setting.
2. If `PER_COUNTRY` → `lookup_key = p_country_code`.
3. If `TIER_BASED` or `REGION_BASED` → look up `DT_COUNTRY_GROUPS` to get `group_code` for `p_country_code`; `lookup_key = group_code`.
4. Query `DT_PER_DIEM_RATES` where `rate_key = lookup_key AND grade_code = p_grade_code AND effective_from ≤ p_travel_date AND (effective_to IS NULL OR effective_to ≥ p_travel_date)`.
5. Fall back to `grade_code = 'ALL'` if no grade-specific row is found.

---

### 5.3 `DT_COUNTRY_GROUPS`
Maps each country to a tier or region code. Used only when `RATE_STRUCTURE = TIER_BASED` or `REGION_BASED`. When `RATE_STRUCTURE = PER_COUNTRY`, this table is ignored.

| Column | Type | Notes |
|---|---|---|
| `country_code` | VARCHAR2(3) NOT NULL PK | ISO alpha-2 |
| `country_name_en` | VARCHAR2(100) NOT NULL | |
| `country_name_ar` | VARCHAR2(100) | |
| `group_code` | VARCHAR2(20) NOT NULL | Tier code or region code — must match a `rate_key` in `DT_PER_DIEM_RATES` |
| `is_active` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `created_by` | NUMBER | FK → DCT_USERS |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | FK → DCT_USERS |
| `updated_at` | TIMESTAMP | |

---

### 5.4 Module Settings (Function 2)

| Setting Code | Default | Description |
|---|---|---|
| `RATE_STRUCTURE` | `PER_COUNTRY` | `PER_COUNTRY` — rate_key is ISO country code; `TIER_BASED` — countries mapped to tier codes; `REGION_BASED` — countries mapped to region codes |
| `PER_DIEM_HALF_DAY_POLICY` | `NONE` | `NONE` = full rate every day; `FIRST_LAST` = half rate on departure and return days; `FIRST_ONLY` = half rate on departure day only |

---

## 6. Function 3 — Document Management

### 6.1 `DT_DOCUMENTS`
All supporting documents for requests and settlements, unified in one table with a `source_type` discriminator.

| Column | Type | Notes |
|---|---|---|
| `document_id` | NUMBER IDENTITY PK | |
| `source_type` | VARCHAR2(20) NOT NULL | `REQUEST` / `SETTLEMENT` |
| `source_id` | NUMBER NOT NULL | PK of the parent record |
| `document_type_id` | NUMBER NOT NULL | FK → DCT_LOOKUP_VALUES (`DT_DOCUMENT_TYPE`) |
| `document_name` | VARCHAR2(200) NOT NULL | |
| `file_mime_type` | VARCHAR2(100) | |
| `file_size` | NUMBER | Bytes |
| `file_blob` | BLOB | |
| `is_required` | VARCHAR2(1) DEFAULT 'N' NOT NULL | Y/N — copied from `DT_DOC_REQUIREMENTS` at upload time |
| `notes` | VARCHAR2(500) | |
| `uploaded_by` | NUMBER | FK → DCT_USERS |
| `uploaded_at` | TIMESTAMP | |

---

### 6.2 `DT_DOC_REQUIREMENTS`
Admin-configurable required document types per mission type, trip direction, and source (request or settlement).

| Column | Type | Notes |
|---|---|---|
| `doc_req_id` | NUMBER IDENTITY PK | |
| `mission_type` | VARCHAR2(20) NOT NULL | `BUSINESS_MISSION` / `TRAINING` / `ALL` |
| `trip_type` | VARCHAR2(10) NOT NULL | `INTERNAL` / `EXTERNAL` / `ALL` |
| `document_type_id` | NUMBER NOT NULL | FK → DCT_LOOKUP_VALUES (`DT_DOCUMENT_TYPE`) |
| `is_mandatory` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `applies_to_source` | VARCHAR2(20) DEFAULT 'REQUEST' NOT NULL | `REQUEST` / `SETTLEMENT` / `BOTH` |
| `is_active` | VARCHAR2(1) DEFAULT 'Y' NOT NULL | Y/N |
| `display_seq` | NUMBER DEFAULT 99 | |
| `created_by` | NUMBER | |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | |
| `updated_at` | TIMESTAMP | |

**Submission gate:** `DT_PKG.VALIDATE_DOCS(p_source_type, p_source_id)` checks all mandatory document types are uploaded; raises an exception listing the missing types.

---

## 7. Function 4 — Post-Travel Settlement

Available only when `SETTLEMENT_REQUIRED = Y`. Employee submits itemised actual expenses; Finance compares actuals against the advance paid and approves a refund or additional payment.

### 7.1 `DT_SETTLEMENT`
Settlement header — at most one per request.

| Column | Type | Notes |
|---|---|---|
| `settlement_id` | NUMBER IDENTITY PK | |
| `settlement_number` | VARCHAR2(30) UNIQUE NOT NULL | Sequence-generated — `DT-STL-YYYY-NNNNN` |
| `request_id` | NUMBER UNIQUE NOT NULL | FK → DT_REQUESTS |
| `employee_user_id` | NUMBER NOT NULL | FK → DCT_USERS (denormalised) |
| `actual_return_date` | DATE NOT NULL | Actual date employee returned |
| `actual_per_diem_days` | NUMBER NOT NULL | Qualifying days actually travelled (may differ from planned) |
| `total_actual_aed` | NUMBER(15,2) NOT NULL | Sum of all settlement lines |
| `advance_paid_aed` | NUMBER(15,2) NOT NULL | Snapshot of `request.total_advance_aed` at settlement time |
| `difference_aed` | NUMBER(15,2) GENERATED ALWAYS AS (total_actual_aed - advance_paid_aed) VIRTUAL | Positive = employee is owed more; negative = refund due |
| `settlement_type` | VARCHAR2(25) GENERATED ALWAYS AS (CASE WHEN total_actual_aed > advance_paid_aed THEN 'ADDITIONAL_PAYMENT' WHEN total_actual_aed < advance_paid_aed THEN 'REFUND' ELSE 'BALANCED' END) VIRTUAL | |
| `employee_notes` | VARCHAR2(4000) | |
| `finance_notes` | VARCHAR2(4000) | |
| `status` | VARCHAR2(20) DEFAULT 'DRAFT' NOT NULL | `DRAFT` / `SUBMITTED` / `APPROVED` / `REJECTED` / `RETURNED` |
| `approval_instance_id` | NUMBER | FK → DCT_APPROVAL_INSTANCES |
| `refund_collected_yn` | VARCHAR2(1) DEFAULT 'N' NOT NULL | Finance marks Y when refund is collected |
| `refund_collected_date` | DATE | |
| `additional_payment_ref` | VARCHAR2(100) | Bank/ERP reference for supplemental payment |
| `additional_payment_date` | DATE | |
| `created_by` | NUMBER | FK → DCT_USERS |
| `created_at` | TIMESTAMP | |
| `updated_by` | NUMBER | FK → DCT_USERS |
| `updated_at` | TIMESTAMP | |

**On settlement approval:** `DT_PKG.CLOSE_REQUEST(p_request_id)` — sets `DT_REQUESTS.status = CLOSED` and `closed_date = SYSDATE`.

---

### 7.2 `DT_SETTLEMENT_LINES`
Itemised actual expenses per settlement. One line per expense category.

| Column | Type | Notes |
|---|---|---|
| `line_id` | NUMBER IDENTITY PK | |
| `settlement_id` | NUMBER NOT NULL | FK → DT_SETTLEMENT (cascade delete) |
| `line_num` | NUMBER NOT NULL | Display order |
| `expense_category` | VARCHAR2(30) NOT NULL | `PER_DIEM` / `ACCOMMODATION` / `TICKET` / `VISA` / `LOCAL_TRANSPORT` / `OTHER` |
| `description` | VARCHAR2(500) | |
| `amount_aed` | NUMBER(15,2) NOT NULL | |
| `receipt_attached` | VARCHAR2(1) DEFAULT 'N' NOT NULL | Y/N |
| `notes` | VARCHAR2(500) | |

**Lines must sum to `total_actual_aed` on the header.**

Receipts are uploaded via `DT_DOCUMENTS` with `source_type = 'SETTLEMENT'` and `source_id = settlement_id`.

---

### 7.3 Approval Template (Function 4)

- `DT_SETTLEMENT_APPROVAL`: Step 1 — DT_MANAGER (ALWAYS) → Step 2 — DT_FINANCE (ALWAYS)

---

### 7.4 Module Settings (Function 4)

| Setting Code | Default | Description |
|---|---|---|
| `SETTLEMENT_REQUIRE_RECEIPTS` | Y | Y = `receipt_attached = Y` is mandatory for ACCOMMODATION and TICKET lines before submission |
| `ALLOW_SETTLEMENT_AMOUNT_EXCEED` | N | N = block settlement if `total_actual_aed > advance_paid_aed × (SETTLEMENT_MAX_EXCEED_PCT / 100)` |
| `SETTLEMENT_MAX_EXCEED_PCT` | 120 | Maximum percentage of advance that actual total may reach (applies only when `ALLOW_SETTLEMENT_AMOUNT_EXCEED = Y`) |

---

## 8. Approval Workflows

Uses the shared `DCT_APPROVAL_TEMPLATES / DCT_APPROVAL_STEPS / DCT_APPROVAL_INSTANCES` framework.

| Template Code | Trigger | Steps |
|---|---|---|
| `DT_REQUEST_APPROVAL` | Request submitted | Step 1: DT_MANAGER (ALWAYS) → Step 2: DT_FINANCE if `total_advance_aed ≥ DT_FINANCE_APPROVAL_THRESHOLD_AED` (AMOUNT_GTE) |
| `DT_SETTLEMENT_APPROVAL` | Settlement submitted | Step 1: DT_MANAGER (ALWAYS) → Step 2: DT_FINANCE (ALWAYS) |

---

## 9. System Lookups

### In `DCT_LOOKUP_CATEGORIES` + `DCT_LOOKUP_VALUES`

| Category Code | Values |
|---|---|
| `DT_EMPLOYEE_GRADE` | `EXEC` (Executive / SCS), `PROF` (Professional / Expert), `SPEC` (Specialist), `STAFF` (Staff / Officer), `ALL` (All grades — used in rate master as catch-all) |
| `DT_DOCUMENT_TYPE` | `INVITATION` (Invitation / Approval Letter), `FLIGHT_TICKET` (Flight Ticket / Itinerary), `HOTEL_BOOKING` (Hotel Booking Confirmation), `TRAINING_ENROLL` (Training Enrollment Letter), `CONFERENCE_PROG` (Conference Programme), `VISA` (Visa Copy), `RECEIPT` (Receipt / Invoice), `OTHER` (Other) |

---

## 10. APEX Pages (App 204)

| Page | Type | Purpose | Auth |
|---|---|---|---|
| 9999 | Login | Login | Public |
| 0 | Global | Notification badge, nav | — |
| 1 | Dashboard | KPIs: pending approvals, upcoming travel, overdue settlements, TRAVELLED requests awaiting closure | IS_AUTHENTICATED |
| 10 | IR | My Travel Requests | IS_AUTHENTICATED |
| 11 | Form | New / Edit Travel Request — header form + destination legs IG | IS_AUTHENTICATED |
| 12 | Form | Request Detail — read-only with allowances breakdown and approval trail | IS_AUTHENTICATED |
| 13 | IR | My Settlements | IS_AUTHENTICATED |
| 14 | Form | Settlement Form — header + expense lines IG | IS_AUTHENTICATED |
| 20 | IR | All Requests | IS_DT_ADMIN |
| 21 | IR | All Settlements | IS_DT_ADMIN or IS_DT_FINANCE |
| 30 | IR | Pending Approvals | IS_DT_MANAGER or IS_DT_ADMIN or IS_DT_FINANCE |
| 40 | IG | Per Diem Rate Master | IS_DT_ADMIN |
| 41 | IG | Country Group Mapping | IS_DT_ADMIN |
| 42 | IG | Document Requirements | IS_DT_ADMIN |
| 50 | IR | Finance Disbursement Queue — APPROVED requests awaiting advance payment | IS_DT_FINANCE or IS_DT_ADMIN |
| 60 | IR | Finance Closure Queue — TRAVELLED requests ready to close | IS_DT_FINANCE or IS_DT_ADMIN |
| 70 | IG | Module Settings | IS_ADMIN |
| 71 | Master-Detail | Approval Rules | IS_ADMIN |
| 80 | Report | Travel Summary by Department / Period | IS_DT_ADMIN or IS_DT_MANAGER |

---

## 11. Module-Specific Application Items (App 204)

| Item Name | Type | Protection | Populated value |
|---|---|---|---|
| `APP_IS_DT_ADMIN` | Varchar2(1) | Restricted | `Y` if user has `DT_ADMIN` role |
| `APP_IS_DT_FINANCE` | Varchar2(1) | Restricted | `Y` if user has `DT_FINANCE` role |
| `APP_IS_DT_MANAGER` | Varchar2(1) | Restricted | `Y` if user has `DT_MANAGER` role |

### Module-Specific Authorization Schemes (local to App 204)

| Scheme Name | Expression |
|---|---|
| `IS_DT_ADMIN` | `RETURN :APP_IS_DT_ADMIN = 'Y';` |
| `IS_DT_FINANCE` | `RETURN :APP_IS_DT_FINANCE = 'Y';` |
| `IS_DT_MANAGER` | `RETURN :APP_IS_DT_MANAGER = 'Y';` |
| `IS_DT_ADMIN_OR_FINANCE` | `RETURN :APP_IS_DT_ADMIN = 'Y' OR :APP_IS_DT_FINANCE = 'Y';` |

---

## 12. PL/SQL Package — `DT_PKG`

| Procedure / Function | Description |
|---|---|
| `GENERATE_REQUEST_NUMBER` | Reads `REQUEST_NUMBER_PREFIX` setting; returns `{PREFIX}-{YYYY}-{LPAD(seq,5,'0')}` |
| `GENERATE_SETTLEMENT_NUMBER` | Reads `SETTLEMENT_NUMBER_PREFIX` setting; returns `{PREFIX}-{YYYY}-{LPAD(seq,5,'0')}` |
| `GET_RATE(p_country_code, p_grade_code, p_travel_date)` | Resolves the correct `DT_PER_DIEM_RATES` row using `RATE_STRUCTURE` setting; falls back to `ALL` grade |
| `CALC_PER_DIEM(p_request_id)` | Loops over destination legs, calls `GET_RATE` for each, snaps rate, applies half-day policy, computes leg total, rolls up `total_per_diem_aed` and `total_advance_aed` on the request |
| `VALIDATE_DOCS(p_source_type, p_source_id)` | Checks mandatory docs from `DT_DOC_REQUIREMENTS`; raises exception listing missing types |
| `SUBMIT_REQUEST(p_request_id)` | Calls `VALIDATE_DOCS`, creates approval instance, sets status = SUBMITTED |
| `MARK_ADVANCE_PAID(p_request_id, p_user_id)` | Sets `finance_disbursed_yn = Y`, `disbursed_date`, `status = ADVANCE_PAID` |
| `SET_TRAVELLED_STATUS` | Daily scheduler — moves `ADVANCE_PAID` requests past `return_date` to `TRAVELLED` |
| `AUTO_CLOSE_REQUESTS` | Daily scheduler — closes `TRAVELLED` requests when `SETTLEMENT_REQUIRED = N` and `AUTO_CLOSE_DAYS` has elapsed |
| `SUBMIT_SETTLEMENT(p_settlement_id)` | Validates line sum, mandatory receipts, creates approval instance, sets status = SUBMITTED |
| `CLOSE_REQUEST(p_request_id)` | Sets request `status = CLOSED`, `closed_date = SYSDATE` |
| `SEND_SETTLEMENT_ALERTS` | Daily scheduler — notifies when settlement is overdue beyond `SETTLEMENT_LATE_ALERT_DAYS` |

---

## 13. Notifications

| Event | Notify |
|---|---|
| Request submitted | Next approver |
| Request approved | Employee + Finance (disbursement action required) |
| Request rejected / returned | Employee |
| Advance disbursed | Employee |
| Employee returned (status → TRAVELLED) | Employee — settlement reminder if `SETTLEMENT_REQUIRED = Y` |
| Settlement overdue | Finance + DT_ADMIN |
| Settlement submitted | Next approver |
| Settlement approved | Employee + Finance (payment/refund action required) |
| Request auto-closed | Employee |

All notifications use `DCT_NOTIFY` package.

---

## 14. Database Tables Summary

| Table | Description |
|---|---|
| Table | Description |
|---|---|
| `DT_REQUESTS` | Master travel request per employee per trip |
| `DT_DESTINATIONS` | Destination legs within a trip |
| `DT_PER_DIEM_RATES` | Rate master: rate_key × grade → single daily per diem |
| `DT_COUNTRY_GROUPS` | Maps country codes to tier or region codes (for TIER_BASED / REGION_BASED rate structures) |
| `DT_DOCUMENTS` | Supporting documents for requests and settlements |
| `DT_DOC_REQUIREMENTS` | Admin-configured required document types |
| `DT_SETTLEMENT` | Post-travel expense settlement header |
| `DT_SETTLEMENT_LINES` | Itemised actual expenses per settlement |

---

## 15. Sequences

| Sequence | Purpose | Format |
|---|---|---|
| `SEQ_DT_REQUEST_NUMBER` | Travel request reference numbers | `{REQUEST_NUMBER_PREFIX}-{YYYY}-{00001}` — prefix configurable via module setting |
| `SEQ_DT_SETTLEMENT_NUMBER` | Settlement reference numbers | `{SETTLEMENT_NUMBER_PREFIX}-{YYYY}-{00001}` — prefix configurable via module setting |

---

## 16. Shared Architecture

App 204 subscribes to App 200 (i-Finance Hub) for:
- Authentication Scheme: `DCT Auth`
- Standard Application Items: `APP_USER_ID`, `APP_EMP_NUM`, `APP_EMP_NAME`, `APP_ORG_ID`, `APP_IS_ADMIN`, `APP_IS_MANAGER`, `APP_PENDING_APPROVAL_COUNT`
- Common LOVs: `LOV_DCT_EMPLOYEES`, `LOV_DCT_ORGANIZATIONS`, `LOV_DCT_ROLES`, `LOV_YES_NO`, `LOV_ACTIVE_INACTIVE`, `LOV_MONTHS`, `LOV_APPROVAL_STATUS`, `LOV_REQUEST_STATUSES`
- Standard Authorization Schemes: `IS_ADMIN`, `IS_MANAGER`, `IS_MANAGER_OR_ADMIN`

Module-specific items, LOVs, and authorization schemes are defined locally in App 204.

See `final apps/SHARED_APEX_ARCHITECTURE.md` for the full shared architecture rules.
