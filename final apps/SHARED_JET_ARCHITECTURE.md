# i-Finance JET SPA Shared Architecture
**Applies to:** All module JET apps (App 201, 204 …) | **Authority app:** Admin JET (App 200) | **Date:** 2026-05-17

---

## Core Principle

**Admin JET (App 200) is the identity provider for the entire i-Finance platform.**

When a user logs in via the Admin app, their identity, roles, and permissions are established and stored in a shared `localStorage` session. Every other module JET app (PC, DT, CC, HR …) reads that same session — no second login, no separate authentication.

```
User opens browser
    ↓
Admin JET (App 200) → authenticates → stores ifinance_jet_session
    ↓
User navigates to any module app (PC, DT, CC …)
    ↓
Module app reads ifinance_jet_session → already knows who you are + roles
    ↓
No second login. Module app calls its own ORDS module with the shared token.
```

---

## Session Contract

### Shared localStorage Key
All JET apps (Admin + every module) use the **same key**:

```
ifinance_jet_session
```

### Session Object Shape (set by Admin JET after login)

```javascript
{
  sessionId:      string,   // Bearer token for ORDS calls
  userId:         number,
  username:       string,
  displayName:    string,
  displayNameAr:  string,
  email:          string,
  phone:          string,
  orgId:          number,
  orgName:        string,
  color:          string,   // avatar background colour
  employeeNumber: string,
  roles:          string[], // e.g. ['SYS_ADMIN', 'MANAGER', 'AP_PETTY_CASH_ADMIN']
  initials:       string,
  loginAt:        ISO8601 string,
}
```

All module apps read this object as-is. They must **never write** to `ifinance_jet_session` (except Admin JET on login/logout).

---

## Module App Rules

### 1. Session key — always `ifinance_jet_session`

In every module app's `services/api.js` and `services/authService.js`:

```javascript
var SESSION_KEY = 'ifinance_jet_session';   // ✔ correct
// var SESSION_KEY = 'ifinance_pc_session'; // ✘ wrong — never module-specific
```

### 2. No own login page in production

Module apps must **not** present a login form in production. Boot sequence:

```javascript
// appController.js boot
var user = authService.getCurrentUser(); // reads ifinance_jet_session
if (!user) {
  // redirect to Admin JET login
  window.location.href = '/apps/admin/index.html';
  return;
}
// proceed to dashboard
self._loadRoute('dashboard');
```

### 3. Own login page in mock/dev mode only

In mock mode (`config.apiBase = null`), the module app MAY show its own login page with quick-login buttons so it can be tested in isolation without running the Admin app. This is **dev scaffolding only** and must be gated:

```javascript
// appController.js boot
var user = authService.getCurrentUser();
if (!user) {
  if (config.apiBase) {
    // production: redirect to Admin portal
    window.location.href = '../Admin/Jet/index.html';
  } else {
    // mock/dev: show local login for standalone testing
    self._loadRoute('login');
  }
  return;
}
```

### 4. ORDS module per app — shared token

Each module has its own ORDS REST module, but all use the **same Bearer token** issued by `DCT_AUTH`:

| JET App | ORDS Module path |
|---|---|
| Admin (App 200) | `/ords/admin/dct/` |
| Petty Cash (App 201) | `/ords/admin/pc/` |
| Duty Travel (App 204) | `/ords/admin/dt/` |
| Credit Cards (App 203) | `/ords/admin/cc/` |
| (future modules) | `/ords/admin/<code>/` |

The ORDS `DCT_AUTH` package validates the token for all modules — the token is not module-specific.

### 5. Role-based features come from the session

Module apps derive their feature visibility from `user.roles` in the shared session:

```javascript
// Example in PC app
function _isPcAdmin(user) {
  return user && (
    user.roles.includes('AP_PETTY_CASH_ADMIN') ||
    user.roles.includes('SYS_ADMIN')
  );
}
```

Never re-query the DB for roles inside a module app. Trust the session object populated by Admin at login.

---

## File Structure for Every Module JET App

```
final apps/<MODULE>/Jet/
  index.html                  ← shell (same structure as Admin)
  css/
    app.css                   ← module brand colour, rest cloned from Admin CSS
  js/
    main.js                   ← RequireJS config + ko.bindingHandlers.module
    appController.js          ← router, nav groups, session check → redirect if no session
    mockData.js               ← dev-only seed data
    services/
      config.js               ← apiBase (null = mock, string = real ORDS)
      api.js                  ← SESSION_KEY = 'ifinance_jet_session'
      authService.js          ← SESSION_KEY = 'ifinance_jet_session'; no write to session
      <module>Service.js      ← module-specific CRUD
      ...
    viewModels/
      login.js                ← MOCK MODE ONLY — standalone dev login
      dashboard.js
      ...
    views/
      login.html              ← MOCK MODE ONLY
      dashboard.html
      ...
```

---

## CSS / Brand Colours

Each module has its own brand colour. Admin's red is App 200 only.

| App | Module | Brand colour |
|---|---|---|
| 200 | Admin | `#C74634` (Oracle Red) |
| 201 | Petty Cash | `#2E7D32` (Green) |
| 204 | Duty Travel | `#0572CE` (Blue) |
| 203 | Credit Cards | `#6A1B9A` (Purple) — TBD |
| 810 | HR/Duty Hub | `#00695C` (Teal) — TBD |

All other CSS (layout, typography, cards, badges, forms, tables) is **identical** across all apps. When Admin's `app.css` changes structurally, propagate the change to all module apps.

---

## Checklist — Every New Module JET App

- [ ] Directory created: `final apps/<MODULE>/Jet/`
- [ ] `css/app.css` — cloned from Admin, brand colour swapped
- [ ] `js/main.js` — identical to Admin (same RequireJS config + module binding)
- [ ] `js/appController.js` — session check: redirect to Admin if no `ifinance_jet_session` in production
- [ ] `js/services/api.js` — `SESSION_KEY = 'ifinance_jet_session'`
- [ ] `js/services/authService.js` — `SESSION_KEY = 'ifinance_jet_session'`; only reads session, never writes
- [ ] `js/services/config.js` — `apiBase` set to module's ORDS path (or null for mock)
- [ ] Mock login page (`login.js` + `login.html`) present but gated behind `!config.apiBase` check
- [ ] Nav groups filtered by roles from `user.roles` (read from shared session)
- [ ] ORDS module created under `/ords/admin/<code>/` using same `DCT_AUTH` token validation
- [ ] Module ORDS handlers validate `sessionId` via `DCT_AUTH.validate_session` (or equivalent)

---

## What Admin JET Owns vs Module JET Owns

| Concern | Admin JET (App 200) | Module JET (App 201+) |
|---|---|---|
| Login / logout | ✔ owns it | ✘ redirects to Admin |
| Session write | ✔ writes `ifinance_jet_session` | ✘ read-only |
| User management | ✔ | ✘ |
| Role assignment | ✔ | ✘ |
| Org / employee directory | ✔ | reads from session / own ORDS |
| Module data (PC records etc.) | ✘ | ✔ |
| Module settings | ✘ | ✔ |
| Module ORDS handlers | ✘ | ✔ |

---

## Relationship with SHARED_APEX_ARCHITECTURE.md

This document covers the **JET SPA layer** only. The same principle (App 200 as authority) applies to the APEX layer too — see `SHARED_APEX_ARCHITECTURE.md` for:
- Auth scheme subscription
- Standard application items
- SET_APP_ITEMS process
- Common LOVs and authorization schemes
