# i-Finance V2 — Master Application Design Proposal

**Date:** 2026-05-09  
**Author:** Design Review  
**Status:** APPROVED — Decisions locked, build ready to start

---

## 1. Executive Summary

i-Finance V2 is a new master Oracle APEX application that consolidates **authentication, authorization, user management, and system administration** for the entire i-Finance platform. It replaces the fragmented role/access control scattered across f100, f910, and f9900, and provides a clean foundation for all 31 domain apps to plug into without re-implementing their own security logic.

**Core responsibility of V2:**
> "Who can log in, what they can see, and how approvals are routed — for every app in the platform."

Domain apps (HR, Budget, CWIP, Procurement, etc.) remain separate APEX applications but delegate authentication and authorization checks to V2's shared PL/SQL packages.

---

## 2. Problems with the Current Architecture

| Problem | Root Cause | Impact |
|---|---|---|
| Three overlapping role systems | APEX ACL + `dct_data_access_assignment` + `roles` table — no single source of truth | Inconsistent access control across apps |
| Each app re-implements approval tables | No shared approval schema | 12+ sets of `_approval_history` tables with no reuse |
| Menu/role config buried in page SQL | Hard-coded LOV queries pointing directly to `dct_employees` | Cannot change navigation without SQL edits |
| `person_id` (numeric) ↔ `user_id` (text) mismatch | `dct_data_access_assignment` uses both identifiers inconsistently | Data integrity risks in access queries |
| No delegation / acting-on-behalf | No table or workflow for covering absent approvers | Approval chains stall when approver is on leave |
| No centralized audit trail | Each app has its own `_history` table, or none at all | Compliance reporting requires querying 15+ tables |
| Authentication is a black-box procedure | `AUTHENTICATE_USER` is a custom PL/SQL proc with no visible contract | Cannot extend or audit login behavior |

---

## 3. Design Goals

1. **Single source of truth** for users, roles, and permissions across all apps.
2. **Zero redundant access control logic** in domain apps — they call V2's packages.
3. **Configurable without code changes** — menus, roles, approval chains, and lookups managed via UI.
4. **Backward compatible** — legacy `dct_*` tables replaced by compatibility views, not dropped.
5. **Extensible module registry** — new apps register themselves; V2 controls their visibility.
6. **Audit-first** — every privilege and access change is logged with effective dates.
7. **Delegation-aware** — users can delegate authority to others for defined periods.
8. **Bilingual-ready** — Arabic/English support at the data and UI layer.

---

## 4. Application Scope

### In Scope — i-Finance V2 Master App

| Module | Description |
|---|---|
| **Authentication** | Login, logout, session management, password/OCI IAM handoff |
| **User Management** | Create, edit, deactivate users; import from HR; manage profiles |
| **Role Management** | Define roles, assign permissions, control scope |
| **Permission Management** | Granular action-level permissions per module |
| **Organization Management** | Org hierarchy, user-org assignments, section heads |
| **Module Registry** | Register all domain apps; control which roles can access them |
| **Approval Framework** | Define reusable approval chain templates per domain |
| **Lookup Management** | Manage all system lookup values (status codes, categories, etc.) |
| **Delegation Management** | Users delegate authority to others for a date range |
| **Announcement & Notifications** | System-wide announcements; notification queue |
| **System Settings** | Global key-value config store |
| **Audit & Compliance** | Centralized audit log for all privilege and data changes |
| **Task Management** | The Finance Division weekly task tracking module (DCT) |
| **App Launcher Portal** | Home page showing authorized modules as clickable cards |

### Out of Scope — Remain in Domain Apps
- Business data entry (payment requests, CWIP, credit cards, budget, etc.)
- Domain-specific reports
- File/document storage (handled per domain)

---

## 5. Database Schema Design

### Naming Convention: `DCT_` prefix (i-Finance Workspace)

All V2 tables use the `DCT_` prefix. Standard audit columns on every table:  
`created_by VARCHAR2(100)`, `created_at TIMESTAMP DEFAULT SYSTIMESTAMP`, `updated_by VARCHAR2(100)`, `updated_at TIMESTAMP`

---

### 5.1 User & Identity

```sql
DCT_USERS
  user_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  username         VARCHAR2(100) NOT NULL UNIQUE       -- APEX APP_USER / OCI IAM
  email            VARCHAR2(255) NOT NULL UNIQUE
  display_name     VARCHAR2(200) NOT NULL
  first_name       VARCHAR2(100)
  last_name        VARCHAR2(100)
  job_title        VARCHAR2(200)
  employee_number  VARCHAR2(50)                        -- Link to HR system
  person_id        NUMBER                              -- HR numeric key (dct_employees.person_id)
  mobile           VARCHAR2(20)
  photo_url        VARCHAR2(500)
  color_hex        VARCHAR2(7)                         -- Avatar color
  language_pref    VARCHAR2(10) DEFAULT 'EN'           -- EN / AR
  org_id           NUMBER FK DCT_ORGANIZATIONS         -- Primary org
  is_active        VARCHAR2(1) DEFAULT 'Y'
  is_external      VARCHAR2(1) DEFAULT 'N'             -- Freelancers / external users
  deactivated_at   TIMESTAMP
  last_login_at    TIMESTAMP
  -- audit columns
```

