# -*- coding: utf-8 -*-
"""Generate UAT workbooks for the 4 i-Finance JET apps.

One .xlsx per app under final apps/<App>/UAT/:
  - Instructions sheet (how to test, legend, live summary via formulas)
  - One sheet per logical functional area
  - Columns: Test ID | Function | Test Scenario | Steps | Expected Result |
             Status (dropdown) | Tested By | Test Date | Comments / Defect Ref
  - Pass/Fail/Blocked/N/A dropdown + conditional colors, frozen header, autofilter
"""
import os
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.worksheet.datavalidation import DataValidation
from openpyxl.formatting.rule import CellIsRule
from openpyxl.utils import get_column_letter

ROOT = r"c:\claude\DCT-task-management\DCT-Task-Management\final apps"

BRANDS = {  # header color per app
    "Admin": "C74634", "PC": "2E7D32", "DT": "0572CE", "HR": "1A7F5A",
}

HEADERS = ["Test ID", "Function", "Test Scenario", "Steps", "Expected Result",
           "Status", "Tested By", "Test Date", "Comments / Defect Ref"]
WIDTHS  = [10, 22, 34, 52, 46, 11, 14, 12, 36]

thin = Side(style="thin", color="C9C9C9")
BORDER = Border(left=thin, right=thin, top=thin, bottom=thin)

# =============================================================================
# Test case data.  Per app: list of (area_sheet_name, prefix, [cases])
# case = (function, scenario, steps, expected)
# =============================================================================

