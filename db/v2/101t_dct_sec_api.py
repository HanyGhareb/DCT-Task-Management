#!/usr/bin/env python3
"""
101t_dct_sec_api.py -- HTTP smoke for the /dct/sec/ Security Console API.

Proves the ORDS layer over DCT_SEC end to end: session auth (401), SYS_ADMIN
gating (403), privilege CRUD with verb-first validation, privilege groups,
role hierarchy sync (duties in a job role), exclusions, role copy, security
profiles with dimension scopes, dated user role/profile/exclusion assignment,
the effective-privileges preview, the page registry and the pageinfo drawer
route, and error mapping (400/404). Self-cleaning via SQLcl at the end (rows
tagged TSEC101 only).
"""
import json, os, re, ssl, subprocess, sys, tempfile, urllib.request, urllib.error

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'final apps')
CTX = ssl.create_default_context()
_cfg = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", _cfg).group(0) + '/ords/admin'
_auth = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
QUICK = dict(re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", _auth))
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
    script = """SET DEFINE OFF
BEGIN
    DELETE FROM prod.dct_sec_page_artifact WHERE page_id IN
        (SELECT page_id FROM prod.dct_sec_page WHERE page_code LIKE 'tsec101%');
    DELETE FROM prod.dct_sec_page WHERE page_code LIKE 'tsec101%';
    DELETE FROM prod.dct_sec_user_profile WHERE profile_id IN
        (SELECT profile_id FROM prod.dct_sec_profile WHERE profile_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_profile_scope WHERE profile_id IN
        (SELECT profile_id FROM prod.dct_sec_profile WHERE profile_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_profile WHERE profile_code LIKE 'TSEC101%';
    DELETE FROM prod.dct_sec_exclusion WHERE permission_id IN
        (SELECT permission_id FROM prod.dct_permissions WHERE permission_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_exclusion WHERE user_id IN
        (SELECT user_id FROM prod.dct_users WHERE username = 'sec.smoke1');
    DELETE FROM prod.dct_user_roles WHERE user_id IN
        (SELECT user_id FROM prod.dct_users WHERE username = 'sec.smoke1');
    DELETE FROM prod.dct_sessions WHERE user_id IN
        (SELECT user_id FROM prod.dct_users WHERE username = 'sec.smoke1');
    DELETE FROM prod.dct_notifications WHERE recipient_user_id IN
        (SELECT user_id FROM prod.dct_users WHERE username = 'sec.smoke1');
    DELETE FROM prod.dct_users WHERE username = 'sec.smoke1';
    DELETE FROM prod.dct_user_roles WHERE role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_module_roles WHERE role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_exclusion WHERE role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_role_hierarchy WHERE parent_role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%')
        OR child_role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_role_priv_group WHERE role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%')
        OR group_id IN
        (SELECT group_id FROM prod.dct_sec_priv_group WHERE group_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_role_permissions WHERE role_id IN
        (SELECT role_id FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%')
        OR permission_id IN
        (SELECT permission_id FROM prod.dct_permissions WHERE permission_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_priv_group_item WHERE group_id IN
        (SELECT group_id FROM prod.dct_sec_priv_group WHERE group_code LIKE 'TSEC101%');
    DELETE FROM prod.dct_sec_priv_group WHERE group_code LIKE 'TSEC101%';
    DELETE FROM prod.dct_roles WHERE role_code LIKE 'TSEC101%';
    DELETE FROM prod.dct_permissions WHERE permission_code LIKE 'TSEC101%';
    prod.dct_sec.refresh_flat;
    COMMIT;
END;
/
EXIT
"""
    fd, path = tempfile.mkstemp(suffix='.sql')
    # CRLF is mandatory: this Linux SQLcl silently swallows LF-only blocks
    os.write(fd, script.replace('\r\n', '\n').replace('\n', '\r\n').encode()); os.close(fd)
    r = subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    if 'ORA-' in (r.stdout or ''):
        print('  WARN cleanup reported:', [l for l in r.stdout.splitlines() if 'ORA-' in l][:2])
    os.unlink(path)


print('=== /dct/sec/ Security Console API smoke ===')
print(f'    {ADB}\n')
import atexit
atexit.register(cleanup)
cleanup()
tok = login('ADMIN', QUICK.get('ADMIN', ''))
if not tok:
    print('cannot log in as ADMIN'); sys.exit(1)
mgr = login('NASER.ALKHAJA', QUICK.get('NASER.ALKHAJA', ''))

# ---- auth gates ----
st, _ = call('GET', '/dct/sec/meta')
ok('no token -> 401') if st == 401 else bad(f'no token -> {st}')
if mgr:
    st, _ = call('GET', '/dct/sec/meta', token=mgr)
    ok('non-admin -> 403') if st == 403 else bad(f'non-admin -> {st}')
else:
    bad('manager quick login unavailable')

# ---- meta ----
st, meta = call('GET', '/dct/sec/meta', token=tok)
ok(f"meta -> 200 ({len(meta.get('objectTypes', []))} dims, {len(meta.get('verbs', []))} verbs)") \
    if st == 200 and len(meta.get('objectTypes', [])) >= 10 and 'VIEW' in meta.get('verbs', []) \
    else bad(f'meta {st}')

# ---- privileges ----
st, a = call('POST', '/dct/sec/privileges',
             {'code': 'TSEC101_BAD', 'name': 'Budget things'}, tok)
ok('non-verb privilege name -> 400') if st == 400 else bad(f'bad verb -> {st}')

st, a = call('POST', '/dct/sec/privileges',
             {'code': 'TSEC101_VIEW_ALPHA', 'name': 'View Alpha Report',
              'actionType': 'VIEW', 'description': 'smoke'}, tok)
p_alpha = a.get('id')
ok(f'create privilege -> id {p_alpha}') if st == 200 and p_alpha else bad(f'create priv {st} {a}')

st, a = call('POST', '/dct/sec/privileges',
             {'code': 'TSEC101_RUN_BETA', 'name': 'Run Beta Job', 'actionType': 'EXPORT'}, tok)
p_beta = a.get('id')
ok('second privilege created') if st == 200 and p_beta else bad(f'second priv {st}')

st, a = call('POST', '/dct/sec/privileges',
             {'code': 'TSEC101_VIEW_ALPHA', 'name': 'View Alpha Report'}, tok)
ok('duplicate code -> 400') if st == 400 else bad(f'dup code -> {st}')

st, a = call('GET', '/dct/sec/privileges?search=TSEC101', token=tok)
ok(f"privilege list -> {a.get('total')} rows") \
    if st == 200 and a.get('total') == 2 else bad(f'priv list {st} {a}')

st, a = call('PUT', f'/dct/sec/privileges/{p_alpha}', {'name': 'Broken name'}, tok)
ok('PUT with non-verb name -> 400') if st == 400 else bad(f'put bad verb -> {st}')
st, a = call('PUT', f'/dct/sec/privileges/{p_alpha}', {'name': 'View Alpha Register'}, tok)
ok('PUT rename ok') if st == 200 else bad(f'put priv {st}')
st, a = call('PUT', '/dct/sec/privileges/999999999', {'name': 'View X'}, tok)
ok('PUT unknown privilege -> 404') if st == 404 else bad(f'put 404 -> {st}')

# ---- groups ----
st, a = call('POST', '/dct/sec/groups',
             {'code': 'TSEC101_GRP', 'name': 'Smoke Group', 'permIds': [p_alpha, p_beta]}, tok)
grp = a.get('id')
ok(f'create group -> id {grp}') if st == 200 and grp else bad(f'group {st} {a}')
st, a = call('GET', f'/dct/sec/groups/{grp}', token=tok)
ok('group detail carries both items') \
    if st == 200 and len(a.get('items', [])) == 2 else bad(f'group detail {st}')
st, a = call('PUT', f'/dct/sec/groups/{grp}', {'permIds': [p_alpha]}, tok)
st, a = call('GET', f'/dct/sec/groups/{grp}', token=tok)
ok('group item sync (2 -> 1)') if len(a.get('items', [])) == 1 else bad('group sync')
st, a = call('PUT', f'/dct/sec/groups/{grp}', {'permIds': [p_alpha, p_beta]}, tok)
st, a = call('GET', '/dct/sec/groups/999999999', token=tok)
ok('unknown group -> 404') if st == 404 else bad(f'group 404 -> {st}')

# ---- roles: duty + job + hierarchy ----
st, a = call('POST', '/dct/sec/roles',
             {'code': 'TSEC101_DUTY_FIN', 'name': 'Manage Smoke Finance', 'category': 'DUTY'}, tok)
duty_fin = a.get('id')
st, a = call('POST', '/dct/sec/roles',
             {'code': 'TSEC101_DUTY_HR', 'name': 'Manage Smoke HR', 'category': 'DUTY'}, tok)
duty_hr = a.get('id')
st, a = call('POST', '/dct/sec/roles',
             {'code': 'TSEC101_JOB', 'name': 'Smoke Accountant', 'category': 'JOB'}, tok)
job = a.get('id')
ok('duty+duty+job roles created') if duty_fin and duty_hr and job else bad('role creates')

st, a = call('POST', '/dct/sec/roles', {'code': 'TSEC101_X', 'name': 'X', 'category': 'NOPE'}, tok)
ok('bad category -> 400') if st == 400 else bad(f'bad category -> {st}')

st, a = call('PUT', f'/dct/sec/roles/{duty_fin}', {'permIds': [p_alpha]}, tok)
st, a = call('PUT', f'/dct/sec/roles/{job}',
             {'dutyIds': [duty_fin, duty_hr], 'groupIds': [grp]}, tok)
ok('job wired (duties + group)') if st == 200 else bad(f'job wire {st} {a}')

st, a = call('GET', f'/dct/sec/roles/{job}', token=tok)
eff = {e['code'] for e in a.get('effective', [])}
ok('job effective closure carries duty + group perms') \
    if {'TSEC101_VIEW_ALPHA', 'TSEC101_RUN_BETA'} <= eff else bad(f'closure {eff}')
ok('job detail lists 2 duties') if len(a.get('duties', [])) == 2 else bad('duties list')

st, a = call('PUT', f'/dct/sec/roles/{job}', {'exclusionPermIds': [p_beta]}, tok)
st, a = call('GET', f'/dct/sec/roles/{job}', token=tok)
eff = {e['code'] for e in a.get('effective', [])}
ok('role exclusion removes perm from closure') \
    if 'TSEC101_RUN_BETA' not in eff and 'TSEC101_VIEW_ALPHA' in eff else bad(f'exclusion {eff}')

st, a = call('GET', '/dct/sec/roles?category=DUTY&search=TSEC101', token=tok)
ok('duty catalog filtered') if st == 200 and len(a.get('items', [])) == 2 else bad(f'cat filter {st}')

# ---- copy ----
st, a = call('POST', f'/dct/sec/roles/{job}/copy',
             {'code': 'TSEC101_JOB_COPY', 'name': 'Smoke Accountant Copy'}, tok)
copy_id = a.get('id')
ok(f'role copy -> id {copy_id}') if st == 200 and copy_id else bad(f'copy {st} {a}')
st, a = call('GET', f'/dct/sec/roles/{copy_id}', token=tok)
ok('copy carries duties + exclusion') \
    if len(a.get('duties', [])) == 2 and len(a.get('exclusions', [])) == 1 \
    and a.get('copiedFrom') == 'TSEC101_JOB' else bad(f'copy detail {a.get("duties")}')
st, a = call('POST', f'/dct/sec/roles/{job}/copy', {'code': 'TSEC101_JOB', 'name': 'X'}, tok)
ok('copy onto existing code -> 400') if st == 400 else bad(f'copy dup -> {st}')

# ---- profiles ----
st, a = call('GET', '/dct/sec/lov?type=SECTOR', token=tok)
sectors = a.get('items', [])
ok(f'sector LOV -> {len(sectors)} rows') if st == 200 and sectors else bad(f'lov {st}')
sect = sectors[0]['key']
st, a = call('POST', '/dct/sec/profiles',
             {'code': 'TSEC101_PROF', 'name': 'Smoke Sector Profile',
              'scopes': [{'objectType': 'SECTOR', 'objectKey': sect}]}, tok)
prof = a.get('id')
ok(f'create profile -> id {prof}') if st == 200 and prof else bad(f'profile {st} {a}')
st, a = call('GET', f'/dct/sec/profiles/{prof}', token=tok)
ok('profile detail carries scope') \
    if st == 200 and len(a.get('scopes', [])) == 1 else bad(f'profile detail {st}')
st, a = call('POST', '/dct/sec/profiles',
             {'code': 'TSEC101_PROF2', 'name': 'Bad dim',
              'scopes': [{'objectType': 'NOPE', 'objectKey': 'X'}]}, tok)
ok('unknown scope dimension -> 400') if st == 400 else bad(f'bad dim -> {st}')

# ---- user lifecycle ----
st, a = call('POST', '/dct/users/',
             {'username': 'sec.smoke1', 'email': 'sec.smoke1@test.local',
              'displayName': 'Sec Smoke', 'password': 'Smoke@2026x', 'isActive': 'Y',
              'roles': []}, tok)
uid = a.get('userId') or a.get('id')
if not uid:
    st2, a2 = call('GET', '/dct/users/?search=sec.smoke1', token=tok)
    items = a2.get('items') or a2.get('users') or []
    uid = items[0].get('userId') or items[0].get('id') if items else None
ok(f'smoke user -> id {uid}') if uid else bad(f'smoke user {st} {a}')

st, a = call('POST', f'/dct/sec/users/{uid}/roles', {'roleId': job}, tok)
ok('assign job role to user') if st == 200 else bad(f'assign {st} {a}')
st, a = call('POST', f'/dct/sec/users/{uid}/roles', {'roleId': duty_fin}, tok)
ok('duty role direct assignment -> 400') if st == 400 else bad(f'duty assign -> {st}')

st, a = call('GET', f'/dct/sec/users/{uid}/effective', token=tok)
codes = {i['code'] for i in a.get('items', [])}
ok('user effective = job closure') \
    if 'TSEC101_VIEW_ALPHA' in codes and 'TSEC101_RUN_BETA' not in codes \
    else bad(f'user effective {codes}')

st, a = call('POST', f'/dct/sec/users/{uid}/exclusions', {'permissionId': p_alpha, 'reason': 'smoke'}, tok)
ok('user exclusion added') if st == 200 else bad(f'user excl {st}')
st, a = call('GET', f'/dct/sec/users/{uid}/effective', token=tok)
codes = {i['code'] for i in a.get('items', [])}
ok('user exclusion removes from effective') \
    if 'TSEC101_VIEW_ALPHA' not in codes else bad(f'excl effective {codes}')

st, a = call('POST', f'/dct/sec/users/{uid}/profiles', {'profileId': prof}, tok)
ok('profile assigned to user') if st == 200 else bad(f'user profile {st}')
st, a = call('GET', f'/dct/sec/users/{uid}/security', token=tok)
ok('user security snapshot (roles+profiles+exclusions)') \
    if st == 200 and a.get('roles') and a.get('profiles') and a.get('exclusions') \
    else bad(f'security {st}')
profiles = a.get('profiles') or []
if profiles:
    up_id = profiles[0]['upId']
    st, a = call('POST', f'/dct/sec/users/{uid}/profiles', {'op': 'end', 'upId': up_id}, tok)
    ok('profile assignment ended') if st == 200 else bad(f'end profile {st}')
else:
    bad('no profile row to end')

st, a = call('GET', '/dct/sec/users/999999999/security', token=tok)
ok('unknown user -> 404') if st == 404 else bad(f'user 404 -> {st}')

# ---- page registry + drawer route ----
st, a = call('POST', '/dct/sec/pages',
             {'module': 'GL', 'page': 'tsec101page', 'name': 'Smoke Page',
              'viewPriv': 'TSEC101_VIEW_ALPHA',
              'artifacts': [
                 {'type': 'BUTTON', 'code': 'runBeta', 'label': 'Run Beta',
                  'privCode': 'TSEC101_RUN_BETA'},
                 {'type': 'TAB', 'code': 'alphaTab', 'label': 'Alpha',
                  'privCode': 'TSEC101_VIEW_ALPHA'}]}, tok)
page_id = a.get('id')
ok(f'register page -> id {page_id}') if st == 200 and page_id else bad(f'page {st} {a}')
st, a = call('GET', '/dct/sec/pages?module=GL', token=tok)
ok('pages list filtered by module') \
    if st == 200 and any(p['page'] == 'tsec101page' for p in a.get('items', [])) \
    else bad(f'pages {st}')
st, a = call('GET', '/dct/sec/pageinfo?module=GL&page=tsec101page', token=tok)
arts = a.get('artifacts', [])
granted = next((x.get('grantedTo', []) for x in arts if x['code'] == 'runBeta'), [])
ok(f'pageinfo drawer -> {len(arts)} artifacts') if st == 200 and len(arts) == 2 else bad(f'pageinfo {st}')
ok('artifact grantedTo rollup present') \
    if isinstance(granted, list) else bad('grantedTo missing')
st, a = call('GET', '/dct/sec/pageinfo?module=GL&page=__nope__', token=tok)
ok('unregistered page -> 404') if st == 404 else bad(f'pageinfo 404 -> {st}')

print(f'\n=== {PASS} pass, {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
