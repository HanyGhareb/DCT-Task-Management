SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 61_dct_wf_seed.sql
-- i-Finance Workflow Platform (DWP) -- Phase 0 -- reference data
-- Schema  : PROD (run as ADMIN with schema-qualified names)
--
-- Seeds the outcome vocabulary that delivers requirement 2 (custom outcomes:
-- Endorse / Agree / Disagree / FYI / Return-for-info), the routing table (every
-- module still on LEGACY -- nothing is switched on by this script), and the
-- UAE business calendar.
--
-- Arabic is written with UNISTR only -- never paste raw Arabic into a .sql file
-- (see db/v2/25_fix_arabic_encoding.sql for why).
--
-- Idempotent. Uses guarded INSERTs, NOT merge -- Linux SQLcl silently swallows
-- merge-bearing blocks (see memory: sqlcl invocation gotchas).
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- reference data ===

PROMPT
PROMPT --- [1/4] outcome sets ---

DECLARE
    v_set NUMBER;

    FUNCTION set_of(p_code IN VARCHAR2) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        SELECT set_id INTO v FROM prod.dct_wf_outcome_set WHERE set_code = p_code;
        RETURN v;
    END;

    PROCEDURE mk_set(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_wf_outcome_set WHERE set_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_wf_outcome_set (set_code, name_en, name_ar, is_system)
            VALUES (p_code, p_en, p_ar, 'Y');
            DBMS_OUTPUT.PUT_LINE('  set    ' || p_code);
        END IF;
    END;

    PROCEDURE mk_out(p_set VARCHAR2, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                     p_sem VARCHAR2, p_quorum VARCHAR2 DEFAULT 'Y',
                     p_pos VARCHAR2 DEFAULT 'Y', p_cmt VARCHAR2 DEFAULT 'N',
                     p_color VARCHAR2 DEFAULT NULL, p_ord NUMBER DEFAULT 10) IS
        v   NUMBER;
        sid NUMBER := set_of(p_set);
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_wf_outcome
         WHERE set_id = sid AND outcome_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_wf_outcome
                (set_id, outcome_code, label_en, label_ar, semantic,
                 counts_toward_quorum, is_positive, requires_comment, color, display_order)
            VALUES (sid, p_code, p_en, p_ar, p_sem, p_quorum, p_pos, p_cmt, p_color, p_ord);
            DBMS_OUTPUT.PUT_LINE('    out  ' || p_set || '.' || p_code || ' -> ' || p_sem);
        END IF;
    END;
BEGIN
    -- Arabic labels via UNISTR
    mk_set('APPROVE_REJECT',        'Approve or Reject',   UNISTR('\0645\0648\0627\0641\0642\0629 \0623\0648 \0631\0641\0636'));
    mk_set('APPROVE_REJECT_RETURN', 'Approve / Reject / Return', UNISTR('\0645\0648\0627\0641\0642\0629 / \0631\0641\0636 / \0625\0639\0627\062F\0629'));
    mk_set('ENDORSE_SET',           'Endorsement',         UNISTR('\062A\0632\0643\064A\0629'));
    mk_set('AGREE_DISAGREE',        'Agree or Disagree',   UNISTR('\0645\0648\0627\0641\0642 \0623\0648 \063A\064A\0631 \0645\0648\0627\0641\0642'));
    mk_set('FYI_ACK',               'For Information',     UNISTR('\0644\0644\0639\0644\0645'));
    mk_set('REVIEW_SET',            'Review',              UNISTR('\0645\0631\0627\062C\0639\0629'));

    -- APPROVE_REJECT
    mk_out('APPROVE_REJECT','APPROVE','Approve', UNISTR('\0645\0648\0627\0641\0642\0629'), 'ADVANCE','Y','Y','N','success',10);
    mk_out('APPROVE_REJECT','REJECT', 'Reject',  UNISTR('\0631\0641\0636'),               'REJECT', 'Y','N','Y','danger', 20);

    -- APPROVE_REJECT_RETURN
    mk_out('APPROVE_REJECT_RETURN','APPROVE','Approve', UNISTR('\0645\0648\0627\0641\0642\0629'), 'ADVANCE','Y','Y','N','success',10);
    mk_out('APPROVE_REJECT_RETURN','RETURN', 'Return',  UNISTR('\0625\0639\0627\062F\0629'),      'RETURN_TO_INITIATOR','Y','N','Y','warning',20);
    mk_out('APPROVE_REJECT_RETURN','REJECT', 'Reject',  UNISTR('\0631\0641\0636'),                'REJECT','Y','N','Y','danger',30);

    -- ENDORSE_SET -- the step the business already calls "Endorsement" but the
    -- legacy engine could only record as APPROVED.
    mk_out('ENDORSE_SET','ENDORSE',         'Endorse',          UNISTR('\062A\0632\0643\064A\0629'), 'ADVANCE','Y','Y','N','success',10);
    mk_out('ENDORSE_SET','RETURN_FOR_INFO', 'Return for Info',  UNISTR('\0625\0639\0627\062F\0629 \0644\0644\0627\0633\062A\064A\0636\0627\062D'), 'RETURN_TO_STEP','Y','N','Y','warning',20);
    mk_out('ENDORSE_SET','REJECT',          'Reject',           UNISTR('\0631\0641\0636'),           'REJECT','Y','N','Y','danger',30);

    -- AGREE_DISAGREE
    mk_out('AGREE_DISAGREE','AGREE',    'Agree',    UNISTR('\0645\0648\0627\0641\0642'),                        'ADVANCE','Y','Y','N','success',10);
    mk_out('AGREE_DISAGREE','DISAGREE', 'Disagree', UNISTR('\063A\064A\0631 \0645\0648\0627\0641\0642'),        'REJECT', 'Y','N','Y','danger', 20);

    -- FYI_ACK -- informed but NOT blocking: NOOP + counts_toward_quorum = N
    mk_out('FYI_ACK','FYI_ACK','Acknowledge', UNISTR('\0625\0642\0631\0627\0631 \0628\0627\0644\0639\0644\0645'), 'NOOP','N','Y','N','info',10);

    -- REVIEW_SET
    mk_out('REVIEW_SET','REVIEWED',       'Reviewed',        UNISTR('\062A\0645\062A \0627\0644\0645\0631\0627\062C\0639\0629'), 'ADVANCE','Y','Y','N','success',10);
    mk_out('REVIEW_SET','RETURN_FOR_INFO','Return for Info', UNISTR('\0625\0639\0627\062F\0629 \0644\0644\0627\0633\062A\064A\0636\0627\062D'), 'RETURN_TO_STEP','Y','N','Y','warning',20);
END;
/

PROMPT
PROMPT --- [2/4] routing table -- every module stays on LEGACY ---

DECLARE
    TYPE t_mods IS TABLE OF VARCHAR2(40);
    v_mods t_mods := t_mods(
        'PETTY_CASH','REIMBURSEMENT','CLEARING',
        'TRAVEL_REQUEST','SETTLEMENT',
        'CC_REQUEST','CC_REPLENISHMENT',
        'FL_REGISTRATION','FL_CONTRACT','FL_AMENDMENT',
        'FL_VOUCHER','FL_RENEWAL','FL_PROFILE_CHANGE');
    v NUMBER;
BEGIN
    FOR i IN 1 .. v_mods.COUNT LOOP
        SELECT COUNT(*) INTO v FROM prod.dct_wf_route WHERE source_module = v_mods(i);
        IF v = 0 THEN
            INSERT INTO prod.dct_wf_route (source_module, engine, changed_by)
            VALUES (v_mods(i), 'LEGACY', 'SEED');
            DBMS_OUTPUT.PUT_LINE('  route  ' || v_mods(i) || ' -> LEGACY');
        END IF;
    END LOOP;
END;
/

PROMPT
PROMPT --- [3/4] business calendar (UAE: Mon-Fri, Sat-Sun weekend) ---

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_wf_calendar WHERE calendar_code = 'UAE';
    IF v = 0 THEN
        INSERT INTO prod.dct_wf_calendar
            (calendar_code, name_en, name_ar, work_days, day_start_hr, day_end_hr)
        VALUES ('UAE', 'UAE Working Week',
                UNISTR('\0623\0633\0628\0648\0639 \0627\0644\0639\0645\0644'),
                'MON,TUE,WED,THU,FRI', 8, 16);
        DBMS_OUTPUT.PUT_LINE('  calendar UAE');
    END IF;
END;
/

PROMPT
PROMPT --- [4/4] verify ---

SELECT s.set_code,
       o.outcome_code,
       o.semantic,
       o.counts_toward_quorum AS quorum,
       o.label_en
  FROM prod.dct_wf_outcome_set s
  JOIN prod.dct_wf_outcome o ON o.set_id = s.set_id
 ORDER BY s.set_code, o.display_order;

SELECT engine, COUNT(*) AS modules FROM prod.dct_wf_route GROUP BY engine;

COMMIT;
