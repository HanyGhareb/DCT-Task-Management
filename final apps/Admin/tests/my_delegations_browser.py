"""
my_delegations_browser.py -- self-service vacation rule acceptance.

Logs in as a NON-ADMIN manager and proves:
  - "My Delegations" appears in the Workspace nav (System group stays hidden),
  - the page opens with the outgoing/incoming split,
  - a delegation (the vacation rule) is created end-to-end from the drawer
    (delegate + window + reason) and lists ACTIVE,
  - the delegate sees it under "Delegated to me" in their own session,
  - the delegator cancels it and it shows CANCELLED,
  - AR/RTL renders.

Self-cleaning: cancels + deletes the delegation it created via SQLcl
(matched on the reason tag).
"""
import os, re, subprocess, sys, tempfile, time
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8098
TAG = 'browser-smoke-mydel'
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def quick_logins():
    src = open(os.path.join(JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)


def click_js(pg, locator):
    locator.first.evaluate('el => el.click()')


def cleanup():
    script = f"""SET DEFINE OFF
BEGIN
    DELETE FROM prod.dct_delegations WHERE reason LIKE '%{TAG}%';
    COMMIT;
END;
/
EXIT
"""
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, script.encode()); os.close(fd)
    subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)


def login(pg, user, pwd):
    pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
    pg.fill('input[type="text"]', user)
    pg.fill('input[type="password"]', pwd)
    pg.click('.btn-primary')
    pg.wait_for_function('() => !!window._jetApp', timeout=30000)
    pg.wait_for_timeout(1500)


print('=== My Delegations (self-service vacation rule) -- browser acceptance ===\n')
cleanup()
proxy = subprocess.Popen([sys.executable, 'dev-proxy.py', str(PORT)], cwd=JET,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(3)
try:
    logins = dict(quick_logins())
    mgr = 'NASER.ALKHAJA'          # non-admin manager = the vacationing user
    delegate_name_hint = 'Ayesha'  # AYESHA.AMERI = the colleague covering
    with sync_playwright() as p:
        b = p.chromium.launch(args=['--no-sandbox', '--disable-dev-shm-usage'])
        pg = b.new_page(viewport={'width': 1500, 'height': 980})
        errors = []
        pg.on('pageerror', lambda e: errors.append(str(e)))
        pg.on('dialog', lambda d: d.accept())

        # ---- non-admin sees the page; System group hidden ----
        login(pg, mgr, logins[mgr])
        ok(f'logged in as non-admin {mgr}')
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1200)
        nav = pg.locator('.side-nav, nav, aside').first.inner_text()
        ok('"My Delegations" visible in Workspace nav') if 'My Delegations' in nav \
            else bad('nav entry missing: ' + nav[:200])
        ok('System group hidden for non-admin') if 'Role Assignments' not in nav \
            else bad('non-admin sees System group')

        pg.evaluate("() => window._jetApp.navigate('myDelegations')")
        pg.wait_for_selector('.page-title', timeout=20000)
        ok('My Delegations page opened')

        # ---- create the vacation rule from the drawer ----
        click_js(pg, pg.locator('.page-actions button', has_text='New Delegation'))
        pg.wait_for_selector('.ed-drawer.ed-show', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        # delegate: pick Ayesha by visible label
        dsel = drawer.locator('select').first
        val = None
        for o in dsel.locator('option').all():
            if delegate_name_hint in (o.inner_text() or ''):
                val = o.get_attribute('value'); break
        if not val:
            val = dsel.locator('option').nth(1).get_attribute('value')
        dsel.select_option(val)
        drawer.locator('input[type="date"]').nth(1).fill('2026-12-31')   # until
        drawer.locator('input[type="text"]').last.fill(TAG)
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2500)
        ok('delegation created (drawer closed)') if not pg.locator('.ed-drawer.ed-show').count() \
            else bad('drawer still open: ' + (pg.locator('.alert-banner--danger').inner_text()
                                              if pg.locator('.alert-banner--danger').count() else '?'))
        row = pg.locator('tbody tr', has_text=TAG)
        ok('listed ACTIVE under "My delegations"') \
            if row.count() and 'ACTIVE' in row.first.inner_text() else bad('row missing/not active')

        # ---- the delegate sees it incoming ----
        pg.evaluate("() => { localStorage.removeItem('ifinance_jet_session'); }")
        login(pg, 'AYESHA.AMERI', logins['AYESHA.AMERI'])
        pg.evaluate("() => window._jetApp.navigate('myDelegations')")
        pg.wait_for_selector('.page-title', timeout=20000)
        pg.wait_for_timeout(1500)
        body = pg.locator('.page-wrap').inner_text()
        ok('delegate sees it under "Delegated to me"') \
            if 'Delegated to me' in body and 'Naser' in body else bad('incoming section missing')

        # ---- delegator cancels ----
        pg.evaluate("() => { localStorage.removeItem('ifinance_jet_session'); }")
        login(pg, mgr, logins[mgr])
        pg.evaluate("() => window._jetApp.navigate('myDelegations')")
        pg.wait_for_selector('tbody tr', timeout=20000)
        row = pg.locator('tbody tr', has_text=TAG).first
        click_js(pg, row.locator('button', has_text='Cancel'))
        pg.wait_for_timeout(2500)
        row = pg.locator('tbody tr', has_text=TAG).first
        ok('cancelled -> status CANCELLED') if 'CANCELLED' in row.inner_text() \
            else bad('still ' + row.inner_text()[:80])

        # ---- AR / RTL ----
        pg.locator('.lang-pill button').nth(1).click()
        pg.wait_for_timeout(2000)
        dirv = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        ar_txt = pg.locator('.page-wrap').inner_text()
        ok('AR/RTL renders') if dirv == 'rtl' and 'تفويضات' in ar_txt else bad(f'dir={dirv}')
        pg.locator('.lang-pill button').nth(0).click()   # ALWAYS restore EN
        pg.wait_for_timeout(1500)
        ok('language restored to EN')

        js_errors = [e for e in errors if 'ResizeObserver' not in e]
        ok('no JS page errors') if not js_errors else bad(f'JS errors: {js_errors[:2]}')
        b.close()
finally:
    proxy.terminate()
    cleanup()

print(f'\n=== {PASS} passed, {FAIL} failed ===')
sys.exit(1 if FAIL else 0)
