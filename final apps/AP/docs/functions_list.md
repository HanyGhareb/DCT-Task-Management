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
- **Effective supplier + Is Beneficiary (2026-07-13)**: the generic `BENEFICIARY` supplier is replaced by the invoice's beneficiary name wherever available (register all levels, exports, top-suppliers chart, suppliers KPI, supplier sort) plus an `Is Beneficiary` Y/N column at every level; free-text search also matches the beneficiary name; the drill keeps raw supplier + beneficiary + flag.
- **Column chooser** (`toggleColsPanel`, `toggleCol`, `showAllCols`, `resetCols`): per-level show/hide over the full column catalog (`COLS`), persisted per user — localStorage autosave + server preference `ap.dash.cols` via `/dct/prefs` (BI-viewer style, roams across machines). The print report mirrors the visible columns.
- Distribution level exposes the **effective charge account**: `glCombination` (canonical full GL combination via `dct_cc_canon`; sourced from the **PO distribution line** for PO-matched invoices, AP dist fallback), `chargeSource` (PO/AP), `poChargeAccount`, plus the full invoice-detail column set (descriptions, pay group, terms, method, voucher, chapter/program, posting, accounting date…).
- `exportCsv()` — server CSV of the full filtered set (header 10k / line-dist 25k cap); `exportXlsx()` — SheetJS Excel from the same export.
- `fusionUrl/fusionPoUrl/fusionPrUrl` + `cellLink(row,col)` — Oracle Fusion deep-links via the SHARED `shared/js/fusionLinks.js` (v1.7.0): invoice numbers (all register levels, drawer, invoice window) + PO/PR numbers (line/dist register levels, invoice-window Lines/Dists tabs) open Fusion in a new tab; needs `poHeaderId`/`prHeaderId` from the endpoints. v1.7.1: the invoice-window **header** Supplier & References PO/PR fields link too — the drill's `poRefs`/`prRefs` `{num,id}` arrays are hoisted onto `header` in `openDrill` and rendered as one anchor per referenced document (plain-text LISTAGG fallback).
- `openDrill(row)` / `closeDrill()` / `setDrillTab(tab)` / `invMax`+`toggleInvMax()` — invoice drill window (2026-07-13 redesign): master header region + top-right Summary card (amounts + status badges) + detail tabs (Lines, Distributions) + ⤢ full-screen maximize (Esc restores, then closes). Round 2 (v1.6.0): Summary card fills the region height; `invAuditOpen`/`toggleInvAudit()` Audit-info collapsible (created/updated by+date); Distributions tab shows the full GL combination with `ccHover/ccMove/ccOut` 10-segment popover (GL-Actuals style, data from the drill's `dct_gl_coa_snap` join). v1.6.1: Summary card Approval badge row (`apprBadge`; header view exposes `approval_status` display labels).
- **New criteria (2026-07-13, v1.4.0)**: `gldatefrom`/`gldateto` (GL Date from/to) + `inclCancelled`/`toggleInclCxl()` (Include Cancelled Invoices? checkbox, default on; off sends `inclcxl=N`).
- **Chart drill-down drawer (2026-07-13)** — every chart segment (aging bar, paid/unpaid slice, trend month, validation/accounting/top-supplier/sector/pay-group bar) opens a GL-butil-style right-edge drawer with the related invoices: `dwCols`/`dwRows`/`dwTitle`/`dwEyebrow`/`dwCtx`/`dwCapNote` state, `toggleDwMax()` (⤢ full-screen, Esc restores then closes), `dwExportCsv()` (BOM CSV + reconciliation total footer), `closeDw()`; drawer rows call `openDrill(row)` (modal layers above). Drill facets sent: `aging` / `paid` / `rcvfrom+rcvto` / `val` / `acc` / `esupplier` / `sector` / `paygroup`.
- **Chart hints (2026-07-13)** — ⓘ tooltip per chart title (`ch.<key>.hint` i18n EN/AR) stating content, date basis and criteria; the monthly trend is based on Invoice Received Date (invoice-date fallback) and defaults to the current budget year.
- `toggleTable()` / `toggleTableMax()`.

**Header actions**
- `printReport()` — pixel-formatted A4-landscape print window: title block, generated-by, the applied search criteria, KPIs, chart images, first 200 register rows at the current level.
- `refresh()` — reload summary + rows.

## Beneficiaries Dashboard (`views/beneficiaries.html` + `viewModels/beneficiaries.js`) — v1.8.0

The full AP Dashboard locked to the generic **BENEFICIARY supplier (supplier number 26553)**. `beneficiaries.js` mounts the SAME `dashboard.html` view with `new DashboardViewModel({ benef: true, suppnum: '26553' })` via a nested `module` binding — zero duplicated markup, the two dashboards can never drift. Every feature above (levels, facets, charts + drill drawer, register, interactive view, column chooser, exports, print, invoice window) works identically inside the scope. Benef-mode differences (all inside `dashboard.js`):
- `buildParams()` always sends `suppnum=26553` (never shown as a chip); `/filters` is called with it so every LOV + count is scoped.
- **Beneficiary name = supplier name**: the register/drawer Supplier column is relabeled *Beneficiary*; the supplier facet group becomes *Beneficiary* and sends `esupplier=` (the scoped `/filters` suppliers LOV lists beneficiary names); the invoice window shows the beneficiary as the supplier headline; KPI label = *Beneficiaries*; chart = *Top beneficiaries (AED)*.
- **Site number = the beneficiary's supplier number**: the `Is Beneficiary` column is replaced by a visible **Supplier No** column bound to `supplierSite` (all 3 levels + drill drawer); the standard AP dashboard gains the same field as a hidden-by-default *Supplier site* column.
- Own column-chooser persistence (`ap.benef.cols` server pref + `ifinance.ap.benef.cols` localStorage) and own interactive-report code `AP_BENEF_REGISTER`, so layouts never clash with the AP Dashboard.
- Exports/print are prefixed `ap-beneficiaries-*` and the print title is the Beneficiaries report title (EN/AR `ben.*` i18n keys).

## API Endpoints (ORDS — `ap.rest`, base `/ords/admin/ap/`)

| Method | Path | Purpose |
|---|---|---|
| GET | `/ap/filters` | Facet LOVs + global header counts + min/max invoice date |
| GET | `/ap/summary` | KPIs + chart datasets for the current facets |
| GET | `/ap/invoices` | Paged header-level register `{items,total,totals,limit,offset}` |
| GET | `/ap/invoices/export` | CSV of the filtered header register (10k cap) |
| GET | `/ap/invoices/:id` | Invoice drill: header + `poRefs`/`prRefs` (distinct referenced docs `{num,id}`, v1.7.1 header deep-links) + lines + distributions |
| GET | `/ap/lines` | Paged line-level register (own-grain facets re-applied) |
| GET | `/ap/lines/export` | CSV (25k cap) |
| GET | `/ap/dists` | Paged distribution-level register (own-grain facets re-applied) |
| GET | `/ap/dists/export` | CSV (25k cap) |

All protected by `dct_rest.validate_session`; facet params: `datefrom dateto supplier paid val acc inv itype curr paygroup paymethod sector dept cc project task etype account approp po pr req search glfrom glto rcvfrom rcvto esupplier aging suppnum inclcxl` (+ `limit offset sort`), multi-values pipe-delimited. `suppnum=` (multi, `supplier_number`; 2026-07-13 Beneficiaries round) scopes `filtered_ids` AND the `/filters` LOVs/counts — with it, the `suppliers` LOV lists the beneficiary-aware **effective** supplier names; register/drill rows at every level carry `supplierSite` (lines/dists via a header join) and the header CSV exports gained a `Site` column. `aging` = one bucket code (`CURRENT|D1_30|D31_60|D61_90|D91_180|D180P`); `esupplier` matches the beneficiary-aware effective supplier; `inclcxl=N` excludes cancelled invoices (frontend DEFAULT since v1.5.0; `/filters` also honours it for counts + LOVs). `appr=` filters by approval status (multi, display labels; v1.6.4). Received-date facets/trend use `COALESCE(invoice_received_date, created_date, invoice_date)`. **Item-only rule (2026-07-13):** all distribution-grain facets, dist-based LOVs and the bySector dataset consider `distribution_type='Item'` rows only, so facet counts reconcile with the KPIs/charts.

## Services / Data layer

| File | Role |
|---|---|
| `services/config.js` | `apiBase=/ords/admin/ap`, `authBase=/ords/admin/dct`, admin portal URL |
| `services/api.js` | re-export of `shared/api` (Bearer + 401 handling) |
| `services/authService.js` | shared-session reader (login/logout for dev standalone) |
| `services/apService.js` | `getFilters` / `getSummary` / `getRows(level)` / `getInvoice` / `getExportBlobUrl` / `getExportCsvText` |
| DB | `PROD.DCT_AP_PKG` (`in_list`, `filtered_ids`) — shared facet engine used by every handler |
