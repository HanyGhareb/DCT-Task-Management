# otbi-atd — Deployment & Runbook

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
The runner does **all** database work through the already-configured **SQLcl**
connection (`sql -name prod_mcp`) — **no separate DB username/password needed**.

One-time setup on the host:
```
pip install -r runner/requirements.txt   # playwright + httpx (oracledb optional)
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

## Fast load mode (oracledb) — for large analyses
Default is SQLcl (no creds). For big tables, switch the DB layer to chunked array-bind:
```
set ATD_DB_MODE=oracledb
set ATD_DB_USER=<db user>      &  set ATD_DB_PASSWORD=********
set ATD_DB_DSN=<tns alias>     &  set TNS_ADMIN=<wallet dir>   (myDoc/)
set ATD_DB_CHUNK=5000          # rows per round-trip
pip install python-oracledb
```
~10× faster on large loads (bind variables vs SQLcl literal hard-parse). Same control tables,
same runner. Measured baselines + why bigger SQLcl batches/`LOAD` are slower: see REFERENCE.md §6.

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

## Scheduling
Windows Task Scheduler (or cron) calling `python runner.py`. Cannot be scheduled from
ATP (Track B drives a browser). Cluster runs inside the Entra session lifetime so MFA is
only needed occasionally; the runner surfaces the number when a refresh is required.

## Adding another analysis
1. (optional) create its target table — model on `06_grn_all_table.sql`.
2. Insert a row in `ATD_OTBI_JOBS` (copy the `GRN_ALL` MERGE in `07`): set `source_ref`
   to the analysis path, `stage_table`, `load_mode`, and `column_map_json`
   (CSV header → column). No code change.

## To repoint host / account / database
Edit rows, not code: `ATD_OTBI_ENV.analytics_base_url` (pod), `.credential_ref` (account),
`ATD_TARGET_DB` (LOCAL_ATP vs REMOTE). Both tracks read the same tables.
