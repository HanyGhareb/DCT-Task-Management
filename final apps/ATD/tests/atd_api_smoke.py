"""ATD ORDS smoke — login as admin, exercise every endpoint."""
import os, re, json, urllib.request, urllib.error
BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
src = open(os.path.join(BASE,'Admin','Jet','js','services','authService.js'), encoding='utf-8').read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)
ADB = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com"

def call(path, token=None, method='GET', body=None, expect=200):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ADB+'/ords/admin'+path, data=data, method=method)
    if token: req.add_header('Authorization','Bearer '+token)
    if data is not None: req.add_header('Content-Type','application/json')
    try:
        r = urllib.request.urlopen(req, timeout=40); code, b = r.status, r.read().decode('utf-8','replace')
    except urllib.error.HTTPError as e:
        code, b = e.code, e.read().decode('utf-8','replace')
    ok = code == expect
    s = ''
    try:
        d = json.loads(b)
        if isinstance(d, dict): s = 'items=%d'%len(d['items']) if 'items' in d else ','.join(list(d.keys())[:6])
    except Exception: s = b[:50]
    print('%-4s %-6s %-30s %s %s' % ('PASS' if ok else 'FAIL', method, path, code, s))
    return ok, b

req = urllib.request.Request(ADB+'/ords/admin/dct/auth/login',
        data=json.dumps({'username':USER,'password':PWD}).encode(),
        headers={'Content-Type':'application/json'}, method='POST')
auth = json.loads(urllib.request.urlopen(req, timeout=40).read())
T = auth['sessionId']
print('login ok as', USER, '| roles:', ','.join(auth.get('roles', [])))

r = []
r.append(call('/atd/dashboard', T)[0])
r.append(call('/atd/lookups', T)[0])
r.append(call('/atd/jobs', T)[0])
r.append(call('/atd/envs', T)[0])
r.append(call('/atd/targets', T)[0])
r.append(call('/atd/runs', T)[0])
r.append(call('/atd/runs?status=SUCCESS&limit=5', T)[0])
# job round-trip
r.append(call('/atd/jobs', T, 'POST', {'jobName':'SMOKE_TEST','envName':'FUSION_ADGOV',
              'targetName':'ATD_LOCAL','sourceRef':'/x/y','stageTable':'ATD_SMOKE',
              'priority':9,'runOrder':99}, expect=200)[0])
r.append(call('/atd/jobs/SMOKE_TEST', T)[0])
r.append(call('/atd/jobs/SMOKE_TEST', T, 'PUT', {'priority':7,'columnMapJson':'{"A":"B"}'})[0])
r.append(call('/atd/jobs/SMOKE_TEST/enqueue', T, 'POST', {})[0])
r.append(call('/atd/jobs/SMOKE_TEST', T, 'DELETE')[0])
# queue ops
r.append(call('/atd/enqueue', T, 'POST', {})[0])
r.append(call('/atd/reap', T, 'POST', {'leaseMinutes':30})[0])
# negative: 404
r.append(call('/atd/jobs/NOPE', T, expect=404)[0])
print('\nRESULT:', 'ALL PASS' if all(r) else 'SOME FAIL (%d/%d)'%(sum(r),len(r)))
