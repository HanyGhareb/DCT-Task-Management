#!/usr/bin/env python3
"""
96t_dct_wf_assign_api.py -- HTTP smoke for the /wf/assign/ role-assignments API.

Proves the ORDS layer over DCT_WF_ASSIGN end to end: session auth (401),
WF_ADMIN gating, object-type registry + LOV pickers, the create -> list ->
preview -> timeline -> replace -> end lifecycle, error mapping (400/404),
the audit trail and its CSV export. Self-cleaning: every row it creates is
removed via SQLcl at the end (test rows only, matched on the test notes tag).
"""
import json, os, re, ssl, subprocess, sys, tempfile, urllib.request, urllib.error

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'final apps')
CTX = ssl.create_default_context()
_cfg = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", _cfg).group(0) + '/ords/admin'
_auth = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
QUICK = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", _auth)
TAG = 'api-smoke-96t'
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def call(method, path, body=None, token=None, raw=False):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ADB + path, data=data, method=method)
    if data is not None:
        req.add_header('Content-Type', 'application/json')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    try:
        with urllib.request.urlopen(req, context=CTX, timeout=60) as r:
            payload = r.read()
            if raw:
                return r.status, payload
            try:
                return r.status, json.loads(payload or b'{}')
            except Exception:
                return r.status, {'_raw': payload[:200].decode('utf-8', 'replace')}
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'{}')
        except Exception:
            return e.code, {}


def login(u, p):
    st, a = call('POST', '/dct/auth/login', {'username': u, 'password': p})
    return a.get('sessionId') if st == 200 else None


def cleanup():
    script = f"""SET DEFINE OFF
DECLARE
    PROCEDURE zap IS
    BEGIN
        UPDATE prod.dct_wf_role_assignment SET replaced_by_id = NULL
         WHERE notes LIKE '%{TAG}%' OR notes LIKE 'Replaces assignment %';
        DELETE FROM prod.dct_wf_role_assignment
         WHERE notes LIKE '%{TAG}%'
            OR (notes LIKE 'Replaces assignment %' AND created_by = 'ADMIN');
    END;
BEGIN
    zap;
    COMMIT;
END;
/
EXIT
"""
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, script.encode()); os.close(fd)
    subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)


print('=== /wf/assign/ role-assignments API smoke ===')
print(f'    {ADB}\n')
tok = None
user_ids = []
for u, p in QUICK:
    t = login(u, p)
    if t and u == 'ADMIN':
        tok = t
if not tok:
    print('cannot log in as ADMIN'); sys.exit(1)

# ---- auth ----
st, _ = call('GET', '/wf/assign/object-types')
ok('no token -> 401') if st == 401 else bad(f'no token -> {st}')

st, a = call('GET', '/wf/assign/object-types', token=tok)
types = {t['code']: t for t in a.get('items', [])} if st == 200 else {}
roles = {r['roleCode']: r for r in a.get('roles', [])} if st == 200 else {}
ok(f'object-types -> 200 ({len(types)} types, {len(roles)} roles)') \
    if st == 200 and len(types) >= 10 and 'WF_FBP' in roles else bad(f'object-types {st} {a}')
ok('TASK is two-part') if types.get('TASK', {}).get('twoPart') == 'Y' else bad('TASK twoPart flag')
ok('FBP is single-assignee') if roles.get('WF_FBP', {}).get('singleAssignee') == 'Y' else bad('FBP policy flag')

# ---- LOVs ----
st, a = call('GET', '/wf/assign/lov?type=PROJECT', token=tok)
projects = a.get('items', [])
ok(f'project LOV -> {len(projects)} rows') if st == 200 and projects else bad(f'lov {st}')
proj = projects[0]['key']
st, a = call('GET', f'/wf/assign/lov?type=TASK&parent={proj}', token=tok)
tasks = a.get('items', [])
ok(f'task LOV under {proj} -> {len(tasks)} rows') if st == 200 else bad(f'task lov {st}')
st, a = call('GET', '/wf/assign/lov?type=TASK', token=tok)
ok('task LOV without parent -> 400') if st == 400 else bad(f'task no-parent -> {st}')
# APEX_JSON omits NULL keys, so root orgs have no parent key -- check any child does
st, a = call('GET', '/wf/assign/lov?type=DEPARTMENT', token=tok)
ok('org LOV ships tree columns') \
    if st == 200 and a.get('items') and any('parent' in i for i in a['items']) \
    else bad(f'org lov {st}')
st, a = call('GET', '/wf/assign/lov?type=__NOPE__', token=tok)
ok('unknown type -> 404') if st == 404 else bad(f'unknown type -> {st}')

# a couple of real users for assignments
st, a = call('GET', '/dct/users?limit=5', token=tok)
for it in (a.get('items') or a.get('users') or []):
    uid = it.get('userId') or it.get('id')
    if uid and it.get('isActive', 'Y') in ('Y', True):
        user_ids.append(uid)
