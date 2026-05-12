# i-Finance V2 — App 200 UI Test Scenarios
**Sprint 1–5 Coverage | Oracle APEX 24.2**

---

## How to Use
- Work through each section in order.
- Open this file in **VS Code** and press **Ctrl+Shift+V** to open the preview pane.
- Click the checkbox next to **PASS** or **FAIL** for each test directly in the preview.
- For failures, note the error message and report it before moving on.
- Prerequisites for each section are listed at the top.

---

## Section 1 — Authentication

### T01 · Login with valid credentials
**Steps**
1. Navigate to App 200 login page.
2. Enter username `ADMIN` and the admin password.
3. Click **Sign In**.

**Expected**
- Redirected to Page 1 (Home / App Launcher).
- Page title shows "i-Finance" or app name.
- Desktop navigation menu is visible on the left.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T02 · Login with wrong password
**Steps**
1. On the login page enter username `ADMIN`, password `wrongpassword`.
2. Click **Sign In**.

**Expected**
- Error message displayed: "Invalid username or password" (or similar).
- Stays on login page.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T03 · Login with unknown username
**Steps**
1. Enter username `NOBODY`, any password.
2. Click **Sign In**.

**Expected**
- Same error as T02 — no information disclosure about whether username exists.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T04 · Direct page access when not logged in
**Steps**
1. Log out (or use a fresh browser/incognito tab).
2. Navigate directly to `f?p=200:10` (Users page).

**Expected**
- Redirected to login page, NOT the Users page.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T05 · Logout
**Precondition:** Logged in.

**Steps**
1. Click the user icon / account menu (top-right).
2. Click **Sign Out** (or equivalent).

**Expected**
- Redirected to login page.
- Navigating back to `f?p=200:1` redirects to login.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 2 — Home / App Launcher (Page 1)

### T06 · App Launcher cards display
**Precondition:** Logged in as ADMIN.

**Steps**
1. Navigate to Page 1 (Home).
2. Observe the cards region.

**Expected**
- At least one card is visible with a module name, icon, and description.
- Cards are styled (not plain text).

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T07 · Navigation menu visible
**Steps**
1. On Page 1, look at the left sidebar.

**Expected**
- Menu sections are visible: Home, My Notifications, User Management, Organisation, Modules, Approvals, Configuration, Audit.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T08 · Navigate via sidebar to Users
**Steps**
1. In the sidebar, expand **User Management**.
2. Click **Users**.

**Expected**
- Page 10 (Users IR) loads.
- Breadcrumb shows: Home > Users.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 3 — User Management (Pages 10 & 11)

### T09 · View users interactive report
**Precondition:** On Page 10.

**Expected**
- IR table renders with columns: Username, Display Name, Email, Role(s), Active, etc.
- At least one row (ADMIN user) is present.
- Search bar and "Create" button are visible in the toolbar.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T10 · Create a new user
**Steps**
1. On Page 10, click **Create**.
2. Page 11 drawer opens.
3. Fill in:
   - Username: `TESTUSER01`
   - Display Name: `Test User One`
   - Email: `test01@ifinance.local`
   - Is Active: `Yes`
4. Click **Create**.

**Expected**
- Drawer closes.
- Page 10 refreshes and `TESTUSER01` appears in the list.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T11 · Edit an existing user
**Steps**
1. On Page 10, click the username link for `TESTUSER01`.
2. Page 11 drawer opens with existing data pre-filled.
3. Change Display Name to `Test User One (Updated)`.
4. Click **Apply Changes**.

**Expected**
- Drawer closes.
- Updated name is reflected in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T12 · Required field validation on user form
**Steps**
1. Click **Create** on Page 10.
2. Leave Username blank.
3. Click **Create**.

**Expected**
- Validation error shown: "Username is required" (or similar).
- Drawer does NOT close.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T13 · Delete a user
**Steps**
1. Click the username link for `TESTUSER01`.
2. In the drawer, click **Delete**.
3. Confirm the deletion.

