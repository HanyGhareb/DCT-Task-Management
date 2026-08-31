#!/usr/bin/env python3
"""KPI Module (App 213) -- ORDS API smoke test.

Covers Happy / Error (400/401/403/404) / Boundary for every kpi.rest route,
plus the shared /wf/ integration (submit -> worklist task -> act -> hooks).

Auth: pass three live session tokens via env (mint with dct_auth.open_session):
  KPI_TOK_ADMIN  -- a KPI_ADMIN holder (also SECTION_HEAD fallback approver)
  KPI_TOK_USER   -- a plain KPI_USER (no admin role)
  KPI_TOK_SYS    -- a KPI_FIN_DIRECTOR / SYS_ADMIN holder (final approver)
"""
import json, os, sys, time, urllib.request, urllib.parse
import random

BASE = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
TOK_ADMIN = os.environ.get('KPI_TOK_ADMIN')
TOK_USER  = os.environ.get('KPI_TOK_USER')
TOK_SYS   = os.environ.get('KPI_TOK_SYS')
if not (TOK_ADMIN and TOK_USER and TOK_SYS):
    sys.exit('Set KPI_TOK_ADMIN / KPI_TOK_USER / KPI_TOK_SYS env vars')
YEAR = int(os.environ.get('KPI_TEST_YEAR', '2098'))  # use a fresh synthetic year per run

results = []

def call(method, path, token=None, body=None, expect=200, raw_body=None, mime=None):
    url = BASE + path
    data = None
    headers = {}
    if token:
        headers['Authorization'] = 'Bearer ' + token
    if body is not None:
        data = json.dumps(body).encode()
        headers['Content-Type'] = 'application/json'
    if raw_body is not None:
        data = raw_body
        headers['Content-Type'] = mime or 'application/octet-stream'
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        r = urllib.request.urlopen(req, timeout=120)
        code, payload = r.status, r.read()
    except urllib.error.HTTPError as e:
        code, payload = e.code, e.read()
    ok = code == expect
    try:
        parsed = json.loads(payload) if payload else {}
    except Exception:
        parsed = payload
    return ok, code, parsed

def t(name, ok, extra=''):
    results.append((name, ok))
    print(('PASS  ' if ok else 'FAIL  ') + name + ((' -- ' + str(extra)) if extra and not ok else ''))

# ---------------------------------------------------------------- auth basics
ok, c, d = call('GET', '/kpi/boot', token='invalid-token-123', expect=401)
t('401 on invalid token', ok, c)
ok, c, d = call('GET', '/kpi/boot', token=TOK_ADMIN)
t('boot 200 (admin)', ok, c)
t('boot flags: isKpiAdmin', ok and d.get('isKpiAdmin') is True, d)
admin_uid = d.get('userId')
ok, c, d = call('GET', '/kpi/boot', token=TOK_USER)
t('boot 200 (user), not admin', ok and d.get('isKpiAdmin') is False, d)
t('boot lookups present', len(d.get('lookups', [])) >= 28, len(d.get('lookups', [])))

# ---------------------------------------------------------------- registry
ok, c, d = call('GET', '/kpi/kpis', token=TOK_USER)
t('kpis list 200', ok and len(d.get('items', [])) == 4, c)
kpis = {i['code']: i for i in d.get('items', [])}
rev_id = kpis['REV_GROWTH']['kpiId']
opt_id = kpis['OPT_PLAN']['kpiId']
cash_id = kpis['CASH_MGMT']['kpiId']

ok, c, d = call('GET', '/kpi/kpis/%d' % opt_id, token=TOK_USER)
t('kpi detail 200', ok, c)
t('detail has 5 bands', len(d.get('bands', [])) == 5, d.get('bands'))
t('detail has 4 criteria with levels', len(d.get('criteria', [])) == 4 and
  all(len(cr.get('levels', [])) == 5 for cr in d.get('criteria', [])), c)
t('detail has 3 targets', len(d.get('targets', [])) == 3, d.get('targets'))
ok, c, d = call('GET', '/kpi/kpis/999999', token=TOK_USER, expect=404)
t('kpi detail 404', ok, c)

# admin gating
ok, c, d = call('POST', '/kpi/kpis', token=TOK_USER, expect=403,
                body={'code': 'TMP_X', 'nameEn': 'x', 'frequency': 'ANNUAL', 'calcMethod': 'RATIO_A_OVER_B'})
t('POST kpis 403 as plain user', ok, c)
ok, c, d = call('POST', '/kpi/kpis', token=TOK_ADMIN,
                body={'code': 'TMP_T%d' % random.randint(10000, 99999), 'nameEn': 'Temp test KPI', 'frequency': 'ANNUAL',
                      'calcMethod': 'RATIO_A_OVER_B', 'requiresEvidence': 'N'})
t('POST kpis 200 as admin', ok, c)
tmp_id = d.get('kpiId')
ok, c, d = call('POST', '/kpi/kpis', token=TOK_ADMIN, expect=400,
                body={'code': 'TMP_BAD', 'nameEn': 'x', 'frequency': 'NOT_A_FREQ', 'calcMethod': 'RATIO_A_OVER_B'})
