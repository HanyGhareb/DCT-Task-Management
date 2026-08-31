#!/usr/bin/env python3
"""GL /gl/butilcmt* API smoke — Budget Utilization Comments (2026-08-23).

Covers capability flags, root + reply threading (single level), the /gl/butil
hasCmt/cmtCount reflection (period-aware), thread + register modes, edit /
soft-delete rules, attachments on the shared dct_documents (raw-binary PUT,
media download), the role-capability admin routes over the COMMON
dct_role_permissions, and the reporting-period close that freezes every write
in the period (403) until reopened. Runs as the platform admin (SYS_ADMIN
passes every has_priv), so no-capability 403s are exercised only via the
bogus-token 401 path. Everything created here is deleted at the end and any
closed period is reopened.

Run: python3 butilcmt_api_smoke.py              (defaults to the webtier)
     GL_BASE=https://... python3 butilcmt_api_smoke.py
"""
import json
import os
import re
import ssl
import urllib.error
import urllib.parse
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

PROJ, TASK = '4517000039', '4510747'          # fixture line (same as costadj smoke)
YEAR = 2026
PER = '02-%d' % YEAR                          # comment period
PER_CLOSE = '11-%d' % YEAR                    # period used for the close test

ok = fail = 0


def ck(name, cond, extra=''):
    global ok, fail
    print(('  PASS ' if cond else '  FAIL ') + name + ('  ' + str(extra) if extra and not cond else ''))
    if cond:
        ok += 1
    else:
        fail += 1


def login():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(BASE + '/ords/admin/dct/auth/login',
                               data=json.dumps({'username': u, 'password': p}).encode(),
                               method='POST', headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


TOK = login()


def call(path, method='GET', body=None, tok=None, raw=None, hdrs=None):
    d = raw if raw is not None else (json.dumps(body).encode() if body is not None else None)
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, data=d, method=method,
                               headers={'Authorization': 'Bearer ' + (tok or TOK)})
    for k, v in (hdrs or {}).items():
        r.add_header(k, v)
    if d is not None and raw is None:
        r.add_header('Content-Type', 'application/json')
    try:
        x = urllib.request.urlopen(r, timeout=240, context=CTX)
        b = x.read()
        try:
            return x.status, json.loads(b or b'null')
        except Exception:
            return x.status, b
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'null')
        except Exception:
            return e.code, None


def butil(extra=''):
    return call('/butil?year=%d&limit=50&project=%s&task=%s%s' % (YEAR, PROJ, TASK, extra))


def thread(level='BUTIL_LINE', extra=''):
    return call('/butilcmt?level=%s&year=%d&project=%s&task=%s&etype=%s%s'
                % (level, YEAR, PROJ, TASK, urllib.parse.quote(ET), extra))


made_ids = []

print('== caps + auth ==')
c, caps = call('/butilcmt/meta/caps')
ck('caps respond', c == 200, c)
ck('admin holds every capability', all(caps.get(k) == 'Y' for k in
   ('canAdd', 'canReply', 'canClosePeriod', 'canManageRoles')), caps)
c, _ = call('/butilcmt/meta/caps', tok='bogus')
ck('bogus token -> 401', c == 401, c)

print('== baseline ==')
c, base = butil()
ck('butil echoes commentsEnabled=Y', c == 200 and base.get('commentsEnabled') == 'Y',
   (c, base and base.get('commentsEnabled')))
row = base['items'][0]
ET = row['expenditureType']

# pre-clean: remove leftovers of an earlier aborted run (replies first);
# a crashed run may have left PER_CLOSE closed, which would 403 the deletes
call('/butilcmt/admin/periods', 'POST', {'year': YEAR, 'period': PER_CLOSE, 'action': 'REOPEN'})
MARKERS = ('api smoke', 'to be frozen', 'must be refused', 'editable again')
for lvl, extra in (('BUTIL_LINE', ''), ('SECTOR', None)):
    if lvl == 'SECTOR':
        skey = row.get('sector')
        if not skey:
            continue
        c, th0 = call('/butilcmt?level=SECTOR&year=%d&ekey=%s' % (YEAR, urllib.parse.quote(skey)))
    else:
        c, th0 = thread()
    if c != 200:
        continue
    for s in th0.get('sections', []):
        for root in s.get('items', []):
            if any(m in root['text'] for m in MARKERS):
                for rp in root.get('replies', []):
                    call('/butilcmt/%d' % rp['id'], 'DELETE')
                call('/butilcmt/%d' % root['id'], 'DELETE')

