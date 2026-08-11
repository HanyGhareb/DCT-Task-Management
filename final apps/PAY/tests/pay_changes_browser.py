#!/usr/bin/env python3
"""PAY Module (App 215) — Employee Change Control browser smoke (EN + AR/RTL).

v2 — covers the enhancement round (variance flags, justification notes,
evidence, WORKFLOW sign-off, briefing report) on top of the original page:
KPI band incl. Flagged, amber flagged rows + chips, note-required guard on
HR confirm, prompt-based note editor, evidence attach (file chooser),
dual confirm -> Submit for sign-off -> IN_APPROVAL -> (tasks approved via
/wf/ API) -> CONFIRMED with chain-stamped sign-offs, all-values tab,
baseline + empty states, run-console readiness chip, AR/RTL round trip.

Precondition (set up by the runner): Dayton 11-2025 BASELINE captured on
CLEAN data, then the ENH mutations applied (gross 397 45738->60000, job
title 398, bank row 397), then 12-2025 captured => register OPEN with 4
changes (3 flagged, 2 bank items needing a note). CHG_SIGNOFF_MODE=WORKFLOW.

Auth env: PAY_TOK (live session token, SYS_ADMIN + PAY_* roles for /wf/).
Run: python dev-proxy.py 8217 (from PAY/Jet) then python pay_changes_browser.py
"""
import json, os, sys, urllib.request
from playwright.sync_api import sync_playwright

BASE = os.environ.get('PAY_BASE', 'http://localhost:8217')
ORDS = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
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

def api(method, path, body=None):
    req = urllib.request.Request(ORDS + path, method=method)
    req.add_header('Authorization', 'Bearer ' + TOK)
    data = None
    if body is not None:
        data = json.dumps(body).encode()
        req.add_header('Content-Type', 'application/json')
    try:
        with urllib.request.urlopen(req, data) as r:
            return r.status, json.loads(r.read().decode() or '{}')
    except urllib.error.HTTPError as e:
        return e.code, {}

results = []
def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)

