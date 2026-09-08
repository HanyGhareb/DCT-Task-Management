#!/usr/bin/env python3
"""GL browser smoke — Sector Performance Report menu entry (v1.115.0).

Verifies the Budget Utilization page's Generate Report dropdown carries the
new "Sector Performance Report (PDF)" entry (EN + AR), and that clicking it
enqueues a run (busy state + "The Binder" popup with the rgGenSpb label).
The full render/download path is covered by sector_book_api_smoke.py.

Run: python sector_book_browser_smoke.py                     (webtier default)
     GL_BASE=http://localhost:8212 python sector_book_browser_smoke.py
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
    page.evaluate("%s.toggleGen()" % VM)
    page.wait_for_timeout(300)
    items = page.locator('#pg-butil .gen-menu .gen-item')
    check('dropdown has 4 entries', items.count() == 4, items.count())
    txt = page.locator('#pg-butil .gen-menu').inner_text()
    check('Sector Performance Report entry (EN)', 'Sector Performance Report (PDF)' in txt)
    spb = page.locator('#pg-butil .gen-menu .gen-item', has_text='Sector Performance Report')
    check('entry sits after Briefing Book',
          items.nth(1).inner_text().startswith('📘') or 'Sector Performance' in items.nth(1).inner_text())

    # one-sector rule (user, 2026-09-06): disabled + hint until a sector is picked
    check('entry DISABLED without a sector', spb.is_disabled())
    check('need-sector hint shown', 'one sector' in (spb.get_attribute('title') or ''))
    page.evaluate("%s.buSector(%s.buSectors()[0])" % (VM, VM))
    page.wait_for_timeout(300)
    check('entry ENABLED once a sector is picked', not spb.is_disabled(),
          page.evaluate("%s.buSector()" % VM))
    check('distribution subtitle (EN) once enabled',
          'Distribution copy with DCT branding' in spb.inner_text())
    check('hint mentions logo + copyright',
          'logo' in (spb.get_attribute('title') or '') and 'copyright' in (spb.get_attribute('title') or ''))

    # click = enqueue: busy state + Binder popup with the rgGenSpb label
    spb.evaluate('el => el.click()')
    page.wait_for_function("() => ko.dataFor(document.body).buSpbBusy()", timeout=20000)
    check('buSpbBusy set', True)
    check('gen button shows busy label',
          'Generating' in page.locator('#pg-butil .gen-btn').first.inner_text())
    page.wait_for_function("() => ko.dataFor(document.body).rgShow()", timeout=10000)
    check('Binder popup label', 'Sector Performance Report' in page.evaluate("%s.rgLabel()" % VM))
    check('no JS errors after enqueue', not errors, '; '.join(errors[:2]))

    # Arabic labels (language persists to localStorage only in GL)
    page.evaluate("%s.toggleLang()" % VM)
    page.wait_for_timeout(800)
    page.evaluate("%s.genOpen(true)" % VM)
    page.wait_for_timeout(300)
    txt_ar = page.locator('#pg-butil .gen-menu').inner_text()
    check('AR entry label', 'تقرير أداء القطاعات (PDF)' in txt_ar)
    check('RTL active', page.evaluate("document.documentElement.getAttribute('dir')") == 'rtl')
    page.evaluate("%s.toggleLang()" % VM)
    page.wait_for_timeout(500)

    b.close()

fails = [n for n, okk in results if not okk]
print('\n%d/%d passed' % (len(results) - len(fails), len(results)))
raise SystemExit(1 if fails else 0)
