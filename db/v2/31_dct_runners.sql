-- =============================================================================
-- i-Finance V2 -- Automation Runners Registry  (DCT_RUNNERS)
-- File    : 31_dct_runners.sql
-- Schema  : PROD table + ADMIN ORDS additions (module dct.admin)
-- Run as  : sql -name prod_mcp   (FRESH session -- do NOT follow an ALTER SESSION
--           SET CURRENT_SCHEMA=PROD run, or the synonym self-references ORA-01471)
-- Purpose : a single catalogue of every automation runner/script the team has
--           built (where it lives, what it does, how to run it, deps, schedule),
--           plus an OPTIONAL stored copy of the script (inline text + binary).
--           Surfaced as Admin -> System -> Automation Registry (CRUD + search).
-- Endpoints (module dct.admin):
--   GET    runners/            list (search/category/runtime/status + paging)
--   POST   runners/            create
--   GET    runners/[COLON]id        detail (incl. content text + file meta)
--   PUT    runners/[COLON]id        update
--   DELETE runners/[COLON]id        delete
--   PUT    runners/[COLON]id/file   raw-binary stored copy upload (MAX_UPLOAD_MB)
--   GET    runners/[COLON]id/file   stored copy download (media)
--   GET    runners/meta        distinct categories / runtimes / statuses
-- Idempotent: table guarded; seeds MERGE WHEN NOT MATCHED (never clobber edits);
--             handlers redefined on re-run.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RUNNERS table ===
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.dct_runners (
      runner_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      runner_code    VARCHAR2(60)  NOT NULL,
      name           VARCHAR2(200) NOT NULL,
      category       VARCHAR2(40),
      runtime        VARCHAR2(30),
      status         VARCHAR2(20)  DEFAULT 'ACTIVE' NOT NULL,
      host_location  VARCHAR2(200),
      file_path      VARCHAR2(500),
      repo_path      VARCHAR2(500),
      purpose        VARCHAR2(2000),
      usage_notes    CLOB,
      schedule_info  VARCHAR2(400),
      dependencies   VARCHAR2(1500),
      related_links  VARCHAR2(1000),
      owner          VARCHAR2(160),
      tags           VARCHAR2(400),
      notes          CLOB,
      content_text   CLOB,
      file_name      VARCHAR2(260),
      file_mime      VARCHAR2(120),
      file_blob      BLOB,
      created_by     VARCHAR2(100),
      created_at     TIMESTAMP DEFAULT SYSTIMESTAMP,
      updated_by     VARCHAR2(100),
      updated_at     TIMESTAMP DEFAULT SYSTIMESTAMP
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

BEGIN
  EXECUTE IMMEDIATE
    'CREATE UNIQUE INDEX prod.ux_dct_runners_code ON prod.dct_runners (UPPER(runner_code))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. ADMIN synonym ===
CREATE OR REPLACE SYNONYM dct_runners FOR prod.dct_runners;

PROMPT === 3. Seed -- the runners we know (MERGE; never clobbers later edits) ===
DECLARE
  PROCEDURE r(p_code VARCHAR2, p_name VARCHAR2, p_cat VARCHAR2, p_rt VARCHAR2,
              p_host VARCHAR2, p_path VARCHAR2, p_repo VARCHAR2, p_purpose VARCHAR2,
              p_usage VARCHAR2, p_sched VARCHAR2 DEFAULT NULL, p_deps VARCHAR2 DEFAULT NULL,
              p_links VARCHAR2 DEFAULT NULL, p_owner VARCHAR2 DEFAULT 'Hany Ghareb',
              p_tags VARCHAR2 DEFAULT NULL) IS
  BEGIN
    MERGE INTO prod.dct_runners t
    USING (SELECT p_code AS c FROM dual) s
    ON (UPPER(t.runner_code) = UPPER(s.c))
    WHEN NOT MATCHED THEN INSERT
      (runner_code, name, category, runtime, status, host_location, file_path,
       repo_path, purpose, usage_notes, schedule_info, dependencies, related_links,
       owner, tags, created_by)
    VALUES
      (p_code, p_name, p_cat, p_rt, 'ACTIVE', p_host, p_path, p_repo, p_purpose,
       p_usage, p_sched, p_deps, p_links, p_owner, p_tags, 'SETUP');
  END;
BEGIN
  -- ── OTBI -> ATD runner toolkit (runs on the worker VMs) ───────────────────
  r('RUNNER', 'ATD Worker / Loader', 'OTBI-ATD', 'PYTHON',
    'atd-vm180 / atd-vm181 / atd-vm182', '/root/otbi-atd/runner/runner.py', 'otbi-atd/runner/runner.py',
    'Main worker loop: claims jobs from the shared SKIP-LOCKED queue, extracts the OTBI analysis to CSV and loads it into the ATD target table. Includes session keep-alive + cross-worker failover self-heal.',
    'systemd service atd-worker (ExecStart: python runner.py --worker --forever). One-off: python runner.py "<Job Name>". Flags: --build (analysis builder queue), --discover, --actions.',
    'systemd atd-worker (Restart=always) on each VM', 'python-oracledb, playwright, env.sh (OTBI_USER/PWD, ATD_DB_*)',
    'otbi-atd/docs/deployment-notes.md', 'core,worker,queue,self-heal');
  r('COPY_ANALYSIS', 'Copy OTBI Analysis (+ relative-time filter)', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/copy_analysis.py', 'otbi-atd/runner/copy_analysis.py',
    'Clones an existing OTBI analysis to F/UH/U10M incremental variants without rebuilding columns; optionally adds a relative-time filter (Last Updated Date >= TIMESTAMPADD) and Saves As a new object (never overwrites the source).',
    'python copy_analysis.py --copy "<src path>" --to "PO_X_UH" --hour 1 --on-column "Last Updated Date" --verify   (use --minute 10 for 10-min; omit filter flags for a plain F copy)',
    'manual (run on a worker while the Fusion session is fresh)', 'playwright, auth.py session (auth_state_FUSION_ADGOV.json)',
    'memory project_otbi_atd_automation', 'otbi,answers,save-as,incremental');
  r('CREATE_ANALYSIS', 'Build / Discover OTBI Analysis', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/create_analysis.py', 'otbi-atd/runner/create_analysis.py',
    'Builds a NEW OTBI analysis from a declarative spec (subject area + columns + filters) by driving the Answers editor; --discover scrapes a subject area''s full folder/column tree for the column picker.',
    'python create_analysis.py --spec ../specs/x.json [--load]  |  --discover --subject-area "<SA>"',
    'queued via atd_analysis_request (runner --build)', 'playwright, auth.py',
    NULL, 'otbi,builder,discovery');
  r('ADD_ANALYSIS', 'Register Analysis as ATD Job', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/add_analysis.py', 'otbi-atd/runner/add_analysis.py',
    'Registers a saved OTBI analysis as an ATD job row (target table, job name, load mode, key cols) and optionally runs it.',
    'python add_analysis.py "<analysis path>" --table PROD.ATD_X --job "X" --load-mode TRUNCATE_INSERT --apply',
    'manual', 'python-oracledb', NULL, 'atd,job,register');
  r('PREPARE', 'Table / Column-Map Prepare + Drift', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/prepare.py', 'otbi-atd/runner/prepare.py',
    'Auto-prepares the target table and column map on a job''s first run; plans schema drift (new/removed columns) for the loader.',
    'imported by runner.py (not run directly)', 'manual', 'python-oracledb', NULL, 'atd,schema,drift');
  r('EXTRACT', 'OTBI CSV Extract (Go-URL)', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/extract.py', 'otbi-atd/runner/extract.py',
    'Downloads an analysis output as CSV via the OTBI Go-URL using the authenticated session; distinguishes session-expiry vs report-error.',
    'imported by runner.py / copy_analysis.py', 'manual', 'playwright', NULL, 'otbi,csv,download');
  r('LOAD', 'ATD CSV Loader (oracledb)', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/load.py', 'otbi-atd/runner/load.py',
    'Parses the extracted CSV and bulk-loads rows into the ATD target table (atomic TRUNCATE_INSERT via in-transaction DELETE).',
    'imported by runner.py', 'manual', 'python-oracledb', NULL, 'atd,load');
  r('LOADSQL', 'ATD CSV Loader (SQLcl path)', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/loadsql.py', 'otbi-atd/runner/loadsql.py',
    'Alternate loader that drives SQLcl for environments without python-oracledb; scrubs unlabelled columns.',
    'imported by runner.py when ATD_DB_MODE=sqlcl', 'manual', 'SQLcl', NULL, 'atd,load,sqlcl');
  r('AUTH', 'OTBI SSO/MFA Session', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/auth.py', 'otbi-atd/runner/auth.py',
    'Handles the federated SSO/MFA login (Entra number-match), reuses a saved session (auth_state_<env>.json), surfaces the match number and relays it via Telegram.',
    'imported by every runner that opens a browser', 'manual', 'playwright, notify.py',
    'memory ops_atd_session_expiry', 'otbi,sso,mfa,session');
  r('CHECKS', 'Drift Detection + Secret Scrub', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/checks.py', 'otbi-atd/runner/checks.py',
    'Schema-drift helpers + scrub() which redacts cookies / session tokens / Bearer values from log messages.',
    'imported by runner.py', 'manual', NULL, NULL, 'atd,drift,security');
  r('CONFIG', 'Runner Config -> Env', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/config.py', 'otbi-atd/runner/config.py',
    'Applies ATD_RUNNER_CONFIG table rows as environment variables (UI-editable Runner Settings).',
    'imported by runner.py', 'manual', 'python-oracledb', NULL, 'atd,config');
  r('NOTIFY', 'Telegram Notifications', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/notify.py', 'otbi-atd/runner/notify.py',
    'Sends Telegram messages (MFA number, job/drift alerts) from UI-editable templates in ATD_RUNNER_CONFIG.',
    'imported by auth.py / runner.py', 'manual', 'ATD_TG_TOKEN / ATD_TG_CHAT', NULL, 'atd,telegram,alerts');
  r('SQLRUN', 'SQLcl Helper', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/sqlrun.py', 'otbi-atd/runner/sqlrun.py',
    'Thin helper to run SQL/PLSQL through SQLcl from the runner.', 'imported by loadsql.py', 'manual',
    'SQLcl', NULL, 'atd,sqlcl');
  r('AP_INVOICE_ACTION', 'Fusion Write-back: AP Invoice', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/actions/ap_invoice.py', 'otbi-atd/runner/actions/ap_invoice.py',
    'Fusion write-back ACTION: creates an AP invoice in Fusion from an approved Petty Cash reimbursement (UI-robot driver, idempotent).',
    'driven by runner.py --actions (ATD_ACTION_LIVE=1; gate FUSION_POST_REIMB)', 'queue ATD_ACTION_REQUEST',
    'playwright', 'otbi-atd/db/19', 'fusion,writeback,ap');
  r('SMOKE_AP_INVOICE', 'AP Invoice Smoke Test', 'OTBI-ATD', 'PYTHON',
    'atd-vm180/181/182', '/root/otbi-atd/runner/smoke_ap_invoice.py', 'otbi-atd/runner/smoke_ap_invoice.py',
    'Standalone smoke test for the AP-invoice write-back action.', 'python smoke_ap_invoice.py', 'manual',
    'playwright', NULL, 'fusion,test');
  r('TG_BOT', 'Telegram Query Bot (PoC)', 'OTBI-ATD', 'PYTHON',
    'atd-vm180', '/root/otbi-atd/runner/tg_bot.py', 'otbi-atd/runner/tg_bot.py',
    'Two-way Telegram bot answering i-Finance lookups (e.g. /vendor number -> name); chat-id allow-list + field whitelist.',
    'python tg_bot.py (polling)', 'manual / planned', 'python-oracledb, ATD_TG_TOKEN',
    'memory project_tg_query_bot', 'telegram,bot,poc');
  -- ── Windows wrappers (scheduled tasks) ────────────────────────────────────
  r('RUN_ATD_PS1', 'Loader Wrapper (Windows)', 'OTBI-ATD', 'POWERSHELL',
    'workstation / scheduled host', 'run_atd.ps1', 'otbi-atd/runner/run_atd.ps1',
    'Windows Task Scheduler wrapper that runs the loader; shares the single-browser lockfile (.otbi_runner.lock).',
    'Task Scheduler -> run_atd.ps1', 'every 15 min (Win Task)', 'PowerShell, venv', NULL, 'atd,windows,task');
  r('RUN_ATD_ACTIONS_PS1', 'Actions Wrapper (Windows)', 'OTBI-ATD', 'POWERSHELL',
    'workstation / scheduled host', 'run_atd_actions.ps1', 'otbi-atd/runner/run_atd_actions.ps1',
    'Wrapper for the Fusion write-back actions runner (shares the runner lockfile).',
    'Task Scheduler -> run_atd_actions.ps1', 'scheduled', 'PowerShell', NULL, 'atd,windows,actions');
  r('RUN_ATD_DISCOVER_PS1', 'Discovery Wrapper (Windows)', 'OTBI-ATD', 'POWERSHELL',
    'workstation / scheduled host', 'run_atd_discover.ps1', 'otbi-atd/runner/run_atd_discover.ps1',
    'Dedicated wrapper for the 1-minute OTBI Discovery task (one subject area per run).',
    'Task Scheduler -> run_atd_discover.ps1', 'every 1 min (Win Task)', 'PowerShell', NULL, 'atd,windows,discover');
  -- ── Worker provisioning / deploy ──────────────────────────────────────────
  r('DEPLOY_WORKER', 'Deploy Runner to Worker', 'OTBI-ATD-Provision', 'BASH',
    'workstation -> atd-vm18x', 'otbi-atd/runner/deploy_worker.sh', 'otbi-atd/runner/deploy_worker.sh',
    'Copies the runner code to a worker VM and restarts the atd-worker service.',
    'bash deploy_worker.sh <vm-ip>', 'manual on each runner change', 'ssh, scp', NULL, 'deploy,worker');
  r('INSTALL_SW', 'Worker Software Install', 'OTBI-ATD-Provision', 'BASH',
    'atd-vm18x', 'otbi-atd/runner/install_sw.sh', 'otbi-atd/runner/install_sw.sh',
    'Installs Python/Playwright/oracledb and dependencies on a fresh worker VM.',
    'bash install_sw.sh', 'once per VM', 'apt, pip, playwright', NULL, 'provision,setup');
  r('PROVISION_VM', 'Provision Worker VM', 'OTBI-ATD-Provision', 'BASH',
    'ESXi / workstation', 'otbi-atd/provision/provision_vm.sh', 'otbi-atd/provision/provision_vm.sh',
    'Provisions a new worker VM (clone + network + base config).', 'bash provision_vm.sh', 'once per VM',
    'ESXi / govc', NULL, 'provision,vm');
  r('MAKE_OEMDRV', 'Unattended-Install ISO', 'OTBI-ATD-Provision', 'PYTHON',
    'workstation', 'otbi-atd/provision/make_oemdrv.py', 'otbi-atd/provision/make_oemdrv.py',
    'Builds an OEMDRV ISO carrying a kickstart for unattended OL install on a new worker VM.',
    'python make_oemdrv.py', 'once per VM', 'genisoimage', NULL, 'provision,iso');
  -- ── Platform dev / build / docs tooling (workstation) ─────────────────────
  r('DEV_PROXY', 'JET Dev Proxy (per app)', 'Dev-Tooling', 'PYTHON',
    'local workstation', 'final apps/<App>/Jet/dev-proxy.py', 'final apps/Admin/Jet/dev-proxy.py',
    'Local static server (port 8080) that proxies /ords/ to ADB with CORS, for running a JET SPA locally. One copy per app; SIBLING_APPS auto-derived for the module switcher.',
    'python dev-proxy.py   (from any final apps/<App>/Jet/)', 'manual (dev)', 'Python 3 stdlib',
    'CLAUDE.md (Running the JET SPA Locally)', 'dev,proxy,jet');
  r('UAT_GENERATOR', 'UAT Workbook Generator', 'UAT', 'PYTHON',
    'local workstation', 'final apps/uat-generator.py', 'final apps/uat-generator.py',
    'Generates the per-module UAT test workbooks (.xlsx) from the master script.', 'python "final apps/uat-generator.py"',
    'manual', 'openpyxl', NULL, 'uat,workbook');
  r('UAT_RUN_ATD', 'ATD UAT Runner', 'UAT', 'PYTHON',
    'local workstation', 'final apps/ATD/UAT/uat_run_atd.py', 'final apps/ATD/UAT/uat_run_atd.py',
    'Playwright + ORDS hybrid UAT runner for the Analytics Loader app; emits the workbook + Word results + evidence screenshots.',
    'python uat_run_atd.py', 'manual', 'playwright, openpyxl, python-docx', NULL, 'uat,playwright,atd');
  r('GEN_FL_GUIDE', 'Freelancer Guide Generator', 'Docs-Gen', 'PYTHON',
    'local workstation', 'final apps/FL/guides/generate_freelancer_guide.py', 'final apps/FL/guides/generate_freelancer_guide.py',
    'Generates the Freelancers user guide (diagrams + cropped screenshots + Word doc).',
    'python generate_freelancer_guide.py', 'manual', 'python-docx, playwright', NULL, 'docs,guide,fl');
  r('GL_GEN_SEED', 'GL Seed Generator', 'DB-Tooling', 'PYTHON',
    'local workstation', 'final apps/GL/db/gen_seed.py', 'final apps/GL/db/gen_seed.py',
    'Generates the General Ledger classification seed SQL from the 3 source CSVs (sectors/chapters/programs).',
    'python gen_seed.py', 'manual (on CoA source change)', 'Python 3 stdlib', 'final apps/GL/db', 'gl,seed,generator');
  COMMIT;
END;
/

PROMPT === 4. ORDS handlers (module dct.admin, additive) ===
CREATE OR REPLACE PROCEDURE admin.setup_dct_runners_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'dct.admin';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => c_mod,
      p_pattern     => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN
  -- ── list ──────────────────────────────────────────────────────────────────
  def_template('runners/');
  def_handler('runners/', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR),100),500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0),0);
  l_q      VARCHAR2(200) := [COLON]search;
  l_cat    VARCHAR2(40)  := [COLON]category;
  l_rt     VARCHAR2(30)  := [COLON]runtime;
  l_st     VARCHAR2(20)  := [COLON]status;
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_runners
   WHERE (l_cat IS NULL OR category = l_cat)
     AND (l_rt  IS NULL OR runtime  = l_rt)
     AND (l_st  IS NULL OR status   = l_st)
     AND (l_q   IS NULL OR UPPER(runner_code||' '||name||' '||NVL(purpose,'')||' '||NVL(tags,'')||' '||NVL(host_location,''))
                            LIKE '%'||UPPER(l_q)||'%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('limit', l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT runner_id, runner_code, name, category, runtime, status, host_location,
           file_path, purpose, owner, tags, updated_at,
           CASE WHEN file_blob IS NOT NULL THEN 'Y' ELSE 'N' END AS has_file
    FROM (
      SELECT a.runner_id, a.runner_code, a.name, a.category, a.runtime, a.status,
             a.host_location, a.file_path, a.purpose, a.owner, a.tags, a.updated_at,
             a.file_blob,
             ROW_NUMBER() OVER (ORDER BY a.category, a.name) rn
      FROM dct_runners a
      WHERE (l_cat IS NULL OR a.category = l_cat)
        AND (l_rt  IS NULL OR a.runtime  = l_rt)
        AND (l_st  IS NULL OR a.status   = l_st)
        AND (l_q   IS NULL OR UPPER(a.runner_code||' '||a.name||' '||NVL(a.purpose,'')||' '||NVL(a.tags,'')||' '||NVL(a.host_location,''))
                               LIKE '%'||UPPER(l_q)||'%')
    ) WHERE rn > l_offset AND rn <= l_offset + l_limit
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runnerId', c.runner_id);
    APEX_JSON.write('runnerCode', c.runner_code);
    APEX_JSON.write('name', c.name);
    APEX_JSON.write('category', c.category);
    APEX_JSON.write('runtime', c.runtime);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('hostLocation', c.host_location);
    APEX_JSON.write('filePath', c.file_path);
    APEX_JSON.write('purpose', c.purpose);
    APEX_JSON.write('owner', c.owner);
    APEX_JSON.write('tags', c.tags);
    APEX_JSON.write('hasFile', c.has_file);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- ── meta (dropdown options) ────────────────────────────────────────────────
  def_template('runners/meta');
  def_handler('runners/meta', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('categories');
  FOR c IN (SELECT DISTINCT category v FROM dct_runners WHERE category IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(c.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('runtimes');
  FOR c IN (SELECT column_value v FROM TABLE(sys.odcivarchar2list(
              'PYTHON','POWERSHELL','BASH','SQL','NODE','OTHER'))) LOOP
    APEX_JSON.write(c.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('statuses');
  FOR c IN (SELECT column_value v FROM TABLE(sys.odcivarchar2list(
              'ACTIVE','DEPRECATED','EXPERIMENTAL','ARCHIVED'))) LOOP
    APEX_JSON.write(c.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- ── create ─────────────────────────────────────────────────────────────────
  def_handler('runners/', 'POST', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_runners
    (runner_code, name, category, runtime, status, host_location, file_path, repo_path,
     purpose, usage_notes, schedule_info, dependencies, related_links, owner, tags, notes,
     content_text, created_by, updated_by)
  VALUES
    (UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'runnerCode'))),
     APEX_JSON.get_varchar2(p_path=>'name'),
     APEX_JSON.get_varchar2(p_path=>'category'),
     APEX_JSON.get_varchar2(p_path=>'runtime'),
     NVL(APEX_JSON.get_varchar2(p_path=>'status'),'ACTIVE'),
     APEX_JSON.get_varchar2(p_path=>'hostLocation'),
     APEX_JSON.get_varchar2(p_path=>'filePath'),
     APEX_JSON.get_varchar2(p_path=>'repoPath'),
     APEX_JSON.get_varchar2(p_path=>'purpose'),
     APEX_JSON.get_clob(p_path=>'usageNotes'),
     APEX_JSON.get_varchar2(p_path=>'scheduleInfo'),
     APEX_JSON.get_varchar2(p_path=>'dependencies'),
     APEX_JSON.get_varchar2(p_path=>'relatedLinks'),
     APEX_JSON.get_varchar2(p_path=>'owner'),
     APEX_JSON.get_varchar2(p_path=>'tags'),
     APEX_JSON.get_clob(p_path=>'notes'),
     APEX_JSON.get_clob(p_path=>'contentText'),
     l_user, l_user)
  RETURNING runner_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('runnerId', l_id); APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'A runner with that code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ── detail ─────────────────────────────────────────────────────────────────
  def_template('runners/[COLON]id');
  def_handler('runners/[COLON]id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  FOR c IN (
    SELECT runner_id, runner_code, name, category, runtime, status, host_location,
           file_path, repo_path, purpose, usage_notes, schedule_info, dependencies,
           related_links, owner, tags, notes, content_text, file_name, file_mime,
           CASE WHEN file_blob IS NOT NULL THEN DBMS_LOB.GETLENGTH(file_blob) ELSE 0 END AS file_size,
           created_by, created_at, updated_by, updated_at
    FROM dct_runners WHERE runner_id = [COLON]id
  ) LOOP
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runnerId', c.runner_id);
    APEX_JSON.write('runnerCode', c.runner_code);
    APEX_JSON.write('name', c.name);
    APEX_JSON.write('category', c.category);
    APEX_JSON.write('runtime', c.runtime);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('hostLocation', c.host_location);
    APEX_JSON.write('filePath', c.file_path);
    APEX_JSON.write('repoPath', c.repo_path);
    APEX_JSON.write('purpose', c.purpose);
    APEX_JSON.write('usageNotes', c.usage_notes);
    APEX_JSON.write('scheduleInfo', c.schedule_info);
    APEX_JSON.write('dependencies', c.dependencies);
    APEX_JSON.write('relatedLinks', c.related_links);
    APEX_JSON.write('owner', c.owner);
    APEX_JSON.write('tags', c.tags);
    APEX_JSON.write('notes', c.notes);
    APEX_JSON.write('contentText', c.content_text);
    APEX_JSON.write('fileName', c.file_name);
    APEX_JSON.write('fileMime', c.file_mime);
    APEX_JSON.write('fileSize', c.file_size);
    APEX_JSON.write('createdBy', c.created_by);
    APEX_JSON.write('createdAt', TO_CHAR(dct_to_local(c.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedBy', c.updated_by);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Runner not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

  -- ── update ─────────────────────────────────────────────────────────────────
  def_handler('runners/[COLON]id', 'PUT', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_runners SET
    runner_code   = UPPER(TRIM(NVL(APEX_JSON.get_varchar2(p_path=>'runnerCode'), runner_code))),
    name          = NVL(APEX_JSON.get_varchar2(p_path=>'name'), name),
    category      = APEX_JSON.get_varchar2(p_path=>'category'),
    runtime       = APEX_JSON.get_varchar2(p_path=>'runtime'),
    status        = NVL(APEX_JSON.get_varchar2(p_path=>'status'), status),
    host_location = APEX_JSON.get_varchar2(p_path=>'hostLocation'),
    file_path     = APEX_JSON.get_varchar2(p_path=>'filePath'),
    repo_path     = APEX_JSON.get_varchar2(p_path=>'repoPath'),
    purpose       = APEX_JSON.get_varchar2(p_path=>'purpose'),
    usage_notes   = APEX_JSON.get_clob(p_path=>'usageNotes'),
    schedule_info = APEX_JSON.get_varchar2(p_path=>'scheduleInfo'),
    dependencies  = APEX_JSON.get_varchar2(p_path=>'dependencies'),
    related_links = APEX_JSON.get_varchar2(p_path=>'relatedLinks'),
    owner         = APEX_JSON.get_varchar2(p_path=>'owner'),
    tags          = APEX_JSON.get_varchar2(p_path=>'tags'),
    notes         = APEX_JSON.get_clob(p_path=>'notes'),
    content_text  = APEX_JSON.get_clob(p_path=>'contentText'),
    updated_by    = l_user,
    updated_at    = SYSTIMESTAMP
  WHERE runner_id = [COLON]id;
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Runner not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'A runner with that code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ── delete ─────────────────────────────────────────────────────────────────
  def_handler('runners/[COLON]id', 'DELETE', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  DELETE FROM dct_runners WHERE runner_id = [COLON]id;
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Runner not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ── stored-file upload (raw binary) ─────────────────────────────────────────
  def_template('runners/[COLON]id/file');
  def_handler('runners/[COLON]id/file', 'PUT', q'[
DECLARE
  l_blob BLOB;
  l_user VARCHAR2(100);
  l_max  NUMBER;
  l_n    NUMBER;
BEGIN
  l_blob := [COLON]body;
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_blob IS NULL OR DBMS_LOB.GETLENGTH(l_blob) = 0 THEN
    dct_rest.err(400,'Request body (file bytes) is required'); RETURN;
  END IF;
  BEGIN
    SELECT TO_NUMBER(setting_value DEFAULT NULL ON CONVERSION ERROR) INTO l_max
    FROM dct_system_settings WHERE setting_key = 'MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL; END;
  l_max := NVL(l_max, 10);
  IF DBMS_LOB.GETLENGTH(l_blob) > l_max * 1024 * 1024 THEN
    dct_rest.err(413,'File exceeds the '||l_max||' MB limit'); RETURN;
  END IF;
  UPDATE dct_runners SET
    file_blob  = l_blob,
    file_name  = NVL([COLON]name, 'runner.txt'),
    file_mime  = NVL([COLON]mime, 'application/octet-stream'),
    updated_by = l_user,
    updated_at = SYSTIMESTAMP
  WHERE runner_id = [COLON]id;
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Runner not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
]');

  -- ── stored-file download (media) ────────────────────────────────────────────
  ORDS.DEFINE_HANDLER(
    p_module_name  => c_mod,
    p_pattern      => REPLACE('runners/[COLON]id/file','[COLON]',CHR(58)),
    p_method       => 'GET',
    p_source_type  => ORDS.source_type_media,
    p_source       => REPLACE(
      'SELECT NVL(file_mime,''application/octet-stream'') AS content_type, file_blob '
      ||'FROM dct_runners WHERE runner_id = [COLON]id', '[COLON]', CHR(58)));

  COMMIT;
END;
/
SHOW ERRORS PROCEDURE admin.setup_dct_runners_ords_tmp

BEGIN
  admin.setup_dct_runners_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_runners_ords_tmp;

PROMPT ============================================================
PROMPT  31_dct_runners.sql complete.
PROMPT  DCT_RUNNERS table + synonym + seed + ORDS /dct/runners*.
PROMPT  Endpoints: GET/POST runners/, GET/PUT/DELETE runners/:id,
PROMPT             PUT/GET runners/:id/file, GET runners/meta.
PROMPT ============================================================
