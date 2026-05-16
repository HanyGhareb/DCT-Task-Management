# Oracle JET — Admin Module Implementation Plan
**App:** i-Finance V2 Admin (App 200 equivalent) | **Framework:** Oracle JET 17 (CDN) | **Date:** 2026-05-16

---

## What we're building

A browser-open **SPA** in Oracle JET that replicates every page of APEX App 200, allowing side-by-side comparison of UX, speed, and code approach. No build step — served from any static web server.

> **To run:** `python -m http.server 8080` inside this folder, then open `http://localhost:8080`

---

## Technology Choices

| Layer | APEX App 200 | Oracle JET Version |
|---|---|---|
| UI Framework | Universal Theme 42 (Redwood Light) | JET 17 Redwood Design System (CDN) |
| State binding | APEX session items / bind items | KnockoutJS observables (JET default) |
| Module loading | Server-side page navigation | RequireJS AMD + `oj-module` router |
| Tables / Reports | Interactive Report (server-side) | `oj-table` + `ArrayDataProvider` (client-side instant) |
| Forms | APEX form regions | `oj-form-layout` + `oj-input-text`, `oj-select-single` |
| Dialogs | APEX modal dialog | `oj-dialog` |
| Charts | N/A in admin | `oj-chart` |
| Auth | `dct_auth.authenticate` PL/SQL | Mirror in `authService.js` (localStorage mock → ORDS-ready) |
| Data | Oracle DB via APEX processes | Mock JSON in `mockData.js` → production uses ORDS REST |

---

## Folder Structure

```
Jet/
├── PLAN.md                         ← This file
├── index.html                      ← App shell (header, nav, oj-module outlet)
├── css/
│   └── app.css                     ← Shell layout + brand overrides
└── js/
    ├── main.js                     ← RequireJS config + bootstrap
    ├── mockData.js                 ← Shared mock data (mirrors DCT_* tables)
    ├── appController.js            ← Root ViewModel: router, nav, user state
    ├── services/
    │   ├── authService.js          ← Login / logout / session guard
    │   ├── userService.js          ← Users CRUD
    │   ├── roleService.js          ← Roles & permissions CRUD
    │   ├── moduleService.js        ← Module registry
    │   ├── notificationService.js  ← Notifications
    │   ├── settingService.js       ← System settings & lookups
    │   ├── orgService.js           ← Org hierarchy
    │   └── auditService.js         ← Audit log / sessions / login history
    ├── viewModels/                 ← One .js per page
    │   ├── login.js
    │   ├── dashboard.js            ← Home / App Launcher (APEX P1)
    │   ├── profile.js              ← My Profile (APEX P2)
    │   ├── notifications.js        ← Notifications (APEX P4)
    │   ├── pendingApprovals.js     ← Pending Approvals (APEX P6)
    │   ├── users.js                ← Users list (APEX P10)
    │   ├── userEdit.js             ← User form (APEX P11)
    │   ├── roles.js                ← Roles list (APEX P20)
    │   ├── roleEdit.js             ← Role form (APEX P21)
    │   ├── permissions.js          ← Permission matrix (APEX P24)
    │   ├── orgHierarchy.js         ← Org tree (APEX P30)
    │   ├── modules.js              ← Module registry (APEX P40)
    │   ├── approvalTemplates.js    ← Templates (APEX P50)
    │   ├── approvalMonitor.js      ← Monitor (APEX P55)
    │   ├── lookups.js              ← Lookups (APEX P60)
    │   ├── systemSettings.js       ← Settings (APEX P70)
    │   └── auditLog.js             ← Audit + sessions + history (APEX P80-83)
    └── views/                      ← HTML fragments for each ViewModel
        └── (same names as viewModels, .html extension)
```

---

## Page-by-Page Mapping

| APEX Page | Title | JET View | Key JET Components |
|---|---|---|---|
| 9999 | Login | `login` | `oj-form-layout`, `oj-input-text`, `oj-input-password`, `oj-button` |
| 1 | Home / App Launcher | `dashboard` | `oj-card`, `oj-avatar`, `oj-badge`, CSS Grid |
| 2 | My Profile | `profile` | `oj-form-layout`, `oj-avatar`, `oj-input-text` |
| 4 | Notifications | `notifications` | `oj-list-view`, `oj-badge`, filter buttons |
| 6 | Pending Approvals | `pendingApprovals` | `oj-table`, `oj-progress-bar` |
| 10 | Users | `users` | `oj-table`, `oj-toolbar`, `oj-search-field` — **instant client-side filter** |
| 11 | User Edit | `userEdit` | `oj-form-layout`, `oj-select-single`, `oj-switch`, `oj-checkboxset` |
| 20 | Roles | `roles` | `oj-table`, `oj-badge` |
| 21 | Role Edit | `roleEdit` | `oj-form-layout`, `oj-checkboxset` (permission matrix) |
| 24 | Permissions | `permissions` | `oj-table` (role × permission grid) |
| 30 | Org Hierarchy | `orgHierarchy` | `oj-tree-view` |
| 40 | Module Registry | `modules` | `oj-card` grid, `oj-dialog` |
| 50 | Approval Templates | `approvalTemplates` | `oj-table`, step editor `oj-dialog` |
| 55 | Approval Monitor | `approvalMonitor` | `oj-table`, `oj-progress-bar`, status `oj-badge` |
| 60 | Lookups | `lookups` | `oj-table`, `oj-select-single` (type filter) |
| 70 | System Settings | `systemSettings` | `oj-list-item-layout`, key-value form |
| 80-83 | Audit / Sessions / History | `auditLog` | `oj-tab-bar`, `oj-table`, `oj-input-date-range` |

---

## Implementation Phases

| Phase | Scope |
|---|---|
| 1 | Shell + router + nav (`index.html`, `main.js`, `appController.js`, `app.css`) |
| 2 | Auth (`login` view + `authService.js` + session guard) |
| 3 | App Launcher (`dashboard` — module cards, announcement banner) |
| 4 | User Management (`users` + `userEdit` + `userService.js` — full CRUD, instant search) |
| 5 | Role & Permissions (`roles` + `roleEdit` + `permissions` + `roleService.js`) |
| 6 | Org & Modules (`orgHierarchy` tree + `modules` card grid) |
| 7 | Approval Workflow (`approvalTemplates` + `approvalMonitor`) |
| 8 | System Admin (`lookups` + `systemSettings` + `auditLog` with tabs) |
| 9 | User Workspace (`profile` + `notifications` + `pendingApprovals`) |

---

## Key Differences the Client Will See

| Aspect | APEX App 200 | Oracle JET |
|---|---|---|
| **Navigation** | Full page reload between pages | Instant SPA route change (no reload) |
| **Table filtering** | Server round-trip (AJAX region) | Client-side, instant as-you-type |
| **Form validation** | APEX server-side validation | Inline KO observable validation, real-time |
| **Customisation** | Config-driven (low code) | Full HTML/CSS/JS control |
| **Mobile / PWA** | Responsive | Responsive + offline PWA possible |
| **Theming** | Redwood via APEX Theme Roller | Redwood CSS variables, full override |
| **Deployment** | Requires APEX + Oracle DB running | Static files + ORDS endpoint |
| **Code ownership** | Oracle APEX platform | Standard JS — portable to any stack |

---

## Production API Layer (ORDS)

Each service file documents the ORDS endpoint it would call in production. Example from `userService.js`:

```javascript
// Production: GET /ords/prod/dct/users/
// Mock: returns MOCK_USERS from mockData.js
```

Enable ORDS REST on DCT_USERS: `ORDS.ENABLE_OBJECT(p_object => 'DCT_USERS');`
