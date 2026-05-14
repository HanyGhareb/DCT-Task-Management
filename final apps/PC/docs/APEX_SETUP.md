# APEX Setup Guide — Petty Cash App 201
**APEX Version:** 24.2 | **Schema:** PROD | **Date:** 2026-05-13

---

## Prerequisites

Before building App 201, confirm the following are complete:

- [ ] Shared V2 framework installed (`db/v2/install.sql` + `db/v2/01b_dct_ddl_alterations.sql`)
- [ ] Petty Cash module installed (`final apps/PC/db/install.sql`)
- [ ] App 200 (i-Finance Hub) is live and DCT_AUTH package is deployed
- [ ] GL Code Combinations data loaded into `PROD.DCT_GL_CODE_COMBINATIONS` (managed via App 200 — GL Management)
- [ ] Project tables exist or `DCT_PROJECT_BUDGET_V` has been updated to point at correct source views
- [ ] Sequences created (see `final apps/PC/app/01_sequences.sql`)
- [ ] Shared components SQL run (see `final apps/PC/app/02_shared_components.sql`)

---

## Step 1 — Run Pre-Build SQL

Run in order via SQLcl (`sqlcl -name prod_mcp`):

```
cd "final apps/PC/app"
< 01_sequences.sql
< 02_shared_components.sql
```

---

## Step 2 — Create the Application

In APEX Builder → **App Gallery → Create**:

| Property | Value |
|---|---|
| Name | Petty Cash — DCT |
| Application ID | 201 |
| Schema | PROD |
| Authentication | (set in Step 4) |
| Theme | Universal Theme (42) |
| Theme Style | Vita (override with Oracle Fusion CSS in Step 9) |
| Language | English |
| Date Format | DD-MON-YYYY |
| Timestamp Format | DD-MON-YYYY HH24:MI:SS |

---

## Step 3 — Application Definition Settings

**Shared Components → Application Definition:**

| Setting | Value |
|---|---|
| Application Alias | PC |
| Logo | DCT Petty Cash |
| Error Handling | (default APEX error handling) |
| Substitution: `APP_NAME` | Petty Cash |
| Substitution: `APP_MODULE` | PETTY_CASH |
| Substitution: `SCHEMA` | PROD |

---

## Step 4 — Authentication Scheme

> **Shared Architecture Rule:** Subscribe to App 200's scheme — do not create a standalone scheme.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Section 1.

**Shared Components → Authentication Schemes → Create:**

| Property | Value |
|---|---|
| Creation Method | Subscribe to Authentication Scheme from another Application |
| Source Application | 200 |
| Source Scheme | DCT Auth |

Set as **Current** authentication scheme.

---

## Step 5 — Application Items

> **Shared Architecture Rule:** Standard items (APP_USER_ID … APP_PENDING_APPROVAL_COUNT) must use
> identical names and protection levels across all apps. Module-specific items are added on top.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Section 2.

**Shared Components → Application Items → Create** (repeat for each):

**Standard items (same in every module app):**

| Name | Scope | Session State Protection |
|---|---|---|
| `APP_USER_ID` | Application | Restricted — May not be set from browser |
| `APP_EMP_NUM` | Application | Restricted — May not be set from browser |
| `APP_EMP_NAME` | Application | Unrestricted |
| `APP_ORG_ID` | Application | Restricted — May not be set from browser |
| `APP_IS_ADMIN` | Application | Restricted — May not be set from browser |
| `APP_IS_MANAGER` | Application | Restricted — May not be set from browser |
| `APP_PENDING_APPROVAL_COUNT` | Application | Unrestricted |

**Petty Cash module-specific items (App 201 only):**

| Name | Scope | Session State Protection |
|---|---|---|
| `APP_IS_PC_ADMIN` | Application | Restricted — May not be set from browser |
| `APP_ACTIVE_PC_ID` | Application | Restricted — May not be set from browser |
| `APP_ACTIVE_PC_COUNT` | Application | Restricted — May not be set from browser |

---

## Step 6 — SET_APP_ITEMS Application Process

> **Shared Architecture Rule:** Every module app has a `SET_APP_ITEMS` process with the standard
> block (same across all apps) extended by a module-specific section.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Section 3.

**Shared Components → Application Processes → Create:**

| Property | Value |
|---|---|
| Name | SET_APP_ITEMS |
| Sequence | 10 |
| Process Point | On New Session |
| Source | Standard block from `SHARED_APEX_ARCHITECTURE.md` Section 3, extended with: |

**Petty Cash module extension (add after standard block):**
```sql
  -- Petty Cash module-specific items
  :APP_IS_PC_ADMIN := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN   prod.dct_roles r ON r.role_id = ur.role_id
      WHERE  ur.user_id  = v_user_id
      AND    r.role_code = 'AP_PETTY_CASH_ADMIN'
      AND    ur.is_active = 'Y'
      AND    (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  SELECT COUNT(*), MAX(CASE WHEN status = 'ACTIVE' THEN pc_id END)
  INTO   :APP_ACTIVE_PC_COUNT, :APP_ACTIVE_PC_ID
  FROM   prod.dct_petty_cash
  WHERE  user_id = v_user_id
  AND    status  = 'ACTIVE';
```

