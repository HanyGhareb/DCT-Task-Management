# Plan: Phase 4 — Build the Missing UIs (FL + CC apps, unified approvals, delegations & announcements)

## Context

Phases 1–3 are deployed and UAT round 1 on Admin is fixed/verified. Per the approved action plan (`assessment-3/06-action-plan.md` §4), Phase 4 closes the two module gaps — **Freelancers (App 203)** and **Credit Cards (App 202)** have complete DB schemas + PL/SQL packages but no ORDS modules and no JET apps — and finishes the platform features that depend on them: the **unified approvals inbox** (Admin already handles PC/DT; FL/CC must join) and **delegations + announcements** (tables exist in `db/v2/01_dct_ddl.sql`, zero endpoints, Admin profile shows a hardcoded mock).

User decisions: freelancer self-service **portal deferred** (internal staff UIs only this phase; nav role-gated so FL_FREELANCER sees nothing harmful); FL built to **full lifecycle** (all 6 approval flows). Same approach as Phase 3: **mockups-first user gate**, one approval-gated PROD deploy per ORDS module, API + Playwright testing, report + UAT workbooks.

Conventions (unchanged): SQLcl runners in `c:\tmp` (`SET DEFINE OFF`, keyword-free header comments, fresh session for synonym scripts), ORDS modules under ADMIN at `/ords/admin/<x>/`, handler pattern from `final apps/PC/db/06_pc_ords.sql`, JET apps on the `final apps/shared/` layer ($vm context, tri-state lists, `<audit-info>`, Asia/Dubai audit timestamps, EN/AR), creds parsed at runtime from Admin authService QUICK_LOGINS.

**Canonical new `source_module` registry:** `FL_REGISTRATION, FL_CONTRACT, FL_AMENDMENT, FL_VOUCHER, FL_RENEWAL, FL_PROFILE_CHANGE` (FL) · `CC_REQUEST, CC_REPLENISHMENT` (already used by DCT_CC_PKG).

**Key design decision:** FL gets a PL/SQL workflow extension (submit_* + act_on_approval in `DCT_FL_PKG`), mirroring CC's package-owned lifecycle — because FL's act logic must dispatch to 6 different approval callbacks and is needed by BOTH `/fl/` and the Admin unified inbox. ORDS handlers stay thin.

---

## Stage 0 — Plan + mockups ✋ USER REVIEW GATE

Create `assessment-3/phase4/00-phase4-plan.md` + `assessment-3/phase4/mockups/` (3 standalone HTMLs, EN/AR toggle, same pattern as phase3; use /frontend-design + /ui-design-system):