**Expected**
- Drawer closes.
- `TESTUSER01` no longer appears in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 4 — Role Management (Pages 20 & 21)

### T14 · View roles IR
**Steps**
1. In sidebar, click **User Management > Roles** (or navigate to Page 20).

**Expected**
- IR shows existing roles (e.g., SYS_ADMIN, PLATFORM_USER, etc.).
- Breadcrumb: Home > Roles.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T15 · Create a new role
**Steps**
1. On Page 20, click **Create**.
2. Fill in:
   - Role Code: `TEST_ROLE`
   - Role Name (EN): `Test Role`
   - Is Active: `Yes`
3. Click **Create**.

**Expected**
- Drawer closes, `TEST_ROLE` appears in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T16 · Edit a role
**Steps**
1. Click the `TEST_ROLE` link.
2. Change Role Name to `Test Role (Updated)`.
3. Click **Apply Changes**.

**Expected**
- Updated name reflected in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T17 · Delete a role
**Steps**
1. Click the `TEST_ROLE` link.
2. Click **Delete** and confirm.

**Expected**
- Role removed from IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 5 — Permissions (Pages 23, 24, 26)

### T18 · View Permissions Library (Page 24)
**Steps**
1. In sidebar, click **User Management > Permissions** (or navigate to Page 24).

**Expected**
- IR shows permissions (e.g., USERS_VIEW, USERS_EDIT, etc.).
- Breadcrumb: Home > Permissions Library.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T19 · View Role Permissions (Page 23)
**Steps**
1. Navigate to Page 20 (Roles).
2. Click a role name (e.g., SYS_ADMIN).
3. In the role drawer (P21), note if there is a "Permissions" button or navigate directly to Page 23.

**Expected**
- Page 23 shows permissions assigned to that role.
- Breadcrumb: Home > Roles > Role Permissions.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T20 · Grant a permission to a role (Page 26)
**Steps**
1. On Page 23 (Role Permissions), click **Grant Permission**.
2. The grant/revoke modal (P26) opens.
3. Select a permission not yet assigned.
4. Click **Grant**.

**Expected**
- Modal closes, new permission appears in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T21 · Revoke a permission from a role
**Steps**
1. On Page 23, click the permission link for the one just granted.
2. In the modal, click **Revoke** (or Delete).

**Expected**
- Permission removed from the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 6 — User Role Assignments (Pages 12, 13, 25)

### T22 · View Role Users (Page 25)
**Steps**
1. Navigate to Page 20 (Roles), click any role.
2. In the role drawer, click **Role Users** (or navigate to Page 25 with a role ID).

**Expected**
- Page 25 shows users assigned to that role.
- Breadcrumb: Home > Roles > Role Users.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T23 · View User Role Assignments (Page 13)
**Steps**
1. Navigate to Page 10 (Users), click a username.
2. In the user drawer (P11), look for "Role Assignments" link, or navigate to Page 13.

**Expected**
- Page 13 shows roles assigned to that user.
- Breadcrumb: Home > Users > Role Assignments.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T24 · Assign role to user (Page 12)
**Precondition:** Create `TESTUSER02` first (repeat T10 with username `TESTUSER02`).

**Steps**
1. On Page 13 for TESTUSER02, click **Assign Role**.
2. Page 12 modal opens.
3. Select role `PLATFORM_USER`.
4. Click **Assign**.

**Expected**
- Modal closes, `PLATFORM_USER` appears in the assignments list.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 7 — Organizations (Pages 30 & 31)

### T25 · View Organizations IR (Page 30)
**Steps**
1. In sidebar, click **Organisation > Org Hierarchy** (or navigate to Page 30).

**Expected**
- IR shows organizations (Finance Division, sections, etc. from seed data).
- Breadcrumb: Home > Organizations.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T26 · Create an organization
**Steps**
1. On Page 30, click **Create**.
2. Fill in:
   - Org Code: `TEST_ORG`
   - Name (EN): `Test Organization`
   - Type: `Section`
   - Is Active: `Yes`