```sql
DCT_USER_PREFERENCES
  pref_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  user_id          NUMBER NOT NULL FK DCT_USERS
  pref_key         VARCHAR2(100) NOT NULL
  pref_value       VARCHAR2(4000)
  UNIQUE (user_id, pref_key)
```

---

### 5.2 Organization Hierarchy

```sql
DCT_ORGANIZATIONS
  org_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  org_code         VARCHAR2(50) NOT NULL UNIQUE
  org_name_en      VARCHAR2(200) NOT NULL
  org_name_ar      VARCHAR2(200)
  org_type         VARCHAR2(50)                        -- DIVISION, SECTION, UNIT, DEPARTMENT
  parent_org_id    NUMBER FK DCT_ORGANIZATIONS         -- Self-referencing hierarchy
  head_user_id     NUMBER FK DCT_USERS                 -- Section/Division head
  level_no         NUMBER                              -- Computed depth
  full_path        VARCHAR2(1000)                      -- e.g. Finance/Payables/...
  is_active        VARCHAR2(1) DEFAULT 'Y'
  display_order    NUMBER DEFAULT 0
  -- audit columns
```

```sql
DCT_USER_ORGS
  user_org_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  user_id          NUMBER NOT NULL FK DCT_USERS
  org_id           NUMBER NOT NULL FK DCT_ORGANIZATIONS
  assignment_type  VARCHAR2(50)                        -- PRIMARY, SECONDARY, ACTING
  is_primary       VARCHAR2(1) DEFAULT 'N'
  start_date       DATE NOT NULL DEFAULT SYSDATE
  end_date         DATE                                -- NULL = no expiry
  assigned_by      VARCHAR2(100)
  -- audit columns
  UNIQUE (user_id, org_id, assignment_type)
```

---

### 5.3 Roles & Permissions (RBAC Core)

```sql
DCT_ROLES
  role_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  role_code        VARCHAR2(100) NOT NULL UNIQUE
  role_name_en     VARCHAR2(200) NOT NULL
  role_name_ar     VARCHAR2(200)
  role_type        VARCHAR2(50)                        -- SYSTEM, MODULE, DATA
                                                       -- SYSTEM: super/admin roles
                                                       -- MODULE: business-domain roles
                                                       -- DATA: row-level access roles
  module_id        NUMBER FK DCT_MODULES               -- NULL = platform-wide role
  description      VARCHAR2(1000)
  is_system_role   VARCHAR2(1) DEFAULT 'N'             -- Cannot be deleted
  is_active        VARCHAR2(1) DEFAULT 'Y'
  display_order    NUMBER DEFAULT 0
  -- audit columns
```

```sql
DCT_PERMISSIONS
  permission_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  permission_code  VARCHAR2(200) NOT NULL UNIQUE       -- e.g. USERS.CREATE, CWIP.APPROVE
  permission_name  VARCHAR2(200) NOT NULL
  module_id        NUMBER FK DCT_MODULES
  action_type      VARCHAR2(50)                        -- VIEW, CREATE, EDIT, DELETE, APPROVE,
                                                       -- EXPORT, CONFIGURE, ADMIN
  description      VARCHAR2(1000)
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
```

```sql
DCT_ROLE_PERMISSIONS
  rp_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  role_id          NUMBER NOT NULL FK DCT_ROLES
  permission_id    NUMBER NOT NULL FK DCT_PERMISSIONS
  granted_by       VARCHAR2(100)
  granted_at       TIMESTAMP DEFAULT SYSTIMESTAMP
  UNIQUE (role_id, permission_id)
```

```sql
DCT_USER_ROLES
  user_role_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  user_id          NUMBER NOT NULL FK DCT_USERS
  role_id          NUMBER NOT NULL FK DCT_ROLES
  org_scope_id     NUMBER FK DCT_ORGANIZATIONS         -- NULL = all orgs; set = scoped to one org
  start_date       DATE NOT NULL DEFAULT SYSDATE
  end_date         DATE                                -- NULL = indefinite
  assigned_by      VARCHAR2(100)
  reason           VARCHAR2(500)
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
```

---

### 5.4 Module Registry

```sql
DCT_MODULES
  module_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  module_code      VARCHAR2(100) NOT NULL UNIQUE       -- e.g. CWIP, BUDGET, HR, TASK_MGMT
  module_name_en   VARCHAR2(200) NOT NULL
  module_name_ar   VARCHAR2(200)
  module_type      VARCHAR2(50)                        -- APEX_APP, EXTERNAL_URL, INTERNAL
  apex_app_id      NUMBER                              -- APEX application ID (e.g. 130)
  apex_page_id     NUMBER DEFAULT 1                    -- Entry page
  app_url          VARCHAR2(500)                       -- Override for external URLs
  icon_class       VARCHAR2(100)                       -- Font Awesome class
  icon_color       VARCHAR2(7)                         -- Hex color for card
  description_en   VARCHAR2(1000)
  description_ar   VARCHAR2(1000)
  category         VARCHAR2(100)                       -- HR, BUDGET, CWIP, PROCUREMENT, ADMIN
  display_order    NUMBER DEFAULT 0
  is_active        VARCHAR2(1) DEFAULT 'Y'
  is_new_tab       VARCHAR2(1) DEFAULT 'N'
  -- audit columns
```

