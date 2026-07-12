import json, time, urllib.request, urllib.parse, sys
BASE = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

def call(path, token=None, expect=200, raw=False):
    req = urllib.request.Request(BASE + path)
    if token: req.add_header('Authorization', 'Bearer ' + token)
    t0 = time.time()
    try:
        r = urllib.request.urlopen(req, timeout=180)
        body = r.read(); code = r.status
    except urllib.error.HTTPError as e:
        code = e.code; body = e.read()
    dt = time.time() - t0
    ok = 'PASS' if code == expect else 'FAIL'
    return ok, code, dt, (json.loads(body) if body and code==expect and not raw else body)

import os
UAT_USER = os.environ.get('IFINANCE_UAT_USER')
UAT_PASS = os.environ.get('IFINANCE_UAT_PASS')
if not UAT_USER or not UAT_PASS:
    sys.exit('Set IFINANCE_UAT_USER / IFINANCE_UAT_PASS env vars (UAT credentials are not stored in the repo)')
data = json.dumps({'username': UAT_USER, 'password': UAT_PASS}).encode()
req = urllib.request.Request(BASE + '/dct/auth/login', data=data, headers={'Content-Type':'application/json'})
tok = json.loads(urllib.request.urlopen(req, timeout=60).read())['sessionId']
res = []

# summary unfiltered: aging reconciliation
ok, c, dt, d = call('/ap/summary', tok); res.append(('summary', ok, c, dt))
k = d['kpis']; ag = sum(a['amount'] for a in d['aging'])
rec = 'RECONCILE' if abs(ag - k['outstandingAed']) < 1 else 'MISMATCH %.2f vs %.2f' % (ag, k['outstandingAed'])
print('aging sum vs outstanding:', rec)

# filtered summary (the one that timed out before)
q = urllib.parse.urlencode({'paid':'Unpaid','sector':'Culture','datefrom':'2026-01-01','dateto':'2026-12-31'})
ok, c, dt, d = call('/ap/summary?'+q, tok); res.append(('summary sector+paid+dates', ok, c, dt))
n1 = d['kpis']['invoices'] if ok=='PASS' else -1
ok, c, dt, d = call('/ap/invoices?'+q+'&limit=2', tok); res.append(('invoices same filters', ok, c, dt))
n2 = d['total'] if ok=='PASS' else -2
print('summary count == register total:', n1, n2, 'RECONCILE' if n1==n2 else 'MISMATCH')
inv = d['items'][0]['id'] if d.get('items') else None

# heavy multi-facet: supplier+account+dept
qq = urllib.parse.urlencode({'account':'6010101','req':'','curr':'AED'})
ok, c, dt, d = call('/ap/invoices?account=6010101&limit=2', tok); res.append(('invoices account facet', ok, c, dt))

# LINES level
ok, c, dt, d = call('/ap/lines?limit=5', tok); res.append(('lines', ok, c, dt))
print('lines total:', d.get('total'), 'totals:', d.get('totals'))
ok, c, dt, d = call('/ap/lines?'+urllib.parse.urlencode({'dept':'DCT Finance'})+'&limit=5', tok); res.append(('lines dept facet', ok, c, dt))
if ok=='PASS':
    print('lines dept=DCT Finance total:', d['total'], 'depts:', {i.get('department') for i in d['items']})

# DISTS level
ok, c, dt, d = call('/ap/dists?limit=5', tok); res.append(('dists', ok, c, dt))
print('dists total:', d.get('total'), 'totals:', d.get('totals'))
ok, c, dt, d = call('/ap/dists?'+urllib.parse.urlencode({'sector':'Tourism'})+'&limit=5', tok); res.append(('dists sector facet', ok, c, dt))
if ok=='PASS':
    print('dists sector=Tourism total:', d['total'], 'sectors:', {i.get('sector') for i in d['items']})

# exports
ok, c, dt, body = call('/ap/lines/export?dept=' + urllib.parse.quote('DCT Finance'), tok, raw=True); res.append(('lines export', ok, c, dt))
if ok=='PASS': print('lines csv rows:', len(body.decode('utf-8-sig').splitlines())-1)
ok, c, dt, body = call('/ap/dists/export?sector=Tourism', tok, raw=True); res.append(('dists export', ok, c, dt))
if ok=='PASS': print('dists csv rows:', len(body.decode('utf-8-sig').splitlines())-1)

# detail + errors
if inv:
    ok, c, dt, d = call('/ap/invoices/%d' % inv, tok); res.append(('detail', ok, c, dt))
ok, c, dt, d = call('/ap/invoices/999999999', tok, expect=404); res.append(('detail 404', ok, c, dt))
ok, c, dt, d = call('/ap/lines', None, expect=401); res.append(('lines 401', ok, c, dt))
ok, c, dt, d = call('/ap/invoices?limit=999999&offset=-5', tok); res.append(('boundary limit/offset', ok, c, dt))
if ok=='PASS': print('boundary: limit clamped to', d['limit'], 'offset', d['offset'])

print()
allpass = True
for n, ok, c, dt in res:
    print('%-26s %s (%s) %.1fs' % (n, ok, c, dt)); allpass &= ok=='PASS'
sys.exit(0 if allpass else 1)
