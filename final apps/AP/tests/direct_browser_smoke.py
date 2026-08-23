# Direct AP dashboard (App 212) browser smoke — Playwright over dev-proxy.
# Start the proxy first:  python3 "final apps/AP/Jet/dev-proxy.py" 8124
# Credentials parsed from the Admin quick logins (same as the UAT runners).
# Optional: DIRECT_BOOK=1 runs the Briefing Book end-to-end (needs a live
# reporting worker; adds ~1-2 minutes).
import json, os, re, sys, urllib.request
from playwright.sync_api import sync_playwright

PORT = os.environ.get('DIRECT_PORT', '8124')
BASE = 'http://localhost:' + PORT
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
EV = os.environ.get('DIRECT_EVIDENCE', '/tmp/direct_evidence') + '/'
os.makedirs(EV, exist_ok=True)

src = open(os.path.join(ROOT, 'Admin', 'Jet', 'js', 'services', 'authService.js'), encoding='utf-8').read()
USER, PASS = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]
req = urllib.request.Request(ADB + '/dct/auth/login',
    data=json.dumps({'username': USER, 'password': PASS}).encode(),
    headers={'Content-Type': 'application/json'})
sess = json.loads(urllib.request.urlopen(req, timeout=60).read())
sess['roles'] = (sess.get('rolesCsv') or '').split(',')

results = []
def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)

with sync_playwright() as p:
    b = p.chromium.launch(headless=True)
    ctx = b.new_context(viewport={'width': 1600, 'height': 1000})
    page = ctx.new_page()
    errors = []
    page.on('pageerror', lambda e: errors.append(str(e)))

    # first load redirects to /Admin/Jet/ (no session yet) — same origin, so
    # localStorage set there is visible to the AP app on the re-load
    try:
        page.goto(BASE + '/index.html')
    except Exception:
        pass
    page.wait_for_timeout(1500)
    page.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", sess)
    page.goto(BASE + '/index.html')
    page.wait_for_load_state('networkidle')
    page.wait_for_timeout(1500)

    # 1 nav shows the new entry, between AP Dashboard and Beneficiaries
    check('Direct AP nav entry', page.locator('.nav-item', has_text='Direct AP').count() == 1)

    # 2 open the Direct AP dashboard — the scoped /filters call runs ~15s cold,
    # and the KPIs/register only load after it, so wait on selectors not time
    page.locator('.nav-item', has_text='Direct AP').click()
    page.wait_for_selector('.page-title:has-text("Direct AP")', timeout=30000)
    check('Direct AP title', 'Direct AP Dashboard' in page.locator('.page-title').inner_text())
    page.wait_for_selector('.kpi', timeout=120000)
    page.wait_for_timeout(1000)
    check('KPI tiles render', page.locator('.kpi').count() == 7,
          str(page.locator('.kpi').count()))

    # 3 Briefing Book button present; AI dup button (benef-only) absent
    check('Briefing Book button', page.locator('.page-actions button',
          has_text='Briefing Book').count() == 1)
    check('no AI dup button', page.locator('.page-actions .ai-btn').count() == 0)

    # 4 refs inputs (PO/PR/Task) hidden; project facet group absent
    refs = page.locator('.ap-facets input[data-bind*="value: po"]').count()
    check('PO/PR/Task ref inputs hidden', refs == 0, str(refs))
    heads = [t.strip() for t in page.locator('.fct-head').all_inner_texts()]
    check('no Project facet group', not any(h.lower().startswith('project') for h in heads),
          '|'.join(heads[:14]))
    check('GL coding facets stay', any('cost cent' in h.lower() for h in heads))
    check('Chapter facet group present', any(h.lower().startswith('chapter') for h in heads))

    # 5 register rows render and the PO Numbers column is hidden by default
    page.wait_for_selector('.data-table tbody tr', timeout=120000)
    rows = page.locator('.ap-register tbody tr, .data-table tbody tr').count()
    check('register rows render', rows > 0, str(rows))
    ths = [t.strip().lower() for t in page.locator('thead th').all_inner_texts()]
    check('PO Numbers column hidden by default',
          not any(t == 'po numbers' for t in ths))
    page.screenshot(path=EV + 'direct_dashboard_en.png', full_page=True)

    # 6 optional: run the Briefing Book end-to-end
    if os.environ.get('DIRECT_BOOK') == '1':
        with page.expect_download(timeout=240000) as dl:
            page.locator('.page-actions button', has_text='Briefing Book').click()
        f = dl.value
        check('Briefing Book downloads', f.suggested_filename.endswith('.xlsx'),
              f.suggested_filename)

    # 7 Arabic / RTL — the shared shell persists the language to the user's
    # server-side prefs, so ALWAYS restore EN or the account flips to Arabic
    page.locator('.lang-pill button').nth(1).click()
    page.wait_for_timeout(3000)
    check('RTL applied', page.evaluate("document.documentElement.dir") == 'rtl')
    check('AR title', len(page.locator('.page-title').inner_text().strip()) > 0)
    page.screenshot(path=EV + 'direct_dashboard_ar.png', full_page=True)
    page.locator('.lang-pill button').nth(0).click()
    page.wait_for_timeout(2000)
    check('EN restored', page.evaluate("document.documentElement.dir") == 'ltr')

    hard = [e for e in errors if 'favicon' not in e]
    check('no page errors', not hard, '; '.join(hard[:3]))
    b.close()

fails = [n for n, okk in results if not okk]
print('\n%d/%d PASS' % (len(results) - len(fails), len(results)))
sys.exit(1 if fails else 0)
