# Executive Summary — i-Finance v2 Full Assessment

**Date:** 2026-06-11 · **Scope:** 6 active modules (Admin 200, PC 201, CC 202, FL 203, DT 204, HR 205) · Details in [02-requirements/](02-requirements/), [03-database/](03-database/), [04-uiux/](04-uiux/), [05-advanced-features.md](05-advanced-features.md).

---

## 1. Verified module status

Checked against the actual repository on 2026-06-11 (the table in `CLAUDE.md` is stale for FL and CC — it claims their JET SPAs are complete; **no `Jet/` folder exists for either**):

| Module | DB | PL/SQL | ORDS | JET SPA | APEX |
|---|---|---|---|---|---|
| **Admin 200** | ✅ 25 core + 11 master | ✅ | ✅ live `/dct/` | ✅ 18 views, live | partial (Users/Roles) |
| **PC 201** | ✅ 8 tables | ✅ (+AI pkg, key pending) | ready, not switched on | ✅ 17 views — **mock mode** | ⬜ |
| **DT 204** | ✅ 8 tables | ✅ + 3 jobs | ✅ live `/dt/` | ✅ 19 views, live | 18 shells, no content |
| **HR 205** | ✅ 8 tables | ✅ | ✅ live `/hr/` | ✅ 13 views, live | ⬜ (no page plan) |
| **FL 203** | ✅ 13 tables | ✅ | ⬜ | ⬜ **no Jet/ folder** | ⬜ |
| **CC 202** | ✅ 8 tables | ⬜ **stub** | ⬜ | ⬜ **no Jet/ folder** | ⬜ |

## 2. Top findings

1. **CC's `DCT_CC_PKG` stub is the platform's biggest blocker** — schema is deployed but zero business logic exists; ORDS/JET/APEX all wait on it (`final apps/CC/db/04_cc_pkg.sql`).
2. **PC ships a finished UI that has never met its real backend** — `apiBase: null` in `final apps/PC/Jet/js/services/config.js`; flipping it will immediately expose the missing loading/error states (UX-4).
3. **The database core is strong; the modules diverged.** Five attachment patterns, four budget-line tables + two inline variants, seven status vocabularies — for three concepts that should each exist once. The proposed convergence is a net simplification: **−6 tables, +2 shared** ([03-database/02-proposed-model.md](03-database/02-proposed-model.md)).
4. **Free-text references to real masters** (`project_number`, `task_number`, `expenditure_type`, `bank_name`) allow silent orphans today — masters exist and are seeded; the FKs were just never added.
5. **The bilingual EN/AR commitment (locked 2026-05-09, "Phase 1, day one") is 0% implemented in UI** — the data layer is fully bilingual, no view renders Arabic, no RTL support (UX-2). Largest requirement-vs-reality gap in the platform.
6. **The approval engine's best features are dormant** — escalation, auto-approve, and delegation enforcement are modeled and seeded but nothing evaluates them. One daily sweep job activates all of it (advanced feature #3 — the cheapest high-impact item found).
7. **Approvals are siloed per module** while `dct_approval_instances` is already cross-module — a unified inbox is one endpoint + one view away (mockup provided).
8. **Accessibility debt is universal** — no ARIA, no semantic HTML in 67 views; a conformance requirement will eventually land on a government platform.
9. **CSS is hand-cloned 4×** (soon 6×) with only a brand variable changing — extract a shared asset layer before FL/CC multiply the debt.
10. **Requirements live mostly in code, not docs.** The per-module documents in [02-requirements/](02-requirements/) now capture both the documented and the inferred requirements — several inferred ones (session timeout, refund handling, bank reconciliation for CC) need business confirmation.

## 3. Recommended sequencing

```
NOW (unblock + cheap wins)
 1. Implement DCT_CC_PKG — adopt the unified documents/coding/status tables
    natively (zero migration cost while it's greenfield)
 2. Flip PC to live ORDS + add the async-state standard (skeleton/toast/empty)
 3. Approval sweep job (escalation + auto-approve) + delegation fix

NEXT (converge)
 4. DB unification migration, module-by-module: CC → FL → PC → DT
 5. Shared asset layer + i18n/RTL together (one structural pass)
 6. FL ORDS + JET app, CC JET app — built on the new foundation
 7. Unified approvals inbox

THEN (differentiate)
 8. Cross-module spend analytics · email notifications · AI clearing rollout
 9. APEX page content per module (Builder-first workflow, per standing rule)
10. PWA inbox → Fusion integration → SSO last
```

## 4. Corrections needed in CLAUDE.md (not applied — your call)

- Module Status table: FL and CC "JET SPA ✅ Complete" → both are ⬜ not started; CC PL/SQL is a stub.
- Repository Layout: `FL/Jet/` and `CC/Jet/` are listed but do not exist.

## 5. What was delivered in this assessment

6 requirements docs · current-model review + proposed model + 5 draft DDL scripts (not executed) · UI/UX assessment + 10 design recommendations · 3 working HTML concept mockups (dashboard with charts/skeletons, unified approvals inbox, bilingual RTL request wizard) · 10 ranked advanced features. All new files; no existing file was modified.
