# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**i-Finance** is a suite of Oracle APEX + Oracle JET SPA applications for the Finance Division of a UAE government organisation. The platform runs on Oracle Autonomous Database (ADB) 23ai/26ai in OCI.

**App 200 (Admin)** is the central identity provider. All other module apps authenticate through it.

---

## Repository Layout

```
final apps/          ← ALL live production code lives here
  Admin/Jet/         ← App 200 — JET SPA (auth, users, roles, settings)
  PC/Jet/            ← App 201 — Petty Cash JET SPA
  DT/Jet/            ← App 204 — Duty Travel JET SPA
  HR/Jet/            ← App 205 — HR JET SPA
  FL/Jet/ + FL/db/   ← App 203 — Freelancers JET SPA + module DB scripts
  FL/Portal/         ← External freelancer self-service portal (plain KO SPA,
                       own ifinance_portal_session — NOT a module app; see
                       FL/docs/deployment-notes.md and 09_fl_portal.sql)
  CC/Jet/ + CC/db/   ← App 202 — Credit Cards JET SPA + module DB scripts
  SHARED_JET_ARCHITECTURE.md   ← session contract, module checklist
  SHARED_APEX_ARCHITECTURE.md  ← APEX auth scheme, app items, LOVs
  DT/STATUS.md       ← per-module status tracking (replicated per module)

db/v2/               ← All DCT_* DDL, packages, ORDS setup (source of truth)
  install.sql        ← master script: runs 01→12 in order
  01_dct_ddl.sql     ← 24 DCT_* tables
  03_dct_auth_pkg.sql← DCT_AUTH package
  11_dct_ords.sql    ← all ORDS module definitions (Admin /dct/ path)
  12_dct_master_data.sql ← reference tables (grades, countries, GL codes…)
  15_dct_unified_structures.sql ← Phase 2: natural-key masters + unified
                       documents / coding-lines / status-history + DCT_LOOKUP_PKG
  16_dct_missing_fks.sql ← Phase 2: natural-key FKs + lookup-first migration
  17_dct_user_photo.sql  ← DCT_USERS photo_blob/photo_mime_type (profile photos via /dct/users/:id/photo)
  19_dct_wave_enhancements.sql ← Wave 1-4: template draft lifecycle, /dct/boot,
                       notifications/count, audit/:id snapshots, FEATURE_*/LANDING_* seeds,
                       validate_session inactivity timeout (deployed 2026-06-13)
  20_dct_enhancements2.sql ← Enh round 2: settings PUT upsert, audit fromdt/todt + /audit/export CSV,
                       /dct/sessions/ + sessions/revoke, approval-templates/:id/restore,
                       INTEGRATION_API_KEY secret seed (deployed 2026-06-13)
  21_uat_cleanup.sql   ← rerunnable UAT artifact housekeeping (park uat.auto.* users,
                       close their sessions, drop UAT_WAVE_FLOW~V% archives)
  22_region_theme.sql  ← THEME_REGION_* settings (region header/border theming)
  23_fl_uat_cleanup.sql ← rerunnable FL UAT data housekeeping (runner registrations/
                       contracts/vouchers + invoice-less drafts on the two seeded
                       sample contracts; preserves seeded samples)
  24_dct_audit_pkg.sql ← DCT_AUDIT_PKG (snapshots_on/snap/log) + per-module switches
                       FEATURE_AUDIT_SNAPSHOTS_<ADMIN|PC|DT|HR|FL|CC|AR> (+ global default;
                       all default N). Populates dct_audit_log.old_values/new_values for the
                       audit-diff modal; all 7 module ORDS scripts call it from their core
                       create/update handlers (deployed 2026-06-13)
  26_focus_theme.sql ← configurable field-focus highlight (all apps): THEME_FOCUS_COLOR
                       (COLOR) + FEATURE_FOCUS_HIGHLIGHT (Y/N) APPEARANCE settings + /dct/boot
                       whitelist; applied at boot by shell.js as --focus-color/--focus-ring
                       (platform.css). Admin-only global; edit in System Settings → Field Focus
                       Highlight (deployed 2026-06-15)
  28_push_tokens.sql ← Mobile push infra (App 209): DCT_DEVICE_TOKENS + DCT_PUSH_OUTBOX +
                       AFTER-INSERT trigger on DCT_NOTIFICATIONS (fans to devices, leaves
                       DCT_NOTIFY untouched) + DCT_PUSH_PKG (register/unregister/send_pending) +
                       DCT_PUSH_SWEEP job (drains outbox → Expo Push every minute) + ORDS
                       POST /dct/devices/register + DELETE /dct/devices/:token. exp.host network
                       ACL granted. DEPLOYED to PROD 2026-06-20 (all VALID, smoke-tested)
  29_user_photo_binary.sql ← raw-binary profile photo PUT /dct/users/:id/photobin (reads :body
                       BLOB, MAX_UPLOAD_MB guard) for mobile/modern clients; legacy base64
                       /users/:id/photo (web) untouched. DEPLOYED 2026-06-20

ifinance-mobile/     ← App 209 — React Native + Expo (TypeScript) cross-platform mobile client
                       (iOS+Android). Thin native client over the shared /dct/ ORDS APIs; MVP =
                       approvals + notifications + delegations + profile + biometric login + push.
                       tsc + Metro bundle clean; see ifinance-mobile/README.md + docs/deployment-notes.md

apps/ifinance-v2/    ← LEGACY: vanilla JS task management prototype (localStorage only)
                       Superseded by final apps/ — do not add features here

docs/                ← proposals, APEX setup guides, analysis
myDoc/               ← Oracle Wallet + tnsnames for ADB connection
```

---

## Running the JET SPA Locally

Every JET app has `dev-proxy.py` in its root. It serves static files on port 8080 and proxies `/ords/` requests to ADB (adds CORS headers).

```bash
# From final apps/Admin/Jet/
python dev-proxy.py
# Open http://localhost:8080
```

The Admin app is the only one that needs to run for full auth. Module apps redirect to `../Admin/Jet/index.html` when no session is found.

Toggle between mock (localStorage) and live ORDS in `js/services/config.js`:
```js
// apiBase: null,            // mock mode — no network calls
apiBase: '/ords/admin/dct',  // live via dev-proxy
```

---

