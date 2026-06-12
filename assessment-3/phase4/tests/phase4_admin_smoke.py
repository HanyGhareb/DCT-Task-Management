"""dct.admin Phase 4 smoke round 2 (status 200/201 both accepted)."""
import sys, os, re, json, urllib.request, urllib.error
from datetime import date, timedelta
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
                                 headers={'Content-Type': 'application/json'})
    if token: req.add_header('Authorization', 'Bearer ' + token)
    try:
        resp = urllib.request.urlopen(req, timeout=40)
        return resp.status, json.loads(resp.read().decode('utf-8', 'replace') or '{}')
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read().decode('utf-8', 'replace') or '{}')
        except Exception: return e.code, {}

st, auth = call('POST', '/auth/login', {'username': USER, 'password': PWD})
T = auth['sessionId']
ok = []
def check(name, cond, extra=''):
    ok.append(bool(cond)); print(('PASS' if cond else 'FAIL'), name, extra)

st, d = call('GET', '/approvals/pending', token=T)
items = d.get('items', [])
check('approvals/pending 200', st == 200, 'items=%d' % len(items))
check('pending has actingFor key', all('actingFor' in i for i in items) if items else True)
st, d2 = call('GET', '/approvals/?status=PENDING', token=T)
check('approvals/ 200', st == 200)
st, _ = call('GET', '/stats/', token=T)
check('stats/ 200', st == 200)

# delegations round-trip
st, users = call('GET', '/users/?limit=5', token=T)
other = next(u for u in users['items'] if u['username'] != USER)
end = (date.today() + timedelta(days=2)).isoformat()
st, cr = call('POST', '/delegations/', {'delegateId': other['userId'], 'scope': 'ALL_ROLES',
                                        'endDate': end, 'reason': 'phase4 smoke 2'}, token=T)
check('delegation POST', st in (200, 201) and cr.get('delegationId'))
did = cr.get('delegationId')
st, cn = call('POST', '/delegations/%d/cancel' % did, {}, token=T)
check('delegation cancel', st == 200 and cn.get('ok'))

# announcements: create, active, deactivate via PUT (the fixed handler), active hides
st, an = call('POST', '/announcements/', {'titleEn': 'Phase4 smoke banner 2',
                                          'bodyEn': 'temp', 'severity': 'WARNING',
                                          'audience': 'MODULE', 'moduleCode': 'FREELANCERS'}, token=T)
check('announcement POST', st in (200, 201) and an.get('announcementId'))
aid = an.get('announcementId')
st, act = call('GET', '/announcements/active?module=FREELANCERS', token=T)
check('active (module match) shows it', any(x['announcementId'] == aid for x in act.get('items', [])))
st, act = call('GET', '/announcements/active?module=PETTY_CASH', token=T)
check('active (other module) hides it', not any(x['announcementId'] == aid for x in act.get('items', [])))
st, up = call('PUT', '/announcements/%d' % aid, {'isActive': 'N', 'bodyEn': 'updated body'}, token=T)
check('announcement PUT (CLOB fix)', st == 200 and up.get('ok'))
st, act = call('GET', '/announcements/active?module=FREELANCERS', token=T)
check('active hides deactivated', not any(x['announcementId'] == aid for x in act.get('items', [])))

# also clean up announcement id 1 from round 1 (already inactive) - verify list shows both
st, alla = call('GET', '/announcements/', token=T)
check('announcements list 200', st == 200, 'items=%d' % len(alla.get('items', [])))

print('---')
print('%d/%d pass' % (sum(ok), len(ok)))
sys.exit(0 if all(ok) else 1)
