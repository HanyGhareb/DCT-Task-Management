# otbi-atd — Deployment & Runbook

## 2026-08-13 — Per-user OTBI credential profiles (db/62+63, App 208 v1.35.0) — **DEPLOYED**
**Deployed 2026-08-13** (Linux SQLcl `sql -name prod_mcp` from dev-vm .191): 62 (selftest
PASS live) → 12 re-run (recompile invalidated ATD_SET_NEXT_RUN/ATD_SET_PKG/
DCT_LOG_CLEANUP_PKG + synonym — recompiled, INVALID back to the pre-existing 4) → 63 →
**the 3 edited 13-handlers were patched IN PLACE via a DEFINE_HANDLER-only one-off**
(GL/db/09 pattern — no DEFINE_TEMPLATE, so the module was NOT rebuilt and the additive
chain did NOT need re-running; the next full 13 re-run reproduces them and THEN needs the
chain + 63). API smoke green: 401 no-session · PUT/GET (write-only password, `passwordSet`
flips, no password in any response) · 400 bad chat id / missing login · roster · DELETE ·
manual enqueue stamps `requested_by` + bulk clears. Frontend release `20260813154204`
(v1.35.0 + the Telegram-chat-id how-to steps on the card). Runner: canary vm180 synced +
restarted clean (session reused, no MFA); vm181/182 pre-synced and restarted as each went
idle. **62 gotcha found at deploy: package-PRIVATE function in SQL DML = PLS-00231**
(`SET fusion_pwd_enc = encrypt_pwd(...)` → compute into a local var first; script fixed).
Each admin can now store a PERSONAL Fusion/OTBI account (Runner Settings → **My OTBI
Account**): username + AES-256-encrypted password (DBMS_CRYPTO, random-IV, master key in
`PROD.ATD_CRED_KEY` — no synonym, never touched by ORDS; write-only over the API, only a
`passwordSet` flag comes back) + personal Telegram chat id + Active toggle. **Jobs and
Fusion actions the user enqueues run under THEIR Fusion account** on the fleet; the MFA
number-match push goes to THEIR chat. Scheduled/automatic runs (the 15-min bulk enqueue
and the UI bulk `/enqueue`) stay on the global service account (`OTBI_USER`/`OTBI_PWD`) —
`atd_queue_pkg.enqueue`'s bulk path actively CLEARS `requested_by` so a stale personal tag
can never leak into automatic cycles.

- **DB `62_atd_user_cred.sql`**: `ATD_USER_CREDENTIAL` + `ATD_CRED_KEY` + `ATD_CRED_PKG`
  (`set_password`/`password_set` for ORDS; `resolve_runner_cred` for the fleet's ADMIN
  connection only) + guarded ALTERs — `atd_otbi_jobs.requested_by`,
  `atd_load_run_log.fusion_account` (audit: which account actually ran),
  **`atd_mfa_lock.lock_name` widened 30→200** (per-account locks `FUSION_MFA:<login>`) +
  runner-config seed `ATD_MAX_USER_SESSIONS` (default 2). Ends with an encryption
  round-trip selftest. NO MERGE — Linux-SQLcl-safe.
- **DB `12` re-run**: `enqueue(p_only, p_requested_by DEFAULT NULL)` — manual single-job
  enqueue stamps the caller, bulk clears. **62 must run BEFORE 12** (body references the
  new column). `release_job` keeps `requested_by` (same human intent on a requeue).
- **DB `13` re-run**: `jobs/:name/enqueue|reset` pass `l_user`; `jobs/:name/run` stamps
  `requested_by=l_user`; bulk `/enqueue` deliberately unchanged. As always, **a 13 re-run
  ⇒ re-run the whole additive chain** (20, 26, 31, 32, 33, 38, 39, 41, 42, 44, 45, 46,
  49, 54, 55) **+ NEW `63`**.
- **DB `63_atd_user_cred_ords.sql`** (additive): `GET/PUT/DELETE /atd/my-credential`
  (always the CALLER's own row; `password` applied only when the JSON key is present and
  non-empty) + `GET /atd/credentials` roster (flags only). SYS_ADMIN.
- **Runner** (`config.py` / `notify.py` / `auth.py` / `runner.py`, fleet-sync + restart
  atd-worker on vm180-182 — canary one VM first): claimed jobs/actions resolve
  `requested_by`/`created_by` → `atd_cred_pkg.resolve_runner_cred` (5-min cache; fallback
  → service account, noted in the run log). Personal identities get their OWN Chromium
  profile/state (`chrome_<worker>_<env>__<slug>` / `auth_state_<env>__<slug>.json`), their
  own MFA lock row, and Telegram routing to their chat; **the default identity keeps
  byte-identical paths + lock name, so the deploy costs no MFA**. Personal sessions are
  never keep-alive-pinged and are LRU-capped at `ATD_MAX_USER_SESSIONS`; a personal login
  failure **fails fast** (clear run-log message + Telegram to the owner — NO requeue
  dance, NO session_dead, the service session/queue untouched); mid-run expiry on a
  personal session = one forced re-login retry then FAILED (never released).
- **Frontend v1.35.0**: Runner Settings gains the My OTBI Account card + roster
  (`atd.rs.myacct.*` i18n EN+AR); service methods `getMyCred/saveMyCred/deleteMyCred/listCreds`.
- **Deploy order**: 62 → 12 → 13 + additive chain + 63 (fresh ADMIN session, `sql -name
  prod_mcp`) → frontend (APP_VERSION bump) → THEN runner fleet-sync (Phase 1 is inert for
  old workers: the column is simply ignored). Unit tests `runner/tests/test_user_cred.py`
  15/15 (suite 37/37).
- **Operational flow**: first personal run on each worker VM = one Authenticator approval
  from that user's phone; not approving fails only their run. A personal account can only
  run jobs whose analyses are readable/shared in the Fusion catalog (seeded source_refs
  live under `/users/haghareb@dctabudhabi.ae/...`).
