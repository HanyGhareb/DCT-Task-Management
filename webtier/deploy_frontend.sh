#!/usr/bin/env bash
# =============================================================================
# i-Finance web tier - deploy the JET frontends to the nginx VM.
#
#   ./deploy_frontend.sh <host>
#
# Env : SSH_USER (default root; non-root gets sudo), SSHPASS (optional)
#
# Ships ONLY the runtime web root out of 'final apps/':
#   shared/  +  every <App>/Jet/  +  FL/Portal/
# (db/, docs/, UAT/, tests/, guides/, dev-proxy.py, *.md never leave the repo)
#
# Releases go to /var/www/ifinance-releases/<timestamp>; the live root is the
# symlink /var/www/ifinance/current (what nginx serves). Keeps last 5 releases.
# Rollback = point the symlink at the previous release dir.
#
# Remember: bump window.APP_VERSION in each changed app's Jet/index.html
# BEFORE deploying - it is the cache key for deployed browsers.
# =============================================================================
set -euo pipefail

HOST="${1:?usage: deploy_frontend.sh <host>}"
SSH_USER="${SSH_USER:-root}"
APPS_ROOT="$(cd "$(dirname "$0")/../final apps" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"
REL="/var/www/ifinance-releases/$STAMP"

SUDO=""
[ "$SSH_USER" != "root" ] && SUDO="sudo "

SSH_OPTS=(-o StrictHostKeyChecking=accept-new -o ConnectTimeout=8)
if [ -n "${SSHPASS:-}" ]; then
  SSH=(sshpass -e ssh "${SSH_OPTS[@]}" "$SSH_USER@$HOST")
else
  SSH=(ssh "${SSH_OPTS[@]}" "$SSH_USER@$HOST")
fi

cd "$APPS_ROOT"

ITEMS=(shared)
for d in */Jet; do [ -d "$d" ] && ITEMS+=("${d%/}"); done
[ -d FL/Portal ] && ITEMS+=(FL/Portal)

echo "== packaging: ${ITEMS[*]}"
tar czf - \
    --exclude='dev-proxy.py' \
    --exclude='__pycache__' \
    --exclude='*.md' \
    "${ITEMS[@]}" \
| "${SSH[@]}" "${SUDO}mkdir -p '$REL' &&
               ${SUDO}tar xzf - -C '$REL' &&
               command -v restorecon >/dev/null 2>&1 && ${SUDO}restorecon -R /var/www/ifinance-releases || true;
               ${SUDO}ln -sfn '$REL' /var/www/ifinance/current &&
               ls -dt /var/www/ifinance-releases/* | tail -n +6 | xargs -r ${SUDO}rm -rf"

echo "== deployed release $STAMP -> https://$HOST/"
echo "   rollback: ssh $SSH_USER@$HOST 'ls /var/www/ifinance-releases; ${SUDO}ln -sfn /var/www/ifinance-releases/<prev> /var/www/ifinance/current'"