## Database Connection

Use SQLcl at `C:\claude\tools\sqlcl\sqlcl\bin\sql.exe`.

```powershell
sql -name prod_mcp
```

**Always use SQLcl for DB scripts — never the MCP `run-sql` tool**, which silently swallows errors.

All packages and objects must be created in PROD schema. When running from an ADMIN session prefix with schema:
```sql
CREATE OR REPLACE PACKAGE prod.package_name AS ...
```

Add `SET DEFINE OFF` at the top of every seed script — `&` in string literals triggers a substitution variable prompt that hangs SQLcl.

---

## JET SPA Architecture

All JET apps share the same pattern. Full contract is in `final apps/SHARED_JET_ARCHITECTURE.md`. Key points:

**Custom router — no ojs/* CDN imports.** `main.js` wires a `ko.bindingHandlers.module` that swaps view HTML + ViewModel into a container element. Never import `ojs/*` paths in `define([])` — they 404 on the CDN config used here.

**All services return Promises.** VMs initialise observables empty (`ko.observableArray([])`) then populate in `.then()`. Never store a Promise directly in a `ko.observableArray()`.

**Session key** is always `'ifinance_jet_session'` in every app. Module apps only read it; only Admin JET writes it on login/logout.

**`api.js`** injects `Authorization: Bearer <token>` on every request and auto-navigates to `login` on 401.

**KO binding patterns in views:**
- Use `<!-- ko if: --> / <!-- /ko -->` and `data-bind="text: ..."` — the existing codebase uses raw KO, not JET's `<oj-if>` / `<oj-bind-text>`. The IDE shows advisory warnings; ignore them.
- Never wrap KO-bound `<input>` in `<label>` — causes double-toggle. Use `<div>` + `pointer-events:none` on the input.
- Use **`$vm.method()`** when calling VM methods inside `foreach`/`with`/templates at any depth — the module binding injects `$vm` (the view's own viewModel) into the binding context. `$root` is the shell AppController (only `$root.t()`, `$root.lang()`, `$root.setLang()` belong to it); `$root.<vmMethod>` silently breaks.
- Never call `ko.cleanNode(element)` on an element's own binding — only clean child nodes.

**Services are ORDS-only (Admin JET).** All 8 Admin JET services (`authService`, `userService`, `roleService`, `orgService`, `moduleService`, `settingService`, `notificationService`, `auditService`) call ORDS directly — no mock branches, no `mockData` imports, no localStorage fallback. `mockData.js` is present but unused. Module apps (PC, DT, HR …) may still have `apiBase: null` in their `config.js` and remain in mock mode until their ORDS endpoints are wired.

**`roleService.getPermissionMatrix()` return shape** is `{ roles: [...], matrix: [...] }` — not a flat array. The `matrix` array contains rows with `permId`, `permCode`, `permName`, `module`, and a `role_<roleId>: boolean` key per role. VMs must destructure: `result.roles` and `result.matrix`.

**`roleService.setRolePermissions(roleId, permIds)`** — added alongside `update()`. Sends `PUT /roles/:id` with `{ permIds }`. Used by both `permissions.js` and `roleEdit.js` VMs.

---

## APEX Module Architecture

Full checklist in `final apps/SHARED_APEX_ARCHITECTURE.md`. Key rules:

- **Build pages in APEX Builder (24.2) first**, then export via `apex_export.get_application`. Never hand-author page SQL scripts.
- Every new module app subscribes to App 200's `DCT Auth` scheme, standard app items, and common LOVs — never create standalone copies.
- `SET_APP_ITEMS` (On New Session) is the standard process body that populates `APP_USER_ID`, `APP_ORG_ID`, `APP_IS_ADMIN`, etc.

---

## ORDS on ADB — Critical Rules

**Module path:** All ORDS modules must be registered under ADMIN schema at `/ords/admin/<module>/`. `ORDS.ENABLE_SCHEMA('PROD')` does not make `/ords/prod/...` routable on ADB managed ORDS.

**Authorization header:** ADB managed ORDS passes the Bearer token under CGI env key `'AUTHORIZATION'` (no `HTTP_` prefix). `OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION')` returns NULL on ADB. `DCT_REST.VALIDATE_SESSION` already handles this with a fallback — do not regress it.

**Synonyms:** ORDS handlers execute as ADMIN. Every PROD object referenced in handler PL/SQL needs an ADMIN synonym:
```sql
CREATE OR REPLACE SYNONYM dct_rest FOR prod.dct_rest;
```

**Handler pattern:** Use `q'[...]'` for string literals containing special characters. Call `dct_rest.validate_session(:body)` at the top of every protected handler. Return JSON via `APEX_JSON` package.

**Local time display (UTC→Asia/Dubai):** the ADB is UTC (`DBTIMEZONE +00:00`) and every timestamp/date column is written by `SYSTIMESTAMP`/`SYSDATE` (UTC). The org is UAE-only (Asia/Dubai, fixed +04:00, no DST), so **storage stays UTC and every datetime is converted only on display**. Wrap each display `TO_CHAR` with the shared helper: `TO_CHAR(dct_to_local(col), '<fmt>')` (`prod.dct_to_local` = `FROM_TZ(ts,'UTC') AT TIME ZONE 'Asia/Dubai'`, `db/v2/30_dct_tz_local.sql`, ADMIN synonym present). Applied platform-wide 2026-06-21 (205 calls across all 10 ORDS modules). **Never wrap** `TO_CHAR(SYSDATE/SYSTIMESTAMP,…)` — those build reference numbers / job names / `TO_DATE` defaults / filenames and must stay UTC — and never wrap timestamp **differences/comparisons** (TZ-agnostic) or `WHERE`/filter `TO_CHAR`. Any NEW handler that displays a stored datetime must use `dct_to_local`.

**Time format = 12-hour AM/PM (2026-06-21):** displayed times use `HH:MI AM` (e.g. `2026-06-21 10:23 PM`), not 24-hour. Server handlers: the human display `TO_CHAR` formats are `'YYYY-MM-DD HH:MI AM'` (NOT `HH24`); ISO `…"T"HH24":"MI":"SS` machine formats stay 24h (the client parses them). Client side: `shared/js/i18n.fmtDate(iso, {...})` callers that include `hour` must pass `hour12: true` (Admin audit log + sessions do). Date-only displays (PC/DT/HR via bare `fmtDate`) are unaffected.

**Public branding endpoint:** `GET /dct/branding` is the ONLY unauthenticated handler (the login page renders pre-session). It exposes just the whitelisted UI keys `APP_NAME` / `APP_NAME_AR` / `APP_TAGLINE` / `APP_TAGLINE_AR` from `DCT_SYSTEM_SETTINGS` — never add secrets to it. The Admin login title/subtitle bind to it (login.js fetch with static/i18n fallback) and are editable on the System Settings page.

---

## Database Layer

**Key packages in PROD schema:**
- `DCT_AUTH` — authenticate, validate_session, has_role, has_permission, open/close session
- `DCT_REST` — validate_session (reads Authorization header), parse_body, err()
- `DCT_NOTIFY` — send, mark_read, get_count, purge
- `DCT_LOOKUP_PKG` — `is_valid` / `validate_lookup` (raises -20090). **Lookup-first rule:** status/enum value sets live in `DCT_LOOKUP_VALUES` (managed in Admin lookups.html), not CHECK constraints. New/refactored tables get no status CHECKs; packages and handlers call `validate_lookup`. PC/DT keep their legacy CHECKs as safety nets until those modules adopt.

**Unified shared structures (Phase 2, 2026-06-11):** `DCT_DOCUMENTS` (+ `DCT_DOC_REQUIREMENTS`, `DCT_DOC_EXPIRY_ALERTS`), `DCT_BUDGET_CODING_LINES`, `DCT_REQUEST_STATUS_HISTORY` — discriminated by `(source_module, source_type, source_id)`. CC and FL use them natively (their private doc/attachment/line tables are dropped); PC ORDS writes status history. FL convention: `dct_documents.reference_id` carries the freelancer_id.

**Natural-key project-costing masters (no surrogate IDs):** `DCT_PROJECTS` (`project_number VARCHAR2(12)` PK), `DCT_TASKS` (`(project_number, task_number VARCHAR2(30))` PK — replaced `DCT_PROJECT_TASKS`), `DCT_EXPENDITURE_TYPES` (`expenditure_type VARCHAR2(255)` PK). Module project/task/exp-type columns FK directly to them (22 validated FKs; DT's inline columns pending DT adoption).

**Non-obvious column names (bitten us before):**
| Table | Gotcha |
|---|---|
| `DCT_USER_ROLES` | date column is `end_date`, not `valid_to`; `chk_dct_ur_dates` requires `end_date >= start_date` and `start_date` defaults to SYSDATE *with time* — never close assignments with `TRUNC(SYSDATE)` (ORA-02290 for same-day rows); use `GREATEST(SYSDATE, start_date)` |
| `DCT_APPROVAL_INSTANCES` | status column is `overall_status`; join steps via `template_id + current_step_seq` |
| `DCT_LOOKUP_VALUES` | columns are `value_code` / `value_name_en` / `display_order` |
| `DCT_GL_CODE_COMBINATIONS` | segment columns end in `_code` (`account_code`, not `account`); `cc_code` is a virtual column with the full 9-segment concatenation — use it for display |
| `DCT_NATIONALITY` | name columns are `nationality_en` / `nationality_ar`, not `nationality_name_en` |
| `DCT_AUTH.HAS_ROLE` | takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |

**INSERT ALL + IDENTITY columns:** Raises ORA-00001. Use individual `INSERT INTO` per row instead.

**ADMIN synonyms need a fresh session:** scripts that `CREATE OR REPLACE SYNONYM x FOR prod.x` must NOT run in a SQLcl session where an earlier script set `ALTER SESSION SET CURRENT_SCHEMA = PROD` — the synonym becomes self-referencing (ORA-01471). Run ORDS/synonym scripts in their own `sql -name prod_mcp` invocation.

**Shared tables used across modules:** `DCT_EMPLOYEES`, `DCT_DATA_ACCESS_ASSIGNMENT`, `DCT_LOOKUP_VALUES`, `DCT_GL_CODE_COMBINATIONS`. See `db/v2/12_dct_master_data.sql` for reference table details (countries, grades, currencies, banks, document types).

---

## Module Status

| Module | DB + ORDS | JET SPA | APEX Pages |
|--------|-----------|---------|------------|
| Admin (App 200) | ✅ Complete | ✅ Live ORDS | ✅ Users/Roles built |
| Petty Cash (App 201) | ✅ Complete (ORDS live `/pc/`) | ✅ Complete (live) | ⬜ Pending in Builder |
| Duty Travel (App 204) | ✅ Complete (ORDS live) | ✅ Complete (live) | ⬜ Pending in Builder |
| HR (App 205) | ✅ Complete (ORDS live) | ✅ Complete (live) | ⬜ Pending in Builder |
| Freelancers (App 203) | ✅ Complete (`fl.rest` live `/fl/`; DCT_FL_PKG workflow engine) + **Phase 1 Registration revamp 2026-06-27** (AI doc-extraction `DCT_FL_AI_PKG` vision Passport/EID/Bank-letter → field pre-fill, gated `AI_FEATURES_ENABLED`; dual-channel intake = staff JET + public Portal email-OTP; `DCT_FL_REG_PKG` dedup (exact block/fuzzy flag/FL-Admin override) + OTP; **line-manager-first** approval via per-instance `dynamic_approver_user_id` + USER_SPECIFIC step + additive shared-inbox patch; bank capture→account on approval; `final apps/FL/db/11–16` + `db/v2/11b`. Also re-granted `EXECUTE ON DBMS_CLOUD TO PROD` — had been lost, all `*_AI_PKG` were INVALID) | ✅ Complete (live, 17 views, #7C4DBE; APP_VERSION 4.6.0; Portal 1.1.0 self-registration wizard) | ⬜ Not started |
| Credit Cards (App 202) | ✅ Complete (`cc.rest` live `/cc/`; thin handlers over DCT_CC_PKG) | ✅ Complete (live, 13 views, #B0721E) | ⬜ Not started |
| Task Management (App 207) | ✅ Complete (`tm.rest` live `/tm/`; DCT_TM_PKG + DCT_TM_REMINDER_PKG; + 2026-06-20 Reporting-Cycle wave — DCT_TM_VIS_PKG + DCT_TM_CYCLE_PKG, team hierarchy, visibility grants, cycle job, `final apps/TM/db/09–15`; **06 ORDS DELETE_MODULEs tm.rest so always run 14 right after 06**) | ✅ Complete (live, 15 views, #0E8A8A; member check-in + executive view + visibility grants + role CRUD + AI period summary + Gantt timeline; APP_VERSION 4.8.0; AI via DCT_TM_AI_PKG reusing AR ANTHROPIC key, gated by AI_FEATURES_ENABLED) | ⬜ Not started |
| Analytics Loader (App 208) | ✅ Complete (`atd.rest` live `/atd/`; control plane over OTBI→ATD tables + ATD_QUEUE_PKG; DB in `otbi-atd/db/`) + **Fusion write-back ACTIONS 2026-06-20** (inverse of extract: `ATD_ACTION_REQUEST`+`ATD_ACTION_PKG` `otbi-atd/db/19`, idempotent SKIP-LOCKED queue; first type `AP_INVOICE` from approved PC reimbursements via `DCT_PC_FUSION_PKG` `final apps/PC/db/07` + approval hooks in `06_pc_ords`/`db/v2/14`; runner `--actions` UI-robot driver reuses SSO session, `ATD_ACTION_LIVE=1`-gated, idempotency pre-check; `run_atd_actions.ps1` shares `.otbi_runner.lock`; `/atd/actions*` ORDS `otbi-atd/db/20`. **Gate `FUSION_POST_REIMB` defaults N**; headed live Fusion test pending) + **Manage Job Sets 2026-07-01** (`otbi-atd/db/40` `ATD_JOB_SET`+`ATD_JOB_SET_MEMBER` [PK job_name = one set/job] + SQL-callable `atd_set_gate_ok`/`atd_set_eff_freq`/`atd_set_next_run` + `ATD_SET_PKG` run_now/notify_sweep + `ATD_SET_NOTIFY_JOB`; grouped scheduling drives the live browser track — enqueue [db/12 2-token edit] gates members by set window/pause/enable + set interval; additive ORDS `/atd/job-sets*`+`/job-set-jobs` `db/41`; failure notify gated `ATD_SET_NOTIFY_ENABLED`=N; deploy 40→re-run 12→41 fresh session; E2E 11/11) | ✅ Complete (live, 9 views inc. Actions + **Job Sets** [list + detail: interval presets/day+time window, per-member enable/order, ≈next-run, Run Set Now/Pause, set run-history, failure-notify], #3A4FB0; APP_VERSION 1.18.0) | ⬜ N/A (admin tool) |
| Mobile (App 209) | ✅ Push infra DEPLOYED 2026-06-20 (`db/v2/28` DCT_DEVICE_TOKENS + outbox + `/dct/devices` + sweep job + exp.host ACL; `db/v2/29` binary user-photo `/photobin`) | ✅ MVP live on Android — RN+Expo TS in `ifinance-mobile/`; **on-device smoke test PASSED incl. end-to-end push** (2026-06-20); approvals/notifications/delegations/profile/biometric/EN-AR-RTL/dark. **Phase 2 CODE COMPLETE 2026-06-20 (v1.2.0, no DB change):** multi-module client `api.for(mod)` + offline write-queue (`requireOnline` + Outbox) + **full ATD admin** (App 208, role-gated SYS_ADMIN): Dashboard + Manage menu, Jobs full mgmt (enable/disable/remap/rebuild/delete), Environments/Targets CRUD, Runner Settings (`/config`), Queue, Discovery (`ifinance-mobile/MOBILE_PHASE2_PLAN.md`); pending preview rebuild + on-device test. iOS pending Apple Org | ⬜ N/A (native app) |
| General Ledger (App 210) | ✅ Complete (`gl.rest` live `/gl/`; DEPLOYED 2026-06-28). **Date-tracked CoA classification layer** over the Fusion-loaded `ATD_GL_*` tables: 3 dimensions — **Sector** (cost-center segment), **Chapter** (appropriation segment), **DCT Program** (program segment, hierarchical PBB). Generic type→value→assignment model (`DCT_GL_CLASS_TYPE`/`_VALUE`(+3 alt-name cols)/`_SEG_CLASS_MAP`), effective-dated with overlap guard; `DCT_GL_CLASS_PKG` (`norm`/`set_asof`/`resolve_value_id`/`validate_map`) + `GL_CTX` context; unified **`DCT_GL_COA_V`** (9,338 rows, all 10 segments + descriptions + effective classifications, as-of via SYS_CONTEXT) + `DCT_GL_BALANCES_V`. **`GL_SRC_*` bridge synonyms** insulate the planned `ATD_GL_*→GL_*` rename. Seed from 3 CSVs (`db/source/`, generator `db/gen_seed.py`): 21 sectors/7 chapters/41 programs, 91% combinations sector-classified. Scripts `final apps/GL/db/01–06`. **+ Actuals reporting 2026-06-30** (`db/v2/32–35`): base pass-through views (`AP_*`/`PO_*`/`GRN_ALL_V2`/`GL_BALANCES`), `DCT_ACTUAL_V` (unified AP/PO/GRN/GL fact, AED-converted), `DCT_BUDGET_ACTUAL_V`, `DCT_BUDGET_ACTUAL_PERIOD_V` (per combination × period YTD; +appropriation; +`commitment_ytd`=PR-backed & `obligation_ytd`=all PO distribution lines, +`open_commitment_ytd`/`open_obligation_ytd`=the unliquidated subset (`FUNDS_STATUS IN ('Reserved','Partially Liquidated')`), +`po_count`/`pr_count` per combination, read live from `po_distributions`; **AP Direct = AP lines with `po_number IS NULL`** (true direct AP, 2026-07-01)), indexed `DCT_GL_COA_SNAP` + `prod.dct_actuals_refresh` + hourly `DCT_ACTUALS_REFRESH_JOB`; ORDS `/actuals/filters`(+accounts/costCenters),`/actuals`(+account/costcenter/source filters,+commitment/obligation/openCommitment/openObligation/slaActual/poCount/prCount),`/actuals/lines`(+commitment/openCommitment→PR lines,+obligation/openObligation→PO lines),`/dashboard`,`POST /actuals/refresh` (see [[project_actuals_reporting_views]]) | ✅ Complete (live; **Portal-style** single-file KO SPA in `GL/Jet/`, NOT the JET shell — mirrors FL/Portal aesthetic, #3F6F5F; Overview/**Actuals**/**Dashboard**/Classifications/Mapping/Explorer; EN-AR-RTL; as-of date + CSV export; Actuals = full-viewport-width Budget-vs-Actual report w/ business-question cards (incl. Commitment/Obligation [+PR/PO counts] + Open Commitment/Open Obligation w/ visible ⓘ hints + **SLA Actual**=GRN+AP Direct) + Sector/Chapter/Program/Appropriation/Account/Cost-center/Trx-source filters + per-figure drill-down (commitment/openCommitment→PR lines, obligation/openObligation→PO lines) + combination tooltip; Dashboard = utilisation gauge + period-over-period trend + by sector/program/appropriation + auto-insights (hand-built SVG/CSS); **Refresh actuals** button on GL + ATD; E2E Playwright-verified; APP_VERSION 1.4.0) | ⬜ N/A (JET only) |
| Reporting / BI (App 211) | ✅ Complete (`rpt.rest` live `/rpt/`; DEPLOYED 2026-06-30). **Reporting Platform** in `reporting/` — free scheduled **PDF+Excel** reports emailed to recipients with dynamic vars; **ONE shared DB control plane, TWO engines** (a definition's `engine` col routes to PYTHON or NATIVE). DB (`reporting/db/01–05,07`): 7 `DCT_RPT_*` tables (DEFINITION/SCHEDULE/RECIPIENT/RUN/OUTPUT(BLOB)/DELIVERY/CONFIG), `DCT_RPT_PKG` (enqueue/claim_next SKIP-LOCKED/mark_status/record_output/record_delivery/resolve_recipients USER\|ROLE\|ORG\|EMAIL\|SELF/reclaim_stuck), `DCT_RPT_SCHED_SYNC` (control-table→DBMS_SCHEDULER, mirrors `ATD_SCHED_SYNC`) + `DCT_RPT_MAINT_JOB` (15-min reclaim+purge), 8 RPT_* lookup-first vocabularies, pilot `GL_BUDGET_ACTUAL`. **Phase 1 Python engine** (`reporting/runner/`, mirrors otbi-atd/runner): Jinja2→Playwright/Chromium PDF + openpyxl Excel + smtplib email; claim→render→archive→deliver→mark; E2E-verified (run produced valid 846KB PDF + 195KB XLSX from 3313 rows). `EMAIL_ENABLED=N` until SMTP set (pilot = own Gmail/Yahoo app password, no IT; prod = OCI Email Delivery + SPF/DKIM). **Phase 3 NATIVE engine** (`06_rpt_native_pkg.sql`): `DCT_RPT_NATIVE_PKG` + `DCT_RPT_NATIVE_JOB` sweep (claims `engine='NATIVE'` QUEUED runs, in-DB `APEX_DATA_EXPORT` PDF+XLSX with BI brand colours via `get_print_config` + `APEX_MAIL`, headless `apex_session.create_session`); pilot `GL_BUDGET_ACTUAL_NATIVE` VERIFIED (SUCCESS, 3313 rows, PDF 763KB+XLSX 148KB). Reporting Platform feature-complete (both engines behind one control plane + UI). See [[project_reporting_platform]] | ✅ Complete (live; JET module app `final apps/BI/Jet/`, SYS_ADMIN-gated, #1F6F8B; Dashboard/Reports/Report-detail(schedules+recipients)/Run-history/Run-detail(download PDF/XLSX+deliveries+retry)/Settings(SMTP/runtime config); EN-AR-RTL; browser smoke 16/16 PASS; APP_VERSION 1.0.0) | ⬜ N/A (JET only) |

Full evaluation + phased action plan: `assessment-3/` (2026-06-11). Phase 1 executed + tested — report in `assessment-3/phase1/`. Phase 2 (data-model convergence: natural-key masters, unified tables, lookup-first, 22 FKs, CC+FL adoption) executed + tested 2026-06-11 — report in `assessment-3/phase2/`. Phase 3 (frontend foundation: `final apps/shared/` layer, page-level shell with module switcher, EN/AR i18n+RTL, tri-state lists, server pagination on users/audit/pc-all/dt-requests/hr-employees, Chart.js dashboards ×4, new `/dct/stats/` + `/dct/prefs/` endpoints) executed + tested 2026-06-11 — report in `assessment-3/phase3/`. Phase 4 (FL + CC apps: `fl.rest`+`cc.rest`, FL JET ×17 + CC JET ×13 views, unified approvals inbox covering all 4 modules with delegation-aware pending + `actingFor`, new `/dct/delegations/` + `/dct/announcements/` endpoints, Admin Delegations/Announcements pages, shared-shell announcement banner in all apps, switcher flipped live for FL/CC, UAT workbooks FL 35 / CC 29 / Admin v2 64 cases) executed + tested 2026-06-12 — report in `assessment-3/phase4/`. Platform sweep job `DCT_APPROVAL_PKG` (db/v2/14) activates approval escalation/auto-approve daily 07:10.

---

## Adding a New Module App — Requirements Checklist

**This is the canonical checklist for building ANY new module app. Keep it here and extend it whenever a new requirement is learned.** It encodes hard-won lessons (the TM/App 207 build hit every one of these). Treat each item as mandatory unless the user explicitly waives it. Model the new app on the most recent complete module (CC or TM), not on older ones.

### 0. Plan & approval
- Produce a written plan (`final apps/<App>/<APP>_PLAN.md`) and get explicit approval **before** implementing. Build **layer-by-layer** (DB → package/views → ORDS → frontend → jobs → docs/UAT), deploying and verifying each layer before the next.
- Include the **full functional-test strategy** in the plan (Unit, System, UAT, Regression) covering Happy Path, Edge Cases, Error Handling (400/401/403/404/500) and Boundary Values.

### 1. Identity & scaffold
- Allocate App number, `module_code`, brand colour, ORDS base `/ords/admin/<mod>/`, package(s) `<mod>.rest` + `DCT_<MOD>_PKG`.
- Folder structure **mirrors CC**: `final apps/<App>/` with `Jet/`, `db/`, `tests/`, `docs/`, `UAT/`, `guides/`, `STATUS.md`, `<APP>_PLAN.md`.
- Register the app in `final apps/shared/js/shell.js` MODULES array **and** `shared/i18n/common.en.json` + `common.ar.json` (`mod.<key>` + `.desc`).
- Add the app to `SIBLING_APPS` in **every** app's `dev-proxy.py` (all of them — the switcher uses root-absolute `/<App>/Jet/` URLs).
- Add the app to this file's **Module Status** table.

### 2. Auth & shell (shared session — never a private login)
- Production auth is via **App 200 (Admin)**. The app has NO real login: when no `ifinance_jet_session` exists it redirects to `../Admin/Jet/index.html`. Only Admin writes the session.
- **Scrub copy artifacts** when cloning another app: `login.html` brand cube/title/subtitle, `authService.js` header comment + role-helper method names, `config.js` (`apiBase`/`authBase`/`adminPortalUrl`). Shipping the source app's branding is a defect (TM shipped an "HR" login cube).
- Bump `window.APP_VERSION` in the app's `Jet/index.html` on every frontend deploy. **A change under `final apps/shared/` requires bumping `APP_VERSION` in ALL apps.**

### 3. Frontend — USE the shared platform design system (NON-NEGOTIABLE)
- `final apps/shared/css/platform.css` is the ONE structural stylesheet. Build views with the **platform classes**, never bespoke ones: `.form-grid`/`.form-group`/`.form-label`/`.form-control`; `.modal-overlay`/`.modal-box`/`.modal-header`/`.modal-body`; `.data-table`(+`.data-table-wrap`); `.btn`/`.btn-primary`/`.btn-secondary`/`.btn-sm`; `.card`, `.badge`, `.empty-state`, `.avatar`; `.page-header-row`+`.page-actions`; `.section-heading-row`+`.region-actions`.
- **Do NOT invent `.input` / `.modal` / `.modal-backdrop` markup, and do NOT wrap KO-bound inputs in `<label>`.** This bespoke markup is exactly what made TM "look different / fields misaligned" — the #1 visual-divergence cause. `app.css` holds ONLY brand tokens (`--brand`/`--brand-rgb`/`--brand-dark`/`--brand-soft`) plus a few genuinely module-specific component styles; never copy platform structure into it.
- Action buttons (Save/Submit/Back/Cancel/Confirm/Edit) sit **top-right** (page/region/modal header), never in a bottom form bar.
- EN/AR + RTL; Latin digits. Chart.js only via requirejs `chartjs` + `shared/chartLoader.makeChart` — never a `<script>` tag.
- **KO gotchas (each has bitten us):** use `$vm.method()` for VM calls inside `foreach`/`with`; **APEX_JSON omits NULL keys** so bind every nullable field as `$data.field` (a bare `text: field` throws `ReferenceError: field is not defined` and blanks the row); a `ko.computed` only re-runs when an **observable** dependency changes — make late-set values (`myUid`, etc.) `ko.observable`; never wrap a KO checkbox/toggle in `<label>`; container `click:` handlers must `return true`; never `ko.cleanNode` an element's own binding.

### 4. Functional completeness — never ship read-only where management is expected
- Every entity/artifact gets **full CRUD from the UI** (create / edit / remove), inline role/status changes, and detail pages that show **ALL** fields — not read-only tables. (TM round 1 shipped read-only members/milestones/meetings, no team edit, no task assignment — all rejected.)
- Provide pickers from real data (e.g. a `GET /<mod>/users` endpoint to choose people from `DCT_USERS`).
- **Reuse the unified shared tables** — `DCT_DOCUMENTS` (`source_module='<MOD>'`), `DCT_REQUEST_STATUS_HISTORY`, `DCT_LOOKUP_VALUES`; do not create private doc/attachment/status tables.
- **Audit state transitions** (assignment/reassignment, status changes) so they are traceable in an activity feed / status history.

### 5. i18n
- Every `t('…')` key MUST exist in **both** `Jet/js/i18n/app.en.json` and `app.ar.json`. A missing key renders the raw key string to users. Add keys as you add views.

### 6. Database (PROD schema)
- **Lookup-first:** status/enum sets live in `DCT_LOOKUP_VALUES`; call `DCT_LOOKUP_PKG.validate_lookup`; no status CHECK constraints on new tables.
- Run all scripts via **SQLcl** `sql -name prod_mcp` (never the MCP `run-sql` tool). Every script: `SET DEFINE OFF`, `SET SQLBLANKLINES ON`, **CRLF** line endings, **UTF-8 no BOM**, keyword-free `--` comment banners. Schema-qualify objects (`CREATE … prod.<obj>`).
- Oracle quirks: no filtered indexes (use function-based unique indexes); `INSERT ALL` + IDENTITY → ORA-00001 (use individual `INSERT`s); package-private functions can't be used in SQL DML → publish helpers in the package spec (PLS-00231); never end-date rows with `TRUNC(SYSDATE)` when the start defaults to `SYSDATE` (use `GREATEST`).

### 7. ORDS (on ADB)
- Modules register under **ADMIN** at `/ords/admin/<mod>/`. Every PROD object referenced in a handler needs an **ADMIN→PROD synonym**. Run the ORDS/synonym script in a **fresh SQLcl session** (must not follow `ALTER SESSION SET CURRENT_SCHEMA=PROD`, or synonyms self-reference → ORA-01471).
- `validate_session(:body)` at the top of every protected handler; `q'[...]'` literals; output via `APEX_JSON`. Error mapping: `-20401→401, -20403→403, -20404→404, -20001/-20090→400, else 500`.
- Bearer token arrives under CGI key `AUTHORIZATION` on ADB (no `HTTP_` prefix) — `DCT_REST.VALIDATE_SESSION` handles it; don't regress. The shared `api.js` only sets `Content-Type` when a body exists (body-less GET/DELETE with `application/json` 400s on ORDS).

### 8. Testing & the UAT package (Admin convention — required deliverable)
- Tiers: PL/SQL unit (standalone assert harness — utPLSQL is NOT installed on this ADB), API (pytest), System/E2E (Playwright via the `webapp-testing` skill), Regression, UAT. Cover Happy / Edge / Error(400/401/403/404/500) / Boundary.
- **The UAT package MUST follow the Admin layout** (not a markdown case list):
  - reusable master `final apps/<App>/UAT/UAT_<App>_TestScript.xlsx` at the UAT root;
  - one folder per trial `final apps/<App>/UAT/UAT_<App>_round<N>-dd-mm-yyyy/` holding the dated workbook `UAT_<App>_<dd-Mon-yyyy>-NN.xlsx` (statuses filled), the Word results `UAT_<App>_Results_<dd-Mon-yyyy>-NN.docx`, and `evidence_<dd-Mon-yyyy>-NN/` (one screenshot per case).
  - Round numbers are **global-sequential per app**; **never overwrite a prior round**. Same convention for `guides/` (`GUIDE_<App>_round<N>-…` + `assets/`).
- Build the runner on the established pattern `assessment-3/phase4/tests/uat_run_<app>.py` (Playwright + ORDS hybrid; model on `uat_run_cc.py` / `uat_run_tm.py`). It emits the workbook(s) + Word doc + evidence.
- **Live-run gotchas:** module apps redirect to Admin for auth, so after quick-login load `http://localhost:<port>/index.html` (the app root) **once a session exists** — relative view paths 404 under `/Admin/Jet/` otherwise. The platform modal backdrop trips Playwright's strict hit-test on modal header buttons (even `force=True` lands on the backdrop) → fire the bound handler with `locator.evaluate('el => el.click()')`. Kanban/native HTML5 DnD can't be driven by `drag_to` → dispatch real `DragEvent`s. Run ONE dev-proxy at a time on 8080, or give each runner its own port.

### 9. Documentation (per module, kept current)
- `docs/deployment-notes.md` (deploy checklist + history + app-specific gotchas — **update on every deploy**), `STATUS.md` (per-layer status + deployment log), `<APP>_PLAN.md`, and `guides/`.
- Update the persistent memory project entry and this CLAUDE.md (Module Status row) when the app ships.

---

## Available Skills

Two skills are configured in `skills-lock.json`:
- `/apex` — Oracle APEX 24.2 page creation workflow
- `/frontend-design` — production-grade frontend design (distinctive aesthetics, avoids generic AI-slop styling). The skill instructs: commit to a bold conceptual direction before coding; pick distinctive fonts (never Inter/Roboto/Arial); use CSS variables for theming; animate high-impact moments (load reveals, toggles) rather than scattering micro-interactions. Used to create the Vault dark theme for the roles/permissions pages.

---

## Conventions

**Deployment notes (2026-06-13):** every app has a deployment runbook at `final apps/<App>/docs/deployment-notes.md` (Admin, PC, DT, HR, FL, CC, AR). It holds the app's deploy checklist (APP_VERSION bump, DB script order, ORDS/synonym rules, smoke test) plus the app's deployment history and gotchas. **Update the relevant file with EVERY deployment** — new DB scripts, ORDS changes, frontend ships, and any new gotcha discovered during deployment go there. Admin's file (§2) carries the canonical platform-wide SQLcl/ORDS rules; the others reference it. Key universal rule: bump `window.APP_VERSION` in the app's `Jet/index.html` on every frontend deploy (it drives the requirejs + i18n cache key; deployed browsers serve stale files without it), and a change to `final apps/shared/` requires the bump in **all 7 apps**.

**Functions List (2026-06-14):** every app has a functional inventory at `final apps/<App>/docs/functions_list.md` (Admin, AR, CC, DT, FL, HR, PC, TM). It lists **all user-facing functions** the app exposes, grouped by functional area — each area maps to a view (`Jet/js/views/<x>.html` + `viewModels/<x>.js`), and each bullet is a public `self.<method>` on that viewModel — plus an **API Endpoints (ORDS)** table (method + path, from the app's `db/<n>_<code>_ords.sql`; Admin's is `db/v2/11_dct_ords.sql`) and a Services/Data-layer table. **This is a MANDATORY maintenance artifact: any time you add, remove, or rename a view, a viewModel method, a service, OR an ORDS endpoint in `final apps/<App>/Jet/` or the app's ORDS script, update that app's `functions_list.md` in the SAME change.** Adding a brand-new view → add its functional-area section; new method → add its bullet; new/changed ORDS handler → update the API Endpoints table; removed/renamed → reflect it. A change to a function or shared endpoint exposed across all apps (e.g. via `final apps/shared/` or the shared `/dct/` module) updates every app's file. Treat it as part of "done", like the deployment note and the APP_VERSION bump.

**UAT & guide artifacts — one folder per trial/round (2026-06-13):** every UAT trial lives in its own folder under `final apps/<App>/UAT/` named `UAT_<App>_round<N>-dd-mm-yyyy` (round number is **global sequential per app**, ordered chronologically; e.g. `UAT_Admin_round2-13-06-2026`). Each round folder holds that trial's workbook (`.xlsx`), results doc (`UAT_<App>_Results_*.docx`), and `evidence_*` screenshot folder — group by run date even when the workbook and results/evidence seq numbers differ. Reusable `TestScript` template workbooks stay at the `UAT/` root, outside the round folders. The **same convention applies to `final apps/<App>/guides/`**: each generated guide version goes in `GUIDE_<App>_round<N>-dd-mm-yyyy`, holding the guide doc **and its `assets/` folder** (the generated diagrams + cropped screenshots embedded in that version — the guide's equivalent of a UAT `evidence_*` folder). Only the reusable generator script (e.g. `generate_freelancer_guide.py`) stays at the `guides/` root. When generating a new trial/guide, write a new round folder — never overwrite a prior one.