```sql
DCT_MODULE_ROLES
  mr_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  module_id        NUMBER NOT NULL FK DCT_MODULES
  role_id          NUMBER NOT NULL FK DCT_ROLES
  access_level     VARCHAR2(20) DEFAULT 'FULL'         -- FULL, READ_ONLY
  UNIQUE (module_id, role_id)
```

---

### 5.5 Menu System

```sql
DCT_MENUS
  menu_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  module_id        NUMBER FK DCT_MODULES               -- Which module this menu belongs to
  menu_code        VARCHAR2(100) NOT NULL UNIQUE
  menu_name_en     VARCHAR2(200) NOT NULL
  menu_name_ar     VARCHAR2(200)
  menu_type        VARCHAR2(30)                        -- APP_LAUNCHER, SIDEBAR, BREADCRUMB
  is_active        VARCHAR2(1) DEFAULT 'Y'
```

```sql
DCT_MENU_ITEMS
  item_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  menu_id          NUMBER NOT NULL FK DCT_MENUS
  parent_item_id   NUMBER FK DCT_MENU_ITEMS            -- Nested menus
  label_en         VARCHAR2(200) NOT NULL
  label_ar         VARCHAR2(200)
  icon_class       VARCHAR2(100)
  target_type      VARCHAR2(30)                        -- APEX_PAGE, URL, MODULE
  apex_app_id      NUMBER
  apex_page_id     NUMBER
  target_url       VARCHAR2(500)
  required_permission_code VARCHAR2(200)               -- Permission needed to see this item
  display_order    NUMBER DEFAULT 0
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
```

---

### 5.6 Approval Framework

```sql
DCT_APPROVAL_TEMPLATES
  template_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  template_code    VARCHAR2(100) NOT NULL UNIQUE       -- e.g. PAYMENT_REQ_APPROVAL
  template_name    VARCHAR2(200) NOT NULL
  module_id        NUMBER FK DCT_MODULES
  description      VARCHAR2(1000)
  is_sequential    VARCHAR2(1) DEFAULT 'Y'             -- Y=sequential steps, N=parallel
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
```

```sql
DCT_APPROVAL_STEPS
  step_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  template_id      NUMBER NOT NULL FK DCT_APPROVAL_TEMPLATES
  step_seq         NUMBER NOT NULL                     -- Order of this step
  step_name        VARCHAR2(200) NOT NULL
  step_type        VARCHAR2(30)                        -- ROLE_BASED, USER_SPECIFIC, ORG_HEAD
  required_role_id NUMBER FK DCT_ROLES                 -- For ROLE_BASED steps
  specific_user_id NUMBER FK DCT_USERS                 -- For USER_SPECIFIC steps
  escalation_days  NUMBER DEFAULT 3                    -- Days before escalation
  escalate_to_role NUMBER FK DCT_ROLES
  is_mandatory     VARCHAR2(1) DEFAULT 'Y'
  allow_skip       VARCHAR2(1) DEFAULT 'N'
  UNIQUE (template_id, step_seq)
```

```sql
DCT_APPROVAL_INSTANCES
  instance_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  template_id      NUMBER NOT NULL FK DCT_APPROVAL_TEMPLATES
  source_module    VARCHAR2(100)                       -- Module code that owns this request
  source_record_id NUMBER NOT NULL                     -- PK of the requesting record
  source_record_ref VARCHAR2(200)                      -- Human-readable ref (e.g. "Payment #PRQ-2026-001")
  current_step_seq NUMBER DEFAULT 1
  overall_status   VARCHAR2(30) DEFAULT 'PENDING'      -- PENDING, APPROVED, REJECTED, CANCELLED
  submitted_by     NUMBER FK DCT_USERS
  submitted_at     TIMESTAMP DEFAULT SYSTIMESTAMP
  completed_at     TIMESTAMP
  -- audit columns
```

```sql
DCT_APPROVAL_ACTIONS
  action_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  instance_id      NUMBER NOT NULL FK DCT_APPROVAL_INSTANCES
  step_id          NUMBER NOT NULL FK DCT_APPROVAL_STEPS
  actioned_by      NUMBER NOT NULL FK DCT_USERS
  actioned_at      TIMESTAMP DEFAULT SYSTIMESTAMP
  action           VARCHAR2(30)                        -- APPROVED, REJECTED, RETURNED, DELEGATED
  comments         VARCHAR2(4000)
  delegate_to      NUMBER FK DCT_USERS                 -- If action = DELEGATED
  is_escalation    VARCHAR2(1) DEFAULT 'N'
```

---

### 5.7 Delegation of Authority

