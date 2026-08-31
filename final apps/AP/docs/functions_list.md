# AP (App 212) — Functions List

Functional inventory of the Accounts Payable JET app (`final apps/AP/Jet/`).
Maintenance rule: update this file in the SAME change as any view/viewModel/service/ORDS edit.

## Home (`views/home.html` + `viewModels/home.js`)

Blank by design — content will be designed later.
- `openDashboard()` — navigate to the AP Dashboard.

## AP Dashboard (`views/dashboard.html` + `viewModels/dashboard.js`)

**Detail level selector** (radio, top of dashboard)
- `setLevel(level)` — switch the register grain: `header` | `line` | `dist` | `inst` (installments payment schedule; drives table columns, exports, print).

**Faceted search rail (APEX-style)**
- 18 facet groups (`toggleGroup`, `toggleItem`, per-group mini-filter): Paid/Validation/Accounting/Invoice status, Invoice type, Currency, Pay group, Payment method, Sector, **Chapter (v1.22.0 — per-invoice classification like Sector: single chapter / `(Multiple chapters)` / `Unclassified`, counts sum to the invoices KPI; on ALL THREE dashboards)** (counted checkboxes); Supplier, Department, Cost center, Project, Expenditure type, GL account, Appropriation, Requestor (searchable lists).
- Free-text search, invoice-date from/to, PO / PR / Task inputs (debounced auto-apply).
- `chips` — applied-filter chips with per-chip clear; `resetFilters()` — clear everything.

**Region 1 — Analytics** (collapsible / maximizable / exportable)
- 7 KPI tiles: invoices, suppliers, total/paid/outstanding/overdue AED, cancelled. Overdue + Days-past-due follow the same DUE_DATE basis as aging; the register gains a hidden-by-default Due date column (also in CSV export + invoice-window Payment section).
- 8 charts (Chart.js via `shared/chartLoader`): AP aging (DUE-DATE buckets — due date = received date [→created→invoice] + payment-terms days, v1.10.0), Paid vs unpaid doughnut, monthly trend, validation status, accounting status, top-10 suppliers, spend by sector, spend by pay group. **Branded data tooltips (v1.10.0)**: hovering any bar/slice/point shows a white brand-bordered card (`tipOpts()`) with labeled rows — Amount (AED) / Invoices / Share of total — and a "Click to list the invoices" footer; no raw `count · amount` strings anywhere (also fixed in the hint-popover rows).
- `exportSummaryCsv()` — analytics datasets as sectioned CSV; `exportChartsPng()` — composite PNG of all charts.
- `toggleCharts()` / `toggleChartsMax()`.

