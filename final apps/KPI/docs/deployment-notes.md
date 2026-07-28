# KPI Module (App 213) — Deployment Notes

Finance KPI Management. Identity: App **213**, key `kpi`, code `KP`, module_code `KPI_MGMT`,
ORDS base `/ords/admin/kpi/` (module `kpi.rest`), brand `#8C6D1F`, roles
`KPI_ADMIN` / `KPI_USER` / `KPI_FIN_DIRECTOR`.

Platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md` §2 — they all apply.

## Deploy checklist

1. **DB scripts** (`db/01 → 07`, one SQLcl invocation each, quoted path — the folder has a space):
   `01` DDL → `02` views → `03` seed (**UTF-8 session**: `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8`)
   → `04` package → `05` DWP seed → `06` ORDS (**fresh session**, synonym rule) → `07` jobs.
   After each: `0 INVALID` in `all_objects` for PROD.
2. **Module-access gate**: db/v2/50 CASE map contains `WHEN 'kpi' THEN 'KPI_MGMT'`
   (added 2026-07-28, synced into db/v2/11). A re-run of db/v2/11 must carry it, and the
   post-11 list (49, 101) applies as usual.
3. **Report**: `reporting/db/29_rpt_kpi_book.sql` + upload
   `reporting/runner/templates/kpi_briefing_book.html.j2` via
   `PUT /rpt/templates/kpi_briefing_book.html.j2` (SYS_ADMIN, raw binary).
4. **Frontend**: bump `window.APP_VERSION` in `Jet/index.html` on every deploy; a change under
   `final apps/shared/` bumps ALL apps. Deploy with `webtier/deploy_frontend.sh`.
5. **Tests**: `db/test/kpi_smoke_test.sql` (36 asserts, rolls back) ·
   `tests/test_kpi_api.py` (56 checks; mint 3 sessions via `dct_auth.open_session`, set
   `KPI_TOK_ADMIN/USER/SYS` + a **fresh `KPI_TEST_YEAR`** per run) ·
   `tests/browser_smoke.py` (15 checks; dev-proxy port via `KPI_PORT`).

## App-specific gotchas

- **Score bands evaluate 5→1, first match wins** — this is how the circular's overlapping
  bands (`3: =100`, `4: >100`, `5: ≥108`) and the descending CASH_MGMT bands both work with
  one evaluator. `EQ` compares after `ROUND(value, 1)`.
- **DCT_KPI_SOURCES is declarative only.** The executable auto-figure SQL lives exclusively in
  `DCT_KPI_PKG.suggest_value` as static SQL (zero dynamic SQL). Unknown/inactive source, no
  data, or any error → NULL → manual entry. GL revenue sources filter
  `DCT_GL_COA_SNAP.account_type = 'Revenue'` (+ optional account range on the source row);
  quarterly actuals sum `DCT_ACTUAL_V` AP+GRN by txn_date.
- **Workflow**: process `KPI_RESULT_APPROVAL` (v1 PUBLISHED), steps SECTION_HEAD
  (LINE_MANAGER resolver, fallback ANY_ROLE_HOLDER of KPI_ADMIN — the line-manager data
  waits on the employee extract, so the fallback is load-bearing) → FIN_DIRECTOR
  (ROLE KPI_FIN_DIRECTOR, fallback BUSINESS_ADMIN, final gate). Hooks ON_COMPLETE →
  `DCT_KPI_PKG.WF_ON_COMPLETE` (APPROVED), ON_REJECT + ON_RETURN → `WF_ON_REJECT` (RETURNED).
  Route `KPI_MGMT → WF`. Resubmission after RETURNED starts a NEW instance (old chain stays
  in history). **05 rebuilds the definition only while zero instances reference it** — once
  live, change the chain in the Workflow Designer.
- **Hook signature** is the DWP 4-arg registry contract
  `(p_instance_id, p_source_module, p_source_record_id, p_user_id)`.
- **ORDS 404-after-header**: never `err(404)` after `json_header`/`initialize_output` — the
  200 is already committed. Existence-check first (bit us on 3 handlers during build).
- **`OWA_UTIL.status_line(201)` before `json_header` does NOT produce a 201 on this ORDS** —
  handlers return plain 200; don't re-add it.
- **`DCT_RPT_RUN.error_msg`** (CLOB) — not `error_message`; a wrong column name in handler SQL
  is an uncatchable 555.
- **`:MI` in a TO_CHAR mask inside a report section SQL** = phantom bind in the Python
  datasource (DPY-4008). Write masks as `'HH'||CHR(58)||'MI AM'` in `source_ref` SQLs
  (same gotcha as the FL termsheet).
- **Evidence** rides shared `DCT_DOCUMENTS` (`source_module='KPI_MGMT'`,
  `source_type='KPI_RESULT'`, doc type `KPI_EVIDENCE`), raw-binary `PUT results/:id/docs`
  guarded by module setting `MAX_UPLOAD_MB` (413 over).
- **`dct_documents.source_module` is VARCHAR2(10)** — `KPI_MGMT` fits (8); don't grow the code.
- Seeds use **update-first upserts, never MERGE** (Linux SQLcl silently swallows
  merge-bearing blocks) and literal Arabic deployed under a UTF-8 session.

## Deployment history

| Date | What | Result |
|---|---|---|
| 2026-07-28 | Full first deployment: db 01–07, db/v2/50 gate (+11 sync), reporting/db/29 + template, shell/i18n registration, APP_VERSION bump all apps | 0 INVALID; unit 36/36; DWP simulate + live cycle APPROVED; API 56/56; browser 15/15; briefing book run 169 SUCCESS (8-page PDF) |
| 2026-07-28 | Webtier frontend release **20260728125906** (`SSH_USER=opc deploy_frontend.sh` — whole fleet incl. KPI/Jet + shared shell) | live: /KPI/Jet/ 200 @ 1.0.0, shell.js carries kpi/213, Admin @ 4.7.11 |
| 2026-07-28 | **v1.1.0 FPB-layout round** (user review): dashboard/results/resultEntry rebuilt on GL-butil-style collapsible brand-headed regions (`.kp-sec`, state in `localStorage('kpi_ui')`), Overview answer band = 4 tinted stat tiles (`.kp-tiles`), **How to Start** 5-step clickable guide region (auto-collapses once results exist), ⓘ hint tooltips throughout, results Search region + matrix legend + role-aware first-step CTA, resultEntry **"How this KPI is scored"** region (formula pills + live band table from `kpis/:id` + rules). KPI-only change — no shared/ edit, no fleet bump. Webtier release **20260728132554** | browser smoke **20/20** (updated for new layout); screenshot draft cleaned from PROD; live @ 1.1.0 |
| 2026-07-28 | **v1.2.0 FPB skin** (user: "look and feel still not matched"): the KPI app now carries the FULL GL/FPB visual language, KPI-gold accented — Google Fonts **Fraunces + Public Sans + Noto Naskh Arabic** loaded in index.html, `--fpb-*` tokens in app.css (cream `#F6F5F1` body, warm line/shadow/14px radius), serif page titles + tile/score/preview numerals, region headers = **brand gradient always** (no `--region-hd-bg` — the platform region theme made them black), GL-style scoped restyle of `.btn/.form-label/.form-control` and `.data-table` (brand header row + tinted zebra/hover) under `.page-wrap`. KPI-only, no shared/ change. Webtier release **20260728141810** | smoke 20/20; live @ 1.2.0. NOTE: a real user DRAFT (result 10, REV_GROWTH 2026) existed in PROD during testing — never bulk-delete drafts when cleaning test data, match on the minted test user/session |
