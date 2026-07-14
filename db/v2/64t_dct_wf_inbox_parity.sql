SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 64t_dct_wf_inbox_parity.sql
-- Proves DCT_WF_INBOX_V returns EXACTLY what the live inbox handler returns.
-- Schema  : PROD (run as ADMIN).  READ-ONLY -- writes nothing, anywhere.
--
-- This is the gate for repointing /dct/approvals/pending at the view. The view
-- is supposed to be a LIFT of db/v2/11c's cursor, not an improvement of it. So
-- the test runs BOTH -- the handler's own query, verbatim, and the view -- for
-- EVERY active user, and asserts the two sets are identical: same instances,
-- same acting-for badge, same amount, same step name, same counts.
--
-- A difference here is not a "nice to know". It means repointing the handler
-- would silently change who can approve what, which is the single most dangerous
-- thing this whole programme could do. Any drift => STOP.
-- =============================================================================

PROMPT === inbox parity: the view vs the live handler ===

DECLARE
    g_pass  PLS_INTEGER := 0;
    g_fail  PLS_INTEGER := 0;
    g_users PLS_INTEGER := 0;
    g_rows  PLS_INTEGER := 0;

    PROCEDURE bad (p_what VARCHAR2) IS
    BEGIN
        g_fail := g_fail + 1;
        DBMS_OUTPUT.PUT_LINE('  FAIL  ' || p_what);
    END;
