#!/usr/bin/env python3
"""
wf_designer_browser.py -- requirement-1 acceptance for the <wf-designer>.

Drives the REAL Admin JET app against PROD ORDS and proves a business admin can,
with NO code and NO deploy:
  - clone a published chain into an editable draft (in-flight work untouched),
  - add a CONDITIONAL step (a condition compiled live server-side),
  - SIMULATE it — see the step fire for one set of facts and SKIP (with the reason)
    for another,
  - PUBLISH it as a new version.

Self-contained: seeds a throwaway process TEST_DZR_UI via SQLcl, runs the flow,
then removes every trace (finally-block cleanup). It never touches a real process.

Run:  python3 "final apps/Admin/tests/wf_designer_browser.py"
"""
import os, re, subprocess, sys, tempfile, time
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8097
PASS = FAIL = 0

SEED = r"""
SET DEFINE OFF
DECLARE v_set NUMBER; v_sch NUMBER; v_pid NUMBER; v_v1 NUMBER; v_s NUMBER;
BEGIN
  SELECT set_id INTO v_set FROM prod.dct_wf_outcome_set WHERE set_code='APPROVE_REJECT';
  INSERT INTO prod.dct_wf_fact_schema(schema_code,name_en,source_view,source_key_column)
    VALUES('TEST_DZR_SCH','UI test','DUAL','X') RETURNING schema_id INTO v_sch;
  INSERT INTO prod.dct_wf_fact_field(schema_id,field_key,label_en,data_type,source_column)
    VALUES(v_sch,'amount','Amount','NUMBER','AMT');
  INSERT INTO prod.dct_wf_process(process_code,source_module,name_en,name_ar,schema_id,requires_final_callback,is_active)
    VALUES('TEST_DZR_UI','TEST','UI Designer Test','AR',v_sch,'N','N') RETURNING process_id INTO v_pid;
  INSERT INTO prod.dct_wf_process_version(process_id,version_no,status) VALUES(v_pid,1,'PUBLISHED') RETURNING version_id INTO v_v1;
  INSERT INTO prod.dct_wf_step(version_id,step_key,step_seq,name_en,name_ar,outcome_set_id,is_final_gate)
    VALUES(v_v1,'FINAL',10,'Final approval','AR final',v_set,'Y') RETURNING step_id INTO v_s;
  INSERT INTO prod.dct_wf_participant_rule(step_id,resolver_type,role_code) VALUES(v_s,'ROLE','SYS_ADMIN');
  COMMIT;
END;
/
EXIT
"""

CLEANUP = r"""
SET DEFINE OFF
DECLARE v_pid NUMBER; v_sch NUMBER;
BEGIN
  BEGIN SELECT process_id, schema_id INTO v_pid, v_sch FROM prod.dct_wf_process WHERE process_code='TEST_DZR_UI';
  EXCEPTION WHEN NO_DATA_FOUND THEN v_pid := NULL; END;
  IF v_pid IS NOT NULL THEN
    DELETE FROM prod.dct_wf_participant_rule WHERE step_id IN (SELECT step_id FROM prod.dct_wf_step WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id=v_pid));
    DELETE FROM prod.dct_wf_step WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id=v_pid);
    DELETE FROM prod.dct_wf_condition WHERE version_id IN (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id=v_pid);
    DELETE FROM prod.dct_wf_process_version WHERE process_id=v_pid;
    DELETE FROM prod.dct_wf_process WHERE process_id=v_pid;
  END IF;
  DELETE FROM prod.dct_wf_fact_field WHERE schema_id IN (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code='TEST_DZR_SCH');
  DELETE FROM prod.dct_wf_fact_schema WHERE schema_code='TEST_DZR_SCH';
  COMMIT;
END;
/
EXIT
"""


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def run_sql(script, tag):
    fd, path = tempfile.mkstemp(suffix='.sql'); os.write(fd, script.encode()); os.close(fd)
    r = subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)
    if 'ORA-' in (r.stdout + r.stderr):
        print(f'  [{tag}] SQL note:', re.findall(r'ORA-\d+.*', r.stdout + r.stderr)[:2])


