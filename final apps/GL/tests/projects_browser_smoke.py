"""Executive Project Dashboard -- browser smoke (GL App 210), EN + AR/RTL.

Covers the Portfolio page, the drill into Project 360, and the honesty markers
(DATA GAP badge, "no actual task dates" note) that this feature depends on.

Usage:
    python ../Jet/dev-proxy.py 8211 &
    GL_TOK=<sessionId> python projects_browser_smoke.py
"""
import json
import os
import re
import ssl
import sys
import urllib.request

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8211')
ORDS = os.environ.get('GL_ORDS', 'https://129.151.159.189')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_proj_evidence')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
os.makedirs(EV, exist_ok=True)
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('  PASS ' if cond else '  FAIL ') + name + ('  ' + str(extra) if extra else ''))


def login():
    tok = os.environ.get('GL_TOK')
    if tok:
        return tok
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(ORDS + '/ords/admin/dct/auth/login',
                               data=json.dumps({'username': u, 'password': p}).encode(),
                               method='POST', headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


def main():
    tok = login()
    sess = {'sessionId': tok, 'userId': 1, 'username': 'ADMIN',
            'displayName': 'ADMIN', 'rolesCsv': 'SYS_ADMIN'}
    errors = []
    with sync_playwright() as pw:
        b = pw.chromium.launch()
        ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
        ctx.add_init_script(
            "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ");"
            "localStorage.setItem('gl_lang','en');")
        page = ctx.new_page()
        page.on('pageerror', lambda e: errors.append(str(e)))
        page.goto(BASE + '/index.html')
        # networkidle never settles on this app -- wait on KO + the nav
        page.wait_for_function("() => window.ko && document.querySelector('.pnav--grp a')",
                               timeout=60000)

        print('\n-- navigation --')
        groups = page.eval_on_selector_all('.pnav--grp a', 'els => els.map(e => e.textContent.trim())')
        check('three nav groups', len(groups) == 3, groups)
        # wait for the VM itself, not just the nav: ko.dataFor(document.body) can
        # still be undefined for a tick after the first bound element appears
        page.wait_for_function(
            "() => window.ko && ko.dataFor(document.body) && ko.dataFor(document.body).go",
            timeout=90000)
        page.evaluate("() => ko.dataFor(document.body).go('portfolio')")
        page.wait_for_function("() => ko.dataFor(document.body).view() === 'portfolio'", timeout=30000)
        subs = page.eval_on_selector_all('.pnav--sub a', 'els => els.map(e => e.textContent.trim())')
        check('portfolio is a Projects sub-tab', any('Portfolio' in s for s in subs), subs)
        check('Project 360 hidden until opened', not any('360' in s for s in subs), subs)
        check('#pg-portfolio visible', page.is_visible('#pg-portfolio'))

        print('\n-- portfolio loads --')
        page.wait_for_function(
            "() => { const v = ko.dataFor(document.body); return v.pfLoaded && v.pfLoaded(); }",
            timeout=240000)
        cnt = page.evaluate("() => ko.dataFor(document.body).pfCount()")
        check('projects loaded', cnt > 0, cnt)
        check('KPI tiles rendered', page.locator('#pg-portfolio .bk').count() >= 6,
              page.locator('#pg-portfolio .bk').count())
        check('gauge rendered', page.locator('#pg-portfolio .pf-gauge circle').count() == 3)
        util = page.evaluate("() => ko.dataFor(document.body).pfGauge().util")
        check('gauge has a utilisation value', isinstance(util, (int, float)), util)
        check('health bar has 4 segments', page.locator('#pg-portfolio .pf-hbar i').count() == 4)
        check('largest consumers listed', page.locator('#pg-portfolio .pf-bar').count() > 0)
        ins = page.locator('#pg-portfolio .ins-list li').count()
        check('insights generated', ins >= 3, ins)
        raw = page.eval_on_selector_all('#pg-portfolio .ins-list li',
                                        'els => els.map(e => e.textContent).join(" ")')
        check('no unsubstituted placeholders', '{' not in raw)

        print('\n-- register (shared interactive report) --')
        page.wait_for_selector('#pg-portfolio .ir-table thead th', timeout=60000)
        ths = page.locator('#pg-portfolio .ir-table thead th').count()
        check('register columns rendered', ths >= 12, ths)
        check('health row tint applied',
              page.locator('#pg-portfolio .ir-table tbody tr[class*="pf-h-"]').count() > 0)
        page.screenshot(path=EV + '/01_portfolio_en.png', full_page=False)

        print('\n-- drill into Project 360 --')
        num = page.evaluate("() => ko.dataFor(document.body).pfItems[0].projectNumber")
        page.evaluate("(n) => ko.dataFor(document.body).openProj360(n)", num)
        page.wait_for_function("() => ko.dataFor(document.body).view() === 'proj360'", timeout=30000)
        check('#pg-proj360 visible', page.is_visible('#pg-proj360'))
        check('#pg-portfolio hidden', not page.is_visible('#pg-portfolio'))
        subs2 = page.eval_on_selector_all('.pnav--sub a', 'els => els.map(e => e.textContent.trim())')
        check('Project 360 tab appears while open', any('360' in s for s in subs2), subs2)
        page.wait_for_function(
            "() => { const v = ko.dataFor(document.body); return v.p3Data() !== null; }", timeout=240000)
        check('360 loaded the right project',
              page.evaluate("() => ko.dataFor(document.body).p3Num()") == num, num)
        check('identity card populated', page.locator('#pg-proj360 .p3-m').count() >= 10)
        card = page.evaluate("() => JSON.stringify(ko.dataFor(document.body).p3Card())")
        check('identity card has no literal undefined', 'undefined' not in card)
        check('funnel has 6 stages', page.locator('#pg-proj360 .fn-bar').count() == 6,
              page.locator('#pg-proj360 .fn-bar').count())
        check('funnel has 5 connectors', page.locator('#pg-proj360 .fn-band').count() == 5)
        check('health components shown', page.locator('#pg-proj360 .p3-comp').count() == 4)

        print('\n-- honesty markers --')
        check('DATA GAP badge present', page.locator('#pg-proj360 .dgap').count() > 0)
        gap = page.locator('#pg-proj360 .bu-alert--gap').first.inner_text().lower()
        check('gap explains receipts', 'receipt' in gap, gap[:70])
        sched = page.inner_text('#pg-proj360 .bu-sec-sum >> nth=0').lower() if page.locator(
            '#pg-proj360 .bu-sec-sum').count() else ''
        note = page.evaluate("() => ko.dataFor(document.body).t('p3SchedNote')").lower()
        check('schedule note states actual dates are empty', 'actual' in note and 'empty' in note)
        disc = page.evaluate("() => (ko.dataFor(document.body).p3H()||{}).disclaimer || ''")
        check('health disclaimer present', 'advisory' in disc.lower(), disc[:60])
        page.screenshot(path=EV + '/02_proj360_en.png', full_page=False)

        print('\n-- funnel stage drill --')
        page.evaluate("() => { const v = ko.dataFor(document.body);"
                      " const s = v.p3Funnel().stages.find(x => x.metric === 'ap');"
                      " if (s) v.p3StageDrill(s); }")
        page.wait_for_timeout(2500)
        check('drill drawer opened', page.evaluate("() => ko.dataFor(document.body).drillDrawer()"))
        page.keyboard.press('Escape')
        page.evaluate("() => ko.dataFor(document.body).closeDrawer()")

        print('\n-- back to portfolio --')
        page.evaluate("() => ko.dataFor(document.body).backToPortfolio()")
        page.wait_for_function("() => ko.dataFor(document.body).view() === 'portfolio'", timeout=30000)
        check('returned to portfolio', page.is_visible('#pg-portfolio'))

        print('\n-- Arabic / RTL --')
        page.click('button[data-bind*="toggleLang"]')
        page.wait_for_timeout(1200)
        check('dir is rtl', page.evaluate("() => document.documentElement.dir") == 'rtl')
        ar = page.evaluate("() => ko.dataFor(document.body).t('pfTitle')")
        check('portfolio title translated', ar and ar != 'pfTitle' and 'محفظة' in ar, ar)
        check('register still rendered in AR',
              page.locator('#pg-portfolio .ir-table thead th').count() >= 12)
        page.screenshot(path=EV + '/03_portfolio_ar.png', full_page=False)
        # restore EN so the shared session is not left flipped
        page.click('button[data-bind*="toggleLang"]')
        page.wait_for_timeout(800)
        check('restored to EN', page.evaluate("() => document.documentElement.dir") == 'ltr')

        check('no JS errors', not errors, errors[:3])
        b.close()

    ok = sum(1 for _, c in results if c)
    print('\n%d passed, %d failed' % (ok, len(results) - ok))
    for n, c in results:
        if not c:
            print('  FAILED: ' + n)
    return 0 if ok == len(results) else 1


if __name__ == '__main__':
    sys.exit(main())
