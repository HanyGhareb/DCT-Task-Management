#!/usr/bin/env python3
"""GL /gl/costadj* API smoke — Projects Costing Adjustments (2026-08-22).

Covers the register + CRUD + APPROVE/REJECT lifecycle, validation errors,
the AP-distribution search, and the /gl/butil reflection behind costadj=Y
(default ON): DRAFT rows are inert; an APPROVED row moves Actual by the
signed amount, Budget (annual + YTD) by the signed budget override, Fund
Available by (override - amount); costadj=N reverts to the published
figures while still reporting the components; the accounting period gates
the adjustment in YTD views. Everything created here is deleted at the end.

Run: python3 costadj_api_smoke.py              (defaults to the webtier)
     GL_BASE=https://... python3 costadj_api_smoke.py
"""
import json
import os
import re
import ssl
import urllib.error
import urllib.parse
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

PROJ, TASK = '4517000039', '4510747'          # fixture line (same as procash smoke)
YEAR = 2026
AMT, OVR = 1000.0, 500.0

ok = fail = 0


def ck(name, cond, extra=''):
    global ok, fail
    print(('  PASS ' if cond else '  FAIL ') + name + ('  ' + str(extra) if extra and not cond else ''))
    if cond:
        ok += 1
    else:
        fail += 1


def login():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(BASE + '/ords/admin/dct/auth/login',
                               data=json.dumps({'username': u, 'password': p}).encode(),
                               method='POST', headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


TOK = login()


def call(path, method='GET', body=None, tok=None):
    d = json.dumps(body).encode() if body is not None else None
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, data=d, method=method,
                               headers={'Authorization': 'Bearer ' + (tok or TOK)})
    if d:
        r.add_header('Content-Type', 'application/json')
    try:
        x = urllib.request.urlopen(r, timeout=240, context=CTX)
        return x.status, json.loads(x.read() or b'null')
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'null')
        except Exception:
            return e.code, None


def butil(extra=''):
    return call('/butil?year=%d&limit=50&project=%s&task=%s%s' % (YEAR, PROJ, TASK, extra))


print('== lookups + dist search ==')
c, lk = call('/costadj/meta/lookups')
ck('lookups respond', c == 200, c)
ck('4 classifications seeded', len(lk['classifications']) == 4, lk['classifications'])
ck('3 statuses seeded', [s['code'] for s in lk['statuses']] == ['DRAFT', 'APPROVED', 'REJECTED'])
c, ds = call('/costadj/meta/dists?search=DCT')
ck('dist search responds capped at 50', c == 200 and ds['total'] <= 50, (c, ds and ds['total']))
ck('dist rows carry invoice + coding fields',
   ds['items'] and all(k in ds['items'][0] for k in
                       ('invoiceId', 'invoiceNumber', 'line', 'dist', 'supplier',
                        'amountAed', 'projectNumber', 'taskNumber', 'expenditureType')),
   ds['items'][:1])
c, _ = call('/costadj/meta/dists')
ck('dist search without a term -> 400', c == 400, c)
c, _ = call('/costadj/meta/dists?search=x')
ck('dist search under 2 chars -> 400', c == 400, c)

print('== dependent pick lists (butil key cache) ==')
c, t = call('/costadj/meta/tasks?year=%d&project=%s' % (YEAR, PROJ))
ck('tasks of the project', c == 200 and TASK in t['items'], (c, t and t['items'][:5]))
c, e1 = call('/costadj/meta/etypes?year=%d&project=%s' % (YEAR, PROJ))
c2, e2 = call('/costadj/meta/etypes?year=%d&project=%s&task=%s' % (YEAR, PROJ, TASK))
ck('etypes narrow with the task', c == 200 and c2 == 200
   and len(e2['items']) <= len(e1['items']) and len(e2['items']) >= 1,
   (len(e1['items']), len(e2['items'])))
c, _ = call('/costadj/meta/tasks?year=%d' % YEAR)
ck('tasks without a project -> 400', c == 400, c)

print('== auth ==')
c, _ = call('/costadj', tok='bogus')
ck('bogus token -> 401', c == 401, c)

print('== baseline ==')
c, base = butil()
ck('butil responds and includeCostAdj defaults to Y', c == 200 and base['includeCostAdj'] == 'Y',
   (c, base and base.get('includeCostAdj')))
