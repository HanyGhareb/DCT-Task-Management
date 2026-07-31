#!/usr/bin/env python3
"""
113t_dct_wf_cascade_api.py -- HTTP smoke for the cascade priority + matrix
import routes (db/v2/113). Self-cleaning via SQLcl.
"""
import json, os, re, ssl, subprocess, sys, tempfile, urllib.request, urllib.error

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


def sqlrun(script):
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, (script + '\nEXIT\n').encode()); os.close(fd)
    r = subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)
    return r.stdout


def cleanup():
    sqlrun("""SET DEFINE OFF
BEGIN
    UPDATE prod.dct_wf_role_assignment SET replaced_by_id = NULL
     WHERE notes LIKE 'Matrix import%' AND created_by = 'ADMIN';
    DELETE FROM prod.dct_wf_role_assignment
     WHERE (notes LIKE 'Matrix import%' OR notes LIKE 'Replaces assignment %')
       AND created_by = 'ADMIN' AND role_code = 'WF_KEY_USER';
    DELETE FROM prod.dct_wf_cascade_level WHERE role_code = 'WF_KEY_USER';
    COMMIT;
END;
/""")


print('=== cascade priority + matrix import API smoke (db/v2/113) ===')
print(f'    {ADB}\n')
tok = None
for u, p in QUICK:
    if u == 'ADMIN':
        tok = login(u, p)
if not tok:
    print('cannot log in as ADMIN'); sys.exit(1)
cleanup()

# ── auth ────────────────────────────────────────────────────────────────────
st, _ = call('GET', '/wf/assign/priority')
ok('priority no token -> 401') if st == 401 else bad(f'-> {st}')

# ── priority GET/PUT ────────────────────────────────────────────────────────
st, r = call('GET', '/wf/assign/priority', token=tok)
ok('priority GET: default = TASK,PROJECT,COST_CENTER,SECTOR') \
    if st == 200 and r.get('defaultLevels') == ['TASK', 'PROJECT', 'COST_CENTER', 'SECTOR'] \
    else bad(f'default -> {st} {r.get("defaultLevels")}')
ok(f'priority GET ships {len(r.get("types", []))} available levels') \
    if len(r.get('types', [])) >= 10 else bad('types missing')

st, r = call('PUT', '/wf/assign/priority',
             {'roleCode': 'WF_KEY_USER', 'levels': ['SECTOR', 'COST_CENTER']}, token=tok)
ok('override saved') if st == 200 else bad(f'override -> {st} {r}')
st, r = call('GET', '/wf/assign/priority', token=tok)
ov = [o for o in r.get('overrides', []) if o['roleCode'] == 'WF_KEY_USER']
ok('override read back in order') if ov and ov[0]['levels'] == ['SECTOR', 'COST_CENTER'] \
    else bad(f'override readback {ov}')
st, r = call('PUT', '/wf/assign/priority', {'roleCode': 'WF_KEY_USER', 'levels': []}, token=tok)
ok('empty list removes the override') if st == 200 else bad(f'remove -> {st}')
st, r = call('GET', '/wf/assign/priority', token=tok)
ok('override gone') if not [o for o in r.get('overrides', []) if o['roleCode'] == 'WF_KEY_USER'] \
    else bad('override still present')

st, r = call('PUT', '/wf/assign/priority', {'roleCode': None, 'levels': []}, token=tok)
ok('emptying the default -> 400') if st == 400 else bad(f'-> {st}')
st, r = call('PUT', '/wf/assign/priority',
             {'roleCode': None, 'levels': ['TASK', 'NO_SUCH']}, token=tok)
ok('unknown level -> 400') if st == 400 else bad(f'-> {st}')
st, r = call('GET', '/wf/assign/priority', token=tok)
ok('default untouched by failed saves') \
    if r.get('defaultLevels') == ['TASK', 'PROJECT', 'COST_CENTER', 'SECTOR'] else bad('default changed!')

# ── matrix import ───────────────────────────────────────────────────────────
# a real CC + a real user email straight from PROD
out = sqlrun("""SET PAGESIZE 0
SET HEADING OFF
SELECT 'CC=' || MIN(cost_center_code) FROM prod.v_dct_wf_obj_cost_center;
SELECT 'EM=' || LOWER(MIN(email)) FROM prod.dct_users WHERE is_active='Y' AND email LIKE '%@%';""")
cc = re.search(r'CC=(\S+)', out).group(1)
em = re.search(r'EM=(\S+)', out).group(1)

entries = [
    {'row': 1, 'cc': cc,        'role': 'WF_KEY_USER', 'email': em},
    {'row': 2, 'cc': '9999999', 'role': 'WF_KEY_USER', 'email': em},
    {'row': 3, 'cc': cc,        'role': 'WF_KEY_USER', 'email': 'nobody@nowhere.xx'},
    {'row': 4, 'cc': cc,        'role': 'NOT_A_ROLE',  'email': em},
]
st, r = call('POST', '/wf/assign/import', {'mode': 'dryrun', 'entries': entries}, token=tok)
res = {x['row']: x for x in r.get('results', [])}
ok('dryrun: valid row -> CREATED') if st == 200 and res.get(1, {}).get('status') == 'CREATED' \
    else bad(f'dryrun -> {st} {res.get(1)}')
ok('dryrun: unknown CC -> ERROR') if res.get(2, {}).get('status') == 'ERROR' else bad(f'{res.get(2)}')
ok('dryrun: unmatched email -> NO_USER (never auto-created)') \
    if res.get(3, {}).get('status') == 'NO_USER' else bad(f'{res.get(3)}')
ok('dryrun: unknown role -> ERROR') if res.get(4, {}).get('status') == 'ERROR' else bad(f'{res.get(4)}')
ok('dryrun changed NOTHING (summary only)') if r.get('created') == 1 and r.get('errors') == 3 \
    else bad(f'counts {r}')

st, r = call('POST', '/wf/assign/import',
             {'mode': 'apply', 'entries': [entries[0]]}, token=tok)
ok('apply: row created') if st == 200 and r.get('created') == 1 else bad(f'apply -> {st} {r}')
st, r = call('POST', '/wf/assign/import',
             {'mode': 'apply', 'entries': [entries[0]]}, token=tok)
ok('re-apply is idempotent (skipped)') if r.get('skipped') == 1 else bad(f're-apply {r}')

# the applied assignment is live in the normal list API
st, r = call('GET', f'/wf/assign/list?type=COST_CENTER&role=WF_KEY_USER&key={cc}', token=tok)
hit = [i for i in r.get('items', []) if i.get('status') == 'ACTIVE']
ok('applied assignment visible in the assignments list') if hit else bad('not listed')

st, r = call('POST', '/wf/assign/import', {'mode': 'bogus', 'entries': entries}, token=tok)
ok('bad mode -> 400') if st == 400 else bad(f'-> {st}')
st, r = call('POST', '/wf/assign/import', {'mode': 'dryrun', 'entries': []}, token=tok)
ok('no entries -> 400') if st == 400 else bad(f'-> {st}')

cleanup()
print(f'\n=== {PASS} passed, {FAIL} failed ===')
sys.exit(1 if FAIL else 0)
