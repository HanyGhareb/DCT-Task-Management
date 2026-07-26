# AR Invoice Rebill page (App 206) browser smoke — Playwright over dev-proxy.
# Start nothing: this script launches its own proxy on PORT.
# READ-ONLY against PROD: it parses a workbook and opens drawers but NEVER
# clicks Submit — every enqueue would create a real Fusion write-back request.
import json
import os
import re
import subprocess
import sys
import time
import urllib.request

from playwright.sync_api import sync_playwright

PORT = 8127
BASE = 'http://localhost:%d' % PORT
HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
EV = os.environ.get('REBILL_EVIDENCE', '/tmp/rebill_evidence') + '/'
os.makedirs(EV, exist_ok=True)

src = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'),
           encoding='utf-8').read()
USER, PASS = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]
req = urllib.request.Request(ADB + '/dct/auth/login',
    data=json.dumps({'username': USER, 'password': PASS}).encode(),
    headers={'Content-Type': 'application/json'})
sess = json.loads(urllib.request.urlopen(req, timeout=60).read())
sess['roles'] = (sess.get('rolesCsv') or '').split(',')

# ---- build the flat test workbook: 1 ready + 1 already-done + 1 bad row ----
import openpyxl                                                    # noqa: E402
WB = '/tmp/rebill_smoke_upload.xlsx'
wb = openpyxl.Workbook()
ws = wb.active
ws.append(['Invoice Number', 'Memo Line', 'Project Number', 'Task',
           'VAT Rate Code', 'CM Number', 'New Invoice Number'])
ws.append(['INV00583821', 'Event Permit', '4511000037', 'Event Permit',
           'VAT OUTPUT - OSC', '', ''])
ws.append(['INV00583821', 'Revenue fees from Urgent request', '4511000037',
           'Urgent requests', 'VAT OUTPUT - STD', '', ''])
ws.append(['INV00583744', 'Event Permit', '4511000037', 'Event Permit',
           'VAT OUTPUT - OSC', '45110096153', '45110096154'])       # done
ws.append(['INV00599999', 'Broken Row', '', '', 'VAT OUTPUT - STD', '', ''])  # bad
wb.save(WB)

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