```sql
DCT_DELEGATIONS
  delegation_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  delegator_id     NUMBER NOT NULL FK DCT_USERS        -- The user delegating
  delegate_id      NUMBER NOT NULL FK DCT_USERS        -- The user receiving authority
  scope            VARCHAR2(30)                        -- ALL_ROLES, SPECIFIC_ROLE
  role_id          NUMBER FK DCT_ROLES                 -- If scope = SPECIFIC_ROLE
  module_id        NUMBER FK DCT_MODULES               -- If scoped to a module
  start_date       DATE NOT NULL
  end_date         DATE NOT NULL
  reason           VARCHAR2(500)
  status           VARCHAR2(20) DEFAULT 'ACTIVE'       -- ACTIVE, CANCELLED, EXPIRED
  approved_by      VARCHAR2(100)
  -- audit columns
```

---

### 5.8 Lookup Management

```sql
DCT_LOOKUP_CATEGORIES
  category_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  category_code    VARCHAR2(100) NOT NULL UNIQUE       -- e.g. TASK_STATUS, PRIORITY, CARD_TYPE
  category_name    VARCHAR2(200) NOT NULL
  module_id        NUMBER FK DCT_MODULES               -- NULL = platform-wide
  is_system        VARCHAR2(1) DEFAULT 'N'             -- System lookups are read-only in UI
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
```

```sql
DCT_LOOKUP_VALUES
  value_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  category_id      NUMBER NOT NULL FK DCT_LOOKUP_CATEGORIES
  value_code       VARCHAR2(100) NOT NULL
  value_name_en    VARCHAR2(200) NOT NULL
  value_name_ar    VARCHAR2(200)
  display_order    NUMBER DEFAULT 0
  tag              VARCHAR2(100)                       -- Optional grouping tag
  is_default       VARCHAR2(1) DEFAULT 'N'
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
  UNIQUE (category_id, value_code)
```

---

### 5.9 Audit & Session

```sql
DCT_AUDIT_LOG
  log_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  logged_at        TIMESTAMP DEFAULT SYSTIMESTAMP
  username         VARCHAR2(100)
  user_id          NUMBER FK DCT_USERS
  session_id       VARCHAR2(100)                       -- APEX session ID
  module_code      VARCHAR2(100)
  action           VARCHAR2(50)                        -- LOGIN, LOGOUT, CREATE, UPDATE, DELETE,
                                                       -- ROLE_ASSIGN, ROLE_REVOKE, APPROVE, REJECT
  object_type      VARCHAR2(100)                       -- Table/entity affected (e.g. DCT_USERS)
  object_id        VARCHAR2(200)                       -- PK of affected record
  old_values       CLOB                                -- JSON snapshot of before state
  new_values       CLOB                                -- JSON snapshot of after state
  ip_address       VARCHAR2(50)
  user_agent       VARCHAR2(500)
  status           VARCHAR2(20) DEFAULT 'SUCCESS'      -- SUCCESS, FAILURE
  error_message    VARCHAR2(4000)
```

```sql
DCT_SESSIONS
  session_id       VARCHAR2(100) PRIMARY KEY           -- APEX session ID
  user_id          NUMBER FK DCT_USERS
  username         VARCHAR2(100)
  login_at         TIMESTAMP DEFAULT SYSTIMESTAMP
  last_activity_at TIMESTAMP DEFAULT SYSTIMESTAMP
  logout_at        TIMESTAMP
  ip_address       VARCHAR2(50)
  is_active        VARCHAR2(1) DEFAULT 'Y'
```

---

### 5.10 Notifications & Announcements

```sql
DCT_NOTIFICATIONS
  notification_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  recipient_user_id NUMBER FK DCT_USERS
  module_code      VARCHAR2(100)
  notification_type VARCHAR2(50)                       -- APPROVAL_PENDING, APPROVAL_DONE,
                                                       -- TASK_DUE, DELEGATION, SYSTEM
  title            VARCHAR2(500)
  body             VARCHAR2(4000)
  link_url         VARCHAR2(500)
  is_read          VARCHAR2(1) DEFAULT 'N'
  read_at          TIMESTAMP
  created_at       TIMESTAMP DEFAULT SYSTIMESTAMP
  expires_at       TIMESTAMP
```

```sql
DCT_ANNOUNCEMENTS
  announcement_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  title_en         VARCHAR2(500) NOT NULL
  title_ar         VARCHAR2(500)
  body_en          CLOB
  body_ar          CLOB
  severity         VARCHAR2(20) DEFAULT 'INFO'         -- INFO, WARNING, CRITICAL
  target_audience  VARCHAR2(30) DEFAULT 'ALL'          -- ALL, ROLE, MODULE
  target_role_id   NUMBER FK DCT_ROLES
  target_module_id NUMBER FK DCT_MODULES
  published_at     TIMESTAMP
  expires_at       TIMESTAMP
  created_by       VARCHAR2(100)
  is_active        VARCHAR2(1) DEFAULT 'Y'
  -- audit columns
```

---

### 5.11 System Settings

