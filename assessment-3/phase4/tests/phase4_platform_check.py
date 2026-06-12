"""Phase 4 platform browser check: Admin delegations/announcements pages,
profile delegations, announcement banner, module switcher shows FL/CC live."""
import sys, subprocess, time, os, re, json, urllib.request
sys.stdout.reconfigure(encoding='utf-8')
from playwright.sync_api import sync_playwright

BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
src = open(os.path.join(BASE, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)

proxy = subprocess.Popen(['python', os.path.join(BASE, 'Admin', 'Jet', 'dev-proxy.py')],
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)
try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width': 1440, 'height': 950})
        errors = []
        page.on('console', lambda msg: errors.append(msg.text) if msg.type == 'error' else None)
        page.on('pageerror', lambda e: errors.append('PAGEERROR: ' + str(e)))

        page.goto('http://localhost:8080', timeout=30000)
        page.wait_for_load_state('networkidle', timeout=30000)
        page.locator('.quick-btn').first.click()
        page.wait_for_selector('.side-logo', timeout=30000)
        page.wait_for_timeout(3500)

        # 1. announcement banner (INFO/ALL announcement from the seed)
        print('banner count:', page.locator('.ann-banner').count())
        print('banner text:', page.locator('.ann-banner__text').first.inner_text()[:80]
              if page.locator('.ann-banner').count() else 'NONE')
        page.screenshot(path='c:/tmp/p4_admin_banner.png')

        # 2. module switcher: FL and CC live (no soon badge)
        page.locator('.modsw-btn').click()
        page.wait_for_timeout(600)
        soon = page.locator('.modsw-item.soon').count()
        items = page.locator('.modsw-item').count()
        print('switcher items:', items, '| soon-flagged:', soon)
        page.screenshot(path='c:/tmp/p4_switcher.png')
        page.keyboard.press('Escape')
        page.locator('.app-content').click()

        # 3. delegations page (seeded NASER->AYESHA row)
        page.evaluate("window._jetApp.navigate('delegations')")
        page.wait_for_timeout(2500)
        print('delegations rows:', page.locator('.data-table tbody tr').count())
        page.screenshot(path='c:/tmp/p4_delegations.png')

        # 4. announcements page (2 active + 2 deactivated smoke rows)
        page.evaluate("window._jetApp.navigate('announcements')")
        page.wait_for_timeout(2500)
        print('announcements rows:', page.locator('.data-table tbody tr').count())
        page.screenshot(path='c:/tmp/p4_announcements.png')

        # 5. profile: real delegations card + New Delegation button
        page.evaluate("window._jetApp.navigate('profile')")
        page.wait_for_timeout(2500)
        body = page.locator('.page-wrap').inner_text()
        print('profile has My Delegations:', 'My Delegations' in body)
        print('profile New Delegation btn:', page.get_by_text('+ New Delegation').count())
        page.screenshot(path='c:/tmp/p4_profile.png')

        # 6. unified inbox shows FL/CC instances
        page.evaluate("window._jetApp.navigate('pendingApprovals')")
        page.wait_for_timeout(2500)
        inbox = page.locator('.page-wrap').inner_text()
        print('inbox mentions FL contract:', 'FL-CON' in inbox, '| CC repl:', 'CCM-' in inbox)
        page.screenshot(path='c:/tmp/p4_inbox.png')

        real = [e for e in errors if 'Failed to load resource' not in e]
        print('non-network console errors (%d):' % len(real))
        for e in real[:10]: print('  -', e[:200])
        browser.close()
finally:
    proxy.terminate()
