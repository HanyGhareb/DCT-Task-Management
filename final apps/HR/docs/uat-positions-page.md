# UAT Test Script — Positions & Headcount Page

**Application:** i-Finance HR Module (Oracle JET SPA)
**URL:** `http://localhost:8081/index.html` → navigate to Positions
**Tester:** ___________________
**Date:** ___________________
**Build / Commit:** ___________________

---

## Preconditions

| # | Condition |
|---|---|
| P1 | HTTP server is running on port 8081 serving `final apps/HR/Jet/` |
| P2 | A valid admin session is active (login as ADMIN or use quick-login) |
| P3 | At least one position record exists in the database |
| P4 | Browser DevTools Console is open and visible throughout testing |

---

## TC-POS-01 — Page Load & Initial Render

**Objective:** Verify the page loads correctly and all structural elements are present.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Navigate to the Positions page from the sidebar | Page transitions without a full reload | | | |
| 2 | Observe the page title | Title reads **"Positions & Headcount"** | | | |
| 3 | Observe the page subtitle below the title | Shows **"X position(s) shown"** where X matches the row count | | | |
| 4 | Observe the stats row (three cards) | Three stat cards are visible: **Approved HC**, **Filled**, **Vacancies** | | | |
| 5 | Verify stats cards show numbers (not dashes or zeros that flash) | Stats values are numeric and stable — they appear only after data loads, not as 0 while loading | | | |
| 6 | Observe the data table | Table renders with correct column headers: Position, Section, Job, Grade, Type, Approved, Filled, Fill Rate, Vacancies, (actions) | | | |
| 7 | Check the DevTools Console | **Zero errors** in the console | | | |

---

## TC-POS-02 — Stats Cards Accuracy

**Objective:** Verify the three KPI numbers are mathematically correct.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Note the **Approved HC** value from the stats card | — | | | |
| 2 | Manually sum the **Approved** column for all visible rows | Sum equals the Approved HC card value | | | |
| 3 | Note the **Filled** value from the stats card | — | | | |
| 4 | Manually sum the **Filled** column for all visible rows | Sum equals the Filled card value | | | |
| 5 | Note the **Vacancies** value from the stats card | — | | | |
| 6 | Verify: Vacancies = Approved HC − Filled | Math is correct | | | |

---

## TC-POS-03 — Sort Columns

**Objective:** Verify all six sortable column headers respond to clicks with correct indicator and row reordering.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Click the **Position** column header | Rows sort A→Z by position name; ▲ indicator appears on header | | | |
| 2 | Click **Position** header again | Rows sort Z→A; indicator changes to ▼ | | | |
| 3 | Click **Section** column header | Rows sort A→Z by section name; ▲ appears on Section, indicator clears from Position | | | |
| 4 | Click **Section** header again | Rows sort Z→A; ▼ appears | | | |
| 5 | Click **Grade** column header | Rows sort A→Z by grade code | | | |
| 6 | Click **Grade** header again | Rows sort Z→A | | | |
| 7 | Click **Approved** column header | Rows sort lowest→highest approved headcount | | | |
| 8 | Click **Approved** header again | Rows sort highest→lowest | | | |
| 9 | Click **Filled** column header | Rows sort lowest→highest filled count | | | |
| 10 | Click **Filled** header again | Rows sort highest→lowest | | | |
| 11 | Click **Vacancies** column header | Rows sort lowest→highest vacancy count | | | |
| 12 | Click **Vacancies** header again | Rows sort highest→lowest | | | |
| 13 | Verify only one column has an active sort indicator at any time | All other column indicators are neutral (↕ or hidden) | | | |

---

## TC-POS-04 — Search Filter

**Objective:** Verify the search box filters rows in real time.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Type the first three characters of a known position name into the search box | Table rows filter in real time to matching positions only; subtitle updates | | | |
| 2 | Type a position code that exists (e.g., `FIN-`) | Rows matching that code pattern appear | | | |
| 3 | Type a string that matches nothing (e.g., `ZZZZZ`) | Table shows empty state: "No positions found" | | | |
| 4 | Clear the search box | All rows return; subtitle reverts to full count | | | |
| 5 | Verify the **Clear Filters** button appears while text is in the search box | Button labelled "✕ Clear Filters" is visible in the toolbar | | | |
| 6 | Verify **Clear Filters** disappears when search is empty | Button is hidden | | | |