c, base = butil()
row = base['items'][0]
ck('fixture line has no comments yet', row['hasCmt'] == 'N' and row['cmtCount'] == 0,
   (row['hasCmt'], row['cmtCount']))

print('== create validations ==')
c, _ = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': PER,
                                  'projectNumber': PROJ, 'taskNumber': TASK,
                                  'expenditureType': ET})
ck('missing text -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR,
                                  'projectNumber': PROJ, 'taskNumber': TASK,
                                  'expenditureType': ET, 'text': 'x'})
ck('missing period -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': '13-2026',
                                  'projectNumber': PROJ, 'taskNumber': TASK,
                                  'expenditureType': ET, 'text': 'x'})
ck('bad period -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': '06-2025',
                                  'projectNumber': PROJ, 'taskNumber': TASK,
                                  'expenditureType': ET, 'text': 'x'})
ck('period outside the budget year -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': PER,
                                  'projectNumber': PROJ, 'text': 'x'})
ck('BUTIL_LINE without full keys -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'SECTOR', 'budgetYear': YEAR, 'period': PER,
                                  'text': 'x'})
ck('SECTOR without entityKey -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'NOT_A_LEVEL', 'budgetYear': YEAR, 'period': PER,
                                  'text': 'x'})
ck('unknown level -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'parentId': 999999999, 'text': 'x'})
ck('reply to unknown parent -> 404', c == 404, c)

print('== root + reply on the fixture line ==')
c, made = call('/butilcmt', 'POST', {
    'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': PER,
    'projectNumber': PROJ, 'taskNumber': TASK, 'expenditureType': ET,
    'text': 'api smoke root: budget risk justification'})
ck('create root', c == 200 and made.get('status') == 'CREATED', (c, made))
rid = made['id']
made_ids.append(rid)
ck('reference is BUC-#####', bool(re.match(r'^BUC-\d{5}$', made['ref'])), made['ref'])
c, rep = call('/butilcmt', 'POST', {'parentId': rid, 'text': 'api smoke reply: acknowledged'})
ck('create reply', c == 200 and rep.get('status') == 'CREATED', (c, rep))
pid = rep['id']
made_ids.append(pid)
c, _ = call('/butilcmt', 'POST', {'parentId': pid, 'text': 'reply to reply'})
ck('reply to a reply -> 400', c == 400, c)

print('== butil reflection (period-aware) ==')
c, on = butil('&period=' + PER)
r2 = on['items'][0]
ck('period of the comment: hasCmt=Y, count = roots+replies', r2['hasCmt'] == 'Y'
   and r2['cmtCount'] == 2, (r2['hasCmt'], r2['cmtCount']))
c, off = butil('&period=01-%d' % YEAR)
ck('earlier period: hasCmt=N', off['items'][0]['hasCmt'] == 'N', off['items'][0]['hasCmt'])
c, fy = butil()
ck('full year counts all periods', fy['items'][0]['hasCmt'] == 'Y'
   and fy['items'][0]['cmtCount'] == 2, fy['items'][0]['cmtCount'])
ck('totals carry cmtCount', fy['totals'].get('cmtCount', 0) >= 2, fy['totals'].get('cmtCount'))

print('== Display Comments (cmtdisp) ==')
c, don = butil('&cmtdisp=ALL')
ck('cmtdisp=ALL echoes commentsDisplay', c == 200 and don.get('commentsDisplay') == 'ALL',
   (c, don and don.get('commentsDisplay')))
ck('row ships commentsText with the comment', 'api smoke root' in (don['items'][0].get('commentsText') or ''),
   don['items'][0].get('commentsText'))
c, doff = butil()
ck('default is NONE with no commentsText key', doff.get('commentsDisplay') == 'NONE'
   and 'commentsText' not in doff['items'][0], doff.get('commentsDisplay'))
c, dper = butil('&period=01-%d&cmtdisp=PERIOD' % YEAR)
ck('PERIOD mode scopes to the selected period (empty month)',
   not (dper['items'][0].get('commentsText') or ''), dper['items'][0].get('commentsText'))
c, dper2 = butil('&period=%s&cmtdisp=PERIOD' % PER)
ck('PERIOD mode returns the comment for its month',
   'api smoke root' in (dper2['items'][0].get('commentsText') or ''),
   dper2['items'][0].get('commentsText'))

print('== thread mode ==')
c, th = thread()
ck('thread responds', c == 200, c)
sec = [s for s in th['sections'] if s['level'] == 'BUTIL_LINE'][0]
ck('line section holds the root with its reply', len(sec['items']) == 1
   and len(sec['items'][0]['replies']) == 1, sec['items'] and len(sec['items'][0]['replies']))
ck('root is mine with author + timestamps', sec['items'][0]['mine'] == 'Y'
   and sec['items'][0]['author'] and sec['items'][0]['createdAt'], sec['items'][:1])
ck('items carry authorId + hasPhoto for the avatar', 'authorId' in sec['items'][0]
   and sec['items'][0].get('hasPhoto') in ('Y', 'N'), sec['items'][:1])
ck('TASK + PROJECT sections returned for a line thread',
   sorted(s['level'] for s in th['sections']) == ['BUTIL_LINE', 'PROJECT', 'TASK'],
   [s['level'] for s in th['sections']])
# newest root first (2026-08-23 feedback)
c, r2 = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': PER,
                                   'projectNumber': PROJ, 'taskNumber': TASK,
                                   'expenditureType': ET, 'text': 'api smoke second root'})
