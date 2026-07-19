# AP (App 212) — Deployment Notes

Platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md` §2 — read those first.

## Deploy checklist

1. **DB order** (SQLcl `sql -name prod_mcp`, each script CRLF + `SET DEFINE OFF` + `SET SQLBLANKLINES ON`):
   - `db/01_ap_module_seed.sql` — DCT_MODULES `AP` row (rerunnable).
   - `db/02_ap_pkg.sql` — `PROD.DCT_AP_PKG`. Verify both spec+body VALID.
   - `db/03_ap_ords.sql` — **fresh session**. Rebuilds `ap.rest` from scratch (DELETE_MODULE):
     **always re-run `04` right after any `03` re-run.** Verify 5 templates / 5 handlers.
   - `db/04_ap_level_ords.sql` — **fresh session**, additive lines/dists (+exports + cc lookup). Verify 10/10.
2. **Frontend**: bump `window.APP_VERSION` in `Jet/index.html`; if anything under
   `final apps/shared/` changed, bump ALL apps. Ship via `webtier/deploy_frontend.sh`.
3. **Smoke**: run `scratch` API suite (or curl `/ap/filters` + `/ap/summary?sector=Culture&paid=Unpaid`
   — the filtered summary must return in ~1–2 s, not minutes) and a browser pass
   (`Jet/dev-proxy.py <port>`; port 8080 may be taken on the dev VM — pass another port).

## App-specific gotchas (all hit during the 2026-07-12 build)

- **Never filter the AP views with `OR EXISTS` correlated subqueries.** The `AP_*_V` views
  sit over un-indexed ATD-loaded tables; a facet like `sector` turned into a 5+ minute
  query. `DCT_AP_PKG.filtered_ids` does ONE scan per used facet into an id collection and
  intersects with `MULTISET INTERSECT DISTINCT` — keep that pattern for any new facet.
- **A stuck long query pins DCT_AP_PKG** — `CREATE OR REPLACE PACKAGE BODY` then hangs on
  the library-cache pin until the query finishes (or its session is killed). If a package
  redeploy "hangs", check `v$session` for an active `/ap/…`-module session first.
- **No due-date column**: aging uses `TERMS_DATE` (100% populated) as the due-date proxy;
  bucket by `TRUNC(SYSDATE) - TRUNC(terms_date)`.
- **Aging must include negative balances** (`balance_due <> 0`, not `> 0`) — credit memos —
  otherwise Σ(aging buckets) ≠ Outstanding KPI and the dashboard looks broken.
- **No `AMOUNT_PAID_AED` column**: AED-normalise paid/balance with the per-invoice ratio
  `NVL(invoice_amount_aed / NULLIF(invoice_amount,0), 1)`.
- **Header `REQUESTER` is always NULL** — the Requestor facet uses `PR_PREPARER` from the
  distributions view. "Department" = `EXPENDITURE_ORGANIZATION` (lines view).
- Multi-value facet params travel **pipe-delimited** (`curr=USD|EUR`); `(None)` selects
  blank pay_group, `Unclassified` selects blank sector.
- Line/dist registers re-apply their own-grain facets directly to the rows (a sector
  filter shows only that sector's distributions, not all rows of matching invoices).

- **ATD_AP_* structural reload playbook** (hit 2026-07-13 when the OTBI analysis
  dropped `Attachment Flag` from `ATD_AP_INVOICES` and ALL three `AP_*_V` views +
  `DCT_AP_PKG` body + five GL-layer views went INVALID): run
  `prod.dct_views_rebuild(l_rebuilt, l_invalid)` (two OUT params) to fix the
  pass-throughs + GL layer, then `@05_ap_views.sql` (recreates the `AP_*_V`
  views — now the source of truth in the repo — and recompiles `dct_ap_pkg`),
  then `@03` + `@04`. Verify `all_objects WHERE status='INVALID'` is empty.

## Deployment history

- **2026-07-19 — AI duplicate-beneficiary detection (AP v1.13.0, NEW db/06).**
  Beneficiaries dashboard gains a **"Check duplicate using AI…"** header button:
  one call clusters all distinct beneficiary names (same person registered
  multiple times — spacing, capitalisation, Mohamed/Mohammed transliterations,
  swapped order, titles, typos) into likely-duplicate groups shown in a
  right-edge drawer (canonical name + confidence badge + reason + member rows
  w/ site, invoice count, total AED, first/last invoice; CSV export;
  verify-before-merging disclaimer). NEW `db/06_ap_ai_dupcheck.sql`:
  `PROD.DCT_AP_AI_PKG.benef_dup_check` — AI config is the FL module's
  (user requirement): provider registry `prod.dct_ar_ai_providers` + the
  FREELANCERS module settings AI_PROVIDER/AI_MODEL/AI_FALLBACK_CLAUDE, text-only
  DBMS_CLOUD call with 4-try backoff + GEMINI→ANTHROPIC fallback (mirrors
  DCT_FL_AI_PKG); prompt sends `id|name` lines, answer references ids only;
  additive `POST /ap/benef/dupcheck?suppnum=` (**re-run 06 after any 03**).
  Live-tested: 1,374 names → 135 groups in ~23 s on gemini-2.5-flash.
  GOTCHAS hit: ① `APEX_JSON.STRINGIFY` has no CLOB overload — a ~50 KB prompt
  needs a chunk-safe `json_escape_clob`; ② gemini-2.5-* burn THINKING tokens
  out of `maxOutputTokens` and truncate the JSON on big lists — set
  `thinkingConfig:{thinkingBudget:0}` (+60k budget); ③ `IS JSON` is a SQL-only
  condition — test via `SELECT … WHERE v IS JSON`; ④ CLOB responses must be
  HTP.prn'd in chunks; ⑤ `dct_rest.validate_session` RETURNS NULL rather than
  raising — every handler needs the explicit `IF l_user IS NULL THEN err(401)`
  guard (first deploy shipped without it = unauthenticated route; fixed same
  hour). Webtier release 20260719175106.

- **2026-07-19 — AP rebrand: plum → green (#8E3B5C → #14682F).** All fills/
  backgrounds and the chart palette move to the new brand green: `app.css`
  tokens (`--brand #14682F` / `--brand-rgb 20,104,47` / `--brand-dark #0F4E23`
  / `--brand-soft #E8F3EC` — every component styled off the vars follows for
  free), `dashboard.js` chart constants (`BRAND`/`BRAND_MID` + the 6-step aging
  ordinal RAMP rebuilt light→dark on the green hue: #9ECBAD → #0B3A1A; print
  report + drawers + tooltips inherit via BRAND), the shared shell module
  registry color (`shared/js/shell.js` — switcher dot + boot brand; shared
  change ⇒ all-apps APP_VERSION bump) and the `DCT_MODULES` row
  (icon_color/bg_color, seed `db/01` + live UPDATE in PROD). No AP
  `THEME_BRAND_COLOR` module-setting row exists, so the registry default is
  what boots. Semantic status colors (paid green / warn amber / error red) and
  the region-theme settings are unchanged. Webtier release 20260719171839.

