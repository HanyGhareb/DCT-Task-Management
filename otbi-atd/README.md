# OTBI → ATD Automation

Config-driven automation that runs Oracle **OTBI** analyses, gets their data as CSV, and loads
it into the **ATD** database — replacing the manual "run each analysis → export CSV → update
ATD" routine. Inputs (analysis path + target table + which OTBI host + which account + which
target DB) are all **data**, held in control tables — no code change to add/repoint a job.

See the design rationale in `../` plan file:
`C:\Users\hanyg\.claude\plans\before-moving-forward-to-sleepy-badger.md`.

## Two extraction tracks, one config

| | Track A (recommended) | Track B (fallback) |
|---|---|---|
| Engine | BI Publisher **SOAP `runReport`** API | Browser **Go-URL** CSV download |
| Runs | **inside ATP** (`APEX_WEB_SERVICE` + `DBMS_SCHEDULER`) | external host (Playwright + httpx) |
| Browser / MFA | none | yes (periodic MFA re-approval) |
| Code | `db/` PL/SQL | `runner/` Python |

Both tracks read the **same** control tables (`ATD_OTBI_ENV`, `ATD_TARGET_DB`, `ATD_OTBI_JOBS`)
and write the same `ATD_LOAD_RUN_LOG`.

## Confirmed (probed 2026-06-16)
The pod `iaaibv.fa.ocs.oraclecloud29.com` exposes the BIP SOAP service
(`/xmlpserver/services/ExternalReportWSSService?wsdl` → 200) with `runReport`, so Track A is
viable. The OTBI Go-URL CSV download also works (Track B fallback viable).

## Layout
```
otbi-atd/
  db/                       ← Track A (in-ATP) + shared control tables
    01_atd_control_tables.sql   control tables + run log + example staging/final
    02_atd_network_acl.sql      ACL so APEX_WEB_SERVICE can reach the pod
    03_atd_otbi_pkg.sql         ATD_OTBI_PKG: runReport → parse → load → log
    04_atd_scheduler.sql        DBMS_SCHEDULER jobs built from ATD_OTBI_JOBS
    install.sql                 runs 01→04 in order
  runner/                   ← Track B (external) — reads the same control tables
    (scaffolded next)
  README.md
```

## Deploy (Track A) — run when creds + account decision are ready
All scripts are **CRLF + UTF-8 no BOM**, `SET DEFINE OFF`, schema-qualified. Run via SQLcl:
```powershell
sql -name prod_mcp
@c:/claude/DCT-task-management/DCT-Task-Management/otbi-atd/db/install.sql
```
> Deployment is intentionally **not** run yet — it creates objects on the live DB and needs the
> Fusion service account + ACL host confirmed first.

## Status / open gate
1. **Account / auth mode** — confirm whether a dedicated service account (WSS, MFA-exempt) is
   available, a session/OAuth token bridge, or Track B fallback. Sets `ATD_OTBI_ENV.auth_type`.
2. **Authenticated probe** — `curl` SOAP `validateLogin` + `runReport` once creds exist.
3. **Pick one real analysis + target ATD table** to seed the first job and run end-to-end.

The `get_secret()` hook in `ATD_OTBI_PKG` is the single place auth wires in — see its header
comment for the OCI Vault vs restricted-table options.
