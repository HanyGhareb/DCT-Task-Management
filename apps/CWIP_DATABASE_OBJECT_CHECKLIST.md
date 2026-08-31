# CWIP Database Object Checklist

## Purpose

Use this document to record the current database objects behind these legacy APEX applications:

- App 130 — CWIP Payments Management
- App 109 — CWIP Payment - Ex
- App 142 — CWIP Change Management

The object names below were observed in the APEX page exports or the supplied payment workflow documents. Current database DDL was not available, so object type, ownership, constraints and continued existence must be confirmed from the database.

## How to update this checklist

For each row:

1. Change `Exists?` to `Y`, `N`, `Renamed` or `Replaced`.
2. Enter the actual schema owner and object type.
3. Add the repository path where you place the DDL or source.
4. Record renamed/replacement objects and any important notes.
5. Change `[ ]` to `[x]` only after the object and its dependencies have been checked.

Suggested values for `Actual type` are `TABLE`, `VIEW`, `MATERIALIZED VIEW`, `SYNONYM` and `DB LINK VIEW`.

## 1. Payment transaction and workflow objects

Used by App 130 and App 109.

| Done | Observed object | Expected type | Priority | Owner | Actual type | Exists? | DDL/source path | Replacement or notes |
|---|---|---|---|---|---|---|---|---|
| [ ] | `CWIP_PAYMENT_RECOMMENDATION` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENT_REC_APPROVAL_HISTORY` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENT_RECOMMENDATION_COMMENTS` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENT_REC_MORE_INFO` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENT_REC_REMINDERS` | Table | Supporting |  |  |  |  |  |
| [ ] | `CWIP_CONTRACT_INVOICES` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENTS_CONFIGURATION` | Table | Core |  |  |  |  |  |
| [ ] | `CWIP_PAYMENT_RECOMMENDATION_V` | View | Core |  |  |  |  |  |

For these objects, verify:

- primary, foreign, unique and check constraints;
- payment/recommendation number generation;
- amount, tax, retention, currency and contract-balance columns;
- all header and workflow status values;
- submitter, approver, delegation and on-behalf fields;
- BLOB, filename, MIME type and file-size columns;
- audit and optimistic-lock columns;
- triggers, sequences/identity definitions and workflow-inbox indexes.

## 2. Project, contract and project-team objects

Shared by all three applications.

| Done | Observed object | Expected type | Priority | Owner | Actual type | Exists? | DDL/source path | Replacement or notes |
|---|---|---|---|---|---|---|---|---|
| [ ] | `PROJECT` | Table or synonym | Core shared |  |  |  |  |  |
| [ ] | `PROJECT_ROLE_CATEGORY` | Table | Core shared |  |  |  |  |  |
| [ ] | `PROJECT_ROLE` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_TEAM` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_CONTRACT` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_CONTRACT_PROJECTS` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_CONTRACTS_V` | View | Core shared |  |  |  |  |  |
| [ ] | `CWIP_CONTRACT_DOCUMENTS` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_DOCUMENTS` | Table | Supporting |  |  |  |  |  |
| [ ] | `CWIP_CONTRACT_END_USERS` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_CONTRACT_CONTRACTUAL_SECURITIES` | Table | Supporting |  |  |  |  |  |
| [ ] | `CWIP_CONTRACTUAL_SECURITIES_LIST` | Unknown | Supporting |  |  |  |  |  |
| [ ] | `CWIP_PROJECT_STATUS_LOOKUP` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_PROJECT_LOCATIONS` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_PROJECT_PROGRESS` | Table | Supporting |  |  |  |  |  |
| [ ] | `CWIP_PROJECT_COST_ADJUSTMENT` | Table | Core shared |  |  |  |  |  |
| [ ] | `CWIP_PROJECT_BUDGET_SPLIT` | Table | Supporting |  |  |  |  |  |
| [ ] | `CWIP_PROJECT_ASSETS` | Table | Supporting |  |  |  |  |  |

Relationships that particularly need confirmation:

| Relationship to verify | Physical FK? | FK/constraint name | Actual parent/child key | Notes |
|---|---|---|---|---|
| Project → contract-project bridge |  |  |  |  |
| Contract → contract-project bridge |  |  |  |  |
| Project → project team |  |  |  |  |
| Project role → project team |  |  |  |  |
| Employee/external user → project team |  |  |  |  |
| Contract → payment recommendation |  |  |  |  |
| Contract → invoice |  |  |  |  |
| Contract → end user/access |  |  |  |  |
| Contract → documents/securities |  |  |  |  |

## 3. Change-management objects

Used by App 142.

| Done | Observed object | Expected type | Priority | Owner | Actual type | Exists? | DDL/source path | Replacement or notes |
|---|---|---|---|---|---|---|---|---|
| [ ] | `VR_REQUESTS` | Table | Core |  |  |  |  |  |
| [ ] | `VR_REQUESTS_DOCUMENTS` | Table | Core |  |  |  |  |  |
| [ ] | `VR_REQUESTS_APPROVAL_HISTORY` | Table | Core |  |  |  |  |  |
| [ ] | `BM_REQUESTS` | Table | Core |  |  |  |  |  |
| [ ] | `BM_VR_REQUESTS` | Table | Core bridge |  |  |  |  |  |
| [ ] | `BM_REQUESTS_DOCUMENTS` | Table | Core |  |  |  |  |  |
| [ ] | `BM_REQUESTS_APPROVAL_HISTORY` | Table | Core |  |  |  |  |  |
| [ ] | `BACOF_REQUESTS` | Table | Core |  |  |  |  | Confirm whether business name is BACOF or PACOF |
| [ ] | `BACOF_VR_REQUESTS` | Table | Core bridge |  |  |  |  |  |
| [ ] | `BACOF_REQUESTS_DOCUMENTS` | Table | Core |  |  |  |  |  |
| [ ] | `BACOF_REQUESTS_APPROVAL_HISTORY` | Table | Core |  |  |  |  |  |
| [ ] | `VO_REQUESTS` | Table | Core |  |  |  |  |  |
| [ ] | `VO_REQUESTS_COST_SUMMARY` | Table | Core detail |  |  |  |  |  |
| [ ] | `VO_REQUESTS_APPROVAL_HISTORY` | Table | Core |  |  |  |  |  |

For these objects, verify:

- request-number generation for VR, BM, BACOF/PACOF and VO;
- project and contract keys;
- the exact VR → BM → BACOF/PACOF → VO relationships;
- whether one request can contain multiple upstream requests;
- amount, currency, funding, schedule-impact and revised-completion fields;
- status, submission, final decision, rejection, return, withdrawal and cancellation fields;
- document and cost-line relationships;
- row version, audit, trigger and sequence definitions;
- whether the four approval-history structures have identical or different columns.

Record the upstream relationships explicitly:

| Relationship to verify | Cardinality | Bridge/FK object | Physical constraint | Notes |
|---|---|---|---|---|
| Project/contract → VR |  |  |  |  |
| VR → BM |  | `BM_VR_REQUESTS` expected |  |  |
| VR/BM → BACOF/PACOF |  | `BACOF_VR_REQUESTS` observed |  |  |
| BACOF/PACOF → VO |  | Unknown from export |  |  |
| Contract → VO |  |  |  |  |
| VO → cost-summary lines |  | `VO_REQUESTS_COST_SUMMARY` expected |  |  |

## 4. People, organization, supplier and lookup objects

| Done | Observed object | Expected type | Priority | Owner | Actual type | Exists? | DDL/source path | Replacement or notes |
|---|---|---|---|---|---|---|---|---|
| [ ] | `DCT_EXT_USERS` | Table | Core shared |  |  |  |  |  |
| [ ] | `EMPLOYEES_V` | View | Core shared |  |  |  |  |  |
| [ ] | `DCT_EMPLOYEES_LIST2` | Unknown | Core shared |  |  |  |  |  |
| [ ] | `DCT_EMPLOYEES_LOOKUPS` | Unknown | Supporting |  |  |  |  |  |
| [ ] | `DCT_EMPLOYEES_SIGNATURES` | Table | Supporting |  |  |  |  |  |
| [ ] | `DCT_HR_ORGANIZATIONS` | Unknown | Core shared |  |  |  |  |  |
| [ ] | `ORGANIZATIONS_V` | View | Core shared |  |  |  |  |  |
| [ ] | `ORGANIZATIONS_DETAILS_V` | View | Core shared |  |  |  |  |  |
| [ ] | `DCT_LOOKUPS` | Unknown | Core shared |  |  |  |  |  |
| [ ] | `DCT_LOOKUP_VALUES` | Table | Core shared |  |  |  |  |  |
| [ ] | `DCT_LOOKUPS_EXTENDED` | Unknown | Core shared |  |  |  |  |  |
| [ ] | `CWIP_LOOKUP_VALUES` | Table | Core shared |  |  |  |  |  |
| [ ] | `VENDORS` | Unknown | Core shared |  |  |  |  |  |
| [ ] | `VENDOR_CONTACTS` | Unknown | Supporting |  |  |  |  |  |
| [ ] | `VENDORS_BANK_ACCOUNTS` | Unknown | Supporting |  |  |  |  |  |
| [ ] | `FA_ASSETS` | Unknown | Supporting |  |  |  |  |  |
| [ ] | `HRSS_CONFIGURATIONS` | Table | Supporting |  |  |  |  |  |

For every view or synonym, provide both its definition and the underlying base objects. Also record whether it is locally maintained, sourced from ERP/HR, refreshed by an integration job, or accessed over a database link.

## 5. Package source checklist

The application behavior cannot be reconstructed from table DDL alone. Please provide the current package specification and body for each applicable package.

| Done | Package | Apps | Spec path | Body path | Current/valid? | Replacement or notes |
|---|---|---|---|---|---|---|
| [ ] | `CWIP_REC_PAYMENT_WORKFLOW` | 130, 109 |  |  |  | Two divergent legacy bodies are currently supplied |
| [ ] | `CWIP_REC_PAYMENT_EMAILS` | 130, 109 |  |  |  | Only 2022 backup source is currently available |
| [ ] | `CWIP_REC_PAYMENT_UTIL` | 130, 109 |  |  |  |  |
| [ ] | `CWIP_REC_PAYMENT_EXT_APP` | 130, 109 |  |  |  |  |
| [ ] | `VR_WORKFLOW` | 142 |  |  |  | Submission call observed |
| [ ] | `VR_WORKFLOW2` | 142 |  |  |  | Approval/action calls observed |
| [ ] | `BM_WORKFLOW` | 142 |  |  |  |  |
| [ ] | `BACOF_WORKFLOW` | 142 |  |  |  | Confirm BACOF/PACOF terminology |
| [ ] | `VO_WORKFLOW` | 142 |  |  |  |  |
| [ ] | `CONTRACT_UTIL` | 142 |  |  |  |  |
| [ ] | `VO_UTIL` | 142 |  |  |  |  |
| [ ] | `EXT_USERS` | 109 |  |  |  | Includes external authentication dependency |
| [ ] | `USER_DETAILS` | 130, 142 |  |  |  |  |
| [ ] | `DCT_UTIL` | 130, 109 |  |  |  | Includes OTP and formatting calls |

## 6. DDL completeness checklist per confirmed table

Use one row per confirmed table. Add rows as necessary.

| Table | Table DDL | PK/UK/FK/check constraints | Indexes | Triggers | Sequence/identity | Comments | Grants/synonyms | Status/code samples | Row count | Complete? |
|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  | [ ] |
|  |  |  |  |  |  |  |  |  |  | [ ] |
|  |  |  |  |  |  |  |  |  |  | [ ] |

## 7. Objects not to recreate as CWIP tables

The APEX exports reference these Oracle/APEX operational objects. They should normally be treated as platform dependencies, not CWIP business tables:

- `ALL_SEQUENCES`
- `APEX$TEAM_DEV_FILES`
- `USER_SCHEDULER_JOBS`
- `USER_SCHEDULER_JOB_RUN_DETAILS`

Record any custom business dependency on these objects before redesigning the related administration pages.

## 8. Additional objects discovered from database source

Package bodies and view definitions may reveal tables not directly referenced by APEX pages. Add them here.

| Done | Discovered object | Type | Discovered from | Business purpose | Owner | DDL/source path | Notes |
|---|---|---|---|---|---|---|---|
| [ ] |  |  |  |  |  |  |  |
| [ ] |  |  |  |  |  |  |  |
| [ ] |  |  |  |  |  |  |  |

## 9. Sign-off

| Review area | Reviewed by | Date | Status | Notes |
|---|---|---|---|---|
| Payment objects |  |  | Not started |  |
| Project/contract/team objects |  |  | Not started |  |
| Change-management objects |  |  | Not started |  |
| People/vendor/lookup objects |  |  | Not started |  |
| Packages and views |  |  | Not started |  |
| Overall physical model |  |  | Not started |  |
