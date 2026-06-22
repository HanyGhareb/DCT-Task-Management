# Troubleshooting failed ATD load jobs — a learning guide

This guide teaches you how to diagnose a run that shows **FAILED** in the App 208
(Analytics Loader) **Run Logs**, using the 3-VM worker fleet (atd-vm180 / 181 / 182 =
192.168.1.180 / .181 / .182). Read the error message first — it almost always tells you
the family of problem. Then confirm on the VMs.

```
KEY=/c/tmp/atd-provision/keys/atd_id_ed25519     # the SSH key (control PC)
```

---

## Step 0 — read the run's MESSAGE in the UI

Open **Run Logs → click the failed run**. The `MESSAGE` field is the single most
important clue. Map it to a family below.

| MESSAGE contains… | Family | Most likely cause |
|---|---|---|
| `did not return CSV (… type=text/html …)` / `Session likely expired` | **Auth / session** | Fusion/Entra session expired; OTBI returned the login page instead of CSV |
| `MFA not approved within timeout` | **Auth / session** | A re-login push was sent but nobody approved it in Authenticator |
| `path wrong` (and the path looks wrong) | **Catalog path** | The OTBI report was moved/renamed; `source_ref` no longer resolves |
| `ORA-…` (e.g. `ORA-00942`, `ORA-01017`, `ORA-12541`) | **DB / load** | Target table/grant/connection problem on ADB, not Fusion |
| `column map` / `prepare` / `discover` errors | **Schema / mapping** | Report columns changed; the staging table no longer matches |
| `claim`/`lease`/nothing in log | **Queue / worker** | Worker down, or job stuck CLAIMED by a dead VM |

The error in the screenshot that triggered this guide —
`Go-URL did not return CSV (status=200, type=text/html…). Session likely expired` — is the
**Auth / session** family. It is by far the most common failure because the session
behind a browser-based scraper is inherently perishable.

---

## Step 1 — is it ALL jobs or ONE job?

- **All jobs on all VMs failing** → it's environment-wide: almost always **auth/session**
  (one shared Fusion account) or ADB down. Not a per-report problem.
- **One job failing, others succeed** → it's that report: **catalog path** moved, or its
  **schema/mapping** drifted. Leave the session alone.
- **All jobs on ONE VM failing, other VMs fine** → that VM's session or host is sick;
  re-seed just that VM (Step 4).

Quick way to tell, from the control PC:

```bash
for ip in 180 181 182; do
  echo "== vm$ip =="
  ssh -i $KEY root@192.168.1.$ip \
    "journalctl -u atd-worker --no-pager | grep -iE '\[ok\]|\[FAIL\]' | tail -5"
done
```
`[ok] <JOB>: N rows` = success; `[FAIL] <JOB>: …` = failure. Compare across VMs.

---

## Step 2 — confirm the workers are even running

```bash
for ip in 180 181 182; do
  echo "== vm$ip =="
  ssh -i $KEY root@192.168.1.$ip "systemctl is-active atd-worker"
done
```
- `active` on all three = the software is fine; the failure is auth/data, not the service.
- `failed`/`inactive` = the **Queue / worker** family → `systemctl status atd-worker -l`
  and `journalctl -u atd-worker -n 50` to see why it died; `systemctl restart atd-worker`.

A live worker that has no work prints `[discover] no queued subject-area discovery
requests` every ~15s. That is **idle, not broken** — it just means no load job is
currently READY in the queue.

---

## Step 3 — for the Auth / session family, read the auth trail

```bash
ssh -i $KEY root@192.168.1.180 \
  "journalctl -u atd-worker --no-pager | grep -iE 'APPROVE|MFA not approved|did not return CSV|\[ok\]' | tail -30"
```
Interpret:
- `>>> APPROVE THE AUTHENTICATOR PUSH — ENTER NUMBER: NN` = the worker asked for MFA. If
  you see this **without** a later success, **the number was never approved**.
- `MFA not approved within timeout — session not established` = confirmed: the push
  expired un-approved. This is the cause you must fix in Step 4.
- A clean run looks like `[ok] GL_BALANCES: 9527 rows -> PROD.ATD_GL_BALANCES`.

Check the saved-session age (it should refresh each time MFA is approved):
```bash
ssh -i $KEY root@192.168.1.180 \
  "ls -la --time-style=long-iso ~/otbi-atd-state/auth_state_*.json"
```
An `auth_state_*.json` older than the first FAIL = a dead session that was never renewed.

---

