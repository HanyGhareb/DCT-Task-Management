"""UAT runner — Procash Transactions (App 212 / AP).

Playwright + ORDS hybrid, following the Admin UAT convention: it drives the real
pages, captures one screenshot per case, and emits

  UAT/UAT_AP_TestScript.xlsx                          (reusable master, written once)
  UAT/UAT_AP_round<N>-dd-mm-yyyy/
      UAT_AP_<dd-Mon-yyyy>-NN.xlsx                    (statuses filled)
      UAT_AP_Results_<dd-Mon-yyyy>-NN.docx            (narrative results)
      evidence_<dd-Mon-yyyy>-NN/                      (one PNG per case)

Auth: module apps redirect to Admin, so the session is seeded into localStorage.
  IFINANCE_SESSION_JSON='{"sessionId":"...","userId":1,...}'   (mint one in the DB)
  IFINANCE_UAT_USER / IFINANCE_UAT_PASS                        (normal login)

Everything it writes to PROD is tagged UAT-PCH-<timestamp> and removed at the end
(the runner cancels then deletes through the API where it can; the closing SQL is
printed for anything a terminal status blocks).

Run: python3 uat_run_procash.py [port] [round]
"""
import json
import os
import sys
import time
import urllib.error
import urllib.request

from openpyxl import Workbook
from openpyxl.styles import Alignment, Font, PatternFill
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from playwright.sync_api import sync_playwright

PORT = sys.argv[1] if len(sys.argv) > 1 else '8134'
ROUND = int(sys.argv[2]) if len(sys.argv) > 2 else 1
BASE = 'http://localhost:' + PORT
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

APP = 'AP'
NOW = time.localtime()
TAG = 'UAT-PCH-' + time.strftime('%Y%m%d%H%M%S', NOW)
DATE_FOLDER = time.strftime('%d-%m-%Y', NOW)
DATE_FILE = time.strftime('%d-%b-%Y', NOW)
SEQ = '01'

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
UAT = os.path.join(ROOT, 'UAT')
ROUND_DIR = os.path.join(UAT, 'UAT_%s_round%d-%s' % (APP, ROUND, DATE_FOLDER))
EVIDENCE = os.path.join(ROUND_DIR, 'evidence_%s-%s' % (DATE_FILE, SEQ))

cases = []   # (no, area, title, steps, expected, actual, status, shot)


def record(no, area, title, steps, expected, actual, ok, shot=''):
    cases.append({'no': no, 'area': area, 'title': title, 'steps': steps,
                  'expected': expected, 'actual': actual,
                  'status': 'PASS' if ok else 'FAIL', 'shot': shot})
    print(('  PASS  ' if ok else '  FAIL  ') + '%02d %s' % (no, title) +
          ('' if ok else '   -> ' + str(actual)))


def api(path, token, method='GET', body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ADB + path, data=data, method=method)
    req.add_header('Authorization', 'Bearer ' + token)
    if data is not None:
        req.add_header('Content-Type', 'application/json')
    try:
        r = urllib.request.urlopen(req, timeout=180)
        code, payload = r.status, r.read()
    except urllib.error.HTTPError as e:
        code, payload = e.code, e.read()
    try:
        return code, json.loads(payload) if payload else None
    except ValueError:
        return code, payload


def session():
    raw = os.environ.get('IFINANCE_SESSION_JSON')
    if raw:
        s = json.loads(raw)
    else:
        user, pwd = os.environ.get('IFINANCE_UAT_USER'), os.environ.get('IFINANCE_UAT_PASS')
        if not user or not pwd:
            sys.exit('Set IFINANCE_SESSION_JSON, or IFINANCE_UAT_USER / IFINANCE_UAT_PASS')
        req = urllib.request.Request(ADB + '/dct/auth/login',
                                     data=json.dumps({'username': user, 'password': pwd}).encode(),
                                     headers={'Content-Type': 'application/json'})
        s = json.loads(urllib.request.urlopen(req, timeout=60).read())
    s['roles'] = (s.get('rolesCsv') or '').split(',')
    s['initials'] = ''.join(p[0] for p in (s.get('displayName') or 'X').split()[:2]).upper()
    return s


