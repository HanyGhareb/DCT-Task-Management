"""Final sanity pass: login AR, notifications view, pendingApprovals, systemSettings."""
import sys, subprocess, time
sys.stdout.reconfigure(encoding='utf-8')
from playwright.sync_api import sync_playwright

proxy = subprocess.Popen(['python', r'c:\claude\DCT-task-management\DCT-Task-Management\final apps\Admin\Jet\dev-proxy.py'],
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)
try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width': 1400, 'height': 900})
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)[:200]))

        page.goto('http://localhost:8080', timeout=30000)
        page.wait_for_load_state('networkidle', timeout=30000)
        print('login title:', page.locator('.login-title').inner_text())
        print('login labels:', page.locator('.form-label').all_inner_texts())
        page.locator('.quick-btn').first.click()
        page.wait_for_selector('.charts-row', timeout=30000)
        page.wait_for_timeout(1500)

        for route in ['notifications', 'pendingApprovals', 'systemSettings', 'lookups', 'profile']:
            page.evaluate("window._jetApp.navigate('%s')" % route)
            page.wait_for_timeout(1800)
            title = page.locator('.page-title').first.inner_text() if page.locator('.page-title').count() else '(no title)'
            print(route, '->', title)

        # Arabic pass over the same views
        page.locator('.lang-pill button').nth(1).click()
        page.wait_for_timeout(1500)
        for route in ['notifications', 'systemSettings', 'lookups']:
            page.evaluate("window._jetApp.navigate('%s')" % route)
            page.wait_for_timeout(1500)
            title = page.locator('.page-title').first.inner_text() if page.locator('.page-title').count() else '(no title)'
            print('AR', route, '->', title)
        page.screenshot(path='c:/tmp/phase3_final_ar.png')
        # reset to EN so server pref stays English
        page.locator('.lang-pill button').nth(0).click()
        page.wait_for_timeout(1200)

        print('pageerrors:', errors[:5] if errors else 'none')
        browser.close()
finally:
    proxy.terminate()
