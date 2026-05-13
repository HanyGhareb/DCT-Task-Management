# Business Requirements Document — Credit Cards Module (App 202)
**Version:** 1.0 | **Date:** 2026-05-13 | **Status:** Locked

---

## 1. Purpose & Scope

Manages corporate credit cards issued to DCT employees. Covers the full card lifecycle: new card issuance, limit changes, card replacement, card closure, and monthly expense replenishment. Gift Cards are a separate module.

All DCT employees may hold a credit card. The CC Admin (Treasury) manages issuance and administrative changes. Employees raise requests and submit monthly expense statements.

---

## 2. Core Entities

### 2.1 Credit Card — Registry (DCT_CREDIT_CARDS)

| Field | Type | Null | Notes |
|---|---|---|---|
| `cc_id` | NUMBER | NOT NULL | PK, system-generated |
| `cc_number` | VARCHAR2(30) | NOT NULL | App-generated: `CC-YYYY-NNNNN` |
| `holder_user_id` | NUMBER | NOT NULL | FK → DCT_USERS |
| `mother_name` | VARCHAR2(200) | NOT NULL | Required for bank issuance |
| `nationality` | VARCHAR2(100) | NOT NULL | Required for bank issuance |
| `credit_limit` | NUMBER | NOT NULL | AED |
| `expiry_date` | DATE | NOT NULL | Card physical expiry |
| `email` | VARCHAR2(200) | NOT NULL | Bank communications email |
| `org_id` | NUMBER | NOT NULL | FK → DCT_ORGANIZATIONS |
| `cost_center` | VARCHAR2(50) | NULL | GL cost center |
| `bank_name` | VARCHAR2(100) | NULL | Defaults from module setting `BANK_NAME` |
| `bank_customer_yn` | CHAR(1) | NOT NULL | Employee already banks with issuing bank? Y/N |
| `bank_mobile_yn` | CHAR(1) | NOT NULL | Mobile banking registered? Y/N |
| `bank_email_yn` | CHAR(1) | NOT NULL | Email banking registered? Y/N |
| `status` | VARCHAR2(30) | NOT NULL | See §3 |
| `notes` | VARCHAR2(1000) | NULL | Admin free-text |
| `approval_instance_id` | NUMBER | NULL | FK → DCT_APPROVAL_INSTANCES (current active request) |
| `created_by` | NUMBER | NOT NULL | FK → DCT_USERS |
| `created_at` | DATE | NOT NULL | |
| `updated_by` | NUMBER | NOT NULL | FK → DCT_USERS |
| `updated_at` | DATE | NOT NULL | Maintained by trigger |

### 2.2 Card Request (DCT_CC_REQUESTS)

Each change to a card — including first issuance — is a request record.

| Field | Type | Null | Notes |
|---|---|---|---|
| `request_id` | NUMBER | NOT NULL | PK |
| `request_number` | VARCHAR2(30) | NOT NULL | `CCR-YYYY-NNNNN` |
| `cc_id` | NUMBER | NULL | FK → DCT_CREDIT_CARDS; NULL for NEW_CARD type |
| `request_type` | VARCHAR2(20) | NOT NULL | NEW_CARD / INCREASE_LIMIT / DECREASE_LIMIT / CLOSE_CARD / REPLACEMENT |
| `requested_limit` | NUMBER | NULL | For INCREASE/DECREASE — new requested limit |
| `reason` | VARCHAR2(500) | NULL | Requester justification |
| `replacement_reason` | VARCHAR2(100) | NULL | DAMAGED / LOST / EXPIRING / OTHER |
| `status` | VARCHAR2(20) | NOT NULL | DRAFT / SUBMITTED / UNDER_REVIEW / RETURNED / APPROVED / REJECTED / WITHDRAWN |
| `approval_instance_id` | NUMBER | NULL | FK → DCT_APPROVAL_INSTANCES |
| `submitted_at` | DATE | NULL | |
| `created_by` | NUMBER | NOT NULL | FK → DCT_USERS |
| `created_at` | DATE | NOT NULL | |
| `updated_by` | NUMBER | NOT NULL | FK → DCT_USERS |
| `updated_at` | DATE | NOT NULL | Maintained by trigger |

**Read-only rule:** Request form is read-only unless `status IN ('DRAFT', 'RETURNED', 'WITHDRAWN')`.

### 2.3 Document Requirements — Admin-Configured (DCT_CC_DOC_REQUIREMENTS)