made_ids.append(r2['id'])
c, th2 = thread()
sec2 = [s for s in th2['sections'] if s['level'] == 'BUTIL_LINE'][0]
ck('roots are sorted newest first', sec2['items'][0]['id'] == r2['id'],
   [i['id'] for i in sec2['items']])
call('/butilcmt/%d' % r2['id'], 'DELETE')
made_ids.remove(r2['id'])
c, _ = call('/butilcmt?level=BUTIL_LINE&year=%d' % YEAR)
ck('thread without line keys -> 400', c == 400, c)
c, _ = call('/butilcmt?level=SECTOR&year=%d' % YEAR)
ck('SECTOR thread without ekey -> 400', c == 400, c)

print('== higher-level comment + register mode ==')
SECTOR_KEY = row.get('sector') or 'Tourism Sector'
c, sm = call('/butilcmt', 'POST', {'level': 'SECTOR', 'budgetYear': YEAR, 'period': PER,
                                   'entityKey': SECTOR_KEY, 'entityName': SECTOR_KEY,
                                   'text': 'api smoke sector-level comment'})
ck('create SECTOR comment', c == 200, (c, sm))
made_ids.append(sm['id'])
c, st = call('/butilcmt?level=SECTOR&year=%d&ekey=%s' % (YEAR, urllib.parse.quote(SECTOR_KEY)))
ck('sector thread finds it', c == 200 and st['sections'][0]['items'], (c, st))
ck('sector comment does NOT mark the butil row',
   butil('&period=' + PER)[1]['items'][0]['cmtCount'] == 2, 'line marker must stay line-grain')
c, reg = call('/butilcmt?year=%d&search=%s' % (YEAR, urllib.parse.quote('api smoke')))
ck('register lists both roots', c == 200 and reg['total'] == 2, (c, reg and reg['total']))
it = [x for x in reg['items'] if x['level'] == 'BUTIL_LINE'][0]
ck('register row carries keys + counts', it['projectNumber'] == PROJ and it['replyCount'] == 1
   and it['period'] == PER, it)

