# Project Budget Transactions extract — implementation plan

**Status: BUILT AND DEPLOYED 2026-08-17.** Every layer is live and verified; the only
step deliberately left off is flipping `PBT_SYNC_ENABLED` to `Y` (see §2.5) — the
extract itself runs on demand today. Runbook, verified numbers and gotchas:
`final apps/ATD/docs/deployment-notes.md` § "Project Budget Transactions (PBT) extract".

**API reference:** [`docs/fusion-actions/pbt-api-spec.md`](fusion-actions/pbt-api-spec.md)

Extract the **Project Budget Transactions** master–detail data from the ADG_FIN
VBCS app into PROD tables — on demand from a new ATD page taking a date or date
range with full job monitoring, **and on a schedule that keeps the tables
current**.

---

## 0. Decisions locked with the user (2026-08-16 / 17)

| # | Decision |
|---|---|
| 1 | **All business units** — DCT, Museum Shared Services, Abrahamic Family House |
| 2 | **All statuses** — Baselined, Entered, Baselining Failed, Pending Approval, Rejected |
| 3 | **Approval history in scope** |
| 4 | **MERGE on the source `identifier`**, plus deletion reconciliation on a full-scope run |
| 5 | Access **Route B** — worker VM through the VBCS proxy (Route A ruled out: no ORDS credential) |
| 6 | **All three budget types** — `Additional`, `Estimated-Cost`, `Annual-Budget` |
| 7 | **D1 resolved: ONE shared header table** across types (the payload is identical and already carries `transaction_type`); lines get a table per type because their shapes genuinely differ (34 / 21 / 38 fields) |
| 8 | **End objective: a scheduled sync** keeping the tables current — §2.5 |

---

## 1. Why this is not an OTBI/BIP job

Neither existing track fits:

* **Track A** (`extract.py`) — OTBI analysis → CSV → one stage table.
* **Track B** (`bip.py`) — BI Publisher `.xdo` → XLSX → one stage table.

Both are whole-job, single-target, schedule-driven snapshots with parameters
pinned on the job row. This work is **per-request, parameterised, master–detail
into five tables, monitored**. That is the shape of the **action queue**
(`ATD_ACTION_REQUEST`) — `payload_json`, `worker_host`, `started_at`/
`finished_at`, retries, telemetry — which already has a generic enqueue
endpoint and a UI precedent (*Manage Projects Org*).

So: **a new action type, `PA_BUDGET_TRX`** — the first *read* action (every
existing action writes into Fusion; this one reads out of it).

---

## 2. Layers

### 2.1 DB — `otbi-atd/db/77_pa_budget_trx.sql`

Five tables in **PROD**, re-runnable guarded `CREATE`, CRLF / UTF-8 no BOM,
`SET DEFINE OFF`.

**`PA_BUDGET_TRX_HEADERS`** — the 20 source fields, all types
`identifier NUMBER PK` · `transaction_num` · `transaction_type` (discriminator)
· `project_type` · `status` · `transaction_date DATE` · `trx_year` ·
`dept_1st_level_approver` · `business_unit` · `decree_no` · `organization` ·
`project_num` · `project_name` · `project_num_1` · `project_id` ·
`project_approved_cost` · `project_estimated_cost` · `project_total_cost` ·
`changein_duration` · `creation_date DATE` + audit `load_run_id` ·
`row_hash` (drives the incremental diff) · `last_seen_at` · `load_ts`.

**`PA_ADDITIONAL_FUND_LINES`** (34) · **`PA_ESTIMATED_COST_LINES`** (21) ·
**`PA_ANNUAL_BUDGET_LINES`** (38) — each `identifier NUMBER PK`,
`transaction_num`, its own field set per spec §4.2, + `load_run_id` ·
`last_seen_at`. `commitments` is **stored NUMBER though the source sends a
string**; the three different `creation_date` formats are parsed per type.

**`PA_BUDGET_TRX_APPROVALS`** — the 9 source fields + **`transaction_num` and
`trx_type` stamped by the caller** (the payload carries no key of its own) +
`seq_no`. No stable source id ⇒ **delete-by-transaction then insert**.

Indexes on `transaction_num` (all), `(transaction_type, transaction_date)`,
`business_unit`, `status`. Plus the `PA_BUDGET_TRX` action-type lookup seed
(pattern of `db/53`) and `V_PA_BUDGET_TRX_REQUEST` for the page register.

### 2.2 Runner — `otbi-atd/runner/actions/pa_budget_trx.py`

Claimed by the fleet's existing idle drain loop. Read-only, so no
`ATD_ACTION_LIVE` gate.

```
payload_json = {
  "mode":            "RANGE" | "SYNC_SHALLOW" | "SYNC_DEEP",
  "transactionTypes": ["Additional","Estimated-Cost","Annual-Budget"],
  "dateFrom": "2026-01-01",      # RANGE only; optional
  "dateTo":   "2026-08-16",      # RANGE only; equal to dateFrom = single day
  "businessUnits": [...],        # default = the 3 real BUs
  "statuses": [...],             # default = all
  "includeApprovals": true,
  "purgeMissing": false          # full-scope runs only
}
```

Flow:
1. Attach to the worker's **existing** session
   (`auth_state_FUSION_ADGOV.json`) — **never initiate a login** (it fires an
   MFA push). A sign-in redirect ⇒ fail clean as `SESSION_EXPIRED` and let the
   normal worker MFA path recover.
2. Open the app URL once (establishes the VBCS session), then **one master call
   per type** with `bu_arr` = all BUs and **no** `p_business_unit` / no
   `p_transaction_date` — the complete set, ~10 s each (spec §5.2–5.3).
