# AP_PLAN.md — Accounts Payable (App 212)

**Date:** 2026-07-12 · **Status:** EXECUTED 2026-07-12 (see STATUS.md) · **Model app:** BI (App 211) scaffold + GL (App 210) analytics-ORDS patterns

> Post-plan additions requested during the build: **detail-level selector**
> (Header / Line / Distribution radio at the top of the dashboard) driving the
> register grain, its exports and the print report → extra endpoints
> `/ap/lines`, `/ap/dists` (+ CSV exports) in `db/04_ap_level_ords.sql`.
> Script numbering as built: 01 module seed · 02 DCT_AP_PKG facet engine ·
> 03 ap.rest core · 04 level endpoints (additive; re-run after any 03 re-run).

---

## 1. Purpose

Give the Accounts Payable team a professional, easy-to-use analytics workspace over the
Fusion-loaded AP invoice data: **AP Aging, AP Register, and status views by
Project / PO / Supplier / Sector / Department**, with APEX-style faceted search,
graphical + tabular results, exports, and a print-ready pixel report.

The app ships with:
- a **blank Home page** (content to be designed later, per requirement), and
- the **AP Dashboard** page (the deliverable of this round).

## 2. Identity & scaffold

| Item | Value |
|---|---|
| App number | **212** |
| Module code | `AP` (key `ap`, badge `AP`) |
| App name | Accounts Payable – AP / الحسابات الدائنة |
| Brand colour | `#8E3B5C` (deep burgundy; dark `#6d2c46`, soft `#f4e9ee`) |
| ORDS module | `ap.rest` at `/ords/admin/ap/` |
| Folder | `final apps/AP/` (`Jet/`, `db/`, `docs/`, `tests/`, `UAT/`, `STATUS.md`, `AP_PLAN.md`) |
| Auth | Shared `ifinance_jet_session` — no own login; redirects to Admin JET (App 200) |
| Data sources | `PROD.AP_INVOICES_HEADER_V` (5,434 hdrs), `AP_INVOICE_LINES_V` (14,094), `AP_INVOICE_DISTRIBUTIONS_V` (25,324) — read-only |

Registration: `shared/js/shell.js` MODULES + `shared/i18n/common.en/ar.json`
(`mod.ap` / `mod.ap.desc`) + `DCT_MODULES` row (`AP`, App 212, category FINANCE)
+ CLAUDE.md Module Status row + APP_VERSION bump in **all** apps (shared layer changes).
dev-proxy siblings auto-derive (no edits needed).

## 3. Data mapping decisions (from live-view profiling)

| Facet asked | Column used | Grain |
|---|---|---|
| Sector | `SECTOR_NAME` | distributions |
| Department | `EXPENDITURE_ORGANIZATION` | lines |
| Cost Center | `COST_CENTER_CODE`/`_DESC` | distributions |
| Supplier | `SUPPLIER_NAME` (495 distinct) | header |
| Project / Task | `PROJECT_NUMBER`/`TASK_NUMBER` | distributions |
| Expenditure type | `EXPENDITURE_TYPE` (69) | distributions |
| GL (natural account) | `ACCOUNT_CODE`/`_DESC` (87) | distributions |
| Appropriation | `APPROPRIATION_CODE`/`_DESC` (15) | distributions |
| PO / PR | `PO_NUMBER` / `PR_NUMBER` | distributions (+ header `PO_NUMBERS` display) |
| Requestor | `PR_PREPARER` (177) — header `REQUESTER` is always NULL | distributions |
| Currency | `INVOICE_CURRENCY` (AED/USD/EUR/GBP) | header |
| Invoice status | `VALIDATION_STATUS`, `ACCOUNTING_STATUS`, `INVOICE_STATUS` (incl. Cancelled), `FUNDS_STATUS` | header |
| Paid status | `PAYMENT_STATUS` (Paid/Unpaid) | header |
| Pay group / Payment method | `PAY_GROUP` / `PAYMENT_METHOD` | header |
| Date from/to | `INVOICE_DATE` (also GL-date toggle considered later) | header |

**Aging:** no due-date column, but `TERMS_DATE` is 100% populated → due date proxy.
Buckets on **unpaid balance (`BALANCE_DUE`)** by `TRUNC(SYSDATE)-TRUNC(TERMS_DATE)`:
Current (not due), 1–30, 31–60, 61–90, 91–180, 180+ days past due.
Amounts standardised on `*_AED` columns; dates are Fusion business dates (no TZ wrap).

Distribution/line-grain facets filter headers via `EXISTS` sub-queries keyed on `INVOICE_ID`.