BEGIN
    FOR u IN (SELECT user_id, username, display_name
                FROM prod.dct_users
               WHERE is_active = 'Y'
               ORDER BY user_id)
    LOOP
        DECLARE
            l_uid    NUMBER        := u.user_id;
            l_roles  VARCHAR2(4000) := ',' || prod.dct_auth.get_user_roles(u.username) || ',';
            v_only_h PLS_INTEGER := 0;   -- handler says yes, view says no
            v_only_v PLS_INTEGER := 0;   -- view says yes, handler says no
            v_diff   PLS_INTEGER := 0;   -- both agree on the row, but a field differs
            v_n      PLS_INTEGER := 0;
        BEGIN
            g_users := g_users + 1;

            -- ---------------------------------------------------------------
            -- HANDLER: db/v2/11c_dct_inbox_step_approvers.sql, cursor verbatim,
            -- with the handler's own l_uid / l_roles bound in.
            -- ---------------------------------------------------------------
            WITH handler AS (
                SELECT ai.instance_id,
                       ast.step_name,
                       NVL(CASE ai.source_module
                         WHEN 'PETTY_CASH'      THEN (SELECT amount            FROM prod.dct_petty_cash            WHERE pc_id            = ai.source_record_id)
                         WHEN 'REIMBURSEMENT'   THEN (SELECT amount            FROM prod.dct_pc_reimbursements     WHERE reimb_id         = ai.source_record_id)
                         WHEN 'CLEARING'        THEN (SELECT amount_spent      FROM prod.dct_pc_clearing           WHERE clearing_id      = ai.source_record_id)
                         WHEN 'TRAVEL_REQUEST'  THEN (SELECT total_advance_aed FROM prod.dt_requests               WHERE request_id       = ai.source_record_id)
                         WHEN 'SETTLEMENT'      THEN (SELECT total_actual_aed  FROM prod.dt_settlement             WHERE settlement_id    = ai.source_record_id)
                         WHEN 'FL_CONTRACT'     THEN (SELECT total_amount      FROM prod.dct_fl_contracts          WHERE contract_id      = ai.source_record_id)
                         WHEN 'FL_AMENDMENT'    THEN (SELECT new_total_amount  FROM prod.dct_fl_contract_amendments WHERE amendment_id    = ai.source_record_id)
                         WHEN 'FL_VOUCHER'      THEN (SELECT amount            FROM prod.dct_fl_payment_vouchers   WHERE voucher_id       = ai.source_record_id)
                         WHEN 'FL_RENEWAL'      THEN (SELECT new_total_amount  FROM prod.dct_fl_contract_renewals  WHERE renewal_id       = ai.source_record_id)
                         WHEN 'CC_REQUEST'      THEN (SELECT requested_limit   FROM prod.dct_cc_requests           WHERE request_id       = ai.source_record_id)
                         WHEN 'CC_REPLENISHMENT' THEN (SELECT total_amount     FROM prod.dct_cc_replenishments     WHERE replenishment_id = ai.source_record_id)
                       END, 0) AS amount,
                       (SELECT COUNT(*) FROM prod.dct_approval_steps s2
                         WHERE s2.template_id = ai.template_id) AS total_steps,
                       (SELECT COUNT(*) FROM prod.dct_approval_steps s3
                         WHERE s3.template_id = ai.template_id
                           AND s3.step_seq   <= ai.current_step_seq) AS current_step,
                       CASE WHEN INSTR(l_roles, ',' || rol.role_code || ',') > 0
                              OR INSTR(l_roles, ',SYS_ADMIN,') > 0
                            THEN NULL
                            ELSE (SELECT MAX(du.display_name)
                                  FROM prod.dct_delegations dg
                                  JOIN prod.dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                                              AND ur2.role_id = rol.role_id
                                                              AND ur2.is_active = 'Y'
                                  JOIN prod.dct_users du ON du.user_id = dg.delegator_id
                                  WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                                    AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                                    AND (dg.scope = 'ALL_ROLES'
                                         OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                                         OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id)))
                       END AS acting_for
                FROM   prod.dct_approval_instances ai
                JOIN   prod.dct_approval_templates t   ON t.template_id   = ai.template_id
                JOIN   prod.dct_approval_steps     ast ON ast.template_id = ai.template_id
                                                      AND ast.step_seq    = ai.current_step_seq
                LEFT JOIN prod.dct_roles           rol ON rol.role_id     = ast.required_role_id
                JOIN   prod.dct_users              sub ON sub.user_id     = ai.submitted_by
                WHERE  ai.overall_status = 'PENDING'
                  AND ((INSTR(l_roles, ',' || rol.role_code || ',') > 0
                        AND (ast.step_type != 'USER_SPECIFIC'
                             OR NOT EXISTS (SELECT 1 FROM prod.dct_fl_instance_approvers fx
                                            WHERE fx.instance_id = ai.instance_id
                                              AND fx.step_seq    = ai.current_step_seq)))
                       OR INSTR(l_roles, ',SYS_ADMIN,') > 0
                       OR (ast.step_type = 'USER_SPECIFIC' AND ai.dynamic_approver_user_id = l_uid
                           AND NOT EXISTS (SELECT 1 FROM prod.dct_fl_instance_approvers fx2
                                           WHERE fx2.instance_id = ai.instance_id
                                             AND fx2.step_seq    = ai.current_step_seq))
                       OR (ast.step_type = 'USER_SPECIFIC' AND EXISTS (
                             SELECT 1 FROM prod.dct_fl_instance_approvers fia
                             WHERE fia.instance_id = ai.instance_id
                               AND fia.step_seq    = ai.current_step_seq
                               AND fia.user_id     = l_uid))
                       OR EXISTS (
                            SELECT 1 FROM prod.dct_delegations dg
                            JOIN prod.dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                                        AND ur2.role_id = rol.role_id
                                                        AND ur2.is_active = 'Y'
                            WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                              AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                              AND (dg.scope = 'ALL_ROLES'
                                   OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                                   OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id))))
            ),
            vw AS (
                SELECT instance_id, current_step_name AS step_name, amount,
                       total_steps, current_step, acting_for
                  FROM prod.dct_wf_inbox_v
                 WHERE user_id = l_uid
                   AND engine  = 'LEGACY'
            )
            SELECT
                (SELECT COUNT(*) FROM (SELECT instance_id FROM handler
                                       MINUS SELECT instance_id FROM vw)),
                (SELECT COUNT(*) FROM (SELECT instance_id FROM vw
                                       MINUS SELECT instance_id FROM handler)),
                (SELECT COUNT(*) FROM handler h JOIN vw v ON v.instance_id = h.instance_id
                  WHERE NVL(TO_CHAR(h.amount), '~')      != NVL(TO_CHAR(v.amount), '~')
                     OR NVL(h.step_name, '~')            != NVL(v.step_name, '~')
                     OR NVL(TO_CHAR(h.total_steps), '~') != NVL(TO_CHAR(v.total_steps), '~')
                     OR NVL(TO_CHAR(h.current_step), '~')!= NVL(TO_CHAR(v.current_step), '~')
                     OR NVL(h.acting_for, '~')           != NVL(v.acting_for, '~')),
                (SELECT COUNT(*) FROM handler)
            INTO v_only_h, v_only_v, v_diff, v_n
            FROM dual;

            g_rows := g_rows + v_n;

            IF v_only_h = 0 AND v_only_v = 0 AND v_diff = 0 THEN
                g_pass := g_pass + 1;
                IF v_n > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  pass  ' || RPAD(u.username, 22)
                                      || LPAD(v_n, 3) || ' request(s) -- identical');
                END IF;
            ELSE
                bad(u.username || ': handler-only=' || v_only_h
                               || ' view-only=' || v_only_v
                               || ' field-diff=' || v_diff);
            END IF;
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=====================================================');
    DBMS_OUTPUT.PUT_LINE('  users compared    : ' || g_users);
    DBMS_OUTPUT.PUT_LINE('  inbox rows matched: ' || g_rows);
    DBMS_OUTPUT.PUT_LINE('  users identical   : ' || g_pass);
    DBMS_OUTPUT.PUT_LINE('  users DIFFERING   : ' || g_fail);
    DBMS_OUTPUT.PUT_LINE('=====================================================');

    IF g_fail > 0 THEN
        raise_application_error(-20999,
            g_fail || ' user(s) see a DIFFERENT inbox through the view. '
                   || 'Do NOT repoint the handler.');
    END IF;
    IF g_rows = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  WARNING: zero inbox rows on either side -- this test proved nothing.');
    END IF;
END;
/

PROMPT
PROMPT --- who currently sees what (the live worklist, through the new view) ---

SELECT u.username,
       v.engine,
       v.source_module,
       v.request_ref,
       v.current_step_name,
       v.via,
       NVL(v.acting_for, '-') AS acting_for
  FROM prod.dct_wf_inbox_v v
  JOIN prod.dct_users u ON u.user_id = v.user_id
 ORDER BY u.username, v.instance_id;