| Field | Type | Null | Notes |
|---|---|---|---|
| `doc_req_id` | NUMBER | NOT NULL | PK |
| `request_type` | VARCHAR2(20) | NOT NULL | NEW_CARD / INCREASE_LIMIT / DECREASE_LIMIT / CLOSE_CARD / REPLACEMENT |
| `document_name` | VARCHAR2(200) | NOT NULL | E.g. "Emirates ID Copy", "HR Letter" |
| `is_mandatory` | CHAR(1) | NOT NULL | Y/N |
| `is_active` | CHAR(1) | NOT NULL | Y/N |
| `display_seq` | NUMBER | NOT NULL | Display order |
| `created_by` | NUMBER | NOT NULL | |
| `created_at` | DATE | NOT NULL | |
| `updated_by` | NUMBER | NOT NULL | |
| `updated_at` | DATE | NOT NULL | |

### 2.4 Attachments (DCT_CC_ATTACHMENTS)

Single table for all uploads — card requests and replenishments — using a source_type discriminator.

| Field | Type | Null | Notes |
|---|---|---|---|
| `attach_id` | NUMBER | NOT NULL | PK |
| `source_type` | VARCHAR2(20) | NOT NULL | REQUEST / REPLENISHMENT |
| `source_id` | NUMBER | NOT NULL | FK to DCT_CC_REQUESTS or DCT_CC_REPLENISHMENTS |
| `reference_id` | NUMBER | NULL | FK to DCT_CC_REIMB_LINES.line_id for line-level receipts |
| `doc_req_id` | NUMBER | NULL | FK → DCT_CC_DOC_REQUIREMENTS (nullable — free upload) |
| `file_name` | VARCHAR2(500) | NOT NULL | |
| `mime_type` | VARCHAR2(200) | NULL | |
| `file_size` | NUMBER | NULL | Bytes |
| `file_blob` | BLOB | NULL | |
| `description` | VARCHAR2(500) | NULL | |
| `uploaded_by` | NUMBER | NOT NULL | FK → DCT_USERS |
| `uploaded_at` | DATE | NOT NULL | |

Line-level receipt key: `source_type = 'REPLENISHMENT'`, `source_id = replenishment_id`, `reference_id = line_id`.

### 2.5 Approver Delegation (DCT_CC_DELEGATION)

Allows an approver to temporarily delegate their approval authority to another user.

| Field | Type | Null | Notes |
|---|---|---|---|
| `delegation_id` | NUMBER | NOT NULL | PK |
| `delegator_user_id` | NUMBER | NOT NULL | FK → DCT_USERS — who is delegating |
| `delegate_user_id` | NUMBER | NOT NULL | FK → DCT_USERS — who receives authority |
| `start_date` | DATE | NOT NULL | Effective from |
| `end_date` | DATE | NOT NULL | Effective to |
| `reason` | VARCHAR2(500) | NULL | |
| `is_active` | CHAR(1) | NOT NULL | Y/N |
| `created_by` | NUMBER | NOT NULL | |
| `created_at` | DATE | NOT NULL | |
| `updated_by` | NUMBER | NOT NULL | |
| `updated_at` | DATE | NOT NULL | |

---

## 3. Credit Card Replenishment (Monthly)

### 3.1 Concept

Each month, by a configurable due date, the card holder (or an assigned proxy) submits a **replenishment statement** listing all expenses charged to the card during that period.

Budget coding is set at **header level** (coding_type + GL or Project fields) and **defaulted onto each line** — overridable per line.

### 3.2 Replenishment Header (DCT_CC_REPLENISHMENTS)

| Field | Type | Null | Notes |
|---|---|---|---|
| `replenishment_id` | NUMBER | NOT NULL | PK |
| `reimb_number` | VARCHAR2(30) | NOT NULL | `CCM-YYYY-MM-NNNNN` |
| `cc_id` | NUMBER | NOT NULL | FK → DCT_CREDIT_CARDS |
| `period_month` | NUMBER(2) | NOT NULL | 1–12 |
| `period_year` | NUMBER(4) | NOT NULL | |
| `total_amount` | NUMBER | NOT NULL | Must equal sum of expense lines |
| `submitted_by_user_id` | NUMBER | NOT NULL | FK → DCT_USERS (owner or proxy) |
| `on_behalf_of_user_id` | NUMBER | NOT NULL | FK → DCT_USERS (card owner) |
| `coding_type` | VARCHAR2(10) | NULL | GL / PROJECT — default for all lines |
| `cc_id_gl` | NUMBER | NULL | FK → DCT_GL_CODE_COMBINATIONS (if GL) |
| `project_number` | VARCHAR2(50) | NULL | (if PROJECT) |
| `task_number` | VARCHAR2(50) | NULL | |
| `expenditure_type` | VARCHAR2(100) | NULL | |
| `status` | VARCHAR2(20) | NOT NULL | DRAFT / SUBMITTED / UNDER_REVIEW / RETURNED / APPROVED / REJECTED |
| `approval_instance_id` | NUMBER | NULL | FK → DCT_APPROVAL_INSTANCES |
| `submitted_at` | DATE | NULL | |
| `created_by` | NUMBER | NOT NULL | |
| `created_at` | DATE | NOT NULL | |
| `updated_by` | NUMBER | NOT NULL | |
| `updated_at` | DATE | NOT NULL | |

