-- ===========================================================================
-- otbi-atd : 43 action type seed - PPM_TASK_ADDL_INFO
-- Second Fusion write-back action type: update a task's Additional
-- Information (Organization Reference cost centre) on a project's
-- financial plan (Manage Financial Project Plan). Queue/ORDS/UI are
-- generic over action_type, so this seed is the only DB change.
-- Rerunnable. Plain INSERT-if-absent (no MERGE blocks). CRLF, UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

INSERT INTO prod.dct_lookup_values
       (category_id, value_code, value_name_en, value_name_ar,
        display_order, is_default, is_active)
SELECT c.category_id, 'PPM_TASK_ADDL_INFO',
       'PPM Task Additional Info',
       N'معلومات إضافية لمهمة المشروع',
       20, 'N', 'Y'
  FROM prod.dct_lookup_categories c
 WHERE c.category_code = 'ATD_ACTION_TYPE'
   AND NOT EXISTS (SELECT 1 FROM prod.dct_lookup_values v
                    WHERE v.category_id = c.category_id
                      AND v.value_code  = 'PPM_TASK_ADDL_INFO')
/

UPDATE prod.dct_lookup_values v
   SET v.value_name_en = 'PPM Task Additional Info',
       v.display_order = 20,
       v.is_active     = 'Y'
 WHERE v.value_code = 'PPM_TASK_ADDL_INFO'
   AND v.category_id = (SELECT category_id FROM prod.dct_lookup_categories
                         WHERE category_code = 'ATD_ACTION_TYPE')
/

COMMIT
/

SELECT v.value_code, v.value_name_en, v.is_active
  FROM prod.dct_lookup_values v
  JOIN prod.dct_lookup_categories c ON c.category_id = v.category_id
 WHERE c.category_code = 'ATD_ACTION_TYPE'
 ORDER BY v.display_order
/

SET ECHO OFF
PROMPT otbi-atd 43 action type seed : done
