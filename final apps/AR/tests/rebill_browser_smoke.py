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

        page.goto(BASE + '/index.html')
        page.evaluate("s => localStorage.setItem('ifinance_jet_session',"
                      " JSON.stringify(s))", sess)
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
                      'VAT Rate Code', 'CM Number', 'New Invoice Number'], str(hdr))

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

        # ---- register + timeline -----------------------------------------
        reg = page.locator('.card', has_text='Requests')
        reg_rows = page.locator('.card').last.locator('tbody tr')
        try:
            reg_rows.first.wait_for(state='visible', timeout=20000)
        except Exception:
            pass
        n = reg_rows.count()
        check('register shows requests', n > 0, str(n))
        body = page.locator('.card').last.inner_text()
        check('register carries a CM document number', '4511009' in body or '4510025' in body)
        if n:
            reg_rows.first.click()
            page.wait_for_timeout(2500)
            check('stage timeline opens on row click',
                  page.locator('text=LOCATE').count() >= 1)
            page.screenshot(path=EV + '02_timeline_en.png', full_page=True)
            # the platform modal backdrop traps Playwright's hit-test — fire
            # the bound close handler directly, then PROVE the overlay is gone
            page.evaluate("() => { const o = document.querySelector('.modal-overlay');"
                          " if (o) o.click(); }")
            page.wait_for_selector('.modal-overlay', state='detached', timeout=10000)

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
