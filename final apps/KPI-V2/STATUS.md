# Finance KPIs V2 (KPI-V2) — Status

Clean-slate UX rebuild of the KPI frontend (App 213). The user drives the redesign
**phase by phase**; prior redesign documents in `final apps/KPI/` are intentionally
ignored. KPI v1 (`final apps/KPI/`) stays untouched and live until a cutover decision.

Identity: rides App **213**'s live backend — `apiBase /ords/admin/kpi`, auth `/dct`.
Switcher key `kpiv2`, code `K2`, URL `/KPI-V2/Jet/index.html`. No DB/ORDS changes so far.

## Look & feel (user decision, Phase 0)

**Exactly FPB** (the GL app 210 — Financial Planning and Budgeting): portal chrome
(`.pbar` top bar + `.pnav` top tabs), cream canvas `#F6F5F1`, brand green `#3F6F5F`,
gold diamond `#C8A24B`, Fraunces serif + Public Sans + Noto Naskh Arabic. Design
language source of truth: `final apps/GL/Jet/css/app.css`. Interactive reporting via
the shared `<interactive-report>` component (wired in `main.js`, `xlsx` path included).

## Top tabs (pages)

| Tab | Audience | Status |
|---|---|---|
| Me | every KPI user | Phase 0 placeholder |
| Admin | plan administrators (`KPI_ADMIN`/`SYS_ADMIN`) | Phase 0 placeholder |
| Configurations | `KPI_ADMIN`/`SYS_ADMIN` | Phase 0 placeholder |
| Settings | `KPI_ADMIN`/`SYS_ADMIN` | **Phases 1–3 LIVE** — sub-tabs: Manage Lookups (P1) · Manage KPIs (P2) · Manage Security (P3) |

## Phase 1 — Settings → Manage Lookups (LIVE 2026-07-28)

- **Storage (user decision)**: the SHARED platform lookup store was extended —
  `db/v2/109_lookup_value_dates.sql` adds `description_en/ar` + `start_date`/`end_date`
  to `prod.dct_lookup_values` (+ `chk_dct_lval_dates`, recompile sweep, 0 INVALID).
  Existing platform handlers name their columns, so nothing else changed.