---

## TC-POS-05 — Section Filter

**Objective:** Verify the Section dropdown filters rows to a single org unit.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Open the **Section** dropdown | Dropdown lists "All Sections" plus each org unit that has positions | | | |
| 2 | Select a specific section | Table shows only positions belonging to that section | | | |
| 3 | Verify the subtitle count updates | Subtitle reflects the filtered count | | | |
| 4 | Select **"All Sections"** | All positions return | | | |

---

## TC-POS-06 — Vacancy Filter

**Objective:** Verify the vacancy status dropdown filters correctly.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Select **"Has Vacancies"** from the vacancy dropdown | Only positions with `vacancyCount > 0` are shown | | | |
| 2 | Select **"Fully Staffed"** | Only positions with `vacancyCount ≤ 0` are shown | | | |
| 3 | Select **"All"** | All positions return | | | |

---

## TC-POS-07 — Combined Filters + Clear Filters

**Objective:** Verify filters combine correctly and Clear Filters resets all at once.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Select a Section AND type a search term | Table applies both filters simultaneously | | | |
| 2 | Observe the **Clear Filters** button | Button is visible | | | |
| 3 | Click **✕ Clear Filters** | Search box empties, Section resets to "All Sections", Vacancy resets to "All"; all rows return | | | |
| 4 | Verify **Clear Filters** button is now hidden | Button disappears | | | |

---

## TC-POS-08 — Fill Rate Color Coding

**Objective:** Verify the fill-rate progress bar uses the correct color tier based on the fill percentage.

### How Fill Rate Is Calculated

`filled_count` is **not a field you set on the position**. It is computed live by the database view `v_hr_headcount` by counting employee assignment records that meet all three conditions:

```
HR_EMPLOYEE_ASSIGNMENTS
  WHERE assignment_status = 'ACTIVE'
    AND is_primary         = 'Y'
    AND end_date           IS NULL
    AND position_id        = <this position>
```

In other words, **a position's filled count equals the number of active employees currently assigned to it as their primary position with no end date.**

`vacancy_count = approved_headcount − filled_count` (can go negative if overstaffed).

**Formula displayed on screen:** `Fill % = round( filled_count ÷ approved_headcount × 100 )`

---

### Color Thresholds

| Fill % Range | Bar Color | CSS Class |
|---|---|---|
| 80% – 100% | Green | `progress-bar-fill--green` |
| 50% – 79% | Orange | `progress-bar-fill--orange` |
| 0% – 49% | Red | `progress-bar-fill--red` |

---

### How to Set Up Each Color Tier for Testing

You cannot set `filled_count` directly. Use one of the two approaches below:

**Option A — Adjust `approved_headcount` on an existing position (easiest)**

If a position already has, say, 1 active employee assigned to it:

| Target Color | Set Approved HC to | Result |
|---|---|---|
| Green | 1 (same as filled) | 1÷1 = 100% → green |
| Orange | 2 | 1÷2 = 50% → orange |
| Red | 3 or more | 1÷3 = 33% → red |

Edit the position via the Edit modal → change **Approved Headcount** → Save.

**Option B — Assign employees to a position via the Employees page**

1. Navigate to the Employees page.
2. Open Edit for an employee.
3. In the **Assignment** section, set **Position** to the target position, **Status = Active**, **Primary = Yes**, leave **End Date** blank.
4. Save. The position's `filled_count` increments by 1 immediately on next page load.

---

### Reference Combinations

| Scenario | Approved HC | Active Assignments | Fill % | Expected Color |
|---|---|---|---|---|
| Fully staffed | 3 | 3 | 100% | Green |
| Near full | 5 | 4 | 80% | Green |
| Boundary — orange/green | 10 | 8 | 80% | Green |
| Mid-range | 10 | 6 | 60% | Orange |
| Boundary — orange floor | 4 | 2 | 50% | Orange |
| Under-staffed | 4 | 1 | 25% | Red |
| Unfilled | 2 | 0 | 0% | Red |
| No HC set | 0 | 0 | 0% (guard) | Red |

