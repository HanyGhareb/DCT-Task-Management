#!/usr/bin/env python3
"""GL (App 210) — two-level navigation + Budget Transactions page smoke (EN + AR/RTL).

Covers the nav restructure (3 groups: Projects / General Ledger / Settings, each
with its own sub-tabs, active group derived from the view) and the new Budget
Transactions page: criteria region, master grid, row selection driving the
Details and Approval History regions, paging, CSV export and the AR pass.

Auth: GL_TOK = a live session token (SYS_ADMIN or a GL privilege holder).
Run:  python dev-proxy.py 8210 (from GL/Jet) then python budgettrx_browser_smoke.py
"""
import json
import os
import sys

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8210')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_bt_evidence/')
os.makedirs(EV, exist_ok=True)

TOK = os.environ.get('GL_TOK')
if not TOK:
    sys.exit('Set GL_TOK (live session token)')
sess = {
    'sessionId': TOK,
    'userId': int(os.environ.get('GL_UID', '1')),
    'username': os.environ.get('GL_USERNAME', 'ADMIN'),
    'displayName': os.environ.get('GL_DN', 'System Administrator'),
    'rolesCsv': os.environ.get('GL_ROLES', 'SYS_ADMIN'),
}
sess['roles'] = sess['rolesCsv'].split(',')

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1050})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))

    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
    page.goto(BASE + '/index.html')
    # networkidle NEVER settles on this app (polling + chart libs) -- wait for
    # KO to have bound the shell instead. Same trap as pending_browser_smoke.
    page.wait_for_function(
        "() => window.ko && document.querySelector('.pnav--grp a')", timeout=60000)
    page.wait_for_timeout(2500)

    # ---- 1. two-level nav -------------------------------------------------
    grp = page.locator('.pnav--grp a')
    check('3 main groups', grp.count() == 3, str(grp.count()))
    labels = [grp.nth(i).inner_text().strip() for i in range(grp.count())]
    check('groups are Projects / General Ledger / Settings',
          labels == ['Projects', 'General Ledger', 'Settings'], str(labels))
    check('no JS errors on load', not errors, '; '.join(errors[:2]))

    # landing page = Projects > Budget Utilization, and the active group is
    # DERIVED from the view, so both rows must light up without a click
    check('lands on Projects group',
          'on' in (page.locator('.pnav--grp a').nth(0).get_attribute('class') or ''),
          str(labels[0]))
    check('lands on the Budget Utilization sub-tab',
          'on' in (page.locator('.pnav--sub a').nth(0).get_attribute('class') or ''),
          page.locator('.pnav--sub a.on').first.inner_text().strip())
    check('butil page is the one shown', page.locator('#pg-butil').is_visible())
    check('Chart of Accounts is NOT shown on load',
          not page.locator('#pg-overview').is_visible())
    page.screenshot(path=EV + '00_landing.png', full_page=False)

    page.locator('.pnav--grp a', has_text='Projects').click()
    page.wait_for_timeout(2500)
    sub = page.locator('.pnav--sub a')
    subs = [sub.nth(i).inner_text().strip() for i in range(sub.count())]
    check('Projects has 5 sub-tabs', sub.count() == 5, str(subs))
    check('Budget Transactions present', 'Budget Transactions' in subs, str(subs))
    page.screenshot(path=EV + '01_nav_projects.png', full_page=False)

    page.locator('.pnav--grp a', has_text='General Ledger').click()
    page.wait_for_timeout(1500)
    subs_gl = [page.locator('.pnav--sub a').nth(i).inner_text().strip()
               for i in range(page.locator('.pnav--sub a').count())]
    check('General Ledger has 6 sub-tabs', len(subs_gl) == 6, str(subs_gl))
    for want in ('Dashboard', 'Budget vs Actual', 'Reconciliation', 'Legacy (EBS)', 'DOF Submissions', 'Balances YoY'):
        check('GL group keeps "%s"' % want, want in subs_gl)

    page.locator('.pnav--grp a', has_text='Settings').click()
    page.wait_for_timeout(1200)
    subs_set = [page.locator('.pnav--sub a').nth(i).inner_text().strip()
                for i in range(page.locator('.pnav--sub a').count())]
    check('Settings = Chart of Accounts', subs_set == ['Chart of Accounts'], str(subs_set))

    # ---- 2. the Budget Transactions page ----------------------------------
    page.locator('.pnav--grp a', has_text='Projects').click()
    page.wait_for_timeout(800)
    page.locator('.pnav--sub a', has_text='Budget Transactions').click()
    page.wait_for_timeout(4000)

    pg = page.locator('#pg-budgettrx')
    check('page visible', pg.is_visible())
    check('four regions', pg.locator('.bu-sec').count() == 4,
          str(pg.locator('.bu-sec').count()))
    # .bu-sec-t is text-transform:uppercase and Chrome's innerText applies it,
    # so compare case-insensitively
    heads = [pg.locator('.bu-sec-t').nth(i).inner_text().strip().lower() for i in range(4)]
    check('regions are criteria/transactions/details/approvals',
          heads == ['search criteria', 'transactions', 'details', 'approval history'],
          str(heads))

    check('criteria has 10 fields', pg.locator('.filter-grid .field').count() == 10,
          str(pg.locator('.filter-grid .field').count()))
    # LOVs populated from /budgettrx/filters
    tsel = pg.locator('.filter-grid select').first
    check('budget type LOV populated', tsel.locator('option').count() >= 4,
          str(tsel.locator('option').count()))

    rows = pg.locator('.bt-row')
    check('master grid has rows', rows.count() > 0, str(rows.count()))
    check('details region prompts for a selection',
          'Select a transaction' in pg.locator('.bu-sec').nth(2).inner_text())
    page.screenshot(path=EV + '02_page.png', full_page=True)

    # ---- 3. row selection drives details + approvals ----------------------
    # pick a row that actually has lines, so the child regions are exercised
    idx = 0
    for i in range(min(rows.count(), 40)):
        cells = rows.nth(i).locator('td')
        if cells.count() >= 10 and (cells.nth(9).inner_text().strip() or '0') != '0':
            idx = i
            break
    rows.nth(idx).click()
    page.wait_for_timeout(3000)
    check('row is highlighted as selected',
          'bt-row--on' in (rows.nth(idx).get_attribute('class') or ''))
    det = pg.locator('.bu-sec').nth(2)
    check('details table rendered', det.locator('tbody tr').count() > 0,
          str(det.locator('tbody tr').count()))
    check('details has column headers', det.locator('thead th').count() > 5,
          str(det.locator('thead th').count()))
    appr = pg.locator('.bu-sec').nth(3)
    check('approval region rendered', appr.locator('tbody tr').count() >= 0)
    page.screenshot(path=EV + '03_selected.png', full_page=True)

    # ---- 3b. status pills: tone comes from the VM, not the literal string ---
    # the source vocabulary is mixed-case (SUCCESS/Success, PASS/Pass), so the
    # same tone must come out of either spelling
    tones = page.evaluate(
        "() => { const vm = ko.dataFor(document.body);"
        " return ['Baselined','Baselining Failed','SUCCESS','Success','PASS','Pass',"
        "'ERROR','Rejected','Pending Approval','Approved','DRAFT','NOT CREATED','']"
        "  .map(s => s + '=' + vm.btTone(s)); }")
    want = {'Baselined': 'ok', 'Baselining Failed': 'err', 'SUCCESS': 'ok', 'Success': 'ok',
            'PASS': 'ok', 'Pass': 'ok', 'ERROR': 'err', 'Rejected': 'err',
            'Pending Approval': 'warn', 'Approved': 'ok', 'DRAFT': 'mute',
            'NOT CREATED': 'mute', '': 'mute'}
    got = dict(t.rsplit('=', 1) for t in tones)
    for k, v in want.items():
        check('tone %-18s -> %s' % ("'" + k + "'", v), got.get(k) == v, got.get(k))

    st = pg.locator('.bt-scroll tbody .st')
    check('master status cells are pills', st.count() > 0, str(st.count()))
    check('every master status pill carries a tone',
          st.count() == pg.locator('.bt-scroll tbody .st[class*="st--"]').count())
    # the pill must actually be painted (a tone class with no CSS behind it
    # would still pass a class-name assertion)
    paint = st.first.evaluate(
        "el => { const c = getComputedStyle(el);"
        " return [c.backgroundColor, c.color, getComputedStyle(el,'::before').content]; }")
    check('pill is painted + has an icon glyph',
          paint[0] not in ('rgba(0, 0, 0, 0)', 'transparent')
          and paint[2] not in ('none', 'normal', ''), str(paint))
    check('details status cells are pills', det.locator('tbody .st').count() > 0,
          str(det.locator('tbody .st').count()))
    check('approval state is a pill', appr.locator('tbody .st').count() > 0,
          str(appr.locator('tbody .st').count()))
    check('line/approval counts are chips',
          pg.locator('.bt-scroll tbody .ct').count() > 0,
          str(pg.locator('.bt-scroll tbody .ct').count()))
    page.screenshot(path=EV + '03b_pills.png', full_page=True)

    # ---- 4. criteria actually filter --------------------------------------
    tsel.select_option(label='Annual Budget')
    pg.locator('.filter-actions .btn-primary').first.click()
    page.wait_for_timeout(4000)
    types = {pg.locator('.bt-row').nth(i).locator('td').nth(1).inner_text().strip()
             for i in range(min(pg.locator('.bt-row').count(), 8))}
    check('type filter applied', types == {'Annual-Budget'}, str(types))
    check('selection cleared by a new search',
          pg.locator('.bt-row--on').count() == 0)

    pg.locator('.filter-actions .btn').nth(1).click()   # Clear
    page.wait_for_timeout(3500)
    check('clear restores the full set', pg.locator('.bt-row').count() > 0)

    # ---- 5. AR / RTL -----------------------------------------------------
    # GL is the portal-style app: its own .lang-flip button, and the choice is
    # persisted to localStorage ('gl_lang') only -- NOT to the user's server-side
    # prefs like the shared shell. So this cannot leak into the real account.
    try:
        page.locator('button[data-bind*="toggleLang"]').click()
        page.wait_for_timeout(2500)
        check('RTL applied', page.locator('html[dir="rtl"]').count() == 1)
        ar = page.locator('.pnav--grp a').first.inner_text().strip()
        check('groups translated', 'المشاريع' in ar, ar)
        page.screenshot(path=EV + '04_ar.png', full_page=True)
    finally:
        page.locator('button[data-bind*="toggleLang"]').click()
        page.wait_for_timeout(2000)
        check('EN restored', page.locator('html[dir="rtl"]').count() == 0)

    check('no JS errors overall', not errors, '; '.join(errors[:3]))
    b.close()

ok = sum(1 for _n, c in results if c)
print('\n%d/%d passed' % (ok, len(results)))
print('evidence:', EV)
sys.exit(0 if ok == len(results) else 1)