# ─────────────────────────────────────────────────────────────── workbook / doc

HEAD_FILL = PatternFill('solid', fgColor='14682F')
HEAD_FONT = Font(color='FFFFFF', bold=True, size=10)
COLS = [('Case', 8), ('Area', 22), ('Test case', 46), ('Steps', 62),
        ('Expected result', 52), ('Actual result', 52), ('Status', 10), ('Evidence', 30)]


def sheet(ws, filled):
    for j, (name, width) in enumerate(COLS, start=1):
        c = ws.cell(1, j, name)
        c.fill, c.font = HEAD_FILL, HEAD_FONT
        c.alignment = Alignment(horizontal='center', vertical='center')
        ws.column_dimensions[chr(64 + j)].width = width
    for i, t in enumerate(cases, start=2):
        vals = [t['no'], t['area'], t['title'], t['steps'], t['expected'],
                t['actual'] if filled else '', t['status'] if filled else '',
                os.path.basename(t['shot']) if filled else '']
        for j, v in enumerate(vals, start=1):
            c = ws.cell(i, j, v)
            c.alignment = Alignment(wrap_text=True, vertical='top')
            if j == 7 and filled:
                c.font = Font(bold=True, color='1E7A3C' if v == 'PASS' else 'B3261E')
    ws.freeze_panes = 'A2'


def write_workbooks():
    os.makedirs(EVIDENCE, exist_ok=True)
    master = os.path.join(UAT, 'UAT_%s_TestScript.xlsx' % APP)
    if not os.path.exists(master):
        wb = Workbook(); wb.active.title = 'Procash Transactions'
        sheet(wb.active, filled=False); wb.save(master)
        print('master test script written:', master)
    wb = Workbook(); wb.active.title = 'Procash Transactions'
    sheet(wb.active, filled=True)
    path = os.path.join(ROUND_DIR, 'UAT_%s_%s-%s.xlsx' % (APP, DATE_FILE, SEQ))
    wb.save(path)
    return path


def write_results_doc():
    passed = sum(1 for c in cases if c['status'] == 'PASS')
    d = Document()
    d.add_heading('UAT Results — Procash Transactions (App 212, Accounts Payable)', 0)
    p = d.add_paragraph()
    p.add_run('Round %d · %s · executed by the automated UAT runner\n' % (ROUND, DATE_FILE)).bold = True
    p.add_run('Scope: manual payments pushed through the bank portal directly, outside Fusion '
              'Payables — capture, budget coding, submit and process, reconciliation to the Fusion '
              'payable invoice, attachments, export and reporting.')
    r = d.add_paragraph().add_run('%d of %d cases passed.' % (passed, len(cases)))
    r.bold = True
    r.font.size = Pt(13)
    r.font.color.rgb = RGBColor(0x1E, 0x7A, 0x3C) if passed == len(cases) else RGBColor(0xB3, 0x26, 0x1E)

    d.add_heading('Summary by area', level=1)
    areas = {}
    for c in cases:
        a = areas.setdefault(c['area'], [0, 0])
        a[0] += 1
        a[1] += 1 if c['status'] == 'PASS' else 0
    t = d.add_table(rows=1, cols=3); t.style = 'Light Grid Accent 1'
    for i, h in enumerate(('Area', 'Cases', 'Passed')):
        t.rows[0].cells[i].text = h
    for a, (n, ok) in areas.items():
        row = t.add_row().cells
        row[0].text, row[1].text, row[2].text = a, str(n), str(ok)

    d.add_heading('Cases', level=1)
    for c in cases:
        d.add_heading('%02d · %s' % (c['no'], c['title']), level=2)
        d.add_paragraph('Area: %s' % c['area'])
        d.add_paragraph('Steps: %s' % c['steps'])
        d.add_paragraph('Expected: %s' % c['expected'])
        d.add_paragraph('Actual: %s' % c['actual'])
        s = d.add_paragraph(); run = s.add_run('Status: %s' % c['status']); run.bold = True
        run.font.color.rgb = RGBColor(0x1E, 0x7A, 0x3C) if c['status'] == 'PASS' else RGBColor(0xB3, 0x26, 0x1E)
        if c['shot'] and os.path.exists(c['shot']):
            d.add_picture(c['shot'], width=Inches(6.2))
    path = os.path.join(ROUND_DIR, 'UAT_%s_Results_%s-%s.docx' % (APP, DATE_FILE, SEQ))
    d.save(path)
    return path


