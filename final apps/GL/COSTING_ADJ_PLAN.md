# Projects Costing Adjustments — Plan (approved 2026-08-22)

Manual, auditable **signed cost adjustment lines** (± AED) on a budget line
(project / task / expenditure type), used to re-allocate actual cost that was
posted to the wrong project — mainly AP invoice distributions (which may or
may not carry project coding). Fusion/ATD data is never touched.

User-approved shape (rev 2 + follow-ups):
- ONE table `DCT_PA_COST_ADJ` — a row = one signed adjustment on one budget line.
- UI picks the source AP invoice distribution (optional; coding may be empty),
  the corrected project/task/etype, signed amount, **signed BUDGET_OVERRIDE**
  (adjusts the same line's budget), reason, classification, comments.
- Status DRAFT → APPROVED / REJECTED, manually approved for now.
- Butil: parameter **"Include Cost Adjustment" checked by default** — APPROVED
  rows fold into the figures (Actual +Σamount, Budget +Σoverride annual+YTD,
  Fund Available recomputed).
- Any butil row carrying an adjustment shows **(*)** prefixed in its FIRST
  cell + a note under the results table explaining the (*).

## Layers

### 1. DB — `db/v2/124_pa_cost_adj.sql` (PROD, run as prod_mcp)
- `PROD.DCT_PA_COST_ADJ`: adj_id IDENTITY PK, adj_ref `PCA-#####`
  (dct_pa_cost_adj_seq), budget_year, accounting_period MM-YYYY (NULL = whole
  year), source dist ref (invoice_id/number, invoice_line_number,
  dist_line_number, supplier_name) + orig_project/orig_task/orig_etype snapshot
  (all nullable), corrected project_number/task_number/expenditure_type (NOT
  NULL, no FKs — AP procash precedent), amount_aed signed NOT NULL,
  budget_override signed nullable, classification (lookup), reason NOT NULL,
  comments, status DRAFT default (lookup-first, no CHECK), action_note,
  created/updated/approved audit cols. Indexes on line key + status.
- `PROD.DCT_PA_COST_ADJ_BUTIL_V`: APPROVED rows aggregated to the butil key
  (budget_year × project × task × etype), **GL_CTX.BUTIL_END-aware** (procash
  view pattern; NULL period always counts): cost_adj_aed + budget_ovr_aed
  (windowed = YTD), budget_ovr_annual (all year), adj_count.
- Lookups `PA_COST_ADJ_CLASS` (REALLOCATION / CORRECTION / MISSED_COST /
  OTHER — Admin-editable) + `PA_COST_ADJ_STATUS` (DRAFT/APPROVED/REJECTED),
  count-then-insert (no MERGE — Linux SQLcl).
- Privilege `GL_MANAGE_COST_ADJ` seeded in DCT_PERMISSIONS (GL module).
- ADMIN synonyms for table + seq + view. Verification block.

### 2. ORDS — `final apps/GL/db/25_pa_cost_adj_ords.sql` (ADDITIVE on gl.rest)
Post-05 re-run list becomes **07..25**. AP `meta/*` third-segment scheme so
nothing collides with `costadj/:id`.
- `GET  costadj`            list w/ year/status/search filters (cap 2000)
- `POST costadj`            create DRAFT
- `PUT  costadj/:id`        edit (DRAFT only → else 400)
- `DELETE costadj/:id`      DRAFT by anyone w/ manage priv; any status = the
                            same gate (cleanup/correction; approval is manual)
- `POST costadj/:id/action` {action: APPROVE|REJECT, note} on DRAFT rows
- `GET  costadj/meta/dists` AP_INVOICE_DISTRIBUTIONS_V search (invoice # /
                            supplier / beneficiary contains, cap 50)
- `GET  costadj/meta/lookups` classification + status LOVs
Gates: reads `GL_VIEW_BUDGET_UTILIZATION` (NULL legacy = any session);
writes/approve `GL_MANAGE_COST_ADJ` w/ legacy SYS_ADMIN.

### 3. `/gl/butil` — `final apps/GL/db/21_butil_procash.sql` re-work (still the
sole live GET butil owner; 07 stays without it — run-order rule unchanged)
- New param `costadj` default **Y**; LEFT JOIN the new view beside procash.
- When on: rows + totals ship **budget/budgetAnnual/actualAp/fundAvailable
  ALREADY adjusted server-side** (so KPI band / CSV / negFund band follow with
  no client math); always ships raw components `costAdj`, `costAdjOvr`,
  `costAdjOvrAnnual`, `hasAdj` per row + `costAdj`/`costAdjCount`/
  `costAdjOvr`/`costAdjOvrAnnual` totals + `includeCostAdj` echo.
- negFund aggregate uses the effective fund (both flags).
- Books/registers/report bridges unchanged (published definition — same
  decision as procash).

### 4. UI — GL v1.78.0 (`GL/Jet/index.html` + `js/app.js` + `css/app.css`)
- NAV_GROUPS Projects += **Costing Adjustments** (`costadj`, after Pending).
- Page: filters (year/status/search) + New Adjustment; register on the SHARED
  `<interactive-report>` (`GL_PA_COST_ADJ`, section `cadj`); row click → drawer.
- Drawer (`.dw-drawer`): dist search picker (mini result list → select fills
  source ref + orig coding + defaults amount), corrected coding via the butil
  datalists (`bu-proj-dl`/`bu-task-dl`/`bu-et-dl`), signed Amount, signed
  Budget override, Classification, Reason (req), Comments; Save / Delete on
  DRAFT; **Approve / Reject** (confirm + optional note) for admins.
- Butil Search region: **Include Cost Adjustment** checkbox (default ON,
  procash toggle pattern; sends `costadj=N` when unchecked).
- Results table: `(*)` prefix in the first cell when `hasAdj==='Y'` + note
  under the table; encumbrances/pending/book-bridge param builders drop the
  new key (same as they drop procash).
- i18n EN+AR in STR; `.adj-star`/`.cadj-note` styles in app.css.

### 5. Tests
- `final apps/GL/tests/costadj_api_smoke.py` — CRUD + approve/reject lifecycle,
  gate checks, butil reflection Y/N + hasAdj, dist search, cleanup.
- `final apps/GL/tests/costadj_browser_smoke.py` — EN+AR: tab, create draft,
  approve, checkbox default-on, (*) + footnote, uncheck reverts figures.

### 6. Docs / wrap-up
deployment-notes + functions_list + STATUS + CLAUDE.md GL cell + memory;
APP_VERSION bump; webtier deploy = **GL-only overlay release**.