## 4. ORDS API (`ap.rest`, all `validate_session`-protected, GET-only, read-only)

| Endpoint | Purpose |
|---|---|
| `GET /ap/filters` | Facet LOVs (+ header counts for small enums; big lists as typeahead arrays) |
| `GET /ap/summary?…all filters…` | KPIs (count, total AED, paid, outstanding, overdue, suppliers) + chart datasets: aging buckets, validation/accounting/payment status mixes, 12-month trend, top-10 suppliers, by sector, by pay group |
| `GET /ap/invoices?…filters…&sort=&limit=&offset=` | Paged register `{items,total,totals,limit,offset}`, whitelisted sort |
| `GET /ap/invoices/export?…filters…` | CSV export of filtered register (10k cap) |
| `GET /ap/invoices/:id` | Drill: header + lines + distributions |

Standard rules: ADMIN synonyms per PROD view, fresh-session deploy, `q'[...]'`+`[COLON]`
technique, `dct_rest.err` mapping, `{items,total,limit,offset}` pagination.

## 5. Frontend (Jet/, standard shared-shell JET app modeled on BI)

Views: `login` (dev only, AP-branded), `home` (blank professional placeholder),
`dashboard` (the AP Dashboard). Nav: Home · AP Dashboard.

**Dashboard layout (APEX faceted-search pattern):**
- **Facet rail (left)**: search box; checkbox facet groups with counts (Paid status,
  Validation, Accounting, Invoice status/type, Currency, Pay group, Payment method);
  searchable multi-select facets (Supplier, Sector, Department, Cost Center, Project,
  Expenditure Type, GL Account, Appropriation, Requestor); text facets (PO #, PR #,
  Task #); Invoice Date from/to. Applied-filter chips + Clear All. Debounced auto-apply.
- **Region 1 — Analytics** (collapsible ▸ / maximize ⤢ / export): KPI cards row +
  Chart.js charts (shared `chartLoader.makeChart`): AP Aging buckets (bar), Payment &
  Validation status (doughnuts), monthly trend (line, amount + count), Top suppliers
  (horizontal bar), Sector spend (bar), Pay-group mix. Export = summary CSV + per-chart PNG.
- **Region 2 — AP Register** (collapsible / maximize / export): server-paginated
  sortable table (tri-state skeleton/pager/toast), row-click drill drawer
  (`<edit-drawer>`: header KV + Lines + Distributions tabs), CSV (server) + XLSX
  (SheetJS over current filter set) export.
- **Header actions (top-right)**: **Print report** (pixel-formatted A4 landscape print
  document: report title/date/user, the applied search criteria, KPIs, chart images via
  `canvas.toDataURL`, register rows — opens print window → `window.print()`), Refresh,
  Reset filters.

Design-system rules honoured: platform.css classes only, brand tokens in `app.css`,
top-right actions, EN/AR + RTL + Latin digits, `$vm.` in loops, `$data.x || ''` for
nullable JSON, Chart.js via requirejs only, i18n keys in both `app.en.json`/`app.ar.json`.

## 6. Test strategy

- **API (pytest)**: happy paths for all 5 endpoints; filter combinations (header +
  distribution grain); boundary (limit cap, offset past end); errors (401 no token,
  400 bad param, 404 unknown invoice id). Totals reconcile: aging Σ = outstanding KPI;
  register total = summary invoiceCount under identical filters.
- **Browser (Playwright, webapp-testing skill)**: login hand-off, blank home, dashboard
  load, facet apply → charts + table update, collapse/maximize/export both regions,
  drill drawer, print window generation, EN↔AR flip.
- **Regression**: shared-layer bump verified on one existing app (BI) still loading.
- UAT package (Admin convention) to follow in a later round when AP team trials it.

## 7. Deployment & docs

DB order: `01_ap_synonyms.sql` → `02_ap_module_seed.sql` → `03_ap_ords.sql`
(01 & 03 in fresh SQLcl sessions). Frontend: new `AP/Jet` + APP_VERSION bump in all
apps; webtier ship via `webtier/deploy_frontend.sh` (all apps — shared layer changed).
Docs kept current: `STATUS.md`, `docs/deployment-notes.md`, `docs/functions_list.md`,
CLAUDE.md module row, persistent memory entry.

## 8. Out of scope this round (future)

- Role-gating (e.g. `AP_USER`) — everyone authenticated can view for now.
- Payments/instalments detail (no payments view loaded yet), holds workbench,
  supplier statement page, scheduled AP reports through App 211, APEX pages.
- Home page content (explicitly deferred by the user).
