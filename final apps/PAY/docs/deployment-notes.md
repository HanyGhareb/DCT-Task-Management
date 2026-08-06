# PAY (App 215) — Deployment Notes

Platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md` §2 — they all apply here.

## Deploy checklist
1. Bump `window.APP_VERSION` in `Jet/index.html` on every frontend ship (a `final apps/shared/` change ⇒ bump ALL apps).
2. DB scripts in order, **one SQLcl invocation per script** (`sql -name prod_mcp`), runner file with absolute path + `EXIT`, CRLF, `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` for the Arabic seed:
   - `db/01_pay_ddl.sql` — DROPS + recreates the 5 DCT_PAY_* tables (data loss on re-run; Phase 1 only).
   - `db/02_pay_seed.sql` — re-runnable (update-else-insert, no MERGE — Linux SQLcl safe).
   - `db/03_pay_pkg.sql` — DCT_PAY_PKG + DCT_PAY_RENEWAL_JOB (drops/recreates the job).
   - `db/04_pay_ords.sql` — **FRESH session** (synonym rule: never after `ALTER SESSION SET CURRENT_SCHEMA=PROD`, ORA-01471). DELETE_MODULEs pay.rest and rebuilds all 22 handlers.
3. Module-access gate: the `pay` ORDS segment maps to module `PAY` in the db/v2/50 CASE (**synced into db/v2/11**). A re-run of 50 or 11 keeps it — the WHEN line is in both sources since 2026-08-05.
4. Smoke: `GET /pay/boot` (Bearer) → isPayAdmin/lookups(30)/banks; browser `tests/pay_browser_smoke.py` (needs a live token via `dct_auth.open_session` in env `PAY_TOK`; dev-proxy on 8215).

## App-specific gotchas
- **Look & feel = Accounts Payable (App 212) BY DESIGN** (user decision 2026-08-05): same brand green `#14682F` (also seeded as PAY's `THEME_BRAND_COLOR`), `.ap-region` collapsible/maximizable regions, `.dw-*` right-edge drawers, `.ap-tabs`, top-right actions. `css/app.css` is a copy of AP's plus a `.dw-form` / `.sub-editor` / `.lov-pop` PAY section — keep class names in sync with AP when porting fixes.
- `ATD_SUPPLIERS.supplier_number` is a **NUMBER** — every comparison against user input goes through `TO_CHAR(supplier_number)` (pkg + LOV) or ORA-01722 on free text.
- `DCT_PAY_PKG.save_supplier_ref` **hard-fails (-20001) when the supplier number is not in ATD_SUPPLIERS** — the extract must have synced a new Fusion supplier before it can be referenced.
- Margin-rule overlap guard: one ACTIVE rule per contract + payment_scope per effective window (400 on overlap). Amendment (`POST contracts/:id/amend`) clones contract + active rules as version n+1 (DRAFT) and flips the old row to SUPERSEDED.
- APEX_JSON omits NULL/empty-string keys — PAY views bind every optional field as `$data.x || ''` (trn, contactName, titleEn, dateTo, buCode, iban, …). Keep doing this for new columns.
- Collections are trailing-slash sensitive the OTHER way here: POST to `/pay/companies` (the template, NO trailing slash) — `/pay/companies/` 404s.
- Renewal alerts: `DCT_PAY_RENEWAL_JOB` daily 07:20 UTC → `dct_pay_pkg.sweep_renewals` notifies all PAY_ADMIN role holders for ACTIVE contracts inside their `renewal_alert_days` window; re-notify throttle 7 days via `last_renewal_notified_at`.

## History
- **2026-08-06 (2)** — Doc-upload fix (v1.0.1, webtier `20260806125101` + 04 re-run): `payService.uploadDoc` was not passing `file_name`/`mime_type` in the putBinary query string → ORA-01400 on DCT_DOCUMENTS.FILE_NAME. **Rule: `api.putBinary` sends ONLY what you put in `opts.query` — always include `file_name` + `mime_type` for doc handlers.** Handler also gained a clean 400 when file_name is missing.
- **2026-08-06** — Webtier release `20260806113102` (SSH_USER=opc deploy_frontend.sh): PAY served at /PAY/Jet/ + updated shared shell (pay switcher entry) + all 15 bumped apps live.
- **2026-08-05** — Phase 1 (Companies & Contracts) initial production deploy: db/01–04 + db/v2/50 re-run (pay segment) + shell/i18n registration + APP_VERSION bump in all 15 sibling apps. API smoke full CRUD chain PASS (incl. 400 paths), browser smoke 24/24 EN+AR/RTL, 0 INVALID objects.