## Step 4 — fix the Auth / session family: RE-SEED (needs a human + phone)

A browser session that needs number-matching MFA **cannot** be renewed unattended. You
must approve the push. Have **Microsoft Authenticator** and **Telegram** open, then:

```bash
# Restart each worker — it detects the dead session and pushes ONE MFA number to Telegram
for ip in 180 181 182; do
  ssh -i $KEY root@192.168.1.$ip "systemctl restart atd-worker"
done
```
Then within ~2 minutes, **approve the 3 numbers** in Authenticator (each push is tagged
with its VM name). Each VM saves a fresh `auth_state_*.json` and resumes. Confirm:

```bash
ssh -i $KEY root@192.168.1.180 \
  "journalctl -u atd-worker -n 15 --no-pager | grep -iE '\[ok\]|APPROVE'"
```
If the push **didn't appear** in Telegram, the restart may have re-validated an apparently
still-good session (no MFA needed) — or `notify` isn't configured. To force a clean login,
delete the stale state first:
```bash
ssh -i $KEY root@192.168.1.180 \
  "systemctl stop atd-worker; rm -f ~/otbi-atd-state/auth_state_FUSION_ADGOV.json; systemctl start atd-worker"
```

> **Timing matters.** The MFA number expires in a couple of minutes. Don't restart until
> you're at your phone. Re-seeding all three back-to-back means three approvals in a row.

---

## Step 5 — fix the other families

**Catalog path** (`path wrong`, only one job fails): the OTBI report moved or was renamed.
Open the job in **Jobs → (job) → detail**, check `source_ref` against the actual OTBI
catalog path, and correct it. Re-run.

**Schema / mapping** (column-map errors after a report's columns changed): on the job
detail page use **Re-map** (re-derives the column map from the live analysis) or
**Rebuild** (drops + recreates the staging table — discards loaded rows). Then enqueue.

**DB / load** (`ORA-…`): the Fusion side worked; the load into ADB failed. Check the exact
ORA code — `ORA-00942` (table/grant missing on PROD), `ORA-01017` (ADB creds in `env.sh`),
`ORA-12541`/TNS (wallet/DSN). Fix on the target side; the session is fine.

**Queue / worker** (job stuck, worker dead): a job CLAIMED by a crashed VM is returned to
READY automatically after the lease (~10–30 min) and re-run by a healthy VM — usually just
wait. If a service is down, `systemctl restart atd-worker` on that VM.

---

## Mental model — why "session expired" is the usual suspect

The runner is a **browser robot** logged into Fusion as a real user. That login is a
perishable cookie/token issued by Microsoft Entra; it expires on Entra's schedule (hours),
and renewing it requires a **human MFA approval** — it is *designed* to resist automation.
So the steady state is: jobs run fine for a while, the session silently dies, and every job
fails identically until someone re-approves MFA. When you see *every* job failing with
`type=text/html` / `Session likely expired`, **don't debug the reports or the DB** — go
straight to Step 4 and re-seed.

**Self-heal (fixed 2026-06-22):** the worker now catches a session-expiry load failure
(`SessionExpired`, raised by `extract.download_csv` on the HTTP 200 + HTML login bounce),
drops the dead cached context, re-runs `authenticate()` (→ **one** MFA push) and retries the
job once. So a *mid-life* expiry self-heals after a single approval instead of failing jobs
for hours. You still must **approve the MFA** — but now it prompts the instant a job hits the
dead session, and recovers automatically once you tap. (Before this fix, the long-lived
`--forever` loop validated the session only once at startup and never re-prompted from the
load path — the cause of the ~20h outage that prompted this guide.) Track A (BIP SOAP, no
browser/MFA) remains the long-term path that removes this failure family entirely.

---

## One-shot health snapshot (paste this anytime)

```bash
KEY=/c/tmp/atd-provision/keys/atd_id_ed25519
for ip in 180 181 182; do
  echo "==================== vm$ip ===================="
  ssh -i $KEY root@192.168.1.$ip "
    echo -n 'service: '; systemctl is-active atd-worker
    echo -n 'session: '; ls --time-style=long-iso -l ~/otbi-atd-state/auth_state_FUSION_ADGOV.json 2>/dev/null | awk '{print \$6, \$7}'
    echo 'recent:'; journalctl -u atd-worker --no-pager | grep -iE '\[ok\]|\[FAIL\]|APPROVE|MFA not approved' | tail -5
  "
done
```
The **Worker Fleet** panel on the App 208 dashboard shows the same green/red health
without SSH.
