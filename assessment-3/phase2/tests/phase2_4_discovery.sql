SET DEFINE OFF
SET PAGESIZE 200
SET LINESIZE 200
SET LONG 4000
PROMPT === Tables with natural-key coding columns ===
SELECT table_name, column_name, data_type, data_length
FROM   all_tab_columns
WHERE  owner='PROD' AND column_name IN ('PROJECT_NUMBER','TASK_NUMBER','EXPENDITURE_TYPE')
ORDER  BY table_name, column_name;
PROMPT === dct_fl_bank_accounts columns ===
SELECT column_name, data_type, data_length FROM all_tab_columns
WHERE owner='PROD' AND table_name='DCT_FL_BANK_ACCOUNTS' ORDER BY column_id;
PROMPT === dct_bank_codes PK column ===
SELECT column_name, data_type, data_length FROM all_tab_columns
WHERE owner='PROD' AND table_name='DCT_BANK_CODES' ORDER BY column_id;
PROMPT === CHECK constraints on PC/DT/FL tables (enum candidates) ===
COLUMN search_condition_vc FORMAT A120
SELECT table_name, constraint_name, search_condition_vc
FROM   all_constraints
WHERE  owner='PROD' AND constraint_type='C'
AND    (table_name LIKE 'DCT_PC%' OR table_name LIKE 'DT_%' OR table_name LIKE 'DCT_FL%' OR table_name='DCT_PETTY_CASH')
AND    search_condition_vc LIKE '%IN%(%'
ORDER  BY table_name, constraint_name;
exit