ADMIN = [
("Login & Session", "LOG", [
 ("Login", "Valid login", "1. Open the app URL\n2. Enter a valid username + password (or use a quick-login button)\n3. Click Sign In", "Dashboard opens; top bar shows your name and avatar initials; side navigation matches your role"),
 ("Login", "Invalid password", "1. Enter a valid username with a wrong password\n2. Click Sign In", "Error message 'Invalid credentials or account inactive'; stays on login page"),
 ("Login", "Inactive account", "1. Login with a deactivated account (ask admin to deactivate a test user first)", "Login refused with the same generic error"),
 ("Session", "Refresh keeps session", "1. Login\n2. Press F5 / Ctrl+F5 on any page", "Still logged in; same page or dashboard reopens (no login prompt)"),
 ("Session", "Deep link without session", "1. Logout\n2. Open the app URL again", "Login page shown; no app content visible before login"),
 ("Logout", "Logout clears session", "1. Click your avatar (top-right) > Logout\n2. Press Back in the browser", "Returned to login; Back does not re-enter the app with data"),
 ("Login", "Arabic login page", "1. On the login page switch language to AR (ع)\n2. Login", "Login page is mirrored (RTL) with Arabic labels; after login the app stays in Arabic"),
]),
("Dashboard", "DSH", [
 ("Headline counts", "Stats cards show live numbers", "1. Open Home/Dashboard\n2. Compare 'Users' count with the Users list total", "Cards show non-zero sensible numbers; users count matches the Users page total"),
 ("Charts", "Both charts render", "1. Open Dashboard\n2. Wait for charts to load", "Approval cycle-time bar chart + 30-day activity line chart render with axes and legend; no empty boxes"),
 ("Charts", "Charts survive navigation", "1. Open Dashboard\n2. Navigate to Users, then back to Dashboard", "Charts render again correctly (not blank, not duplicated)"),
 ("Loading states", "Skeleton then data", "1. Hard-refresh (Ctrl+F5) on Dashboard", "Brief skeleton/placeholder shown, then real data; no flash of errors"),
]),
("My Workspace", "WSP", [
 ("My Profile", "Profile loads current data", "1. Go to My Workspace > My Profile", "Display names, email, phone, employee number, organisation are the CURRENT values from the server"),
 ("My Profile", "Update phone persists", "1. Change Phone\n2. Click Save Profile\n3. Hard-refresh (Ctrl+F5) and reopen My Profile", "Success banner on save; after refresh the NEW phone is still shown"),
 ("My Profile", "Update Arabic display name", "1. Edit Display Name (Arabic)\n2. Save\n3. Refresh and recheck", "Arabic name saved and persists; shown RTL in the field"),
 ("My Profile", "Employee number not lost", "1. Note your Employee Number\n2. Change phone and Save Profile\n3. Refresh", "Employee Number is unchanged after a profile save"),
 ("My Profile", "Upload photo", "1. Click Change Photo\n2. Pick a JPG/PNG (any size)\n3. Wait for upload", "File picker opens; avatar shows the photo; photo still there after Ctrl+F5"),
 ("My Profile", "Replace photo", "1. Upload a different photo over the existing one", "New photo replaces the old one without errors"),
 ("Change password", "Happy path", "1. In Change Password enter a new valid password twice\n2. Submit\n3. Logout and login with the NEW password\n4. Change it back", "Success message; old password no longer works; new one does"),
 ("Change password", "Validation", "1. Try mismatching passwords\n2. Try a password shorter than 8 characters", "Clear validation errors; nothing saved"),
 ("Notifications", "List + unread badge", "1. Open Notifications\n2. Compare the bell badge count with unread rows", "List loads; badge equals the number of unread notifications"),
 ("Notifications", "Mark as read", "1. Mark one notification as read", "Row state changes; bell badge count decreases by 1"),
 ("Pending approvals", "My queue", "1. Open Pending Approvals (use an approver account with pending items)", "Only items waiting for YOUR approval are listed with module, requester, date"),
 ("Pending approvals", "Approve / reject", "1. Approve one item\n2. Reject another with a comment", "Items leave the queue; requester gets a notification; status history updated"),
]),
("User Management", "USR", [
 ("Users list", "Server pagination", "1. Open Users\n2. Check the pager caption (e.g. '1-50 of N')\n3. Click next page", "Counts are correct; next page loads different rows; pager updates"),
 ("Users list", "Search", "1. Type part of a name/username in search\n2. Pause typing", "List filters after a short delay (server search); count updates; clearing search restores the full list"),
 ("Users list", "Status filter", "1. Filter by Active, then Inactive", "Only matching users shown each time"),
 ("Create user", "Happy path", "1. Click New User\n2. Fill username, names, email, org, role(s), password\n3. Save\n4. Logout and login as the new user", "User created and appears in the list; new user can login and sees role-appropriate navigation"),
 ("Create user", "Duplicate username", "1. Create a user with an existing username", "Clear error; no duplicate created"),
 ("Edit user", "Change roles", "1. Edit a test user\n2. Add/remove a role\n3. Save\n4. Login as that user", "Saved roles reflected; navigation/permissions change accordingly"),
 ("Edit user", "Edit fields", "1. Edit display names / email / phone / employee number / org\n2. Save and reopen", "All edited values persisted and shown"),
 ("Deactivate", "Deactivate + reactivate", "1. Deactivate a test user\n2. Try logging in as them\n3. Reactivate", "Deactivated user cannot login; after reactivation they can"),
]),
("Roles & Permissions", "ROL", [
 ("Roles list", "Vault list renders", "1. Open Roles", "Dark 'Vault' page lists roles with code, type, member count, active state"),
 ("Create role", "New role", "1. Create a role with code + names\n2. Save", "Role appears in the list; audit entry recorded"),
 ("Edit role", "Assign permissions", "1. Open a role\n2. Toggle several permissions on/off\n3. Save\n4. Reopen", "Saved toggles persist; member count unchanged"),
 ("Permission matrix", "Matrix view", "1. Open Permissions\n2. Locate a role column and toggle a cell\n3. Save", "Matrix shows roles x permissions; toggle animates; change persists after reload"),
 ("Permissions", "Effect on user", "1. Remove a permission from a role\n2. Login as a user with ONLY that role", "Corresponding function is hidden/refused for that user (restore afterwards)"),
]),
("Organisation", "ORG", [
 ("Hierarchy", "Tree renders", "1. Open Org Hierarchy", "Organisation tree shows with expand/collapse; correct parent-child structure"),
 ("Hierarchy", "Add unit", "1. Add a child org unit (EN + AR names)\n2. Save", "New unit appears under its parent; available in user org dropdown"),
 ("Hierarchy", "Edit / deactivate unit", "1. Rename a test unit\n2. Deactivate it", "Rename persists; deactivated unit flagged and not offered for new users"),
]),
("System Administration", "SYS", [
 ("Module registry", "List + toggle", "1. Open Module Registry\n2. Toggle a non-critical module inactive and back", "Modules (PC/DT/HR/FL/CC...) listed with status; toggle persists"),
 ("Approval templates", "View / edit template", "1. Open Approval Templates\n2. Open one template and review steps (sequence, role, escalation days)\n3. Edit a non-production template", "Steps listed in order; edits persist"),
 ("Approval monitor", "In-flight instances", "1. Open Approval Monitor\n2. Filter by module/status", "Live approval instances with current step; filters work"),
 ("Lookups", "Add lookup value", "1. Open Lookups\n2. Pick a category (e.g. a status set)\n3. Add a value (code + EN/AR names)\n4. Edit it, then disable it", "Value appears immediately; edits persist; disabled value stops appearing in module dropdowns"),
 ("System settings", "Edit a setting", "1. Open System Settings\n2. Edit a non-system setting value\n3. Save and refresh", "New value persists; system-flagged settings are read-only"),
 ("System settings", "Secrets masked", "1. Locate a key/password-type setting (e.g. API key)", "Value displays as ******** ; saving the mask back is refused (no secret overwrite)"),
 ("Theme setting", "Brand color from settings", "1. Edit THEME_BRAND_COLOR (e.g. #7B1FA2)\n2. Hard-refresh the app", "App chrome (buttons, accents) adopts the new color; restore the original afterwards"),
 ("Audit log", "Pagination + filter", "1. Open Audit Log\n2. Check pager caption\n3. Filter by action (e.g. LOGIN)\n4. Page through", "Server-paged list; filter narrows rows; newest entries first; your own recent actions appear"),
 ("Appearance", "Theme switch", "1. Open Appearance\n2. Switch theme and back", "Theme applies immediately and persists across refresh"),
]),
("Shell & Platform", "SHL", [
 ("Module switcher", "Switch to another module", "1. Click the module dropdown in the top bar\n2. Choose HR (or PC/DT)", "Target app opens WITHOUT a second login (shared session); switcher highlights the current module"),
 ("Language", "EN to AR live switch", "1. Click the ع button in the top bar", "Entire page flips RTL instantly: top bar, side nav, content; Arabic font; numbers stay Latin digits"),
 ("Language", "AR persists across login", "1. Switch to AR\n2. Logout, close browser, reopen and login", "App opens in Arabic (server-stored preference); switch back to EN at the end"),
 ("Side navigation", "Collapse / expand", "1. Click the hamburger icon", "Side nav collapses/expands; content area adjusts"),
 ("Role-based nav", "Menu matches role", "1. Login as a non-admin user", "Admin-only groups (User Management, System) are hidden"),
 ("Error handling", "API failure feedback", "1. Disconnect network (or stop the proxy)\n2. Try loading a list", "Friendly error state with Retry + a toast; no frozen skeleton, no blank screen"),
]),
]

