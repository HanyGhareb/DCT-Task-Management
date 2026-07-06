# i-Finance Web Tier (Deployment Option C)

Production web tier for the i-Finance JET frontends: one Nginx VM that serves
`final apps/` as a single web root and reverse-proxies `/ords/` to ADB managed
ORDS — the production equivalent of `dev-proxy.py`, with TLS, security headers
and rate limiting added. **Zero frontend code changes**: `config.js` keeps
`apiBase: '/ords/admin/dct'` etc., root-absolute `/PC/Jet/…`, `/shared/…` and
`/FL/Portal/…` URLs resolve exactly as they do under the dev proxy, and CORS
disappears because everything is same-origin.

Full option analysis / comparison: `.claude/plans` deployment proposal
(Option A pure-ADB / **Option C this kit** / Option B LB+WAF end-state).

## Contents

| File | Purpose |
|---|---|
| `DEPLOYMENT.md` | **Day-to-day "how do I ship a change" steps** (frontend redeploy, rollback, config refresh, troubleshooting). Start there. |
| `nginx/ifinance.conf` | Server config (HTTP→HTTPS redirect, TLS, headers, rate limits, static root, `/ords/` proxy). Placeholders substituted at provision time. |
| `nginx/ifinance-ords.inc` | Shared `/ords/` reverse-proxy snippet (180s read timeout for FL AI extraction; Bearer `Authorization` passes through untouched). |
| `provision_webtier.sh` | One-shot VM setup over ssh: installs nginx, self-signed bootstrap cert, config, SELinux boolean, firewall. Idempotent. |
| `deploy_frontend.sh` | Ships `shared/` + every `<App>/Jet/` + `FL/Portal/` as a timestamped release; live root is the `/var/www/ifinance/current` symlink (instant rollback, keeps last 5). |

## Target VM & topology (decided 2026-07-06)

**The OCI VM is the WEB TIER ONLY.** Workers (reporting PYTHON engine +
otbi-atd runner) stay on the existing local fleet `vm180/181/182` — do NOT
deploy workers to this VM. Its role is exactly: serve static frontends +
reverse-proxy `/ords/` to the ADB.

Shape: **`VM.Standard.E2.1.Micro` (Always Free, 1 OCPU / 1 GB, x86)** is
sufficient — nginx static+proxy is a tens-of-MB workload. (An Ampere A1 also
works if capacity appears; the micro allowance is separate from the A1
allowance.) Any Oracle Linux 8/9 or Ubuntu 20.04+ image, x86_64 or aarch64.

Notes for Always Free specifically:
- Always Free compute must live in the tenancy **home region** — confirm it is
  `me-abudhabi-1` (same as the ADB) when creating the instance.
- On a purely-Free tenancy Oracle may reclaim **idle** instances. Upgrading the
  tenancy to Pay-As-You-Go keeps the free allowance (still $0 within limits)
  and removes the reclamation risk — recommended before this becomes the
  production entry point.
- On a 1 GB shape add a small swap file (2 GB) before heavy `dnf` runs —
  nginx itself never needs it, but package installs can get memory-squeezed.
- VM creation itself is manual (OCI Console): Instances → Create, Oracle
  Linux 9 or Ubuntu 22.04, public subnet, **ingress TCP 80 + 443 in the
  security list / NSG** (22 from your IP only).
  See `otbi-atd/docs/oci-vm-setup.md` for the same Console flow.

## Deploy

From Git Bash on any machine with the repo + ssh access to the VM:

```bash
cd webtier
# OL images log in as 'opc', Ubuntu images as 'ubuntu' (sudo is handled):
SSH_USER=opc ./provision_webtier.sh <vm-ip> [dns-name]
SSH_USER=opc ./deploy_frontend.sh  <vm-ip>
```

Then open `https://<vm-ip-or-dns>/` → redirects to `/Admin/Jet/index.html`.
The self-signed certificate warning is expected until a real cert is installed.

Re-deploying the frontend after code changes = bump `window.APP_VERSION` in
each changed app's `Jet/index.html` (unchanged platform rule — it is the
browser cache key), then re-run `deploy_frontend.sh`.

