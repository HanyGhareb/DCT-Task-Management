# Beneficiaries dashboard (App 212) API smoke — suppnum facet + benef semantics.
# Auth: same pattern as the UAT runners — parse quick-login creds from the
# Admin app's authService.js (no credentials stored here).
import json, os, re, sys, time, urllib.request, urllib.parse

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
BASE = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
SUPPNUM = '26553'

def quick_of(app):
    src = open(os.path.join(ROOT, app, 'Jet', 'js', 'services', 'authService.js'),
               encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)

creds = quick_of('Admin')
if not creds:
    sys.exit('no quick-login creds found in Admin authService.js')
USER, PASS = creds[0]

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
    return ok, code, dt, (json.loads(body) if body and code == expect and not raw else body)

data = json.dumps({'username': USER, 'password': PASS}).encode()
req = urllib.request.Request(BASE + '/dct/auth/login', data=data,
                             headers={'Content-Type': 'application/json'})
tok = json.loads(urllib.request.urlopen(req, timeout=60).read())['sessionId']

res = []
def chk(name, ok, cond=True, note=''):
    st = 'PASS' if (ok == 'PASS' and cond) else 'FAIL'
    res.append((name, st, note))
    print('%-52s %s  %s' % (name, st, note))

Q = 'suppnum=' + SUPPNUM

# 1) filters scoped to the beneficiary supplier
ok, c, dt, f = call('/ap/filters?inclcxl=N&' + Q, tok)
sups = f.get('suppliers', []) if ok == 'PASS' else []
# invoices with no beneficiary name recorded legitimately keep the generic
# BENEFICIARY value (still filterable via the esupplier fallback)
chk('filters?suppnum LOVs', ok, len(sups) > 500,
    '%d names in the scoped supplier facet' % len(sups))

# 2) unfiltered filters regression — suppliers stays the raw supplier LOV
ok, c, dt, f0 = call('/ap/filters?inclcxl=N', tok)
chk('filters regression (no suppnum)', ok,
    'BENEFICIARY' in f0.get('suppliers', []),
    'raw supplier LOV intact')

# 3) summary scoped: KPI count == register total == SQL count (printed by caller)
ok, c, dt, s = call('/ap/summary?inclcxl=N&' + Q, tok)
k = s.get('kpis', {}) if ok == 'PASS' else {}
ok2, c2, dt2, r = call('/ap/invoices?inclcxl=N&limit=5&' + Q, tok)
chk('summary?suppnum KPIs', ok, k.get('invoices', 0) > 0,
    'invoices=%s beneficiaries=%s totalAed=%s' % (k.get('invoices'), k.get('suppliers'), k.get('totalAed')))
chk('summary count == register total', ok2, k.get('invoices') == r.get('total'),
    '%s vs %s' % (k.get('invoices'), r.get('total')))
items = r.get('items', [])
chk('register rows are beneficiary invoices', ok2,
    items and all(i.get('isBeneficiary') == 'Y' and i.get('supplierNumber') is not None
                  and str(i.get('supplierNumber')) == SUPPNUM for i in items),
    'supplierNumber=%s' % SUPPNUM)
chk('register rows carry supplierSite', ok2,
    items and all(i.get('supplierSite') for i in items),
    'e.g. %s' % (items[0].get('supplierSite') if items else '-'))

# aging reconciliation inside the scope
ag = sum(a['amount'] for a in s.get('aging', []))
chk('aging sum == outstanding KPI', ok, abs(ag - k.get('outstandingAed', 0)) < 1,
    '%.2f vs %.2f' % (ag, k.get('outstandingAed', 0)))
# top suppliers = beneficiary names
tops = s.get('topSuppliers', [])
chk('topSuppliers = beneficiary names', ok,
    tops and sum(1 for t in tops if t['name'] != 'BENEFICIARY') >= len(tops) - 1,
    (tops[0]['name'][:30] if tops else '-'))
# sector classification counts sum to the invoices KPI
sect = sum(x['count'] for x in s.get('bySector', []))
chk('bySector counts sum <= invoices KPI', ok, sect <= k.get('invoices', 0),
    '%s of %s (top-14 cap)' % (sect, k.get('invoices')))

# 4) esupplier facet within the scope (the benef "supplier name" facet)
name = sups[0] if sups else ''
qq = urllib.parse.urlencode({'suppnum': SUPPNUM, 'esupplier': name, 'inclcxl': 'N'})
ok, c, dt, r1 = call('/ap/invoices?limit=5&' + qq, tok)
chk('esupplier facet inside suppnum', ok,
    r1.get('total', 0) >= 1 and all(i.get('supplier') == name for i in r1.get('items', [])),
    '%s -> %s invoices' % (name[:28], r1.get('total')))

# 5) lines / dists levels scoped + site present
ok, c, dt, ln = call('/ap/lines?inclcxl=N&limit=5&' + Q, tok)
chk('lines?suppnum', ok,
    ln.get('total', 0) > 0 and all(x.get('isBeneficiary') == 'Y' and x.get('supplierSite')
                                   for x in ln.get('items', [])),
    'total=%s' % ln.get('total'))
ok, c, dt, ds = call('/ap/dists?inclcxl=N&limit=5&' + Q, tok)
chk('dists?suppnum', ok,
    ds.get('total', 0) > 0 and all(x.get('isBeneficiary') == 'Y' and x.get('supplierSite')
                                   for x in ds.get('items', [])),
    'total=%s' % ds.get('total'))

# 6) CSV exports scoped (header has the new Site column)
ok, c, dt, csv = call('/ap/invoices/export?inclcxl=N&' + Q, tok, raw=True)
head = csv.decode('utf-8-sig', 'replace').splitlines()
chk('invoices/export?suppnum CSV', ok,
    len(head) > 2 and ',Site,' in head[0] and ',Y,' in head[1],
    '%d rows' % (len(head) - 1))
ok, c, dt, csv = call('/ap/lines/export?inclcxl=N&' + Q, tok, raw=True)
head = csv.decode('utf-8-sig', 'replace').splitlines()
chk('lines/export?suppnum CSV', ok, len(head) > 2 and ',Site,' in head[0], '%d rows' % (len(head) - 1))
ok, c, dt, csv = call('/ap/dists/export?inclcxl=N&' + Q, tok, raw=True)
head = csv.decode('utf-8-sig', 'replace').splitlines()
chk('dists/export?suppnum CSV', ok, len(head) > 2 and ',Site,' in head[0], '%d rows' % (len(head) - 1))

# 7) regression: unscoped summary/register still agree (whole AP dashboard)
ok, c, dt, s0 = call('/ap/summary?inclcxl=N', tok)
ok2, c2, dt2, r0 = call('/ap/invoices?inclcxl=N&limit=1', tok)
chk('regression summary == register (no suppnum)', ok,
    ok2 == 'PASS' and s0['kpis']['invoices'] == r0['total'],
    '%s invoices' % s0['kpis']['invoices'])
chk('regression: benef scope < total', 'PASS',
    k.get('invoices', 0) < s0['kpis']['invoices'])

# 8) error handling: 401 without token
ok, c, dt, _ = call('/ap/summary?' + Q, None, expect=401)
chk('401 without token', ok)

fails = [x for x in res if x[1] == 'FAIL']
print('\n%d/%d PASS' % (len(res) - len(fails), len(res)))
sys.exit(1 if fails else 0)