- **Admin steps — personal Telegram chat id** (also shown inline on the Runner Settings
  card; simplified 2026-08-14): ① open Telegram, search **@ifinanceDctBot**, press
  **Start** / send it any message; ② **the bot replies with your chat id** ("Your
  i-Finance runner chat id is: <n>") — tg_bot.py now answers unregistered PRIVATE chats
  with their id (5-min per-chat rate limit; query commands stay allow-list-only; groups
  still ignored silently); ③ paste the number into Runner Settings → My OTBI Account →
  *Telegram chat id* and Save. Fallback: @userinfobot returns the same number.
  **OPS GOTCHA (found 2026-08-14):** the `atd-tgbot` PoC service on vm180 long-polls
  `getUpdates` on the SAME bot token, so it consumes every incoming message —
  `python notify.py chatid` will ALWAYS print "no chats yet" while atd-tgbot is running;
  read incoming chat ids from `journalctl -u atd-tgbot` instead (unregistered senders are
  logged, and now also replied to).

## 2026-08-15 (2) — PERMANENT job owner from the catalog path (App 208 v1.37.0) — DEPLOYED
User rule: a job whose analysis lives under `/users/<name>/…` is owned by that person
ALWAYS — scheduled cycles included — not just when they click Run. Identity priority is
now **catalog-path owner → manual requester (requested_by) → service account**, in BOTH
the Owner column and the actual runner sign-in.
- **db/62 re-run**: `atd_user_credential.catalog_login` (nullable) — the OTBI catalog
  personal-folder name when it DIFFERS from the Entra sign-in (the folder is the Fusion
  APPLICATION username: live case = sign-in `c-saljaaidi@…` vs folder `saljaaidi@…`;
  same split as hg2248 vs haghareb). `atd_cred_pkg` gains SQL-callable
  `job_owner_login(source_ref)` (matches `/users/<x>/` against
  NVL(catalog_login,fusion_login), active+pwd only) + `resolve_job_cred(source_ref,
  requested_by, OUTs)` (owner first, then requester). Selftest extended (path-owner,
  case-insensitive, fallback) — PASS live.
- **db/63 re-run**: `catalogLogin` on GET/PUT my-credential + roster.
- **13 handlers patched in place again** (DEFINE_HANDLER-only): `GET /jobs` +
  `/jobs/:name` ship `owner` + `ownerType` (catalog|manual|''); `requestedBy` kept.
- **Runner** (config.py `resolve_job_cred` + runner.py claim path; fleet-synced, all 3
  restarted): claimed jobs resolve identity via the new proc — **scheduled cycles of an
  owned job now sign in as the OWNER** (their session stays warm between cycles; if it
  ever dies the owner gets ONE push, an unapproved push fails only that cycle and the
  next cycle retries). Actions still key on created_by.
- **UI v1.37.0** (release `20260815213126`): Owner column = permanent owner (hover
  explains catalog vs manual vs "Service account"); My OTBI Account gains the optional
  **"OTBI catalog folder"** field with the c-saljaaidi example in the hint.
- Verified live: AR INVOICE LINES - ALL + AR Invoice Distribution Details - ALL show
  owner `c-saljaaidi@dctabudhabi.ae` (catalog). Tests 39/39.

## 2026-08-15 — Jobs page "Owner" column (App 208 v1.36.0) — DEPLOYED
`GET /jobs` + `GET /jobs/:name` now ship `requestedBy` (the job owner — who queued the
current/last manual cycle; blank = scheduler/service account, per-user OTBI db/62). Both
handlers were **patched in place DEFINE_HANDLER-only** (same pattern as the 2026-08-13
deploy — no atd.rest rebuild, no additive-chain re-run; sources synced into 13 for the
next full rebuild). Jobs page gains an **Owner** column between Status and Last Run —
green mono badge = the queuing user (their OTBI account runs it), muted "Scheduler" =
automatic cycle. i18n `atd.jobs.col.owner*`/`atd.jobs.owner.*` EN+AR; web release
`20260815211438`, APP_VERSION 1.36.0.

## 2026-08-11 — INCIDENT: App 208 dashboard blank below Needs Attention (bare `occurred` bind)
The whole lower dashboard (Queue State / Recent Runs / Worker Fleet / Fusion Actions /
Job Freshness / Alerts) rendered as EMPTY region shells with blank headings, with ZERO
console/page errors. Root cause: `dashboard.html` bound the attention row timestamp as
bare `text: occurred || '—'` — APEX_JSON omits NULL keys, and on 2026-08-11 a *Review*
attention item arrived WITHOUT `occurred` ("Supplier Bank Accounts Full — disabled job
still has active queue state FAILED"), so the binding threw `ReferenceError: occurred is
not defined` **during the `ko ifnot: loading` re-render**, aborting every remaining
binding in the view. The error was invisible because the re-render is triggered by
`self.loading(false)` inside `getDashboard().then(...)`, whose
`.catch(function () { self.loading(false); })` swallows it. Diagnosed by setting
`ko.onError` in-page and toggling `loading`. Fix: `text: $data.occurred || '—'`
(the platform KO rule: bind EVERY nullable field as `$data.field`, never bare) +
APP_VERSION 1.34.8; web-tier release `20260811141540` verified (all 7 regions render).
Lesson: an APEX_JSON-omitted key in a row template doesn't just blank its cell — it
kills every binding after it in the view, silently when the trigger runs inside a
promise with an empty catch.

## 2026-08-06 (3) — Supplier extract family (/Data/Suppliers/prod, 4 analyses; data-only)

Four jobs seeded via the NATIVE PREPARE FLOW (job row w/ no colmap + `schema_reviewed='N'` →
one-shot run profiles the CSV, creates the table + column map, HOLDs; review → approve → load):
- **Suppliers Full** → `ATD_SUPPLIERS` — 28,607 rows (the old 2026-06-21 one-off held only a
  1,417-row filtered subset), REGISTRY_ID = SUPPLIER_NUMBER grain, both fully unique.
  **+ Suppliers Incremental** (`SUPPLIERS_UH24`, filter col **`Last Updated`** — not "Last
  Updated Date" — key `REGISTRY_ID`, TXN_INCREMENTAL order 150; verified 193 staged ≈ table
  last-24h). ⚠ the new analysis carries NO bank columns, so the legacy denormalized
  bank cols on ATD_SUPPLIERS (bank_name/iban/bank_account_number/currency/site_pay_group/
  primary_flag/from_assignment_date) are now NULL — **PAY's supplier type-ahead
  (PAY/db/04 `/pay/lov/suppliers`) shows blank bank hints until it is re-pointed at the new
  normalized bank tables**; validation (supplier_number exists) unaffected and now FRESH.
- **Supplier Bank Accounts Full** → `ATD_SUPPLIER_BANK_ACCOUNTS` — 36,232 rows. **Daily full
  ONLY — NO incremental possible:** the extract has no unique natural key (72 near-dup groups
  on (registry,iban,acct#,inactive_on) + 1 exact full-row duplicate). To enable one, add a
  bank-account/assignment ID column to the analysis.
- **Supplier Sites Full** → `ATD_SUPPLIER_SITES` and **Supplier Sites Bank Accounts Full** →
  `ATD_SUPPLIER_SITES_BANK_ACCOUNTS` — jobs work but each analysis has a LEFTOVER TEST FILTER
  returning ONE supplier (ORACLE SYSTEMS LIMTIED, registry 19257; 2 rows each). Remove the
  supplier filter in OTBI, re-run, then pick keys + add incrementals. (Sites-bank dates
  profiled VARCHAR2 — format unparsed; revisit after the filter fix.)
All four fulls = PAYABLES_DAILY members (orders 40–70, window 10:00–11:00 Dubai).
Catalog navigation gotcha: the Catalog UI needs real mouse **dblclicks** on folder names
(click only selects; "Expand" only drives the tree; `saw.dll?getFolderItems` = 404 here).

**Same-evening follow-up:** user removed the Sites test filters → **Supplier Sites Full =
59,651 rows** + **Supplier Sites Incremental** live (`SUPPLIER_SITES_UH24`, filter col
`Last Updated`, key `REGISTRY_ID,SITE,BUSINESS_UNIT,CREATED` — one Fusion-side dup site
trio differs only by CREATED). **Both BANK analyses broke after the user's 5:07–5:09 PM
edits: `nQSError 60009` query-governor timeout** (diagnosed by rendering Results in the
Answers editor — the Go CSV export just returns the JS shell; the supplier-level one worked
pre-edit at 36,232 rows). Bank incrementals also blocked on grain: even pre-edit,
(registry, bank_name, iban, account#) has 68 dup groups → the analysis needs an
account/assignment ID column for a MERGE key. `ATD_DOWNLOAD_TIMEOUT_SEC` raised 300→900 in
ATD_RUNNER_CONFIG (DB config OVERRIDES the env var — exporting it on a one-shot does
nothing). **PAY supplier LOV re-pointed** at ATD_SUPPLIER_BANK_ACCOUNTS same evening (see
PAY/docs/deployment-notes.md).

## 2026-08-06 (2) — INCIDENT: all daily job sets silently stopped 01→06 Aug (window ∩ break = ∅)

`AP Invoices Full` (and EVERY daily-set job) had not run since 31-Jul. Root cause — two gates
whose open intervals never intersect:
- `atd_queue_pkg.enqueue` **no-ops during the fleet break** (`atd_in_break='Y'`, 21:00–08:00
  Dubai) — no rows are queued overnight;
- `atd_set_gate_ok` passes only **inside the set's daily window, on the Dubai wall clock** —
  and the six daily windows configured 2026-07-31 20:52 (00:30…07:30 Dubai staggered) all fell
  ENTIRELY inside the break. Day: enqueue awake, window closed. Night: window open, enqueue
  asleep. Result: zero daily enqueues from 01-Aug (daily-type runs/day: 255 → 2/10/0/0/0)
  while windowless TXN_INCREMENTAL ran normally and PRPO_PENDING survived only because its
  07:30–16:30 window overlaps worker hours.
- **Fix (user-approved):** windows shifted after break-end, same stagger order —
  GL_COA 08:00–09:00 · HR 08:30–09:30 · PROJECTS 09:00–10:00 · PROCUREMENT 09:30–10:30 ·
  PAYABLES 10:00–11:00 · GL_GRN 10:30–11:30 (Dubai). One UPDATE on `atd_job_set`, no code.
- Catch-up note: jobs manually re-run on 06-Aug evening (PR/PO family, AP Invoices Full) are
  within their 1440-min frequency at the 07-Aug window, so they resume on 08-Aug; everything
  else resumes 07-Aug morning.
- **RULE: a daily set window MUST overlap worker active hours (08:00–21:00 Dubai) — the
  break gate and the window gate are ANDed through the enqueue.**

## 2026-08-06 — AP Installments Incremental (UH24 convention; data-only, no script)

Hourly incremental for AP invoice installments (payment schedules), completing the AP family
(Invoices/Lines/Distributions already had one). Standard recipe: `AP_INVOICE_INSTALLMENTS_UH24`
(Save-As of `AP Installments Full`'s analysis + `Last Updated Date` 24h filter, same folder,
identical 16 columns), job `AP Installments Incremental` — stage
`PROD.ATD_AP_INVOICE_INSTALLMENTS_STG` (CTAS WHERE 1=0), MERGE key
`INVOICE_ID,INSTALLMENT_NUMBER` (verified unique 9,689/9,689, no NULLs), freq 60,
`TXN_INCREMENTAL` member (order 140). Verified: 248 last-24h rows staged = table's own
last-24h count exactly; all keys present in final after merge; run log SUCCESS.
**Session gotcha replayed:** the saved auth_state had idled out (~1h since the previous
extract), so the first copy attempt initiated a login (MFA push) — per the standing rule,
PROBE the saved session first and ask before any step that can trigger MFA; after the user
approved, the state file was re-saved and the rerun attached MFA-free. A copy process that
loses its ssh stdout can wedge silently — kill and rerun; Save-As is idempotent (Confirm
Overwrite path).

## 2026-08-02 (3) — PR/PO BU-filter alignment reload + lenient NUMBER loading (INVALID_NUMBER)

The line↔distribution coverage gap below was NOT a status filter — the PR/PO analyses had
**different Business-Unit filters** (PO Lines was the wide one; Headers/Schedules/Distributions
narrow). The user aligned the BU filters on ALL PR and PO analyses; all 7 Full jobs re-run:
PR 5,959/9,025/9,544 (unchanged — already aligned), PO Headers 2,539→**4,027**, PO Lines 5,925
(was already wide), PO Schedules 3,534→**5,926**, PO Distributions 3,631→**6,180**.

- **Coverage now correct:** every PO line has ≥1 distribution (0 missing) and every
  distribution/schedule has its line; all 7 natural keys fully unique. PO_LINES_V
  NULL-allocation dropped 2,396→191 (lines whose distributions carry no project — GL-coded,
  legitimate) + 64 `(Multiple)`. Residual: 2 PO lines (NULL line_status, Feb/May 2026) whose
  headers the PO Headers analysis still excludes, and 2 PR lines without distributions —
  cosmetic, 2/5,925.
- **load.py NUMBER columns are now lenient like DATE columns:** the first PO Distributions
  reload FAILED with ORA-01722 — 4 misaligned CSV rows (a free-text description from a
  newly-included BU shifts the row: a person name landed in PROJECT_ID, a GL combination in
  TASK_ID). A coerced NUMBER value that doesn't match `-?\d+(\.\d*)?` now loads as **NULL +
  `INVALID_NUMBER` row warning** (same framework as INVALID_DATE; `coerce_number`'s
  fail-loudly pass-through remains, the guard is at bind time in load()). Fleet-synced +
  workers restarted.
- **Drift widenings invalidated 20 objects mid-reload** (longer new-BU values → ALTER MODIFY
  on REQUESTOR_EMAIL/LOCATION_NAME/ORGANIZATION_NAME/ORDER_TYPE/PO_TYPE): fixed with
  `dct_views_rebuild` + recompile sweep → 0 INVALID; butil figures healthy after.
- **UH24 incrementals verified aligned:** all 7 one-shot runs clean, and each staged count
  EXACTLY matches its table's own last-24h count (PR Lines 30/30, PR Dists 7/7, PO Headers
  8/8, PO Lines 22/22, PO Schedules 22/22, PO Dists 22/22).

## 2026-08-02 (2) — PO Lines grain fix: allocation columns REMOVED from the extract (user decision)

Same-day follow-up superseding the composite-key design below: allocation detail belongs at
PO **Distributions** level, so **Project ID / Task ID / Expenditure Type were removed from the
`PO_LINES_F` and `PO_LINES_UH24` analyses themselves** (new `copy_analysis.py --edit <path>
--remove-columns "A,B,C"` mode — opens Criteria, deletes each column via its gear menu, Save As
the same name w/ Confirm Overwrite; filters kept). The BI server then collapses the grain to
one row per line (6,131 fanned rows → 5,918 true lines).

- **DB migration (python-oracledb on vm180, jobs paused during):** both PO Lines job
  column maps 38→35 entries; incremental `key_columns='PO_LINE_ID'` (plain, no composite);
  `ALTER TABLE prod.atd_po_lines DROP (project_id, task_id, expenditure_type)`; stage re-CTAS;
  `dct_views_rebuild` (15 pass-throughs); **PO_LINES_V redeployed** (db/v2/46 updated) — its
  project/task/etype now derive from the line's DISTRIBUTIONS: single value → shown, mixed →
  `(Multiple)`, no dists → NULL. 0 INVALID after.
- **Dependency audit result (why only one view changed):** every butil/actuals/pending view,
  briefing book and register takes allocation from po_distributions/GRN and joins po_lines
  ONLY for the line number (deduped) — `PO_LINES_V` was the sole reader of the line-level
  allocation columns. `dct_open_po_lines_v` in the reports is distributions-based (name grep
  trap: it merely CONTAINS "po_lines_v").
- **Coverage caveat (flagged, accepted):** ATD_PO_DISTRIBUTIONS covers only a subset of lines
  — 2,396 of 5,918 lines (mostly Closed/Liquidated/Canceled) have NO distribution row, so
  their PO_LINES_V allocation shows NULL. Platform reports never used line-level allocation,
  so nothing else changes; widen the PO Distributions analysis if closed-line allocation is
  ever needed.
- **Verified:** Full reload 5,918 rows (PO_LINE_ID fully unique), Incremental 25-row MERGE
  clean, PO_LINES_V 5,918 rows (15 `(Multiple)`), butil 2026 figures unchanged/healthy.
  The NULL-safe DECODE merge join in load.py (below) STAYS — correct platform-wide hardening.

## 2026-08-02 — PO Distributions / Schedules / Lines Incrementals (UH24 convention ×3) + NULL-safe MERGE join

Hourly incrementals completing the PO family (Headers already had one). Same UH24 recipe as
PR Distributions Incremental below, with two findings worth recording:

- **The UH24 filter column heading differs per analysis** — pass `--on-column` explicitly:
  PO Distributions = `Last Updated Date` (the default), PO Schedules = `Schedule Last Updated
  Date`, PO Lines = `Updated on`. Analyses created with `copy_analysis.py` on vm180 (one MFA;
  the first attempt died with "MFA number not found within 30s" — the Entra number challenge
  can render slowly, so the retry ran with `ATD_MFA_CAPTURE_WAIT_MS=120000` and succeeded):
  `PO_DISTRIBUTIONS_UH24` / `PO_SCHEDULES_UH24` / `PO_LINES_UH24`, each a Save-As copy of its
  Full analysis + `>= TIMESTAMPADD(SQL_TSI_HOUR,-24,CURRENT_TIMESTAMP)`, same folder,
  columns identical to Full (column_map_json copied VERBATIM onto the job rows).
- **`PO_LINE_ID` is NOT unique in ATD_PO_LINES** — the extract fans a PO line out per
  project/task/expenditure-type allocation (6,131 rows / 5,899 distinct line ids; 3 combos
  even share line+project+task and differ only by expenditure type). Key =
  `PO_LINE_ID,PROJECT_ID,TASK_ID,EXPENDITURE_TYPE` (unique 6,131/6,131). 18 rows carry NULL
  project/task, which a plain `t.k=s.k` merge join never matches → those rows would INSERT a
  duplicate on every hourly run. **`load.py` MERGE ON is now NULL-safe platform-wide:**
  `decode(t.k, s.k, 1, 0) = 1` per key column (NULL==NULL matches; identical to `=` when both
  sides are non-NULL — byte-identical behaviour for every existing MERGE job). Synced to
  vm180-182 + `systemctl restart atd-worker`.
- **Job rows (data-only, no db/ script):** `PO Distributions Incremental` (key
  `PO_DISTRIBUTION_ID`), `PO Schedules Incremental` (key `LINE_LOCATION_ID`), `PO Lines
  Incremental` (composite key above); stages `PROD.ATD_PO_<X>_STG` (CTAS WHERE 1=0), finals
  the Full tables, MERGE, freq 60, priority 1, members of `TXN_INCREMENTAL` (order 110/120/130).
  Seeded via python-oracledb on vm180 (MERGE-bearing).
- **Verified live:** one-shot runs SUCCESS — 14 / 19 / 28 last-24h rows staged and merged;
  every staged key present in final (NULL-safe join proven on the LINES composite); key
  uniqueness intact after merge (3,623 / 3,526 / 6,145 rows, all fully distinct on their keys);
  the hourly TXN_INCREMENTAL cadence picked all three up on its own in the same hour (a
  one-shot racing a worker claim shows a benign REQUEUED→SUCCESS pair in the run log).

## 2026-08-01 — PR Distributions Incremental (mirrors PR Lines Incremental; data-only, no script)

Hourly incremental for PR distributions, completing the PR family (Headers/Lines already had one).
Same recipe as every `* Incremental` job — record of the convention:

- **OTBI analysis:** created with `runner/copy_analysis.py` on a worker VM (one MFA):
  `--copy '/users/haghareb@dctabudhabi.ae/Data/PR/prod/03_PR_DISTRIBUTIONS/01_PR_DISTRIBUTIONS_F'
  --to '01_PR_DISTRIBUTIONS_UH24' --hour 24 --verify` → Save-As copy of the Full analysis +
  `Last Updated Date >= TIMESTAMPADD(SQL_TSI_HOUR,-24,CURRENT_TIMESTAMP)` filter, same folder,
  columns IDENTICAL to Full (so the Full job's column_map_json is copied VERBATIM onto the job row).
- **Job row (data-only, like all the other incrementals — no db/ script):** job
  `PR Distributions Incremental`, source_ref = the `_UH24` path, stage
  `PROD.ATD_PR_DISTRIBUTIONS_STG` (created as an empty structural copy of the final table:
  `CREATE TABLE … AS SELECT * … WHERE 1=0`), final `PROD.ATD_PR_DISTRIBUTIONS`,
  `load_mode='MERGE'`, `key_columns='DISTRIBUTION_ID'`, freq 60, priority 1, member of job set
  `TXN_INCREMENTAL` (Hourly Transaction Incrementals). Deployed via python-oracledb on vm180
  (MERGE-bearing).
- **Verified live:** run 8959 SUCCESS — 104 last-24h rows → stage, merged into final (9,538 rows,
  DISTRIBUTION_ID still unique, all 104 keys present). Direct one-shot run
  (`python runner.py 'PR Distributions Incremental'`) used for the break-window verification;
  scheduled runs ride the normal TXN_INCREMENTAL hourly cadence.

## 2026-07-27 — AR rebill pacing layer: ATD_AR_FAST condition waits (code shipped, knob OFF)

Latency work on `actions/ar_invoice_rebill.py` (~6-7 min/invoice, of which ~370s of ~445s was
literal `time.sleep()` and the FuseWelcome→Navigator→Billing renav (32s) was paid 4×/invoice).
**UiPath was evaluated and rejected**: the bottleneck is the same ADF UI and the same server
round-trips whatever tool drives the browser; switching would restart the 25 ADF selector laws,
add licensing/orchestrator infra, rebuild SSO/MFA session sharing, and discard the saga/
idempotency/queue integration. The fix is in our pacing:

- **`_pace(page, predicate, what, legacy, timeout=None)` + `ATD_AR_FAST` env knob.** Unset
  (default) → `time.sleep(legacy)` byte-identical to every live campaign (the predicate is never
  called); `=1` → `_wait_until` poll whose **timeout is NEVER below the legacy sleep**. Rollback =
  unset + restart. Conversion rule: each predicate is the exact condition the next line already
  depends on, expressed through an ALREADY-PROVEN reader (`_label_input_id`, `_read_label_value`,
  `_visible_id_by_suffix`, `_grid_rows`, `_dup_line_rows`) — no new selectors; every downstream
  guard (grid assert, drawer identity proof, `_valid_doc_number`, read-back verify) unchanged.
- 23 `_pace` sites: `_goto_billing` (9/4/2/15 → nav-link/nav-open/billing-entry/workarea-ready),
  `_open_search_panel`, post-Search grid wait, all six record-open 10s waits (predicate
  `_review_page_open(number)` = read-only Transaction Number matches AND the search INPUT is
  absent, so a mid-transition read of the still-mounted search form can't pass), Actions-menu
  (+ one re-click retry in fast mode), both 12s form waits, stage-3/9 dialog waits, split-menu
  wait, stage-7 Details-drawer wait (identity check stays the authority), Invoice-Lines tab waits.
- **NOT converted** (stale-read-back failure class): `_fill_by_id_suffix`/`_select_option`
  internals, post-fill 2s settles, `_reassert_header_dates` settle, `_dff_one_row` recovery
  sleeps, `_ensure_line_grid` internals — and the two **post-commit** sleeps (after the CM commit
  and after Complete and Review), deferred to a later PR to keep this diff commit-free.
- Stage 1 no longer renavs unconditionally: blank page → `_goto_billing`, else the panel-first
  self-healing ladder (`_search_transaction(page, invoice, base)`), same as stages 2/4/5.
- `diag_ar.py` gained the **`reviewnav`** screen (evidence for phase 2 nav-elimination: is there
  a Done button / Tasks magnifier on the record page that reaches the Billing search without the
  32s renav? `DIAG_AR_CLICK_DONE=1` second pass proves the search panel after Done). NOT RUN yet —
  user constraint 2026-07-27: no Fusion contact until go-ahead.
- Unit harness: `_test_ar_pacing` (early exit, timeout-returns-falsy, exception=not-yet, legacy
  path never calls the predicate and sleeps exactly N, timeout floor `max(1.5N, N+5)`); all pass.
- Fleet: handler + diag synced to vm180-182 (checksums match), **workers NOT restarted** (a
  restart nudges the Fusion session — off-limits under the same constraint) and `ATD_AR_FAST`
  unset everywhere, so live behavior is unchanged until the canary. Rollout plan (phase 2, each
  step needs user go-ahead): reviewnav evidence → dry-run A/B on an already-rebilled invoice
  (`ATD_ACTION_LIVE=0` walks everything but the commits with zero writes; saga stage timestamps
  give the A/B) → `ATD_AR_FAST=1` canary on ONE VM with a real batch → fleet-wide.
  Predicted: ~180s/invoice (~2.5×), fleet ~28-30 invoices/30 min.

## 2026-07-18 — Non-blocking invalid-date warnings (db/49, ATD 1.23.0)

- Invalid values in DATE/TIMESTAMP target columns now load as NULL without stopping
  the extract. The successful run message carries the total and up to 200 samples are
  stored in `PROD.ATD_LOAD_ROW_WARNING` with source row, target column, raw value,
  warning code, and reason.
- `GET /atd/runs/:id` returns `warningCount` + `warnings[]`; Run Details renders the
  warning table in EN/AR. Protected-route smoke returned 401 without a token as expected.
- PROD verification: warning table/9 columns present, exactly one GET handler on
  `atd.rest` `runs/:id`, zero invalid ATD objects.
- Runner/load sources synced to vm180/181/182; syntax clean, matching checksums, all
  services active. Partial web release `20260718000149-atd49` activated from the prior
  live release with only ATD files overlaid; served `APP_VERSION=1.23.0`.

## 2026-07-17 — Renewable extract-job leases and claim fencing (db/48)

- PROD `ATD_OTBI_JOBS` now carries `CLAIM_TOKEN` and `LEASE_EXPIRES_AT`.
  `ATD_QUEUE_PKG` renews leases and requires job + worker + token ownership for
  completion, failure, or release.
- `runner.py` renews an active lease from a separate DB session while a long
  OTBI/BIP download or database load blocks the main worker thread.
- Coordinated rollout completed on vm180/181/182. Package spec/body are VALID,
  both columns are present, runner checksums match, and all workers are active/IDLE.
- The legacy claim overload remains temporarily for rolling-deploy compatibility;
  all production workers now use the token overload.

## 2026-07-16 — PR/PO Pending Approval extract: FIRST BIP (.xdo/xmlpserver) job (db/47 + runner bip.py)

New daily snapshot of every PR + PO in **PENDING APPROVAL** status, from the BI Publisher report
`ADG Document Status Report` (NOT an OTBI analysis — this introduced first-class **BIP report
support** in the Track B runner).

- **Target:** `PROD.ATD_PR_PO_PENDING_APPROVAL` (8 report columns + `load_ts`), full refresh
  (`TRUNCATE_INSERT`) — the table always holds the CURRENT pending list; approved/rejected
  documents drop out on the next run.
- **Job:** `PR PO Pending Approval` (env `FUSION_ADGOV`, `output_format='xlsx'`,
  `source_ref='/Custom/ADGE Procurement Reports/Purchasing/ADG Document Status Report.xdo'`).
  Params in `params_json`: `_xt` (template), `_paramsP_BU=*`, `_paramsP_DOCTYPE=["REQUISITION","STANDARD"]`
  (a JSON ARRAY repeats the URL key — BIP multi-select), `_paramsP_STATUS=PENDING APPROVAL`, and the
  runner directive `_atd_require="Document Number"` (rows without a Document Number are excluded;
  banner/blank rows always are). Column map keeps ONLY the 8 wanted report columns.
- **Schedule:** job set `PRPO_PENDING` — daily window **06:30–08:30 Asia/Dubai**, freq 1440
  (+ job `frequency_minutes=1440`); category tag `PO`. NOTE the fleet **break window ends 08:00**,
  so in practice the run lands 08:00–08:30. History = the normal `ATD_LOAD_RUN_LOG` / Run Logs page.
- **DB deploy:** `db/47_atd_pr_po_pending.sql` — **MERGE-bearing → deployed via python-oracledb on
  vm180** (Linux SQLcl swallows MERGE blocks), verified: table + job + set + member + category all in.
- **Runner (`bip.py` NEW + `extract.py`/`runner.py`/`config.py` touched, `openpyxl` added):**
  a `source_ref` ending `.xdo` routes to `bip.download_csv`: fetch
  `{xmlpserver}/<path>.xdo?_xpt=1&_xf=xlsx&_xautorun=true&_paramsP_*=…` via the warm session
  cookies (**`_xpt=1` returns the document itself — no viewer, no 'Apply' click**), convert
  XLSX→CSV (openpyxl; header row auto-detected below BIP's title/banner rows; headers matched
  case-insensitively but emitted under the column-map's own key text so `resolve_pairs` hits),
  then the UNCHANGED prepare/load pipeline runs. Job selects now also fetch
  `output_format`/`xmlpserver_base_url`. Unit tests `runner/tests/test_bip.py` (7/7).
- **Why the converter projects mapped columns only:** prepare's drift engine ADDs any unmapped
  CSV column to the table — emitting only the mapped headers is what enforces "extract only these
  columns" AND keeps drift quiet if the report gains columns.
- **SSO gotcha (protects every future .xdo job):** the FIRST xmlpserver touch of a session can
  bounce to sign-in even with live cookies — the IDCS/Entra hop needs a JS auto-post that
  `ctx.request` can't run. `bip.download_bytes` primes once via a real `page.goto(xmlpserver)/`
  then retries before raising SessionExpired (which still triggers the worker's normal
  re-auth+retry). Error triage mirrors the Go-URL: HTML while still on /xmlpserver = ReportError
  (bad path/params — re-auth won't help); bounced off = SessionExpired.
- **Fleet rollout:** bip/extract/runner/config/requirements + `pip install openpyxl` synced to
  vm180/181/182, `systemctl restart atd-worker` — all three active clean.
- **FIRST LIVE RUN — SUCCESS (2026-07-16 ~02:20 Dubai, 1,060 rows = 916 REQUISITION + 144
  STANDARD; zero null/duplicate Document Numbers).** One finding: the BIP template exports
  `Submitted for Approval Date` as **text `DD-MM-YYYY`** (`14-07-2026`), which the loader's
  date formats didn't know → run 1 warned (drift: "column is DATE … load may fail") and loaded
  the dates NULL. The user resolved it live by altering the column to **VARCHAR2(20)** (kept as
  verbatim text — user decision; db/47 updated to match) and re-running clean. The runner ALSO
  gained the day-first `%d-%m-%Y` format (load.DATE_FORMATS + prepare.DATE_RE), so a FUTURE BIP
  job with such dates auto-types/parses to real DATE from run 1. NOTE: the legacy SQLcl loadsql
  path still emits only ISO TO_DATE — fleet is oracledb, so not extended.

## 2026-07-01 — Run Logs: Job Set column + filter (App 208, APP_VERSION 1.19.0)

Make the global **Run Logs** page set-aware so operators can see which Job Set a run's job
belongs to and filter the log by set (the per-set Run History on the Job Set Detail page still
exists; this adds visibility from the main log). Additive & backward-compatible.

- **ORDS — `db/42_atd_runs_set_ords.sql` (new, ADDITIVE — no DELETE_MODULE):** REDEFINES the
  `GET /runs` + `GET /runs/export` handlers to `LEFT JOIN atd_job_set_member → atd_job_set`
  (a job is in ≤1 set → PK `job_name`, so no row fan-out), adding `setCode`/`setName` to each
  run row + a `jobSet` CSV column, and accepting a `?setcode=` filter. Times stay `dct_to_local`.
- **Deploy:** run `db/42` in a **FRESH SQLcl session** (synonym rule). It upserts only those two
  handlers — job-sets/actions/etc. untouched. **NOTE:** because `13_atd_ords.sql` DELETE_MODULEs
  and rebuilds `atd.rest` with the plain (no-set) `/runs` handlers, **always re-run `42` after `13`**
  (same rule as `20_atd_action_ords.sql` for Actions). Header note added to `13`.
- **Frontend (`final apps/ATD/Jet/`, APP_VERSION 1.19.0):** `runs.html` gains a **Job Set** column
  (region-themed `.badge`, `—` when the job is in no set) + a **Job Set** filter `<select>` in the
  toolbar; `runs.js` loads the set list via `listJobSets()`, passes `setcode`, and persists the
  filter (filterStore). `atd.col.jobSet` / `atd.runs.allSets` added to EN + AR i18n.
- **Verification:** deployed VALID (both handlers registered). Playwright E2E **9/9 PASS** against
  the live `FULL_DATA` set — column header, per-row set badges, populated filter dropdown, filter
  returns only that set's rows (20/20 tagged), AR/RTL header, and `GET /runs?setcode=` API
  (100 rows all tagged & members). Non-destructive (no data created/deleted).
- **Gotcha:** SPA route switching in tests — `page.goto('/index.html#runs')` does NOT reload the
  app (hash-only change), so the route never switches; use `page.evaluate("window._jetApp.navigate('runs')")`
  (or click the nav link) instead.

## 2026-07-01 — Manage Job Sets: grouped scheduling (App 208, APP_VERSION 1.18.0)

Group jobs under **one shared schedule** so the operator can schedule / pause / run a *batch*
together instead of editing every job's frequency + enabled flag one by one. Fully additive and
**backward-compatible** — a job in no set behaves exactly as before.

- **What it does.** A **Job Set** = a run interval + an active window (Start/End dates, optional
  daily HH:MI mask + day-of-week mask, all **local Asia/Dubai**) + per-member enable/disable +
  notify-on-failure. It drives the LIVE browser track: the 15-min `enqueue` (db/12) only marks a
  member `READY` while its set says "go now" (`atd_set_gate_ok`) and re-runs it on the set's
  interval (`atd_set_eff_freq`). Plus **Run Set Now**, **Pause/Resume**, **≈ next-run** preview per
  member, **set-scoped run history**, and **failure notifications** (DCT_NOTIFY → SYS_ADMINs).
- **DB — `db/40_atd_job_set.sql` (new):** `ATD_JOB_SET` + `ATD_JOB_SET_MEMBER` (**PK `(job_name)`**
  enforces *one set per job*), SQL-callable `atd_set_gate_ok` / `atd_set_eff_freq` / `atd_set_next_run`,
  `ATD_SET_PKG` (`run_now` + `notify_sweep`), `ATD_SET_NOTIFY_JOB` (5-min sweep), config
  `ATD_SET_NOTIFY_ENABLED` (Y/N, default **N**) + `ATD_SET_NOTIFY_WATERMARK`, ADMIN synonyms.
- **DB — `db/12_atd_job_queue.sql` (2-token enqueue edit):** on the scheduled bulk path only,
  `AND (p_only IS NOT NULL OR prod.atd_set_gate_ok(j.job_name)='Y')` + the frequency NVL now wraps
  `prod.atd_set_eff_freq(j.job_name, j.frequency_minutes)`. Manual single-job enqueue (`p_only`)
  bypasses the gate (operator override, like the break window).
- **ORDS — `db/41_atd_job_set_ords.sql` (new, ADDITIVE — no DELETE_MODULE):** 11 handlers on
  `atd.rest` — `/job-sets` (GET/POST), `/job-sets/:code` (GET/PUT/DELETE), `/job-sets/:code/members`
  (POST), `/job-sets/:code/members/:job` (PUT/DELETE), `/job-sets/:code/run` (POST),
  `/job-sets/:code/pause` (PUT), `/job-set-jobs` (GET candidate picker). SYS_ADMIN-gated.
- **Deploy order (idempotent):** run **`40` first**, then **re-run `12`** (picks up the enqueue edit;
  db/12 references the db/40 wrappers, so 12 is INVALID until 40 runs — auto-revalidates), then
  **`41` in a FRESH SQLcl session** (synonyms). Verify all objects VALID + `ATD_SET_NOTIFY_JOB`
  scheduled. **No runner change** (the queue pkg isn't ORDS; the runner drains READY as always).
- **Gotchas hit & fixed:**
  - **PLS-00231 (`function 'PTS' may not be used in SQL`)** — the create/update handlers first used
    a nested `pts()` function inside the INSERT/UPDATE; a locally-declared PL/SQL function can't be
    called from SQL DML (→ ORDS returned **HTTP 555**, a fresh-compile failure of the stored block, NOT
    a caught runtime 500). Fixed by inlining the parse as a pure SQL expression
    `TO_TIMESTAMP(REPLACE(SUBSTR(APEX_JSON.get_varchar2(...),1,16),'T',' '),'YYYY-MM-DD HH24:MI')`.
  - **ORA-12860 on `DELETE FROM atd_job_set` in SQLcl** (auto parallel-DML sibling-lock via the
    ON DELETE CASCADE chain) — a SQLcl-session artifact only; the ORDS DELETE handler runs serially
    (like the existing `/jobs/:name` cascade delete) and is fine. For manual cleanup:
    `ALTER SESSION DISABLE PARALLEL DML;` first.
  - Re-running `db/12` ends with `UPDATE atd_otbi_jobs SET run_status='READY' WHERE enabled='Y'`
    (its documented reset) — deploy during a quiet window / worker idle.
- **Frontend (`final apps/ATD/Jet/`, APP_VERSION 1.18.0):** new nav item **Job Sets** (Operations),
  `jobSets` list + `jobSetDetail` pages (shared `<edit-drawer>` create/edit with interval presets +
  day chips + datetime/time windows; `.data-table` member manager with per-row enable toggle + order
  + ≈ next-run; set-scoped run history; Run/Pause/Delete). `atdService` set methods; EN+AR i18n
  (`atd.set.*`/`atd.nav.jobSets`/`atd.day.*`); no bespoke CSS (platform classes only).
- **Full E2E — Playwright, SYS_ADMIN, 11/11 PASS (self-cleaned):** login → create set (DAILY) →
  add member → toggle in-set → **Run Set Now** (worker actually ran AP Distributions Full, 23,555
  rows SUCCESS, appeared in set-scoped history) → Pause → Edit drawer → Arabic RTL → Delete. Every
  ORDS call returned 200. PL/SQL smoke separately verified the gate (in-window Y, paused/out-of-window/
  disabled N), eff_freq (set-over-job), and run_now.

## 2026-06-29 — MERGE load mode: staging-clear fix + GRN incremental-upsert runbook

### Runner fix (`runner/load.py`) — REQUIRED before any MERGE job is used
The oracledb loader only cleared the staging table for `TRUNCATE_INSERT`; in `MERGE` mode it
re-inserted each extract on top of the previous run's rows. On the **2nd run** a re-extracted key
then appeared twice in the merge source → `ORA-30926 "unable to get a stable set of rows in the
source tables"`, and the staging table grew unbounded. Fix: the staging `DELETE` is now
**unconditional** (both modes) so staging always holds *only* the current extract; behaviour for
`TRUNCATE_INSERT` is unchanged (stage IS the destination → atomic replace). Also added a guard that
raises a clear error if a MERGE job is misconfigured with `stage_table == final_table`.
**Deploy:** copy `runner/load.py` to all worker VMs + `systemctl restart atd-worker`. (SQLcl-mode
`loadsql.py` still rejects MERGE with `NotImplementedError` — prod runs oracledb, so MERGE works.)

### How MERGE mode works (for the Edit Job form)
A MERGE job uses **two** tables. **Target Table** (`stage_table`) is the scratch landing zone the
fresh OTBI extract loads into each run; **Final Table (MERGE)** (`final_table`) is the persistent
base table you query. After staging loads, the runner runs
`MERGE INTO final USING stage ON (key_columns)` — updating matched rows, inserting new ones. Stage
and final **must be different tables**, and **`key_columns` must be UNIQUE per row in a single
extract** or the merge fails with ORA-30926. Neither table needs pre-creating — `prepare.py` builds
both from the live CSV on first run (and ALTERs both on schema drift).

### GRN incremental conversion (GRN Updates 10Min → MERGE) — PENDING a unique key
There are 3 GRN jobs sharing staging `PROD.ATD_GRN`: **GRN Full** (`GRN_ALL_F`, daily, real map),
**GRN Hourly** (`GRN_ALL_UH`, 60 min), **GRN Updates 10Min** (`GRN_ALL_U10M`, 10 min, currently
disabled). The plan: keep **staging = `ATD_GRN`**, MERGE into **base = `GRN`**.

**Blocker:** the GRN extract is accounting-line-level and has **no unique key** — `TRANSACTION_ID`
yields only 2,802 distinct of 6,943 rows (up to 5 lines/txn: Dr/Cr signs, multiple CC_IDs); even a
5-column composite (`TXN+CC+SIGN+GL_BATCH+LEDGER_AMOUNT`) still leaves 16 collisions. MERGE needs a
truly unique key. **Decision (2026-06-29): add a true accounting-line unique id to the OTBI
analysis** (e.g. the receipt-accounting distribution id, or XLA `AE_HEADER_ID`+`AE_LINE_NUM` / GL
link id). Add it to `GRN_ALL_U10M` (ideally all three, so the shared `ATD_GRN`/`GRN` carry it
consistently); the runner auto-adds the new column on the next run via schema-drift handling.

**Once the analysis emits the unique id column (call it `<KEY_COL>`):**
1. (One-time) Seed/own the base table `GRN`. Options: make **GRN Full** also write the base — either
   MERGE Full into `GRN` on `<KEY_COL>` (daily full upsert) or TRUNCATE_INSERT Full directly into
   `GRN` (daily full rebuild) — or seed `GRN` once from `ATD_GRN` then let increments maintain it.
2. Drop the stray junk column once no job's column map references it:
   `ALTER TABLE prod.atd_grn DROP COLUMN the_query_resulted_in_no_r;`
3. Reconfigure GRN Updates 10Min:
   ```sql
   UPDATE prod.atd_otbi_jobs
      SET load_mode='MERGE', stage_table='PROD.ATD_GRN', final_table='PROD.GRN',
          key_columns='<KEY_COL>', column_map_json=NULL, updated_at=SYSTIMESTAMP
    WHERE job_name='GRN Updates 10Min';
   COMMIT;
   ```
   (Set `column_map_json=NULL` only if the analysis structure changed, to force a clean re-profile.)
4. Verify: enable + run it **twice**. Both SUCCESS; staging row count = latest extract (not growing);
   `GRN` reflects upserts (changed rows updated in place, only new keys add rows). Confirm
   `SELECT <KEY_COL>, COUNT(*) FROM prod.grn GROUP BY <KEY_COL> HAVING COUNT(*)>1` returns nothing.

## 2026-06-27 — Fusion session auto-heal: keep-alive + cross-worker failover (App 208, APP_VERSION 1.15.3)

The recurring "session expired mid-run" failure (Fusion SSO/MFA session dies between sparse
jobs or at its absolute lifetime) is now largely self-healing — two layers on top of the
existing once-daily relogin + aging nudge:

- **Tier 1 — keep-alive (prevention).** An idle `--forever` worker pings its warm Fusion
  session every `ATD_SESSION_KEEPALIVE_MIN` min (**default 3** — comfortably under any OBIEE
  idle timeout) via the cheap `auth._validate` GET, which resets OBIEE's idle timer (no MFA).
  A live session never idle-expires between jobs. A ping that fails for `ATD_KEEPALIVE_STRIKES`
  **consecutive** tries (default 2 — a 2-strike guard so a transient network blip doesn't trigger
  a needless MFA) marks the session dead → pauses claiming + self-heals via a **rate-limited
  forced re-login** (one MFA, gated by `ATD_REAUTH_COOLDOWN`).
- **Tier 2 — cross-worker failover (resilience).** A mid-run session bounce is logged
  **`REQUEUED`** (neutral, not `FAILED` → no chronic-fail alert) and the job is **released back
  to the queue** (`atd_queue_pkg.release_job`) for a peer with a healthy session — instead of
  being consumed as FAILED. The bouncing worker pauses claiming until it re-auths. Budget
  `ATD_REQUEUE_MAX` (default 6) cross-worker bounces/60 min, then the job is marked FAILED so a
  genuinely stuck job still surfaces.
- **Unavoidable:** the *first* recovery after every session death still needs **one Telegram MFA
  approval** (SSO is MFA-gated) — but only one, and keep-alive then holds the session open.
- **DB:** `db/12` (+ `release_job` in `atd_queue_pkg`, recompiled VALID — additive, backward-
  compatible with the old runner) + `db/35` (MERGE-seed `ATD_SESSION_KEEPALIVE_MIN` +
  `ATD_REQUEUE_MAX`, UI-editable on Runner Settings; also added to `db/14` for fresh installs).
  No ORDS rebuild needed (queue pkg isn't ORDS).
- **Runner — DEPLOYED to all 3 VMs 2026-06-27:** `runner.py` only (keep-alive block, `_relogin`
  + `_recent_requeues` helpers, session-bounce → REQUEUED/release, claim gating on a dead
  session). scp + `systemctl restart atd-worker`; all `active`, `[config] applied 25 runner
  settings` (was 23 → the 2 new keys load).
- **Frontend:** neutral `REQUEUED` status pill (`app.css` `.rstat--REQUEUED`, ↻) + REQUEUED/HELD
  added to the Run Logs status filter. APP_VERSION 1.15.3.

### 2026-06-28 — job sub-categories + remembered filters with Search/Clear (APP_VERSION 1.16.0)
- **Sub-categories (hierarchical categories):** `db/36` adds `ATD_JOB_CATEGORY.parent_code`
  (self-FK + "not its own parent" CHECK + index). A category with `parent_code = NULL` is top-level
  (Purchasing); one with a parent is a SUB-category (PO/PR/REC). `db/32` `/categories` GET/POST/PUT
  now carry `parentCode`/`parentName`; DELETE also blocks a parent that still has children. `db/13`
  `/jobs` category filter now **includes children** (selecting a parent matches jobs tagged to it OR
  any of its sub-categories). **Redeploy chain: `36 → 13 → 20 → 26 → 31 → 32 → 33`** (13 rebuilds the
  module). Existing 6 categories stay top-level; create sub-categories in **Manage Categories** (new
  **Parent** dropdown + column). Jobs/Queue filter bars gain a **Sub-category** dropdown that appears
  once the chosen category has children.
- **Remembered filters + Search/Clear (UX):** new `js/util/filterStore.js` persists each page's filter
  criteria in `localStorage` (key `atd.filters.<page>`) and restores them on load — fixing "criteria
  reset on browser refresh". Added a **Search** button (apply/refresh) + **Clear** button (reset all)
  to **Jobs**, **Run Logs**, and **Queue** (Queue also gained search + status + category filters it
  didn't have). Filters still apply live as you change them; the buttons are explicit apply/reset.
- **Frontend only for the UX part** (jobs/runs/queue VMs+views, filterStore, i18n `atd.cat.allSub`/
  `atd.cat.parent`/`atd.cat.parentNone`/`atd.filter.search`/`atd.filter.clear`, EN+AR). APP_VERSION 1.16.0.

### 2026-06-28 — schema-editor remove-column + download timeout + cookie scrubbing (APP_VERSION 1.15.6)
- **Schema editor "remove column" (✕):** each row in the Table Schema editor now has a ✕ that drops
  the column from the list (`jobDetail.removeCol`); it's removed from the table only on **Apply**
  (recreate from the remaining cols; Reload restores). For leftover columns the analysis no longer
  returns (the runner keeps dropped columns loading NULL — never auto-drops). Frontend only.
- **(b) CSV download timeout configurable (`extract.py`):** the hard-coded 180 s Go-URL download
  timeout is now `ATD_DOWNLOAD_TIMEOUT_SEC` (default **300**, Runner Settings editable) — raise it for
  large/slow reports (was the cause of the AP Invoice Lines "Timeout 180000ms exceeded" FAILED).
- **(c) secret scrubbing (`checks.scrub`):** a failed Go-URL download's Playwright error dumps the
  full request incl. the `cookie:` header (live JSESSIONID / ORA_OCIS_CG_SESSION / _WL_AUTHCOOKIE —
  replayable). All run-log writers now scrub cookie/auth/Bearer values to `[redacted]` before storing
  (`runner._log_end` + `_log_orphan`, `loadsql.log_failure` + `log_held`). Verified on the real leaked
  message — tokens gone, useful text kept.
- **DB:** `db/35` MERGE + `db/14` add `ATD_DOWNLOAD_TIMEOUT_SEC`. **Runner — all 3 VMs 2026-06-28:**
  `checks.py`/`extract.py`/`runner.py`/`loadsql.py` + restart (`applied 27 runner settings`).

### 2026-06-27 follow-up — pre-run auth gap + Queue wording (APP_VERSION 1.15.4)
- **Bug closed (`runner.py`, all 3 VMs):** the Tier 2 failover only covered a session death
  *inside* a run. A login failure **before** the run (opening the session for a claimed job — MFA
  timeout, or a session dead at its absolute lifetime) escaped the loop, **crashed the worker, and
  left the job orphaned in `CLAIMED`** with no run-log row until the 30-min reap (hit live: GL_ACCOUNTS_
  COMBINATIONS, claimed by vm182 09:24, no run row; auto-recovered at the reap → vm181 ran it SUCCESS
  9 338 rows 09:55). Now the pre-run `auth.authenticate()` is wrapped: on failure it marks the host
  session dead, writes a visible `REQUEUED` (or `FAILED` past `ATD_REQUEUE_MAX`) run-log row via the
  new `_log_orphan`, and **releases the job to a healthy peer** (`release_job`) instead of crashing.
- **UI wording:** Queue page **"Reap Stale" → "Recover Stuck"** + the lease box **"Lease (min)" →
  "Stuck after (min)"**, both with explanatory tooltips (`atd.queue.reap.hint` / `atd.queue.lease.hint`,
  EN+AR). No behaviour change — clearer label for returning stuck `CLAIMED` jobs to the queue.

## 2026-06-27 — Unlabelled-OTBI-column fix + editable source header (App 208, APP_VERSION 1.15.1)

OTBI sometimes exports a column with **no heading**. The column map was keyed by header, so
every blank header collapsed onto one `''` key — all but the last vanished from the map (→ blank
"Source header" in the schema editor, re-added as drift every run) and the unlabelled columns
**did not load their data** (the loaders matched map-key → CSV header, and `''` matched at most one).

- **Fix (runner):** unlabelled columns now key by a **positional sentinel** `#__blankcol_<1-based CSV pos>__`
  — distinct per column and stable across runs (survives renames). New `prepare.map_key` /
  `is_blank_key` / `blank_key_pos` / **`resolve_pairs`** (shared); `column_map`, `_plan_drift`,
  `_drift_warnings` use it. Both loaders (`load.py` `_parse_csv`, `loadsql.py` `_parse`) switched to a
  **positional CSV reader** so blank-header columns load by position. Real-header jobs are byte-for-byte
  unaffected (no blank keys → new branch never fires). Verified locally: 2-blank-header CSV → all cols
  distinct, load positionally, re-run drift is a no-op (no re-add loop), rename survives re-runs.
- **Fix (ORDS apply handler, `db/13` POST `/jobs/:name/schema`):** **no longer drops** a column whose
  source header is blank — stores it under the positional sentinel (was `IF l_hdr IS NOT NULL` → skip).
- **Editable source header (frontend):** the schema editor's "Source header" is now an editable input
  (placeholder *"(unnamed in OTBI — type a header)"*); sentinel keys render blank; a typed header is
  saved into the map on Apply. `jobDetail.js` (`isBlankKey`, `header` → observable), `jobDetail.html`,
  EN/AR `atd.schema.unnamedHdr`.
- **DB redeploy (one fresh SQLcl session):** `13 → 20 → 26 → 31 → 32 → 33` (13 `DELETE_MODULE`s
  `atd.rest`, so additive scripts follow; 33 last re-adds approve-schema). All `PL/SQL procedure
  successfully completed`, no ORA-/PLS-.
- **Runner — DEPLOYED to all 3 VMs 2026-06-27:** `prepare.py`, `load.py`, `loadsql.py` scp'd to
  `/root/otbi-atd/runner/` on atd-vm180 (canary, verified clean startup) then 181/182; `ast.parse`
  syntax-check + `systemctl restart atd-worker` (all `active`, `[config] applied … settings`, clean).
- **Note for users:** to get a heading shown (and to make a column self-describing), set a *Custom
  Heading* on the column in the OTBI analysis; otherwise type one in the schema editor. Either way the
  data now loads.

## 2026-06-26 — Existing-target-table fix + schema-review gate (App 208, APP_VERSION 1.14.0)

Two linked changes to job create/update.
- **Bug fixed — entering an already-existing target table "went wrong":** on first run the runner
  reused the existing table but derived the column map *from the CSV* as if it were fresh, so a
  shared/peer table (the 10-min / hourly / daily jobs on one analysis) or a customised table could
  fail to load. `prepare.ensure_prepared_oracledb` now **reconciles to the existing table**
  (`_reconcile_existing`: ADD genuinely-new columns, widen outgrown text) instead of assuming a new
  one. Shared target tables are **intentional and allowed** — no blocking.
- **Schema-review gate (`db/33`):** `ATD_OTBI_JOBS.schema_reviewed CHAR(1) DEFAULT 'Y'`. A
  **"Hold for schema review"** checkbox on the form, and **auto-hold when the target table already
  exists**, set it to `'N'`. The worker then **prepares** the table+map but **HOLDS before loading**
  (run-log status `HELD`) until approved via **`POST /jobs/:name/approve-schema`** (job-detail
  "Approve schema"). `db/12 enqueue` skips a held job once it is prepared (no repeated HELD); resumes
  on approval. Existing jobs default `'Y'` → no behaviour change.
- **DB:** `db/33` (column + approve endpoint, additive) + `db/12` (enqueue guard) + `db/13`
  (create/PUT `holdForReview` + table-exists auto-hold, GET returns `schemaReviewed`). Redeploy ran
  **`33 → 12 → 13 → 20 → 26 → 31 → 32 → 33`** (33 last to re-add the endpoint after the 13 rebuild).
- **Runner — DEPLOYED to all 3 VMs 2026-06-26:** `prepare.py` (reconcile), `runner.py` (HELD gate,
  both paths), `config.py` (selects `schema_reviewed`), `loadsql.py` (`log_held`). scp'd to
  `/root/otbi-atd/runner/` on atd-vm180/181/182 + `systemctl restart atd-worker` (all `active`,
  clean startup, no SQL errors). No MFA needed at restart — all jobs were disabled so the workers
  stayed idle; each re-auths (one MFA) on its next real job claim.
- **Frontend:** hold checkbox + "Review" badge (jobs), approve button + notice (jobDetail),
  `atdService.approveSchema`, EN/AR i18n, `app.css` `.review-*`.


## 2026-06-26 — Job Categories (ATD App 208, APP_VERSION 1.13.0)

Tag jobs with any number of **categories** (ATD-native lookup) to simplify job management.
- **DB (`db/32_atd_job_category.sql`, additive):** `ATD_JOB_CATEGORY` (code, EN/AR name, color,
  order, active) + `ATD_JOB_CATEGORY_MAP` (`(job_name,category_code)` PK — no per-job cap; FK
  `job_name` ON DELETE CASCADE). Seeds 6 starters (AP/GL/PO/SUPPLIER/MASTER/FINANCE). **No max-3
  cap** (the PK alone prevents duplicate tags). Additive ORDS: `GET/POST /atd/categories`,
  `PUT/DELETE /atd/categories/:code` (DELETE blocked while in use → deactivate).
  **Deploy with `-Dfile.encoding=UTF-8`** for the Arabic seed (verified bytes ≈ 2× chars, no
  mojibake).
- **`db/13` (jobs handlers, triggers a rebuild):** list returns `categories[]` per job +
  **`?category=CODE` filter**; `GET /jobs/:name` returns `categories[]`; `POST`/`PUT` accept
  `categories:[codes]` (PUT = replace-set). **Redeploy ran `13 → 20 → 26 → 31 → 32`** (32 is
  additive and must follow any 13 rebuild — the chain is now five scripts). Verified all 12 handlers
  registered; tag round-trip + filter + PK-dup-block + delete-in-use guard all pass.
- **Frontend:** Jobs list Category column + filter + **Manage Categories** right-edge **drawer**
  (shared `.ed-*` chrome, New/Close/Save in the header — APP_VERSION **1.13.1**); drawer category
  picker on the job form (toggle chips, no cap); jobDetail chips. Colored EN/AR chips. `atdService`
  category CRUD; `app.css` `.cat-chip*`/`.cat-swatch`; EN/AR i18n.
- **Live browser smoke test PASSED 11/11** (Playwright, SYS_ADMIN): create/edit/delete category,
  tag/untag a job, list Category column + chips, category filter, drawer header actions, Arabic RTL
  in the drawer — all verified end-to-end (UI→ORDS→DB), test self-cleaned (no prod residue).

## 2026-06-26 — Unqualified stage table → ORA-00942 (blank source headers)

- **Symptom:** a new job (AP_INVOICES_F) showed every SOURCE HEADER blank on the schema-review
  page. Root cause: the user typed the stage table as `ATD_AP_INVOICES` (no schema prefix) in the
  create form, and it was stored verbatim. The runner connects as **ADMIN**, so the bare name
  resolved to `ADMIN.ATD_AP_INVOICES` → every run failed `ORA-00942` in prepare/reconcile →
  `column_map_json` never persisted → no headers. (Minimal-create jobs auto-get `PROD.`; only a
  user-typed bare name hit this.)
- **Fixes:**
  - Data: `UPDATE atd_otbi_jobs SET stage_table='PROD.ATD_AP_INVOICES'` for the affected job, and
    reset it to READY (audited all jobs — no other unqualified stage/final names).
  - Runner (`prepare.py`, deployed to all 3 VMs + restart): new `qualify(table)` defaults any
    UNqualified staging/final table name to `PROD.<name>` in both prepare paths (create + drift,
    oracledb + sqlcl); the qualified name is persisted back, so the stored value self-heals on the
    first prepare. Compile-verified on each VM; all `active`.
  - Frontend (committed): the job-detail review banner now distinguishes prepared vs not — a held
    job with an empty map reads "Not prepared yet …" instead of falsely claiming "prepared".
- **Note:** the stale-RUNNING reaper (`_reap_stale_runs`) was already deployed on all 3 VMs and is
  working; run 1456 ended on the real ORA-00942, not as a reaped orphan (correct behaviour).

## 2026-06-26 — Dashboard scoped to real job loads

- **Recent Runs / Alerts / 24h KPIs showed phantom rows for deleted jobs (db/13, redeployed).**
  These dashboard panels read `atd_load_run_log` with no track filter, so after the orphan sweep
  the 69 leftover **DISCOVER** rows (subject-area names, not jobs) surfaced as fake "jobs". Scoped
  the dashboard handler: `runs24h`/`success24h`/`lastFinished` now count only `track IN
  ('API','BROWSER')`; the **recent** + **alerts** cursors additionally require the job to still
  exist (`EXISTS atd_otbi_jobs`). Verified live with 0 jobs: jobs/runs24h/recent/alerts all 0,
  successRate `—`. Full 13-chain re-run (13→20→26→31→32→33); regression-checked jobs/health,
  actions/stats, categories, workers all 200.

## 2026-06-26 — Job→log cascade + dev-proxy no-cache

- **Orphaned run-logs (db/34, DEPLOYED):** run-log rows had no link to their job, so deleting a
  job left its load history behind. New row trigger `prod.trg_atd_job_log_cascade`
  (AFTER DELETE on `atd_otbi_jobs`) clears that job's load rows (track API/BROWSER) on any delete
  path (ORDS/SQLcl). DISCOVER rows are keyed by subject area, not a job, so they are preserved.
  One-time sweep removed **1369** already-orphaned load rows (verified: 0 load-orphans left,
  69 DISCOVER rows kept, trigger ENABLED). No FK added (a hard FK would break DISCOVER inserts).
  Independent of the 13-chain (no ORDS).
- **Blank-page-after-deploy fix (dev-proxy.py, all 9 apps):** the dev-proxy served static assets
  with **no `Cache-Control`**, so the browser cached `index.html`; after rapid APP_VERSION bumps a
  stale `index.html` kept re-requesting old-versioned (cached) JS → blank page. Added an
  `end_headers` override emitting `Cache-Control: no-store, must-revalidate` for non-`/ords/`
  responses. Verified header now served. (One-time remedy for an already-stale browser: hard
  refresh / Ctrl+Shift+R.)

## 2026-06-25/26 — Production-workload hardening (Phases 0–2) + Track A spike

Driven by a run-log review (multi-hour overnight dead windows; a moved-path job blind for
~2 days; orphaned RUNNING rows stuck 4–6 days). All new behaviour is **config-gated** in
`ATD_RUNNER_CONFIG` (Runner Settings page) so each piece is independently toggleable.

- **Phase 0 — data quality (commit 486a098):** `prepare.py` date detection now wins over the
  numeric-name hint (fixed `BUDGET_DATE` → was NUMBER; remediated live via ALTER), date-name
  awareness, TIMESTAMP + ISO-`T`/fractional support; blank header → `COL_<pos>`. `load.py`
  DATE_FORMATS broadened. `PO_HEADERS.SUBMIT_DATE` (VARCHAR2, job disabled) corrects on its next
  Rebuild.
- **Phase 1 — reliability (commit 3b9b3fa):** stale-RUNNING reaper (`ATD_RUN_REAP_MINUTES`, closed
  the 2 orphans); proactive session mgmt (`ATD_WORKER_HEARTBEAT.session_started`, `ATD_DAILY_RELOGIN`
  job at 06:00 Asia/Dubai gated by `ATD_AUTO_RELOGIN`, aging nudge `ATD_SESSION_WARN_HOURS`+
  `ATD_AGING_MSG`); chronic-failure alert (`fail_alert_sent`, `ATD_FAIL_ALERT_STREAK`,
  `ATD_FAIL_ALERT_MSG`); Break window (`db/30 prod.atd_in_break` + `ATD_BREAK_ENABLED/START/END`,
  enforced in `enqueue` + worker idle loop, seeded DISABLED 20:00–06:00, midnight-wrap aware).
  DB 27/28/30 + db/12; runner.py.
- **Phase 2.1 — per-job scheduling (commit 2ed3b11):** `ATD_OTBI_JOBS.frequency_minutes` (NULL →
  `ATD_DEFAULT_FREQ_MINUTES`=15); `enqueue` only (re)queues a DUE job. db/29 + db/12.
- **Phase 2.2 — observability + frequency UI (2026-06-26, APP_VERSION 1.12.0):** additive ORDS
  **`GET /atd/jobs/health`** (`db/31`, no module rebuild needed by itself) returns break-window
  status + per-VM session age + per-job freshness. Dashboard gains a **Break-window banner**, a
  **Session Age** column on the Worker Fleet (amber past ~7h), and a **Job Freshness** card
  (last success / since / consecutive fails / stuck / frequency). The job form (+ jobDetail) gains a
  **Frequency (min)** field — persisted via the core `/jobs` POST + `/jobs/:name` PUT/GET in `db/13`,
  so this redeploy **rebuilt `atd.rest`**: ran **13 → 20 → 26 → 31** in order (20/26/31 are additive
  and must follow any `db/13` rebuild). Verified: all 8 handlers registered (incl. `jobs/health`,
  `workers/:id/refresh`, `actions/stats`); `frequencyMinutes` round-trips through create/update/get;
  `jobs/health` queries run clean (workers vm180/181 showed ~9h sessions — exactly what the new
  Session Age column surfaces). **No runner change.** Frontend: dashboard/jobs/jobDetail views+VMs,
  `atdService.getJobHealth`, EN/AR i18n.
- **Track A (BIP) spike — NO MFA wall, BUT current credential REJECTED by BIP (2026-06-26, zeep on vm180).**
  Ran a real `zeep` 4.3.2 spike against the BIP web services. Findings, in order:
    1. **No MFA / no Entra redirect** on any BIP SOAP endpoint — confirmed. The service does its own
       credential check; MFA is genuinely not in the path.
    2. **WSSE (`ExternalReportWSSService.getFolderContents`) keeps returning `InvalidSecurity: error
       in processing the WS-Security security header`** — even with correct `zeep` UsernameToken
       **and** a `wsu:Timestamp`, PasswordText **and** PasswordDigest. So it is NOT a curl/canon
       issue and NOT a missing-timestamp issue; OWSM wants a stricter policy (likely message
       protection / signing) on the WSS endpoint. These are header-structure rejections → password
       never evaluated → lockout-safe.
    3. **The clean path is `…/xmlpserver/services/v2/ReportService`** — its non-`InSession` ops take
       **inline `userID`/`password` as plain SOAP body params, no WS-Security at all**:
       `runReport(reportRequest, userID, password)`, `getReportParameters(reportRequest, userID, password)`.
       This sidesteps OWSM/WSSE entirely.
    4. **DECISIVE:** `getReportParameters(req, OTBI_USER, OTBI_PWD)` returned
       **`java.lang.SecurityException: Failed to log into BI Publisher: invalid username or password.`**
       The credential was **evaluated and rejected**. The `OTBI_USER/OTBI_PWD` in `env.sh` (the
       Entra/SSO password the browser workers use to drive the interactive login) is **not valid for
       BIP direct service auth** — the classic federated-SSO gotcha (SSO password ≠ a credential the
       Fusion identity domain accepts for non-interactive web-service login).
  **Revised verdict:** the *mechanism* is solved (v2/ReportService, inline creds, no WSSE, no MFA),
  but Track A is **blocked on a credential**: it needs either (a) the correct username form / a
  Fusion-local (non-SSO) password for this user, or (b) a dedicated **BI Publisher service account**
  from IT with web-service access. **Do not keep trying username/password variants** — each is a real
  FailedAuth against the shared account the whole browser fleet depends on (one such failure already
  occurred during this spike; worker confirmed still `active` after). **Next step is an IT/credential
  ask, not more code.** Once a working credential exists, the build is small: `extract_bip.py` calling
  `v2/ReportService.runReport` with inline creds + `extract_track='BIP'` + per-job report path.

## What is proven (2026-06-17)
End-to-end pipeline for the **GRN All** analysis works:

1. **Auth** — login chain is Oracle IDCS → **ADGOV-Employees-Login** → Microsoft
   Entra ID (username+password) → **Microsoft Authenticator push, number-matching**.
   Credentials valid; MFA is enforced (semi-attended — a human approves the push).
2. **Extract** — `GET /analytics/saw.dll?Go&path=<ENC>&Action=Download&Format=csv`
   returns `text/csv`. **The param is lowercase `path`; capital `Path` → WebLogic 404.**
   Pulled 317 KB / 1,527 rows.
3. **Load** — `PROD.ATD_GRN_ALL` created from the dataset (16 cols) and loaded;
   verified 1,527 rows, 1,051 distinct receipts, dates 2026-03-02→2026-06-16,
   total 701,610,978, 94 non-null rates (matches the source profile).
4. **Orchestration** — control tables (`ATD_OTBI_ENV/_TARGET_DB/_JOBS/_LOAD_RUN_LOG`)
   deployed; job `GRN_ALL` seeded (BROWSER track, TRUNCATE_INSERT → `PROD.ATD_GRN_ALL`).

## DB objects deployed
Run via SQLcl (`sql -name prod_mcp`), in order:
`01_atd_control_tables.sql`, then per analysis a table + seed:
`06_grn_all_table.sql` + `07_seed_grn_all.sql`,
`08_suppliers_table.sql` + `09_beneficiaries_table.sql` + `10_seed_more.sql`.
(`02_network_acl` / `03_otbi_pkg` / `04_scheduler` are Track A only — not needed for Track B.)

Three jobs are live in `ATD_OTBI_JOBS` (all BROWSER / TRUNCATE_INSERT):
| job | analysis path | target table |
|---|---|---|
| GRN_ALL | /users/haghareb@dctabudhabi.ae/MG/GRN All | PROD.ATD_GRN_ALL |
| SUPPLIERS | /users/haghareb@dctabudhabi.ae/Hany/Suppliers/Suppliers | PROD.ATD_SUPPLIERS |
| BENEFICIARIES | /users/haghareb@dctabudhabi.ae/Hany/AP/Beneficiaries | PROD.ATD_BENEFICIARIES |

`ATD_GRN_ALL` is already loaded (1,527 rows, verified); `ATD_SUPPLIERS` (1,398) and
`ATD_BENEFICIARIES` (12,086) are created and load on the next runner run.
**ADB gotcha:** seeding MERGE hit ORA-12860 (parallel DML); `07`/`10` do
`ALTER SESSION DISABLE PARALLEL DML` + `NOPARALLEL` on the control tables.
**Date handling:** `load.py` parses DATE/TIMESTAMP columns in Python (mixed date-only +
datetime values), so no NLS dependency.

## Running the Track B runner (`runner/`)
DB load defaults to **`oracledb`** (fast; see "Fast load mode" below) when DB creds are present,
and falls back to **SQLcl** (`sql -name prod_mcp`, no separate creds) otherwise.

One-time setup on the host:
```
pip install -r runner/requirements.txt   # playwright + httpx + python-oracledb
python -m playwright install chromium
```
Environment variables:
```
# Fusion login (used by auth.py; referenced by the env's credential_ref FUSION_ADGOV)
set OTBI_USER=hg2248@dctabudhabi.ae
set OTBI_PWD=********
set ATD_STATE_DIR=c:\otbi-atd-state   # where auth_state_*.json + mfa number file live
# SQLcl (defaults shown) — used for ALL DB reads/writes, reuses stored creds
set ATD_SQLCL=C:\claude\tools\sqlcl\sqlcl\bin\sql.exe
set ATD_SQLCL_CONN=prod_mcp
set ATD_LOAD_BATCH=200                 # rows per INSERT ALL (tuning)
```
Run a job:
```
cd runner
python runner.py GRN_ALL      # or: python runner.py   (all enabled BROWSER jobs)
```
Verified 2026-06-17: all 3 jobs load via SQLcl with no DB creds —
BENEFICIARIES 12,086 / GRN_ALL 1,527 / SUPPLIERS 1,398, each a SUCCESS row in
ATD_LOAD_RUN_LOG. SQLcl headless gotcha: it needs an empty real-file stdin and a
real-file stdout (NUL/pipe -> "IOException: Incorrect function"); `SET LONG` is
raised so JSON CLOB columns aren't truncated to 80 chars (both handled in sqlrun.py).
On first run (or after the session expires) the console prints
`>>> APPROVE THE AUTHENTICATOR PUSH — ENTER NUMBER: NN`; open Authenticator, enter NN,
approve. The session is saved to `auth_state_FUSION_ADGOV.json` and reused on later runs
(no MFA) until Entra expires it. Each run writes a row to `PROD.ATD_LOAD_RUN_LOG`.

## Creating analyses (`create_analysis.py`) — build, don't just load
`add_analysis.py` registers an analysis that already exists; `create_analysis.py` **builds**
one in the OTBI Answers UI from a declarative spec (`otbi-atd/specs/*.json`) and reuses the
same `auth.authenticate()` session, so it triggers the same MFA flow as the runner.
```
cd runner
python create_analysis.py --spec ../specs/po_headers.json --headed   # bring-up: watch it
python create_analysis.py --spec ../specs/po_headers.json --load      # create + table + load
```
Four spec inputs: `subject_area`+`columns[]` (the data), `params[]` (optional prompted
filters), `save_folder`, `name`. `--load` chains `add_analysis.py` + `runner.py`.
**Selectors are confirmed live** (the Answers editor is dynamic): use `--headed` or `--pause`
(Playwright inspector) on first bring-up of a new pod/subject area, then harden the selector
lists in `create_analysis.py`; step failures screenshot to `ATD_STATE_DIR` as
`create_<step>_*.png`. The reference spec `po_headers.json` builds PO header details from
`Procurement - Purchasing Real Time` → `/users/haghareb@dctabudhabi.ae/PO/PO Headers`
(TRUNCATE_INSERT full snapshot; see the 2026-06-19 entry below for the date-only + Status
column choices). Save to `/Shared Folders/...` instead if a different service account runs
the scheduled loads (personal folders are private to their owner).

## Fast load mode (oracledb) — NOW THE DEFAULT
`oracledb` is auto-selected when `ATD_DB_USER`+`ATD_DB_PASSWORD` are set; it falls back to SQLcl
otherwise. Force either with `ATD_DB_MODE`. Pure-Python **thin mode** (no Instant Client, no Java):
```
pip install python-oracledb
set ATD_DB_USER=ADMIN          &  set ATD_DB_PASSWORD=********
set ATD_WALLET_PASSWORD=****** &  rem decrypts ewallet.pem (= DB password here)
set ATD_DB_DSN=prod_low        &  set TNS_ADMIN=<wallet dir: ewallet.pem + tnsnames.ora>
set ATD_DB_CHUNK=5000          rem rows per array-bind round-trip
```
**Measured A/B on this host (BENEFICIARIES 12,160 rows): pure DB load 80.7s → 0.5s = 155×;
end-to-end 109s → 17.5s.** Same control tables, same runner. Two gotchas (full detail REFERENCE.md
§10): thin mode **needs the wallet password** (SQLcl/JDBC use the password-less `cwallet.sso`,
which thin mode ignores); and the wallet's `retry_count=20` makes a *bad* connect hang ~60s while
a correct one is <1s. On Windows the secrets live in the git-ignored `runner/env.ps1`
(`. .\env.ps1` then `python runner.py`).

## Job ordering (priority / run_order)
`db/11_atd_job_ordering.sql` adds `priority` (lower runs earlier; default 5) and `run_order`
(sequence within a band; default 100) to `ATD_OTBI_JOBS`. Both runner paths order by
`priority, run_order, job_name`. Re-sequence with a plain `UPDATE` — no code change.

## Truncation / OTBI export cap warning
OTBI caps the CSV download server-side (often ~65k rows) → large analyses can come back
silently truncated. The runner flags it: if a load's row count equals a common cap
(`ATD_TRUNCATION_CAPS`) or is below `ATD_EXPECTED_MIN`, it prints `[WARN]`, sends it to Telegram,
and stores it in `ATD_LOAD_RUN_LOG.message`. Raise the pod's download limit before relying on
extracts near the cap. Full detail: REFERENCE.md §7.

## MFA number delivery (Telegram) — approve from anywhere
When the saved session has expired the runner needs a fresh push approval. It prints the
number-matching value NN, writes it to a file, AND sends it via `notify.py` so you can read
it on your phone and approve in Authenticator without being at the host.

Telegram setup (one-time, ~2 min):
1. In Telegram, message **@BotFather** → `/newbot` → get the **bot token**.
2. Send any message to your new bot (so it can reply to you).
3. Get your **chat id**:  `set ATD_TG_TOKEN=...` then `python notify.py chatid`.
4. Configure the runner host:
```
set ATD_NOTIFY=telegram
set ATD_TG_TOKEN=123456:ABC...
set ATD_TG_CHAT=<your chat id>
set ATD_MFA_WAIT=420            # seconds the runner waits for approval (default 420 = 7 min)
```
5. Test:  `python notify.py test`  (you should get a Telegram message).

Other channels (same `notify.send`): `ATD_NOTIFY=email|webhook|sms` — see env vars at the
top of `runner/notify.py` (Teams/Slack incoming webhook, SMTP, or Twilio SMS). Notification
is best-effort: a delivery failure is logged but never breaks the login.

**Editable message text (db/18, Runner Settings page):** the three notification
messages are templates in `ATD_RUNNER_CONFIG`, editable in the app's **Runner Settings**
page — no code change needed. `notify.render(key, default, ...)` formats them, falls back to
the built-in default if the key is blank/malformed, and never raises:
- `ATD_MFA_MSG` — MFA sign-in approval. Placeholders `{number}` (auto-appended if the
  template omits it, so the code can never be lost) and `{env}`.
- `ATD_JOB_MSG` — job status / truncation warning. Placeholders `{job}`, `{note}`.
- `ATD_DRIFT_MSG` — schema-drift warning. Placeholders `{job}`, `{drift}`.

Re-running `db/18_atd_msg_templates.sql` is idempotent (MERGE inserts only when absent —
it never overwrites a value edited in the UI).

## Scheduling
Cannot be scheduled from ATP (Track B drives a browser). Runs stay inside the Entra session
lifetime, so MFA is only needed occasionally; the runner surfaces the number (Telegram) on refresh.

**This host — live every 15 min (registered 2026-06-18):** Windows Task `OTBI-ATD Loader` runs
`runner/run_atd.ps1`, which dot-sources the git-ignored `env.ps1` and drains **all three runner
queues each cycle** (since 2026-06-19): `--discover` (subject-area column-picker scrapes),
`--build` (Add-New-Analysis requests), then the plain load for all enabled jobs — each phase logged
separately to `otbi-atd/run.log`. The discover/build phases early-exit cheaply (no browser/MFA) when
their queues are empty, so they cost nothing when idle but make every queue self-draining like the
load queue. Trigger: every 15 minutes, `MultipleInstances=
IgnoreNew`, 10-min limit, `StartWhenAvailable`. Runs in the logged-on user session (Playwright
headless). Manage it:
```
Get-ScheduledTaskInfo -TaskName 'OTBI-ATD Loader'      # last result + next run
Start-ScheduledTask  -TaskName 'OTBI-ATD Loader'       # run now
Disable-ScheduledTask -TaskName 'OTBI-ATD Loader'      # pause
Unregister-ScheduledTask -TaskName 'OTBI-ATD Loader' -Confirm:$false   # remove
```
To run **while logged off**, re-register with stored credentials (`-User`/`-Password` or
`-LogonType S4U`). `run.log` is git-ignored. (Linux/VM equivalent: the cron line in
`oci-vm-setup.md` §7.)

## Adding another analysis
1. (optional) create its target table — model on `06_grn_all_table.sql`.
2. Insert a row in `ATD_OTBI_JOBS` (copy the `GRN_ALL` MERGE in `07`): set `source_ref`
   to the analysis path, `stage_table`, `load_mode`, and `column_map_json`
   (CSV header → column). No code change.

## To repoint host / account / database
Edit rows, not code: `ATD_OTBI_ENV.analytics_base_url` (pod), `.credential_ref` (account),
`ATD_TARGET_DB` (LOCAL_ATP vs REMOTE). Both tracks read the same tables.

## 2026-06-19 — PO Headers (date-only) + "Add New OTBI Analysis" from the UI
**PO Headers analysis** built via `create_analysis.py --spec ../specs/po_headers.json`
(18 cols, `/users/haghareb@dctabudhabi.ae/PO/PO Headers`), loaded to `PROD.ATD_PO_HEADERS`
(`TRUNCATE_INSERT`, 2641 rows). Date columns (Creation/Approved/Closed) sourced from the
`Time - <X> Date` folders' **`Report Date`** attribute (date-only); status from
`Document Status` → **`Document Status Meaning`** (the bare attribute returns a hierarchy
total). Two robustness fixes so date columns type as `DATE` despite a few OTBI-misaligned
rows: `prepare.profile` tolerates ≤2% non-date cells when typing a `DATE` column;
`load._to_dt` nulls an unparseable date cell instead of failing the load.

**Add New OTBI Analysis (feature).** Jobs page → "+ New OTBI Analysis" drawer collects a
spec (subject area, save folder, name, Folder/Column/Heading repeater, optional prompt JSON,
load mode) and POSTs `{name, saveFolder, specJson}` to `/atd/analyses`. Deploy order:
1. `sql -name prod_mcp @otbi-atd/db/15_atd_analysis_request.sql`  (creates `ATD_ANALYSIS_REQUEST`)
2. `sql -name prod_mcp @otbi-atd/db/13_atd_ords.sql`  (FRESH session — adds the
   `atd_analysis_request` synonym + `GET/POST /atd/analyses` handlers)
3. Bump `final apps/ATD/Jet/index.html` `APP_VERSION` (→ 1.4.0).
The runner host drains requests: **`python runner.py --build`** (oracledb mode) builds each
queued analysis in OTBI (`create_analysis.build_analysis`), registers it as a job, and loads
it once; marks the request DONE/FAILED. (Schedule `--build` alongside the loader task, or run
on demand. Building needs the OTBI session, so MFA may be prompted like any runner login.)

**Column picker (Add-New-Analysis drawer).** Instead of typing Folder/Column labels, pick a
**discovered** subject area and tick its real folders/columns. Deploy order:
1. `sql -name prod_mcp @otbi-atd/db/16_atd_sa_catalog.sql`  (creates `ATD_SA_CATALOG` — the
   discover queue **and** the picker cache; one row per subject area)
2. `sql -name prod_mcp @otbi-atd/db/13_atd_ords.sql`  (FRESH session — adds the
   `atd_sa_catalog` synonym + `GET /atd/subject-areas`, `GET /atd/subject-areas/columns?sa=`,
   `POST /atd/subject-areas/discover` handlers)
3. Bump `final apps/ATD/Jet/index.html` `APP_VERSION` (→ 1.5.0).
"Discover columns" POSTs `/atd/subject-areas/discover` (QUEUED). The runner host drains scrapes:
**`python runner.py --discover`** (oracledb mode) drives the OTBI Answers tree
(`create_analysis.discover_subject_area`) — enumerates every top-level folder, walks each
(virtualised) folder's leaves, and caches `{folders:[{folder,columns:[]}]}` into
`ATD_SA_CATALOG` (status READY). Scope = **whole subject area per run** (first scrape of a big
SA can take minutes; the picker is instant + offline afterwards). The picker reads the cache via
`GET /atd/subject-areas/columns?sa=`; non-READY returns `{status, folders:[]}` so the UI shows
QUEUED/SCRAPING/FAILED. Sub-folders that leak into a parent's leaves are filtered out (a folder
owns a `_disclosure` node). Standalone test: `python create_analysis.py --discover --subject-area "…" [--headed]`.
**Gotcha (live-pod, fixed):** the Answers criteria pane lists EVERY subject area in the catalog
as its own `criteriaDataBrowser$…` node, so enumerating all `_disclosure` ids grabs all subject
areas as phantom folders (a Financials subject area showed 274). OTBI **quotes subject-area names
in the id** (`criteriaDataBrowser$"Costing - X Real Time"`) but presentation **folders are
unquoted** (`criteriaDataBrowser$Currency`) — `_top_folders` keeps only unquoted ids (and drops
zero-column folders). Verified: "Project Control - Financial Project Plans Real Time" → 11 folders
/ 195 columns.

**Full-depth nested discovery + dedicated 1-min runner + AI suggester (2026-06-20, APP_VERSION 1.6.4).**
- **Nested discovery (full depth).** `create_analysis.discover_subject_area` now recurses into
  sub-folders to the true leaf columns and returns a **nested tree**
  `{subject_area, folders:[{folder, columns, folders}], column_count, folder_count, scraped_at}`.
  The builder (`build`/`add_column`) is **path-aware**: a spec column may carry `path:[...]`
  (top→immediate parent) and the builder expands every ancestor before adding the leaf
  (`_expand_path`/`_child_id`); legacy depth-1 `folder` still works. **Live-DOM gotcha (caused a
  hang):** OTBI tree rows are `criteriaDataBrowser$<base>_details` with the twisty/children as
  SIBLINGS on `<base>`; **folder vs column is the ICON** (`.../obips.Tree/folder.png` vs
  `column.png`) — NOT the disclosure, which EVERY node (incl. leaf columns) carries collapsed.
  The first cut keyed on disclosure → treated every column as a folder → 30s expand-timeout each →
  multi-hour hang. `_JS_CHILDREN` now keys folder-ness on the icon. Verified: Requisitions
  15 flat→**73 folders/1166 cols**, Project Control 11→40/370, Supplier 7→34/552 (depth-3).
  Re-queue all SAs after deploying (old catalogs are flat): `UPDATE prod.atd_sa_catalog SET
  status='QUEUED' WHERE catalog_json NOT LIKE '%"column_count"%'`.
- **Dedicated discovery runner.** `run_atd_discover.ps1` + Windows Task **`OTBI-ATD Discover`**
  (every **1 min**, `MultipleInstances=IgnoreNew`, 30-min limit, logged-on session) drains the
  discovery queue independently of the 15-min loader. `runner.py --discover` now processes **ONE**
  oldest QUEUED SA per invocation, so a multi-minute scrape never overlaps the next tick and each
  SA gets the full limit. `run_atd.ps1` reverted to **build + load only** (no `--discover`).
  `--discover` still no-ops (no browser) when the queue is empty. Manage:
  `Get-ScheduledTaskInfo / Start-ScheduledTask / Disable-ScheduledTask -TaskName 'OTBI-ATD Discover'`.
- **Single-browser lock (2026-06-20).** The 1-min Discover task and the 15-min loader must never
  drive an OTBI browser at the same time — two Playwright sessions on the one Fusion SSO session
  corrupt each other's server-side Answers-editor state (intermittent build failures like
  `folder did not load children: '<name>'` / `saTreeNode_NN`). Both `run_atd.ps1` and
  `run_atd_discover.ps1` acquire the SAME exclusive lockfile `otbi-atd/.otbi_runner.lock`
  (`[System.IO.File]::Open(path,'OpenOrCreate','ReadWrite','None')`) before launching python; if the
  other holds it, the cycle is skipped and retried next tick. One OTBI browser per host — the only
  safe model with a single MFA account.
- **Stale-SCRAPING reaper (2026-06-20).** `--discover` only retries `QUEUED` rows, so a row left in
  `SCRAPING` by a crashed/killed scrape (or one that wrote the catalog but lost the `READY` flip)
  would never recover. `runner._reap_stale_discovery` runs at the top of every `--discover` cycle:
  it resets to `QUEUED` any `SCRAPING` catalog row that has **no** `DISCOVER` run-log row `RUNNING`
  within `ATD_LEASE_MINUTES` (default 30), and closes the dangling `RUNNING` run-log rows as
  `FAILED`. A genuinely-live scrape keeps a fresh `RUNNING` log row and is never reaped. Gotchas:
  the statements carry `/*+ no_parallel */` (these ATD tables auto-parallelize → ORA-12860 deadlock
  under concurrency) and compare `started >= CAST(systimestamp AS TIMESTAMP) - …` (the run-log
  `started` is a plain `TIMESTAMP`; comparing it against TZ-aware `systimestamp` mis-fired the lease
  — same skew fixed earlier in `ATD_QUEUE_PKG.reap_stale`).
- **AI column suggester (Sonnet 4.6).** `db/17_atd_ai.sql` = network ACL for `api.anthropic.com`
  + `ATD_RUNNER_CONFIG` keys `AI_MODEL` (default `claude-sonnet-4-6`) / `AI_MAX_TOKENS` /
  `AI_API_KEY` (secret; blank → reuses the AR ANTHROPIC provider key) + `DCT_ATD_AI_PKG`.
  `suggest_columns(sa, request)` flattens the cached catalog to a NUMBERED list, asks Claude for
  the matching **indices**, and maps them back to `{path,column}` server-side — so a suggestion can
  never be a column outside the catalog (no hallucination). ORDS `POST /atd/subject-areas/suggest`
  `{sa, request}` (synonym `dct_atd_ai_pkg`; error map -20404→404 / -20001→400). Frontend: a
  "✨ Suggest columns" textarea in the Add-New-Analysis drawer ticks the matches in the nested
  picker. Deploy: `@db/17_atd_ai.sql` (own session) then `@db/13_atd_ords.sql` (FRESH session).
  **PLS gotchas:** `DBMS_LOB.CONVERTTOBLOB` offset/lang args are IN OUT (pass variables, not
  literals); the CLOB-escape chunk buffer must be `VARCHAR2(32767)` reading 8000 chars (ORA-06502
  otherwise). Verified live: a supplier-data request returned 11 correctly-pathed real columns.

**OTBI Discovery page (ATD JET, APP_VERSION 1.6.0).** New `discovery` view = one page, three
tables: (1) discovery requests (`/subject-areas`, queue-style, with Discover / Re-discover),
(2) discovery run history (`/subject-areas/runs`), (3) analysis build requests (`/analyses`).
Backend additions: each `--discover` scrape now writes an `ATD_LOAD_RUN_LOG` row with
`track='DISCOVER'` (job_name = subject area truncated to 80, row_count = column count); new
`GET /atd/subject-areas/runs` lists them, and the main `/runs` now excludes `track='DISCOVER'` so
the Run Logs page stays load-focused. Redeploy `13_atd_ords.sql` (fresh session) for the new
endpoint; no new DB script (reuses `ATD_LOAD_RUN_LOG`). Nav item added under Operations in
`appController.js`.

---

**Fusion write-back ACTIONS — AP invoices from Petty Cash (APP_VERSION 1.7.0, 2026-06-20).**
The inverse of the extract jobs: a queue of actions the runner *performs inside* Oracle Fusion via
the SAME authenticated browser session (no service account). First action type = `AP_INVOICE`,
sourced from approved Petty Cash reimbursements.

- **DB (new, isolated):** `otbi-atd/db/19_atd_action_queue.sql` = `ATD_ACTION_REQUEST` (queue:
  `READY|CLAIMED|DONE|FAILED|CANCELLED`, UNIQUE `idem_key`, `payload_json`) + `ATD_ACTION_PKG`
  (`enqueue_action` MERGE-on-idem_key, `claim_next_action` FOR UPDATE SKIP LOCKED,
  `mark_action_done/failed`, `reap_stale_actions`, `cancel_action`) + `ATD_ACTION_TYPE`/`ATD_ACTION_STATUS`
  lookups. **Idempotency law:** a `DONE` row is never re-created; `enqueue` re-arms only FAILED/CANCELLED.
- **DB (PC source):** `final apps/PC/db/07_pc_fusion.sql` = `DCT_PC_FUSION_PKG`
  (`build_ap_invoice_payload` / `enqueue_fusion_action` / `receive_fusion_result`) + 4 tracking
  columns on `DCT_PC_REIMBURSEMENTS` (`post_to_fusion`, `fusion_status`, `fusion_invoice_id`,
  `fusion_pushed_at`) + 2 settings (`FUSION_POST_REIMB` Y/N gate, `FUSION_ENV_NAME`). Hooks:
  `db/v2/14` `apply_final_approval` (sweep) + `final apps/PC/db/06_pc_ords.sql` (interactive approve)
  both call `dct_pc_fusion_pkg.enqueue_fusion_action(reimb_id)` — **no-op until FUSION_POST_REIMB=Y**.
  `changed_by` on `dct_request_status_history` is NOT NULL → both procs resolve the petty-cash owner
  user_id (bit us once: ORA-01400).
- **Runner:** `runner.py --actions [--forever]` (oracledb mode) drains the queue; `actions/__init__.py`
  dispatch + `actions/ap_invoice.py` driver. **Idempotency probe** = read-only Payables REST lookup
  by InvoiceNumber over the session cookies (`ctx.request`); if found, return that id, create nothing.
  **Writes are gated by `ATD_ACTION_LIVE=1`** — without it the driver does probe + form validation and
  raises `DryRun` (nothing saved). Pod-specific Create-Invoice selectors in `ap_invoice.py` MUST be
  confirmed in a HEADED run against a Fusion TEST pod before the first live save.
- **Schedule:** `run_atd_actions.ps1` (e.g. every 5 min, MultipleInstances=IgnoreNew) — shares the
  SAME `.otbi_runner.lock` as loader/discover so no two tasks drive a Fusion browser concurrently.
- **App 208 UI/ORDS:** `otbi-atd/db/20_atd_action_ords.sql` (ADDITIVE — no DELETE_MODULE) adds
  `GET /atd/actions`, `GET /atd/actions/stats`, `GET /atd/actions/:id`, `POST /atd/actions/:id/retry`,
  `POST /atd/actions/:id/cancel` to the live `atd.rest`. New JET `actions` view + dashboard tile.
  - **⚠️ ALWAYS run `20_atd_action_ords.sql` RIGHT AFTER `13_atd_ords.sql`.** `13` does
    `ORDS.DELETE_MODULE(atd.rest)` + rebuild, so any redeploy of `13` (e.g. the 2026-06-21 `/workers`
    add) WIPES these additive `/actions/*` handlers. Symptom: the dashboard's `/actions/stats` call
    404s and the browser shows a CORS **"Network error — check your connection"** toast + a dead
    Fusion Actions page. Fix = re-run `20`. (Same trap as the TM `06`/`14` rule.) Hit & fixed
    2026-06-21.
- **Employee→Fusion supplier map:** `otbi-atd/db/21_emp_supplier_map.sql` = `DCT_EMP_SUPPLIER_MAP`
  (`source_module`, `party_key`=employee_num/freelancer_id, `supplier_number/name/site`,
  `business_unit`, **`payment_method`**, `pay_group/payment_terms/currency_code`,
  UNIQUE(source_module, party_key)). `build_ap_invoice_payload` LEFT-JOINs it (`PC` + employee_num,
  active) → emits a `supplier{number,name,site,paymentMethod,payGroup,paymentTerms}` block and
  overrides `businessUnit`/`currency`; omitted (ABSENT ON NULL) when unmapped. Per-app by design.
  Ships EMPTY — populate before live posting.
- **Deploy order (each in its OWN fresh SQLcl session — synonym rule):**
  `@otbi-atd/db/19...` → `@otbi-atd/db/21...` → `@final apps/PC/db/07...` → `@db/v2/14...` →
  `@final apps/PC/db/06...` (recreates pc.rest) → `@otbi-atd/db/20...`. Then bump ATD `APP_VERSION` + ship JET.
- **Verified (2026-06-20):** all objects VALID; idempotency unit (DONE never resurrected); end-to-end
  on real RMB-2026-00100 — payload builds, enqueue → 1 READY + reimb QUEUED, runner-callback → POSTED.
  Runner action handler unit-tested (idempotent skip + dry-run safety). **Pending:** headed live test
  of `ap_invoice.py` against a Fusion test pod (needs MFA approval) before enabling FUSION_POST_REIMB=Y.
- **Honest note:** semi-attended — runs unattended while the saved SSO session is valid; a human
  approves the Authenticator number-match only when it expires (same as the extract jobs).
- **Explicit Fusion apps URL (db/22, 2026-06-21):** `ATD_OTBI_ENV.fusion_apps_url` (FUSION_ADGOV =
  `https://iaaibv.fa.ocs.oraclecloud29.com`). `ap_invoice._apps_base` resolves: this column →
  `ATD_FUSION_APPS_URL` env → derive from `analytics_base_url`. Threaded via `config.get_action` /
  `get_default_browser_env` → worker env dict.
- **Supplier identity source:** `DCT_EMP_SUPPLIER_MAP` is fed from the **HR module Employee screen**
  (employee↔supplier mapping; HR has no supplier columns yet → this table is the store, party_key =
  employee_number). HR-screen wiring is a follow-up.
- **Smoke test (db/22 + runner):** `smoke_ap_invoice.fields.txt` (fill-in form) → generate
  `payload.json` → `python smoke_ap_invoice.py payload.json` (HEADED, bypasses the queue). It first
  runs a **fscmRestApi reachability probe** (settles the InvoiceId source: REST read-back if reachable,
  else the invoice number we set + UI-based idempotency), then drives Create-Invoice. Dry-run by default
  (fills the form, validates selectors, does NOT save); `ATD_ACTION_LIVE=1` actually saves. `create()`
  now fills the form BEFORE the save gate so a dry-run exercises the selectors.
- **AP invoice TYPE (answer to "Fusion doc"):** in Fusion Payables every invoice has a TYPE — Standard,
  Prepayment, Credit Memo, etc. Reimbursement = **Standard** (built). Advance = likely **Prepayment**;
  Clearing = prepayment application / adjustment — both pending confirmation before wiring their
  action_types.

---

**Round 2 — all 3 PC documents + configurable type + HR mapping screen (2026-06-21):**
- **Configurable invoice TYPE** (`otbi-atd/db/23_fusion_doctype_map.sql`): `DCT_FUSION_DOCTYPE_MAP`
  (source_module, source_type) -> invoice_type. Seeded PC_REIMB=Standard, PC_CLEAR=Standard,
  PC_ADVANCE=Prepayment. `DCT_PC_FUSION_PKG.doctype()` reads it (default Standard); the payload
  carries `invoiceType`; `ap_invoice.py` fills the Fusion Invoice Type field from it.
- **All 3 PC documents** now post (each its own per-type gate + tracking cols on
  DCT_PETTY_CASH / DCT_PC_CLEARING / DCT_PC_REIMBURSEMENTS):
  - Reimbursement -> Standard, gate FUSION_POST_REIMB, hook = approve (06 + sweep 14).
  - Advance -> Prepayment, gate FUSION_POST_ADVANCE, hook = **disburse** (06 pc/:id/disburse,
    fires at status->ACTIVE), idem = pc_number.
  - Clearing -> Standard, gate FUSION_POST_CLEARING, hook = approve (06 + sweep 14), idem = clearing_number.
  `receive_fusion_result` is now generic `(source_type, source_id, invoice_id, ref)`; the runner
  passes `action.source_type`. Verified: reimb->Standard, advance->Prepayment enqueue end-to-end.
- **HR Employee supplier-mapping screen** (`final apps/HR/db/07_hr_supplier_map_ords.sql`, additive
  to hr.rest): `GET/PUT /hr/employees/:id/supplier-map` upsert DCT_EMP_SUPPLIER_MAP (source_module='PC',
  party_key = employee_number). HR `employeeDetail` view: a "🏛 Supplier" button + modal (all fields
  incl. payment_method). HR APP_VERSION 4.6.0. This is the map's source of truth per the requirement.
- **`db/v2/14` DEPLOYED 2026-06-21 (VALID):** the CLEARING **sweep-path** enqueue is now live
  alongside the reimbursement one; interactive approval (06) and idle-timeout auto-approve both
  enqueue all 3 PC documents. All Fusion-action DB deploys complete; only the live headed smoke
  test + populating `DCT_EMP_SUPPLIER_MAP` remain before flipping a `FUSION_POST_*` gate to Y.

## ⚠️ The worker VMs KERNEL-PANIC under browser load (diagnosed 2026-07-25, OPEN)

**Symptom that sends you the wrong way:** an unattended run vanishes — process gone, no traceback,
no exit code, systemd unit garbage-collected. It looks like the script died. It did not: **the VM
rebooted underneath it.** Check `uptime` before debugging anything else.

**Root cause — a bug in the VMware paravirtual NIC driver, nothing to do with the runner:**

```
kernel BUG at drivers/net/vmxnet3/vmxnet3_drv.c:1807!
RIP: vmxnet3_rq_rx_complete+0xbe3/0x1340 [vmxnet3]
     vmxnet3_poll_rx_only -> __napi_poll -> net_rx_action -> handle_softirqs
```

Identical RIP in **every** dump on all three VMs — one bug, in the RX completion path, which is why
a Playwright/Chromium session pulling Fusion pages is the reliable trigger.

| VM | vmcores | disk | worst day |
|---|---|---|---|
| vm180 | 39 | 3.7G | 4 crashes on 2026-07-25 |
| vm181 | 27 | 2.6G | 4 in six hours (18:17, 21:46, 23:15, 23:31) |
| vm182 | 9 | 892M | least affected — prefer it for long runs |

All three: kernel `6.12.0-105.51.5.el9uek`, `open-vm-tools-13.0.0`, `vmxnet3 1.9.0.0-k-NAPI`,
**`large-receive-offload: on`**.

**Finding the evidence.** `last -x` shows every boot as "still running" with NO shutdown record =
hard reset. The systemd journal is **volatile** here (no `/var/log/journal`), so `journalctl -b -1`
is empty — but `/var/log/messages` persists and **kdump is enabled**, so the panic is always in
`/var/crash/<timestamp>/vmcore-dmesg.txt`.

**Mitigation APPLIED 2026-07-26 on all three workers:** `ethtool -K ens192 lro off gro off`, made
persistent via `nmcli con modify ens192 ethtool.feature-lro off ethtool.feature-gro off`. LRO on
vmxnet3 is the usual trigger for this BUG_ON. Real fix = newer UEK kernel / VMware Tools, or an
E1000E vNIC. Housekeeping still owed: 7.2G of vmcores across the fleet. (The 6-invoice rebill batch
ran right after with ZERO panics — vm181 had panicked twice in the preceding 3 hours.)

**Belt and braces:** launch long jobs **detached** (`systemd-run --unit=… --setenv=HOME=/root` —
`env.sh` sets `TNS_ADMIN="$HOME/wallet"` and systemd-run has no `$HOME`, else `DPY-4026`) so a
checkpointed saga survives the reboot, and resume rather than restart.

## 3-VM parallel worker fleet — DEPLOYED 2026-06-21 (Track B scale-out)

The Track B runner now runs on **3 on-prem Oracle Linux 9.7 VMs** (replaced the single Windows
box + the OL7.9 agents) as **parallel workers draining the one shared ADB queue**.

- **VMs:** `atd-vm180/181/182` = 192.168.1.180/181/182 on standalone ESXi 6.5 (192.168.1.190),
  provisioned hands-off via OL9.7 kickstart (see `provision/`). 2 vCPU / 6 GB / 50 GB each.
- **Each VM runs** `runner.py --worker --forever` as systemd **`atd-worker.service`**
  (`runner/systemd/`, `Restart=always`, `Environment=HOME=/root` + `PYTHONUNBUFFERED=1`, logs to
  journald — **not** `append:/root/...`, which SELinux blocks → status 209/STDOUT). One warm Fusion
  session per VM; **worker id = hostname** so `env.sh` is identical on every VM.
- **The `--forever` loop now also drains discover + builds** when no load job is waiting (reuses the
  warm session), and calls `reap_stale` + a stale-peer Telegram alert each idle cycle.
- **DB changes (deployed):** `db/12` `ATD_QUEUE_PKG` — `enqueue` skips `CLAIMED` rows; added
  `claim_sa` / `claim_build` (FOR UPDATE SKIP LOCKED) so discover/build are race-safe across VMs.
  `db/24` `ATD_ENQUEUE_JOB` (DBMS_SCHEDULER, every 15 min — the only schedule). `db/25`
  `host_id` on `ATD_LOAD_RUN_LOG` + `ATD_WORKER_HEARTBEAT`. `db/13` ORDS `GET /atd/workers` + `host`
  in the runs feed. (Numbered 24/25 — 19–23 are the parallel Fusion-action work-stream.)
- **UI (App 208, APP_VERSION 1.8.0):** dashboard **Worker Fleet** panel (green/red per VM, current
  job, last-seen, runs-24h) + **VM column** on the Runs page.
- **Deploy / scale-out:** `runner/deploy_worker.sh <ip>` (idempotent: software via `install_sw.sh`,
  syncs runner+wallet+`env.sh`, enables the service). Add a VM later with
  `provision/provision_vm.sh <host> <ip>` then `deploy_worker.sh <ip>` — **no DB/queue/UI change**, it
  self-registers in the queue + dashboard. **Old Windows "OTBI-ATD Loader" task DISABLED** (cutover).
- **GOTCHAS hit & fixed:** PyPI package is **`oracledb`** not `python-oracledb`; OL9 needs Chromium
  libs via `dnf` (Playwright `--with-deps` is Debian-only) — `CHROMIUM_SMOKE_OK` confirms; kickstart
  `network` must be **one line** (pykickstart chokes on `\` continuation → "unrecognized arguments");
  systemd needs `HOME=/root` (env.sh uses `$HOME` for `TNS_ADMIN`); the MFA number-match screen needs
  **polling** (single look races it) — auth.py now polls ~36s; the heartbeat staleness check must
  `CAST(SYSTIMESTAMP AS TIMESTAMP)` (raw TIMESTAMPTZ vs TIMESTAMP skews by the TZ offset → false DOWN).
- **VALIDATED:** parallel load spread across 2 VMs with no duplication (SUPPLIERS→vm180,
  AP_INVOICE_HEADER→vm181, each one SUCCESS); `host_id` recorded; heartbeats stable IDLE. Fusion
  confirmed to allow concurrent sessions for one account (3 independent sessions seeded).
- **MFA Telegram message now includes the VM name** (`auth.surface_number` adds `host`).
- **Pending:** VM clock sync (chronyd — ~13 min skew observed, cosmetic for timestamps only);
  optional crash-recovery + discover-race live tests (mechanism deployed).

---

## 2026-06-22 — Mid-life session self-heal + fleet re-seed (Track B)

**Incident:** all 3 VMs failed every GL_BALANCES load for ~20h with
`Go-URL did not return CSV (status=200, type=text/html) … Session likely expired`. Root cause:
the Fusion/Entra session expired **mid-life**; the `--forever` worker caches its Playwright
context in `ctx_by_env` and only calls `auth.authenticate()` (which re-validates + re-prompts MFA)
the **first** time it needs an env — so a cached session that dies later is never re-validated and
every load fails until a manual restart. The midnight MFA pushes came from the *discovery* path
(authenticates fresh per scrape); none were approved → stuck.

**Immediate recovery:** re-seeded all 3 (restart → approve MFA: vm182=21, vm180=34, vm181=98).
vm181 needed a **forced** re-seed (`runner/seed_session.py` one-shot `auth.authenticate` after
`rm auth_state_*.json`) because its dead session still passed auth.py's cheap `_validate`
(bieehome loads even when the Go-URL export bounces to login — a false positive).

**Permanent fix (code, deployed to all 3 VMs):**
- `runner/extract.py` — new `SessionExpired(RuntimeError)`, raised by `download_csv` **only** when
  the Go-URL bounces to the login page (HTTP 200 + HTML). A genuinely wrong path (WebLogic 404,
  status≠200) still raises plain `RuntimeError` — so we re-auth only when it can actually help.
- `runner/runner.py` — `_make_run_one_oracledb` logs the failed attempt then **re-raises**
  `SessionExpired`; `_run_worker` catches it, drops the dead context (`ctx_by_env`/`browser_by_env`,
  closes the browser), calls `auth.authenticate()` (→ **one** MFA push) and **retries the job once**
  with the fresh session. MFA-not-approved/re-auth failure is caught → job fails this cycle, worker
  keeps running (next claim re-prompts). `_drive` (direct non-worker path) guards `SessionExpired`
  as a clean failure (no retry) so it can't crash a batch. New `_env_of(job, env_name)` helper.
- **Effect:** a mid-life expiry now self-heals after **one** approval instead of failing silently
  for hours. Deploy = `scp runner.py extract.py` to each VM + `systemctl restart atd-worker`
  (py_compile-checked on each; all came back `active` with no MFA — fresh sessions valid).
- **VERIFIED by simulation (2026-06-22).** `extract.download_csv` has an inert test affordance: if
  the one-shot sentinel `$ATD_STATE_DIR/ATD_TEST_EXPIRE_ONCE` exists it is consumed and raises
  `SessionExpired` (as if the Go-URL bounced to login) — the file never exists in normal operation.
  To simulate: `ssh vm<ip> "touch /root/otbi-atd-state/ATD_TEST_EXPIRE_ONCE"`, then run/enqueue a
  load job. Observed on atd-vm180 (10s, real `_run_worker`):
  `[FAIL] GL_BALANCES: session expired mid-run; re-authenticating` ->
  `GL_BALANCES: SIMULATED session expiry ... -> re-authenticating` ->
  `[ok] GL_BALANCES: 9530 rows`. Re-auth was silent (real session valid -> no MFA); a real expiry
  would prompt one MFA, then retry. (One FAILED + one SUCCESS run row per simulated heal is expected
  test residue; `rm` any sentinel you arm on VMs that didn't claim the job.)
- **Note:** the same latent pattern exists in `_run_action_worker` but is low-impact
  (`FUSION_POST_REIMB` defaults N, actions DRY by default) — left for a follow-up.

---

## 2026-06-24 — Operator-triggered worker re-login ("Refresh") — UI button + Telegram

Re-seeding a worker's Fusion session no longer needs SSH. Two front-ends now set a flag
that the worker acts on:
- **DB (`db/26_atd_worker_refresh.sql`, deployed):** `refresh_req TIMESTAMP` on
  `ATD_WORKER_HEARTBEAT`; **additive** ORDS `POST /atd/workers/:id/refresh` (`:id` = worker_id
  or `all`; SYS_ADMIN) sets it. Additive only (DEFINE_TEMPLATE/HANDLER) — actions + workers-GET
  untouched; run in a fresh session (synonym rule).
- **Worker (`runner.py`, deployed all 3):** the `--forever` idle loop calls `_handle_refresh`
  — if `refresh_req` is set for THIS host, it clears it and **forces a fresh login**
  (`auth.authenticate(force=True)` → one MFA push), dropping the cached session first.
- **UI (App 208, APP_VERSION 1.11.0):** a **Refresh** button per VM in the dashboard Worker
  Fleet table (`atdService.refreshWorker` → the POST). Confirm dialog + toast; i18n EN/AR.
- **Telegram (`tg_bot.py`, vm180 only):** `refresh vm180` / `vm181` / `vm182` / `all` →
  `do_refresh` sets the same flag. Added to `/help`.
- **The MFA tap still happens in Microsoft Authenticator** — these only *trigger* the login and
  surface the number; they cannot replace the approval (only Track A/BIP removes the tap).
- **Verified:** ORDS template registered (actions intact); `refresh_req` column present; all 3
  workers read the column with no error; tgbot restarted clean. Final live tap = operator test.

---

## 2026-06-23 — The GL_BALANCES "session" outage was actually a MOVED REPORT PATH

**Lesson: HTTP 200 + HTML from the Go-URL does NOT always mean the session expired.** After
the 2026-06-22 self-heal work, GL_BALANCES kept failing on all 3 VMs with
`Go-URL did not return CSV (type=text/html) … Session likely expired`. A controlled probe
(reuse a freshly-approved session, dump every job's Go-URL) proved the session was **fine** —
6 of 8 reports returned CSV; only GL_BALANCES + AP_INVOICE_HEADER returned HTML. Dumping the
GL_BALANCES HTML showed the real error: **"Path not found — Check the input path entered.
Error Codes: U9KP7Q94"** — the report had been **moved/renamed** out of its configured path
(`/users/haghareb@dctabudhabi.ae/Drafts/GL/GL Balances`). The runner blindly treated *any*
HTML as expiry, so the self-heal kept re-authenticating (uselessly) and pushing MFA for a
problem re-auth can never fix.

**Fixes:**
- **Path corrected** (by the report owner): `GL_BALANCES.source_ref` →
  `/users/haghareb@dctabudhabi.ae/Data/GL/Budget Status` (verified: Go-URL returns CSV).
- **`extract.download_csv` now classifies HTML by the FINAL url** (deployed to all 3 VMs):
  - still on `/analytics/` → **`ReportError`** (report moved/renamed/deleted or a report
    runtime error) — a clean failure with an honest message; **no re-auth, no MFA**.
  - redirected to sign-in (`login.microsoft*` / `signin` / `/oam`) → **`SessionExpired`**
    (the worker re-authenticates + retries, as designed).
  - non-200 → plain `RuntimeError`.
  The old test sentinel was removed (it routed to an analytics HTML page and so now classifies
  as `ReportError`, which is correct but no longer simulates expiry). Verified live with
  `test_classify.py`: configured path → CSV; bogus path → `ReportError` (NOT `SessionExpired`).
- **Diagnosing this class:** reuse a known-good session and dump the Go-URL — if 200+HTML with a
  final url still on `/analytics/`, read the page text (it carries the OTBI error, e.g. "Path not
  found"); the report/path is wrong, not the session. (`probe_dump.py` did exactly this.)
- **Telegram relay is flaky** (`[notify] telegram send failed: handshake timed out`) and the
  MFA number capture sometimes yields `"see login screen"` (no digit). Both make manual re-seeds
  unreliable — another reason to pursue Track A (BIP, MFA-free).

---

## Telegram query bot (tg_bot.py) — PoC, vm180 only

A lightweight long-polling bot that answers i-Finance lookups in Telegram.
**getUpdates is single-consumer — run on vm180 only** (one service, no lock needed).

### What it does (PoC scope)
| Command | Behaviour |
|---|---|
| `/help` | List commands + "coming soon" services |
| `/vendor <number>` | Exact supplier lookup by number (name, status, currency) |
| `/vendor <text>` | Case-insensitive fuzzy name search, top 5 results |
| (others) | Stub "coming soon" reply (payments, pettycash, freelancer) |

Bank-sensitive columns (`iban`, `bank_account_number`, `bank_name`, `bank_branch_name`,
`account_name`) are never returned by any command — hardcoded whitelist in `tg_bot.py`.

Unrecognised Telegram chat IDs are silently ignored (no reply revealing the bot exists).

### Files
- `runner/tg_bot.py` — poll loop + command dispatch + DB lookups (imports `config`, `notify`)
- `runner/systemd/atd-tgbot.service` — systemd unit (clone of atd-worker.service)

### env.sh additions (vm180 only)
Add these two lines to `/root/otbi-atd/env.sh` on vm180 **after** the existing `ATD_TG_CHAT` line:
```bash
export ATD_TGBOT_ALLOW="${ATD_TG_CHAT}"   # comma-separated; seed = operator chat id
export ATD_TGBOT_ENABLED=1                # set to 0 to pause without stopping the unit
```
If you want to allow additional chat IDs later: `ATD_TGBOT_ALLOW="111111111,222222222"`.

### Deploy (one-time, vm180 only)
```bash
# 1. Copy the bot script and service unit to vm180
scp -i /c/tmp/atd-provision/keys/atd_id_ed25519 \
    otbi-atd/runner/tg_bot.py \
    root@192.168.1.180:/root/otbi-atd/runner/

scp -i /c/tmp/atd-provision/keys/atd_id_ed25519 \
    otbi-atd/runner/systemd/atd-tgbot.service \
    root@192.168.1.180:/etc/systemd/system/

# 2. SSH into vm180 and add the env vars
ssh -i /c/tmp/atd-provision/keys/atd_id_ed25519 root@192.168.1.180

  # --- on vm180 ---
  # Append the two env vars after ATD_TG_CHAT in /root/otbi-atd/env.sh:
  #   export ATD_TGBOT_ALLOW="${ATD_TG_CHAT}"
  #   export ATD_TGBOT_ENABLED=1

  # 3. Enable and start the service
  systemctl daemon-reload
  systemctl enable atd-tgbot
  systemctl start  atd-tgbot
  systemctl status atd-tgbot    # should show "active (running)"

  # 4. Follow logs
  journalctl -u atd-tgbot -f
```

### Redeployment (after tg_bot.py changes)
```bash
scp -i /c/tmp/atd-provision/keys/atd_id_ed25519 \
    otbi-atd/runner/tg_bot.py \
    root@192.168.1.180:/root/otbi-atd/runner/

ssh -i /c/tmp/atd-provision/keys/atd_id_ed25519 root@192.168.1.180 \
    systemctl restart atd-tgbot
```

### State file
The last processed `update_id` is persisted to `/root/otbi-atd/tgbot_offset.txt` so a
`systemctl restart` does not replay already-handled messages.

### Test plan
1. **Allowed chat → `/help`** — should list commands and "coming soon" services.
2. **Allowed chat → `/vendor <known number>`** — should reply with name (status, currency).
3. **Allowed chat → `/vendor acme`** (or any partial name) — should reply with up to 5 matches.
4. **Non-allowed chat** — send any message → no reply at all (check `journalctl -u atd-tgbot`
   for `"ignored chat_id=..."` log line).
5. **Bank field check** — search for a supplier known to have IBAN data; confirm the reply
   contains NO `IBAN`, `Bank`, or `Account Name` fields.
6. **Restart resilience** — `systemctl restart atd-tgbot`; send a message; should reply
   correctly with no duplicate responses.

---

## Fusion Actions — read PoC (2026-06-30)

Driving Fusion via the extract-job session now has a dedicated hub:
**`otbi-atd/docs/fusion-actions/`** (README + `fusion_invoice_lookup.py` + PoC writeup
+ evidence). PoC verified: looked up `INV/HQ/26032465` on atd-vm181 and returned its
line description via the Payables UI.

Key finding: **`fscmRestApi` returns 401 even with a full Fusion UI cookie session**
(federated ADGOV SSO has no Fusion-local password/OAuth) → **UI robot is the only
channel** for both reads and the AP write-back. ADF needs JS `el.click()`; Navigator
sub-items are lazy (expand the group first). Push scripts to the VMs with
base64-in-one-shot (a plain `scp` + separate run can leave a 0-byte file).
See `fusion-actions/README.md`.

---

## Fusion Action #2 — PPM_TASK_ADDL_INFO (financial-plan task Organization Reference, 2026-07-09)

Second write-back action type: **update a task's "Additional Information" DFF on a project's
financial plan** (first use: set the *Organization Reference* cost-centre segment). Requested
flow replicated 1:1: My Projects → search Project Number → open project → Tasks drawer →
*Manage Financial Project Plan* → Display=**List** → QBE-filter Task Number → row's
*Additional Information* icon → popup → fill Organization Reference (LOV autosuggest) → OK → Save.

- **DB:** `otbi-atd/db/43_atd_action_ppm.sql` — seeds `PPM_TASK_ADDL_INFO` into the
  `ATD_ACTION_TYPE` lookup. **DEPLOYED 2026-07-09.** That is the ONLY DB change — queue,
  `ATD_ACTION_PKG`, `/atd/actions*` ORDS and the App 208 Actions page are all generic over
  `action_type`. (Script uses plain INSERT-if-absent, no MERGE block — the Linux SQLcl 26.1
  MERGE-swallow gotcha.)
- **Runner:** `actions/ppm_task_addl.py` (+ dispatch branch in `actions/__init__.py`).
  Built on the PROVEN ADF patterns from the read PoC (`docs/fusion-actions/`): `_jsclick`
  (`el.click()` in-DOM — ADF intercepts normal clicks), lazy Navigator groups (expand
  `groupNode_projects` first), `_fill_label` for label-adjacent inputs, long ADF waits.
  **No REST anywhere** — `fscmRestApi` is 401 under ADGOV SSO (PoC finding), so idempotency
  is **UI-based**: the handler reads the popup's current Organization Reference and returns
  "already set — idempotent skip" without saving when it already carries the target. An
  UPDATE is also naturally idempotent (re-applying the same value is a no-op).
- **Payload** (`payload_json`): `{"projectNumber": "...", "taskNumber": "...", "orgReference": "..."}`
  (+ optional `entitySpecific` / `appropriation` / `program` / `bgOverride` /
  `revenueAccountOverride` — the other popup segments). Suggested `idem_key`:
  `PPM-ORGREF:<project>:<task>:<cc>` (include the cc — a later re-point of the same task to a
  NEW cost centre must be a NEW idem_key; DONE rows are never re-armed).
- **Safety:** `ATD_ACTION_LIVE=1` gates the page-level Save; a dry run navigates, filters,
  fills the popup and clicks OK (all in-memory on the ADF page) then raises `DryRun` BEFORE
  Save. After a live Save the handler re-opens the popup and verifies the value stuck
  (read-back) before marking DONE. Step screenshots via `ATD_ACTION_SHOT_DIR` (set
  automatically by the smoke) — the headless-VM way to tune selectors.
- **Smoke:** `smoke_ppm_task.py` + `payload_ppm_task.json` (first trial: project 4511000682,
  task "Annual Reports", cost centre 4510195). HEADLESS by default with screenshots to
  `./ppm_smoke_shots/`; `--headed` on a desktop. On a worker VM:
  ```bash
  # push the two new/changed files base64-in-one-shot (race-free), then dry-run
  for f in actions/ppm_task_addl.py actions/__init__.py smoke_ppm_task.py payload_ppm_task.json; do
    base64 otbi-atd/runner/$f | ssh -i $KEY root@192.168.1.181 "base64 -d > /root/otbi-atd/runner/$f"
  done
  ssh -i $KEY root@192.168.1.181 "cd ~/otbi-atd/runner && source ~/otbi-atd/env.sh && \
    ~/otbi-atd/venv/bin/python -u smoke_ppm_task.py payload_ppm_task.json"
  # review ppm_smoke_shots/*.png; when selectors are confirmed:
  #   ATD_ACTION_LIVE=1 ~/otbi-atd/venv/bin/python -u smoke_ppm_task.py payload_ppm_task.json
  ```
- **Enqueue (via the queue instead of the smoke):**
  ```sql
  DECLARE
    v_id NUMBER;
  BEGIN
    v_id := prod.atd_action_pkg.enqueue_action(
      p_action_type   => 'PPM_TASK_ADDL_INFO',
      p_source_module => 'ATD', p_source_type => 'ADHOC', p_source_id => NULL,
      p_source_ref    => 'Annual Reports @ 4511000682',
      p_idem_key      => 'PPM-ORGREF:4511000682:Annual Reports:4510195',
      p_payload       => '{"projectNumber":"4511000682","taskNumber":"Annual Reports","orgReference":"4510195"}');
  END;
  /
  ```
  The scheduled `runner.py --actions` sweep picks it up (worker must run with
  `ATD_ACTION_LIVE=1` to actually save; otherwise the row fails with the DryRun note).
- **Selector status: VALIDATED LIVE 2026-07-13** — E2E on vm180 (headless): dry-run PASS
  (popup filled, DryRun gate held) then **LIVE run PASS** (Save + read-back verified; trial
  project 4511000682 / task "Annual Reports" / cc 4510195 now carries *DCT ALC Executive
  Director's Office Division*). Final handler synced to vm180/181/182 (md5-verified);
  **restart `atd-worker` on the fleet** so the long-running workers import the new module.
  Unit tests: `tests/test_actions.py` PASS. **ADF selector laws learned in the 19-round tune
  (apply to every future UI action):**
  1. **Visible-first, always** — ADF keeps HIDDEN duplicates in the DOM (topbar Personalize
     spans, pre-rendered dialog buttons) that match text/title selectors FIRST in document
     order. Iterate matches and act on the first `is_visible()` one; in JS filters use
     `offsetParent!==null && getBoundingClientRect().width>0`.
  2. **The af:query Search panel lands COLLAPSED with its inputs NOT in the DOM** — expand
     via a REAL Playwright click on the anchor `a[id$="_afrDscl"]` / `[title="Expand Search"]`
     (header-text clicks and JS clicks never expand it).
  3. **JS value-set does not register in ADF component state** — the query ran empty despite
     the input visually holding the value. Fill with REAL typing (`press_sequentially`) + Tab
     blur; LOV autosuggest also only fires on real keystrokes, and the suggest entry needs a
     REAL click on the VISIBLE row.
  4. **Saved-search defaults over-constrain** — My Projects pre-fills Team Member + Project
     Status=Approved; clear them (Ctrl+A, Delete, Tab) before searching by number.
  5. **Never walk <tr> ancestors to find a row** — the whole page is nested tables + a
     frozen/scrollable grid split. Use the deterministic id scheme instead: Task Number cell
     `…:tt1:<row>:tNum::content` (span in display mode, **input in edit mode** — match both)
     ↔ same row's Additional Information icon `…:tt1:<row>:dffIL1` (swap the suffix).
  6. **ADF panelWindow popups carry NO `role="dialog"`** — detect by the visible title text,
     then walk up to the smallest div containing the field inputs.
  7. **Page-level Save is not a `<button>`** — click the first VISIBLE exact-text "Save"
     element (`get_by_text("Save", exact=True)`).
  8. **After an LOV commit Fusion displays the DESCRIPTION, not the code** — read-back must
     accept the resolved display text captured at fill time (and the idempotency fast-path
     only triggers when the code is visible in the field).
## Fusion Action #3 — `AR_INVOICE_REBILL` (AR invoice VAT rebill), 2026-07-25

Third UI write-back action, and the first **multi-stage saga**. Replaces the manual Receivables
flow: credit an invoice off in full → duplicate it → correct the Tax Classification on the
nominated memo lines → set the Project/Task DFF on each line → complete the duplicate,
capturing both generated **Document Numbers**. The DFF stage sits BEFORE the commit so the saga
has exactly one irreversible step.

- Handler `runner/actions/ar_invoice_rebill.py`; diagnostic `runner/diag_ar.py`.
- DB: `db/52_atd_action_saga.sql` (`ATD_ACTION_STEP` + `ATD_ACTION_SAGA_PKG` +
  `V_ATD_AR_REBILL_REQUEST`), `db/53_atd_action_ar_rebill.sql` (action type + vocabularies).
- Submitted from the **AR app** (App 206) via `final apps/AR/db/11_ar_rebill_ords.sql`;
  `/atd/` stays SYS_ADMIN-only.

**Why a saga, not a single write.** AP_INVOICE and PPM_TASK_ADDL_INFO are single, naturally
idempotent writes. This one CREATES two objects and COMPLETES them, and a completed credit memo
cannot be un-completed in Fusion — only reversed. Every stage is checkpointed in
`ATD_ACTION_STEP`; `resume_from()` returns one past the highest **contiguous** completed stage,
so a later stage is never mistaken for done. Probes: the credit memo is found exactly via the
grid's **Original Transaction Number** column (populated only on credit memos — nothing to
stamp); the duplicate has no such link, so it is stamped `Rebill of <invoice>` in **Comments**.

**PROD-only safety.** `ATD_AR_REBILL_ALLOW` (csv of invoice numbers) refuses any invoice not on
the list; every committing click is gated on `ATD_ACTION_LIVE=1` **per stage**, not once at the
end; `ATD_ACTION_STOP_AFTER=<stage>` steps through the saga.

**ADF selector laws — additions from this build (laws 1-8 from Action #2 all still apply):**
9. **`:has-text()` is a SUBSTRING match — use `:text-is()`.** `a:has-text("Actions")` matched the
   topbar *"Settings and Actions"* first, and `a:has-text("INV00583863")` also matched
   *INV00583863CM*, so the robot opened the credit memo believing it opened the invoice.
10. **Never map grid headers onto `<td>`s by position.** The Manage Transactions grid splits
    headers (`…table2::ch::t`) from data, and the page nests toolbars and saved-search menus in
    tables too: a positional scraper returned **13 confident rows of menu text and zero
    transactions**. Use the id scheme — data cells are `…:table2:<rowIndex>:<component>`
    (`cl1` = Transaction Number, `cl3` = Original Transaction Number).
11. **Prove a probe can read the page before trusting a negative.** "No credit memo found" and
    "I could not read the grid" are indistinguishable and have opposite consequences. Every
    probe first asserts it can see a row it KNOWS is there, and raises otherwise.
12. **Not every field is reachable by label.** The Credit Transaction date inputs sit beside the
    hint *"Press down arrow to access Calendar"*, not beside "Transaction Date" — a label-based
    fill silently no-ops and the memo posts to the default accounting period. Fill by id suffix
    and **read the value back**; a failed fill must raise, never return False.
13. **ADF split buttons expose a `::popEl` dropdown arrow.** Save / Complete and Close /
    Complete and Review each match twice; the `::popEl` one only opens a menu. Exclude it
    (`:not([id$="::popEl"])`).
14. **Menu entries can be `<td>` with empty ids**, and the menu itself needs a REAL pointer
    click — a JS `el.click()` leaves the popup closed so the entries never enter the DOM.
15. **Fields can be collapsed out of the DOM.** Comments on the Create Transaction form sits
    behind *Show More*; expand it first or the write silently never lands.
16. **Keep the diagnostic delegating to the handler's own navigation.** `diag_ar.py` briefly had
    its own copies and "passed" while dumping the wrong page entirely.
17. **An ADF control that LOOKS like a combo box may be a plain `<select>` — check the tag, not
    the picture.** Credit Reason renders exactly like the LOV beside it but is a `<select>`.
    Typing into it does not fail cleanly: on the first dry run (ADGOV pod, 2026-07-25) the
    keystrokes landed in **Transaction Source**, opened its *Search and Select* dialog, and that
    dialog then stole focus from the **Comments** textarea mid-typing, truncating it to
    `Credit I`. **One mis-typed field corrupted three.** Select by option text
    (`_select_option`), and raise listing the real options when nothing matches. `diag_ar.py`
    now dumps a **SELECT DROPDOWNS** section for exactly this reason.
18. **`locator.fill("")` does not reliably clear an ADF date field.** It re-asserts its previous
    value on the focus/blur cycle `fill()` triggers, and the typed text merges with the
    survivor: Accounting Date defaulting to `25/07/2026`, filled with `28/02/2026`, came out as
    **`28/02/20262`** — a malformed date that posts the memo to the wrong period. Clear with a
    real `Control+a` + `Delete`, then type.
19. **Verify against the CONTROL, never the label's neighbour — and treat a prefix match as a
    FAILURE.** The first `_fill_verified` only read the value next to a *label*, so every field
    filled purely by id suffix was never checked at all. Both dates on this form are exactly
    that case: their only nearby text is "Press down arrow to access Calendar". Read the element
    by id, and reject a value that merely *starts with* what was typed — that is the signature
    of a failed clear (law 18), and it is indistinguishable from success on a screenshot.
20. **Only stage 1 navigates; every later stage must be able to navigate too.** Stages inherited
    the page from the stage before, which holds for one clean pass and breaks on ANY resume — a
    fleet retry after a worker restart, or a supervised run picking up mid-saga — because the
    browser then opens cold on FuseWelcome with no search panel. `_search_transaction` takes the
    apps base and re-navigates on demand.
21. **A verified fill is not a permanent fill — Fusion can overwrite a header field AFTER you
    verify it.** Saving an invoice LINE makes Fusion re-run the invoicing rule ("In Advance" on
    these transactions), which re-derives the header **Accounting Date** from the line's Revenue
    Scheduling *Start Date*. Measured end-to-end on 45110096152 (2026-07-25): stage 6 set and
    verified 28/02/2026; stage 7 saved three line drawers; the invoice completed with 18/02/2026 —
    the revenue-schedule start — and every stage reported DONE, because each one was individually
    correct. Laws 18/19 harden the *typing*; they cannot see a later recalculation.
    **Assert any header value that matters again at the LAST point before the commit**, after every
    edit that could recalculate it (`_reassert_header_dates`). The accounting date picks the GL
    period, so the guard raises rather than completing with a date nobody requested — the form is
    uncommitted there, so a resume just rebuilds it at stage 5.

22. **A fallback selector that matches every row will open the FIRST row — never fall back to one.**
    Stage 7 resolved line 3 to grid row 2 correctly, its row-specific Details icon
    (`…:table1:2:commandImageLink110`) missed, and the code fell back to `[title="Details"]`, which
    matches every row's icon. ADF opened **line 1**, and line 3's Project/Task were written over
    line 1's: line 1 finished with task *Urgent requests* instead of *Public Speaker Permit*, line 3
    with **no** DFF at all — and the stage still reported `project/task set on lines 1,2,3`
    (45110096152, 2026-07-25). Resolving the right row and then clicking something else is worse
    than not clicking: the run looks clean and the data is wrong on two lines.
    **Two rules.** (a) A row-targeted click has no generic fallback — if the id misses, raise.
    (b) **The drawer must prove its identity before anything is written into it**: read its
    *Memo Line* and refuse if it is not the requested one. Resolving the correct row is worthless
    if the drawer that opens belongs to a different line, and only the drawer can answer that.
    Corollary: `verify=False` on a fill (needed here because ADF law 8 shows the LOV *description*
    rather than the code) must still be followed by a read-back — substring either way — or a line
    saves with an empty DFF and nothing says so.

23. **Waiting for the line grid after the FIRST line's Save and Close can never succeed by waiting
    alone — saving that line COMMITS the transaction and the page morphs underneath you.** The
    Create Transaction form reloads as the Edit Transaction page, which opens on the
    **Distribution tab**, sometimes behind an Information dialog, so the grid is genuinely not on
    screen (all four fresh-path failures of the 2026-07-26 batch, e.g. INV00583821: "Save and Close
    was clicked but the line grid never came back"). A grid wait must be able to SURFACE the grid:
    dismiss the dialog, click the Invoice Lines tab, then re-read (`_ensure_line_grid`) — the same
    dance `_stage_dup_edit` already did for the resume path, now applied to every grid wait because
    the morph happens mid-stage-7 on every fresh invoice.

24. **The payload's matching key is the MEMO LINE, and it selects EVERY row carrying it** (user
    rules 2026-07-26). `lineNumber` is optional everywhere (runner `validate_payload`, AR ORDS
    bridge, JET form/bulk) and defaults to payload position; a payload repeating a memo line is
    rejected as ambiguous at validation. The grid rows are resolved by memo line
    (`_dup_rows_for_line`) — Fusion's line order need not match the sheet's (proven live on
    45110096166, whose lines were reversed vs the sheet). **ALL matching rows get the treatment:**
    45110096161's duplicate carried TWO 'Entertainer Permit' lines while the request named one —
    the first pass taxed one and left the other with no tax classification and no Project/Task
    (correctly logged as `left untouched`, but wrong by the user's intent; they fixed it by hand).
    Same memo, same treatment, every row — stage 6 taxes and stage 7 DFFs each matching row
    (`_dff_one_row` per row, context re-asserted between rows because the first save commits).

**Harvested ids (ADGOV pod, 2026-07-25).** Credit Transaction (`…:ap1:`): `it1` transaction
number · `id1` transaction date · `id2` accounting date · `selectOneChoice2` credit reason
(**a `<select>`, see law 17 — choose an option, never type**) · `HdrComments` comments ·
`creditEntireBal` button · `batchsourceseq` Transaction Source (**prefilled `DCT_SYSTEM`; NOT
ours to set — the handler asserts it was not overwritten before completing the memo**). Duplicate / Create Transaction (`…:TCF:0:ap1:`):
`batchSourceId` source · `tdt` transaction date · `inputDate9` accounting date · `showMore` ·
line grid `AT1:_ATp:table1:<row>:memoLineNameId` / `:taxClassificationCodeId`. Search rail
magnifier = `title="Search: Transactions"` (**never** bare `title="Search"` — that is the topbar).

**Status: LIVE — 9 invoices rebilled (2026-07-25/26), including a 6-invoice PARALLEL batch across
all three worker VMs.**

| Run | Invoice | Credit memo doc | New invoice doc | Result |
|---|---|---|---|---|
| 1 (supervised, stage-by-stage) | INV00584150 | 45110096149 | 45110096150 | 9/9 after ~12 in-flight repairs; laws 9-20 came out of it |
| 2 (**unattended `--auto`**) | INV00585046 | 45110096151 | 45110096152 | 9/9 clean, end-to-end 7:34, zero interventions |
| 3 (resumed across a VM panic) | INV00583744 | 45110096153 | 45110096154 | law 22 fixes proven on the resume path |
| batch (2026-07-26, 2 invoices/VM) | INV00583821 · INV00583637 (vm180); INV00584156 · INV00584327 (vm181); INV00584992 · INV00584064 (vm182) | see AR deployment-notes | 45110096160-… | law 23 found + fixed mid-batch; the 3 pre-fix starts failed loudly at stage 7 line 1 and resumed clean; every post-fix start ran 9/9 unattended |

**Two defects found in run 2, both "stage reported DONE while the write did not land":**
- **Wrong-line DFF (law 22, the serious one).** Line 3's Details icon missed and a generic fallback
  opened line 1, so line 3's Project/Task overwrote line 1's: line 1 got task *Urgent requests*,
  line 3 got nothing, and the stage logged `set on lines 1,2,3`. Fixed — no generic fallback, the
  drawer must prove its Memo Line, and both values are read back before the line is saved.
  **Proven live in the 2026-07-26 batch** (fresh path INV00584327 + all resumes).
- Accounting Date completed as 18/02/2026 rather than the requested 28/02/2026 (law 21). Guard
  added; **user has deprioritised this** — both dates fall in the same GL period.

**GO-LIVE CAMPAIGN (2026-07-26, later the same night): 110/110 invoices DONE.** The user uploaded
the remaining 101 invoices through the AR page; the fleet drained them in parallel in ~3.5h
(~2 min/invoice fleet throughput), zero data defects. Operational lessons now encoded:
- **Requeueing MUST reset `attempts=0`** — the allowlist failures had left every row at 3/4
  attempts, one hiccup from permanent failure.
- Session-failure rows (`env/session unavailable: MFA not approved…`, always 0/9 stages) are safe
  to auto-requeue blindly; anything else stays FAILED for review.
- **The worker heartbeat now beats DURING the actions drain** (`_drain_actions_idle` calls
  `_heartbeat(BUSY, "ACTION <type> <ref>")` per claim and IDLE when the queue empties) — before
  this, the ATD dashboard showed the whole fleet IDLE / "last seen 239m ago" all night while it
  was flat out, because only the extract loop ever beat. The dashboard also gained a
  **"Fusion Actions — Recent"** region (ATD v1.24.0) so extracts AND actions monitor from the
  single view.

**Batch mechanics (2026-07-26):** `run_rebill_batch.sh` on each VM = sequential
`step_ar_rebill.py <payload> --ctl .ar_batch/<INV> --auto` per invoice, launched detached
(`setsid`), one ctl/screenshot dir per invoice so any failure resumes individually. Payloads are
generated from the flat CSV by `gen_payloads.py` — memo-line keyed, no line numbers (law 24).
A failed invoice never blocks the next; rc summary in `.ar_batch/batch.log`.

Per-stage cost of run 2 (this is the number that decides whether bulk upload is viable):
`LOCATE 58s · CM_CREATE 107s · CM_CONFIRM 6s · CM_CAPTURE 69s · DUPLICATE 80s · DUP_EDIT 21s ·
DUP_LINE_DFF 89s · DUP_COMPLETE 21s · DUP_CAPTURE 7s` = 457s of stage time. ~212s of that is
hard-coded `time.sleep`, so condition-based waits are the obvious next optimisation.

**Unattended runs must be detached** (`systemd-run --unit=ar-rebill --setenv=HOME=/root`): an ssh
disconnect SIGHUPs the run mid-saga, and stages 5-8 share ONE in-memory Create Transaction form.
Note `env.sh` sets `TNS_ADMIN="$HOME/wallet"` — systemd-run has no `$HOME`, so without `--setenv`
every DB call dies with `DPY-4026: /wallet/tnsnames.ora is missing`.

- **UI (2026-07-09, ATD APP_VERSION 1.20.0):** App 208 **"Manage Projects Org"** page (route
  `projectsOrg`) — single-row form + **Excel bulk upload** (SheetJS client-side parse + template
  download) + recent-actions list. Backed by additive **`otbi-atd/db/44_atd_ppm_org_ords.sql`**
  (`POST /atd/actions/enqueue`, ≤500 rows/req, per-row result; DEPLOYED + API/browser-verified).
  **13 re-run ⇒ re-run 20, 38, 41, 42, 44, 45.** Details in `final apps/ATD/docs/deployment-notes.md`.
- **LOVs + fleet actions drain (2026-07-13, ATD APP_VERSION 1.21.0):** additive
  **`otbi-atd/db/45_atd_ppm_lov_ords.sql`** = `GET /atd/actions/ppmlov?type=project|task|cc
  [&search=][&project=]` type-ahead lists (sources `prod.atd_projects`/`prod.atd_tasks`/
  `prod.dct_gl_coa_v`; **`q=` is reserved by ORDS — use `search=`**; validate params BEFORE
  `json_header`) feeding `<datalist>`s on the 3 required form inputs (project searchable by number
  or name; tasks per typed project; suggestion-only, free text preserved — the extract is a
  snapshot). AND the worker fleet now drains the ACTIONS queue: `runner.py`
  `_drain_actions_idle` runs in the `--worker --forever` idle path (before this, NOTHING on the
  VMs ran `--actions`, so UI-enqueued actions sat READY forever); `ATD_ACTION_LIVE=1` set in each
  VM's `env.sh`; fleet synced + restarted. The actions queue (`ATD_ACTION_REQUEST`) is SEPARATE
  from the extract queue (`ATD_OTBI_JOBS`) — same fleet + SSO session, different tables/claim pkgs.
- **Projects Budget incremental delta-load (2026-07-21):** split the slow (4+ min) hourly
  full extract into a **daily full baseline + hourly 24h delta**. Two jobs share the target
  `PROD.ATD_PROJECTS_BUDGET`:
  * `Projects Budget Full` — analysis `…/Projects/PROJECTS_BUDGET_PERIODS`, `TRUNCATE_INSERT`,
    now `frequency_minutes=1440` (was 60). The authoritative baseline; the ONLY path that
    reflects deletes / closed lines (a delta MERGE cannot).
  * `Projects Budget Incremental` — analysis `…/PROJECTS_BUDGET_PERIODS_UH24` (a Save-As copy of
    the base with a baked SQL-expression filter `"Update Date" >= TIMESTAMPADD(SQL_TSI_HOUR,-24,
    CURRENT_TIMESTAMP)`, evaluated pod-side so NO runner-clock/TZ coupling), `MERGE`, stage
    `PROD.ATD_PROJECT_BUDGET_STG`, `final PROD.ATD_PROJECTS_BUDGET`, `key_columns=
    PROJECT_ID,TASK_ID,EXPENDITURE_TYPE,ACCOUNTING_PERIOD` (verified UNIQUE — 0 dup groups over
    1,836 rows; the natural grain the view `db/v2/37` SUMs over), `frequency_minutes=60`.
  Scripts: **`otbi-atd/db/50_atd_projects_budget_incremental.sql`** (stage table + job register,
  re-runnable/inert) + **`50b_enable_projects_budget_incremental.sql`** (point at variant +
  enable + the daily flip). E2E verified: variant returns 25 rows (last-24h) vs 1,836 full;
  fleet-driven run 6118 SUCCESS 25 rows; post-MERGE count stable at 1,836, 0 dup key groups, all
  25 delta keys upserted.
  * **Considered but rejected: a single-analysis "optional filter" via a Go-URL P0..PN filter
    override (Option A).** The extract framework NEVER passes filters to an analysis at request
    time — every filter is baked into the analysis (`copy_analysis.add_relative_filter` /
    `schedgen` `_F`/`_UH`/`_U10M`). Runtime override is unproven on the ADGOV pod for
    `Action=Download` and would couple the filter value to the runner clock. Went with the proven
    baked-variant approach.
  * **To regenerate the variant** (e.g. after the base analysis columns change): reuse
    `copy_analysis.do_copy(page, BASE, SRC, "PROJECTS_BUDGET_PERIODS_UH24", hour=24,
    on_column="Update Date")` on a worker VM with a live session, or `schedgen` for the standard
    `_UH`/`_U10M` windows. Keep the base and `_UH24` column sets in lockstep (the incremental job
    reuses the full job's `column_map_json`, matched by header name not position).
  * **Window is baked in the analysis (24h), cadence is per-job (`frequency_minutes`).** To change
    the look-back, regenerate the variant with a different `hour=`; to change how often it runs,
    edit `frequency_minutes` on the job row.
- **AP/PR/PO incremental delta-load — LIVE 2026-07-21 (rolled out the Projects Budget pattern):**
  applied the daily-full + hourly-24h-delta-MERGE pattern to six more slow full-refresh extracts.
  Scripts `otbi-atd/db/51_atd_ap_pr_po_incremental.sql` (6 stage tables + 6 disabled MERGE jobs)
  + `51b_enable_ap_pr_po_incremental.sql` (point at variants + enable). Each full job is unchanged
  and still daily; a new `<Name> Incremental` MERGE job (frequency 60) reads a baked `_UH24` variant
  (`<update col> >= TIMESTAMPADD(SQL_TSI_HOUR,-24,CURRENT_TIMESTAMP)`):
  | Incremental job | Variant | Update col | Target | Key (verified UNIQUE) |
  |---|---|---|---|---|
  | AP Invoices Incremental | AP_INVOICES_UH24 | Last Updated Date | ATD_AP_INVOICES | INVOICE_ID |
  | AP Invoice Lines Incremental | AP_INVOICE_LINES_UH24 | Last Updated Date | ATD_AP_INVOICE_LINES | INVOICE_ID, INVOICE_LINE_NUMBER |
  | AP Distributions Incremental | AP_INVOICE_DISTRIBUTIONS_UH24 | Last Updated Date | ATD_AP_INVOICE_DISTRIBUTIONS | INVOICE_ID, LINE_NUMBER, DISTRIBUTION_LINE_NUMBER |
  | PR Headers Incremental | 01_PR_HEADERS_UH24 | Last Updated Date | ATD_PR_HEADERS | PR_HEADER_ID |
  | PR Lines Incremental | 01_PR_LINES_UH24 | Last Updated Date | ATD_PR_LINES | PR_LINE_ID |
  | PO Headers Incremental | PO_HEADERS_UH24 | Updated Date | ATD_PO_HEADERS | PO_HEADER_ID |
  E2E verified: all 6 variants built in one MFA session; each incremental ran (443/460/757/125/201/87
  delta rows), MERGE integrity clean (0 dup groups on every target; counts rose only by genuinely new
  keys). **Not converted: GL_ACCOUNTS_COMBINATIONS + GL Balances** — their analyses have NO last-update
  column, so a date-delta isn't possible without adding one (GL combos is slow ~217s max — worth adding
  a column later). Batch variant creation = `mk_uh24_batch.py` style (copy_analysis.do_copy per spec on
  a worker; one MFA covers all).

## 2026-08-11 — PROJECTS_BUDGET_PERIODS OTBI breakage: investigation (probe_budget.py)
Both Projects Budget jobs (Full + Incremental) started FAILING 100% around 2026-08-09/10:
HTTP **500 after ~570 s** on the Go-URL (raw WebLogic error page — the request thread is
killed before OTBI even renders an error). The last clean Full run (Aug 9 05:44) already
took 247 s vs the 57 s historical average — the underlying query cost was growing fast,
then crossed the web-tier kill threshold. **All 45 other jobs are 100% healthy** (incl.
Projects Full / Tasks Full), so it is specific to the `Project Control - Budgets Real
Time` subject area query, NOT the pod/session/runner.

Isolated with `runner/probe_budget.py` (attaches via `auth.authenticate` on a worker VM —
stop atd-worker first; modes: dump / run / ladder / ladder2 / each / final / sql / base).
Timed logical-SQL probes (same columns + BU/FY filters as the analysis):

| Scope | Result |
|---|---|
| 1 project (`=`), any of 5 tested | **1.9–9.1 s** |
| `IN (p1, p1)` (collapses to 1 value) | 1.8 s |
| 2 distinct projects (`IN` or `OR`) | **341–350 s** |
| `BETWEEN` covering ~6 projects | killed @577 s |
| 5 distinct projects | killed @566 s |
| full scope (624 projects) — even WITHOUT currency var / ORDER BY | killed @571 s |
| **one Fiscal Period `= '01-2026'`, ALL projects** | **165 s, 1,528 rows** (reconciles ~97% to the Aug-11 manual load; delta = live churn) |

Conclusions: (1) the BI Server only pushes a **single-value equality** on
`"Project"."Project Key"` into the fact/budget-version join; ANY multi-project predicate
(IN/OR/BETWEEN/none) takes a catastrophic plan whose fixed cost now exceeds ~9.5 min.
(2) Go-URL `P0..P3` runtime filters are silently IGNORED for `Action=Download` on this pod
(1-project P-filter run died at 568 s while the same semantics via `&SQL=` took 1.9 s) —
confirms the "baked variants only" rule. (3) `FETCH FIRST … ROWS ONLY` is rejected by the
`&SQL=` parser (nQSError 27002) though the Answers editor shows it. (4) OTBI CSV export
itself emits Excel-style `'`-prefixed numerics occasionally (2 rows in the period slice) —
the same artifact seen in the user's manual export.
Viable workaround (not yet implemented): **chunk the Full extract by Fiscal Period** —
12 Go-URL `&SQL=` requests (~165 s worst, most periods tiny), concatenate, then
TRUNCATE_INSERT. Root cause is Fusion-side (budget-version data growth / plan regression
since ~Aug 8) — raise an SR / ask the Fusion admin to investigate; historical norm was
57 s for the whole extract. Both jobs left DISABLED; `ATD_PROJECTS_BUDGET` holds the
2026-08-11 manual load (1,896 rows / 7.643B).

## 2026-08-11 — Projects Budget Full: period-chunked extraction LIVE (sqlchunks.py + db/61)

The workaround above is implemented and deployed. New runner module
`runner/sqlchunks.py`: a job whose `params_json` carries the `_atd_sql_chunks`
directive is extracted as N raw logical-SQL Go-URL requests (`&SQL=`, one per
chunk value substituted into a `{chunk}` placeholder) concatenated into ONE CSV
for the unchanged prepare/load pipeline. Routed from `extract.download_job`
(third dispatch leg, after the `.xdo` BIP leg). The directive's `headers` map is
whitelist + rename in one: a `&SQL=` export emits presentation-layer headers
plus a junk literal `0` column (the Answers `SELECT 0 s_0` convention), which do
NOT match the saved analysis' custom headings the job's `column_map_json` keys
on — only mapped headers are emitted, under the map's value text (the bip.py
trick), so `load.resolve_pairs` matches and prepare's drift engine stays quiet.
Values also get the Excel-marker apostrophe stripped (`'-42339` → `-42339` — an
OTBI export artifact). Guards: an OTBI "No Results" page = an empty chunk (not
an error); sign-in bounce → SessionExpired (worker re-auths); any other chunk
failure retries once then FAILS the job **before** the load runs, and a
`min_rows` floor (1000) refuses to TRUNCATE_INSERT a suspiciously small result.
`db/61_projects_budget_chunked.sql` seeds the directive (12 chunks
`01-2026`..`12-2026`) + re-enables **Projects Budget Full**; **Projects Budget
Incremental stays DISABLED** (the daily chunked Full covers it; its analysis
would hit the same bad plan). Year rollover: the fiscal year is baked into BOTH
the `sql` text and the `chunks` list in params_json — edit both together.

First live run (vm180 one-shot, run_id 10647): **SUCCESS, 35.7 min, 1,852
rows / 7.603B / 615 projects**. Every chunk costs the ~3-min plan price
regardless of row count (161–226 s each; 01-2026 = 1,528 of the 1,852 rows) —
the total is pure per-query plan cost × 12, so the job is slow-but-reliable
until Fusion fixes the subject area (SR still warranted; historical norm 57 s
total). Delta vs the same-day manual Excel load (1,896/7.643B/624) = 9 projects
/ 45 rows / 40.2M that the live analysis no longer returns AT ALL (verified —
the old full extract would drop them identically): live budget-version churn,
not a chunking gap. Old load backed up in `PROD.ATD_PROJECTS_BUDGET_BAK_20260811`.
Deploy = `sqlchunks.py` + `extract.py` to all 3 workers + **systemctl restart
atd-worker** (long-running workers hold the OLD extract.py, which would urlencode
the directive onto the Go-URL) + db/61 via SQLcl.

**Chunk-count optimization probed 2026-08-13 — DEAD END:** `Fiscal Period IN (2 values)` =
362s (exactly 2× the single-equality cost) and `IN (11 values)` = killed at 576s — the BI
Server pays the full plan cost PER IN MEMBER for period predicates too, same as projects.
So the 12-chunk shape cannot be collapsed; the only remaining speed lever is running chunks
CONCURRENTLY (3–4 parallel `&SQL=` requests ≈ 9–12 min wall), untested. ALSO learned: the 9
projects in the manual Excel load but absent from every live extract are ALL `6171xxxxxx`
AFH (Abrahamic Family House) projects — the saved analysis' BU filter
(DESCRIPTOR_IDOF IN (300000002427529, 300000324906601)) covers only 2 of the 3 BUs; the
manual export evidently included AFH. Adding AFH = one more id in that IN (params_json sql
+ the saved analysis). AND a master-lag gotcha: a budget line on a task created TODAY loads
fine, but the butil view hides it until Tasks Full refreshes ATD_TASKS (missing-master
'#'-id exclusion) — seen live with project 4511000339; remedy = run Tasks Full.

**2026-08-13 — AFH scope + parallel chunks LIVE (db/64 + sqlchunks.py v2):** three
user-approved changes. ① PROJECTS_DAILY set frequency 1440→720 (a manual afternoon run can
no longer make the next 09:00–10:00 Dubai window skip a day — the 1-h window still caps it
at once daily). ② The chunk SQL's BU filter gains **Abrahamic Family House
(DESCRIPTOR_IDOF 300000034874765)** alongside DCT + MSS — restores the 9 AFH `6171xxxxxx`
projects (45 rows / ~40M). ③ `"parallel": 4` in the directive — sqlchunks.py now fetches
chunks 4-at-a-time over plain urllib threads with the context's cookies (sync Playwright is
NOT thread-safe — never call it from the pool); missed chunks fall back to the sequential
Playwright path with full session triage. Verified run 11238: **SUCCESS in 19 SECONDS**,
1,898 rows / 7.660B / 625 projects incl. all 45 AFH rows. The 19s (vs the projected ~10
min) means the 3-BU chunk queries ran at good-plan speed — either the 3-value IN dodges the
catastrophic plan the 2-value one triggered, or the day's probing left the fact slices hot;
expect anywhere from seconds (warm) to ~10-12 min (cold, 3 waves × ~195s) — both ≪ the 35
min sequential shape. Deploy = sqlchunks.py to all 3 workers + restart, then db/64.

**db/65 (2026-08-13): `Projects Budget Full - V2`** — user-requested on-demand twin of the
daily job for the Jobs-page Enqueue button: same chunked directive but `"parallel": 6`
(2 waves), frequency 525600 + no set membership so the sweep never auto-fires it. First
run: SUCCESS in **20s** (1,898 rows). Same TRUNCATE_INSERT target as the daily job — avoid
firing it during the 09:00–10:00 Dubai window. Rerunnable count-then-insert; re-running 65
also re-syncs V2's params/source/column-map from the original job.

**db/66 (2026-08-13): V2 is now THE budget extract — HOURLY.** Original Projects Budget
Full DISABLED (rollback = re-enable + disable V2), Incremental stays disabled, V2
frequency 60. User asked for 10 min; recommended+applied 60 because the enqueue sweep is
15-min (10 unachievable) and each run = 12 heavy OTBI queries — hourly is near-real-time
for budget-version churn at a quarter of the load. On-demand refresh = Jobs-page Enqueue
(~20s warm). Frequency editable in the Jobs UI (15 = practical floor).

**db/67 (2026-08-13): job set PROJECTS_DATA** — Projects Full + Tasks Full + Projects Budget
Full - V2 in ONE set, **hourly, no window** (masters moved OUT of PROJECTS_DAILY — one set per
job; PROJECTS_DAILY keeps only the disabled legacy budget job). Closes the master-lag gap (a
same-day new task+budget line now lands within the hour together). Runnable on demand from the
GL Project Budget Utilization page ("Refresh source data" button → GL/db/19 bridge →
atd_set_pkg.run_now). Hourly masters = ~2 extra light queries/hour — deliberate.

## 2026-08-14 — Transaction Distribution - All: chunked + service account (db/68)

The user-created AR job was triple-broken: the saved analysis lives in a PRIVATE catalog
folder (`/users/saljaaidi@…` — the service account gets Path-not-found, so every run needed
c-saljaaidi personal MFA approvals via the db/62 credential profiles), it selects the WHOLE
`Receivables - Transactions Real Time` SA with NO filter (461,678 rows), and its DOWNLOAD
phase hit **889s of the 900s timeout** — one growth week from permanent failure. Converted
to the chunked logical-SQL extract (db/68, generator `runner/txd_def.py`): **19 chunks
partitioning the space by construction** (dim accounting-date IS NULL [58,938 rows — 12.8%
of the table has no accounting date!] + past guard + Dec-2025 split 4 ways by Accounting
Class w/ null-safe catch-all [ALL of 2025 sits in month 2025/12 = migration entries] + 12
monthly 2026 ranges + open ≥2027 tail), **positional `#N` headers** (new sqlchunks feature —
two logical columns both export as 'Accounting Date', so text keys can't disambiguate; the
authored SELECT fixes positions), parallel 6, min_rows 300k, `requested_by` cleared.
Verified run 11500: **SUCCESS 5.8 min, 461,678 rows — byte-identical to the personal-session
single-shot** (parallel pass = 19/19 chunks in 134s; the balance is CSV parse + load). Now
runs on the SERVICE account — no personal MFA, no catalog dependency. TWO new sqlchunks
lessons: ① an EMPTY `&SQL=` result exports a one-cell body "The query resulted in no rows"
(plain text, NOT the HTML No-Results view) — handled as a valid 0-row chunk; ② a `&SQL=`
export's headers are the SA presentation names, which CAN match the saved analysis' headings
(here all 30 matched exactly) — but positional keys are still safer for authored selects.
The probes also confirmed the service account CAN query the Receivables SA via `&SQL=` even
though it cannot read the private catalog path. Rollover: extend the 2026 month list in
db/68/txd_def.py when 2027 volume grows — the ≥2027 tail catches everything until then.

## 2026-08-14 — AR_INVOICE_LINES: chunked conversion (db/69) + morning window (db/70)

Same triple-break as Transaction Distribution (private saljaaidi catalog path, personal-MFA
runs, no-filter full-SA select) but WORSE: the single shot is killed at ~570s every time —
the job NEVER completed once (no map/table). Converted (generator `runner/aril_def.py`):
**27 chunks** (dim-date NULL × class + past guard + the 2025-12-31 Revenue migration lump
[48,297] alone + Dec remainder × class + Jan–Aug 2026 month × class + merged Sep–Dec + ≥2027
tail + class catch-alls), positional `#N` headers (38 clean columns; classes at line grain =
Revenue/Unearned Revenue only), the analysis' `Transaction Line Type <> 'TAX'` filter in
every chunk, min_rows 250k (probed total **320,750** via fast aggregate `&SQL=` — aggregates
stay cheap even when detail queries die). First run auto-prepares the table+map.
**NOT yet completed — the pod's cost for this query class swings ~8× within hours**: the
same 18k chunk ran 76.8s at midday and was killed at ~570s by afternoon, WITH or WITHOUT the
Project dim join (A/B-proven — server state, not SQL shape); afternoon retries also triggered
transient **502 cascades** from the saw tier. db/70 parks the job in the new **AR_MORNING**
set (daily 05:00–07:00 Dubai window) so it completes in the pod's quiet hour instead of
hammering PROD. THREE sqlchunks hardenings shipped from this saga (fleet-deployed):
① `parallel` death-spiral lesson — concurrent heavy chunks slow each other past the 570s
kill (probe-fast ≠ pool-fast; this job runs parallel:1); ② the OBIEE **JS landing page**
("please enable javascript"/doFrameBust) now maps to SessionExpired → worker re-auths, not
ReportError; ③ ALL first-pass fetches go through the urllib pool even at parallel=1 — rapid
back-to-back Playwright ctx.request downloads pick up rotated cookies and start drawing the
landing page mid-sequence, while the fixed-cookie urllib path survives long sequences.
Accumulated evidence for the Fusion SR: budget-SA plan regression (Aug 9) + AR full-scope
kills + intraday 8× cost swings + 502 cascades = one platform-side degradation story.

## 2026-08-16 — Custom-heading pinning platform-wide (pin_batch.py) + heading-drift heal

**Root cause of the supplier-name regression class:** the runner's CSV header = the
analysis' displayed **Column Heading** (never the formula). A Fusion patch changed several
subject-area *default* headings ('Supplier Name'→'Supplier' on PO Headers + PR Lines,
'Legal Name'→'DataFox Legal Name' on Suppliers; the AP Invoices renames hit only the UH24
copy: 'GL Date'→'Invoice Accounting Date', 'Cancelled Date'→'Invoice Canceled Date',
'Inter Company Flag'→'Intercompany Invoice Indicator', 'Pay Alone Flag'→'Pay alone',
'Party Site Name'→'Supplier or Party Site'). Drift then auto-added new columns and
NULL-loaded the old ones — ATD_PO_HEADERS.SUPPLIER_NAME went 0/4,412, ATD_PR_LINES 0/9,784,
and every AP UH24 merge punched intraday NULL holes in GL_DATE etc. that the nightly Full
repaired.

**Fix (user decision):** pin **every column of every extract analysis** with *Custom
Headings* = the exact colmap heading, so patches can never rename a CSV header again.

- `runner/copy_analysis.py` gained `--probe-formula` (dialog discovery), `_headings()` /
  `_gear_exact()` (exact-match, **sort-order badge prefix stripped** — sorted columns
  render '2<TAB><NBSP>Heading'), `pin_heading()` (gear → Edit formula → tick `customHdg`
  checkbox → fill `columnHdg` input → OK; the dialog fields have NO ids, only stable
  `name=` attrs), and `do_pin()` (pin all + Save over same name + verify heading set).
- `runner/gen_pin_plans.py` builds `pin_plans.json` from PROD.ATD_OTBI_JOBS colmaps
  (strays dropped from `expected`, drifted names mapped back via `renames`).
- `runner/pin_batch.py` runs the whole set in ONE authenticated session.
- **Result: 35/35 analyses PASS** (~620 columns pinned; renames applied on PO Headers,
  PR Lines, Suppliers). AP Invoices Full was verified to still carry the OLD headings —
  only its UH24 copy had drifted. 'Header Batch Name' is GONE from the AP analysis
  (removed by Fusion, cannot be pinned back; column stays NULL until the field is re-added
  from the subject area).
- `runner/regen_uh24.py` — regenerates ALL 13 _UH24 incremental copies from the pinned
  Fulls (Save-As over the same catalog name + fresh 24h TIMESTAMPADD filter + CSV verify),
  so Full and UH24 headings can never diverge again. **RULE: after ANY heading/column
  change to a Full analysis, re-run regen_uh24.py for that family.**
- Audit deliverable: `docs/otbi-heading-review.md` — every job's heading→column→type map,
  orphan columns, and 14-day drift/row warnings, with the priority findings table.

Follow-up (same day): trigger PO Headers Full / PR Lines All / Suppliers Full / AP
Invoices Full reloads (heals SUPPLIER_NAME platform-wide), then cleanup round — drop
stray/dup columns (SUPPLIER ×2, DATAFOX_LEGAL_NAME, the 5 AP new-name columns,
THE_QUERY_RESULTED_IN_NO_R ×2, orphan _2 halves), remove stray colmap keys, and fix
wrong types (PR SECTOR DATE→VARCHAR2, text dates→DATE, PO ORDERED_AMOUNT/RATE→NUMBER,
AP INVOICE_GROUP NUMBER→VARCHAR2(60) — free-text seen in Fusion).

## 2026-08-16 (2) — Heading-drift heal EXECUTED + cleanup round (same day)

- **Heal verified:** PO Headers / PR Lines / Suppliers / AP Invoices Fulls reloaded —
  `ATD_PO_HEADERS.SUPPLIER_NAME` 4,412/4,412 (was 0), `ATD_PR_LINES.SUPPLIER_NAME` 6,499
  (rest genuinely supplier-less), AP `GL_DATE` intact. Supplier names back on every GL
  butil register / PO view surface with zero view changes.
- **`AP Invoices Full` had `requested_by='ADMIN'` stamped on the JOB row** — every run
  (incl. scheduled) took the personal-credential path (saljaaidi MFA) and had been failing
  since ~13-Aug. Tag CLEARED → service account. RULE: a persistent `requested_by` on
  `atd_otbi_jobs` re-routes every future run to that user's credential profile; clear it
  after one-off personal runs.
- **Cleanup executed** (`cleanup_phase6.py`, python-oracledb on vm180): stray colmap keys
  removed (Supplier ×2 jobs, DataFox Legal Name ×2, the 5 AP new-name keys + 'Header Batch
  Name' [field REMOVED from the subject area — key removed to stop the every-run warning;
  column kept for AP_INVOICES_HEADER_V.BATCH_NAME] ×2); stray/orphan columns dropped from
  finals AND `_STG` twins (SUPPLIER ×2, DATAFOX_LEGAL_NAME, 5 AP new-name cols,
  THE_QUERY_RESULTED_IN_NO_R ×2 [an error-page export had become a "column"], orphan `_2`
  halves: ATD_PO_SCHEDULES.BUSINESS_UNIT / ATD_PAYMENTS.PAYMENT_DATE /
  ATD_SUPPLIER_SITES.LEGAL_ADDRESS).
