# otbi-atd worker VM — restart runbook (atd-vm180 / 181 / 182)

The worker runs as a systemd service (`atd-worker`) that is **enabled** (auto-starts on boot) and
**Restart=always**. So after a reboot or crash, in the normal case **you do nothing** — it comes back
by itself and reuses its saved Fusion session.

## After a VM reboot — the only thing to watch
1. The worker auto-starts and tries to log in to OTBI using its **saved session**.
2. **If the saved session is still valid** → it resumes silently. Nothing to do. ✅
3. **If the session expired** (Microsoft Entra eventually expires it) → it sends **one MFA number to
   Telegram** (tagged with the VM name, e.g. `atd-vm181`). **Open Microsoft Authenticator and approve
   that number.** It then saves a fresh session and resumes.

## Quick health check (optional, from the control PC)
```bash
KEY=/c/tmp/atd-provision/keys/atd_id_ed25519
ssh -i $KEY root@192.168.1.181 "systemctl is-active atd-worker; journalctl -u atd-worker -n 20 --no-pager"
```
- `active` = running. Look for `[worker atd-vm181] starting` and `[ok] <JOB>: N rows`.
- `>>> APPROVE THE AUTHENTICATOR PUSH — ENTER NUMBER: NN` = it's waiting for you to approve NN.
- The **Worker Fleet panel** on the App 208 dashboard shows each VM green (online) / red (offline).

## Manual controls (rarely needed)
```bash
ssh -i $KEY root@192.168.1.181 "systemctl restart atd-worker"   # restart the worker
ssh -i $KEY root@192.168.1.181 "systemctl stop atd-worker"      # stop it
ssh -i $KEY root@192.168.1.181 "systemctl start atd-worker"     # start it
```
A stopped/crashed VM is safe: the other VMs keep draining the queue, and any job the dead VM was
mid-way through is automatically re-run by a healthy VM after the lease (~10–30 min).

## If you ever need to re-seed a session by hand (e.g. you want to pre-approve before peak)
```bash
ssh -i $KEY root@192.168.1.181 "systemctl stop atd-worker; cd ~/otbi-atd/runner && source ~/otbi-atd/env.sh && \
  ~/otbi-atd/venv/bin/python -c 'import config,auth; from playwright.sync_api import sync_playwright; \
  c=config.connect();cur=c.cursor();cur.execute(\"select env_name,analytics_base_url,nvl(credential_ref,env_name) from prod.atd_otbi_env where enabled=chr(89) and rownum=1\");e,u,r=cur.fetchone(); \
  p=sync_playwright().start(); b,x=auth.authenticate(p,{\"env_name\":e,\"analytics_base_url\":u,\"credential_ref\":r}); print(\"SEEDED\"); b.close()'; \
  systemctl start atd-worker"
# -> approve the Telegram number, then the service restarts with a fresh session.
```

## Notes
- Nothing needs the old Windows PC anymore (its "OTBI-ATD Loader" task is disabled).
- Jobs are re-queued automatically every 15 min by the DB job `ATD_ENQUEUE_JOB` — no action on restart.
