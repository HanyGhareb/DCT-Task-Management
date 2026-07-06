"""Admin JET SSO frontend E2E: boot hook + injected APEX button (gate-aware)."""
import sys, os, re, json, urllib.request
from playwright.sync_api import sync_playwright

sys.stdout.reconfigure(encoding='utf-8')

BASE = r'c:\claude\DCT-task-management\DCT-Task-Management\final apps'
src = open(os.path.join(BASE, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)
cfg = open(os.path.join(BASE, 'FL', 'Jet', 'js', 'services', 'config.js'), encoding='utf-8').read()
ADB = re.search(r"https://[\w.-]+oraclecloudapps\.com", cfg).group(0) + '/ords/admin/dct'

def api(method, path, body=None, token=None):
    req = urllib.request.Request(ADB + path, method=method,
                                 data=json.dumps(body).encode() if body is not None else None,
                                 headers={'Content-Type': 'application/json'} if body is not None else {})
    if token: req.add_header('Authorization', 'Bearer ' + token)
    resp = urllib.request.urlopen(req, timeout=40)
    return json.loads(resp.read().decode('utf-8', 'replace') or '{}')

auth = api('POST', '/auth/login', {'username': USER, 'password': PWD})
T = auth['sessionId']
def set_gate(v): api('PUT', '/settings/FEATURE_SSO_HANDOFF', {'value': v}, token=T)

ok = []
def check(name, cond, extra=''):
    ok.append(bool(cond)); print(('PASS' if cond else 'FAIL'), name, extra)

page_errors = []
console_errors = []

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    ctx = browser.new_context()
    page = ctx.new_page()
    page.on('pageerror', lambda e: page_errors.append(str(e)))
    page.on('console', lambda msg: console_errors.append(msg.text) if msg.type == 'error' else None)

    try:
        # ── Phase A: gate N — login works, NO APEX button ────────────────
        set_gate('N')
        page.goto('http://localhost:8080/index.html', wait_until='networkidle')
        page.wait_for_selector('text=System Admin', timeout=20000)
        page.locator('text=System Admin').first.click()
        page.wait_for_function("location.hash === '#dashboard'", timeout=30000)
        page.wait_for_timeout(3000)   # _bootstrap /boot round-trip
        check('quick login reaches dashboard', '#dashboard' in page.url)
        check('gate N: no APEX button', page.locator('#ifSsoApexBtn').count() == 0)

        # ── Phase B: gate Y — button appears, click opens APEX URL ──────
        set_gate('Y')
        page.reload(wait_until='networkidle')
        try:
            page.wait_for_selector('#ifSsoApexBtn', timeout=15000)
        except Exception:
            pass
        btn = page.locator('#ifSsoApexBtn')
        check('gate Y: APEX button injected', btn.count() == 1)
        if btn.count():
            with ctx.expect_page(timeout=20000) as popup_info:
                btn.click()
            popup = popup_info.value
            popup.wait_for_timeout(5000)
            check('click opens APEX URL with a code',
                  'P9999_SSO_CODE' in popup.url and re.search(r'P9999_SSO_CODE:[0-9A-F]{64}', popup.url) is not None,
                  popup.url[:110])
            popup.close()

        # ── Phase C: garbage #sso lands safely on login (gate back N) ───
        set_gate('N')
        page.evaluate("localStorage.removeItem('ifinance_jet_session')")
        page.goto('http://localhost:8080/index.html#sso=garbagecode123', wait_until='networkidle')
        page.wait_for_timeout(4000)
        on_login = page.locator('input[type=password]').count() > 0
        check('garbage #sso= lands on login view', on_login)
        check('code scrubbed from URL', '#sso=' not in page.url, page.url)
    finally:
        set_gate('N')
        browser.close()

fatal = [e for e in page_errors]
check('no uncaught page errors', not fatal, '; '.join(fatal[:3]))
noise = [e for e in console_errors if '401' not in e and 'Failed to load resource' not in e]
print('console error-level messages (info):', len(console_errors), 'non-40x:', len(noise))
for e in noise[:5]: print('  console:', e[:160])

print('----------------------------------------')
print('PASS=%d FAIL=%d (gate left at N)' % (sum(ok), len(ok) - sum(ok)))
sys.exit(0 if all(ok) else 1)
