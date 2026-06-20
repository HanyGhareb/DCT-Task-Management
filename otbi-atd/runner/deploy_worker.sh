#!/bin/bash
# otbi-atd : deploy / refresh ONE parallel-worker VM (Plan 2). Reusable for scale-out.
#   ./deploy_worker.sh <ip>
# Source locations are overridable via env vars (defaults suit the Windows control box):
#   ATD_KEY      ssh private key   (default /c/tmp/atd-provision/keys/atd_id_ed25519)
#   ATD_SRC      runner source dir (default: this script's own dir)
#   ATD_WALLET   ADB thin wallet   (default /c/otbi-atd-state/wallet  -> needs ewallet.pem+tnsnames.ora)
#   ATD_ENVFILE  env.sh w/ secrets (default /c/tmp/atd-provision/env.sh ; identical on every VM)
# Installs software (idempotent), syncs runner+wallet+env, installs+enables the systemd
# service. First service start sends ONE Telegram MFA number to approve (seeds the session).
set -euo pipefail
IP="${1:?usage: deploy_worker.sh <ip>}"
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
KEY="${ATD_KEY:-/c/tmp/atd-provision/keys/atd_id_ed25519}"
SRC="${ATD_SRC:-$SELF_DIR}"
WALLET="${ATD_WALLET:-/c/otbi-atd-state/wallet}"
ENVFILE="${ATD_ENVFILE:-/c/tmp/atd-provision/env.sh}"
O="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
SSH="ssh -i $KEY $O"; SCP="scp -i $KEY $O"

echo "[deploy $IP] software (idempotent)…"
if ! $SSH root@$IP '~/otbi-atd/venv/bin/python -c "import playwright,oracledb,httpx"' >/dev/null 2>&1; then
  $SCP "$SRC/install_sw.sh" root@$IP:/root/install_sw.sh
  $SSH root@$IP 'sed -i "s/\r$//" /root/install_sw.sh; bash /root/install_sw.sh; tail -1 ~/sw_install.log'
fi

echo "[deploy $IP] runner code + wallet + env…"
$SSH root@$IP 'mkdir -p ~/otbi-atd/runner ~/otbi-atd-state ~/wallet'
$SCP -r "$SRC/." root@$IP:/root/otbi-atd/runner/
$SCP -r "$WALLET/." root@$IP:/root/wallet/
$SCP "$ENVFILE" root@$IP:/root/otbi-atd/env.sh
$SSH root@$IP 'chmod 600 ~/otbi-atd/env.sh; sed -i "s/\r$//" ~/otbi-atd/env.sh'

echo "[deploy $IP] systemd service…"
$SCP "$SRC/systemd/atd-worker.service" root@$IP:/etc/systemd/system/atd-worker.service
$SSH root@$IP 'sed -i "s/\r$//" /etc/systemd/system/atd-worker.service; systemctl daemon-reload; systemctl enable atd-worker'

echo "[deploy $IP] DONE."
echo "  start: ssh root@$IP systemctl start atd-worker   (first start -> approve one Telegram MFA number)"