- **Type fixes** (values sampled clean first; stage twins truncated+mirrored):
  ATD_PR_HEADERS SECTOR/SECTOR_DESCRIPTION DATE→VARCHAR2(100/300), LAST_UPDATED_DATE +
  CANCEL_DATE →DATE; ATD_PR_LINES APPROVED_DATE + ACCOUNTING_DATE →DATE ('0-00-00' rows
  warn+NULL by design); ATD_PO_HEADERS ORDERED_AMOUNT + RATE →NUMBER, SUBMIT_DATE →DATE;
  ATD_AP_INVOICES INVOICE_GROUP NUMBER→VARCHAR2(60) (free text seen in Fusion). Wiped
  columns repopulated by same-day forced Full reloads (queue gate bypassed via
  `atd_queue_pkg.enqueue(p_only)`).
- **db/v2/46 patched + redeployed** (po_header_v + po_schedules_v via python-oracledb):
  `submitted_date`/`ordered_amount` now read the typed columns directly (the old
  `TO_DATE(date_col,'YYYY-MM-DD') DEFAULT NULL ON CONVERSION ERROR` would silently NULL
  after the type flip), and **PO_SCHEDULES_V.business_unit re-pointed
  BUSINESS_UNIT→BUSINESS_UNIT_2** — the view had been exposing the empty orphan column
  (pre-existing silent bug; it now returns real BU names). 0 INVALID after
  dct_views_rebuild + recompile.
