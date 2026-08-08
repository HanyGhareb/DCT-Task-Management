# PAY (App 215) — Deployment Notes

Platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md` §2 — they all apply here.

## Deploy checklist
1. Bump `window.APP_VERSION` in `Jet/index.html` on every frontend ship (a `final apps/shared/` change ⇒ bump ALL apps).
2. DB scripts in order, **one SQLcl invocation per script** (`sql -name prod_mcp`), runner file with absolute path + `EXIT`, CRLF, `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` for the Arabic seed:
   - `db/01_pay_ddl.sql` — DROPS + recreates the 5 DCT_PAY_* tables (data loss on re-run; Phase 1 only).
   - `db/02_pay_seed.sql` — re-runnable (update-else-insert, no MERGE — Linux SQLcl safe).
   - `db/03_pay_pkg.sql` — DCT_PAY_PKG + DCT_PAY_RENEWAL_JOB (drops/recreates the job).
   - `db/04_pay_ords.sql` — **FRESH session** (synonym rule: never after `ALTER SESSION SET CURRENT_SCHEMA=PROD`, ORA-01471). DELETE_MODULEs pay.rest and rebuilds all 22 handlers. **Re-run 08 AND 12 after any 04 re-run** (both are additive onto pay.rest).
   - `db/09_pay_phase2_ddl.sql` — additive (guards; safe re-run): DCT_EMPLOYEES columns + 3 Phase 2 tables + recompile sweep (the ALTER invalidates ~6 dependent bodies; script ends at 0 INVALID).
   - `db/10_pay_phase2_seed.sql` — re-runnable Phase 2 seed (lookups, entry roles, settings, emp-number sequence, doc types + PAY_EMPLOYEE checklist).
   - `db/11_pay_phase2_pkg.sql` — DCT_PAY_EMP_PKG + DCT_PAY_EMPDOC_JOB (drops/recreates the job).
   - `db/12_pay_phase2_ords.sql` — **FRESH session**; additive Workforce routes (15 handlers) + Phase 2 synonyms.
   - `db/13_pay_phase2_1_enrich.sql` — additive Phase 2.1 (assignment enrichment columns, grade ladder 1A..7C, DAYTON/REACH companies, ALN markup 795); deploy BEFORE re-running 11+12 (both reference the new columns).
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

- **Phase 2 gotchas:** `DCT_EMPLOYEES.FULL_NAME_EN` is a **VIRTUAL column** — any INSERT/UPDATE naming it dies with ORA-54013 (FULL_NAME_AR is a real column and IS maintained by the pkg). `EMAIL` is NOT NULL **and unique** platform-wide — mandatory for every employee category by user decision 2026-08-07, so hire/bulk validate it to a clean 400. Employee docs use `add_emp_doc` (real doc types + `expiry_date`, source_type `PAY_EMPLOYEE`, reference_id = person_id) — NOT Phase 1's `add_doc`. Playwright note: KO `value:` bindings commit on `change`; after `fill()` on the LAST field before an `evaluate('el=>el.click()')` save, dispatch a `change` event or the observable stays empty (`kfill` helper in `tests/pay_phase2_browser.py`).

## History
- **2026-08-07 (2)** — **Phase 2.1 real-data enrichment + production load** (db/13 + 11/12 re-run + JET v1.3.0, webtier `20260807233240`): assignment gains company_ref / job_title / sector_name / department_name / cost_center_code / basic+allowance+gross salary snapshot; grade ladder 1A..7C seeded (category OUTSOURCE); DAYTON + REACH companies created; ALN per-employee markup corrected to the observed **795** (was demo 1500); bulk upsert matches by fusionPersonNumber, takes enrichment + bank columns, department/grade resolution LENIENT (sheet names → text columns, stray grades → NULL). **478 real employees loaded** from docs/PAYROLL (ALN Dec-2025 313 · Dayton Nov-2025 25 · Reach/TCA Oct-2025 140) + 140 Reach IBANs; grosses reconcile to the sheets; idempotent re-run = UPDATED. ⚠ emails = `<erpno>@os.dct.placeholder` (no email column in any company sheet — HR to backfill). Loader kept at the session scratchpad only; re-loads should go through the page's bulk upload.
- **2026-08-07** — **Phase 2 Workforce LIVE** (db/09–12 + JET v1.2.0, webtier `20260807224553`): outsourced employees on the shared `DCT_EMPLOYEES` master (`employee_type='OUTSOURCE'`, auto `OS-#####` numbers, nullable unique `fusion_person_number`), effective-dated assignments on the DCT/HR masters (one ACTIVE PRIMARY per person per window), role-gated bank details (PAY_PAYROLL_ENTRY; masked otherwise), lifecycle events (transfer/suspend/resume/terminate/rehire), employee documents w/ 6-type checklist + daily expiry alerts (`DCT_PAY_EMPDOC_JOB` 07:25 UTC), Excel full-upsert bulk (≤500/req, per-row results, blank cells keep stored values, masters resolvable by code OR name), Employees page + dashboard headcount/expiring-docs. API 35/35 · browser 24/24 EN+AR/RTL · 0 INVALID.
- **2026-08-06 (3)** — Supplier-reference payment LOVs (v1.1.1, webtier `20260806215019` + 08 re-run): Payment Method / Pay Group / Payment Terms on the supplier-reference editor became dropdowns fed by NEW `GET /pay/lov/payment` — distinct values from the AP installments extract `ATD_AP_INVOICE_INSTALLMENTS` (method + pay group) and `ATD_AP_INVOICES` (payment terms; installments carry no terms column). Stored values absent from the list are re-injected as their own option (KO `options:` rule); the extract tables are read with the `prod.` prefix (AP pattern — no synonyms).

