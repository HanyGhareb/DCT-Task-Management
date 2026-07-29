# KPI-V2 (Finance KPIs V2) — Functions List

App 213 frontend rebuild (`final apps/KPI-V2/Jet/`). Rides the live `kpi.rest`
backend. Tabs Me / Admin / Configurations are Phase 0 placeholders.

## Settings (views/settings.html + viewModels/settings.js) — Phases 1–3

Sub-tabs: **Manage Lookups** · **Manage KPIs** · **Manage Security**.

**Manage Lookups — master (lookup categories)**
- `loadLookups(keepSelection)` — list KPI-module + `KPI2_*` lookups w/ value counts + status
- `selectLookup(l)` — select master row → loads its values
- `openNewLookup()` / `openEditLookup()` / `saveLookup()` — create/edit via shared `<edit-drawer>` (code locked on edit)
- `exportLookupsCsv()` — client CSV (UTF-8 BOM)

**Manage Lookups — detail (lookup values)**
- `loadValues()` — values incl. description EN/AR, start/end dates, order, default, effective status
- `openNewValue()` / `openEditValue(v)` / `saveValue()` — create/edit via drawer (dates validated; single default per lookup)
- `exportValuesCsv()` — client CSV
- helpers: `ln`/`ldesc` (localised name/description), `stCls`/`stTxt` (Active / Inactive / Expired / Scheduled chips)

**Manage KPIs (plan-independent master records)**
- `goKpis()` — lazy-loads LOVs + register on first open
- `loadLovs()` / `lovOpts(cat, curObs)` / `lovLabel(i)` / `lovName(cat, code)` — one-call LOV cache; effective values for forms w/ stored-code re-inject; localized names for the register
- `kSearch`/`kFType`/`kFFreq`/`kFStatus` + `filteredKpis` + `resetKpiFilters()` — search criteria (client-side)
- `openNewKpi()` / `openEditKpi(row)` / `saveKpi()` — wide drawer (min(1080px,96vw)) in regions: Basic Information · Classification · Data Sources (chips) · KPI Source Figures (chips) · Score Bands (5 fixed rows, operator blank = skip, BETWEEN reveals threshold 2); single save carries children
- `toggleSource/isSourcePicked` · `toggleFigure/isFigurePicked` — multi-select chips
- `exportKpisCsv()` — CSV of the filtered register with lookup names

**Manage Security (forwards to the Admin Security Console)**
- `secJobRoles` / `secDutyRoles` / `secPrivileges` — at-a-glance KPI security model (mirrors `db/05` seed; enforcement chip FEATURE_SEC_ENFORCE_KPI = N)
- `openAdminSec(route)` — opens Admin console pages in a new tab (#privileges, #privilegeGroups, #dutyRoles, #jobRoles, #secProfiles, #userManagement)

## API Endpoints (ORDS) — additive on kpi.rest

| Method | Path | Purpose | Script |
|---|---|---|---|
| GET | /kpi/v2/lookups | Lookup master list w/ counts | db/02 |
| POST | /kpi/v2/lookups | Create lookup | db/02 |
| PUT | /kpi/v2/lookups/:id | Rename / (de)activate lookup | db/02 |
| GET | /kpi/v2/lookups/:id/values | Values incl. desc/dates/effectiveStatus | db/02 |
| POST | /kpi/v2/lookups/:id/values | Create value | db/02 |
| PUT | /kpi/v2/lookup-values/:id | Edit value (partial-PUT guarded) | db/02 |
| GET | /kpi/v2/kpi-lovs | All KPI2_* + KPI_BAND_OP values + eff flag | db/04 |
| GET | /kpi/v2/kpis | KPI register w/ child counts | db/04 |
| POST | /kpi/v2/kpis | Create KPI + sources[]/figures[]/bands[] | db/04 |
| GET | /kpi/v2/kpis/:id | Full KPI detail incl. arrays | db/04 |
| PUT | /kpi/v2/kpis/:id | Update KPI, children replaced | db/04 |

All routes gated KPI_ADMIN or SYS_ADMIN; errors 401/403/404/400/500 per platform
mapping; lookup-coded fields validated via `dct_lookup_pkg.validate_lookup`.

## Services / data layer

| Module | Role |
|---|---|
| `services/api.js` | re-export of `shared/api` (Bearer inject, 401 → Admin portal) |
| `services/config.js` | apiBase `/ords/admin/kpi`, authBase `/ords/admin/dct` |
| `services/authService.js` | session read, role helpers (`isKpiAdmin`) |
| shared `editDrawer` / `toast` / `i18n` / `skeleton` / `pager` / `interactiveReport` | registered at boot in `main.js` |

## Security registry (db/05)

Privileges `KPI_VIEW_WORKSPACE/ADMIN/CONFIGURATIONS/SETTINGS`,
`KPI_MANAGE_LOOKUPS`, `KPI_MANAGE_DEFINITIONS`, `KPI_EXPORT_REGISTERS`;
duty roles `KPI_DUTY_SETTINGS/WORKSPACE/ADMINISTRATION` nested into the job
roles KPI_ADMIN / KPI_USER / KPI_FIN_DIRECTOR; pages me/admin/configurations/
settings + 13 artifacts. Enforcement flag `FEATURE_SEC_ENFORCE_KPI` = N.
