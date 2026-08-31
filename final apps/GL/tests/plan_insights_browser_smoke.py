#!/usr/bin/env python3
"""GL plan-insights browser smoke (v1.88.0, EN + AR).

Butil page: always-on vs-Plan + Plan-Coverage columns (D1), "Show Plan
Insights" search toggle revealing the D2 micro-chart + D3 composite columns,
Plan Performance + Plan Coverage KPI tiles (K1) with verdict-row drills, the
amber/green insight strips (K2) with View-lines filters, the verdict filter
chip, and Reset clearing everything.

Run: python dev-proxy.py 8214 (from GL/Jet) then GL_TOK=... python plan_insights_browser_smoke.py
"""
import json
import os
import sys

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8214')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_plan_insights_evidence/')
os.makedirs(EV, exist_ok=True)
TOK = os.environ.get('GL_TOK') or sys.exit('Set GL_TOK')
sess = {'sessionId': TOK, 'userId': 1, 'username': 'ADMIN',
        'displayName': 'System Administrator', 'rolesCsv': 'SYS_ADMIN',
        'roles': ['SYS_ADMIN']}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1900, 'height': 1080}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                           timeout=60000)
    # the landing butil run must have DELIVERED the plan aggregates before any
    # assertion (waiting on buLoading alone races the initial fetch)
    page.wait_for_function(
        "() => { const vm = window.ko && ko.dataFor(document.body); "
        "return !!vm && (vm.buTotals()||{}).planWithin !== undefined && vm.buItems().length > 0; }",
        timeout=120000)

    body = page.inner_text('body').lower()
    check('D1 vs-Plan header', 'vs plan' in body)
    check('D1 Plan-Coverage header', 'plan coverage' in body)
    check('verdict hands render', ('👍' in body) or ('👎' in body) or ('✋' in body))
    check('coverage pills render', page.locator('.pi-pill').count() > 0)
    check('K1 Plan Performance tile', 'plan performance' in body)
    check('K1 tile hero shows a pct',
          page.evaluate("() => { const vm=ko.dataFor(document.body); return vm.piExecPct() != null; }"))
    check('K2 execution strip', page.locator('.bu-alert--pi').first.is_visible())
    check('K2 coverage strip', page.locator('.bu-alert--picov').first.is_visible())
    check('D2/D3 hidden by default', page.locator('td.pi-d2').count() == 0
          and page.locator('td.pi-d3').count() == 0)
    page.screenshot(path=EV + '01_default_en.png')

    # ── "Show Plan" LOV (v1.88.1): YES default / INSIGHTS / NO ──
    check('Show Plan LOV defaults YES',
          page.evaluate("() => ko.dataFor(document.body).buPlanMode()") == 'YES')
    page.evaluate("() => ko.dataFor(document.body).buPlanMode('INSIGHTS')")
    page.wait_for_timeout(400)
    check('INSIGHTS reveals D2 micro-chart cells', page.locator('td.pi-d2').count() > 0)
    check('INSIGHTS reveals D3 composite cells', page.locator('td.pi-d3').count() > 0)
    check('D2 bullet tracks render', page.locator('.bl-track').count() > 0)
    page.screenshot(path=EV + '02_insights_cols.png')
    page.evaluate("() => ko.dataFor(document.body).buPlanMode('NO')")
    page.wait_for_timeout(400)
    thead = page.inner_text('.bu-results thead').lower()
    # v1.96.0: the vs Budget column is also a .pi-th but is INDEPENDENT of the
    # Show Plan LOV — with NO it must be the only verdict header left
    check('NO hides every plan column',
          page.locator('#pg-butil .bu-results th.pi-th').count() == 1
          and 'plan annual' not in thead and 'vs plan' not in thead)
    page.screenshot(path=EV + '02b_no_plan_cols.png')
    page.evaluate("() => ko.dataFor(document.body).buPlanMode('YES')")
    page.wait_for_timeout(300)

    # ── K2 "View below-plan" → planstate filter + chip ──
    page.evaluate("() => ko.dataFor(document.body).setPlanState('BELOW')")
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); "
        "return !vm.buLoading() && vm.buItems().length > 0 && vm.buItems()[0].planExecState; }",
        timeout=60000)
    st = page.evaluate(
        "() => { const vm = ko.dataFor(document.body); "
        "return { all: vm.buItems().every(r => r.planExecState === 'BELOW'), "
        "tot: vm.buTotal(), pb: vm.buTot('planBelow') }; }")
    check('BELOW filter: rows all BELOW', st['all'])
    check('BELOW filter: total == planBelow', st['tot'] == st['pb'],
          '%s vs %s' % (st['tot'], st['pb']))
    check('filter chip visible', page.locator('.pi-chip').first.is_visible())
    check('strips hidden while filtered',
          page.evaluate("() => { const vm=ko.dataFor(document.body); "
                        "return !vm.piExecBandOn() && !vm.piCovBandOn(); }"))
    page.screenshot(path=EV + '03_below_filter.png')
    page.evaluate("() => ko.dataFor(document.body).clearPlanState()")
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); return !vm.buLoading() && !vm.buPlanState(); }",
        timeout=60000)
    check('chip cleared', not page.locator('.pi-chip').first.is_visible())

    # ── Reset restores the LOV + clears the filter ──
    page.evaluate("() => { const vm=ko.dataFor(document.body); vm.buPlanMode('INSIGHTS'); vm.buPlanState('AHEAD'); vm.buReset(); }")
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); "
        "return !vm.buLoading() && !vm.buPlanState() && vm.buPlanMode() === 'YES'; }", timeout=60000)
    check('Reset restores Show Plan = Yes + clears verdict filter', True)

    # ── CSV export carries the indicator columns ──
    with page.expect_download(timeout=120000) as dl:
        page.evaluate("() => ko.dataFor(document.body).buExportCsv()")
    path = dl.value.path()
    head = open(path, encoding='utf-8-sig').readline()
    check('CSV has Plan Utilization % / Status / Coverage columns',
          all(c in head for c in ('Plan Utilization %', 'Plan Status', 'Plan Coverage %',
                                  'Coverage Status', 'Plan Variance')))

    # ── Arabic / RTL ──
    page.evaluate("() => ko.dataFor(document.body).toggleLang()")
    page.wait_for_timeout(1200)
    ar = page.inner_text('body')
    check('AR: vs-Plan header', 'مقابل الخطة' in ar)
    check('AR: Plan Performance tile', 'أداء الخطة' in ar)
    check('AR: RTL direction', page.evaluate("() => document.documentElement.dir") == 'rtl')
    page.screenshot(path=EV + '04_ar.png')
    page.evaluate("() => ko.dataFor(document.body).toggleLang()")
    page.wait_for_timeout(600)

    check('no page errors', not errors, errors[:3])
    b.close()

passed = sum(1 for _, c in results if c)
print('\n%d/%d passed' % (passed, len(results)))
sys.exit(0 if passed == len(results) else 1)