**CSS (Phase 3):** `final apps/shared/css/platform.css` is the ONE structural stylesheet for all JET apps — edit it once; never copy styles into a module app. Each app's `css/app.css` holds only brand tokens (`--brand`/`--brand-rgb`/`--brand-dark`/`--brand-soft` + legacy aliases); the live brand color loads from the module's `THEME_BRAND_COLOR` setting at boot (`shared/js/shell.js`). Full contract incl. the shared shell (top bar + module switcher + side-nav), i18n (`t()`, EN/AR, Latin digits), tri-state lists (`<list-skeleton>`/`<list-pager>`/toast) and the Chart.js rule (**never `<script>`-tag it — load via requirejs `chartjs` path; create via `shared/chartLoader.makeChart`**) is in `final apps/SHARED_JET_ARCHITECTURE.md`. KO+ORDS gotcha: APEX_JSON skips NULLs — bind optional fields as `$data.field || ''`, never bare `text: field`.

**Region header colors + borders (2026-06-13):** every region header (fill + font) and region border (color/thickness/style) in ALL apps — current and future — is driven by the five `THEME_REGION_*` settings, applied at boot by `shared/js/shell.js` as CSS vars `--region-hd-bg/-fg/-accent/-soft` + `--region-bd-color/-width/-style` (resolution: module row in `DCT_MODULE_SETTINGS` → system default in `DCT_SYSTEM_SETTINGS` via `GET /dct/boot` → platform.css fallback; seed = `db/v2/22_region_theme.sql`). Configure via the palette picker in Admin → System Settings → Region Appearance (curated fill/font pairs + AA-contrast check); each module can override in its own Module Settings page. **Never hard-code header/border colors in views** — use `.section-heading` / `.section-heading-row` / `.modal-header` / `table.data-table` and the theme applies for free. Buttons inside colored headers restyle automatically (ghost non-primary, inverted primary).

