-- =============================================================================
-- Accounts Payable (App 212) -- module registry row
-- File    : 01_ap_module_seed.sql
-- Schema  : PROD (registry row only; no new objects)
-- Run     : sql -name prod_mcp @01_ap_module_seed.sql
-- Safe    : rerunnable -- add-if-missing, then refresh the mutable columns
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

INSERT INTO prod.dct_modules
  (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
   apex_page_id, icon_class, icon_color, bg_color,
   description_en, description_ar, category, display_order,
   is_active, is_new_tab, is_admin_only)
SELECT 'AP',
       'Accounts Payable',
       'الحسابات الدائنة',
       'APEX_APP',
       212,
       1,
       'fa-file-invoice-dollar',
       '#8E3B5C',
       '#F4E9EE',
       'Accounts Payable analytics over Fusion AP data - invoice register, AP aging, and spend status by supplier, sector, department, project, PO and PR.',
       'تحليلات الحسابات الدائنة من بيانات فيوجن - سجل الفواتير وأعمار الديون وحالة الإنفاق حسب المورد والقطاع والإدارة والمشروع وأوامر الشراء.',
       'FINANCE',
       78,
       'Y', 'N', 'N'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_modules WHERE module_code = 'AP');

UPDATE prod.dct_modules
   SET module_name_en = 'Accounts Payable',
       module_name_ar = 'الحسابات الدائنة',
       apex_app_id    = 212,
       icon_class     = 'fa-file-invoice-dollar',
       icon_color     = '#8E3B5C',
       bg_color       = '#F4E9EE',
       category       = 'FINANCE',
       is_active      = 'Y'
 WHERE module_code = 'AP';

COMMIT;

PROMPT === verification -- expect one AP row with readable Arabic ===
SELECT module_id, module_code, module_name_en, module_name_ar, apex_app_id
  FROM prod.dct_modules WHERE module_code = 'AP';