---

## Step 7 — Authorization Schemes

> **Shared Architecture Rule:** Standard schemes (IS_ADMIN, IS_MANAGER, IS_MANAGER_OR_ADMIN)
> are subscribed from App 200. Module-specific schemes are created locally.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Sections 4 & 6.

### Standard Schemes — Subscribe from App 200
**Shared Components → Authorization Schemes → Create → From Existing Scheme in another Application**

| Scheme Name | Source App |
|---|---|
| `IS_ADMIN` | 200 |
| `IS_MANAGER` | 200 |
| `IS_MANAGER_OR_ADMIN` | 200 |

### Common LOVs — Subscribe from App 200
**Shared Components → List of Values → Create → From Existing LOV in another Application**

Subscribe all 8 common LOVs: `LOV_DCT_EMPLOYEES`, `LOV_DCT_EMPLOYEES_BY_ORG`, `LOV_DCT_ORGANIZATIONS`, `LOV_DCT_ROLES`, `LOV_YES_NO`, `LOV_ACTIVE_INACTIVE`, `LOV_MONTHS`, `LOV_APPROVAL_STATUS`, `LOV_REQUEST_STATUSES`

### Petty Cash Module-Specific Schemes — Create Locally

**Shared Components → Authorization Schemes → Create** (repeat for each):

### IS_EMPLOYEE
| Property | Value |
|---|---|
| Name | IS_EMPLOYEE |
| Scheme Type | PL/SQL Function Body (returning Boolean) |
| Expression | `RETURN prod.dct_auth.has_role('EMPLOYEE', :APP_USER);` |
| Error Message | You do not have access to this page. |
| Caching | Once per session |

### IS_MANAGER
| Property | Value |
|---|---|
| Name | IS_MANAGER |
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_MANAGER = 'Y';` |
| Caching | Once per session |

### IS_PC_ADMIN
| Property | Value |
|---|---|
| Name | IS_PC_ADMIN |
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_PC_ADMIN = 'Y';` |
| Caching | Once per session |

### IS_ADMIN
| Property | Value |
|---|---|
| Name | IS_ADMIN |
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_ADMIN = 'Y';` |
| Caching | Once per session |

### IS_MANAGER_OR_ADMIN
| Property | Value |
|---|---|
| Name | IS_MANAGER_OR_ADMIN |
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_MANAGER = 'Y' OR :APP_IS_PC_ADMIN = 'Y';` |
| Caching | Once per session |

### IS_OWN_PC
| Property | Value |
|---|---|
| Name | IS_OWN_PC |
| Scheme Type | PL/SQL Function Body |
| Expression | `DECLARE v NUMBER; BEGIN SELECT 1 INTO v FROM prod.dct_petty_cash WHERE pc_id = :P3_PC_ID AND user_id = :APP_USER_ID; RETURN TRUE; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE; END;` |
| Caching | Once per page view |

---

## Step 8 — Navigation Menu

**Shared Components → Navigation Menu → Desktop Navigation Menu → Create Entry** (in order):

| Seq | Label | Icon | Target | Auth Scheme |
|---|---|---|---|---|
| 10 | Home | fa-home | f?p=201:1 | — |
| 20 | My Petty Cash | fa-money | f?p=201:2 | — |
| 30 | New Request | fa-plus-circle | f?p=201:3 | — |
| 40 | Reimbursements | fa-file-text-o | f?p=201:4 | — |
| 50 | Clearing | fa-check-square-o | f?p=201:6 | — |
| 60 | Approve / Reject | fa-thumbs-up | f?p=201:7 | IS_MANAGER_OR_ADMIN |
| 65 | *(separator)* | — | — | IS_PC_ADMIN |
| 70 | All Petty Cash | fa-list | f?p=201:8 | IS_PC_ADMIN |
| 80 | All Reimbursements | fa-list-alt | f?p=201:9 | IS_PC_ADMIN |
| 90 | All Clearings | fa-list-ol | f?p=201:10 | IS_PC_ADMIN |
| 100 | GL Code Combinations | fa-table | f?p=201:11 | IS_PC_ADMIN |
| 105 | *(separator)* | — | — | IS_ADMIN |
| 110 | Approval Rules | fa-sitemap | f?p=201:12 | IS_ADMIN |
| 120 | Module Settings | fa-cog | f?p=201:13 | IS_ADMIN |

---

## Step 9 — Apply Oracle Fusion CSS

**Shared Components → User Interface Attributes → CSS:**

