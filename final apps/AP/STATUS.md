# Accounts Payable (App 212) — Status

**Module:** AP · **Brand:** `#8E3B5C` · **ORDS:** `/ords/admin/ap/` (`ap.rest`) · **Data:** read-only over `PROD.AP_INVOICES_HEADER_V` / `AP_INVOICE_LINES_V` / `AP_INVOICE_DISTRIBUTIONS_V`

| Layer | Status | Notes |
|---|---|---|
| Module registry | ✅ Deployed 2026-07-12 | `db/01_ap_module_seed.sql` — `AP` row in `DCT_MODULES` (module_id 121, App 212) |
| Facet engine pkg | ✅ Deployed 2026-07-12 | `db/02_ap_pkg.sql` — `PROD.DCT_AP_PKG` (in_list + filtered_ids), VALID |
| ORDS core | ✅ Deployed 2026-07-12 | `db/03_ap_ords.sql` — filters / summary / invoices / invoices export / invoice drill |
| ORDS level endpoints | ✅ Deployed 2026-07-12 | `db/04_ap_level_ords.sql` — lines / dists + CSV exports (ADDITIVE — re-run after any 03 re-run) |
| JET SPA | ✅ Built 2026-07-12 | Blank Home + AP Dashboard (facets, level radio, analytics, register, print). APP_VERSION 1.0.0 |
| Platform registration | ✅ Done 2026-07-12 | shell.js MODULES + common i18n (`mod.ap`) + APP_VERSION bumped in ALL apps (shared change) |
| API smoke | ✅ 14/14 PASS | reconciliations (aging Σ = outstanding; summary count = register total), 401/404/boundary |
| Browser smoke | ✅ 23/23 PASS | Playwright: home, facets, 8 charts, 3 levels, collapse/maximize, drill, print, RTL |
| Webtier ship | ✅ Live 2026-07-12 | release `20260712231423` (all apps + shared + AP); AP 200-OK on https://129.151.159.189/AP/Jet/ |
| UAT package | ⬜ Not started | Admin-convention round to be run with the AP team |
| APEX pages | ⬜ Not started | |

## Deployment log

- **2026-07-12** — Initial build: db/01→04 deployed to PROD (fresh sessions), `ap.rest` published with 9 templates/9 handlers. Perf rework in `DCT_AP_PKG.filtered_ids` (correlated `OR EXISTS` → per-facet id-set scans + `MULTISET INTERSECT`; filtered summary >5 min → ~1.4 s). Aging made credit-inclusive (`balance_due <> 0`) so Σaging = outstanding KPI. Frontend built + registered platform-wide.
- **2026-07-12** — Pushed to origin (`26ebaa8`) and shipped web-tier release `20260712231423` (whole fleet — shared/ changed). Production smoke: AP index 200, shell.js carries the AP entry, `/ords/admin/ap/*` proxied (401 w/o token as expected).
- **2026-07-12 (round 2)** — Full-width dashboard, PO-sourced effective charge account + full GL combination + complete invoice details at Distribution level (db/04 re-run), per-user column show/hide saved as `/dct/prefs` `ap.dash.cols`. APP_VERSION 1.1.0; browser smoke 30/30; shipped to web tier.
- **2026-07-12 (round 3)** — Interactive view (shared `<interactive-report>`: rename/calc columns, aggregates, breaks, highlights, per-user layouts) on the register; caps 500→10000 (03+04 re-run). APP_VERSION 1.2.0; smoke 37/37; shipped to web tier.
- **2026-07-13** — Attachment Flag dropped from ATD_AP_INVOICES (OTBI change): views rebuilt via `dct_views_rebuild` + NEW `db/05_ap_views.sql` (AP_*_V source of truth, no has_attachment), 03+04 re-run, frontend/i18n cleaned. 0 INVALID; API 14/14. APP_VERSION 1.2.1.
- **2026-07-13 (beneficiary, v1.3.0)** — Effective supplier (BENEFICIARY → real beneficiary name) across register/exports/charts/KPI/sort + new Is Beneficiary Y/N column (all levels, chooser-managed); search matches beneficiary; lines/dists views gained BENEFICIARY_NAME (05→02→03→04 redeployed). Same day: canonical GL-combination rule — poChargeAccount now dct_cc_canon-wrapped; db/v2/46 PO view charge_account canonical; db/v2/48 cc_code canonical; db/v2/43 retired. API smoke 6/6 + browser smoke PASS.
- **2026-07-13 (dashboard enhancements, v1.4.0)** — Include-Cancelled checkbox + GL Date from/to filters; monthly trend re-based to Invoice Received Date (fallback invoice date) starting at the current budget year; drill-down drawer (GL butil pattern: wide + ⤢ full-screen + Esc + CSV + reconciling total) on ALL 8 charts via 7 new `filtered_ids` facets (`glfrom/glto/rcvfrom/rcvto/esupplier/aging/inclcxl`); region maximize CSS bug fixed (late `.ap-region{position:relative}` overrode `--max`); ⓘ hint per chart (EN/AR). **Item-only rule**: dist-grain facets/LOVs/bySector count `distribution_type='Item'` only — sector facet now reconciles with the KPI (Unclassified 4,887 → 78). Deployed 02→03→04; DB verify + 7/7 SQL reconciliation tests PASS. APP_VERSION 1.4.0.