- **2026-07-19 — Interactive-view deep-links + register COA popover (AP v1.12.0).**
  User-reported: in the Interactive view (shared `<interactive-report>`) at Line/Dist
  level the Invoice/PO/PR numbers were plain text and PO/PR rendered comma-grouped
  like ids (they were typed `num` in the IR envelope). Fixes: ① the SHARED IR
  component gained an optional envelope hook `cellLink(row, colKey) → href|null`
  (renders the cell as a new-tab `.ir-link` anchor, base columns only; cells now
  carry `data-key` for app-level delegated handlers; `.ir-link` style in
  platform.css) — AP's envelope passes an adapter over the existing
  `cellLink(row,col)` rule set, so the IR grid links Invoice # (row.id), PO
  (poHeaderId) and PR (prHeaderId) exactly like the standard table; ② PO/PR/
  receipt/voucher numbers dropped from `IR_NUM_KEYS` → typed text, no thousands
  grouping; ③ **GL Combination popover**: the 10-segment code+desc popover (same
  as the invoice window's Distributions tab) now shows on hover over the
  register's `glCombination`/`chargeAccount`/`poChargeAccount` cells in BOTH
  views (and the Beneficiaries dashboard — same VM): delegated
  `ccRegOver/Move/Out` on the register region + NEW additive `GET /ap/cc?cc=`
  (04 part 5 — one snap row by cc_string, `found:'N'` when absent), lazy-cached
  per combination. Shared change ⇒ APP_VERSION bumped in ALL 12 apps
  (AP 1.12.0). Deploy: 04 re-run (10/10 templates+handlers), webtier release
  20260719152633; sanity 50/50 register combinations resolve in the snap.

- **2026-07-18 — BU facet fix round (AP v1.11.1).** User screenshot: the Business-unit
  facet rendered three "(None)" rows — the `/filters` `businessUnits[]` LOV was emitted as
  `{v,c}` (the GL LOV shape) but the counted-facet renderer expects `{name,count}` like every
  other counted array; 03 re-run with the corrected shape (then 04 — 03 rebuilds ap.rest).
  Also per user: the group moved to the TOP of the facet rail (open by default) and
  **Department of Culture and Tourism is pre-selected on first load** — `loadFilters` checks
  the `^Department of Culture` item on the first fetch only and the initial summary/register
  load now runs AFTER filters resolve, so the page opens DCT-scoped (5,321 invoices,
  cancelled excluded) with a clearable chip; re-fetches keep user selections as before.
  Applies to BOTH dashboards (the beneficiary scope spans all 3 BUs too). Browser check 9/9.
  APP_VERSION 1.11.1.

- **2026-07-18 — Business Unit facet + CROSS-BU data (AP v1.11.0).** The user added *Business
  Unit Name* to the AP Invoices OTBI analyses and the extract now loads **cross-BU** data:
  DCT 5,757 + Museum Shared Services 2,166 + Abrahamic Family House 232 invoices (was 5,456
  DCT-only — every AP figure platform-wide grew accordingly, by design). Wiring: `ATD_AP_INVOICES.
  BUSINESS_UNIT_NAME` → all 3 `AP_*_V` views gain `BUSINESS_UNIT` (05), `DCT_AP_PKG.filtered_ids`
  gains `p_bu` (multi, header grain; 02), every handler passes `bu=` + `/filters` ships a counted
  `businessUnits[]` LOV (03+04), registers/CSVs at all 3 levels carry the column. **Deploy gotcha:
  the new extract column requires `prod.dct_views_rebuild` BEFORE 05** (the `prod.ap_invoices`
  pass-through predates the column; without the rebuild 05 compiles INVALID with ORA-00904).
  Frontend: **Business unit** counted facet group (both dashboards incl. Beneficiaries), visible
  `businessUnit` register column (hidden at line/dist levels). API verified: all=8,155 / MSS=2,166 /
  MSS register rows all-MSS; browser spot-check PASS.

- **2026-07-12** — Initial deploy: 01→04 to PROD; `ap.rest` 9 routes live; API smoke 14/14;
  browser smoke 23/23; platform registration (shell + i18n + all-apps APP_VERSION bump).
  Web-tier release `20260712231423` shipped same day (whole fleet; AP live at /AP/Jet/).
- **2026-07-12 (round 2)** — `db/04` re-run: dists register/export now join `po_lines`
  (order_number/line) → `po_distributions` (schedule/distribution_number) for the
  PO-sourced charge account; `glCombination` = `dct_cc_canon(COALESCE(po, ap))`
  (the PO extract stores charge accounts in the FLIPPED segment order — canon fixes it),
  `chargeSource` PO/AP + full invoice-detail columns. Coverage: 9,910 PO-matched dists,
  4,430 with a loaded PO dist row, 0 canonical mismatches. Frontend 1.1.0: full-width
  dashboard (`page-wrap--full`), ONE metadata-driven register table (all levels),
  per-user column chooser saved to `/dct/prefs` key `ap.dash.cols` + localStorage.
  Browser smoke 30/30. Web-tier redeployed.
- **2026-07-12 (round 3)** — Interactive view on the register: shared `<interactive-report>`
  component embedded (rename cols / calculated cols / aggregates / breaks / highlights;
  `layoutsApi: null` = localStorage layouts only — the server-layout endpoints are BI-gated).
  Register endpoint caps raised 500 → 10000 for the one-shot IR fetch (03 + 04 re-run;
  remember 03 rebuilds ap.rest → always re-run 04 after it). The envelope must carry
  `section` — the component scopes its autosave key from env.section, not the param.
  APP_VERSION 1.2.0; browser smoke 37/37.
- **2026-07-13** — `Attachment Flag` removed from the OTBI analysis / `ATD_AP_INVOICES`.
  Recovery per the playbook above; NEW `db/05_ap_views.sql` captures the three view
  definitions (minus `has_attachment`); drill handler no longer selects/returns it
  (03+04 re-run); `dr.attachment` i18n keys dropped. Zero INVALID in PROD, API smoke
  14/14, GL butil verified. APP_VERSION 1.2.1.
- **2026-07-13 (beneficiary round, v1.3.0)** — supplier `BENEFICIARY` is a generic Fusion
  supplier record (2,723 of 5,456 invoices; the real payee is in header `BENEFICIARY_NAME`,
  populated on 2,295 of them and ONLY on BENEFICIARY rows). All three register levels,
  their CSV exports, the top-suppliers chart, the suppliers KPI and the supplier sort now
  use the **effective supplier** (`CASE WHEN supplier_name='BENEFICIARY' AND beneficiary_name
  IS NOT NULL THEN beneficiary_name ELSE supplier_name END`) + a new **Is Beneficiary Y/N**
  column everywhere (visible by default at header level, in the chooser at line/dist).
  Free-text `search=` now also matches `beneficiary_name` (db/02). Lines + dists views
  gained `BENEFICIARY_NAME` (db/05 — the header attr joined via `ap_invoices`). The drill
  keeps the RAW supplier + beneficiary + flag (detail view). Deploy order was 05 → 02 →
  03 → 04. The supplier FACET still lists the generic `BENEFICIARY` value (filtering is
  by real supplier record); find a payee via free-text search.
- **2026-07-13 (canonical GL combination)** — platform rule (user-confirmed same day):
  every combination string uses the canonical **Fusion** order
  `entity.program.cc.bg.account.es.appr.ic.f1.f2`. AP was already
  canonical (`glCombination`/`chargeAccount` via `dct_cc_canon`/COA snap); the raw
  `poChargeAccount` (register + CSV) is now wrapped in `dct_cc_canon` too (db/04).
  NOTE: `db/v2/43` (old AP view DDL) RETIRED — `AP/db/05_ap_views.sql` is the only source.
- **2026-07-13 (dashboard enhancements round 4, v1.4.0)** — six-part UX/analytics round:
  1. **Include Cancelled Invoices?** checkbox in Search Filters (default ON = previous
     behaviour; OFF sends `inclcxl=N` → engine excludes `invoice_status='Cancelled'`).
  2. **GL Date from/to** filter (`glfrom`/`glto` on header `gl_date`).
  3. **Monthly trend re-based**: month basis is now `NVL(invoice_received_date,
     invoice_date)` (was `invoice_date`; 5,207 of 5,484 headers carry a received date)
     and the default window starts at the **current budget year** (Jan 1) — any explicit
     date facet (invoice/GL/received) restores the full filtered range (cap 60 months).
  4. **Chart drill-down on ALL 8 charts** — GL Budget-Utilization-style right-edge
     drawer (`.dw-*` in app.css): click any bar/slice/point → related invoice list
     (current facets + the clicked segment), wide default + ⤢ full-screen (Esc restores,
     then closes), CSV export w/ reconciliation footer, "top N of M" cap note (500),
     row click opens the invoice-detail modal ABOVE the drawer. New engine facets:
     `aging=<CURRENT|D1_30|D31_60|D61_90|D91_180|D180P>`, `esupplier=` (effective,
     beneficiary-aware — the top-suppliers bars), `rcvfrom/rcvto` (trend months),
     plus `glfrom/glto/inclcxl` (7 new `filtered_ids` params, 31 args total).
  5. **Maximize fixed**: `.ap-region { position:relative }` was declared AFTER
     `.ap-region--max { position:fixed }` at equal specificity, so the fixed positioning
     silently lost and the ⤢ button looked dead. Rules merged; region-max z lowered
     900 → 750 so drawers (760/761) and the platform modal (800) layer above it.
  6. **Chart hints**: ⓘ icon on every chart title (native tooltip, EN+AR) explaining
     content, date basis and criteria.
  **Item-only rule (reconciliation fix, user-reported)**: every distribution-grain
  analysis now counts **`distribution_type = 'Item'` rows only** — tax/freight dists
  carry unmapped cost centers and dragged classified invoices into sector
  'Unclassified' (facet said 4,887; Item-only truth = 78). Applied to all 10 dist
  facet scans in `dct_ap_pkg.filtered_ids`, the `/filters` dist-based LOVs + sector
  counts, and the `/summary` bySector dataset, so facet counts == KPIs == charts.
  The dist-level REGISTER still lists all dist rows of matching invoices (a register,
  not an analysis). Deploy order 02 → 03 → 04 (03 rebuilds ap.rest — 04 right after).
  DB verify: 31 pkg args, 7 handlers w/ new binds, item-only present in filters+summary;
  7/7 SQL reconciliation tests PASS (cxl 5484−406=5078; Unclassified 78=78; aging D1_30
  428=428; GL-date 1383=1383; rcv-month 1112=1112; esupplier 457=457). APP_VERSION 1.4.0.
- **2026-07-13 (round 4b + invoice window, v1.5.0)** — follow-ups to round 4:
  1. **Include Cancelled Invoices? now defaults to UNCHECKED** (cancelled excluded
     everywhere by default; ticking it shows a "Yes" chip). The **/filters facet
     counts + LOVs follow the checkbox** — every count/LOV query in the filters
     handler takes the `inclcxl` bind (`NULL/'Y'` = include for API back-compat;
     the frontend always sends it and re-fetches `/filters` on toggle, preserving
     the user's selections and open groups).
  2. **Received-date fallback = invoice CREATION date** (was invoice date):
     `COALESCE(invoice_received_date, created_date, invoice_date)` in the pkg
     rcv facets + the /summary trend (all 277 received-date-less headers have a
     created_date; 0 fall through to invoice_date).
  3. **Invoice window redesigned** (/senior-frontend + /frontend-design):
     document-style **master region** (big invoice number + effective supplier +
     type/beneficiary chips + grouped sections Supplier & references / Payment /
     Dates & audit) with a **Summary card top-right** (hero AED amount, FX line
     when non-AED, Paid/Balance/Tax rows, status badge stack, cancelled ribbon)
     and a **detail region with 2 tabs (Lines, Distributions)** — the old Header
     tab dissolved into the master region; **⤢ maximize** turns the window
     full-screen (`.inv-max`; Esc restores first, second Esc closes).
  Deploy 02 → 03 → 04; verify: filters/summary carry the new logic; SQL smoke —
  rcv-month 2026-05 engine 1,140 = direct 1,140 (moved from 1,112 under the old
  fallback), exclude-cancelled 5,078 = 5,078. APP_VERSION 1.5.0.
- **2026-07-13 (invoice window round 2, v1.6.0)** — user-review refinements:
  1. **Summary card fills the master-region height** (align-self stretch + flex column;
     the status stack anchors to the card foot). **Approval status: DATA GAP** — neither
     `AP_INVOICES` nor `ATD_AP_INVOICES` carries an approval-status column (checked
     `%APPR%/%WORKFLOW%` across all AP tables); the OTBI analysis must add Fusion's
     "Approval Status" field before it can be surfaced (then: view 05 + drill handler + card row).
  2. **Audit info collapsible** (collapsed by default) in the master region: created
     by/on + last updated by/on (drill handler now emits `lastUpdatedBy/lastUpdatedDate`)
     + cancelled by/on when present; the Dates section keeps invoice/GL/received dates only.
  3. **Distributions tab: full GL combination column** + GL-Actuals-style hover popover —
     the drill handler LEFT JOINs `dct_gl_coa_snap` on the (already canonical)
     `charge_account` and emits all 10 segment codes+descs; the popover lists them in the
     canonical Fusion order with descriptions (`.combo-tip`, z 950 above the modal; header
     ⓘ hint on the column). Snap join coverage 5,024/5,041 Item dists.
  Deploy: 03 → 04 re-run (02 untouched). APP_VERSION 1.6.0.
- **2026-07-13 (approval status, v1.6.1)** — user added `APPROVAL_STATUS` to
  `ATD_AP_INVOICES` via the OTBI analysis (data gap from the invoice-window round
  closed). Recovery-playbook flow: `prod.dct_views_rebuild` (15 pass-throughs,
  0 invalid — `ap_invoices` picks up the column) → 05 re-run (header view maps
  Fusion codes to display labels: WFAPPROVED→'Workflow Approved', else INITCAP;
  4,480 Workflow Approved / 496 Required / 407 Not Required / 79 Initiated /
  14 Rejected / 10 Stopped) → 03 → 04. Drill handler emits `approvalStatus`;
  the invoice-window Summary card gained the Approval badge row (`apprBadge`:
  approved=green, Rejected/Stopped=red, Not Required=idle, else amber).
  Facet/register column for approval status NOT added yet (only the Summary was
  requested). APP_VERSION 1.6.1.
- **2026-07-13 (UI polish, v1.6.2, frontend-only)** — Summary-card statuses show a
  glyph instead of the badge dot (✓ success / ✕ danger / ! warn / – idle; scoped
  `.inv-badges .badge::before` overrides the platform 5px dot). Audit-info chevron
  moved next to the label, brand-colored, larger (was far-right, barely visible).
  ALSO fixed a latent gap: `badge--success/--warn/--danger` were emitted by the VM
  helpers but never defined in ANY stylesheet (status pills rendered colorless
  platform-app-wide) — now defined in AP app.css with the platform soft palette,
  colouring the register/drawer/window badges everywhere. APP_VERSION 1.6.2.
- **2026-07-13 (sector reconciliation, v1.6.3)** — two corrections after user review:
  1. **Item-only rule was WRONG → non-tax rule.** PO-matched Item lines produce
     `Accrual` (+ Conversion rate variance / Retainage / Tax rate variance)
     distributions, NOT `Item` — 1,801 invoices had vanished from every dist-grain
     facet. All 10 pkg facet scans, the /filters dist LOVs and bySector now use
     `distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax')` (= exactly
     the distributions of Item lines; tax rows stay excluded). Dist-grain coverage
     3,381 → 5,390 of 5,486 invoices.
  2. **Sector became a per-invoice CLASSIFICATION facet** (user: "for invoices that
     span more than one sector, show it as separate"): each invoice lands in exactly
     one bucket — its single sector, `(Multiple sectors)` (88), or `Unclassified`
     (93, incl. invoices with no distributions) — so the facet counts now SUM TO the
     invoices KPI (5,080 non-cancelled). Applied in lock-step to the pkg `p_sector`
     match (header LEFT JOIN + per-invoice bucket), /filters counts, the bySector
     chart dataset (amount = invoice's non-tax distributed AED), and the dists
     register/export sector predicate (a `(Multiple sectors)` selection passes its
     invoices' rows through). Deploy 02 → 03 → 04; combined facet query ~0.3s.
  Frontend: bySector ⓘ hint rewritten (EN/AR). APP_VERSION 1.6.3.
- **2026-07-13 (approval facet, v1.6.4)** — Approval Status added as a search
  criterion: `p_appr` facet in `filtered_ids` (multi, header `approval_status`
  display labels) + `appr=` bind in all 7 facet handlers; `/filters` gains the
  `approvalStatus` counted list (inclcxl-aware, placed after Accounting status);
  header register + CSV export gained the `approvalStatus` column (hidden by
  default, `appr` badge). Verified: facet Workflow Approved 4,480 = direct;
  multi-value `Rejected|Stopped` = 23. Deploy 02 → 03 → 04. APP_VERSION 1.6.4.
- **2026-07-13 (Fusion deep-links, v1.6.5, frontend-only)** — invoice numbers are
  links to Oracle Fusion (`fscmUI/faces/deeplink?objType=AP_VIEWINVOICE&action=VIEW
  &objKey=InvoiceId=<invoice_id>`; base URL in `config.js` `fusionInvoiceUrl`),
  opening in a NEW TAB (`target=_blank rel=noopener`; ↗ affordance). Applied in the
  AP Register (all 3 levels via the generic invoiceNumber cell — the anchor uses
  `click: return true` + `clickBubble: false` so the row-drill doesn't fire), the
  chart drill-drawer table, and the invoice window's big header number.
  APP_VERSION 1.6.5.
- **2026-07-13 (PO/PR deep-links + shared fusionLinks, v1.7.0)** — deep-link
  builders promoted to `shared/js/fusionLinks.js` (invoice / purchaseOrder /
  requisition / generic `link()`; contract in SHARED_JET_ARCHITECTURE.md —
  shared change ⇒ APP_VERSION bumped in ALL 11 apps). PR/PO numbers link to
  Fusion (PURCHASE_REQUISITION_LOBUSER / PURCHASE_ORDER deeplinks) wherever a
  single number shows: register line+dist levels, invoice-window Lines/Dists
  tabs (header-level PO/PR are comma-separated LISTAGGs — not linked). The
  deeplinks need the FUSION ids, so `AP/db/05` lines view gained `PO_HEADER_ID`
  and the dists view `PO_HEADER_ID`+`PR_HEADER_ID` (from `po_headers.po_header_id`
  / `pr_headers.pr_header_id`, 100%% populated) and 03 drill + 04 lines/dists emit
  `poHeaderId`/`prHeaderId`. Frontend: generic `cellLink(row,col)` drives the
  register/drawer anchors (invoice/PO/PR in one place); `config.fusionInvoiceUrl`
  retired. Deploy 05 → 03 → 04. APP_VERSION 1.7.0.
- **2026-07-13 (invoice-header PO/PR deep-links, v1.7.1)** — the invoice window's
  Supplier & References PO/PR fields (header level) are now links too: the 03
  drill handler emits `poRefs`/`prRefs` arrays of distinct `{num, id}` referenced
  documents (POs = UNION of lines+dists grouped by number, PRs from dists;
  `MAX(header_id)` per number), and the master region renders each number as a
  Fusion anchor (`foreach` over the refs, falls back to the plain LISTAGG string
  when a ref has no id). `openDrill` hoists `d.poRefs/prRefs` onto `d.header`
  because the region binds `with: header`. `.inv-reflist` wraps multi-document
  lists. Deploy 03 → 04 (03 rebuilds ap.rest). APP_VERSION 1.7.1, release
  20260713230157.
- **2026-07-13 (Beneficiaries dashboard, v1.8.0)** — NEW nav page `beneficiaries`:
  the full AP dashboard locked to the generic BENEFICIARY supplier (supplier
  number 26553), where the beneficiary name acts as the supplier name and the
  supplier SITE number as the beneficiary's supplier number. DB: `db/02` adds
  `p_suppnum` (multi, `supplier_number`) to `filtered_ids`; `db/03` threads
  `suppnum=` through /filters (every LOV/count scoped; the suppliers LOV lists
  EFFECTIVE supplier names under suppnum), /summary, /invoices (+`supplierSite`
  in rows + `Site` CSV column); `db/04` same for lines/dists (+exports) with a
  `supplierSite` header join. Frontend: `viewModels/beneficiaries.js` mounts the
  SAME `dashboard.html` via a nested `module` binding with
  `DashboardViewModel({benef:true, suppnum:'26553'})` — benef mode relabels
  Supplier→Beneficiary (register/facet/KPI/top chart/print, `ben.*` i18n EN+AR),
  swaps the Is-Beneficiary column for a visible Supplier No (site) column at all
  3 levels + drill drawer, maps the supplier facet to `esupplier=`, keeps its
  own column prefs (`ap.benef.cols`) and IR code (`AP_BENEF_REGISTER`), and
  prefixes exports `ap-beneficiaries-*`. Standard dashboard also gained a
  hidden-by-default *Supplier site* column. GOTCHA: `renderCharts` has a local
  `var tr = d.trend` — a constructor-level helper named `tr` gets shadowed there
  (was "tr is not a function"); the label-override helper is named `lt`.
  Deploy 02 → 03 → 04 (fresh sessions). Tests: `tests/benef_api_smoke.py` 18/18,
  `tests/api_smoke.py` regression 14/14, `tests/benef_browser_smoke.py` 24/24
  (scoped KPIs 2,604 invoices / 1,064 beneficiaries vs 5,080 unscoped).
  APP_VERSION 1.8.0. Web-tier release 20260713233720 LIVE 2026-07-13 (prod smoke: index 1.8.0, beneficiaries files 200, ORDS proxy 401 w/o token); pushed as c9a6170.
- **2026-07-13 (beneficiary-name enrichment, DB-only)** — user caught generic
  "BENEFICIARY" names still showing on the Beneficiaries dashboard: 429/2,727
  invoices of supplier 26553 arrive from Fusion with NULL `beneficiary_name`.
  Fix in `db/05_ap_views.sql`: all three `AP_*_V` views now derive the name
  from a `benef_site` map (per supplier_number+site `MAX(beneficiary_name)`
  where recorded — the site uniquely identifies the person) via
  `COALESCE(i.beneficiary_name, bs.beneficiary_name)`. One view-level fix
  covers the facet engine, /filters LOVs, registers, exports, charts and the
  drill with ZERO handler changes (no 03/04 re-run — handler source untouched;
  pkg recompiled by 05). Generic rows 429 → 4 (2 sites whose name was never
  recorded on any invoice). benef API smoke 18/18 + regression 14/14. No
  frontend change / no web-tier deploy needed.
- **2026-07-14 (beneficiary name PLATFORM-WIDE, DB-only)** — user caught the generic
  BENEFICIARY vendor on the GL Budget-Utilization AP drill. Full sweep of every
  surface that displays an AP-invoice vendor: NEW `db/v2/51_ap_supplier_eff.sql`
  `DCT_AP_SUPPLIER_EFF_V` (invoice_id → beneficiary-aware effective supplier w/
  same-site fallback) now joined by the GL butil AP drill (`GL/db/07` re-run),
  `DCT_UNPAID_INVOICES_V` (`db/v2/39` re-run → BUDGET_UTIL_SECTOR report) and
  `DCT_ACTUAL_V`'s AP branch (`db/v2/32`, surgical single-view redeploy). BI
  definitions scanned — only BUDGET_UTIL_SECTOR touches supplier (covered via 39).
  PO/GRN/PR surfaces show real suppliers (beneficiary payments are AP-direct).
  Live-verified: the reported invoice DCT2026MARSUP002 now returns
  "UAE AL WATHBA STABLES FSTVL BGT AC" from /gl/butil/lines?metric=ap.
- **2026-07-14 (rich chart/region hints, v1.9.0)** — the plain title-attr tooltips
  on the 8 chart ⓘ icons became a styled popover (`.ap-tip`: brand header +
  description + LIVE figures for the current filters), and the Analytics +
  Register region headings gained ⓘ hints too. Per-chart stats: aging
  (outstanding/overdue/unpaid count/largest bucket), payment (per-status
  count·amount + paid share), trend (months/total/peak/latest), validation +
  accounting (statuses/largest/share), top suppliers (count/#1/top-10 share),
  sector (buckets/#1/unclassified), pay group (groups/#1+share); regions show
  KPIs/level/rows/active-filter count. Benef mode reuses everything with its
  own labels + scope wording (`rg.*.hint`→`ben.*.hint` via LBL). 41 new i18n
  keys EN+AR. Playwright hint test 15/15 + browser smoke 24/24 on BOTH
  dashboards. APP_VERSION 1.9.0.
- **2026-07-14 (aging re-base + branded chart tooltips, v1.10.0)** — user-confirmed
  aging basis change: **due date = invoice received date (fallback created →
  invoice date) + payment-terms credit days** (`DCT_AP_PKG.terms_days` parses the
  first number in the terms name: Immediate→0, Net 30→30; the data has only those
  two values). NEW `DUE_DATE` column on `AP_INVOICES_HEADER_V` (05) is THE single
  source — the aging chart/facet (02), Overdue KPI, daysPastDue, register+CSV
  `Due Date` column and the invoice-window Payment section (03) all derive from
  it; terms_date remains displayed but is no longer the aging basis. Deploy
  02→05→03→04 (pkg body transiently INVALID between 02 and 05 — 05's COMPILE
  BODY fixes it). Validated: due_date exact for all 5,486 rows, aging buckets
  Σ == Outstanding KPI. Frontend: Chart.js data tooltips (hovering bars/slices/
  points) restyled to a branded white card via `tipOpts()` — title + labeled
  rows (Amount (AED) / Invoices / Share of total) + italic "Click to list the
  invoices" footer, on all 8 charts, both dashboards; hint-popover rows no
  longer join count·amount with an interpunct (user-reported unreadable) —
  counts sit in the label ("Paid (2,514 Invoices)"), amounts stay plain
  99,999,999.99. APP_VERSION 1.10.0; smokes 18/18 + 14/14 + browser 5/5.
