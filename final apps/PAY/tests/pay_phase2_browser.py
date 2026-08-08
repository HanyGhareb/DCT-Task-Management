#!/usr/bin/env python3
"""PAY Module (App 215) — Phase 2 Workforce browser smoke test (EN + AR/RTL).

Covers: Employees nav entry, register + filters, hire drawer (profile save →
auto OS- number), assignments tab (add w/ master LOVs), bank tab (add), docs
tab (6-row checklist + upload controls), lifecycle tab (suspend + resume →
event trail), bulk-upload region, dashboard headcount KPI + expiring-docs
region, AR/RTL round trip (restores EN — the shell PERSISTS language).

Auth env (mint with dct_auth.open_session): PAY_TOK required; PAY_UID /
PAY_USERNAME / PAY_DN / PAY_ROLES optional. Cleanup of the created employee
is the caller's job (person id is printed as CLEANUP_PID).
Run: python dev-proxy.py 8215 (from PAY/Jet) then python pay_phase2_browser.py
"""
import json, os, sys, time
from playwright.sync_api import sync_playwright

BASE = os.environ.get('PAY_BASE', 'http://localhost:8215')
EV = os.environ.get('PAY_EVIDENCE',
     '/tmp/claude-0/-root-DCT-Task-Management/1bc7cf4b-9264-4bcf-b60b-55f789458ab0/scratchpad/pay_p2_evidence/')
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

STAMP = str(int(time.time()))[-6:]
EMP_EMAIL = 'smkui' + STAMP + '@example.test'

results = []
def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)

def eclick(loc):
    loc.evaluate('el => el.click()')   # drawer subtree intercepts strict hit-tests