- **2026-08-06 (3)** — Phase 1.1 governance enhancement (v1.1.0): additive `05`–`08`; lookup-driven contacts/compliance/fees/renewals/amendments/risk, exact Fusion supplier/site/bank validation, optimistic locking, immutable superseded versions, authenticated document downloads, masked bank data, governance dashboard/CSV. Transactional DB 12/12 and browser 8/8 passed. UAT and DWP approval are out of scope.
- **2026-08-06 (3)** — **Supplier LOV re-pointed at the normalized bank extract** (user-approved;
  DEFINE_HANDLER-only redeploy of `GET lov/suppliers` + new ADMIN synonym
  `atd_supplier_bank_accounts`, both synced into 04): the Suppliers-family extract rework
  (otbi-atd 2026-08-06) made `ATD_SUPPLIERS` a clean one-row-per-registry master **without
  bank columns** (28,607 suppliers, hourly incremental) — the LOV's bank hints now come from
  `ATD_SUPPLIER_BANK_ACCOUNTS` (best account per supplier: primary → active → newest);
  `currency`/`payGroup` stay in the response but are NULL until re-sourced. Validation
  unchanged (supplier_number) and now covers post-June suppliers. Smoke: ETISALAT search
  returns real bank/IBAN per supplier.
- **2026-08-06 (2)** — Doc-upload fix (v1.0.1, webtier `20260806125101` + 04 re-run): `payService.uploadDoc` was not passing `file_name`/`mime_type` in the putBinary query string → ORA-01400 on DCT_DOCUMENTS.FILE_NAME. **Rule: `api.putBinary` sends ONLY what you put in `opts.query` — always include `file_name` + `mime_type` for doc handlers.** Handler also gained a clean 400 when file_name is missing.
- **2026-08-06** — Webtier release `20260806113102` (SSH_USER=opc deploy_frontend.sh): PAY served at /PAY/Jet/ + updated shared shell (pay switcher entry) + all 15 bumped apps live.
- **2026-08-05** — Phase 1 (Companies & Contracts) initial production deploy: db/01–04 + db/v2/50 re-run (pay segment) + shell/i18n registration + APP_VERSION bump in all 15 sibling apps. API smoke full CRUD chain PASS (incl. 400 paths), browser smoke 24/24 EN+AR/RTL, 0 INVALID objects.
