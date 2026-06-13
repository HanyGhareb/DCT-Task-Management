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

## Action Buttons — Always Top-Right (platform rule, 2026-06-13)

**Save / Save Changes / Submit / Back / Cancel / Confirm buttons live at the TOP-RIGHT of the page or region they act on — never at the bottom of the form.** This applies to every existing view and every future one. CSS lives in `shared/css/platform.css`.

| Scope | Markup recipe |
|---|---|
| Page-level form (edit/detail page) | `<div class="page-header page-header-row"><div>title + subtitle</div><div class="page-actions">[← Back] [Save Draft] [Save/Submit (primary)]</div></div>` |
| Region (card / inline edit panel) | `<div class="section-heading-row"><div class="section-heading">Title</div><div class="region-actions">[Cancel] [Save]</div></div>` — or a flex row with `.region-actions` if the region has no `.section-heading` |
| Modal dialog | Buttons go in the modal header row next to the title (`.region-actions`, `btn-sm`), replacing the old `×` close button (Cancel covers it). No `.modal-footer`. |
| Wizard steps | Per-step buttons go in the page header `page-actions`, gated by `<!-- ko if: step() === n -->`. |

Rules:
- Button order (LTR): Back / Cancel first, primary action (Save / Submit / Confirm) last — the primary is the right-most button. RTL mirrors automatically (flex + logical properties).
- A page never needs both Back and Cancel when they call the same handler — keep Back only.
- `.form-actions` (bottom bar with top border) is **deprecated for new work**; the only sanctioned bottom-row leftovers are non-form CTAs (e.g. "+ Add X") and table-row inline editors.
- Confirmation-only dialogs (e.g. the Vault delete-role prompt: a question + two buttons, no form fields) keep their buttons in place.

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

---

## Shared Asset Layer (Phase 3, 2026-06-11)

`final apps/shared/` is the single source of truth for shell + components:

```
shared/
  css/platform.css   <- ALL structural CSS (shell, components, skeleton/toast/pager,
                        RTL logical properties, AR fonts). EDIT THIS ONCE - never
                        copy styles into a module app again.
  css/themes.css     <- legacy data-theme sets (moved from per-app copies)
  css/vault.css      <- Vault dark tier (security surfaces only - two-tier rule)
  js/api.js i18n.js toast.js skeleton.js pager.js chartLoader.js shell.js
  i18n/common.en.json common.ar.json
```

**Rules:**
- Each app's `css/app.css` holds ONLY brand tokens (--brand/--brand-rgb/--brand-dark/--brand-soft + legacy aliases). The live color comes from the module's THEME_BRAND_COLOR setting at boot (shared/js/shell.js derives dark/soft from the one stored hex).
- Each app's `js/services/api.js` is a 1-line re-export of `shared/api` (which needs `config.adminPortalUrl` for the 401 redirect; null in Admin).
- `main.js` requirejs paths: `'shared': '/shared/js'` and `'chartjs': <CDN chart.umd.min>`. **Chart.js must NEVER be loaded via <script> tag** - its UMD calls define() and crashes under RequireJS. Charts must be created via `shared/chartLoader.makeChart` (auto-destroys on route change).
- The shell is page-level: fixed dark top bar (suite logo + MODULE SWITCHER dropdown + EN|AR toggle + user menu) + full-height side navigation rendered from each app's NAV_GROUPS (labelKey -> i18n). Adding module #7 = one entry in shared/js/shell.js MODULES.
- i18n: `t()` from shared/i18n; nav/view labels use keys (common.*.json + per-app js/i18n/app.{en,ar}.json); Latin digits for all amounts in Arabic; language persists in localStorage 'ifinance_lang' + the LANG row in DCT_USER_PREFERENCES (Admin prefs/ endpoint).
- Tri-state list standard: `<list-skeleton>` while loading -> table or .empty-state -> error empty-state + retry (api.js already toasts the failure). Server-paged lists use `<list-pager>` ({items,total,limit,offset} envelope, or hasMore mode for ORDS-native paging).
- **KO + ORDS gotcha:** APEX_JSON skips NULL fields, so bind optional fields as `.field || ''` - a bare `text: field` throws ReferenceError when the field is absent and the whole list dies into the error state.
- **KO shell-click gotcha:** any `click:` binding on a container element (e.g. `<main>`'s `closeUserMenu` dropdown-dismisser) MUST `return true` - KO preventDefaults by default, which silently cancels the native default action of every click bubbling through (file-picker open, checkbox toggle). Symptom: "button does nothing", zero console errors.
- **KO context contract (post-UAT 2026-06-11):** in module views `$root` = the shell AppController (use ONLY for `t()`/`lang()`/`setLang()`); the view's own viewModel is **`$vm`** (injected by the `module` binding in every app's main.js, inherited at any foreach/with/template depth). Never call VM methods via `$root.x` - the Phase 3 shell silently broke every legacy reference of that form (stuck modals, dead permission toggles, empty trees).
- **Audit region standard:** every edit/view page or modal includes `<audit-info params="data: obj"></audit-info>` (shared/js/auditInfo.js, registered in each main.js). It renders Created/Last-updated (by + timestamp) from the standard `createdBy/createdAt/updatedBy/updatedAt` JSON keys, and renders nothing for new records. Detail/list ORDS handlers must emit those four keys (`TO_CHAR(.., 'YYYY-MM-DD HH24:MI')`); when a service flattens/remaps API objects it must carry the audit keys through (bit the lookups flattener).
- **Router (Admin):** the current route is mirrored to `location.hash` and restored on boot - F5 keeps the page. Logout posts `/auth/logout` with `{}` + `{silent:true}` BEFORE clearing the token (a bodyless POST gets ORDS 400; clearing first leaks the server session). `/auth/*` 401s bypass the global expired-session redirect so login forms can render the server's error inline.
- Dev: each app's dev-proxy.py serves `/shared/*` from the sibling folder. Deploy: ship `final apps/` as one web root (module switcher uses root-absolute /App/Jet/index.html URLs).
