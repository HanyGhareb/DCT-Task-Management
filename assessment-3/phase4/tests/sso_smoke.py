"""Cross-UI SSO hand-off (db/v2/41 + 41b) API smoke.

Covers POST /dct/sso/code and POST /dct/auth/sso plus the SSO$ sentinel on
POST /dct/auth/login (the JET->APEX redemption path, without needing APEX).
Flips FEATURE_SSO_HANDOFF via PUT /settings/ for the run and restores 'N'
(dark until the APEX Builder steps in Admin/docs/apex-sso-setup.md are done).
"""
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
        resp = urllib.request.urlopen(req, timeout=40)
        return resp.status, json.loads(resp.read().decode('utf-8', 'replace') or '{}')
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read().decode('utf-8', 'replace') or '{}')
        except Exception: return e.code, {}

ok = []
def check(name, cond, extra=''):
    ok.append(bool(cond)); print(('PASS' if cond else 'FAIL'), name, extra)

st, auth = call('POST', '/auth/login', {'username': USER, 'password': PWD})
assert st == 200, 'admin login failed: %s' % st
T = auth['sessionId']

def set_gate(v):
    st, d = call('PUT', '/settings/FEATURE_SSO_HANDOFF', {'value': v}, token=T)
    assert st == 200, 'gate flip failed: %s %s' % (st, d)

try:
    # ── gate OFF ─────────────────────────────────────────────────────────
    set_gate('N')
    st, d = call('POST', '/sso/code', {}, token=T)
    check('gate N: sso/code -> 403', st == 403, str(d))
    st, d = call('POST', '/auth/sso', {'code': 'deadbeef'})
    check('gate N: auth/sso -> 403', st == 403, str(d))

    # ── gate ON ──────────────────────────────────────────────────────────
    set_gate('Y')
    st, d = call('POST', '/sso/code', {})
    check('sso/code without bearer -> 401', st == 401)
    st, d = call('POST', '/sso/code', {}, token=T)
    check('sso/code -> 200', st == 200, str({k: (v[:12] + '...' if k == 'code' else v) for k, v in d.items()}))
    code = d.get('code', '')
    check('sso/code returns 64-hex code', bool(re.fullmatch(r'[0-9A-F]{64}', code)))
    check('sso/code returns apexUrl', 'P9999_SSO_CODE' in (d.get('apexUrl') or ''))
    check('sso/code returns expiresInSecs', d.get('expiresInSecs') == 60)

    # direction binding: a JET2APEX code must NOT redeem on auth/sso (APEX2JET)
    st, d2 = call('POST', '/auth/sso', {'code': code})
    check('auth/sso rejects JET2APEX code (direction-bound) -> 401', st == 401, str(d2))

    # JET->APEX redemption path: auth/login with the SSO$ sentinel password
    st, d2 = call('POST', '/auth/login', {'username': USER, 'password': 'SSO$' + code})
    check('auth/login with SSO$<code> -> 200 + session', st == 200 and d2.get('sessionId'))
    tok2 = d2.get('sessionId')
    if tok2:
        st, d3 = call('GET', '/boot', token=tok2)
        check('SSO-issued session works on GET /boot', st == 200)
    st, d2 = call('POST', '/auth/login', {'username': USER, 'password': 'SSO$' + code})
    check('replayed SSO$<code> -> 401 (single use)', st == 401)

    st, d2 = call('POST', '/auth/sso', {'code': 'not-a-real-code'})
    check('auth/sso garbage code -> 401', st == 401)
    st, d2 = call('POST', '/auth/sso', {})
    check('auth/sso missing code -> 400', st == 400)
finally:
    set_gate('N')
    print('gate restored to N')

print('----------------------------------------')
print('PASS=%d FAIL=%d' % (sum(ok), len(ok) - sum(ok)))
sys.exit(0 if all(ok) else 1)