print('== edit + delete rules ==')
c, _ = call('/butilcmt/%d' % rid, 'PUT', {'text': 'api smoke root EDITED'})
ck('edit own root', c == 200, c)
c, th = thread()
sec = [s for s in th['sections'] if s['level'] == 'BUTIL_LINE'][0]
ck('edit persisted with updatedAt', sec['items'][0]['text'].endswith('EDITED')
   and sec['items'][0]['updatedAt'], sec['items'][:1])
c, _ = call('/butilcmt/%d' % rid, 'DELETE')
ck('delete root with replies -> 400', c == 400, c)
c, _ = call('/butilcmt/999999999', 'PUT', {'text': 'x'})
ck('edit unknown id -> 404', c == 404, c)

print('== attachments ==')
payload = b'butilcmt smoke attachment bytes'
c, up = call('/butilcmt/%d/docs?file_name=smoke.txt&mime_type=text/plain' % rid,
             'PUT', raw=payload, hdrs={'Content-Type': 'application/octet-stream'})
ck('raw-binary upload', c == 200 and up.get('docId'), (c, up))
doc_id = up['docId']
ck('upload reports the byte size', up.get('fileSize') == len(payload), up.get('fileSize'))
c, lst = call('/butilcmt/%d/docs' % rid)
ck('attachment listed with uploader + timestamp', c == 200 and lst['items']
   and lst['items'][0]['fileName'] == 'smoke.txt' and lst['items'][0]['uploadedBy'],
   (c, lst))
c, blob = call('/butilcmt/docs/%d' % doc_id)
ck('media download returns the bytes', c == 200 and blob == payload, (c, blob))
c, th = thread()
sec = [s for s in th['sections'] if s['level'] == 'BUTIL_LINE'][0]
ck('thread docCount reflects the file', sec['items'][0]['docCount'] == 1,
   sec['items'][0]['docCount'])
c, _ = call('/butilcmt/%d/docs?file_name=e.txt' % rid, 'PUT', raw=b'',
            hdrs={'Content-Type': 'application/octet-stream'})
ck('empty body -> 400', c == 400, c)

print('== role-capability admin (common dct_role_permissions) ==')
c, roles = call('/butilcmt/admin/roles')
ck('roles list responds', c == 200 and roles['items'], c)
by_code = {r['roleCode']: r for r in roles['items']}
ck('seeded grants visible (FIN_BP add+reply, FIN_DIRECTOR reply+close)',
   by_code.get('FIN_BP', {}).get('canAdd') == 'Y'
   and by_code.get('FIN_BP', {}).get('canReply') == 'Y'
   and by_code.get('FIN_DIRECTOR', {}).get('canClose') == 'Y',
   {k: by_code.get(k) for k in ('FIN_BP', 'FIN_DIRECTOR')})
ck('granted roles sort first', roles['items'][0]['roleCode'] in
   ('FIN_BP', 'FBP_UNIT_HEAD', 'PBP_UNIT_HEAD', 'FBP_SECTION_HEAD', 'FIN_DIRECTOR',
    'PROJECT_PLANNER', 'SECTOR_PLANNER', 'DEPT_PLANNER'), roles['items'][0])
tgt = by_code['PROJECT_PLANNER']
c, _ = call('/butilcmt/admin/roles', 'POST',
            {'roleId': tgt['roleId'], 'capability': 'CLOSE_PERIOD', 'granted': 'Y'})
ck('grant a capability', c == 200, c)
c, roles = call('/butilcmt/admin/roles')
ck('grant visible', {r['roleCode']: r for r in roles['items']}['PROJECT_PLANNER']['canClose'] == 'Y')
c, _ = call('/butilcmt/admin/roles', 'POST',
            {'roleId': tgt['roleId'], 'capability': 'CLOSE_PERIOD', 'granted': 'N'})