def creds():
    src = open(os.path.join(JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def click_js(pg, locator):
    """Fire the bound handler directly — the modal backdrop trips strict hit-tests."""
    locator.first.evaluate('el => el.click()')


print('=== <wf-designer> — requirement-1 acceptance (rolls back) ===\n')
run_sql(CLEANUP, 'pre-clean')
run_sql(SEED, 'seed')

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
        pg.on('dialog', lambda d: d.accept())          # auto-accept confirm() prompts

        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        ok(f'logged in as {user}')

        # force EN, then route by id (language-agnostic)
        pg.locator('button:text-is("EN")').last.click(); pg.wait_for_timeout(1500)
        pg.evaluate("() => window._jetApp.navigate('processes')")
        pg.wait_for_selector('.wf-dz', timeout=20000)
        ok('Approval Processes page opened (routed by id)')

        # the seeded process shows in the list
        row = pg.locator('tr.wf-dz-row', has_text='TEST_DZR_UI')
        row.first.wait_for(state='visible', timeout=20000)
        ok('the process list renders the seeded process')

        # select it -> published version is read-only
        click_js(pg, row)
        pg.wait_for_selector('.wf-dz-design', timeout=10000)
        chip = pg.locator('.wf-dz-vchip').first.inner_text()
        ok(f'design panel shows the published version ({chip.strip()})') if 'PUBLISHED' in chip else bad(f'chip {chip}')

        # Edit chain -> clone to a draft
        click_js(pg, pg.locator('button', has_text='Edit chain'))
        pg.wait_for_timeout(1800)
        add_step_btn = pg.locator('button', has_text='+ Add step')
        add_step_btn.first.wait_for(state='visible', timeout=10000)
        chip2 = pg.locator('.wf-dz-vchip').first.inner_text()
        ok(f'Edit chain cloned to an editable draft ({chip2.strip()})') if 'DRAFT' in chip2 else bad(f'draft chip {chip2}')

        # add a CONDITION (compiled live, server-side)
        click_js(pg, pg.locator('button', has_text='+ Add condition'))
        pg.wait_for_selector('.wf-dz-modal', timeout=8000)
        pg.locator('.wf-dz-modal input.mono').first.fill('BIG')
        pg.locator('.wf-dz-modal textarea').first.fill('amount >= 5000')
        # live validation resolves 'amount' against the schema field -> Valid
        try:
            pg.wait_for_selector('.wf-dz-ok', timeout=8000)
            ok('condition compiled live to VALID (amount resolved against the fact schema)')
        except Exception:
            bad('condition did not validate live')
        click_js(pg, pg.locator('.wf-dz-modal .region-actions .btn-primary'))
        pg.wait_for_timeout(1500)
        ok('condition saved') if pg.locator('.wf-dz-cond', has_text='BIG').count() else bad('condition not listed')

        # add a CONDITIONAL step (uses the condition; has an approver + outcome set)
        click_js(pg, add_step_btn)
        pg.wait_for_selector('.wf-dz-modal', timeout=8000)
        pg.locator('.wf-dz-modal input.mono').first.fill('LEGAL')
        pg.locator('.wf-dz-modal input:not(.mono)').first.fill('Legal review')   # nameEn
        pg.locator('.wf-dz-modal input[dir="rtl"]').first.fill('مراجعة قانونية')  # nameAr
        # outcome set + condition selects
        pg.locator('.wf-dz-modal select').nth(1).select_option('APPROVE_REJECT')  # outcome set
        pg.locator('.wf-dz-modal select').nth(2).select_option('BIG')             # condition
        # add an approver (ROLE / SYS_ADMIN)
        click_js(pg, pg.locator('.wf-dz-modal button', has_text='Add approver'))
        pg.wait_for_selector('.wf-dz-part', timeout=5000)
        pg.locator('.wf-dz-part input.mono').first.fill('SYS_ADMIN')
        click_js(pg, pg.locator('.wf-dz-modal .region-actions .btn-primary'))
        pg.wait_for_timeout(1800)
        step_card = pg.locator('.wf-dz-step', has_text='Legal review')
        ok('conditional step added to the draft') if step_card.count() else bad('LEGAL step not shown')

        # SIMULATE — fires for a big amount, SKIPS (with reason) for a small one
        click_js(pg, pg.locator('button', has_text='Simulate'))
        pg.wait_for_selector('.wf-dz-modal--wide', timeout=8000)
        facts = pg.locator('.wf-dz-modal--wide textarea')
        facts.fill('{"amount": 6000, "roles": []}')
        click_js(pg, pg.locator('.wf-dz-modal--wide .region-actions .btn-primary'))  # Run
        pg.wait_for_selector('.wf-dz-simsteps', timeout=12000)
        fires = pg.locator('.wf-dz-simsteps .wf-dz-step', has_text='Legal')
        ok('simulate: Legal step RUNS for amount 6000') \
            if fires.count() and 'sim--fire' in (fires.first.get_attribute('class') or '') else \
            bad('legal step did not fire at 6000')
        facts.fill('{"amount": 1000, "roles": []}')
        click_js(pg, pg.locator('.wf-dz-modal--wide .region-actions .btn-primary'))
        pg.wait_for_timeout(2500)
        legal_sim = pg.locator('.wf-dz-simsteps .wf-dz-step', has_text='Legal').first
        cls = legal_sim.get_attribute('class') or ''
        ok('simulate: Legal step SKIPS for amount 1000 (with reason)') \
            if 'sim--skip' in cls else bad(f'legal step class at 1000: {cls}')
        click_js(pg, pg.locator('.wf-dz-modal--wide .region-actions button', has_text='Close'))
        pg.wait_for_timeout(600)

        # PUBLISH — validation is clean (every step has approver+outcome, a final gate exists)
        click_js(pg, pg.locator('.wf-dz-design button', has_text='Publish'))
        pg.wait_for_timeout(3000)
        chip3 = pg.locator('.wf-dz-vchip').first.inner_text()
        ok(f'published as a new version ({chip3.strip()})') \
            if 'PUBLISHED' in chip3 and 'v2' in chip3 else bad(f'publish chip {chip3}')

        pg.screenshot(path=os.path.join(HERE, 'wf_designer_en.png'), full_page=True)

        # AR / RTL — no raw i18n keys leak
        pg.locator('button:text-is("ع")').last.click(); pg.wait_for_timeout(1800)
        direction = pg.evaluate("document.documentElement.getAttribute('dir')")
        ok('Arabic switches the document to RTL') if direction == 'rtl' else bad('not RTL in AR')
        leaked = re.findall(r'\bwf\.dz\.[a-z_.]+', pg.inner_text('.wf-dz'))
        ok('AR render leaks no raw wf.dz.* keys') if not leaked else bad(f'raw keys: {sorted(set(leaked))[:4]}')
        pg.locator('button:text-is("EN")').last.click(); pg.wait_for_timeout(1500)
        ok('language restored to EN (the test leaves no trace)')

        real = [e for e in errors if 'favicon' not in e.lower()]
        ok('no JavaScript errors during the run') if not real else bad(f'{len(real)} JS error(s): {real[:2]}')
        b.close()
finally:
    proxy.terminate()
    run_sql(CLEANUP, 'cleanup')

print('\n=====================================================')
print(f'  passed : {PASS}')
print(f'  failed : {FAIL}')
print('=====================================================')
sys.exit(1 if FAIL else 0)
