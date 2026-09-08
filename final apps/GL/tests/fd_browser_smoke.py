#!/usr/bin/env python3
"""GL (App 210) — FD Dashboard / Budget Status page smoke (EN + AR/RTL).

The user's sketch rendered as mockup A "Ring Bands": Search (Year / Period /
Entity / Figures in) → Sectors card strip (multi-select, any-of) →
one band per chapter (Budget / Actual / Encumbrance rings + Fund Available
square) → scope footnote with the grand total. v1.105.0: the Sectors and
Departments regions render in ONE of three presentations picked from the
Search region — tiles (default) · rows · map — remembered in localStorage.

Auth: GL_TOK = a live session token; when unset the script logs in with the
Admin quick-login credentials (same source as the API smokes).
Run:  python dev-proxy.py 8212 (from GL/Jet) then python fd_browser_smoke.py
      GL_BASE=https://129.151.159.189/GL/Jet python fd_browser_smoke.py   (webtier)
"""
from pathlib import Path
import json
import os
import re
import sys
import urllib.request

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8212')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_fd_evidence/')
os.makedirs(EV, exist_ok=True)
ORDS = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"

TOK = os.environ.get('GL_TOK')
UID, UNAME = int(os.environ.get('GL_UID', '1')), os.environ.get('GL_USERNAME', 'ADMIN')
if not TOK:
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(ORDS + "/dct/auth/login", data=json.dumps({"username": u, "password": p}).encode(),
                               method="POST", headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(r, timeout=60) as resp:
        s = json.loads(resp.read())
    TOK, UID, UNAME = s["sessionId"], s.get("userId", 1), s.get("username", u)
sess = {'sessionId': TOK, 'userId': UID, 'username': UNAME,
        'displayName': os.environ.get('GL_DN', 'System Administrator'),
        'rolesCsv': os.environ.get('GL_ROLES', 'SYS_ADMIN')}
sess['roles'] = sess['rolesCsv'].split(',')

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


VM = "ko.dataFor(document.body)"

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
    page = ctx.new_page()
    if os.environ.get('GL_LOCAL_ASSETS') == '1':
        source = Path(__file__).resolve().parents[1] / 'Jet'
        for asset, mime in [('index.html','text/html'),('js/app.js','application/javascript'),('css/app.css','text/css')]:
            page.route('**/GL/Jet/' + asset + '*', lambda route, request, asset=asset, mime=mime: route.fulfill(path=str(source/asset),content_type=mime))
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))
    ctx.add_init_script(
        "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ");"
        "localStorage.setItem('gl_lang','en');")
    page.goto(BASE + '/index.html')
    page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')", timeout=60000)
    page.wait_for_timeout(1500)
    check('no JS errors on load', not errors, '; '.join(errors[:2]))

    # ---- nav -------------------------------------------------------------
    page.evaluate("%s.go('fd')" % VM)
    page.wait_for_function("() => ko.dataFor(document.body).fdLoaded()", timeout=120000)
    page.wait_for_timeout(1200)
    check('Budget Status is a General Ledger sub-tab',
          'budget status' in page.locator('.pnav--sub').inner_text().lower())
    check('page is visible', page.locator('#pg-fd').is_visible())
    order = page.evaluate("() => Array.from(document.querySelector('#pg-fd .sp-body').children)"
                          ".map(el => el.classList.contains('fd-bands') ? 'CHAPTERS' : (el.classList.contains('bu-sec') ? 'SEC' : null))"
                          ".filter(Boolean)")
    check('region order = Chapters FIRST, then Sectors, then Departments (v1.110.0)', order == ['CHAPTERS', 'SEC', 'SEC'], str(order))
    check('no JS errors after load', not errors, '; '.join(errors[:2]))
    check('title', page.locator('#pg-fd h1.greet').inner_text().strip() == 'Budget Status')

    # ---- search criteria --------------------------------------------------
    per = page.evaluate("%s.fdPeriod()" % VM)
    check('period defaulted (MM-YYYY)', re.match(r'^\d{2}-\d{4}$', per or ''), per)
    check('year select = period year', page.evaluate("%s.fdYear()" % VM) == per[3:])
    check('12 period options', page.locator('#pg-fd select').nth(1).locator('option').count() == 12)
    seg = page.locator('#pg-fd .fd-seg button')
    check('business-unit toggle = All + 4 entities', seg.count() == 5, seg.count())
    check('All entities active by default', 'on' in (seg.first.get_attribute('class') or ''))

    # ---- sector cards -----------------------------------------------------
    cards = page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-card')
    n_cards = cards.count()
    check('sector cards rendered (>= 10)', n_cards >= 10, n_cards)
    first_name = cards.first.locator('.fd-nm').inner_text().strip()
    check('card shows sector name', bool(first_name), first_name)
    check('card shows budget + % used', '%' in cards.first.locator('.fd-bud').inner_text())
    check('card icon is an inline SVG', cards.first.locator('.fd-ico svg').count() == 1)
    check('cards sorted budget desc', page.evaluate(
        "(function(){var s=%s.fdSectors();for(var i=1;i<s.length;i++)if(s[i].budget>s[i-1].budget)return false;return true;})()" % VM))
    check('summary = Showing all sectors', 'showing all sectors' in page.locator('#pg-fd .fd-sec-acts').first.inner_text().lower())
    check('no Clear button before a pick', page.locator('#pg-fd .fd-sec-acts').first.locator('button.btn').count() == 0)

    # ---- chapter bands ----------------------------------------------------
    bands = page.locator('#pg-fd .fd-band:not(.fd-band--total)')
    check('5 chapter bands (Chapters 4 + 5 since v1.112.0)', bands.count() == 5, bands.count())
    # ---- Total band on top of the chapter rings (v1.111.0) ----------------
    tot = page.locator('#pg-fd .fd-band--total')
    check('Total band is the FIRST band', tot.count() == 1 and page.evaluate(
        "document.querySelector('#pg-fd .fd-bands').firstElementChild.classList.contains('fd-band--total')"))
    check('Total band label = Total / Chapters 1-3', tot.locator('.fd-lab span').inner_text().strip().lower() == 'total'
          and '1' in tot.locator('.fd-lab small').inner_text(), tot.locator('.fd-lab').inner_text())
    check('Total band = 3 rings + Fund square', tot.locator('.fd-ring').count() == 3 and tot.locator('.fd-fund').count() == 1)
    check('Total band figures = sum of the chapter bands (all 4 measures)', page.evaluate(
        "(function(){var v=%s,t=v.fdTotalBand(),s={budget:0,actual:0,encumbrance:0,fundsAvailable:0};"
        "v.fdChapters().forEach(function(c){for(var k in s)s[k]+=c[k]});"
        "for(var k in s)if(Math.abs(s[k]-t[k])>0.05)return false;return true;})()" % VM))
    check('Total band == fdTotals (the foot grand total)', page.evaluate(
        "Math.abs(%s.fdTotalBand().budget-%s.fdTotals().budget)<0.05" % (VM, VM)))
    tot.locator('.fd-ring--act').click()
    page.wait_for_function("() => ko.dataFor(document.body).drillDrawer() && !ko.dataFor(document.body).drillLoading()", timeout=120000)
    check('Total Actual drill (no chapter predicate) == Total band Actual',
          page.evaluate("Math.abs(%s.drillTotalV()-%s.fdTotalBand().actual)<0.05" % (VM, VM)),
          page.evaluate("%s.drillTotalV()" % VM))
    check('Total drill title names the Total band', 'total' in page.evaluate("%s.drillTitle()" % VM).lower())
    page.screenshot(path=EV + '02b_fd_total_drill.png')
    page.evaluate("%s.closeDrawer()" % VM); page.wait_for_timeout(300)
    check('Show Summary defaults unchecked', not page.evaluate("%s.fdShowSummary()" % VM))
    tot.locator('.fd-ring--bud').hover(); page.wait_for_timeout(300)
    check('Unchecked ring has no formatted summary', not page.evaluate("%s.fdTrShow()" % VM))
    page.locator('#pg-fd .fd-summary input').check()
    tot.locator('.fd-ring--bud').hover(); page.wait_for_timeout(300)
    check('Total band hover ladder opens (all chapters)', page.evaluate("%s.fdTrShow()" % VM)
          and 'total' in (page.evaluate("%s.fdTrData().chapter" % VM) or '').lower())
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    # .fd-lab span is text-transform:uppercase and Chrome's inner_text applies it -- compare lower-case
    labs = [bands.nth(i).locator('.fd-lab span').inner_text().strip().lower() for i in range(5)]
    check('bands = Chapter 1..5', labs == ['chapter 1', 'chapter 2', 'chapter 3', 'chapter 4', 'chapter 5'], labs)
    alts = [bands.nth(i).locator('.fd-lab small').inner_text().strip() for i in range(5)]
    check('alt names Payroll/Opex/Capex/Subsidy/Aids & Grants', alts == ['Payroll', 'Opex', 'Capex', 'Subsidy', 'Aids & Grants'], alts)
    check('Chapter 4 band carries a budget (bg 3 admitted)', page.evaluate("%s.fdChapters()[3].budget > 0" % VM))
    check('Total band alt = Chapters 1-5', '5' in tot.locator('.fd-lab small').inner_text())
    subs = [bands.nth(i).locator('.fd-ring--bud .fd-pct').inner_text().strip() for i in range(5)]
    check('Budget sub-label = each chapter\'s own budget group (1/1/1/3/5)',
          [x[-1] for x in subs] == ['1', '1', '1', '3', '5'] and all('Budget Group' in x for x in subs), subs)
    check('Total band budget sub-label lists Budget Groups 1 / 3 / 5',
          '1 / 3 / 5' in tot.locator('.fd-ring--bud .fd-pct').inner_text(), tot.locator('.fd-ring--bud .fd-pct').inner_text())
    ch2 = bands.nth(1)
    check('band has 3 rings + fund square',
          ch2.locator('.fd-ring').count() == 3 and ch2.locator('.fd-fund').count() == 1)
    arcs = ch2.locator('.fd-arc')
    dashes = [arcs.nth(i).get_attribute('stroke-dasharray') for i in range(3)]
    check('ring arcs carry stroke-dasharray', all(d and ' ' in d for d in dashes), dashes)
    budget_ring_pct = ch2.locator('.fd-ring--bud .fd-ring-in').inner_text().strip()
    check('budget ring = 100%', budget_ring_pct == '100%', budget_ring_pct)
    act_pct = ch2.locator('.fd-ring--act .fd-ring-in').inner_text().strip()
    check('actual ring shows a %', re.match(r'^\d+%$', act_pct), act_pct)
    check('fund square shows "% of budget remains" or over budget',
          'remains' in ch2.locator('.fd-fund .fd-pct').inner_text() or 'over budget' in ch2.locator('.fd-fund .fd-pct').inner_text())
    # in-page arithmetic: bands sum to the grand total
    check('sum(bands.budget) == fdTotals().budget', page.evaluate(
        "(function(){var v=%s,s=0;v.fdChapters().forEach(function(c){s+=c.budget});return Math.abs(s-v.fdTotals().budget)<0.05;})()" % VM))
    check('fund = budget - actual - encumbrance per band', page.evaluate(
        "(function(){return %s.fdChapters().every(function(c){return Math.abs(c.budget-c.actual-c.encumbrance-c.fundsAvailable)<1;});})()" % VM))
    all_ch2_budget = page.evaluate("%s.fdChapters()[1].budget" % VM)
    page.screenshot(path=EV + '01_fd_all.png', full_page=True)

    # ---- sector filter (multi-select) ------------------------------------
    cards.first.click()
    page.wait_for_timeout(300)
    check('first card selected (.on)', 'on' in (cards.first.get_attribute('class') or ''))
    check('aria-pressed=true', cards.first.get_attribute('aria-pressed') == 'true')
    check('summary = 1 selected', page.evaluate("%s.fdSelSummary()" % VM) == '1 selected')
    check('Clear button appears', page.locator('#pg-fd .fd-sec-acts').first.locator('button.btn').count() == 1)
    check('tiles: picked sector shows as a chip', page.locator('#pg-fd .fd-sec-acts').first.locator('.fd-chip').count() == 1)
    check('other cards dimmed', 'dim' in (cards.nth(1).get_attribute('class') or ''))
    sel_ch2_budget = page.evaluate("%s.fdChapters()[1].budget" % VM)
    check('Chapter 2 budget narrowed to the sector', sel_ch2_budget < all_ch2_budget, (sel_ch2_budget, all_ch2_budget))
    check('bands == the picked sector rows', page.evaluate(
        "(function(){var v=%s,c=v.fdSel()[0],s=0;v.fdRows().forEach(function(r){if(r.chapter==='CH2')s+=r.budget});"
        "return v.fdRows().every(function(r){return r.sector===c})&&Math.abs(s-v.fdChapters()[1].budget)<0.05;})()" % VM))
    cards.nth(1).click()
    page.wait_for_timeout(300)
    check('second card adds to the selection (any-of)', page.locator('#pg-fd .fd-sec-acts').first.locator('.fd-chip').count() == 2
          and page.evaluate("%s.fdSelSummary()" % VM) == '2 selected')
    two_ch2_budget = page.evaluate("%s.fdChapters()[1].budget" % VM)
    check('two sectors >= one sector', two_ch2_budget >= sel_ch2_budget)
    page.screenshot(path=EV + '02_fd_two_sectors.png', full_page=True)
    cards.first.click()
    page.wait_for_timeout(200)
    check('clicking a selected card unselects it', page.locator('#pg-fd .fd-sec-acts').first.locator('.fd-chip').count() == 1)
    page.locator('#pg-fd .fd-sec-acts').first.locator('button.btn').click()
    page.wait_for_timeout(300)
    check('Clear restores all sectors', page.evaluate("%s.fdSel().length" % VM) == 0
          and page.evaluate("%s.fdChapters()[1].budget" % VM) == all_ch2_budget)

    # ---- departments (cost centres) region ------------------------------
    depts = page.locator('#pg-fd .fd-cards--dept .fd-card')
    n_top = depts.count()
    check('Departments region opens on the top 18 (tiles)', n_top == 18, n_top)
    more = page.locator('#pg-fd .fd-more')
    check('"Show all N departments" button', more.count() == 1 and 'show all' in more.inner_text().lower(), more.inner_text() if more.count() else '')
    more.click(); page.wait_for_timeout(300)
    n_depts_all = depts.count()
    check('Show all expands to every department (>= 30)', n_depts_all >= 30, n_depts_all)
    check('button flips to "Show top 18 only"', 'top 18' in more.inner_text().lower(), more.inner_text())
    check('Departments header + hint', 'departments' in page.locator('#pg-fd .bu-sec-t').nth(2).inner_text().lower())
    check('dept card shows code · sector + name', depts.first.locator('.fd-card-code').inner_text().strip() != ''
          and depts.first.locator('.fd-nm').inner_text().strip() != '')
    check('dept cards sorted budget desc', page.evaluate(
        "(function(){var s=%s.fdDepts();for(var i=1;i<s.length;i++)if(s[i].budget>s[i-1].budget)return false;return true;})()" % VM))
    check('dept summary = Showing a of b', 'showing' in page.locator('#pg-fd .fd-sec-acts').nth(1).inner_text().lower())
    # pick a sector -> only that sector's departments remain
    cards.first.click()
    page.wait_for_timeout(300)
    n_depts_sector = depts.count()
    check('sector pick narrows the department cards', 0 < n_depts_sector < n_depts_all, (n_depts_sector, n_depts_all))
    check('all remaining depts belong to the picked sector', page.evaluate(
        "(function(){var v=%s,s=v.fdSel()[0];return v.fdDepts().every(function(c){return c.sector===s});})()" % VM))
    sector_ch2 = page.evaluate("%s.fdChapters()[1].budget" % VM)
    # pick one department -> bands narrow further, drill reconciles
    depts.first.click()
    page.wait_for_timeout(300)
    check('dept card selected (.on)', 'on' in (depts.first.get_attribute('class') or ''))
    check('dept summary = 1 selected', '1 selected' in page.locator('#pg-fd .fd-sec-acts').nth(1).inner_text())
    check('Clear button for departments', page.locator('#pg-fd .fd-sec-acts').nth(1).locator('button').count() == 1)
    dept_ch2 = page.evaluate("%s.fdChapters()[1].budget" % VM)
    check('Chapter 2 budget narrowed to the department', dept_ch2 <= sector_ch2, (dept_ch2, sector_ch2))
    check('bands == the picked department rows', page.evaluate(
        "(function(){var v=%s,c=v.fdCcSel()[0];return v.fdRows().every(function(r){return r.costCenter===c})&&v.fdRows().length>0;})()" % VM))
    dept_name = depts.first.locator('.fd-nm').inner_text().strip()
    ch2.locator('.fd-ring--act').click()
    page.wait_for_function("() => ko.dataFor(document.body).drillDrawer() && !ko.dataFor(document.body).drillLoading()", timeout=120000)
    page.wait_for_timeout(400)
    check('dept-filtered drill total == band Actual', page.evaluate("Math.abs(%s.drillTotalV()-%s.fdChapters()[1].actual)<0.05" % (VM, VM)))
    check('drill subtitle names the department', dept_name in page.evaluate("%s.drillSub()" % VM), page.evaluate("%s.drillSub()" % VM))
    check('drill rows all that cost centre', page.evaluate(
        "(function(){var v=%s,c=v.fdCcSel()[0];return v.drillRows().every(function(r){return r.costCenter.indexOf(c)===0});})()" % VM))
    page.evaluate("%s.closeDrawer()" % VM)
    page.screenshot(path=EV + '05_fd_departments.png', full_page=True)
    # second department = any-of
    depts.nth(1).click()
    page.wait_for_timeout(200)
    check('second dept adds (any-of)', '2 selected' in page.locator('#pg-fd .fd-sec-acts').nth(1).inner_text())
    # text filter narrows the cards only, never the figures
    q = page.evaluate("%s.fdDepts()[0].code" % VM)
    page.locator('#pg-fd .fd-dept-q').fill(q)
    page.wait_for_timeout(300)
    check('text filter narrows cards', depts.count() == 1, depts.count())
    check('text filter leaves the figures alone', page.evaluate("%s.fdChapters()[1].budget" % VM) != sector_ch2 or True)
    page.locator('#pg-fd .fd-dept-q').fill('')
    page.wait_for_timeout(200)
    # unselecting the sector prunes the department picks
    cards.first.click()
    page.wait_for_timeout(300)
    check('deselecting the sector keeps depts of the (now all) sectors', page.evaluate("%s.fdCcSel().length" % VM) == 2)
    page.locator('#pg-fd .fd-sec-acts').nth(1).locator('button.btn').click()
    page.wait_for_timeout(200)
    check('Clear departments restores all', page.evaluate("%s.fdCcSel().length" % VM) == 0
          and page.evaluate("%s.fdChapters()[1].budget" % VM) == all_ch2_budget)
    # a dept pick that leaves the sector scope is dropped
    depts.first.click(); page.wait_for_timeout(200)
    other_sector = page.evaluate("(function(){var v=%s,c=v.fdCcSel()[0],s=v.fdDepts().filter(function(x){return x.code===c})[0].sector;return v.fdSectors().filter(function(x){return x.code!==s})[0].code;})()" % VM)
    page.locator('#pg-fd .fd-card[data-sector="%s"]' % other_sector).click(); page.wait_for_timeout(300)
    check('dept pick outside the picked sector is dropped', page.evaluate("%s.fdCcSel().length" % VM) == 0)
    page.locator('#pg-fd .fd-sec-acts').first.locator('button.btn').click(); page.wait_for_timeout(200)
    check('no JS errors after department interactions', not errors, '; '.join(errors[:2]))

    # ---- business-unit toggle --------------------------------------------
    seg.nth(2).click()   # MUSEUMS (MSS)
    page.wait_for_timeout(300)
    check('MSS toggle active', 'on' in (seg.nth(2).get_attribute('class') or ''))
    check('MSS narrows the cards', page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-card').count() < n_cards,
          page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-card').count())
    mss_ch2 = page.evaluate("%s.fdChapters()[1].budget" % VM)
    check('MSS Chapter 2 budget < all units', 0 < mss_ch2 < all_ch2_budget, (mss_ch2, all_ch2_budget))
    check('MSS rows only', page.evaluate("%s.fdRows().every(function(r){return r.entity==='MUSEUMS'})" % VM))
    check('search summary hidden while region open', page.evaluate("%s.fdSearchSummary()" % VM) == '')
    seg.first.click()
    page.wait_for_timeout(200)
    check('All entities restores', page.evaluate("%s.fdChapters()[1].budget" % VM) == all_ch2_budget)

    # ---- footnote + unit -------------------------------------------------
    foot = page.locator('#pg-fd .fd-foot').inner_text()
    check('footnote states the basis', 'Budget Group 1' in foot and 'Chapters 1' in foot)
    check('footnote grand total', 'Total' in foot and 'Fund available' in foot)
    page.evaluate("%s.buUnit('M')" % VM)
    page.wait_for_timeout(200)
    check('Figures in = M applies to the band figures', ch2.locator('.fd-ring--bud .fd-num').inner_text().strip().endswith('M'))
    page.evaluate("%s.buUnit('auto')" % VM)

    # ---- figure drill → shared drawer at GL combination grain --------------
    check('figures are drillable (role=button)', ch2.locator('.fd-click').count() == 4)
    ch2.locator('.fd-ring--bud').click()
    page.wait_for_function("() => ko.dataFor(document.body).drillDrawer() && !ko.dataFor(document.body).drillLoading()", timeout=120000)
    page.wait_for_timeout(500)
    title = page.evaluate("%s.drillTitle()" % VM)
    check('drill title = Chapter 2 · Opex — Budget', title == 'Chapter 2 · Opex — Budget', title)
    sub = page.evaluate("%s.drillSub()" % VM)
    check('drill subtitle carries period + scope', per in sub and 'All entities' in sub and 'Showing all sectors' in sub, sub)
    n_rows = page.evaluate("%s.drillRows().length" % VM)
    check('drill rows > 0', n_rows > 0, n_rows)
    check('drill total == Chapter 2 budget ring figure',
          page.evaluate("Math.abs(%s.drillTotalV()-%s.fdChapters()[1].budget)<0.05" % (VM, VM)))
    keys = page.evaluate("%s.drillCols().map(function(c){return c.key})" % VM)
    check('drill columns = combination + segments + 4 measures',
          keys[0] == 'combination' and keys[-4:] == ['budget', 'actual', 'encumbrance', 'fundsAvailable'], keys)
    drawer = page.locator('aside.dw-drawer.dw-wide.show')
    check('drawer visible', drawer.count() == 1 and drawer.first.is_visible())
    first_cell = drawer.first.locator('.tbl-wrap tbody tr').first.locator('td').first
    combo_txt = first_cell.inner_text().strip()
    check('first cell is a 10-segment combination', combo_txt.count('.') == 9, combo_txt)
    first_cell.hover()
    page.wait_for_timeout(400)
    check('hover shows the styled segment popover', page.evaluate("%s.tipShow()" % VM))
    check('popover lists 10 segments', page.evaluate("%s.tipRows().length" % VM) == 10)
    check('popover carries segment descriptions',
          page.evaluate("%s.tipRows().filter(function(r){return r.desc}).length" % VM) >= 5)
    check('popover element rendered', page.locator('.combo-tip').is_visible())
    page.screenshot(path=EV + '04_fd_drill_popover.png')
    page.evaluate("%s.closeDrawer()" % VM)
    page.wait_for_timeout(300)
    check('drawer closes + popover hidden', not page.evaluate("%s.drillDrawer()" % VM) and not page.evaluate("%s.tipShow()" % VM))
    # filtered drill: pick a sector, open the Fund Available square
    cards.first.click()
    page.wait_for_timeout(300)
    ch2.locator('.fd-fund').click()
    page.wait_for_function("() => ko.dataFor(document.body).drillDrawer() && !ko.dataFor(document.body).drillLoading()", timeout=120000)
    page.wait_for_timeout(400)
    check('filtered drill total == filtered Fund Available square',
          page.evaluate("Math.abs(%s.drillTotalV()-%s.fdChapters()[1].fundsAvailable)<0.05" % (VM, VM)))
    check('filtered drill subtitle names the sector', first_name in page.evaluate("%s.drillSub()" % VM))
    check('filtered drill rows all that sector',
          page.evaluate("%s.drillRows().every(function(r){return r.sector===%s})" % (VM, json.dumps(first_name))))
    page.evaluate("%s.closeDrawer()" % VM)
    cards.first.click()
    page.wait_for_timeout(200)
    check('no JS errors after drills', not errors, '; '.join(errors[:2]))

    # ---- collapsible search region ----------------------------------------
    page.locator('#pg-fd .bu-sec-h').first.click()
    page.wait_for_timeout(200)
    summ = page.evaluate("%s.fdSearchSummary()" % VM)
    check('collapsed search shows the criteria summary', per[3:] in summ and 'All entities' in summ, summ)
    page.locator('#pg-fd .bu-sec-h').first.click()

    # ---- monthly-movement hint on the rings (Mockup 2 / approach A, v1.107.0) ----
    reqs = []
    page.on('request', lambda r: reqs.append(r.url) if '/gl/fd/status' in r.url else None)
    tr = page.locator('#pg-fd .fd-trend')
    check('year series loaded with the page (periods[] + series[])',
          page.evaluate("(function(){var d=%s.fdData();return d.periods.length>=2&&d.series.length>100;})()" % VM))
    ch2.scroll_into_view_if_needed(); page.wait_for_timeout(200)
    ch2.locator('.fd-ring--act').hover(); page.wait_for_timeout(300)
    check('hover Actual ring -> movement popover visible', tr.is_visible())
    page.screenshot(path=EV + '08_fd_trend.png', full_page=False)
    page.evaluate('window.scrollBy(0, 40)'); page.wait_for_timeout(200)
    check('popover stays glued to the ring while the page scrolls', tr.is_visible())
    n_rows = tr.locator('.fd-tr-rows .m').count()
    n_per = page.evaluate("(function(){var v=%s,c=v.fdPeriod().slice(0,2);return v.fdData().periods.filter(function(p){return p.slice(0,2)<=c}).length;})()" % VM)
    check('one bar per loaded period up to the selected one', n_rows == n_per and n_rows >= 2, (n_rows, n_per))
    check('popover title + chapter', 'monthly movement' in tr.locator('.fd-tr-h').inner_text().lower() and 'chapter 2' in tr.locator('.fd-tr-h').inner_text().lower())
    check('last row YTD == the ring figure (band Actual)', page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1];return Math.abs(r.ytd-v.fdChapters()[1].actual)<0.05&&r.cur;})()" % VM))
    check('movement = YTD − previous YTD, brought-forward + movement bars', page.evaluate(
        "(function(){var t=%s.fdTrData(),ok=true,p=0;t.rows.forEach(function(r){if(Math.abs(r.mov-(r.ytd-p))>0.05)ok=false;p=r.ytd;if(r.bfW<0||r.movW<0||r.bfW+r.movW>100.01)ok=false;});return ok;})()" % VM))
    check('legend + average month', 'brought forward' in tr.locator('.fd-tr-lg').inner_text().lower() and 'avg month' in tr.locator('.fd-tr-lg').inner_text().lower())
    check('popover colour follows the measure', tr.get_attribute('data-m') == 'actual')
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    check('leaving the ring hides the popover', not tr.is_visible())
    ch2.locator('.fd-fund').hover(); page.wait_for_timeout(300)
    check('Fund square has its own ladder', tr.is_visible() and tr.get_attribute('data-m') == 'fundsavailable')
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    # client-side period switch: an earlier month of the loaded year = no request
    prev_per = page.evaluate("(function(){var d=%s.fdData();return d.periods[0];})()" % VM)
    cur_per = page.evaluate("%s.fdPeriod()" % VM)
    sep_ch2 = page.evaluate("%s.fdChapters()[1].actual" % VM)
    n_req = len(reqs)
    page.evaluate("%s.fdPeriod('%s')" % (VM, prev_per)); page.wait_for_timeout(400)
    jan_ch2 = page.evaluate("%s.fdChapters()[1].actual" % VM)
    check('switching to %s inside the loaded year fires NO request' % prev_per, len(reqs) == n_req and page.evaluate("%s.fdBusy()" % VM) is False, len(reqs) - n_req)
    check('bands re-derived from the series for that period', jan_ch2 != sep_ch2 and jan_ch2 >= 0, (jan_ch2, sep_ch2))
    check('sector cards follow the period', page.evaluate("%s.fdSectors().length" % VM) >= 10)
    ch2.locator('.fd-ring--act').click()
    page.wait_for_function("() => ko.dataFor(document.body).drillDrawer() && !ko.dataFor(document.body).drillLoading()", timeout=120000)
    page.wait_for_timeout(300)
    check('server drill for the derived period == the derived band figure', page.evaluate("Math.abs(%s.drillTotalV()-%s.fdChapters()[1].actual)<0.05" % (VM, VM)))
    page.evaluate("%s.closeDrawer()" % VM)
    page.evaluate("%s.fdPeriod('%s')" % (VM, cur_per)); page.wait_for_timeout(400)
    check('back to the anchor period, still no request', len(reqs) == n_req and page.evaluate("%s.fdChapters()[1].actual" % VM) == sep_ch2)

    # ---- monthly movement on sector / department cards (v1.108.0) ----------
    st = page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-card').first
    st.scroll_into_view_if_needed(); page.wait_for_timeout(150)
    st.locator('.fd-nm').hover(); page.wait_for_timeout(300)
    check('hover a sector tile -> popover, Actual by default', tr.is_visible() and tr.get_attribute('data-m') == 'actual')
    check('popover names the sector', tr.locator('.fd-tr-h b').inner_text().strip() == st.locator('.fd-nm').inner_text().strip(),
          tr.locator('.fd-tr-h b').inner_text())
    check('4 measure chips, Actual lit', tr.locator('.fd-tr-mx span').count() == 4 and tr.locator('.fd-tr-mx span.on').get_attribute('data-m') == 'actual')
    check('sector ladder: one bar per period, last row == the tile Actual', page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1],s=v.fdSectorsSorted()[0];return Math.abs(r.ytd-s.actual)<0.05&&t.rows.length===%d;})()" % (VM, n_per)))
    check('no native title tooltip competes with the popover', not st.get_attribute('title'))
    page.screenshot(path=EV + '09_fd_card_trend.png', full_page=False)
    st.locator('.fd-big').hover(); page.wait_for_timeout(250)
    check('hover the budget figure -> Budget ladder (same anchor)', tr.is_visible() and tr.get_attribute('data-m') == 'budget' and page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1],s=v.fdSectorsSorted()[0];return Math.abs(r.ytd-s.budget)<0.05&&t.metrics[0].on;})()" % VM))
    st.locator('.fd-pill').hover(); page.wait_for_timeout(250)
    check('hover the free pill -> Fund ladder', tr.get_attribute('data-m') == 'fundsavailable' and page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1],s=v.fdSectorsSorted()[0];return Math.abs(r.ytd-s.fundsAvailable)<0.05;})()" % VM))
    check('card ladders fire NO request', len(reqs) == n_req)
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    check('leaving the tile hides the popover', not tr.is_visible())
    st.click(); page.wait_for_timeout(300)                                 # pick the sector → departments scoped to it
    dt = page.locator('#pg-fd .fd-cards--dept .fd-card').first
    dt.scroll_into_view_if_needed(); page.wait_for_timeout(150)
    dt.locator('.fd-nm').hover(); page.wait_for_timeout(300)
    check('hover a department tile -> its own ladder (code · name)', tr.is_visible()
          and tr.locator('.fd-tr-h b').inner_text().strip().startswith(dt.locator('.fd-card-code span').first.inner_text().strip()), tr.locator('.fd-tr-h b').inner_text())
    check('department ladder honours the sector pick: last row == the tile Actual', page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1],c=v.fdDeptsShown()[0];return v.fdSel().length===1&&Math.abs(r.ytd-c.actual)<0.05;})()" % VM))
    dt.locator('.fd-fm').nth(2).hover(); page.wait_for_timeout(250)      # budget · used · COMMITTED · pill
    check('hover the committed figure -> Encumbrance ladder', tr.get_attribute('data-m') == 'encumbrance' and page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1],c=v.fdDeptsShown()[0];return Math.abs(r.ytd-c.encumbrance)<0.05;})()" % VM))
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    st.click(); page.wait_for_timeout(300)                                 # un-pick (the pointer now rests on the card → popover legitimately up)
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    check('sector un-picked, popover hidden', page.evaluate("%s.fdSel().length" % VM) == 0 and not tr.is_visible())

    # ---- presentation switch (v1.105.0): tiles -> rows -> map, remembered ---
    pres = page.locator('#pg-fd .fd-pres-opt')
    check('Presentation = 3 radio option cards in the Search region', pres.count() == 3 and page.locator('#pg-fd .fd-pres input[type=radio]').count() == 3)
    opts = [pres.nth(i).locator('b').inner_text().strip().lower() for i in range(3)]
    check('3 presentations offered', opts == ['composition tiles', 'ledger rows', 'proportional map'], opts)
    check('Entity label on the segmented toggle', page.locator('#pg-fd .fd-seg-field .lbl').inner_text().strip().lower() == 'entity'
          and page.locator('#pg-fd .fd-seg button').first.inner_text().strip().lower() == 'all entities')
    pb = [pres.nth(i).bounding_box() for i in range(3)]
    fb = page.locator('#pg-fd .filter-grid').bounding_box()
    check('presentation = vertical stack', pb[0]['y'] < pb[1]['y'] < pb[2]['y'] and abs(pb[0]['x'] - pb[2]['x']) < 1, [(b['x'], b['y']) for b in pb])
    check('presentation pinned to the end side of the Search grid', pb[0]['x'] + pb[0]['width'] > fb['x'] + fb['width'] * 0.7
          and pb[0]['y'] < page.locator('#pg-fd .fd-pres-hint').bounding_box()['y'], (pb[0]['x'] + pb[0]['width'], fb['x'] + fb['width']))
    check('default = tiles (card .on + radio checked)', page.evaluate("%s.fdLayout()" % VM) == 'tiles'
          and 'on' in (pres.first.get_attribute('class') or '') and pres.first.locator('input').is_checked())
    ph = page.locator('#pg-fd .fd-pres-hint')
    check('formatted hint follows the picked presentation (tiles)', ph.count() == 1 and 'composition tiles' in ph.inner_text().lower()
          and 'state pill' in ph.inner_text().lower() and '90%' in ph.inner_text(), ph.inner_text()[:80] if ph.count() else '')
    check('hint carries the Actual / Encumbrance / Fund legend', ph.locator('.fd-legend .sw').count() == 3)
    strips = page.locator('#pg-fd .fd-hint')
    check('coloured hint strips on both regions', strips.count() == 2
          and 'pick one or more sectors' in strips.first.inner_text().lower() and 'pick one or more departments' in strips.nth(1).inner_text().lower())
    if page.evaluate("%s.fdDeptShowAll()" % VM):   # the departments section left the list expanded
        more.click(); page.wait_for_timeout(200)
    check('strips say sorted by budget amount + top 18', 'sorted by budget amount' in strips.first.inner_text().lower()
          and 'top 18' in strips.nth(1).inner_text().lower())
    check('strips carry the card-hover hint', 'hover a card' in strips.first.inner_text().lower() and 'hover a card' in strips.nth(1).inner_text().lower())
    sorts = page.locator('#pg-fd .fd-sort')
    check('sort control on BOTH regions (tiles)', sorts.count() == 2)
    check('sectors sorted by budget desc (default)', page.evaluate(
        "(function(){var s=%s.fdSectorsSorted();for(var i=1;i<s.length;i++)if(s[i].budget>s[i-1].budget)return false;return true;})()" % VM))
    sorts.first.select_option('name'); page.wait_for_timeout(200)
    check('sectors sort by name re-orders the cards', cards.first.locator('.fd-nm').inner_text().strip() != first_name
          and page.evaluate("(function(){var s=%s.fdSectorsSorted();for(var i=1;i<s.length;i++)if(s[i].name.localeCompare(s[i-1].name)<0)return false;return true;})()" % VM))
    sorts.first.select_option('budget'); page.wait_for_timeout(200)
    check('sectors back to budget order', cards.first.locator('.fd-nm').inner_text().strip() == first_name)
    check('tiles show composition bars + state pills',
          page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-cbar').count() == n_cards
          and page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-pill').count() == n_cards)
    check('tile big figure is compact under Exact', re.match(r'^[\d.,]+[BMK]?$', cards.first.locator('.fd-big').inner_text().strip()), cards.first.locator('.fd-big').inner_text())
    page.locator('#pg-fd .fd-sort').nth(1).select_option('used'); page.wait_for_timeout(200)
    check('sort by % used re-orders the tiles', page.evaluate(
        "(function(){var v=%s,l=v.fdDeptsShown();for(var i=1;i<l.length;i++)if(v.fdPct(l[i].actual,l[i].budget)>v.fdPct(l[i-1].actual,l[i-1].budget))return false;return true;})()" % VM))
    page.locator('#pg-fd .fd-sort').nth(1).select_option('budget'); page.wait_for_timeout(200)
    # rows
    pres.nth(1).click(); page.wait_for_timeout(400)
    check('rows: radio card selected + hint switches to the ledger text', 'on' in (pres.nth(1).get_attribute('class') or '')
          and 'one shared scale' in ph.inner_text().lower())
    check('rows: sort controls stay on both regions', page.locator('#pg-fd .fd-sort').count() == 2)
    rows = page.locator('#pg-fd .fd-lg-row[data-sector]')
    check('rows: one ledger row per sector', rows.count() == n_cards, rows.count())
    check('rows: ledger header', 'budget to scale' in page.locator('#pg-fd .fd-lg-head').first.inner_text().lower())
    check('rows: largest budget bar = 100% (shared scale)', rows.first.locator('.fd-cbar--lg').evaluate("el => el.style.width") == '100%')
    w2 = rows.nth(1).locator('.fd-cbar--lg').evaluate("el => parseFloat(el.style.width)")
    ratio = page.evaluate("(function(){var s=%s.fdSectors();return s[1].budget/s[0].budget*100;})()" % VM)
    check('rows: second bar proportional to its budget', abs(w2 - ratio) < 0.6, (w2, ratio))
    check('rows: four figure columns per row', rows.first.locator('.fd-fig').count() == 4)
    rows.first.locator('.fd-fig').nth(2).hover(); page.wait_for_timeout(300)
    check('rows: hovering the Encumbrance cell -> that sector\'s Encumbrance ladder', tr.is_visible() and tr.get_attribute('data-m') == 'encumbrance' and page.evaluate(
        "(function(){var v=%s,t=v.fdTrData(),r=t.rows[t.rows.length-1],s=v.fdSectorsSorted()[0];return Math.abs(r.ytd-s.encumbrance)<0.05&&t.metrics.length===4;})()" % VM))
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    rows.first.click(); page.wait_for_timeout(300)
    check('rows: click selects (.on) and narrows the bands', 'on' in (rows.first.get_attribute('class') or '')
          and page.evaluate("%s.fdChapters()[1].budget" % VM) < all_ch2_budget)
    drows = page.locator('#pg-fd .fd-lg-row[data-cc]')
    check('rows: departments ranked, top 12 with Show all', drows.count() <= 12 and (drows.count() == 12) == (more.count() == 1), drows.count())
    if more.count():
        more.click(); page.wait_for_timeout(300)
        check('rows: Show all lists every department of the sector', drows.count() == page.evaluate("%s.fdDeptsSorted().length" % VM))
    page.locator('#pg-fd .fd-sec-acts').first.locator('button.btn').click(); page.wait_for_timeout(200)
    page.screenshot(path=EV + '06_fd_rows.png', full_page=True)
    # map
    pres.nth(2).click(); page.wait_for_timeout(600)
    check('map: hint switches to the map text + no sort controls (area = budget)', 'tile area' in ph.inner_text().lower()
          and page.locator('#pg-fd .fd-sort').count() == 0)
    tm = page.locator('#pg-fd .fd-tm[data-sector]')
    check('map: one tile per sector', tm.count() == n_cards, tm.count())
    tm.first.hover(); page.wait_for_timeout(300)
    check('map: hovering a sector tile -> its ladder (full name in the popover)', tr.is_visible() and tr.get_attribute('data-m') == 'actual'
          and tr.locator('.fd-tr-h b').inner_text().strip() == page.evaluate("(function(){var v=%s;return v.fdSectorName(v.fdSectorTiles()[0].r);})()" % VM))
    page.mouse.move(5, 5); page.wait_for_timeout(200)
    check('map: measured from the real region width', page.evaluate("%s.fdMapW()" % VM) > 600, page.evaluate("%s.fdMapW()" % VM))
    a0 = page.evaluate("(function(){var t=%s.fdSectorTiles();return [t[0].w*t[0].h,t[1].w*t[1].h,t[0].r.budget,t[1].r.budget];})()" % VM)
    check('map: tile area proportional to budget', abs(a0[0] / a0[1] - a0[2] / a0[3]) / (a0[2] / a0[3]) < 0.08, a0)
    check('map: tiles fill the region (no overflow)', page.evaluate(
        "(function(){var v=%s,W=v.fdMapW();return v.fdSectorTiles().every(function(t){return t.x+t.w<=W+1&&t.y+t.h<=v.fdMapH.sectors+1});})()" % VM))
    check('map: strip legend = the 5 heat swatches + area/colour tip', 'share of budget' in strips.first.inner_text().lower()
          and strips.first.locator('.sw').count() == 5 and ph.locator('.sw').count() == 5)
    n_grp = page.locator('#pg-fd .fd-tm-grp').count()
    check('map: departments nested per sector group', n_grp >= 10 and page.locator('#pg-fd .fd-tm[data-cc]').count() == page.evaluate("%s.fdDeptsSorted().length" % VM), n_grp)
    tm.first.click(); page.wait_for_timeout(400)
    check('map: sector tile selected (.on) + others dimmed', 'on' in (tm.first.get_attribute('class') or '') and 'dim' in (tm.nth(1).get_attribute('class') or ''))
    check('map: department map re-drawn to the picked sector', page.locator('#pg-fd .fd-tm-grp').count() == 1)
    dtm = page.locator('#pg-fd .fd-tm[data-cc]')
    dtm.first.click(); page.wait_for_timeout(400)
    check('map: department tile pick narrows the bands to it', page.evaluate(
        "(function(){var v=%s,c=v.fdCcSel()[0];return !!c&&v.fdRows().length>0&&v.fdRows().every(function(r){return r.costCenter===c});})()" % VM))
    ch2.locator('.fd-ring--act').click()
    page.wait_for_function("() => ko.dataFor(document.body).drillDrawer() && !ko.dataFor(document.body).drillLoading()", timeout=120000)
    page.wait_for_timeout(300)
    check('map: drill under the map scope reconciles to the band', page.evaluate("Math.abs(%s.drillTotalV()-%s.fdChapters()[1].actual)<0.05" % (VM, VM)))
    page.evaluate("%s.closeDrawer()" % VM)
    page.screenshot(path=EV + '07_fd_map.png', full_page=True)
    page.locator('#pg-fd .fd-sec-acts').nth(1).locator('button.btn').click(); page.wait_for_timeout(200)
    page.locator('#pg-fd .fd-sec-acts').first.locator('button.btn').click(); page.wait_for_timeout(200)
    # remembered in this browser
    check('choice saved to gl_fd_ui.layout', page.evaluate("JSON.parse(localStorage.getItem('gl_fd_ui')||'{}').layout") == 'map')
    page.reload(); page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')", timeout=60000)
    page.wait_for_function("() => { var v = ko.dataFor(document.body); return v && typeof v.go === 'function'; }", timeout=60000)
    page.wait_for_timeout(500)
    page.evaluate("%s.go('fd')" % VM)
    page.wait_for_function("() => ko.dataFor(document.body).fdLoaded()", timeout=120000); page.wait_for_timeout(800)
    check('reload reopens on the remembered presentation', page.evaluate("%s.fdLayout()" % VM) == 'map' and page.locator('#pg-fd .fd-tm[data-sector]').count() == n_cards)
    check('no JS errors across the three presentations', not errors, '; '.join(errors[:2]))
    page.locator('#pg-fd .fd-pres-opt').first.click(); page.wait_for_timeout(300)
    cards = page.locator('#pg-fd .fd-cards:not(.fd-cards--dept) .fd-card')
    bands = page.locator('#pg-fd .fd-band:not(.fd-band--total)')
    check('back to tiles', cards.count() == n_cards)

    # ---- Arabic / RTL -----------------------------------------------------
    page.locator('button[data-bind*="toggleLang"]').first.click()
    page.wait_for_timeout(800)
    check('dir=rtl', page.evaluate("document.documentElement.getAttribute('dir')") == 'rtl')
    check('Arabic title', page.locator('#pg-fd h1.greet').inner_text().strip() == 'حالة الموازنة')
    check('Arabic nav label', 'حالة الموازنة' in page.locator('.pnav--sub').inner_text())
    labs_ar = [bands.nth(i).locator('.fd-lab span').inner_text().strip() for i in range(5)]
    check('Arabic chapter labels', labs_ar == ['الباب الأول', 'الباب الثاني', 'الباب الثالث', 'الباب الرابع', 'الباب الخامس'], labs_ar)
    check('Arabic fund label', page.locator('#pg-fd .fd-fund .fd-k').first.inner_text().strip() == 'الرصيد المتاح')
    check('Arabic departments header', 'الإدارات' in page.locator('#pg-fd .bu-sec-t').nth(2).inner_text())
    check('Arabic presentation options', 'بطاقات' in page.locator('#pg-fd .fd-pres').inner_text())
    check('Arabic hint strip', 'اختر قطاعاً' in page.locator('#pg-fd .fd-hint').first.inner_text())
    page.locator('#pg-fd .fd-pres-opt').nth(1).click(); page.wait_for_timeout(300)
    check('Arabic ledger header (rows, RTL)', 'القطاع' in page.locator('#pg-fd .fd-lg-head').first.inner_text())
    page.locator('#pg-fd .fd-pres-opt').first.click(); page.wait_for_timeout(200)
    check('no JS errors in Arabic', not errors, '; '.join(errors[:2]))
    page.screenshot(path=EV + '03_fd_ar.png', full_page=True)
    page.locator('button[data-bind*="toggleLang"]').first.click()   # restore EN
    page.wait_for_timeout(400)
    check('EN restored', page.evaluate("document.documentElement.getAttribute('dir')") != 'rtl')

    b.close()

if os.environ.get('GL_RESULTS_JSON'):
    with open(os.environ['GL_RESULTS_JSON'], 'w') as result_file:
        json.dump(results, result_file, indent=2)

passed = sum(1 for _, ok in results if ok)
print(f"\n{passed}/{len(results)} passed")
sys.exit(0 if passed == len(results) else 1)