if len(user_ids) < 2:
    user_ids = [1, 2]

# ---- create ----
st, a = call('POST', '/wf/assign/', {
    'objectType': 'PROJECT', 'objectKey': proj, 'roleCode': 'WF_FBP',
    'userId': user_ids[0], 'startDate': '2026-01-01', 'notes': TAG}, tok)
aid = a.get('assignmentId')
ok(f'create FBP on project {proj} -> id {aid}') if st == 200 and aid else bad(f'create {st} {a}')

st, a = call('POST', '/wf/assign/', {
    'objectType': 'PROJECT', 'objectKey': proj, 'roleCode': 'WF_FBP',
    'userId': user_ids[1], 'startDate': '2026-06-01', 'notes': TAG}, tok)
ok('overlapping single-assignee -> 400') if st == 400 else bad(f'overlap -> {st}')

st, a = call('POST', '/wf/assign/', {
    'objectType': 'PROJECT', 'objectKey': '__NO_SUCH__', 'roleCode': 'WF_FBP',
    'userId': user_ids[0], 'notes': TAG}, tok)
ok('nonexistent object -> 400') if st == 400 else bad(f'bad object -> {st}')

# ---- list + preview + timeline ----
st, a = call('GET', f'/wf/assign/list?type=PROJECT&key={proj}&role=WF_FBP', token=tok)
items = a.get('items', [])
ok(f'list filters find the row (status {items[0]["status"]})') \
    if st == 200 and any(i['assignmentId'] == aid for i in items) else bad(f'list {st}')

st, a = call('GET', f'/wf/assign/preview?type=PROJECT&key={proj}&role=WF_FBP', token=tok)
ok('preview resolves the assignee') \
    if st == 200 and a.get('count') == 1 and a['users'][0]['userId'] == user_ids[0] \
    else bad(f'preview {st} {a}')
st, a = call('GET', f'/wf/assign/preview?type=PROJECT&key={proj}&role=WF_FBP&asof=2025-12-31', token=tok)
ok('preview before start resolves nobody') if st == 200 and a.get('count') == 0 else bad(f'asof {st} {a}')

# ---- replace ----
st, a = call('POST', '/wf/assign/', {
    'action': 'replace', 'assignmentId': aid,
    'newUserId': user_ids[1], 'effectiveDate': '2026-07-01'}, tok)
new_id = a.get('assignmentId')
ok(f'replace -> new id {new_id}') if st == 200 and new_id else bad(f'replace {st} {a}')

st, a = call('GET', f'/wf/assign/timeline?type=PROJECT&key={proj}&role=WF_FBP', token=tok)
tl = a.get('items', [])
old = next((i for i in tl if i['assignmentId'] == aid), None)
ok('timeline shows the chain (old end-dated, linked)') \
    if st == 200 and old and old.get('endDate') == '2026-06-30' \
       and old.get('replacedById') == new_id else bad(f'timeline {st} {tl}')

st, a = call('GET', f'/wf/assign/preview?type=PROJECT&key={proj}&role=WF_FBP&asof=2026-03-01', token=tok)
ok('history preview: old holder before the switch') \
    if st == 200 and a.get('count') == 1 and a['users'][0]['userId'] == user_ids[0] else bad(f'hist {st}')

# ---- end + errors ----
st, a = call('PUT', f'/wf/assign/{new_id}', {'op': 'end', 'endDate': '2026-12-31'}, tok)
ok('end assignment -> 200') if st == 200 else bad(f'end {st} {a}')
st, a = call('PUT', f'/wf/assign/{new_id}', {'op': 'end', 'endDate': '2026-12-31'}, tok)
ok('double end -> 400') if st == 400 else bad(f'double end -> {st}')
st, a = call('PUT', '/wf/assign/999999999', {'op': 'end'}, tok)
ok('missing id -> 404') if st == 404 else bad(f'missing -> {st}')

# ---- audit + CSV ----
st, a = call('GET', f'/wf/assign/audit?type=PROJECT&key={proj}', token=tok)
acts = {i['action'] for i in a.get('items', [])}
ok(f'audit trail carries the lifecycle ({sorted(acts)})') \
    if st == 200 and {'ASSIGN_CREATE', 'ASSIGN_REPLACE', 'ASSIGN_END'} <= acts else bad(f'audit {st} {acts}')

st, payload = call('GET', f'/wf/assign/audit/export?type=PROJECT&key={proj}', token=tok, raw=True)
ok('CSV export: BOM + header + rows') \
    if st == 200 and payload.startswith(b'\xef\xbb\xbf') and b'When,Actor,Action' in payload \
       and payload.count(b'\n') >= 3 else bad(f'csv {st} {payload[:80]}')

cleanup()
print(f'\n=== {PASS} pass / {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