3. Click **Create**.

**Expected**
- Drawer closes, `TEST_ORG` appears in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T27 · Edit an organization
**Steps**
1. Click the `Test Organization` link.
2. Change Name to `Test Organization (Updated)`.
3. Click **Apply Changes**.

**Expected**
- Updated name in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T28 · Delete an organization
**Steps**
1. Click `Test Organization (Updated)`.
2. Click **Delete** and confirm.

**Expected**
- Removed from IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 8 — Modules (Pages 40, 41, 42)

### T29 · View Modules IR (Page 40)
**Steps**
1. In sidebar, click **Modules > Module Registry** (or navigate to Page 40).

**Expected**
- IR shows modules from seed data (i-Finance Hub, Petty Cash, etc.).
- Breadcrumb: Home > Modules.
- Module name is a clickable link.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T30 · Open Module Details drawer (Page 41)
**Steps**
1. Click any module name link on Page 40.

**Expected**
- Drawer (Page 41) opens with module details pre-filled.
- "Manage Role Access" button is visible.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T31 · Create a module
**Steps**
1. On Page 40, click **Create**.
2. Fill in:
   - Module Code: `TEST_MOD`
   - Name (EN): `Test Module`
   - Is Active: `Yes`
3. Click **Create**.

**Expected**
- Drawer closes, `TEST_MOD` in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T32 · View Module Role Access (Page 42)
**Steps**
1. Click `Test Module` to open drawer (P41).
2. Click **Manage Role Access**.

**Expected**
- Page 42 opens showing role access for `TEST_MOD`.
- Breadcrumb: Home > Modules > Module Details > Module Role Access.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T33 · Delete test module
**Steps**
1. Navigate to P40, click `Test Module`, click **Delete**.

**Expected**
- Removed from IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 9 — Approval Framework (Pages 50–56)

### T34 · View Approval Templates IR (Page 50)
**Steps**
1. In sidebar, click **Approvals > Templates** (or navigate to Page 50).

**Expected**
- IR renders (may be empty if no templates seeded).
- Breadcrumb: Home > Approval Templates.
- "Create" button visible.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T35 · Create an approval template
**Steps**
1. On Page 50, click **Create**.
2. Fill in:
   - Template Code: `TEST_APPROVAL`
   - Name (EN): `Test Approval Flow`
   - Is Sequential: `Yes`
   - Is Active: `Yes`
3. Click **Create**.

**Expected**
- Drawer closes, `TEST_APPROVAL` in IR.
- Template name is a clickable link.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T36 · Open template and navigate to Steps (Page 53)
**Steps**
1. Click `Test Approval Flow` to open drawer (P51).
2. Click **Manage Steps**.

**Expected**
- Page 53 opens, filtered to this template.
- Breadcrumb: Home > Approval Templates > Template Detail > Approval Steps.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T37 · Create an approval step
**Steps**
1. On Page 53, click **Create**.
2. Fill in:
   - Step Name: `Manager Approval`
   - Step Order: `1`
   - Step Type: `ROLE_BASED`
   - Role: select any role
   - Is Mandatory: `Yes`
3. Click **Create**.

**Expected**
- Drawer closes, step appears in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T38 · Edit the step
**Steps**
1. Click `Manager Approval` link.
2. Change Step Name to `Manager Approval (Revised)`.
3. Click **Apply Changes**.

**Expected**
- Updated name in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T39 · Delete the step
**Steps**
1. Click the step link, click **Delete**.

**Expected**
- Removed from IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T40 · View Approval Monitor (Page 55)
**Steps**
1. In sidebar, click **Approvals > Monitor** (or navigate to Page 55).