**Unique constraint:** one replenishment per card per (period_month, period_year).

### 3.3 Expense Lines (DCT_CC_REIMB_LINES)

| Field | Type | Null | Notes |
|---|---|---|---|
| `line_id` | NUMBER | NOT NULL | PK |
| `replenishment_id` | NUMBER | NOT NULL | FK → DCT_CC_REPLENISHMENTS (cascade delete) |
| `line_num` | NUMBER | NOT NULL | Display order |
| `expense_date` | DATE | NOT NULL | Date of transaction |
| `merchant_name` | VARCHAR2(200) | NOT NULL | Vendor / payee |
| `amount` | NUMBER | NOT NULL | |
| `description` | VARCHAR2(500) | NULL | |
| `coding_type` | VARCHAR2(10) | NULL | Defaulted from header, overridable |
| `cc_id_gl` | NUMBER | NULL | FK → DCT_GL_CODE_COMBINATIONS — defaulted, overridable |
| `project_number` | VARCHAR2(50) | NULL | Defaulted from header, overridable |
| `task_number` | VARCHAR2(50) | NULL | Defaulted from header, overridable |
| `expenditure_type` | VARCHAR2(100) | NULL | Defaulted from header, overridable |
| `receipt_attached` | CHAR(1) | NOT NULL | Y/N — receipt uploaded for this line |

Lines must sum to `total_amount` on the header.

### 3.4 Proxy Submitters (DCT_CC_PROXIES)

Admin defines who can submit replenishments on behalf of a card owner.

| Field | Type | Null | Notes |
|---|---|---|---|
| `proxy_id` | NUMBER | NOT NULL | PK |
| `cc_id` | NUMBER | NOT NULL | FK → DCT_CREDIT_CARDS |
| `proxy_user_id` | NUMBER | NOT NULL | FK → DCT_USERS |
| `is_active` | CHAR(1) | NOT NULL | Y/N |
| `start_date` | DATE | NOT NULL | |
| `end_date` | DATE | NULL | NULL = no expiry |
| `granted_by_user_id` | NUMBER | NOT NULL | Admin who set this |
| `created_by` | NUMBER | NOT NULL | |
| `created_at` | DATE | NOT NULL | |
| `updated_by` | NUMBER | NOT NULL | |
| `updated_at` | DATE | NOT NULL | |

---

## 4. Status Values

### Card Status
| Value | Description |
|---|---|
| `ACTIVE` | Card in use |
| `INACTIVE` | Card disabled |
| `UNDER_PROCESS` | Awaiting initial processing |
| `REPLACEMENT_IN_PROGRESS` | Replacement request pending |
| `CLOSING_IN_PROGRESS` | Closure request pending |
| `INCREASING_IN_PROGRESS` | Limit increase request pending |
| `DECREASING_IN_PROGRESS` | Limit decrease request pending |

### Request Status
`DRAFT` / `SUBMITTED` / `UNDER_REVIEW` / `RETURNED` / `APPROVED` / `REJECTED` / `WITHDRAWN`

### Replenishment Status
`DRAFT` / `SUBMITTED` / `UNDER_REVIEW` / `RETURNED` / `APPROVED` / `REJECTED`

---

## 5. Approval Workflow

Uses the shared **DCT_APPROVAL_TEMPLATES / DCT_APPROVAL_STEPS** framework.

| Template Code | Request Type | Typical Steps |
|---|---|---|
| `CC_NEW_CARD_APPROVAL` | NEW_CARD | Manager → CC Admin → Bank (optional) |
| `CC_CHANGE_APPROVAL` | INCREASE_LIMIT / DECREASE_LIMIT / REPLACEMENT | CC Admin → Bank (optional) |
| `CC_CLOSE_APPROVAL` | CLOSE_CARD | CC Admin |
| `CC_REPLENISHMENT_APPROVAL` | REPLENISHMENT | CC Admin |

