#!/usr/bin/env python3
"""ATD (App 208) — Worker Fleet round browser smoke (EN + AR/RTL).

Covers: the region-header ↻ Refresh button, the Account column, the offline
banner absence on a healthy fleet, Pause → Resume on one worker (buttons swap,
PAUSED pill), the VM-name drill into Run Logs (VM select pre-set, host column
scoped, Clear resets), the Run Logs VM filter dropdown, and the AR/RTL pass.

Mints its own session with the quick-login credentials. Runs against the live
webtier by default (ATD_BASE to override).

  python3 fleet_browser_smoke.py
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
EV = os.environ.get('ATD_EVIDENCE', '/tmp/fleet_evidence/')
os.makedirs(EV, exist_ok=True)

src = open(os.path.join(APPS, "Admin", "Jet", "js", "services", "authService.js"),
           encoding="utf-8").read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)
req = urllib.request.Request(
    ADB + "/ords/admin/dct/auth/login",
    data=json.dumps({"username": USER, "password": PWD}).encode(),
    headers={"Content-Type": "application/json"}, method="POST")
login = json.loads(urllib.request.urlopen(req, timeout=60).read())
sess = {
    'sessionId': login.get('sessionId') or login.get('token'),
    'userId': login.get('userId', 1),
    'username': login.get('username', USER),
    'displayName': login.get('displayName', 'System Administrator'),
    'rolesCsv': 'SYS_ADMIN', 'roles': ['SYS_ADMIN'],
}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1700, 'height': 1000},
                        ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))

    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_timeout(4000)

    # 1 — fleet region + header refresh button
    fleet = page.locator('.card', has=page.locator('.section-heading',
                                                   has_text='Worker Fleet')).first
    check('Worker Fleet region present', fleet.count() == 1)
    reload_btn = fleet.locator('.region-actions button')
    check('region-header Refresh button present', reload_btn.count() == 1)
    check('refresh button carries the ↻ icon', '↻' in reload_btn.inner_text())

    # 2 — table columns incl. the new Account column
    # header cells are CSS-uppercased and Chrome's innerText applies the
    # transform — compare lower-case (established platform test gotcha)
    heads = [h.strip().lower() for h in fleet.locator('thead th').all_inner_texts()]
    check('Account column present', any('account' in h for h in heads), '|'.join(heads))
    check('Actions column present', any('actions' in h for h in heads))
    # every column carries a ⓘ hint (title attribute) — v1.43.0
    ths = fleet.locator('thead th')
    titled = sum(1 for i in range(ths.count())
                 if (ths.nth(i).get_attribute('title') or '').strip())
    check('every column has a hint', titled == ths.count(),
          f'{titled}/{ths.count()}')
    rows = fleet.locator('tbody tr')
    check('fleet rows rendered', rows.count() >= 3, str(rows.count()))
    acct = rows.first.locator('td').nth(3).inner_text()
    check('Account value populated', '@' in acct, acct)

    # 3 — healthy fleet: no offline banner
    check('no offline banner on a healthy fleet',
          page.locator('text=Worker offline').count() == 0)

    # 4 — header refresh keeps the table
    reload_btn.click()
    page.wait_for_timeout(2500)
    check('table intact after refresh', fleet.locator('tbody tr').count() >= 3)
    page.screenshot(path=EV + '01_fleet.png', full_page=True)

    # 5 — Pause → PAUSED pill + Resume swap → Resume restores
    target = 'atd-vm182'
    row = fleet.locator('tbody tr', has_text=target).first
    row.locator('button', has_text='Pause').click()
    page.wait_for_timeout(2500)
    row = fleet.locator('tbody tr', has_text=target).first
    check('Resume button appears after Pause', row.locator('button', has_text='Resume').count() == 1)
    check('PAUSED pill shown', 'PAUSED' in row.inner_text())
    page.screenshot(path=EV + '02_paused.png', full_page=True)
    row.locator('button', has_text='Resume').click()
    page.wait_for_timeout(2500)
    row = fleet.locator('tbody tr', has_text=target).first
    check('Pause button back after Resume', row.locator('button', has_text='Pause').count() == 1)
    check('PAUSED pill gone', 'PAUSED' not in row.inner_text())

    # 6 — VM-name drill into Run Logs
    vm = 'atd-vm180'
    fleet.locator('tbody tr', has_text=vm).first.locator('.wk-link').click()
    page.wait_for_timeout(3500)
    check('landed on Run Logs', page.locator('.page-title', has_text='Run Logs').count() == 1)
    vm_sel = page.locator('.view-toolbar select').nth(3)
    check('VM select pre-set to the drilled VM',
          vm_sel.input_value() == vm, vm_sel.input_value())
    hosts = page.locator('table.data-table').last.locator(
        'tbody tr td:nth-child(4)').all_inner_texts()
    hosts = [h.strip() for h in hosts if h.strip()]
    check('run rows scoped to the VM', hosts and all(h == vm for h in hosts),
          f'{len(hosts)} rows')
    page.screenshot(path=EV + '03_drill.png', full_page=True)

    # 7 — Clear resets the VM filter
    page.locator('button', has_text='Clear').first.click()
    page.wait_for_timeout(2500)
    check('Clear resets the VM filter', vm_sel.input_value() == '')
    opts = page.locator('.view-toolbar select').nth(3).locator('option').all_inner_texts()
    check('VM dropdown lists the fleet', sum(1 for o in opts if o.startswith('atd-vm')) >= 3,
          '|'.join(opts))

    # 8 — AR / RTL.  The shell PERSISTS the language to the user's server-side
    # prefs, so this MUST restore EN before exiting or it silently flips the
    # account's UI for good.
    try:
        page.locator('button:text-is("ع")').last.click()
        page.wait_for_timeout(3000)
        check('RTL applied', page.locator('html[dir="rtl"]').count() == 1)
        page.locator('a', has_text='لوحة').first.click()   # Dashboard nav item
        page.wait_for_timeout(3000)
        ar_fleet = page.locator('.section-heading', has_text='أسطول')
        check('fleet heading translated to AR', ar_fleet.count() >= 1)
        ar_btns = page.locator('.card', has=ar_fleet.first).locator('tbody button').all_inner_texts()
        check('AR Pause button', any('إيقاف' in t for t in ar_btns), '|'.join(ar_btns[:4]))
        page.screenshot(path=EV + '04_ar_rtl.png', full_page=True)
    finally:
        page.locator('button:text-is("EN")').last.click()
        page.wait_for_timeout(2500)
        check('EN restored (must not leave the account in AR)',
              page.locator('html[dir="rtl"]').count() == 0)

    check('no JS errors overall', not errors, '; '.join(errors[:3]))
    b.close()

ok = sum(1 for _n, c in results if c)
print('\n%d/%d passed' % (ok, len(results)))
print('evidence:', EV)
sys.exit(0 if ok == len(results) else 1)
