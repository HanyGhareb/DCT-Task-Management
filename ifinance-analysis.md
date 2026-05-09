# i-Finance APEX Applications — Full Analysis

**Exported:** 2026-05-09  
**Source folder:** `iFinance-20260509T122918Z-3-001/iFinance/`  
**Total applications:** 31

---

## Applications Summary

| App ID | Name | Alias | Purpose |
|--------|------|-------|---------|
| f100 | i-finance | I-FINANCE | Core hub: user profile, org access, menus, roles |
| f101 | Petty Cash | PCM | Petty cash expense requests, approvals, report views |
| f102 | HR | HR | Org structure viewing, hierarchy, missing HR data |
| f103 | Credit Cards Management | CREDIT-CARD-MGMT | Corporate credit card requests & approvals |
| f104 | Prepaid Cards | PREPAID-CARDS | Prepaid card provisioning |
| f105 | Fund Management | FUND-MGMT | Budget transfers, project access, fund approval flows |
| f106 | Employee Self Service | SSHR810 | Insurance, housing, missions, payroll upload |
| f108 | Manual PR | MPR500500 | Manual purchase requests, docs, approvals, budget analysis |
| f109 | CWIP Payment-Ex | EX-IFINANCE666666 | CWIP contract payment recommendations (external users) |
| f110 | Budget Allocation | BUDGET-ALLOCATION | Budget scenarios, publish requests, approvals |
| f113 | Payment Requests | IFINANCE-PAY-REQ | PO/GRN payment requests, allocation, approvals |
| f114 | Manager Checks | MANAGER-CHECKS | Check approval requests with docs & reminders |
| f115 | Budget Planning | BUDGET-PLANNING | Budget planning & forecasting |
| f116 | ifinance Template | IFINANCE-TEMPLATE | Base UI/UX template for other i-Finance apps |
| f117 | Documents | DOCUEMENTS | Document management system |
| f118 | Accounts Receivable | AR | Customer AR, due transactions, data validation |
| f119 | UCM | UCM | Unified content management / duty travel |
| f124 | Demand Planning | SCM-DPAP510510 | Item categories, budget brackets, demand planning |
| f127 | Bank Guarantee | BANK-GUARANTEE | Bank guarantee requests, docs, approvals |
| f130 | CWIP Payments Management | CWIPPAY | CWIP project teams, external users, contracts, payments |
| f142 | CWIP Change Management | CCM | CWIP variation requests, change reasons, funding sources |
| f166 | SMD Form | SCM-SINGLE-SOURCE120 | Single-source procurement exemption requests & TAC committees |
| f313 | SMD Form-Test | SCM-SINGLE-SOURCE120-TEST | Test instance of f166 (SMD Form) |
| f805 | Freelancers-Test | FREELANCERS-TEST | Freelancer/service provider registrations & agreements |
| f810 | Duty Hub | SSHR | Employee duty, missions, insurance, housing hub |
| f901 | HRSS | HRSS | HR Self Service petty cash & expense reports |
| f903 | Budget Transfer | BTR | Budget transfer requests, audit, support docs |
| f904 | CWIP Payments | CWIPPAY-DEV | Dev version of CWIP payments management |
| f910 | i-finance-EX | I-FINANCE100-EXT | Extended i-Finance: org access, menus, roles |
| f911 | Credit Cards Management | CREDIT-CARD-MGMT103 | Extended credit cards + gift card tracking |
| f9900 | i-finance-EX | I-FINANCE-EXT | Backup/archive of extended i-Finance |

---

## Per-Application Detail

---

### f100 — i-finance

**Alias:** I-FINANCE  
**Purpose:** Core enterprise financial management hub. Provides centralized navigation to all financial modules, manages user profile photos, organizational access control, role and group management, and system-wide instance settings.

**Key Pages:**
- Page 1: Home
- Page 2: Update User Profile Photo
- Page 3: User Organizations Access
- Page 5: Menus
- Page 6: Menu Details
- Page 7: My Roles & Groups
- Page 8: Instance Settings

**Database Objects:**
- `approval_types`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `dct_employees_signatures`
- `employees_v`

---

