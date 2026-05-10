-- =============================================================================
-- i-Finance V2 — APEX App 200 Login Page Enhancement
-- File    : 11_apex_login_page_style.sql
-- Adds    : Two-panel branding layout + custom CSS to page 9999 (Login)
-- Idempotent: g_mode=REPLACE replaces the branding region on re-run
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

PROMPT ============================================================
PROMPT  Login Page — Two-Panel Branding (App 200, Page 9999)
PROMPT ============================================================

BEGIN
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd     => '2024.05.31',
        p_release                => '24.2.15',
        p_default_workspace_id   => 9249752073687531,
        p_default_application_id => 200,
        p_default_id_offset      => 0,
        p_default_owner          => 'PROD'
    );
    DBMS_OUTPUT.PUT_LINE('import_begin OK');
END;
/

BEGIN
    wwv_flow_imp.g_mode := 'REPLACE';
END;
/

PROMPT Adding branding HTML region to page 9999 ...
DECLARE
    l_tmpl_id  NUMBER := 0;
    l_html     CLOB;
BEGIN
    -- Resolve "No Template" region template for App 200's theme
    -- apex_application_templates uses template_id (not id)
    BEGIN
        SELECT template_id
        INTO   l_tmpl_id
        FROM   apex_application_templates
        WHERE  application_id = 200
        AND    template_type  = 'REGION'
        AND    UPPER(template_name) LIKE '%NO TEMPLATE%'
        AND    rownum = 1;
        DBMS_OUTPUT.PUT_LINE('No-Template region template ID: ' || l_tmpl_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT template_id
                INTO   l_tmpl_id
                FROM   apex_application_templates
                WHERE  application_id = 200
                AND    template_type  = 'REGION'
                AND    UPPER(template_name) LIKE '%BLANK%'
                AND    rownum = 1;
                DBMS_OUTPUT.PUT_LINE('Blank region template ID: ' || l_tmpl_id);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_tmpl_id := 0;
                    DBMS_OUTPUT.PUT_LINE('WARNING: no suitable template found, using 0');
            END;
        WHEN OTHERS THEN
            l_tmpl_id := 0;
            DBMS_OUTPUT.PUT_LINE('WARNING: template lookup error: ' || SQLERRM || ' — using 0');
    END;

    l_html := q'~<!-- =============================================================
     i-Finance Login Page — Branding Panel
     Injected by: 11_apex_login_page_style.sql
     ============================================================= -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap">

<style>
/* =================================================================
   i-Finance App 200 – Login Page Custom Design
   Two-panel: left branding (460 px) + right APEX login form
   ================================================================= */
:root {
  --lp-primary:  #1e3a5f;
  --lp-blue:     #2563eb;
  --lp-accent:   #f59e0b;
  --lp-accent2:  #fbbf24;
  --lp-bg:       #f8fafc;
  --lp-text:     #0f172a;
  --lp-text2:    #475569;
  --lp-border:   #e2e8f0;
  --lp-dk0:      #0f2040;
  --lp-dk1:      #1e3a5f;
  --lp-dk2:      #163058;
}

/* ── Font + body ──────────────────────────────────────────── */
body.t-PageBody--login,
body.t-PageBody--login * {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif !important;
  -webkit-font-smoothing: antialiased;
  box-sizing: border-box;
}
body.t-PageBody--login {
  background: var(--lp-dk0) !important;
  margin: 0 !important; padding: 0 !important; overflow-x: hidden;
}

/* ── Strip APEX login card ────────────────────────────────── */
.t-Login-container {
  display: flex !important; flex-direction: column !important;
  max-width: none !important; width: 100vw !important;
  min-height: 100vh !important;
  margin: 0 !important; padding: 0 !important;
  box-shadow: none !important; border-radius: 0 !important;
  background: transparent !important;
}
.t-Login-logo, .t-Login-footer { display: none !important; }

/* ── Two-column flex on the body (regions container) ─────── */
.t-Login-body {
  display: flex !important; flex-direction: row !important;
  flex: 1 !important; width: 100% !important;
  min-height: 100vh !important;
  padding: 0 !important; gap: 0 !important; align-items: stretch !important;
}

/* ── Right panel — everything except our branding ─────────── */
.t-Login-body > div:not(.lp-branding),
.t-Login-body > article:not(.lp-branding) {
  flex: 1 !important;
  background: var(--lp-bg) !important;
  display: flex !important; align-items: center !important;
  justify-content: center !important;
  padding: 2.5rem !important; min-height: 100vh !important;
}

/* ── APEX login region card ───────────────────────────────── */
.t-Login-region { max-width: 440px !important; width: 100% !important; }
.t-Login-region .t-Region-title {
  font-size: 1.75rem !important; font-weight: 800 !important; color: var(--lp-text) !important;
}
.t-Login-region .t-Region-body { padding: 0 !important; }

/* ── Form inputs ──────────────────────────────────────────── */
.apex-item-text,
input[type="text"].apex-item-text,
input[type="email"],
input[type="password"] {
  width: 100% !important; border: 1.5px solid var(--lp-border) !important;
  border-radius: 8px !important; padding: .75rem 1rem !important;
  font-size: .9rem !important; color: var(--lp-text) !important;
  background: white !important; transition: border-color .2s, box-shadow .2s !important;
}
input[type="text"]:focus,
input[type="email"]:focus,
input[type="password"]:focus {
  border-color: var(--lp-blue) !important;
  box-shadow: 0 0 0 3px rgba(37,99,235,.15) !important; outline: none !important;
}

/* ── Submit button ────────────────────────────────────────── */
.t-Button--hot, #B_LOGIN, button.t-Button--hot {
  width: 100% !important; padding: .875rem 1rem !important;
  background: linear-gradient(135deg, var(--lp-primary), var(--lp-blue)) !important;
  color: white !important; border: none !important; border-radius: 8px !important;
  font-size: .95rem !important; font-weight: 700 !important; cursor: pointer !important;
  box-shadow: 0 4px 12px rgba(37,99,235,.3) !important;
  transition: all .2s !important; font-family: inherit !important;
}
.t-Button--hot:hover, #B_LOGIN:hover {
  box-shadow: 0 6px 20px rgba(37,99,235,.4) !important; transform: translateY(-1px) !important;
}