ck('revoke it back', c == 200, c)
c, roles = call('/butilcmt/admin/roles')
ck('revoke visible', {r['roleCode']: r for r in roles['items']}['PROJECT_PLANNER']['canClose'] == 'N')
c, _ = call('/butilcmt/admin/roles', 'POST', {'roleId': tgt['roleId'], 'capability': 'NOPE'})
ck('unknown capability -> 400', c == 400, c)

print('== reporting-period close ==')
c, per = call('/butilcmt/admin/periods?year=%d' % YEAR)
ck('12 periods with status + counts', c == 200 and len(per['items']) == 12
   and all(p['status'] in ('OPEN', 'CLOSED') for p in per['items']), (c, per and len(per['items'])))
c, cm2 = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': PER_CLOSE,
                                    'projectNumber': PROJ, 'taskNumber': TASK,
                                    'expenditureType': ET, 'text': 'to be frozen'})
made_ids.append(cm2['id'])
c, _ = call('/butilcmt/admin/periods', 'POST', {'year': YEAR, 'period': PER_CLOSE,
                                                'action': 'CLOSE', 'remarks': 'smoke close'})
ck('close the period', c == 200, c)
c, _ = call('/butilcmt/admin/periods', 'POST', {'year': YEAR, 'period': PER_CLOSE, 'action': 'CLOSE'})
ck('close again -> 400', c == 400, c)
c, _ = call('/butilcmt', 'POST', {'level': 'BUTIL_LINE', 'budgetYear': YEAR, 'period': PER_CLOSE,
                                  'projectNumber': PROJ, 'taskNumber': TASK,
                                  'expenditureType': ET, 'text': 'must be refused'})
ck('new comment in a CLOSED period -> 403', c == 403, c)
c, _ = call('/butilcmt/%d' % cm2['id'], 'PUT', {'text': 'edit must be refused'})
ck('edit in a CLOSED period -> 403', c == 403, c)
c, _ = call('/butilcmt/%d' % cm2['id'], 'DELETE')
ck('delete in a CLOSED period -> 403', c == 403, c)
c, _ = call('/butilcmt/%d/docs?file_name=f.txt' % cm2['id'], 'PUT', raw=b'x',
            hdrs={'Content-Type': 'application/octet-stream'})
ck('attach in a CLOSED period -> 403', c == 403, c)
c, th2 = thread(extra='&period=' + PER_CLOSE)
ck('thread reports the closed period', PER_CLOSE in th2.get('closedPeriods', []),
   th2.get('closedPeriods'))
c, _ = call('/butilcmt/admin/periods', 'POST', {'year': YEAR, 'period': PER_CLOSE,
                                                'action': 'REOPEN', 'remarks': 'smoke reopen'})
ck('reopen', c == 200, c)
c, _ = call('/butilcmt/%d' % cm2['id'], 'PUT', {'text': 'editable again'})
ck('writes work after reopen', c == 200, c)
c, per = call('/butilcmt/admin/periods?year=%d' % YEAR)
p11 = [p for p in per['items'] if p['period'] == PER_CLOSE][0]
ck('period row records who closed and reopened', p11['status'] == 'OPEN'
   and p11['closedBy'] and p11['reopenedBy'], p11)

print('== cleanup ==')
c, _ = call('/butilcmt/docs/%d' % doc_id, 'DELETE')
ck('delete attachment', c == 200, c)
c, _ = call('/butilcmt/%d' % pid, 'DELETE')
ck('delete reply', c == 200, c)
for x in [i for i in made_ids if i != pid]:
    c, _ = call('/butilcmt/%d' % x, 'DELETE')
    ck('delete #%d' % x, c == 200, c)
c, _ = call('/butilcmt/%d' % rid, 'DELETE')
ck('delete again -> 400 (already deleted)', c == 400, c)
c, fin = butil()
ck('butil back to baseline', fin['items'][0]['hasCmt'] == 'N' and fin['items'][0]['cmtCount'] == 0,
   (fin['items'][0]['hasCmt'], fin['items'][0]['cmtCount']))

print('\n%d passed, %d failed' % (ok, fail))
exit(1 if fail else 0)
