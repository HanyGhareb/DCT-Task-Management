#!/usr/bin/env python3
"""GL browser smoke — MSS - Projects Budget Utilization menu entry (v1.122.0).

Verifies the Budget Utilization page's Generate Report dropdown carries the
new "MSS - Projects Budget Utilization (XLSX)" entry (EN + AR), and that
clicking it enqueues a run (busy state + "The Binder" popup with the rgGenMss
label). The full render/download/layout path is covered by
mss_register_api_smoke.py.

Run: python mss_register_browser_smoke.py                    (webtier default)
     GL_BASE=http://localhost:8213 python mss_register_browser_smoke.py
"""
import json
import os
import re
import ssl
import urllib.request

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189/GL/Jet')
ORDS = os.environ.get('GL_ORDS', 'https://129.151.159.189/ords/admin')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'

_ctx = ssl.create_default_context()
_ctx.check_hostname = False
_ctx.verify_mode = ssl.CERT_NONE

u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
r = urllib.request.Request(ORDS + '/dct/auth/login',
                           data=json.dumps({'username': u, 'password': p}).encode(),
                           method='POST', headers={'Content-Type': 'application/json'})
s = json.loads(urllib.request.urlopen(r, timeout=60, context=_ctx).read())
sess = {'sessionId': s['sessionId'], 'userId': s.get('userId', 1),
        'username': s.get('username', u), 'displayName': 'System Administrator',
        'rolesCsv': 'SYS_ADMIN', 'roles': ['SYS_ADMIN']}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


VM = "ko.dataFor(document.body)"

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ");"
        "localStorage.setItem('gl_lang','en');")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')", timeout=60000)
    page.wait_for_timeout(1500)
    check('no JS errors on load', not errors, '; '.join(errors[:2]))

    # the app lands on Budget Utilization; open the Generate Report dropdown
    page.wait_for_function("() => document.querySelector('#pg-butil .gen-btn')", timeout=60000)
    page.wait_for_function("() => window.ko && ko.dataFor(document.body)"
                           " && typeof ko.dataFor(document.body).toggleGen === 'function'",
                           timeout=60000)
    page.evaluate("%s.toggleGen()" % VM)
    page.wait_for_timeout(300)
    items = page.locator('#pg-butil .gen-menu .gen-item')
    check('dropdown has 6 entries', items.count() == 6, items.count())
    txt = page.locator('#pg-butil .gen-menu').inner_text()
    check('MSS entry (EN)', 'MSS - Projects Budget Utilization (XLSX)' in txt)
    mss = page.locator('#pg-butil .gen-menu .gen-item',
                       has_text='MSS - Projects Budget Utilization')
    check('entry sits after the FBP entry',
          'MSS - Projects Budget Utilization' in items.nth(4).inner_text())
    check('fixed-layout subtitle (EN)', 'Requester' in mss.inner_text())
    hint = mss.get_attribute('title') or ''
    check('hint = fixed layout + Requester + Task Name',
          'FIXED' in hint and 'Requester' in hint and 'Task Name' in hint
          and 'Manage Columns' in hint)

    # click = enqueue: busy state + Binder popup with the rgGenMss label
    # (wait for the filters LOV to land first — runBuMss guards on buYear())
    page.wait_for_function("() => ko.dataFor(document.body).buYear()", timeout=60000)
    mss.evaluate('el => el.click()')
    page.wait_for_function("() => ko.dataFor(document.body).buMssBusy()", timeout=20000)
    check('buMssBusy set', True)
    check('gen button shows busy label',
          'Generating' in page.locator('#pg-butil .gen-btn').first.inner_text())
    page.wait_for_function("() => ko.dataFor(document.body).rgShow()", timeout=10000)
    check('Binder popup label',
          'MSS - Projects Budget Utilization' in page.evaluate("%s.rgLabel()" % VM))
    check('no JS errors after enqueue', not errors, '; '.join(errors[:2]))

    # Arabic labels (language persists to localStorage only in GL)
    page.evaluate("%s.toggleLang()" % VM)
    page.wait_for_timeout(800)
    page.evaluate("%s.genOpen(true)" % VM)
    page.wait_for_timeout(300)
    txt_ar = page.locator('#pg-butil .gen-menu').inner_text()
    check('AR entry label', 'MSS - استغلال ميزانية المشاريع (XLSX)' in txt_ar)
    check('RTL active', page.evaluate("document.documentElement.getAttribute('dir')") == 'rtl')
    page.evaluate("%s.toggleLang()" % VM)
    page.wait_for_timeout(500)

    b.close()

fails = [n for n, okk in results if not okk]
print('\n%d/%d passed' % (len(results) - len(fails), len(results)))
raise SystemExit(1 if fails else 0)
