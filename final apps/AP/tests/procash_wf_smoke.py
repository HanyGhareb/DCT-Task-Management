"""Procash Transactions - workflow approval path (App 212 / AP + DWP).

Exercises the mode the AP setting PROCASH_APPROVAL_MODE=WORKFLOW turns on:
  submit -> IN_APPROVAL -> line-manager step -> Finance Director step -> APPROVED
  -> mark processed.

The approval verbs are NEVER hard-coded here either: each step's action comes
from the task's own outcomes[] array, exactly as the shared action bar renders
it.

Before running, flip the setting on (and off again afterwards):
  UPDATE prod.dct_module_settings SET setting_value='WORKFLOW'
   WHERE module_id=121 AND setting_key='PROCASH_APPROVAL_MODE';  COMMIT;

Auth: IFINANCE_TOKEN=<session id>  or  IFINANCE_UAT_USER / IFINANCE_UAT_PASS.
Each step is taken by whoever the engine actually assigned it to, so a second
approver token is usually needed: step 1 resolves to the submitter's line
manager (falling back to a PROCASH_ADMIN holder) and step 2 to the Finance
Director. Set IFINANCE_TOKEN_2=<session id of the FIN_DIRECTOR holder>; without
it the suite reports the step as waiting on someone else and stops there.

Run: python3 procash_wf_smoke.py
"""
import json
import os
import sys
import time
import urllib.error
import urllib.request

BASE = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
TAG = 'WF-SMOKE-PCH-' + time.strftime('%Y%m%d%H%M%S')

results = []


