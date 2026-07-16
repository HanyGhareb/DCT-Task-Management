# General Ledger (App 210) — STATUS

Date-tracked Chart-of-Accounts classification layer (Sector / Chapter / DCT Program)
over the Fusion-loaded `ATD_GL_*` tables + a Portal-style management UI.

| Layer | State |
|---|---|
| DB tables (`DCT_GL_CLASS_TYPE/_VALUE/_SEG_CLASS_MAP`) | ✅ Deployed PROD (2026-06-28) — all VALID; +`alt_name1/2/3` |
| Bridge synonyms (`GL_SRC_*`) | ✅ Deployed — insulate the planned `ATD_GL_* → GL_*` rename |
| Package `DCT_GL_CLASS_PKG` + context `GL_CTX` | ✅ Deployed — norm / set_asof / resolve_value_id / validate_map |
| Views `DCT_GL_COA_V` (+`GL_COA_V`) / `DCT_GL_BALANCES_V` | ✅ Deployed — COA view = 9,338 rows (no fan-out), 8,485 (91%) have a Sector |
| Seed | ✅ 21 Sectors / 7 Chapters / 41 PBB Programs; 109 sector + 74 chapter + 33 program mappings |
| ORDS `gl.rest` (`/ords/admin/gl/`) | ✅ Deployed — route groups incl. actuals/dashboard/refresh; auth + overlap-guard + as-of verified |
| Actuals reporting (`db/v2/32–36`) | ✅ Deployed — `DCT_ACTUAL_V` / `DCT_BUDGET_ACTUAL_V` / `DCT_BUDGET_ACTUAL_PERIOD_V` (3-figure Commitment from **`DCT_PR_COMMITMENT_PERIOD_V`** [db/v2/36 over `ATD_PR_*`] + 3-figure PO buckets w/ **GRN-netted Open Obligation** + `open_encumbrance_ytd` + `funds_available_calc_ytd`; **AP Direct = `po_number IS NULL`**) + indexed `DCT_GL_COA_SNAP` + hourly `DCT_ACTUALS_REFRESH_JOB` |
| Frontend (Portal-style KO SPA, `Jet/`) | ✅ Live — Overview / Actuals (full-width; **grouped Commitment/Obligation cells** [Total/Open/Pipeline] + Open Encumbrance + Funds Available GL/Calc + SLA Actual; real PR/PO drills; filters + ⓘ hints) / Dashboard / Classifications / Mapping / Explorer; EN-AR-RTL; E2E + mock-render passed |
| Registration | ✅ shell switcher + common i18n + proxies (auto-derived) + CLAUDE.md Module Status |
| APEX pages | ⬜ N/A (JET only) |

## Deployment log
- **2026-07-16** — **Pending Approval review round** (`APP_VERSION` 1.28.0). Book: reserved
  non-zero lines only, full text (no truncation), +Sector/Cost centre/Appropriation (code+name)
  in registers + oldest-20, Cur/Funds dropped (reporting/db/23 v2, E2E run 82 = 1,385 lines).
  Page: Source (PR/PO) + "Showing figures in" filters, KPI band redesigned w/ semantic accents +
  heat badges (senior-frontend pass), Document # cells deep-link to Fusion (view db/v2/52 +
  GL/db/13 add fusion_header_id/source=). Browser smoke 29/29 — webtier release 20260716050503.
- **2026-07-16** — **Encumbrances – Pending Approval page + ENC_PENDING_BOOK briefing book**
  (`APP_VERSION` 1.27.0). New nav tab: every PR/PO document PENDING APPROVAL in Fusion (daily BIP
  snapshot `atd_pr_po_pending_approval`, otbi-atd/db/47) joined to the open-encumbrance line detail —
  view `DCT_PR_PO_PENDING_V` (db/v2/52, BUTIL_END-aware, `in_extract` coverage leg), ORDS `GL/db/13`
  (`GET /gl/pending` register + server-side KPIs/aging/approvers/unmatched in one scan; book bridge
  `POST /gl/pending/book` + status + pdf). Page reuses the butil filter bar + shared
  `<interactive-report>` (section `pend`), 4 composite KPI tiles + aging/top-approver mini tables +
  extract-coverage note + Briefing Book button. Reporting: `ENC_PENDING_BOOK` (reporting/db/23,
  MULTI/PYTHON, 9 sections; template `enc_pending_book.html.j2` DB-stored) — E2E 67-page PDF
  reconciles to the page. API smoke 20/20 + browser smoke 21/21 EN/AR — webtier release
  20260716025748. **GL post-05 re-run list now = 07+08+09+10+11+12+13.**
- **2026-07-02** — **Budget Utilization: KPI-card aggregate drill-down** (`APP_VERSION` 1.8.0). The four
  KPI cards (Actual AP/GRN/Commitment PR/Obligation PO) are now clickable → all supporting lines across
  the current filters, in the same drawer (adds Project/Task cols + "top N of M" note). `/gl/butil/lines`
  extended: `year+metric` with `project[+task+etype]` (row) OR `projecttype/sector/search` (aggregate),
  one `kys` CTE + window totals; PO/PR header/line joins de-duped (fixed aggregate PO fan-out). DEPLOYED
  as ADMIN; live totals reconcile row + aggregate; drawer Playwright-verified.
