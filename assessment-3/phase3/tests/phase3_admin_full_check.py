"""Phase 3 end-to-end browser check: Admin dashboard charts + paginated users + AR."""
import sys, subprocess, time, os
sys.stdout.reconfigure(encoding='utf-8')
from playwright.sync_api import sync_playwright

proxy = subprocess.Popen(['python', r'c:\claude\DCT-task-management\DCT-Task-Management\final apps\Admin\Jet\dev-proxy.py'],
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)
try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width': 1400, 'height': 950})
        errors = []
        page.on('console', lambda m: errors.append(m.text) if m.type == 'error' else None)

        page.goto('http://localhost:8080', timeout=30000)
        page.wait_for_load_state('networkidle', timeout=30000)
        page.locator('.quick-btn').first.click()
        page.wait_for_selector('.charts-row', timeout=30000)
        page.wait_for_timeout(3000)

        canvases = page.locator('.charts-row canvas').count()
        print('dashboard chart canvases:', canvases)
        stat_vals = page.locator('.stat-value').all_inner_texts()
        print('stat values:', stat_vals)
        page.screenshot(path='c:/tmp/phase3_dash_charts.png')

        # users list (navigate by route id — locale-agnostic)
        page.evaluate("window._jetApp.navigate('users')")
        page.wait_for_timeout(2500)
        print('users rows:', page.locator('.data-table tbody tr').count())
        print('pager visible:', page.locator('.pager').count())
        print('pager info:', page.locator('.pager__info').inner_text() if page.locator('.pager__info').count() else 'n/a')
        page.screenshot(path='c:/tmp/phase3_users_paged.png')

        # audit log
        page.evaluate("window._jetApp.navigate('auditLog')")
        page.wait_for_timeout(2500)
        print('audit rows:', page.locator('.data-table tbody tr').count())
        print('audit pager info:', page.locator('.pager__info').inner_text() if page.locator('.pager__info').count() else 'n/a')

        # Arabic full pass on dashboard
        page.locator('.lang-pill button').nth(1).click()
        page.wait_for_timeout(1800)
        page.evaluate("window._jetApp.navigate('dashboard')")
        page.wait_for_timeout(2500)
        print('dir:', page.evaluate('document.documentElement.dir'))
        print('AR chart canvases:', page.locator('.charts-row canvas').count())
        page.screenshot(path='c:/tmp/phase3_dash_ar.png')

        real = [e for e in errors if 'Failed to load resource' not in e]
        print('non-network console errors (%d):' % len(real))
        for e in real[:8]: print('  -', e[:220])
        net = [e for e in errors if 'Failed to load resource' in e]
        print('network errors:', len(net))
        browser.close()
finally:
    proxy.terminate()