PC = [
("Access & Session", "ACC", [
 ("Shared session", "Entry from Admin", "1. Login in the Admin app\n2. Use the module switcher to open Petty Cash", "PC opens logged-in (no second login); your name in the top bar"),
 ("No session", "Direct open without login", "1. Logout (or new private window)\n2. Open the PC app URL directly", "Redirected to the Admin login page"),
 ("Role gating", "Approver/Admin menus", "1. Login as a regular user, then as a PC admin", "Approvals group only for approvers; All Petty Cash/Configuration only for admins"),
]),
("Dashboard", "DSH", [
 ("Stats", "Cards show live numbers", "1. Open PC Dashboard", "Cards (my floats, pending, totals) show sensible non-error values"),
 ("Charts", "Floats by org + ageing", "1. Wait for both charts", "Outstanding floats by organisation bar chart + TEMPORARY ageing chart render correctly"),
 ("Charts", "Re-render on return", "1. Navigate away and back", "Charts render again, not blank/duplicated"),
]),
("My Petty Cash", "MPC", [
 ("My list", "My requests only", "1. Open My Petty Cash", "Only YOUR petty cash requests, with number, type, amount, status badge"),
 ("Create", "PERMANENT float request", "1. New Petty Cash Request\n2. Type=PERMANENT, amount, justification\n3. Add GL coding line(s) summing to the amount\n4. Save draft", "Draft created with number PC-YYYY-NNNNN; appears in My Petty Cash as DRAFT"),
 ("Create", "TEMPORARY float request", "1. Same with Type=TEMPORARY + needed-by/return date", "Draft created; type shown correctly"),
 ("Validation", "Coding must equal amount", "1. Create a request where coding lines total <> requested amount\n2. Try to submit", "Submission blocked with a clear message"),
 ("Validation", "Required fields", "1. Try saving with empty amount / justification", "Field-level validation errors; nothing saved"),
 ("Submit", "Send for approval", "1. Open a DRAFT request\n2. Click Submit", "Status changes to submitted/pending; appears in the approver's queue; status history records the event"),
 ("Detail", "Request detail", "1. Open a request from the list", "Full detail: amounts, coding lines, status history timeline, documents"),
 ("Withdraw", "Withdraw a submitted request", "1. Open your submitted request\n2. Withdraw", "Status returns to draft/withdrawn; it leaves the approver queue"),
]),
("Reimbursements", "RMB", [
 ("Create", "New reimbursement", "1. Open Reimbursements > New\n2. Add expense lines (date, GL code, amount, description)\n3. Save + Submit", "Reimbursement created with its own number; goes to approval"),
 ("Detail", "Line items + history", "1. Open a reimbursement", "Lines, totals, status history all shown"),
 ("My list", "Status tracking", "1. Check list after submit/approval", "Status badge updates through the lifecycle"),
]),
("Clearing", "CLR", [
 ("Create", "Clear a TEMPORARY float", "1. Open Clearing > New for a disbursed TEMPORARY float\n2. Add receipts/expense lines + returned amount\n3. Submit", "Clearing created; float and clearing linked; goes to approval"),
 ("Validation", "Totals must reconcile", "1. Make receipts + returned cash <> float amount\n2. Try to submit", "Blocked with a clear reconciliation message"),
 ("Detail", "Clearing detail", "1. Open a clearing record", "Receipt lines, float reference, status history shown"),
]),
("Approvals", "APR", [
 ("Queue", "Pending list (approver)", "1. Login as approver\n2. Open Approvals", "All PC items awaiting YOUR step; badge count matches"),
 ("Approve", "Approve with comment", "1. Open an item > Approve (+ comment)", "Item leaves queue; requester notified; history shows approver + timestamp + comment"),
 ("Reject", "Reject with reason", "1. Reject another item with a reason", "Status rejected; requester notified with the reason"),
 ("Authorization", "Non-approver blocked", "1. Login as a regular user\n2. Try the Approvals route", "No Approvals menu; direct navigation shows no queue/denied"),
]),
("Administration", "ADM", [
 ("All Petty Cash", "Paged admin list", "1. Open All Petty Cash (admin)\n2. Check pager '1-50 of N'\n3. Search + filter by status", "All requests org-wide; server pagination, search and status filter work together"),
 ("All Reimbursements", "Admin list", "1. Open All Reimbursements", "Org-wide list with status filters"),
 ("All Clearings", "Admin list", "1. Open All Clearings", "Org-wide list; links open details"),
 ("Disburse", "Mark approved float disbursed", "1. Open an APPROVED request\n2. Disburse (date/reference)", "Status becomes DISBURSED; history updated; TEMPORARY floats start ageing"),
]),
("Configuration", "CFG", [
 ("GL codes", "Browse + search combinations", "1. Open GL Codes\n2. Search a segment value", "9-segment combinations listed with full code string; search filters"),
 ("Approval rules", "View/edit PC rules", "1. Open Approval Rules\n2. Review steps/amount thresholds", "Rules display matches the configured approval template"),
 ("Module settings", "PC settings incl. brand", "1. Open Module Settings\n2. Edit a setting (e.g. THEME_BRAND_COLOR)\n3. Hard-refresh", "Setting persists; brand color change reflects in PC only (restore afterwards)"),
]),
("Shell & Language", "SHL", [
 ("Switcher", "Back to Admin / other modules", "1. Use the top-bar module dropdown", "Other apps open without re-login"),
 ("Arabic", "RTL pass", "1. Switch to AR\n2. Walk My Petty Cash + Dashboard", "Shell + navigation in Arabic, layout mirrored, amounts keep Latin digits; lists still load"),
 ("Notifications", "PC notifications", "1. Trigger an approval event\n2. Check the bell", "Notification received and readable"),
]),
]

