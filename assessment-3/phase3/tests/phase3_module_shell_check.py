"""Phase 3 shell check for a module app (PC/DT/HR) with a seeded fake session.
Usage: python phase3_module_shell_check.py <AppDir> <expectedCube>
Starts the app's dev-proxy itself on :8080, checks the shell, stops it.
"""
import sys, subprocess, time, os, signal
sys.stdout.reconfigure(encoding='utf-8')
from playwright.sync_api import sync_playwright

app, cube = sys.argv[1], sys.argv[2]
base_dir = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
proxy = subprocess.Popen(['python', os.path.join(base_dir, app, 'Jet', 'dev-proxy.py')],
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)

FAKE_SESSION = ('{"sessionId":"PHASE3-SHELL-TEST","userId":1,"username":"ADMIN",'
                '"displayName":"Shell Tester","email":"t@t","roles":["SYS_ADMIN"],'
                '"color":"#444","initials":"ST","orgId":1,"orgName":"Test"}')

try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={'width': 1400, 'height': 900})
        ctx.add_init_script("localStorage.setItem('ifinance_jet_session', '" + FAKE_SESSION + "');")
        # stub all ORDS calls so the fake session never 401s (shell test only)
        ctx.route('**/ords/**', lambda route: route.fulfill(
            status=200, content_type='application/json', body='{"items":[]}'))
        page = ctx.new_page()
        errors = []
        page.on('console', lambda m: errors.append(m.text) if m.type == 'error' else None)
        page.goto('http://localhost:8080', timeout=30000)
        page.wait_for_selector('.side-logo', timeout=30000)
        page.wait_for_timeout(2000)

        print(app, 'topbar:', page.locator('.topbar').is_visible())
        print(app, 'cube:', page.locator('.side-logo .brand-cube').inner_text(), '(expect', cube + ')')
        print(app, 'nav items:', page.locator('.side .nav-item').count())
        print(app, 'switcher btn:', page.locator('.modsw-btn').inner_text()[:40].replace('\n', ' '))
        brand = page.evaluate("getComputedStyle(document.documentElement).getPropertyValue('--brand')").strip()
        print(app, '--brand:', brand)
        # AR toggle
        page.locator('.lang-pill button').nth(1).click()
        page.wait_for_timeout(1200)
        print(app, 'dir after AR:', page.evaluate("document.documentElement.dir"),
              '| nav[0]:', page.locator('.side .nav-label').first.inner_text())
        page.screenshot(path='c:/tmp/phase3_%s_shell.png' % app.lower())
        # only report non-network console errors (API calls fail with fake token — expected)
        real = [e for e in errors if 'Failed to load resource' not in e]
        print(app, 'non-network console errors (%d):' % len(real))
        for e in real[:8]: print('   -', e[:200])
        browser.close()
finally:
    proxy.terminate()