/* ── Branding panel ───────────────────────────────────────── */
.lp-branding {
  flex: 0 0 460px;
  display: flex; align-items: center; justify-content: center;
  padding: 3rem;
  background: linear-gradient(145deg, var(--lp-dk0) 0%, var(--lp-dk1) 50%, var(--lp-dk2) 100%);
  position: relative; overflow: hidden; min-height: 100vh;
}
.lb-content  { position: relative; z-index: 2; width: 100%; max-width: 380px; }
.lb-logo     { display: flex; align-items: center; gap: 1rem; margin-bottom: 3rem; }
.lb-logo-icon {
  width: 56px; height: 56px;
  background: linear-gradient(135deg, var(--lp-accent), var(--lp-accent2));
  border-radius: 16px; display: flex; align-items: center; justify-content: center;
  font-size: 1.5rem; color: white; box-shadow: 0 8px 20px rgba(245,158,11,.35);
  flex-shrink: 0;
}
.lb-app-name { font-size: 1.375rem; font-weight: 800; color: white; display: block; }
.lb-app-sub  { font-size: .75rem; color: rgba(255,255,255,.5); font-weight: 500; display: block; margin-top: .1rem; }
.lb-headline {
  font-size: 2.25rem !important; font-weight: 800 !important;
  color: white !important; line-height: 1.15 !important; margin-bottom: 1.25rem !important;
}
.lb-accent-word { color: var(--lp-accent); }
.lb-features { display: flex; flex-direction: column; gap: .875rem; }
.lb-feature  { display: flex; align-items: center; gap: .75rem; color: rgba(255,255,255,.85); font-size: .9rem; font-weight: 500; }
.lb-feature .fa { color: var(--lp-accent); font-size: .875rem; flex-shrink: 0; }
.lb-stats    { display: flex; gap: 2rem; margin-top: 2.5rem; padding-top: 2rem; border-top: 1px solid rgba(255,255,255,.1); }
.lb-stat     { text-align: left; }
.lb-stat-val { font-size: 1.5rem; font-weight: 800; color: white; display: block; }
.lb-stat-lbl { font-size: .7rem; color: rgba(255,255,255,.5); text-transform: uppercase; letter-spacing: .5px; }

