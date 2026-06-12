# Phase 4 — Build the Missing UIs — Execution Report

**Date:** 2026-06-12 · **Status:** ✅ Executed + tested (UAT round pending)
**Plan:** `00-phase4-plan.md` (approved) · **Mockups:** `mockups/` (approved)

Phase 4 closed the two module gaps (Freelancers App 203, Credit Cards App 202)
and finished the platform features that depended on them: the unified approvals
inbox now covers all 4 transactional modules, and delegations + announcements
went from empty tables to working end-to-end features.

---

## 1. What was built

### Stage 1 — FL backend (deployed)
- `final apps/FL/db/07_fl_pkg_workflow.sql` — `DCT_FL_PKG` extended with 6
  `submit_*` procedures + `act_on_approval` (package-owned approval engine,
  CC pattern). Final-approval dispatch: REGISTRATION→create profile,
  CONTRACT→ACTIVE + schedule, AMENDMENT→apply + rebuild schedule,
  VOUCHER→APPROVED (+Fusion stand-in), RENEWAL→new contract,
  PROFILE_CHANGE→apply. AMOUNT condition: ≥ 50k adds the FL_ADMIN step.
- `final apps/FL/db/08_fl_ords.sql` — module **`fl.rest`** at
  `/ords/admin/fl/` (~52 handlers): registrations (+photo), freelancers
  (+bank accounts), contracts (+schedule/amendments/renewals), vouchers
  (+generate-from-schedule/mark-paid), deliverables, unified documents,
  profile-changes, delegation-aware approvals, lookups/gl-codes/settings/
  notifications. Smoke: **27/27** full-lifecycle pass.
- `02_fl_views.sql` fix: `created_by` joins on **username** (ORA-01722 guard).

### Stage 2 — FL JET app (`final apps/FL/Jet/`, brand #7C4DBE)
17 view/VM pairs on the Phase 3 shared layer: dashboard (2 Chart.js charts),
registrations + registrationEdit (photo gate), freelancers + freelancerDetail
(4 tabs), contracts + contractEdit (GL/PROJECT toggle) + contractDetail
(schedule, generate voucher, amendments, renewals), paymentSchedule, vouchers
+ voucherDetail (invoice→submit→mark-paid), deliverables (accept/reject),
documents (expiry filter), approvals (comment-mandatory), moduleSettings,
notifications, login. Browser check: every route renders, charts draw,
pager works, AR/RTL flips, audit-info in Asia/Dubai — **0 console errors**.

### Stage 3 — CC ORDS (deployed)
- `final apps/CC/db/09_cc_ords.sql` — module **`cc.rest`** at
  `/ords/admin/cc/` (~27 templates, thin handlers over `DCT_CC_PKG`):
  cards (+register/limit-history), requests (+submit/withdraw),
  doc-requirements, unified documents (+file), replenishments (+replace-all
  merchant lines into `dct_budget_coding_lines` + recalc + submit), proxies,
  delegation-aware approvals → `dct_cc_pkg.act_on_approval`, lookups,
  gl-codes, settings, notifications. Smoke: **17/17**.
- `02_cc_views.sql` fix: `dct_cc_request_v` created_by join on username.

### Stage 4 — CC JET app (`final apps/CC/Jet/`, brand #B0721E)
13 view/VM pairs: dashboard (limits-by-org + 6-month replenishment
compliance charts), **myCard** (CSS card visual, limit-history timeline,
replenishment-due banner), **requestNew** (3-step wizard: type tiles →
details → mandatory-doc checklist with upload gate), requests (Mine/All
toggle for admins) + requestDetail (submit/withdraw), replenishments +
replenishmentDetail (merchant-lines editor with per-line GL/PROJECT coding
and receipt flags), approvals, allCards (+register drawer from approved
NEW_CARD requests), proxies, moduleSettings, notifications, login.
Browser check: **0 console errors**, AR/RTL pass.

### Stage 5 — Platform (dct.admin redeployed)
- `db/v2/11_dct_ords.sql`:
  - `approvals/pending` + `approvals/`: amount CASEs for the 6 FL + 2 CC
    source modules; **delegation-aware** role predicate (ALL_ROLES /
    SPECIFIC_ROLE / MODULE scopes, date window) emitting `actingFor`.
  - Action handler routes `FL_%` → `dct_fl_pkg.act_on_approval` and
    `CC_%` → `dct_cc_pkg.act_on_approval` (PC/DT logic untouched).
  - **New endpoints:** `delegations/` GET(?mine)/POST + `/:id/cancel`
    (lazy EXPIRED flip on every list), `announcements/` GET/POST +
    `/:id` PUT + `announcements/active` (audience-filtered: ALL / my ROLE /
    `?module=`).
