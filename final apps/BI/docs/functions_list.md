# BI - Reporting (App 211) — Functions List

User-facing functions of the BI - Reporting JET app (`final apps/BI/Jet/`), grouped by view. Each area
maps to `Jet/js/views/<x>.html` + `Jet/js/viewModels/<x>.js`; each bullet is a public `self.<method>`.
Admin surface (Reports/Runs/Workers/Settings) is SYS_ADMIN-gated; the viewer surface (Dashboard +
Interactive Reports) also admits **BI_USER** (nav is role-filtered; admin routes reroute to Dashboard).
Consumes the Reporting Platform ORDS module `/ords/admin/rpt/`.

## Dashboard (`dashboard`)
- `go(path)` — navigate to a section. `openRun(row)` — open a run's detail. `badge(status)` — status→badge class.
- Loads (SYS_ADMIN only — skipped for BI_USER, who gets an "Open Interactive Reports" hero instead):
  total reports, recent runs (counts: succeeded/failed/in-progress), `EMAIL_ENABLED` banner.

## Interactive Reports (`irViewer`) — BI_USER + SYS_ADMIN
- Catalog: `select(item)` (auto-runs param-less reports) / `backToCatalog` / search + category filter
  (`catSearch`/`catCategory`); deep-link via `navigate('irViewer', { reportCode, section? })`.
- Runner: parameter inputs built from the catalog's spec-driven `params[]` — **EN/AR labels, hints
  and required markers from the definition's `PARAM_SPEC_JSON`** (fallback: raw keys from
  `params_json` defaults); MULTI adds a section picker + `required[]` enforcement; params with a
  `lov_sql` render as **LOV dropdowns** (values via `GET ir/reports/:code/lov?param=`);
  `run()` — one capped POST `ir/reports/:code/data`, envelope handed to the `<interactive-report>` grid.
- `<interactive-report>` component — **SHARED since 2026-07-03**
  (`final apps/shared/js/components/interactiveReport.js` + `.html`, engine `irExpr.js`; require as
  `'shared/components/interactiveReport'`; `.ir-*` styles in platform.css, `ir.*` keys in
  `shared/i18n/common.*.json`) — all client-side over the fetched set:
  - column manager: show/hide, up/down reorder, **rename header** (pencil → inline input; empty
    reverts to default; persists in layouts + autosave), per-column aggregate (sum/avg/min/max/count
    → footer row over the FILTERED set), **Break toggle per column**, reset view;
  - **control breaks**: break columns lead the sort; group **band rows** (`Label: value`) + break
    chips (× removes); with any aggregate set, **per-group subtotal rows** at each group end plus
    the grand-total footer;
  - **highlight rules**: toolbar Highlight panel — column + typed operator + row/cell scope +
    5-color soft palette; row scope fills the whole row, cell scope the one column; rule list with
    click-to-edit/×; count badge on the toolbar button; persists in layouts + autosave;
  - themed header (full `--region-hd-bg/-fg` region fill) + **maximize toggle** (⤢ at toolbar right
    → fullscreen overlay, Esc restores);
  - filters: typed operator popover (text contains/=/≠/starts/empty; number =/≠/>/≥/</≤/between;
    date on/before/after/between) → chips row (click chip = edit, × = remove, clear all);
  - sort: header click asc→desc→off, Shift+click multi-sort (indexed ▲▼ badges); global search box;
  - calculated columns: name + expression editor in a wide (760px) right-edge `<edit-drawer>`
    with live first-row preview + inline validation
    (safe parser — ROUND/ABS/NVL/UPPER/LOWER, + - * / % ( ) 'text' ||; no eval); **formula
    autocomplete** (typing suggests columns by key/label + functions; ↑↓ + Enter/Tab or click
    inserts; Esc closes the dropdown only) + **click-to-insert column & function chips** under the
    textarea; header-label aliases (type the header text with underscores — renamed headers too)
    and **did-you-mean** unknown-column errors;
  - export: CSV (UTF-8 BOM, filtered+sorted rows, visible columns in display order) and XLSX
    (SheetJS, lazy-loaded via the requirejs `xlsx` path);
  - layouts: server-saved named layouts per report (`Save` / `Save as` / `Apply` / `Rename` /
    `Delete` / `Make default` [auto-applies on load] / admin-only `Share`), dirty-dot vs the applied
    layout, plus localStorage last-state autosave (`ifinance.ir.<code>::<section>`);
  - truncation banner when the server capped the fetch (`IR_MAX_ROWS`).

