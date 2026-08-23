# Direct AP dashboard (App 212) API smoke — nopo facet + AP_DIRECT_REGISTER
# briefing book bridge. Auth: same pattern as the UAT runners — parse
# quick-login creds from the Admin app's authService.js (nothing stored here).
import json, os, re, sys, time, urllib.request, urllib.parse

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
BASE = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

def quick_of(app):
    src = open(os.path.join(ROOT, app, 'Jet', 'js', 'services', 'authService.js'),
               encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)

creds = quick_of('Admin')
if not creds:
    sys.exit('no quick-login creds found in Admin authService.js')
USER, PASS = creds[0]

def call(path, token=None, expect=200, raw=False, data=None):
    req = urllib.request.Request(BASE + path,
                                 data=(json.dumps(data).encode() if data is not None else None))
    if token: req.add_header('Authorization', 'Bearer ' + token)
    if data is not None: req.add_header('Content-Type', 'application/json')
    t0 = time.time()
    try:
        r = urllib.request.urlopen(req, timeout=300)
        body = r.read(); code = r.status
    except urllib.error.HTTPError as e:
        code = e.code; body = e.read()
    dt = time.time() - t0
    ok = 'PASS' if code == expect else 'FAIL'
    try:
        parsed = json.loads(body) if body and code == expect and not raw else body
    except Exception:
        parsed = body
    return ok, code, dt, parsed

data = json.dumps({'username': USER, 'password': PASS}).encode()
req = urllib.request.Request(BASE + '/dct/auth/login', data=data,
                             headers={'Content-Type': 'application/json'})
tok = json.loads(urllib.request.urlopen(req, timeout=60).read())['sessionId']

res = []
def chk(name, ok, cond=True, note=''):
    st = 'PASS' if (ok == 'PASS' and cond) else 'FAIL'
    res.append((name, st, note))
    print('%-56s %s  %s' % (name, st, note))

Q = 'nopo=Y&inclcxl=N'

# 1) filters scoped to direct invoices — projects LOV must be empty by rule
ok, c, dt, f = call('/ap/filters?' + Q, tok)
projects = f.get('projects', []) if ok == 'PASS' else ['x']
bus = f.get('businessUnits', []) if ok == 'PASS' else []
chk('filters?nopo=Y LOVs', ok, len(projects) == 0 and len(bus) > 0,
    'projects=%d BUs=%d (%.1fs)' % (len(projects), len(bus), dt))
ccs = f.get('costCenters', []) if ok == 'PASS' else []
chk('filters?nopo=Y still has GL coding LOVs', ok, len(ccs) > 0,
    '%d cost centers' % len(ccs))

# 2) unfiltered filters regression — projects LOV intact
ok, c, dt, f0 = call('/ap/filters?inclcxl=N', tok)
chk('filters regression (no nopo)', ok, len(f0.get('projects', [])) > 0,
    '%d projects in the unscoped LOV' % len(f0.get('projects', [])))

# 2b) chapter facet (2026-08-21): classification LOV present scoped + unscoped,
#     buckets sum to the invoice universe, and chapter= narrows the KPIs
chaps0 = f0.get('chapters', [])
chk('filters has chapters LOV (unscoped)', ok, len(chaps0) >= 3,
    '|'.join('%s:%s' % (c.get('name'), c.get('count')) for c in chaps0[:4]))
chaps = f.get('chapters', [])
chk('filters?nopo=Y has chapters LOV', 'PASS' if chaps else 'FAIL', len(chaps) > 0,
    '%d buckets in direct scope' % len(chaps))
okc, cc_, dtc, sc = call('/ap/summary?inclcxl=N&chapter=' + urllib.parse.quote('Chapter 2'), tok)
kc = sc.get('kpis', {}) if okc == 'PASS' else {}
ch2 = next((c.get('count', 0) for c in chaps0 if c.get('name') == 'Chapter 2'), None)
chk('summary?chapter=Chapter 2 == facet count', okc,
    kc.get('invoices', -1) == ch2, 'kpi=%s facet=%s' % (kc.get('invoices'), ch2))
okd, cd_, dtd, dsc = call('/ap/dists?inclcxl=N&chapter=' + urllib.parse.quote('Chapter 3') + '&limit=100', tok)
drows_c = dsc.get('items', []) if okd == 'PASS' else []
bad_c = [r for r in drows_c if (r.get('chapter') or 'Unclassified') != 'Chapter 3']
chk('dists?chapter=Chapter 3 rows re-applied', okd,
    len(drows_c) > 0 and not bad_c, 'rows=%d bad=%d' % (len(drows_c), len(bad_c)))

