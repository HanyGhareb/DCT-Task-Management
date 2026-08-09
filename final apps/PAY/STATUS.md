# PAY — Outsource Payroll (App 215) — Status

Phase plan: `PAY_PLAN_V2.md` (7 end-to-end phases). **Current: Phase 3 — Payroll Setup & First Calculated Payroll — LIVE 2026-08-08** (plan `PAY_PHASE3_PLAN.md`; Phases 2/2.1 LIVE 2026-08-07, plan `PAY_PHASE2_PLAN.md`; real payroll rounds in `docs/PAYROLL/`).

### Phase 3 — Payroll setup + first calculated payroll (db/14–17, JET v1.4.0)
- **13 new `DCT_PAY_*` tables** (db/14): payrolls, period calendars, elements (+eligibility links, entries), rate tables (+rows), invoice groups (+sector map), runs (+per-employee results, calculation lines, company-charge preview) + `is_wps` on employee banks. **PLATFORM RULE (user 2026-08-08): DCT never pays an employee directly — every payment goes to the outsource company's validated supplier account; employee IBAN/WPS data is reference only.**
- Seed (db/15): 11 `PAY_*` vocabularies, **one monthly AED payroll per company** (`ALN_MONTHLY`/`DAYTON_MONTHLY`/`REACH_MONTHLY`, 2025+2026 calendars), 7 elements (BASIC/GROSS_SALARY/ALLOWANCE/ARREARS_ADJ/PENSION_EE/DEDUCTION_ADJ/PENSION_ER; pension linked to REACH only), `PENSION_GCC` rate table (AE 5 / SA 9 / OM 7.5 employee; **employer rates NULL until Finance confirms**), invoice groups from the REAL ALN invoices 61302–61305 (4 sector groups; Dayton/Reach 1), `payroll_code` backfilled on all 478 assignments + 927 salary entries from the Phase 2.1 snapshots.
- Engine `DCT_PAY_CALC_PKG` (db/16): run lifecycle `OPEN→LOADED→VALIDATED→CALCULATED→REVIEWED` (+REOPEN); proration FIXED_30 default / CALENDAR_DAYS / WORKING_DAYS (configurable per payroll); eligibility links any-of; calc rules FLAT/PERCENT/QTY_RATE/RATE_TABLE (**FORMULA seeded but disabled**); charge preview from the Phase-1 contract margin rules per invoice group (PER_EMPLOYEE × prorated headcount, VAT 5% preview, DRAFT-contract note, "no margin rule" flag).
- ORDS db/17 additive (17 handlers): `paysetup/boot` + payroll/period/element/link/rate-row/invoice-group writes, `entries`, `runs` register/detail (KPIs+groups+charges+exceptions+**variance vs prior period**)/action/emps (paged+search)/lines drill/CSV export. **Re-run 08, 12 AND 17 after any 04 re-run.**
- JET v1.4.0: **Payroll Runs** console (payroll+period pickers, stage buttons, KPI band, invoice-group + charge tables, exceptions, variance, results register w/ line-drill drawer, CSV) + **Payroll Setup** page (payrolls/elements/rate tables/invoice groups w/ edit drawers, period generation).
- **Replay acceptance PASSED**: ALN Dec-2025 (313, gross 13,817,398.68) · Dayton Nov-2025 (25, 743,552.50, 4 genuine no-salary exceptions) · Reach Oct-2025 (140, 586,859) — per-employee 0 difference, company totals exact vs the approval sheets; ALN margin 795×313 splits per invoice group like the real invoices; Dayton DRAFT contract (TCA/C&P/AB/13-0222, 1,250/employee) created; **Reach margin still TBD** (engine flags it).
- Verification: API smoke **37/37**, browser smoke `tests/pay_phase3_browser.py` **29/29 EN+AR/RTL**, 0 INVALID.
- **The parallel-run period starts now**: next live month is calculated here AND by the manual process; the manual process stays authoritative until the user switches.