- GOTCHA (bit twice today): grepping `table|column` on ONE line misses view references —
  `s.business_unit` sat lines away from the table name; PO_SCHEDULES_V went INVALID on the
  orphan drop. Verify column drops with a live `ALL_ERRORS`/INVALID sweep, not repo grep.

## 2026-08-16 (3) — 'Header Batch Name' + 'Legal Name' REMOVED end-to-end (user request)

Both fields removed everywhere (both were 0-populated: the AP field left the Fusion
subject area; supplier Legal Name is empty in Fusion itself):

- **OTBI:** 'Legal Name' column deleted from `01-Suppliers` (copy_analysis --edit) +
  `SUPPLIERS_UH24` regenerated (header verified without it). 'Header Batch Name' was
  already absent from both AP analyses.
- **Jobs:** 'Legal Name' key removed from Suppliers Full/Incremental colmaps (now 14 keys);
  AP 'Header Batch Name' keys were removed earlier the same day.
- **DB:** dropped ATD_SUPPLIERS.LEGAL_NAME and ATD_AP_INVOICES.HEADER_BATCH_NAME (+ both
  `_STG` twins); `dct_views_rebuild` (16) + recompile sweep → 0 INVALID.
- **AP module (v1.18.1):** AP_INVOICES_HEADER_V recreated WITHOUT `BATCH_NAME`
  (`AP/db/05` edited); invoice-drill handler redefined without `batchName`
  (`AP/db/03` part 5 re-run standalone via python-oracledb — safe: the invoices/:id
  template's only handler is defined in that same part); drill modal Batch row +
  `dr.batch` i18n keys (EN+AR) removed; **frontend hot-patched into the LIVE webtier
  release** (only the 4 changed AP files tar'd into `/var/www/ifinance/current/` as
  opc+sudo + restorecon — a full deploy_frontend.sh run was AVOIDED because the working
  tree carried other sessions' in-progress frontend work; webtier ssh login is `opc`,
  not root).

## 2026-08-16 (4) — the two salmen AR jobs converted to chunked + service account (db/71+72)

Projects-Budget-V2 treatment applied to 'AR Invoice Distribution Details - ALL' and
'AR INVOICE LINES - ALL' (user request). Root causes found by dumping the analyses'
OWN logical SQL from the Answers Advanced tab (get_ar_sql.py pattern — read-only, via
the job-owner credential path `config.resolve_job_cred`, warm c-saljaaidi profile):

- **The "500k export cap" was `FETCH FIRST 500001 ROWS ONLY` INSIDE the analysis** —
  every 30-min load truncated a ~575k-row space to 500,000 (~71k distribution rows +
  7,255 whole transactions never reached the table).
- The lines analysis is pure LINE grain (122,615, filter IDOF(Line Type) <> 'TAX') —
  the never-deployed db/69 aril_def was MIXED grain (distribution columns fanned it to
  320,750); superseded by arl_def.py. Lines chunk on the LINE-grain Creation Date —
  never a distribution-dim date (straddling lines would duplicate).
- Why the jobs ran personal at all: `requested_by` was NULL, but the v1.37.0
  **path-owner rule matches `/users/saljaaidi/` in source_ref** — so conversion also
  swaps source_ref to a `chunked-sql: ...` token (sqlchunks never touches the catalog).

Deployed (python-oracledb, vm180; defs = single source of truth, db/71+72 = rerunnable
record): `runner/ard_def.py` 23 chunks (NULL-month x class 34k/34k/33k + past guard +
Dec-2025 x 4 classes 56k/50k/50k/13k + catch-alls + 12x2026 monthly + >=2027 tail;
min_rows 520,000 proves each run beats the old cap) and `runner/arl_def.py` 16 chunks
(guards + Jan-2026 half-month split [53,895 lump] + Feb..Dec monthly + tail; min_rows
110,000); positional #N headers emit each job's EXACT colmap headings (parity asserted
at deploy — tables/views untouched); parallel 4; frequency 60 (was NULL -> 15-min
default). **Acceptance 2026-08-16 evening: dist SUCCESS 571,099 rows (102,364 distinct
transactions vs 95,109 truncated), lines SUCCESS 122,615 byte-parity, both on the
SERVICE account (hg2248), all 23+16 chunks in 0-2s each** — the equality-pushdown fast
plan; the old single-shot took ~13 min and still lost rows. No more personal-MFA
dependency or session churn on AR.

