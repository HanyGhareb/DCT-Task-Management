# Beneficiaries dashboard (App 212) browser smoke — Playwright over dev-proxy.
# Start the proxy first:  python3 "final apps/AP/Jet/dev-proxy.py" 8123
# Credentials parsed from the Admin quick logins (same as the UAT runners).
import json, os, re, sys, urllib.request
from playwright.sync_api import sync_playwright

BASE = 'http://localhost:8123'
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
EV = os.environ.get('BENEF_EVIDENCE', '/tmp/benef_evidence') + '/'
os.makedirs(EV, exist_ok=True)

src = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
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

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1600, 'height': 1000})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.on('console', lambda m: errors.append(m.text) if m.type == 'error' else None)

    page.goto(BASE + '/index.html')
    page.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", sess)
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')
    page.wait_for_timeout(1500)

    # 1 nav shows the new entry
    check('side nav has 3 items', page.locator('.nav-item').count() == 3,
          str(page.locator('.nav-item').count()))
    check('Beneficiaries nav entry', page.locator('.nav-item', has_text='Beneficiaries').count() == 1)

    # 2 open the Beneficiaries dashboard
    page.locator('.nav-item', has_text='Beneficiaries').click()
    page.wait_for_timeout(8000)
    check('benef title', 'Beneficiaries Dashboard' in page.locator('.page-title').inner_text())
    check('KPI tiles', page.locator('.kpi').count() == 7, str(page.locator('.kpi').count()))
    kpi_lbls = page.locator('.kpi-l').all_inner_texts()
    check('Beneficiaries KPI label', any(l.upper() == 'BENEFICIARIES' for l in kpi_lbls), '|'.join(kpi_lbls))
    inv_kpi = page.locator('.kpi-n').first.inner_text()
    check('invoices KPI = benef scope (2,604)', inv_kpi.replace(',', '') == '2604', inv_kpi)
    check('8 charts', page.locator('.ap-chart-body canvas').count() == 8)
    titles = page.locator('.ap-chart-title span').all_inner_texts()
    check('Top beneficiaries chart title', any('Top beneficiaries' in t for t in titles))
    # facet rail: the supplier group is relabeled Beneficiary
    fct_heads = page.locator('.fct-head').all_inner_texts()
    check('Beneficiary facet group', any(h.strip().startswith('Beneficiary') for h in fct_heads))
    page.screenshot(path=EV + '01_benef_dashboard.png', full_page=True)

    # 3 register: Beneficiary + Supplier No columns, no Is-Beneficiary column
    heads = [h.strip().upper() for h in page.locator('.data-table thead th').all_inner_texts()]
    check('register Beneficiary column', any(h.startswith('BENEFICIARY') for h in heads), '|'.join(heads[:8]))
    check('register Supplier No column', 'SUPPLIER NO' in heads)
    check('no Is-Beneficiary column', 'IS BENEFICIARY' not in heads)
    reg_txt = page.locator('.section-heading', has_text='Beneficiary Register').inner_text()
    check('register heading + count', 'Beneficiary Register' in reg_txt and '2,604' in reg_txt, reg_txt)

    # 4 beneficiary facet narrows the register
    grp = page.locator('.fct-group', has_text='Beneficiary').last
    grp.locator('.fct-head').click()
    page.wait_for_timeout(600)
    grp.locator('input.fct-mini').fill('OLGA EFIMOVA')
    page.wait_for_timeout(600)
    grp.locator('.fct-item').first.click()
    page.wait_for_timeout(5000)
    check('facet chip appears', page.locator('.ap-chip').count() >= 1)
    rows = page.locator('.data-table tbody tr').count()
    check('register narrowed to one beneficiary', 0 < rows <= 10, str(rows))
    page.screenshot(path=EV + '02_benef_facet.png')

    # 5 drill: row click opens the invoice window with the beneficiary as supplier
    page.locator('.data-table tbody tr').first.click()
    page.wait_for_timeout(2500)
    check('invoice window opens', page.locator('.inv-box').count() == 1)
    sup_line = page.locator('.inv-supplier').inner_text() if page.locator('.inv-supplier').count() else ''
    check('drill supplier = beneficiary name', 'OLGA EFIMOVA' in sup_line.upper(), sup_line[:60])
    page.screenshot(path=EV + '03_benef_drill.png')
    page.keyboard.press('Escape')
    page.wait_for_timeout(800)

    # 6 level switch keeps benef columns
    page.locator('.ap-chip-x').first.click()
    page.wait_for_timeout(4000)
    page.locator('.ap-seg-btn', has_text='Distribution').click()
    page.wait_for_timeout(6000)
    heads = [h.strip().upper() for h in page.locator('.data-table thead th').all_inner_texts()]
    check('dist level Supplier No column', 'SUPPLIER NO' in heads, '|'.join(heads[:8]))
    page.screenshot(path=EV + '04_benef_dist.png')

    # 7 regression: the standard AP dashboard is untouched
    page.locator('.nav-item', has_text='AP Dashboard').click()
    page.wait_for_timeout(8000)
    check('AP dashboard title intact', 'AP Dashboard' in page.locator('.page-title').inner_text())
    inv_kpi = page.locator('.kpi-n').first.inner_text()
    check('AP dashboard unscoped (5,080)', inv_kpi.replace(',', '') == '5080', inv_kpi)
    kpi_lbls = page.locator('.kpi-l').all_inner_texts()
    check('Suppliers KPI label intact', any(l.upper() == 'SUPPLIERS' for l in kpi_lbls))
    heads = [h.strip().upper() for h in page.locator('.data-table thead th').all_inner_texts()]
    check('AP register Supplier column intact', any(h.startswith('SUPPLIER') for h in heads))
    check('AP register keeps Is Beneficiary', 'IS BENEFICIARY' in heads)
    page.screenshot(path=EV + '05_ap_regression.png', full_page=True)

    # 8 console cleanliness (favicon 404s tolerated)
    bad = [e for e in errors if 'favicon' not in e]
    check('no console errors', not bad, ' | '.join(bad[:3]))

    b.close()

fails = [n for n, ok in results if not ok]
print('\n%d/%d PASS' % (len(results) - len(fails), len(results)))
if fails: print('FAILED:', fails)
sys.exit(1 if fails else 0)
