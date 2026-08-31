SET PAGESIZE 100
SET LINESIZE 220
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT === Warning table ===
SELECT owner, table_name FROM all_tables
 WHERE owner='PROD' AND table_name='ATD_LOAD_ROW_WARNING';

PROMPT === Warning columns ===
SELECT column_name, data_type FROM all_tab_columns
 WHERE owner='PROD' AND table_name='ATD_LOAD_ROW_WARNING'
 ORDER BY column_id;

PROMPT === ORDS run-detail handler ===
SELECT t.uri_template, h.method
  FROM user_ords_modules m
  JOIN user_ords_templates t ON t.module_id=m.id
  JOIN user_ords_handlers h ON h.template_id=t.id
 WHERE m.name='atd.rest' AND t.uri_template='runs/:id' AND h.method='GET';

PROMPT === Invalid objects ===
SELECT object_name, object_type, status FROM all_objects
 WHERE owner='PROD' AND status<>'VALID' AND object_name LIKE 'ATD%';

EXIT
