#!/usr/bin/env python3
"""GL butil — cost-adjustment rows in the drill drawer (browser, EN).

Filters the Budget Utilization page to project 4511000981, opens the Actual
(AP) cell drill on the starred row and asserts the PCA adjustment row is
listed and the drawer total reconciles to the cell figure. Then unchecks
"Include Cost Adjustment" and asserts the drill goes back to raw (no PCA row).

Run: python dev-proxy.py 8213 (from GL/Jet) then GL_TOK=... python costadj_drill_browser_smoke.py
"""
import json
import os
import sys

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8213')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_cadj_evidence/')
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
    ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                           timeout=60000)
    page.wait_for_timeout(2500)

    # filter to the sample project via the VM (deterministic) and re-run
    page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      vm.buProjSel(['%s']);      // multi-select chip list -> exact any-of
      vm.buPeriod('');           // full year
      vm.runButil(0);
    }""" % PROJECT)
    page.wait_for_function(
        "() => !ko.dataFor(document.body).buBusy() && ko.dataFor(document.body).buItems().length > 0",
        timeout=60000)
    state = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const r = vm.buItems().filter(x => x.hasAdj === 'Y')[0];
      return r ? { task: r.taskNumber, ap: r.actualAp, cadjOn: vm.buCadjOn() } : null; }""")
    check('starred row loaded (hasAdj=Y)', bool(state), str(state))
    check('include-cost-adjustment echo ON', state and state['cadjOn'])

    # open the Actual AP drill on that row from the VM (same handler the cell uses)
    page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const r = vm.buItems().filter(x => x.hasAdj === 'Y')[0];
      vm.openBuDrill(r, 'ap');
    }""")
    page.wait_for_function("() => !ko.dataFor(document.body).drillLoading()", timeout=60000)
    page.wait_for_timeout(400)
    drill = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      return { rows: vm.drillRows(), total: vm.drillTotalV(), count: vm.drillCount() }; }""")
    pca = [r for r in drill['rows'] if r.get('fromAdj') == 'Y']
    check('PCA adjustment row in the drawer', len(pca) == 1, len(pca))
    check('row shaped as the referenced invoice dist (real statuses)',
          pca and pca[0].get('validation') not in ('', 'Cost Adjustment')
          and str(pca[0].get('adjRef', '')).startswith('PCA-'))
    check('drawer total == cell figure', abs(drill['total'] - state['ap']) < 0.01,
          '%s vs %s' % (drill['total'], state['ap']))
    body_txt = page.locator('.dw-drawer.show .dw-b').inner_text()
    check('(**) source marker rendered in the table', '(**)' in body_txt)
    check('referenced invoice number shown in the doc column',
          pca and not str(pca[0].get('invoice', '')).startswith('PCA-'), pca and pca[0].get('invoice'))
    check('(**) footnote under the table', 'cost adjustment' in
          (page.locator('.dw-drawer.show .cadj-note').inner_text() or '').lower())
    page.screenshot(path=EV + '01_drill_with_adj.png')
    page.evaluate("ko.dataFor(document.body).closeDrawer()")
    page.wait_for_timeout(300)

    # uncheck Include Cost Adjustment -> figures AND drill go raw
    page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      vm.buCadj(false);
      vm.runButil(0);
    }""")
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); "
        "return !vm.buLoading() && !vm.buCadjOn() && vm.buItems().length > 0; }",
        timeout=60000)
    diag = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      return { n: vm.buItems().length, tasks: vm.buItems().map(x => x.taskNumber) }; }""")
    check('rows reloaded without adjustment', diag['n'] > 0, str(diag))
    raw = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      const r = vm.buItems().filter(x => x.taskNumber === '%s')[0] || vm.buItems()[0];
      if (r) vm.openBuDrill(r, 'ap');
      return { ap: r ? r.actualAp : null }; }""" % (state['task'] if state else ''))
    page.wait_for_function("() => !ko.dataFor(document.body).drillLoading()", timeout=60000)
    drill2 = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      return { rows: vm.drillRows(), total: vm.drillTotalV() }; }""")
    check('unchecked: no adjustment row in the drill',
          not any(r.get('fromAdj') == 'Y' for r in drill2['rows']))
    check('unchecked: drawer total == raw cell figure',
          abs((drill2['total'] or 0) - (raw['ap'] or 0)) < 0.01,
          '%s vs %s' % (drill2['total'], raw['ap']))
    check('no JS errors', not errors, '; '.join(errors[:3]))
    b.close()

passed = sum(1 for _, okk in results if okk)
print('\n== RESULT: %d/%d passed ==' % (passed, len(results)))
sys.exit(0 if passed == len(results) else 1)
