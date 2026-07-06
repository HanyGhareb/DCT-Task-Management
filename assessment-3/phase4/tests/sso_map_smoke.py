"""Smoke of the app-aware POST /dct/sso/code (41c)."""
import sys, os, re, json, urllib.request, urllib.error
sys.stdout.reconfigure(encoding='utf-8')

BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
src = open(os.path.join(BASE, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)
cfg = open(os.path.join(BASE, 'FL', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", cfg).group(0) + '/ords/admin/dct'

def call(method, path, body=None, token=None):
    req = urllib.request.Request(ADB + path, method=method,
                                 data=json.dumps(body).encode() if body is not None else None,
                                 headers={'Content-Type': 'application/json'} if body is not None else {})
    if token: req.add_header('Authorization', 'Bearer ' + token)
    try:
        r = urllib.request.urlopen(req, timeout=40)
        return r.status, json.loads(r.read().decode('utf-8', 'replace') or '{}')
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read().decode('utf-8', 'replace') or '{}')
        except Exception: return e.code, {}

ok = []
def check(name, cond, extra=''):
    ok.append(bool(cond)); print(('PASS' if cond else 'FAIL'), name, extra)

st, auth = call('POST', '/auth/login', {'username': USER, 'password': PWD})
T = auth['sessionId']

def app_of(d):
    mm = re.search(r'f\?p=(\d+):9999', d.get('apexUrl') or '')
    return mm.group(1) if mm else '?'

st, d = call('POST', '/sso/code', {}, token=T)
check('empty body -> 200, targets app 200', st == 200 and app_of(d) == '200' and d.get('targetApp') == '200', d.get('apexUrl', ''))
check('no %APP% left in url', '%APP%' not in (d.get('apexUrl') or ''))

st, d = call('POST', '/sso/code', {'app': '200'}, token=T)
check('app=200 -> targets 200', st == 200 and app_of(d) == '200')

st, d = call('POST', '/sso/code', {'app': '201'}, token=T)
check('app=201 (not allowlisted) -> falls back to 200', st == 200 and app_of(d) == '200' and d.get('targetApp') == '200')

st, d = call('POST', '/sso/code', {'app': 'DROP TABLE x'}, token=T)
check('garbage app -> falls back to 200', st == 200 and app_of(d) == '200')

# temporarily allowlist 201 to prove the mapping switches, then restore
st, _ = call('PUT', '/settings/APEX_SSO_APPS', {'value': '200,201'}, token=T)
st, d = call('POST', '/sso/code', {'app': '201'}, token=T)
check('app=201 (allowlisted) -> targets 201', st == 200 and app_of(d) == '201' and d.get('targetApp') == '201', d.get('apexUrl', ''))
st, _ = call('PUT', '/settings/APEX_SSO_APPS', {'value': '200'}, token=T)
print('allowlist restored to 200')

print('----------------------------------------')
print('PASS=%d FAIL=%d' % (sum(ok), len(ok) - sum(ok)))
sys.exit(0 if all(ok) else 1)
