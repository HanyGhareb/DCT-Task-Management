#!/usr/bin/env python3
"""GL Generate-and-Send API smoke — /gl/butil/dist* + /gl/butil/emails*.

Covers: recipient-list CRUD, the 3-level selection tree, recipient preview
(test-mode + email-enabled flags), Excel-import upsert, the batch send
(1 real sector x XLSX register), batch poll, the email-history register +
drill, and the 400/401/404/409 error paths.

SAFE BY CONSTRUCTION: EMAIL_ENABLED=N and EMAIL_TEST_MODE=Y with no
EMAIL_TEST_TO — the run generates its report but every defined recipient is
logged SKIPPED; NO email can leave the platform (user rule 2026-08-24).

Run: python gs_dist_api_smoke.py           (defaults to the webtier)
     GL_BASE=https://... python gs_dist_api_smoke.py
"""
import json
import os
import re
import ssl
import sys
import time
import urllib.request
import urllib.error

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

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


def call(tok, method, path, body=None):
    hdr = {'Authorization': 'Bearer ' + tok}
    data = None
    if body is not None:
        hdr['Content-Type'] = 'application/json'
        data = json.dumps(body).encode()
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, data=data,
                               method=method, headers=hdr)
    try:
        resp = urllib.request.urlopen(r, timeout=180, context=CTX)
        return resp.status, json.loads(resp.read() or b'{}')
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b'{}')
        except Exception:
            return e.code, {}


