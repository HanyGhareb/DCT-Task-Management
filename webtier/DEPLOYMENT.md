# Deploying Changes to the i-Finance Web Tier

Quick reference for shipping changes to production once they work locally.
The web tier is `ifinance-web` — OCI `VM.Standard.E2.1.Micro` (Always Free),
Oracle Linux 9, public IP **129.151.159.189**, region `me-abudhabi-1`.

| What | Value |
|---|---|
| URL | `https://129.151.159.189/` (self-signed cert until a DNS name exists) |
| SSH | `ssh opc@129.151.159.189` (key: `C:\Users\hanyg\Desktop\DCT\ssh-key-2026-07-06.key`, entry already in `~/.ssh/config`) |
| Web root | `/var/www/ifinance/current` → symlink to `/var/www/ifinance-releases/<timestamp>` |
| nginx config | `/etc/nginx/conf.d/ifinance.conf` + `/etc/nginx/snippets/ifinance-ords.inc` |
| Security-list SSH rule | pinned to `94.59.158.153/32` — if ssh suddenly times out, your ISP IP rotated: fix the rule in OCI Console → VCN → Default Security List |

---

## 1. Frontend changes (JET apps, `final apps/shared/`, FL Portal) — the everyday case

```bash
# 1. Edit + test locally against dev-proxy.py (localhost:8080) as usual.

# 2. Bump window.APP_VERSION in the changed app's Jet/index.html.
#    A change under final apps/shared/ => bump APP_VERSION in ALL apps.
#    (Unchanged platform rule - it is the browser cache key; skipping it
#    means deployed browsers keep serving stale JS.)

# 3. Ship it (~10 seconds, from Git Bash):
cd webtier
SSH_USER=opc ./deploy_frontend.sh 129.151.159.189
```

The script packages `shared/` + every `<App>/Jet/` + `FL/Portal/` from the
working tree into a new timestamped release directory and flips the
`current` symlink. Users pick the new version up on their next page load.

**Verify:** open `https://129.151.159.189/<App>/Jet/index.html`, hard-refresh
(Ctrl+F5), check the footer/console APP_VERSION.

**Rollback (instant):**
```bash
ssh opc@129.151.159.189 "ls -dt /var/www/ifinance-releases/*"
ssh opc@129.151.159.189 "sudo ln -sfn /var/www/ifinance-releases/<previous> /var/www/ifinance/current"
```
(The deploy keeps the last 5 releases.)

## 2. Database / ORDS changes — nothing to do on the web tier

Deploy via SQLcl (`sql -name prod_mcp`) exactly as always. The web tier only
proxies `/ords/` to the ADB, so new endpoints, handlers, and package changes
are live through `https://129.151.159.189/` the moment they are in the DB.

## 3. nginx config changes (rare)

Edit `webtier/nginx/ifinance.conf` or `webtier/nginx/ifinance-ords.inc` in
the repo, then re-run the idempotent provisioner (skips the install step,
refreshes config + placeholders, restorecon, reloads nginx):

```bash
cd webtier
SSH_USER=opc ./provision_webtier.sh 129.151.159.189
```

Never edit config directly on the VM — it gets overwritten on the next
provision run; the repo is the source of truth.

## 4. APEX apps — unaffected

APEX apps (200-211) are served by the ADB's APEX engine at the
`oraclecloudapps.com` URL as before; nothing on the web tier to deploy.

---

## Rules that don't change

- **APP_VERSION bump on every frontend deploy** (all apps when `shared/`
  changed) — see each app's `docs/deployment-notes.md`.
- Update the app's `functions_list.md` + deployment notes in the same change,
  as per CLAUDE.md conventions.
- Workers (reporting + otbi-atd) live on the local `vm180-182` fleet — the
  web tier VM never runs workers.
- Never run `dnf` casually on this VM (it OOMs — see README gotcha #1). For
  packages, use the direct-rpm recipe in `README.md`.

## When something looks wrong

1. `curl -ksI https://129.151.159.189/` → expect `302` to `/Admin/Jet/index.html`.
2. `curl -ks https://129.151.159.189/ords/admin/dct/branding` → expect JSON
   (proves the ADB proxy path).
3. `ssh opc@129.151.159.189 "systemctl status nginx; sudo tail -20 /var/log/nginx/error.log"`.
4. SSH timing out entirely → your IP rotated (fix security-list rule) or the
   VM is swap-thrashing (force-reboot from OCI Console; see README gotcha #1).
5. Full deployment history + gotchas: `webtier/README.md`.
