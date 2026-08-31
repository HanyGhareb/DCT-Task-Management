#!/usr/bin/env python3
"""GL Report Recipients — Excel import PARSE smoke against the REAL workbook
(docs/Approval/Sectors  Departments Email list for 2026-FPB and PBP.xlsx).

Loads the file into the import drawer and asserts sheet detection, scope-kind
detection (Departments -> COSTCENTER, Sectors -> SECTOR), email-column
discovery w/ To/Cc defaults, Active-only filtering and the ready-row count.
The IMPORT BUTTON IS NEVER CLICKED — parsing only, nothing is written.

Run: python dev-proxy.py 8213 (from GL/Jet) then GL_TOK=... python gs_import_parse_smoke.py
"""
import json
import os
import sys

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8213')
XLSX = os.environ.get('GS_XLSX',
    '/root/DCT-Task-Management/docs/Approval/Sectors  Departments Email list for 2026-FPB and PBP.xlsx')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_gs_evidence/')
os.makedirs(EV, exist_ok=True)
TOK = os.environ.get('GL_TOK') or sys.exit('Set GL_TOK')
sess = {'sessionId': TOK, 'userId': 1, 'username': 'ADMIN',
        'displayName': 'System Administrator', 'rolesCsv': 'SYS_ADMIN',
        'roles': ['SYS_ADMIN']}

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                           timeout=60000)
    page.wait_for_timeout(2500)

    page.locator('.pnav--grp a', has_text='Settings').click()
    page.wait_for_timeout(600)
    page.locator('.pnav--sub a', has_text='Report Recipients').click()
    page.wait_for_selector('#pg-recipients', timeout=15000)
    page.locator('#pg-recipients .page-actions .btn', has_text='Import from Excel').click()
    page.wait_for_selector('.dw-rl.show', timeout=15000)

    page.set_input_files('#rc-imp-file', XLSX)
    page.wait_for_function(
        "() => { const vm = ko.dataFor(document.body); return vm.rlImpSheets().length > 0; }",
        timeout=60000)
    vm_state = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      return { sheets: vm.rlImpSheets().length, sheet: vm.rlImpSheet(),
               kind: vm.rlImpKind(), cols: vm.rlImpCols().map(c => [c.label, c.disp()]),
               ready: vm.rlImpRows(), hasStatus: vm.rlImpHasStatus(), err: vm.rlImpErr() }; }""")
    check('workbook parsed, no error', not vm_state['err'], vm_state['err'])
    check('16 sheets listed', vm_state['sheets'] == 16, vm_state['sheets'])
    check('Departments sheet auto-preferred', 'department' in vm_state['sheet'].lower(),
          vm_state['sheet'])
    check('scope kind COSTCENTER', vm_state['kind'] == 'COSTCENTER')
    check('email columns discovered', len(vm_state['cols']) >= 4, str(vm_state['cols']))
    to_cols = [c for c in vm_state['cols'] if c[1] == 'TO']
    cc_cols = [c for c in vm_state['cols'] if c[1] == 'CC']
    check('PBP/FBP default TO', any('pbp' in c[0].lower() or 'fbp' in c[0].lower()
                                    for c in to_cols), str(to_cols))
    check('Director/Key Users default CC', len(cc_cols) >= 1, str(cc_cols))
    check('CC-status column detected', vm_state['hasStatus'])
    check('Active-only ready rows plausible (30-70)', 30 <= vm_state['ready'] <= 70,
          vm_state['ready'])

    # flip Active-only off -> more rows
    page.evaluate("ko.dataFor(document.body).rlImpActive(false)")
    page.wait_for_timeout(400)
    all_rows = page.evaluate("() => ko.dataFor(document.body).rlImpRows()")
    check('all-rows > active-rows', all_rows > vm_state['ready'], (all_rows, vm_state['ready']))
    page.evaluate("ko.dataFor(document.body).rlImpActive(true)")

    # switch to the Sectors sheet -> SECTOR kind
    page.evaluate("ko.dataFor(document.body).rlImpSheet('Sectors')")
    page.wait_for_timeout(800)
    sec_state = page.evaluate("""() => {
      const vm = ko.dataFor(document.body);
      return { kind: vm.rlImpKind(), ready: vm.rlImpRows(),
               cols: vm.rlImpCols().map(c => [c.label, c.disp()]), err: vm.rlImpErr() }; }""")
    check('Sectors sheet -> SECTOR kind', sec_state['kind'] == 'SECTOR', str(sec_state))
    check('sector rows ~7', 5 <= sec_state['ready'] <= 9, sec_state['ready'])
    check('ED/BP email columns found', len(sec_state['cols']) >= 2, str(sec_state['cols']))
    page.screenshot(path=EV + '09_import_parse.png')
    check('no JS errors', not errors, '; '.join(errors[:3]))
    b.close()

passed = sum(1 for _, okk in results if okk)
print('\n== RESULT: %d/%d passed ==' % (passed, len(results)))
sys.exit(0 if passed == len(results) else 1)