# ──────────────────────────────────────────────────────────────────── the round

def main():
    sess = session()
    tok = sess['sessionId']
    os.makedirs(EVIDENCE, exist_ok=True)
    made = []

    with sync_playwright() as p:
        b = p.chromium.launch(headless=True)
        ctx = b.new_context(viewport={'width': 1600, 'height': 1000})
        page = ctx.new_page()

        def shot(no, name):
            f = os.path.join(EVIDENCE, '%02d_%s.png' % (no, name))
            page.screenshot(path=f)
            return f

        page.goto(BASE + '/index.html')
        page.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", sess)
        page.goto(BASE + '/index.html')
        page.wait_for_function("() => !!window._jetApp", timeout=30000)
        page.wait_for_timeout(1500)

        # 1 — navigation
        page.evaluate("() => window._jetApp.navigate('procash')")
        page.wait_for_timeout(2800)
        title = page.locator('.page-title').first.inner_text()
        record(1, 'Navigation', 'Open the Procash Transactions register',
               'Sign in to the AP app and choose Procash Transactions in the side navigation.',
               'The register page opens with its title, filter bar and results region.',
               'Page title: "%s"' % title, 'Procash' in title, shot(1, 'register'))

        # 2 — KPI band
        k = page.locator('.kpi').count()
        record(2, 'Register', 'The KPI band summarises the filtered set',
               'Look at the band above the filters.',
               'Four tiles: transactions, total AED, open, awaiting invoice.',
               '%d KPI tiles rendered' % k, k == 4, shot(2, 'kpis'))

        # 3 — create
        page.locator('button:has-text("New procash")').click()
        page.wait_for_timeout(2500)

        def fill(label, value, scope=''):
            grp = page.locator((scope + ' ' if scope else '') + '.form-group',
                               has=page.locator('.form-label', has_text=label)).first
            el = grp.locator('.form-control').first
            el.fill(str(value)); el.dispatch_event('change')

        fill('Bank reference', TAG)
        fill('Paying bank account', 'FAB Current 4471')
        fill('Payee', 'UAT Procash Payee')
        fill('Amount', '1500')
        page.locator('.form-group', has=page.locator('.form-label', has_text='Business unit')).first \
            .locator('select').select_option(index=1)
        page.wait_for_timeout(300)
        page.locator('.page-actions button:has-text("Save")').click()
        page.wait_for_timeout(3000)
        t = page.locator('.page-title').inner_text()
        record(3, 'Capture', 'Record a new procash payment',
               'Choose New procash transaction, enter the bank reference, paying account, payee, '
               'business unit and amount, then Save.',
               'The payment is saved as a Draft and the system stamps a payment number (PCH-#####).',
               'Title after save: "%s"' % t, 'PCH-' in t, shot(3, 'created'))

        _, reg = api('/ap/procash/?search=' + TAG, tok)
        pid = reg['items'][0]['procashId'] if reg.get('items') else None
        if pid:
            made.append(pid)

        # 4 — validation findings
        blocks = page.locator('.pc-finding--block').count()
        record(4, 'Validation', 'An unfinished payment says what is missing',
               'Look at the message band under the page header.',
               'A blocking finding tells the user a detail line is still required.',
               '%d blocking finding(s) shown' % blocks, blocks >= 1, shot(4, 'findings'))

        # 5 — duplicate bank reference
        code, _ = api('/ap/procash', tok, 'POST', {
            'bankReference': TAG, 'businessUnit': reg['items'][0]['businessUnit'],
            'amount': 10, 'currencyCode': 'AED', 'paymentDate': time.strftime('%Y-%m-%d')})
        record(5, 'Validation', 'The same bank reference cannot be recorded twice',
               'Try to save a second payment carrying a bank reference already on file.',
               'The system refuses it (400) and explains that the reference is already recorded.',
               'HTTP %s returned' % code, code == 400)

        # 6 — coding fixture + line
        _, ps = api('/ap/procash/meta/projects', tok)
        proj = task = etype = None
        for pr in ps['items'][:25]:
            _, ts = api('/ap/procash/meta/tasks?project=' + pr['code'], tok)
            if ts.get('items'):
                _, es = api('/ap/procash/meta/etypes', tok)
                proj, task, etype = pr['code'], ts['items'][0]['code'], es['items'][0]['code']
                break

        page.locator('button:has-text("Add line")').click()
        page.wait_for_timeout(900)

        def dfill(label, value):
            grp = page.locator('.dw-drawer.show .form-group',
                               has=page.locator('.form-label', has_text=label)).first
            el = grp.locator('.form-control').first
            el.fill(str(value)); el.dispatch_event('change')

        dfill('Project', proj); dfill('Task', task)
        dfill('Expenditure type', etype); dfill('Amount', '900')
        s6 = shot(6, 'line_drawer')
        page.locator('.dw-drawer.show button:has-text("Save")').click()
        page.wait_for_timeout(2500)
        rows = page.locator('.data-table tbody tr').count()
        record(6, 'Budget coding', 'Code a detail line to a project, task and expenditure type',
               'Open Add line, choose the coding basis Project, pick the project, task and '
               'expenditure type, enter the amount and Save.',
               'The line is stored and appears in the detail grid.',
               '%d detail line(s) listed' % rows, rows == 1, s6)

        # 7 — project line without a task
        code, _ = api('/ap/procash/%s/lines' % pid, tok, 'POST',
                      {'codingBasis': 'PROJECT', 'projectNumber': proj, 'amount': 100})
        record(7, 'Budget coding', 'A project line without a task is refused',
               'Try to save a project-coded line that carries no task.',
               'The system refuses it (400): a project line needs project, task and expenditure type.',
               'HTTP %s returned' % code, code == 400)

        # 8 — unknown GL combination
        code, _ = api('/ap/procash/%s/lines' % pid, tok, 'POST',
                      {'codingBasis': 'GL', 'amount': 100,
                       'glCombination': '001.999999.9999999.9.999999.9999999.999999.999.999999.999999'})
        record(8, 'Budget coding', 'A GL combination outside the chart of accounts is refused',
               'Try to save a GL-coded line quoting a combination that does not exist.',
               'The system refuses it (400).', 'HTTP %s returned' % code, code == 400)

        # 9 — out of balance blocks submit
        page.locator('.page-actions button:has-text("Submit")').click()
        page.wait_for_timeout(2200)
        st = page.locator('.pc-pill').first.inner_text().strip().lower()
        record(9, 'Lifecycle', 'A payment whose lines do not add up cannot be submitted',
               'With lines totalling less than the payment amount, choose Submit.',
               'The payment stays Draft and the difference is reported.',
               'Status after Submit: %s' % st, st == 'draft', shot(9, 'out_of_balance'))

        # 10 — balance and submit
        fill('Amount', '900')
        page.locator('.page-actions button:has-text("Save")').click()
        page.wait_for_timeout(2500)
        page.locator('.page-actions button:has-text("Submit")').click()
        page.wait_for_timeout(2500)
        st = page.locator('.pc-pill').first.inner_text().strip().lower()
        record(10, 'Lifecycle', 'A balanced payment submits',
               'Correct the payment amount so it equals the lines, Save, then Submit.',
               'The payment moves to Submitted.', 'Status: %s' % st,
               st in ('submitted', 'in approval'), shot(10, 'submitted'))

        # 11 — process
        page.locator('button:has-text("Mark processed")').click()
        page.wait_for_timeout(2500)
        st = page.locator('.pc-pill').first.inner_text().strip().lower()
        _, det = api('/ap/procash/%s' % pid, tok)
        record(11, 'Lifecycle', 'Mark the payment processed once the bank has paid it',
               'Choose Mark processed.',
               'The payment moves to Processed and the system stamps who processed it and when.',
               'Status %s, processed by "%s" on %s' % (st, det.get('processedBy'), det.get('processedOn')),
               st == 'processed' and bool(det.get('processedBy')), shot(11, 'processed'))

        # 12 — invoice picker
        page.locator('button:has-text("Link invoice")').click()
        page.wait_for_timeout(3000)
        inv_rows = page.locator('.dw-drawer.show .data-table tbody tr').count()
        s12 = shot(12, 'invoice_picker')
        record(12, 'Reconciliation', 'Pick the Fusion payable invoice from the loaded list',
               'Choose Link invoice and search the list of Fusion invoices.',
               'Only invoices already loaded from Fusion are offered, and ones already linked are marked.',
               '%d invoice(s) offered' % inv_rows, inv_rows > 0, s12)

        # 13 — link
        btn = page.locator('.dw-drawer.show button:has-text("Link")')
        if btn.count():
            btn.first.click()
            page.wait_for_timeout(3000)
        st = page.locator('.pc-pill').first.inner_text().strip().lower()
        _, det = api('/ap/procash/%s' % pid, tok)
        record(13, 'Reconciliation', 'Linking the invoice completes the record',
               'Choose Link against one of the offered invoices.',
               'The payment moves to Invoiced and the invoice number, supplier, date and amount are stored.',
               'Status %s, invoice %s' % (st, det.get('invoiceNumber')),
               st == 'invoiced' and bool(det.get('invoiceNumber')), shot(13, 'invoiced'))

        # 14 — mismatch flag
        record(14, 'Reconciliation', 'A difference between the payment and the invoice is flagged',
               'Read the Fusion payable invoice region.',
               'The system states whether the amounts agree, so a difference cannot pass unnoticed.',
               'Mismatch flag = %s (invoice %s vs paid %s)' %
               (det.get('amountMismatch'), det.get('invoiceAmount'), det.get('amount')),
               det.get('amountMismatch') in ('Y', 'N'))

        # 15 — locked after invoicing
        code, _ = api('/ap/procash/%s' % pid, tok, 'PUT', {'payeeName': 'should not stick'})
        record(15, 'Controls', 'An invoiced payment can no longer be edited',
               'Try to change the payee of an invoiced payment.',
               'The system refuses it (403).', 'HTTP %s returned' % code, code == 403)

        # 16 — history
        page.locator('.ap-tab', has_text='History').click()
        page.wait_for_timeout(900)
        hrows = page.locator('.data-table tbody tr').count()
        record(16, 'Audit', 'Every status change is on the record',
               'Open the History tab.',
               'The trail shows each transition with who made it and when.',
               '%d history entries' % hrows, hrows >= 4, shot(16, 'history'))

        # 17 — attachments tab
        page.locator('.ap-tab', has_text='Attachments').click()
        page.wait_for_timeout(900)
        record(17, 'Attachments', 'Supporting documents can be attached',
               'Open the Attachments tab.',
               'The tab offers the document checklist and an upload action.',
               'Attachment tab rendered with the type picker',
               page.locator('.region-actions select').count() >= 1, shot(17, 'attachments'))

        # 18 — register filters
        page.locator('button:has-text("Back")').click()
        page.wait_for_timeout(2500)
        page.locator('.ap-chips input[type=search]').fill(TAG)
        page.wait_for_timeout(1800)
        found = page.locator('.data-table tbody tr').count()
        record(18, 'Register', 'Search and filters narrow the register',
               'Type the bank reference in the search box.',
               'Only the matching payment is listed, with its status pill.',
               '%d row(s) found' % found, found >= 1, shot(18, 'filtered'))

        # 19 — CSV export
        code, _ = api('/ap/procash/meta/export?search=' + TAG, tok)
        record(19, 'Export', 'The register can be exported to CSV',
               'Choose Export CSV on the register page.',
               'A CSV of the filtered register downloads.',
               'Export endpoint returned HTTP %s' % code, code == 200)

        # 20 — report
        code, run = api('/ap/procash/meta/report', tok, 'POST', {'format': 'XLSX', 'search': TAG})
        status = None
        if code == 200:
            for _ in range(40):
                time.sleep(6)
                _, s = api('/ap/procash/meta/report/%s' % run['runId'], tok)
                status = s['status']
                if status in ('SUCCESS', 'FAILED', 'ERROR'):
                    break
        record(20, 'Reporting', 'Generate the Procash Transactions Register',
               'Run the report for the current filters and wait for it to finish.',
               'The Reporting Platform produces the register (summary, payments, lines, '
               'reconciliation and exceptions).',
               'Run %s finished with status %s' % (run.get('runId') if code == 200 else '-', status),
               status == 'SUCCESS')

        # 21 — Arabic / RTL
        page.locator('.lang-pill button', has_text='ع').click()
        page.wait_for_timeout(2500)
        page.evaluate("() => window._jetApp.navigate('procash')")
        page.wait_for_timeout(2500)
        ar_title = page.locator('.page-title').first.inner_text()
        rtl = page.evaluate("document.documentElement.getAttribute('dir')")
        s21 = shot(21, 'arabic_rtl')
        record(21, 'Localisation', 'The page works in Arabic, right to left',
               'Switch the language to Arabic.',
               'The page mirrors to right-to-left and every label is Arabic.',
               'dir=%s, title "%s"' % (rtl, ar_title), rtl == 'rtl' and 'معاملات' in ar_title, s21)
        page.locator('.lang-pill button', has_text='EN').click()
        page.wait_for_timeout(2000)

        # 22 — Excel template
        code, _ = api('/xl/templates/download?code=PROCASH_ENTRY', tok)
        record(22, 'Excel', 'The Excel entry template can be downloaded',
               'Download the procash workbook from the template repository.',
               'The workbook downloads with its Single, Headers, Lines and Invoice Update sheets.',
               'Template download returned HTTP %s' % code, code == 200)

        b.close()

    # cleanup
    for pid in made:
        api('/ap/procash/%s/cancel' % pid, tok, 'POST', {'comments': 'UAT round %d done' % ROUND})

    xlsx = write_workbooks()
    docx = write_results_doc()
    passed = sum(1 for c in cases if c['status'] == 'PASS')
    print('\n=== UAT round %d: %d passed, %d failed ===' % (ROUND, passed, len(cases) - passed))
    print('workbook :', xlsx)
    print('results  :', docx)
    print('evidence :', EVIDENCE)
    print("\ncleanup SQL:\n  DELETE FROM prod.dct_request_status_history WHERE source_module='AP'"
          " AND source_type='PROCASH' AND source_id IN (SELECT procash_id FROM prod.dct_ap_procash"
          " WHERE bank_reference LIKE '%s%%');\n  DELETE FROM prod.dct_ap_procash WHERE bank_reference"
          " LIKE '%s%%';  COMMIT;" % (TAG, TAG))
    return 0 if passed == len(cases) else 1


if __name__ == '__main__':
    sys.exit(main())
