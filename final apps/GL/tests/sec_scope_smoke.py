#!/usr/bin/env python3
"""
sec_scope_smoke.py -- GL Security Console adoption smoke (Phase 2).

Proves, against PROD:
  1. Equivalence: with FEATURE_SEC_ENFORCE_GL=N nothing changed -- a plain
     authenticated user still gets /gl/butil (grandfather path, NULL role).
  2. Data security: assigning a Sector security profile to that user filters
     /gl/butil to that sector only; SYS_ADMIN stays unrestricted.
  3. Enforcement flip: with FEATURE_SEC_ENFORCE_GL=Y the same user (no
     privilege) gets a clean 403; granting the GL_ANALYST job role (which
     nests the View Financial Planning Reports duty) restores 200 -- the
     full privilege -> duty -> job -> user chain.
Self-cleaning: profile, role assignment and the setting flip are reverted.
"""
import json, os, re, ssl, subprocess, sys, tempfile, urllib.request, urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
CTX = ssl.create_default_context()
_cfg = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", _cfg).group(0) + '/ords/admin'
_auth = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
QUICK = dict(re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", _auth))
PASS = FAIL = 0
TEST_USER = 'NASER.ALKHAJA'


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
        with urllib.request.urlopen(req, context=CTX, timeout=120) as r:
            try:
                return r.status, json.loads(r.read() or b'{}')
            except Exception:
                return r.status, {}
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'{}')
        except Exception:
            return e.code, {}


def login(u):
    st, a = call('POST', '/dct/auth/login', {'username': u, 'password': QUICK[u]})
    return a.get('sessionId') if st == 200 else None


def run_sql(stmts):
    script = 'SET DEFINE OFF\n' + stmts + '\nCOMMIT;\nEXIT\n'
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, script.encode()); os.close(fd)
    r = subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)
    return r.stdout


def set_enforce(val):
    run_sql("UPDATE prod.dct_system_settings SET setting_value='%s' "
            "WHERE setting_key='FEATURE_SEC_ENFORCE_GL';" % val)


def cleanup():
    run_sql("""
DELETE FROM prod.dct_sec_user_profile WHERE profile_id IN
  (SELECT profile_id FROM prod.dct_sec_profile WHERE profile_code='TSECGL_SCOPE');
DELETE FROM prod.dct_sec_profile_scope WHERE profile_id IN
  (SELECT profile_id FROM prod.dct_sec_profile WHERE profile_code='TSECGL_SCOPE');
DELETE FROM prod.dct_sec_profile WHERE profile_code='TSECGL_SCOPE';
DELETE FROM prod.dct_user_roles WHERE reason='TSECGL smoke'
   OR (assigned_by='ADMIN' AND role_id IN
       (SELECT role_id FROM prod.dct_roles WHERE role_code='GL_ANALYST')
       AND user_id IN (SELECT user_id FROM prod.dct_users WHERE username='%s'));
UPDATE prod.dct_system_settings SET setting_value='N'
 WHERE setting_key='FEATURE_SEC_ENFORCE_GL';
BEGIN prod.dct_sec.refresh_flat; END;
/
""" % TEST_USER)


print('=== GL Security Console adoption smoke ===')
print(f'    {ADB}\n')
import atexit
atexit.register(cleanup)
cleanup()

adm = login('ADMIN')
usr = login(TEST_USER)
if not adm or not usr:
    print('logins failed'); sys.exit(1)

st, f = call('GET', '/gl/butil/filters', token=adm)
year = f.get('years', [2026])[0] if st == 200 else 2026
sectors = f.get('sectors', [])
ok(f'butil filters -> 200 (year {year}, {len(sectors)} sectors)') \
    if st == 200 and sectors else bad(f'filters {st}')

# 1. equivalence: plain user still passes with enforcement off
st, a = call('GET', f'/gl/butil?year={year}&limit=5', token=usr)
ok('grandfather: plain user still gets /gl/butil (enforce=N)') \
    if st == 200 else bad(f'grandfather -> {st} {a}')

st, a = call('GET', f'/gl/butil?year={year}&limit=500', token=adm)
all_sectors = {r.get('sector') for r in a.get('items', a.get('rows', []))} - {'', None}
ok(f'admin sees {len(all_sectors)} sectors') if st == 200 and len(all_sectors) > 1 \
    else bad(f'admin rows {st} ({len(all_sectors)} sectors)')

# 2. data security: sector profile scopes the user
st, lov = call('GET', '/dct/sec/lov?type=SECTOR', token=adm)
target = None
for it in lov.get('items', []):
    if it['label'] in all_sectors:
        target = it
        break
if not target:
    bad('no LOV sector matches butil sectors'); sys.exit(1)

st, a = call('POST', '/dct/sec/profiles',
             {'code': 'TSECGL_SCOPE', 'name': 'Smoke Sector Scope',
              'scopes': [{'objectType': 'SECTOR', 'objectKey': target['key'],
                          'label': target['label']}]}, adm)
prof = a.get('id')
st2, u = call('GET', f'/dct/users/?search={TEST_USER}', token=adm)
uid = None
for it in (u.get('items') or u.get('users') or []):
    if (it.get('username') or '').upper() == TEST_USER:
        uid = it.get('userId') or it.get('id')
if prof and uid:
    st, _ = call('POST', f'/dct/sec/users/{uid}/profiles', {'profileId': prof}, adm)
    ok(f'sector profile ({target["label"]}) assigned to {TEST_USER}') if st == 200 else bad(f'assign {st}')
else:
    bad(f'profile/user setup (prof={prof}, uid={uid})')

st, a = call('GET', f'/gl/butil?year={year}&limit=500', token=usr)
scoped = {r.get('sector') for r in a.get('items', a.get('rows', []))} - {'', None}
ok(f'scoped user sees ONLY {target["label"]}') \
    if st == 200 and scoped and scoped <= {target['label']} else bad(f'scope leak: {scoped}')

st, a = call('GET', f'/gl/butil?year={year}&limit=500', token=adm)
adm_sectors = {r.get('sector') for r in a.get('items', a.get('rows', []))} - {'', None}
ok('SYS_ADMIN stays unrestricted') if len(adm_sectors) > 1 else bad('admin got scoped')

# 3. enforcement flip
set_enforce('Y')
st, a = call('GET', f'/gl/butil?year={year}&limit=5', token=usr)
ok('enforce=Y: user without privilege -> 403') if st == 403 else bad(f'enforce -> {st}')
st, a = call('GET', f'/gl/butil?year={year}&limit=5', token=adm)
ok('enforce=Y: SYS_ADMIN still 200') if st == 200 else bad(f'admin enforce -> {st}')

# grant the job role (privilege -> duty -> job -> user chain)
st, roles = call('GET', '/dct/sec/roles?category=JOB&search=GL_ANALYST', token=adm)
rid = next((r['id'] for r in roles.get('items', []) if r['code'] == 'GL_ANALYST'), None)
st, _ = call('POST', f'/dct/sec/users/{uid}/roles', {'roleId': rid, 'reason': 'TSECGL smoke'}, adm)
st, a = call('GET', f'/gl/butil?year={year}&limit=500', token=usr)
scoped = {r.get('sector') for r in a.get('items', a.get('rows', []))} - {'', None}
ok('enforce=Y: GL_ANALYST job role restores access') if st == 200 else bad(f'job role -> {st} {a}')
ok('scope still applies under enforcement') \
    if st == 200 and scoped <= {target['label']} else bad(f'scope under enforce: {scoped}')

set_enforce('N')
print(f'\n=== {PASS} pass, {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
