# Action Plan — From Assessment to Done

**Created:** 2026-06-11 · Derived from [01-executive-summary.md](01-executive-summary.md) §3 and [05-advanced-features.md](05-advanced-features.md). Phases are dependency-ordered; each has an owner, effort, and exit criteria. **Owner key:** 🤖 Claude-executable · 👤 you (APEX Builder / decisions / keys) · 🤝 both.

> Two facts discovered while preparing this plan (both corrected below):
> - **PC has no ORDS module** — `final apps/PC/db/` contains no `06_pc_ords.sql` (DT and HR have one). PC STATUS.md's "set apiBase for live mode" assumed an endpoint that was never built. Going live = build the module first.
> - **No DCT_APPROVAL package exists** in `db/v2/` — the escalation/auto-approve sweep needs a new platform package, not a patch to an existing one.

---

## Phase 0 — Housekeeping ✦ this session

| # | Task | Owner | Effort |
|---|---|---|---|
| 0.1 | Fix stale `CLAUDE.md`: FL/CC JET = not started, CC PL/SQL = stub, remove nonexistent `FL/Jet/`/`CC/Jet/` from layout | 🤖 | minutes |
| 0.2 | This document | 🤖 | done |

**Exit:** future sessions work from true facts.

## Phase 1 — Unblock the backend ✦ **✅ DONE 2026-06-11 — report: [phase1/](phase1/)** (1.5 done too: key was already set, but must now be **rotated** — see phase1 report §4)

| # | Task | Owner | Effort |
|---|---|---|---|
| 1.1 | **Implement `DCT_CC_PKG`** (`final apps/CC/db/04_cc_pkg.sql`): request lifecycle (submit/approve-callback/withdraw per type), limit enforcement + `dct_cc_card_limit_history` writes, replenishment validation (one per card/month, coding checks), card-status transitions. Mirror `DCT_FL_PKG` structure. Deploy via SQLcl, verify VALID. | 🤖 | 2–4 d |
| 1.2 | **Build PC ORDS module** `final apps/PC/db/06_pc_ords.sql` at `/ords/admin/pc/` — model on `final apps/DT/db/06_dt_ords.sql`; endpoints to cover the 8 PC services; ADMIN synonyms for PROD objects; deploy. | 🤖 | 1–2 d |
| 1.3 | **Flip PC JET live**: `apiBase: '/ords/admin/pc'` in `final apps/PC/Jet/js/services/config.js`; smoke test login + lists through `dev-proxy.py`; add the error-toast catch in `api.js` (minimum async-state safety). | 🤝 | 0.5 d |
| 1.4 | **Approval sweep**: new `db/v2/13_dct_approval_pkg.sql` — `DCT_APPROVAL_PKG.SWEEP` evaluating `escalation_days` → notify `escalate_role_id` via `DCT_NOTIFY`, and `auto_approve_days` → auto-advance; daily `JOB_DCT_APPROVAL_SWEEP` (pattern: the 3 DT jobs in `final apps/DT/db/04_dct_dt_pkg.sql`). | 🤖 | 1–2 d |
| 1.5 | Set the AI API key in `DCT_SYSTEM_SETTINGS` to activate `DCT_PC_AI_PKG` | 👤 | minutes |

**Exit:** CC package VALID in PROD · PC JET running against real ORDS · sweep job scheduled and tested on a seeded template.

## Phase 2 — Converge the data model ✦ **✅ DONE 2026-06-11 — report: [phase2/README.md](phase2/README.md)** (approved plan: [phase2/00-phase2-plan.md](phase2/00-phase2-plan.md); delivered natural-key masters, unified docs/coding/history tables, lookup-first statuses with DCT_LOOKUP_PKG, 22 validated FKs, DT module_code fix, CC+FL adoption with 5 superseded tables dropped — zero backfill, all tables were empty)

| # | Task | Owner |
|---|---|---|
| 2.1 | Finalize + deploy the three shared tables from [03-database/ddl/](03-database/ddl/): `dct_documents`, `dct_budget_coding_lines`, `dct_request_status_history` (created empty — no module touched yet) | 🤖 |
| 2.2 | **CC adopts natively** (no UI exists yet → zero migration): DCT_CC_PKG reads/writes unified tables; simplify card status to ACTIVE/INACTIVE/CLOSED + `dct_cc_cards_v` (`ddl/05_migration_notes.sql` §4) | 🤖 |
| 2.3 | FL adopts (package-only changes; backfill from `dct_fl_documents`) | 🤖 |
| 2.4 | Add NOVALIDATE FKs + lookup migrations (`ddl/04`); produce orphan report; VALIDATE after cleanup | 🤝 (orphan decisions: 👤) |
| 2.5 | PC and DT adopt opportunistically when next modified — not a dedicated effort | 🤖 |

