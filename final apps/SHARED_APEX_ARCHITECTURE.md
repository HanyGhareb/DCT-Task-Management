# i-Finance Shared APEX Architecture
**Applies to:** All module apps (App 201, 202, 203 …) | **Authority app:** App 200 | **Date:** 2026-05-13

---

## Principle

Every module application in the i-Finance platform **shares** the following with App 200:

| Component | Rule |
|---|---|
| Authentication Scheme | Subscribe to App 200's `DCT Auth` scheme |
| Standard Application Items | Identical names, types, and protection levels in every app |
| SET_APP_ITEMS Process | Same process body calling DCT_AUTH in every app |
| Common LOVs | Subscribe from App 200 — never redefine |
| Module-specific LOVs | Define locally in the module app only |

This ensures:
- Single point of maintenance for authentication logic
- Consistent session state across all apps
- Uniform user experience (same nav bar, same user context)
- Changes to DCT_AUTH or common LOVs propagate by refreshing subscriptions

---

## 1. Authentication Scheme

### Rule
Every new app subscribes to App 200's `DCT Auth` authentication scheme.

### How to set up in APEX Builder
1. Create a new app (e.g. App 201)
2. Go to **Shared Components → Authentication Schemes → Create**
3. Choose: **Based on a pre-configured scheme** → select `Subscribe to Authentication Scheme from another Application`
4. Select: **Application 200**, Scheme: **DCT Auth**
5. Set as **Current** scheme

### What this means
- The auth logic (DCT_AUTH.AUTHENTICATE, POST_LOGIN) lives in App 200 only
- Any change to the auth scheme in App 200 is subscribed to by all module apps
- Login page (Page 9999) in each module app still exists for direct access, but SSO via App 200 is the primary path

---

## 2. Standard Application Items

Every module app must define these application items with **identical names and protection levels**.
They are populated by the `SET_APP_ITEMS` process (see Section 3).

| Item Name | Type | Session State Protection |
|---|---|---|
| `APP_USER_ID` | Number | Restricted — May not be set from browser |
| `APP_EMP_NUM` | Varchar2 | Restricted — May not be set from browser |
| `APP_EMP_NAME` | Varchar2 | Unrestricted |
| `APP_ORG_ID` | Number | Restricted — May not be set from browser |
| `APP_IS_ADMIN` | Varchar2(1) | Restricted — May not be set from browser |
| `APP_IS_MANAGER` | Varchar2(1) | Restricted — May not be set from browser |
| `APP_PENDING_APPROVAL_COUNT` | Number | Unrestricted |

> **Module-specific items** (e.g. `APP_IS_PC_ADMIN`, `APP_ACTIVE_PC_ID`) are defined additionally in each module app alongside the standard set above.

### How to create in APEX Builder
**Shared Components → Application Items → Create** (one per item above).

---

## 3. SET_APP_ITEMS Application Process

Every module app must include this process to populate the standard app items.

### Process Properties
| Property | Value |
|---|---|
| Name | `SET_APP_ITEMS` |
| Sequence | 10 |
| Process Point | On New Session |
| Condition | None (always fires) |

### Process Source (standard section — same in every app)
```sql
DECLARE
  v_user_id  NUMBER;
  v_emp_num  VARCHAR2(50);
  v_emp_name VARCHAR2(200);
  v_org_id   NUMBER;
BEGIN
  SELECT u.user_id, u.employee_number, u.display_name, u.org_id
  INTO   v_user_id, v_emp_num, v_emp_name, v_org_id
  FROM   prod.dct_users u
  WHERE  UPPER(u.username) = UPPER(:APP_USER);

  :APP_USER_ID  := v_user_id;
  :APP_EMP_NUM  := v_emp_num;
  :APP_EMP_NAME := v_emp_name;
  :APP_ORG_ID   := v_org_id;

  :APP_IS_ADMIN := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN   prod.dct_roles r ON r.role_id = ur.role_id
      WHERE  ur.user_id  = v_user_id
      AND    r.role_code = 'ADMIN'
      AND    ur.is_active = 'Y'
      AND    (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  :APP_IS_MANAGER := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN   prod.dct_roles r ON r.role_id = ur.role_id
      WHERE  ur.user_id  = v_user_id
      AND    r.role_code = 'MANAGER'
      AND    ur.is_active = 'Y'
      AND    (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  SELECT COUNT(DISTINCT ai.instance_id)
  INTO   :APP_PENDING_APPROVAL_COUNT
  FROM   prod.dct_approval_instances ai
  JOIN   prod.dct_approval_steps     s  ON s.template_id = ai.template_id
                                       AND s.step_seq    = ai.current_step_seq
  JOIN   prod.dct_user_roles         ur ON ur.role_id    = s.required_role_id
                                       AND ur.user_id    = v_user_id
                                       AND ur.is_active  = 'Y'
  WHERE  ai.overall_status = 'PENDING';

  -- *** MODULE-SPECIFIC ITEMS GO HERE ***
  -- Each module app extends this block with its own role flags and context items.
  -- Example for Petty Cash (App 201):
  --   :APP_IS_PC_ADMIN := CASE WHEN ... THEN 'Y' ELSE 'N' END;
  --   SELECT COUNT(*), MAX(pc_id) INTO :APP_ACTIVE_PC_COUNT, :APP_ACTIVE_PC_ID ...

EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END;
```

