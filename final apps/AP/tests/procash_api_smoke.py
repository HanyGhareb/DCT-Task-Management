"""Procash Transactions - API smoke suite (App 212 / AP, ap.rest /ap/procash*).

Covers happy path, 400/401/403/404 error handling and boundary values across
the whole lifecycle: create -> lines -> submit -> process -> link invoice ->
unlink -> cancel.

Auth: either
  IFINANCE_TOKEN=<session id>                      (mint one in the DB), or
  IFINANCE_UAT_USER / IFINANCE_UAT_PASS            (normal login)

The suite tags everything it writes with the bank reference prefix
"API-SMOKE-PCH-" and removes every row it still can at the end. Records that
reach a terminal state (CANCELLED / INVOICED) cannot be removed over the API by
design, so a deploy that runs this against PROD should follow up with:

  DELETE FROM prod.dct_ap_procash WHERE bank_reference LIKE 'API-SMOKE-PCH-%';

Run: python3 procash_api_smoke.py
"""
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

BASE = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
TAG = 'API-SMOKE-PCH-' + time.strftime('%Y%m%d%H%M%S')

results = []


def call(path, token=None, method='GET', body=None, expect=200, raw=False):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    if data is not None:
        req.add_header('Content-Type', 'application/json')
    try:
        r = urllib.request.urlopen(req, timeout=180)
        code, payload = r.status, r.read()
        ctype = r.headers.get('Content-Type', '')
    except urllib.error.HTTPError as e:
        code, payload, ctype = e.code, e.read(), e.headers.get('Content-Type', '')
    parsed = payload
    if not raw and payload:
        try:
            parsed = json.loads(payload)
        except ValueError:
            parsed = payload.decode('utf-8', 'replace')
    return code, parsed, ctype


def check(name, cond, detail=''):
    results.append((name, bool(cond), detail))
    print(('  PASS  ' if cond else '  FAIL  ') + name + (('  -> ' + str(detail)) if detail and not cond else ''))
    return bool(cond)


def api(name, path, token=None, method='GET', body=None, expect=200, raw=False):
    code, data, ctype = call(path, token, method, body, expect, raw)
    check('%s (%s %s)' % (name, method, path.split('?')[0]), code == expect,
          'expected %s got %s: %s' % (expect, code, str(data)[:300]))
    return data, ctype


def login():
    tok = os.environ.get('IFINANCE_TOKEN')
    if tok:
        return tok
    user, pwd = os.environ.get('IFINANCE_UAT_USER'), os.environ.get('IFINANCE_UAT_PASS')
    if not user or not pwd:
        sys.exit('Set IFINANCE_TOKEN, or IFINANCE_UAT_USER / IFINANCE_UAT_PASS')
    data = json.dumps({'username': user, 'password': pwd}).encode()
    req = urllib.request.Request(BASE + '/dct/auth/login', data=data,
                                 headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(req, timeout=60).read())['sessionId']


