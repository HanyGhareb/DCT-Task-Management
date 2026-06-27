-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Arabic label repair
-- File    : 16_fl_ar_fix.sql
-- Schema  : PROD
-- Run     : After 14_fl_reg_seed.sql. Idempotent. Own SQLcl session.
-- Purpose : Re-set the Arabic names of the Phase-1 lookup sets + the line-manager
--           approval step using UNISTR code points (pure ASCII source), because
--           SQLcl read the original UTF-8 seed files as cp1252 and stored mojibake.
--           UNISTR is encoding-independent so this is correct regardless of how
--           SQLcl reads the file.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- Category names
UPDATE prod.dct_lookup_categories SET category_name_ar = UNISTR('\062D\0627\0644\0629\0020\0627\0644\062A\0643\0631\0627\0631') WHERE category_code='FL_DUP_STATUS';
UPDATE prod.dct_lookup_categories SET category_name_ar = UNISTR('\062D\0627\0644\0629\0020\0627\0644\0627\0633\062A\062E\0631\0627\062C') WHERE category_code='FL_EXTRACT_STATUS';
UPDATE prod.dct_lookup_categories SET category_name_ar = UNISTR('\062D\0627\0644\0629\0020\0631\0645\0632\0020\0627\0644\062A\062D\0642\0642') WHERE category_code='FL_OTP_STATUS';

-- FL_DUP_STATUS values
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0644\0627\0020\064A\0648\062C\062F\0020\062A\0643\0631\0627\0631') WHERE value_code='NONE'       AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_DUP_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0628\062D\0627\062C\0629\0020\0644\0645\0631\0627\062C\0639\0629') WHERE value_code='REVIEW'     AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_DUP_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\062A\0645\0020\0627\0644\062A\062C\0627\0648\0632') WHERE value_code='OVERRIDDEN' AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_DUP_STATUS');

-- FL_EXTRACT_STATUS values
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0642\064A\062F\0020\0627\0644\0627\0646\062A\0638\0627\0631') WHERE value_code='PENDING' AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_EXTRACT_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\062A\0645') WHERE value_code='DONE' AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_EXTRACT_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0641\0634\0644') WHERE value_code='FAILED' AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_EXTRACT_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\062A\0645\0020\0627\0644\062A\0637\0628\064A\0642') WHERE value_code='APPLIED' AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_EXTRACT_STATUS');

-- FL_OTP_STATUS values
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0642\064A\062F\0020\0627\0644\0627\0646\062A\0638\0627\0631') WHERE value_code='PENDING'  AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_OTP_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\062A\0645\0020\0627\0644\062A\062D\0642\0642') WHERE value_code='VERIFIED' AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_OTP_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0645\0646\062A\0647\064A') WHERE value_code='EXPIRED'  AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_OTP_STATUS');
UPDATE prod.dct_lookup_values SET value_name_ar = UNISTR('\0645\0642\0641\0644') WHERE value_code='LOCKED'   AND category_id=(SELECT category_id FROM prod.dct_lookup_categories WHERE category_code='FL_OTP_STATUS');

-- Line-manager approval step name
UPDATE prod.dct_approval_steps SET step_name_ar = UNISTR('\0627\0639\062A\0645\0627\062F\0020\0627\0644\0645\062F\064A\0631\0020\0627\0644\0645\0628\0627\0634\0631')
WHERE step_seq=5 AND template_id=(SELECT template_id FROM prod.dct_approval_templates WHERE template_code='FL_REGISTRATION_APPROVAL');

COMMIT;
PROMPT === 16_fl_ar_fix.sql complete ===