t('POST kpis 400 bad lookup value', ok, c)
ok, c, d = call('POST', '/kpi/kpis/%d/bands' % tmp_id, token=TOK_ADMIN, expect=400, body={'bands': []})
t('bands empty array 400', ok, c)
ok, c, d = call('POST', '/kpi/kpis/%d/bands' % tmp_id, token=TOK_ADMIN,
                body={'bands': [{'score': s, 'operator': 'GE', 'threshold1': s * 20} for s in range(1, 6)]})
t('bands replace-set 200', ok and d.get('saved') == 5, (c, d))
ok, c, d = call('POST', '/kpi/kpis/%d/targets' % tmp_id, token=TOK_ADMIN,
                body={'targets': [{'year': YEAR, 'value': 90, 'labelEn': '90%'}]})
t('targets upsert 200', ok, c)
ok, c, d = call('DELETE', '/kpi/kpis/%d' % tmp_id, token=TOK_ADMIN)
t('DELETE kpi (soft) 200', ok, c)
ok, c, d = call('DELETE', '/kpi/kpis/%d' % tmp_id, token=TOK_USER, expect=403)
t('DELETE kpi 403 as user', ok, c)

# ---------------------------------------------------------------- periods
ok, c, d = call('POST', '/kpi/periods/generate', token=TOK_USER, expect=403, body={'year': YEAR})
t('periods/generate 403 as user', ok, c)
ok, c, d = call('POST', '/kpi/periods/generate', token=TOK_ADMIN, body={'year': YEAR})
t('periods/generate 200 as admin', ok, c)
ok, c, d = call('POST', '/kpi/periods/generate', token=TOK_ADMIN, expect=400, body={'year': 1900})
t('periods/generate 400 invalid year', ok, c)
ok, c, d = call('GET', '/kpi/periods?year=%d' % YEAR, token=TOK_USER)
t('periods list = 5 rows', ok and len(d.get('items', [])) == 5, (c, len(d.get('items', []))))
periods = {(i['type'], i.get('quarter')): i['periodId'] for i in d.get('items', [])}
annual_p = periods[('ANNUAL', None)]
q1_p = periods[('QUARTER', 1)]

# ---------------------------------------------------------------- results flow
ok, c, d = call('POST', '/kpi/results/init', token=TOK_USER, expect=400,
                body={'kpiId': cash_id, 'periodId': annual_p})
t('init 400 frequency mismatch', ok, c)
ok, c, d = call('POST', '/kpi/results/init', token=TOK_USER,
                body={'kpiId': opt_id, 'periodId': annual_p})
t('init OPT_PLAN 200', ok, c)
res_id = d.get('resultId')
ok, c, d = call('GET', '/kpi/results/%d' % res_id, token=TOK_USER)
t('result detail 200', ok and d.get('status') == 'DRAFT', (c, d.get('status')))
t('result has 4 criteria rows', len(d.get('criteria', [])) == 4, len(d.get('criteria', [])))
crits = {cr['code']: cr for cr in d.get('criteria', [])}

ok, c, d = call('GET', '/kpi/results/999999', token=TOK_USER, expect=404)
t('result detail 404', ok, c)

# criteria entry (all level 4 => 80% => band 5)
for code, cr in crits.items():
    ok, c, d = call('PUT', '/kpi/results/%d/criteria/%d' % (res_id, cr['criterionId']),
                    token=TOK_USER, body={'levelNo': 4, 'justification': 'API test'})
    if not ok:
        break
t('criteria entries saved', ok, (c, d))
t('live compute: 80 pct score 5', d.get('resultPct') == 80 and d.get('score') == 5, d)

ok, c, d = call('PUT', '/kpi/results/%d/criteria/%d' % (res_id, crits['DATA_QUALITY']['criterionId']),
                token=TOK_USER, body={'levelNo': 9}, expect=400)
t('criterion level 9 rejected 400', ok, c)
ok, c, d = call('PUT', '/kpi/results/%d/criteria/%d' % (res_id, crits['DATA_QUALITY']['criterionId']),
                token=TOK_USER, body={'levelNo': 4, 'justification': 'API test'})
t('criterion re-saved', ok, c)

# evidence gate on submit
ok, c, d = call('POST', '/kpi/results/%d/submit' % res_id, token=TOK_USER, expect=400)
t('submit 400 without evidence', ok and 'evidence' in str(d), (c, d))

# evidence: oversize rejected, then real upload
big = b'x' * (11 * 1024 * 1024)
ok, c, d = call('PUT', '/kpi/results/%d/docs?file_name=big.bin' % res_id, token=TOK_USER,
                raw_body=big, expect=413)
t('evidence oversize 413', ok, c)
pdf = b'%PDF-1.4 kpi evidence test\n%%EOF'
ok, c, d = call('PUT', '/kpi/results/%d/docs?file_name=evidence.pdf&mime_type=application/pdf' % res_id,
                token=TOK_USER, raw_body=pdf, mime='application/pdf')
