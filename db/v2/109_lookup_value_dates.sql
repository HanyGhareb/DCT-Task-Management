-- =============================================================================
-- i-Finance -- Platform lookup values: bilingual descriptions + effective dates
-- File   : 109_lookup_value_dates.sql
-- Schema : PROD objects (run as ADMIN in a fresh session; objects prefixed prod.)
-- Why    : KPI-V2 Settings -> Manage Lookups needs per-value description EN/AR
--          plus start/end effective dates (user decision 2026-07-28: extend the
--          shared platform lookup store, not a private KPI table).
-- Impact : additive columns only. Every existing handler names its columns
--          (SELECT lists in db/v2/11 + module ORDS scripts), so nothing else
--          changes behaviour. Ends with a recompile sweep -- the column adds
--          invalidate dependent package bodies and the deploy must finish at
--          0 INVALID as it started.
-- Rerun  : safe -- each column/constraint is added only when missing.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT == 1. additive columns on prod.dct_lookup_values ==

DECLARE
    PROCEDURE add_col(p_name VARCHAR2, p_spec VARCHAR2) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM all_tab_columns
         WHERE owner = 'PROD' AND table_name = 'DCT_LOOKUP_VALUES'
           AND column_name = UPPER(p_name);
        IF n = 0 THEN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_lookup_values ADD (' || p_name || ' ' || p_spec || ')';
            DBMS_OUTPUT.PUT_LINE('.. added column ' || p_name);
        ELSE
            DBMS_OUTPUT.PUT_LINE('.. column ' || p_name || ' already present');
        END IF;
    END;
BEGIN
    add_col('description_en', 'VARCHAR2(1000 CHAR)');
    add_col('description_ar', 'VARCHAR2(1000 CHAR)');
    add_col('start_date',     'DATE');
    add_col('end_date',       'DATE');
END;
/

PROMPT == 2. date-order guard (nullable-friendly) ==

DECLARE
    n NUMBER;
BEGIN
    SELECT COUNT(*) INTO n FROM all_constraints
     WHERE owner = 'PROD' AND table_name = 'DCT_LOOKUP_VALUES'
       AND constraint_name = 'CHK_DCT_LVAL_DATES';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_lookup_values ADD CONSTRAINT chk_dct_lval_dates ' ||
                          'CHECK (start_date IS NULL OR end_date IS NULL OR end_date >= start_date)';
        DBMS_OUTPUT.PUT_LINE('.. constraint chk_dct_lval_dates added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('.. constraint chk_dct_lval_dates already present');
    END IF;
END;
/

PROMPT == 3. recompile sweep (dependents invalidated by the column adds) ==

DECLARE
    l_left NUMBER := 0;
BEGIN
    FOR pass IN 1 .. 3 LOOP
        FOR r IN (SELECT object_name, object_type
                    FROM all_objects
                   WHERE owner = 'PROD' AND status = 'INVALID'
                   ORDER BY CASE object_type
                                WHEN 'PACKAGE'      THEN 1
                                WHEN 'VIEW'         THEN 2
                                WHEN 'PACKAGE BODY' THEN 3
                                ELSE 4 END) LOOP
            BEGIN
                IF r.object_type = 'PACKAGE BODY' THEN
                    EXECUTE IMMEDIATE 'ALTER PACKAGE prod."' || r.object_name || '" COMPILE BODY';
                ELSIF r.object_type = 'PACKAGE' THEN
                    EXECUTE IMMEDIATE 'ALTER PACKAGE prod."' || r.object_name || '" COMPILE';
                ELSIF r.object_type = 'VIEW' THEN
                    EXECUTE IMMEDIATE 'ALTER VIEW prod."' || r.object_name || '" COMPILE';
                ELSIF r.object_type = 'PROCEDURE' THEN
                    EXECUTE IMMEDIATE 'ALTER PROCEDURE prod."' || r.object_name || '" COMPILE';
                ELSIF r.object_type = 'FUNCTION' THEN
                    EXECUTE IMMEDIATE 'ALTER FUNCTION prod."' || r.object_name || '" COMPILE';
                ELSIF r.object_type = 'TRIGGER' THEN
                    EXECUTE IMMEDIATE 'ALTER TRIGGER prod."' || r.object_name || '" COMPILE';
                END IF;
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END LOOP;
    END LOOP;
    SELECT COUNT(*) INTO l_left FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID';
    DBMS_OUTPUT.PUT_LINE('.. invalid objects remaining in PROD: ' || l_left);
END;
/

PROMPT == 4. verification ==
SELECT column_name, data_type
  FROM all_tab_columns
 WHERE owner = 'PROD' AND table_name = 'DCT_LOOKUP_VALUES'
   AND column_name IN ('DESCRIPTION_EN','DESCRIPTION_AR','START_DATE','END_DATE')
 ORDER BY column_id;

SELECT COUNT(*) AS invalid_in_prod FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID';
