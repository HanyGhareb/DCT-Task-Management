-- =============================================================================
-- i-Finance — Targeted approval lookup indexes
-- Supports approval history, source-record lookup, and pending-status searches.
-- Additive and rerunnable. Run as ADMIN: sql -name prod_mcp @73_dct_approval_indexes.sql
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
  PROCEDURE ensure_index(p_name VARCHAR2, p_ddl VARCHAR2) IS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_count FROM dba_indexes
     WHERE owner='PROD' AND index_name=UPPER(p_name);
    IF l_count=0 THEN
      EXECUTE IMMEDIATE p_ddl;
      DBMS_OUTPUT.PUT_LINE('Created '||p_name);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exists  '||p_name);
    END IF;
  END;
BEGIN
  ensure_index('IX_DCT_APPACT_INST',
    'CREATE INDEX prod.ix_dct_appact_inst ON prod.dct_approval_actions(instance_id, actioned_at)');
  ensure_index('IX_DCT_APPINST_SOURCE',
    'CREATE INDEX prod.ix_dct_appinst_source ON prod.dct_approval_instances(source_module, source_record_id, overall_status)');
  ensure_index('IX_DCT_APPINST_STATUS',
    'CREATE INDEX prod.ix_dct_appinst_status ON prod.dct_approval_instances(overall_status, current_step_seq)');
END;
/

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS('PROD','DCT_APPROVAL_ACTIONS',
    estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE,
    no_invalidate=>DBMS_STATS.AUTO_INVALIDATE);
  DBMS_STATS.GATHER_TABLE_STATS('PROD','DCT_APPROVAL_INSTANCES',
    estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=>TRUE,
    no_invalidate=>DBMS_STATS.AUTO_INVALIDATE);
END;
/

SELECT i.index_name, i.table_name, i.status,
       LISTAGG(c.column_name,',') WITHIN GROUP (ORDER BY c.column_position) columns_list
  FROM dba_ind_columns c JOIN dba_indexes i
    ON i.owner=c.index_owner AND i.index_name=c.index_name
 WHERE i.owner='PROD' AND i.index_name IN
   ('IX_DCT_APPACT_INST','IX_DCT_APPINST_SOURCE','IX_DCT_APPINST_STATUS')
 GROUP BY i.index_name,i.table_name,i.status ORDER BY i.index_name;

PROMPT db/v2/73 targeted approval indexes complete.
EXIT