### Phase 2.1 — real-data enrichment + production load (db/13, JET v1.3.0)
- Sources: the actual Oct–Dec 2025 payroll rounds (docs/PAYROLL) of **Al Nahiya (313), Dayton (25), Reach/TCA (140)** → **478 outsourced employees LOADED** with one ACTIVE PRIMARY assignment each, 478 HIRE events, 140 Reach bank accounts (name+IBAN from the sheet). Grosses reconcile (ALN 13.82M vs 13.75M prior-month total on the sheet).
- `DCT_PAY_ASSIGNMENT` enrichment columns: `company_ref` (ANG ref / Reach ID#), `job_title` (free-text designation), `sector_name`, `department_name`, `cost_center_code`, `basic_salary`/`allowance_amount`/`gross_salary` (current contractual snapshot — Phase 3 elements supersede).
- Real outsource **grade ladder 1A..7C** seeded into `DCT_EMPLOYEE_GRADES` (category OUTSOURCE); DAYTON + REACH companies created; **ALN per-employee markup corrected 1500→795** (the value on every Nov+Dec sheet row).
- Bulk upsert now also **matches by fusionPersonNumber** (the 2000xxx / Oracle-no ERP numbers), takes the enrichment + bank columns, and resolves department/grade **leniently** (unmatched name → text column / NULL grade instead of a failed row).
- ⚠ **Emails are placeholders** (`<erpno>@os.dct.placeholder`) — no email column exists in any company sheet; HR to backfill real addresses (email stays mandatory for new entries).

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

### Phase 2 Workforce (db/09–12, JET v1.2.0)

- `DCT_EMPLOYEES` + additive `employee_type` (INTERNAL/OUTSOURCE lookup) and unique-when-set `fusion_person_number`; **EMAIL stays NOT NULL by user decision (mandatory for every category)**; `FULL_NAME_EN` is a virtual column — never insert/update it.
- New tables: `DCT_PAY_ASSIGNMENT` (effective-dated, one ACTIVE PRIMARY per person per window, FKs to `DCT_ORGANIZATIONS`/`HR_JOBS`/`DCT_EMPLOYEE_GRADES`/`HR_POSITIONS`/`HR_LOCATIONS` + manager), `DCT_PAY_EMP_BANK` (PAY_PAYROLL_ENTRY-gated, one primary), `DCT_PAY_EMP_EVENT` (immutable HIRE/TRANSFER/SUSPEND/RESUME/TERMINATE/REHIRE trail).
- `DCT_PAY_EMP_PKG`: auto `OS-#####` numbering (sequence + `EMP_NUMBER_PREFIX` setting), dedup 400s on email/Emirates ID/passport/Fusion no, lifecycle procs, bulk full-upsert (≤500 rows, per-row results, blank cells keep stored values), `add_emp_doc` w/ real doc types + expiry, daily `DCT_PAY_EMPDOC_JOB` 07:25 UTC expiry alerts.
- Roles `PAY_HR_ENTRY` / `PAY_PAYROLL_ENTRY`; PAY_EMPLOYEE doc checklist (6 types incl. new LABOUR_CARD) on shared `DCT_DOC_REQUIREMENTS`.
- ORDS db/12 additive (15 handlers): employees register/profile/assignments/lifecycle/banks/docs/bulk/LOVs/expiring-docs.
- JET v1.2.0: Employees page (register + facets, drawer tabs Profile/Assignments/Bank/Documents/Lifecycle, lifecycle sub-forms, SheetJS bulk upload w/ template + per-row results), dashboard headcount KPI + expiring-docs region.
- Verification: API smoke **35/35**, browser smoke `tests/pay_phase2_browser.py` **24/24 EN + AR/RTL**, 0 INVALID objects, all test data deleted.

### Phase 1.1 governance enhancement

- Additive schema: ownership, contacts, compliance, performance, commercial controls, configurable fees, renewals, amendment history, document rules, data quality, and optimistic row versions.
- Lookup-driven bilingual configuration, exact Fusion supplier/site/bank validation, immutable superseded versions, authenticated documents, and masked bank data.
- JET v1.1.0 exposes the functions in EN/AR with governance dashboards and CSV exports.
- Verification: transactional DB suite 12/12 PASS; read-only browser smoke 8/8 PASS. UAT and DWP approval excluded by user decision.

## Deployment log
- **2026-08-09 (2)** — v1.5.1 (webtier `20260809193155`): "Show selected only" filter checkbox on the invoice-group drawer's cost-center picker (+ live selected-count in the region title; empty-state hint when filtered with nothing ticked). Browser smoke re-based on data-independent assertions (group short codes are user-editable — the user had already renamed ADALC→ALC in PROD) — 40/40.
- **2026-08-09** — **Invoice groups on COST CENTERS** (user change requests: CC-based grouping · numeric group code + Short Code · Pay-Admin add/remove employees from both the group drawer and the run page): db/18 migration (numeric `group_code` + `short_code`, `DCT_PAY_INVOICE_GROUP_CC` map + `DCT_PAY_INVOICE_GROUP_EMP` INCLUDE/EXCLUDE overrides, seeded from the observed assignments — 42 CC mappings + 1 preservation override for the one employee whose CC 4510250 spans two sectors) + db/16 engine rework (resolution = INCLUDE override → CC map → default group; `set_group_emp` / `set_run_emp_group`; charge preview extracted to `compute_charges` and re-priced live on a group move) + db/17 rework (numeric+shortCode envelopes, `paysetup/cc-lov`, group members/candidates/override routes, `PUT runs/:id/emps/:reid` move) + JET **v1.5.0** (group drawer = CC checkbox picker w/ cross-group locks + resolved members w/ source badges + Remove/Restore + add-employee search; run lines drawer = invoice-group move select; webtier `20260809185404`). **Replay acceptance re-passed**: all 3 runs reproduce baselines exactly (ALN 313/13,817,398.68/952,146.69 split 35/119/159). API 28/28 + browser 38/38 EN/AR, 0 INVALID.
- **2026-08-08** — Phase 3: db/14→17 deployed (14 DDL 13 tables + IS_WPS, 15 seed UTF-8, 16 DCT_PAY_CALC_PKG, 17 ORDS fresh session); ALN contract/rule backdated to 2025-01-01 (invoices prove the 795 terms applied through 2025); Dayton DRAFT contract 41 + 1,250/employee rule created; 3 replay runs CALCULATED and reconciled to the source sheets; JET v1.4.0 (webtier `20260808144424`). API 37/37 + browser 29/29 EN/AR, 0 INVALID.
- **2026-08-08** — Employee-ID guard hardening: seven `employees/:id` ORDS handlers now return 400 for missing/non-numeric/non-positive IDs; JET v1.3.1 blocks invalid dependent calls client-side.
- **2026-08-07 (2)** — Phase 2.1: db/13 + 11/12 re-run + JET v1.3.0 (webtier `20260807233240`); 478 real employees loaded (bulk API, idempotent re-run verified UPDATED); browser smoke 24/24.
- **2026-08-07** — Phase 2 Workforce: db/09→12 deployed (09 DDL + recompile sweep to 0 INVALID, 10 seed, 11 pkg + job, 12 ORDS fresh session); JET v1.2.0 shipped (webtier `20260807224553`). API 35/35 + browser 24/24 EN/AR.
- **2026-08-06 (2)** — v1.1.1: supplier-reference Payment Method / Pay Group / Payment Terms became LOV dropdowns (NEW `GET /pay/lov/payment` over the AP installments extract + AP header terms; 08 re-run, webtier `20260806215019`); Playwright check PASS (3/22/2 values, no KO errors).
- **2026-08-06** — Phase 1.1 backend `05`–`08` deployed and verified; JET v1.1.0 deployed. DWP approval and human UAT intentionally excluded.
- **2026-08-05** — Phase 1 initial deploy: db/01→04 via SQLcl (`sql -name prod_mcp`, one script per invocation, CRLF), db/v2/50 re-run for the `pay` segment; 0 INVALID objects; frontend shipped; browser smoke 24/24.

## Next (Phase 4 — Full monthly cycle)
DWP approval chain for payroll runs, period locking + frozen calculation snapshots, payslip generation (PDF EN/AR) with per-payroll AUTO/MANUAL publishing + tracked email delivery, company payment summary/detail reports. Open business inputs carried from Phase 3: **Reach margin terms**, employer pension % per country (rate table `er_rate`), real employee emails (payslip delivery), the ~23 Gaming & Digital Development ALN employees not present in the loaded approval sheet, and Dayton contract approval (DRAFT → ACTIVE).
