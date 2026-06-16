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
Two interchangeable load paths (env `ATD_DB_MODE`):

| Mode | How | Credentials | Speed |
|---|---|---|---|
| **`sqlcl`** (default) | SQLcl `sql -name prod_mcp`, batched literal `INSERT ALL` | **none** (reuses SQLcl's stored connection) | baseline |
| **`oracledb`** (fast) | python-oracledb chunked `executemany` (array bind) | `ATD_DB_USER/PASSWORD/DSN` + wallet | ~10× on large tables |

**Measured steady-state cycle (session cached, all 3 jobs ≈ 15k rows, SQLcl mode):**
```
config read (SQLcl)  7.5s
auth (cached)        5.7s
downloads            1.1s   (negligible)
loads              115.3s   ← bottleneck (88%)
  Beneficiaries 12,086  81.0s
  GRN All        1,527  17.9s
  Suppliers      1,398  16.4s
TOTAL              ~130s (~2m10s)
```

**Load-method experiments (don't repeat these — conclusions recorded):**
| Method | 12,086-row load | 3-job cycle |
|---|---|---|
| Batched INSERT, `ATD_LOAD_BATCH=200` (default) | 81s | **130s — best** |
| Batched INSERT, batch=500 | 121s | 186s (worse) |
| SQLcl native `LOAD` | 116s | 390s (much worse) |

Why bigger batches / `LOAD` are slower: the SQLcl path writes **literal values** (no bind
variables), so every statement is **hard-parsed**; larger statements cost more to parse than the
round-trips they save. This is the floor for the credential-free path. The real fix is **bind
variables** → that's exactly what `oracledb` mode does (`executemany`), which would load 12k
rows in ~2–3s.

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

**Scale guidance (SQLcl mode):** ≤20k ✅ ~1–2 min · ~50k ✅ ~5 min · ~100k ⚠️ ~10 min + may hit
OTBI cap · 200k+ → use `oracledb` mode and confirm the OTBI limit.

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
| `ATD_DB_MODE` | `sqlcl` \| `oracledb` | `sqlcl` |
| `ATD_SQLCL` / `ATD_SQLCL_CONN` | SQLcl path / named connection | local sql.exe / `prod_mcp` |
| `ATD_LOAD_METHOD` | `insert` \| `bulk` (SQLcl mode) | `insert` |
| `ATD_LOAD_BATCH` | rows per INSERT ALL (SQLcl) | 200 |
| `ATD_DB_USER`/`ATD_DB_PASSWORD`/`ATD_DB_DSN`/`TNS_ADMIN` | oracledb mode | — |
| `ATD_DB_CHUNK` | rows per array-bind chunk (oracledb) | 5000 |
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

## 11. Adding an analysis later
```
python add_analysis.py "/users/.../Folder/Analysis" [--table NAME] [--job NAME]
                       [--load-mode TRUNCATE_INSERT|MERGE] [--key "Header"] [--apply]
```
Downloads a sample, auto-derives column names/types, and emits `CREATE TABLE` + an
`ATD_OTBI_JOBS` seed under `db/generated/`. Review, then apply (or `--apply`). No code change.

## 12. File map
```
otbi-atd/
  db/   01 control tables · 02 net ACL · 03 ATD_OTBI_PKG (Track A) · 04 scheduler ·
        05 seed example · 06 grn table · 07 grn seed · 08 suppliers · 09 beneficiaries ·
        10 seed more · install.sql · generated/ (from add_analysis)
  runner/  runner.py (orchestrator, 2 modes) · auth.py (federated MFA + notify) ·
           extract.py (Go-URL) · loadsql.py (SQLcl load) · load.py (oracledb chunked) ·
           sqlrun.py (SQLcl bridge) · config.py · checks.py (truncation) · notify.py ·
           add_analysis.py · requirements.txt
  docs/  REFERENCE.md (this) · deployment-notes.md · oci-vm-setup.md · functions_list?
```

## 13. Deployment targets
- **Windows host** — SQLcl mode, Task Scheduler. No DB creds.
- **OCI Always-Free VM (recommended)** — Ubuntu ARM (Ampere A1, 2 OCPU/12 GB), **fully headless**
  (Telegram delivers the MFA number, no VNC). cron-scheduled. See `oci-vm-setup.md`. On the VM,
  enabling `oracledb` mode gives the large-file speed-up.

## 14. Status (2026-06-17)
3 jobs live and verified end-to-end (GRN All 1,527 / Suppliers 1,398 / Beneficiaries 12,086),
SQLcl mode, MFA number delivered via Telegram and approved from phone. `oracledb` fast-mode +
chunking + truncation check implemented; first live `oracledb` run pending DB creds (the VM).
