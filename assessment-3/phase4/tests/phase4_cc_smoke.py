"""CC ORDS read smoke — login via /dct/auth, hit every GET + a 401 probe."""
import sys, os, re, json, urllib.request, urllib.error
sys.stdout.reconfigure(encoding='utf-8')

BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
src = open(os.path.join(BASE, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)
cfg = open(os.path.join(BASE, 'FL', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", cfg).group(0)

def call(path, token=None, expect=200):
    req = urllib.request.Request(ADB + '/ords/admin' + path)
    if token: req.add_header('Authorization', 'Bearer ' + token)
    try:
        resp = urllib.request.urlopen(req, timeout=40)
        code, body = resp.status, resp.read().decode('utf-8', 'replace')
    except urllib.error.HTTPError as e:
        code, body = e.code, e.read().decode('utf-8', 'replace')
    ok = (code == expect)
    summary = ''
    if ok and code == 200:
        try:
            d = json.loads(body)
            if isinstance(d, dict):
                if 'items' in d: summary = 'items=%d' % len(d['items'])
                else: summary = ','.join(list(d.keys())[:6])
            elif isinstance(d, list): summary = 'array=%d' % len(d)
        except Exception: summary = body[:60]
    print('%s %-44s %s %s' % ('PASS' if ok else 'FAIL', path, code, summary))
    return ok

req = urllib.request.Request(ADB + '/ords/admin/dct/auth/login',
                             data=json.dumps({'username': USER, 'password': PWD}).encode(),
                             headers={'Content-Type': 'application/json'}, method='POST')
auth = json.loads(urllib.request.urlopen(req, timeout=40).read())
assert auth.get('sessionId'), 'login failed'
T = auth['sessionId']
print('login ok')

results = []
results.append(call('/cc/dashboard/stats', T))
results.append(call('/cc/dashboard/charts', T))
results.append(call('/cc/cards/', T))
results.append(call('/cc/cards/?mine=Y', T))
results.append(call('/cc/requests/', T))
results.append(call('/cc/requests/?mine=Y&status=DRAFT', T))
results.append(call('/cc/replenishments/', T))
results.append(call('/cc/doc-requirements', T))
results.append(call('/cc/doc-requirements?context=NEW_CARD', T))
results.append(call('/cc/documents/?sourceType=REQUEST', T))
results.append(call('/cc/proxies/', T))
results.append(call('/cc/approvals/pending', T))
results.append(call('/cc/lookups', T))
results.append(call('/cc/gl-codes', T))
results.append(call('/cc/settings', T))
results.append(call('/cc/notifications/', T))
results.append(call('/cc/dashboard/stats', None, expect=401))

print('---')
print('%d/%d pass' % (sum(results), len(results)))
sys.exit(0 if all(results) else 1)
