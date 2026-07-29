# KPI-V2 (Finance KPIs V2, App 213 frontend) — Deployment Notes

Platform-wide SQLcl/ORDS rules: see `final apps/Admin/docs/deployment-notes.md` §2.
KPI-V2 rides App 213's live backend (`/ords/admin/kpi` + `/dct` auth).

## Deploy checklist

1. **DB scripts** (SQLcl `sql -name prod_mcp`, one script per invocation, CRLF, `SET DEFINE OFF`):
   - Platform prerequisites first (e.g. `db/v2/109` before `KPI-V2/db/01`).
   - Seeds with Arabic → run with `-Dfile.encoding=UTF-8`.
   - ORDS scripts in a **fresh** session (never after `ALTER SESSION SET CURRENT_SCHEMA`).
2. **Frontend**: bump `window.APP_VERSION` in `Jet/index.html` on every deploy.
   A change under `final apps/shared/` requires the bump in ALL apps (fleet).
3. **Webtier**: `cd webtier && SSH_USER=opc bash ./deploy_frontend.sh 129.151.159.189`.
4. Smoke: index 200 + APP_VERSION on prod; browser smoke script in the repo history.

## Re-run coupling (IMPORTANT)

- **`KPI/db/06_kpi_ords.sql` rebuilds `kpi.rest` from scratch (DELETE_MODULE).
  After ANY re-run of 06, re-run `KPI-V2/db/02_kpi2_ords.sql` AND
  `KPI-V2/db/04_kpi2_master_ords.sql`** to restore the additive `v2/*` routes.
- `db/v2/101` re-run rule (Security Console API after any 11 re-run) is
  platform-level; KPI-V2's `db/05` seed itself is idempotent — re-run any time.
- `db/v2/109` is rerunnable (column/constraint adds are guarded) and ends with a
  recompile sweep — deploys must finish at 0 INVALID.

## App-specific gotchas

- **`<edit-drawer>` body context**: the drawer body rebinds to the HOST VM
  (`template { nodes: $componentTemplateNodes, data: vm }`), and `$root` inside the
  body is the **drawer component VM**, not the shell — `$root.t(...)` throws there.
  Expose `self.t = i18n.t` on the page VM and bind bare `t(...)` inside drawer bodies.
  The `params="..."` attribute itself evaluates in the OUTER context, so `$root.t`
  is fine inside `params`. **Inside a `foreach` within the drawer body, use
  `$parent.method(...)`** (the host VM is the parent context) — never `$vm`, which
  only exists in module-bound views (same convention as Admin's security drawers).
- **KO options re-inject rule**: `lovOpts(cat, curObs)` appends the stored code
  when it is no longer effective, or KO would silently blank the select.
- **APEX_JSON omits NULL keys** — `NVL(col,'')` does NOT help ('' = NULL in Oracle).
  The VM normalises every nullable field (`normLk`/`normVal`) before rows reach KO.
- KPI-V2 deliberately does NOT call `shell.initBrand`/`initRegionTheme` — the FPB
  (GL) tokens are hard-coded in `css/app.css` per the user's Phase 0 decision.
- v1 isolation: KPI-V2 lookup categories are `KPI2_*`; v1's `/kpi/boot` matches
  `LIKE 'KPI\_%' ESCAPE '\'`, so KPI2 rows never appear in v1. v1's `KPI_*`
  categories are `is_system='Y'` + module NULL → not listed and 403 on edit in v2.

## Deployment history

| Date | What | Release / result |
|---|---|---|
| 2026-07-28 | Phase 0 scaffold (FPB chrome, 4 gated tabs) + fleet bump (shared/ changed) | webtier 20260728231109; smoke 28/28 |
| 2026-07-28 | Phase 1 DB: db/v2/109 → KPI-V2/db/01 (seed, UTF-8) → KPI-V2/db/02 (ORDS, fresh session) | PROD, 0 INVALID; API smoke 24/24 |
| 2026-07-28 | Phase 1 frontend: Settings left nav + Manage Lookups master-detail, APP_VERSION 2.1.0 (KPI-V2 only, no fleet bump) | webtier 20260728233914; browser smoke 29/29 EN+AR |
| 2026-07-29 | Phase 2 DB: 01 re-run (KPI2_KPI_TYPE) → 03 DDL+synonyms (fresh session) → 04 ORDS (fresh session) | PROD; API smoke 16/16 |
| 2026-07-29 | Phase 3 DB: 05 security seed (UTF-8) — privileges/groups/duties/pages, FEATURE_SEC_ENFORCE_KPI=N, refresh_flat | PROD; access unchanged by design |
| 2026-07-29 | Phase 2+3 frontend: settings sub-tabs + Manage KPIs + Manage Security, APP_VERSION 2.2.0 (KPI-V2 only) | webtier 20260729000502; browser smoke 30/30 EN+AR |
