-- =============================================================================
-- Correct the Operations Center schema-capacity threshold.
-- PROD was already above the legacy 2 GB application warning while DATA had
-- 11.55 GB usable capacity. 8 GB is a conservative warning point and leaves
-- roughly 3.3 GB reserve at the capacity measured on 2026-09-03.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_description VARCHAR2(500) :=
    'Warn when the PROD schema approaches the conservative 8 GB application allocation within DATA.';
BEGIN
  UPDATE prod.dct_system_settings
     SET setting_value='8192',
         value_type='NUMBER',
         category='DATA_MAINTENANCE',
         description_en=l_description,
         is_system='Y',
         updated_at=SYSTIMESTAMP,
         updated_by='SYSTEM'
   WHERE setting_key='OPS_SCHEMA_WARNING_MB';
  IF SQL%ROWCOUNT=0 THEN
    INSERT INTO prod.dct_system_settings
      (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
    VALUES
      ('OPS_SCHEMA_WARNING_MB','8192','NUMBER','DATA_MAINTENANCE',l_description,'Y','SYSTEM');
  END IF;
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  RAISE;
END;
/

SELECT setting_key,setting_value,description_en
  FROM prod.dct_system_settings
 WHERE setting_key='OPS_SCHEMA_WARNING_MB';

SELECT tablespace_name,
       ROUND(tablespace_size*block_size/1024/1024,2) size_mb,
       ROUND(used_space*block_size/1024/1024,2) used_mb,
       ROUND(used_percent,2) used_pct
  FROM dba_tablespace_usage_metrics
 WHERE tablespace_name='DATA';

PROMPT db/v2/128 Operations Center schema capacity complete.
EXIT
