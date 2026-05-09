# DCT Task Management — CLAUDE.md

## Project Overview

**i-Finance Task Management** is a weekly task management system for the Finance Division of a government organization. It supports one Finance Director and five Section Managers across five finance sections.

The frontend is pure HTML/CSS/Vanilla JS with no build tools. It currently runs against mock data stored in `localStorage` and is designed to be migrated to an Oracle APEX backend.

---

## Architecture

```
index.html                  ← Login / entry point
pages/
  manager-dashboard.html    ← Section Manager view
  director-dashboard.html   ← Finance Director view
js/
  auth.js                   ← Login, session, role-based redirect
  data.js                   ← DataStore, mock data models, seed data
  utils.js                  ← ISO week helpers, date/number formatters
  manager.js                ← Manager dashboard controller (~589 lines)
  director.js               ← Director dashboard controller (~706 lines)
  charts.js                 ← Chart.js wrappers (donut, bar, trend)
css/
  main.css                  ← CSS variables, global layout
  components.css            ← Reusable component styles
  login.css                 ← Login page
  manager.css               ← Manager dashboard
  director.css              ← Director dashboard
db/
  01_schema_ddl.sql         ← Oracle 23ai schema (tables, views, triggers)
```

**Pattern:** MVC-like. `manager.js` and `director.js` are controllers that call `DataStore` for data and `Charts` for rendering. No framework — everything is object literals or plain functions on `window`.

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | HTML5, CSS3 (Grid/Flexbox, custom properties) |
| Logic | Vanilla JavaScript ES6+ |
| Charts | Chart.js (CDN) |
| Icons | Font Awesome 6.5.0 (CDN) |
| Fonts | Google Fonts — Inter |
| Storage (dev) | `localStorage` |
| Database (prod) | Oracle Database 23ai |
| Backend (planned) | Oracle APEX / REST API |
| Auth (planned) | OCI IAM |

No `package.json`, no bundler, no transpilation. Open `index.html` directly in a browser.

---

## Users & Roles

Two roles exist: `DIRECTOR` and `MANAGER`.

| Role | User | Section |
|---|---|---|
| Director | Hashem Al Kabbi | Finance Division |
| Manager | Naser Mohamed Al Khaja | Finance Operations |
| Manager | Ayesha Abdul Kareem Ameri | Payables Operations |
| Manager | Shaikha Ghanem Al Ameri | Financial Planning & Budgeting |
| Manager | Shaikha Ahmed Al Suwaidi | Revenue Assurance |
| Manager | Noora Saeed Al Ali | Receivables Operations |

Login is handled by `auth.js`. Quick-login buttons on the login page seed a session in `localStorage`. Role determines which dashboard the user is redirected to.

---

## Data Model (JavaScript)

Defined in `js/data.js`. `DataStore` reads/writes `localStorage`.

**Task fields:** `id`, `title`, `description`, `category`, `status`, `priority`, `startDate`, `dueDate`, `completionPercent`, `nextAction`, `nextActionDate`, `assignedTo` (user id), `weekNumber`, `year`, `attachments[]`, `tags[]`, `notes`, `createdAt`, `updatedAt`

**Task statuses:** `NOT_STARTED`, `IN_PROGRESS`, `COMPLETED`, `DELAYED`, `BLOCKED`

**Priorities:** `HIGH`, `MEDIUM`, `LOW`

**Categories (13):** Budget Review, Financial Report, Vendor Payment, Audit & Compliance, Treasury Management, Cash Flow Analysis, Financial Forecast, Meeting & Communication, System & Process, Payroll Processing, Reconciliation, Risk Assessment, Other

**Auto-sync rule:** Setting `completionPercent` to 0 → `NOT_STARTED`; 100 → `COMPLETED`. Status changes to `IN_PROGRESS` when progress is 1–99.

---

## Key Behaviors

- **Week navigation:** Both dashboards use ISO week numbers (`utils.js`). Users can browse historical weeks. Current week is the default.
- **EOW alert:** A banner appears on the last working day of the week to remind managers of the deadline.
- **6-week trend:** Charts show completion rates for the past 6 weeks.
- **Director drill-down:** Clicking a KPI card or manager card opens a modal filtered to that manager's tasks.
- **File attachments:** Drag-and-drop, max 2 MB each, stored as base64 in `localStorage` for now. DB schema uses BLOB.
- **Toast/Confirm:** `Toast` and `Confirm` are global helpers for notifications and destructive-action dialogs.

---

## Database (Oracle 23ai)

Schema is in `db/01_schema_ddl.sql`. Tables:

- `roles` — app roles
- `users` — user records (no passwords; auth via OCI IAM)
- `user_roles` — time-bounded role assignments
- `tasks` — weekly tasks
- `task_attachments` — file BLOBs
- `task_tags` — free-form tags

Views: `v_user_active_roles`, `v_task_weekly_stats`, `v_manager_overview`

All tables have `created_by/created_at/updated_by/updated_at` audit columns. `updated_at` is maintained by triggers.

---

## Development Notes

- **No build step.** Open `index.html` in a browser or serve via any static file server.
- **Reseed data:** Clear `localStorage` in DevTools to reset to fresh mock data.
- **Quick login:** Use the preset buttons on the login page to switch between roles.
- **Chart.js & Font Awesome** are loaded from CDN — internet access required in dev.
- **Oracle APEX migration** is tracked in `i-Finance-APEX-Project-Plan.html`. The JS controllers are designed so data calls can be swapped from `DataStore` to REST API calls without restructuring the controllers.

---

## Conventions

- Global controller objects: `Manager`, `Director`, `Auth`, `DataStore`, `Charts`, `Utils`
- CSS custom properties defined in `css/main.css` under `:root`
- Status/priority values are uppercase string constants — match them exactly when filtering
- ISO week calculation: use `Utils.getISOWeek()` and `Utils.getWeekDates()` — do not reimplement
- Avoid introducing `npm`, build tools, or frameworks unless the user explicitly requests it