DT = [
("Access & Session", "ACC", [
 ("Shared session", "Entry from Admin", "1. Login in Admin\n2. Switch to Duty Travel via the module dropdown", "DT opens logged-in; correct nav for your role"),
 ("No session", "Direct open without login", "1. In a fresh private window open the DT URL", "Redirected to Admin login"),
 ("Role gating", "Finance/Admin menus", "1. Compare menus as requester vs finance vs admin", "Finance (disbursement/closure) and Admin (all requests/report) groups only for those roles"),
]),
("Dashboard", "DSH", [
 ("Stats", "Cards + recent requests", "1. Open DT Dashboard", "Cards show counts; recent requests list populated"),
 ("Charts", "Monthly spend + status funnel", "1. Wait for both charts", "12-month advances vs per-diem line + status funnel render with data"),
]),
("My Travel", "TRV", [
 ("My requests", "List + status", "1. Open My Requests", "Your travel requests with destination, dates, amount, status badge"),
 ("Create", "New travel request", "1. New Request: traveller, destination country/city, purpose, dates\n2. Check per-diem auto-calculation\n3. Save draft", "Per-diem computes from country group + grade and nights; draft saved with request number"),
 ("Create", "Advance request", "1. In the request enable/enter a cash advance", "Advance amount validated against policy and stored"),
 ("Validation", "Dates + required fields", "1. Try end date before start date; missing destination", "Clear validation errors; cannot submit"),
 ("Documents", "Attach required docs", "1. Attach the documents required for the destination/type\n2. Try submitting without them", "Missing mandatory docs block submission; with docs it submits"),
 ("Submit", "Send for approval", "1. Submit the draft", "Status pending; appears in approver queue; status history started"),
 ("Detail", "Request detail", "1. Open a request", "Segments, per-diem breakdown, advance, documents, history timeline all visible"),
 ("Settlement", "Create settlement", "1. After a disbursed trip open My Settlements > New\n2. Enter actuals/receipts\n3. Submit", "Settlement created and linked to the request; difference (refund/claim) computed"),
 ("My settlements", "Track settlement status", "1. Open My Settlements", "Settlements with statuses; detail opens"),
]),
("Approvals", "APR", [
 ("Queue", "Pending approvals", "1. As approver open Approvals", "DT items awaiting your step; badge matches"),
 ("Approve / Reject", "Action with comment", "1. Approve one; reject one with reason", "Statuses advance; requester notified; history updated"),
]),
("Finance", "FIN", [
 ("Disbursement queue", "Pay approved advances", "1. As finance open Disbursement Queue\n2. Mark an approved request disbursed", "Request leaves the queue; status DISBURSED; history updated"),
 ("Closure queue", "Close settled trips", "1. Open Closure Queue\n2. Close a fully settled request", "Request closed; removed from open lists"),
 ("All settlements", "Finance settlements view", "1. Open All Settlements", "Org-wide settlements with statuses and amounts"),
]),
("Administration", "ADM", [
 ("All requests", "Paged admin list", "1. Open All Requests\n2. Check pager; search; filter by status", "Org-wide server-paged list; filters work; 'mine' lists elsewhere unaffected"),
 ("Travel report", "Aggregated report", "1. Open Travel Report\n2. Apply period/org filters", "Aggregates (trips, spend, advances) consistent with the lists"),
]),
("Configuration", "CFG", [
 ("Per-diem rates", "Rates by group/grade", "1. Open Per Diem Rates\n2. Edit one rate\n3. Create a new request for that group/grade", "New rate persists and is used in the calculation (restore afterwards)"),
 ("Country groups", "Country assignment", "1. Open Country Groups\n2. Move a country to another group", "Mapping persists; per-diem for that country follows the new group"),
 ("Doc requirements", "Required docs matrix", "1. Open Doc Requirements\n2. Add a required doc for a travel type", "New requirement enforced on the next request of that type (remove afterwards)"),
 ("Approval rules", "DT rules", "1. Open Approval Rules", "Steps/thresholds match the approval template"),
 ("Module settings", "DT settings", "1. Edit a DT module setting and refresh", "Value persists; behaviour/brand follows"),
]),
("Shell & Language", "SHL", [
 ("Switcher", "Cross-module hop", "1. Use the module dropdown to another app and back", "No re-login; DT state intact"),
 ("Arabic", "RTL pass", "1. Switch to AR and walk My Requests + Dashboard", "Mirrored layout, Arabic shell labels, Latin digits, lists load"),
 ("Notifications", "DT notifications", "1. Trigger approval/disbursement events", "Bell shows them; readable detail"),
]),
]