## Reports (`reports`) — definition CRUD
- `load` / `applyFilter` / `prev` / `next` — list + search + engine filter + paging.
- `openNew` / `openEdit(row)` / `save` — create/edit definition via the shared `<edit-drawer>` (code, names, source, engine, formats, templates, params, enabled). Drawer Cancel/Esc/scrim close via the `editing` observable.
- `runNow(row)` — fetches the param spec (`GET reports/:code/params`); parameterized definitions open the **Run Parameters drawer in place on the list** (LOV dropdowns + EN/AR labels/hints + required-field validation) — no navigation to detail; param-less definitions queue immediately. `submitRun` posts the collected params. `openDetail(row)` — open report detail. `remove(row)` — delete.

## Report Detail (`reportDetail`) — schedules + recipients
- `loadAll` / `back` / `syncSched` (rebuild DBMS_SCHEDULER jobs).
- `runNow` — fetches the param spec (`GET reports/:code/params`) and opens the **Run Parameters
  drawer** (LOV dropdowns from the definition's `param_spec_json` lov_sql, EN/AR labels + hints,
  required markers; empty optional field = report default, numeric strings sent as numbers);
  no declared params → queues immediately. `submitRun` validates required fields, then
  `queueRun(params)` POSTs the params object as the run body.
- Schedules: `openSchNew` / `openSchEdit` / `saveSch` / `removeSch`.
- Recipients: `openRcNew` / `openRcEdit` / `saveRc` / `removeRc` (USER/ROLE/ORG/EMAIL/SELF × channel).
- **Run-parameter spec editor** (Definition card → `Parameters`, SYS_ADMIN): `openParamSpec` — loads
  `GET ir/reports/:code/paramspec` and lists one card per param (names = params_json defaults ∪
  spec keys) with label EN/AR, hint EN/AR, Required toggle and the LOV SQL; `testLov(row)` — runs
  the draft query via `POST ir/lov/preview` (cap 50) and shows the value count + samples inline;
  `saveParamSpec` — collapses empty fields and `PUT ir/reports/:code/paramspec`.

## Workers (`workers`) — engine monitoring + control
- `load` / `refresh` — workers + derived health (ONLINE < 90s heartbeat, STALE < 10min, else OFFLINE), queue stats (queued/running/failed today/success today/oldest queued age) and the two DCT_RPT_* scheduler jobs. Auto-refreshes every 10s while the page is open.
- `pause(w)` / `resume(w)` / `stop(w)` — write the worker's `command`; the Python worker obeys on its next loop (STOP exits after the current run). `remove(w)` — delete an OFFLINE registry row.
- `reclaim` — requeue stuck RUNNING runs (`DCT_RPT_PKG.reclaim_stuck`).
- `toggleJob(j)` — enable/disable `DCT_RPT_NATIVE_JOB` (NATIVE sweep) / `DCT_RPT_MAINT_JOB` (maintenance).

## Run History (`runs`)
- `load` / `applyFilter` / `refresh` / `prev` / `next` — list with report + status filters + paging.
- `open(row)` — run detail. `retry(row)` — re-queue. `badge(status)`.

## Run Detail (`runDetail`)
- `load` / `back` / `retry`. `download(output)` — authed BLOB download (PDF/XLSX). `fmtBytes(n)`.
- Shows summary, generated files (download), per-recipient deliveries.

## Settings (`settings`) — runtime / SMTP config editor
- `load` / `saveAll` / `toggle(row)` — edit `DCT_RPT_CONFIG` (EMAIL_ENABLED, SMTP_*, PDF_RENDERER, retention…).
- `sendTest` — **Send Test Email** card: posts to `config/test-email` (via `rptService.sendTestEmail(to)`) and shows the result (`testTo`/`testing`/`testMsg`/`testOk`); recipient pre-filled from `SMTP_FROM`.
  Secrets (SMTP password) live in the runner's env, not here.

## Login (`login`)
- `doLogin` / `quickLogin(ql)` — dev standalone login; production redirects to Admin (App 200) for the shared session.

