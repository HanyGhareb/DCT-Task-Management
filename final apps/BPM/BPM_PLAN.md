# Fusion BPM — Workflow Management (App 214) — Plan (as built, 2026-08-01)

**Request:** "create separate App to manage all workflow related. Name it 'Fusion BPM'
workflow management. and add all related artifacts to it."

## Concept

One dedicated shared-shell JET app consolidating EVERY workflow surface that had
accumulated inside Admin (App 200) — both the DWP platform pages and the legacy
approval-engine pages — so workflow has a single home with its own brand, nav and
role gating, and Admin returns to being the identity/administration console.

## Key architecture decision — no ORDS module

Fusion BPM owns **zero server-side artifacts** beyond one `dct_modules` registry row.
It is a pure console over the two existing cross-module APIs:

- `/ords/admin/wf/` — the DCT Workflow Platform API (worklist, action, designer,
  role assignments, priority, import, test-mode). Deliberately gate-EXEMPT in
  db/v2/50 (cross-module by definition).
- `/ords/admin/dct/` — the shared Admin module (legacy approvals inbox/monitor/
  templates, delegations, users, notifications). The `dct` segment is exempt too.

Therefore `config.apiBase = …/ords/admin/dct` (identical to Admin's), which makes
every page lifted from Admin work **verbatim** — including the `{ base: 'wf' }`
derivation in `shared/api.js` (`/dct` → `/wf` segment swap) — and means **no
db/v2/50 CASE-map entry, no synonyms, no handlers, no re-run coupling.**

## Scope moved from Admin (removed there, hosted here)

Workspace (all users): **My Worklist** (DWP `<wf-worklist>` + `<wf-timeline>`),
**Pending Approvals** (legacy inbox), **My Delegations** (self-service vacation rule).
Process Design (WF_ADMIN/SYS_ADMIN): **Approval Processes** (`<wf-designer>` incl.
cascade resolver, Timers, Test mode), **Role Assignments** (+ 5 drawers: Policies,
Manage Roles, Manage Objects, Level Priority, Import Matrix).
Oversight (admin): **Approval Monitor**, **Approval Templates** (legacy),
**Delegations** (everyone's, oversight).
New: **Dashboard** (stat tiles + quick links), **Notifications**.

Admin keeps: profile-page delegation section, dashboard approval KPIs (the
approval-cycle chart drill now deep-links to `/BPM/Jet/index.html#approvalMonitor`;
`sessionStorage['amPresetSearch']` survives the same-tab hop), and the shared
`/dct/` endpoints (they are platform APIs, not Admin-private).

## Identity & registration

- App **214**, module_code **BPM**, brand **#7D3243** (deep burgundy), cube **BP**,
  folder `final apps/BPM/` (Jet/db/tests/docs/UAT/guides), display_order 78.
- `shared/js/shell.js` MODULES entry (after kpiv2) + `mod.bpm`/`mod.bpm.desc` in
  shared common i18n EN+AR → APP_VERSION bumped in ALL 14 existing apps.
- `db/01_bpm_seed.sql` — the one `dct_modules` row (rerunnable, UNISTR Arabic).
  DEPLOYED 2026-08-01, module_id 181.
- dev-proxies need NO edit (SIBLING_APPS auto-derives); webtier deploy script
  globs `*/Jet` so the new app ships automatically.

## Gating

Nav groups: Workspace `all` · Process Design `WF_ADMIN|SYS_ADMIN` · Oversight
`SYS_ADMIN|USER_ADMIN|WF_ADMIN`. Server checks stay the boundary (wf routes
self-gate; per-task worklist gating).

## Verification (all run 2026-08-01)

- 7 browser suites moved from Admin/tests and adapted to the shared-session
  login hop: worklist 8/8 · my_delegations 11/11 · manage_drawers 17/17 ·
  designer 15/15 · diagram 14/14 · cascade 18/18 · role_assign 13/13.
- NEW `bpm_browser_smoke.py` 30/30 (shell identity, dashboard, nav, all 9 routes,
  switcher entry, AR/RTL, Admin-side strip + BPM link, zero JS errors).
- PROD residue after all runs: 0 rows (assignments / processes / delegations).
