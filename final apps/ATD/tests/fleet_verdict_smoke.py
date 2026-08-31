#!/usr/bin/env python3
"""Worker Fleet #2 — inline Check-session verdict smoke (v1.42.0).

Clicks Check session on one VM and asserts the row's inline badge appears
("Checking…" pulse) and resolves to a green terminal verdict ("Session OK —
no MFA was needed") once the worker answers on its next idle beat.
Non-destructive: a session check never forces MFA on a healthy session.

  python3 fleet_verdict_smoke.py
"""
import json
import os
import re
import sys
import urllib.request

from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
APPS = os.path.abspath(os.path.join(HERE, "..", ".."))
BASE = os.environ.get('ATD_BASE', 'https://129.151.159.189/ATD/Jet')
ADB = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com"
EV = os.environ.get('ATD_EVIDENCE', '/tmp/fleet_verdict_evidence/')
os.makedirs(EV, exist_ok=True)

src = open(os.path.join(APPS, "Admin", "Jet", "js", "services", "authService.js"),
           encoding="utf-8").read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
req = urllib.request.Request(
    ADB + "/ords/admin/dct/auth/login",
    data=json.dumps({"username": m.group(1), "password": m.group(2)}).encode(),
    headers={"Content-Type": "application/json"}, method="POST")
login = json.loads(urllib.request.urlopen(req, timeout=60).read())
sess = {'sessionId': login.get('sessionId'), 'userId': login.get('userId', 1),
        'username': login.get('username'), 'displayName': login.get('displayName', ''),
        'rolesCsv': 'SYS_ADMIN', 'roles': ['SYS_ADMIN']}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1700, 'height': 1000}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_timeout(4000)

    fleet = page.locator('.card', has=page.locator('.section-heading',
                                                   has_text='Worker Fleet')).first
    vm = 'atd-vm181'
    row = fleet.locator('tbody tr', has_text=vm).first
    check('fleet row present', row.count() == 1)
    check('no verdict badge before the click', row.locator('.wk-verdict').count() == 0)

    row.locator('button', has_text='Check session').click()
    page.wait_for_timeout(1200)
    row = fleet.locator('tbody tr', has_text=vm).first
    badge = row.locator('.wk-verdict')
    check('verdict badge appears on click', badge.count() == 1)
    check('badge opens amber (in progress)',
          'warn' in (badge.get_attribute('class') or ''), badge.inner_text())
    page.screenshot(path=EV + '01_checking.png', full_page=True)

    # the worker answers on its next idle beat (~15s) + the 3s poll: allow 90s
    final = ''
    for _ in range(30):
        page.wait_for_timeout(3000)
        badge = fleet.locator('tbody tr', has_text=vm).first.locator('.wk-verdict')
        if badge.count() and 'wk-verdict--ok' in (badge.get_attribute('class') or ''):
            final = badge.inner_text()
            break
    check('badge resolves GREEN', bool(final), final)
    check('verdict says no MFA was needed', 'no MFA' in final, final)
    page.screenshot(path=EV + '02_verdict_ok.png', full_page=True)

    check('no JS errors', not errors, '; '.join(errors[:3]))
    b.close()

ok = sum(1 for _n, c in results if c)
print('\n%d/%d passed' % (ok, len(results)))
print('evidence:', EV)
sys.exit(0 if ok == len(results) else 1)