HR = [
("Access & Session", "ACC", [
 ("Shared session", "Entry from Admin", "1. Login in Admin\n2. Switch to HR via the module dropdown", "HR opens logged-in; viewer/manager/admin nav per role"),
 ("No session", "Direct open without login", "1. Fresh private window > HR URL", "Redirected to Admin login"),
]),
("Dashboard", "DSH", [
 ("Stats", "Headcount cards", "1. Open HR Dashboard", "Cards (headcount, vacancies, expiring docs) show live values"),
 ("Charts", "Headcount + expiry horizon", "1. Wait for both charts", "Approved vs filled headcount chart + document expiry horizon chart render"),
]),
("People", "EMP", [
 ("Employees list", "Paged list", "1. Open Employees\n2. Page next/previous", "Employee cards/rows with photo or initials; paging works without losing filters"),
 ("Employees list", "Search + filters", "1. Search by name\n2. Filter by organisation and grade", "Server-side filtering; combined filters work; clear restores"),
 ("Employee detail", "Full record", "1. Open an employee", "Personal, job (position/grade/org), contacts, documents tabs all populated"),
 ("Create", "New employee", "1. New Employee: number, names EN/AR, hire date, position, org, grade\n2. Save", "Employee created and findable; appears in headcount"),
 ("Edit", "Update employee", "1. Edit job title / phone / org\n2. Save and reopen", "Changes persist"),
 ("Photo", "Upload employee photo", "1. In employee detail click photo/upload\n2. Choose an image", "Picker opens; photo saved and shown in list + detail (small file < 20KB if large files fail)"),
 ("Documents", "Add employee document", "1. Add a document (type, number, expiry date) to an employee\n2. Upload the file", "Document listed with expiry; appears in compliance views"),
 ("Org hierarchy", "Org chart", "1. Open Org Hierarchy", "Tree/chart of org units with employees; expand/collapse works"),
]),
("Structure", "STR", [
 ("Positions", "CRUD", "1. Open Positions\n2. Create a position (title, org, grade, headcount)\n3. Edit it\n4. Try assigning an employee to it", "Position created/edited; assignable to employees; filled count updates"),
 ("Jobs", "CRUD", "1. Open Jobs\n2. Create/edit a job", "Job persists; selectable on positions/employees"),
 ("Grades", "List + edit", "1. Open Grades\n2. Edit a grade label", "Grades listed; edit persists; grade dropdowns reflect it"),
 ("Locations", "CRUD", "1. Open Locations\n2. Add/edit a location", "Location persists; selectable on employees/positions"),
]),
("Compliance", "CMP", [
 ("Expiring documents", "Expiry list + badge", "1. Open Documents (compliance)\n2. Compare the side-nav badge number with rows", "Documents expiring within the window listed with days-left; badge matches"),
 ("Document detail", "Navigate to employee", "1. Click an expiring document", "Opens the owning employee's documents tab"),
 ("Renewal", "Update expiry", "1. Update a document's expiry to a future date", "Item leaves the expiring list; badge decreases"),
]),
("Administration", "ADM", [
 ("Lookups", "HR lookup values", "1. Open Lookups\n2. Add/edit a value in an HR category", "Value persists and appears in the matching dropdowns"),
 ("Module settings", "HR settings", "1. Open Module Settings\n2. Edit a value and refresh", "Persists; no errors"),
]),
("Shell & Language", "SHL", [
 ("Switcher", "Cross-module hop", "1. Module dropdown > Admin and back", "No re-login"),
 ("Arabic", "RTL pass", "1. Switch to AR\n2. Walk Employees + Dashboard", "Mirrored layout; Arabic shell; Arabic names display correctly; Latin digits"),
 ("Notifications", "HR notifications", "1. Check the bell after document-expiry alerts run", "Expiry notifications visible and readable"),
]),
]