row = base['items'][0]
ET = row['expenditureType']
ck('fixture line found with no adjustment yet', row['hasAdj'] == 'N', row['hasAdj'])
b_ap, b_bud, b_buda, b_fund = row['actualAp'], row['budget'], row['budgetAnnual'], row['fundAvailable']

print('== create validations ==')
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'projectNumber': PROJ, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': AMT, 'period': '01-%d' % YEAR})
ck('missing reason -> 400', c == 400, c)
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'projectNumber': PROJ, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': 0, 'reason': 'x', 'period': '01-%d' % YEAR})
ck('zero amount AND zero override -> 400', c == 400, c)
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'projectNumber': PROJ, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': AMT, 'reason': 'x'})
ck('missing period -> 400 (period is mandatory)', c == 400, c)
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'projectNumber': PROJ, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': AMT, 'reason': 'x', 'period': '13-2026'})
ck('bad period -> 400', c == 400, c)
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'projectNumber': PROJ, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': AMT, 'reason': 'x', 'period': '06-2025'})
ck('period outside the budget year -> 400', c == 400, c)
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'projectNumber': PROJ, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': AMT, 'reason': 'x',
                                 'period': '01-%d' % YEAR, 'classification': 'NOT_A_CODE'})
ck('unknown classification -> 400', c == 400, c)
c, _ = call('/costadj', 'POST', {'budgetYear': YEAR, 'taskNumber': TASK,
                                 'expenditureType': ET, 'amount': AMT, 'reason': 'x'})
ck('missing project -> 400', c == 400, c)

print('== create + list + edit ==')
c, made = call('/costadj', 'POST', {
    'budgetYear': YEAR, 'period': '01-%d' % YEAR,
    'projectNumber': PROJ, 'taskNumber': TASK, 'expenditureType': ET,
    'amount': AMT, 'budgetOverride': OVR, 'classification': 'REALLOCATION',
    'reason': 'api smoke', 'comments': 'temp row', 'invoiceNumber': 'SMOKE-API',
    'supplier': 'Smoke Vendor', 'origProject': '9999', 'origTask': '1', 'origEtype': 'Wrong etype'})
ck('create DRAFT', c == 200 and made.get('status') == 'CREATED', (c, made))
aid, ref = made['id'], made['ref']
ck('reference is PCA-#####', bool(re.match(r'^PCA-\d{5}$', ref)), ref)
c, lst = call('/costadj?status=DRAFT&search=' + ref)
ck('register finds the row by ref + status', c == 200 and lst['total'] == 1
   and lst['items'][0]['ref'] == ref, (c, lst and lst['total']))
it = lst['items'][0] if lst['items'] else {}
ck('row ships original coding + supplier + classification name',
   it.get('origProject') == '9999' and it.get('supplier') == 'Smoke Vendor'
   and it.get('className') == 'Cost Re-allocation', it)
c, _ = call('/costadj/%d' % aid, 'PUT', {
    'budgetYear': YEAR, 'period': '01-%d' % YEAR,
    'projectNumber': PROJ, 'taskNumber': TASK, 'expenditureType': ET,
    'amount': AMT, 'budgetOverride': OVR, 'classification': 'CORRECTION',
    'reason': 'api smoke edited', 'comments': 'temp row'})
ck('edit DRAFT', c == 200, c)
c, lst = call('/costadj?search=' + ref)
ck('edit persisted', lst['items'][0]['classification'] == 'CORRECTION'
   and lst['items'][0]['reason'] == 'api smoke edited', lst['items'][:1])

print('== butil: DRAFT is inert ==')
c, mid = butil()
r2 = mid['items'][0]
ck('figures unchanged while DRAFT', abs(r2['fundAvailable'] - b_fund) < 0.005
   and r2['hasAdj'] == 'N', (r2['fundAvailable'], b_fund))

print('== approve + reflection ==')
c, act = call('/costadj/%d/action' % aid, 'POST', {'action': 'APPROVE', 'note': 'smoke'})
ck('approve', c == 200 and act.get('status') == 'APPROVED', (c, act))
c, on = butil()
r3, t3 = on['items'][0], on['totals']
ck('row Actual AP moves by the adjustment', abs(r3['actualAp'] - (b_ap + AMT)) < 0.005,
   (r3['actualAp'], b_ap + AMT))
ck('row YTD Budget moves by the override', abs(r3['budget'] - (b_bud + OVR)) < 0.005,
   (r3['budget'], b_bud + OVR))
ck('row Annual Budget moves by the override', abs(r3['budgetAnnual'] - (b_buda + OVR)) < 0.005,
   (r3['budgetAnnual'], b_buda + OVR))
