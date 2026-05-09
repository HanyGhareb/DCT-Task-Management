# DCT Task Management — CLAUDE.md

## Project Overview

**i-Finance Task Management** is a weekly task management system for the Finance Division of a government organization. It supports one Finance Director and five Section Managers across five finance sections.

The frontend is pure HTML/CSS/Vanilla JS with no build tools. It currently runs against mock data stored in `localStorage` and is designed to be migrated to an Oracle APEX backend.

---

## Architecture

```
frontend/
  index.html                ← Login / entry point
  pages/
    manager-dashboard.html  ← Section Manager view
    director-dashboard.html ← Finance Director view
  js/
    auth.js                 ← Login, session, role-based redirect
    data.js                 ← DataStore, mock data models, seed data
    utils.js                ← ISO week helpers, date/number formatters
    manager.js              ← Manager dashboard controller
    director.js             ← Director dashboard controller
    charts.js               ← Chart.js wrappers (donut, bar, trend)
  css/
    main.css                ← CSS variables, global layout
    components.css          ← Reusable component styles
    login.css               ← Login page
    manager.css             ← Manager dashboard
    director.css            ← Director dashboard
db/
  v1/
    01_schema_ddl.sql       ← Original Oracle 23ai schema
  v2/
    install.sql             ← Master install script
    01_dct_ddl.sql          ← 24 DCT_* tables, constraints, indexes, triggers
    02_dct_views.sql        ← Utility + backward-compatibility views
    03_dct_auth_pkg.sql     ← DCT_AUTH package
    04_dct_seed.sql         ← Seed data
    05_apex_200_setup.sql   ← APEX App 200 page setup
    05b_apex_200_shared_components.sql ← Auth scheme, app items, auth schemes, processes
    06_dct_notify_pkg.sql   ← DCT_NOTIFY package
    APEX_SETUP.md           ← Manual APEX configuration steps
apex-exports/               ← 31 APEX app zip exports (f100–f9900)
docs/                       ← Analysis, proposals, project plans
myDoc/                      ← Wallet, local setup notes
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

Schema is in `db/v1/01_schema_ddl.sql`. Tables:

- `roles` — app roles
- `users` — user records (no passwords; auth via OCI IAM)
- `user_roles` — time-bounded role assignments
- `tasks` — weekly tasks
- `task_attachments` — file BLOBs
- `task_tags` — free-form tags

Views: `v_user_active_roles`, `v_task_weekly_stats`, `v_manager_overview`

All tables have `created_by/created_at/updated_by/updated_at` audit columns. `updated_at` is maintained by triggers.

---

## i-Finance APEX Ecosystem

The organization runs 31 Oracle APEX applications under the i-Finance platform. Full analysis is in `ifinance-analysis.md`.

**Application groups:**

| Group | Apps |
|---|---|
| Core Platform | f100 (i-finance hub), f910 (i-finance-EX), f9900 (backup), f116 (template) |
| HR & Employee | f102 (HR), f106 (Employee Self Service), f810 (Duty Hub), f901 (HRSS), f101 (Petty Cash), f805 (Freelancers) |
| Budget & Finance | f110 (Budget Allocation), f115 (Budget Planning), f105 (Fund Management), f903 (Budget Transfer) |
| Payments & Procurement | f113 (Payment Requests), f108 (Manual PR), f114 (Manager Checks), f127 (Bank Guarantee), f103/f911 (Credit Cards), f104 (Prepaid Cards), f118 (AR) |
| CWIP | f130 (CWIP Payments Mgmt), f904 (CWIP Dev), f109 (CWIP Payment-Ex), f142 (CWIP Change Mgmt) |
| SCM & Procurement | f124 (Demand Planning), f166 (SMD Form), f313 (SMD Form-Test) |
| Content & Utility | f117 (Documents), f119 (UCM) |

**Key shared database objects (used across multiple apps):**
- `dct_employees` — employee directory, used by nearly all apps
- `employees_v` — employee view, used by most apps
- `dct_data_access_assignment` — access control, used by ~12 apps
- `dct_employees_signatures` — signatures, used by 6 apps
- `dct_lookup_values` — lookup reference data, used by 5 apps

**APEX export location:** `apex-exports/` (31 zip files, f100–f9900)

**V2 Master App design proposal:** `docs/ifinance-v2-proposal.md` — architecture, schema (DCT_* tables), PL/SQL packages, page inventory, security model, and build sequence for the new central auth/admin app (App ID 200).

**V2 Sprint 1 — Database files** (`db/v2/`):

| File | Contents |
|---|---|
| `install.sql` | Master install script — runs all 5 steps in order |
| `01_dct_ddl.sql` | All 24 `DCT_*` tables, constraints, indexes, updated_at triggers |
| `02_dct_views.sql` | 6 utility views + 2 backward-compatibility views (`dct_data_access_assignment`, `roles`) |
| `03_dct_auth_pkg.sql` | `DCT_AUTH` package — authenticate, post_login, has_role, has_permission, session management |
| `04_dct_seed.sql` | 26 modules, 9 roles, 22 permissions, role-permission maps, system settings, lookup values, Finance Division org hierarchy, default ADMIN user |
| `05_apex_200_setup.sql` | APEX App 200 page-level setup |
| `05b_apex_200_shared_components.sql` | Auth scheme, 14 app items, 7 authorization schemes, 2 global processes |
| `06_dct_notify_pkg.sql` | `DCT_NOTIFY` package — notification count, send, mark read, purge |
| `APEX_SETUP.md` | Step-by-step APEX App 200 configuration: auth scheme, app items, authorization schemes, navigation, page queries |

---

## Development Notes

- **No build step.** Open `frontend/index.html` in a browser or serve via any static file server.
- **Reseed data:** Clear `localStorage` in DevTools to reset to fresh mock data.
- **Quick login:** Use the preset buttons on the login page to switch between roles.
- **Chart.js & Font Awesome** are loaded from CDN — internet access required in dev.
- **Oracle APEX migration** is tracked in `docs/i-Finance-APEX-Project-Plan.html`. The JS controllers are designed so data calls can be swapped from `DataStore` to REST API calls without restructuring the controllers.
- **APEX applications analysis** is in `docs/ifinance-analysis.md` — covers all 31 apps, their functions, pages, and database objects.

---

## Conventions

- Global controller objects: `Manager`, `Director`, `Auth`, `DataStore`, `Charts`, `Utils`
- CSS custom properties defined in `frontend/css/main.css` under `:root`
- Status/priority values are uppercase string constants — match them exactly when filtering
- ISO week calculation: use `Utils.getISOWeek()` and `Utils.getWeekDates()` — do not reimplement
- Avoid introducing `npm`, build tools, or frameworks unless the user explicitly requests it
