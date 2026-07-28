#!/usr/bin/env python3
"""KPI Module (App 213) — browser smoke test (Playwright).

Injects a live DB session (env KPI_TOK_ADMIN + KPI_UID/KPI_UNAME) into
localStorage and drives the KPI JET app through every page, EN + AR/RTL.

Run via the dev-proxy:
  python "final apps/KPI/Jet/dev-proxy.py" 8098   (or use with_server.py)
  KPI_TOK_ADMIN=... python browser_smoke.py
"""
import os, sys, json
from playwright.sync_api import sync_playwright

BASE = 'http://localhost:' + os.environ.get('KPI_PORT', '8098')
TOK = os.environ.get('KPI_TOK_ADMIN')
if not TOK:
    sys.exit('Set KPI_TOK_ADMIN (a live session token)')

SESSION = {
    'sessionId': TOK,
    'userId': int(os.environ.get('KPI_UID', '21')),
    'username': os.environ.get('KPI_UNAME', 'HANY'),
    'displayName': os.environ.get('KPI_DNAME', 'Hany'),
    'email': 'kpi.smoke@test',
    'rolesCsv': 'KPI_ADMIN,KPI_USER',
    'roles': ['KPI_ADMIN', 'KPI_USER'],
}

results = []
def t(name, ok, extra=''):
    results.append((name, ok))
    print(('PASS  ' if ok else 'FAIL  ') + name + ((' -- ' + str(extra)) if extra and not ok else ''))

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    ctx = browser.new_context(viewport={'width': 1440, 'height': 900})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))

    # seed the shared session before the app boots
    page.goto(BASE + '/KPI/Jet/index.html')
    page.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", SESSION)
    page.goto(BASE + '/KPI/Jet/index.html')
    page.wait_for_timeout(5000)

    # dashboard
    t('app mounts (topbar visible)', page.locator('.topbar').is_visible())
    t('module switcher shows Finance KPIs', 'Finance KPIs' in page.locator('.modsw-btn').inner_text())
    t('FPB-style regions render (>=4 kp-sec)', page.locator('.kp-sec').count() >= 4,
      page.locator('.kp-sec').count())
    t('How-to-start guide has 5 steps', page.locator('.kp-step').count() == 5,
      page.locator('.kp-step').count())
    t('overview answer band has 4 stat tiles', page.locator('.kp-tiles .kt').count() == 4,
      page.locator('.kp-tiles .kt').count())
    t('4 KPI cards render', page.locator('.kp-card').count() == 4, page.locator('.kp-card').count())
    t('hint icons present', page.locator('.hint-i').count() >= 4, page.locator('.hint-i').count())
    # collapse/expand a region
    page.locator('.kp-sec-h').first.click()
    page.wait_for_timeout(400)
    closed = page.locator('.kp-sec-h.closed').count()
    page.locator('.kp-sec-h').first.click()
    page.wait_for_timeout(400)
    t('region header collapses/expands', closed >= 1 and page.locator('.kp-sec-h.closed').count() == closed - 1)

    # results matrix
    page.evaluate("window._jetApp.navigate('results')")
    page.wait_for_timeout(3500)
    t('results Search + Results regions render', page.locator('.kp-sec').count() >= 2,
      page.locator('.kp-sec').count())
    rows = page.locator('.kp-matrix tbody tr').count()
    t('matrix has 4 KPI rows (or no-periods empty state)',
      rows == 4 or page.locator('.empty-state').count() > 0, rows)
    t('matrix legend renders (or empty state)',
      page.locator('.kp-legend').count() == 1 or page.locator('.empty-state').count() > 0)

    # registry (admin)
    page.evaluate("window._jetApp.navigate('kpiList')")
    page.wait_for_timeout(3000)
    t('registry lists 4 KPIs', page.locator('.data-table tbody tr').count() == 4,
      page.locator('.data-table tbody tr').count())

    # kpiEdit via row click
    page.locator('.data-table tbody tr').first.click()
    page.wait_for_timeout(3500)
    t('kpiEdit loads bands editor', page.locator('.score-pill').count() >= 5)

    # worklist
    page.evaluate("window._jetApp.navigate('myWorklist')")
    page.wait_for_timeout(3500)
    t('wf-worklist component mounts', page.locator('wf-worklist').count() == 1)

    # reports
    page.evaluate("window._jetApp.navigate('reports')")
    page.wait_for_timeout(2000)
    t('reports launcher renders', 'KPI' in page.locator('h1').first.inner_text())

    # notifications
    page.evaluate("window._jetApp.navigate('notifications')")
    page.wait_for_timeout(2500)
    t('notifications page renders', page.locator('.page-header-row').count() == 1)

    # AR / RTL — set via i18n; MUST restore EN afterwards (server-persisted pref)
    page.evaluate("window._jetApp.navigate('dashboard')")
    page.wait_for_timeout(2500)
    page.locator('.lang-pill button').nth(1).click()
    page.wait_for_timeout(3000)
    t('AR flips document to RTL', page.evaluate("document.documentElement.dir") == 'rtl')
    ar_title = page.locator('h1').first.inner_text()
    t('AR dashboard title translated', 'لوحة' in ar_title, ar_title)
    page.locator('.lang-pill button').nth(0).click()
    page.wait_for_timeout(2500)
    t('EN restored', page.evaluate("document.documentElement.dir") == 'ltr')

    t('no page JS errors', len(errors) == 0, errors[:3])
    page.screenshot(path='/tmp/claude-0/-root-DCT-Task-Management/d1780973-f17c-4278-abdd-ab0ba32afb06/scratchpad/kpi_dashboard.png', full_page=True)
    browser.close()

print('-' * 50)
npass = sum(1 for _, o in results if o)
print('TOTAL %d/%d PASS' % (npass, len(results)))
sys.exit(0 if npass == len(results) else 1)
