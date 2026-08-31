#!/usr/bin/env python3
"""GL plan-insights API smoke (GL/db/32, v1.88.0).

GET /gl/butil computes per-row Plan-vs-Actual verdicts (planExecState/Pct/
Variance over the EFFECTIVE plan = revised when one exists) and Plan-vs-Budget
coverage (planCovState/Pct), plus full-filtered-set aggregates in totals and a
planstate= verdict filter. Thresholds come from the GL module settings and are
echoed per response.

Run: python plan_insights_api_smoke.py      (defaults to the webtier)
"""
import json
import os
import re
import ssl
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE
YEAR = 2026

ok = fail = 0


def ck(name, cond, extra=''):
    global ok, fail
    print(('  PASS ' if cond else '  FAIL ') + name + ('  ' + str(extra) if extra else ''))
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


def get(q):
    rq = urllib.request.Request(BASE + '/ords/admin/gl/butil?' + q,
                                headers={'Authorization': 'Bearer ' + TOK})
    return json.loads(urllib.request.urlopen(rq, timeout=120, context=CTX).read())


def verdict(pct, th):
    if pct is None:
        return 'NOPLAN'
    return 'BELOW' if pct < th['execLow'] else 'AHEAD' if pct > th['execHigh'] else 'WITHIN'


print('== totals aggregates + thresholds ==')
d = get('year=%d&limit=100' % YEAR)
t = d['totals']
th = d.get('planThresholds') or {}
keys = ['planEffYtd', 'planEffAnnual', 'planWithin', 'planBelow', 'planBelowAmt',
        'planAhead', 'planAheadAmt', 'planNoPlan', 'planCovFull', 'planCovUnder',
        'planCovGap', 'planCovOver', 'planCovNone']
ck('totals carry the 13 plan-insight keys', all(k in t for k in keys))
ck('thresholds echoed', all(k in th for k in ('execLow', 'execHigh', 'covLow', 'covHigh')), th)
ck('verdict counts reconcile to total',
   t['planWithin'] + t['planBelow'] + t['planAhead'] + t['planNoPlan'] == d['total'],
   '%s vs %s' % (t['planWithin'] + t['planBelow'] + t['planAhead'] + t['planNoPlan'], d['total']))
ck('coverage counts reconcile to total',
   t['planCovFull'] + t['planCovUnder'] + t['planCovOver'] + t['planCovNone'] == d['total'])

print('== per-row verdicts recompute (first page) ==')
bad = []
for r in d['items']:
    st = r.get('planExecState')
    effy = r.get('planEffYtd') or 0
    if effy > 0.005:
        act = (r.get('actualAp') or 0) + (r.get('actualGrn') or 0)
        pct = round(100.0 * act / effy, 1)
        if abs(pct - (r.get('planExecPct') or 0)) > 0.11 or verdict(pct, th) != st:
            bad.append((r['projectNumber'], pct, r.get('planExecPct'), st))
    elif st != 'NOPLAN':
        bad.append((r['projectNumber'], 'no plan', st, None))
ck('planExecPct/State match a client recompute', not bad, bad[:3])
bad = []
for r in d['items']:
    effa = r.get('planEffAnnual') or 0
    bud = r.get('budgetAnnual') or 0
    cs = r.get('planCovState')
    if effa <= 0.005:
        if cs != 'NONE':
            bad.append((r['projectNumber'], cs))
    elif abs(bud) > 0.005:
        pct = round(100.0 * effa / bud, 1)
        want = 'UNDER' if pct < th['covLow'] else 'OVER' if pct > th['covHigh'] else 'FULL'
        if want != cs or abs(pct - (r.get('planCovPct') or 0)) > 0.11:
            bad.append((r['projectNumber'], pct, r.get('planCovPct'), cs))
ck('planCovPct/State match a client recompute', not bad, bad[:3])
rev = [r for r in d['items'] if (r.get('planRevisedAnnual') or 0) != 0]
appr = [r for r in d['items'] if (r.get('planRevisedAnnual') or 0) == 0 and (r.get('planApprovedYtd') or 0) > 0]
ck('effective plan = approved when no revised exists',
   all(abs((r['planEffYtd'] or 0) - (r['planApprovedYtd'] or 0)) < 0.01 for r in appr))
if rev:
    ck('effective plan = revised when one exists',
       all(abs((r['planEffYtd'] or 0) - (r['planRevisedYtd'] or 0)) < 0.01 for r in rev))

print('== planstate verdict filter ==')
for state, key in (('BELOW', 'planBelow'), ('AHEAD', 'planAhead'), ('NOPLAN', 'planNoPlan')):
    f = get('year=%d&planstate=%s&limit=50' % (YEAR, state))
    ck('planstate=%s total == %s' % (state, key), f['total'] == t[key],
       '%s vs %s' % (f['total'], t[key]))
    ck('planstate=%s rows all %s' % (state, state),
       all(r.get('planExecState') == state for r in f['items']))
    ck('planstate=%s echoed' % state, f.get('planState') == state)
f = get('year=%d&planstate=GARBAGE&limit=1' % YEAR)
ck('invalid planstate ignored (falls back to full set)', f['total'] == d['total'])

print('== YTD period basis ==')
p = get('year=%d&period=06-2026&limit=100' % YEAR)
ck('period run still reconciles',
   p['totals']['planWithin'] + p['totals']['planBelow'] + p['totals']['planAhead']
   + p['totals']['planNoPlan'] == p['total'])
row = next((r for r in p['items'] if (r.get('planEffYtd') or 0) > 0.005), None)
if row:
    act = (row.get('actualAp') or 0) + (row.get('actualGrn') or 0)
    ck('period-run row pct recomputes', abs(round(100.0 * act / row['planEffYtd'], 1)
                                            - (row.get('planExecPct') or 0)) <= 0.11)

print('== costadj=N consistency ==')
n = get('year=%d&costadj=N&limit=100' % YEAR)
bad = []
for r in n['items']:
    effy = r.get('planEffYtd') or 0
    if effy > 0.005:
        act = (r.get('actualAp') or 0) + (r.get('actualGrn') or 0)
        if abs(round(100.0 * act / effy, 1) - (r.get('planExecPct') or 0)) > 0.11:
            bad.append(r['projectNumber'])
ck('costadj=N rows recompute against raw actual', not bad, bad[:3])

print('\n%d passed, %d failed' % (ok, fail))
raise SystemExit(1 if fail else 0)
