# PAY — Outsource Payroll (App 215) — Status

Phase plan: `PAY_PLAN_V2.md` (7 end-to-end phases). **Current: Phase 1 — Companies & Contracts — LIVE 2026-08-05.**

| Layer | Status | Notes |
|---|---|---|
| DB DDL (db/01) | ✅ Deployed 2026-08-05 | 5 tables: DCT_PAY_COMPANY / _COMPANY_SUPPLIER (1..N supplier/site/bank per company) / _CONTRACT (amendment chain) / _MARGIN_RULE (effective-dated, overlap-guarded) / _DCT_BANK |
| Seed (db/02) | ✅ Deployed 2026-08-05 | 8 PAY_* lookup categories, DCT_MODULES row (App 215, brand #14682F = AP by user decision), roles PAY_ADMIN / PAY_USER + 4 permissions, module settings (THEME_BRAND_COLOR / MAX_UPLOAD_MB / RENEWAL_ALERT_DAYS), doc type PAY_DOCUMENT |
| Package (db/03) | ✅ Deployed 2026-08-05 | DCT_PAY_PKG (validated saves, amend-as-version, ATD_SUPPLIERS check, docs, sweep_renewals) + DCT_PAY_RENEWAL_JOB daily 07:20 UTC |
| ORDS (db/04) | ✅ Deployed 2026-08-05 | pay.rest at /ords/admin/pay/ — 22 handlers; `WHEN 'pay' THEN 'PAY'` added to db/v2/50 CASE map (synced into 11) and REDEPLOYED |
| JET SPA | ✅ Live (v1.0.0) | 4 views: dashboard / companies / contracts / banks — AP (App 212) look & feel: same brand green, .ap-region collapsible+maximizable regions, .dw-* right-edge drawers, top-right actions, EN/AR/RTL |
| Registration | ✅ | shell.js MODULES (key `pay`), shared i18n mod.pay EN+AR, APP_VERSION bumped in ALL 15 sibling apps (shared change) |
| Tests | ✅ | API CRUD-chain smoke PASS (company → supplier ref w/ ATD validation + 400 on unknown supplier → contract → margin rule + 400 on overlap → amend + version chain) · browser smoke `tests/pay_browser_smoke.py` **24/24 EN + AR/RTL** |
| APEX pages | ⬜ N/A (JET only) | |

## Deployment log
- **2026-08-05** — Phase 1 initial deploy: db/01→04 via SQLcl (`sql -name prod_mcp`, one script per invocation, CRLF), db/v2/50 re-run for the `pay` segment; 0 INVALID objects; frontend shipped; browser smoke 24/24.

## Next (Phase 2 — Workforce)
`DCT_EMPLOYEES.employee_type='OUTSOURCE'` flag + `DCT_PAY_ASSIGNMENT` (effective-dated, concurrent, BU DCT/MSS/AFH) + lifecycle + document expiry alerts + Excel bulk upload.