**Field focus highlight (2026-06-15):** the highlight on a focused input field in ALL apps — soft **field fill** + colored border + ring — is driven by three global APPEARANCE settings — `THEME_FOCUS_COLOR` (the color, native color picker = any color), `FEATURE_FOCUS_HIGHLIGHT` (Y/N on/off) and `THEME_FOCUS_FILL_LEVEL` (0–100 fill intensity, % of the color; higher = darker; default 15) — applied at boot by `shared/js/shell.js` (`applyRegionTheme`) as CSS vars `--focus-color` / `--focus-ring` / `--focus-fill` (defaults in `platform.css`; `--focus-fill` = opaque tint mixed `1 - level/100` toward white so field text stays readable; `FEATURE_FOCUS_HIGHLIGHT=N` → neutral border, no ring/fill; keyboard `:focus-visible` outline is unaffected; error fields keep a red tint). Admin-only/global (no per-module override); configured in Admin → System Settings → Field Focus Highlight via the shared `regionPicker` (color picker + on/off switch + intensity slider, live preview). All three keys ship to every app via `GET /dct/boot`; seed = `db/v2/26_focus_theme.sql`. **Never hard-code focus colors** — `.form-control:focus` and bare `input/textarea/select:focus` already use the vars (use `background-color`, not the `background` shorthand, to preserve the select arrow image).

