SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/112_dct_wf_cascade.sql
-- Approval-matrix cascade layer, part 1: DDL + seeds.
-- CONFIGURABLE LEVEL PRIORITY for role resolution: an FBP-style step checks
-- the levels in a configured order (default Task -> Project -> Cost Center ->
-- Sector; per-role override replaces the default wholesale) and the FIRST
-- level with an assignee wins. Read at approval time by the new
-- ASSIGNED_ROLE_CASCADE resolver (63 re-run) -- changing the order is a data
-- change that applies everywhere immediately.
-- Also: registry default fact paths (where each level's key lives in the
-- facts), the four new matrix DATA roles, and the user-confirmed cardinality
-- flips (FBP / PBP / AP Contact / Key Users = group; FBP-UH / Director single).
-- Idempotent. Deploy BEFORE re-running 63. Companion: 95 re-run (pkg), 113 API.

PROMPT === table: the priority config ===

DECLARE
    PROCEDURE mk (p_ddl IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_ddl;
        DBMS_OUTPUT.PUT_LINE('  created');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE IN (-955, -1408, -1430, -2260, -2275, -1442) THEN
            DBMS_OUTPUT.PUT_LINE('  exists, skipped');
        ELSE RAISE; END IF;
    END;
BEGIN
    mk(q'[CREATE TABLE prod.dct_wf_cascade_level (
        cascade_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        role_code        VARCHAR2(100),
        seq              NUMBER NOT NULL,
        object_type_code VARCHAR2(30) NOT NULL
                         REFERENCES prod.dct_wf_object_type(object_type_code),
        is_active        VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        created_by       VARCHAR2(100),
        created_at       TIMESTAMP DEFAULT SYSTIMESTAMP,
        updated_by       VARCHAR2(100),
        updated_at       TIMESTAMP,
        CONSTRAINT chk_wf_cl_act CHECK (is_active IN ('Y','N'))
    )]');

    -- one row per (scope, level): the same level cannot appear twice in a set
    mk('CREATE UNIQUE INDEX prod.uq_wf_cl_scope_type ON prod.dct_wf_cascade_level '
       || q'[(NVL(role_code,'#'), object_type_code)]');
    mk('CREATE INDEX prod.ix_wf_cl_role ON prod.dct_wf_cascade_level (role_code, is_active, seq)');
END;
/

PROMPT === registry: default fact paths per level ===

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM all_tab_columns
     WHERE owner = 'PROD' AND table_name = 'DCT_WF_OBJECT_TYPE'
       AND column_name = 'DEFAULT_FACT_PATH';
    IF v = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_wf_object_type ADD '
            || '(default_fact_path VARCHAR2(200), default_key2_fact_path VARCHAR2(200))';
        DBMS_OUTPUT.PUT_LINE('  fact-path columns added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  fact-path columns already present');
    END IF;
END;
/

-- the platform fact-field CONTRACT: a module's fact view exposes these names
-- and every cascade level lights up for free. (sector is derived in the fact
-- view from the cost center via the date-tracked class map.)
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.taskNumber',
       default_key2_fact_path = NULL   WHERE object_type_code = 'TASK';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.projectNumber'
                                    WHERE object_type_code = 'PROJECT';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.costCenter'
                                    WHERE object_type_code = 'COST_CENTER';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.sector'
                                    WHERE object_type_code = 'SECTOR';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.glAccount'
                                    WHERE object_type_code = 'GL_ACCOUNT';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.poHeaderId'
                                    WHERE object_type_code = 'PO';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.orgId'
                                    WHERE object_type_code IN ('DEPARTMENT','HR_ORG');
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.appropriation'
                                    WHERE object_type_code = 'APPROPRIATION';
UPDATE prod.dct_wf_object_type SET default_fact_path = '$.entity'
                                    WHERE object_type_code = 'ENTITY';
-- TASK is the one two-part key: project number rides as the first key
UPDATE prod.dct_wf_object_type
   SET default_fact_path = '$.projectNumber', default_key2_fact_path = '$.taskNumber'
 WHERE object_type_code = 'TASK';
COMMIT;

PROMPT === resolver enum: ASSIGNED_ROLE_CASCADE ===

DECLARE
    v_txt VARCHAR2(600);
BEGIN
    SELECT search_condition_vc INTO v_txt
      FROM all_constraints
     WHERE owner = 'PROD' AND constraint_name = 'CHK_WF_PR_RT';
    IF INSTR(v_txt, 'ASSIGNED_ROLE_CASCADE') = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_wf_participant_rule DROP CONSTRAINT chk_wf_pr_rt';
        EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_wf_participant_rule ADD CONSTRAINT chk_wf_pr_rt CHECK (resolver_type IN ('ROLE','ROLE_SCOPED_ORG','ORG_HEAD','LINE_MANAGER','FACT_LINE_MANAGER','FACT_USER','STATIC_USER','PREVIOUS_ACTOR','INITIATOR','ASSIGNED_ROLE','ASSIGNED_ROLE_CASCADE'))]';
        DBMS_OUTPUT.PUT_LINE('  chk_wf_pr_rt: ASSIGNED_ROLE_CASCADE added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  chk_wf_pr_rt: already allows ASSIGNED_ROLE_CASCADE');
    END IF;