### f101 — Petty Cash

**Alias:** PCM  
**Purpose:** Manages petty cash expense requests end-to-end. Supports request submission, document attachment, approval/rejection workflows, and provides AP-level reporting views for all expense reports across the organization.

**Key Pages:**
- Page 1: Home
- Page 2: Petty Cash Requests
- Page 3: Petty Cash Details
- Page 4: Petty Cash Documents
- Page 6: Petty Cash Approve/Reject
- Page 7: All Expense Reports - AP
- Page 8: All Petty Cash

**Database Objects:**
- `hrss_petty_cash`
- `hrss_expense_reports`
- `hrss_expense_report_lines`
- `hrss_expense_report_approval_history`
- `hrss_configurations`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `employees_v`

---

### f102 — HR

**Alias:** HR  
**Purpose:** Human resources organizational management. Provides table and tree views of all organizational structures, highlights missing HR data, and allows managers to drill into department/organization details.

**Key Pages:**
- Page 1: Home
- Page 2: All Organizations - Table
- Page 3: All Organizations - View
- Page 4: Organizations Details View
- Page 5: Missing HR Data Details
- Page 6: Tree Page
- Page 8: Organization Details

**Database Objects:**
- `dct_employees_list2`

---

### f103 — Credit Cards Management

**Alias:** CREDIT-CARD-MGMT  
**Purpose:** Corporate credit card request management. Handles card request details, required document management, submission confirmation, approval/rejection workflows, and comment tracking for all credit card requests.

**Key Pages:**
- Page 1: Home
- Page 2: Credit Card Details
- Page 3: Manage Documents Required
- Page 4: Credit Card Document
- Page 5: Submit Credit Card Confirmation
- Page 6: Credit Card Approve/Reject
- Page 8: Credit Card Comment Details

**Database Objects:**
- `credit_cards`
- `approval_types`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `employees_v`

---

### f104 — Prepaid Cards

**Alias:** PREPAID-CARDS  
**Purpose:** Basic application for managing prepaid card provisioning and employee records. Minimal scope — likely early-stage or supplementary to credit card management.

**Key Pages:**
- Page 1: Home

**Database Objects:**
- `dct_employees_list2`

---

### f105 — Fund Management

**Alias:** FUND-MGMT  
**Purpose:** Comprehensive budget transfer and fund management. Manages project access requests, budget transfer requests across cost centers and projects, approval workflows, and maintains budget allocation and proposal plans.

**Key Pages:**
- Page 1: Home
- Page 2: End User - Requests Project Access Report
- Page 3: End User - Access Requests Form
- Page 4: End User - Access Request Approve/Reject
- Page 6: Budget Transfer Requests
- Page 7: End User - Transfer Request
- Page 8: BTF End User Details

**Database Objects:**
- `btf_data_access_requests`
- `btf_end_users_header`
- `btf_end_users_header_v`
- `btf_end_users_lines`
- `btf_end_users_req_approval_history`
- `budget_allocation_cost_centers_plans`
- `budget_allocation_projects_plans`
- `budget_proposal_cost_centers_plans`
- `budget_proposal_projects_plans`
- `cashflow_lines`

---

### f106 — Employee Self Service

**Alias:** SSHR810  
**Purpose:** Employee self-service portal covering insurance statement viewing, housing benefits, mission/duty rates, mission leg details, and payroll element upload with data load source management.

**Key Pages:**
- Page 1: Home
- Page 2: Insurance Statement
- Page 3: Duty Hub Home
- Page 4: Housing Home
- Page 5: Mission Rates
- Page 6: Mission Rate Details
- Page 7: Upload Payroll Elements
- Page 8: Data Load Source

**Database Objects:**
- `mission_distributions`
- `mission_legs`
- `mission_header`
- `insurance_invoices`
- `dct_lookup_values`
- `dct_employees_list2`
- `dct_employees_signatures`
- `dct_data_access_assignment`
- `employees_v`
- `roles`
- `sf_employees`

---

### f108 — Manual PR

**Alias:** MPR500500  
**Purpose:** Manual Purchase Request creation and management. Handles procurement method selection, document attachment, comments, approval workflows, and budget plan analysis by cost center.