**Region 2 — AP Register** (collapsible / maximizable / exportable)
- `toggleViewMode()` — **Interactive view**: swaps the register for the shared `<interactive-report>` component (one-shot capped fetch, 10k rows) with column rename, calculated columns (irExpr), aggregates footer, control breaks, highlight rules, typed filter chips, multi-sort, global search, CSV/XLSX — layouts autosaved per user/level (localStorage; `reportCode 'AP_REGISTER'`, section = level).
- Server-paginated metadata-driven table at the selected level (`reloadRows`, `<list-pager>`), sortable headers (`sortBy`: date/amount/balance/supplier).
- **Effective supplier + Is Beneficiary (2026-07-13)**: the generic `BENEFICIARY` supplier is replaced by the invoice's beneficiary name wherever available (register all levels, exports, top-suppliers chart, suppliers KPI, supplier sort) plus an `Is Beneficiary` Y/N column at every level; free-text search also matches the beneficiary name; the drill keeps raw supplier + beneficiary + flag.
- **Column chooser** (`toggleColsPanel`, `toggleCol`, `showAllCols`, `resetCols`): per-level show/hide over the full column catalog (`COLS`), persisted per user — localStorage autosave + server preference `ap.dash.cols` via `/dct/prefs` (BI-viewer style, roams across machines). The print report mirrors the visible columns.
- Distribution level exposes the **effective charge account**: `glCombination` (canonical full GL combination via `dct_cc_canon`; sourced from the **PO distribution line** for PO-matched invoices, AP dist fallback), `chargeSource` (PO/AP), `poChargeAccount`, plus the full invoice-detail column set (descriptions, pay group, terms, method, voucher, chapter/program, posting, accounting date…).
- `exportCsv()` — server CSV of the full filtered set (header 10k / line-dist 25k cap); `exportXlsx()` — SheetJS Excel from the same export.
- `fusionUrl/fusionPoUrl/fusionPrUrl` + `cellLink(row,col)` — Oracle Fusion deep-links via the SHARED `shared/js/fusionLinks.js` (v1.7.0): invoice numbers (all register levels, drawer, invoice window) + PO/PR numbers (line/dist register levels, invoice-window Lines/Dists tabs) open Fusion in a new tab; needs `poHeaderId`/`prHeaderId` from the endpoints. v1.7.1: the invoice-window **header** Supplier & References PO/PR fields link too — the drill's `poRefs`/`prRefs` `{num,id}` arrays are hoisted onto `header` in `openDrill` and rendered as one anchor per referenced document (plain-text LISTAGG fallback). v1.12.0: the **Interactive view** links the same columns — the IR envelope passes a `cellLink(row,colKey)` adapter to the shared component's new hook (`.ir-link` anchors); PO/PR/receipt/voucher are typed `text` in the envelope so they no longer render comma-grouped.
- `ccRegOver/ccRegMove/ccRegOut` (v1.12.0) — delegated hover on the register region: the 10-segment COA popover (same `.combo-tip` as the invoice window) shows over `glCombination`/`chargeAccount`/`poChargeAccount` cells in BOTH standard and Interactive views (cells carry `data-key`); segments lazy-loaded per combination from `GET /ap/cc` and cached.
- `openDrill(row)` / `closeDrill()` / `setDrillTab(tab)` / `invMax`+`toggleInvMax()` — invoice drill window (2026-07-13 redesign): master header region + top-right Summary card (amounts + status badges) + detail tabs (Lines, Distributions) + ⤢ full-screen maximize (Esc restores, then closes). Round 2 (v1.6.0): Summary card fills the region height; `invAuditOpen`/`toggleInvAudit()` Audit-info collapsible (created/updated by+date); Distributions tab shows the full GL combination with `ccHover/ccMove/ccOut` 10-segment popover (GL-Actuals style, data from the drill's `dct_gl_coa_snap` join). v1.6.1: Summary card Approval badge row (`apprBadge`; header view exposes `approval_status` display labels).
- **New criteria (2026-07-13, v1.4.0)**: `gldatefrom`/`gldateto` (GL Date from/to) + `inclCancelled`/`toggleInclCxl()` (Include Cancelled Invoices? checkbox, default on; off sends `inclcxl=N`).
- **Chart drill-down drawer (2026-07-13)** — every chart segment (aging bar, paid/unpaid slice, trend month, validation/accounting/top-supplier/sector/pay-group bar) opens a GL-butil-style right-edge drawer with the related invoices: `dwCols`/`dwRows`/`dwTitle`/`dwEyebrow`/`dwCtx`/`dwCapNote` state, `toggleDwMax()` (⤢ full-screen, Esc restores then closes), `dwExportCsv()` (BOM CSV + reconciliation total footer), `closeDw()`; drawer rows call `openDrill(row)` (modal layers above). Drill facets sent: `aging` / `paid` / `rcvfrom+rcvto` / `val` / `acc` / `esupplier` / `sector` / `paygroup`.
- **Rich hint popovers (2026-07-14, v1.9.0)** — the ⓘ on every chart title AND on the Analytics/Register region headings opens a styled popover (`.ap-tip`: brand header + description + LIVE figures for the current filter selection via `hintOver/hintMove/hintOut` + `hintStats`). Chart stats: aging (outstanding/overdue/unpaid count/largest bucket), payment (per-status count·amount + paid share), trend (months/total/peak/latest), validation+accounting (statuses/largest/share of total), top suppliers (supplier count/#1/top-10 share), sector (buckets/#1/unclassified), pay group (groups/#1+share); region stats: KPIs / detail level / filtered rows / active-filter count. Descriptions stay in `ch.<key>.hint` (+ new `rg.*.hint`, stat labels `ht.*`); the monthly trend is based on Invoice Received Date (creation-date fallback) and defaults to the current budget year. Benef mode swaps labels + scope wording (`ben.analytics.hint`/`ben.register.hint`).
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
- **Check duplicate using AI… (since v1.16.0)** — `runAiDup()` header button navigates to the **AI Duplicate Check page** (`aiDuplicates` view); all analysis UI lives there.

## Direct AP Dashboard (`views/directap.html` + `viewModels/directap.js`) — v1.21.0

The full AP Dashboard locked to **invoices with NO purchase-order reference and NO project coding anywhere** — the direct-expense slice of Payables. `directap.js` mounts the SAME `dashboard.html` view with `new DashboardViewModel({ nopo: true })` via a nested `module` binding (the Beneficiaries pattern — zero duplicated markup). The rule (server-side, `dct_ap_pkg.filtered_ids p_nopo='Y'`): `header_po_number IS NULL AND po_count = 0 AND project_count = 0` **AND no invoice LINE carries a `po_number`/`project_number`** (the header counts derive from distributions only; 131 invoices are project-coded at the line grain with clean distributions and are excluded too). Nopo-mode differences (all inside `dashboard.js`):
- `buildParams()` + the `/filters` call always send `nopo=Y` (never shown as a chip), so every LOV, count, KPI, chart, register grain and export is scoped.
- Facet groups that are empty by definition are dropped (Project / Expenditure type / Requestor), and the PO / PR / Task reference inputs are hidden; the GL-coding facets (Cost centre / Account / Appropriation / Sector) remain — for direct invoices the GL combination IS the coding story.
- PO/PR/project/task columns are hidden by default at every level (the column chooser can re-enable them; they are always empty here).
- Own column-chooser persistence (`ap.direct.cols` server pref + `ifinance.ap.direct.cols` localStorage) and own interactive-report code `AP_DIRECT_REGISTER`; exports/print prefixed `ap-direct-*` (EN/AR `dap.*` i18n keys).
- **Briefing Book (Excel)** header button — `runBook()` posts the page's current criteria (bu / supplier / paid / val / datefrom / dateto / search / inclcxl) to `POST /ap/direct/report`, polls `GET /ap/direct/report/:id` every 5 s and auto-downloads the workbook (`:id/file`) — Reporting-Platform definition `AP_DIRECT_REGISTER` (reporting/db/38), 5 sheets: overview by payment status, the full direct-invoice register, by supplier (beneficiary-aware), GL coding of the non-tax distributions, aging of the unpaid balance. XLSX only (no PDF template authored; other formats = 400).

## AI Duplicate Check (`views/aiDuplicates.html` + `viewModels/aiDuplicates.js`) — v1.16.0

**v1.17.0 (2026-08-11) — run criteria + explanations + self-pair guard:**
- **Run criteria region** (applies to the NEXT run; every stored run echoes the criteria it was made with — `inclFab/inclCxl/createdFrom/createdTo` in both envelopes and on the run line): *Include FAB DEBIT CARD vendors* (any vendor whose effective name STARTS WITH `FAB DEBIT CARD`; **default excluded** — corporate-card payees), *Include cancelled invoices* (**default excluded**), and an *Invoice created from / to* window on the invoice CREATED date. Applied server-side to the entry list, the bank-account map, the sharedAccounts section and the `runid+grp` drill (drill counts reconcile with the group's stored counts).
- **Short explanation per finding**: every AI group shows `Why flagged: <evidence>` (the prompt now requires the concrete variation type + shared-account last-4; fallback text when the model omits it), and every shared-account block shows a deterministic `Why flagged:` line (N vendor names on one account across M invoices).
- **Self-pair guard**: `DISTINCT` on the AI-returned ids + ≥2 distinct entries per group — kills the model-emitted `ids:[57,57]` groups that showed one beneficiary twice with doubled totals (29 such groups in run 21).
- **Truncated-response salvage**: responses cut at the provider's output-token ceiling are trimmed to the last complete group and re-validated (plus control-character normalisation) instead of failing with "please retry".

**v1.18.0 (2026-08-12) — reason-category sections:**
- **Same-reason findings grouped into their own section** (user requirement): every AI group carries a server-derived `reasonType` (`dct_ap_ai_pkg.reason_type` — deterministic keyword classification of the enforced reason format, published in the pkg spec, retroactive on stored runs) and the page clusters the group cards under one brand-accented section band per category (`dupSections` computed, `.ai-sec/.ai-sec-hd/.ai-sec-pill/.ai-sec-stats`): band shows the category label + group-count pill + combined invoices/AED. Vocabulary (fixed order): SPELLING / TRANSLITERATION / SPACING / CAPITALISATION / WORD_ORDER / TYPO / ABBREVIATION / PARTIAL_NAME / COMPANY_SUFFIX / NAME_VARIATION (generic wording) / SHARED_ACCOUNT (account-only reasons) / OTHER — variation types win over the supplementary shared-account mention. Prompt now demands the SPECIFIC variation type (never the generic phrase "name variation"). `aiExportCsv()` gains a *Finding type* column; labels i18n'd EN+AR (`ai.rt.*`).

- **Last-run load** — the page opens on the LATEST persisted AI run instantly (`GET /ap/benef/dupcheck/last`; `neverRan` empty state with a Run button when no run exists); `runAiDup()` = "Run / Re-run analysis…" (`POST /ap/benef/dupcheck`, ~30–60 s, results persisted server-side with `runId/ranAt/ranBy` shown in the run line).
- **Duplicate groups region** — AI likely-duplicate groups (canonical + confidence badge `aiConfCls/aiConfTxt` + reason + member table incl. bank accounts); **Shared bank accounts region** (red `.ai-group--warn`) — same account paid under 2+ different vendor names, platform-wide (`aiShared`, `aiSharedTrunc` top-100 note).
- **Invoice drills** — every invoice count is a link: `drillGroup(g)` (runid+grp), `drillMember(m)` (name), `drillAccount(a)` (bank, platform-wide), `drillVendorAccount(a,v)` (bank+name) → right-edge drawer (`dwOpen/dwRows/dwCount/dwTotal`, Esc closes) over `GET /ap/benef/dupinvoices`; **invoice numbers deep-link to Fusion** (`fusionLinks.invoice`); `dwExportCsv()` with reconciling total.
- **Generate reports** — `runPdf()` / `runXlsx()` enqueue Reporting-Platform definition `AP_BENEF_DUP_REGISTER` via `POST /ap/benef/dupreport` and poll `GET /ap/benef/dupreport/:id` every 5 s until the file auto-downloads (`GET :id/file`); `aiExportCsv()` = on-page CSV of both sections.


## Procash Transactions — register (`views/procash.html` + `viewModels/procash.js`) — v1.19.0

Manual payments pushed through the bank portal directly, outside Fusion Payables.

- `load` / `reload` — paged register over `GET /ap/procash/` with the current filters
- `onPage` — pager hook (shared `<list-pager>`)
- `onSearchKey` — debounced free-text search (350 ms)
- `resetFilters` — clears status / business unit / invoice-link / date range / mine / search
- `openRow` — opens one transaction on the entry page (id handed over through the shell state bag)
- `openNew` — starts a new transaction (hidden unless the server reports `canCreate`)
- `exportCsv` — authed CSV of the filtered register
- `toggleTableMax` — maximise the results region
- `num` / `statusLabel` / `pillCls` — formatting; status labels come from the lookup, never hard-coded
- KPI band: `kTotal`, `kAmount`, `kOpen`, `kAwaiting` (computed from the response envelope's `totals`)

## Procash Transactions — entry (`views/procashEntry.html` + `viewModels/procashEntry.js`) — v1.19.0

- `reload` — header + lines + documents + history + findings for one transaction
- `save` — create or update the header (partial update: an absent key keeps the stored value)
- `submitTrx` / `processTrx` / `cancelTrx` — lifecycle transitions
- `openInvoicePicker` / `onInvSearch` / `pickInvoice` / `unlinkInvoice` — Fusion payable invoice reconciliation
- `addLine` / `editLine` / `saveLine` / `removeLine` / `closeLineDw` — detail lines in the `.dw-*` drawer
- `onProjectPick` — project dropdown change; reloads the dependent task list and clears the task
- `onGlSearch` / `onSupSearch` — debounced searches that feed the GL and supplier dropdowns (both masters are too large to list in full: 9.4k combinations, 28.7k suppliers)
- `onSupplierPick` — fills supplier name and payee from the chosen Fusion supplier
- `projectOpts` / `taskOpts` / `etypeOpts` / `glOpts` / `supplierLov` — the dropdown option lists, each **re-injecting the stored value as its own option** when the master no longer carries it (a KO `options:` binding blanks a value absent from its list)
- `uploadDoc` / `viewDoc` / `removeDoc` — attachments on the shared `DCT_DOCUMENTS`
- `onCurrency` — defaults the exchange rate from the currency (AED forced to 1)
- `goBack` — returns to the register
- Computed gates mirror the SERVER's answer, they never re-decide it: `canEdit`, `canSubmit`,
  `canProcess`, `canLink`, `canUnlink`, `canCancel`, `canAttach`, plus `balanced` and `amountAedDisplay`

## API Endpoints (ORDS — `ap.rest`, base `/ords/admin/ap/`)

| Method | Path | Purpose |
|---|---|---|
| GET | `/ap/filters` | Facet LOVs + global header counts + min/max invoice date; **`businessUnits[]` counted LOV (v1.11.0)**; **`nopo=Y` scopes every LOV/count to direct invoices (v1.21.0)**; **`chapters[]` counted classification LOV (v1.22.0)** |
| GET | `/ap/summary` | KPIs + chart datasets for the current facets |
| GET | `/ap/invoices` | Paged header-level register `{items,total,totals,limit,offset}` |
| GET | `/ap/invoices/export` | CSV of the filtered header register (10k cap) |
| GET | `/ap/invoices/:id` | Invoice drill: header + `poRefs`/`prRefs` (distinct referenced docs `{num,id}`, v1.7.1 header deep-links) + lines + distributions |
| GET | `/ap/lines` | Paged line-level register (own-grain facets re-applied) |
| GET | `/ap/lines/export` | CSV (25k cap) |
| GET | `/ap/dists` | Paged distribution-level register (own-grain facets re-applied) |
| GET | `/ap/dists/export` | CSV (25k cap) |
| GET | `/ap/installments` | Paged installment-level register (payment schedule: due date, method, vendor bank account, pay group, paid/on-hold, gross/unpaid AED; own-grain bank/due facets re-applied) |
| GET | `/ap/installments/export` | CSV (25k cap) |
| GET | `/ap/cc` | GL combination lookup `?cc=<canonical cc_string>` → the 10 segment code+desc pairs from `dct_gl_coa_snap` (`found:'N'` when absent) — feeds the register combination popover (v1.12.0) |
| POST | `/ap/benef/dupcheck` | AI duplicate-beneficiary detection `?suppnum=` (default 26553) — `DCT_AP_AI_PKG.benef_dup_check` clusters the distinct beneficiary names with the FL-configured AI provider/model (FL AI_PROVIDER/AI_MODEL + `dct_ar_ai_providers`, Gemini→Claude fallback); prompt lines carry each name's vendor bank account(s) as same-identity evidence (conf < 0.4 groups dropped server-side); run PERSISTED to `DCT_AP_AI_DUP_RUN/_GROUP/_MEMBER` → `{analyzed, groupCount, provider, model, fellback, elapsedSecs, runId, ranAt, ranBy, groups:[{groupNo,canonical,confidence,reason,invoices,totalAed,members[incl. bankAccounts]}], sharedAccounts:[{bankAccount,vendorCount,invoices,totalAed,vendors[]}], sharedAccountCount, sharedShown}` — sharedAccounts = same account used by ≥2 different vendors, platform-wide (v1.13.0; bank-account round v1.15.0; persistence v1.16.0) |
| GET | `/ap/benef/dupcheck/last` | The same envelope rebuilt from the LATEST persisted run (`DCT_AP_AI_PKG.benef_dup_last`; groups from the tables, shared accounts recomputed live; no AI call) — `{"runId":null}` when no run was ever saved (v1.16.0) |
| GET | `/ap/benef/dupinvoices` | The invoices behind any AI-check count — `?bank=` (normalised account match, platform-wide, optional `&name=`), `?runid=&grp=` (a persisted AI group's member names) or `?name=` (effective vendor name; the name modes scope `&suppnum=`, default 26553) → `{items:[{invoiceId, invoiceNumber, invoiceDate, name, supplierNumber, site, businessUnit, amountAed, paymentStatus, invoiceStatus, bankAccounts}], count, totalAed}` (cap 500; `invoiceId` powers the Fusion deep link) (v1.16.0) |
| POST | `/ap/benef/dupreport` | Enqueue the Reporting-Platform definition `AP_BENEF_DUP_REGISTER` (reporting/db/33) as the calling user — body `{format:'PDF'\|'XLSX', suppnum?}` → `{runId, format}` (v1.16.0, AP/db/07) |
| GET | `/ap/benef/dupreport/:id` | Report run status → `{runId, status, rowCount, error, startedAt, finishedAt, hasFile, format}` (v1.16.0) |
| GET | `/ap/benef/dupreport/:id/file` | Authed download of the finished run's output (PDF book or 5-sheet Excel register) (v1.16.0) |
| POST | `/ap/direct/report` | Enqueue the Reporting-Platform definition `AP_DIRECT_REGISTER` (reporting/db/38) as the calling user — body `{format:'XLSX', bu?, supplier?, paid?, val?, chapter?, datefrom?, dateto?, search?, inclcxl?}` → `{runId, format}`; XLSX only, any other format = 400 (v1.21.0, AP/db/14; `chapter` v1.22.0) |
| GET | `/ap/direct/report/:id` | Direct AP Briefing Book run status → `{runId, status, rowCount, error, startedAt, finishedAt, hasFile, format}` (v1.21.0) |
| GET | `/ap/direct/report/:id/file` | Authed download of the finished run's 5-sheet Excel workbook (v1.21.0) |
| GET | `/ap/procash/` | Paged procash register `{items,total,totals}` — filters `status` (pipe any-of) `bu` `from` `to` `supplier` `linked` `mismatch` `mine` `search` (+ `limit offset sort`) (v1.19.0) |
| POST | `/ap/procash` | Create a header (+ optional `lines[]`) — **no trailing slash on the collection POST** |
| GET | `/ap/procash/:id` | Header + lines + documents + status history + validation `findings[]` + the caller's `canEdit`/`canProcess`/`canUnlink` |
| PUT | `/ap/procash/:id` | Partial update — the handler reads the stored row and overrides only the keys the body carries |
| DELETE | `/ap/procash/:id` | Remove a draft |
| POST | `/ap/procash/:id/submit` | Draft → Submitted, or → In Approval when `PROCASH_APPROVAL_MODE=WORKFLOW` |
| POST | `/ap/procash/:id/process` | Stamp processed by / on (needs `PROCASH_PROCESSOR`) |
| POST | `/ap/procash/:id/cancel` | Cancel |
| POST | `/ap/procash/:id/invoice` | Link the Fusion payable invoice (validated against the AP extract; sets the mismatch flag) |
| DELETE | `/ap/procash/:id/invoice` | Unlink it again (`PROCASH_ADMIN` only) |
| POST | `/ap/procash/:id/lines` | Add a detail line |
| PUT | `/ap/procash/:id/lines/:lineid` | Edit one |
| DELETE | `/ap/procash/:id/lines/:lineid` | Remove one (the rest renumber) |
| GET | `/ap/procash/:id/documents` | Attachments |
| POST | `/ap/procash/:id/documents` | Raw-binary upload (`:body`, name/type in the query, `MAX_UPLOAD_MB` → 413) |
| DELETE | `/ap/procash/:id/documents/:docid` | Deactivate an attachment |
| GET | `/ap/procash/:id/documents/:docid/file` | Authed download |
| GET | `/ap/procash/meta/lovs` | Statuses, coding bases, currencies, business units, attachment checklist + `approvalMode`/`canCreate`/`canProcess`/`isAdmin` |
| GET | `/ap/procash/meta/projects` · `/tasks` · `/etypes` | Coding dropdown sources (`?search=`; tasks need `?project=`) |
| GET | `/ap/procash/meta/gl` | GL combination dropdown — reads **`DCT_GL_COA_SNAP`** (9.4k real combinations). `DCT_GL_CODE_COMBINATIONS` is a 12-row demo master and must not be used |
| GET | `/ap/procash/meta/suppliers` | Fusion supplier pick list from `ATD_SUPPLIERS` (`?search=`, distinct supplier number, cap 200) — feeds the Payee dropdown |
| GET | `/ap/procash/meta/invoices` | Validated invoice pick from `AP_INVOICES_HEADER_V` (+ `alreadyLinked` flag) |
| GET | `/ap/procash/meta/export` | CSV of the filtered register (25k cap) |
| POST | `/ap/procash/meta/report` | Enqueue `PROCASH_REGISTER` (reporting/db/37) with the page filters — `{format:'PDF'\|'XLSX', status, bu, datefrom, dateto, search}` → `{runId, format}` (AP/db/12) |
| GET | `/ap/procash/meta/report/:runid` | Report run status |
| GET | `/ap/procash/meta/report/:runid/file` | Authed download of the finished book / register |


All protected by `dct_rest.validate_session`; facet params: `datefrom dateto supplier paid val acc inv itype curr paygroup paymethod sector dept cc project task etype account approp po pr req search glfrom glto rcvfrom rcvto esupplier aging suppnum bu inclcxl` (+ `limit offset sort`), multi-values pipe-delimited. `suppnum=` (multi, `supplier_number`; 2026-07-13 Beneficiaries round) scopes `filtered_ids` AND the `/filters` LOVs/counts — with it, the `suppliers` LOV lists the beneficiary-aware **effective** supplier names; register/drill rows at every level carry `supplierSite` (lines/dists via a header join) and the header CSV exports gained a `Site` column. **Platform rule (2026-07-14): EVERY surface that displays an AP-invoice vendor is beneficiary-aware** — the AP views embed the rule (AP/db/05 `benef_site` enrichment) and cross-module consumers join `DCT_AP_SUPPLIER_EFF_V` (`db/v2/51`): GL butil AP drill (GL/db/07), `DCT_UNPAID_INVOICES_V` (db/v2/39), `DCT_ACTUAL_V` AP branch (db/v2/32). `aging` = one bucket code (`CURRENT|D1_30|D31_60|D61_90|D91_180|D180P`); `esupplier` matches the beneficiary-aware effective supplier; `inclcxl=N` excludes cancelled invoices (frontend DEFAULT since v1.5.0; `/filters` also honours it for counts + LOVs). `appr=` filters by approval status (multi, display labels; v1.6.4). **`bu=` (v1.11.0, multi) filters by the invoice header's Business Unit** — the extract is CROSS-BU since 2026-07-18 (DCT / Museum Shared Services / Abrahamic Family House), the counted `businessUnits[]` LOV ships in `/filters`, and register/CSV rows at all 3 levels carry `businessUnit`. Received-date facets/trend use `COALESCE(invoice_received_date, created_date, invoice_date)`. **Item-only rule (2026-07-13):** all distribution-grain facets, dist-based LOVs and the bySector dataset consider `distribution_type='Item'` rows only, so facet counts reconcile with the KPIs/charts.

## Services / Data layer

| File | Role |
|---|---|
| `services/config.js` | `apiBase=/ords/admin/ap`, `authBase=/ords/admin/dct`, admin portal URL |
| `services/api.js` | re-export of `shared/api` (Bearer + 401 handling) |
| `services/authService.js` | shared-session reader (login/logout for dev standalone) |
| `services/apService.js` | `getFilters` / `getSummary` / `getRows(level)` / `getInvoice` / `getExportBlobUrl` / `getExportCsvText` |
| `services/procashService.js` | Procash CRUD + lifecycle + lines + documents + coding pick lists + invoice search + CSV/report (v1.19.0) |
| DB | `PROD.DCT_AP_PKG` (`in_list`, `filtered_ids`) — shared facet engine used by every handler |
| DB | `PROD.DCT_AP_PROCASH_PKG` — every validated procash write (status gates, role checks, coding rules, line-sum rule, invoice linking, bulk upsert, workflow hooks) |
| DB | `PROD.DCT_XL_PROCASH_PKG` — the Excel add-in layer over the same package (`db/v2/121`, routes in `db/v2/107`) |
