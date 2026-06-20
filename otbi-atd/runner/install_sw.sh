#!/bin/bash
# otbi-atd : runner software for one Oracle Linux 9 VM (Plan 2 Phase 1).
# Installs Python 3.11 + the python deps + Chromium and its RHEL runtime libraries
# (Playwright's --with-deps is Debian-only, so we install the libs via dnf), then
# runs a 5-second headless smoke test. Idempotent enough to re-run. Logs to ~/sw_install.log.
exec > "$HOME/sw_install.log" 2>&1
set -x
echo "===== START $(date) on $(hostname) ====="

# 1) python 3.11 + chromium runtime libraries
dnf install -y python3.11 python3.11-pip \
  nss nss-util atk at-spi2-atk at-spi2-core cups-libs libdrm libXcomposite libXdamage \
  libXrandr libXScrnSaver libxkbcommon mesa-libgbm pango cairo alsa-lib gtk3 \
  libX11 libXext libXfixes libXi libXtst
echo "DNF_RC=$?"

# 2) venv + python deps  (PyPI distribution is "oracledb", NOT "python-oracledb")
mkdir -p "$HOME/otbi-atd" "$HOME/otbi-atd-state"
python3.11 -m venv "$HOME/otbi-atd/venv"
"$HOME/otbi-atd/venv/bin/pip" install --upgrade pip
"$HOME/otbi-atd/venv/bin/pip" install playwright httpx oracledb
echo "PIP_RC=$?"

# 3) chromium browser (no --with-deps; libs installed above)
"$HOME/otbi-atd/venv/bin/playwright" install chromium
echo "PWINSTALL_RC=$?"

# 4) headless smoke test
"$HOME/otbi-atd/venv/bin/python" - <<'PY'
from playwright.sync_api import sync_playwright
try:
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True)
        pg = b.new_page(); pg.goto("about:blank")
        print("CHROMIUM_SMOKE_OK")
        b.close()
except Exception as e:
    print("CHROMIUM_SMOKE_FAIL:", e)
PY

echo "===== DONE $(date) ====="
