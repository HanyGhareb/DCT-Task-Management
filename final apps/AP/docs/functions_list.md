# AP (App 212) — Functions List

Functional inventory of the Accounts Payable JET app (`final apps/AP/Jet/`).
Maintenance rule: update this file in the SAME change as any view/viewModel/service/ORDS edit.

## Home (`views/home.html` + `viewModels/home.js`)

Blank by design — content will be designed later.
- `openDashboard()` — navigate to the AP Dashboard.

## AP Dashboard (`views/dashboard.html` + `viewModels/dashboard.js`)

**Detail level selector** (radio, top of dashboard)
- `setLevel(level)` — switch the register grain: `header` | `line` | `dist` (drives table columns, exports, print).

**Faceted search rail (APEX-style)**
- 17 facet groups (`toggleGroup`, `toggleItem`, per-group mini-filter): Paid/Validation/Accounting/Invoice status, Invoice type, Currency, Pay group, Payment method, Sector (counted checkboxes); Supplier, Department, Cost center, Project, Expenditure type, GL account, Appropriation, Requestor (searchable lists).
- Free-text search, invoice-date from/to, PO / PR / Task inputs (debounced auto-apply).
- `chips` — applied-filter chips with per-chip clear; `resetFilters()` — clear everything.

**Region 1 — Analytics** (collapsible / maximizable / exportable)
- 7 KPI tiles: invoices, suppliers, total/paid/outstanding/overdue AED, cancelled.
- 8 charts (Chart.js via `shared/chartLoader`): AP aging (terms-date buckets, ordinal ramp), Paid vs unpaid doughnut, monthly trend, validation status, accounting status, top-10 suppliers, spend by sector, spend by pay group.
- `exportSummaryCsv()` — analytics datasets as sectioned CSV; `exportChartsPng()` — composite PNG of all charts.
- `toggleCharts()` / `toggleChartsMax()`.

**Region 2 — AP Register** (collapsible / maximizable / exportable)
- `toggleViewMode()` — **Interactive view**: swaps the register for the shared `<interactive-report>` component (one-shot capped fetch, 10k rows) with column rename, calculated columns (irExpr), aggregates footer, control breaks, highlight rules, typed filter chips, multi-sort, global search, CSV/XLSX — layouts autosaved per user/level (localStorage; `reportCode 'AP_REGISTER'`, section = level).
- Server-paginated metadata-driven table at the selected level (`reloadRows`, `<list-pager>`), sortable headers (`sortBy`: date/amount/balance/supplier).
- **Column chooser** (`toggleColsPanel`, `toggleCol`, `showAllCols`, `resetCols`): per-level show/hide over the full column catalog (`COLS`), persisted per user — localStorage autosave + server preference `ap.dash.cols` via `/dct/prefs` (BI-viewer style, roams across machines). The print report mirrors the visible columns.
- Distribution level exposes the **effective charge account**: `glCombination` (canonical full GL combination via `dct_cc_canon`; sourced from the **PO distribution line** for PO-matched invoices, AP dist fallback), `chargeSource` (PO/AP), `poChargeAccount`, plus the full invoice-detail column set (descriptions, pay group, terms, method, voucher, chapter/program, posting, accounting date…).
- `exportCsv()` — server CSV of the full filtered set (header 10k / line-dist 25k cap); `exportXlsx()` — SheetJS Excel from the same export.
- `openDrill(row)` / `closeDrill()` / `setDrillTab(tab)` — invoice drill modal (Header KV + Lines + Distributions tabs).
- `toggleTable()` / `toggleTableMax()`.

**Header actions**
- `printReport()` — pixel-formatted A4-landscape print window: title block, generated-by, the applied search criteria, KPIs, chart images, first 200 register rows at the current level.
- `refresh()` — reload summary + rows.

## API Endpoints (ORDS — `ap.rest`, base `/ords/admin/ap/`)

| Method | Path | Purpose |
|---|---|---|
| GET | `/ap/filters` | Facet LOVs + global header counts + min/max invoice date |
| GET | `/ap/summary` | KPIs + chart datasets for the current facets |
| GET | `/ap/invoices` | Paged header-level register `{items,total,totals,limit,offset}` |
| GET | `/ap/invoices/export` | CSV of the filtered header register (10k cap) |
| GET | `/ap/invoices/:id` | Invoice drill: header + lines + distributions |
| GET | `/ap/lines` | Paged line-level register (own-grain facets re-applied) |
| GET | `/ap/lines/export` | CSV (25k cap) |
| GET | `/ap/dists` | Paged distribution-level register (own-grain facets re-applied) |
| GET | `/ap/dists/export` | CSV (25k cap) |

All protected by `dct_rest.validate_session`; facet params: `datefrom dateto supplier paid val acc inv itype curr paygroup paymethod sector dept cc project task etype account approp po pr req search` (+ `limit offset sort`), multi-values pipe-delimited.

## Services / Data layer

| File | Role |
|---|---|
| `services/config.js` | `apiBase=/ords/admin/ap`, `authBase=/ords/admin/dct`, admin portal URL |
| `services/api.js` | re-export of `shared/api` (Bearer + 401 handling) |
| `services/authService.js` | shared-session reader (login/logout for dev standalone) |
| `services/apService.js` | `getFilters` / `getSummary` / `getRows(level)` / `getInvoice` / `getExportBlobUrl` / `getExportCsvText` |
| DB | `PROD.DCT_AP_PKG` (`in_list`, `filtered_ids`) — shared facet engine used by every handler |