**Key Pages:**
- Page 1: Home
- Page 2: MPR Details
- Page 3: Procurement Methods
- Page 4: MPR Documents
- Page 5: MPR Comments
- Page 6: MPR Approve/Reject
- Page 7: Manual PR Action
- Page 8: PBP By Cost Center

**Database Objects:**
- `mpr`
- `mpr_approval_history`
- `dct_gl_code_combinations_all`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `employees_v`

---

### f109 — CWIP Payment-Ex

**Alias:** EX-IFINANCE666666  
**Purpose:** External-facing CWIP (Capital Work In Progress) payment recommendation system. Manages contracts, payment recommendation forms, supporting documents, comments, and approval tracking for external users.

**Key Pages:**
- Page 1: Home
- Page 2: My Contracts
- Page 3: Contract Details
- Page 4: Payment Recommendation Form
- Page 5: Payment Recommendation Documents
- Page 6: Payment Recommendation Comments
- Page 7: My Payments Recommendation
- Page 8: Payment Recommendation Approve/Reject

**Database Objects:**
- `cwip_contract`
- `cwip_payment_recommendation`
- `cwip_payment_recommendation_documents`
- `dct_ext_users`

---

### f110 — Budget Allocation

**Alias:** BUDGET-ALLOCATION  
**Purpose:** Budget allocation and scenario management. Supports multi-scenario budget views, notifications for approved budget publish requests, and approval workflows for budget finalization.

**Key Pages:**
- Page 1: Home
- Page 2: Budget 1
- Page 3: Budget 2
- Page 4: Budget 4
- Page 5: Notification - Approved Budget Publish Request
- Page 6: New Scenario
- Page 7: Budget IG 7
- Page 8: Budget IG 8

**Database Objects:**
- `budget`
- `approved_budget_summary`
- `dct_employees_list2`
- `employees_v`

---

### f113 — Payment Requests

**Alias:** IFINANCE-PAY-REQ  
**Purpose:** Purchase order and payment request processing. Manages payment request details, PO and GRN selection, document attachment, submission confirmation, multi-step approval workflows, and payment allocation.

**Key Pages:**
- Page 1: Home
- Page 2: Payment Request Details
- Page 3: Select PO and Receiving for Payment Request Lines
- Page 4: Payment Request Document
- Page 5: Submit Payment Request Confirmation
- Page 6: Payment Request Approve/Reject
- Page 7: Payment Request Approve/Reject Actions
- Page 8: Allocate Payment Request

**Database Objects:**
- `payment_request_lines`
- `receiving`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `employees_v`

---

### f114 — Manager Checks

**Alias:** MANAGER-CHECKS  
**Purpose:** Manager check request and approval system. Handles check request creation, document attachment, submission confirmation, approval/rejection workflows, comment tracking, and pending reminder dispatch.

**Key Pages:**
- Page 1: Home
- Page 2: Check Details
- Page 3: Check Documents
- Page 4: Submit Confirmation
- Page 5: Manager Checks Comments
- Page 6: Manager Cheque Approve/Reject
- Page 7: Manager Cheque Approve/Reject Actions
- Page 8: Send Manager Check Pending Reminder

**Database Objects:**
- `manager_checks`
- `manager_checks_approval_history`
- `manager_checks_reminders`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `employees_v`

---

### f115 — Budget Planning

**Alias:** BUDGET-PLANNING  
**Purpose:** Budget planning and forecasting module for organizational budget development and scenario management. Early-stage or lightweight supplement to f110 Budget Allocation.

**Key Pages:**
- Page 1: Home

**Database Objects:**
- `dct_employees_list2`

---

### f116 — ifinance Template

**Alias:** IFINANCE-TEMPLATE  
**Purpose:** Base template application providing standardized UI components, layout, and common functionality shared across all i-Finance APEX applications.

**Key Pages:**
- Page 1: Home

**Database Objects:**
- `dct_employees_list2`
- `employees_v`

---

### f117 — Documents

**Alias:** DOCUEMENTS  
**Purpose:** Centralized document management system for storing and managing documents across the i-Finance platform. Minimal scope identified — may be a utility/shared component app.

