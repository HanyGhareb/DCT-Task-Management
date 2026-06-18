# otbi-atd — Full Reference

Automated extraction of **Oracle OTBI** analyses into the **ATD** database. Replaces the manual
"run analysis → export CSV → update ATD" routine with a config-driven pipeline. This is the
single reference for how it works, the design decisions, measured performance, limits, and
configuration.

Related docs: `deployment-notes.md` (runbook + history), `oci-vm-setup.md` (Always-Free VM).

---

## 1. What it does
For each **job** (a row in `ATD_OTBI_JOBS`): log in to OTBI, download the analysis as CSV,
load it into a target table, and record the run. Inputs — analysis path, target table, OTBI
host, account, target DB — are all **data** in control tables; adding/changing a job needs no
code change.

## 2. Why Track B (browser), not the API
The pod exposes the BI Publisher SOAP API (`ExternalReportWSSService` / `runReport`), which
would allow an in-database, fully-unattended pipeline (**Track A**). But it runs **BIP reports**,
not OTBI analyses directly, and the team's analyses live in the analytics catalog. The
confirmed-working path is the analytics **Go-URL** CSV download (**Track B**), driven by a
headless browser for login. Track A remains a future option if the analyses are wrapped as BIP
reports and a non-MFA service account is provisioned.

## 3. Authentication (the hard part)
Login chain for `@dctabudhabi.ae` accounts:

```
OTBI /analytics  →(OAM SSO 302)→  Oracle IDCS sign-in
   →  "ADGOV-Employees-Login"  →  Microsoft Entra ID (login.microsoftonline.com)
   →  username + password  →  Microsoft Authenticator push (NUMBER MATCHING)
```

- HTTP Basic auth on `/analytics` is **rejected** (OAM redirects to SSO).
- MFA is **enforced** → fully-headless login is impossible; a human approves the push.
- **Semi-attended model:** the runner reuses a saved browser session
  (`auth_state_<env>.json`) and only triggers MFA when it expires. On a fresh login it captures
  the match number, **delivers it (Telegram)**, and waits `ATD_MFA_WAIT` seconds for approval.
  Between refreshes, scheduled runs are silent. With "Stay signed in", MFA recurs only when the
  Entra SSO session itself expires.

## 4. Extraction — the Go-URL
```
{analytics}/saw.dll?Go&path=<url-encoded path>&Action=Download&Format=csv
```
- **The query parameter is lowercase `path`.** Capital `Path` returns a WebLogic 404. (This cost
  real debugging time — it is the single most important extraction detail.)
- The path is fully percent-encoded (`/`→`%2F`, space→`%20`, `@`→`%40`).
- Downloaded with the authenticated session cookies (Playwright context request API).
- Extraction is **fast** (~0.2–1s); essentially all cycle time is the DB load.

## 5. Configuration model (control tables, drives everything)
| Table | Purpose | Key columns |
|---|---|---|
| `ATD_OTBI_ENV` | source pod + account | `analytics_base_url`, `credential_ref`, `auth_type`, `extract_track` |
| `ATD_TARGET_DB` | destination DB | `db_kind` (LOCAL_ATP/REMOTE), `schema_name`, `db_link` |
| `ATD_OTBI_JOBS` | per-analysis job | `source_ref`, `stage_table`, `load_mode`, `column_map_json`, `key_columns` |
| `ATD_LOAD_RUN_LOG` | run audit | `status`, `row_count`, `csv_checksum`, `message` |

Repoint host/account/DB or add a job by editing rows — no redeploy. Secrets are referenced by
name (`credential_ref`), never stored in these tables.

## 6. DB load modes + measured performance
Two interchangeable load paths. **`oracledb` is the default** (auto-selected when
`ATD_DB_USER`/`ATD_DB_PASSWORD` are set; falls back to `sqlcl` otherwise). Force either with
`ATD_DB_MODE`.

