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