**Key Pages:**
- Page 1: Home

**Database Objects:**
- *(none identified)*

---

### f118 — Accounts Receivable

**Alias:** AR  
**Purpose:** Accounts receivable management for tracking customers, due transactions, and performing data validation. Includes data load and mapping tools for AR data migration and reconciliation.

**Key Pages:**
- Page 1: Home
- Page 2: Customers
- Page 3: Customer
- Page 4: Due Transactions
- Page 5: AR Due Transaction
- Page 6: Data Load Source
- Page 7: Data / Table Mapping
- Page 8: Data Validation

**Database Objects:**
- `ar_hotels_p_l_documents`
- `dct_employees_list2`

---

### f119 — UCM

**Alias:** UCM  
**Purpose:** Unified Content Management system providing access to duty travel details and employee records.

**Key Pages:**
- Page 1: Home
- Page 2: Duty Travel Details

**Database Objects:**
- `employees_v`

---

### f124 — Demand Planning

**Alias:** SCM-DPAP510510  
**Purpose:** SCM demand planning and forecasting system. Manages item categories, budget brackets, lookup values, demand planning items with full lifecycle (creation, participants, documents, PR requests, reminders), and approval workflows.

**Key Pages:**
- Page 1: Home
- Page 2: System Settings
- Page 3: System Setting
- Page 4: Item Categories
- Page 5: Item Category
- Page 6: Budget Brackets
- Page 7: Budget Bracket
- Page 8: Manage Lookups

**Database Objects:**
- `dp_items`
- `dp_item_categories`
- `dp_item_category_roles`
- `dp_item_participants`
- `dp_item_roles`
- `dp_item_status`
- `dp_items_approval_history`
- `dp_items_documents`
- `dp_items_pr_requests`
- `dp_items_reminders`
- `cashflow_lines`
- `dct_employees_list2`

---

### f127 — Bank Guarantee

**Alias:** BANK-GUARANTEE  
**Purpose:** Bank guarantee request management. Handles guarantee request creation, document attachment, submission, approval/rejection workflows, and action tracking for all bank guarantee transactions.

**Key Pages:**
- Page 1: Home
- Page 2: Bank Guarantee Details
- Page 3: Bank Guarantee Documents
- Page 4: Bank Guarantee Submit
- Page 5: Bank Guarantee Actions
- Page 6: Bank Guarantee Approve/Reject

**Database Objects:**
- `bank_guarantee_all_approval_history`
- `dct_employees_list2`
- `employees_v`

---

### f130 — CWIP Payments Management

**Alias:** CWIPPAY  
**Purpose:** Comprehensive CWIP payment administration. Manages project role categories, team assignments, external user registration, CWIP lookups, contract-based payment recommendations, and reminder tracking.

**Key Pages:**
- Page 1: Home
- Page 2: Project Roles Categories
- Page 3: Projects Roles
- Page 4: Project Team
- Page 5: External Users Report
- Page 6: External User Details
- Page 7: CWIP Lookups
- Page 8: Lookup Details

**Database Objects:**
- `cwip_contract`
- `cwip_payment_recommendation`
- `cwip_payment_recommendation_documents`
- `cwip_payment_recommendation_v`
- `cwip_payment_rec_reminders`
- `dct_employees_signatures`
- `employees_v`
- `vendors`

---

### f142 — CWIP Change Management

**Alias:** CCM  
**Purpose:** CWIP variation request and change management. Handles variation request creation, change reason documentation, estimate basis tracking, and funding source management for capital project changes.

**Key Pages:**
- Page 1: Home
- Page 2: Variation Requests VRs
- Page 3: VR Details
- Page 4: VR Change Reasons
- Page 5: VR Change Reason Details
- Page 6: VR Estimate Basis Report
- Page 7: VR Estimate Basis Details
- Page 8: VR Funding Source Report

**Database Objects:**
- `vr_requests`
- `dct_employees_list2`
- `employees_v`

---

### f166 — SMD Form