| Mode | How | Credentials | Speed |
|---|---|---|---|
| **`oracledb`** (default, fast) | python-oracledb thin mode, chunked `executemany` (array bind) | `ATD_DB_USER/PASSWORD` + `ATD_WALLET_PASSWORD` + wallet | **~155× on the DB load** |
| **`sqlcl`** (fallback) | SQLcl `sql -name prod_mcp`, batched literal `INSERT ALL` | **none** (reuses SQLcl's stored connection) | baseline |

**Measured A/B (this host, BENEFICIARIES 12,160 rows, same CSV) — 2026-06-17:**
| Measurement | `sqlcl` | `oracledb` | Speedup |
|---|---|---|---|
| **Pure DB load** | **80.7s** | **0.5s** | **155×** |
| End-to-end (auth + download + load) | 109s | 17.5s | 6.2× |
| Download (identical) | 0.4s | 0.4s | — |

Once the load is ~0.5s, the remaining ~17s end-to-end is **fixed per-run overhead** (browser
session launch/validate ~5s, oracledb connect ~1s, page nav) — *not* per-job. So extra jobs are
nearly free: a 3-job run drops from ~130s (sqlcl) to ~15–20s (oracledb).

**Why oracledb wins:** the SQLcl path writes **literal values** (no bind variables) → every
statement is **hard-parsed**, the dominant cost. oracledb sends rows as **bind variables in one
array operation** (`executemany`), eliminating parse cost. (For the record, on the SQLcl path
bigger batches/`LOAD` were *slower*, not faster — `ATD_LOAD_BATCH=200`=130s/3-job best, batch
500=186s, SQLcl `LOAD`=390s — because they enlarge the hard-parsed statements. Don't re-test.)

## 7. Large files, chunking, and the OTBI export cap
- **`oracledb` mode chunks** the array-bind insert (`ATD_DB_CHUNK`, default 5000 rows/round-trip)
  → fast **and** memory-bounded; the right choice for large analyses and the small VM.
- **SQLcl mode does not chunk** — at ~100k rows it still works but is slow (~10–11 min) and builds
  a ~30–40 MB in-memory script.
- **OTBI export cap (the real risk at scale):** the analytics CSV download is row-capped
  server-side (instanceconfig, often ~65,000). A larger analysis comes back **silently
  truncated** (a round number of rows, no error). `checks.truncation_note()` flags a load whose
  count equals a common cap (`ATD_TRUNCATION_CAPS`) or falls below `ATD_EXPECTED_MIN`; the runner
  prints a `[WARN]`, sends it to Telegram, and stores it in `ATD_LOAD_RUN_LOG.message`. Raise the
  pod's download limit before relying on big extracts.

**Scale guidance:** with **`oracledb` mode (default)** the DB load is no longer the limit
(155× faster) — at any size the cost is the download + the OTBI export cap, so the cap is the
only thing to watch (≤65k safe; confirm `instanceconfig` before relying on more). The legacy
`sqlcl` fallback is load-bound: ≤20k ~1–2 min · ~50k ~5 min · ~100k ~10 min.

## 8. MFA number delivery
`notify.send()` pushes the match number when a login is needed (channel via `ATD_NOTIFY`):
`telegram` (configured), `webhook` (Teams/Slack), `email` (SMTP), `sms` (Twilio). Best-effort —
a notify failure never breaks the login. The number is also printed and written to a file.

## 9. Environment variables (complete)
| Var | Purpose | Default |
|---|---|---|
| `OTBI_USER` / `OTBI_PWD` | Fusion login | — (required) |
| `ATD_STATE_DIR` | saved sessions + mfa file | `.` |
| `ATD_MFA_WAIT` | seconds to wait for approval | 420 |
| `ATD_DB_MODE` | `oracledb` \| `sqlcl` | auto: `oracledb` if `ATD_DB_USER`+`PASSWORD` set, else `sqlcl` |
| `ATD_DB_USER`/`ATD_DB_PASSWORD`/`ATD_DB_DSN` | oracledb login + DSN | — (required for oracledb) |
| `ATD_WALLET_PASSWORD` | decrypts the wallet `ewallet.pem` (thin mode) | — (required for oracledb; = DB password here) |
| `TNS_ADMIN` | wallet dir (`ewallet.pem` + `tnsnames.ora`) | — (required for oracledb) |
| `ATD_DB_CHUNK` | rows per array-bind chunk (oracledb) | 5000 |
| `ATD_SQLCL` / `ATD_SQLCL_CONN` | SQLcl path / named connection (fallback) | local sql.exe / `prod_mcp` |
| `ATD_LOAD_METHOD` / `ATD_LOAD_BATCH` | SQLcl-mode tuning | `insert` / 200 |
| `ATD_NOTIFY` + channel vars | MFA delivery | off |
| `ATD_TRUNCATION_CAPS` / `ATD_EXPECTED_MIN` | truncation warning | common caps |

## 10. Gotchas (all bitten during the build)
- **Go-URL lowercase `path`** (capital → 404).
- **SQLcl headless on Windows:** needs an empty **real-file** stdin + real-file stdout, else
  `java.io.IOException: Incorrect function`. Handled in `sqlrun.py`. (Not an issue on Linux.)
- **SQLcl `SET LONG`** must be raised or CLOB columns (`column_map_json`) truncate to 80 chars →
  invalid JSON.
- **ORA-12860** on seed `MERGE` → `ALTER SESSION DISABLE PARALLEL DML` + `NOPARALLEL`.
- **Mixed date precision** (date-only + datetime) in one analysis: `oracledb` parses per column
  type in Python; SQLcl path emits per-value `TO_DATE` with the right mask.
- **Git Bash mangles** `/users/...` CLI args (MSYS path conversion) → run helpers from
  PowerShell/cmd or set `MSYS_NO_PATHCONV=1`.
- **oracledb thin mode needs the WALLET password** to decrypt `ewallet.pem` (`BEGIN ENCRYPTED
  PRIVATE KEY`). SQLcl/JDBC don't, because they use the password-less `cwallet.sso` (which thin
  mode ignores). Set `ATD_WALLET_PASSWORD` (here it equals the DB password). Symptom if missing:
  TLS handshake fails.
- **Wallet `retry_count` makes a bad connect "hang" ~60s** — ADB `tnsnames.ora` entries carry
  `(retry_count=20)(retry_delay=3)`, so a failing connect silently retries ~60s before erroring.
  A *correct* connect is <1s. When diagnosing, use a one-off descriptor with `(retry_count=0)` to
  fail fast. (No Oracle Instant Client / Java needed — python-oracledb thin mode is pure Python.)

## 11. Adding an analysis later
```
python add_analysis.py "/users/.../Folder/Analysis" [--table NAME] [--job NAME]
                       [--load-mode TRUNCATE_INSERT|MERGE] [--key "Header"] [--apply]
```
Downloads a sample, auto-derives column names/types, and emits `CREATE TABLE` + an
`ATD_OTBI_JOBS` seed under `db/generated/`. Review, then apply (or `--apply`). No code change.

## 11b. Creating an analysis (generic builder + specs)
`add_analysis.py` assumes the analysis already exists. `create_analysis.py` **builds it** —
generic across subject areas, driven by a declarative **spec** (the four inputs: the data =
`subject_area` + `columns[]`; optional `params[]`; the `save_folder`; the `name`). It reuses
`auth.authenticate()` (same federated/MFA session as the runner) and drives the OTBI **Answers**
UI with Playwright: open the subject area → add columns → set headings → add any prompted
filters → Save As → verify the saved path downloads as CSV.
```
python create_analysis.py --spec ../specs/po_headers.json [--headed] [--pause] [--load]
```
- Specs live in `otbi-atd/specs/*.json`. `po_headers.json` is the reference (PO header details,
  `Procurement - Purchasing Real Time`, saved to `/users/.../PO/PO Headers`).
- `--load` chains `add_analysis.py` + `runner.py` so creation→table→load is one command.
- **The Answers editor is a heavy dynamic JS app — selectors are confirmed live.** Bring up a
  new pod/subject area with `--headed` (watch) or `--pause` (Playwright inspector to record
  selectors), then harden the selector lists. Failures screenshot to `ATD_STATE_DIR`
  (`create_<step>_*.png`). Most fragile step = prompted filters; columns-only works standalone.
- Saving to a **personal** `/users/<you>/...` folder is fine only if the runner logs in as the
  same account; otherwise save to `/Shared Folders/...` (just change the spec's `save_folder`).

## 12. File map
```
otbi-atd/
  db/   01 control tables · 02 net ACL · 03 ATD_OTBI_PKG (Track A) · 04 scheduler ·
        05 seed example · 06 grn table · 07 grn seed · 08 suppliers · 09 beneficiaries ·
        10 seed more · 11 job ordering (priority/run_order) · install.sql · generated/
  runner/  runner.py (orchestrator, 2 modes) · auth.py (federated MFA + notify) ·
           extract.py (Go-URL) · loadsql.py (SQLcl load) · load.py (oracledb chunked) ·
           sqlrun.py (SQLcl bridge) · config.py · checks.py (truncation) · notify.py ·
           add_analysis.py · requirements.txt · env.ps1 (git-ignored secrets)
  docs/  REFERENCE.md (this) · deployment-notes.md · oci-vm-setup.md
```

### Per-host requirements for `oracledb` mode (the default)
1. **Python 3.8+** (already needed for Playwright).
2. **`pip install python-oracledb`** — pure-Python **thin mode**: no Oracle Instant Client, no Java.
3. **ADB wallet** at `TNS_ADMIN`: needs `ewallet.pem` (mTLS client key) + `tnsnames.ora` (DSN
   alias). `cwallet.sso` is **not** used by thin mode; `sqlnet.ora` optional.
4. **`ATD_WALLET_PASSWORD`** to decrypt `ewallet.pem` (= DB password here).
5. **`ATD_DB_USER` / `ATD_DB_PASSWORD` / `ATD_DB_DSN`** (`prod_low|medium|high`).
6. **Network egress:** TCP **1522 (TCPS)** → `adb.me-abudhabi-1.oraclecloud.com` (outbound only).

Both modes ultimately need the wallet + DB credentials on the host; SQLcl just hides them inside
its saved connection. oracledb is *lighter to install* (one pip package, no Java) and 155× faster
on load — the only extra it asks for is the wallet password as an explicit env var. Secret-mgmt
for many hosts: wallet on the box, passwords in **OCI Vault** (don't bake into images / commit).

## 13. Deployment targets
- **Windows host** — `oracledb` mode (default), Task Scheduler. Secrets in git-ignored `env.ps1`.
- **OCI Always-Free VM (recommended)** — Ubuntu ARM (Ampere A1, 2 OCPU/12 GB), **fully headless**
  (Telegram delivers the MFA number, no VNC). cron-scheduled. See `oci-vm-setup.md`.

## 14. Status (2026-06-17)
3 jobs live and verified end-to-end (GRN All / Suppliers / Beneficiaries). **`oracledb` mode now
the default** and benchmarked on this host: pure DB load **80.7s → 0.5s (155×)**, end-to-end
109s → 17.5s. Job ordering (`priority` + `run_order`) deployed (`db/11`). MFA delivered via
Telegram, approved from phone. Wallet-password (thin mode) + retry-hang gotchas captured (§10).
Next: #3 multi-host shared-queue (claim/`SKIP LOCKED` + `--worker`).
