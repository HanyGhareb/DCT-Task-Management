#!/usr/bin/env python3
"""GL Budget Utilization — Fund Movement columns (v1.94.0, GL/db/34) API smoke.

GET /gl/butil/fundmove (per-key aggregates, level=line|dept|sector) and
GET /gl/butil/lines/fundmove (drill rows = the register Fund Movement sheet
column set, sort=default|date). Rules under test: all three levels reconcile
to the same totals; a cell's drill count/total tie EXACTLY to the cell;
net = additions + deductions and cnt = posCnt + negCnt everywhere; the two
sort orders return the same set; page filters narrow the dept/sector
aggregates AND their group drills identically; validation 400s; 401 without
a token. Read-only. Run: python3 butil_fundmove_api_smoke.py
"""
import json, re, ssl, urllib.error, urllib.parse, urllib.request
BASE = 'https://129.151.159.189'
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context(); CTX.check_hostname = False; CTX.verify_mode = ssl.CERT_NONE
u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
r = urllib.request.Request(BASE + '/ords/admin/dct/auth/login',
    data=json.dumps({'username': u, 'password': p}).encode(), method='POST',
    headers={'Content-Type': 'application/json'})
TOK = json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


def call(path, tok=TOK):
    hdr = {'Authorization': 'Bearer ' + tok} if tok else {}
    rq = urllib.request.Request(BASE + '/ords/admin/gl' + path, headers=hdr)
    return json.loads(urllib.request.urlopen(rq, timeout=120, context=CTX).read())


def status(path, tok=TOK):
    try:
        call(path, tok); return 200
    except urllib.error.HTTPError as e:
        return e.code


ok = fail = 0


def ck(name, cond, extra=''):
    global ok, fail
    print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '  ' + str(extra)))
    ok, fail = ok + (1 if cond else 0), fail + (0 if cond else 1)


def q(d):
    return '?' + urllib.parse.urlencode({k: v for k, v in d.items() if v not in (None, '')})


def coherent(name, t):
    ck(name + ' cnt = pos+neg', t['cnt'] == t['posCnt'] + t['negCnt'], t)
    ck(name + ' amt = posAmt+negAmt', abs(t['amt'] - (t['posAmt'] + t['negAmt'])) < 0.01, t)
    ck(name + ' signs', t['posAmt'] >= 0 and t['negAmt'] <= 0, t)


# ── 1. three levels reconcile to the same totals ────────────────────────────
ln = call('/butil/fundmove?year=2026&level=line')
dp = call('/butil/fundmove?year=2026&level=dept')
sc = call('/butil/fundmove?year=2026&level=sector')
ck('line items > 0', len(ln['items']) > 0, len(ln['items']))
ck('dept items > 0', len(dp['items']) > 0)
ck('sector items > 0', len(sc['items']) > 0)
for nm, d in (('line', ln), ('dept', dp), ('sector', sc)):
    coherent(nm + ' totals', d['totals'])
    s = {k: sum(i[k] for i in d['items']) for k in ('cnt', 'amt', 'posCnt', 'posAmt', 'negCnt', 'negAmt')}
    ck(nm + ' item sums == totals', all(abs(s[k] - d['totals'][k]) < 0.01 for k in s), (s, d['totals']))
ck('dept totals == line totals', abs(dp['totals']['amt'] - ln['totals']['amt']) < 0.01
   and dp['totals']['cnt'] == ln['totals']['cnt'], (dp['totals'], ln['totals']))
ck('sector totals == line totals', abs(sc['totals']['amt'] - ln['totals']['amt']) < 0.01
   and sc['totals']['cnt'] == ln['totals']['cnt'], (sc['totals'], ln['totals']))

# ── 2. line-cell drill ties (top 3 keys by |amt|) ───────────────────────────
tops = sorted(ln['items'], key=lambda i: -abs(i['amt']))[:3]
for i, it in enumerate(tops):
    dr = call('/butil/lines/fundmove' + q({'year': 2026, 'project': it.get('project', ''),
                                          'task': it.get('task', ''), 'etype': it.get('etype', '')}))
    ck(f'line drill #{i + 1} count ties', dr['count'] == it['cnt'], (dr['count'], it['cnt']))
    ck(f'line drill #{i + 1} total ties', abs(dr['total'] - it['amt']) < 0.01, (dr['total'], it['amt']))
    ck(f'line drill #{i + 1} rows == count', len(dr['rows']) == dr['count'] or dr['count'] > 1000)

# ── 3. drill row shape = the Fund Movement sheet columns ────────────────────
dr = call('/butil/lines/fundmove' + q({'year': 2026, 'project': tops[0].get('project', ''),
                                      'task': tops[0].get('task', ''), 'etype': tops[0].get('etype', '')}))
keys = set()
for row in dr['rows']:
    keys |= set(row.keys())
need = {'project', 'projectName', 'task', 'etype', 'combination', 'amount', 'commitment',
        'annualBudget', 'fundAvailable', 'totalActual', 'costCentre', 'department',
        'organization', 'sector', 'trxNum', 'decreeNo', 'trxDate', 'trxYear',
        'businessUnit', 'trxStatus', 'lineStatus', 'baselineStatus', 'journalStatus'}
ck('drill rows carry the sheet columns', need <= keys, sorted(need - keys))
ck('drill row amounts non-zero', all(abs(row['amount']) > 0 for row in dr['rows']))