**Alias:** SCM-SINGLE-SOURCE120  
**Purpose:** Single-source procurement exemption request system. Manages exemption type configuration, request submission, supporting document tracking, TAC committee assignments, and multi-stage approval workflows.

**Key Pages:**
- Page 1: Single Source Requests
- Page 2: Single Source Details
- Page 3: Submit Confirmation
- Page 4: Exemption Types
- Page 5: Single Source Document
- Page 6: Single Source Approve/Reject
- Page 7: Single Source Approve/Reject Actions
- Page 8: TAC Committees Report

**Database Objects:**
- `scm_singl_source`
- `scm_singl_source_approval_history`
- `scm_singl_source_documents`
- `tac_committees`
- `tac_committee_members`
- `dct_lookup_values`
- `dct_employees_list2`
- `dct_employees_signatures`
- `dct_data_access_assignment`
- `employees_v`
- `roles`

---

### f313 — SMD Form-Test

**Alias:** SCM-SINGLE-SOURCE120-TEST  
**Purpose:** Test/QA instance of the SMD Form (f166). Identical functionality used for testing and validation before production deployment.

**Key Pages:** Same as f166

**Database Objects:** Same as f166 (all `scm_singl_source*`, `tac_*`, `dct_*`, `employees_v`, `roles`)

---

### f805 — Freelancers-Test

**Alias:** FREELANCERS-TEST  
**Purpose:** Freelancer and service provider registration and management. Processes registration requests, maintains service provider profiles including bank account details, and manages service agreement documents.

**Key Pages:**
- Page 1: Home
- Page 2: Registration Requests
- Page 3: Registration Request Details
- Page 4: Registration Request Details (alt)
- Page 5: Service Providers Report
- Page 6: Service Provider Details
- Page 7: Service Provider Bank Account Details
- Page 8: Service Provider Document Details

**Database Objects:**
- `freelancer_requests`
- `employees_v`
- `dct_employees_list2`
- `banks`

---

### f810 — Duty Hub

**Alias:** SSHR  
**Purpose:** Central employee duty and mission management hub. Provides access to insurance information, housing benefits, mission rates and leg details, mission distributions, payroll data upload, and data load source management.

**Key Pages:**
- Page 1: Home
- Page 2: Insurance Statement
- Page 3: Missions Home
- Page 4: Housing Home
- Page 5: Mission Rates
- Page 6: Mission Rate Details
- Page 7: Upload Payroll Elements
- Page 8: Data Load Source

**Database Objects:**
- `mission_distributions`
- `mission_approval_history`
- `mission_legs`
- `mission_header`
- `mission_emails`
- `insurance_invoices`
- `dct_lookup_values`
- `dct_employees_list2`
- `dct_employees_signatures`
- `dct_data_access_assignment`
- `employees_v`

---

### f901 — HRSS

**Alias:** HRSS  
**Purpose:** HR Self Service portal for employee petty cash requests and expense report management through the HR system.

**Key Pages:**
- Page 1: Home
- Page 2: Petty Cash Requests
- Page 3: Petty Cash Details
- Page 4: Petty Cash Documents
- Page 5: Petty Cash Comments
- Page 6: Petty Cash Approve/Reject
- Page 7: All Expense Reports - AP
- Page 8: All Petty Cash

**Database Objects:**
- `hrss_petty_cash`
- `dct_employees_list2`

---

### f903 — Budget Transfer

**Alias:** BTR  
**Purpose:** Budget transfer request management system. Handles transfer request creation, line-level detail, audit trail, supporting document attachment, project data views, and approver configuration.

**Key Pages:**
- Page 1: Home
- Page 2: Budget Transfer Requests
- Page 3: Budget Transfer Main Details
- Page 4: BTF Line
- Page 5: Budget Transfer Request Audit Details
- Page 6: Add Budget Transfer Support Documents
- Page 7: Projects Data
- Page 8: Approvers Management

**Database Objects:**
- `btf_all_actions`
- `btf_data_access`
- `btf_end_users_req`
- `btf_lines`
- `dct_employees_list2`

---

### f904 — CWIP Payments

**Alias:** CWIPPAY-DEV  
**Purpose:** Development version of CWIP Payments Management (f130). Used for testing new features including project roles, team assignments, external user management, and CWIP payment recommendations.

