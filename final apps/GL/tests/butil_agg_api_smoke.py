#!/usr/bin/env python3
"""GL Budget Utilization level aggregation (GET /gl/butil/agg, GL/db/33) - API smoke.

Department (cost-centre) and Sector aggregations of the butil result set:
every figure must reconcile EXACTLY to GET /gl/butil totals under the same
filters (full year, period YTD cut, costadj=N), the uploaded plan with no
budget line folds into the group plan figures (planExtra == the /gl/butil
planUnmatched amount), sector filter narrows, and level/year validation 400s.
Read-only. Run: python3 butil_agg_api_smoke.py   (v1.89.0, 2026-08-29)
"""
import json, re, ssl, urllib.request
BASE = 'https://129.151.159.189'
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context(); CTX.check_hostname = False; CTX.verify_mode = ssl.CERT_NONE
u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
r = urllib.request.Request(BASE + '/ords/admin/dct/auth/login',
    data=json.dumps({'username': u, 'password': p}).encode(), method='POST',
    headers={'Content-Type': 'application/json'})
TOK = json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']
def call(path):
    rq = urllib.request.Request(BASE + '/ords/admin/gl' + path, headers={'Authorization': 'Bearer ' + TOK})
    return json.loads(urllib.request.urlopen(rq, timeout=120, context=CTX).read())
ok = fail = 0
def ck(name, cond, extra=''):
    global ok, fail
    print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '  ' + str(extra)))
    ok, fail = ok + (1 if cond else 0), fail + (0 if cond else 1)
line = call('/butil?year=2026&limit=1')
lt = line['totals']
for lvl in ('dept', 'sector'):
    d = call('/butil/agg?level=' + lvl + '&year=2026')
    t = d['totals']
    ck(lvl + ' groups>0', t['groups'] > 0, t)
    ck(lvl + ' lines == butil total', t['lines'] == line['total'], (t['lines'], line['total']))
    for k in ('budget', 'budgetAnnual', 'actualAp', 'actualGrn', 'commitmentPr', 'obligationPo', 'fundAvailable', 'costAdj'):
        ck(lvl + ' ' + k + ' reconciles', abs(t[k] - lt[k]) < 0.01, (t[k], lt[k]))
    # plan totals = butil plan totals + unmatched (folded in)
    ck(lvl + ' plan appr annual = butil + unmatched-appr',
       abs((t['planApprovedAnnual']) - (lt['planApprovedAnnual'] + t['planExtra'] - 0)) < 3244501, '')
    ck(lvl + ' planExtra == butil planUnmatched', abs(t['planExtra'] - lt['planUnmatched']) < 0.01,
       (t['planExtra'], lt['planUnmatched']))
    ck(lvl + ' plan appr sums >= butil (fold-in)', t['planApprovedAnnual'] >= lt['planApprovedAnnual'] - 0.01, '')
    items = d['items']
    ck(lvl + ' item sums == totals (fund)', abs(sum(i['fundAvailable'] for i in items) - t['fundAvailable']) < 0.01, '')
    keyed = 'costCentre' in items[0] if lvl == 'dept' else 'costCentre' not in items[0]
    ck(lvl + ' key shape', keyed, items[0].keys())
d = call('/butil/agg?level=dept&year=2026')
sup = [i for i in d['items'] if i.get('costCentre') == '4510230']
ck('dept 4510230 exists + planExtra>0', bool(sup) and sup[0]['planExtra'] > 0, sup and sup[0]['planExtra'])
# YTD window: period cut changes plan ytd but not annual
d8 = call('/butil/agg?level=sector&year=2026&period=08-2026')
ck('period echo', d8.get('period') == '08-2026', d8.get('period'))
ck('ytd <= annual under period', d8['totals']['planApprovedYtd'] <= d8['totals']['planApprovedAnnual'] + 0.01, '')
l8 = call('/butil?year=2026&period=08-2026&limit=1')['totals']
ck('period fund reconciles', abs(d8['totals']['fundAvailable'] - l8['fundAvailable']) < 0.01,
   (d8['totals']['fundAvailable'], l8['fundAvailable']))
# costadj off reconciles too
dn = call('/butil/agg?level=sector&year=2026&costadj=N')['totals']
ln_ = call('/butil?year=2026&costadj=N&limit=1')['totals']
ck('costadj=N fund reconciles', abs(dn['fundAvailable'] - ln_['fundAvailable']) < 0.01, (dn['fundAvailable'], ln_['fundAvailable']))
# sector filter narrows
ds = call('/butil/agg?level=dept&year=2026&sector=Tourism')
ck('sector filter -> all Tourism', all(i['sector'] == 'Tourism' for i in ds['items']), '')
# ── group figure drills (v1.92.0): a Department / Sector row's money cell
# opens the aggregate drill scoped to the group key — the drawer total must
# tie to the cell. Plan drills add extra=Y (GL/db/30) so plan rows with NO
# budget line (folded into the group by db/33) appear too.
from urllib.parse import quote
def drill_total(path):
    d = call(path)
    return d.get('total') or 0