```sql
DCT_SYSTEM_SETTINGS
  setting_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  setting_key      VARCHAR2(200) NOT NULL UNIQUE
  setting_value    VARCHAR2(4000)
  value_type       VARCHAR2(20) DEFAULT 'STRING'       -- STRING, NUMBER, BOOLEAN, JSON, DATE
  category         VARCHAR2(100)                       -- SECURITY, NOTIFICATIONS, UI, INTEGRATIONS
  description      VARCHAR2(1000)
  is_encrypted     VARCHAR2(1) DEFAULT 'N'
  is_system        VARCHAR2(1) DEFAULT 'N'             -- Cannot be deleted
  -- audit columns
```

---

### 5.12 Compatibility Views (Backward Compatibility)

To avoid breaking existing domain apps immediately, V2 provides compatibility views that simulate the legacy table structures:

```sql
-- Replaces dct_data_access_assignment
CREATE OR REPLACE VIEW dct_data_access_assignment AS
SELECT ur.user_role_id        AS assignment_id,
       u.username             AS user_id,
       u.person_id,
       'ROLE'                 AS entity_type_id,
       r.role_id              AS entity_id,
       r.role_code,
       ur.start_date,
       ur.end_date,
       CASE WHEN ur.is_active = 'Y'
             AND SYSDATE BETWEEN ur.start_date AND NVL(ur.end_date, SYSDATE + 1)
            THEN 'A' ELSE 'I' END AS status
FROM   dct_user_roles ur
JOIN   dct_users u  ON ur.user_id = u.user_id
JOIN   dct_roles r  ON ur.role_id = r.role_id;

-- Replaces roles (task management module roles)
CREATE OR REPLACE VIEW roles AS
SELECT r.role_id, r.role_code, r.role_name_en AS role_name,
       m.module_code, r.is_active
FROM   dct_roles r
LEFT JOIN dct_modules m ON r.module_id = m.module_id;
```

---

## 6. PL/SQL Package Design

### `DCT_AUTH` — Authentication & Authorization

```
DCT_AUTH.authenticate(p_username, p_password) RETURN BOOLEAN
DCT_AUTH.post_login(p_username)                -- Sets APEX items: USER_ROLES, USER_ORGS, IS_ADMIN
DCT_AUTH.has_permission(p_user, p_perm_code) RETURN BOOLEAN
DCT_AUTH.has_role(p_user, p_role_code)        RETURN BOOLEAN
DCT_AUTH.has_module_access(p_user, p_module)  RETURN BOOLEAN
DCT_AUTH.get_user_roles(p_user)               RETURN VARCHAR2  -- Comma-delimited
DCT_AUTH.get_effective_user(p_user)           RETURN VARCHAR2  -- Resolves delegations
```

### `DCT_USERS_API` — User Lifecycle

```
DCT_USERS_API.create_user(...)                RETURN NUMBER   -- user_id
DCT_USERS_API.update_user(p_user_id, ...)
DCT_USERS_API.deactivate_user(p_user_id, p_reason)
DCT_USERS_API.assign_role(p_user_id, p_role_id, p_start, p_end)
DCT_USERS_API.revoke_role(p_user_id, p_role_id)
DCT_USERS_API.sync_from_hr(p_employee_num)   -- Pull from dct_employees
```

### `DCT_APPROVAL` — Approval Engine

```
DCT_APPROVAL.submit(p_template_code, p_module, p_record_id, p_ref) RETURN NUMBER  -- instance_id
DCT_APPROVAL.approve(p_instance_id, p_user_id, p_comments)
DCT_APPROVAL.reject(p_instance_id, p_user_id, p_comments)
DCT_APPROVAL.return_for_revision(p_instance_id, p_user_id, p_comments)
DCT_APPROVAL.get_pending_actions(p_user_id)   RETURN SYS_REFCURSOR
DCT_APPROVAL.is_current_approver(p_instance_id, p_user_id) RETURN BOOLEAN
DCT_APPROVAL.cancel(p_instance_id, p_user_id)
```

### `DCT_AUDIT` — Audit Logging

```
DCT_AUDIT.log(p_action, p_object_type, p_object_id, p_old, p_new)
DCT_AUDIT.log_login(p_username, p_status)
DCT_AUDIT.log_access_denied(p_username, p_resource)
```

### `DCT_NOTIFY` — Notification Dispatch

```
DCT_NOTIFY.send(p_user_id, p_type, p_title, p_body, p_link)
DCT_NOTIFY.send_to_role(p_role_id, p_type, p_title, p_body)
DCT_NOTIFY.mark_read(p_notification_id, p_user_id)
DCT_NOTIFY.get_unread_count(p_user_id) RETURN NUMBER
```

---

## 7. APEX Application — Page Inventory

**App ID:** 200 (suggested)  
**Alias:** I-FINANCE-V2  
**Theme:** Universal Theme 42  
**Authentication:** Custom — calls `DCT_AUTH.authenticate`  
**Authorization Scheme:** `DCT_AUTH.has_role(:APP_USER, 'PLATFORM_USER')`

---

### Authentication Pages