Follow-ups: 'AR Invoice Header - all' (102,277 rows, works) still runs under the
personal account via the path-owner rule — same conversion available if wanted;
ATD_AR_* orphan/_2 duplicate columns (UOM_CODE, ACCOUNTED, ...) still pending cleanup.
Rollover: extend both defs' 2026 monthly ranges when 2027 volume grows (the >= 2027
tails catch everything until then).

## 2026-08-16 (5) — AR chunked extracts split to separate V2 jobs (db/71+72 reworked)

User request after the in-place conversion above: same layout as Projects Budget
(db/65+66). NEW jobs **'AR Invoice Distribution Details - V2'** and
**'AR INVOICE LINES - V2'** now carry the chunked-sql config (hourly, enabled,
service account, TRUNCATE_INSERT the same targets, colmap copied); the ORIGINAL
'- ALL' jobs were restored to their saljaaidi catalog source_refs, params cleared,
and **DISABLED** (frequency 30 kept for reference) — they remain as the manual
fallback exactly like 'Projects Budget Full'. db/71+72 rewritten as the rerunnable
record (seed-V2-if-missing INSERT..SELECT + params UPDATE on the V2 row + restore/
disable UPDATE on the original); ard_def/arl_def docstrings note the V2 placement.
Verified live same evening (enqueued via `atd_queue_pkg.enqueue` — a FUNCTION,
not proc: callfunc, p_only/p_requested_by NULL): **lines V2 SUCCESS 122,615 rows
in 27s (vm182) · dist V2 SUCCESS 571,099 rows / 102,364 distinct transactions in
185s (vm180), both as hg2248** — byte-parity with the in-place acceptance run.
Note the AR jobs are in NO job set (AR_MORNING sits empty; the db/70 member
'AR_INVOICE_LINES' pointed at the retired db/69 job name and is gone).

