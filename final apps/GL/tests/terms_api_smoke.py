#!/usr/bin/env python3
"""GL API smoke — Terms and Key definitions (db/v2/129 + GL/db/51, v1.118.0).

CRUD + guardrails for /gl/terms (the rich-text report-intro documents shown
as content entry 01 of the Sector Performance Report):
  - 401 without a session, caps/lookups shapes, seeded document present
  - create validation (title/startDate/appliedTo/status/date-order = 400)
  - create/read/update round-trip incl. CLOB contentHtml + the HTML sanitiser
    (script blocks and on* attributes are stripped server-side)
  - delete + 404 afterwards
Optionally (RUN_REPORT=1) runs a live SECTOR_PERF_BOOK render and asserts the
terms print as Part 1 (slow, ~90s).

Run: python terms_api_smoke.py
     GL_ORDS=https://... RUN_REPORT=1 python terms_api_smoke.py
"""
import json
import os
import re
import ssl
import sys
import time
import urllib.error
import urllib.request

ORDS = os.environ.get('GL_ORDS', 'https://129.151.159.189/ords/admin')
AUTH = os.path.join(os.path.dirname(__file__), '..', '..', 'Admin', 'Jet', 'js', 'services', 'authService.js')

_ctx = ssl.create_default_context()
_ctx.check_hostname = False
_ctx.verify_mode = ssl.CERT_NONE

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


def call(method, path, body=None, tok=None, raw=False):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ORDS + path, data=data, method=method)
    if body is not None:
        req.add_header('Content-Type', 'application/json')
    if tok:
        req.add_header('Authorization', 'Bearer ' + tok)
    try:
        with urllib.request.urlopen(req, timeout=90, context=_ctx) as r:
            d = r.read()
            return r.status, (d if raw else (json.loads(d) if d else {}))
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read())
        except Exception:
            return e.code, {}


u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
st, s = call('POST', '/dct/auth/login', {'username': u, 'password': p})
assert st == 200, 'login failed'
tok = s['sessionId']

# guards + metadata
st, _ = call('GET', '/gl/terms')
check('401 without a session', st == 401, st)
st, d = call('GET', '/gl/terms/meta/caps', tok=tok)
check('caps: canManage=Y for admin', st == 200 and d.get('canManage') == 'Y', d)
st, d = call('GET', '/gl/terms/meta/lookups', tok=tok)
check('lookups: SECTOR_PERF in appliedTo', st == 200 and
      any(x['code'] == 'SECTOR_PERF' for x in d.get('appliedTo', [])))
check('lookups: ACTIVE in statuses', any(x['code'] == 'ACTIVE' for x in d.get('statuses', [])))

# seeded document
st, d = call('GET', '/gl/terms', tok=tok)
check('list ok + canManage echo', st == 200 and d.get('canManage') == 'Y')
seeded = [x for x in d.get('items', []) if x['appliedTo'] == 'SECTOR_PERF' and x['status'] == 'ACTIVE']
check('seeded SECTOR_PERF document present', len(seeded) >= 1,
      '%d items' % len(d.get('items', [])))

# create validation
st, _ = call('POST', '/gl/terms', {'appliedTo': 'SECTOR_PERF', 'startDate': '2026-01-01'}, tok=tok)
check('create without title = 400', st == 400, st)
st, _ = call('POST', '/gl/terms', {'title': 'x', 'appliedTo': 'SECTOR_PERF'}, tok=tok)
check('create without startDate = 400', st == 400, st)
st, _ = call('POST', '/gl/terms', {'title': 'x', 'appliedTo': 'NOPE', 'startDate': '2026-01-01'}, tok=tok)
check('create with bad appliedTo = 400', st == 400, st)
st, _ = call('POST', '/gl/terms', {'title': 'x', 'appliedTo': 'SECTOR_PERF',
                                   'startDate': '2026-06-01', 'endDate': '2026-01-01'}, tok=tok)
check('create with endDate before startDate = 400', st == 400, st)

# create / read / update round-trip + sanitiser
html = ('<p class="ql-align-center"><strong>Smoke term:</strong> value.</p>'
        '<script>alert(1)</script><p onclick="evil()">tail</p>')
st, d = call('POST', '/gl/terms', {'title': 'API smoke doc', 'appliedTo': 'SECTOR_PERF',
                                   'status': 'INACTIVE', 'startDate': '2026-01-01',
                                   'endDate': '2026-12-31', 'contentHtml': html}, tok=tok)
check('create ok', st == 200 and d.get('termId'), d)
tid = d['termId']
st, d = call('GET', '/gl/terms/%d' % tid, tok=tok)
check('detail round-trip', st == 200 and d.get('title') == 'API smoke doc'
      and d.get('endDate') == '2026-12-31' and d.get('status') == 'INACTIVE')
check('sanitiser stripped script + on* attrs',
      'Smoke term' in d.get('contentHtml', '')
      and '<script' not in d.get('contentHtml', '')
      and 'onclick' not in d.get('contentHtml', ''), d.get('contentHtml', '')[:120])
big = '<p>' + ('long text block. ' * 3000) + '</p>'   # ~48K > VARCHAR2 cap = real CLOB
st, _ = call('PUT', '/gl/terms/%d' % tid, {'contentHtml': big, 'endDate': None}, tok=tok)
check('update ok (CLOB content + endDate cleared)', st == 200, st)
st, d = call('GET', '/gl/terms/%d' % tid, tok=tok)
check('CLOB content survives round-trip', st == 200 and len(d.get('contentHtml', '')) > 40000,
      len(d.get('contentHtml', '')))
# a cleared endDate comes back with the key OMITTED (APEX_JSON drops '' values)
check('partial PUT kept title + cleared endDate',
      d.get('title') == 'API smoke doc' and d.get('endDate') in ('', None))

# delete
st, _ = call('DELETE', '/gl/terms/%d' % tid, tok=tok)
check('delete ok', st == 200, st)
st, _ = call('GET', '/gl/terms/%d' % tid, tok=tok)
check('404 after delete', st == 404, st)
st, _ = call('GET', '/gl/terms/99999999', tok=tok)
check('404 unknown id', st == 404, st)

# optional live report render (slow)
if os.environ.get('RUN_REPORT') == '1':
    st, d = call('GET', '/gl/butil/filters?year=2026', tok=tok)
    sector = d['sectors'][0]
    st, d = call('POST', '/gl/butil/sectorbook',
                 {'year': 2026, 'period': '09-2026', 'sector': sector}, tok=tok)
    check('report enqueued', st == 200 and d.get('runId'), d)
    rid = d['runId']
    for _ in range(75):
        time.sleep(6)
        st, d = call('GET', '/gl/butil/sectorbook/%d' % rid, tok=tok)
        if d.get('status') in ('SUCCESS', 'FAILED'):
            break
    check('report run SUCCESS', d.get('status') == 'SUCCESS', d.get('error', ''))
    st, pdf = call('GET', '/gl/butil/sectorbook/%d/pdf' % rid, tok=tok, raw=True)
    open('/tmp/terms_smoke_report.pdf', 'wb').write(pdf)
    import subprocess
    txt = subprocess.run(['pdftotext', '-f', '1', '-l', '4', '/tmp/terms_smoke_report.pdf', '-'],
                         capture_output=True, text=True).stdout
    check('PDF prints Terms and Key definitions as Part 1',
          'Terms and Key definitions' in txt and 'YTD Budget:' in txt)

fails = [n for n, okk in results if not okk]
print('\n%d/%d passed' % (len(results) - len(fails), len(results)))
sys.exit(1 if fails else 0)