| Page | Title | Notes |
|---|---|---|
| 9999 | Login | Branded login with quick-switch buttons for dev; OCI IAM redirect hook |
| 9998 | Logout | Clears session, logs audit |
| 9997 | Unauthorized | Shown on denied access |
| 9996 | Session Expired | |

---

### Home & Portal (All Authenticated Users)

| Page | Title | Key Components |
|---|---|---|
| 1 | Home — App Launcher | Cards grid from `DCT_MODULES` filtered by `DCT_AUTH.has_module_access`; announcement banner; unread notification badge |
| 2 | My Profile | Edit display name, photo, language pref, mobile; view active roles & org assignments |
| 3 | My Delegations | Create/view/cancel delegations; active and past delegation list |
| 4 | Notifications | Full notification list; mark read; filter by module/type |
| 5 | Announcements | System-wide announcements per audience |
| 6 | My Pending Approvals | Tasks waiting for current user's approval across all modules |

---

### User Management (Role: USER_ADMIN, SYS_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 10 | Users | Interactive Grid: search by name/email/org/status; bulk activate/deactivate; export |
| 11 | User Detail | Tabs: Profile \| Active Roles \| Org Assignments \| Data Access \| Delegations \| Audit History |
| 12 | Create / Edit User | Form with validation; sync-from-HR button |
| 13 | User Role Assignments | Assign/revoke roles with date range; org scope selector |
| 14 | User Organization Access | Assign user to one or more orgs; set primary |
| 15 | Bulk Import Users | CSV upload; field mapping; dry-run preview; import log |
| 16 | External Users | Separate list for `is_external = 'Y'`; manage freelancer/vendor access |

---

### Role & Permission Management (Role: SYS_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 20 | Roles | Interactive Grid; filter by type/module; active user count per role |
| 21 | Role Detail | Role info + permission list + assigned users count |
| 22 | Create / Edit Role | Form; role type; module scope |
| 23 | Role Permissions | Assign/remove permissions; grouped by module |
| 24 | Permissions Library | All permissions across all modules; filter by module/action |
| 25 | Role Users | Users assigned to a role; with date-range validity display |

---

### Organization Management (Role: ORG_ADMIN, SYS_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 30 | Organizations | Tree view (collapsible hierarchy) + flat grid toggle |
| 31 | Organization Detail | Org info; head user; member list; sub-orgs |
| 32 | Create / Edit Organization | Form; parent selector (tree-LOV); head user selector |
| 33 | Organization Members | Users assigned to this org; with assignment type and dates |

---

### Module Registry (Role: SYS_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 40 | Modules | Cards view + grid; active/inactive toggle; quick launch link |
| 41 | Module Detail | Module info; authorized roles; menu items |
| 42 | Create / Edit Module | Form; icon picker; category; APEX app ID; URL; display order |
| 43 | Module Role Access | Assign/remove roles that can access this module |
| 44 | Module Menu Items | Manage the sidebar/navigation items for this module |

---

### Approval Framework (Role: SYS_ADMIN, MODULE_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 50 | Approval Templates | List of all templates; module filter; active/inactive |
| 51 | Template Detail | Template info + steps list in sequence order |
| 52 | Create / Edit Template | Form; module; sequential vs parallel |
| 53 | Approval Steps | Ordered list for a template; drag-to-reorder; step type selector |
| 54 | Approval Step Detail | Step config: role-based / user-specific / org-head; escalation settings |
| 55 | Approval Monitor | Live view of all pending instances; filter by module/status/overdue |
| 56 | Approval Instance Detail | Full audit trail of one instance; current step; action history |

---

### Lookup Management (Role: SYS_ADMIN, MODULE_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 60 | Lookup Categories | List of all categories; system vs configurable badge |
| 61 | Lookup Values | Values for a selected category; drag-to-reorder; bilingual labels |
| 62 | Create / Edit Lookup Category | Form; module scope |
| 63 | Create / Edit Lookup Value | Form with EN + AR fields; default flag |

---

### System Configuration (Role: SYS_ADMIN)

| Page | Title | Key Components |
|---|---|---|
| 70 | System Settings | Key-value grid grouped by category; in-line edit; encrypted values masked |
| 71 | Notification Templates | Message templates for each notification type |
| 72 | Instance Settings | Per-APEX-instance overrides (logo, app name, theme color) |

---

### Audit & Compliance (Role: SYS_ADMIN, AUDITOR)

| Page | Title | Key Components |
|---|---|---|
| 80 | Audit Log | Searchable log; filter by user/action/date/module; export to CSV |
| 81 | Login History | Login/logout events; IP address; success/failure |
| 82 | Role Change History | History of all role assign/revoke events across all users |
| 83 | Active Sessions | Live sessions; force-logout action |
| 84 | Access Denied Report | Failed permission checks; potential security alerts |

---

### Task Management Module (Role: TASK_DIRECTOR, TASK_MANAGER, TASK_VIEWER)