---

## 4. Common LOVs (Subscribe from App 200)

The following LOVs are defined in App 200 and must be **subscribed to** in every module app — never redefined locally.

| LOV Name | Description |
|---|---|
| `LOV_DCT_EMPLOYEES` | All active employees (display_name / user_id) |
| `LOV_DCT_EMPLOYEES_BY_ORG` | Employees filtered by org (cascade) |
| `LOV_DCT_ORGANIZATIONS` | All active organizations |
| `LOV_DCT_ROLES` | All active roles |
| `LOV_YES_NO` | Y → Yes / N → No |
| `LOV_ACTIVE_INACTIVE` | Y → Active / N → Inactive |
| `LOV_MONTHS` | 1–12 with month names |
| `LOV_APPROVAL_STATUS` | PENDING / APPROVED / REJECTED / CANCELLED |
| `LOV_REQUEST_STATUSES` | DRAFT / SUBMITTED / PENDING_APPROVAL / APPROVED / REJECTED / CANCELLED |

### How to subscribe in APEX Builder
1. **Shared Components → List of Values → Create**
2. Select **From Existing LOV in another Application**
3. Choose **Application 200**, select the LOV
4. Check **Subscribe to LOV** → this keeps it in sync with App 200

---

## 5. Module-Specific LOVs (Local — not shared)

LOVs specific to a module are defined locally in that app only and are **not** shared back to App 200.

**Examples:**
- Petty Cash (App 201): `LOV_GL_ENTITY_CODE`, `LOV_GL_APPROPRIATION` … `LOV_GL_FUTURE2`, `LOV_PROJECT_NUMBER`, `LOV_TASK_NUMBER`, `LOV_EXPENDITURE_TYPE`
- Future modules: their own domain-specific lookup lists

---

## 6. Standard Authorization Schemes (Subscribe from App 200)

The following schemes are defined in App 200 and subscribed in all module apps:

| Scheme Name | Expression |
|---|---|
| `IS_AUTHENTICATED` | `RETURN TRUE;` (APEX built-in) |
| `IS_ADMIN` | `RETURN :APP_IS_ADMIN = 'Y';` |
| `IS_MANAGER` | `RETURN :APP_IS_MANAGER = 'Y';` |
| `IS_MANAGER_OR_ADMIN` | `RETURN :APP_IS_MANAGER = 'Y' OR :APP_IS_ADMIN = 'Y';` |

Module-specific schemes (e.g. `IS_PC_ADMIN`, `IS_OWN_PC`) are defined locally in the module app.

---

## 7. Checklist — Every New Module App

Use this checklist when starting any new module app:

- [ ] App created with correct ID, schema = PROD, Theme = Universal Theme 42
- [ ] Authentication: subscribed to App 200 `DCT Auth` scheme
- [ ] Standard Application Items created (APP_USER_ID … APP_PENDING_APPROVAL_COUNT)
- [ ] Module-specific Application Items created
- [ ] `SET_APP_ITEMS` process created — standard block + module extension
- [ ] Common LOVs subscribed from App 200 (8 LOVs)
- [ ] Standard Authorization Schemes subscribed from App 200
- [ ] Module-specific Authorization Schemes created locally
- [ ] Oracle Fusion CSS applied (copy from App 200 Shared Components)
- [ ] Navigation menu configured
- [ ] App alias set (e.g. `PC`, `HR`, `BUDGET`)

---

## 8. Maintaining Subscriptions

When App 200's shared components change (auth scheme updated, LOV query changed, etc.):

1. Open each subscribed module app in APEX Builder
2. **Shared Components → Subscriptions → Refresh All**
3. Or refresh individual components via their edit page → **Refresh** button

This keeps all module apps in sync with App 200 without manual updates.