- **Seeds**: `db/01_kpi2_lookup_seed.sql` — **14 `KPI2_*` categories / 44 values (EN+AR)**
  under module KPI_MGMT, `is_system='N'`: Reporting Freq + Updating Freq (Yearly…Daily ×7),
  Polarity, UOM, Data Source (Fusion/EBS/EPM), Calc Method (v1's 3), Yes/No, Source
  Figures (Actual YTD GL Revenue/Expense), Category, KPI Status (= v1 KPI_RESULT_STATUS
  vocabulary, user decision), **Period Status (Open/Closed — user addition)**, Plan Type,
  Plan Owner, Plan Status. `KPI2_` prefix on purpose — v1's `/kpi/boot` matches
  `LIKE 'KPI\_%' ESCAPE '\'` so these never leak into v1.
- **ORDS**: `db/02_kpi2_ords.sql` — ADDITIVE on the live `kpi.rest`: GET/POST `v2/lookups`,
  PUT `v2/lookups/:id`, GET/POST `v2/lookups/:id/values`, PUT `v2/lookup-values/:id`.
  All KPI_ADMIN-or-SYS_ADMIN. Master scope = module KPI_MGMT rows OR `KPI2_*`;
  `is_system='Y'` rows are never listed/editable. Effective status per value =
  INACTIVE / PENDING (start > today) / EXPIRED (end < today) / ACTIVE.
  **RERUN RULE: any re-run of `KPI/db/06` (DELETE_MODULE) requires re-running 02.**
- **Frontend (APP_VERSION 2.1.0)**: Settings page = left nav region (Manage Lookups
  active, Reminders disabled) + master-detail on FPB `.tbl` tables, row-click select,
  shared `<edit-drawer>` add/edit for lookups AND values (code locked on edit, EN/AR
  names + descriptions, start/end dates, order, default, active), status chips incl.
  date-derived Expired/Scheduled, client CSV export (UTF-8 BOM) on both grids.
  Gotcha captured: inside an `<edit-drawer>` body the context is the HOST VM and
  `$root` is the drawer component — expose `self.t = i18n.t` and bind bare `t(...)`.

## Phase 2 — Settings → Manage KPIs (LIVE 2026-07-29)

- The Phase-1 left nav became **sub-tabs** (Manage Lookups | Manage KPIs | Manage Security).
- **KPI master records are plan-independent** (`db/03`): `DCT_KPI2_DEFINITIONS`
  (code unique+immutable, name/desc EN+AR, Type [NEW lookup `KPI2_KPI_TYPE` —
  user decision] + Category, both frequencies, polarity, calc method, UOM,
  evidence flag, active) + children `_DEF_SOURCE` (multi Data Sources),
  `_DEF_FIGURE` (multi Source Figures), `DCT_KPI2_BANDS` (v1 shape: score 1..5,
  operator KPI_BAND_OP, thresholds, labels EN/AR, evaluated 5→1 first-match).
  **Weight / display order / targets deliberately absent — they belong to the
  plan assignment (later phase).**
- **ORDS** (`db/04`, ADDITIVE on kpi.rest): `GET /v2/kpi-lovs` (all form lookup
  values + eff flag, one call), `GET/POST /v2/kpis`, `GET/PUT /v2/kpis/:id`
  (single save carries sources[]/figures[]/bands[]; children replaced on PUT;
  lookup-first validation via dct_lookup_pkg). API smoke 16/16.
- **UI**: searchable register (text + Type + Reporting Freq + Status criteria,
  client-side over the loaded set, lookup names not codes) + **wide drawer
  min(1080px, 96vw)** organised in regions: Basic Information · Classification ·
  Data Sources (chip multi-select) · KPI Source Figures (chips) · Score Bands
  (fixed 5 rows, operator '—' = skip, BETWEEN reveals threshold 2). CSV export
  of the filtered register. Browser smoke 30/30 EN + AR/RTL.

## Phase 3 — Settings → Manage Security (LIVE 2026-07-29)

- User decisions: **forward to the Admin Security Console** (no duplicated
  screens) + **full KPI security model seeded with enforcement OFF**.
- `db/05`: 7 verb-first KPI privileges (+EN/AR descriptions), 2 privilege
  groups, 3 duty roles (`KPI_DUTY_SETTINGS`/`_WORKSPACE`/`_ADMINISTRATION`)
  nested into the existing job roles (KPI_ADMIN gets all three; KPI_USER +
  KPI_FIN_DIRECTOR get workspace), page registry for all 4 KPI-V2 tabs +
  13 artifacts (tabs/buttons/endpoints) feeding the Security Info drawer,
  `FEATURE_SEC_ENFORCE_KPI = N`, `dct_sec.refresh_flat`. **Nobody's access
  changed** — handlers keep their KPI_ADMIN role checks until the flag flips.
- UI sub-tab: at-a-glance model (job roles / duty roles / privileges cards +
  enforcement chip) + buttons that open the Admin console pages in a new tab
  (#privileges, #privilegeGroups, #dutyRoles, #jobRoles, #secProfiles,
  #userManagement) on the shared session.

## Phase log

| Date | Phase | What | Result |
|---|---|---|---|
| 2026-07-28 | Phase 0 | Scaffold: FPB portal chrome, 4 gated top tabs, hash routing, EN/AR + RTL, shared-session redirect, switcher registration (shared shell + GL's hard-coded list), APP_VERSION 2.0.0 | ✅ built — browser smoke **28/28** (chrome parity, tab gating, deep-link guard, AR/RTL, redirect, switcher) |
| 2026-07-28 | Phase 0 | **DEPLOYED to prod webtier** (release 20260728231109) — shared/ changed (shell MODULES + common i18n) so the whole fleet was bumped + shipped (13 apps; KPI v1 → 1.2.1, GL → 1.47.2 w/ hard-coded switcher entry) | ✅ live at /KPI-V2/Jet/ (index+css 200, shell.js carries kpiv2, GL switcher carries K2) |
| 2026-07-28 | Phase 1 | Settings page: left nav + **Manage Lookups** master-detail. DB `db/v2/109` (dct_lookup_values +desc EN/AR +start/end, 0 INVALID) + `KPI-V2/db/01` (14 KPI2_* lookups / 44 values EN+AR) + `KPI-V2/db/02` (6 additive kpi.rest v2 routes) all DEPLOYED to PROD; API smoke 24/24 real checks (auth/404/400 dup/dates/effective statuses/partial PUT), browser smoke **29/29** EN + AR/RTL incl. live create/edit/deactivate + CSV downloads | ✅ live |
| 2026-07-28 | Phase 1 | **DEPLOYED to prod webtier** (release 20260728233914) — KPI-V2 only change (no shared/ edits, no fleet bump), APP_VERSION 2.1.0 | ✅ live (index 200, settings view + AR keys verified on prod) |
| 2026-07-29 | Phase 2 | KPI master records: 01 re-run (KPI2_KPI_TYPE, now 15 lookups), db/03 DCT_KPI2_* DDL + synonyms, db/04 five additive kpi.rest routes; Manage KPIs sub-tab + wide region-organised drawer + CSV | ✅ PROD; API 16/16 |
| 2026-07-29 | Phase 3 | Security model: db/05 — 7 privileges, 2 groups, 3 duties → job roles, 4 pages + 13 artifacts in the security registry, FEATURE_SEC_ENFORCE_KPI=N; Manage Security sub-tab forwards to the Admin console | ✅ PROD (refresh_flat run, access unchanged) |
| 2026-07-29 | Phase 2+3 | **DEPLOYED to prod webtier** (release 20260729000502), APP_VERSION 2.2.0; browser smoke **30/30** EN + AR/RTL | ✅ live |
| 2026-07-29 | Phase 2 UI round | KPI drawer regions restyled as **bordered region cards with brand-filled headers** (`.dw-reg` / `.dw-reg-h` brand fill + gold diamond + white serif title, bands hint inline in the header; `.dw-reg-b` soft-cream body) — user review request; APP_VERSION 2.2.1 | ✅ live |