| Page | Title | Notes |
|---|---|---|
| 90 | Task Dashboard — Director | KPI cards, 6-week trend, section breakdown (migrated from director-dashboard.html) |
| 91 | Task Dashboard — Manager | My tasks this week, status board (migrated from manager-dashboard.html) |
| 92 | Task Detail | Create/edit task form; attachments; notes |
| 93 | Week Navigation | Browse historical weeks |
| 94 | Task Reports | Completion rate by section, by category, trend charts |

---

## 8. Security Model

### Role Hierarchy

```
SYS_ADMIN
├── Full access to all V2 admin pages
├── Can assign any role
└── Cannot be locked out (minimum 1 active SYS_ADMIN enforced)

USER_ADMIN
├── User Management pages (10–16)
├── View roles (not edit)
└── Cannot elevate to SYS_ADMIN

ORG_ADMIN
├── Org Management pages (30–33)
└── Scoped to their own org subtree only

MODULE_ADMIN
├── Manage lookups (60–63) for their module
├── Approval template config (50–56) for their module
└── Cannot access user management

AUDITOR
├── Read-only access to audit pages (80–84)
└── No create/edit capabilities

PLATFORM_USER
└── All authenticated users (base role)
   ├── Home / App Launcher
   ├── My Profile
   ├── My Notifications
   └── My Pending Approvals

TASK_DIRECTOR   → DCT task management director features
TASK_MANAGER    → DCT task management manager features
TASK_VIEWER     → Read-only task access
```

### Permission Checks Flow

```
User logs in
  → DCT_AUTH.post_login runs
  → Loads into APEX items:
      :USER_ID, :USER_DISPLAY_NAME, :USER_ROLES (comma list),
      :USER_PERMISSIONS (JSON), :USER_ORG_IDS, :IS_ADMIN,
      :ACTIVE_DELEGATION (username if delegating for someone)
  → Menu items rendered only if DCT_AUTH.has_permission returns TRUE
  → Each page has APEX Authorization Scheme calling DCT_AUTH
  → Data queries auto-filter by org scope if user is ORG_ADMIN
```

### Row-Level Security
- Users with `ORG_ADMIN` role see only data belonging to their org subtree.
- Implemented via `DCT_AUTH.get_user_org_ids(:APP_USER)` used in WHERE clauses.
- Domain apps call the same function for their own data filtering.

---

## 9. UI/UX Design Principles

### Visual Design
- **Theme:** Oracle APEX Universal Theme 42 — Redwood style
- **Primary color:** `#003366` (deep navy) — Finance authority
- **Accent color:** `#0076CE` (corporate blue)
- **Success/Approved:** `#3DAA6D`
- **Warning/Pending:** `#F2A900`
- **Danger/Rejected:** `#C74634`
- **Cards:** Rounded corners (8px), subtle shadow, hover elevation effect
- **Font:** Inter (consistent with existing apps)

### App Launcher (Home Page)
- Module cards organized in category rows (HR, Budget, Payments, CWIP, SCM)
- Card shows: icon, module name, short description, unread count badge if applicable
- Categories collapsed/expanded per user preference
- Quick-action strip at top: My Pending Approvals, Notifications, My Profile
- Announcement banner pinned if any active CRITICAL announcements

### Navigation
- Top navigation bar: Logo | Search | Notifications bell | User avatar → dropdown
- Left sidebar (collapsed by default on small screens): Admin sections
- Breadcrumb on every page beyond depth 1
- "Back to Launcher" persistent button in sidebar

### Bilingual (Arabic / English)
- All labels stored in `_en` / `_ar` columns
- Language toggled per user in `DCT_USER_PREFERENCES`
- RTL layout applied when `AR` selected (APEX built-in RTL support)
- Date/number format adjusted per locale

### Responsiveness
- Desktop (≥1200px): Full sidebar + content area
- Tablet (768–1199px): Collapsed sidebar with icon-only mode
- Mobile (< 768px): App launcher only (admin pages require desktop)

---

## 10. Integration with Domain Apps

### How a Domain App Uses V2

1. **Authentication redirect:** Domain app uses "Redirect to V2 Login" as its auth scheme. V2 issues an APEX session token that domain apps validate.
2. **Permission check:** Domain app pages call `DCT_AUTH.has_permission(:APP_USER, 'MODULE.ACTION')` as their authorization scheme.
3. **User lookup:** Domain apps call `DCT_USERS_API.get_user_details(:APP_USER)` instead of querying `dct_employees` directly.
4. **Approval submission:** Domain apps call `DCT_APPROVAL.submit('TEMPLATE_CODE', 'MODULE', :RECORD_ID, 'Ref Text')` — no local approval tables needed.
5. **Notifications:** Domain apps call `DCT_NOTIFY.send(...)` — no local notification logic.
6. **Lookups:** Domain apps query `DCT_LOOKUP_VALUES` via a standard LOV query pattern.

### Migration Path for Existing Apps

| Phase | Action |
|---|---|
| 1 — Foundation | Build V2 schema + packages; deploy compatibility views |
| 2 — Pilot | Migrate f100 + f910 config into V2; test auth |
| 3 — Domain Migration | Update each domain app auth scheme to use V2 |
| 4 — Approval Migration | Replace domain `_approval_history` tables with `DCT_APPROVAL_*` calls |
| 5 — Deprecation | Remove compatibility views; retire f100, f910, f9900 |

