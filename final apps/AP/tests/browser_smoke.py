import json, sys, urllib.request
from playwright.sync_api import sync_playwright

BASE = 'http://localhost:8123'
EV = '/tmp/claude-0/-root-DCT-Task-Management/3c5cc61b-25fc-4ae3-999f-30fcb48537fc/scratchpad/ap_evidence/'
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

# get a real session server-side (module apps redirect to Admin otherwise)
import os
UAT_USER = os.environ.get('IFINANCE_UAT_USER')
UAT_PASS = os.environ.get('IFINANCE_UAT_PASS')
if not UAT_USER or not UAT_PASS:
    sys.exit('Set IFINANCE_UAT_USER / IFINANCE_UAT_PASS env vars (UAT credentials are not stored in the repo)')
req = urllib.request.Request(ADB + '/dct/auth/login',
    data=json.dumps({'username': UAT_USER, 'password': UAT_PASS}).encode(),
    headers={'Content-Type':'application/json'})
sess = json.loads(urllib.request.urlopen(req, timeout=60).read())
sess['roles'] = (sess.get('rolesCsv') or '').split(',')
results = []
def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width':1600,'height':1000})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.on('console', lambda m: errors.append(m.text) if m.type == 'error' else None)

    # seed the shared session before app JS runs
    page.goto(BASE + '/index.html')
    page.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", sess)
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')
    page.wait_for_timeout(1500)

    # 1 home (blank placeholder)
    check('home loads', page.locator('.page-title').first.inner_text() != '', page.url)
    check('home placeholder', page.locator('.empty-state').count() >= 1)
    check('side nav has 2 items', page.locator('.nav-item').count() == 2)
    check('brand cube AP', page.locator('.side .brand-cube').inner_text() == 'AP')
    page.screenshot(path=EV+'01_home.png')

    # 2 dashboard
    page.locator('.nav-item', has_text='AP Dashboard').click()
    page.wait_for_timeout(6000)
    check('dashboard title', 'AP Dashboard' in page.locator('.page-title').inner_text())
    check('level radio present', page.locator('.ap-seg-btn').count() == 3)
    check('facet groups render', page.locator('.fct-group').count() >= 15, str(page.locator('.fct-group').count()))
    kpis = page.locator('.kpi').count()
    check('KPI tiles', kpis == 7, str(kpis))
    canv = page.locator('.ap-chart-body canvas').count()
    check('8 charts', canv == 8, str(canv))
    rows = page.locator('.data-table tbody tr').count()
    check('register rows', rows > 0, str(rows))
    page.screenshot(path=EV+'02_dashboard.png', full_page=True)

    # 3 facet apply: check Unpaid
    paid_group = page.locator('.fct-group').first
    page.locator('.fct-item', has_text='Unpaid').first.click()
    page.wait_for_timeout(5000)
    check('chip appears', page.locator('.ap-chip').count() >= 1)
    total_txt = page.locator('.section-heading', has_text='AP Register').inner_text()
    check('register filtered (1,102)', '1,102' in total_txt, total_txt)
    page.screenshot(path=EV+'03_facet_unpaid.png')

    # 4 level switch to distribution
    page.locator('.ap-seg-btn', has_text='Distribution').click()
    page.wait_for_timeout(5000)
    heads = page.locator('.data-table thead th').all_inner_texts()
    check('dist columns (Account)', any('ACCOUNT' in h.upper() for h in heads), '|'.join(heads[:8]))
    page.screenshot(path=EV+'04_level_dist.png')

    # 5 line level
    page.locator('.ap-seg-btn', has_text='Invoice line').click()
    page.wait_for_timeout(5000)
    heads = page.locator('.data-table thead th').all_inner_texts()
    check('line columns (Department)', any('DEPARTMENT' in h.upper() for h in heads), '')

    # 6 collapse + maximize analytics
    page.locator('.ap-region').first.locator('.region-actions button').nth(3).click()
    page.wait_for_timeout(400)
    check('charts collapsed', page.locator('.ap-chart-body canvas').count() == 0)
    page.locator('.ap-region').first.locator('.region-actions button').nth(3).click()
    page.wait_for_timeout(2500)
    check('charts re-rendered', page.locator('.ap-chart-body canvas').count() == 8)
    page.locator('.ap-region').first.locator('.region-actions button').nth(2).click()
    page.wait_for_timeout(600)
    check('maximized', page.locator('.ap-region--max').count() == 1)
    page.screenshot(path=EV+'05_maximized.png')
    page.locator('.ap-region').first.locator('.region-actions button').nth(2).click()
    page.wait_for_timeout(400)

    # 7 drill modal (back to header level)
    page.locator('.ap-seg-btn', has_text='Invoice header').click()
    page.wait_for_timeout(4000)
    page.locator('.data-table tbody tr').first.click()
    page.wait_for_timeout(2500)
    check('drill modal opens', page.locator('.modal-box').count() == 1)
    page.locator('.ap-tab', has_text='Distribution').click()
    page.wait_for_timeout(400)
    check('drill dists tab', page.locator('.modal-box .data-table').count() == 1)
    page.screenshot(path=EV+'06_drill.png')
    page.locator('.modal-box .region-actions button').click()
    page.wait_for_timeout(300)

    # 8 print window (popup)
    with ctx.expect_page() as pop_info:
        page.locator('.page-actions .btn-primary').click()
    pop = pop_info.value
    pop.wait_for_timeout(2500)
    body = pop.content()
    check('print window content', 'Accounts Payable Dashboard Report' in body)
    check('print criteria echoed', 'Paid status' in body and 'Unpaid' in body)
    pop.screenshot(path=EV+'07_print.png', full_page=True)
    pop.close()

    # 9 arabic flip
    page.locator('.lang-pill button', has_text='ع').click()
    page.wait_for_timeout(3500)
    check('RTL applied', page.evaluate("document.documentElement.dir") == 'rtl')
    page.screenshot(path=EV+'08_arabic.png')

    real_errors = [e for e in errors if 'favicon' not in e and 'net::' not in e]
    check('no console/page errors', len(real_errors) == 0, ' | '.join(real_errors[:4]))
    b.close()

print()
fails = [n for n, ok in results if not ok]
print('TOTAL %d PASS %d FAIL %d' % (len(results), len(results)-len(fails), len(fails)))
sys.exit(1 if fails else 0)
