#!/usr/bin/env python3
"""GL vs-Budget column + Manage-columns drawer browser smoke (v1.96.0, EN+AR).

Butil page: the always-on vs Budget verdict column (hand + % of ANNUAL budget,
independent of the Show Plan LOV), the Manage-columns button on the Results
header opening the chooser drawer (checkbox show/hide, arrow reorder, named
views saved per level to /dct/prefs, default view, reset), the registry-driven
line + Department/Sector tables, and CSV/sheetcols following the active view.

Run: python dev-proxy.py 8214 (from GL/Jet) then python cols_vsbudget_browser_smoke.py
"""
import json
import os
import re
import ssl
import urllib.request

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8214')
API = os.environ.get('GL_API', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_cols_vsbudget_evidence/')
os.makedirs(EV, exist_ok=True)
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE


def login():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(API + '/ords/admin/dct/auth/login',
                               data=json.dumps({'username': u, 'password': p}).encode(),
                               method='POST', headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


def reset_pref(tok):
    rq = urllib.request.Request(API + '/ords/admin/dct/prefs/gl.butil.colviews',
                                data=json.dumps({'value': '{}'}).encode(), method='PUT',
                                headers={'Authorization': 'Bearer ' + tok,
                                         'Content-Type': 'application/json'})
    urllib.request.urlopen(rq, timeout=60, context=CTX).read()


TOK = login()
reset_pref(TOK)
sess = {'sessionId': TOK, 'userId': 1, 'username': 'ADMIN',
        'displayName': 'System Administrator', 'rolesCsv': 'SYS_ADMIN',
        'roles': ['SYS_ADMIN']}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


LINE_TBL = '#pg-butil .bu-results table:not(.bu-agg-tbl)'
AGG_TBL = '#pg-butil .bu-results table.bu-agg-tbl'


def line_headers(page):
    return [t.strip().lower() for t in page.locator(LINE_TBL + ' thead th').all_inner_texts()]


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1920, 'height': 1080}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ");"
        "localStorage.removeItem('gl_bu_colviews'); localStorage.setItem('gl_lang','en');")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                           timeout=60000)
    page.wait_for_function(
        "() => { const vm = window.ko && ko.dataFor(document.body); "
        "return !!vm && (vm.buTotals()||{}).planWithin !== undefined && vm.buItems().length > 0; }",
        timeout=120000)
    page.wait_for_timeout(600)

    # ── vs Budget column (always on, Annual basis) ──
    hs = line_headers(page)
    check('vs Budget header present', 'vs budget' in hs)
    check('vs Budget right after YTD Budget',
          'vs budget' in hs and hs.index('vs budget') == hs.index('ytd budget') + 1)
    check('verdict hands render in vs Budget cells',
          page.evaluate("() => ko.dataFor(document.body).buItems()"
                        ".every(r => !!r.budState)"))
    check('vs Budget cells show a % of annual budget',
          page.locator(LINE_TBL + ' .vp .mono').first.inner_text().endswith('%'))
    check('thresholds echoed to the page',
          page.evaluate("() => { const t = ko.dataFor(document.body).buBudThr(); "
                        "return t.near != null && t.over != null; }"))
    page.screenshot(path=EV + '01_vsbudget_en.png')

    # independent of the Show Plan LOV
    page.evaluate("() => ko.dataFor(document.body).buPlanMode('NO')")
    page.wait_for_timeout(400)
    hs = line_headers(page)
    check('Show Plan NO keeps vs Budget', 'vs budget' in hs and 'vs plan' not in hs)
    page.evaluate("() => ko.dataFor(document.body).buPlanMode('YES')")
    page.wait_for_timeout(400)

    # ── Manage-columns drawer ──
    page.click('.bu-colsbtn')
    page.wait_for_timeout(400)
    check('drawer opens', page.locator('.dw-cols.show').count() == 1)
    n_items = page.locator('.cols-row').count()
    check('drawer lists the full registry', n_items >= 28, n_items)
    check('vs Budget listed in the chooser',
          page.evaluate("() => ko.dataFor(document.body).colDrItems()"
                        ".some(i => i.k === 'vsBudget')"))

    # hide Organization + move vs Budget up two slots, apply
    page.evaluate("() => { const vm = ko.dataFor(document.body); "
                  "vm.colDrItems().filter(i => i.k === 'organization')[0].on(false); }")
    page.evaluate("() => { const vm = ko.dataFor(document.body); "
                  "const it = vm.colDrItems().filter(i => i.k === 'vsBudget')[0]; "
                  "vm.colMove(it, -1); vm.colMove(it, -1); }")
    page.screenshot(path=EV + '02_drawer_en.png')
    page.evaluate("() => ko.dataFor(document.body).colApply()")
    page.wait_for_timeout(500)
    hs = line_headers(page)
    check('hidden column leaves the table', 'organization' not in hs)
    check('reordered column moves in the header',
          'vs budget' in hs and hs.index('vs budget') == hs.index('annual budget') - 1)
    check('drawer closed on Apply', page.locator('.dw-cols.show').count() == 0)

    # sheetcols follows the view (drives the Excel Register sheet 1)
    sc = page.evaluate("() => ko.dataFor(document.body).buSheetCols()")
    check('sheetcols built from the view', bool(sc) and sc.startswith('budget_combination,'))
    check('sheetcols drops the hidden column', 'organization' not in (sc or ''))
    check('sheetcols keeps the verdict columns', 'budget_status' in (sc or ''))

    # CSV columns follow the view
    csvkeys = page.evaluate("() => { const vm = ko.dataFor(document.body); var out = []; "
                            "vm.buColsLine().forEach(c => (c.csv||[]).forEach(p => out.push(p[0]))); return out; }")
    check('CSV columns follow the view',
          'organization' not in csvkeys and 'budUtilPct' in csvkeys)

    # ── named views: save, default, reload persistence ──
    page.evaluate("() => { const vm = ko.dataFor(document.body); vm.openColDrawer(); "
                  "vm.colDrName('Smoke view'); vm.colSaveView(); vm.colSetDefault(); vm.closeColDrawer(); }")
    page.wait_for_timeout(800)
    page.goto(BASE + '/index.html')
    page.wait_for_function(
        "() => { const vm = window.ko && ko.dataFor(document.body); "
        "return !!vm && vm.buItems().length > 0; }", timeout=120000)
    page.wait_for_timeout(500)
    hs = line_headers(page)
    check('saved view survives a reload', 'organization' not in hs)
    check('saved view listed with default marker',
          page.evaluate("() => { const d = ko.dataFor(document.body).buColData(); "
                        "return (d.line.views||{})['Smoke view'] != null && d.line.def === 'Smoke view'; }"))

    # ── Department tab: own registry + vs Budget, chooser scoped per level ──
    page.evaluate("() => ko.dataFor(document.body).setBuLevel('dept')")
    page.wait_for_function("() => { const vm = ko.dataFor(document.body); "
                           "return !vm.buAggLoading() && vm.buAggItems().length > 0; }",
                           timeout=120000)
    page.wait_for_timeout(400)
    ah = [t.strip().lower() for t in page.locator(AGG_TBL + ' thead th').all_inner_texts()]
    check('dept tab shows vs Budget', 'vs budget' in ah)
    check('dept tab shows its own identity columns', 'cost center' in ah and 'department' in ah)
    page.evaluate("() => { const vm = ko.dataFor(document.body); vm.openColDrawer(); "
                  "vm.colDrItems().filter(i => i.k === 'procash')[0].on(false); vm.colApply(); }")
    page.wait_for_timeout(500)
    ah = [t.strip().lower() for t in page.locator(AGG_TBL + ' thead th').all_inner_texts()]
    check('dept view hides its column', 'procash' not in ah)
    page.evaluate("() => ko.dataFor(document.body).setBuLevel('line')")
    page.wait_for_timeout(400)
    hs = line_headers(page)
    check('line view untouched by the dept view', 'procash' in hs)
    page.screenshot(path=EV + '03_dept_tab.png')

    # ── reset to standard ──
    page.evaluate("() => { const vm = ko.dataFor(document.body); vm.openColDrawer(); "
                  "vm.colReset(); vm.colApply(); }")
    page.wait_for_timeout(500)
    hs = line_headers(page)
    check('reset restores the standard layout',
          'organization' in hs and hs.index('vs budget') == hs.index('ytd budget') + 1)

    # ── AR / RTL ──
    page.click('button[data-bind*="toggleLang"]')
    page.wait_for_timeout(900)
    hs_ar = line_headers(page)
    check('AR vs Budget header', any('مقابل الموازنة' in h for h in hs_ar))
    page.click('.bu-colsbtn')
    page.wait_for_timeout(400)
    body_ar = page.inner_text('.dw-cols')
    check('AR drawer title', 'إدارة الأعمدة' in body_ar)
    check('AR column labels', 'مقابل الموازنة' in body_ar)
    page.screenshot(path=EV + '04_drawer_ar.png')
    page.evaluate("() => ko.dataFor(document.body).closeColDrawer()")
    page.click('button[data-bind*="toggleLang"]')
    page.wait_for_timeout(600)

    check('no page errors', not errors, errors[:3])
    b.close()

reset_pref(TOK)

passed = sum(1 for _, okk in results if okk)
print('\n%d/%d passed' % (passed, len(results)))
raise SystemExit(0 if passed == len(results) else 1)
