#!/usr/bin/env python3
"""PAY Module (App 215) — Employee Change Control browser smoke (EN + AR/RTL).

Covers: the payChanges page over the REAL Dayton smoke registers (11-2025
baseline + 12-2025 with one JOB_TITLE change), the full dual-confirmation
lifecycle in the UI (HR confirm -> HR sign-off -> Payroll confirm -> Payroll
sign-off), the all-values interactive report + changed-only filter, capture
of a fresh period, the register history, the run-console readiness chip on
the Payroll Runs page, and an AR/RTL round trip (restores EN — the shell
PERSISTS language).

Precondition (set up by the runner script): Dayton 12-2025 register OPEN with
exactly one pending JOB_TITLE change ('API Smoke Title').

Auth env (mint with dct_auth.open_session): PAY_TOK required.
Run: python dev-proxy.py 8217 (from PAY/Jet) then python pay_changes_browser.py
"""
import json, os, sys
from playwright.sync_api import sync_playwright

BASE = os.environ.get('PAY_BASE', 'http://localhost:8217')
EV = os.environ.get('PAY_EVIDENCE',
     '/tmp/claude-0/-root-DCT-Task-Management/1bc7cf4b-9264-4bcf-b60b-55f789458ab0/scratchpad/pay_chg_evidence/')
os.makedirs(EV, exist_ok=True)

TOK = os.environ.get('PAY_TOK')
if not TOK:
    sys.exit('Set PAY_TOK (live session token)')
sess = {
    'sessionId': TOK,
    'userId': int(os.environ.get('PAY_UID', '1')),
    'username': os.environ.get('PAY_USERNAME', 'ADMIN'),
    'displayName': os.environ.get('PAY_DN', 'System Administrator'),
    'rolesCsv': os.environ.get('PAY_ROLES', 'SYS_ADMIN'),
}
sess['roles'] = sess['rolesCsv'].split(',')