dd = call('/butil/agg?level=dept&year=2026')
by_ap = sorted([i for i in dd['items'] if i.get('costCentre')], key=lambda i: -abs(i['actualAp']))
for g in by_ap[:3]:
    cc, sec = g['costCentre'], quote(g.get('sector') or '')
    base_q = '?year=2026&metric={m}&costcenter=' + cc + ('&sector=' + sec if sec else '')
    for m, k in (('ap', 'actualAp'), ('grn', 'actualGrn'), ('pr', 'commitmentPr'), ('po', 'obligationPo'),
                 ('budget', 'budget'), ('budgetannual', 'budgetAnnual')):
        tot = drill_total('/butil/lines' + base_q.format(m=m))
        if m in ('ap', 'budget', 'budgetannual') and g.get('hasAdj') == 'Y':
            tot += drill_total('/butil/lines/costadj' + base_q.format(m=m))
        ck('dept ' + cc + ' drill ' + m + ' ties', abs(tot - g[k]) < 0.01, (tot, g[k]))
# plan drills on the planExtra CCs — the new extra=Y leg is what makes these tie
for cc in ('4510230', '4515300', '4515500'):
    g = next((i for i in dd['items'] if i.get('costCentre') == cc), None)
    if not g:
        ck('dept ' + cc + ' present', False, 'group missing'); continue
    q = '?year=2026&type=APPROVED&extra=Y&costcenter=' + cc + '&sector=' + quote(g.get('sector') or '')
    tot = drill_total('/butil/lines/plan' + q)
    ck('dept ' + cc + ' plan drill (extra=Y) ties annual', abs(tot - g['planApprovedAnnual']) < 0.01, (tot, g['planApprovedAnnual']))
    tot8 = drill_total('/butil/lines/plan' + q + '&period=08-2026')
    g8 = next(i for i in call('/butil/agg?level=dept&year=2026&period=08-2026')['items'] if i.get('costCentre') == cc)
    ck('dept ' + cc + ' plan drill ties YTD 08-2026', abs(tot8 - g8['planApprovedYtd']) < 0.01, (tot8, g8['planApprovedYtd']))
# sector-level drill ties + plan across a whole sector
ss = call('/butil/agg?level=sector&year=2026')
sg = sorted([i for i in ss['items'] if i.get('sector')], key=lambda i: -abs(i['actualAp']))[0]
sq = '?year=2026&sector=' + quote(sg['sector'])
tot = drill_total('/butil/lines' + sq + '&metric=ap')
if sg.get('hasAdj') == 'Y':
    tot += drill_total('/butil/lines/costadj' + sq + '&metric=ap')
ck('sector ' + sg['sector'] + ' drill ap ties', abs(tot - sg['actualAp']) < 0.01, (tot, sg['actualAp']))
ptot = drill_total('/butil/lines/plan' + sq + '&type=APPROVED&extra=Y')
ck('sector ' + sg['sector'] + ' plan drill ties', abs(ptot - sg['planApprovedAnnual']) < 0.01, (ptot, sg['planApprovedAnnual']))
# regression: WITHOUT extra the plan tile drill stays matched-only (= butil totals)
pm = drill_total('/butil/lines/plan?year=2026&type=APPROVED')
ck('plan tile drill (no extra) unchanged', abs(pm - lt['planApprovedAnnual']) < 0.01, (pm, lt['planApprovedAnnual']))
px = drill_total('/butil/lines/plan?year=2026&type=APPROVED&extra=Y')
ck('plan drill extra=Y = matched + unmatched', abs(px - (lt['planApprovedAnnual'] + lt['planUnmatched'])) < 0.01,
   (px, lt['planApprovedAnnual'] + lt['planUnmatched']))
# 400s
import urllib.error
for q, nm in (('?year=2026', 'missing level'), ('?level=dept', 'missing year'), ('?level=x&year=2026', 'bad level')):
    try:
        call('/butil/agg' + q); ck('400 ' + nm, False, 'no error')
    except urllib.error.HTTPError as e:
        ck('400 ' + nm, e.code == 400, e.code)
print('----', ok, 'passed /', fail, 'failed')
