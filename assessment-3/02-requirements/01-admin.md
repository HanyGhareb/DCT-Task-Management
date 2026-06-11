# Admin / Platform Core (App 200) — Requirements & Feature Assessment

**Role in the platform:** Central identity provider and platform backbone. Every other module authenticates through App 200 and consumes its roles, permissions, organizations, lookups, approval engine, notifications, and audit log.

**Primary sources:** `docs/_legacy/ifinance-v2-proposal.md` (approved 2026-05-09), `docs/APEX_SETUP.md`, `final apps/SHARED_JET_ARCHITECTURE.md`, `final apps/SHARED_APEX_ARCHITECTURE.md`, `db/v2/` (25 core tables + packages), `final apps/Admin/Jet/` (18 views, live ORDS).

---

## 1. Purpose

> "Who can log in, what they can see, and how approvals are routed — for every app in the platform." (`docs/_legacy/ifinance-v2-proposal.md`)

App 200 owns: authentication, users, roles/permissions, org hierarchy, module registry, the generic approval engine, lookups, delegations, announcements/notifications, system settings, and audit.

## 2. Actors

| Actor | Description |
|---|---|
| SYS_ADMIN | Full platform administration |
| USER_ADMIN | User lifecycle management only |
| Auditor | Read-only access to audit log and approval history |
| Module admins (DT_ADMIN, PC_ADMIN, …) | Manage their module's config through App 200's shared components |
| Every platform user | Login, profile, notifications, delegation of own authority |
| External users | Same `dct_users` table with `is_external = 'Y'` (decision locked 2026-05-09) |

## 3. Functional requirements

### 3.1 Authentication & session (documented)
- Custom PL/SQL authentication (`DCT_AUTH`, `db/v2/03_dct_auth_pkg.sql`): SHA-512 password hashing, `auth_method` per user (DB | LDAP | OCI_IAM | SAML — only DB implemented).
- Post-login initialization loads roles/permissions/orgs into APEX app items (`SET_APP_ITEMS`, On New Session — `final apps/SHARED_APEX_ARCHITECTURE.md`).
- JET session contract: Admin JET is the **only** writer of the `ifinance_jet_session` localStorage key; module apps read it and redirect to `../Admin/Jet/index.html` when absent (`final apps/SHARED_JET_ARCHITECTURE.md`).
- ORDS Bearer-token sessions validated by `DCT_REST.VALIDATE_SESSION` against `dct_sessions` (`db/v2/11_dct_ords.sql`); ADB passes the header under CGI key `AUTHORIZATION` (no `HTTP_` prefix) — fallback already implemented.

### 3.2 User management (documented)
- Full CRUD on `dct_users` (30 cols): bilingual display names, org assignment, avatar color, employee link via `person_id → dct_employees`.
- Multi-org membership with type (PRIMARY | SECONDARY | ACTING) and date ranges (`dct_user_orgs`).
- User preferences as key-value store (`dct_user_preferences`).
- JET views: `users.html`, `userEdit.html`, `profile.html`.

### 3.3 Roles & permissions (documented)
- Role types SYSTEM | MODULE | DATA; `is_system_role` blocks deletion (`dct_roles`).
- Fine-grained permissions with action types VIEW…ADMIN (`dct_permissions`), role-permission matrix (`dct_role_permissions`).
- Time-bounded, org-scoped user-role grants (`dct_user_roles` — note: date column is `end_date`, not `valid_to`).
- Module access control with FULL | READ_ONLY levels (`dct_module_roles`).
- JET: `roles.html`, `permissions.html`, `roleEdit.html` — the Vault dark-theme design system; permission matrix returns `{ roles, matrix }` shape (`roleService.getPermissionMatrix()`).

### 3.4 Organization management (documented)
- Org hierarchy DIVISION | SECTION | UNIT | DEPARTMENT, adjacency list (`parent_org_id`), `head_user_id` (`dct_organizations`, 43 cols).
- JET: `orgHierarchy.html` (tree view).

### 3.5 Module registry (documented)
- Registry of all APEX apps + external modules with `apex_app_id`, URL, category (`dct_modules`, 28 cols); drives the dynamic app launcher.
- JET: `modules.html`.

