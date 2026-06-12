"""Phase 4 — Stage 6 integration seed (idempotent-ish; safe to re-run pieces).

Role grants + CC lifecycle + extra FL records + 1 delegation + 2 announcements.
Credentials are parsed at runtime from the apps' authService QUICK_LOGINS and
never printed. Run: python phase4_seed.py
"""
import sys, os, re, json, base64, urllib.request, urllib.error
from datetime import date, timedelta
sys.stdout.reconfigure(encoding='utf-8')

BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
cfg = open(os.path.join(BASE, 'FL', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", cfg).group(0) + '/ords/admin'

def creds_of(app, username):
    src = open(os.path.join(BASE, app, 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
    m = re.search(r"username:\s*'" + re.escape(username) + r"',\s*password:\s*'([^']+)'", src)
    return m.group(1)

def call(method, path, body=None, token=None):
    req = urllib.request.Request(ADB + path, method=method,
                                 data=json.dumps(body).encode() if body is not None else None,
                                 headers={'Content-Type': 'application/json'})
    if token: req.add_header('Authorization', 'Bearer ' + token)
    try:
        resp = urllib.request.urlopen(req, timeout=60)
        return resp.status, json.loads(resp.read().decode('utf-8', 'replace') or '{}')
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read().decode('utf-8', 'replace') or '{}')
        except Exception: return e.code, {}

def login(username, password):
    st, d = call('POST', '/dct/auth/login', {'username': username, 'password': password})
    assert d.get('sessionId'), 'login failed for ' + username
    return d['sessionId'], d['userId']

# tiny valid 1x1 PNG for document uploads
PNG_B64 = base64.b64encode(base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==')).decode()

T, ADMIN_UID = login('ADMIN', creds_of('Admin', 'ADMIN'))
print('[1] ADMIN login ok')

# ── users lookup ─────────────────────────────────────────────────────────────
st, ur = call('GET', '/dct/users/?limit=200', token=T)
users = {u['username']: u for u in ur['items']}
def user_of(name):
    if name not in users:
        st2, r2 = call('GET', '/dct/users/?search=' + name.split('.')[0], token=T)
        for u in r2.get('items', []):
            users[u['username']] = u
    return users.get(name)
def uid(name): return user_of(name)['userId']

# ── role grants (PUT /users/:id roles = replace-all, so merge) ───────────────
GRANTS = {
    'AYESHA.AMERI':     ['FL_ADMIN'],
    'NASER.ALKHAJA':    ['FL_MANAGER', 'CC_ADMIN'],
    'SHAIKHA.GALAMERI': ['FL_USER'],
}
for uname, add in GRANTS.items():
    have = [r for r in (users[uname].get('rolesCsv') or '').split(',') if r]
    merged = sorted(set(have + add))
    if set(merged) == set(have):
        print('[2] %s roles already include %s' % (uname, add)); continue
    st, d = call('PUT', '/dct/users/%d' % uid(uname), {'roles': merged}, token=T)
    print('[2] %s roles -> %s (%s)' % (uname, merged, 'ok' if d.get('ok') else 'FAIL ' + str(st)))

# ── CC: NEW_CARD requests through approval, then register 2 cards ────────────
def cc_new_card_to_registered(holder_uname, limit_aed, label):
    holder = user_of(holder_uname)
    if not holder:
        print('[3] %s: user not found — skipped' % holder_uname); return None
    st, ex = call('GET', '/cc/cards/?search=' + holder['displayName'].split(' ')[0], token=T)
    mine = [c for c in ex.get('items', []) if c['holderUserId'] == holder['userId']
            and c['status'] != 'CLOSED']
    if mine:
        print('[3] %s already holds card %s — skipped' % (holder_uname, mine[0]['ccNumber']))
        return mine[0]['ccId']
    st, req = call('POST', '/cc/requests/', {'requestType': 'NEW_CARD',
                                             'requestedLimit': limit_aed,
                                             'reason': 'Phase 4 seed — ' + label}, token=T)
    rid, rnum = req['requestId'], req['requestNumber']
    # mandatory docs
    st, dr = call('GET', '/cc/doc-requirements?context=NEW_CARD', token=T)
    for d in dr['items']:
        if d['isMandatory'] != 'Y': continue
        st, doc = call('POST', '/cc/documents/', {'sourceType': 'REQUEST', 'sourceId': rid,
                                                  'docReqId': d['docReqId'], 'docTypeId': d['docTypeId'],
                                                  'fileName': 'seed_' + str(d['docReqId']) + '.png',
                                                  'mimeType': 'image/png'}, token=T)
        call('PUT', '/cc/documents/%d/file' % doc['documentId'],
             {'file_data_b64': PNG_B64, 'mime_type': 'image/png'}, token=T)
    st, d = call('POST', '/cc/requests/%d/submit' % rid, {}, token=T)
    assert d.get('ok'), 'submit failed: ' + str(d)
    # approve every pending step (SYS_ADMIN may act)
    for _ in range(5):
        st, pend = call('GET', '/cc/approvals/pending', token=T)
        inst = next((p for p in pend['items'] if p['requestRef'] == rnum), None)
        if not inst: break
        call('POST', '/cc/approvals/%d/action' % inst['instanceId'],
             {'action': 'APPROVED', 'comments': 'Phase 4 seed approval'}, token=T)
    st, reg = call('POST', '/cc/cards/register', {
        'requestId': rid, 'holderUserId': holder['userId'],
        'motherName': 'Seed Mother', 'nationality': 'Emirati',
        'creditLimit': limit_aed,
        'expiryDate': (date.today() + timedelta(days=3 * 365)).isoformat(),
        'email': holder.get('email') or (holder_uname.lower() + '@dct.gov.ae'),
        'orgId': holder['orgId'], 'costCenter': 'CC-100'}, token=T)
    print('[3] %s: request %s -> card ccId=%s' % (holder_uname, rnum, reg.get('ccId', 'FAIL ' + str(st) + str(reg))))
    return reg.get('ccId')

cc1 = cc_new_card_to_registered('SHAIKHA.ALSUWAIDI', 20000, 'primary holder')
cc2 = cc_new_card_to_registered('NOORA.ALALI', 12000, 'second holder')

# ── CC: INCREASE_LIMIT submitted then withdrawn ───────────────────────────────
if cc1:
    st, req = call('POST', '/cc/requests/', {'ccId': cc1, 'requestType': 'INCREASE_LIMIT',
                                             'requestedLimit': 30000,
                                             'reason': 'Phase 4 seed — to be withdrawn'}, token=T)
    rid = req['requestId']
    st, dr = call('GET', '/cc/doc-requirements?context=INCREASE_LIMIT', token=T)
    for d in dr['items']:
        if d['isMandatory'] != 'Y': continue
        st, doc = call('POST', '/cc/documents/', {'sourceType': 'REQUEST', 'sourceId': rid,
                                                  'docReqId': d['docReqId'], 'docTypeId': d['docTypeId'],
                                                  'fileName': 'seed_inc.png', 'mimeType': 'image/png'}, token=T)
        call('PUT', '/cc/documents/%d/file' % doc['documentId'],
             {'file_data_b64': PNG_B64, 'mime_type': 'image/png'}, token=T)
    call('POST', '/cc/requests/%d/submit' % rid, {}, token=T)
    st, d = call('POST', '/cc/requests/%d/withdraw' % rid, {}, token=T)
    print('[4] INCREASE_LIMIT submitted+withdrawn:', 'ok' if d.get('ok') else 'FAIL ' + str(d))

# ── CC: replenishment with 3 merchant lines, submitted by the holder ─────────
if cc1:
    HT, _ = login('SHAIKHA.ALSUWAIDI', creds_of('CC', 'SHAIKHA.ALSUWAIDI'))
    prev = (date.today().replace(day=1) - timedelta(days=1))
    st, rep = call('POST', '/cc/replenishments/', {'ccId': cc1, 'periodMonth': prev.month,
                                                   'periodYear': prev.year}, token=HT)
    if st in (200, 201):
        repid = rep['replenishmentId']
        st, gl = call('GET', '/cc/gl-codes', token=HT)
        glid = next(g['ccId'] for g in gl if g['isActive'] == 'Y')
        lines = [
            {'expenseDate': prev.replace(day=5).isoformat(),  'merchantName': 'Etisalat',
             'amount': 420.50, 'description': 'Office connectivity', 'codingType': 'GL',
             'ccIdGl': glid, 'receiptAttached': 'Y'},
            {'expenseDate': prev.replace(day=12).isoformat(), 'merchantName': 'Amazon AE',
             'amount': 1310.00, 'description': 'Event supplies', 'codingType': 'GL',
             'ccIdGl': glid, 'receiptAttached': 'Y'},
            {'expenseDate': prev.replace(day=21).isoformat(), 'merchantName': 'ADNOC',
             'amount': 240.00, 'description': 'Fleet fuel', 'codingType': 'GL',
             'ccIdGl': glid, 'receiptAttached': 'N'},
        ]
        st, d = call('PUT', '/cc/replenishments/%d/lines' % repid, {'lines': lines}, token=HT)
        st, d = call('POST', '/cc/replenishments/%d/submit' % repid, {}, token=HT)
        print('[5] replenishment %s, 3 lines, submitted: %s' % (rep['reimbNumber'], 'ok' if d.get('ok') else 'FAIL ' + str(d)))
    else:
        print('[5] replenishment create skipped:', st, rep)

# ── FL: extra registrations (1 DRAFT + 1 SUBMITTED) + a >=50k 2-step contract ─
# nationality codes are 2-letter ISO from dct_nationality — resolve via lookups
st, lk = call('GET', '/fl/lookups', token=T)
nats = lk.get('nationalities', [])
def nat(namepart):
    for n in nats:
        if namepart.lower() in n['name'].lower(): return n['code']
    return nats[0]['code']

st, reg1 = call('POST', '/fl/registrations/', {'firstNameEn': 'Omar', 'lastNameEn': 'Saleh',
    'dateOfBirth': '1990-03-14', 'nationalityCode': nat('jordan'), 'email': 'omar.saleh.uat@example.com',
    'mobile': '+971501112233', 'specialization': 'Video editing', 'notes': 'Phase 4 seed — stays DRAFT'}, token=T)
print('[6] FL registration DRAFT:', reg1.get('registrationNumber', 'FAIL ' + str(st)))

st, reg2 = call('POST', '/fl/registrations/', {'firstNameEn': 'Mariam', 'lastNameEn': 'Khalil',
    'dateOfBirth': '1995-08-02', 'nationalityCode': nat('leban'), 'email': 'mariam.khalil.uat@example.com',
    'mobile': '+971502223344', 'specialization': 'Translation', 'notes': 'Phase 4 seed — pending approval'}, token=T)
if reg2.get('registrationId'):
    # photo required before submit
    call('PUT', '/fl/registrations/%d/photo' % reg2['registrationId'],
         {'photo_data_b64': PNG_B64, 'mime_type': 'image/png', 'file_name': 'seed.png'}, token=T)
    st, d = call('POST', '/fl/registrations/%d/submit' % reg2['registrationId'], {}, token=T)
    print('[6] FL registration SUBMITTED:', reg2['registrationNumber'], 'ok' if d.get('ok') else 'FAIL ' + str(d))

st, fls = call('GET', '/fl/freelancers/?limit=5', token=T)
if fls.get('items'):
    flid = fls['items'][0]['freelancerId']
    st, gl = call('GET', '/fl/gl-codes', token=T)
    glid = next(g['ccId'] for g in gl if g['isActive'] == 'Y')
    today = date.today()
    st, con = call('POST', '/fl/contracts/', {
        'freelancerId': flid, 'title': 'Production Services Retainer (large)',
        'startDate': today.replace(day=1).isoformat(),
        'endDate': (today.replace(day=1) + timedelta(days=365)).isoformat(),
        'totalAmount': 84000, 'billingMethod': 'MONTHLY',
        'orgId': users['ADMIN']['orgId'], 'codingType': 'GL', 'ccIdGl': glid,
        'notes': 'Phase 4 seed — exercises the >=50k two-step approval'}, token=T)
    if con.get('contractId'):
        st, d = call('POST', '/fl/contracts/%d/submit' % con['contractId'], {}, token=T)
        # approve step 1 (FL_MANAGER) only — leaves it at the FL_ADMIN step
        st, pend = call('GET', '/fl/approvals/pending', token=T)
        inst = next((p for p in pend['items'] if p['requestRef'] == con['contractNumber']), None)
        if inst:
            call('POST', '/fl/approvals/%d/action' % inst['instanceId'],
                 {'action': 'APPROVED', 'comments': 'Phase 4 seed — step 1 of 2'}, token=T)
        st, pend = call('GET', '/fl/approvals/pending', token=T)
        still = next((p for p in pend['items'] if p['requestRef'] == con['contractNumber']), None)
        print('[7] FL 84k contract %s: 2-step path %s' %
              (con['contractNumber'], 'pending at step 2 ✓' if still else 'fully approved (check threshold)'))

# ── delegation NASER -> AYESHA + 2 announcements ─────────────────────────────
st, d = call('POST', '/dct/delegations/', {'delegatorId': uid('NASER.ALKHAJA'),
    'delegateId': uid('AYESHA.AMERI'), 'scope': 'ALL_ROLES',
    'endDate': (date.today() + timedelta(days=14)).isoformat(),
    'reason': 'Annual leave cover (Phase 4 seed)'}, token=T)
print('[8] delegation NASER->AYESHA:', d.get('delegationId', 'FAIL ' + str(st)))

st, a1 = call('POST', '/dct/announcements/', {
    'titleEn': 'Freelancers & Credit Cards modules are live',
    'titleAr': 'تم إطلاق وحدتي المتعاقدين وبطاقات الائتمان',
    'bodyEn': 'Apps 202 and 203 are now available from the module switcher.',
    'bodyAr': 'التطبيقان 202 و203 متاحان الآن من مبدل الوحدات.',
    'severity': 'INFO', 'audience': 'ALL'}, token=T)
print('[9] announcement INFO/ALL:', a1.get('announcementId', 'FAIL ' + str(st)))

st, a2 = call('POST', '/dct/announcements/', {
    'titleEn': 'Monthly replenishments are due by the 5th',
    'titleAr': 'التغذية الشهرية مستحقة قبل الخامس من الشهر',
    'bodyEn': 'Card holders: submit last month\'s statement before the grace period ends.',
    'bodyAr': 'على حاملي البطاقات تقديم كشف الشهر الماضي قبل انتهاء فترة السماح.',
    'severity': 'WARNING', 'audience': 'MODULE', 'moduleCode': 'CREDIT_CARDS'}, token=T)
print('[10] announcement WARNING/CC:', a2.get('announcementId', 'FAIL ' + str(st)))

print('--- phase4_seed complete ---')
