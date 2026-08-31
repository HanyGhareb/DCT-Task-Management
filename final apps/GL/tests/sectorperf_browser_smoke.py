#!/usr/bin/env python3
"""GL (App 210) — Sector Financial Performance page smoke (EN + AR/RTL).

Covers the four regions rebuilt from docs/Reports/GL/Sector Report_October.pdf
(Business Overview / Budget Overview / Project Level / Revenue Overview), the
criteria multi-selects (Sector and Department as requested), the sample-plan
banner, the RAG dots, CSV export and the Arabic pass.

Auth: GL_TOK = a live session token (SYS_ADMIN or a GL privilege holder).
Run:  python dev-proxy.py 8211 (from GL/Jet) then python sectorperf_browser_smoke.py
"""
import json
import os
import sys

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8211')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_sp_evidence/')
os.makedirs(EV, exist_ok=True)

TOK = os.environ.get('GL_TOK')
if not TOK:
    sys.exit('Set GL_TOK (live session token)')
sess = {
    'sessionId': TOK,
    'userId': int(os.environ.get('GL_UID', '1')),
    'username': os.environ.get('GL_USERNAME', 'ADMIN'),
    'displayName': os.environ.get('GL_DN', 'System Administrator'),
    'rolesCsv': os.environ.get('GL_ROLES', 'SYS_ADMIN'),
}
sess['roles'] = sess['rolesCsv'].split(',')

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


