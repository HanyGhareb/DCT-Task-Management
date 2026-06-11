# UI/UX Assessment — Current State

**Scope:** the 4 built JET SPAs — Admin (18 views), PC (17), DT (19), HR (13) — 67 views total under `final apps/*/Jet/`. FL and CC have no UI yet (greenfield opportunity: they can adopt the recommendations natively).

---

## 1. What works well (preserve)

| Strength | Evidence |
|---|---|
| **Consistent shell**: dark 56px header + collapsible 240px sidebar + avatar menu, identical across all 4 apps — users move between modules without relearning | `final apps/*/Jet/index.html`, `js/appController.js` |
| **Per-module brand color** on a shared structure (Admin red `#C74634`, PC green `#2E7D32`, DT blue `#0572CE`, HR teal `#00695C`) — instant "which app am I in" cue | `final apps/*/Jet/css/app.css` `--brand-*` variables |
| **Vault design system** for security pages: distinctive dark theme (`#0D1117`), Outfit + Fira Code fonts, amber spring-timing toggles — the platform's strongest design work | bottom of `final apps/Admin/Jet/css/app.css` (`rm-*`/`re-*` classes) |
| **Single sign-on UX**: one login in Admin, every module picks the session up silently | `ifinance_jet_session` contract, `SHARED_JET_ARCHITECTURE.md` |
| Theme infrastructure already exists (Corporate / Redwood / Midnight via `data-theme`) | `final apps/Admin/Jet/css/themes.css` |
| Empty-state pattern exists (icon + message + CTA) — just inconsistently applied | `.empty-state` in `app.css`; used in `PC/Jet/js/views/dashboard.html` |

## 2. Findings

### UX-1 (HIGH) — CSS duplicated 4×
`app.css` (~1,145 lines in Admin) is cloned per module with only the brand variable changed. Every structural fix must be hand-propagated to 4 files (CLAUDE.md itself instructs this manual propagation). FL/CC would make it 6.
**Files:** `final apps/{Admin,PC,DT,HR}/Jet/css/app.css`.

### UX-2 (HIGH) — Zero i18n / RTL despite bilingual being a Phase-1 commitment
The 2026-05-09 decision log says "Bilingual: Phase 1 — all labels EN/AR from day one" (`docs/_legacy/ifinance-v2-proposal.md`). Reality: DB has `*_ar` columns everywhere, mock data carries `displayNameAr`, the session contract transports it — and **no view renders a single Arabic string**. No `dir="rtl"`, no translation bundles, every label hardcoded English (e.g. `final apps/PC/Jet/js/views/login.html`). This is the largest gap between stated requirement and implementation in the whole platform.

### UX-3 (HIGH) — Accessibility debt
Across all 67 views: no `aria-*` attributes, no `<nav>/<main>/<button>` semantics (interactive elements are `<div>`s with click bindings), modals without `aria-modal`, sidebar toggle without `aria-expanded`. A UAE-government platform will face WCAG/accessibility conformance requirements.

### UX-4 (MEDIUM) — Loading / error / failure states inconsistent
Services return Promises and VMs populate observables in `.then()`, but most views render an empty table during fetch with no spinner/skeleton; ORDS failures log to console with **no user-visible error toast** (only the 401→login redirect in `api.js` is handled). Users on slow ADB links can't distinguish "loading" / "empty" / "failed".

### UX-5 (MEDIUM) — No pagination or virtualization
All list views (`allPettyCash.html`, `allRequests.html`, `employees.html`…) bind the full result set. Fine on mock data; with thousands of production rows it degrades both ORDS payloads and DOM rendering.

### UX-6 (MEDIUM) — Dashboards have KPI cards but no visualization
Every module dashboard is stat-cards + a recent-activity table. No charts anywhere (no Chart.js/JET viz), despite finance being a charts-first domain (spend trends, ageing, approval cycle time). The legacy prototype (`apps/ifinance-v2/`) actually had Chart.js — capability regressed in the rewrite.

### UX-7 (MEDIUM) — Approvals are siloed per module
A manager who approves PC + DT + HR items must visit three apps to clear their queue. The data to unify this exists (`dct_approval_instances` is already cross-module). See mockup `approvals-inbox-concept.html`.

### UX-8 (LOW) — Form validation is ad-hoc
No standard inline error pattern (`.form-error` class absent); some forms validate in VM with `alert()`, others not at all. Required-field asterisks exist in CSS but the enforcement is inconsistent.

### UX-9 (LOW) — Pattern drift between apps
Admin nav uses `standalone: true` groups; PC/DT/HR don't. Nav badges (pending counts) exist in PC/DT but not Admin/HR. `isRead === 'N'` string booleans in notificationService vs true booleans elsewhere. Each is small; together they erode the "one platform" feel.

### UX-10 (LOW) — Vault system stops at 3 pages
The platform's most distinctive design (`roles.html`, `permissions.html`, `roleEdit.html`) coexists with plain-gray everything else — two visual languages inside one app, undocumented as intentional.

## 3. Per-module notes

| Module | Specific observations |
|---|---|
| **Admin** | Most polished; appearance settings + themes exist here only. Missing: delegation + announcements views (backend ready). |
| **PC** | Still mock mode (`config.js` `apiBase: null`) — UI looks done but has never faced real ORDS latency/errors; activating live mode will surface UX-4 immediately. |
| **DT** | Best functional coverage (19 views incl. 2 finance queues). Multi-leg destinations render as plain rows — itinerary/timeline visualization would materially help approvers. |
| **HR** | Org chart tree redesigned recently (commit 4563fc4); employee photos served via ORDS. Missing contracts/salary views (backend tables exist). |
| **FL/CC** | Greenfield. Build them on the shared-asset + i18n + a11y foundation from day one rather than cloning today's debt. FL additionally needs an **external-user-facing** experience (freelancer self-registration) — a different design problem than internal back-office screens; see `mockups/request-wizard-concept.html`. |

## 4. Where the mockups fit

The three concept pages in [mockups/](mockups/) demonstrate the proposed direction (full rationale in [02-design-recommendations.md](02-design-recommendations.md)):

1. `dashboard-concept.html` — module dashboard with charts, ageing, loading skeletons (UX-4/6).
2. `approvals-inbox-concept.html` — unified cross-module approvals inbox (UX-7).
3. `request-wizard-concept.html` — multi-step request form with inline validation and RTL toggle (UX-2/8).
