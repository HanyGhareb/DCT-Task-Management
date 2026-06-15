# Task Management (App 207) — Deployment Notes

Module `TASK_MGMT` · ORDS `/ords/admin/tm/` (`tm.rest`) · JET `final apps/TM/Jet/` · brand teal `#0E8A8A`.
Canonical platform-wide SQLcl/ORDS rules live in **Admin → docs/deployment-notes.md §2**; this file is TM-specific.

## 1. Deploy checklist

**DB (SQLcl `sql -name prod_mcp`, run scripts via PowerShell `& sql.exe -S -name prod_mcp "@file"`):**
1. `@install.sql` — runs `01_tm_ddl` → `03_tm_seed` → `02_tm_views` → `04_tm_pkg` → `05_tm_reminder_pkg` → `07_tm_jobs`.
2. **Fresh session**, then `@06_tm_ords.sql` (ORDS module + ADMIN synonyms — must NOT follow an `ALTER SESSION SET CURRENT_SCHEMA=PROD`, or synonyms self-reference → ORA-01471).
3. Verify: `@test/tm_smoke_test.sql` (16 asserts, rolls back) and `SELECT object_name,status FROM all_objects WHERE object_name LIKE 'DCT_TM%' AND status='INVALID'` → 0 rows.

**Frontend:**
4. `final apps/TM/Jet/index.html` `window.APP_VERSION` is `4.5.0`. Bump on every TM frontend deploy (drives requirejs + i18n cache key).
5. App 207 is registered in `final apps/shared/js/shell.js` MODULES + `shared/i18n/common.*.json` (`mod.tm`). **A change to `final apps/shared/` requires bumping `APP_VERSION` in ALL 8 apps** (done at 4.5.0 for this release).
6. **Update `docs/functions_list.md`** if this deploy added/removed/renamed any view, viewModel method, service, or ORDS endpoint (functional inventory — see root `CLAUDE.md` → "Functions List").

## 2. Hard-won gotchas (this build)

- **`SET SQLBLANKLINES ON` is mandatory** in every TM `.sql`. Without it, SQLcl 26.1 silently swallows any PL/SQL block that contains interior blank lines (no error; prints bogus WHENEVER help on the next statement). Symptom seen: lookup seed block vanished, CATS stayed 0.
- **CRLF line endings** required (SQLcl skips LF-only files). All TM scripts written CRLF, UTF-8 **no BOM**.
- **Keyword-free comment banners** — a leading `--` comment containing a SQL keyword (e.g. `MERGE`) makes SQLcl swallow the next statement.
- **No Oracle filtered indexes** — used function-based unique indexes for "one active membership per (team,user)" and the role-perm template/override key (`NVL(team_id,-1)`).
- **PLS-00231** — package-private functions can't be used in SQL DML; `actor_name`/`gen_code`/`role_id_of` are published in the `DCT_TM_PKG` spec.
- **Arabic** stored correctly (multibyte, verified no mojibake) via UTF-8-no-BOM files + PowerShell SQLcl. Do NOT deploy seeds through the bash `printf | sql` pipe (mangles backslashes/UTF-8).
- **utPLSQL is not installed** on this ADB — unit tests are a standalone transactional assert harness (`test/tm_smoke_test.sql`).

## 3. Permission model

Two layers: system roles `TM_ADMIN`/`TM_USER` (module access, via App 200) + **team-scoped roles** (Leader/Supervisor/Coordinator/Member/Quality/Observer) carrying an artifact CRUD matrix (`DCT_TM_ROLE_PERMS`, template default + per-team override). `DCT_TM_PKG.tm_can()/require_perm()` enforce it; ORDS maps `-20401→401 -20403→403 -20404→404 -20001/-20090→400`.

## 4. Reminders

`DCT_TM_REMINDER_JOB` (DBMS_SCHEDULER, daily 07:00 Asia/Dubai) → `DCT_TM_REMINDER_PKG.run_job`: due-within-lead-days + overdue reminders to assignees (per `DCT_TM_REMINDER_PREFS.lead_days`, fallback module setting `DEFAULT_REMINDER_LEAD_DAYS`) + overdue escalation to team leaders. Run manually: `BEGIN dct_tm_reminder_pkg.run_job; END;`.

## 5. Deployment history