def call(path, token, method='GET', body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
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


def check(name, cond, detail=''):
    results.append((name, bool(cond)))
    print(('  PASS  ' if cond else '  FAIL  ') + name + (('   -> ' + str(detail)) if detail and not cond else ''))
    return bool(cond)


def login():
    tok = os.environ.get('IFINANCE_TOKEN')
    if tok:
        return tok
    user, pwd = os.environ.get('IFINANCE_UAT_USER'), os.environ.get('IFINANCE_UAT_PASS')
    if not user or not pwd:
        sys.exit('Set IFINANCE_TOKEN, or IFINANCE_UAT_USER / IFINANCE_UAT_PASS')
    req = urllib.request.Request(BASE + '/dct/auth/login',
                                 data=json.dumps({'username': user, 'password': pwd}).encode(),
                                 headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(req, timeout=60).read())['sessionId']


def approve_step(tokens, pid, step_no):
    """Find this record's task in whichever approver's worklist holds it."""
    tok = None
    wl = {}
    for t in tokens:
        code, w = call('/wf/worklist', t)
        if code == 200 and [x for x in (w.get('items') or [])
                            if x.get('module') == 'AP_PROCASH'
                            and int(x.get('sourceRecordId') or 0) == pid]:
            tok, wl = t, w
            break
    if tok is None:
        tok = tokens[0]
    code, wl = call('/wf/worklist', tok)
    if not check('worklist loads (step %d)' % step_no, code == 200, code):
        return None
    task = [t for t in (wl.get('items') or [])
            if t.get('module') == 'AP_PROCASH' and int(t.get('sourceRecordId') or 0) == pid]
    if not check('the transaction is waiting on step %d' % step_no, len(task) == 1,
                 [(t.get('module'), t.get('sourceRecordId')) for t in (wl.get('items') or [])]):
        return None
    t = task[0]
    outs = t.get('outcomes') or []
    check('step %d ships its own outcome vocabulary' % step_no, len(outs) >= 2, outs)
    positive = [o for o in outs
                if (o.get('isPositive') or o.get('is_positive')) in ('Y', True)
                or str(o.get('code') or o.get('outcomeCode') or '').upper() == 'APPROVE']
    if not check('step %d offers a positive outcome' % step_no, len(positive) >= 1, outs):
        return None
    verb = positive[0].get('code') or positive[0].get('outcomeCode')
    code, res = call('/wf/tasks/%s/action' % t['id'], tok, 'POST',
                     {'outcome': verb, 'comments': 'wf smoke step %d' % step_no})
    check('step %d action %s is accepted' % (step_no, verb), code == 200, (code, res))
    return verb


def main():
    tok = login()
    tokens = [tok] + [t for t in [os.environ.get('IFINANCE_TOKEN_2')] if t]
    print('=== procash workflow smoke, tag %s ===' % TAG)

    code, lovs = call('/ap/procash/meta/lovs', tok)
    if not check('the module is in WORKFLOW approval mode', lovs.get('approvalMode') == 'WORKFLOW',
                 lovs.get('approvalMode')):
        print('\nFlip PROCASH_APPROVAL_MODE to WORKFLOW before running this suite.')
        return 1
    bu = lovs['businessUnits'][0]

    code, projects = call('/ap/procash/meta/projects', tok)
    proj = task = etype = None
    for p in projects['items'][:25]:
        code, ts = call('/ap/procash/meta/tasks?project=' + p['code'], tok)
        if ts.get('items'):
            code, es = call('/ap/procash/meta/etypes', tok)
            proj, task, etype = p['code'], ts['items'][0]['code'], es['items'][0]['code']
            break
    check('a coding fixture was found', bool(proj and task and etype), (proj, task, etype))

    code, created = call('/ap/procash', tok, 'POST', {
        'bankReference': TAG, 'businessUnit': bu, 'payeeName': 'WF smoke payee',
        'amount': 750, 'currencyCode': 'AED', 'paymentDate': time.strftime('%Y-%m-%d'),
        'description': 'workflow smoke'})
    pid = created.get('procashId')
    check('the transaction is created', code == 200 and bool(pid), (code, created))

    code, _ = call('/ap/procash/%s/lines' % pid, tok, 'POST',
                   {'codingBasis': 'PROJECT', 'projectNumber': proj, 'taskNumber': task,
                    'expenditureType': etype, 'amount': 750})
    check('a balanced line is added', code == 200, code)

    code, sub = call('/ap/procash/%s/submit' % pid, tok, 'POST', {'comments': 'wf smoke'})
    check('submitting starts the approval', code == 200 and sub.get('status') == 'IN_APPROVAL', (code, sub))

    code, detail = call('/ap/procash/%s' % pid, tok)
    check('a workflow instance is stamped on the record', (detail.get('wfInstanceId') or 0) > 0,
          detail.get('wfInstanceId'))
    check('an in-approval transaction is closed to editing', detail.get('canEdit') == 'N',
          detail.get('canEdit'))

    approve_step(tokens, pid, 1)
    time.sleep(1)
    code, detail = call('/ap/procash/%s' % pid, tok)
    check('the record is still in approval after step 1', detail.get('status') == 'IN_APPROVAL',
          detail.get('status'))

    approve_step(tokens, pid, 2)
    time.sleep(1)
    code, detail = call('/ap/procash/%s' % pid, tok)
    check('the final gate moves the record to APPROVED', detail.get('status') == 'APPROVED',
          detail.get('status'))
    check('the approval is written to the status history',
          any(h.get('newStatus') == 'APPROVED' for h in detail.get('history', [])),
          [h.get('newStatus') for h in detail.get('history', [])])

    code, proc = call('/ap/procash/%s/process' % pid, tok, 'POST', {'comments': 'paid'})
    check('an approved transaction can be processed', code == 200 and proc.get('status') == 'PROCESSED',
          (code, proc))

    code, _ = call('/ap/procash/%s/cancel' % pid, tok, 'POST', {'comments': 'wf smoke done'})
    check('the smoke record is cancelled at the end', code == 200, code)

    passed = sum(1 for _, ok in results if ok)
    print('\n=== %d passed, %d failed ===' % (passed, len(results) - passed))
    print("remember: flip PROCASH_APPROVAL_MODE back to NONE, and remove rows LIKE '%s%%'" % TAG)
    return 0 if passed == len(results) else 1


if __name__ == '__main__':
    sys.exit(main())