**Expected**
- Page 55 renders (empty if no instances submitted).
- Breadcrumb: Home > Approval Monitor.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T41 · Clean up test template
**Steps**
1. Navigate to P50, open `TEST_APPROVAL`, click **Delete**.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 10 — Lookup Management (Pages 60–63)

### T42 · View Lookup Categories IR (Page 60)
**Steps**
1. In sidebar, click **Configuration > Lookups** (or navigate to Page 60).

**Expected**
- IR shows seed lookup categories.
- Category Name column is a clickable link (→ P62).
- Values column shows a count, also clickable (→ P61).
- Breadcrumb: Home > Lookup Categories.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T43 · Create a lookup category
**Steps**
1. On Page 60, click **Create**.
2. Drawer (P62) opens.
3. Fill in:
   - Category Code: `TEST_CAT`
   - Name (EN): `Test Category`
   - Is System: `No`
   - Is Active: `Yes`
4. Click **Create**.

**Expected**
- Drawer closes, `TEST_CAT` in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T44 · Edit a lookup category
**Steps**
1. Click `Test Category` to open P62.
2. Change Name to `Test Category (Updated)`.
3. Click **Apply Changes**.

**Expected**
- Updated name in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T45 · Navigate to Lookup Values from category IR (Page 61)
**Steps**
1. On Page 60, click the value count (`0`) in the Values column for `Test Category (Updated)`.

**Expected**
- Page 61 opens, filtered to `TEST_CAT`.
- IR is empty (no values yet).
- Breadcrumb: Home > Lookup Categories > Lookup Values.
- "Create" button visible.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T46 · Navigate to Lookup Values from category drawer
**Steps**
1. On Page 60, click `Test Category (Updated)` to open P62.
2. Click **View Values**.

**Expected**
- Page 61 opens, filtered to `TEST_CAT`.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T47 · Create a lookup value
**Steps**
1. On Page 61 (with TEST_CAT context), click **Create**.
2. Drawer (P63) opens.
3. Fill in:
   - Value Code: `VAL_01`
   - Name (EN): `First Value`
   - Display Order: `10`
   - Is Default: `No`
   - Is Active: `Yes`
4. Click **Add Value**.

**Expected**
- Drawer closes, `VAL_01` appears in the IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T48 · Edit a lookup value
**Steps**
1. On Page 61, click `VAL_01` link.
2. Drawer (P63) opens with `VAL_01` data pre-filled.
3. Change Name to `First Value (Updated)`.
4. Click **Apply Changes**.

**Expected**
- Drawer closes, updated name in IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T49 · Create a second lookup value
**Steps**
1. Click **Create**, fill in Code: `VAL_02`, Name: `Second Value`, Order: `20`, Active: `Yes`.
2. Click **Add Value**.

**Expected**
- `VAL_02` appears in IR. Values count on P60 now shows `2`.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T50 · Delete a lookup value
**Steps**
1. Click `VAL_02` link on P61.
2. Click **Delete** and confirm.

**Expected**
- `VAL_02` removed, count back to `1`.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T51 · Delete test lookup category
**Steps**
1. Navigate to Page 60.
2. Click `Test Category (Updated)`, then **Delete** and confirm.

**Note:** This will fail if `VAL_01` still exists (FK constraint). Delete `VAL_01` first if needed.

**Expected**
- Category removed from IR.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 11 — My Notifications (Page 4)

### T52 · Navigate to My Notifications
**Steps**
1. In sidebar, click **My Notifications** (or navigate to Page 4).

**Expected**
- Page renders with IR.
- If no notifications: "No notifications found." message.
- Breadcrumb: Home > My Notifications.
- **Mark All Read** button visible in toolbar.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T53 · Seed a test notification and verify display
**Precondition:** Run the following in SQLcl or SQL Developer:
```sql
INSERT INTO prod.dct_notifications (
    recipient_user_id, notification_type, title_en, body_en, is_read
)
SELECT user_id, 'SYSTEM', 'Test Notification', 'This is a UI test notification.', 'N'
FROM   prod.dct_users
WHERE  UPPER(username) = 'ADMIN';
COMMIT;
```