# 2c) PR guard (2026-08-21): no direct invoice may carry a PR reference
ok, c, dt, regp = call('/ap/invoices?' + Q + '&limit=200', tok)
pr_bad = [r for r in regp.get('items', []) if (r.get('prNumbers') or '').strip()]
chk('nopo=Y rows carry no PR references', ok, not pr_bad,
    'rows_with_pr=%d' % len(pr_bad))

# 3) summary scoped vs unscoped — the direct slice is a strict subset
ok, c, dt, s = call('/ap/summary?' + Q, tok)
k = s.get('kpis', {}) if ok == 'PASS' else {}
ok0, c0, dt0, s0 = call('/ap/summary?inclcxl=N', tok)
k0 = s0.get('kpis', {}) if ok0 == 'PASS' else {}
chk('summary?nopo=Y KPIs', ok,
    k.get('invoices', 0) > 0 and k.get('invoices', 0) < k0.get('invoices', 1),
    'direct=%s of all=%s, AED %.0f (%.1fs)'
    % (k.get('invoices'), k0.get('invoices'), k.get('totalAed') or 0, dt))

# 4) header register — every row must carry NO PO numbers
ok, c, dt, reg = call('/ap/invoices?' + Q + '&limit=200', tok)
items = reg.get('items', []) if ok == 'PASS' else []
bad = [r for r in items if (r.get('poNumbers') or '').strip()]
chk('invoices?nopo=Y register', ok,
    reg.get('total', 0) == k.get('invoices', -1) and len(items) > 0 and not bad,
    'total=%s rows=%d rows_with_po=%d' % (reg.get('total'), len(items), len(bad)))

# 5) line + dist grains — no PO / project on any row
ok, c, dt, ln = call('/ap/lines?' + Q + '&limit=200', tok)
lrows = ln.get('items', []) if ok == 'PASS' else []
lbad = [r for r in lrows if (str(r.get('poNumber') or '').strip()
                             or str(r.get('projectNumber') or '').strip())]
chk('lines?nopo=Y rows carry no po/project', ok, len(lrows) > 0 and not lbad,
    'rows=%d bad=%d' % (len(lrows), len(lbad)))
ok, c, dt, ds = call('/ap/dists?' + Q + '&limit=200', tok)
drows = ds.get('items', []) if ok == 'PASS' else []
dbad = [r for r in drows if (str(r.get('poNumber') or '').strip()
                             or str(r.get('projectNumber') or '').strip())]
chk('dists?nopo=Y rows carry no po/project', ok, len(drows) > 0 and not dbad,
    'rows=%d bad=%d' % (len(drows), len(dbad)))

# 6) CSV export honours the facet
ok, c, dt, csv = call('/ap/invoices/export?' + Q, tok, raw=True)
head = csv.decode('utf-8-sig', 'replace').splitlines()[:1] if ok == 'PASS' else ['']
chk('invoices/export?nopo=Y CSV', ok, head and head[0].startswith('Invoice Number'),
    '%d bytes' % len(csv))

# 7) briefing book bridge — enqueue, poll, download
ok, c, dt, r = call('/ap/direct/report', tok, data={'format': 'XLSX'})
run_id = r.get('runId') if ok == 'PASS' else None
chk('POST direct/report enqueues', ok, run_id is not None, 'runId=%s' % run_id)

ok, c, dt, e = call('/ap/direct/report', tok, expect=400, data={'format': 'PDF'})
chk('POST direct/report format=PDF -> 400', ok)

ok, c, dt, e = call('/ap/direct/report/999999999', tok, expect=404)
chk('GET direct/report/:bad -> 404', ok)

status = None
if run_id:
    for i in range(60):                       # up to 5 minutes
        time.sleep(5)
        ok, c, dt, st = call('/ap/direct/report/%s' % run_id, tok)
        status = st.get('status') if ok == 'PASS' else None
        if status in ('SUCCESS', 'FAILED'):
            break
    chk('report run completes', 'PASS' if status == 'SUCCESS' else 'FAIL',
        status == 'SUCCESS', 'status=%s rows=%s' % (status, st.get('rowCount')))
    if status == 'SUCCESS':
        ok, c, dt, blob = call('/ap/direct/report/%s/file' % run_id, tok, raw=True)
        chk('report file downloads (XLSX)', ok,
            isinstance(blob, bytes) and blob[:2] == b'PK',
            '%d bytes' % (len(blob) if isinstance(blob, bytes) else 0))

# 8) unauthenticated
ok, c, dt, e = call('/ap/summary?' + Q, None, expect=401)
chk('summary?nopo=Y without token -> 401', ok)

fails = [r for r in res if r[1] == 'FAIL']
print('\n%d/%d PASS' % (len(res) - len(fails), len(res)))
sys.exit(1 if fails else 0)