END;
/

PROMPT === seeds: default priority + matrix roles + policy flips ===

DECLARE
    v NUMBER;
    PROCEDURE lvl (p_seq NUMBER, p_type VARCHAR2) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM prod.dct_wf_cascade_level
         WHERE role_code IS NULL AND object_type_code = p_type;
        IF n = 0 THEN
            INSERT INTO prod.dct_wf_cascade_level
                (role_code, seq, object_type_code, created_by)
            VALUES (NULL, p_seq, p_type, 'SEED');
        END IF;
    END;
    PROCEDURE ins_role (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_single VARCHAR2) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM prod.dct_roles WHERE role_code = p_code;
        IF n = 0 THEN
            INSERT INTO prod.dct_roles
                (role_code, role_name_en, role_name_ar, role_type,
                 is_system_role, is_active, created_by)
            VALUES (p_code, p_en, p_ar, 'DATA', 'N', 'Y', 'SEED');
        END IF;
        SELECT COUNT(*) INTO n FROM prod.dct_wf_role_policy WHERE role_code = p_code;
        IF n = 0 THEN
            INSERT INTO prod.dct_wf_role_policy (role_code, single_assignee)
            VALUES (p_code, p_single);
        END IF;
    END;
BEGIN
    -- default level priority: most specific first (user rule 2026-07-19)
    lvl(10, 'TASK');
    lvl(20, 'PROJECT');
    lvl(30, 'COST_CENTER');
    lvl(40, 'SECTOR');

    -- the four new approval-matrix roles
    ins_role('WF_FBP_UH',    'FBP Unit Head',
             UNISTR('\0631\0626\064A\0633 \0648\062D\062F\0629 \0634\0631\0643\0627\0621 \0627\0644\0623\0639\0645\0627\0644 \0627\0644\0645\0627\0644\064A\0629'), 'Y');
    ins_role('WF_AP_CONTACT', 'AP Contact',
             UNISTR('\0645\0646\0633\0642 \0627\0644\062D\0633\0627\0628\0627\062A \0627\0644\062F\0627\0626\0646\0629'), 'N');
    ins_role('WF_DIRECTOR',  'Director / ED',
             UNISTR('\0627\0644\0645\062F\064A\0631 \0627\0644\062A\0646\0641\064A\0630\064A'), 'Y');
    ins_role('WF_KEY_USER',  'Key User',
             UNISTR('\0645\0633\062A\062E\062F\0645 \0631\0626\064A\0633\064A'), 'N');

    -- user-confirmed cardinality flips: FBP + PBP allow MANY assignees
    UPDATE prod.dct_wf_role_policy SET single_assignee = 'N'
     WHERE role_code IN ('WF_FBP', 'WF_PBP') AND single_assignee = 'Y';
    DBMS_OUTPUT.PUT_LINE('  policy flips applied: ' || SQL%ROWCOUNT);
    COMMIT;
END;
/

PROMPT === ADMIN synonym ===
CREATE OR REPLACE SYNONYM dct_wf_cascade_level FOR prod.dct_wf_cascade_level;

PROMPT === recompile sweep (ALTER TABLE invalidates dependents) ===
BEGIN
    FOR r IN (SELECT object_name, object_type FROM all_objects
               WHERE owner = 'PROD' AND status = 'INVALID') LOOP
        BEGIN
            IF r.object_type = 'PACKAGE BODY' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || r.object_name || ' COMPILE BODY';
            ELSIF r.object_type = 'VIEW' THEN
                EXECUTE IMMEDIATE 'ALTER VIEW prod.' || r.object_name || ' COMPILE';
            ELSE
                EXECUTE IMMEDIATE 'ALTER ' || r.object_type || ' prod.' || r.object_name || ' COMPILE';
            END IF;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
END;
/

PROMPT === verify ===
SELECT NVL(role_code, '(default)') AS scope, seq, object_type_code
  FROM prod.dct_wf_cascade_level ORDER BY 1, 2;
SELECT ro.role_code, NVL(p.single_assignee, '?') AS single_assignee
  FROM prod.dct_roles ro LEFT JOIN prod.dct_wf_role_policy p ON p.role_code = ro.role_code
 WHERE ro.role_type = 'DATA' ORDER BY 1;
SELECT COUNT(*) AS invalid_objects FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID';

EXIT
