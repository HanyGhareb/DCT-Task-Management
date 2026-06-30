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
| Actuals reporting (`db/v2/32–35`) | ✅ Deployed — `DCT_ACTUAL_V` / `DCT_BUDGET_ACTUAL_V` / `DCT_BUDGET_ACTUAL_PERIOD_V` (+appropriation, +commitment_ytd/obligation_ytd, +open_commitment_ytd/open_obligation_ytd) + indexed `DCT_GL_COA_SNAP` + hourly `DCT_ACTUALS_REFRESH_JOB` |
| Frontend (Portal-style KO SPA, `Jet/`) | ✅ Live — Overview / Actuals (full-width, Commitment/Obligation + Open Commitment/Open Obligation cols w/ ⓘ hints + PR/PO drill, Account/Cost-center/Source filters) / Dashboard / Classifications / Mapping / Explorer; EN-AR-RTL; E2E + mock-render passed |
| Registration | ✅ shell switcher + common i18n + proxies (auto-derived) + CLAUDE.md Module Status |
| APEX pages | ⬜ N/A (JET only) |

## Deployment log
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