### 3.6 Approval framework (documented — **shared engine for all modules**)
- Templates per (module, request_type), sequential or parallel, `auto_approve_days` (`dct_approval_templates`).
- Steps: ROLE_BASED | USER_SPECIFIC | ORG_HEAD, escalation after N days to an escalation role, conditional firing (ALWAYS | AMOUNT | TYPE_FILTER | COMBINED | CUSTOM PL/SQL) (`dct_approval_steps`, 30 cols).
- Instances track `current_step_seq` and `overall_status`; actions are an append-only audit trail with delegation support (`dct_approval_instances`, `dct_approval_actions`).
- JET: `approvalTemplates.html`, `approvalMonitor.html`, `pendingApprovals.html`.

### 3.7 Delegation (documented; **UI gap**)
- `dct_delegations`: scope ALL_ROLES | SPECIFIC_ROLE | MODULE, date-bounded, delegator ≠ delegate.
- **Gap:** no JET view exists for managing delegations; `dct_auth.get_effective_user()` is not consistently applied inside approval-step resolution (see DB review §6.10).

### 3.8 Lookups, settings, announcements, notifications, audit (documented)
- Lookup categories/values with `is_system` protection (`dct_lookup_categories/values` — columns `value_code` / `value_name_en` / `display_order`). JET: `lookups.html`.
- System settings (typed values, `is_encrypted`) and per-module settings with `effective_date` (`dct_system_settings`, `dct_module_settings`). JET: `systemSettings.html`.
- Announcements with severity and target audience (`dct_announcements`) — **no JET view yet**.
- Notification inbox with types, read state, expiry; bilingual title/body (`dct_notifications`, `DCT_NOTIFY`). JET: `notifications.html`.
- Month-partitioned audit log with JSON old/new values (`dct_audit_log`). JET: `auditLog.html`.

### 3.9 Inferred requirements (implemented but not written down)
- Appearance/theming per user: `appearance.html` + 3 themes in `final apps/Admin/Jet/css/themes.css` (Corporate, Redwood, Midnight) via `data-theme` attribute.
- Avatar color assignment and initials computation (session contract `color`/`initials` fields).
- Session "touch" semantics: every ORDS call refreshes `last_activity_at` — implies an inactivity-timeout requirement that is **nowhere stated**. Recommend documenting the intended timeout value as a system setting.

## 4. Current status (verified 2026-06-11)

| Layer | Status | Evidence |
|---|---|---|
| DB | ✅ 25 core tables + 11 master-data tables | `db/v2/01_dct_ddl.sql`, `db/v2/12_dct_master_data.sql` |
| Packages | ✅ DCT_AUTH, DCT_REST, DCT_NOTIFY, DCT_USERS_API | `db/v2/03,06,07,11_*.sql` |
| ORDS | ✅ Live at `/ords/admin/dct/` | `db/v2/11_dct_ords.sql` |
| JET SPA | ✅ 18 views, all 8 services ORDS-only | `final apps/Admin/Jet/` |
| APEX | Partial — Users/Roles pages built | `CLAUDE.md` module table |

## 5. Gaps & recommendations

| # | Gap | Recommendation | Effort |
|---|---|---|---|
| A1 | No delegation management UI | Add `delegations.html` view + ORDS endpoints; reuse Vault list patterns | S |
| A2 | No announcements UI | Add `announcements.html` (create/target/expire) | S |
| A3 | Approval escalation designed but no scheduler job wired | `JOB_DCT_APPROVAL_ESCALATE` daily job reading `escalation_days` | M |
| A4 | Auto-approve (`auto_approve_days`) not enforced anywhere | Same job as A3 | — |
| A5 | OCI IAM / SAML auth methods are enum values only | Phase decision; keep custom auth until module rollout completes | L |
| A6 | Session timeout undefined | Add `SESSION_TIMEOUT_MINUTES` system setting + purge job on `dct_sessions` | S |
| A7 | Unified cross-module approvals inbox missing (each module shows only its own) | See `05-advanced-features.md` §1 | M |
