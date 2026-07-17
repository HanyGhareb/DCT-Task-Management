#!/usr/bin/env python3
"""
69t_dct_wf_designer_api.py -- HTTP smoke for the /wf/ process-designer write API.

Proves the ORDS layer over DCT_WF_DESIGNER: session auth (401), owner-scoped
authz (403), error mapping (404), and a full write round-trip (clone-to-draft ->
save step -> save invalid condition -> read design -> validate -> discard).

Needs a throwaway process TEST_DZR_API seeded first (scratch dzr_setup.sql) and
cleaned after (dzr_cleanup.sql). Read-only against real data otherwise.
"""
import json, os, re, ssl, sys, urllib.request, urllib.error

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'final apps')
CTX = ssl.create_default_context()
_cfg = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", _cfg).group(0) + '/ords/admin'
_auth = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
QUICK = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", _auth)
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def call(method, path, body=None, token=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ADB + path, data=data, method=method)
    if data is not None:
        req.add_header('Content-Type', 'application/json')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    try:
        with urllib.request.urlopen(req, context=CTX, timeout=60) as r:
            raw = r.read()
            try:
                return r.status, json.loads(raw or b'{}')
            except Exception:
                return r.status, {'_raw': raw[:200].decode('utf-8', 'replace')}
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'{}')
        except Exception:
            return e.code, {}


def login(u, p):
    st, a = call('POST', '/dct/auth/login', {'username': u, 'password': p})
    return a.get('sessionId') if st == 200 else None


print('=== /wf/ designer API smoke ===')
print(f'    {ADB}\n')
tok = None
for u, p in QUICK:
    t = login(u, p)
    if t and u == 'ADMIN':
        tok = t
if not tok:
    print('cannot log in as ADMIN'); sys.exit(1)

# ---- auth + authz + error mapping ----
st, _ = call('GET', '/wf/processes')
ok('no token -> 401') if st == 401 else bad(f'no token -> {st}')
st, _ = call('GET', '/wf/processes', token=tok)
ok('GET /wf/processes -> 200') if st == 200 else bad(f'processes -> {st}')
st, _ = call('POST', '/wf/processes/__NOPE__/draft', {}, tok)
ok('draft of a missing process -> 404') if st == 404 else bad(f'draft missing -> {st}')
st, _ = call('GET', '/wf/versions/999999999/design', token=tok)
ok('design of a missing version -> 403') if st == 403 else bad(f'design missing -> {st}')

# ---- write round-trip on the seeded throwaway process ----
st, a = call('POST', '/wf/processes/TEST_DZR_API/draft', {}, tok)
vid = a.get('versionId')
ok(f'clone-to-draft -> 200 (v{a.get("versionNo")})') if st == 200 and vid else bad(f'draft -> {st} {a}')

if vid:
    st, a = call('PUT', f'/wf/versions/{vid}/step',
                 {'stepKey': 'LEGAL', 'nameEn': 'Legal review', 'nameAr': 'AR legal',
                  'outcomeSetCode': 'APPROVE_REJECT'}, tok)
    ok('PUT step (JSON body) -> 200') if st == 200 and a.get('stepId') else bad(f'put step -> {st} {a}')

    st, a = call('PUT', f'/wf/versions/{vid}/condition',
                 {'conditionKey': 'C1', 'expr': 'amount >>> 9', 'nameEn': 'bad', 'nameAr': 'ar'}, tok)
    ok('PUT invalid condition -> valid=N (compiled, not saved as valid)') \
        if st == 200 and a.get('valid') == 'N' else bad(f'condition -> {st} {a}')

    st, a = call('GET', f'/wf/versions/{vid}/design', token=tok)
    steps = a.get('steps', [])
    has_legal = any(s.get('stepKey') == 'LEGAL' for s in steps)
    ok(f'GET design shows the new step ({len(steps)} steps)') \
        if st == 200 and has_legal else bad(f'design -> {st}')

    st, a = call('POST', f'/wf/versions/{vid}/validate', {}, tok)
    ok('validate flags the incomplete draft (not clean)') \
        if st == 200 and a.get('clean') is False else bad(f'validate -> {st} {a}')

    st, a = call('DELETE', f'/wf/versions/{vid}', token=tok)
    ok('discard draft -> 200') if st == 200 else bad(f'discard -> {st} {a}')

print(f'\n  passed {PASS}  failed {FAIL}')
sys.exit(1 if FAIL else 0)
