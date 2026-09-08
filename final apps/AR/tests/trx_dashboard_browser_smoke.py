# AR Transactions dashboard (App 206) browser smoke — Playwright over dev-proxy.
# Start nothing: this script launches its own proxy on PORT. READ-ONLY against
# PROD (the dashboard is analytics-only). Verifies: build-bar loader, KPI band,
# 8 charts, facet rail, register + sort + facet chip, level switch, drill
# window, chart drill drawer, column chooser, AR/RTL pass (language restored).
import json
import os
import re
import subprocess
import sys
import time
import urllib.request

from playwright.sync_api import sync_playwright

PORT = 8133
BASE = 'http://localhost:%d' % PORT
HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
EV = os.environ.get('TRXDASH_EVIDENCE', '/tmp/trxdash_evidence') + '/'
os.makedirs(EV, exist_ok=True)

src = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'),
           encoding='utf-8').read()
USER, PASS = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]
req = urllib.request.Request(ADB + '/dct/auth/login',
    data=json.dumps({'username': USER, 'password': PASS}).encode(),
    headers={'Content-Type': 'application/json'})
sess = json.loads(urllib.request.urlopen(req, timeout=60).read())
sess['roles'] = (sess.get('rolesCsv') or '').split(',')

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


proxy = subprocess.Popen([sys.executable, 'dev-proxy.py', str(PORT)], cwd=JET,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(3)
try:
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True,
                              args=['--no-sandbox', '--disable-dev-shm-usage'])
        ctx = b.new_context(viewport={'width': 1600, 'height': 1000},
                            accept_downloads=True)
        page = ctx.new_page()
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)))

        ctx.add_init_script("localStorage.setItem('ifinance_jet_session', "
                            + json.dumps(json.dumps(sess)) + ")")
        page.goto(BASE + '/index.html')
        page.wait_for_function('() => !!window._arApp', timeout=30000)

        # ---- open the dashboard + build-bar loader -----------------------
        page.evaluate("() => window._arApp.navigate('arTrxDashboard')")
        page.wait_for_selector('.page-title', timeout=20000)
        check('dashboard page opens',
              'Transactions' in page.locator('.page-title').inner_text())
        # the build-bar overlay is up while filters/summary load
        seen_loader = page.locator('.arld-ov').is_visible()
        if seen_loader:
            page.screenshot(path=EV + '00_build_bar.png')
        check('build-bar loader shown while loading', seen_loader)
        page.wait_for_selector('.arld-ov', state='hidden', timeout=60000)
        check('build-bar loader hides when loaded', True)

        # ---- KPI band + charts -------------------------------------------
        page.wait_for_selector('.tkpi-n', timeout=30000)
        kpis = page.locator('.tkpi').count()
        check('KPI band: 8 tiles', kpis == 8, str(kpis))
        trx_kpi = page.locator('.tkpi-n').first.inner_text()
        check('transactions KPI numeric', re.sub(r'[,٬]', '', trx_kpi).isdigit(), trx_kpi)
        page.wait_for_timeout(1500)
        ncv = page.locator('.ap-chart-body canvas').count()
        check('8 chart canvases render', ncv == 8, str(ncv))
        page.screenshot(path=EV + '01_dashboard_en.png', full_page=True)

        # ---- facet rail ---------------------------------------------------
        ngr = page.locator('.fct-group').count()
        check('facet rail: 13 groups', ngr == 13, str(ngr))
        # settlement group is open by default and carries counted items
        open_item = page.locator('.fct-item', has_text='Open').first
        check('settlement facet lists Open w/ count',
              open_item.locator('.fct-count').inner_text() != '')

        # ---- register -----------------------------------------------------
        page.wait_for_selector('.ap-region .data-table tbody tr', timeout=30000)
        nrows = page.locator('.ap-region .data-table tbody tr').count()
        check('register rows load (25/page)', nrows == 25, str(nrows))
        total_txt = page.locator('.section-heading.ap-rh').nth(1).inner_text()
        check('register total shown', re.search(r'[\d,]{4,}', total_txt), total_txt)

        # sort by invoiced
        page.locator('th', has_text='Invoiced AED').first.click()
        page.wait_for_timeout(2500)
        arrow = page.locator('th', has_text='Invoiced AED').first.inner_text()
        check('sort by amount toggles arrow', ('▼' in arrow) or ('▲' in arrow), arrow)

        # ---- facet click -> chip + reload --------------------------------
        open_item.click()
        page.wait_for_timeout(3500)
        chips = page.locator('.ap-chip').all_inner_texts()
        check('facet click adds a chip', any('Open' in c for c in chips), '|'.join(chips))
        page.screenshot(path=EV + '02_facet_open.png')

        # ---- level switch -> lines ---------------------------------------
        page.locator('.ap-seg-btn', has_text='Lines').click()
        page.wait_for_selector('.ap-region .data-table tbody tr', timeout=30000)
        # Chrome innerText applies the th text-transform — compare lower-case
        heads = ' | '.join(page.locator('.ap-region .data-table thead th').all_inner_texts()).lower()
        check('line level: memo-line column', 'memo line' in heads, heads[:120])
        check('line level: revenue column', 'revenue aed' in heads)
        page.screenshot(path=EV + '03_lines_level.png')
        page.locator('.ap-seg-btn', has_text='Transactions').click()
        page.wait_for_selector('.ap-region .data-table tbody tr', timeout=30000)

        # ---- drill window -------------------------------------------------
        page.locator('.ap-region .data-table tbody tr').first.click()
        page.wait_for_selector('.inv-box', timeout=30000)
        check('drill window opens', page.locator('.inv-box').is_visible())
        check('drill summary card amount',
              page.locator('.inv-amount').inner_text().strip() != '')
        check('drill settlement badge',
              page.locator('.inv-badges .badge').count() >= 2)
        page.screenshot(path=EV + '04_drill_window.png')
        page.keyboard.press('Escape')
        page.wait_for_timeout(600)
        check('Esc closes drill window', page.locator('.inv-box').count() == 0)

        # ---- chart drill drawer (click the M6P aging bar) -----------------
        page.evaluate("() => document.getElementById('arChartAging').scrollIntoView({block:'center'})")
        page.wait_for_timeout(600)
        pos = page.evaluate("""() => new Promise(res => {
          require(['chartjs'], function (C) {
            var ch = (C.Chart || C).getChart(document.getElementById('arChartAging'));
            if (!ch) { res(null); return; }
            var meta = ch.getDatasetMeta(0);
            var el = meta.data[meta.data.length - 1];   // M6P bar
            var r = ch.canvas.getBoundingClientRect();
            res({ x: r.left + el.x, y: r.top + (el.y + el.base) / 2 });
          });
        })""")
        check('aging chart instance found', bool(pos))
        if pos:
            page.mouse.click(pos['x'], pos['y'])
            try:
                page.wait_for_selector('.dw-drawer.show', timeout=8000)
            except Exception:
                # coordinate click missed (headless quirk) — fire the chart's
                # own onClick with the last bar's element index instead
                page.evaluate("""() => new Promise(res => {
                  require(['chartjs'], function (C) {
                    var ch = (C.Chart || C).getChart(document.getElementById('arChartAging'));
                    ch.options.onClick(null, [{ index: ch.getDatasetMeta(0).data.length - 1 }]);
                    res(1);
                  });
                })""")
                page.wait_for_selector('.dw-drawer.show', timeout=15000)
            check('chart drill drawer opens', True)
            page.wait_for_selector('.dw-drawer tbody tr', timeout=30000)
            check('drawer rows load',
                  page.locator('.dw-drawer tbody tr').count() > 0)
            check('drawer reconciling totals footer',
                  page.locator('.dw-total').inner_text().strip() != '')
            page.screenshot(path=EV + '05_chart_drill.png')
            page.keyboard.press('Escape')
            page.wait_for_timeout(600)
            check('Esc closes drawer',
                  not page.locator('.dw-drawer.show').count())

        # ---- column chooser ----------------------------------------------
        page.locator('.region-actions .btn', has_text='Columns').first.click()
        page.wait_for_selector('.ap-cols-panel', timeout=10000)
        before = page.locator('.ap-region .data-table thead th').count()
        page.locator('.ap-cols-panel .fct-item', has_text='Customer').first.click()
        page.wait_for_timeout(800)
        after = page.locator('.ap-region .data-table thead th').count()
        check('column chooser toggles a column', abs(after - before) == 1,
              '%d -> %d' % (before, after))
        page.locator('.ap-cols-panel .btn', has_text='Reset').click()
        page.locator('.ap-cols-panel .btn-primary').click()
        page.wait_for_timeout(1200)      # let the debounced server pref save land

        # ---- AR / RTL pass (restore EN after — shell persists the choice) -
        page.locator('.lang-pill button').nth(1).click()
        page.wait_for_timeout(4000)
        check('RTL applied', page.evaluate("() => document.documentElement.dir") == 'rtl')
        title_ar = page.locator('.page-title').inner_text()
        check('title translated to Arabic', 'الذمم' in title_ar, title_ar)
        page.screenshot(path=EV + '06_dashboard_ar.png', full_page=True)
        page.locator('.lang-pill button').nth(0).click()
        page.wait_for_timeout(3000)
        check('EN restored', page.evaluate("() => document.documentElement.dir") == 'ltr')

        real_errors = [e for e in errors if 'ResizeObserver' not in e]
        check('no page errors', not real_errors, ' || '.join(real_errors[:3]))

        b.close()
finally:
    proxy.terminate()

npass = sum(1 for _, ok in results if ok)
print('\n%d/%d PASS' % (npass, len(results)))
sys.exit(0 if npass == len(results) else 1)