proxy = subprocess.Popen([sys.executable, 'dev-proxy.py', str(PORT)], cwd=JET,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(3)
try:
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True,
                              args=['--no-sandbox', '--disable-dev-shm-usage'])
        ctx = b.new_context(viewport={'width': 1600, 'height': 1000},
                            accept_downloads=True)
        page = ctx.new_page()
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)))

        # seed the session BEFORE any app script runs — the app redirects to
        # Admin when it finds no session, which can destroy the evaluate's
        # execution context mid-call
        ctx.add_init_script("localStorage.setItem('ifinance_jet_session', "
                            + json.dumps(json.dumps(sess)) + ")")
        page.goto(BASE + '/index.html')
        page.wait_for_load_state('networkidle')
        page.wait_for_function('() => !!window._arApp', timeout=30000)

        # ---- EN pass -----------------------------------------------------
        page.evaluate("() => window._arApp.navigate('arRebill')")
        page.wait_for_selector('.page-title', timeout=20000)
        page.wait_for_timeout(2500)
        check('rebill page opens', 'Rebill' in page.locator('.page-title').inner_text())

        # single form: line grid has NO required line number any more
        heads = [h.strip() for h in
                 page.locator('.card').first.locator('.data-table thead th').all_inner_texts()]
        check('line grid: Line column marked optional',
              any('optional' in h.lower() for h in heads), '|'.join(heads))

        # bulk defaults (date + reason + finish) are on the page
        check('bulk defaults: date input',
              page.locator('input[type="date"]').count() >= 5)
        check('bulk defaults: finish select', page.locator('select').count() >= 3)

        # ---- flat template download --------------------------------------
        with page.expect_download(timeout=30000) as dl:
            page.locator('.page-actions .btn', has_text='template').first.click()
        d = dl.value
        tpl = '/tmp/rebill_smoke_template.xlsx'
        d.save_as(tpl)
        twb = openpyxl.load_workbook(tpl)
        tws = twb[twb.sheetnames[0]]
        hdr = [c.value for c in next(tws.iter_rows(max_row=1))]
        check('template is ONE flat sheet', len(twb.sheetnames) == 1,
              str(twb.sheetnames))
        check('template headers match the agreed format',
              hdr == ['Invoice Number', 'Memo Line', 'Project Number', 'Task',
                      'VAT Rate Code', 'CM Number', 'New Invoice Number',
                      'CM_TXN_NO', 'CM_TXN_DATE', 'CM_ACCT_DATE',
                      'CREDIT_REASON', 'COMMENTS', 'CM_FINISH',
                      'DUP_SOURCE', 'DUP_TXN_DATE', 'DUP_ACCT_DATE'], str(hdr))

        # ---- bulk parse: ready / done-skipped / error --------------------
        with page.expect_file_chooser() as fc:
            page.locator('.btn', has_text='Choose file').first.click()
        fc.value.set_files(WB)
        page.wait_for_timeout(2500)
        badges = page.locator('.card', has_text='Bulk upload').locator('.badge').all_inner_texts()
        btxt = ' | '.join(badges)
        check('1 invoice ready', any('1 ready' in x for x in badges), btxt)
        check('1 already done (skipped)', any('skipped' in x for x in badges), btxt)
        check('1 with errors', any('error' in x for x in badges), btxt)
        rows = page.locator('.card', has_text='Bulk upload').locator('tbody tr')
        check('3 invoices in the preview', rows.count() == 3, str(rows.count()))
        page.screenshot(path=EV + '01_bulk_parse_en.png', full_page=True)
        # NOTE: Submit deliberately NOT clicked — enqueues are real.

        # ---- register: shared interactive report -------------------------
        reg_rows = page.locator('.ir-table tbody tr')
        try:
            reg_rows.first.wait_for(state='visible', timeout=25000)
        except Exception:
            pass
        n = reg_rows.count()
        check('IR register renders request rows', n > 0, str(n))
        # the DONE rows sit beyond page 1 (register is newest-first), so use
        # the component's own global search to reach one — proving the search
        # AND the document-number data in one move
        srch = page.locator('.ir-wrap input').first
        srch.fill('45110096')
        page.wait_for_timeout(1200)
        body = page.locator('.ir-table').inner_text()
        check('IR search finds the CM document numbers',
              '45110096' in body and page.locator('.ir-table tbody tr').count() > 0)
        # row click while the search shows DONE rows — a fresh 0/9 request has
        # an EMPTY timeline, so the assertion needs a completed one
        page.locator('.ir-table tbody tr').first.locator('td').nth(1).click()
        page.wait_for_timeout(2500)
        check('timeline DRAWER slides in on IR row click',
              page.locator('.ed-drawer.ed-show').count() == 1)
        try:
            page.locator('.ed-drawer.ed-show').get_by_text('LOCATE').first.wait_for(timeout=12000)
            tl_ok = True
        except Exception:
            tl_ok = False
        check('drawer shows the stage timeline', tl_ok)
        check('read-only drawer: Close only, no Save',
              page.locator('.ed-drawer.ed-show .region-actions .btn').count() == 1)
        page.screenshot(path=EV + '02_timeline_en.png', full_page=True)
        page.locator('.ed-drawer.ed-show .region-actions .btn').click()
        page.wait_for_timeout(900)
        check('drawer closes', page.locator('.ed-drawer.ed-show').count() == 0)
        srch.fill('')
        page.wait_for_timeout(1200)
        mx = page.locator('.ir-wrap button[title*="Maximize"]')
        check('IR maximize button present', mx.count() == 1, str(mx.count()))
        mx.click()
        page.wait_for_timeout(800)
        check('maximize applies .ir-max', page.locator('.ir-wrap.ir-max').count() == 1)
        page.screenshot(path=EV + '04_ir_maximized.png')
        page.keyboard.press('Escape')
        page.wait_for_timeout(800)
        check('Esc restores from maximize', page.locator('.ir-wrap.ir-max').count() == 0)

        # ---- AR / RTL pass -----------------------------------------------
        page.locator('button:text-is("ع")').last.click()
        page.wait_for_timeout(2500)
        check('RTL applied', page.evaluate("() => document.documentElement.dir") == 'rtl')
        t_ar = page.locator('.page-title').inner_text()
        check('AR title translated', t_ar and 'Rebill' not in t_ar, t_ar)
        page.screenshot(path=EV + '03_rebill_ar.png', full_page=True)
        # restore EN — the shell persists the language to the account's prefs
        page.locator('button:text-is("EN")').last.click()
        page.wait_for_timeout(2000)
        check('restored EN', page.evaluate("() => document.documentElement.dir") == 'ltr')

        check('no page errors', not errors, '; '.join(errors[:3]))
        b.close()
finally:
    proxy.terminate()

fails = [n for n, okk in results if not okk]
print('\n%d/%d passed' % (len(results) - len(fails), len(results)))
sys.exit(1 if fails else 0)
