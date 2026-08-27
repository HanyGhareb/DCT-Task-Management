#!/usr/bin/env python3
"""GL expenditure-plan balances browser smoke (EN + AR).

Butil page: Approved Plan Annual/YTD columns + Expenditure Plan KPI tile,
plan cell drill and KPI aggregate drill reconciling to the on-screen figures;
Portfolio register plan columns + tile; Project 360 plan tile. Revised pair
stays hidden while no revised plan exists.

Run: python dev-proxy.py 8213 (from GL/Jet) then GL_TOK=... python plan_browser_smoke.py
"""
import json
import os
import sys

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8213')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_plan_evidence/')
os.makedirs(EV, exist_ok=True)
TOK = os.environ.get('GL_TOK') or sys.exit('Set GL_TOK')
PROJECT = '4511000981'
sess = {'sessionId': TOK, 'userId': 1, 'username': 'ADMIN',
        'displayName': 'System Administrator', 'rolesCsv': 'SYS_ADMIN',
        'roles': ['SYS_ADMIN']}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1760, 'height': 1050}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                           timeout=60000)
    # let the initial default butil run finish BEFORE issuing ours, or the two
    # concurrent runs race and the late one overwrites totals mid-assert
    page.wait_for_function(
        "() => { const vm = window.ko && ko.dataFor(document.body); "
        "return !!vm && !vm.buLoading() && !vm.buBusy(); }",
        timeout=90000)

    page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      vm.buProjSel(['%s']); vm.buPeriod(''); vm.runButil(0);
    }""" % PROJECT)
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); "
        "return !vm.buBusy() && vm.buItems().length > 0 "
        "&& vm.buItems().every(r => r.projectNumber === '%s'); }" % PROJECT,
        timeout=60000)
    st = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const t = vm.buTotals() || {};
      const r = vm.buItems().filter(x => x.hasPlan === 'Y')[0] || null;
      return { planA: t.planApprovedAnnual, planY: t.planApprovedYtd,
               revOn: vm.buPlanRevOn(),
               row: r && { task: r.taskNumber, pa: r.planApprovedAnnual } }; }""")
    check('totals plan loaded', (st['planA'] or 0) > 0, st['planA'])
    check('full year: YTD == Annual', abs((st['planY'] or 0) - (st['planA'] or 0)) < 0.01)
    check('revised pair hidden (no revised data)', st['revOn'] is False)
    check('a row carries plan figures', bool(st['row']) and st['row']['pa'] > 0, str(st['row']))

    heads = page.evaluate(
        "() => Array.from(document.querySelectorAll('#pg-butil thead th')).map(x => x.innerText.trim().toLowerCase())")
    check('plan headers rendered (EN)', 'plan annual' in heads and 'plan ytd' in heads,
          heads[11:15])
    check('revised headers absent', not any('revised plan' in h for h in heads))
    tile = page.evaluate(
        "() => { const el = document.querySelector('#pg-butil .bk-plan'); return el ? el.innerText : ''; }")
    check('Expenditure Plan KPI tile', 'EXPENDITURE PLAN' in tile.upper(), tile[:40].replace('\n', ' '))
    page.screenshot(path=EV + '01_butil_plan_en.png')

    # plan cell drill (annual) reconciles to the cell
    page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const r = vm.buItems().filter(x => x.hasPlan === 'Y')[0];
      vm.openBuPlanDrill(r, 'APPROVED', true);
    }""")
    page.wait_for_function("() => !ko.dataFor(document.body).drillLoading()", timeout=60000)
    dr = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const r = vm.buItems().filter(x => x.hasPlan === 'Y')[0];
      return { n: vm.drillRows().length, tot: vm.drillTotalV(), cell: r.planApprovedAnnual,
               cols: vm.drillCols().map(c => c.key) }; }""")
    check('plan cell drill rows', dr['n'] > 0, dr['n'])
    check('plan drill columns', dr['cols'][:2] == ['period', 'amount'], dr['cols'])
    check('cell drill total == cell', abs(dr['tot'] - dr['cell']) < 0.01,
          '%s vs %s' % (dr['tot'], dr['cell']))
    page.screenshot(path=EV + '02_plan_cell_drill.png')
    page.evaluate("ko.dataFor(document.body).closeDrawer()")

    # KPI aggregate drill reconciles to the tile figure
    page.evaluate("() => ko.dataFor(document.body).openBuPlanAgg('APPROVED', false)")
    page.wait_for_function("() => !ko.dataFor(document.body).drillLoading()", timeout=60000)
    dr2 = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      return { tot: vm.drillTotalV(), cols: vm.drillCols().map(c => c.key) }; }""")
    check('aggregate drill total == KPI', abs(dr2['tot'] - st['planY']) < 0.01,
          '%s vs %s' % (dr2['tot'], st['planY']))
    check('aggregate cols carry identity', dr2['cols'][:3] == ['project', 'task', 'etype'])
    page.evaluate("ko.dataFor(document.body).closeDrawer()")

    # YTD period cut: 06-2026 YTD < Annual, cell drill still reconciles
    page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      vm.buPeriod('06-2026'); vm.runButil(0);
    }""")
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); "
        "return !vm.buBusy() && vm.buItems().length > 0 "
        "&& (vm.buTotals()||{}).planApprovedYtd < (vm.buTotals()||{}).planApprovedAnnual; }",
        timeout=60000)
    st2 = page.evaluate("""() => {
      const t = ko.dataFor(document.body).buTotals() || {};
      return { a: t.planApprovedAnnual, y: t.planApprovedYtd }; }""")
    check('YTD 06-2026 < Annual', 0 < st2['y'] < st2['a'], '%s < %s' % (st2['y'], st2['a']))

    # Portfolio: register columns + tile (shares the butil criteria)
    page.evaluate("() => ko.dataFor(document.body).go('portfolio')")
    page.wait_for_timeout(800)
    page.evaluate("() => { const vm = ko.dataFor(document.body); if (!vm.pfLoaded()) vm.runPortfolio(); }")
    page.wait_for_function("() => ko.dataFor(document.body).pfLoaded()", timeout=120000)
    pf = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const env = vm.pfIr() || {};
      const el = document.querySelector('#pg-portfolio .bk-plan');
      return { keys: (env.columns || []).map(c => c.key),
               planT: vm.pfT('planApprovedAnnual'), tile: el ? el.innerText : '' }; }""")
    check('portfolio IR plan columns', 'planA' in pf['keys'] and 'planY' in pf['keys'])
    check('portfolio revised columns absent', 'planRevA' not in pf['keys'])
    check('portfolio plan total > 0', (pf['planT'] or 0) > 0, pf['planT'])
    check('portfolio plan tile', 'EXPENDITURE PLAN' in pf['tile'].upper())
    page.screenshot(path=EV + '03_portfolio_plan.png')

    # Project 360 plan tile
    page.evaluate("() => ko.dataFor(document.body).openProj360('%s')" % PROJECT)
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); "
        "return vm.view() === 'proj360' && (vm.p3Year()||{}).planApprovedAnnual > 0; }",
        timeout=90000)
    p3 = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const el = document.querySelector('#pg-proj360 .bk-plan') || document.querySelector('.bk-plan');
      return { y: vm.p3Year().planApprovedYtd, a: vm.p3Year().planApprovedAnnual,
               tile: el ? el.innerText : '' }; }""")
    check('360 plan figures', (p3['a'] or 0) > 0, '%s / %s' % (p3['y'], p3['a']))
    check('360 plan tile rendered', 'EXPENDITURE PLAN' in p3['tile'].upper())
    page.screenshot(path=EV + '04_p360_plan.png')

    # Arabic / RTL — column headers + tile translate (GL keeps language in
    # localStorage only, so no server pref restore is needed)
    page.evaluate("() => ko.dataFor(document.body).go('butil')")
    page.wait_for_timeout(500)
    page.evaluate("() => { const vm = ko.dataFor(document.body); if (vm.lang() !== 'ar') vm.toggleLang(); }")
    page.wait_for_timeout(1200)
    ar = page.evaluate("""() => {
      const heads = Array.from(document.querySelectorAll('#pg-butil thead th')).map(x => x.innerText.trim());
      const el = document.querySelector('#pg-butil .bk-plan');
      return { rtl: document.documentElement.getAttribute('dir') === 'rtl',
               head: heads.some(h => h.indexOf('الخطة السنوية') >= 0),
               tile: el ? el.innerText : '' }; }""")
    check('AR: RTL applied', ar['rtl'])
    check('AR: plan headers translated', ar['head'])
    check('AR: plan tile translated', 'خطة الإنفاق' in ar['tile'])
    page.screenshot(path=EV + '05_butil_plan_ar.png')
    page.evaluate("() => { const vm = ko.dataFor(document.body); if (vm.lang() !== 'en') vm.toggleLang(); }")
    page.wait_for_timeout(600)

    check('no JS errors', not errors, '; '.join(errors[:3]))
    b.close()

passed = sum(1 for _, okk in results if okk)
print('\n== RESULT: %d/%d passed ==' % (passed, len(results)))
sys.exit(0 if passed == len(results) else 1)
