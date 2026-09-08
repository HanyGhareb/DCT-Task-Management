"""GL Budget Status deep-link smoke — local dev-proxy or PROD.

Run: python3 dev-proxy.py 8124 (GL/Jet) then BASE=http://localhost:8124 python3 deeplink_browser_smoke.py
or   BASE=https://129.151.159.189 python3 deeplink_browser_smoke.py (PROD, adds the short-URL check)
Checks: hash routing (+alias), F5 restore, unknown-hash fallback,
login round-trip (?return=), and on PROD the /budget-status short URL.
"""
import os, json
from playwright.sync_api import sync_playwright

BASE = os.environ.get('BASE', 'http://localhost:8124')
PROD = BASE.startswith('https')
LOGIN = '/dct/index.html'
results = []

def check(name, ok):
    results.append([name, bool(ok)])
    print(('PASS ' if ok else 'FAIL ') + name, flush=True)

with sync_playwright() as pw:
    browser = pw.chromium.launch(headless=True)
    ctx = browser.new_context(ignore_https_errors=True, viewport=dict(width=1440, height=1000))
    page = ctx.new_page()

    # ── 1. no session + deep link → login bounce carries ?return= ──
    page.goto(BASE + '/GL/Jet/index.html#budget-status')
    page.wait_for_url('**' + LOGIN + '*', timeout=30000)
    check('session-less deep link bounces to login', LOGIN in page.url)
    check('?return= carries path + #budget-status',
          'return=%2FGL%2FJet%2Findex.html%23budget-status' in page.url)

    # ── 2. login → lands straight on Budget Status ──
    page.wait_for_selector('.quick-btn', timeout=60000)
    page.locator('.quick-btn').filter(has_text='System Admin').click(timeout=60000)
    page.wait_for_url('**/GL/Jet/index.html*', timeout=60000)
    page.wait_for_function("window.ko && !!ko.dataFor(document.body)", timeout=60000)
    page.wait_for_function("ko.dataFor(document.body).ready()", timeout=60000)
    vm_view = page.evaluate("ko.dataFor(document.body).view()")
    check('after login lands on Budget Status (view=fd)', vm_view == 'fd')
    check('address bar shows #budget-status', page.url.endswith('#budget-status'))
    page.wait_for_selector('#pg-fd', state='attached', timeout=30000)
    check('#pg-fd page is the visible one',
          page.locator('#pg-fd').is_visible())

    # ── 3. raw id alias + F5 restore ──
    page.goto(BASE + '/GL/Jet/index.html#fd')
    page.wait_for_function("window.ko && ko.dataFor(document.body) && ko.dataFor(document.body).ready()", timeout=60000)
    check('raw #fd works too', page.evaluate("ko.dataFor(document.body).view()") == 'fd')
    page.evaluate("ko.dataFor(document.body).go('butil')")
    check('nav writes hash (#butil)', page.url.endswith('#butil'))
    page.reload()
    page.wait_for_function("window.ko && ko.dataFor(document.body) && ko.dataFor(document.body).ready()", timeout=60000)
    check('F5 restores the tab', page.evaluate("ko.dataFor(document.body).view()") == 'butil')

    # ── 4. unknown hash falls back to the default page ──
    page.goto(BASE + '/GL/Jet/index.html#garbage-tab')
    page.wait_for_function("window.ko && ko.dataFor(document.body) && ko.dataFor(document.body).ready()", timeout=60000)
    check('unknown hash falls back to butil', page.evaluate("ko.dataFor(document.body).view()") == 'butil')

    # ── 5. logged-in Admin ignores a bad ?return= (open-redirect guard) ──
    fresh = browser.new_context(ignore_https_errors=True)
    fp = fresh.new_page()
    fp.goto(BASE + LOGIN + '?return=//evil.example/x')
    fp.wait_for_selector('.quick-btn', timeout=60000)
    fp.locator('.quick-btn').filter(has_text='System Admin').click(timeout=60000)
    fp.wait_for_function('!!localStorage.getItem("ifinance_jet_session")', timeout=60000)
    fp.wait_for_timeout(2500)
    # the inert query param may remain in the URL; what matters is that the
    # page never NAVIGATED to it — origin unchanged, still inside the app
    from urllib.parse import urlparse
    check('malicious ?return=//host is ignored',
          urlparse(fp.url).netloc == urlparse(BASE).netloc and '/dct' in urlparse(fp.url).path)
    fresh.close()

    # ── 6. PROD short URL ──
    if PROD:
        r = ctx.request.get(BASE + '/budget-status', max_redirects=0)
        loc = r.headers.get('location', '')
        check('/budget-status 302 -> GL#budget-status',
              r.status == 302 and loc.endswith('/GL/Jet/index.html#budget-status'))

    browser.close()

print(json.dumps(results))
raise SystemExit(0 if all(ok for _, ok in results) else 1)
