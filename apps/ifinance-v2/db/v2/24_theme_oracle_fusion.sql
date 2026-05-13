SET DEFINE OFF
-- =============================================================
--  24_theme_oracle_fusion.sql
--  Apply Oracle Fusion professional theme to App 200.
--
--  What this script does:
--    1. Uploads theme-oracle-fusion.css as a Redwood theme file
--       (accessible via #THEME_DB_FILES#theme-oracle-fusion.css)
--    2. Updates the "Redwood Light - DCT" theme style to:
--       - Switch pillar colour from neutral → blue (Oracle brand)
--       - Add the fusion CSS file to its css_file_urls load list
--
--  To apply to other apps:
--    In APEX Builder > Shared Components > Themes > Theme Style,
--    add  #THEME_DB_FILES#theme-oracle-fusion.css  to CSS File URLs.
-- =============================================================

DECLARE
  l_css    CLOB;
  l_len    PLS_INTEGER;
  l_pos    PLS_INTEGER := 1;
  l_idx    PLS_INTEGER := 1;
  C_CHUNK  CONSTANT PLS_INTEGER := 100;   -- bytes per hex entry
BEGIN

  /* ── Build the CSS content ──────────────────────────────── */
  l_css := TO_CLOB(q'[/* ══════════════════════════════════════════════════════════════
   i-Finance Fusion — Oracle Professional Theme
   Designed for Oracle APEX 24.2 · Redwood Base Theme
   Covers all Apps / Modules (generic, no app-specific rules)
   ══════════════════════════════════════════════════════════════ */

/* ── 1. Oracle Brand Design Tokens ─────────────────────────── */
:root {
  --ifn-blue-950:  #06193A;
  --ifn-blue-900:  #0C2D5E;
  --ifn-blue-800:  #124588;
  --ifn-blue-700:  #1A5EB2;
  --ifn-blue-600:  #1B6ACC;
  --ifn-blue-500:  #2B7FE3;
  --ifn-blue-400:  #5A9FEE;
  --ifn-blue-300:  #92C0F5;
  --ifn-blue-100:  #E0EEFF;
  --ifn-blue-50:   #F0F6FF;
  --ifn-gray-950:  #111214;
  --ifn-gray-900:  #1A1C1E;
  --ifn-gray-800:  #2D3035;
  --ifn-gray-700:  #454A50;
  --ifn-gray-600:  #5D6470;
  --ifn-gray-400:  #8C95A0;
  --ifn-gray-300:  #B4BBC4;
  --ifn-gray-200:  #D4D9DF;
  --ifn-gray-100:  #EAEDF0;
  --ifn-gray-50:   #F4F5F7;
  --ifn-white:     #FFFFFF;
  --ifn-success:       #147A3B;
  --ifn-success-light: #E4F5EC;
  --ifn-warning:       #B45309;
  --ifn-warning-light: #FEF3CD;
  --ifn-danger:        #B91C1C;
  --ifn-danger-light:  #FEE2E2;
  --ifn-info:          #1B6ACC;
  --ifn-info-light:    #E0EEFF;
  --ifn-shadow-xs: 0 1px 2px rgba(0,0,0,0.06);
  --ifn-shadow-sm: 0 1px 4px rgba(0,0,0,0.08),0 1px 2px rgba(0,0,0,0.04);
  --ifn-shadow:    0 4px 10px rgba(0,0,0,0.09),0 2px 4px rgba(0,0,0,0.05);
  --ifn-shadow-md: 0 8px 20px rgba(0,0,0,0.11),0 3px 6px rgba(0,0,0,0.06);
  --ifn-shadow-lg: 0 20px 40px rgba(0,0,0,0.14),0 8px 16px rgba(0,0,0,0.07);
  --ifn-radius-xs: 2px;  --ifn-radius-sm: 4px;
  --ifn-radius:    6px;  --ifn-radius-md: 8px;  --ifn-radius-lg: 12px;
  --ifn-font: 'Oracle Sans','Segoe UI',system-ui,-apple-system,sans-serif;
}

/* ── 2. Redwood Blue Pillar → Oracle Exact Blue ─────────────── */
.rw-pillar--blue,html.rw-pillar--blue {
  --rw-color-primary:var(--ifn-blue-600)!important;
  --rw-pillar-1:var(--ifn-blue-950)!important;
  --rw-pillar-2:var(--ifn-blue-900)!important;
  --rw-pillar-3:var(--ifn-blue-600)!important;
  --rw-pillar-4:var(--ifn-blue-400)!important;
  --rw-pillar-5:var(--ifn-blue-100)!important;
}

/* ── 3. Base Typography ──────────────────────────────────────── */
html,body,.t-Body {
  font-family:var(--ifn-font)!important;
  -webkit-font-smoothing:antialiased!important;
  -moz-osx-font-smoothing:grayscale!important;
  font-size:14px!important;
}
.t-Body,#t_PageBody { background-color:var(--ifn-gray-50)!important; }

/* ── 4. Global Header / Pillar ──────────────────────────────── */
#t_Header,.t-Header {
  background:linear-gradient(160deg,var(--ifn-blue-950) 0%,var(--ifn-blue-900) 100%)!important;
  border-bottom:2px solid var(--ifn-blue-700)!important;
  box-shadow:0 2px 10px rgba(0,0,0,.30)!important;
}
.t-Header-logo a,.t-Header-appName,.rw-Pillar-appName {
  font-weight:700!important;font-size:16px!important;
  letter-spacing:.2px!important;color:var(--ifn-white)!important;
  text-decoration:none!important;
}
.t-Header-navBar .t-Button,.rw-Pillar .t-Button {
  color:rgba(255,255,255,.80)!important;
  background:transparent!important;border-color:transparent!important;
}
.t-Header-navBar .t-Button:hover,.rw-Pillar .t-Button:hover {
  color:var(--ifn-white)!important;background:rgba(255,255,255,.10)!important;
}]');

  l_css := l_css || TO_CLOB(q'[
/* ── 5. Navigation Panel (dark mode) ───────────────────────── */
#t_Body_nav,.t-Body-nav {
  background-color:var(--ifn-blue-950)!important;
  border-right:1px solid rgba(255,255,255,.06)!important;
}
.t-TreeNav .t-Nav-sectionLabel,.a-TreeView-label--groupLabel {
  color:rgba(180,200,230,.50)!important;font-size:10px!important;
  font-weight:700!important;letter-spacing:1.4px!important;
  text-transform:uppercase!important;padding:18px 16px 6px!important;display:block!important;
}
.t-TreeNav .a-TreeView-node { margin:1px 8px!important;border-radius:var(--ifn-radius)!important; }
.t-TreeNav .a-TreeView-content {
  display:flex!important;align-items:center!important;gap:10px!important;
  color:rgba(195,215,245,.82)!important;font-size:13px!important;font-weight:400!important;
  padding:9px 12px!important;border-radius:var(--ifn-radius)!important;
  transition:background .13s ease,color .13s ease!important;
  text-decoration:none!important;cursor:pointer!important;
}
.t-TreeNav .a-TreeView-node:hover>.a-TreeView-content {
  color:var(--ifn-white)!important;background:rgba(255,255,255,.08)!important;
}
.t-TreeNav .a-TreeView-node--selected>.a-TreeView-content,
.t-TreeNav .is-active>.a-TreeView-content,
.t-TreeNav .a-TreeView-node.is-active>.a-TreeView-content {
  color:var(--ifn-white)!important;background:var(--ifn-blue-700)!important;
  font-weight:600!important;box-shadow:0 2px 8px rgba(27,106,204,.35)!important;
}
.t-TreeNav .a-TreeView-icon,.t-TreeNav .fa {
  color:rgba(180,205,245,.65)!important;font-size:14px!important;
  width:18px!important;text-align:center!important;flex-shrink:0!important;
}
.t-TreeNav .a-TreeView-node--selected>.a-TreeView-content .a-TreeView-icon,
.t-TreeNav .a-TreeView-node--selected>.a-TreeView-content .fa {
  color:rgba(255,255,255,.90)!important;
}
.t-Button--navBar,.t-TreeNav-toggleButton {
  color:rgba(255,255,255,.75)!important;background:transparent!important;border-color:transparent!important;
}