- `db/v2/19_dct_delegation_announcement_seed.sql` — THEME_BRAND_COLOR rows
  (FREELANCERS #7C4DBE, CREDIT_CARDS #B0721E).
- **Admin JET:** profile "My Delegations" is now real (list/create/cancel,
  outgoing vs "acting for" incoming); new System pages **Delegations**
  (oversight + cancel) and **Announcements** (CRUD, EN/AR, severity,
  audience targeting, activate/deactivate).
- **Shared shell:** `shell.initAnnouncements()` renders dismissible
  severity-colored banners (sessionStorage dismiss) at the top of the work
  surface in **all 7 apps**; `platform.css` gained the `.ann-banner` styles;
  module registry now carries `mc` (module_code) per app.
- **Switcher flip:** FL + CC are live in the module switcher (no `soon`).
- Smoke: delegations round-trip, announcement audience filtering + PUT
  (after a CLOB CASE fix), approvals regression — pass.

### Stage 6 — Integration seed (`tests/phase4_seed.py`)
- Roles granted: AYESHA.AMERI→**FL_ADMIN**, NASER.ALKHAJA→**FL_MANAGER +
  CC_ADMIN**, SHAIKHA.GALAMERI→**FL_USER** (user-approved).
- CC: NEW_CARD→docs→approval→**CC-2026-00002** (SHAIKHA.ALSUWAIDI, 20k) and
  **CC-2026-00003** (HASHEM.ALKABBI, 12k); INCREASE_LIMIT submitted→WITHDRAWN;
  **CCM-2026-05-00001** May statement with 3 GL-coded merchant lines,
  SUBMITTED by the holder.
- FL: FL-REG-000004 (DRAFT), FL-REG-000005 (SUBMITTED), **FL-CON-000002**
  (84k) verified pending at step 2 of 2 (≥50k path).
- Delegation NASER→AYESHA (14 days) + 2 announcements (INFO/ALL bilingual,
  WARNING targeted at CREDIT_CARDS).

### Stage 7 — Tests, UAT, docs
- `tests/`: `phase4_fl_smoke.ps1` (27/27), `phase4_cc_smoke.py` (17/17),
  `phase4_admin_smoke.py`, `phase4_fl_ui_check.py`, `phase4_cc_ui_check.py`,
  `phase4_platform_check.py`, `phase4_seed.py`.
- Platform browser check: banner renders (bilingual, severity colors),
  switcher shows 7 modules with **0 soon-flagged**, Delegations page (3
  rows), Announcements page (4 rows), profile delegations + create modal,
  unified inbox shows FL-CON + CCM rows — **0 console errors**.
- UAT workbooks: **FL 35 cases / 10 areas**, **CC 29 cases / 8 areas**,
  **Admin v2 64 cases** (new *Delegations & Announcements* area, 9 cases;
  round-1 filled workbook preserved — v2 is a separate file).
  `uat-generator.py` now takes app filters + `UAT_SUFFIX`.

---

## 2. Defects found & fixed during the phase

| # | Defect | Fix |
|---|---|---|
| 1 | FL/CC `*_v` views joined `created_by` (username) to `user_id` → ORA-01722 | join on `username` |
| 2 | FL authService/notificationService still referenced HR `mockData` (404 = app dead) | ORDS-only rewrites |
| 3 | FL main.js exposed `window._hrApp` while VMs call `window._jetApp` → navigation no-op | renamed |
| 4 | FL dashboard charts blank: canvases inside `ifnot: loading()` rendered after `getCharts()` resolved | `Promise.all` then render |
| 5 | Chart legend showed raw i18n keys (`t()` returns the key, `||` fallback never fires) | keys added EN/AR |
| 6 | `announcements/:id` PUT 555: `CASE` mixing VARCHAR2/CLOB branches (ORA-00932) | `TO_CLOB()` |
| 7 | SQLcl swallowed an entire LF-only seed script (silent!) | CRLF line endings; diagnose with `SET ECHO ON` |
| 8 | Seed 500s: FL nationality codes are 2-letter ISO (`JO`), not 3-letter | resolve via `/fl/lookups` |

## 3. Deferred (documented)
- Freelancer self-service portal (FL_FREELANCER persona) — Phase 4.5/5.
- PC/DT module-local pending lists are not delegation-aware (the Admin
  unified inbox is; avoids 2 extra gated redeploys).
- Real Fusion integration — `mark-paid` is an admin stand-in.
- APEX Builder pages for FL/CC.

## 4. UAT entry point
1. `python "final apps/Admin/Jet/dev-proxy.py"` → http://localhost:8080
2. Workbooks: `final apps/FL/UAT/`, `final apps/CC/UAT/`,
   `final apps/Admin/UAT/UAT_Admin_TestScript_v2.xlsx` (Delegations &
   Announcements + FL/CC switcher cases).
3. Personas per workbook Instructions sheet (roles seeded in Stage 6).