---

### Test Steps

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Using Option A or B above, arrange a position so that `filled ÷ approved ≥ 80%` | — | | | |
| 2 | Navigate to the Positions page and locate that position | Progress bar renders in **green** | | | |
| 3 | Verify the percentage label beside the bar | Shows the correct `%` value matching the formula | | | |
| 4 | Arrange a position so that `50% ≤ filled ÷ approved < 80%` | — | | | |
| 5 | Locate that position on the Positions page | Progress bar renders in **orange** | | | |
| 6 | Verify the **boundary at exactly 50%** (e.g., Approved=4, Filled=2) | Bar is **orange** (50% is inclusive to the orange tier) | | | |
| 7 | Arrange a position with `filled ÷ approved < 50%` (or zero filled) | — | | | |
| 8 | Locate that position on the Positions page | Progress bar renders in **red** | | | |
| 9 | Inspect the bar element in DevTools (Elements tab → find `<div>` inside `.progress-bar-wrap`) | `class` attribute contains `progress-bar-fill--green`, `--orange`, or `--red` as appropriate | | | |
| 10 | Verify bar **width** visually matches the percentage | A 60% bar occupies roughly 60% of the grey track behind it | | | |

---

## TC-POS-09 — Vacancy Urgency Badge

**Objective:** Verify the vacancy badge escalates to red when vacancies are critically high.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Find a position with `vacancyCount = 0` | Badge is **green** ("Filled") | | | |
| 2 | Find a position with `vacancyCount > 0` but `≤ approvedHeadcount / 2` | Badge is **amber/warning** | | | |
| 3 | Find a position with `vacancyCount > approvedHeadcount / 2` (e.g., Approved=4, Vacancies=3) | Badge is **red/danger** | | | |

---

## TC-POS-10 — Position Type Badge

**Objective:** Verify the Type column renders with the correct badge color per type.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Find a position with type `PERMANENT` | Type cell shows badge "PERMANENT" in **blue** | | | |
| 2 | Find a position with type `CONTRACT` | Badge shows "CONTRACT" in **amber** | | | |
| 3 | Find a position with type `TEMPORARY` | Badge shows "TEMPORARY" in **purple** | | | |
| 4 | Find a position with no type set | Type cell shows "—" with no badge | | | |

---

## TC-POS-11 — Clickable Rows (Navigate to Employees)

**Objective:** Verify clicking a table row navigates to the Employees page filtered by that position.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Click anywhere on a table row (not on the Edit button) | Page navigates to the **Employees** module | | | |
| 2 | Verify the click does **not** fire when clicking the Edit button within the row | Only the Edit modal opens; no navigation | | | |

---

## TC-POS-12 — Add Position Modal

**Objective:** Verify the Add Position modal opens correctly and all fields are present.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Click **"+ Add Position"** button | Modal appears; backdrop dims the page; modal title reads **"Add Position"** | | | |
| 2 | Verify no error banner is visible on open | The red error banner is hidden by default | | | |
| 3 | Verify the **Position Code** field is editable (not disabled) | Field accepts input | | | |
| 4 | Verify **Position Name (EN)** field | Text input is present and editable | | | |
| 5 | Verify **Position Name (AR)** field | Text input with `dir="rtl"` is present | | | |
| 6 | Verify **Job** field | Dropdown with at least one job option | | | |
| 7 | Verify **Section** field | Dropdown with org units listed | | | |
| 8 | Verify **Grade** field | **Dropdown** (not a text input); options include "— No Grade —" plus grade codes | | | |
| 9 | Verify **Position Type** field | Dropdown with three options: Permanent, Contract, Temporary | | | |
| 10 | Verify **Approved Headcount** field | Numeric input, default value is `1` | | | |
| 11 | Verify **Status** field | Dropdown with Active / Inactive; default is Active | | | |
| 12 | Verify the Save button text | Button reads **"Save Position"** | | | |