**Document uploads — raw binary, no size cap (2026-06-15):** all document file uploads (every app) go up as **raw bytes**, never base64-in-JSON. Client: `shared/js/api.js` **`api.putBinary(path, file, { mime, query })`** (file = request body, name/mime in the query string, Bearer auth) + `api.fetchBlobUrl(path)` for authed downloads; UI via `shared/js/docUpload.js` — the **`<doc-upload>`** KO component (register `'shared/docUpload'` in `main.js`) or **`docUpload.choose({accept,maxMb})` → Promise<File|null>** for custom layouts. Server (ORDS): read **`l_blob := :body`** (deref `:body` exactly ONCE — `:body_blob` binds as VARCHAR2 on this ADB's ORDS version, PLS-00382) and size-guard against the per-module **`MAX_UPLOAD_MB`** setting (default 10 → HTTP 413; seed `db/v2/27_max_upload_mb.sql`). **Never reintroduce the old base64 `VARCHAR2(32767)` upload pattern (it capped files at ~24 KB).** Full contract in `final apps/SHARED_JET_ARCHITECTURE.md` § "Document upload". Live in FL/CC/TM/HR; the `DCT_DOCUMENTS.file_blob` column is BLOB (unlimited).

**Action buttons — top-right (2026-06-13):** Save / Save Changes / Submit / Back / Cancel / Confirm always sit at the TOP-RIGHT of the page header (`.page-header-row` + `.page-actions`), region heading (`.section-heading-row` + `.region-actions`), or modal header (`.region-actions` `btn-sm`, replacing the `×`) — never at the bottom of a form. `.form-actions` bottom bars are deprecated (only "+ Add X" CTAs and table-row inline editors may stay at the bottom). Primary action is the right-most button; never pair Back AND Cancel when they call the same handler. Full recipes in `final apps/SHARED_JET_ARCHITECTURE.md` § "Action Buttons — Always Top-Right".

**Vault design system** (`rm-*` / `re-*` classes, defined in `final apps/shared/css/vault.css` — the 673-line redesign was completed and promoted out of Admin's `app.css` into the shared layer so other apps' security pages can reuse it; Admin loads it via `index.html`). Applied to the roles/permissions pages (`roles.html`, `permissions.html`, `roleEdit.html`), each scoped with an `rm-page`/`re-page` wrapper. Key design tokens:

| Variable | Value | Usage |
|---|---|---|
| `--vault-bg` | `#0D1117` | Page background |
| `--vault-surface` | `#161B22` | Card / panel surface |
| `--vault-border` | `#30363D` | Borders |
| `--vault-text` | `#E6EDF3` | Primary text |
| `--vault-muted` | `#7D8590` | Secondary text |
| `--vault-amber` | `#F0883E` | Accent / active states |
| `--vault-green` | `#3FB950` | Success / active status |
| `--vault-red` | `#F85149` | Error / danger |
| `--vault-blue` | `#58A6FF` | Code badges / info |
| `--vault-font` | `'Outfit'` | UI text (Google Fonts) |
| `--vault-mono` | `'Fira Code'` | Role codes, permission codes |

The permission matrix toggle (`rm-toggle-wrap` / `rm-toggle--on`) and permission checkbox items (`re-perm-item` / `re-perm-item--on`) use amber dot animations with `cubic-bezier(.34,1.56,.64,1)` spring timing. Use the same pattern for any new security-section pages.

**ORDS URL:** `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com` — always get from OCI Console, never guess from tnsnames (JDBC and HTTPS use different hostnames on ADB).

**Legacy app conventions** (apps/ifinance-v2/ only): Global controller objects `Manager`, `Director`, `Auth`, `DataStore`, `Charts`, `Utils`. ISO week: use `Utils.getISOWeek()` / `Utils.getWeekDates()`. Status/priority values are uppercase string constants.