prompt_text = {'v': ''}

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1000})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    page.on('dialog', lambda d: d.accept(prompt_text['v']) if d.type == 'prompt' else d.accept())

    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')

    # 1 — nav + page + Dayton 12-2025
    check('nav Employee Changes', page.locator('.nav-item', has_text='Employee Changes').count() == 1)
    page.evaluate("window._jetApp.navigate('payChanges')")
    page.wait_for_timeout(3000)
    check('page title', 'Employee Change Control' in page.locator('.page-title').inner_text())
    page.locator('.ap-chips select').first.select_option('2')
    page.wait_for_timeout(2000)
    page.locator('.ap-chips select').nth(1).select_option('12-2025')
    page.wait_for_timeout(2500)

    # 2 — head: OPEN, KPIs incl. flagged, workflow mode (no inline sign buttons)
    check('status pill Open', page.locator('.chg-pill--open').count() >= 1)
    kpis = page.locator('.pr-k .pr-k-v').all_inner_texts()
    check('KPI in scope 25', '25' in kpis, str(kpis))
    check('KPI changes 4', '4' in kpis, str(kpis))
    check('KPI flagged 3', '3' in kpis, str(kpis))
    check('tracker two sides', page.locator('.chg-side').count() == 2)
    check('no inline sign buttons (workflow mode)',
          page.locator('.chg-side button').count() == 0)
    check('report buttons', page.locator('.page-actions button', has_text='Report PDF').count() == 1)
    page.screenshot(path=EV + 'e01_register_flags.png', full_page=True)

    # 3 — flagged rows + chips + note-required
    check('2 employee groups', page.locator('.chg-emp').count() == 2)
    check('3 amber flagged rows', page.locator('.chg-row--flag').count() == 3)
    check('flag chips render', page.locator('.chg-flag').count() >= 3)
    check('2 note-required warnings', page.locator('.chg-notereq').count() == 2)

    # 4 — flagged-only filter narrows to 3
    page.locator('.ap-chips input[type=checkbox]').first.check()
    page.wait_for_timeout(1800)
    rows = page.locator('.chg-table tbody tr').count() - page.locator('.chg-emp').count()
    check('flagged-only 3 rows', rows == 3, str(rows))
    page.locator('.ap-chips input[type=checkbox]').first.uncheck()
    page.wait_for_timeout(1800)

    # 5 — HR confirm-all blocked while notes missing
    page.locator('.region-actions button', has_text='Confirm all (HR)').evaluate('el => el.click()')
    page.wait_for_timeout(2000)
    check('confirm blocked, note error', 'note' in (page.locator('.dw-err').inner_text()
          if page.locator('.dw-err').count() else ''),
          page.locator('.dw-err').inner_text() if page.locator('.dw-err').count() else 'no err')

    # 6 — add notes via the prompt editor on both bank rows
    prompt_text['v'] = 'IBAN letter received from the employee'
    for _ in range(2):
        page.locator('.chg-notereq').first.locator('xpath=..').locator('a', has_text='add note') \
            .first.evaluate('el => el.click()')
        page.wait_for_timeout(2000)
    check('notes saved, warnings gone', page.locator('.chg-notereq').count() == 0
          and page.locator('.chg-note').count() == 2)

    # 7 — attach evidence on a bank row (file chooser)
    ev_file = EV + 'iban_letter.txt'
    with open(ev_file, 'w') as f:
        f.write('evidence: bank letter')
    with page.expect_file_chooser() as fc:
        page.locator('.chg-row--flag a', has_text='attach').first.evaluate('el => el.click()')
    fc.value.set_files(ev_file)
    page.wait_for_timeout(2500)
    check('evidence count chip', page.locator('a', has_text='📎 1').count() == 1)
    page.screenshot(path=EV + 'e02_notes_evidence.png', full_page=True)

    # 8 — dual confirm-all, then Submit for sign-off
    page.locator('.region-actions button', has_text='Confirm all (HR)').evaluate('el => el.click()')
    page.wait_for_timeout(2200)
    check('HR 4/4', '4 / 4' in page.locator('.chg-side').first.inner_text())
    page.locator('.region-actions button', has_text='Confirm all (Payroll)').evaluate('el => el.click()')
    page.wait_for_timeout(2200)
    check('PAY 4/4', '4 / 4' in page.locator('.chg-side').nth(1).inner_text())
    sub = page.locator('.chg-wf button', has_text='Submit for sign-off')
    check('submit button enabled', sub.count() == 1 and sub.is_enabled())
    sub.evaluate('el => el.click()')
    page.wait_for_timeout(2500)
    check('IN_APPROVAL pill', page.locator('.chg-pill--in_approval').count() >= 1)
    check('in-approval note', 'approval workflow' in page.locator('.chg-wf').inner_text())
    page.screenshot(path=EV + 'e03_in_approval.png', full_page=True)

    # 9 — approve both workflow tasks via /wf/, page shows CONFIRMED
    for _ in range(2):
        s, d = api('GET', '/wf/worklist')
        task = next((t for t in d.get('items', []) if t.get('module') == 'PAY'), None)
        if task:
            api('POST', f'/wf/tasks/{task["id"]}/action', {'outcome': 'APPROVE', 'comments': 'browser smoke'})
            page.wait_for_timeout(1500)
    page.locator('.ap-chips select').nth(1).select_option('11-2025')
    page.wait_for_timeout(1500)
    page.locator('.ap-chips select').nth(1).select_option('12-2025')
    page.wait_for_timeout(2500)
    check('CONFIRMED after workflow', page.locator('.chg-pill--confirmed').count() >= 1)
    check('both sides signed by chain', page.locator('.chg-side--done').count() == 2
          and page.locator('.chg-signed').count() == 2)
    page.screenshot(path=EV + 'e04_confirmed_wf.png', full_page=True)

    # 10 — all-values tab + changed-only
    page.locator('.chg-tab', has_text='All values').click()
    page.wait_for_timeout(2500)
    check('IR renders', page.locator('.ir-table').count() == 1)
    page.locator('input[type=checkbox]').first.check()
    page.wait_for_timeout(2000)
    check('changed-only 4 rows', page.locator('.ir-table tbody tr').count() == 4)
    page.locator('input[type=checkbox]').first.uncheck()
    page.wait_for_timeout(1200)
    page.locator('.chg-tab', has_text='Changes').first.click()
    page.wait_for_timeout(1200)

    # 11 — baseline + empty states
    page.locator('.ap-chips select').nth(1).select_option('11-2025')
    page.wait_for_timeout(2200)
    check('baseline pill', page.locator('.chg-pill--baseline').count() >= 1)
    page.locator('.ap-chips select').nth(1).select_option('10-2025')
    page.wait_for_timeout(2200)
    check('empty state', 'No change register' in page.locator('.ap-region').first.inner_text())

    # 12 — run-console readiness chip (confirmed via workflow)
    page.evaluate("window._jetApp.navigate('payRuns')")
    page.wait_for_timeout(3000)
    page.locator('.ap-chips select').first.select_option('2')
    page.wait_for_timeout(2000)
    page.locator('.ap-chips select').nth(1).select_option('12-2025')
    page.wait_for_timeout(2500)
    chip = page.locator('.chg-chip')
    check('runs chip confirmed', chip.count() == 1 and 'Confirmed' in chip.inner_text(),
          chip.inner_text() if chip.count() else '')
    chip.evaluate('el => el.click()')
    page.wait_for_timeout(3000)
    check('chip deep-links', 'Employee Change Control' in page.locator('.page-title').inner_text())

    # 13 — AR/RTL round trip (restore EN — the shell persists language)
    page.locator('.lang-pill button', has_text='ع').click()
    page.wait_for_timeout(2500)
    check('RTL applied', page.evaluate("document.documentElement.dir || document.dir") == 'rtl'
          or page.locator('html[dir=rtl]').count() == 1)
    check('AR title', 'ضبط تغييرات الموظفين' in page.locator('.page-title').inner_text())
    page.screenshot(path=EV + 'e05_ar_rtl.png', full_page=True)
    page.locator('.lang-pill button', has_text='EN').click()
    page.wait_for_timeout(2000)
    check('EN restored', 'Employee Change Control' in page.locator('.page-title').inner_text())

    check('no page errors', not errors, '; '.join(errors[:3]))

    b.close()

passed = sum(1 for _, ok in results if ok)
print(f'\nRESULT: {passed}/{len(results)} passed')
sys.exit(0 if passed == len(results) else 1)