| Mockup | Shows |
|---|---|
| `01-fl-app.html` (#7C4DBE) | FL dashboard (stats + committed-vs-paid chart + doc-expiry horizon), freelancer detail (tabs: profile/bank/contracts/documents), contract detail (schedule table w/ generate-voucher, amendments/renewal), registration form |
| `02-cc-app.html` (#B0721E) | My Card (card visual, limit, pending-op chip, replenishment-due banner), 5-type request wizard (type → fields → doc checklist → submit), replenishment detail w/ merchant coding-lines editor, compliance chart |
| `03-approvals-delegations.html` | Admin unified inbox w/ PC/DT/FL/CC rows + "acting for" badge, My Delegations (create/cancel), Announcements admin + shared top-banner (severity colors, dismiss) |

No app/db code until approved.

## Stage 1 — FL backend ✋ DEPLOY GATE

1. **`final apps/FL/db/07_fl_pkg_workflow.sql`** — CREATE OR REPLACE `prod.dct_fl_pkg` keeping the 9 existing procs verbatim (diff before deploy; read `04_fl_pkg.sql` callback preconditions first), adding:
   - `submit_registration/contract/amendment/voucher/renewal/profile_change(p_id, p_user_id)` — validate per module settings, set SUBMITTED, create `dct_approval_instances` from the seeded `FL_*_APPROVAL` templates (module FREELANCERS), write back `approval_instance_id`, notify step-1 role, history row.
   - `act_on_approval(p_instance_id, p_user_id, p_action, p_comments)` — CC-pattern: record action, evaluate AMOUNT conditions (50k threshold), advance/complete. Final-approval dispatch: REGISTRATION→`create_freelancer_profile`; CONTRACT→ACTIVE + `mirror_contract_coding` + `generate_payment_schedule`; AMENDMENT→apply new_* + `rebuild_payment_schedule`; VOUCHER→APPROVED (+`push_to_fusion` if flagged); RENEWAL→`create_renewed_contract`; PROFILE_CHANGE→`apply_profile_change`. REJECTED/RETURNED handled with history + notify.
2. **`final apps/FL/db/08_fl_ords.sql`** — module `fl.rest`, base `/ords/admin/fl/`, ~36 handlers (PC skeleton): `dashboard/stats|charts`; `registrations/` CRUD+`/submit`+photo (HR base64/media pattern); `freelancers/` list/detail (+bank-accounts CRUD, photo); `contracts/` CRUD+`/submit`+`/schedule`+`/amendments`; `amendments/:id(/submit)`; `renewals/(+submit)`; `schedule/` (due worklist); `vouchers/` CRUD+`/submit`+`/mark-paid` (admin stand-in for the Fusion callback) — POST `{scheduleId}` = generate-from-schedule; `deliverables/(+accept|reject)`; `documents/` (unified dct_documents, expiryStatus filter, file PUT/media GET); `profile-changes/(+submit)`; `approvals/pending` (FL source modules + delegation clause) + `approvals/:id/action` → pkg; `lookups`, `gl-codes`, `settings`, `notifications/` (PC patterns). ADMIN synonyms for the 10 FL tables + 7 views (`dct_fl_*_v`) + pkg + sequences.
3. Update FL `install.sql`; deploy 07+08 (one gated event, fresh session); immediate API smoke.

## Stage 2 — FL JET app (`final apps/FL/Jet/`, scaffold from HR/Jet)

Standard app file set (index.html shell, app.css brand tokens #7C4DBE, main.js w/ $vm + chartjs paths, appController NAV_GROUPS + hash routing, config `apiBase: '/ords/admin/fl'`, services/api re-export of shared/api, authService read-only shared session → redirect to Admin, i18n app.{en,ar}.json, dev-proxy.py).

Nav (gating: viewer=FL_USER+, manager=FL_MANAGER+, admin=FL_ADMIN/SYS_ADMIN): home `dashboard` · people `registrations, freelancers` · contracts `contracts, paymentSchedule` · payments `vouchers, deliverables` · compliance(mgr) `documents` (expiry badge) · approvals(mgr) `approvals` · admin `moduleSettings`.

**17 view/VM pairs:** login, dashboard (2 charts via chartLoader: committed-vs-paid by org; doc-expiry horizon), registrations, registrationEdit, freelancers, freelancerDetail (tabs: profile/bank/contracts/documents), contracts, contractEdit (GL/PROJECT coding), contractDetail (schedule + generate voucher + amendments + renewal), paymentSchedule, vouchers, voucherDetail, deliverables, documents, approvals (comment-mandatory modal), moduleSettings, notifications. All lists tri-state + pager; all details `<audit-info>`.

## Stage 3 — CC ORDS ✋ DEPLOY GATE

**`final apps/CC/db/09_cc_ords.sql`** — module `cc.rest`, base `/ords/admin/cc/`, ~26 thin handlers over `dct_cc_pkg`: `dashboard/stats|charts`; `cards/` (`?mine`/all, detail + limit history, `cards/register` → `register_card`); `requests/` CRUD + `/submit` + `/withdraw` (pkg validates mandatory docs); `doc-requirements?context=`; `documents/` (+file PUT/media GET); `replenishments/` CRUD + `/lines` (replace-all into dct_budget_coding_lines source_type CC_REPL w/ merchant_name + `recalc_replenishment_total`) + `/submit`; `proxies/` CRUD; `approvals/pending` (CC_REQUEST/CC_REPLENISHMENT + delegation clause) + `/action` → `dct_cc_pkg.act_on_approval` (CUSTOM conditions stay in the pkg); `settings`; `notifications/`; `lookups`. Synonyms for CC tables/views/pkg/sequences. Gated deploy + smoke.

## Stage 4 — CC JET app (`final apps/CC/Jet/`, scaffold from HR)

Brand #B0721E. Gating: holder=any, approver=MANAGER/CC_ADMIN/SYS_ADMIN, admin=CC_ADMIN/SYS_ADMIN. Nav: home · my-card `myCard, myRequests, myReplenishments` · approvals · administration `allCards (register drawer), allRequests, allReplenishments, proxies, moduleSettings`.

**13 view/VM pairs:** login, dashboard (compliance stacked bar + limits-by-org), myCard (card visual + limit timeline + replenishment-due banner), requestNew (5-type wizard w/ doc-requirements checklist), requests (mine/all via `?mine`), requestDetail (history/docs/withdraw), replenishments, replenishmentDetail (PC reimbDetail pattern: merchant lines editor + receipt flags), approvals, allCards, proxies, moduleSettings, notifications.

## Stage 5 — Admin/platform ✋ DEPLOY GATE (dct.admin in-place redeploy)

Edits in `db/v2/11_dct_ords.sql` + new seed `db/v2/19_dct_delegation_announcement_seed.sql`:
1. Amount CASEs in `approvals/pending` + `approvals/` + the action handler: add the 8 FL/CC source modules.
2. Action handler: route `FL_%` → `dct_fl_pkg.act_on_approval`, `CC_%` → `dct_cc_pkg.act_on_approval` (PC/DT logic untouched).
3. **Delegation-aware pending**: extend the role predicate with an EXISTS over active `dct_delegations` (ALL_ROLES / SPECIFIC_ROLE / MODULE scopes, date window); emit `actingFor`. (PC/DT module-local pendings: documented follow-up — avoids 2 extra gated redeploys.)
4. New endpoints: `delegations/` GET(`?mine`)/POST + `/:id/cancel` (lazy expiry); `announcements/` GET/POST + `/:id` PUT + `announcements/active` (audience-filtered: ALL / my ROLE / MODULE, published & not expired).
5. Seeds: THEME_BRAND_COLOR module settings for FREELANCERS (#7C4DBE) / CREDIT_CARDS (#B0721E).
6. **Admin UI:** profile.js real delegations (replace the mock array; create/cancel); new System pages `delegations` (oversight) + `announcements` (CRUD EN/AR, severity, audience); i18n keys.
7. **Shared shell:** announcement banner in `shared/js/shell.js` (fetch `announcements/active`, severity styling in platform.css, sessionStorage dismiss) → appears in all apps; flip MODULES `url` for fl/cc (remove `soon`) — done LAST so the switcher never links to a dead app.

## Stage 6 — Integration seed (API-driven, like the UAT seeding)

Role grants via Admin APIs: AYESHA.AMERI→FL_ADMIN, NASER.ALKHAJA→FL_MANAGER+CC_ADMIN, SHAIKHA.GALAMERI→FL_USER; SHAIKHA.ALSUWAIDI = CC card holder. `assessment-3/phase4/tests/phase4_seed.ps1`: FL — 3 registrations (1→APPROVED→freelancer+bank), 2 contracts (1 approved→schedule→voucher approved; exercise the 50k threshold both ways), 1 amendment, 1 deliverable, near/far-expiry docs; CC — 2 cards registered, NEW_CARD request through approval, 1 withdrawn INCREASE_LIMIT, 1 replenishment w/ 3 merchant lines submitted; 1 delegation (NASER→AYESHA) + 2 announcements (INFO all, WARNING module).

## Stage 7 — Tests, UAT workbooks, report

- API smokes `phase4_fl_smoke.ps1` / `phase4_cc_smoke.ps1` / `phase4_admin_smoke.ps1` (lifecycle assertions end-to-end, envelope shapes, 401/400, delegation actingFor, announcements audience filtering).
- Playwright `phase4_fl_ui_check.py` / `phase4_cc_ui_check.py` / `phase4_platform_check.py` (every route renders error-free, 2 charts per app, pager, AR/RTL flip, audit-info present, role gating, switcher shows FL/CC live, banner shows + dismisses, profile delegations CRUD).
- Extend `final apps/uat-generator.py` (BRANDS + FL/CC case lists; Delegations/Announcements area added to Admin) → `final apps/FL/UAT/`, `final apps/CC/UAT/`.
- Report `assessment-3/phase4/README.md` + STATUS.md / CLAUDE.md / action-plan / memory updates.

## Order, gates, risks, effort

**0 mockups ✋ → 1 FL db+ORDS ✋ → 2 FL Jet → 3 CC ORDS ✋ → 4 CC Jet → 5 Admin redeploy ✋ + shell flip → 6 seed → 7 tests/report.**

Risks: FL callback preconditions (read `04_fl_pkg.sql` bodies before sequencing status updates vs callbacks); CREATE OR REPLACE of dct_fl_pkg must preserve the 9 existing procs verbatim; CC CUSTOM step conditions must stay inside dct_cc_pkg (never duplicated in Admin); verify FL number formats and the gl-codes source table against the PC handler; delegation predicate is cheap (indexed).

Effort ≈ 8.5 focused days. Deferred (documented): freelancer self-service portal, PC/DT delegation-aware module pendings, real Fusion integration (mark-paid stand-in).
