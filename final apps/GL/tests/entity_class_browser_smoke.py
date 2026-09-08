#!/usr/bin/env python3
"""Browser smoke for the data-driven ENTITY classification UI (GL v1.114.0).

Chart of Accounts: Entity dimension in Classification values (Default chip,
Default select in the value editor), the assignments drawer with the GL-segment
column + rule hint + per-row segment picker feeding the datalist, Manage CoA
Mapping's segment picker, the Combinations explorer's Entity filter + column;
Budget Status entity toggle + Financial Performance entity names from the
classification; Arabic labels. Read-only (nothing is saved).

Run: python dev-proxy.py 8212 (from GL/Jet) then python entity_class_browser_smoke.py
     GL_BASE=https://129.151.159.189/GL/Jet python entity_class_browser_smoke.py   (webtier)
"""
import json, os, re, sys, urllib.request
from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8212')
ORDS = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
r = urllib.request.Request(ORDS + "/dct/auth/login", data=json.dumps({"username": u, "password": p}).encode(), method="POST", headers={"Content-Type": "application/json"})
s = json.loads(urllib.request.urlopen(r, timeout=60).read())
sess = {'sessionId': s['sessionId'], 'userId': s.get('userId', 1), 'username': s.get('username', u), 'displayName': 'System Administrator', 'rolesCsv': 'SYS_ADMIN', 'roles': ['SYS_ADMIN']}
results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond))); print(('PASS' if cond else 'FAIL'), name, extra)