**Key Pages:**
- Page 1: Home
- Page 2: Project Roles Categories
- Page 3: Projects Roles
- Page 4: Project Team
- Page 5: External Users Report
- Page 6: External User Details
- Page 7: CWIP Lookups
- Page 8: Lookup Details

**Database Objects:**
- `cwip_payment_recommendation`
- `cwip_payment_recommendation_v`
- `dct_employees_list2`
- `dct_employees_signatures`

---

### f910 — i-finance-EX

**Alias:** I-FINANCE100-EXT  
**Purpose:** Extended version of the core i-Finance hub (f100). Provides enhanced user profile management, organizational access control, menu configuration, role/group management, and instance settings.

**Key Pages:**
- Page 1: Home
- Page 2: Update User Profile Photo
- Page 3: User Organizations Access
- Page 4: User Organizations Access Details
- Page 5: Menus
- Page 6: Menu Details
- Page 7: My Roles & Groups
- Page 8: Instance Settings

**Database Objects:**
- `dct_data_access_assignment`
- `dct_employees_list2`

---

### f911 — Credit Cards Management (Extended)

**Alias:** CREDIT-CARD-MGMT103  
**Purpose:** Extended credit card management including gift card tracking. Handles corporate and gift card requests, document requirements, approval workflows, comment tracking, and action management.

**Key Pages:**
- Page 1: Home
- Page 2: Credit Card Details
- Page 3: Manage Documents Required
- Page 4: Credit Card Document
- Page 5: Submit Credit Card Confirmation
- Page 6: Credit Card Approve/Reject
- Page 7: Credit Card Approve/Reject Actions
- Page 8: Credit Card Comment Details

**Database Objects:**
- `credit_cards`
- `gift_cards_request_line_details`
- `approval_types`
- `dct_data_access_assignment`
- `dct_employees_list2`
- `employees_v`

---

### f9900 — i-finance-EX (Backup)

**Alias:** I-FINANCE-EXT  
**Purpose:** Backup/archive version of the extended i-Finance application. Retains core team management, external user management, menu configuration, and internal email functionality.

**Key Pages:**
- Page 1: Home
- Page 2: Update User Profile Photo
- Page 3: Menus
- Page 4: Menu Details
- Page 5: Send Email Internal

**Database Objects:**
- `cwip_team`
- `dct_employees_list2`
- `dct_ext_users`

---

## Consolidated Database Objects

### Shared / Cross-App Tables (used by 3 or more apps)

| Table / View | Used By |
|---|---|
| `dct_employees_list2` | Nearly all apps |
| `employees_v` | f100, f103, f105, f106, f108, f110, f113, f114, f116, f119, f127, f130, f142, f166, f313, f805, f810, f811, f911 |
| `dct_data_access_assignment` | f100, f101, f103, f106, f108, f113, f114, f166, f313, f810, f910, f911 |
| `dct_employees_signatures` | f100, f106, f130, f166, f313, f810, f904 |
| `dct_lookup_values` | f106, f124, f166, f313, f810 |

### Domain-Specific Database Objects

#### Budget & Finance Planning

| Object | App(s) |
|---|---|
| `budget` | f110 |
| `approved_budget_summary` | f110 |
| `budget_allocation_cost_centers_plans` | f105 |
| `budget_allocation_projects_plans` | f105 |
| `budget_proposal_cost_centers_plans` | f105 |
| `budget_proposal_projects_plans` | f105 |
| `cashflow_lines` | f105, f124 |

#### Budget Transfer (BTF)

| Object | App(s) |
|---|---|
| `btf_data_access_requests` | f105 |
| `btf_end_users_header` | f105 |
| `btf_end_users_header_v` | f105 |
| `btf_end_users_lines` | f105 |
| `btf_end_users_req_approval_history` | f105 |
| `btf_all_actions` | f903 |
| `btf_data_access` | f903 |
| `btf_end_users_req` | f903 |
| `btf_lines` | f903 |

#### CWIP (Capital Work In Progress)

