#!/usr/bin/env python3
"""ATD (App 208) — Project Budget Transactions page browser smoke (EN + AR/RTL).

Covers: nav entry, loaded-data region, parameter form (type/mode/date/BU and
status chips), mode hint switching, client-side validation, the extracted-data
register + filters + paging, the transaction drill drawer (lines + approval
trail), and the AR/RTL pass.

Deliberately does NOT enqueue a run — that is the API smoke's job
(pbt_api_smoke.py), which cancels what it queues. This test must never leave
work on the fleet's queue.

Auth: pass a live session via env (mint with dct_auth.open_session):
  ATD_TOK   — session token (SYS_ADMIN)      ATD_UID   — user_id
  ATD_USERNAME — username                    ATD_DN    — display name
Run: python dev-proxy.py 8208 (from ATD/Jet) then python pbt_browser_smoke.py
"""
import json
import os
import sys
import time

from playwright.sync_api import sync_playwright

BASE = os.environ.get('ATD_BASE', 'http://localhost:8208')
EV = os.environ.get('ATD_EVIDENCE', '/tmp/pbt_evidence/')
os.makedirs(EV, exist_ok=True)

TOK = os.environ.get('ATD_TOK')
if not TOK:
    sys.exit('Set ATD_TOK (live session token)')
sess = {
    'sessionId': TOK,
    'userId': int(os.environ.get('ATD_UID', '1')),
    'username': os.environ.get('ATD_USERNAME', 'ADMIN'),
    'displayName': os.environ.get('ATD_DN', 'System Administrator'),
    'rolesCsv': os.environ.get('ATD_ROLES', 'SYS_ADMIN'),
}
sess['roles'] = sess['rolesCsv'].split(',')

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

    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')
    page.wait_for_timeout(2000)

    # 1 — navigate by ID, never by visible text (labels are translated)
    page.evaluate("window._jetApp && window._jetApp.navigate('pbtExtract')")
    page.wait_for_timeout(2500)
    check('page title', 'Project Budget Transactions' in
          page.locator('.page-title').first.inner_text())
    check('no JS errors on load', not errors, '; '.join(errors[:2]))

    # 2 — loaded-data region reflects what the extract landed
    body = page.locator('.data-table').first.inner_text()
    check('loaded region lists Additional', 'Additional' in body)
    check('loaded region lists Estimated-Cost', 'Estimated-Cost' in body)
    check('loaded region lists Annual-Budget', 'Annual-Budget' in body)
    check('sync badge shown', page.locator('.badge').count() >= 1)
    page.screenshot(path=EV + '01_loaded.png', full_page=True)

    # 3 — parameters
    check('type select', page.locator('select').first.count() == 1)
    modes = page.locator('select').nth(1)
    check('3 run modes', modes.locator('option').count() == 3,
          str(modes.locator('option').count()))
    hint_before = page.locator('.pbt-mode-hint').inner_text()
    modes.select_option('SYNC_DEEP')
    page.wait_for_timeout(400)
    hint_after = page.locator('.pbt-mode-hint').inner_text()
    check('mode hint changes with mode', hint_before != hint_after)
    modes.select_option('RANGE')
    page.wait_for_timeout(300)

    # 4 — BU + status chips toggle
    chips = page.locator('.chip')
    n_chips = chips.count()
    check('filter chips rendered', n_chips >= 3, str(n_chips))
    on_before = page.locator('.chip--on').count()
    chips.first.click()
    page.wait_for_timeout(300)
    check('chip toggles off', page.locator('.chip--on').count() == on_before - 1)
    chips.first.click()
    page.wait_for_timeout(300)
    check('chip toggles back on', page.locator('.chip--on').count() == on_before)

    # 5 — client-side validation: RANGE with no dates must not enqueue
    page.locator('.page-actions .btn-primary').click()
    page.wait_for_timeout(700)
    check('RANGE without dates is blocked client-side',
          page.locator('.alert-danger').count() == 1)
    page.screenshot(path=EV + '02_validation.png', full_page=True)

    # 6 — extracted-data register
    rows = page.locator('.card').last.locator('tbody tr')
    check('register has rows', rows.count() > 0, str(rows.count()))
    showing = page.locator('.muted').last.inner_text()
    check('pager shows a total', '2187' in showing.replace(',', '') or '/' in showing, showing[:60])

    # 7 — filter the register by type
    selects = page.locator('.card').last.locator('select')
    selects.first.select_option('Annual-Budget')
    page.locator('.card').last.locator('.btn-secondary').first.click()
    page.wait_for_timeout(2000)
    cells = page.locator('.card').last.locator('tbody tr td:nth-child(2)')
    types = {cells.nth(i).inner_text().strip() for i in range(min(cells.count(), 8))}
    check('type filter applied', types == {'Annual-Budget'}, str(types))
    selects.first.select_option('')
    page.locator('.card').last.locator('.btn-secondary').first.click()
    page.wait_for_timeout(2000)

    # 8 — drill drawer: header + lines + approvals
    page.locator('.card').last.locator('tbody tr').first.click()
    page.wait_for_timeout(2500)
    check('drawer opened', page.locator('.modal-box').count() == 1)
    dtxt = page.locator('.modal-box').inner_text()
    check('drawer shows Details section', 'Details' in dtxt)
    check('drawer shows Approval history', 'Approval' in dtxt)
    page.screenshot(path=EV + '03_drill.png', full_page=True)
    # the platform modal backdrop wins Playwright's hit-test (even force=True
    # lands on .modal-overlay) -> fire the bound handler directly
    page.locator('.modal-box .btn-secondary').last.evaluate('el => el.click()')
    page.wait_for_timeout(600)
    check('drawer closed', page.locator('.modal-box').count() == 0)

    # 9 — AR / RTL.  The shell PERSISTS the language to the user's server-side
    # prefs, so this MUST restore EN before exiting or it silently flips the
    # account's UI for good.
    try:
        page.locator('button:text-is("ع")').last.click()
        page.wait_for_timeout(2500)
        check('RTL applied', page.locator('html[dir="rtl"]').count() == 1)
        ar_title = page.locator('.page-title').first.inner_text()
        check('title translated to AR', 'معاملات' in ar_title, ar_title[:40])
        page.screenshot(path=EV + '04_ar_rtl.png', full_page=True)
    finally:
        page.locator('button:text-is("EN")').last.click()
        page.wait_for_timeout(2000)
        check('EN restored (must not leave the account in AR)',
              page.locator('html[dir="rtl"]').count() == 0)

    check('no JS errors overall', not errors, '; '.join(errors[:3]))
    b.close()

ok = sum(1 for _n, c in results if c)
print('\n%d/%d passed' % (ok, len(results)))
print('evidence:', EV)
sys.exit(0 if ok == len(results) else 1)
