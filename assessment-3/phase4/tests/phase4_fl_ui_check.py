"""Phase 4 FL JET app browser check.
Logs in via live ORDS (creds parsed at runtime from Admin authService QUICK_LOGINS
and never printed), seeds the shared session key, then walks every FL route.
"""
import sys, subprocess, time, os, re, json, urllib.request
sys.stdout.reconfigure(encoding='utf-8')
from playwright.sync_api import sync_playwright

BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'

# -- runtime credential parse (first QUICK_LOGINS entry = System Admin) --------
src = open(os.path.join(BASE, 'Admin', 'Jet', 'js', 'services', 'authService.js'),
           encoding='utf-8').read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)

# -- ORDS login → real session object (same shape authService builds) ----------
cfg = open(os.path.join(BASE, 'FL', 'Jet', 'js', 'services', 'config.js'),
           encoding='utf-8').read()
adb = re.search(r"https://[\w.-]+oraclecloudapps\.com", cfg).group(0)
req = urllib.request.Request(adb + '/ords/admin/dct/auth/login',
                             data=json.dumps({'username': USER, 'password': PWD}).encode(),
                             headers={'Content-Type': 'application/json'}, method='POST')
data = json.loads(urllib.request.urlopen(req, timeout=30).read())
assert data.get('userId'), 'ORDS login failed'
data['roles'] = [r for r in (data.get('rolesCsv') or '').split(',') if r]
parts = (data.get('displayName') or USER).split(' ')
data['initials'] = (parts[0][0] + parts[-1][0]).upper() if len(parts) >= 2 else parts[0][0].upper()
SESSION = json.dumps(data)
print('login ok — roles:', ','.join(data['roles']))

proxy = subprocess.Popen(['python', os.path.join(BASE, 'FL', 'Jet', 'dev-proxy.py')],
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)

SIMPLE_ROUTES = ['paymentSchedule', 'vouchers', 'deliverables', 'documents',
                 'approvals', 'moduleSettings', 'notifications',
                 'registrationEdit', 'contractEdit']

try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={'width': 1440, 'height': 950})
        ctx.add_init_script(
            "localStorage.setItem('ifinance_jet_session', " + json.dumps(SESSION) + ");")
        page = ctx.new_page()
        errors = []
        page.on('console', lambda msg: errors.append(msg.text) if msg.type == 'error' else None)
        page.on('pageerror', lambda e: errors.append('PAGEERROR: ' + str(e)))

        page.goto('http://localhost:8080', timeout=30000)
        page.wait_for_selector('.side-logo', timeout=30000)
        page.wait_for_timeout(3500)

        print('cube:', page.locator('.side-logo .brand-cube').inner_text())
        print('nav items:', page.locator('.side .nav-item').count())
        brand = page.evaluate(
            "getComputedStyle(document.documentElement).getPropertyValue('--brand')").strip()
        print('--brand:', brand)
        print('dashboard canvases:', page.locator('canvas').count())
        print('stat values:', page.locator('.stat-value').all_inner_texts())
        page.screenshot(path='c:/tmp/fl_dashboard.png')

        # registrations list + pager + row click -> registrationEdit
        page.evaluate("window._jetApp.navigate('registrations')")
        page.wait_for_timeout(2500)
        rows = page.locator('.data-table tbody tr').count()
        print('registrations rows:', rows, '| pager:', page.locator('.pager').count())
        if rows:
            page.locator('.data-table tbody tr').first.click()
            page.wait_for_timeout(2000)
            print('reg row click -> route:',
                  page.evaluate("window.location.hash"),
                  '| audit-info:', page.locator('.audit-info').count())

        # freelancers -> freelancerDetail tabs
        page.evaluate("window._jetApp.navigate('freelancers')")
        page.wait_for_timeout(2500)
        rows = page.locator('.data-table tbody tr').count()
        print('freelancers rows:', rows)
        if rows:
            page.locator('.data-table tbody tr').first.click()
            page.wait_for_timeout(2500)
            print('fl detail route:', page.evaluate("window.location.hash"),
                  '| tabs:', page.locator('.fl-tabs .fl-tab, .tab-btn').count(),
                  '| audit-info:', page.locator('.audit-info').count())
            page.screenshot(path='c:/tmp/fl_detail.png')

        # contracts -> contractDetail
        page.evaluate("window._jetApp.navigate('contracts')")
        page.wait_for_timeout(2500)
        rows = page.locator('.data-table tbody tr').count()
        print('contracts rows:', rows)
        if rows:
            page.locator('.data-table tbody tr').first.click()
            page.wait_for_timeout(2500)
            print('contract detail route:', page.evaluate("window.location.hash"),
                  '| audit-info:', page.locator('.audit-info').count())
            page.screenshot(path='c:/tmp/fl_contract.png')

        for r in SIMPLE_ROUTES:
            page.evaluate("window._jetApp.navigate('%s')" % r)
            page.wait_for_timeout(2200)
            ok = page.locator('.page-title').count() > 0
            print('route %-18s page-title:%s tables:%d cards:%d' %
                  (r, ok, page.locator('.data-table').count(), page.locator('.card').count()))

        # AR / RTL pass on dashboard
        page.locator('.lang-pill button').nth(1).click()
        page.wait_for_timeout(1500)
        page.evaluate("window._jetApp.navigate('dashboard')")
        page.wait_for_timeout(2800)
        print('AR dir:', page.evaluate('document.documentElement.dir'),
              '| AR canvases:', page.locator('canvas').count(),
              '| nav[0]:', page.locator('.side .nav-label').first.inner_text())
        page.screenshot(path='c:/tmp/fl_dashboard_ar.png')

        real = [e for e in errors if 'Failed to load resource' not in e]
        net = [e for e in errors if 'Failed to load resource' in e]
        print('non-network console errors (%d):' % len(real))
        for e in real[:12]:
            print('  -', e[:220])
        print('network errors:', len(net))
        for e in net[:6]:
            print('  ~', e[:180])
        browser.close()
finally:
    proxy.terminate()