| Object | App(s) |
|---|---|
| `cwip_contract` | f109, f130 |
| `cwip_payment_recommendation` | f109, f130, f904 |
| `cwip_payment_recommendation_documents` | f109, f130 |
| `cwip_payment_recommendation_v` | f130, f904 |
| `cwip_payment_rec_reminders` | f130 |
| `cwip_team` | f9900 |
| `vr_requests` | f142 |

#### Credit Cards

| Object | App(s) |
|---|---|
| `credit_cards` | f103, f911 |
| `gift_cards_request_line_details` | f911 |
| `approval_types` | f100, f103, f911 |

#### HR & Petty Cash (HRSS)

| Object | App(s) |
|---|---|
| `hrss_petty_cash` | f101, f901 |
| `hrss_expense_reports` | f101 |
| `hrss_expense_report_lines` | f101 |
| `hrss_expense_report_approval_history` | f101 |
| `hrss_configurations` | f101 |

#### Missions & Duty

| Object | App(s) |
|---|---|
| `mission_header` | f106, f810 |
| `mission_legs` | f106, f810 |
| `mission_distributions` | f106, f810 |
| `mission_approval_history` | f810 |
| `mission_emails` | f810 |
| `insurance_invoices` | f106, f810 |

#### Demand Planning (SCM)

| Object | App(s) |
|---|---|
| `dp_items` | f124 |
| `dp_item_categories` | f124 |
| `dp_item_category_roles` | f124 |
| `dp_item_participants` | f124 |
| `dp_item_roles` | f124 |
| `dp_item_status` | f124 |
| `dp_items_approval_history` | f124 |
| `dp_items_documents` | f124 |
| `dp_items_pr_requests` | f124 |
| `dp_items_reminders` | f124 |

#### Single-Source Procurement (SCM/SMD)

| Object | App(s) |
|---|---|
| `scm_singl_source` | f166, f313 |
| `scm_singl_source_approval_history` | f166, f313 |
| `scm_singl_source_documents` | f166, f313 |
| `tac_committees` | f166, f313 |
| `tac_committee_members` | f166, f313 |

#### Finance Operations

| Object | App(s) |
|---|---|
| `manager_checks` | f114 |
| `manager_checks_approval_history` | f114 |
| `manager_checks_reminders` | f114 |
| `bank_guarantee_all_approval_history` | f127 |
| `payment_request_lines` | f113 |
| `receiving` | f113 |
| `mpr` | f108 |
| `mpr_approval_history` | f108 |
| `ar_hotels_p_l_documents` | f118 |

#### Freelancers

| Object | App(s) |
|---|---|
| `freelancer_requests` | f805 |
| `banks` | f805 |

#### Reference / Shared

| Object | App(s) |
|---|---|
| `dct_gl_code_combinations_all` | f108 |
| `dct_ext_users` | f109, f9900 |
| `roles` | f106, f166, f313 |
| `sf_employees` | f106 |
| `vendors` | f130 |

---

## Application Groups

### Core Platform
- **f100** i-finance — main hub
- **f910** i-finance-EX — extended hub
- **f9900** i-finance-EX Backup
- **f116** ifinance Template — base template

### HR & Employee
- **f102** HR
- **f106** Employee Self Service
- **f810** Duty Hub
- **f901** HRSS
- **f101** Petty Cash
- **f805** Freelancers-Test

### Budget & Finance
- **f110** Budget Allocation
- **f115** Budget Planning
- **f105** Fund Management
- **f903** Budget Transfer

### Payments & Procurement
- **f113** Payment Requests
- **f108** Manual PR
- **f114** Manager Checks
- **f127** Bank Guarantee
- **f103** Credit Cards Management
- **f911** Credit Cards Management (Extended)
- **f104** Prepaid Cards
- **f118** Accounts Receivable

### CWIP (Capital Work In Progress)
- **f130** CWIP Payments Management
- **f904** CWIP Payments (Dev)
- **f109** CWIP Payment-Ex
- **f142** CWIP Change Management

### SCM & Procurement
- **f124** Demand Planning
- **f166** SMD Form
- **f313** SMD Form-Test

### Content & Utility
- **f117** Documents
- **f119** UCM