3. Filter to the requested range / statuses **client-side** (the API has no
   server-side range at all — spec §5.9).
4. Decide which transactions need child calls:
   * `RANGE` / `SYNC_DEEP` — all of them;
   * `SYNC_SHALLOW` — only where `row_hash` differs from stored, or the header
     is new.
5. Per selected header: `…/lines`, and if requested `…/ApprovalHistory`.
6. MERGE headers and lines on `identifier`; delete+insert approvals per
   transaction; stamp `load_run_id` + `last_seen_at`.
7. **Deletion reconciliation** on full-scope runs only: headers not seen this
   run no longer exist upstream — reported always, purged on `purgeMissing`.
8. Write `atd_load_run_log` (`track='BROWSER'`, counts, message) so runs appear
   on the existing **Run Logs** page, and stamp counts onto the action row.

### 2.3 ORDS — `otbi-atd/db/78_pa_budget_trx_ords.sql` (additive)

Enqueue reuses the **existing generic** `POST /atd/actions/enqueue` (db/44).
New read routes for the page: `GET /atd/pbt/runs`, `/runs/:id`, `/summary`
(rows by type/BU/status, date span, last successful sync), `/data` (paged
header register + lines/approvals drill).

> **Re-run coupling:** `db/13` rebuilds `atd.rest` from scratch. The chain is
> *13 ⇒ re-run 20/38/41/42/44/45/63*; **78 joins that list.**

### 2.4 Frontend — ATD (App 208) `final apps/ATD/Jet/`

New view `pbtExtract` (nav under Manage, modelled on *Manage Projects Org*):
parameters region (type, single date **or** range, BU chips, statuses, include
approvals, purge-missing) · Run + live monitoring (status chip READY → CLAIMED
→ DONE/FAILED, worker VM, started/ended/duration, submitted-by, per-table row
counts, last error) · recent-runs register · extracted-data register on the
shared `<interactive-report>` with a lines/approvals drawer · **sync schedule
panel** (next run, last run, enable/pause, cadence) · EN + AR, platform classes,
actions top-right, `APP_VERSION` bump.

### 2.5 Scheduled sync — the end objective

**`PA_PBT_SYNC_JOB`** (DBMS_SCHEDULER) enqueues an action row; the fleet's idle
drain executes it. Nothing new is needed for monitoring — Run Logs and the
Actions register already show worker, timings and counts.

Two speeds, because the master call is cheap and the child calls are not:

| Mode | Cadence (proposed) | Cost | What it catches |
|---|---|---|---|
| `SYNC_SHALLOW` | hourly | ~30 s idle; child calls only for changed/new rows | new transactions, status changes, any header edit |
| `SYNC_DEEP` | nightly | ~8 min (≈2,000 headers × 0.11 s × 2 calls) | line-only edits, deletions |

**Why the deep pass exists:** the header payload has **no `last_updated_date`**
(the lines do), so a line edited without touching its header is invisible to the
hash diff. The nightly deep pass closes that hole. If upstream later exposes a
header update stamp, the deep pass can drop to weekly.

**Throttling for free:** `idem_key = 'PBT:SYNC:<mode>:<YYYYMMDDHH24>'` — the
UNIQUE constraint means a tick that fires while the fleet is still busy cannot
pile up a duplicate.

Cadence, enable/pause and the type list are settings rows, not code.

---

## 3. Testing

| Tier | Coverage |
|---|---|
| Unit (pytest, no network) | the three `creation_date` formats · string `commitments` · null-heavy rows · range filtering · `row_hash` stability · MERGE idempotency (same payload twice ⇒ no duplicates) |
| API (pytest) | enqueue happy path · 400 on bad type/date · 401/403 · register/summary/drill routes |
| E2E (live, one worker) | full pull of each type, counts reconciled **against the VBCS page's own numbers**; re-run ⇒ zero duplicates; shallow sync after a known edit picks it up |
| Browser (Playwright) | new page EN + AR/RTL, params → run → monitor → drill |
| Regression | existing extracts and actions unaffected (additive handler; no shared-file changes beyond the action dispatch table) |

---

## 4. Deploy order

1. `db/77` — tables + lookup seed *(MERGE-bearing ⇒ **python-oracledb on a
   worker VM**, not Linux SQLcl)*
2. `db/78` — additive ORDS *(as `prod_mcp`, fresh session)*
3. `runner/actions/pa_budget_trx.py` → sync to **vm180-182** + `systemctl
   restart atd-worker` on each
4. Enable `PA_PBT_SYNC_JOB` only after a manual full run verifies clean
5. ATD frontend deploy + `APP_VERSION` bump
6. Docs: `final apps/ATD/docs/deployment-notes.md`, `functions_list.md`,
   CLAUDE.md Module Status, memory entry

---

## 5. Risks

| Risk | Mitigation |
|---|---|
| VBCS session expires | Same failure mode as every Fusion job; existing MFA/Telegram path recovers. Handler fails clean, never initiates a login. |
| Header has no update stamp | Nightly `SYNC_DEEP`; documented as the reason it exists. |
| Proxy URL embeds `;profile=prod_configuration` + a VBCS app version | Config constants at the top of the handler, not scattered literals. |
| Upstream adds/renames a field | Load is name-driven; unknown fields logged and ignored, drift reported on the run. |
| Volume growth | 2026 YTD ≈ 1,978 headers across types; linear and monitored. Range mode is the escape hatch. |
| `Annual-Budget` spans 2014–2025 | Historical and static — a candidate for deep-sync exclusion once loaded, if the nightly pass gets long. |