ck('row Fund Available moves by (override - amount)',
   abs(r3['fundAvailable'] - (b_fund + OVR - AMT)) < 0.005, (r3['fundAvailable'], b_fund + OVR - AMT))
ck('row is flagged hasAdj=Y with the components',
   r3['hasAdj'] == 'Y' and r3['costAdj'] == AMT and r3['costAdjOvr'] == OVR, r3.get('costAdj'))
ck('totals carry the adjustment figures', t3['costAdj'] == AMT and t3['costAdjCount'] == 1
   and t3['costAdjOvr'] == OVR, (t3.get('costAdj'), t3.get('costAdjCount')))

c, off = butil('&costadj=N')
r4 = off['items'][0]
ck('costadj=N restores published figures', abs(r4['fundAvailable'] - b_fund) < 0.005
   and abs(r4['actualAp'] - b_ap) < 0.005 and off['includeCostAdj'] == 'N',
   (r4['fundAvailable'], b_fund))
ck('components still reported when off', r4['costAdj'] == AMT and r4['hasAdj'] == 'Y', r4.get('costAdj'))

print('== approved rows are locked ==')
c, _ = call('/costadj/%d' % aid, 'PUT', {'budgetYear': YEAR, 'projectNumber': PROJ,
                                         'taskNumber': TASK, 'expenditureType': ET,
                                         'amount': 1, 'reason': 'x'})
ck('PUT on APPROVED -> 400', c == 400, c)
c, _ = call('/costadj/%d/action' % aid, 'POST', {'action': 'APPROVE'})
ck('re-action on APPROVED -> 400', c == 400, c)
c, _ = call('/costadj/%d/action' % aid, 'POST', {'action': 'MAYBE'})
ck('unknown action -> 400', c == 400, c)
c, _ = call('/costadj/999999999/action', 'POST', {'action': 'APPROVE'})
ck('action on unknown id -> 404', c == 404, c)

print('== period window (YTD) ==')
c, made2 = call('/costadj', 'POST', {'budgetYear': YEAR, 'period': '12-%d' % YEAR,
                                     'projectNumber': PROJ, 'taskNumber': TASK,
                                     'expenditureType': ET, 'amount': 777, 'reason': 'window smoke'})
aid2 = made2['id']
call('/costadj/%d/action' % aid2, 'POST', {'action': 'APPROVE'})
c, y6 = butil('&period=06-%d' % YEAR)
c, y12 = butil('&period=12-%d' % YEAR)
ck('June YTD excludes the December adjustment', y6['totals']['costAdj'] == AMT,
   y6['totals']['costAdj'])
ck('December YTD includes it', y12['totals']['costAdj'] == AMT + 777, y12['totals']['costAdj'])

print('== reject flow ==')
c, made3 = call('/costadj', 'POST', {'budgetYear': YEAR, 'period': '01-%d' % YEAR,
                                     'projectNumber': PROJ, 'taskNumber': TASK,
                                     'expenditureType': ET, 'amount': 333, 'reason': 'reject smoke'})
aid3 = made3['id']
c, act = call('/costadj/%d/action' % aid3, 'POST', {'action': 'REJECT', 'note': 'not valid'})
ck('reject', c == 200 and act.get('status') == 'REJECTED', (c, act))
c, on2 = butil()
# both approved rows (AMT + the 777 December one) count on the full year;
# the rejected 333 must NOT
ck('rejected rows never reach the figures', on2['totals']['costAdj'] == AMT + 777,
   on2['totals']['costAdj'])
c, lst = call('/costadj?status=REJECTED&search=reject smoke'.replace(' ', '%20'))
ck('rejected row shows its action note', lst['items'] and lst['items'][0]['actionNote'] == 'not valid',
   lst['items'][:1])

print('== cleanup ==')
for x in (aid, aid2, aid3):
    c, _ = call('/costadj/%d' % x, 'DELETE')
    ck('delete #%d' % x, c == 200, c)
c, _ = call('/costadj/%d' % aid, 'DELETE')
ck('delete again -> 404', c == 404, c)
c, fin = butil()
ck('figures back to baseline after cleanup',
   abs(fin['items'][0]['fundAvailable'] - b_fund) < 0.005 and fin['items'][0]['hasAdj'] == 'N',
   fin['items'][0]['fundAvailable'])

print('\n%d passed, %d failed' % (ok, fail))
exit(1 if fail else 0)
