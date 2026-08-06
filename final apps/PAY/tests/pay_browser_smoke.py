#!/usr/bin/env python3
"""PAY Module (App 215) — Phase 1 browser smoke test (EN + AR/RTL).

Covers: dashboard KPIs + expiring region, companies register + drawer
(profile / suppliers / documents tabs, create + edit), contracts register +
drawer (details / margin rules, create + amend), banks page, module switcher
entry, AR/RTL toggle (restores EN at the end — the shell PERSISTS language).

Auth: pass a live session via env (mint with dct_auth.open_session):
  PAY_TOK   — session token (SYS_ADMIN or PAY_ADMIN holder)
  PAY_UID   — user_id      PAY_USERNAME — username
  PAY_DN    — display name PAY_ROLES    — roles CSV
Run: python dev-proxy.py 8215 (from PAY/Jet) then python pay_browser_smoke.py
"""
import json, os, sys, time
from playwright.sync_api import sync_playwright

BASE = os.environ.get('PAY_BASE', 'http://localhost:8215')
EV = os.environ.get('PAY_EVIDENCE',
     '/tmp/claude-0/-root-DCT-Task-Management/1bc7cf4b-9264-4bcf-b60b-55f789458ab0/scratchpad/pay_evidence/')
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
CO_CODE = 'SMKUI' + STAMP
CT_NO = 'SMKCT-' + STAMP

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

    # seed the shared session before ANY app JS runs (init script beats the
    # appController redirect-to-Admin race)
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')
    page.wait_for_timeout(2000)

    # 1 — dashboard
    check('dashboard title', 'Overview' in page.locator('.page-title').first.inner_text())
    check('brand cube PY', page.locator('.side .brand-cube').inner_text() == 'PY')
    check('side nav 4 items', page.locator('.nav-item').count() == 4,
          str(page.locator('.nav-item').count()))
    page.wait_for_timeout(1500)
    check('6 KPI tiles', page.locator('.kpi').count() == 6, str(page.locator('.kpi').count()))
    check('expiring region', page.locator('.ap-region .section-heading').count() >= 1)
    page.screenshot(path=EV + '01_dashboard.png', full_page=True)

    # 2 — module switcher contains PAY
    page.locator('.modsw-btn').click()
    page.wait_for_timeout(400)
    sw = page.locator('.modsw-item', has_text='Outsource Payroll').count()
    check('switcher lists Outsource Payroll', sw >= 1, str(sw))
    page.keyboard.press('Escape'); page.locator('.app-content').click(force=True)

    # 3 — companies page + create via drawer
    page.locator('.nav-item', has_text='Companies').click()
    page.wait_for_timeout(2000)
    check('companies title', 'Companies' in page.locator('.page-title').inner_text())
    page.locator('.page-actions .btn-primary', has_text='New Company').click()
    page.wait_for_timeout(600)
    check('company drawer opens', page.locator('.dw-drawer.show').count() == 1)
    check('drawer tabs (3)', page.locator('.ap-tabs .ap-tab').count() == 3)
    page.fill('.dw-form input.form-control >> nth=0', CO_CODE)          # code
    page.fill('.dw-form input.form-control >> nth=1', 'Smoke UI Manpower LLC')
    page.locator('.dw-h .btn', has_text='Save').click()
    page.wait_for_timeout(2500)
    check('company saved', page.locator('.dw-okmsg').count() == 1,
          page.locator('.dw-err').inner_text() if page.locator('.dw-err').count() else '')
    page.screenshot(path=EV + '02_company_drawer.png')

    # 4 — suppliers tab enabled after save; add a supplier ref via LOV
    page.locator('.ap-tab', has_text='Supplier References').click()
    page.wait_for_timeout(500)
    page.locator('.btn', has_text='+ Add supplier reference').click()
    page.wait_for_timeout(400)
    page.fill('.sub-editor .lov-pop input.form-control', 'llc')
    page.wait_for_timeout(1800)
    lov_n = page.locator('.lov-item').count()
    check('supplier LOV suggests', lov_n > 0, str(lov_n))
    if lov_n:
        page.locator('.lov-item').first.click()
        page.wait_for_timeout(300)
        page.locator('.sub-actions .btn-primary', has_text='Save').click()
        page.wait_for_timeout(2500)
        check('supplier ref saved', page.locator('.dw-b .data-table tbody tr').count() >= 1)
    page.screenshot(path=EV + '03_company_suppliers.png')
    page.locator('.dw-h .btn', has_text='Close').click()
    page.wait_for_timeout(600)

    # register shows the new company
    page.fill('.ap-chips input[type=search]', CO_CODE)
    page.wait_for_timeout(1800)
    check('register finds new company',
          page.locator('.data-table tbody tr', has_text=CO_CODE).count() == 1)

    # 5 — contracts page + create + margin rule + amend
    page.locator('.nav-item', has_text='Contracts').click()
    page.wait_for_timeout(2000)
    check('contracts title', 'Contracts' in page.locator('.page-title').inner_text())
    page.locator('.page-actions .btn-primary', has_text='New Contract').click()
    page.wait_for_timeout(800)
    page.select_option('.dw-form select.form-control >> nth=0',
                       label='Smoke UI Manpower LLC')
    page.fill('.dw-form input.form-control >> nth=0', CT_NO)            # contract no
    # dates
    page.fill('.dw-form input[type=date] >> nth=0', '2026-01-01')
    page.fill('.dw-form input[type=date] >> nth=1', '2026-09-20')
    page.locator('.dw-h .btn', has_text='Save').click()
    page.wait_for_timeout(2500)
    check('contract saved', page.locator('.dw-okmsg').count() == 1,
          page.locator('.dw-err').inner_text() if page.locator('.dw-err').count() else '')

    page.locator('.ap-tab', has_text='Margin Rules').click()
    page.wait_for_timeout(500)
    page.locator('.btn', has_text='+ Add margin rule').click()
    page.wait_for_timeout(400)
    page.fill('.sub-editor input[type=date] >> nth=0', '2026-01-01')
    page.fill('.sub-editor input[type=number]', '7.5')
    page.locator('.sub-actions .btn-primary', has_text='Save').click()
    page.wait_for_timeout(2500)
    check('margin rule saved', page.locator('.dw-b .data-table tbody tr').count() >= 1)
    page.screenshot(path=EV + '04_contract_margins.png')

    # amend (accept the suggested number)
    page.locator('.ap-tab', has_text='Details').click()
    page.wait_for_timeout(400)
    page.once('dialog', lambda d: d.accept(CT_NO + '-A1'))
    page.locator('.dw-h .btn', has_text='Amend').click()
    page.wait_for_timeout(4500)
    check('amend created new draft', page.locator('.dw-okmsg').count() == 1)
    check('version chips (2)', page.locator('.ap-chip').count() >= 2,
          str(page.locator('.ap-chip').count()))
    page.screenshot(path=EV + '05_contract_amended.png')
    page.locator('.dw-h .btn', has_text='Close').click()
    page.wait_for_timeout(500)

    # 6 — banks page
    page.locator('.nav-item', has_text='DCT Bank Accounts').click()
    page.wait_for_timeout(1500)
    check('banks title', 'Bank' in page.locator('.page-title').inner_text())
    page.locator('.page-actions .btn-primary', has_text='New Bank Account').click()
    page.wait_for_timeout(500)
    check('bank drawer opens', page.locator('.dw-drawer.show').count() == 1)
    page.locator('.dw-h .btn', has_text='Close').click()
    page.wait_for_timeout(400)
    page.screenshot(path=EV + '06_banks.png')

    # 7 — AR / RTL round trip (shell persists language: MUST restore EN)
    page.locator(".lang-pill button", has_text='ع').click()
    page.wait_for_timeout(2500)
    check('RTL applied', page.evaluate("document.documentElement.dir || document.dir") == 'rtl'
          or page.locator('html[dir=rtl]').count() == 1)
    ar_title = page.locator('.page-title').inner_text()
    check('AR title rendered', any('؀' <= ch <= 'ۿ' for ch in ar_title), ar_title)
    page.screenshot(path=EV + '07_ar_rtl.png', full_page=True)
    page.locator(".lang-pill button", has_text='EN').click()
    page.wait_for_timeout(2000)
    check('EN restored', page.locator('.page-title').inner_text() != ar_title)

    check('no page JS errors', len(errors) == 0, '; '.join(errors[:3]))
    b.close()

print('\n%d/%d PASS' % (sum(1 for _, ok in results if ok), len(results)))
sys.exit(0 if all(ok for _, ok in results) else 1)
