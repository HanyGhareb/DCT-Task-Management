# AP (App 212) — Deployment Notes

Platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md` §2 — read those first.

## Deploy checklist

1. **DB order** (SQLcl `sql -name prod_mcp`, each script CRLF + `SET DEFINE OFF` + `SET SQLBLANKLINES ON`):
   - `db/01_ap_module_seed.sql` — DCT_MODULES `AP` row (rerunnable).
   - `db/02_ap_pkg.sql` — `PROD.DCT_AP_PKG`. Verify both spec+body VALID.
   - `db/03_ap_ords.sql` — **fresh session**. Rebuilds `ap.rest` from scratch (DELETE_MODULE):
     **always re-run `04` right after any `03` re-run.** Verify 5 templates / 5 handlers.
   - `db/04_ap_level_ords.sql` — **fresh session**, additive lines/dists (+exports). Verify 9/9.
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

## Deployment history

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