def main():
    tok = login()
    print('=== procash API smoke, tag %s ===' % TAG)

    print('-- auth')
    code, _, _ = call('/ap/procash/')
    check('register without a token is 401', code == 401, code)

    print('-- pick lists')
    lovs, _ = api('meta lovs', '/ap/procash/meta/lovs', tok)
    check('lovs carry the 8 statuses', len(lovs.get('statuses', [])) == 8, len(lovs.get('statuses', [])))
    check('lovs carry both coding bases', len(lovs.get('codingBases', [])) == 2)
    check('lovs carry currencies', len(lovs.get('currencies', [])) > 0)
    check('lovs carry business units', len(lovs.get('businessUnits', [])) > 0)
    check('lovs carry the attachment checklist', len(lovs.get('docTypes', [])) == 5)
    check('lovs report the approval mode', lovs.get('approvalMode') in ('NONE', 'WORKFLOW'))
    bu = lovs['businessUnits'][0]
    ccy = 'AED'

    projects, _ = api('meta projects', '/ap/procash/meta/projects?limit=5', tok)
    check('projects come back', len(projects.get('items', [])) > 0)
    proj = projects['items'][0]['code']

    code, _, _ = call('/ap/procash/meta/tasks', tok)
    check('tasks without a project is 400', code == 400, code)

    tasks, _ = api('meta tasks', '/ap/procash/meta/tasks?project=' + urllib.parse.quote(proj), tok)
    etypes, _ = api('meta etypes', '/ap/procash/meta/etypes', tok)
    gls, _ = api('meta gl', '/ap/procash/meta/gl?search=451', tok)
    check('the GL pick list reads the real chart of accounts', len(gls.get('items', [])) > 0,
          len(gls.get('items', [])))
    sup, _ = api('meta suppliers', '/ap/procash/meta/suppliers?search=a', tok)
    check('the supplier pick list returns Fusion suppliers', len(sup.get('items', [])) > 0,
          len(sup.get('items', [])))
    invoices, _ = api('meta invoices', '/ap/procash/meta/invoices', tok)
    check('invoice search returns rows', len(invoices.get('items', [])) > 0)

    # a project fixture that actually has tasks
    task = tasks['items'][0]['code'] if tasks.get('items') else None
    if not task:
        for p in projects['items'][:20]:
            _, t, _ = call('/ap/procash/meta/tasks?project=' + urllib.parse.quote(p['code']), tok)
            if t.get('items'):
                proj, task = p['code'], t['items'][0]['code']
                break
    etype = etypes['items'][0]['code']
    check('a project/task/expenditure fixture was found', bool(task and etype), (proj, task, etype))

    print('-- create')
    hdr = {'bankReference': TAG + '-1', 'bankAccount': 'FAB Current 1234', 'businessUnit': bu,
           'payeeName': 'API Smoke Payee', 'amount': 1000, 'currencyCode': ccy,
           'paymentDate': time.strftime('%Y-%m-%d'), 'description': 'procash api smoke'}
    created, _ = api('create header', '/ap/procash', tok, 'POST', hdr)
    pid = created.get('procashId')
    check('create returns an id', bool(pid), created)

    code, data, _ = call('/ap/procash', tok, 'POST', hdr)
    check('a duplicate bank reference is 400', code == 400, code)

    code, _, _ = call('/ap/procash', tok, 'POST', dict(hdr, bankReference=None))
    check('a missing bank reference is 400', code == 400, code)

    code, _, _ = call('/ap/procash', tok, 'POST', dict(hdr, bankReference=TAG + '-bad', currencyCode='ZZZ'))
    check('an unknown currency is 400', code == 400, code)

    print('-- detail')
    detail, _ = api('detail', '/ap/procash/%s' % pid, tok)
    check('a new transaction is DRAFT', detail.get('status') == 'DRAFT', detail.get('status'))
    check('detail carries the findings list', any(f['code'] == 'NO_LINES' for f in detail.get('findings', [])))
    check('detail says the owner may still edit', detail.get('canEdit') == 'Y')
    check('detail carries empty child arrays', detail.get('lines') == [] and detail.get('documents') == [])
    check('detail carries the creation history', len(detail.get('history', [])) == 1)

    code, _, _ = call('/ap/procash/999999999', tok)
    check('an unknown id is 404', code == 404, code)
    code, _, _ = call('/ap/procash/not-a-number', tok)
    check('a non numeric id is 400', code == 400, code)

    print('-- lines')
    code, _, _ = call('/ap/procash/%s/lines' % pid, tok, 'POST',
                      {'codingBasis': 'PROJECT', 'projectNumber': proj, 'amount': 600})
    check('a project line without a task is 400', code == 400, code)

    # Master codes are no longer validated (user decision 2026-08-17) - the form
    # offers real values in a dropdown, but the API stores what it is given.
    code, gl, _ = call('/ap/procash/%s/lines' % pid, tok, 'POST',
                       {'codingBasis': 'GL',
                        'glCombination': '451.999999.9999999.9.999999.9999999.999999.000.000000.000000',
                        'amount': 600})
    check('a GL code outside the chart of accounts is accepted over the API', code == 200, code)
    if code == 200:
        call('/ap/procash/%s/lines/%s' % (pid, gl['lineId']), tok, 'DELETE')

    line1, _ = api('add line', '/ap/procash/%s/lines' % pid, tok, 'POST',
                   {'codingBasis': 'PROJECT', 'projectNumber': proj, 'taskNumber': task,
                    'expenditureType': etype, 'amount': 600, 'comments': 'first'})
    lid = line1.get('lineId')
    check('the line total follows the line', line1.get('lineTotal') == 600, line1)

    line2, _ = api('add second line', '/ap/procash/%s/lines' % pid, tok, 'POST',
                   {'codingBasis': 'PROJECT', 'projectNumber': proj, 'taskNumber': task,
                    'expenditureType': etype, 'amount': 300})
    lid2 = line2.get('lineId')

    print('-- submit gate')
    code, data, _ = call('/ap/procash/%s/submit' % pid, tok, 'POST', {})
    check('submit is blocked while out of balance', code == 400, code)

    upd, _ = api('edit the line to balance', '/ap/procash/%s/lines/%s' % (pid, lid), tok, 'PUT',
                 {'codingBasis': 'PROJECT', 'projectNumber': proj, 'taskNumber': task,
                  'expenditureType': etype, 'amount': 700, 'comments': 'first'})
    check('editing a line re-totals', upd.get('lineTotal') == 1000, upd)

    print('-- partial update keeps stored values')
    api('partial update', '/ap/procash/%s' % pid, tok, 'PUT', {'description': 'changed by smoke'})
    detail, _ = api('detail after update', '/ap/procash/%s' % pid, tok)
    check('the described field changed', detail.get('description') == 'changed by smoke')
    check('an absent key kept its stored value', detail.get('bankAccount') == 'FAB Current 1234',
          detail.get('bankAccount'))
    check('the amount survived a partial update', float(detail.get('amount')) == 1000.0)

    print('-- lifecycle')
    sub, _ = api('submit', '/ap/procash/%s/submit' % pid, tok, 'POST', {'comments': 'smoke submit'})
    check('a balanced transaction submits', sub.get('status') in ('SUBMITTED', 'IN_APPROVAL'), sub)

    if sub.get('status') == 'SUBMITTED':
        proc, _ = api('process', '/ap/procash/%s/process' % pid, tok, 'POST', {'comments': 'paid'})
        check('processing lands on PROCESSED', proc.get('status') == 'PROCESSED', proc)

        detail, _ = api('detail after processing', '/ap/procash/%s' % pid, tok)
        check('processing stamped who', bool(detail.get('processedBy')), detail.get('processedBy'))
        check('processing stamped when', bool(detail.get('processedOn')), detail.get('processedOn'))

        print('-- invoice reconciliation')
        code, _, _ = call('/ap/procash/%s/invoice' % pid, tok, 'POST', {'invoiceNumber': 'NO-SUCH-INV-9999'})
        check('an unknown invoice number is 404', code == 404, code)

        free = [i for i in invoices['items'] if i.get('alreadyLinked') == 'N']
        check('the invoice list flags what is already taken', len(free) > 0)
        inv = free[0]
        linked, _ = api('link invoice', '/ap/procash/%s/invoice' % pid, tok, 'POST',
                        {'invoiceId': inv['invoiceId']})
        check('linking lands on INVOICED', linked.get('status') == 'INVOICED', linked)
        check('the mismatch flag is computed', linked.get('amountMismatch') in ('Y', 'N'), linked)

        detail, _ = api('detail after linking', '/ap/procash/%s' % pid, tok)
        check('an invoiced transaction is locked', detail.get('canEdit') == 'N', detail.get('canEdit'))
        check('the invoice snapshot is stored', detail.get('invoiceNumber') == inv['invoiceNumber'])

        code, _, _ = call('/ap/procash/%s' % pid, tok, 'PUT', {'description': 'should not stick'})
        check('editing an invoiced transaction is 403', code == 403, code)

        unlinked, _ = api('unlink invoice', '/ap/procash/%s/invoice' % pid, tok, 'DELETE')
        check('unlinking returns to PROCESSED', unlinked.get('status') == 'PROCESSED', unlinked)

    print('-- register and export')
    reg, _ = api('register', '/ap/procash/?limit=5', tok)
    check('the register has an envelope', all(k in reg for k in ('items', 'total', 'totals')), list(reg))
    check('the register page is capped by limit', len(reg['items']) <= 5)
    check('totals carry the AED figure', 'amountAed' in reg['totals'])

    mine, _ = api('register filtered by search', '/ap/procash/?search=' + TAG, tok)
    check('the search filter narrows to this run', mine['total'] >= 1, mine['total'])
    check('every found row carries the tag',
          all(TAG in r['bankReference'] for r in mine['items']), [r['bankReference'] for r in mine['items']])

    st, _ = api('register filtered by status', '/ap/procash/?status=DRAFT|PROCESSED&search=' + TAG, tok)
    check('the status filter accepts a pipe list',
          all(r['status'] in ('DRAFT', 'PROCESSED') for r in st['items']))

    unl, _ = api('register filtered by invoice link', '/ap/procash/?linked=N&search=' + TAG, tok)
    check('the unlinked filter excludes linked rows',
          all(not r.get('invoiceNumber') for r in unl['items']))

    csv, ctype = api('csv export', '/ap/procash/meta/export?search=' + TAG, tok, raw=True)
    check('the export is text/csv', 'csv' in ctype.lower(), ctype)
    check('the export carries a header row', b'Payment Number' in csv, csv[:80])

    print('-- cancel and cleanup')
    tmp, _ = api('create a throwaway draft', '/ap/procash', tok, 'POST',
                 dict(hdr, bankReference=TAG + '-tmp'))
    api('remove a draft', '/ap/procash/%s' % tmp['procashId'], tok, 'DELETE')
    code, _, _ = call('/ap/procash/%s' % tmp['procashId'], tok)
    check('a removed draft is gone', code == 404, code)

    can, _ = api('cancel', '/ap/procash/%s/cancel' % pid, tok, 'POST', {'comments': 'smoke done'})
    check('cancelling lands on CANCELLED', can.get('status') == 'CANCELLED', can)
    code, _, _ = call('/ap/procash/%s' % pid, tok, 'DELETE')
    check('a cancelled transaction cannot be removed', code == 403, code)

    passed = sum(1 for _, ok, _ in results if ok)
    print('\n=== %d passed, %d failed ===' % (passed, len(results) - passed))
    print('leftover rows carry bank_reference LIKE %r -- clean them from PROD when done' % (TAG + '%'))
    return 0 if passed == len(results) else 1


if __name__ == '__main__':
    sys.exit(main())
