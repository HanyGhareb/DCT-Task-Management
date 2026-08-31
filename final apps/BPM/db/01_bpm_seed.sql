SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

PROMPT === 01_bpm_seed.sql : Fusion BPM (App 214) module registration ===
PROMPT === BPM owns NO ORDS module of its own. The app is a console over ===
PROMPT === the two existing cross-module APIs: /ords/admin/wf (workflow ===
PROMPT === platform, gate-EXEMPT in db/v2/50) and /ords/admin/dct (the ===
PROMPT === shared Admin module, also exempt). Therefore: no db/v2/50 ===
PROMPT === CASE-map entry, no synonyms, no handlers. This one row makes ===
PROMPT === the app restrictable via Admin - Modules - Access and gives ===
PROMPT === it a settings home (THEME_BRAND_COLOR etc.). Rerunnable. ===

DECLARE
  v_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_n FROM prod.dct_modules WHERE module_code = 'BPM';
  IF v_n = 0 THEN
    INSERT INTO prod.dct_modules
           (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
            apex_page_id, icon_class, icon_color, bg_color,
            description_en, description_ar, category, display_order,
            is_active, is_new_tab, is_admin_only)
    VALUES ('BPM', 'Fusion BPM', UNISTR('\0625\062F\0627\0631\0629 \0633\064A\0631 \0627\0644\0639\0645\0644'), 'APEX_APP', 214,
            1, 'fa-diagram-project', '#7D3243', '#F5E7EA',
            'Workflow management: worklists, process design and approvals oversight',
            UNISTR('\0625\062F\0627\0631\0629 \0633\064A\0631 \0627\0644\0639\0645\0644: \0642\0648\0627\0626\0645 \0627\0644\0645\0647\0627\0645 \0648\062A\0635\0645\064A\0645 \0627\0644\0639\0645\0644\064A\0627\062A \0648\0627\0644\0627\0639\062A\0645\0627\062F\0627\062A'), 'CORE', 78, 'Y', 'N', 'N');
    DBMS_OUTPUT.PUT_LINE('BPM module row inserted');
  ELSE
    UPDATE prod.dct_modules
       SET module_name_en = 'Fusion BPM',
           module_name_ar = UNISTR('\0625\062F\0627\0631\0629 \0633\064A\0631 \0627\0644\0639\0645\0644'),
           apex_app_id    = 214,
           icon_color     = '#7D3243',
           bg_color       = '#F5E7EA',
           description_en = 'Workflow management: worklists, process design and approvals oversight',
           description_ar = UNISTR('\0625\062F\0627\0631\0629 \0633\064A\0631 \0627\0644\0639\0645\0644: \0642\0648\0627\0626\0645 \0627\0644\0645\0647\0627\0645 \0648\062A\0635\0645\064A\0645 \0627\0644\0639\0645\0644\064A\0627\062A \0648\0627\0644\0627\0639\062A\0645\0627\062F\0627\062A'),
           display_order  = 78,
           is_active      = 'Y'
     WHERE module_code = 'BPM';
    DBMS_OUTPUT.PUT_LINE('BPM module row updated');
  END IF;
  COMMIT;
END;
/

PROMPT === verify ===
SELECT module_id, module_code, module_name_en, apex_app_id, display_order, is_active
  FROM prod.dct_modules
 WHERE module_code = 'BPM';