- **2026-06-15 — Shared `<edit-drawer>` component + Edit-Team conversion. APP_VERSION → 4.5.3.**
  - **What:** introduced a reusable APEX-style right-edge drawer as the first promoted entry from the new `final apps/Shared UI Components/` reference gallery. TM is the reference adopter — the **Edit Team** modal in `teamDetail` is now a drawer.
  - **Shared (new):** `shared/css/platform.css` gained the `.ed-*` block (scrim, drawer, themed header reusing `--region-hd-*`, pulsing unsaved-dot, staggered field reveal, RTL-aware slide); `shared/js/editDrawer.js` registers the `edit-drawer` Knockout component. Body markup is supplied by the host view and rebound to its own ViewModel via `template:{ nodes: $componentTemplateNodes, data: vm }` — so fields keep binding to the view's observables while the chrome binds to the component VM. **This is a `final apps/shared/` change** → per the shared-change rule it eventually needs an `APP_VERSION` bump in every app, but the `.ed-*` CSS + component are inert until an app adds `'shared/editDrawer'` to its `main.js`, so the practical minimum is to bump each app as it adopts the drawer (only TM here).
  - **Frontend (TM):** `main.js` require array gained `'shared/editDrawer'`; `teamDetail.html` Edit-Team `.modal-overlay`/`.modal-box` block replaced by `<edit-drawer params="open: showEdit, vm: $vm, title:…, onSave: saveTeam, width:'760px'">` wrapping the **unchanged** form-grid. (The `width` param binds the drawer's real `width`, bounded by `min/max` in platform.css; default 560px — an earlier draft bound `max-width` only, which pinned every drawer at the 480px base.) **No ViewModel change** — `showEdit`/`eName…`/`saveTeam` already existed (so `functions_list.md` is unaffected). The task drawer + Teams create modal still use the legacy `.modal-box` pattern (unchanged).
  - **Note:** body markup is now always in the DOM (drawer hidden via transform) instead of gated behind `<!-- ko if: showEdit -->`; fields render empty until `editTeam()` populates them, which is fine. **Pending live smoke test** (Playwright quick-login → open a team → Edit → verify slide-in, save, Esc/scrim close).

- **2026-06-14 — Measurable objectives / Key Results (round 3). APP_VERSION → 4.5.2.**
  - **What:** team objectives are now measurable (OKR-style). Each objective owns 1..N **Key Results** (unit, baseline → target → current, direction, weight, target date); the objective's `progress_pct` is a **weighted roll-up** of its KRs when `progress_mode='AUTO'` (a `MANUAL` mode pins a hand-entered %). Objectives also gained full edit/remove (were add-only).
  - **DB (new):** `@08_tm_key_results.sql` — `DCT_TM_KEY_RESULTS` (ON DELETE CASCADE from objectives) + `DCT_TM_OBJECTIVES.progress_mode VARCHAR2(10) DEFAULT 'AUTO'` + lookups `TM_KR_DIRECTION` (INCREASE/DECREASE/MAINTAIN) and `TM_KR_UNIT` (suggestions only — the `unit` column is free text, NOT validated). Script is **re-runnable** (CREATE/ALTER guarded by ORA-00955/-01430; lookup seed is MERGE). Slots into `install.sql` as step **[3/7], before `02_tm_views.sql`** (the views reference the KR table + new column).
  - **DB (re-run):** `@02_tm_views.sql` (adds `dct_tm_key_result_v`, extends `dct_tm_objective_v`), `@04_tm_pkg.sql` (adds `upsert_key_result`/`record_kr_value`/`delete_key_result`/`delete_objective` + private `recompute_objective_progress`; `upsert_objective` gains `p_progress_mode`). Then **fresh session** `@06_tm_ords.sql` (new routes `GET/POST key-results`, `POST key-results/value`, `DELETE key-results/:id`, `DELETE objectives/:id`; +2 synonyms `dct_tm_key_results`, `dct_tm_key_result_v`). Smoke test **26/26**.
  - **KR CRUD is governed by the existing `OBJECTIVE` artifact permission** — no new `DCT_TM_ROLE_PERMS` rows / artifact type. KR status **reuses** `TM_OBJECTIVE_STATUS`.
  - **Per-KR progress is computed in `dct_tm_key_result_v`** (clamped 0–100): INCREASE `(cur−base)/(target−base)`, DECREASE `(base−cur)/(base−target)`, MAINTAIN `100 if cur≥target else cur/target`. `recompute_objective_progress` writes the weighted Σ back to `dct_tm_objectives.progress_pct` only when AUTO — so existing objective-progress dashboards/charts improve for free.
  - **Frontend:** objectives tab rows are clickable → **objective drawer** (mirrors the task drawer `.tm-drawer`): edit objective fields + Auto/Manual toggle, Key Results list with a baseline→target gauge, inline **Update value**, and add/edit/remove KR. New `tmService` methods `deleteObjective`/`listKeyResults`/`saveKeyResult`/`recordKrValue`/`deleteKeyResult`. ~22 EN+AR i18n keys; new `.tm-kr*` CSS in `css/app.css`.
  - **Gotcha (new):** the inline KR "current value" input must bind `value: $data.current, valueUpdate: 'input'` — plain `value:` only writes back to the (non-observable) row property on **blur**, so a click-to-Update that doesn't blur first posts a stale value. `valueUpdate:'input'` writes on every keystroke. (Auto-progress roll-up otherwise verified live: 50%→37.5%→62.5%→100%.)
  - **Verified live (Playwright quick-login):** drawer add INCREASE+DECREASE KR → objective auto 37.5%, update value → 62.5%, delete → 100%; 0 real console errors (only the universal pre-login branding 401).

- **2026-06-13 — UI/UX rework + functional enhancements (round 2). APP_VERSION → 4.5.1.**
  - **DB (redeployed):** `@04_tm_pkg.sql` (assign_task/unassign_task now log assignment + primary-reassignment history into `DCT_TM_TASK_UPDATES`; new `add_document` → unified `DCT_DOCUMENTS`, source_module='TM', base64 ≤ ~24 KB inline or metadata-only). Then **fresh session** `@06_tm_ords.sql` — new routes `GET /users`, `GET /tasks/assignees`, `POST /documents`; boot returns `docTypes`; +3 synonyms (`dct_users`, `dct_tm_task_assignees`, `dct_document_types`). Both compiled clean; new routes 401-gated.
  - **Frontend:** rebuilt `teamDetail` (overview definition-grid + Edit Team modal, member add/role/remove, task drawer with assignees + activity feed + comments, milestones/meetings add, new Documents tab). Converted `teams` modal + all forms to platform `.form-control`/`.form-group`/`.modal-overlay` classes; `css/app.css` gained an `.input`→form-control shim, helpers, and new components. New EN/AR i18n keys.
  - **Gotchas hit (add to the canonical list):**
    - **APEX_JSON omits NULL keys**, so a row missing an optional column has *no* such property. KO `text: dueDate` then throws *"dueDate is not defined"* (ReferenceError, not undefined). **Always bind optional fields as `$data.field`** in `foreach` rows — never bare. This is the #1 cause of a blank/broken list row.
    - **KO computed + plain (non-observable) vars:** a `ko.computed` only re-runs when an *observable* dependency changes. `canEditTeam` read a plain `myUid` set inside `boot().then`; because `isTmAdmin` stayed `false`, the computed never re-evaluated after `myUid` was set, so the Edit/manage buttons stayed hidden. Fix: make such late-set values `ko.observable`.
    - **TM redirects to the Admin portal for auth.** After quick-login the browser is at `/Admin/Jet/index.html`; to test/use the TM SPA load `/<port>/index.html` (TM root) *after* the session exists, else relative view paths resolve under `/Admin/Jet/` and 404.
    - Milestone status uses the **`TM_OBJECTIVE_STATUS`** lookup set (shared with objectives); meeting status uses **`TM_LOG_STATUS`** (which intentionally includes PLANNED/HELD/CANCELLED). There is no `TM_MILESTONE_STATUS`/`TM_MEETING_STATUS` set.
  - **Verified live (Playwright quick-login):** 15/15 authenticated backend flows incl. assign→reassign trail; UI renders with 0 console errors.

- **2026-06-13 — initial build (layer-by-layer).**
  - DDL: 13 `DCT_TM_*` tables + indexes + triggers.
  - Seed: 14 `TM_*` lookup sets, module `TASK_MGMT`, roles `TM_ADMIN`/`TM_USER`, 7 settings, 6 team-role templates × 10-artifact CRUD matrix (60 rows). Verified CATS=14/VALS=72/TMROLES=6/TMPERMS=60.
  - Package `DCT_TM_PKG` + 12 views + `DCT_TM_REMINDER_PKG` — all VALID; smoke test 16/16.
  - ORDS `tm.rest` — 23 templates, PUBLISHED; live 401 gate verified.
  - Scheduler job created (daily 07:00 Asia/Dubai).
  - JET app built (10 views/VMs), registered App 207 in shared shell + i18n; bumped APP_VERSION → 4.5.0 across all 8 apps. Static-served smoke OK.
  - Live Playwright E2E (quick-login via Admin) — **8/8 flows pass, 0 console errors**; evidence in `UAT/UAT_TM_round1-13-06-2026/evidence_13-Jun-2026/`.
  - Three fixes during the live run: (1) boot lookup query was SQL-Server `LIKE 'TM[_]%' ESCAPE '['` (matched nothing → empty type/class dropdowns → ORA-01400 on create) → Oracle `LIKE 'TM\_%' ESCAPE '\'`; (2) `notificationService.js` hit `/tm/notifications` → now `{base:'auth'}` (platform `/dct`); (3) `SIBLING_APPS` in **all 8 dev-proxies** was missing `'TM'` so the switcher's `/TM/Jet/` URL 404'd in dev — added. **Dev gotcha:** run only ONE app's dev-proxy at a time (port 8080); it serves itself at `/` and siblings at `/<App>/Jet/`. Kanban uses native HTML5 DnD — Playwright `drag_to` can't fire it; the E2E spec dispatches real `DragEvent`s.
  - Pending: authenticated pytest API (`tests/api`, needs `TM_USER`/`TM_PASS` env), UAT round-1 sign-off doc, AI-assist hooks (deferred sub-feature).
