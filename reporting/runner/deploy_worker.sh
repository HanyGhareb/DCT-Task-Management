#!/usr/bin/env bash
# =============================================================================
# i-Finance Reporting Platform — deploy a PYTHON-engine worker to a Linux VM
# as a permanent systemd service (rpt-worker.service, Restart=always).
#
# Run FROM a machine that has this repo + the Oracle wallet + SSH access:
#
#   export RPT_DB_PASSWORD='<ADMIN db password>'          # required
#   export SSHPASS='<root ssh password>'                  # or use key-based ssh
#   ./deploy_worker.sh 192.168.1.180 vm180
#
# Args : $1 = host/IP    $2 = worker display name (RPT_WORKER_NAME; default $1)
# Env  : RPT_DB_PASSWORD (required)  RPT_WALLET_PASSWORD (default = db password)
#        RPT_SMTP_PASSWORD (optional but needed for EMAIL delivery -- the SMTP
#          app password; without it the worker renders fine but every delivery
#          FAILS with gmail "530 5.7.0 Authentication Required")
#        WALLET_SRC (default /opt/oracle-wallet/Wallet_prod)  SSH_USER (default root)
#
# What it does on the target:
#   /opt/rpt-worker            <- runner code (this directory)
#   /opt/oracle-wallet/...     <- wallet copy
#   /etc/rpt-worker.env (600)  <- DB + wallet passwords
#   pip: oracledb jinja2 openpyxl playwright docxtpl python-pptx  + chromium (+deps)
#   systemd: rpt-worker.service enabled + started
# The worker then appears on the BI app Workers page as <name>/py<pid> and
# obeys PAUSE / RESUME / STOP from the UI.
# =============================================================================
set -euo pipefail

HOST="${1:?usage: deploy_worker.sh <host> [worker-name]}"
NAME="${2:-$HOST}"
SSH_USER="${SSH_USER:-root}"
RUNNER_DIR="$(cd "$(dirname "$0")" && pwd)"
WALLET_SRC="${WALLET_SRC:-/opt/oracle-wallet/Wallet_prod}"
: "${RPT_DB_PASSWORD:?export RPT_DB_PASSWORD first}"
RPT_WALLET_PASSWORD="${RPT_WALLET_PASSWORD:-$RPT_DB_PASSWORD}"

SSH_OPTS=(-o StrictHostKeyChecking=accept-new -o ConnectTimeout=8)
if [ -n "${SSHPASS:-}" ]; then
  SSH=(sshpass -e ssh "${SSH_OPTS[@]}" "$SSH_USER@$HOST")
  SCP=(sshpass -e scp "${SSH_OPTS[@]}" -r)
else
  SSH=(ssh "${SSH_OPTS[@]}" "$SSH_USER@$HOST")
  SCP=(scp "${SSH_OPTS[@]}" -r)
fi

echo "== [$HOST] preparing directories"
"${SSH[@]}" "mkdir -p /opt/rpt-worker /opt/oracle-wallet"

echo "== [$HOST] copying runner code + wallet"
"${SCP[@]}" "$RUNNER_DIR/." "$SSH_USER@$HOST:/opt/rpt-worker/"
"${SCP[@]}" "$WALLET_SRC" "$SSH_USER@$HOST:/opt/oracle-wallet/"
"${SSH[@]}" "rm -rf /opt/rpt-worker/__pycache__ /opt/rpt-worker/output"

echo "== [$HOST] installing python deps (this can take a few minutes)"
"${SSH[@]}" "python3 -m pip --version >/dev/null 2>&1 || dnf install -y -q python3-pip;
             python3 -m pip install --quiet oracledb jinja2 openpyxl playwright docxtpl python-pptx &&
             python3 -m playwright install chromium >/dev/null"

# Word (.docx) templates: docxtpl renders, headless LibreOffice converts to PDF.
# Arabic reports need an Arabic font or the PDF shows boxes (Noto Sans Arabic).
echo "== [$HOST] installing LibreOffice + fonts (Word template -> PDF path)"
"${SSH[@]}" "rpm -q libreoffice-writer >/dev/null 2>&1 ||
               dnf install -y -q libreoffice-writer;
             rpm -qa | grep -qi 'noto.*arabic' ||
               dnf install -y -q google-noto-sans-arabic-vf-fonts ||
               dnf install -y -q google-noto-sans-arabic-fonts || true;
             rpm -q liberation-fonts >/dev/null 2>&1 ||
               dnf install -y -q liberation-fonts || true"

# playwright install --with-deps assumes apt; on RHEL/OL resolve the browser's
# missing shared libraries as dnf soname capabilities instead
echo "== [$HOST] resolving chromium system libraries"
"${SSH[@]}" "cat > /tmp/rpt_chromium_deps.sh" <<'EOS'
#!/bin/bash
set -e
CH=$(find /root/.cache/ms-playwright -type f \( -name chrome -o -name headless_shell \) | head -1)
[ -n "$CH" ] || { echo "chromium binary not found"; exit 1; }
MISS=$(ldd "$CH" 2>/dev/null | awk '/not found/{print $1}' | sort -u)
if [ -n "$MISS" ]; then
  CAPS=()
  for l in $MISS; do CAPS+=("$l()(64bit)"); done
  dnf install -y -q "${CAPS[@]}"
fi
echo "unresolved libs: $(ldd "$CH" | grep -c 'not found' || true)"
EOS
"${SSH[@]}" "bash /tmp/rpt_chromium_deps.sh && rm -f /tmp/rpt_chromium_deps.sh"

echo "== [$HOST] writing /etc/rpt-worker.env + systemd unit"
"${SSH[@]}" "umask 177 && cat > /etc/rpt-worker.env" <<EOF
RPT_DB_PASSWORD=$RPT_DB_PASSWORD
RPT_WALLET_PASSWORD=$RPT_WALLET_PASSWORD
RPT_SMTP_PASSWORD=${RPT_SMTP_PASSWORD:-}
EOF
"${SSH[@]}" "cat > /etc/systemd/system/rpt-worker.service" <<EOF
[Unit]
Description=i-Finance Reporting worker (PYTHON engine) — $NAME
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=/opt/rpt-worker
Environment=TNS_ADMIN=/opt/oracle-wallet/Wallet_prod
Environment=RPT_DB_USER=ADMIN
Environment=RPT_DB_DSN=prod_low
Environment=RPT_WORKER_NAME=$NAME
Environment=PYTHONUNBUFFERED=1
EnvironmentFile=/etc/rpt-worker.env
ExecStart=/usr/bin/python3 /opt/rpt-worker/runner.py --forever
Restart=always
RestartSec=15

[Install]
WantedBy=multi-user.target
EOF

echo "== [$HOST] starting rpt-worker.service"
"${SSH[@]}" "systemctl daemon-reload && systemctl enable --now rpt-worker && sleep 8 &&
             systemctl is-active rpt-worker && journalctl -u rpt-worker -n 5 --no-pager"

echo "== [$HOST] done — worker '$NAME' should now show ONLINE on the BI Workers page"