/* ── 6. Breadcrumb Bar ──────────────────────────────────────── */
.t-Body-header,.t-BreadcrumbRegion {
  background:var(--ifn-white)!important;
  border-bottom:1px solid var(--ifn-gray-100)!important;
  box-shadow:var(--ifn-shadow-xs)!important;padding:8px 20px!important;
}
.t-Breadcrumb li { font-size:12px!important; }
.t-Breadcrumb a { color:var(--ifn-blue-600)!important;text-decoration:none!important; }
.t-Breadcrumb a:hover { text-decoration:underline!important; }
.t-Breadcrumb-item--active,.t-Breadcrumb li:last-child span {
  color:var(--ifn-gray-700)!important;font-weight:600!important;
}
.t-Breadcrumb-separator { color:var(--ifn-gray-300)!important; }

/* ── 7. Content Area ────────────────────────────────────────── */
#t_Body_content,.t-Body-content { background:var(--ifn-gray-50)!important;padding:20px!important; }

/* ── 8. Regions / Cards ─────────────────────────────────────── */
.t-Region,.t-Form--popup {
  background:var(--ifn-white)!important;border:1px solid var(--ifn-gray-100)!important;
  border-radius:var(--ifn-radius-md)!important;box-shadow:var(--ifn-shadow-sm)!important;overflow:hidden!important;
}
.t-Region-header {
  background:var(--ifn-white)!important;border-bottom:2px solid var(--ifn-blue-600)!important;padding:14px 20px!important;
}
.t-Region-title {
  color:var(--ifn-gray-900)!important;font-size:14px!important;font-weight:600!important;letter-spacing:.1px!important;
}
.t-Region-headerItems--buttons .t-Button { font-size:12px!important; }
.t-Region-body { padding:16px 20px!important; }
.t-Region-bodyWrap { padding:0!important; }]');

  l_css := l_css || TO_CLOB(q'[
/* ── 9. Buttons ─────────────────────────────────────────────── */
.t-Button {
  font-family:var(--ifn-font)!important;font-size:13px!important;font-weight:500!important;
  letter-spacing:.15px!important;border-radius:var(--ifn-radius)!important;
  padding:7px 18px!important;line-height:1.4!important;cursor:pointer!important;
  transition:background .14s ease,border-color .14s ease,box-shadow .14s ease,transform .10s ease!important;
}
.t-Button--hot {
  background:var(--ifn-blue-600)!important;border-color:var(--ifn-blue-700)!important;
  color:var(--ifn-white)!important;box-shadow:0 1px 3px rgba(27,106,204,.28)!important;
}
.t-Button--hot:hover {
  background:var(--ifn-blue-700)!important;border-color:var(--ifn-blue-800)!important;
  box-shadow:0 3px 10px rgba(27,106,204,.40)!important;transform:translateY(-1px)!important;
}
.t-Button--hot:active { transform:translateY(0)!important;box-shadow:0 1px 2px rgba(27,106,204,.20)!important; }
.t-Button:not(.t-Button--hot):not(.t-Button--warning):not(.t-Button--danger):not(.t-Button--noLabel) {
  background:var(--ifn-white)!important;border:1px solid var(--ifn-gray-200)!important;color:var(--ifn-gray-700)!important;
}
.t-Button:not(.t-Button--hot):not(.t-Button--warning):not(.t-Button--danger):not(.t-Button--noLabel):hover {
  background:var(--ifn-gray-50)!important;border-color:var(--ifn-blue-600)!important;color:var(--ifn-blue-600)!important;
}
.t-Button--danger {
  background:var(--ifn-danger)!important;border-color:#991B1B!important;color:var(--ifn-white)!important;
}
.t-Button--danger:hover { background:#991B1B!important;transform:translateY(-1px)!important; }
.t-Button--small { font-size:11px!important;padding:4px 12px!important; }
.t-Button--noLabel { padding:7px 9px!important;border-radius:var(--ifn-radius)!important; }

/* ── 10. Forms & Inputs ─────────────────────────────────────── */
.t-Form-label {
  font-family:var(--ifn-font)!important;font-size:12px!important;font-weight:600!important;
  color:var(--ifn-gray-700)!important;letter-spacing:.15px!important;margin-bottom:4px!important;
}
.apex-item-text,.apex-item-select,.apex-item-textarea,
input[type="text"].apex-form-text,input[type="search"],select.apex-item-select {
  font-family:var(--ifn-font)!important;font-size:13px!important;color:var(--ifn-gray-900)!important;
  border:1px solid var(--ifn-gray-200)!important;border-radius:var(--ifn-radius)!important;
  padding:7px 10px!important;background:var(--ifn-white)!important;
  transition:border-color .14s ease,box-shadow .14s ease!important;
}
.apex-item-text:focus,.apex-item-select:focus,.apex-item-textarea:focus {
  border-color:var(--ifn-blue-600)!important;
  box-shadow:0 0 0 3px rgba(27,106,204,.12)!important;outline:none!important;
}
.apex-item-text:disabled,.apex-item-select:disabled {
  background:var(--ifn-gray-50)!important;color:var(--ifn-gray-400)!important;cursor:not-allowed!important;
}
.t-Form-required { color:var(--ifn-danger)!important; }
.t-Form-error { font-size:12px!important;color:var(--ifn-danger)!important;margin-top:3px!important; }]');

  l_css := l_css || TO_CLOB(q'[
/* ── 11. Interactive Reports ────────────────────────────────── */
.t-IRR-region {
  border-radius:var(--ifn-radius-md)!important;overflow:hidden!important;
  border:1px solid var(--ifn-gray-100)!important;box-shadow:var(--ifn-shadow-sm)!important;
  background:var(--ifn-white)!important;
}
.a-IRR-toolbar,.t-IRR-toolbar {
  background:var(--ifn-white)!important;border-bottom:1px solid var(--ifn-gray-100)!important;
  padding:10px 16px!important;display:flex!important;align-items:center!important;
  flex-wrap:wrap!important;gap:6px!important;
}
.a-IRR-toolbar .a-SearchBar-input,.a-IRR-searchBar input[type="search"] {
  border:1px solid var(--ifn-gray-200)!important;border-radius:var(--ifn-radius)!important;
  font-size:12px!important;padding:6px 10px!important;background:var(--ifn-gray-50)!important;
}
.a-IRR-toolbar .a-SearchBar-input:focus {
  background:var(--ifn-white)!important;border-color:var(--ifn-blue-600)!important;
  box-shadow:0 0 0 2px rgba(27,106,204,.12)!important;
}
.a-IRR-table { font-size:13px!important;border-collapse:collapse!important;width:100%!important; }
.a-IRR-table thead th,.a-IRR-table th {
  background:var(--ifn-gray-50)!important;color:var(--ifn-gray-600)!important;
  font-size:11px!important;font-weight:700!important;letter-spacing:.7px!important;
  text-transform:uppercase!important;padding:10px 14px!important;
  border-bottom:2px solid var(--ifn-blue-600)!important;white-space:nowrap!important;
  border-right:1px solid var(--ifn-gray-100)!important;
}
.a-IRR-table thead th:last-child { border-right:none!important; }
.a-IRR-table th .a-Icon { color:var(--ifn-blue-500)!important; }
.a-IRR-table td {
  padding:10px 14px!important;color:var(--ifn-gray-800)!important;
  border-bottom:1px solid var(--ifn-gray-100)!important;
  border-right:1px solid var(--ifn-gray-50)!important;
  vertical-align:middle!important;font-size:13px!important;line-height:1.45!important;
}
.a-IRR-table td:last-child { border-right:none!important; }
.a-IRR-table tbody tr:nth-child(even) td { background:#FAFBFC!important; }
.a-IRR-table tbody tr:hover td { background:var(--ifn-blue-50)!important;cursor:pointer!important; }
.a-IRR-table td a {
  color:var(--ifn-blue-600)!important;text-decoration:none!important;font-weight:500!important;
}
.a-IRR-table td a:hover { text-decoration:underline!important;color:var(--ifn-blue-700)!important; }
.a-IRR-pagination {
  background:var(--ifn-white)!important;border-top:1px solid var(--ifn-gray-100)!important;
  padding:8px 16px!important;font-size:12px!important;color:var(--ifn-gray-600)!important;
}
.a-IRR-noData {
  text-align:center!important;padding:40px 20px!important;
  color:var(--ifn-gray-400)!important;font-size:14px!important;
}

/* ── 12. Status Badges ──────────────────────────────────────── */
.t-Badge {
  display:inline-flex!important;align-items:center!important;
  font-size:10px!important;font-weight:700!important;padding:3px 8px!important;
  border-radius:100px!important;letter-spacing:.5px!important;
  text-transform:uppercase!important;white-space:nowrap!important;
}
.t-Badge--success,.u-color-success{background:var(--ifn-success-light)!important;color:var(--ifn-success)!important;}
.t-Badge--warning,.u-color-warning{background:var(--ifn-warning-light)!important;color:var(--ifn-warning)!important;}
.t-Badge--danger,.u-color-danger {background:var(--ifn-danger-light)!important; color:var(--ifn-danger)!important; }
.t-Badge--info,.u-color-info    {background:var(--ifn-info-light)!important;   color:var(--ifn-info)!important;   }]');

  l_css := l_css || TO_CLOB(q'[
/* ── 13. Alerts ─────────────────────────────────────────────── */
.t-Alert {
  border-radius:var(--ifn-radius)!important;padding:12px 16px!important;
  font-size:13px!important;border-width:1px!important;border-style:solid!important;
}
.t-Alert--success{background:var(--ifn-success-light)!important;border-color:var(--ifn-success)!important;color:var(--ifn-success)!important;}
.t-Alert--warning{background:var(--ifn-warning-light)!important;border-color:var(--ifn-warning)!important;color:var(--ifn-warning)!important;}
.t-Alert--danger {background:var(--ifn-danger-light)!important; border-color:var(--ifn-danger)!important; color:var(--ifn-danger)!important; }
.t-Alert--info   {background:var(--ifn-info-light)!important;   border-color:var(--ifn-info)!important;   color:var(--ifn-blue-800)!important;}

/* ── 14. Dialogs & Drawers ──────────────────────────────────── */
.t-Dialog--standard .t-Dialog-region,.t-DrawerRegion {
  border-radius:var(--ifn-radius-lg)!important;box-shadow:var(--ifn-shadow-lg)!important;
  border:1px solid var(--ifn-gray-100)!important;overflow:hidden!important;
}
.t-Dialog-header,.t-DrawerRegion .t-Region-header {
  background:linear-gradient(135deg,var(--ifn-blue-900),var(--ifn-blue-800))!important;
  border-bottom:none!important;padding:16px 20px!important;
}
.t-Dialog-title,.t-DrawerRegion .t-Region-title {
  font-size:14px!important;font-weight:600!important;color:var(--ifn-white)!important;
}
.t-Dialog-header .t-Button--closeRegion,.t-DrawerRegion .t-Button--closeRegion {
  color:rgba(255,255,255,.75)!important;background:transparent!important;border-color:transparent!important;
}
.t-Dialog-header .t-Button--closeRegion:hover,.t-DrawerRegion .t-Button--closeRegion:hover {
  color:var(--ifn-white)!important;background:rgba(255,255,255,.12)!important;
}
.t-Dialog-footer,.t-DrawerRegion .t-Region-footer {
  background:var(--ifn-gray-50)!important;border-top:1px solid var(--ifn-gray-100)!important;padding:12px 20px!important;
}
.t-Dialog-body,.t-DrawerRegion .t-Region-body { background:var(--ifn-white)!important;padding:20px!important; }
.ui-widget-overlay,.t-Dialog-overlay {
  background:rgba(6,25,58,.50)!important;backdrop-filter:blur(2px)!important;
}

/* ── 15. App Launcher Cards ─────────────────────────────────── */
.t-Cards .t-Card {
  background:var(--ifn-white)!important;border:1px solid var(--ifn-gray-100)!important;
  border-radius:var(--ifn-radius-md)!important;box-shadow:var(--ifn-shadow-sm)!important;
  transition:box-shadow .18s ease,transform .18s ease,border-color .18s ease!important;
  overflow:hidden!important;cursor:pointer!important;
}
.t-Cards .t-Card:hover {
  box-shadow:var(--ifn-shadow-md)!important;transform:translateY(-3px)!important;
  border-color:var(--ifn-blue-300)!important;
}
.t-Cards .t-Card-wrap { padding:20px!important; }
.t-Cards .t-Card-titleWrap .t-Card-title {
  font-size:14px!important;font-weight:600!important;color:var(--ifn-blue-700)!important;
}
.t-Cards .t-Card-body { color:var(--ifn-gray-600)!important;font-size:12px!important;line-height:1.5!important; }
.t-Cards .t-Card-iconWrap .t-Icon,.t-Cards .t-Card-iconWrap .fa {
  color:var(--ifn-blue-600)!important;font-size:28px!important;
}

/* ── 16. Inline Messages ────────────────────────────────────── */
.apex-page-success,.apex-success-message {
  background:var(--ifn-success-light)!important;border-left:4px solid var(--ifn-success)!important;
  border-radius:var(--ifn-radius)!important;color:var(--ifn-success)!important;
  font-size:13px!important;padding:12px 16px!important;margin:12px 0!important;
}
.apex-error-message,.apex-page-error {
  background:var(--ifn-danger-light)!important;border-left:4px solid var(--ifn-danger)!important;
  border-radius:var(--ifn-radius)!important;color:var(--ifn-danger)!important;
  font-size:13px!important;padding:12px 16px!important;margin:12px 0!important;
}

/* ── 17. Miscellaneous Polish ───────────────────────────────── */
.t-Report-pagination .t-Button { min-width:32px!important;padding:5px 10px!important;font-size:12px!important; }
input[type="checkbox"],input[type="radio"] { accent-color:var(--ifn-blue-600)!important;cursor:pointer!important; }
*:focus-visible { outline:2px solid var(--ifn-blue-500)!important;outline-offset:2px!important; }

/* ── 18. Thin Scrollbars ────────────────────────────────────── */
* { scrollbar-width:thin!important;scrollbar-color:var(--ifn-gray-300) transparent!important; }
*::-webkit-scrollbar { width:5px!important;height:5px!important; }
*::-webkit-scrollbar-track { background:transparent!important; }
*::-webkit-scrollbar-thumb { background:var(--ifn-gray-300)!important;border-radius:3px!important; }
*::-webkit-scrollbar-thumb:hover { background:var(--ifn-gray-400)!important; }

/* ── 19. RTL Support ────────────────────────────────────────── */
[dir="rtl"] .t-TreeNav .a-TreeView-content { flex-direction:row-reverse!important; }
[dir="rtl"] .t-Body-nav { border-right:none!important;border-left:1px solid rgba(255,255,255,.06)!important; }
[dir="rtl"] .apex-page-success,[dir="rtl"] .apex-success-message {
  border-left:none!important;border-right:4px solid var(--ifn-success)!important;
}
[dir="rtl"] .apex-error-message,[dir="rtl"] .apex-page-error {
  border-left:none!important;border-right:4px solid var(--ifn-danger)!important;
}]');

  /* ── Convert CLOB → hex table for create_theme_file ───────── */
  l_len := DBMS_LOB.GETLENGTH(l_css);
  wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
  WHILE l_pos <= l_len LOOP
    wwv_flow_imp.g_varchar2_table(l_idx) :=
      RAWTOHEX(UTL_RAW.CAST_TO_RAW(DBMS_LOB.SUBSTR(l_css, C_CHUNK, l_pos)));
    l_idx := l_idx + 1;
    l_pos := l_pos + C_CHUNK;
  END LOOP;

  /* ── Begin APEX import ────────────────────────────────────── */
  wwv_flow_imp.import_begin(
     p_version_yyyy_mm_dd         => '2024.11.30'
    ,p_release                    => '24.2.0'
    ,p_default_workspace_id       => 9249752073687531
    ,p_default_application_id     => 200
    ,p_default_id_offset          => 0
    ,p_default_owner              => 'PROD'
  );

  /* ── Step 1: Upload fusion CSS as a Redwood theme file ──────── */
  wwv_flow_imp_shared.create_theme_file(
     p_id           => wwv_flow_imp.id(9499100000000001)
    ,p_theme_id     => 42
    ,p_file_name    => 'theme-oracle-fusion.css'
    ,p_mime_type    => 'text/css'
    ,p_file_charset => 'utf-8'
    ,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
  );

  /* ── Step 2: Update theme style ─────────────────────────────── */
  --   · Switches pillar from neutral → blue
  --   · Adds theme-oracle-fusion.css to the CSS load list
  wwv_flow_imp_shared.create_theme_style(
     p_id                           => wwv_flow_imp.id(9391707740957065)
    ,p_theme_id                     => 42
    ,p_name                         => 'Redwood Light - DCT'
    ,p_css_file_urls                => wwv_flow_string.join(wwv_flow_t_varchar2(
        '#APEX_FILES#libraries/oracle-fonts/oraclesans-apex#MIN#.css?v=#APEX_VERSION#'
       ,'#THEME_FILES#css/Redwood#MIN#.css?v=#APEX_VERSION#'
       ,'#THEME_DB_FILES#theme-oracle-fusion.css'))
    ,p_css_classes                  => ' rw-pillar--blue rw-layout--edge-to-edge rw-mode-header--pillar rw-mode-nav--dark rw-mode-body-header--dark rw-mode-body--light'
    ,p_is_public                    => true
    ,p_is_accessible                => false
    ,p_theme_roller_input_file_urls => '#THEME_FILES#less/theme/Redwood-Theme.less'
    ,p_theme_roller_config          => '{"classes":["rw-pillar--blue","rw-layout--fixed t-PageBody--scrollTitle","rw-layout--edge-to-edge","rw-mode-header--pillar","rw-mode-nav--dark","rw-mode-body-header--dark","rw-mode-body--light"],"vars":{},"customCSS":"","useCustomLess":"N"}'
    ,p_theme_roller_output_file_url => '#THEME_DB_FILES#9391707740957065.css'
    ,p_theme_roller_read_only       => false
  );

  COMMIT;

END;
/

PROMPT Oracle Fusion theme applied to App 200.
PROMPT CSS file : #THEME_DB_FILES#theme-oracle-fusion.css
PROMPT Pillar   : rw-pillar--blue (Oracle brand blue)
PROMPT To apply to other apps: add #THEME_DB_FILES#theme-oracle-fusion.css
PROMPT to the theme style CSS File URLs in APEX Builder.