Paste the Oracle Fusion theme CSS (same as App 200 — copy from App 200's Shared Components → User Interface Attributes → CSS → Inline).

Key CSS classes used:
- `.t-Header` — top bar styling
- `.t-NavigationBar` — nav bar
- `.t-Region--raised` — card regions
- `.t-Alert--warning` — closing banner

---

## Step 10 — Build Pages

Build pages in this order (each depends on app items and auth being ready):

1. **Page 9999** — Login (use APEX wizard: Login Page)
2. **Page 0** — Global Page (add notification badge region)
3. **Page 1** — Home Dashboard (4 regions — see APEX_PAGE_PLAN.md)
4. **Page 2** — My Petty Cash (IR)
5. **Page 11** — GL Code Combinations (IG — build early to test GL data)
6. **Page 3** — Petty Cash Request (Form + IG budget lines)
7. **Page 5** — Reimbursement Detail (Form + IG)
8. **Page 6** — Clearing Request (Form + IG)
9. **Page 4** — Reimbursement Requests (IR + link to Page 5)
10. **Page 7** — Approve / Reject (IR + modal form)
11. **Page 8** — All Petty Cash (IR)
12. **Page 9** — All Reimbursements (IR)
13. **Page 10** — All Clearings (IR)
14. **Page 12** — Approval Rules (Master-Detail)
15. **Page 13** — Module Settings (IG)

---

## Step 11 — Cascade LOVs for GL Segments

> These are **module-specific LOVs** — defined locally in App 201 only, not shared back to App 200.
> Common LOVs (employees, orgs, etc.) were already subscribed in Step 7.

For each cascade level in the GL budget lines Interactive Grid, create a **Shared LOV**:

**Example — APPROPRIATION (filtered by ENTITY_CODE):**

| Property | Value |
|---|---|
| Name | LOV_GL_APPROPRIATION |
| Type | SQL Query |
| Query | `SELECT DISTINCT appropriation d, appropriation r FROM prod.dct_gl_code_combinations WHERE entity_code = :ENTITY_CODE AND is_active='Y' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1` |

Create one Shared LOV per segment (8 LOVs total for Appropriation → Future2).

In the Interactive Grid column properties:
- Set LOV to the appropriate Shared LOV
- Set **Cascading LOV Parent Item** to the upstream segment column

---

## Step 12 — Test Checklist

### Employee Flow
- [ ] Login as an employee with no active PC → see empty dashboard, New Request button enabled
- [ ] Submit a new Temporary PC request → status = SUBMITTED, approval instance created
- [ ] Submit a new Permanent PC request → verify step 4 (AP Admin) fires
- [ ] Submit a request > 5,000 AED → verify step 2 fires
- [ ] Submit a request > 20,000 AED → verify step 3 fires

### Approval Flow
- [ ] Login as Manager → see pending request in Page 7
- [ ] Approve → instance advances to next step or closes
- [ ] Reject → request status = REJECTED, employee notified

### Reimbursement Flow
- [ ] Employee with active PC → New Reimbursement → submit
- [ ] Approve reimbursement → float balance restored
- [ ] Submit multiple reimbursements for same PC → all allowed

### Clearing Flow
- [ ] Employee submits clearing → amount_spent + amount_refunded = advance amount → validates
- [ ] Approve clearing → PC status = CLOSED → employee cannot submit new reimbursement

### Admin Flows
- [ ] AP Admin sees all records in Pages 8, 9, 10
- [ ] Admin edits GL Code Combinations (Page 11) — add, edit, deactivate
- [ ] Admin edits Approval Rules (Page 12) — add step, change threshold
- [ ] Admin edits Module Settings (Page 13) — change BUDGET_VALIDATION_MODE to HARD, verify new request blocks over-budget lines

### Budget Coding
- [ ] GL coding: cascade LOVs filter correctly at each segment level
- [ ] GL coding: CC_ID resolves to correct combination
- [ ] Project coding: budget/actual/encumbrance/fund_available display correctly
- [ ] Budget line sum validation fires correctly

---

## Step 13 — Export Application

After all pages are built and tested:

```sql
-- Run via MCP or SQLcl connected to PROD schema
SELECT apex_export.get_application(
  p_application_id          => 201,
  p_split                   => FALSE,
  p_with_date               => TRUE,
  p_with_ir_public_reports  => TRUE,
  p_with_translations       => FALSE
).getclob()
FROM dual;
```

Save export to `final apps/PC/app/f201.sql`.

---

## Troubleshooting

| Issue | Fix |
|---|---|
| App items not set | Check SET_APP_ITEMS process — ensure it fires On New Session |
| Authorization fails for all users | Verify DCT_AUTH.HAS_ROLE is compiled in PROD schema, not ADMIN |
| Cascade LOV shows no values | Verify DCT_GL_CODE_COMBINATIONS has data and IS_ACTIVE='Y' |
| DCT_PROJECT_BUDGET_V invalid | Connect project source tables — update view in `02_pc_views.sql` and re-run |
| Approval instance not created | Verify DCT_APPROVAL_TEMPLATES.IS_ACTIVE='Y' for PETTY_CASH module |
| Budget line sum validation error | Ensure IG saves before validation runs — use IG Save as a page process before validation |
