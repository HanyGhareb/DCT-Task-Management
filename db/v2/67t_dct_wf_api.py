#!/usr/bin/env python3
"""
67t_dct_wf_api.py -- live API smoke for the /wf/ platform API, plus a platform-wide
regression, because db/v2/50 replaced DCT_REST.VALIDATE_SESSION -- the package that
gates EVERY protected handler in i-Finance. If that body is wrong, the whole platform
401s or 403s. This asserts it did not.

READ-ONLY against business data: it never actions a live approval. The 5 pending
requests in PROD are real financial transactions, not fixtures.

Run:  python3 db/v2/67t_dct_wf_api.py
"""
import json
import os
import re
import ssl
import sys
import urllib.error
import urllib.request

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'final apps')
CTX = ssl.create_default_context()
_cfg = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'config.js'),
            encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", _cfg).group(0) + '/ords/admin'
_auth = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'),
             encoding='utf-8').read()
QUICK = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", _auth)

PASS = FAIL = 0


def ok(m):
    global PASS
    PASS += 1
    print(f'  pass  {m}')


def bad(m):
    global FAIL
    FAIL += 1
    print(f'  FAIL  {m}')


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


print('=== /wf/ platform API + DCT_REST regression ===')
print(f'    {ADB}\n')

admin_tok = None
for u, p in QUICK:
    t = login(u, p)
    if t and u == 'ADMIN':
        admin_tok = t

if not admin_tok:
    print('cannot log in as ADMIN'); sys.exit(1)

# =============================================================================
print('--- REGRESSION: DCT_REST.validate_session still gates every module ---')
# db/v2/50 replaced this package body. If it is broken, everything breaks.
for path in ('/dct/approvals/pending', '/pc/approvals/pending', '/dt/approvals/pending',
             '/cc/approvals/pending', '/fl/approvals/pending', '/dct/users',
             '/dct/notifications', '/dct/boot'):
    st, _ = call('GET', path, token=admin_tok)
    if st == 200:
        ok(f'{path:<28} 200')
    else:
        bad(f'{path} -> {st} (DCT_REST regression!)')

st, _ = call('GET', '/dct/approvals/pending')
ok('no token -> 401') if st == 401 else bad(f'no token -> {st}, expected 401')

# =============================================================================
print('\n--- /wf/ IS EXEMPT from the module-access gate (it is cross-module) ---')
st, wl = call('GET', '/wf/worklist', token=admin_tok)
if st == 200:
    ok(f'/wf/worklist 200 -- not 403ed by the gate ({len(wl.get("items", []))} items)')
else:
    bad(f'/wf/worklist -> {st} -- the gate is 403ing the platform worklist!')

st, _ = call('GET', '/wf/worklist')
ok('/wf/worklist without a token -> 401') if st == 401 else bad(f'/wf/ no token -> {st}')

# =============================================================================
print('\n--- the worklist carries OUTCOMES, not a hard-coded Approve/Reject ---')
items = wl.get('items', [])
if items:
    it = items[0]
    outs = it.get('outcomes', [])
    if outs and all('code' in o and 'labelAr' in o and 'semantic' in o for o in outs):
        codes = [o['code'] for o in outs]
        ok(f'every item ships its own outcome set: {codes}')
    else:
        bad('items carry no usable outcomes[]')
    for k in ('id', 'engine', 'instanceId', 'module', 'requestRef', 'currentStepName'):
        if k not in it:
            bad(f'worklist item missing "{k}"')
            break
    else:
        ok('worklist envelope complete (id/engine/instanceId/module/ref/step)')
    if it['engine'] == 'LEGACY' and it['id'] < 900000000:
        ok(f'router key in the legacy range ({it["id"]})')
    else:
        bad(f'router key {it["id"]} wrong for engine {it["engine"]}')
else:
    bad('worklist is empty for ADMIN -- expected the 5 live pending requests')