VM = "ko.dataFor(document.body)"
with sync_playwright() as pw:
    b = pw.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1000}, ignore_https_errors=True)
    ctx.add_init_script("localStorage.setItem('ifinance_jet_session'," + json.dumps(json.dumps(sess)) + ");localStorage.setItem('gl_lang','en');")
    page = ctx.new_page(); errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')", timeout=60000); page.wait_for_timeout(1200)
    page.evaluate(VM + ".go('overview')"); page.wait_for_timeout(2500)
    check('10 GL segments loaded at boot', page.evaluate(VM + ".segments().length") == 10)
    check('Entity is a dimension', page.evaluate("(function(){return %s.dimensions().map(function(d){return d.code})})()" % VM).count('ENTITY') == 1)

    # --- Classification values: Entity
    page.evaluate(VM + ".coaTab('cls')"); page.wait_for_timeout(300)
    page.locator('#pg-overview select.inp').first.select_option('ENTITY'); page.wait_for_timeout(1500)
    rows = page.locator('tr[data-bind*="openClsDrill"]')
    codes = [rows.nth(i).locator('td').first.inner_text().strip().split()[0] for i in range(rows.count())]
    check('Entity values listed (DCT / MUSEUMS / ALC / MASTERPIECES)', set(['DCT', 'MUSEUMS', 'ALC', 'MASTERPIECES']) <= set(codes), codes)
    check('DCT carries the Default chip', 'default' in rows.filter(has_text='DCT').first.locator('td').first.inner_text().lower())
    rows.filter(has_text='MASTERPIECES').first.locator('button', has_text='Edit').click(); page.wait_for_timeout(400)
    check('value editor shows the Default select for Entity', page.locator('.ov:visible select[data-bind*="vDefault"]').is_visible() and page.evaluate(VM + ".vDefault()") == 'N')
    page.evaluate(VM + ".closeValue()"); page.wait_for_timeout(200)
    rows.filter(has_text='DCT').first.locator('button', has_text='Edit').click(); page.wait_for_timeout(300)
    check('DCT editor: Default = Yes', page.evaluate(VM + ".vDefault()") == 'Y')
    page.evaluate(VM + ".closeValue()"); page.wait_for_timeout(200)

    # --- assignments drawer: segment column + hint + picker
    rows.filter(has_text='MASTERPIECES').first.click()
    page.wait_for_function("() => ko.dataFor(document.body).clsDrawer() && !ko.dataFor(document.body).clsDrillLoading()", timeout=60000); page.wait_for_timeout(500)
    check('drawer shows the Entity rule hint', page.locator('.cls-ent-hint').is_visible() and 'ONE rule' in page.locator('.cls-ent-hint').inner_text())
    check('existing rule shows its GL segment (Appropriation 301439)', page.locator('.clsdw-tbl tbody tr').first.locator('td.cls-segkey').inner_text().strip() == 'Appropriation'
          and '301439' in page.locator('.clsdw-tbl tbody tr').first.inner_text())
    page.evaluate(VM + ".clsAddRow()"); page.wait_for_timeout(300)
    sel = page.locator('.clsdw-tbl tbody tr').last.locator('td.cls-segkey select')
    check('new rule row: GL-segment picker with the 10 segments', sel.count() == 1 and sel.locator('option').count() == 10)
    sel.select_option('COST_CENTER'); page.wait_for_timeout(1500)
    n_opts = page.evaluate(VM + ".clsSegOptions().length")
    check('picking Cost Centre reloads the value list for that segment', n_opts > 50 and page.evaluate("(function(){return %s.clsSegOptions()[0].segmentValue.length})()" % VM) == 7, n_opts)
    sel.select_option('ACCOUNT'); page.wait_for_timeout(1500)
    check('picking Account reloads again (6-digit codes)', page.evaluate("(function(){return %s.clsSegOptions()[0].segmentValue.length})()" % VM) == 6)
    page.evaluate("var v=%s; v.clsRows.remove(v.clsRows()[v.clsRows().length-1]); v.closeClsDrill();" % VM); page.wait_for_timeout(300)

    # --- Manage CoA Mapping: segment picker for Entity
    page.evaluate(VM + ".coaTab('map')"); page.wait_for_timeout(300)
    page.evaluate(VM + ".mapType('ENTITY')"); page.wait_for_timeout(1200)
    segsel = page.locator('select[data-bind*="mapSegKey"]')
    check('Manage CoA Mapping shows the segment picker for Entity (default Entity Specific)', segsel.is_visible() and page.evaluate(VM + ".mapSegKey()") == 'ENTITY_SPECIFIC')
    page.evaluate(VM + ".mapSegKey('APPROPRIATION')"); page.wait_for_timeout(1500)
    check('segment values follow the picked segment (appropriations)', page.evaluate("(function(){var o=%s.segOptions();return o.length>10&&o.some(function(x){return x.segmentValue==='301439'})})()" % VM))
    page.evaluate(VM + ".mapType('SECTOR')"); page.wait_for_timeout(600)
    check('picker hidden again for Sector', not segsel.is_visible())

    # --- Combinations explorer: entity filter + column
    page.evaluate(VM + ".coaTab('exp')"); page.wait_for_timeout(300)
    page.evaluate(VM + ".fEntity('MASTERPIECES')"); page.wait_for_timeout(2500)
    check('explorer Entity filter (Masterpieces) narrows the list', page.evaluate(VM + ".comboTotal()") in (4, 5) and page.evaluate("(function(){return %s.combos().every(function(c){return c.entityClassCode==='MASTERPIECES'})})()" % VM), page.evaluate(VM + ".comboTotal()"))
    check('explorer Entity column shows the chip', 'masterpieces' in page.locator('#pg-overview table.tbl:visible tbody tr').first.inner_text().lower())
    page.evaluate(VM + ".fEntity('DCT')"); page.wait_for_timeout(2500)
    check('DCT rows are marked as the default', page.evaluate("(function(){return %s.combos()[0].entityClassSource})()" % VM) == 'DEFAULT' and '· default' in page.locator('#pg-overview table.tbl:visible tbody tr').first.inner_text())
    page.evaluate(VM + ".fEntity('')"); page.wait_for_timeout(500)

    # --- Budget Status + Financial Performance read the classification
    page.evaluate(VM + ".go('fd')"); page.wait_for_function("() => ko.dataFor(document.body).fdLoaded()", timeout=120000); page.wait_for_timeout(800)
    labs = [x.strip() for x in page.locator('#pg-fd .fd-seg button').all_inner_texts()]
    check('Budget Status entity toggle = All entities + the 4 classification values (MSS name from the value)', labs == ['All entities', 'DCT', 'MSS', 'ALC', 'Masterpieces'], labs)
    check('entities carry isDefault from the server', page.evaluate("(function(){return %s.fdEntities()[0].isDefault})()" % VM) == 'Y')
    page.evaluate(VM + ".go('fmr')"); page.wait_for_function("() => ko.dataFor(document.body).fmrLoaded && ko.dataFor(document.body).fmrLoaded()", timeout=120000); page.wait_for_timeout(800)
    check('Financial Performance still lists the 4 entities', page.evaluate("(function(){return %s.fmrEntities().map(function(e){return e.code})})()" % VM) == ['DCT', 'MUSEUMS', 'ALC', 'MASTERPIECES'])
    check('no JS errors', not errors, '; '.join(errors[:2]))

    # --- Arabic
    page.locator('button[data-bind*="toggleLang"]').first.click(); page.wait_for_timeout(800)
    page.evaluate(VM + ".go('fd')"); page.wait_for_timeout(800)
    labs = [x.strip() for x in page.locator('#pg-fd .fd-seg button').all_inner_texts()]
    check('Arabic entity names come from the classification (name_ar)', labs[0] == 'جميع الجهات' and 'دائرة الثقافة والسياحة' in labs, labs)
    page.evaluate(VM + ".go('overview')"); page.wait_for_timeout(600)
    check('Arabic segment names available', page.evaluate("(function(){var v=%s;return v.segNameOf('APPROPRIATION')})()" % VM) == 'الاعتماد')
    page.locator('button[data-bind*="toggleLang"]').first.click(); page.wait_for_timeout(400)
    b.close()

passed = sum(1 for _, ok in results if ok)
print(f"\n{passed}/{len(results)} passed")
sys.exit(0 if passed == len(results) else 1)