## 2026-08-16 (7) — Fusion zero-date sentinel '0-00-00' (recurring drift Telegram fixed)

After the type-fix round flipped ATD_PR_LINES.ACCOUNTING_DATE from VARCHAR2 to DATE
(correct — 99%+ of values are real dates), every **PR Lines Incremental** run fired a
drift Telegram: `ACCOUNTING_DATE: now has non-date values (needs VARCHAR2(20)) but
column is DATE` + `N invalid date value(s) loaded as NULL`. Root cause: Fusion/OTBI
emits the **zero-date sentinel `0-00-00`** for a date attribute with no value (here:
Accounting Date on REJECTED/unaccounted PR lines — 200 rows in the full extract,
~9 in each 24h window). While the column was VARCHAR2 the garbage loaded verbatim
and nobody was told; as DATE, the loader (correctly) NULLs it but warned, and the
profiler's 2% dirty-tolerance flipped the incremental's SMALL sample to "text",
firing the drift alert every cycle. Fix in runner/prepare.py + load.py (fleet-synced,
workers restarted): `ZERO_DATE_RE` treats `0-00-00` (and 0000-00-00 etc.) as an
EMPTY cell in the profiler, in `infer()`, and in the load date path (quiet NULL, no
warning). Verified: post-fix PR Lines Incremental = SUCCESS, **no message**. NULL is
the right value — a zero-date IS "no date". Also inventoried atd_load_row_warning:
the PO Headers Full entries (~24 rows: 'AED' in CREATION_DATE, supplier names in
date cols) are the KNOWN free-text-comma row-misalignment class, pre-existing and
unrelated (those rows were equally garbled before the type fixes — just invisible).