---

## TC-POS-13 — Add Position Validation

**Objective:** Verify required-field validation fires before save.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Open Add Position modal; click **Save Position** immediately with all fields empty | Red error banner appears: **"Position Name (EN) is required."** | | | |
| 2 | Fill in Position Name (EN); leave Position Code blank; click Save | Error: **"Position Code is required."** | | | |
| 3 | Fill in Position Code; leave Job blank; click Save | Error: **"Job is required."** | | | |
| 4 | Select a Job; leave Section blank; click Save | Error: **"Section is required."** | | | |
| 5 | Verify the error banner is cleared when a new save attempt begins | Error resets on each save click | | | |

---

## TC-POS-14 — Add Position — Successful Save

**Objective:** Verify a valid position can be created.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Open Add Position modal | — | | | |
| 2 | Fill in all required fields: Position Code `TEST-001`, Name (EN) `Test Position`, Job (any), Section (any) | — | | | |
| 3 | Set Type to **Contract**, Grade to any grade, Headcount to `3` | — | | | |
| 4 | Click **Save Position** | Button briefly shows **"Saving…"** (if ORDS is slow), then modal closes | | | |
| 5 | Observe the page | Green success banner: **"Position added."** | | | |
| 6 | Observe the table | New position `TEST-001` appears in the list | | | |
| 7 | Observe the stats cards | Approved HC increases by 3 | | | |
| 8 | Verify the banner auto-dismisses after 4 seconds | Banner disappears without any user action | | | |

---

## TC-POS-15 — Edit Position Modal

**Objective:** Verify the Edit modal pre-populates all fields correctly.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Click **Edit** on a known position row | Edit modal opens; title reads **"Edit Position"** | | | |
| 2 | Verify **Position Code** field | Shows the existing code and is **disabled** (cannot be edited) | | | |
| 3 | Verify **Position Name (EN)** | Pre-filled with existing English name | | | |
| 4 | Verify **Position Name (AR)** | Pre-filled with existing Arabic name (if set) | | | |
| 5 | Verify **Job** dropdown | Shows the currently assigned job | | | |
| 6 | Verify **Section** dropdown | Shows the currently assigned section | | | |
| 7 | Verify **Grade** dropdown | Shows the current grade (or "— No Grade —" if unset) | | | |
| 8 | Verify **Position Type** dropdown | Shows the current type (e.g., PERMANENT) | | | |
| 9 | Verify **Approved Headcount** | Shows the existing headcount number | | | |
| 10 | Verify **Status** dropdown | Shows Active or Inactive per current record | | | |

---

## TC-POS-16 — Edit Position — Successful Update

**Objective:** Verify a position can be modified and the change reflects in the table.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Open Edit for the `TEST-001` position created in TC-POS-14 | Modal pre-filled | | | |
| 2 | Change the Position Name (EN) to `Test Position Updated` | Field updates | | | |
| 3 | Change Approved Headcount to `5` | Field updates | | | |
| 4 | Click **Save Position** | Modal closes; green banner: **"Position updated."** | | | |
| 5 | Find `TEST-001` in the table | Name now shows `Test Position Updated`; Approved column shows `5` | | | |
| 6 | Verify stats cards updated | Approved HC increased by 2 (from 3 to 5 for this record) | | | |

---

## TC-POS-17 — ESC Key Closes Modal

**Objective:** Verify pressing Escape dismisses the modal without saving.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Open **Add Position** modal | Modal visible | | | |
| 2 | Type some text into Position Name (EN) | — | | | |
| 3 | Press **Escape** | Modal closes; no position was created; page content is interactive (not covered by backdrop) | | | |
| 4 | Open **Edit** modal for any position | Modal visible | | | |
| 5 | Press **Escape** | Modal closes | | | |

---

## TC-POS-18 — Close Modal via Cancel / × Button