---

## 11. Proposed App Launcher — Module Cards

Below is how V2's home page would organize the 31 apps + task management:

### Category: Core Platform
| Module | Icon | App ID |
|---|---|---|
| Task Management | fa-tasks | V2 built-in |

### Category: HR & Employee
| Module | Icon | App ID |
|---|---|---|
| HR Organizations | fa-sitemap | f102 |
| Employee Self Service | fa-user-circle | f106 |
| Duty Hub | fa-plane | f810 |
| HR Self Service | fa-id-badge | f901 |
| Petty Cash | fa-money-bill-wave | f101 |
| Freelancers | fa-briefcase | f805 |

### Category: Budget & Finance
| Module | Icon | App ID |
|---|---|---|
| Budget Allocation | fa-chart-pie | f110 |
| Budget Planning | fa-chart-line | f115 |
| Fund Management | fa-exchange-alt | f105 |
| Budget Transfer | fa-arrows-alt-h | f903 |

### Category: Payments & Procurement
| Module | Icon | App ID |
|---|---|---|
| Payment Requests | fa-file-invoice-dollar | f113 |
| Manual PR | fa-shopping-cart | f108 |
| Manager Checks | fa-check-square | f114 |
| Bank Guarantee | fa-university | f127 |
| Credit Cards | fa-credit-card | f911 |
| Prepaid Cards | fa-id-card | f104 |
| Accounts Receivable | fa-hand-holding-usd | f118 |

### Category: CWIP
| Module | Icon | App ID |
|---|---|---|
| CWIP Payments Management | fa-hard-hat | f130 |
| CWIP Payment (External) | fa-external-link-alt | f109 |
| CWIP Change Management | fa-edit | f142 |

### Category: SCM & Procurement
| Module | Icon | App ID |
|---|---|---|
| Demand Planning | fa-boxes | f124 |
| Single Source (SMD) | fa-file-contract | f166 |

### Category: Admin & Config (SYS_ADMIN only)
| Module | Icon | App ID |
|---|---|---|
| User Management | fa-users-cog | V2 built-in |
| Role Management | fa-shield-alt | V2 built-in |
| Approval Framework | fa-project-diagram | V2 built-in |
| Lookup Management | fa-list | V2 built-in |
| Audit Log | fa-clipboard-list | V2 built-in |
| System Settings | fa-cogs | V2 built-in |

---

## 12. Architectural Decisions (Approved 2026-05-09)

| # | Question | Decision |
|---|---|---|
| 1 | **Authentication method** | Custom PL/SQL now; architecture must support adding multiple schemes (OCI IAM, SAML) later without restructuring |
| 2 | **App ID** | **200** |
| 3 | **Schema owner** | **Same PROD schema** — all DCT_* tables created alongside existing tables |
| 4 | **Domain app migration** | **Phased** — auth first, then approvals, then lookups; domain apps keep working throughout |
| 5 | **Bilingual (AR/EN)** | **Phase 1** — all labels bilingual from day one; `_en`/`_ar` columns on all relevant tables; RTL support required |
| 6 | **Task Management** | **Separate APEX app** (Option B) — Task Management remains its own application, uses V2 for authentication only |
| 7 | **External users** | **Same `DCT_USERS` table** with `is_external = 'Y'` flag (Option A) |
| 8 | **Approval engine** | **Build now** — central engine in place for all new domain apps from Sprint 1; existing apps migrate per phase plan |

---

## 13. Recommended Build Sequence

If you approve this proposal, the suggested build order is:

```
Sprint 1 — Foundation (Schema + Auth)
  ├── Create all DCT_* tables
  ├── Create compatibility views
  ├── Build DCT_AUTH package
  ├── APEX app shell (App 200) + login page
  └── Home / App Launcher with static module cards

Sprint 2 — User & Role Management
  ├── DCT_USERS_API package
  ├── User list, detail, create/edit pages
  ├── Role list, detail, permission assignment pages
  └── User-role assignment with date ranges

Sprint 3 — Organization + Module Registry
  ├── Org hierarchy tree + management pages
  ├── Module registry + role access config
  └── Dynamic App Launcher pulling from DCT_MODULES

Sprint 4 — Approval Framework
  ├── DCT_APPROVAL package
  ├── Template + step management pages
  ├── Approval monitor + instance detail
  └── My Pending Approvals page

Sprint 5 — Audit, Lookup, Notifications
  ├── DCT_AUDIT auto-trigger setup
  ├── Audit log + login history pages
  ├── Lookup category + values management
  └── DCT_NOTIFY + notification bell

Sprint 6 — Task Management Integration
  ├── Migrate DCT task management pages into App 200
  ├── Wire to DCT_AUTH roles (TASK_DIRECTOR, TASK_MANAGER)
  └── Task reports + trend charts

Sprint 7 — Domain App Auth Migration (per domain)
  └── Update each domain app's auth scheme to use V2
```

---

*Document version: 1.0 — Pending approval*