.lb-shape    { position: absolute; border-radius: 50%; background: rgba(255,255,255,.04); pointer-events: none; }
.lb-shape-1  { width: 300px; height: 300px; top: -80px; right: -80px; }
.lb-shape-2  { width: 200px; height: 200px; bottom: 60px; right: 20px; }
.lb-shape-3  { width: 150px; height: 150px; bottom: -40px; left: -40px; }
.lb-shape-4  { width: 80px;  height: 80px;  top: 40%; left: -20px; background: rgba(245,158,11,.06); }

/* ── Responsive ───────────────────────────────────────────── */
@media (max-width: 960px) {
  .lp-branding { display: none !important; }
  body.t-PageBody--login { background: white !important; }
  .t-Login-body > div:not(.lp-branding) { background: white !important; }
}
</style>

<!-- ═══════════ Left Branding Panel ═══════════ -->
<div class="lp-branding">
  <span class="lb-shape lb-shape-1"></span>
  <span class="lb-shape lb-shape-2"></span>
  <span class="lb-shape lb-shape-3"></span>
  <span class="lb-shape lb-shape-4"></span>

  <div class="lb-content">

    <div class="lb-logo">
      <div class="lb-logo-icon">
        <i class="fa fa-chart-line" aria-hidden="true"></i>
      </div>
      <div>
        <span class="lb-app-name">i-Finance</span>
        <span class="lb-app-sub">Task Management Module</span>
      </div>
    </div>

    <h1 class="lb-headline">
      Streamline Your<br>
      <span class="lb-accent-word">Financial</span><br>
      Operations
    </h1>

    <div class="lb-features">
      <div class="lb-feature">
        <i class="fa fa-check-circle" aria-hidden="true"></i>
        <span>Weekly task tracking across all finance sections</span>
      </div>
      <div class="lb-feature">
        <i class="fa fa-check-circle" aria-hidden="true"></i>
        <span>Real-time progress monitoring &amp; alerts</span>
      </div>
      <div class="lb-feature">
        <i class="fa fa-check-circle" aria-hidden="true"></i>
        <span>Director oversight with drill-down analytics</span>
      </div>
      <div class="lb-feature">
        <i class="fa fa-check-circle" aria-hidden="true"></i>
        <span>Role-based access for 5 finance sections</span>
      </div>
      <div class="lb-feature">
        <i class="fa fa-check-circle" aria-hidden="true"></i>
        <span>Automated end-of-week reports &amp; notifications</span>
      </div>
    </div>

    <div class="lb-stats">
      <div class="lb-stat">
        <span class="lb-stat-val">5</span>
        <span class="lb-stat-lbl">Finance Sections</span>
      </div>
      <div class="lb-stat">
        <span class="lb-stat-val">25+</span>
        <span class="lb-stat-lbl">Weekly Tasks</span>
      </div>
      <div class="lb-stat">
        <span class="lb-stat-val">100%</span>
        <span class="lb-stat-lbl">Visibility</span>
      </div>
    </div>

  </div>
</div>
~';

    wwv_flow_imp_page.create_page_plug(
        p_id                    => wwv_flow_imp.id(9461200001432070),
        p_flow_id               => 200,
        p_page_id               => 9999,
        p_plug_name             => 'Login Branding',
        p_plug_display_sequence => 5,
        p_plug_display_point    => 'BODY',
        p_plug_template         => l_tmpl_id,
        p_plug_source_type      => 'NATIVE_STATIC',
        p_plug_source           => l_html,
        p_translate_title       => 'N'
    );

    DBMS_OUTPUT.PUT_LINE('Branding region created (template ID: ' || l_tmpl_id || ').');
END;
/

BEGIN
    wwv_flow_imp.import_end;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Done. Login page enhanced — verify at App 200 > Page 9999.');
END;
/

PROMPT ============================================================
PROMPT  Login page branding applied.
PROMPT  Open App 200 in APEX and navigate to the login page to verify.
PROMPT  If the layout looks off, check Page 9999 in Page Designer:
PROMPT    - Region "Login Branding" should have Display Seq = 5
PROMPT    - Adjust CSS selectors if the APEX theme wraps differently
PROMPT ============================================================
