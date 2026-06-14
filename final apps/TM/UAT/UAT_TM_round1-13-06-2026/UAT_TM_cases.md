# UAT — Task Management (App 207) — Round 1 (13-06-2026)

Scope: first functional acceptance of the TM module (DB + ORDS + JET). Run on the live
dev-proxy with quick-login users. Mark each Actual + PASS/FAIL; capture a screenshot per
case into `evidence_13-Jun-2026/`. (Reusable `TestScript` templates stay at the `UAT/` root;
this round folder holds this case book, the results doc, and the evidence folder.)

| # | ID | Area | Steps | Expected |
|---|----|------|-------|----------|
| 1 | TM-SHL-01 | Shell | Open TM app, log in | Dashboard loads; side logo shows "TM · APP 207"; no console errors |
| 2 | TM-SHL-02 | Switcher | Open module switcher | Task Management (APP 207) listed with teal dot |
| 3 | TM-SHL-03 | i18n | Toggle EN→ع | Labels translate; layout flips RTL |
| 4 | TM-DSH-01 | Dashboard | View KPIs | My Teams / My Open Tasks / Overdue / Open Risks / Deliverables Due render |
| 5 | TM-DSH-02 | Dashboard | View charts | Teams-by-Health doughnut + Teams-by-Class bar render |
| 6 | TM-TEAM-01 | Teams | Click New Team, fill name/type/class/category, Create | Team created (201); appears in grid with code TM-YYYY-NNNNN |
| 7 | TM-TEAM-02 | Teams | Apply type/class/status filters + search | Grid filters correctly |
| 8 | TM-TEAM-03 | Teams | Toggle "My Teams Only" | Shows only teams the user belongs to |
| 9 | TM-TEAM-04 | Teams | Create team with empty name | Blocked with validation message (400) |
| 10 | TM-DET-01 | Detail | Open a team | Overview tab shows objective + counts + RAG |
| 11 | TM-OBJ-01 | Objectives | Add objective (title/status/target) | Objective listed; team objective count +1 |
| 12 | TM-TASK-01 | Tasks | Add task (title/priority/due) | Card appears in TODO column |
| 13 | TM-TASK-02 | Tasks (Kanban) | Drag card TODO→DONE | Status persists; card moves to DONE; team % done updates |
| 14 | TM-TASK-03 | Tasks | Add task with progress 101 (via API) | Rejected 400 (-20001) |
| 15 | TM-DLV-01 | Deliverables | Add deliverable | Listed with type/status/due |
| 16 | TM-RAID-01 | RAID | Add issue/risk with severity | Listed in RAID register |
| 17 | TM-MEM-01 | Members | View members tab | Leader listed with LEADER role |
| 18 | TM-MYW-01 | My Tasks | Open My Tasks | Assigned tasks across all teams listed; overdue flagged |
| 19 | TM-MYW-02 | My Tasks | Mark a task done (✓) | Task status → DONE; row updates |
| 20 | TM-LIB-01 | Documents | Open Documents library | TM documents listed/filterable (empty OK) |
| 21 | TM-RPT-01 | Reports | Open Reports | Team Progress table renders with % done + RAG; 6 report types listed |
| 22 | TM-ROLE-01 | Team Roles | Select a role | Artifact CRUD matrix shows template defaults (✓/·) |
| 23 | TM-PRF-01 | Preferences | Set lead days = 3, save | Saved toast; reload shows 3 |
| 24 | TM-PRF-02 | Preferences | Set lead days = -1, save | Rejected 400 (-20001) |
| 25 | TM-SEC-01 | Security | As MEMBER, attempt role edit (API) | Denied 403 (-20403) |
| 26 | TM-SEC-02 | Security | Call /tm/boot without token | 401 (verified live ✓) |
| 27 | TM-REM-01 | Reminders | Create task due in 2 days; run `dct_tm_reminder_pkg.run_job` | Notification row created for assignee |
| 28 | TM-NOT-01 | Notifications | Open notifications | Bell shows unread; list renders |

**Automation:** mirror the Admin/CC Python UAT runner (see `[[project_automated_uat]]`): case-retry,
proxy GET-retry, route-verify `nav()`. Selector notes from prior rounds apply (input *values* vs
inner_text; `pointer-events:none` on toggles; CSS-uppercased headers).

**Pre-seed suggestion for a clean run:** create 2–3 teams across classes (Strategic/Operational/
Management), each with 3–5 tasks at mixed statuses + 1 overdue, 1 objective, 1 deliverable, 1 risk —
so dashboards/reports/RAG show meaningful data.