## API Endpoints (ORDS `/ords/admin/rpt/`)
| Method | Path | Purpose |
|---|---|---|
| GET | `meta` | dropdown vocabularies |
| GET/POST | `reports/` | list / create definitions |
| GET/PUT/DELETE | `reports/:code` | detail / update / delete |
| POST | `reports/:code/run` | enqueue on-demand run (optional JSON body = run parameters; absent/`{}` keeps definition defaults) |
| GET | `reports/:code/params` | run-parameter spec for the Run drawer: name/label/labelAr/hint/hintAr/required + LOV values (each `param_spec_json` lov_sql executed, max 500 rows) — `reporting/db/10` |
| GET | `runs/` | run history (paged) |
| GET | `runs/:id` | run detail (+ outputs + deliveries) |
| GET | `runs/:id/output/:fmt` | authed BLOB download |
| POST | `runs/:id/retry` | re-queue a run |
| GET | `workers/` | workers + health + queue stats + DCT_RPT_* scheduler jobs |
| POST | `workers/command` | `{workerId, command: PAUSE\|RESUME\|STOP\|CLEAR}` |
| POST | `workers/remove` | `{workerId}` — delete a dead/stopped registry row |
| POST | `workers/reclaim` | requeue stuck RUNNING runs |
| POST | `workers/job` | `{jobName, enabled}` — toggle DCT_RPT_NATIVE_JOB / DCT_RPT_MAINT_JOB |
| GET/POST | `schedules/` | list / create |
| PUT/DELETE | `schedules/:id` | update / delete |
| POST | `schedules/sync` | rebuild DBMS_SCHEDULER jobs |
| GET/POST | `recipients/` | list / create |
| PUT/DELETE | `recipients/:id` | update / delete |
| GET/PUT | `config` | runtime/SMTP config editor |
| POST | `config/test-email` | send a test email via APEX_MAIL (SYS_ADMIN); `reporting/db/11` |
| GET | `ir/catalog` | enabled definitions for the viewer (+ spec-driven `params[]` labels/hints/required/hasLov + MULTI sections/required + lovParams) — BI_USER or SYS_ADMIN |
| GET | `ir/reports/:code/lov?param=` | dropdown values for one run parameter (the param's `lov_sql` in `PARAM_SPEC_JSON`, bind-free query, cap 500) — BI_USER or SYS_ADMIN |
| POST | `ir/reports/:code/data` | one-shot capped data fetch (body `{section?, params?}`) via `DCT_RPT_IR_PKG` — BI_USER or SYS_ADMIN |
| GET | `ir/reports/:code/layouts` | own + shared saved layouts — BI_USER or SYS_ADMIN |
| POST | `ir/layouts` | save a layout (409 dup name; sharing = SYS_ADMIN only) |
| PUT/DELETE | `ir/layouts/:id` | rename / re-share / default / update json / delete (owner-or-admin) |
| GET/PUT | `ir/reports/:code/paramspec` | raw `PARAM_SPEC_JSON` + defaults for the editor / replace the spec (`{paramSpec:{…}}`, `{}` clears) — SYS_ADMIN |
| POST | `ir/lov/preview` | test a draft `lov_sql` (`{sql}`; query-keyword + bind-free guards, cap 50) — SYS_ADMIN |

## Services / Data layer
| File | Role |
|---|---|
| `js/services/config.js` | `apiBase=/ords/admin/rpt`, `authBase=/ords/admin/dct`, `adminPortalUrl` |
| `js/services/api.js` | re-export of `shared/api` (Bearer + 401 handling) |
| `js/services/authService.js` | shared-session reader; `isReportAdmin()` (SYS_ADMIN), `isReportUser()` (BI_USER or SYS_ADMIN) |
| `js/services/rptService.js` | all `/rpt` endpoint wrappers (incl. `getIrCatalog`/`getIrData`/`getIrLov`/`getIrLayouts`/`createIrLayout`/`updateIrLayout`/`deleteIrLayout`/`getParamSpec`/`putParamSpec`/`previewLov`) |
| `shared/js/components/interactiveReport.js` (+ `.html`) | `<interactive-report>` KO component — the reusable IR grid (SHARED layer since 2026-07-03) |
| `shared/js/components/irExpr.js` | safe expression compiler for calculated columns (no eval) |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