def num(page, expr):
    return page.evaluate(expr)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    # networkidle never settles on this app -- wait for KO to have bound
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                           timeout=60000)
    page.wait_for_timeout(2000)
    check('no JS errors on load', not errors, '; '.join(errors[:2]))

    # ---- nav -------------------------------------------------------------
    vm = "ko.dataFor(document.body)"
    page.evaluate("%s.go('sectorperf')" % vm)
    page.wait_for_function("() => ko.dataFor(document.body).spLoaded()", timeout=120000)
    page.wait_for_timeout(1200)
    check('Sector Performance is a Projects sub-tab',
          'Sector Performance' in page.locator('.pnav--sub').inner_text())
    check('page is visible', page.locator('#pg-sectorperf').is_visible())
    check('no JS errors after load', not errors, '; '.join(errors[:2]))

    # ---- criteria --------------------------------------------------------
    body = page.locator('#pg-sectorperf')
    txt = body.inner_text().lower()
    for lbl in ('search criteria', 'budget year', 'accounting period', 'sector',
                'department (cost centre)', 'expenditure kind'):
        check('criteria shows "%s"' % lbl, lbl in txt)
    check('year is preselected', bool(num(page, "%s.spcYear()" % vm)))
    check('default kind scope is Opex + Capex',
          num(page, "%s.spKindSel()" % vm) == ['Opex', 'Capex'])

    # ---- region 1: Business Overview -------------------------------------
    check('matrix has the 4 source rows', body.locator('.sp-matrix tbody tr').count() == 4)
    rows = [body.locator('.sp-matrix tbody tr').nth(i).inner_text().lower() for i in range(4)]
    check('matrix rows are Revenue / Opex / Capex / Opex & Capex',
          'revenue' in rows[0] and 'opex' in rows[1] and 'capex' in rows[2],
          str([r.split('\t')[0] for r in rows]))
    check('Opex & Capex row totals its two rows',
          num(page, "(function(m){return Math.abs(m[3].fyBudget-(m[1].fyBudget+m[2].fyBudget))<0.01})"
                    "(%s.spMatrix())" % vm))
    check('revenue-to-opex tile rendered', body.locator('.sp-r2o').count() == 1)
    check('cumulative chart has 12 columns',
          body.locator('.sp-chart .sp-cols').first.locator('.sp-col').count() == 12)

    # ---- region 2: Budget Overview ---------------------------------------
    check('KPI band has 6 tiles', body.locator('.sp-kpis .bk').count() == 6)
    check('both gauges rendered', body.locator('.sp-gauge').count() == 2)
    check('gauge arcs are drawn', body.locator('.sp-gauge-svg path').count() == 4)
    check('department bars rendered', body.locator('.sp-dept .bar-row').count() > 0,
          body.locator('.sp-dept .bar-row').count())
    # region headers: filled band + icon, coloured from the THEME vars
    check('every chart region has a filled header', body.locator('.sp-hd').count() == 4,
          body.locator('.sp-hd').count())
    check('each filled header carries an icon', body.locator('.sp-hd-ic').count() == 4)
    check('header fill comes from the region theme, not a flat/absent background',
          'gradient' in page.evaluate(
              "getComputedStyle(document.querySelector('#pg-sectorperf .sp-hd')).backgroundImage"))
    # department labels: FULL name + cost-centre code, never truncated
    lbl = body.locator('.sp-dept .bar-label').first
    check('department label shows the cost-centre code',
          bool(body.locator('.sp-dept .bar-label .sp-dcc').first.inner_text().strip()),
          body.locator('.sp-dept .bar-label .sp-dcc').first.inner_text())
    check('department name is not truncated',
          not page.evaluate("(function(e){return e.scrollWidth > e.clientWidth + 1})"
                            "(document.querySelector('#pg-sectorperf .sp-dept .bar-label'))"))
    # all four cells share one grid row -- an inherited 3-column .bar-row pushed
    # the % onto an implicit second row, which is what the report looked wrong on
    check('bar row keeps label / bar / value / % on ONE line',
          page.evaluate("(function(r){var t=[].map.call(r.children,function(c){"
                        "return c.getBoundingClientRect().top});"
                        "return Math.max.apply(null,t)-Math.min.apply(null,t) < 14})"
                        "(document.querySelector('#pg-sectorperf .sp-dept .bar-row'))"))
    check('nothing overflows the department card',
          page.evaluate("(function(b){return b.scrollWidth <= b.clientWidth + 1})"
                        "(document.querySelector('#pg-sectorperf .sp-dept .bars'))"))
    en_col = page.evaluate(
        "getComputedStyle(document.querySelector('#pg-sectorperf .sp-dept .sp-f--act')).backgroundColor")

    # ---- region 3: Project Level -----------------------------------------
    check('sector table has rows', body.locator('.sp-sectors tbody tr').count() > 0,
          body.locator('.sp-sectors tbody tr').count())
    check('sector table has a total row', body.locator('.sp-sectors tfoot tr.sp-total').count() == 1)
    check('RAG dots rendered', body.locator('.sp-sectors .sp-rag').count() > 0)
    check('RAG legend shows the three source bands',
          body.locator('.sp-rag-legend span').count() == 3)
    sec_rows = body.locator('.sp-sectors tbody tr').count()
    page.evaluate("%s.spToggleExpand()" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)
    page.wait_for_timeout(800)
    check('project level expands the table',
          body.locator('.sp-sectors tbody tr').count() >= sec_rows,
          '%s -> %s' % (sec_rows, body.locator('.sp-sectors tbody tr').count()))
    page.evaluate("%s.spToggleExpand()" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)

    # ---- region 4: Revenue Overview --------------------------------------
    check('three revenue stream cards', body.locator('.sp-stream').count() == 3)
    check('revenue category bars rendered', body.locator('.sp-cats .bar-row').count() > 0,
          body.locator('.sp-cats .bar-row').count())

    # ---- data quality ----------------------------------------------------
    check('data-quality tiles rendered', body.locator('.sp-dq > div').count() == 4)

    # ---- sample banner ---------------------------------------------------
    sample = num(page, "%s.spSampleActive()" % vm)
    check('sample banner matches the sample state',
          body.locator('.sp-sample').count() == (1 if sample else 0),
          'sampleActive=%s' % sample)
    if sample:
        check('sample banner names the plan figures',
              'sample data' in body.locator('.sp-sample').inner_text().lower())

    # ---- multi-select criteria (the user-requested parameters) ------------
    # the default Opex|Capex scope is itself shown as chips (the page is explicit
    # about the scope the source pack applies silently), so count from that base
    base_chips = body.locator('.mchips-bar .mchip').count()
    page.evaluate("(function(v){v.spSectorSel([v.spFilters().sectors[0]]);"
                  "v.spDeptSel([v.spFilters().departments[0].costCentre]);})(%s)" % vm)
    page.wait_for_timeout(400)
    check('applied-filters chip bar appears', body.locator('.mchips-bar').first.is_visible())
    check('sector + department add two chips',
          body.locator('.mchips-bar .mchip').count() == base_chips + 2,
          '%s -> %s' % (base_chips, body.locator('.mchips-bar .mchip').count()))
    page.evaluate("%s.spSearch()" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)
    page.wait_for_timeout(600)
    check('filtered run returns a narrower sector set',
          body.locator('.sp-sectors tbody tr').count() <= sec_rows)
    check('no JS errors after filtering', not errors, '; '.join(errors[:2]))
    page.screenshot(path=EV + 'sectorperf_en.png', full_page=True)

    page.evaluate("%s.spClear()" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)
    page.wait_for_timeout(500)
    check('clear drops the sector/department chips back to the default scope',
          body.locator('.mchips-bar .mchip').count() == base_chips,
          body.locator('.mchips-bar .mchip').count())
    check('clear restores the default Opex + Capex scope',
          num(page, "%s.spKindSel()" % vm) == ['Opex', 'Capex'])

    # ---- period cut ------------------------------------------------------
    check('page opens on the current accounting period, not full year',
          num(page, "%s.spcPeriod()" % vm) == num(page, "%s.spDefaultPeriod()" % vm),
          num(page, "%s.spcPeriod()" % vm))
    check('Target % is meaningful at the default period (not a flat 100)',
          num(page, "(function(m){return m[3].targetPct}) (%s.spMatrix())" % vm) != 100)
    page.evaluate("(function(v){v.spcPeriod('');v.spSearch();})(%s)" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)
    page.wait_for_timeout(500)
    full = num(page, "((%s.spOverview()||{}).kpi||{}).actual" % vm)
    page.evaluate("(function(v){v.spcPeriod('04-'+v.spcYear());v.spSearch();})(%s)" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)
    page.wait_for_timeout(600)
    cut = num(page, "((%s.spOverview()||{}).kpi||{}).actual" % vm)
    check('period cut lowers the actual', cut < full, '%s -> %s' % (full, cut))
    page.evaluate("(function(v){v.spcPeriod(v.spDefaultPeriod());v.spSearch();})(%s)" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)

    # ---- Arabic / RTL ----------------------------------------------------
    page.evaluate("%s.spClear()" % vm)
    page.wait_for_function("() => !ko.dataFor(document.body).spBusy()", timeout=120000)
    page.evaluate("%s.toggleLang()" % vm)
    page.wait_for_timeout(1500)
    check('page flips to RTL', page.evaluate("document.documentElement.dir") == 'rtl')
    ar = body.inner_text()
    check('criteria are translated', 'معايير البحث' in ar)
    check('sector table still renders in AR', body.locator('.sp-sectors tbody tr').count() > 0)
    check('gauges still render in AR', body.locator('.sp-gauge').count() == 2)
    # `html[dir=rtl] .bar-fill` out-specifies a single class, so the chart
    # colours silently reverted to the brand gradient in Arabic once already.
    ar_col = page.evaluate(
        "getComputedStyle(document.querySelector('#pg-sectorperf .sp-dept .sp-f--act')).backgroundColor")
    check('chart colours survive the RTL flip', ar_col == en_col, '%s vs %s' % (en_col, ar_col))
    check('no JS errors in AR', not errors, '; '.join(errors[:2]))
    page.screenshot(path=EV + 'sectorperf_ar.png', full_page=True)
    # GL persists language to localStorage only, but restore anyway so a
    # following suite starts from English
    page.evaluate("%s.toggleLang()" % vm)
    page.wait_for_timeout(800)
    check('language restored to EN', page.evaluate("document.documentElement.dir") != 'rtl')

    b.close()

passed = sum(1 for _, c in results if c)
print('\n%d passed / %d total   evidence: %s' % (passed, len(results), EV))
sys.exit(0 if passed == len(results) else 1)