**Exit:** new modules cannot diverge again; orphan report empty; cross-module spend query works.

## Phase 3 — Frontend foundation ✦ **✅ DONE 2026-06-11 — report: [phase3/README.md](phase3/README.md)** (mockups-first per user direction; shared layer + page-level shell w/ module switcher + settings-driven brands, EN/AR i18n+RTL, async tri-state standard, server pagination on the 5 big lists, 8 Chart.js charts; 3 ORDS modules redeployed; 15/15 smoke + browser-verified — also fixed 5 pre-existing platform bugs incl. settings/notifications 555s)

| # | Task | Owner |
|---|---|---|
| 3.1 | Shared asset layer `final apps/shared/` (extract the 4× duplicated `app.css`, `api.js`, session plumbing) — design rec §1 | 🤖 |
| 3.2 | i18n EN/AR + RTL in the same pass (`t()` helper, `i18n/en.json`+`ar.json`, logical CSS properties, IBM Plex Sans Arabic) — honors the locked Phase-1 bilingual decision | 🤖 |
| 3.3 | Async-state standard everywhere (skeletons, toast, tri-state lists per `mockups/dashboard-concept.html`) | 🤖 |
| 3.4 | Server-side pagination on `employees`, `allPettyCash`, `allRequests`, `auditLog` | 🤖 |
| 3.5 | Chart.js dashboards (2 charts per module, table in design rec §6) | 🤖 |

**Exit:** one CSS source of truth; language toggle works end-to-end in Admin; no silent empty tables.

## Phase 4 — Build the missing UIs (≈ 3–4 weeks)

| # | Task | Owner |
|---|---|---|
| 4.1 | FL ORDS module + FL JET app (scaffold from HR per `final apps/FL/STATUS.md`, built on Phase-3 foundation) | 🤖 |
| 4.2 | CC JET app (reuse PC reimbursement view patterns for replenishments) | 🤖 |
| 4.3 | Unified approvals inbox in Admin (`mockups/approvals-inbox-concept.html` → real view + one ORDS endpoint over `dct_approval_instances`) | 🤖 |
| 4.4 | Delegation + announcements Admin views (backend already complete) | 🤖 |
| 4.5 | **Decision:** freelancer external portal (self-registration wizard — `mockups/request-wizard-concept.html` pattern) — separate reduced-nav JET app vs APEX public app | 👤 then 🤖 |

**Exit:** every module has a UI; managers approve everything from one inbox.

## Phase 5 — APEX pages (user-led, runs in parallel from Phase 2)

Standing rule applies: **build in APEX Builder first**, export via `apex_export.get_application` — never hand-author page SQL (`docs/APEX_SETUP.md` §14).

| Order | App | Prereq |
|---|---|---|
| 1 | DT (App 204 — 18 shells already deployed) | `docs/APEX_PAGE_PLAN.md` exists |
| 2 | PC (App 201 — shell not started) | Phase 1.2/1.3 done |
| 3 | HR (App 205) | 🤖 writes the missing HR page plan first |
| 4 | FL / CC (Apps 203/202) | Phase 4 |

🤖 assists each step via the `/apex` skill (page plans, shared-component subscription checklists, post-build exports).

## Phase 6 — Advanced features (ongoing, after their prereqs)

From [05-advanced-features.md](05-advanced-features.md): analytics MV (#4, needs 2.1) → email/digest notifications (#5) → AI clearing rollout PC→CC→DT (#2, needs 1.5) → document OCR (#6) → PWA inbox (#8, needs 4.3) → Fusion integration (#9) → SSO last (#7).

---

## Timeline at a glance

```
Week 1-2   ████ Phase 1 backend unblock        ← starts now
Week 3-5   ████ Phase 2 data convergence        Phase 5 APEX (DT) runs parallel ▒▒▒▒
Week 5-7   ████ Phase 3 frontend foundation     Phase 5 APEX (PC, HR) ▒▒▒▒
Week 7-11  ████ Phase 4 missing UIs             Phase 5 APEX (FL, CC) ▒▒▒▒
Week 11+   ████ Phase 6 advanced features
```

Re-baseline at each phase exit; effort assumes current single-developer velocity.