def kfill(loc, val):
    loc.fill(val)
    loc.dispatch_event('change')       # KO value binding listens to change, fill never blurs

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
    page.wait_for_timeout(2500)

    # 1 — dashboard gains headcount KPI + expiring-docs region
    check('nav has 5 items', page.locator('.nav-item').count() == 5,
          str(page.locator('.nav-item').count()))
    check('7 KPI tiles', page.locator('.kpi').count() == 7, str(page.locator('.kpi').count()))
    check('expiring-docs region', page.locator('.section-heading',
          has_text='Expiring Employee Documents').count() == 1)
    page.screenshot(path=EV + '01_dashboard.png', full_page=True)

    # 2 — employees register
    page.locator('.nav-item', has_text='Employees').click()
    page.wait_for_timeout(2000)
    check('employees title', 'Outsourced Employees' in page.locator('.page-title').inner_text())
    check('filter chips', page.locator('.ap-chips select').count() == 3)
    check('register region', page.locator('.section-heading', has_text='Employee Register').count() == 1)
    check('bulk region', page.locator('.section-heading', has_text='Excel Bulk Upload').count() == 1)
    page.screenshot(path=EV + '02_register.png', full_page=True)

    # 3 — hire a new employee via the drawer
    page.locator('.page-actions .btn-primary', has_text='New Employee').click()
    page.wait_for_timeout(600)
    check('drawer opens', page.locator('.dw-drawer.show').count() == 1)
    form_inputs = page.locator('.dw-drawer .dw-form input.form-control')
    kfill(form_inputs.nth(0), 'Smoke')          # first name EN
    kfill(form_inputs.nth(1), 'Test' + STAMP)   # last name EN
    kfill(page.locator('.dw-drawer .dw-form input[type=email]'), EMP_EMAIL)
    eclick(page.locator('.dw-h .btn', has_text='Save'))
    page.wait_for_timeout(2000)
    title = page.locator('.dw-title').inner_text()
    check('hire saved -> OS number', 'OS-' in title, title)
    page.screenshot(path=EV + '03_hire.png')

    # 4 — assignments tab: add primary assignment
    eclick(page.locator('.ap-tab', has_text='Assignments'))
    page.wait_for_timeout(600)
    eclick(page.locator('.region-actions .btn-primary', has_text='Add Assignment'))
    page.wait_for_timeout(600)
    page.locator('.dw-drawer .dw-form select').nth(0).select_option(index=1)  # company
    page.locator('.dw-drawer .dw-form select').nth(2).select_option('DCT')    # BU
    kfill(page.locator('.dw-drawer .dw-form input[type=date]').nth(0), '2026-08-01')
    eclick(page.locator('.dw-drawer .region-actions .btn-primary', has_text='Save'))
    page.wait_for_timeout(2000)
    check('assignment row', page.locator('.dw-drawer .data-table tbody tr').count() >= 1)
    check('PRIMARY badge', page.locator('.dw-drawer .badge', has_text='Primary').count() >= 1)
    page.screenshot(path=EV + '04_assignment.png')

    # 5 — bank tab: add account
    eclick(page.locator('.ap-tab', has_text='Bank'))
    page.wait_for_timeout(600)
    eclick(page.locator('.region-actions .btn-primary', has_text='Add Bank Account'))
    page.wait_for_timeout(500)
    binputs = page.locator('.dw-drawer .dw-form input.form-control')
    kfill(binputs.nth(0), 'FAB')
    kfill(binputs.nth(1), 'AE070331234567890' + STAMP)
    eclick(page.locator('.dw-drawer .region-actions .btn-primary', has_text='Save'))
    page.wait_for_timeout(2000)
    check('bank row', page.locator('.dw-drawer .data-table tbody tr').count() >= 1)
    page.screenshot(path=EV + '05_bank.png')

    # 6 — documents tab: checklist
    eclick(page.locator('.ap-tab', has_text='Documents'))
    page.wait_for_timeout(1200)
    check('checklist 6 rows',
          page.locator('.dw-drawer .data-table').nth(0).locator('tbody tr').count() == 6,
          str(page.locator('.dw-drawer .data-table').nth(0).locator('tbody tr').count()))
    check('doc type picker', page.locator('.dw-drawer .region-actions select').count() == 1)
    page.screenshot(path=EV + '06_docs.png')

    # 7 — lifecycle: suspend then resume
    eclick(page.locator('.ap-tab', has_text='Lifecycle'))
    page.wait_for_timeout(600)
    check('hire event listed', page.locator('.dw-drawer .badge', has_text='Hire').count() >= 1)
    eclick(page.locator('.dw-drawer .region-actions .btn', has_text='Suspend'))
    page.wait_for_timeout(500)
    eclick(page.locator('.dw-drawer .region-actions .btn-primary', has_text='Confirm'))
    page.wait_for_timeout(2000)
    check('suspend event listed', page.locator('.dw-drawer .badge', has_text='Suspend').count() >= 1)
    eclick(page.locator('.dw-drawer .region-actions .btn', has_text='Resume'))
    page.wait_for_timeout(500)
    eclick(page.locator('.dw-drawer .region-actions .btn-primary', has_text='Confirm'))
    page.wait_for_timeout(2000)
    check('resume event listed', page.locator('.dw-drawer .badge', has_text='Resume').count() >= 1)
    page.screenshot(path=EV + '07_lifecycle.png')
    eclick(page.locator('.dw-h .btn', has_text='Close'))
    page.wait_for_timeout(600)

    # 8 — register shows the new hire
    page.locator('.ap-chips input[type=search]').fill('Test' + STAMP)
    page.wait_for_timeout(1500)
    check('register finds hire', page.locator('.ap-region .data-table tbody tr').count() >= 1)
    pid = page.evaluate("""() => {
      const el = document.querySelector('.ap-region .data-table tbody tr');
      return el ? el.textContent : '';
    }""")

    # 9 — bulk region controls
    eclick(page.locator('.region-actions .btn', has_text='▸').first)
    page.wait_for_timeout(400)
    check('bulk template button', page.locator('.btn', has_text='Download Template').count() == 1)
    check('bulk upload button', page.locator('.btn', has_text='Upload Excel').count() == 1)
    page.screenshot(path=EV + '08_bulk.png', full_page=True)

    # 10 — AR / RTL round trip (shell persists language: MUST restore EN)
    page.locator(".lang-pill button", has_text='ع').click()
    page.wait_for_timeout(2500)
    check('RTL applied', page.evaluate("document.documentElement.dir || document.dir") == 'rtl'
          or page.locator('html[dir=rtl]').count() == 1)
    ar_title = page.locator('.page-title').inner_text()
    check('AR title rendered', any('؀' <= ch <= 'ۿ' for ch in ar_title), ar_title)
    page.screenshot(path=EV + '09_ar_rtl.png', full_page=True)
    page.locator(".lang-pill button", has_text='EN').click()
    page.wait_for_timeout(2000)
    check('EN restored', page.locator('.page-title').inner_text() != ar_title)

    check('no page JS errors', len(errors) == 0, '; '.join(errors[:3]))
    b.close()

print('\n%d/%d PASS' % (sum(1 for _, ok in results if ok), len(results)))
print('CLEANUP_EMAIL', EMP_EMAIL)
sys.exit(0 if all(ok for _, ok in results) else 1)
