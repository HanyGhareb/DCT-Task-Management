# i-Finance V2 — APEX App 200 Configuration Guide

## Sprint 1: Create the APEX Application Shell

---

## 1. Create the Application

In APEX App Builder → Create Application:

| Field | Value |
|---|---|
| Name | i-Finance V2 |
| Application ID | 200 |
| Alias | I-FINANCE-V2 |
| Theme | Universal Theme (42) — Redwood Light |
| Authentication | Custom (see Section 2) |

---

## 2. Authentication Scheme

**Shared Components → Authentication Schemes → Create**

| Field | Value |
|---|---|
| Name | IFW Custom Auth |
| Scheme Type | Custom |
| Authentication Function Name | `ifw_auth.authenticate` |
| Post-Authentication Procedure | `ifw_auth.post_login` |
| Invalid Session Target | Page 9999 (Login) |
| Session Not Valid Message | Your session has expired. Please log in again. |
| Logout URL | apex/f?p=200:9998:&APP_SESSION. |

---

## 3. Application Items (Session State)

**Shared Components → Application Items → Create** — one per row:

| Item Name | Session State Protection | Scope |
|---|---|---|
| USER_ID | Checksum Required | App |
| USER_DISPLAY_NAME | Unrestricted | App |
| USER_DISPLAY_NAME_AR | Unrestricted | App |
| USER_EMAIL | Unrestricted | App |
| USER_LANGUAGE | Unrestricted | App |
| USER_COLOR | Unrestricted | App |
| USER_PHOTO_URL | Unrestricted | App |
| USER_ORG_ID | Checksum Required | App |
| USER_ORG_IDS | Checksum Required | App |
| USER_ROLES | Checksum Required | App |
| IS_ADMIN | Checksum Required | App |
| IS_EXTERNAL | Checksum Required | App |
| UNREAD_NOTIFICATIONS | Unrestricted | App |
| ACTIVE_DELEGATION_FOR | Unrestricted | App |

---

## 4. Authorization Schemes

**Shared Components → Authorization Schemes → Create** — one per scheme:

### 4.1 Platform User (base — all logged-in users)
| Field | Value |
|---|---|
| Name | Is Platform User |
| Scheme Type | PL/SQL Function returning Boolean |
| PL/SQL | `RETURN ifw_auth.has_role(:APP_USER, 'PLATFORM_USER');` |
| Error Message | You do not have access to this application. |
| Evaluate At | Once per Session |

### 4.2 System Admin
| Field | Value |
|---|---|
| Name | Is SYS_ADMIN |
| PL/SQL | `RETURN ifw_auth.has_role(:APP_USER, 'SYS_ADMIN');` |
| Evaluate At | Once per Session |

### 4.3 User Admin
| Field | Value |
|---|---|
| Name | Is USER_ADMIN |
| PL/SQL | `RETURN ifw_auth.has_role(:APP_USER, 'USER_ADMIN') OR ifw_auth.has_role(:APP_USER, 'SYS_ADMIN');` |
| Evaluate At | Once per Session |

### 4.4 Can Manage Users (permission-based)
| Field | Value |
|---|---|
| Name | Can Manage Users |
| PL/SQL | `RETURN ifw_auth.has_permission(:APP_USER, 'USERS.EDIT');` |
| Evaluate At | Always (no cache) |

### 4.5 Auditor
| Field | Value |
|---|---|
| Name | Is Auditor |
| PL/SQL | `RETURN ifw_auth.has_role(:APP_USER, 'AUDITOR') OR ifw_auth.has_role(:APP_USER, 'SYS_ADMIN');` |
| Evaluate At | Once per Session |

### 4.6 Task Director
| Field | Value |
|---|---|
| Name | Is Task Director |
| PL/SQL | `RETURN ifw_auth.has_role(:APP_USER, 'TASK_DIRECTOR');` |
| Evaluate At | Once per Session |

---

## 5. Application Processes

**Shared Components → Application Processes → Create**

### 5.1 Touch Session (every page)
| Field | Value |
|---|---|
| Name | Touch Session |
| Point | On Load: Before Header |
| Condition | Request is NOT `LOGOUT` |
| PL/SQL | `ifw_auth.touch_session(V('APP_SESSION'));` |

### 5.2 Refresh Notification Count (every page)
| Field | Value |
|---|---|
| Name | Refresh Notification Count |
| Point | On Load: Before Header |
| PL/SQL | `APEX_UTIL.SET_SESSION_STATE('UNREAD_NOTIFICATIONS', ifw_notify.get_unread_count(TO_NUMBER(:USER_ID)));` |

---

## 6. Navigation Menu

**Shared Components → Navigation Menu → Desktop Navigation Menu**

Add entries in this order:

