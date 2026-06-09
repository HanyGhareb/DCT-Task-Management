-- Patch: Replace CHK_DCT_GRADE_CAT check constraint with a lookup category
-- Run via: sql -name prod_mcp @patch_grade_category_lookup.sql

SET DEFINE OFF
SET FEEDBACK ON

-- 1. Drop the hardcoded check constraint
ALTER TABLE prod.dct_employee_grades DROP CONSTRAINT chk_dct_grade_cat;

-- 2. Insert the lookup category
INSERT INTO prod.dct_lookup_categories (
    category_code, category_name_en, category_name_ar,
    module_id, is_system, is_active,
    created_by, created_at, updated_by, updated_at
) VALUES (
    'HR_GRADE_CATEGORY', 'Grade Category', 'تصنيف الدرجة',
    5, 'N', 'Y',
    SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
    SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP
);

-- 3. Insert the four grade category lookup values
DECLARE
    v_cat_id NUMBER;
BEGIN
    SELECT category_id INTO v_cat_id
    FROM prod.dct_lookup_categories
    WHERE category_code = 'HR_GRADE_CATEGORY';

    INSERT INTO prod.dct_lookup_values (
        category_id, value_code, value_name_en, value_name_ar,
        display_order, is_active, created_by, created_at, updated_by, updated_at
    ) VALUES (v_cat_id, 'SUPPORT',      'Support',      'دعم',         10, 'Y',
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP);

    INSERT INTO prod.dct_lookup_values (
        category_id, value_code, value_name_en, value_name_ar,
        display_order, is_active, created_by, created_at, updated_by, updated_at
    ) VALUES (v_cat_id, 'TECHNICAL',    'Technical',    'تقني',        20, 'Y',
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP);

    INSERT INTO prod.dct_lookup_values (
        category_id, value_code, value_name_en, value_name_ar,
        display_order, is_active, created_by, created_at, updated_by, updated_at
    ) VALUES (v_cat_id, 'PROFESSIONAL', 'Professional', 'مهني',        30, 'Y',
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP);

    INSERT INTO prod.dct_lookup_values (
        category_id, value_code, value_name_en, value_name_ar,
        display_order, is_active, created_by, created_at, updated_by, updated_at
    ) VALUES (v_cat_id, 'EXECUTIVE',    'Executive',    'تنفيذي',      40, 'Y',
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP,
        SYS_CONTEXT('USERENV','SESSION_USER'), SYSTIMESTAMP);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('HR_GRADE_CATEGORY seeded with 4 values.');
END;
/

-- Verify
SELECT lv.value_code, lv.value_name_en, lv.display_order
FROM   prod.dct_lookup_values lv
JOIN   prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
WHERE  lc.category_code = 'HR_GRADE_CATEGORY'
ORDER  BY lv.display_order;

EXIT