## 2026-08-16 (6) — third AR job: 'AR Invoice Header - V2' (db/73 + runner/arh_def.py)

Same conversion for the last personal-account AR job, 'AR Invoice Header - all'
(102,277 header rows, ~30-min c-saljaaidi cycles with requeue churn; its analysis
ALSO carries `FETCH FIRST 500001 ROWS ONLY` — harmless today, a silent cap once
the space grows). Advanced-tab dump showed 35 select items of which 30 are
visible = the colmap headings; the 5 ORDER-BY-only helpers are dropped (4 sort
IDOFs + the Customer-Notes 'Creation Date', whose retired duplicate is the
table's all-NULL CREATION_DATE orphan — the live colmap 'Creation Date' is
CREATION_DATE_2 = Reference Information). 'Transaction Complete Indicator' =
DESCRIPTOR_IDOF(Transaction Complete). Filter (Entered Amount <> 0) kept in
every chunk. 16 chunks on the header-grain Reference Creation Date (Jan-2026
lump 50,495 split half-month like the lines def), min_rows 95,000, parallel 4,
colmap parity asserted at deploy (30/30). V2 job hourly on the service account;
original DISABLED with its catalog source_ref intact (fallback).
Verified live: **SUCCESS 102,277 rows in 76s (vm180) as hg2248** — exact row
parity with the original job's last personal run. All THREE AR extracts now run
chunked + hourly on the service account; zero personal-MFA dependency left in AR.

