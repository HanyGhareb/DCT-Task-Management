#!/usr/bin/env bash
# =============================================================================
# i-Finance web tier (Option C) - provision nginx on a Linux VM over ssh.
#
# Run FROM a machine with this repo + ssh access to the target (Git Bash OK):
#
#   ./provision_webtier.sh <host> [server-name]
#   ./provision_webtier.sh 140.x.x.x ifinance.example.ae
#
# Args : $1 = host/IP    $2 = public DNS name (omit when addressed by IP)
# Env  : SSH_USER (default root; use 'opc' on OL images, 'ubuntu' on Ubuntu -
#                  non-root users get sudo prefixed automatically)
#        ORDS_HOST (default = prod ADB managed-ORDS host)
#        SSHPASS   (optional, uses sshpass -e like the worker deploy scripts)
#
# Works on Oracle Linux 8/9 (dnf, SELinux, firewalld) and Ubuntu 20.04+
# (apt, OCI iptables rules), x86_64 or aarch64 (Ampere A1).
#
# What it does on the target:
#   nginx + openssl installed; /etc/nginx/conf.d/ifinance.conf +
#   /etc/nginx/snippets/ifinance-ords.inc (placeholders substituted);
#   self-signed bootstrap cert in /etc/nginx/ssl (replace via certbot later);
#   SELinux httpd_can_network_connect=1 (proxy_pass to ADB needs it);
#   firewall opened for 80/443; nginx enabled + started.
#
# It does NOT deploy the frontend (run ./deploy_frontend.sh <host> next) and
# it can NOT open the OCI security list / NSG - add ingress TCP 80,443 in the
# OCI Console yourself.
# =============================================================================
set -euo pipefail

HOST="${1:?usage: provision_webtier.sh <host> [server-name]}"
SERVER_NAME="${2:-_}"
SSH_USER="${SSH_USER:-root}"
ORDS_HOST="${ORDS_HOST:-gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com}"
KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

SUDO=""
[ "$SSH_USER" != "root" ] && SUDO="sudo "

SSH_OPTS=(-o StrictHostKeyChecking=accept-new -o ConnectTimeout=8)
if [ -n "${SSHPASS:-}" ]; then
  SSH=(sshpass -e ssh "${SSH_OPTS[@]}" "$SSH_USER@$HOST")
  SCP=(sshpass -e scp "${SSH_OPTS[@]}")
else
  SSH=(ssh "${SSH_OPTS[@]}" "$SSH_USER@$HOST")
  SCP=(scp "${SSH_OPTS[@]}")
fi

echo "== [$HOST] swap file (1 GB shapes get memory-squeezed during dnf runs)"
"${SSH[@]}" "if [ ! -f /swapfile ]; then
               ${SUDO}fallocate -l 2G /swapfile && ${SUDO}chmod 600 /swapfile &&
               ${SUDO}mkswap /swapfile >/dev/null && ${SUDO}swapon /swapfile &&
               echo '/swapfile none swap sw 0 0' | ${SUDO}tee -a /etc/fstab >/dev/null;
             fi; free -m | awk '/^Swap:/{print \"swap MB:\", \$2}'"

echo "== [$HOST] installing nginx + openssl"
# rpm -q guard: on memory-starved shapes (E2.1.Micro) dnf's resolver gets
# OOM-killed - install nginx via direct 'rpm -ivh' first, then re-run this
"${SSH[@]}" "if command -v nginx >/dev/null 2>&1 || rpm -q nginx >/dev/null 2>&1; then echo 'nginx already installed - skipping';
             elif command -v dnf >/dev/null 2>&1; then ${SUDO}dnf install -y -q --setopt=install_weak_deps=False nginx openssl;
             else ${SUDO}apt-get update -qq && DEBIAN_FRONTEND=noninteractive ${SUDO}apt-get install -y -qq nginx openssl; fi"

echo "== [$HOST] directories + self-signed bootstrap certificate"
"${SSH[@]}" "${SUDO}mkdir -p /etc/nginx/ssl /etc/nginx/snippets /var/www/ifinance /var/www/ifinance-releases /var/www/acme &&
             if [ ! -f /etc/nginx/ssl/ifinance.crt ]; then
               ${SUDO}openssl req -x509 -nodes -newkey rsa:2048 -days 825 \
                 -keyout /etc/nginx/ssl/ifinance.key -out /etc/nginx/ssl/ifinance.crt \
                 -subj '/CN=$SERVER_NAME' >/dev/null 2>&1;
             fi"

echo "== [$HOST] installing nginx config (server_name=$SERVER_NAME, ords=$ORDS_HOST)"
"${SCP[@]}" "$KIT_DIR/nginx/ifinance.conf"      "$SSH_USER@$HOST:/tmp/ifinance.conf"
"${SCP[@]}" "$KIT_DIR/nginx/ifinance-ords.inc"  "$SSH_USER@$HOST:/tmp/ifinance-ords.inc"
"${SSH[@]}" "RES=\$(awk '/^nameserver/{print \$2; exit}' /etc/resolv.conf); RES=\${RES:-8.8.8.8};
             ${SUDO}sed -i \"s|__RESOLVER__|\$RES|g; s|__ORDS_HOST__|$ORDS_HOST|g; s|__SERVER_NAME__|$SERVER_NAME|g\" /tmp/ifinance.conf;
             ${SUDO}sed -i \"s|__ORDS_HOST__|$ORDS_HOST|g\" /tmp/ifinance-ords.inc;
             ${SUDO}mv /tmp/ifinance.conf /etc/nginx/conf.d/ifinance.conf;
             ${SUDO}mv /tmp/ifinance-ords.inc /etc/nginx/snippets/ifinance-ords.inc;
             ${SUDO}rm -f /etc/nginx/sites-enabled/default;
             ${SUDO}sed -ri 's/(listen[[:space:]]+(\[::\]:)?80) default_server;/\1;/' /etc/nginx/nginx.conf || true;
             command -v restorecon >/dev/null 2>&1 && ${SUDO}restorecon -R /etc/nginx || true"

echo "== [$HOST] SELinux + firewall (whichever applies)"
"${SSH[@]}" "if command -v setsebool >/dev/null 2>&1 && sestatus 2>/dev/null | grep -qi 'status:.*enabled'; then
               ${SUDO}setsebool -P httpd_can_network_connect 1;
             fi;
             if systemctl is-active firewalld >/dev/null 2>&1; then
               ${SUDO}firewall-cmd -q --permanent --add-service=http --add-service=https && ${SUDO}firewall-cmd -q --reload;
             elif command -v iptables >/dev/null 2>&1; then
               ${SUDO}iptables -C INPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null || ${SUDO}iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT;
               ${SUDO}iptables -C INPUT -p tcp --dport 443 -j ACCEPT 2>/dev/null || ${SUDO}iptables -I INPUT 1 -p tcp --dport 443 -j ACCEPT;
               command -v netfilter-persistent >/dev/null 2>&1 && ${SUDO}netfilter-persistent save || true;
             fi"

echo "== [$HOST] starting nginx"
"${SSH[@]}" "${SUDO}nginx -t && ${SUDO}systemctl enable --now nginx && ${SUDO}systemctl reload nginx && systemctl is-active nginx"

echo "== [$HOST] done."
echo "   next : ./deploy_frontend.sh $HOST          (ships 'final apps/' web root)"
echo "   then : open https://$HOST/  (self-signed cert warning is expected until certbot)"
echo "   OCI  : ensure VCN security list / NSG allows ingress TCP 80,443."
