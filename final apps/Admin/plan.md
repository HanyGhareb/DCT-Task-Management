# Admin Module (App 200) — Status & Plan

> Snapshot date: **2026-07-13** · APP_VERSION **4.6.2** · ORDS base `/ords/admin/dct/`
> Detailed per-function inventory: `docs/functions_list.md` · Deploy runbook/history: `docs/deployment-notes.md`

---

## 1. Current Status

| Layer | Status |
|---|---|
| Database (db/v2, PROD schema) | ✅ Complete — 24 `DCT_*` tables + DCT_AUTH / DCT_REST / DCT_NOTIFY / DCT_LOOKUP_PKG / DCT_AUDIT_PKG / DCT_SSO_PKG; patches deployed through db/v2/48 |
| ORDS (`/ords/admin/dct/`) | ✅ Live — platform-shared API (auth, boot, users, roles, orgs, modules, lookups, settings, notifications, approvals, audit, sessions, delegations, announcements, runners, SSO) |
| JET SPA (`Jet/`) | ✅ Live on ORDS (no mock branches) — 22 views, EN/AR + RTL, shared shell + module switcher |
| Cross-UI SSO (JET ⇄ APEX) | ✅ LIVE both directions (db/v2/41–41c; `FEATURE_SSO_HANDOFF=Y`; allowlist `APEX_SSO_APPS = 200,211`) |
| APEX pages | 🟡 Partial — Users/Roles pages built; remaining admin areas JET-only |
| UAT | ✅ Round 2 passed 96/96 (wave enhancements); UAT packages under `UAT/` |

Admin is the platform **identity provider**: all 10 module apps authenticate through it and share the `ifinance_jet_session` key; only Admin writes the session.

---

## 2. Current Functions (by area)

### Authentication & Session
- Central login (username/password) + quick-login for UAT users; writes the shared session.
- Cross-UI SSO hand-off: APEX topbar button in every shared-shell app (`POST /sso/code`) and APEX→JET `#sso=<code>` boot exchange (public `POST /auth/sso`); one-time SHA-256-hashed codes, 60s TTL.
- Active Sessions — view and revoke any live session platform-wide.
- My Profile — edit profile, change password, upload profile photo, create/cancel own approval delegations.
- Session inactivity timeout enforced in `validate_session`.

### User Management
- Users directory — server-paginated, searchable, ACTIVE/INACTIVE filter, bulk actions, soft deactivate with undo.
- User Editor — create/edit user with validation (username, EN/AR names, email, org unit, password) **plus role assignment via checkbox set** (default `PLATFORM_USER`).

### Roles & Permissions (Vault design system)
- Roles catalogue — create / edit / delete roles.
- Role Editor — role details + its permission set.
- Permission Matrix — role × permission grid grouped by module, toggle + save-all.

### Organisation & Modules
- Org Hierarchy — division/department/section tree; add/edit/toggle-active units.
- Modules registry — configure the module apps (brand colour, settings, active flag).

### Approvals & Delegation
- Approval Templates — multi-step workflow designer with draft lifecycle, versioning, clone, restore, diff.
- Approval Monitor — live in-flight instances with step progress.
- Pending Approvals — unified inbox across all modules (delegation-aware, `actingFor`).
- Delegations — admin view/cancel of all approval delegations.
- Daily escalation/auto-approve sweep job (`DCT_APPROVAL_PKG`, 07:10).

### System Configuration
- System Settings — branding, feature flags, secrets (API keys write-only/masked), SSO settings.
- Region Appearance — platform-wide region header/border theming (`THEME_REGION_*`).
- Field Focus Highlight — global focus colour/intensity (`THEME_FOCUS_*`, db/v2/26).
- Lookups — manage `DCT_LOOKUP_VALUES` value sets (lookup-first rule).

### Communication
- Announcements — platform banners (audience, severity, active toggle); shown by the shared shell in all apps.
- Notifications centre — list, mark read, unread count badge.

### Audit & Monitoring
- Audit Log — searchable trail, date filters, CSV export, before/after diff modal (snapshots via `DCT_AUDIT_PKG`, per-module `FEATURE_AUDIT_SNAPSHOTS_*` switches).
- Automation Registry — CRUD catalogue of every automation runner/script with binary file storage.

### Dashboard
- Customisable KPI/widget home (show/hide/reorder widgets, `/dct/stats/`, `/dct/prefs/`).

### Platform services Admin hosts for other apps
- `GET /dct/boot` (feature flags + theme keys), `GET /dct/branding` (only public endpoint), `/dct/stats/`, `/dct/prefs/`, device push registration (db/v2/28, App 209), binary photo `PUT /users/:id/photobin` (db/v2/29).

---

## 3. Planned / Future Work

### Near-term (known gaps)
1. **APEX pages** — only Users/Roles built in Builder; decide whether remaining admin areas need APEX equivalents or stay JET-only.
2. **SSO app-mapping rollout** — onboard the remaining module APEX apps (201 PC, 204 DT, 205 HR …) to `APEX_SSO_APPS` (wire page 9999 + the 14 `USER_*` items per `db/v2/42` pattern; runbook `docs/apex-sso-setup.md`).
3. **Audit snapshot coverage** — all `FEATURE_AUDIT_SNAPSHOTS_*` switches default OFF; enable per module when wanted. Instrument workflow actions (approve/submit) and reference-data writes, which currently rely on status-history only.
4. **Notifications API parity** — `/dct/` has no `mark-all-read` endpoint (client loops `PUT :id/read`); add one.
5. **Org Hierarchy / Announcements** — no DELETE endpoints (deactivate-only today); confirm whether that is final.
6. **Web photo upload** — web still uses the legacy base64 `PUT /users/:id/photo` (~24 KB cap); migrate to the binary `/photobin` path used by mobile.

### Medium-term
7. **Password policy / account lockout** — no configurable complexity, expiry, or failed-attempt lockout on DCT_USERS today.
8. **User import/bulk provisioning** — Users page has bulk status actions but no CSV/Excel user import.
9. **Role assignment audit view** — surface `DCT_USER_ROLES` start/end history in the user detail (data already end-dated, not displayed).
10. **UAT housekeeping automation** — schedule the rerunnable cleanup scripts (db/v2/21, 23).

11. **Module-access management UI** — `DCT_MODULE_ROLES` (module → role App-Launcher access) is seeded in db/v2/04 and exposed via `DCT_USER_MODULES_V`, but no Admin page manages it and the JET module switcher does not consume it (it shows all modules; gating happens inside each app by role). Either wire the switcher/boot to it and add a Modules-page editor, or retire the table.

### Ideas / backlog (not committed)
- 2FA / OTP option on top of DCT_AUTH (portal already has email-OTP infrastructure).
- Admin health dashboard (worker fleets, scheduler jobs, INVALID objects) — pieces exist in ATD/BI apps.
- Self-service password reset via email (blocked on production SMTP — OCI Email Delivery, see Reporting platform).