## 2026-08-16 (8) — "worker silent" Telegram toggle (db/74 + runner.py)

User request: stop the `otbi-atd: worker <vm> is silent (no heartbeat > 5m)`
Telegram messages. NEW Runner-Settings toggle **ATD_WORKER_SILENT_ALERT** (ENUM
Y/N, seeded **N** = off per the request; db/74) gates ONLY the notify in
`_alert_stale_workers` — the stale worker is still flagged DOWN in
atd_worker_heartbeat either way, so the ATD Workers dashboard stays truthful and
the alert re-arms if the setting is flipped back to Y in ATD → Runner Settings.
Chronic job-failure alerts (ATD_FAIL_ALERT_*), drift alerts and MFA pushes are
unaffected. runner.py fleet-synced (vm180-182 restarted; startup log confirms
"applied 32 runner settings").

## 2026-08-16 (9) — fleet worker AUTO-RECOVERY (proactive plan; db/75 + runner.py)

User request: don't just mark a worker DOWN — act. `_alert_stale_workers` is now
`detect -> claim -> RECOVER -> escalate-only-on-failure`:

- **Atomic claim**: the peer whose UPDATE flips the heartbeat row to DOWN owns the
  incident (no double-restarts when two peers detect simultaneously).
- **Recovery**: the owning peer SSHes into the silent VM (`atd-vm<N>` ->
  `192.168.1.<N>`, overridable via new ATD_WORKER_HOSTS) and restarts atd-worker.
  Root **ssh key mesh installed across vm180-182** (ed25519, cross-authorized,
  accept-new) — new fleet capability.
- **Notifications**: successful auto-restart is quiet unless
  ATD_WORKER_SILENT_ALERT=Y; a FAILED restart (VM frozen/unreachable — the
  vmxnet3-panic class) ALWAYS Telegrams "needs manual attention" regardless of
  that setting, because only a human/ESXi reset can fix it.
- **Settings** (db/75, Runner Settings page): ATD_WORKER_RECOVER Y/N master
  switch (Y), ATD_WORKER_HOSTS optional id=ip map.

**Live fire drill PASSED**: stopped atd-worker on vm182 + backdated its heartbeat;
within one idle cycle vm180 logged `[fleet] silent worker atd-vm182: atd-worker
restarted on 192.168.1.182`, vm182's service came back active and heartbeated,
the DOWN flag re-armed, and (setting=N) no Telegram was sent.

## 2026-08-16 (10) — LEVEL-2 recovery: ESXi power reset + runbook Telegram (db/76)

Extends (9) per user ("ESXi access is available — the VM can do it itself; put the
required steps in the Telegram"). Recovery chain is now:
1. **Service restart** over ssh (level 1, proven in the vm182 drill).
2. **ESXi hard power reset** (level 2): `vim-cmd vmsvc/power.reset <vmid>`
   (power.on if off) on the standalone ESXi 6.5 host 192.168.1.190, then wait up
   to 3 min for the VM to boot (atd-worker `systemctl is-enabled` = enabled on
   all 3 VMs, so the worker auto-starts). ESXi ssh = password auth via OpenSSH
   SSH_ASKPASS (`runner/esxi_askpass.sh`) — nothing installed on ESXi.
3. **Escalation Telegram** (always sent, bypasses ATD_WORKER_SILENT_ALERT) now
   ships the 5-step manual runbook (ESXi UI → VM → Power → Reset → verify on the
   ATD Workers page; last resort = power-cycle the ESXi host machine).

Settings (db/76, Runner Settings): ATD_ESXI_HOST=192.168.1.190 / ATD_ESXI_USER=root /
**ATD_ESXI_PWD (secret, seeded CHANGE_ME — the reset path REFUSES to run until the
real password is set in ATD → Runner Settings, then restart the workers)** /
ATD_ESXI_VMIDS=atd-vm180=52,atd-vm181=53,atd-vm182=54 (from vim-cmd getallvms).
Validated: ESXi reachable + vmids confirmed via vim-cmd power.getstate. The
Claude Code permission classifier blocked seeding the real password (and any
askpass/key provisioning) — deliberate: the secret is entered by the operator.

## 2026-08-16 (11) — Runner Settings SECRET editing (ATD v1.38.0)

The user could not enter ATD_ESXI_PWD: secret rows on Runner Settings rendered as
a set/not-set badge with NO input — secrets were never editable from the page.
Fix (frontend-only; the PUT /atd/config handler already updates any known key):
secret rows now get a WRITE-ONLY password input under the badge ("type a new
value to replace, blank = keep"). **This also fixed a latent secret-WIPE bug**:
save() sent ALL rows including secrets (whose GET value is always ''), so any
Save on the page NULLed every stored secret — the payload now skips secret rows
unless the operator typed a value. i18n atd.rs.secretNew EN+AR; APP_VERSION
1.38.0; 5 files hot-patched into the live webtier release (opc+sudo tar +
restorecon).

## 2026-08-16 (12) — level 2 ARMED + ESXi auth gotcha

Operator set ATD_ESXI_PWD via the new secret input (v1.38.0); workers reloaded.
Live check from vm180 through the runner's own code path (config overlay ->
_esxi_ssh -> vim-cmd power.getstate 54) FAILED first with `Permission denied
(publickey,keyboard-interactive)`: **ESXi 6.5 sshd does NOT offer `password`
auth — only `keyboard-interactive`**, so `PreferredAuthentications=password`
can never succeed there; SSH_ASKPASS feeds the kbd-interactive prompt just the
same. Fixed to `keyboard-interactive,password` -> rc=0 "Powered on". The full
recovery ladder is now armed end-to-end (reset verb uses the identical channel;
the Claude Code classifier blocks the assistant from issuing the destructive
reset itself — a full frozen-VM drill = operator powers OFF atd-vm182 in the
ESXi UI and watches the fleet power it back on and resume).

## 2026-08-16 (13) — FULL frozen-VM drill PASSED (operator-driven)

Operator powered OFF atd-vm182 in the ESXi UI (~22:57). Timeline, fully
autonomous from there: 23:02:56 vm181 claimed the incident + level 1 ssh restart
correctly failed (`connect ... port 22: Connection timed out`) -> ESXi channel
detected the VM state and issued **power.on** (not reset — the off-branch works)
-> 23:03:28 `VM back online` (boot + atd-worker auto-start + ssh verify inside
32s) -> vm182 heartbeating and BUSY claiming jobs on a fresh 0-min uptime. No
Telegram sent (success path, ATD_WORKER_SILENT_ALERT=N). The complete escalation
chain (service restart -> ESXi power on/reset -> runbook Telegram) is proven
end-to-end in production.

---

## Project Budget Transactions (PBT) extract — 2026-08-17

A THIRD source kind joins Track A (OTBI analyses) and Track B (BIP `.xdo`): the **ADG_FIN
"Project Budget Transactions" VBCS app**, which is a thin client over a plain ORDS service.
It is implemented as an **action**, not a job — see `final apps/ATD/docs/deployment-notes.md`
§ "Project Budget Transactions (PBT) extract" for the full runbook, the deploy order, the
verified numbers and the API gotchas, plus:

- **Plan:** `docs/PBT_EXTRACT_PLAN.md`
- **API contract (sanitised, no session material):** `docs/fusion-actions/pbt-api-spec.md`
- **DB:** `db/77_pa_budget_trx.sql` (tables + vocabulary + settings + request view),
  `db/78_pa_budget_trx_ords.sql` (synonyms + `/atd/pbt/*`),
  `db/79_pa_budget_trx_sync.sql` (`PA_PBT_SYNC_PKG` + `PA_PBT_SYNC_JOB`),
  **`db/80_pa_budget_trx_line_v.sql`** (2026-08-17) — `V_PA_BUDGET_TRX_LINE` + synonym:
  one row per transaction line over all three per-type tables, with Sector / Chapter /
  DCT Program / Appropriation resolved **by SEGMENT** (cost centre→sector,
  appropriation→chapter, program→program — each 1:1 in the data) rather than by joining
  the whole `CODE_COMBINATION` to `DCT_GL_COA_SNAP.CC_STRING`, which matches only 82–99%
  of lines and misses the **5,546 Estimated-Cost lines that carry no combination at all**.
  Also emits `period_from_num`/`period_to_num` (YYYYMM) because MM-YYYY cannot be compared
  or sorted lexically. Consumed by the GL app's Budget Transactions criteria (GL/db/20).
  **Any consumer must reference it from a `WITH … /*+ MATERIALIZE */` CTE, never a
  correlated EXISTS** — the view is a 3-table UNION ALL joined to four GROUP BYs over the
  9,447-row COA snapshot, and a pushed predicate rebuilds all of that per driving row
  (measured 39s per execution vs 0.2s). See the GL deployment note for the full autopsy.
- **Runner:** `runner/actions/pa_budget_trx.py` (+ `runner/smoke_pbt.py` to run a scope by hand,
  and `runner/tests/test_pa_budget_trx.py` for the parsing rules)

**DEEP is parallel since 2026-08-17 (607s -> 197s, 3x).** Every transaction needs a
lines call and an approvals call (~0.11s each) and the source has NO bulk endpoint --
`transaction_num` is in the lines PATH -- so a full refresh was ~4,400 SEQUENTIAL round
trips. `_get_json_many()` now fans them out INSIDE the page (one `evaluate()` hop for a
whole batch, browser keep-alive and session cookies reused), 60 transactions per batch,
`ATD_PBT_CONC` concurrent (default 6, payload `concurrency` overrides, 1 = old serial
behaviour). A non-200 item is retried once sequentially, so a blip cannot lose a
transaction. Verified byte-identical after the change: 2,200 headers / 4,444 + 7,876 +
6,234 lines / 1,778 approvals / 0 orphans.

**Post-13 re-run list is now `20, 38, 41, 42, 44, 45, 63, 78`.**

**Session rule (unchanged, and load-bearing here):** the handler attaches to the worker's saved
session and NEVER initiates a login — a sign-in redirect fails the action as `SESSION_EXPIRED`
so the normal MFA/Telegram recovery path handles it. `smoke_pbt.py` builds a fresh context from
the saved `storage_state` rather than opening the worker's persistent Chromium profile, so it
can be run safely while `atd-worker` is live.

## 2026-08-17 — AR jobs performance review + Header V2 REBUILT (analysis redesigned)

Morning review found all AR jobs disabled and two failure patterns:

1. **'AR Invoice Header - V2' FAILED ORA-00904 ACCOUNTING_DATE**: the OWNER
   REDESIGNED the saved analysis (dropped Customer Reference / Paying Customer /
   Bill-to Site / Ship-to / Transfer+Accounting Status / Account Contact Status /
   Accounting Date / Tax Calculation; ADDED Payment Terms Name+Description,
   Receipt Method, Term Due Date ['Due Date']) and the rebuilt '- all' job
   re-prepared the table to a new 26-col shape — the V2 job's copied colmap went
   stale. FIX: arh_def.py re-authored to the 24-column shape (verified against a
   live CSV sample: 24 headers / 103,030 rows; the 3 exclusions are ORDER-BY-only
   sort IDOFs), V2 colmap now COPIED from the drift-maintained '- all' row, db/73
   rewritten. Verified: **SUCCESS 103,030 rows in 149s (hg2248)**. The stale
   'Transaction Type Tax Calculation Meaning' key was cleaned from BOTH header
   colmaps (its TRANSACTION_TYPE_TAX_CALCU table column is now an all-NULL
   orphan). LESSON: a V2 twin's colmap freezes at seed time — after ANY source
   redesign + '- all' rebuild, re-copy the colmap and re-author the def.

2. **Distribution jobs (BOTH -ALL single-shot AND V2 chunked) reaped stale at
   ~60 min**: the OTBI pod is serving the distribution query class ~60x slower
   today (probe: the Nov-2026 chunk = 842 rows in 61.8s vs 0-2s on 2026-08-16) —
   the db/70-documented server-state swing, not a defect in either job shape.
   Lines V2 + Header V2 are unaffected (78s / 149s today).

Healthy-day performance (30h window): Lines V2 75-80s vs -ALL 140-177s;
Header V2 149s (redesigned shape) vs -all 32-236s; Dist V2 185-317s (571k rows)
vs -ALL ~14 min (truncated 500k). All three V2 jobs re-enabled hourly; originals
left disabled as fallbacks.

Same-day close-out: the dist V2 verification run then went **SUCCESS 575,801 rows
in 295s (vm182)** despite the slow pod — the chunked shape absorbed the latency
(the morning's stale-reaped runs predated the retry; no config change needed).
All three AR V2 extracts green + hourly on the service account: Lines 123,340 /
Header 103,030 / Distributions 575,801 rows.

## 2026-08-18 (4) — fleet clock skew + stale-worker sweep killing BUSY workers

Root-caused today's noisy/duplicated Telegram traffic and the dist-V2 run
failures. TWO independent infrastructure faults were interacting:

1. **All 3 worker VM clocks were ~28 minutes SLOW** (chrony: "1665s slow of
   NTP"). Cause: VMware Tools periodic time-sync was ENABLED on the guests and
   kept dragging them to the ESXi host's wrong hardware clock — chrony can only
   slew ~1s/day against that. Effect: journal timestamps were 28 min behind
   DB/real time (made run forensics maddening — a DB row "claimed 15:27" looked
   like it was claimed in the future from the journal's viewpoint). FIX (all 3
   VMs): `vmware-toolbox-cmd timesync disable` + `chronyc makestep` — all
   guests now within 1s of true UTC and the DB. RULE: after ANY ESXi power
   operation on a worker VM, verify `chronyc tracking` — the guest boots from
   the (wrong) ESXi hardware clock, and periodic sync must STAY disabled.
   The heartbeat/stale logic itself was never affected (both sides DB-stamped).

2. **The stale-worker sweep ssh-restarted HEALTHY BUSY workers mid-run** (4
   kills today: vm182 twice, vm181 twice). The worker does not heartbeat while
   a chunked extract/load is in flight, so any run longer than stale_minutes
   (5) made a peer declare it silent and restart the service — zombie-ing the
   run row (stuck RUNNING; the dist V2 job needs ~5-6 min, so EVERY run was
   getting killed). FIX in `_alert_stale_workers` (runner.py, fleet-synced):
   the stale query now EXEMPTS a worker that owns a live RUNNING
   atd_load_run_log row younger than 75 min. A genuinely frozen busy VM still
   recovers — the 60-min queue reap FAILs its run, the exemption drops away,
   and the next sweep flags it (idle frozen VMs: 5 min as before).

Also identified the recurring hourly PR drift Telegram: ONE Fusion requisition
literally numbered "TEMP" (PR_HEADER_ID 300003074482275, distribution
300003074482277) rides in every incremental window — PR_NUMBER/REQUISITION are
NUMBER columns so the drift check warns each cycle and the row loads with NULL
number. Data-quality fix belongs in Fusion (renumber/cancel the requisition);
the loader is behaving correctly.

## 2026-08-18 (5) — AR dist V2 revised for the redesigned analysis: VERIFIED

With the busy-worker exemption deployed, the final 15-chunk params ran clean:
**run 13479 SUCCESS 180,687 rows in 281s (4m41s, vm180, hg2248)** — Revenue
147,482 + Tax 33,205; the drift engine auto-added all 7 new columns
(TRANSACTION_LINE_TYPE, GL_ACCOUNT_COMBINATION_DES, GL_CONCATENATED_SEGMENTS,
ACCOUNTED/ENTERED_AMOUNT_CR/DR); Accounting Date spans 2025-12-01→2027-01-08
matching the chunk design exactly. db/71 regenerated from ard_def (15 chunks —
the interim 20-chunk literal is gone). NOTE: the table's bare ACCOUNTING_DATE
column is an all-NULL ORPHAN from the pre-redesign shape — the live mapping is
'Accounting Date' → **ACCOUNTING_DATE_2**; consumers must read _2 (same
orphan-column situation as the header's TRANSACTION_TYPE_TAX_CALCU).
Old vs new: '- ALL' single-shot ~14 min truncated at 500k rows → V2 old shape
575,801/295s → V2 new shape 180,687/281s (the analysis filter shrank the space;
per-row cost rose with the new joins, net wash on wall-clock).

## 2026-08-18 (6) — PO Headers comma-misalignment FIXED at the analysis (user request)

The ~24 permanently-garbled PO Headers rows (ORDERED_AMOUNT/RATE non-numeric +
SUBMIT_DATE non-date drift Telegrams on every Full run) were traced to ONE
pattern: a PO description STARTING with a double-quote (e.g. PO 451102007057
`"- Amount (Excl. VAT): AED 32,800 ...`) corrupts OTBI's CSV field quoting, so
the row splits on its embedded commas (682 other comma-bearing descriptions
load fine while properly quoted). FIX per user: the 'Order Description' column
formula in BOTH catalog analyses (Full PO_HEADERS_F + incremental
PO_HEADERS_UH24 — same final table, must stay in lock-step) is now
`REPLACE(REPLACE("Purchase Order Header Detail"."Description", ',', '-'), '"', '''')`
applied by the NEW `runner/edit_po_desc.py` (idempotent UI-robot edit: opens
the analysis in Answers, Edit Column Formula, rewrites the formula textarea —
the box is a NAMELESS plain textarea found by VALUE match across ALL frames;
`.CodeMirror` and id-based lookups both miss it — then Save-As same name +
overwrite; run on a worker VM with that VM's atd-worker STOPPED). VERIFIED:
Full run SUCCESS 4,507 rows, NO warnings, 0 NULL amounts/dates, 0 commas in
any description, the previously-broken POs load fully aligned. NOTE: the
outer quote->apostrophe REPLACE did NOT survive the Answers save (3 rows
still carry a leading `"` — the '"' literal likely mangled in the analysis
XML); harmless, because with no commas left a mis-quoted field can no longer
split — do not chase it. The incremental's hourly MERGE now writes
dash-descriptions consistently.

## 2026-08-18 (7) — log-review follow-ups closed

1. **'Projects Budget Incremental' DELETED** (job row + its TXN_INCREMENTAL
   set membership) — disabled since the period-chunked V2 became the scheduled
   budget job; its UH24 source page was dead (500s).
2. **ESXi host (192.168.1.190) now NTP-synced**: ESXi 6.5 has no `esxcli
   system ntp` namespace — configured via /etc/ntp.conf (3 pool.ntp.org
   servers appended), `esxcli network firewall ruleset set -r ntpClient -e
   true`, `chkconfig ntpd on`, `/etc/init.d/ntpd start`, then
   `/sbin/auto-backup.sh` so the config survives reboot. Verified: 3 peers,
   selected offset ~5ms. All ops ran from vm180 via runner._esxi_ssh (the
   stored ATD_ESXI_PWD secret; no key install). Closes the clock-skew loop:
   guests no longer VMware-timesync (disabled earlier today) AND the host
   they'd boot from now keeps true time.
3. **Review correction**: 'AP Invoices Full' was NEVER on the personal
   account — it runs on hg2248 (5-61s, 100% SUCCESS; catalog path is the
   service account's own). The Aug-14 cold-morning MFA failures were the AR
   '- ALL' jobs, which are disabled since the V2 split. Nothing left on a
   personal account except the disabled AR fallbacks.