**Objective:** Verify the Cancel button and × close button dismiss the modal.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Open Add Position modal; click **Cancel** | Modal closes | | | |
| 2 | Open Add Position modal; click the **×** button in the modal header | Modal closes | | | |
| 3 | Open Add Position modal; click the **dim backdrop** area outside the modal box | Modal closes | | | |

---

## TC-POS-19 — Export CSV

**Objective:** Verify the Export CSV button downloads a file with correct data.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | With all filters cleared, click **Export CSV** | Browser downloads a file named `positions.csv` | | | |
| 2 | Open the downloaded file in Excel or a text editor | File opens correctly; no encoding errors; first row is the header row | | | |
| 3 | Verify header row contains: `Position Code, Position Name EN, Position Name AR, Job, Section, Grade, Type, Approved HC, Filled, Vacancies, Fill %, Status` | All 12 columns present | | | |
| 4 | Verify row count (excluding header) matches the page subtitle count | Counts match | | | |
| 5 | Verify a known position's data in the CSV | Code, names, job, section, grade, type, numbers, and status all correct | | | |
| 6 | Apply a filter (e.g., select a Section); click **Export CSV** | Exported file contains only the filtered rows, not all positions | | | |

---

## TC-POS-20 — Loading State

**Objective:** Verify the page shows a loading indicator and hides stats while data is fetching.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Using DevTools Network tab, throttle to **Slow 3G** | — | | | |
| 2 | Navigate to the Positions page | Loading indicator (clipboard icon + "Loading…") appears; stats cards are **not visible** during load | | | |
| 3 | Wait for data to finish loading | Stats cards appear; loading indicator disappears; table renders | | | |
| 4 | Restore network speed to Normal | — | | | |

---

## TC-POS-21 — Error State

**Objective:** Verify an API error is surfaced gracefully.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Using DevTools Network tab, block requests to the ORDS host | — | | | |
| 2 | Navigate to the Positions page | Red error banner appears with a meaningful message (not a raw exception) | | | |
| 3 | Table is empty; stats cards are not shown | — | | | |
| 4 | Restore network; refresh/re-navigate | Page loads normally | | | |

---

## TC-POS-22 — Role-Based Visibility

**Objective:** Verify Add/Edit controls are hidden for users without admin or manager role.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Log in as a user with only a **read-only** role (no HR_ADMIN or HR_MANAGER) | — | | | |
| 2 | Navigate to Positions | Page loads normally | | | |
| 3 | Observe the page header | **"+ Add Position"** button is **not visible** | | | |
| 4 | Observe each table row | **Edit** button is **not visible** in any row | | | |
| 5 | Log back in as ADMIN | Add and Edit controls reappear | | | |

---

## TC-POS-23 — Regression: Employees Page Unaffected

**Objective:** Confirm changes to Positions did not break the Employee Directory.

| Step | Action | Expected Result | Pass | Fail | Notes |
|---|---|---|---|---|---|
| 1 | Navigate to **Employees** from the sidebar | Employee Directory loads normally | | | |
| 2 | Open Add Employee modal | Modal opens cleanly; no broken rendering | | | |
| 3 | Press ESC | Modal closes | | | |
| 4 | Click a column sort header | Sort works | | | |
| 5 | Check DevTools console | Zero errors | | | |

---

## Summary Sign-off

| Category | Test Cases | Pass | Fail | Blocked |
|---|---|---|---|---|
| Page Load & Stats | TC-01, TC-02 | | | |
| Sorting | TC-03 | | | |
| Filters | TC-04, TC-05, TC-06, TC-07 | | | |
| Visual Indicators | TC-08, TC-09, TC-10 | | | |
| Navigation | TC-11 | | | |
| Add Position | TC-12, TC-13, TC-14 | | | |
| Edit Position | TC-15, TC-16 | | | |
| Modal Controls | TC-17, TC-18 | | | |
| Export | TC-19 | | | |
| Edge Cases | TC-20, TC-21, TC-22 | | | |
| Regression | TC-23 | | | |
| **Total** | **23** | | | |

**Overall Result:** PASS / FAIL / CONDITIONAL PASS

**Tester sign-off:** ___________________
**Date:** ___________________
**Defects raised:** ___________________
