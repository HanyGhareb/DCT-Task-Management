#!/usr/bin/env python3
"""GL browser smoke — Terms and Key definitions Settings page (v1.118.0).

Verifies the capability-gated Settings tab, the register (seeded document),
the drawer with the Quill rich-text editor, a full create -> edit -> delete
lifecycle on a throwaway document, and the AR/RTL labels. The report side
(terms printed as Part 1 of the Sector Performance Report) is covered by
terms_api_smoke.py RUN_REPORT=1.

Run: python terms_browser_smoke.py                     (webtier default)
     GL_BASE=http://localhost:8212 python terms_browser_smoke.py
"""
import json
import os
import re
import ssl
import urllib.request

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189/GL/Jet')
ORDS = os.environ.get('GL_ORDS', 'https://129.151.159.189/ords/admin')
AUTH = os.path.join(os.path.dirname(__file__), '..', '..', 'Admin', 'Jet', 'js', 'services', 'authService.js')

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
    check('Quill UMD loaded (window.Quill)', page.evaluate("!!window.Quill"))

    # capability-gated Settings tab (caps land at boot for SYS_ADMIN)
    page.wait_for_function("() => %s.termsCaps().canManage === 'Y'" % VM, timeout=20000)
    page.evaluate("%s.goGroup('settings')" % VM)
    page.wait_for_timeout(600)
    tabs = page.evaluate("%s.activeGroupItems().map(function(i){return i.id})" % VM)
    check('terms tab present in Settings group', 'terms' in tabs, tabs)

    # register: seeded document row
    page.evaluate("%s.go('terms')" % VM)
    page.wait_for_function("() => %s.tkLoaded()" % VM, timeout=30000)
    page.wait_for_timeout(400)
    body_txt = page.locator('#pg-terms').inner_text()
    check('register shows the seeded document', 'Terms and Key definitions' in body_txt)
    check('seeded row is Active', page.evaluate(
        "%s.tkRows().some(function(r){return r.appliedTo==='SECTOR_PERF' && r.status==='ACTIVE'})" % VM))
    check('applied-to shows lookup name', 'Sector Performance' in body_txt)

    # drawer on the seeded row: Quill editor with the seeded content
    page.evaluate("%s.tkOpen(%s.tkRows()[%s.tkRows().length-1])" % (VM, VM, VM))
    page.wait_for_function("() => %s.tkDrawer()" % VM, timeout=15000)
    page.wait_for_timeout(800)
    check('drawer open with Quill toolbar', page.locator('.dw-tk .ql-toolbar').count() == 1)
    ed_html = page.evaluate("document.querySelector('.dw-tk .ql-editor').innerHTML")
    check('editor holds the seeded rich text', 'YTD Budget' in ed_html and '<strong>' in ed_html)
    check('editor formatting toolbar has lists + color', page.evaluate(
        "!!document.querySelector('.dw-tk .ql-toolbar button.ql-list') && !!document.querySelector('.dw-tk .ql-toolbar .ql-color')"))
    page.evaluate("%s.tkDrawer(false)" % VM)
    page.wait_for_timeout(300)

    # full lifecycle on a throwaway document (never touches the seed)
    page.evaluate("%s.tkNew()" % VM)
    page.wait_for_function("() => %s.tkDrawer()" % VM, timeout=10000)
    page.wait_for_timeout(800)
    page.evaluate("""(function(){
      var vm = %s;
      vm.tkEdit().title('Browser smoke doc');
      vm.tkEdit().status('INACTIVE');
      // write through Quill's document model (the user path) -- raw innerHTML
      // bypasses the Delta that getSemanticHTML() serialises from
      var q = window.Quill.find(document.getElementById('tk-quill'));
      q.setContents(q.clipboard.convert({html:'<p><strong>Smoke:</strong> browser test entry.</p>'}), 'user');
      vm.tkSave();
    })()""" % VM)
    page.wait_for_function(
        "() => !%s.tkDrawer() && %s.tkRows().some(function(r){return r.title==='Browser smoke doc'})" % (VM, VM),
        timeout=20000)
    check('new document saved + listed', True)
    row = page.evaluate("%s.tkRows().filter(function(r){return r.title==='Browser smoke doc'})[0]" % VM)
    check('new document INACTIVE', row and row['status'] == 'INACTIVE', row)
    page.evaluate("%s.tkOpen(%s.tkRows().filter(function(r){return r.title==='Browser smoke doc'})[0])" % (VM, VM))
    page.wait_for_function("() => %s.tkDrawer()" % VM, timeout=15000)
    page.wait_for_timeout(800)
    ed_html = page.evaluate("document.querySelector('.dw-tk .ql-editor').innerHTML")
    check('saved rich text round-trips into the editor', 'Smoke:' in ed_html and '<strong>' in ed_html, ed_html[:100])
    page.on('dialog', lambda d: d.accept())
    page.evaluate("%s.tkDelete()" % VM)
    page.wait_for_function(
        "() => !%s.tkRows().some(function(r){return r.title==='Browser smoke doc'})" % VM, timeout=20000)
    check('throwaway document deleted', True)
    check('no JS errors after lifecycle', not errors, '; '.join(errors[:2]))

    # Arabic labels + RTL (GL persists language to localStorage only)
    page.evaluate("%s.toggleLang()" % VM)
    page.wait_for_timeout(800)
    check('AR nav label', page.evaluate(
        "%s.activeGroupItems().some(function(i){return i.id==='terms'}) && %s.t('navTerms')" % (VM, VM))
        == 'الشروط والتعريفات الرئيسية')
    check('RTL active', page.evaluate("document.documentElement.getAttribute('dir')") == 'rtl')
    check('AR page subtitle renders', 'مستندات' in page.locator('#pg-terms').inner_text())
    page.evaluate("%s.toggleLang()" % VM)
    page.wait_for_timeout(500)

    b.close()

fails = [n for n, okk in results if not okk]
print('\n%d/%d passed' % (len(results) - len(fails), len(results)))
raise SystemExit(1 if fails else 0)