## Smoke test checklist

1. `curl -kI https://<host>/` → `302` to `/Admin/Jet/index.html`; headers
   include `X-Content-Type-Options: nosniff`.
2. `curl -k https://<host>/ords/admin/dct/branding` → JSON (the one public
   endpoint; proves the ORDS proxy + SNI + resolver work).
3. Log in via the Admin app over HTTPS; switch modules with the top-bar
   switcher (validates root-absolute sibling URLs); open one BI Interactive
   Report and one GL Actuals page (validates authed GET/POST through proxy).
4. Upload a document in FL/CC/TM (validates `client_max_body_size` + binary
   `:body` uploads through the proxy).
5. `for i in $(seq 1 15); do curl -k -s -o /dev/null -w '%{http_code}\n' \
   https://<host>/ords/admin/fl/portal/auth/login -X POST -d '{}'; done`
   → later requests return `429` (portal rate limiter live).
6. Optionally point a Playwright UAT runner (`assessment-3/phase4/tests/`
   pattern) at the new origin instead of `localhost:8080`.

## Hardening follow-ups (in order)

1. **Real TLS cert** once a DNS name exists: `dnf/apt install certbot
   python3-certbot-nginx && certbot --nginx -d <dns-name>` (the `:80` server
   already exposes the ACME webroot). THEN uncomment the
   `Strict-Transport-Security` header in `ifinance.conf` — never enable HSTS
   while on the self-signed cert.
2. **CSP header**: derive the allowlist from devtools (JET/KO from
   `static.oracle.com`, Google Fonts, Chart.js/SheetJS CDN) and add it as
   `Content-Security-Policy-Report-Only` first.
3. **Option B evolution** (when the FL Portal opens to real freelancers): put
   an OCI Load Balancer + WAF + custom domain in front of this VM and move the
   ADB to a private endpoint. Nothing in this kit is thrown away.

## Deployment history & gotchas

**2026-07-06 — first production deployment.** Instance `ifinance-web`,
`VM.Standard.E2.1.Micro` (Always Free), OL 9.7, public IP `129.151.159.189`,
`me-abudhabi-1`. All smoke tests green (redirect, ORDS proxy end-to-end 401,
security/cache headers, portal limiter 429 after burst). Self-signed cert
(no DNS name yet); HSTS deliberately NOT enabled.

Gotchas learned on this deploy (all baked back into the scripts):
1. **`dnf` is unusable on the micro** — the kernel OOM-killer reaps it every
   time (even with 2.5 GB swap; the throttled disk can't swap fast enough,
   and the `dnf-makecache` timer piles on). Fix = install nginx via direct
   `rpm -Uvh` of 4 RPMs curl'd from `yum.oracle.com` (nginx, nginx-core,
   nginx-filesystem + dep `oracle-logos-httpd`); the provision script now
   skips its dnf step when nginx is already present. If wedged: force-reboot
   from the OCI Console — SSH banner-exchange timeouts = swap thrash.
2. **First boot showed only 498 MB RAM; after a reboot the box reports 945 MB.**
   If free memory looks halved, reboot before debugging anything else.
3. **SELinux vs `mv` from /tmp**: configs scp'd to /tmp then mv'd keep
   `user_tmp_t` and nginx fails to start with Permission denied even though
   `nginx -t` (run unconfined) passes. Script now runs `restorecon -R
   /etc/nginx`.
4. **ORDS absolute redirects**: ORDS 301s `/x` → `/x/` with a Location on the
   ADB hostname; browsers would leave the origin and drop the Authorization
   header (dev-proxy hid this by following redirects server-side).
   `proxy_redirect` with the **literal** host rewrites it — the `$ords_host`
   variable form silently fails to match on nginx 1.20.
5. `dnf-makecache.timer` is permanently disabled on the VM; run
   `sudo dnf makecache` manually (expect pain) or temporarily add swap +
   stop agents before any future dnf work.

## Rollback

- Frontend: `ln -sfn /var/www/ifinance-releases/<previous> /var/www/ifinance/current`
- Whole tier: stop nginx; users fall back to nothing (there is no prior
  production entry point), so treat the VM as canary until sign-off.
