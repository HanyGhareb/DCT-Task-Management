#!/usr/bin/env python3
"""PAY Module (App 215) — Phase 3 Payroll browser smoke test (EN + AR/RTL).

Covers: Payroll Runs + Payroll Setup nav entries; the run console over the
REAL replay runs (ALN 12-2025: status pill, KPI band, invoice-group split,
company-charge preview incl. VAT, results register + search, calculation-line
drawer; Dayton 11-2025: exception register + DRAFT-contract note), and the
setup page (3 payrolls, 7 elements, PENSION_GCC rows w/ pending-Finance
employer rates, 6 invoice groups, payroll + element drawers), then an AR/RTL
round trip (restores EN — the shell PERSISTS language).

Auth env (mint with dct_auth.open_session): PAY_TOK required.
Run: python dev-proxy.py 8216 (from PAY/Jet) then python pay_phase3_browser.py
"""
import json, os, sys, time
from playwright.sync_api import sync_playwright

BASE = os.environ.get('PAY_BASE', 'http://localhost:8216')
EV = os.environ.get('PAY_EVIDENCE',
     '/tmp/claude-0/-root-DCT-Task-Management/1bc7cf4b-9264-4bcf-b60b-55f789458ab0/scratchpad/pay_p3_evidence/')
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

    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')

    # 1 — nav entries exist
    check('nav Payroll Runs', page.locator('.nav-item', has_text='Payroll Runs').count() == 1)
    check('nav Payroll Setup', page.locator('.nav-item', has_text='Payroll Setup').count() == 1)

    # 2 — run console: ALN 12-2025 (replay run) auto-loads
    page.evaluate("window.location.hash = '#payRuns'")
    page.locator('.nav-item', has_text='Payroll Runs').click()
    page.wait_for_timeout(3500)
    check('runs page title', 'Payroll Runs' in page.locator('.page-title').inner_text())
    sel = page.locator('.ap-chips select').first
    check('3 payrolls in select', sel.locator('option').count() == 3)
    # ALN is first alphabetically; its 12-2025 period preselects (first with a run)
    page.wait_for_timeout(2500)
    check('status pill CALCULATED', page.locator('.pr-pill--calculated').count() >= 1)
    kpis = page.locator('.pr-k .pr-k-v').all_inner_texts()
    check('KPI employees 313', '313' in kpis, str(kpis[:3]))
    check('KPI gross 13.8M', any('13,817,398' in k for k in kpis), str(kpis))
    check('groups table 3 rows', page.locator('.pr-2col .card').first.locator('tbody tr').count() == 3)
    charges_txt = page.locator('.pr-2col .card').nth(1).inner_text()
    check('charge PER_EMPLOYEE 795', 'PER_EMPLOYEE 795' in charges_txt)
    check('charge VAT preview', 'VAT' in charges_txt)
    check('register total 313', '313' in page.locator('.ap-region .section-heading').last.inner_text()
          or page.locator('tbody tr').count() > 10)
    page.screenshot(path=EV + '01_run_console_aln.png', full_page=True)

    # 3 — register row click -> calculation lines drawer
    page.locator('.ap-region').last.locator('tbody tr').first.click()
    page.wait_for_timeout(1500)
    check('lines drawer open', page.locator('.dw-drawer.show').count() == 1)
    dw = page.locator('.dw-drawer.show').inner_text()
    check('BASIC line present', 'BASIC' in dw, dw[:120])
    # invoice-group move control (Pay Admin, calculated run): 4 ALN groups
    mv = page.locator('.dw-drawer.show select').first
    check('move-group select 4 options', mv.locator('option').count() == 4)
    # short codes are user-editable data - assert the "SHORT (code) - name" shape
    check('move-group shows short codes', all('(' in o and ')' in o for o in mv.locator('option').all_inner_texts()))
    page.screenshot(path=EV + '02_lines_drawer.png')
    page.locator('.dw-drawer.show .dw-acts button').first.click()
    page.wait_for_timeout(600)

    # 4 — register search narrows
    page.locator('.ap-region').last.locator('input[type=search]').fill('Gacayan')
    page.wait_for_timeout(1800)
    rows = page.locator('.ap-region').last.locator('tbody tr').count()
    check('search narrows register', 0 < rows <= 3, str(rows))
    page.locator('.ap-region').last.locator('input[type=search]').fill('')
    page.wait_for_timeout(1500)

    # 5 — Dayton run: exceptions + DRAFT note
    sel.select_option(label=[o for o in sel.locator('option').all_inner_texts() if 'DAYTON' in o][0])
    page.wait_for_timeout(3000)
    body_txt = page.inner_text('body')
    check('dayton run loaded', 'DAYTON_MONTHLY' in body_txt)
    check('dayton DRAFT note', 'DRAFT' in body_txt)
    check('dayton exceptions region', 'NO_SALARY_ENTRY' in body_txt)
    page.screenshot(path=EV + '03_run_console_dayton.png', full_page=True)

    # 6 — setup page
    page.locator('.nav-item', has_text='Payroll Setup').click()
    page.wait_for_timeout(3000)
    check('setup title', 'Payroll Setup' in page.locator('.page-title').inner_text())
    regions = page.locator('.card.ap-region')
    check('payrolls table 3', regions.nth(0).locator('tbody tr').count() == 3)
    check('elements table 7', regions.nth(1).locator('tbody tr').count() == 7)
    rt_txt = regions.nth(2).inner_text()
    check('pension rows AE/SA/OM', all(k in rt_txt for k in ('AE', 'SA', 'OM')))
    check('employer rate pending', 'pending Finance' in rt_txt)
    check('invoice groups 6', regions.nth(3).locator('tbody tr').count() == 6)
    # Chrome innerText applies the th text-transform -> compare lower-case
    ig_head = regions.nth(3).locator('thead').inner_text().lower()
    check('groups have Short Code column', 'short code' in ig_head, ig_head)
    # first ALN group: capture its (user-editable) short code + CC count
    first_g = regions.nth(3).locator('tbody tr').first.locator('td').all_inner_texts()
    g_short = first_g[2]
    check('groups show cost-center counts', first_g[4].strip().isdigit() and int(first_g[4]) > 0, str(first_g[:5]))
    page.screenshot(path=EV + '04_setup.png', full_page=True)

    # 6b — invoice group drawer: CC picker + resolved members + overrides
    regions.nth(3).locator('tbody tr').first.click()   # ADALC
    page.wait_for_timeout(3000)
    gdw = page.locator('.dw-drawer.show')
    gdt = gdw.inner_text()
    check('group drawer opens first ALN group', g_short in gdt, g_short)
    checked = gdw.locator('.data-table-wrap').first.locator('input[type=checkbox]:checked').count()
    check('its cost centers are ticked', checked == int(first_g[4]), '%s vs %s' % (checked, first_g[4]))
    check('members region shows 35', '(35)' in gdt, gdt[:200])
    check('member remove buttons', gdw.locator('button', has_text='Remove').count() > 0)
    check('add-employee search present', gdw.locator('input[type=search]').count() == 1)
    # selected-only filter narrows the CC picker to the ticked centers
    cc_rows_all = gdw.locator('.data-table-wrap').first.locator('tbody tr').count()
    gdw.locator('span', has_text='Show selected only').first.click()
    page.wait_for_timeout(500)
    cc_rows_sel = gdw.locator('.data-table-wrap').first.locator('tbody tr').count()
    check('selected-only filter narrows to ticked rows', cc_rows_sel == int(first_g[4]) and cc_rows_all > cc_rows_sel,
          '%d -> %d' % (cc_rows_all, cc_rows_sel))
    gdw.locator('span', has_text='Show selected only').first.click()
    page.wait_for_timeout(500)
    check('filter off restores full list',
          gdw.locator('.data-table-wrap').first.locator('tbody tr').count() == cc_rows_all)
    page.screenshot(path=EV + '07_invoice_group_drawer.png', full_page=True)
    page.locator('.dw-drawer.show .dw-acts button').first.click()
    page.wait_for_timeout(600)

    # 7 — payroll drawer opens
    regions.nth(0).locator('tbody tr').first.click()
    page.wait_for_timeout(1000)
    check('payroll drawer', 'ALN_MONTHLY' in page.locator('.dw-drawer.show').inner_text())
    page.locator('.dw-drawer.show .dw-acts button').first.click()
    page.wait_for_timeout(600)

    # 8 — element drawer opens (BASIC row)
    regions.nth(1).locator('tbody tr').first.click()
    page.wait_for_timeout(1000)
    dw = page.locator('.dw-drawer.show').inner_text()
    check('element drawer BASIC', 'BASIC' in dw)
    page.screenshot(path=EV + '05_element_drawer.png')
    page.locator('.dw-drawer.show .dw-acts button').first.click()
    page.wait_for_timeout(600)

    # 8b — Employees drawer: Salary tab (element entries)
    page.locator('.nav-item', has_text='Employees').click()
    page.wait_for_timeout(3000)
    page.locator('input[type=search]').first.fill('OS-00009')
    page.wait_for_timeout(2000)
    page.locator('tbody tr').first.click()
    page.wait_for_timeout(2500)
    edw = page.locator('.dw-drawer.show')
    check('employee drawer open', edw.count() == 1)
    edw.locator('.ap-tab', has_text='Salary').click()
    page.wait_for_timeout(2500)
    sal_txt = edw.inner_text()
    check('salary tab lists BASIC entry', 'BASIC' in sal_txt, sal_txt[:150])
    check('salary tab New Entry button', edw.locator('button', has_text='New Entry').count() == 1)
    check('salary tab End action', edw.locator('button', has_text='End').count() >= 1)
    # sticky dw-h header intercepts Playwright's hit-test -> fire handlers directly
    edw.locator('button', has_text='New Entry').first.evaluate('el => el.click()')
    page.wait_for_timeout(800)
    check('entry form element picker', edw.locator('select').first.locator('option').count() >= 5)
    page.screenshot(path=EV + '08_salary_tab.png', full_page=True)
    edw.locator('button', has_text='Cancel').first.evaluate('el => el.click()')
    page.wait_for_timeout(500)
    edw.locator('.dw-acts button', has_text='Close').first.evaluate('el => el.click()')
    page.wait_for_timeout(800)

    # 8c — Company dashboard (ALN): Dashboard button on the Companies register
    page.locator('.nav-item', has_text='Companies').click()
    page.wait_for_timeout(2500)
    check('companies Dashboard column', page.locator('tbody tr').first.locator('button', has_text='Dashboard').count() == 1)
    page.locator('tbody tr').first.locator('button', has_text='Dashboard').first.evaluate('el => el.click()')
    page.wait_for_timeout(4500)
    cd_body = page.inner_text('body')
    check('companyDash title ALN', '(ALN)' in page.locator('.page-title').inner_text())
    cd_kpis = page.locator('.pr-k .pr-k-v').all_inner_texts()
    check('companyDash headcount 313', '313' in cd_kpis, str(cd_kpis))
    check('companyDash paid total', any('189,' in k for k in cd_kpis), str(cd_kpis))
    check('companyDash charts rendered', page.locator('canvas').count() == 3)
    check('companyDash invoices region', 'Fusion AP Invoices' in cd_body)
    check('companyDash cost-by-cc region', 'Payroll Cost by Cost Center' in cd_body)
    check('companyDash employees table rows', page.locator('.ap-region').last.locator('tbody tr').count() >= 100)
    page.screenshot(path=EV + '09_company_dash.png', full_page=True)
    page.locator('.page-actions button', has_text='Back to Companies').click()
    page.wait_for_timeout(2000)
    check('back to companies', 'Outsource Companies' in page.locator('.page-title').inner_text())

    # 9 — AR / RTL round trip (shell persists language: MUST restore EN)
    page.locator('.lang-pill button', has_text='ع').click()
    page.wait_for_timeout(2500)
    check('RTL applied', page.evaluate("document.documentElement.dir || document.dir") == 'rtl'
          or page.locator('html[dir=rtl]').count() == 1)
    ar_title = page.locator('.page-title').inner_text()
    check('AR title rendered', any('؀' <= ch <= 'ۿ' for ch in ar_title), ar_title)
    page.screenshot(path=EV + '06_ar_rtl.png', full_page=True)
    page.locator('.lang-pill button', has_text='EN').click()
    page.wait_for_timeout(2000)
    check('EN restored', page.locator('.page-title').inner_text() != ar_title)

    check('no page JS errors', len(errors) == 0, '; '.join(errors[:3]))
    b.close()

print('\n%d/%d PASS' % (sum(1 for _, ok in results if ok), len(results)))
sys.exit(0 if all(ok for _, ok in results) else 1)