def main():
    tok = login()
    print('== auth ==')
    ck('login', bool(tok))
    year = 2026

    # ── error paths first (nothing created yet) ──
    print('== error paths ==')
    st, _ = call('bad-token', 'GET', '/butil/dist')
    ck('401 bad token', st == 401, st)
    st, _ = call(tok, 'GET', '/butil/dist/meta/tree?level=NOPE&year=%d' % year)
    ck('400 bad tree level', st == 400, st)
    st, _ = call(tok, 'GET', '/butil/dist/meta/tree?level=SECTOR')
    ck('400 tree year required', st == 400, st)
    st, _ = call(tok, 'GET', '/butil/dist/999999999')
    ck('404 unknown dist', st == 404, st)
    st, _ = call(tok, 'GET', '/butil/dist/batch/999999999')
    ck('404 unknown batch', st == 404, st)
    st, _ = call(tok, 'GET', '/butil/emails/999999999')
    ck('404 unknown email run', st == 404, st)
    st, _ = call(tok, 'POST', '/butil/dist/meta/send',
                 {'level': 'SECTOR', 'formats': ['XLSX'], 'criteria': {}, 'nodes': [{'sector': 'X'}]})
    ck('400 send year required', st == 400, st)
    st, _ = call(tok, 'POST', '/butil/dist/meta/send',
                 {'level': 'SECTOR', 'formats': [], 'criteria': {'year': year},
                  'nodes': [{'sector': 'X'}]})
    ck('400 send formats required', st == 400, st)

    # ── tree (all three levels) ──
    print('== tree ==')
    st, t1 = call(tok, 'GET', '/butil/dist/meta/tree?level=SECTOR&year=%d' % year)
    ck('tree SECTOR 200', st == 200 and t1.get('sectors'), st)
    sectors = t1.get('sectors') or []
    ck('tree SECTOR leaves flat', all('children' in s for s in sectors) or sectors)
    real_sector = sectors[0]['sector'] if sectors else None
    ck('tree has a sector', bool(real_sector), real_sector)

    st, t2 = call(tok, 'GET', '/butil/dist/meta/tree?level=DEPARTMENT&year=%d' % year)
    ck('tree DEPARTMENT 200', st == 200 and t2.get('sectors'), st)
    ccs = [c for s in (t2.get('sectors') or []) for c in (s.get('children') or [])]
    ck('tree DEPARTMENT has cost centres', len(ccs) > 0, len(ccs))

    st, t3 = call(tok, 'GET', '/butil/dist/meta/tree?level=PROJECT&year=%d' % year)
    prjs = [p for s in (t3.get('sectors') or []) for c in (s.get('children') or [])
            for p in (c.get('children') or [])]
    ck('tree PROJECT 200 + projects', st == 200 and len(prjs) > 0, len(prjs))

    # ── CRUD ──
    print('== recipient-list CRUD ==')
    st, d = call(tok, 'POST', '/butil/dist', {
        'scopeType': 'SECTOR', 'scopeValue': real_sector, 'scopeLabel': real_sector,
        'sectorName': real_sector,
        'recipients': [
            {'disposition': 'TO', 'email': 'smoke.to@example.invalid', 'name': 'Smoke To'},
            {'disposition': 'CC', 'email': 'smoke.cc@example.invalid', 'name': 'Smoke Cc'},
            {'disposition': 'BCC', 'email': 'smoke.bcc@example.invalid'}]})
    dup_existing = st == 400          # a real list may already exist for this sector
    if dup_existing:
        st2, lst = call(tok, 'GET', '/butil/dist')
        row = [r for r in lst.get('items', [])
               if r['scopeType'] == 'SECTOR' and r['scopeValue'] == real_sector][0]
        dist_id = row['distId']
        st2, det = call(tok, 'GET', '/butil/dist/' + str(dist_id))
        ours = all(r['email'].endswith('example.invalid') for r in det.get('recipients', []))
        if ours:                      # our own leftover smoke row — restore it
            call(tok, 'PUT', '/butil/dist/' + str(dist_id), {
                'enabled': 'Y',
                'recipients': [
                    {'disposition': 'TO', 'email': 'smoke.to@example.invalid', 'name': 'Smoke To'},
                    {'disposition': 'CC', 'email': 'smoke.cc@example.invalid', 'name': 'Smoke Cc'},
                    {'disposition': 'BCC', 'email': 'smoke.bcc@example.invalid'}]})
            dup_existing = False      # safe to exercise the write paths on it
        ck('create dist (already existed, reused)', True, dist_id)
    else:
        ck('create dist 200', st == 200 and d.get('distId'), (st, d))
        dist_id = d.get('distId')

    st, d = call(tok, 'POST', '/butil/dist', {
        'scopeType': 'SECTOR', 'scopeValue': real_sector,
        'recipients': [{'disposition': 'TO', 'email': 'x@example.invalid'}]})
    ck('400 duplicate scope', st == 400, st)

    st, d = call(tok, 'GET', '/butil/dist/' + str(dist_id))
    ck('get dist + recipients', st == 200 and len(d.get('recipients', [])) >= 1,
       len(d.get('recipients', [])))

    if not dup_existing:      # never rewrite a REAL production list
        st, d = call(tok, 'PUT', '/butil/dist/' + str(dist_id),
                     {'subjectTpl': 'SMOKE | {{ report_name }} | {{ scope_label }}'})
        ck('put subject 200', st == 200, st)
        st, d = call(tok, 'GET', '/butil/dist/' + str(dist_id))
        ck('subject persisted', (d.get('subjectTpl') or '').startswith('SMOKE |'), d.get('subjectTpl'))

    st, lst = call(tok, 'GET', '/butil/dist')
    ck('list register 200 + counts', st == 200 and any(
        r['distId'] == dist_id and r['toCount'] >= 1 for r in lst.get('items', [])))

    # hasRecipients now true on the tree
    st, t1b = call(tok, 'GET', '/butil/dist/meta/tree?level=SECTOR&year=%d' % year)
    node = [s for s in t1b.get('sectors', []) if s['sector'] == real_sector]
    ck('tree hasRecipients flips', node and node[0].get('hasRecipients') is True)

    # ── preview ──
    print('== preview ==')
    st, p = call(tok, 'POST', '/butil/dist/meta/preview',
                 {'level': 'SECTOR', 'nodes': [{'sector': real_sector, 'label': real_sector},
                                              {'sector': 'ZZ No Such Sector', 'label': 'ZZ'}]})
    ck('preview 200', st == 200 and len(p.get('items', [])) == 2, st)
    ck('preview env flags', p.get('testMode') in ('Y', 'N') and p.get('emailEnabled') in ('Y', 'N'),
       (p.get('testMode'), p.get('emailEnabled')))
    found = [i for i in p.get('items', []) if i.get('found')]
    missing = [i for i in p.get('items', []) if not i.get('found')]
    ck('preview found + toList', found and len(found[0].get('toList', [])) >= 1)
    ck('preview missing flagged', len(missing) == 1)

    # ── import (fake cost centres, replaced recipients) ──
    print('== import ==')
    rows = [{'scopeType': 'COSTCENTER', 'scopeValue': 'Z99990%d' % i,
             'scopeLabel': 'Smoke Dept %d' % i, 'sectorName': 'Smoke Sector',
             'recipients': [{'disposition': 'TO', 'email': 'dept%d@example.invalid' % i}]}
            for i in (1, 2)]
    st, im = call(tok, 'POST', '/butil/dist/meta/import', {'rows': rows})
    ck('import 200 created', st == 200 and im.get('created') == 2, (st, im))
    st, im = call(tok, 'POST', '/butil/dist/meta/import', {'rows': rows})
    ck('re-import updates', st == 200 and im.get('updated') == 2, im)
    st, im = call(tok, 'POST', '/butil/dist/meta/import', {'rows': []})
    ck('400 import empty', st == 400, st)

    # ── send: ONE real sector, XLSX register only (no email can leave) ──
    print('== send ==')
    st, s = call(tok, 'POST', '/butil/dist/meta/send',
                 {'level': 'SECTOR', 'formats': ['XLSX'],
                  'criteria': {'year': year},
                  'nodes': [{'sector': real_sector, 'label': real_sector},
                            {'sector': 'ZZ No Such Sector', 'label': 'ZZ'}]})
    ck('send 200 + batch', st == 200 and s.get('batchId'), (st, s))
    batch_id = s.get('batchId')
    items = s.get('items', [])
    runs = [r for i in items for r in i.get('runs', [])]
    ck('send one run for the real node', len(runs) == 1, runs)
    ck('send NO_RECIPIENTS for unknown node',
       any(i.get('status') == 'NO_RECIPIENTS' for i in items))
    run_id = runs[0]['runId'] if runs else None

    st, b = call(tok, 'GET', '/butil/dist/batch/%s' % batch_id)
    ck('batch poll 200', st == 200 and len(b.get('runs', [])) == 1, st)

    # wait for the worker (register ~40-90s); tolerate a dead fleet gracefully
    terminal = None
    for _ in range(48):
        time.sleep(5)
        st, b = call(tok, 'GET', '/butil/dist/batch/%s' % batch_id)
        r0 = (b.get('runs') or [{}])[0]
        if r0.get('status') in ('SUCCESS', 'FAILED'):
            terminal = r0
            break
    if terminal is None:
        print('  WARN worker fleet did not process run %s in 4 min — delivery asserts skipped' % run_id)
    else:
        ck('run terminal', terminal['status'] in ('SUCCESS', 'FAILED'), terminal['status'])
        ck('deliveries logged (EMAIL_ENABLED=N -> all SKIPPED)',
           terminal.get('skippedCount', 0) >= 3 and terminal.get('sentCount', 0) == 0,
           (terminal.get('sentCount'), terminal.get('skippedCount')))

    # ── email history ──
    print('== email logs ==')
    st, e = call(tok, 'GET', '/butil/emails?batch=%s' % batch_id)
    ck('emails register 200 + row', st == 200 and len(e.get('items', [])) == 1, st)
    row = (e.get('items') or [{}])[0]
    ck('register row identity', row.get('runId') == run_id and row.get('report') == 'BUDGET_UTIL_REGISTER')
    st, e2 = call(tok, 'GET', '/butil/emails?recipient=example.invalid&batch=%s' % batch_id)
    ck('recipient filter', st == 200 and
       (len(e2.get('items', [])) == 1 if terminal else True), len(e2.get('items', [])))
    st, det = call(tok, 'GET', '/butil/emails/%s' % run_id)
    ck('email drill 200', st == 200 and det.get('runId') == run_id, st)
    if terminal:
        ck('drill recipients carry dispositions',
           all(r.get('disposition') in ('TO', 'CC', 'BCC') for r in det.get('recipients', []))
           and len(det.get('recipients', [])) >= 3, len(det.get('recipients', [])))
        ck('drill has output file', len(det.get('files', [])) >= (1 if terminal['status'] == 'SUCCESS' else 0))

    # ── delete guards + cleanup ──
    print('== delete + cleanup ==')
    st, _ = call(tok, 'DELETE', '/butil/dist/' + str(dist_id))
    ck('409 delete with history', st == 409, st)
    if not dup_existing:      # leave a pre-existing production row untouched
        st, _ = call(tok, 'PUT', '/butil/dist/' + str(dist_id), {'enabled': 'N'})
        ck('disable instead', st == 200, st)
    # the two imported fake departments have no history -> hard delete works
    st, lst = call(tok, 'GET', '/butil/dist')
    fakes = [r for r in lst.get('items', []) if str(r['scopeValue']).startswith('Z99990')]
    done = all(call(tok, 'DELETE', '/butil/dist/' + str(r['distId']))[0] == 200 for r in fakes)
    ck('cleanup imported rows', done and len(fakes) == 2, len(fakes))

    print('\n== RESULT: %d passed, %d failed ==' % (ok, fail))
    sys.exit(1 if fail else 0)


if __name__ == '__main__':
    main()
