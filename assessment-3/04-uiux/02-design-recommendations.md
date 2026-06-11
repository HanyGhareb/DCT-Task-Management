# UI/UX Design Recommendations

Ordered so each step makes the next one cheaper. FL and CC (no UI yet) should be built directly on steps 1–3.

---

## 1. Shared asset layer (fixes UX-1)

Create `final apps/shared/` served alongside the apps:

```
final apps/shared/
  css/platform.css      ← everything currently duplicated in the 4 app.css files
  css/themes.css        ← the 3 themes, today Admin-only
  js/api.js, js/sessionContract.js   ← identical service plumbing
  i18n/en.json, i18n/ar.json
```

Each app keeps a ~30-line `css/app.css`: brand variables + true module-specific rules. `dev-proxy.py` already serves static files relative to the app root — add one route for `../shared/` (or copy at a build step; either ends the 4-way hand-propagation). Rule change in CLAUDE.md afterwards: "edit platform.css once" replaces "propagate to all module apps".

## 2. i18n + RTL (fixes UX-2 — honors the locked Phase-1 bilingual decision)

No framework needed at this scale — a ~40-line `t()` helper:

- `shared/i18n/en.json` / `ar.json` keyed by view (`"login.username": "Username"` / `"اسم المستخدم"`).
- KO binding `data-bind="text: t('login.username')"`; language in `dct_user_preferences`, transported in the session object (field exists already).
- RTL: `<html dir="rtl">` toggle + logical CSS properties (`margin-inline-start` instead of `margin-left`) applied during the shared-CSS extraction in step 1 — doing 1 and 2 together costs ~half of doing them separately.
- DB is already bilingual (`*_ar` columns); ORDS responses must start including the `_ar` fields the views will need.
- Arabic-appropriate font: Outfit (Vault) has no Arabic glyphs — pair with **IBM Plex Sans Arabic** (matching mono: IBM Plex Mono) via `--vault-font-ar`.

## 3. Accessibility pass (fixes UX-3)

Mechanical, view-by-view, do per-app when an app is next touched:
- Landmark semantics: `<nav>` (sidebar), `<main>` (module container), `<header>`; clickable `<div>`s → `<button class="btn-unstyled">`.
- Sidebar toggle: `aria-controls` + `aria-expanded`; KO-bound toggles (the custom `<div>`-wrapped checkbox pattern that avoids the label double-toggle bug) get `role="switch"` + `aria-checked`.
- Tables: `scope="col"`; notifications use `aria-live="polite"`.
- Keep the existing focus outlines (already decent); test tab order on the 3 worst forms (`requestForm.html`, `pcRequest.html`, `userEdit.html`).

## 4. Async-state standard (fixes UX-4) — adopt before PC goes live

Three pieces, all in shared assets:
- **Skeleton rows** (`.skeleton-row` shimmer) shown while a VM's `loading()` observable is true — pattern: `<!-- ko if: loading -->` skeleton `<!-- /ko --><!-- ko ifnot: loading -->` table `<!-- /ko -->`.
- **Toast component** (one `toast.js` + `showToast(type, msg)`): `api.js` catch-all surfaces non-401 ORDS failures as an error toast instead of console-only.
- **Tri-state list contract**: every list view must render one of skeleton / empty-state / data — never a silent empty table. The `.empty-state` CSS already exists; this just makes it mandatory.

Flipping PC from mock to live (`final apps/PC/Jet/js/services/config.js`) is the natural moment: real latency will exercise every one of these states.

## 5. Pagination (fixes UX-5)

ORDS already supports `offset`/`limit` on collection queries. Standard: server-side paging at 50 rows + a shared `pager` KO component (page-size select, prev/next, total count). Apply first to the four largest lists: `employees.html`, `allPettyCash.html`, `allRequests.html`, `auditLog.html`.

## 6. Dashboard visualization (fixes UX-6)

Add **Chart.js via CDN** (proven in this codebase — the legacy `apps/ifinance-v2/` prototype used it; do NOT try `ojs/*` JET viz modules — they 404 on the CDN config, see `feedback_jet_amd_404`). Per module, two charts max, chosen for decisions not decoration:

| Module | Chart 1 | Chart 2 |
|---|---|---|
| PC | Outstanding floats by org (bar) | Uncleared TEMPORARY ageing buckets (stacked) |
| DT | Monthly travel spend vs advances (line) | Requests by status funnel |
| HR | Headcount by org/grade (bar) | Document expiry horizon (timeline buckets) |
| Admin | Approval cycle time per module (bar) | Active sessions / logins trend |

See `mockups/dashboard-concept.html` for layout, skeleton states, and chart placement.

## 7. Unified approvals inbox (fixes UX-7)

One new Admin view (`approvalsInbox.html`) reading `dct_approval_instances` across modules (the table is already cross-module), with type-ahead filter, amount, requester, waiting-time badge, and approve/reject/return inline. Module apps keep their local queues; the inbox is the manager's "one place in the morning". See `mockups/approvals-inbox-concept.html`.

## 8. Form standard (fixes UX-8)

- `.form-error` class + per-field `error` observable convention; submit buttons disable while `saving()`.
- Multi-step wizard pattern for the two longest forms (DT request: trip → destinations → allowances → documents → review; FL registration). Step indicator, per-step validation, review step before submit. See `mockups/request-wizard-concept.html`.

## 9. Visual direction — extend Vault selectively (resolves UX-10)

Recommendation: **keep two intentional tiers, document them.**
- **Vault dark** stays the signature for security/admin surfaces (roles, permissions, audit, approval templates) — it signals "you are in a privileged area".
- **Light tier** (everything else) adopts Vault's *tokens* without its darkness: Outfit for headings, Fira Code for codes/amounts/badges, the amber accent for active states, spring cubic-bezier on toggles. This gives the platform one personality at two brightness levels rather than two unrelated languages.
- Write the rule into `SHARED_JET_ARCHITECTURE.md` so FL/CC follow it.

## 10. Sequencing

| When | What |
|---|---|
| Now (cheap, high value) | 4 (async states) + flip PC live; 6 (charts) |
| With the next structural touch | 1 (shared assets) + 2 (i18n/RTL) together |
| Per-app opportunistic | 3 (a11y), 5 (pagination), 8 (forms) |
| With FL/CC build | All of the above natively + 9 |
| After CC package exists | 7 (unified inbox) |