**Steps**
1. Refresh Page 4.

**Expected**
- The test notification appears in the IR with `IS_READ = N`.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T54 · Mark all notifications as read
**Steps**
1. On Page 4 with at least one unread notification, click **Mark All Read**.

**Expected**
- Success message: "All notifications marked as read."
- Page refreshes; notification now shows `IS_READ = Y`.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 12 — Navigation & Breadcrumbs

### T55 · Breadcrumb works on Users page
**Steps**
1. Navigate to Page 10.
2. Click **Home** in the breadcrumb.

**Expected**
- Returns to Page 1 (Home / App Launcher).

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T56 · Breadcrumb works on deep page (Role Permissions)
**Steps**
1. Navigate to Page 23 (Role Permissions).
2. Breadcrumb should show: Home > Roles > Role Permissions.
3. Click **Roles**.

**Expected**
- Returns to Page 20 (Roles IR).

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T57 · Breadcrumb on Lookup Values
**Steps**
1. Navigate to Page 61.
2. Breadcrumb: Home > Lookup Categories > Lookup Values.
3. Click **Lookup Categories**.

**Expected**
- Returns to Page 60.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T58 · Sidebar navigation — all top-level items expand
**Steps**
1. Click each sidebar section: User Management, Organisation, Modules, Approvals, Configuration, Audit.

**Expected**
- Each section expands to show child links without errors.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 13 — IR Features (apply to any IR page)

### T59 · Search in Users IR
**Steps**
1. On Page 10, type `ADMIN` in the search bar and press Enter.

**Expected**
- IR filters to show only the ADMIN row.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T60 · Reset search
**Steps**
1. Clear the search or click the reset icon.

**Expected**
- All users visible again.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T61 · IR column sorting
**Steps**
1. On Page 10, click the **Username** column header.

**Expected**
- IR sorts ascending by username.
- Clicking again sorts descending.

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Section 14 — Error & Edge Cases

### T62 · Duplicate username rejected
**Steps**
1. Try to create a user with username `ADMIN` (already exists).
2. Click **Create**.

**Expected**
- Error: unique constraint violation or "Username already exists".
- Drawer stays open.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T63 · Duplicate role code rejected
**Steps**
1. Try to create a role with code that already exists (e.g., `SYS_ADMIN`).

**Expected**
- Constraint error shown, drawer stays open.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T64 · Duplicate lookup category code rejected
**Steps**
1. Try to create a category with code `TEST_CAT` when it already exists.

**Expected**
- Constraint error shown.

**Result:**
- [ ] PASS
- [ ] FAIL

---

### T65 · Duplicate lookup value code in same category
**Steps**
1. Try to create a second value with code `VAL_01` in the same category.

**Expected**
- Unique constraint error (category_id + value_code must be unique).

**Result:**
- [ ] PASS
- [ ] FAIL

---

## Summary Checklist

| Section | Tests | Pass | Fail | Skip |
|---|---|---|---|---|
| 1 — Authentication | T01–T05 | | | |
| 2 — Home / Launcher | T06–T08 | | | |
| 3 — User Management | T09–T13 | | | |
| 4 — Role Management | T14–T17 | | | |
| 5 — Permissions | T18–T21 | | | |
| 6 — User Role Assignments | T22–T24 | | | |
| 7 — Organizations | T25–T28 | | | |
| 8 — Modules | T29–T33 | | | |
| 9 — Approval Framework | T34–T41 | | | |
| 10 — Lookup Management | T42–T51 | | | |
| 11 — My Notifications | T52–T54 | | | |
| 12 — Navigation | T55–T58 | | | |
| 13 — IR Features | T59–T61 | | | |
| 14 — Error / Edge Cases | T62–T65 | | | |
| **Total** | **65** | | | |
