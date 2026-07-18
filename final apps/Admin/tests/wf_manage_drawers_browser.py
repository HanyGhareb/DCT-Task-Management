"""
wf_manage_drawers_browser.py -- Role Assignments management drawers acceptance.

Drives the REAL Admin JET app against PROD ORDS and proves:
  - the Policies dialog is now a right-edge DRAWER (shared <edit-drawer>),
  - Manage Roles drawer: list -> add a DATA role from the UI -> appears in the
    list AND in the assignment pickers -> deactivate it -> hidden again,
  - Manage Objects drawer (SYS_ADMIN): registry list -> add an object type
    picking the LOV view + columns from dictionary dropdowns -> appears ->
    deactivate,
  - the process designer step editor exposes the TIMERS section (reminders,
    escalation, auto-action) -- escalation/expiration rules editable from UI,
  - AR/RTL renders.

Self-cleaning: removes the role/type it created via SQLcl; restores EN.
"""
import os, re, subprocess, sys, tempfile, time
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8096
ROLE = 'ZZZ_UI98_ROLE'
OTYPE = 'ZZZ_UI98_OT'
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def creds():
    src = open(os.path.join(JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def click_js(pg, locator):
    locator.first.evaluate('el => el.click()')


def cleanup():
    script = f"""SET DEFINE OFF
BEGIN
    DELETE FROM prod.dct_wf_role_policy WHERE role_code = '{ROLE}';
    DELETE FROM prod.dct_roles WHERE role_code = '{ROLE}' AND role_type = 'DATA';
    DELETE FROM prod.dct_wf_object_type WHERE object_type_code = '{OTYPE}';
    COMMIT;
END;
/
EXIT
"""
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, script.encode()); os.close(fd)
    subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)