| Label (EN) | Target Page | Auth Scheme | Icon |
|---|---|---|---|
| Home | 1 | Is Platform User | fa-home |
| **User Management** | — | Is USER_ADMIN | fa-users-cog |
| → Users | 10 | Is USER_ADMIN | fa-user |
| → Roles | 20 | Is SYS_ADMIN | fa-shield-alt |
| → Permissions | 24 | Is SYS_ADMIN | fa-key |
| **Organisation** | — | Is ORG_ADMIN | fa-sitemap |
| → Org Hierarchy | 30 | Is ORG_ADMIN | fa-project-diagram |
| **Modules** | — | Is SYS_ADMIN | fa-th-large |
| → Module Registry | 40 | Is SYS_ADMIN | fa-th-large |
| **Approvals** | — | Is SYS_ADMIN | fa-check-circle |
| → Templates | 50 | Is SYS_ADMIN | fa-list-alt |
| → Monitor | 55 | Is SYS_ADMIN | fa-eye |
| **Configuration** | — | Is SYS_ADMIN | fa-cogs |
| → Lookups | 60 | Is MODULE_ADMIN | fa-list |
| → System Settings | 70 | Is SYS_ADMIN | fa-sliders-h |
| **Audit** | — | Is Auditor | fa-clipboard-list |
| → Audit Log | 80 | Is Auditor | fa-history |
| → Login History | 81 | Is Auditor | fa-sign-in-alt |
| → Active Sessions | 83 | Is SYS_ADMIN | fa-desktop |

---

## 7. Page List — Sprint 1 to Create

| Page | Title | Template | Auth Scheme |
|---|---|---|---|
| 1 | Home — App Launcher | Minimal (No Nav) | Is Platform User |
| 2 | My Profile | Standard | Is Platform User |
| 3 | My Delegations | Standard | Is Platform User |
| 4 | Notifications | Standard | Is Platform User |
| 6 | My Pending Approvals | Standard | Is Platform User |
| 9997 | Unauthorized | Minimal | Public |
| 9998 | Logout | Minimal | Public |
| 9999 | Login | Minimal | Public |

---

## 8. Login Page (9999) Setup

- **Page Template:** Minimal (No Navigation)
- **Authentication:** Set page to Public (no auth required)
- **Region:** HTML region with login form
  - Username item: `P9999_USERNAME` (Text Field)
  - Password item: `P9999_PASSWORD` (Password)
  - Login button: submits page
- **Process — Authenticate:**
  - Type: Login
  - Username: `P9999_USERNAME`
  - Password: `P9999_PASSWORD`
  - Authentication Scheme: IFW Custom Auth

**Quick-login buttons** (for development only — remove in production):

Add buttons that set username/password and submit. Use a conditional display on system setting `DEFAULT_AUTH_METHOD = 'DB'`.

---

## 9. Home Page (Page 1) — App Launcher

**Region: Announcement Banner**
```sql
SELECT title_en, body_en, severity
FROM   ifw_announcements
WHERE  is_active = 'Y'
  AND  (target_audience = 'ALL'
        OR (target_audience = 'ROLE'
            AND target_role_id IN (
                SELECT role_id FROM v_ifw_user_active_roles
                WHERE UPPER(username) = UPPER(:APP_USER)
            ))
  )
  AND  (published_at IS NULL OR published_at <= SYSTIMESTAMP)
  AND  (expires_at   IS NULL OR expires_at   > SYSTIMESTAMP)
ORDER  BY severity DESC, published_at DESC
FETCH FIRST 3 ROWS ONLY
```

**Region: Module Cards (per category)**

Use this query as the data source for a Cards region, one per category:

```sql
SELECT module_id,
       module_name_en,
       module_name_ar,
       description_en,
       icon_class,
       icon_color,
       bg_color,
       CASE target_type
           WHEN 'APEX_APP' THEN 'f?p=' || apex_app_id || ':' || apex_page_id || ':' || :APP_SESSION
           ELSE app_url
       END AS launch_url,
       is_new_tab,
       category,
       display_order
FROM   v_ifw_module_access
WHERE  UPPER(username) = UPPER(:APP_USER)
  AND  category        = :BIND_CATEGORY
ORDER  BY display_order
```

Render one Cards region per category, arranged in a responsive CSS Grid layout.

---

## 10. Substitution Strings

**Shared Components → Substitution Strings:**

| Name | Value |
|---|---|
| APP_NAME | i-Finance V2 |
| APP_NAME_AR | آي فاينانس V2 |
| SUPPORT_EMAIL | _(from IFW_SYSTEM_SETTINGS)_ |

---

## 11. Global Page (Page 0)

Add these to the Global Page so they render on every page:

- **Notification Bell** — link to Page 4, badge showing `&UNREAD_NOTIFICATIONS.`
- **User Avatar** — circle with `&USER_COLOR.` background, initials from `&USER_DISPLAY_NAME.`
- **Delegation Banner** — conditional region shown when `&ACTIVE_DELEGATION_FOR.` is not null:
  > "You are currently acting on behalf of `&ACTIVE_DELEGATION_FOR.`"

---

## 12. Logout Page (9998)

**Process on Load:**
```plsql
BEGIN
    ifw_auth.close_session(:APP_SESSION);
    APEX_AUTHENTICATION.LOGOUT(
        p_next_app_id  => 200,
        p_next_page_id => 9999
    );
END;
```

---

## Done — Sprint 1 Checklist

- [ ] Run `install.sql` against PROD schema
- [ ] Verify all 24 IFW_* tables created
- [ ] Verify views compile without errors (`SHOW ERRORS`)
- [ ] Verify IFW_AUTH package compiles (`SHOW ERRORS PACKAGE BODY IFW_AUTH`)
- [ ] Verify seed data: 26 modules, 9 roles, 22 permissions
- [ ] Create APEX App 200 with settings above
- [ ] Login with ADMIN / iFinance@2026
- [ ] Change admin password immediately
- [ ] Verify App Launcher shows all modules for ADMIN user
- [ ] Verify module cards filtered correctly for a PLATFORM_USER account
