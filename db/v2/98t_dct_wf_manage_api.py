#!/usr/bin/env python3
"""
98t_dct_wf_manage_api.py -- HTTP smoke for the /wf/assign management routes (db/v2/98).

Proves: auth 401, manage/roles list+create+update+deactivate-warn, the
security-role-code collision guard, manage/object-types list+create against a
real view + bad-view/bad-column 400s, the dict view/column helpers, and the
reassign route's 404/400 guards. Self-cleaning via SQLcl (rows matched on the
ZZZ_SMOKE98 prefix).
"""
import json, os, re, ssl, subprocess, sys, tempfile, urllib.request, urllib.error

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'final apps')
CTX = ssl.create_default_context()
_cfg = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", _cfg).group(0) + '/ords/admin'
_auth = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
QUICK = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", _auth)
PASS = FAIL = 0
ROLE = 'ZZZ_SMOKE98_ROLE'
OTYPE = 'ZZZ_SMOKE98_OT'


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
            try:
                return r.status, json.loads(r.read() or b'{}')
            except Exception:
                return r.status, {}
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
BEGIN
    DELETE FROM prod.dct_wf_role_policy   WHERE role_code = '{ROLE}';
    DELETE FROM prod.dct_roles            WHERE role_code = '{ROLE}' AND role_type = 'DATA';
    DELETE FROM prod.dct_wf_object_type   WHERE object_type_code = '{OTYPE}';
    COMMIT;