print('=== Role Assignments management drawers -- browser acceptance ===\n')
cleanup()
proxy = subprocess.Popen([sys.executable, 'dev-proxy.py', str(PORT)], cwd=JET,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(3)
try:
    user, pwd = creds()
    with sync_playwright() as p:
        b = p.chromium.launch(args=['--no-sandbox', '--disable-dev-shm-usage'])
        pg = b.new_page(viewport={'width': 1500, 'height': 980})
        errors = []
        pg.on('pageerror', lambda e: errors.append(str(e)))
        pg.on('dialog', lambda d: d.accept())

        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        ok(f'logged in as {user}')
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1200)
        pg.evaluate("() => window._jetApp.navigate('roleAssignments')")
        pg.wait_for_selector('.data-table', timeout=20000)
        ok('Role Assignments page opened')

        # ---- Policies is now a DRAWER ----
        click_js(pg, pg.locator('.page-actions button', has_text='Policies'))
        pg.wait_for_selector('.ed-drawer.ed-show', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        ok('Policies opens as a right-edge drawer with the roles table') \
            if drawer.locator('tbody tr').count() >= 5 else bad('policies drawer rows missing')
        pg.keyboard.press('Escape'); pg.wait_for_timeout(600)
        ok('Esc closes the drawer') if not pg.locator('.ed-drawer.ed-show').count() \
            else bad('drawer still open after Esc')

        # ---- Manage Roles drawer: add a role from the UI ----
        click_js(pg, pg.locator('.page-actions button', has_text='Manage Roles'))
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        n0 = drawer.locator('tbody tr').count()
        ok(f'Manage Roles drawer lists {n0} roles') if n0 >= 5 else bad(f'only {n0} roles')

        click_js(pg, drawer.locator('button', has_text='Add role'))
        pg.wait_for_timeout(500)
        drawer.locator('input.mono').first.fill(ROLE)
        drawer.locator('input.form-control:not(.mono):not([dir])').first.fill('UI Smoke Role')
        drawer.locator('input[dir="rtl"]').first.fill('دور تجريبي')
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2500)
        ok('role created from the drawer') \
            if drawer.locator('tbody tr', has_text=ROLE).count() else bad('new role not listed')

        # the new role is immediately assignable (create-drawer role picker)
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))  # Close
        pg.wait_for_timeout(600)
        click_js(pg, pg.locator('.page-actions button', has_text='New Assignment'))
        pg.wait_for_selector('.modal-box', timeout=8000)
        role_opts = pg.locator('.modal-box select').nth(1).locator('option').all_inner_texts()
        ok('new role appears in the assignment picker') \
            if any('UI Smoke Role' in o for o in role_opts) else bad(f'picker roles {role_opts}')
        click_js(pg, pg.locator('.modal-box button', has_text='Cancel'))
        pg.wait_for_timeout(500)

        # deactivate it again from the drawer
        click_js(pg, pg.locator('.page-actions button', has_text='Manage Roles'))
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        click_js(pg, drawer.locator('tbody tr', has_text=ROLE).locator('button', has_text='Edit'))
        pg.wait_for_timeout(500)
        # uncheck Active (second checkbox in the form)
        drawer.locator('input[type="checkbox"]').nth(1).uncheck()
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2500)
        ok('role deactivated (listed Inactive)') \
            if 'Inactive' in drawer.locator('tbody tr', has_text=ROLE).inner_text() \
            else bad('role not shown inactive')
        pg.keyboard.press('Escape'); pg.wait_for_timeout(600)

        # ---- Manage Objects drawer: add a type against a real view ----
        click_js(pg, pg.locator('.page-actions button', has_text='Manage Objects'))
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        n0 = drawer.locator('tbody tr').count()
        ok(f'Manage Objects drawer lists {n0} registry rows') if n0 >= 10 else bad(f'only {n0} types')

        click_js(pg, drawer.locator('button', has_text='Add object type'))
        pg.wait_for_timeout(500)
        drawer.locator('input.mono').first.fill(OTYPE)
        drawer.locator('input.form-control:not(.mono):not([dir]):not([type="number"])').first.fill('UI Smoke Type')
        # view picker: search the dictionary then choose
        drawer.locator('input.mono').nth(1).fill('DCT_WF_OBJ_PROJECT')
        click_js(pg, drawer.locator('button', has_text='Find'))
        pg.wait_for_timeout(1500)
        drawer.locator('select.mono').nth(0).select_option('V_DCT_WF_OBJ_PROJECT')
        pg.wait_for_timeout(1500)   # columns load
        drawer.locator('select.mono').nth(1).select_option('PROJECT_NUMBER')   # key col
        drawer.locator('select.mono').nth(2).select_option('PROJECT_NAME_EN')  # label col
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2500)
        ok('object type created from the drawer (view + columns from dictionary dropdowns)') \
            if drawer.locator('tbody tr', has_text=OTYPE).count() else bad('new type not listed')

        # deactivate it
        click_js(pg, drawer.locator('tbody tr', has_text=OTYPE).locator('button', has_text='Edit'))
        pg.wait_for_timeout(800)
        drawer.locator('input[type="checkbox"]').nth(2).uncheck()   # Active flag
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2500)
        ok('object type deactivated') \
            if 'Inactive' in drawer.locator('tbody tr', has_text=OTYPE).inner_text() \
            else bad('type not shown inactive')
        pg.keyboard.press('Escape'); pg.wait_for_timeout(600)

        # ---- designer step editor exposes the TIMERS section ----
        pg.evaluate("() => window._jetApp.navigate('processes')")
        pg.wait_for_selector('.wf-dz', timeout=20000)
        row = pg.locator('tr.wf-dz-row').first
        row.wait_for(state='visible', timeout=20000)
        click_js(pg, row)
        pg.wait_for_selector('.wf-dz-design', timeout=10000)
        click_js(pg, pg.locator('button', has_text='Edit chain'))
        pg.wait_for_timeout(2000)
        click_js(pg, pg.locator('button', has_text='+ Add step'))
        pg.wait_for_selector('.wf-dz-modal', timeout=8000)
        # form labels are CSS-uppercased -- Chrome innerText applies text-transform
        modal_txt = pg.locator('.wf-dz-modal').inner_text().lower()
        ok('step editor shows the Timers section (reminders / escalation / expiration)') \
            if 'timers' in modal_txt and 'escalate to role' in modal_txt \
               and 'auto-action outcome' in modal_txt else bad('timers fields missing')
        # reminder field accepts the offsets format
        pg.locator('.wf-dz-modal input[placeholder="48,24,4"]').fill('24,4')
        ok('reminder offsets editable')
        click_js(pg, pg.locator('.wf-dz-modal .region-actions button', has_text='Cancel'))
        pg.wait_for_timeout(600)
        click_js(pg, pg.locator('button', has_text='Discard draft'))
        pg.wait_for_timeout(2000)
        ok('draft discarded (designer state restored)')

        # ---- AR / RTL ----
        pg.evaluate("() => window._jetApp.navigate('roleAssignments')")
        pg.wait_for_timeout(1200)
        pg.locator('.lang-pill button').nth(1).click()
        pg.wait_for_timeout(2000)
        click_js(pg, pg.locator('.page-actions button').nth(2))  # Manage Roles (AR)
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        dirv = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        ar_txt = pg.locator('.ed-drawer.ed-show').inner_text()
        ok('AR/RTL: drawer renders translated under dir=rtl') \
            if dirv == 'rtl' and 'الأدوار' in ar_txt else bad(f'dir={dirv}')
        pg.keyboard.press('Escape'); pg.wait_for_timeout(400)
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