APPS = [
    ("Admin", "Admin (App 200) — Identity, Users, Roles, Platform Administration", ADMIN),
    ("PC",    "Petty Cash (App 201) — Floats, Reimbursements, Clearing",            PC),
    ("DT",    "Duty Travel (App 204) — Travel Requests, Per-Diem, Settlements",     DT),
    ("HR",    "HR (App 205) — Employees, Structure, Compliance",                    HR),
]

KNOWN_ISSUES = {
    "HR": ["Employees list may show 0 rows even though employees exist in the database — "
           "known issue under investigation; mark affected cases Blocked and note it."],
    "Admin": [],
    "PC": [],
    "DT": [],
}


def style_header(ws, brand):
    fill = PatternFill("solid", fgColor=brand)
    for col, (h, w) in enumerate(zip(HEADERS, WIDTHS), start=1):
        c = ws.cell(row=1, column=col, value=h)
        c.font = Font(bold=True, color="FFFFFF", size=11)
        c.fill = fill
        c.alignment = Alignment(vertical="center", horizontal="center", wrap_text=True)
        c.border = BORDER
        ws.column_dimensions[get_column_letter(col)].width = w
    ws.row_dimensions[1].height = 24
    ws.freeze_panes = "A2"


def build_area_sheet(wb, area, prefix, app_key, cases, brand):
    ws = wb.create_sheet(area[:31])
    style_header(ws, brand)
    r = 2
    for i, (func, scen, steps, exp) in enumerate(cases, start=1):
        tid = "%s-%s-%02d" % (app_key.upper(), prefix, i)
        vals = [tid, func, scen, steps, exp, "", "", "", ""]
        for col, v in enumerate(vals, start=1):
            c = ws.cell(row=r, column=col, value=v)
            c.alignment = Alignment(vertical="top", wrap_text=True,
                                    horizontal="center" if col in (1, 6, 7, 8) else "left")
            c.border = BORDER
            if col == 1:
                c.font = Font(bold=True, color="555555")
        r += 1
    last = r - 1

    dv = DataValidation(type="list", formula1='"Pass,Fail,Blocked,N/A"',
                        allow_blank=True, showDropDown=False)
    dv.error = "Choose Pass, Fail, Blocked or N/A"
    dv.errorTitle = "Invalid status"
    ws.add_data_validation(dv)
    dv.add("F2:F%d" % last)

    rng = "F2:F%d" % last
    ws.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Pass"'],
        fill=PatternFill("solid", fgColor="C8E6C9"), font=Font(color="1B5E20", bold=True)))
    ws.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Fail"'],
        fill=PatternFill("solid", fgColor="FFCDD2"), font=Font(color="B71C1C", bold=True)))
    ws.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"Blocked"'],
        fill=PatternFill("solid", fgColor="FFE0B2"), font=Font(color="E65100", bold=True)))
    ws.conditional_formatting.add(rng, CellIsRule(operator="equal", formula=['"N/A"'],
        fill=PatternFill("solid", fgColor="ECEFF1"), font=Font(color="546E7A")))

    ws.auto_filter.ref = "A1:I%d" % last
    return area, last - 1