END;
/
EXIT
"""
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, script.encode()); os.close(fd)
    subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)


print('=== /wf/assign management API smoke (db/v2/98) ===')
print(f'    {ADB}\n')
tok = None
for u, p in QUICK:
    if u == 'ADMIN':
        tok = login(u, p)
if not tok:
    print('cannot log in as ADMIN'); sys.exit(1)
cleanup()   # clear any residue from an aborted prior run

# ── auth ────────────────────────────────────────────────────────────────────
st, _ = call('GET', '/wf/assign/manage/roles')
ok('manage/roles no token -> 401') if st == 401 else bad(f'manage/roles no token -> {st}')
st, _ = call('GET', '/wf/assign/manage/object-types')
ok('manage/object-types no token -> 401') if st == 401 else bad(f'-> {st}')

# ── manage/roles ────────────────────────────────────────────────────────────
st, r = call('GET', '/wf/assign/manage/roles', token=tok)
items = (r or {}).get('items', [])
codes = [i['roleCode'] for i in items]
ok(f'roles list {len(items)} rows incl. seeds') if st == 200 and 'WF_FBP' in codes \
    else bad(f'roles list -> {st} {codes[:3]}')

st, r = call('POST', '/wf/assign/manage/roles',
             {'roleCode': ROLE, 'nameEn': 'Smoke Role', 'nameAr': 'دور',
              'singleAssignee': 'Y', 'isActive': 'Y'}, token=tok)
ok('create role -> 200') if st == 200 else bad(f'create role -> {st} {r}')

st, r = call('GET', '/wf/assign/manage/roles', token=tok)
row = [i for i in (r or {}).get('items', []) if i['roleCode'] == ROLE]
ok('new role listed, single=Y') if row and row[0]['singleAssignee'] == 'Y' \
    else bad(f'new role listing {row}')

st, r = call('GET', '/wf/assign/object-types', token=tok)
in_meta = ROLE in [x['roleCode'] for x in (r or {}).get('roles', [])]
ok('new role visible in picker metadata') if in_meta else bad('role missing from assignMeta')

st, r = call('POST', '/wf/assign/manage/roles',
             {'roleCode': ROLE, 'nameEn': 'Smoke Role v2', 'singleAssignee': 'N',
              'isActive': 'N'}, token=tok)
ok('update+deactivate role -> 200') if st == 200 else bad(f'update role -> {st} {r}')
st, r = call('GET', '/wf/assign/object-types', token=tok)
gone = ROLE not in [x['roleCode'] for x in (r or {}).get('roles', [])]
ok('deactivated role hidden from pickers') if gone else bad('inactive role still in assignMeta')

# a code that exists as a SECURITY role must be refused
st, r = call('POST', '/wf/assign/manage/roles',
             {'roleCode': 'SYS_ADMIN', 'nameEn': 'X'}, token=tok)
ok('security-role code collision -> 400') if st == 400 else bad(f'collision -> {st}')

st, r = call('POST', '/wf/assign/manage/roles',
             {'roleCode': 'bad code!', 'nameEn': 'X'}, token=tok)
ok('bad role code -> 400') if st == 400 else bad(f'bad code -> {st}')

# ── dict helpers ────────────────────────────────────────────────────────────
st, r = call('GET', '/wf/assign/dict?search=DCT_WF_OBJ', token=tok)
views = (r or {}).get('views', [])
ok(f'dict views search -> {len(views)} hits') if st == 200 and any('V_DCT_WF_OBJ' in v for v in views) \
    else bad(f'dict views -> {st} {views[:2]}')
st, r = call('GET', '/wf/assign/dict?view=V_DCT_WF_OBJ_PROJECT', token=tok)
cols = [c['name'] for c in (r or {}).get('columns', [])]
ok('dict columns of project LOV') if 'PROJECT_NUMBER' in cols else bad(f'columns {cols}')
st, r = call('GET', '/wf/assign/dict?view=BAD%3BDROP%20TABLE%20X', token=tok)
ok('malicious view name -> 400') if st == 400 else bad(f'injection view -> {st}')

# ── manage/object-types ─────────────────────────────────────────────────────
st, r = call('GET', '/wf/assign/manage/object-types', token=tok)
reg = (r or {}).get('items', [])
ok(f'registry list {len(reg)} rows') if st == 200 and len(reg) >= 10 else bad(f'registry -> {st}')

st, r = call('POST', '/wf/assign/manage/object-types',
             {'code': OTYPE, 'nameEn': 'Smoke Type', 'lovView': 'V_DCT_WF_OBJ_PROJECT',
              'keyCol': 'PROJECT_NUMBER', 'labelCol': 'PROJECT_NAME_EN',
              'keyIsNumeric': 'N', 'hierarchy': 'NONE'}, token=tok)
ok('create object type -> 200') if st == 200 else bad(f'create type -> {st} {r}')

st, r = call('GET', '/wf/assign/object-types', token=tok)
ok('new type live in picker metadata') if OTYPE in [x['code'] for x in (r or {}).get('items', [])] \
    else bad('new type missing from assignMeta')
st, r = call('GET', f'/wf/assign/lov?type={OTYPE}&search=', token=tok)
ok(f'new type LOV serves rows ({len((r or {}).get("items", []))})') \
    if st == 200 and (r or {}).get('items') else bad(f'new type LOV -> {st}')

st, r = call('POST', '/wf/assign/manage/object-types',
             {'code': 'ZZX', 'nameEn': 'X', 'lovView': 'NO_SUCH_VIEW_XX',
              'keyCol': 'A', 'labelCol': 'B'}, token=tok)
ok('unknown view -> 400') if st == 400 else bad(f'unknown view -> {st}')
st, r = call('POST', '/wf/assign/manage/object-types',
             {'code': 'ZZX', 'nameEn': 'X', 'lovView': 'V_DCT_WF_OBJ_PROJECT',
              'keyCol': 'NO_SUCH_COL', 'labelCol': 'PROJECT_NAME_EN'}, token=tok)
ok('unknown column -> 400') if st == 400 else bad(f'unknown col -> {st}')

st, r = call('POST', '/wf/assign/manage/object-types',
             {'code': OTYPE, 'nameEn': 'Smoke Type', 'lovView': 'V_DCT_WF_OBJ_PROJECT',
              'keyCol': 'PROJECT_NUMBER', 'labelCol': 'PROJECT_NAME_EN',
              'isActive': 'N'}, token=tok)
ok('deactivate type -> 200') if st == 200 else bad(f'deactivate type -> {st} {r}')
st, r = call('GET', '/wf/assign/object-types', token=tok)
ok('inactive type hidden from pickers') \
    if OTYPE not in [x['code'] for x in (r or {}).get('items', [])] \
    else bad('inactive type still in assignMeta')

# ── reassign guards ─────────────────────────────────────────────────────────
st, r = call('POST', '/wf/tasks/999999123/reassign', {'toUserId': 1}, token=tok)
ok('reassign unknown task -> 404') if st == 404 else bad(f'reassign 404 -> {st}')
st, r = call('POST', '/wf/tasks/999999123/reassign', {}, token=tok)
ok('reassign no target -> 400') if st == 400 else bad(f'reassign 400 -> {st}')

cleanup()
print(f'\n=== {PASS} passed, {FAIL} failed ===')
sys.exit(1 if FAIL else 0)