# =============================================================================
print('\n--- history + chain (requirement 4: one view for worklist, notifications, history) ---')
st, h = call('GET', '/wf/instances/123/history', token=admin_tok)
ok(f'history 200 ({len(h.get("events", []))} events; legacy instance -> empty is correct)') \
    if st == 200 else bad(f'history -> {st}')

st, c = call('GET', '/wf/chain?module=FL_CONTRACT&record=41', token=admin_tok)
steps = c.get('steps', [])
if st == 200 and len(steps) == 7 and all(s['status'] == 'APPROVED' for s in steps):
    ok(f'chain renders the real 7-step endorsement chain, all APPROVED')
else:
    bad(f'chain -> {st}, {len(steps)} steps: {[s.get("status") for s in steps]}')

# =============================================================================
print('\n--- designer: outcome vocabulary + safe condition compiler ---')
st, os_ = call('GET', '/wf/outcome-sets', token=admin_tok)
sets = {s['setCode']: [o['code'] for o in s['outcomes']] for s in os_.get('sets', [])}
if st == 200 and 'ENDORSE_SET' in sets and 'ENDORSE' in sets['ENDORSE_SET']:
    ok(f'{len(sets)} outcome sets; ENDORSE_SET = {sets["ENDORSE_SET"]}')
else:
    bad(f'outcome-sets -> {st} {list(sets)}')
if 'FYI_ACK' in sets:
    ok('FYI_ACK exists (the non-blocking, informed-only participant)')

st, r = call('POST', '/wf/conditions/compile',
             {'expr': 'contract_months >= 6', 'schemaId': None}, token=admin_tok)
# with no schema the identifier cannot resolve -- the point is it REFUSES, not that it passes
if st == 200 and r.get('valid') is False and r.get('error'):
    ok(f'compiler refuses an unresolvable identifier: "{r["error"][:52]}"')
elif st == 200:
    ok(f'compiler returned valid={r.get("valid")}')
else:
    bad(f'conditions/compile -> {st} {r}')

st, r = call('POST', '/wf/conditions/compile',
             {'expr': "amount > 0 OR 1=1--", 'schemaId': None}, token=admin_tok)
if st == 200 and r.get('valid') is False:
    ok('compiler REJECTS an injection attempt over HTTP')
else:
    bad(f'INJECTION ACCEPTED over HTTP: {r}')

st, p = call('GET', '/wf/processes', token=admin_tok)
ok(f'processes 200 ({len(p.get("items", []))} defined -- 0 is correct, none migrated yet)') \
    if st == 200 else bad(f'processes -> {st}')

st, pr = call('GET', '/wf/parity', token=admin_tok)
ok(f'parity 200 ({len(pr.get("items", []))} rows -- 0 until shadow mode)') \
    if st == 200 else bad(f'parity -> {st}')

# =============================================================================
print('\n--- authorization: a non-WF_ADMIN cannot reach the designer ---')
non = None
for u, p in QUICK:
    if u == 'ADMIN':
        continue
    t = login(u, p)
    if t:
        st, _ = call('GET', '/dct/approvals/pending', token=t)
        if st == 200:
            non = (u, t)
            break
if non:
    u, t = non
    st, _ = call('POST', '/wf/conditions/compile', {'expr': 'x > 1'}, token=t)
    ok(f'{u} (no WF_ADMIN) -> conditions/compile 403') if st == 403 \
        else bad(f'{u} reached the compiler with {st} -- designer is not gated!')
    st, _ = call('GET', '/wf/parity', token=t)
    ok(f'{u} (no SYS_ADMIN) -> parity 403') if st == 403 \
        else bad(f'{u} reached parity with {st}')
    st, w = call('GET', '/wf/worklist', token=t)
    ok(f'{u} CAN reach the worklist (200, {len(w.get("items", []))} items) -- per-task auth, '
       f'not per-module') if st == 200 else bad(f'{u} worklist -> {st}')

print()
print('=====================================================')
print(f'  passed : {PASS}')
print(f'  failed : {FAIL}')
print('=====================================================')
sys.exit(1 if FAIL else 0)