# ── 3b. combos side-map feeds the combination popover (v1.95.0) ─────────────
d1 = call('/butil/lines/fundmove?year=2026&costcenter=4510110')
combos = d1.get('combos', {})
row_cc = {row.get('combination') for row in d1['rows'] if row.get('combination')}
ck('drill ships combos side-map', isinstance(combos, dict) and len(combos) > 0, len(combos))
ck('combos cover the row combinations', row_cc <= set(combos), sorted(row_cc - set(combos)))
seg_keys = ('entityCode', 'programCode', 'costCenterCode', 'accountCode', 'appropriationCode',
            'budgetGroupCode', 'entitySpecificCode', 'intercompanyCode', 'future1Code', 'future2Code')
ck('combo carries the 10 segment codes',
   all(all(k in c for k in seg_keys) for c in combos.values()))

# ── 4. the two sort orders: same set, different lead key ────────────────────
d2 = call('/butil/lines/fundmove?year=2026&costcenter=4510110&sort=date')
ck('sort=date same count/total', d2['count'] == d1['count'] and abs(d2['total'] - d1['total']) < 0.01)
ck('default sorted by project first', [r['project'] for r in d1['rows']] == sorted(r['project'] for r in d1['rows']))
ck('date sorted by trxDate first', [r['trxDate'] for r in d2['rows']] == sorted(r['trxDate'] for r in d2['rows']))
ck('sort echo', d1.get('sort') == 'default' and d2.get('sort') == 'date', (d1.get('sort'), d2.get('sort')))

# ── 5. dept/sector group drills tie to their aggregates ─────────────────────
bigd = sorted([i for i in dp['items'] if i.get('key')], key=lambda i: -abs(i['amt']))[:2]
for it in bigd:
    dr = call('/butil/lines/fundmove' + q({'year': 2026, 'costcenter': it['key']}))
    ck('dept ' + it['key'] + ' drill ties', dr['count'] == it['cnt'] and abs(dr['total'] - it['amt']) < 0.01,
       (dr['count'], it['cnt'], dr['total'], it['amt']))
bigs = max([i for i in sc['items'] if i.get('key')], key=lambda i: abs(i['amt']))
dr = call('/butil/lines/fundmove' + q({'year': 2026, 'sector': bigs['key']}))
ck('sector drill ties', dr['count'] == bigs['cnt'] and abs(dr['total'] - bigs['amt']) < 0.01,
   (dr['count'], bigs['cnt']))

# ── 6. page filters narrow aggregates and drill identically ─────────────────
dpf = call('/butil/fundmove' + q({'year': 2026, 'level': 'dept',
                                 'projecttype': 'DCT OPEX Project Type'}))
ck('projecttype narrows dept', dpf['totals']['cnt'] < dp['totals']['cnt'],
   (dpf['totals']['cnt'], dp['totals']['cnt']))
coherent('filtered dept totals', dpf['totals'])
fit = sorted([i for i in dpf['items'] if i.get('key')], key=lambda i: -abs(i['amt']))[0]
drf = call('/butil/lines/fundmove' + q({'year': 2026, 'costcenter': fit['key'],
                                       'projecttype': 'DCT OPEX Project Type'}))
ck('filtered dept drill ties', drf['count'] == fit['cnt'] and abs(drf['total'] - fit['amt']) < 0.01,
   (drf['count'], fit['cnt']))
# sector filter narrows the sector level to one group
one = call('/butil/fundmove' + q({'year': 2026, 'level': 'sector', 'sector': bigs['key']}))
ck('sector filter -> one group', len([i for i in one['items'] if i.get('key')]) == 1
   and abs(one['totals']['amt'] - bigs['amt']) < 0.01, one['totals'])

# ── 7. period cut never grows the set ───────────────────────────────────────
p3 = call('/butil/fundmove?year=2026&level=line&period=03-2026')
ck('period 03-2026 cnt <= full year', p3['totals']['cnt'] <= ln['totals']['cnt'],
   (p3['totals']['cnt'], ln['totals']['cnt']))
dr3 = call('/butil/lines/fundmove' + q({'year': 2026, 'costcenter': '4510110', 'period': '03-2026'}))
p3d = [i for i in call('/butil/fundmove?year=2026&level=dept&period=03-2026')['items']
       if i.get('key') == '4510110']
ck('period dept drill ties', (not p3d and dr3['count'] == 0)
   or (p3d and dr3['count'] == p3d[0]['cnt'] and abs(dr3['total'] - p3d[0]['amt']) < 0.01))

# ── 8. validation + auth ────────────────────────────────────────────────────
ck('year required -> 400', status('/butil/fundmove?level=line') == 400)
ck('bad level -> 400', status('/butil/fundmove?year=2026&level=x') == 400)
ck('bad period -> 400', status('/butil/fundmove?year=2026&period=13-2026') == 400)
ck('drill year required -> 400', status('/butil/lines/fundmove') == 400)
ck('bad sort -> 400', status('/butil/lines/fundmove?year=2026&sort=x') == 400)
ck('drill bad period -> 400', status('/butil/lines/fundmove?year=2026&period=00-2026') == 400)
ck('no token -> 401', status('/butil/fundmove?year=2026', tok=None) == 401)

print(f'\n{ok} passed, {fail} failed')
raise SystemExit(1 if fail else 0)