Step conditions: `ALWAYS` / `TYPE_FILTER` / `CUSTOM` (bank step conditional on `BANK_APPROVAL_REQUIRED` setting).

---

## 6. Roles

| Role Code | Type | Description |
|---|---|---|
| `CC_ADMIN` | MODULE | Full access — all cards, all orgs, admin pages |
| `EMPLOYEE` | PLATFORM | View own card, raise requests |
| `MANAGER` | PLATFORM | Approve requests in their org |
| `ADMIN` | PLATFORM | Approval rules, module settings |

---

## 7. Module Settings (key: `CREDIT_CARDS`)

| Key | Default | Description |
|---|---|---|
| `BANK_NAME` | `ADCB` | Displayed on card records |
| `BANK_APPROVAL_REQUIRED` | `Y` | Whether bank step fires in workflows |
| `MAX_CARD_LIMIT_AED` | null | Hard cap on requestable limit (null = no cap) |
| `ALLOW_SELF_SERVICE_REQUEST` | `Y` | Employee can raise own requests |
| `REPLENISHMENT_DUE_DAY` | `5` | Day of month submission is due |
| `REPLENISHMENT_GRACE_DAYS` | `3` | Grace days after due date before late flag |
| `REPLENISHMENT_LINES_REQUIRED` | `Y` | Must have at least one expense line to submit |

---

## 8. APEX Pages (App 202)

| Page | Name | Type | Auth Scheme |
|---|---|---|---|
| 9999 | Login | Login | — |
| 0 | Global Page | — | — |
| 1 | Home Dashboard | Dashboard (KPI cards) | IS_EMPLOYEE |
| 2 | My Credit Card | IR + card details | IS_EMPLOYEE |
| 3 | Card Request Form | Form | IS_EMPLOYEE |
| 4 | All Credit Cards | IR | IS_CC_ADMIN |
| 5 | All Requests | IR | IS_CC_ADMIN |
| 6 | Pending Approvals | IR | IS_MANAGER_OR_ADMIN |
| 7 | Document Requirements | IG | IS_CC_ADMIN |
| 8 | Delegation | Form + IR | IS_MANAGER_OR_ADMIN |
| 9 | Approval Rules | Master-Detail | IS_ADMIN |
| 10 | Module Settings | IG | IS_ADMIN |
| 11 | My Replenishments | IR | IS_EMPLOYEE |
| 12 | Replenishment Form | Form + IG (lines) | IS_EMPLOYEE |
| 13 | All Replenishments | IR | IS_CC_ADMIN |
| 14 | Proxy Management | IG | IS_CC_ADMIN |

---

## 9. Notifications

- Request submitted → notify next approver
- Approved / Rejected / Returned → notify requester
- Replenishment due reminder → notify card holders approaching due date
- Uses `DCT_NOTIFY` package

---

## 10. Database Tables Summary

| Table | Description |
|---|---|
| `DCT_CREDIT_CARDS` | Card registry |
| `DCT_CC_REQUESTS` | Card change requests (new / change / close / replace) |
| `DCT_CC_DOC_REQUIREMENTS` | Required documents per request type (admin-configured) |
| `DCT_CC_ATTACHMENTS` | File uploads for requests and replenishments |
| `DCT_CC_DELEGATION` | Approver delegation records |
| `DCT_CC_REPLENISHMENTS` | Monthly expense statement headers |
| `DCT_CC_REIMB_LINES` | Expense lines per replenishment |
| `DCT_CC_PROXIES` | Proxy submitter assignments per card |

---

## 11. Shared Architecture

App 202 subscribes to App 200 (i-Finance Hub) for:
- Authentication Scheme: `DCT Auth`
- Standard Application Items: `APP_USER_ID`, `APP_EMP_NUM`, `APP_EMP_NAME`, `APP_ORG_ID`, `APP_IS_ADMIN`, `APP_IS_MANAGER`, `APP_PENDING_APPROVAL_COUNT`
- Common LOVs: `LOV_DCT_EMPLOYEES`, `LOV_DCT_ORGANIZATIONS`, `LOV_DCT_ROLES`, `LOV_YES_NO`, `LOV_ACTIVE_INACTIVE`, `LOV_MONTHS`, `LOV_APPROVAL_STATUS`, `LOV_REQUEST_STATUSES`
- Standard Authorization Schemes: `IS_ADMIN`, `IS_MANAGER`, `IS_MANAGER_OR_ADMIN`

Module-specific items, LOVs, and authorization schemes are created locally in App 202.

See `final apps/SHARED_APEX_ARCHITECTURE.md` for the full shared architecture rules.