- **2026-07-02** — **Budget Utilization: per-figure drill-down** (`APP_VERSION` 1.7.0). The four money
  cells (Actual AP / Actual GRN / Commitment PR / Obligation PO) on each Budget Utilization row are
  clickable → supporting transaction lines in a **right-edge slide-in drawer** (`.dw-*`, mirrors the
  platform edit-drawer). Additive ORDS `GET /gl/butil/lines?year=&project=&task=&etype=&metric=`
  (`ap|grn|pr|po`) in `db/07` — totals reconcile to the row figure (verified against live 2026 data).
  **Deploy `db/07` as ADMIN in a fresh session** (ORDS is ADMIN-owned).
  Real requisitions (`ATD_PR_*`, `db/v2/36` `DCT_PR_COMMITMENT_PERIOD_V`) drive Commitment
  (Total=Reserved+Liquidated / Open=Reserved / Pipeline=Not-reserved). PO split into Total (ex
  Failed/Passed) / Open (Reserved+Partial **GRN-netted**) / Pipeline (Failed/Passed), de-duped by
  `po_distribution_id`. `db/v2/34` rewritten (+`open_encumbrance_ytd`, +`funds_available_calc_ytd`).
  ORDS `/actuals` new figures + PR/PO/pipeline drills (`prod.`-qualified, no new synonyms). Frontend =
  **grouped cells** (Total/Open/Pipeline) + Funds GL/Calc + 14 KPI cards. Deploy: `db/v2/36` →
  `db/v2/34` → `05_gl_ords.sql`. Verified live SQL + drills + node --check + mock-render (0 err).
  Currency caveat: PR AED via `DCT_CURRENCY_CODES` snapshot (only rate source).
- **2026-07-01** — **Actuals: AP Direct redefine + SLA Actual + PO/PR counts** (`APP_VERSION` 1.4.0).
  #1 **AP Direct** = AP lines with `po_number IS NULL` (true direct AP; drops `ap_po_match`); 06-2026
  1.322B → 1.292B. #2 **SLA Actual** = GRN + AP Direct (≈2.27B) — KPI card + column. #5 **po_count/
  pr_count** per combination → Obligation/Commitment cells show amount + "N POs"/"N PRs" sub-line.
  `db/v2/34` + `05_gl_ords.sql`. Verified live SQL + drill query + `node --check` + mock-render (0 err).
  **Pending (Batch B, user's PR_HEADER/PR_LINES/PR_DISTRIBUTIONS tables):** #3 Open Commitment from
  real PR source, #4 Encumbrance = Open PR + Open PO, #6 second Funds Available figure.
- **2026-06-30** — **Actuals: Open Commitment / Open Obligation + visible ⓘ hint** (`APP_VERSION` 1.3.0).
  Added `open_commitment_ytd` + `open_obligation_ytd` (the unliquidated subset =
  `FUNDS_STATUS IN ('Reserved','Partially Liquidated')`, de-duped) to `DCT_BUDGET_ACTUAL_PERIOD_V`
  (`db/v2/34`, live from `po_distributions`); ORDS `/actuals` (+openCommitment/openObligation in
  totals+items + as `source` values), `/actuals/lines` (+openCommitment→open PR lines, +openObligation
  →open PO lines). Frontend: 2 KPI cards + 2 drillable columns + visible ⓘ hint markers on the four
  PO-derived headers (wording kept) + 2 source-filter options + CSV. 06-2026 open = 723.08M (both).
  Verified live SQL + handler harness + `node --check` + Playwright mock-render (0 errors).
- **2026-06-30** — **Actuals: Commitment/Obligation + filters + full width** (`APP_VERSION` 1.2.0).
  Added `commitment_ytd` (PR-backed) + `obligation_ytd` (all PO) to `DCT_BUDGET_ACTUAL_PERIOD_V`
  (`db/v2/34`, read live from `po_distributions`); ORDS `/actuals/filters` (+accounts/costCenters),
  `/actuals` (+account/costcenter/source filters, +commitment/obligation), `/actuals/lines`
  (+commitment→PR lines, +obligation→PO lines). Frontend: full-viewport-width Actuals + Dashboard,
  3 new filters, 2 new KPI cards + 2 drillable columns, CSV updated. Verified via live SQL + handler
  query harness (no ORA errors), `node --check`, KO balance.
- **2026-06-30** — **Actuals reporting + Executive dashboard** (`APP_VERSION` 1.1.0). Added the
  **Actuals** (Budget vs Actual, YTD per combination — period/sector/chapter/program/appropriation
  filters, business-question cards, per-figure drill-down, combination tooltip, CSV) and
  **Dashboard** (utilisation gauge, period-over-period trend, by sector/program/appropriation,
  auto-insights — hand-built SVG/CSS) pages; **Refresh actuals** button (Overview/Actuals/Dashboard
  + ATD). ORDS `/actuals/filters|/actuals|/actuals/lines|/dashboard|POST /actuals/refresh`. DB
  `db/v2/34` (+appropriation) + `db/v2/35` (hourly job). Verified via live SQL probes, handler JSON
  harness, and a Playwright mock-render (0 console errors).
- **2026-06-28** — Initial build, all layers deployed to PROD and verified end-to-end.
  Brand `#3F6F5F`. `APP_VERSION` 1.0.0. Source CSVs preserved in `db/source/`.

## Known follow-ups
- **DCT Program mappings cover 33 of 35** used program codes (matched to PBB by description);
  the 2 unmatched can be mapped manually on the Mapping page.
- **`DCT_GL_BALANCES_V`** enriches Sector only (the `ATD_GL_BALANCES` feed is currently empty;
  Chapter/Program enrichment to be added once it carries parseable segments).
- **Sector seed** uses the latest cost-center column with a `2024-01-01` baseline start; historical
  closed ranges (2018–2023) can be added on the Mapping page when needed.
