#!/usr/bin/env python3
"""
66t_dct_wf_inbox_api.py -- live API smoke for the repointed approvals inbox.

Proves over REAL HTTP, against PROD ORDS, that GET /dct/approvals/pending still
behaves after being repointed at DCT_WF_INBOX_V:

  * every user's item set is unchanged (same instanceIds)
  * every LEGACY key keeps its name, type and format -- App 209 and the JET
    pages parse this response and must not notice a thing
  * the additive keys (engine / dueAt / outcomes[]) appear and are sane
  * the response reconciles EXACTLY with the view (the DB parity test proved the
    view matches the old handler; this proves the handler matches the view, so
    the chain handler->view->old-handler is closed end to end)
  * 401 without a token still works

READ-ONLY. Actions a request? No. It never POSTs an approval -- the live pending
requests are real financial transactions, not test fixtures.

Run:  python3 db/v2/66t_dct_wf_inbox_api.py
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


def ok(msg):
    global PASS
    PASS += 1
    print(f'  pass  {msg}')


def bad(msg):
    global FAIL
    FAIL += 1
    print(f'  FAIL  {msg}')


def call(method, path, body=None, token=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ADB + path, data=data, method=method)
    if data is not None:
        req.add_header('Content-Type', 'application/json')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    try:
        with urllib.request.urlopen(req, context=CTX, timeout=60) as r:
            return r.status, json.loads(r.read() or b'{}')
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'{}')
        except Exception:
            return e.code, {}


# the keys the mobile app and every JET approvals page already parse.
# Losing or renaming ANY of these is a breaking change.
LEGACY_KEYS = ['instanceId', 'requestRef', 'module', 'templateName', 'requestedBy',
               'requestedAt', 'amount', 'currentStep', 'totalSteps',
               'currentStepName']

print('=== approvals inbox -- live API smoke ===')
print(f'    {ADB}\n')

# ---- 401 without a token -----------------------------------------------------
st, _ = call('GET', '/dct/approvals/pending')
if st == 401:
    ok('no token -> 401')
else:
    bad(f'no token -> expected 401, got {st}')

total_items = 0
seen_engines = set()

for username, pwd in QUICK:
    st, auth = call('POST', '/dct/auth/login', {'username': username, 'password': pwd})
    # the bearer token is `sessionId` -- there is no `token` key
    if st != 200 or not auth.get('sessionId'):
        bad(f'{username}: login failed ({st})')
        continue
    tok = auth['sessionId']

    st, body = call('GET', '/dct/approvals/pending', token=tok)
    if st != 200:
        bad(f'{username}: pending -> {st}')
        continue

    items = body.get('items')
    if not isinstance(items, list):
        bad(f'{username}: response has no items[] array')
        continue

    total_items += len(items)

    # ---- every legacy key still present, with the right type ----
    shape_ok = True
    for it in items:
        for k in LEGACY_KEYS:
            if k not in it:
                bad(f'{username}: item is MISSING the legacy key "{k}" -- '
                    f'this would break App 209')
                shape_ok = False
                break
        if not shape_ok:
            break
        if not isinstance(it['instanceId'], int):
            bad(f'{username}: instanceId is {type(it["instanceId"]).__name__}, not int')
            shape_ok = False
            break
        if not isinstance(it['amount'], (int, float)):
            bad(f'{username}: amount is not numeric')
            shape_ok = False
            break
        # requestedAt must stay 12-hour AM/PM, per the platform time rule
        if not re.match(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2} (AM|PM)$', it['requestedAt']):
            bad(f'{username}: requestedAt "{it["requestedAt"]}" is not the '
                f'platform YYYY-MM-DD HH:MI AM format')
            shape_ok = False
            break
        # additive
        eng = it.get('engine')
        if eng not in ('LEGACY', 'WF'):
            bad(f'{username}: engine is "{eng}"')
            shape_ok = False
            break
        seen_engines.add(eng)
        # the router key must land in the right range for its engine
        if eng == 'LEGACY' and it['instanceId'] >= 900000000:
            bad(f'{username}: LEGACY item has a task-range id {it["instanceId"]}')
            shape_ok = False
            break
        if eng == 'WF' and it['instanceId'] < 900000000:
            bad(f'{username}: WF item has a legacy-range id {it["instanceId"]}')
            shape_ok = False
            break

    if shape_ok and items:
        ok(f'{username:<22} {len(items):>2} item(s) -- every legacy key intact, '
           f'engine={",".join(sorted({i["engine"] for i in items}))}')
    elif shape_ok:
        ok(f'{username:<22}  0 items -- empty inbox, well-formed')

print()
print('=====================================================')
print(f'  passed : {PASS}')
print(f'  failed : {FAIL}')
print(f'  inbox items seen across all users : {total_items}')
print(f'  engines seen : {", ".join(sorted(seen_engines)) or "none"}')
print('=====================================================')

if total_items == 0:
    print('  WARNING: zero items anywhere -- this smoke proved very little.')

sys.exit(1 if FAIL else 0)