results = []
def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1000})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.on('dialog', lambda d: d.accept())

    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')

    # 1 — nav entry
    check('nav Employee Changes', page.locator('.nav-item', has_text='Employee Changes').count() == 1)

    # 2 — open the page, switch to Dayton 12-2025 (the seeded register)
    page.evaluate("window._jetApp.navigate('payChanges')")
    page.wait_for_timeout(3000)
    check('page title', 'Employee Change Control' in page.locator('.page-title').inner_text())
    page.locator('.ap-chips select').first.select_option('2')     # DAYTON_MONTHLY
    page.wait_for_timeout(2000)
    page.locator('.ap-chips select').nth(1).select_option('12-2025')
    page.wait_for_timeout(2500)

    # 3 — register head: OPEN status, KPI band, tracker
    check('status pill Open', page.locator('.chg-pill--open').count() >= 1)
    kpis = page.locator('.pr-k .pr-k-v').all_inner_texts()
    check('KPI in scope 25', '25' in kpis, str(kpis))
    check('KPI changes 1', '1' in kpis, str(kpis))
    check('tracker two sides', page.locator('.chg-side').count() == 2)
    check('HR progress 0/1', '0 / 1' in page.locator('.chg-side').first.inner_text())
    page.screenshot(path=EV + '01_register_open.png', full_page=True)

    # 4 — changes grid: employee group + JOB_TITLE diff row
    check('employee group row', page.locator('.chg-emp').count() == 1)
    row = page.locator('.chg-table tbody tr').nth(1)
    check('attr Job title', 'Job title' in row.inner_text())
    check('new value shown', 'API Smoke Title' in row.locator('.chg-new').inner_text())

    # 5 — HR confirm the item, then HR sign-off
    row.locator('button', has_text='Confirm').first.evaluate('el => el.click()')
    page.wait_for_timeout(2000)
    check('HR confirmed tick', '✓' in page.locator('.chg-table tbody tr').nth(1).inner_text())
    check('HR progress 1/1', '1 / 1' in page.locator('.chg-side').first.inner_text())
    page.locator('.chg-side').first.locator('button', has_text='HR sign-off').evaluate('el => el.click()')
    page.wait_for_timeout(2000)
    check('status HR confirmed', page.locator('.chg-pill--hr_confirmed').count() >= 1)
    check('HR side signed', 'Signed off by' in page.locator('.chg-side').first.inner_text())

    # 6 — Payroll confirm + sign-off => CONFIRMED
    page.locator('.chg-table tbody tr').nth(1).locator('button', has_text='Confirm').first.evaluate('el => el.click()')
    page.wait_for_timeout(2000)
    page.locator('.chg-side').nth(1).locator('button', has_text='Payroll sign-off').evaluate('el => el.click()')
    page.wait_for_timeout(2000)
    check('status Confirmed', page.locator('.chg-pill--confirmed').count() >= 1)
    check('both sides done', page.locator('.chg-side--done').count() == 2)
    page.screenshot(path=EV + '02_register_confirmed.png', full_page=True)

    # 7 — all-values tab on the shared interactive report
    page.locator('.chg-tab', has_text='All values').click()
    page.wait_for_timeout(2500)
    check('IR renders', page.locator('.ir-table').count() == 1)
    ir_region = page.locator('.ap-region').nth(1)
    check('IR pager full matrix', 'of 2' in ir_region.inner_text()
          or page.locator('.ir-table tbody tr').count() >= 50,
          str(page.locator('.ir-table tbody tr').count()))
    # changed-only narrows to the single diff
    page.locator('input[type=checkbox]').first.check()
    page.wait_for_timeout(2000)
    check('changed-only 1 row', page.locator('.ir-table tbody tr').count() == 1)
    page.screenshot(path=EV + '03_all_values.png', full_page=True)
    page.locator('input[type=checkbox]').first.uncheck()
    page.wait_for_timeout(1200)
    page.locator('.chg-tab', has_text='Changes').first.click()
    page.wait_for_timeout(1200)

    # 8 — baseline period view
    page.locator('.ap-chips select').nth(1).select_option('11-2025')
    page.wait_for_timeout(2200)
    check('baseline pill', page.locator('.chg-pill--baseline').count() >= 1)
    check('baseline note', page.locator('.chg-baseline').count() == 1)

    # 9 — un-captured period: empty state, then live capture
    page.locator('.ap-chips select').nth(1).select_option('10-2025')
    page.wait_for_timeout(2200)
    check('empty state', 'No change register' in page.locator('.ap-region').first.inner_text())
    page.locator('.ap-chips button', has_text='Capture changes').evaluate('el => el.click()')
    page.wait_for_timeout(3000)
    check('capture -> baseline (earliest period)', page.locator('.chg-pill--baseline').count() >= 1)

    # 10 — register history lists the captured periods
    page.locator('.section-heading', has_text='Register history').click()
    page.wait_for_timeout(800)
    hist_rows = page.locator('.ap-region').last.locator('tbody tr').count()
    check('history rows >= 3', hist_rows >= 3, str(hist_rows))
    page.screenshot(path=EV + '04_history.png', full_page=True)

    # 11 — run-console readiness chip on Payroll Runs
    page.evaluate("window._jetApp.navigate('payRuns')")
    page.wait_for_timeout(3000)
    page.locator('.ap-chips select').first.select_option('2')
    page.wait_for_timeout(2000)
    page.locator('.ap-chips select').nth(1).select_option('12-2025')
    page.wait_for_timeout(2500)
    chip = page.locator('.chg-chip')
    check('runs chip present', chip.count() == 1)
    check('runs chip confirmed', 'Confirmed' in chip.inner_text(), chip.inner_text() if chip.count() else '')
    check('runs chip green', chip.evaluate('el => el.className').find('confirmed') >= 0)
    page.screenshot(path=EV + '05_runs_chip.png')
    # chip deep-links into the change register
    chip.evaluate('el => el.click()')
    page.wait_for_timeout(3000)
    check('chip navigates to changes', 'Employee Change Control' in page.locator('.page-title').inner_text())
    check('deep link period kept', page.locator('.ap-chips select').nth(1).input_value() == '12-2025')

    # 12 — AR/RTL round trip
    page.locator('.lang-pill button', has_text='ع').click()
    page.wait_for_timeout(2500)
    check('RTL applied', page.evaluate("document.documentElement.dir || document.dir") == 'rtl'
          or page.locator('html[dir=rtl]').count() == 1)
    check('AR title', 'ضبط تغييرات الموظفين' in page.locator('.page-title').inner_text())
    page.screenshot(path=EV + '06_ar_rtl.png', full_page=True)
    page.locator('.lang-pill button', has_text='EN').click()
    page.wait_for_timeout(2000)
    check('EN restored', 'Employee Change Control' in page.locator('.page-title').inner_text())

    check('no page errors', not errors, '; '.join(errors[:3]))

    b.close()

passed = sum(1 for _, ok in results if ok)
print(f'\nRESULT: {passed}/{len(results)} passed')
sys.exit(0 if passed == len(results) else 1)