t('evidence upload 200', ok, c)
doc_id = d.get('docId')
ok, c, d = call('GET', '/kpi/results/%d/docs' % res_id, token=TOK_USER)
t('evidence list 1 row', ok and len(d.get('items', [])) == 1, c)
ok, c, d = call('GET', '/kpi/docs/%d/file' % doc_id, token=TOK_USER)
t('evidence download 200', ok, c)

# a second doc then delete it (editable state)
ok, c, d = call('PUT', '/kpi/results/%d/docs?file_name=extra.pdf&mime_type=application/pdf' % res_id,
                token=TOK_USER, raw_body=pdf, mime='application/pdf')
doc2 = d.get('docId')
ok, c, d = call('DELETE', '/kpi/docs/%d' % doc2, token=TOK_USER)
t('evidence delete 200', ok, c)

# other users cannot edit someone else's draft (admin can)
ok, c, d = call('PUT', '/kpi/results/%d' % res_id, token=TOK_SYS, expect=200,
                body={'figureA': None, 'figureB': None, 'notes': 'admin touch'})
t('admin may edit any draft', ok, c)

# submit -> workflow
ok, c, d = call('POST', '/kpi/results/%d/submit' % res_id, token=TOK_USER)
t('submit 200', ok and d.get('status') == 'SUBMITTED', (c, d))
inst = d.get('wfInstanceId')
t('wf instance created', bool(inst), d)

# result is now locked
ok, c, d = call('PUT', '/kpi/results/%d' % res_id, token=TOK_USER, expect=400,
                body={'figureA': 1, 'figureB': 1, 'notes': ''})
t('edit after submit 400', ok, c)

# /wf/ worklist shows the task for the section-head fallback (admin token)
ok, c, d = call('GET', '/wf/worklist', token=TOK_ADMIN)
items = [i for i in d.get('items', d.get('tasks', [])) or [] if i.get('module') == 'KPI_MGMT'] if ok else []
t('wf worklist has KPI task', ok and len(items) >= 1, (c, len(items)))
if items:
    task = items[0]
    outcomes = [o.get('code') for o in task.get('outcomes', [])]
    t('task ships outcomes APPROVE/RETURN/REJECT', set(outcomes) == {'APPROVE', 'RETURN', 'REJECT'}, outcomes)
    ok, c, d = call('POST', '/wf/tasks/%s/action' % task['id'], token=TOK_ADMIN,
                    body={'outcome': 'APPROVE', 'comments': 'API test step 1'})
    t('step1 approve via /wf/ 200', ok, (c, d))
    # final approver
    ok, c, d = call('GET', '/wf/worklist', token=TOK_SYS)
    items2 = [i for i in d.get('items', d.get('tasks', [])) or [] if i.get('module') == 'KPI_MGMT'] if ok else []
    t('step2 task visible to approver', ok and len(items2) >= 1, (c, len(items2)))
    if items2:
        ok, c, d = call('POST', '/wf/tasks/%s/action' % items2[0]['id'], token=TOK_SYS,
                        body={'outcome': 'APPROVE', 'comments': 'API test step 2'})
        t('step2 approve via /wf/ 200', ok, (c, d))
ok, c, d = call('GET', '/kpi/results/%d' % res_id, token=TOK_USER)
t('result APPROVED after chain', ok and d.get('status') == 'APPROVED', (c, d.get('status')))
t('history has 3+ rows', len(d.get('history', [])) >= 3, len(d.get('history', [])))

# ---------------------------------------------------------------- scorecard
ok, c, d = call('GET', '/kpi/scorecard?year=%d' % YEAR, token=TOK_USER)
t('scorecard 200', ok, c)
sc = {k['code']: k for k in d.get('kpis', [])}
t('scorecard OPT avg 5', sc.get('OPT_PLAN', {}).get('avgScore') == 5, sc.get('OPT_PLAN'))
t('scorecard overall present', d.get('overallScore') is not None, d.get('overallScore'))

# ---------------------------------------------------------------- results list
ok, c, d = call('GET', '/kpi/results?year=%d&status=APPROVED' % YEAR, token=TOK_USER)
t('results filter APPROVED', ok and d.get('total', 0) >= 1, (c, d.get('total')))
ok, c, d = call('GET', '/kpi/results?limit=1&offset=0', token=TOK_USER)
t('results paging limit=1', ok and len(d.get('items', [])) == 1, c)

# ---------------------------------------------------------------- users
ok, c, d = call('GET', '/kpi/users?search=han', token=TOK_USER)
t('users picker 200', ok and len(d.get('items', [])) >= 1, c)

# ---------------------------------------------------------------- report bridge
ok, c, d = call('GET', '/kpi/reports/999999/status', token=TOK_ADMIN, expect=404)
t('report status 404 unknown run', ok, c)

print('-' * 50)
npass = sum(1 for _, o in results if o)
print('TOTAL %d/%d PASS' % (npass, len(results)))
sys.exit(0 if npass == len(results) else 1)