def build_instructions(wb, app_key, app_title, areas_counts, brand):
    ws = wb.create_sheet("Instructions", 0)
    ws.sheet_view.showGridLines = False
    ws.column_dimensions["A"].width = 3
    for col, w in zip("BCDEFG", (30, 16, 12, 12, 12, 12)):
        ws.column_dimensions[col].width = w

    ws["B2"] = "i-Finance UAT Script"
    ws["B2"].font = Font(size=18, bold=True, color=brand)
    ws["B3"] = app_title
    ws["B3"].font = Font(size=12, bold=True, color="444444")

    meta = [("Environment URL", "(fill in: e.g. http://localhost:8080 or the deployed URL)"),
            ("Build / version date", "2026-06-11"),
            ("UAT round", ""), ("Lead tester", ""), ("Start date", ""), ("End date", "")]
    r = 5
    for k, v in meta:
        ws.cell(row=r, column=2, value=k).font = Font(bold=True)
        ws.cell(row=r, column=3, value=v)
        ws.merge_cells(start_row=r, start_column=3, end_row=r, end_column=7)
        r += 1

    r += 1
    ws.cell(row=r, column=2, value="How to test").font = Font(size=12, bold=True, color=brand); r += 1
    howto = [
        "1. Each tab is one functional area. Work top-to-bottom; one row = one test case.",
        "2. Follow the Steps column exactly; compare the outcome with Expected Result.",
        "3. Set Status from the dropdown: Pass / Fail / Blocked / N/A.",
        "4. On Fail or Blocked, ALWAYS fill Comments (what happened, screenshots reference, error text).",
        "5. Fill Tested By + Test Date on every executed row.",
        "6. Login accounts: use the quick-login buttons on the login page, or accounts provided by the admin. Never write passwords in this file.",
        "7. Hard-refresh (Ctrl+F5) after the team deploys a fix before retesting.",
    ]
    for line in howto:
        ws.cell(row=r, column=2, value=line); ws.merge_cells(start_row=r, start_column=2, end_row=r, end_column=7); r += 1

    r += 1
    ws.cell(row=r, column=2, value="Status legend").font = Font(size=12, bold=True, color=brand); r += 1
    legend = [("Pass", "C8E6C9", "Works exactly as the Expected Result describes"),
              ("Fail", "FFCDD2", "Does not match the Expected Result (describe in Comments)"),
              ("Blocked", "FFE0B2", "Cannot be executed (missing data/role/dependency failed)"),
              ("N/A", "ECEFF1", "Not applicable to this round/role")]
    for name, color, desc in legend:
        c = ws.cell(row=r, column=2, value=name)
        c.fill = PatternFill("solid", fgColor=color); c.font = Font(bold=True)
        c.border = BORDER
        ws.cell(row=r, column=3, value=desc)
        ws.merge_cells(start_row=r, start_column=3, end_row=r, end_column=7)
        r += 1

    issues = KNOWN_ISSUES.get(app_key, [])
    if issues:
        r += 1
        ws.cell(row=r, column=2, value="Known issues (do not log as new defects)").font = Font(size=12, bold=True, color="B71C1C"); r += 1
        for line in issues:
            ws.cell(row=r, column=2, value="- " + line)
            ws.merge_cells(start_row=r, start_column=2, end_row=r, end_column=7)
            ws.cell(row=r, column=2).alignment = Alignment(wrap_text=True)
            ws.row_dimensions[r].height = 28
            r += 1

    r += 1
    ws.cell(row=r, column=2, value="Live summary").font = Font(size=12, bold=True, color=brand); r += 1
    hdrs = ["Functional area", "Cases", "Pass", "Fail", "Blocked", "Executed %"]
    for col, h in enumerate(hdrs, start=2):
        c = ws.cell(row=r, column=col, value=h)
        c.font = Font(bold=True, color="FFFFFF"); c.fill = PatternFill("solid", fgColor=brand)
        c.border = BORDER
    r += 1
    first_data = r
    for area, n in areas_counts:
        q = "'%s'" % area[:31]
        ws.cell(row=r, column=2, value=area).border = BORDER
        ws.cell(row=r, column=3, value=n).border = BORDER
        ws.cell(row=r, column=4, value='=COUNTIF(%s!F:F,"Pass")' % q).border = BORDER
        ws.cell(row=r, column=5, value='=COUNTIF(%s!F:F,"Fail")' % q).border = BORDER
        ws.cell(row=r, column=6, value='=COUNTIF(%s!F:F,"Blocked")' % q).border = BORDER
        ws.cell(row=r, column=7, value='=ROUND(COUNTA(%s!F2:F500)/C%d*100,0)&"%%"' % (q, r)).border = BORDER
        r += 1
    ws.cell(row=r, column=2, value="TOTAL").font = Font(bold=True)
    for col in range(3, 7):
        L = get_column_letter(col)
        ws.cell(row=r, column=col, value="=SUM(%s%d:%s%d)" % (L, first_data, L, r - 1)).font = Font(bold=True)
        ws.cell(row=r, column=col).border = BORDER
    ws.cell(row=r, column=2).border = BORDER


total_all = 0
for app_key, app_title, areas in APPS:
    wb = Workbook()
    wb.remove(wb.active)
    brand = BRANDS[app_key]
    counts = []
    for area, prefix, cases in areas:
        name, n = build_area_sheet(wb, area, prefix, app_key, cases, brand)
        counts.append((name, n))
    build_instructions(wb, app_key, app_title, counts, brand)
    out_dir = os.path.join(ROOT, app_key, "UAT")
    os.makedirs(out_dir, exist_ok=True)
    out = os.path.join(out_dir, "UAT_%s_TestScript.xlsx" % app_key)
    wb.save(out)
    n_cases = sum(n for _, n in counts)
    total_all += n_cases
    print("%-6s %3d cases, %d areas -> %s" % (app_key, n_cases, len(counts), out))
print("TOTAL  %d test cases" % total_all)
