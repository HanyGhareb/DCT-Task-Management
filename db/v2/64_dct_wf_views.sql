SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 64_dct_wf_views.sql
-- i-Finance Workflow Platform (DWP) -- the union views
-- Schema  : PROD (run as ADMIN with schema-qualified names)
--
-- THREE views, all read-only, all additive, all safe to deploy while every
-- module is still on LEGACY. The WF leg of each returns ZERO rows today.
--
--   DCT_WF_INBOX_V   one worklist across both engines (requirement 4).
--                    Eligibility is materialised AS ROWS -- one row per
--                    (request x eligible user) -- so every inbox handler
--                    collapses to  WHERE user_id = :me  on an index.
--                    This is what retires the FIVE near-duplicate inbox
--                    queries in /dct, /pc, /dt, /cc and /fl.
--
--   DCT_WF_CHAIN_V   the endorsement chain of a request, either engine.
--                    reporting/db/22 (FL Termsheet PDF) currently hard-joins
--                    the legacy approval tables -- an UNDOCUMENTED consumer
--                    that would silently render an EMPTY chain the day
--                    FL_CONTRACT migrates. This view is what it moves onto,
--                    while that is still a pure refactor.
--
--   DCT_WF_PARITY_V  for every live PENDING legacy request, what the legacy
--                    engine decided vs what the new engine decided in shadow.
--                    Zero rows until shadow mode. Every disagreement is either
--                    a bug in the new engine or an undocumented behaviour of
--                    the old one -- and you want to know which BEFORE cutover.
--
-- FAITHFULNESS -- DCT_WF_INBOX_V's legacy leg is a LIFT of the live handler in
-- db/v2/11c_dct_inbox_step_approvers.sql, not a re-derivation. Two deliberate
-- choices keep it honest:
--   * role eligibility joins V_DCT_USER_ACTIVE_ROLES -- the SAME view
--     dct_auth.get_user_roles reads. The handler does an INSTR against that
--     function's CSV output; joining the view means "active role" has ONE
--     definition platform-wide and cannot drift.
--   * the INNER join to dct_users on submitted_by is KEPT, because the handler
--     has it. It means a request whose submitter is not a DCT user is invisible
--     in the inbox. That is today's behaviour; parity first, fix separately.
--     (Checked on PROD: no PENDING instance has a NULL submitted_by, so this
--     hides nothing right now -- but the FL Portal has no DCT user, so it will
--     matter the moment a portal-submitted request needs approving.)
--
-- Additive. Creates no table, alters nothing, and cannot change behaviour until
-- a handler is repointed at it (that is 66).
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- union views ===

PROMPT
PROMPT --- [1/3] DCT_WF_INBOX_V -- the one worklist ---

CREATE OR REPLACE VIEW prod.dct_wf_inbox_v AS
WITH inst AS (
    -- every PENDING legacy request, resolved to the step it is sitting on
    SELECT ai.instance_id,
           ai.template_id,
           ai.source_module,
           ai.source_record_id,
           ai.source_record_ref,
           ai.submitted_at,
           ai.submitted_by,
           ai.current_step_seq,
           ai.dynamic_approver_user_id,
           t.template_name,
           t.module_id,
           ast.step_id,
           ast.step_name,
           ast.step_type,
           ast.required_role_id
      FROM prod.dct_approval_instances ai
      JOIN prod.dct_approval_templates t
        ON t.template_id = ai.template_id
      JOIN prod.dct_approval_steps ast
        ON ast.template_id = ai.template_id
       AND ast.step_seq    = ai.current_step_seq
     WHERE ai.overall_status = 'PENDING'
),
elig AS (
    -- ---- (a) a holder of the step's role -------------------------------
    -- ... but NOT on a USER_SPECIFIC step that has a named approver stamped:
    -- that is the whole point of db/v2/11c. Role holders are the FAIL-OPEN
    -- path, used only when nobody is named.
    SELECT i.instance_id,
           uar.user_id,
           'ROLE'      AS via,
           1           AS prio,
           CAST(NULL AS NUMBER) AS acting_for_uid
      FROM inst i
      JOIN prod.v_dct_user_active_roles uar
        ON uar.role_id = i.required_role_id
     WHERE (i.step_type != 'USER_SPECIFIC'
            OR NOT EXISTS (SELECT 1 FROM prod.dct_fl_instance_approvers fx
                            WHERE fx.instance_id = i.instance_id
                              AND fx.step_seq    = i.current_step_seq))

    UNION ALL
    -- ---- (b) SYS_ADMIN sees everything ---------------------------------
    SELECT i.instance_id, uar.user_id, 'SYS_ADMIN', 1, CAST(NULL AS NUMBER)
      FROM inst i
      JOIN prod.v_dct_user_active_roles uar
        ON uar.role_code = 'SYS_ADMIN'

    UNION ALL
    -- ---- (c) the instance-level dynamic approver (legacy line manager) ---
    SELECT i.instance_id, i.dynamic_approver_user_id, 'DYNAMIC', 1, CAST(NULL AS NUMBER)
      FROM inst i
     WHERE i.step_type = 'USER_SPECIFIC'
       AND i.dynamic_approver_user_id IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM prod.dct_fl_instance_approvers fx2
                        WHERE fx2.instance_id = i.instance_id
                          AND fx2.step_seq    = i.current_step_seq)

    UNION ALL
    -- ---- (d) the per-step NAMED approver (FL Contract phase 2) ----------
    SELECT i.instance_id, fia.user_id, 'NAMED', 1, CAST(NULL AS NUMBER)
      FROM inst i
      JOIN prod.dct_fl_instance_approvers fia
        ON fia.instance_id = i.instance_id
       AND fia.step_seq    = i.current_step_seq
     WHERE i.step_type = 'USER_SPECIFIC'

    UNION ALL
    -- ---- (e) a delegate of someone who holds the step's role ------------
    SELECT i.instance_id, dg.delegate_id, 'DELEGATE', 2, dg.delegator_id
      FROM inst i
      JOIN prod.dct_delegations dg
        ON dg.status = 'ACTIVE'
       AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
       AND (dg.scope = 'ALL_ROLES'
            OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id   = i.required_role_id)
            OR (dg.scope = 'MODULE'        AND dg.module_id = i.module_id))
      JOIN prod.dct_user_roles ur2
        ON ur2.user_id   = dg.delegator_id
       AND ur2.role_id   = i.required_role_id
       AND ur2.is_active = 'Y'
),
elig1 AS (
    -- one row per (request, user). Holding the role OUTRANKS being a delegate,
    -- so a user who is both sees the request as THEIRS, with no "acting for"
    -- badge -- which is exactly what the handler's CASE does.
    SELECT e.instance_id, e.user_id, e.via, e.acting_for_uid,
           ROW_NUMBER() OVER (PARTITION BY e.instance_id, e.user_id
                              ORDER BY e.prio, e.acting_for_uid DESC) AS rn
      FROM elig e
     WHERE e.user_id IS NOT NULL
)
SELECT
       'LEGACY'                       AS engine,
       i.instance_id                  AS id,            -- the router key
       i.instance_id                  AS instance_id,
       e.user_id                      AS user_id,
       e.via                          AS via,
       i.source_module                AS source_module,
       i.source_record_id             AS source_record_id,
       NVL(i.source_record_ref, '-')  AS request_ref,
       NVL(i.template_name, '-')      AS template_name,
       NVL(sub.display_name, '-')     AS requested_by,
       i.submitted_at                 AS submitted_at,
       NVL(CASE i.source_module
             WHEN 'PETTY_CASH'       THEN (SELECT amount            FROM prod.dct_petty_cash            WHERE pc_id            = i.source_record_id)
             WHEN 'REIMBURSEMENT'    THEN (SELECT amount            FROM prod.dct_pc_reimbursements     WHERE reimb_id         = i.source_record_id)
             WHEN 'CLEARING'         THEN (SELECT amount_spent      FROM prod.dct_pc_clearing           WHERE clearing_id      = i.source_record_id)
             WHEN 'TRAVEL_REQUEST'   THEN (SELECT total_advance_aed FROM prod.dt_requests               WHERE request_id       = i.source_record_id)
             WHEN 'SETTLEMENT'       THEN (SELECT total_actual_aed  FROM prod.dt_settlement             WHERE settlement_id    = i.source_record_id)
             WHEN 'FL_CONTRACT'      THEN (SELECT total_amount      FROM prod.dct_fl_contracts          WHERE contract_id      = i.source_record_id)
             WHEN 'FL_AMENDMENT'     THEN (SELECT new_total_amount  FROM prod.dct_fl_contract_amendments WHERE amendment_id    = i.source_record_id)
             WHEN 'FL_VOUCHER'       THEN (SELECT amount            FROM prod.dct_fl_payment_vouchers   WHERE voucher_id       = i.source_record_id)
             WHEN 'FL_RENEWAL'       THEN (SELECT new_total_amount  FROM prod.dct_fl_contract_renewals  WHERE renewal_id       = i.source_record_id)
             WHEN 'CC_REQUEST'       THEN (SELECT requested_limit   FROM prod.dct_cc_requests           WHERE request_id       = i.source_record_id)
             WHEN 'CC_REPLENISHMENT' THEN (SELECT total_amount      FROM prod.dct_cc_replenishments     WHERE replenishment_id = i.source_record_id)
           END, 0)                    AS amount,
       CAST(NULL AS VARCHAR2(3))      AS currency,
       NVL((SELECT COUNT(*) FROM prod.dct_approval_steps s3
             WHERE s3.template_id = i.template_id
               AND s3.step_seq   <= i.current_step_seq), 1) AS current_step,
       NVL((SELECT COUNT(*) FROM prod.dct_approval_steps s2
             WHERE s2.template_id = i.template_id), 1)      AS total_steps,
       NVL(i.step_name, '-')          AS current_step_name,
       af.display_name                AS acting_for,
       CAST(NULL AS TIMESTAMP)        AS due_at,
       CAST(NULL AS VARCHAR2(40))     AS outcome_set_code
  FROM elig1 e
  JOIN inst  i   ON i.instance_id = e.instance_id
  JOIN prod.dct_users sub ON sub.user_id = i.submitted_by
  LEFT JOIN prod.dct_users af ON af.user_id = e.acting_for_uid
 WHERE e.rn = 1

UNION ALL

-- ---------------------------------------------------------------------------
-- the WF leg. Zero rows until a module is routed to the new engine. Note the
-- eligibility fan-out is ALREADY a table here (dct_wf_task_participant), which
-- is the whole reason the new engine's worklist is one index range scan.
-- ---------------------------------------------------------------------------
SELECT
       'WF'                           AS engine,
       t.task_id                      AS id,            -- >= 900,000,000: cannot
       t.instance_id                  AS instance_id,   -- collide with a legacy id
       tp.user_id                     AS user_id,
       tp.via                         AS via,
       wi.source_module               AS source_module,
       wi.source_record_id            AS source_record_id,
       NVL(t.source_record_ref, '-')  AS request_ref,
       NVL(p.name_en, '-')            AS template_name,
       NVL(t.requester_name, '-')     AS requested_by,
       wi.started_at                  AS submitted_at,
       NVL(t.amount, 0)               AS amount,
       t.currency                     AS currency,
       NVL((SELECT COUNT(*) FROM prod.dct_wf_step_instance si2
             WHERE si2.instance_id = t.instance_id
               AND si2.status IN ('SATISFIED', 'SKIPPED')), 0) + 1 AS current_step,
       NVL((SELECT COUNT(*) FROM prod.dct_wf_step s2
             WHERE s2.version_id = wi.version_id), 1)              AS total_steps,
       NVL(t.subject_en, '-')         AS current_step_name,
       dl.display_name                AS acting_for,
       t.due_at                       AS due_at,
       os.set_code                    AS outcome_set_code
  FROM prod.dct_wf_task t
  JOIN prod.dct_wf_task_participant tp
    ON tp.task_id          = t.task_id
   AND tp.is_active        = 'Y'
   AND tp.participant_type = 'POTENTIAL_OWNER'
  JOIN prod.dct_wf_instance wi      ON wi.instance_id      = t.instance_id
  JOIN prod.dct_wf_process  p       ON p.process_id        = wi.process_id
  JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
  JOIN prod.dct_wf_step     s       ON s.step_id           = si.step_id
  LEFT JOIN prod.dct_wf_outcome_set os ON os.set_id = s.outcome_set_id
  LEFT JOIN prod.dct_users dl
    ON tp.via = 'DELEGATE'
   AND dl.user_id = TO_NUMBER(REGEXP_SUBSTR(tp.via_ref, '^\d+$'))
 WHERE t.state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED')
   AND wi.status IN ('RUNNING', 'WAITING')
   -- ONLY surface WF tasks for a module that is ACTUALLY routed to the new engine.
   -- This is load-bearing, for two reasons:
   --   1. SHADOW MODE. A shadow run creates real WF instances and real tasks while the
   --      legacy engine is still authoritative. Without this join those tasks would show
   --      up in people's worklists and get actioned -- shadow mode would not be a shadow.
   --   2. ROLLBACK. Flipping dct_wf_route back to LEGACY instantly hides every WF task,
   --      with no deploy. In-flight WF instances keep their state and reappear the moment
   --      the route is flipped forward again.
   -- It also guarantees an un-migrated module's action handler can NEVER be handed a
   -- task_id it does not know how to route (PC/DT still own their legacy POST bodies).
   AND EXISTS (SELECT 1 FROM prod.dct_wf_route rt
                WHERE rt.source_module = wi.source_module
                  AND rt.engine        = 'WF');

PROMPT
PROMPT --- [2/3] DCT_WF_CHAIN_V -- the endorsement chain, either engine ---

CREATE OR REPLACE VIEW prod.dct_wf_chain_v AS
WITH leg_inst AS (
    SELECT ai.instance_id, ai.template_id, ai.source_module, ai.source_record_id,
           ai.overall_status, ai.current_step_seq, ai.dynamic_approver_user_id,
           ai.submitted_at,
           ROW_NUMBER() OVER (PARTITION BY ai.source_module, ai.source_record_id
                              ORDER BY ai.submitted_at DESC, ai.instance_id DESC) AS rn
      FROM prod.dct_approval_instances ai
),
leg_act AS (
    -- the LAST action recorded on each step
    SELECT aa.instance_id, aa.step_id, aa.action, aa.comments,
           aa.actioned_at, aa.actioned_by,
           ROW_NUMBER() OVER (PARTITION BY aa.instance_id, aa.step_id
                              ORDER BY aa.actioned_at DESC, aa.action_id DESC) AS rn
      FROM prod.dct_approval_actions aa
)
SELECT 'LEGACY'                      AS engine,
       i.source_module               AS source_module,
       i.source_record_id            AS source_record_id,
       i.instance_id                 AS instance_id,
       CASE WHEN i.rn = 1 THEN 'Y' ELSE 'N' END AS is_current,
       st.step_seq                   AS step_seq,
       TO_CHAR(st.step_seq)          AS step_key,
       st.step_name                  AS step_name,
       -- who is/was being asked: a stamped name beats the instance-level dynamic
       -- approver, which beats the step's role. Lifted from reporting/db/22.
       CASE WHEN nu.display_name IS NOT NULL       THEN nu.display_name
            WHEN st.step_type = 'USER_SPECIFIC'    THEN NVL(du.display_name, 'Line Manager')
            ELSE NVL(ro.role_name_en, '-')
       END                           AS approver,
       CASE WHEN a.action IS NOT NULL THEN a.action
            WHEN i.overall_status = 'PENDING' AND st.step_seq = i.current_step_seq THEN 'PENDING'
            WHEN i.overall_status = 'PENDING' AND st.step_seq > i.current_step_seq THEN 'WAITING'
            ELSE '-'
       END                           AS status,
       ua.display_name               AS actioned_by,
       a.actioned_at                 AS actioned_at,
       a.comments                    AS comments
  FROM leg_inst i
  JOIN prod.dct_approval_steps st ON st.template_id = i.template_id
  LEFT JOIN prod.dct_roles ro     ON ro.role_id     = st.required_role_id
  LEFT JOIN prod.dct_fl_instance_approvers fia
         ON fia.instance_id = i.instance_id
        AND fia.step_seq    = st.step_seq
  LEFT JOIN prod.dct_users nu ON nu.user_id = fia.user_id
  LEFT JOIN prod.dct_users du ON du.user_id = i.dynamic_approver_user_id
  LEFT JOIN leg_act a ON a.instance_id = i.instance_id
                     AND a.step_id     = st.step_id
                     AND a.rn          = 1
  LEFT JOIN prod.dct_users ua ON ua.user_id = a.actioned_by

UNION ALL

-- The WF leg records the REAL outcome -- 'ENDORSE', not 'APPROVED'. That is the
-- point of the whole platform, and it is why the termsheet must read this view
-- rather than dct_approval_actions.
SELECT 'WF',
       wi.source_module,
       wi.source_record_id,
       wi.instance_id,
       CASE WHEN ROW_NUMBER() OVER (PARTITION BY wi.source_module, wi.source_record_id
                                    ORDER BY wi.started_at DESC, wi.instance_id DESC) = 1
            THEN 'Y' ELSE 'N' END,
       s.step_seq,
       s.step_key,
       s.name_en,
       NVL((SELECT LISTAGG(u2.display_name, ', ')
                     WITHIN GROUP (ORDER BY u2.display_name)
              FROM prod.dct_wf_task t2
              JOIN prod.dct_users u2 ON u2.user_id = t2.assignee_user_id
             WHERE t2.step_instance_id = si.step_instance_id), '-'),
       CASE si.status
            WHEN 'SATISFIED' THEN NVL((SELECT MAX(t3.outcome_code) FROM prod.dct_wf_task t3
                                        WHERE t3.step_instance_id = si.step_instance_id
                                          AND t3.outcome_code IS NOT NULL), 'APPROVED')
            WHEN 'SKIPPED'   THEN 'SKIPPED'
            WHEN 'ACTIVE'    THEN 'PENDING'
            WHEN 'PENDING'   THEN 'WAITING'
            WHEN 'REJECTED'  THEN 'REJECTED'
            ELSE si.status
       END,
       (SELECT MAX(u3.display_name) FROM prod.dct_wf_task t4
          JOIN prod.dct_users u3 ON u3.user_id = t4.outcome_by
         WHERE t4.step_instance_id = si.step_instance_id),
       (SELECT MAX(t5.outcome_at) FROM prod.dct_wf_task t5
         WHERE t5.step_instance_id = si.step_instance_id),
       (SELECT MAX(TO_CHAR(SUBSTR(t6.comments, 1, 2000))) FROM prod.dct_wf_task t6
         WHERE t6.step_instance_id = si.step_instance_id)
  FROM prod.dct_wf_instance wi
  JOIN prod.dct_wf_step_instance si ON si.instance_id = wi.instance_id
  JOIN prod.dct_wf_step s           ON s.step_id      = si.step_id
 WHERE si.status <> 'CANCELLED';

PROMPT
PROMPT --- [3/3] DCT_WF_PARITY_V -- shadow-mode disagreement report ---

-- For every live PENDING legacy request that ALSO has a shadow WF instance,
-- what did each engine decide? Read-only, zero production risk, zero rows until
-- shadow mode starts. Run it against live traffic for two weeks before cutting
-- anything over: every disagreement is either a bug in the new engine or an
-- undocumented behaviour of the old one, and you want to know which one BEFORE.

CREATE OR REPLACE VIEW prod.dct_wf_parity_v AS
SELECT ai.source_module,
       ai.source_record_id,
       ai.source_record_ref,
       ai.instance_id                  AS legacy_instance_id,
       wi.instance_id                  AS wf_instance_id,
       ai.overall_status               AS legacy_status,
       wi.status                       AS wf_status,
       ast.step_name                   AS legacy_step,
       (SELECT MIN(s.name_en)
          FROM prod.dct_wf_step_instance si
          JOIN prod.dct_wf_step s ON s.step_id = si.step_id
         WHERE si.instance_id = wi.instance_id
           AND si.status = 'ACTIVE')   AS wf_step,
       CASE
           WHEN ai.overall_status = 'PENDING' AND wi.status NOT IN ('RUNNING','WAITING')
                THEN 'STATUS DRIFT: legacy still pending, WF is ' || wi.status
           WHEN ai.overall_status <> 'PENDING' AND wi.status IN ('RUNNING','WAITING')
                THEN 'STATUS DRIFT: legacy is ' || ai.overall_status || ', WF still running'
           WHEN NVL(ast.step_name, '~') <> NVL((SELECT MIN(s.name_en)
                                                  FROM prod.dct_wf_step_instance si
                                                  JOIN prod.dct_wf_step s ON s.step_id = si.step_id
                                                 WHERE si.instance_id = wi.instance_id
                                                   AND si.status = 'ACTIVE'), '~')
                THEN 'STEP DRIFT: the two engines are asking different people'
           ELSE 'AGREE'
       END                             AS verdict
  FROM prod.dct_approval_instances ai
  JOIN prod.dct_wf_instance wi
    ON wi.source_module    = ai.source_module
   AND wi.source_record_id = ai.source_record_id
  LEFT JOIN prod.dct_approval_steps ast
    ON ast.template_id = ai.template_id
   AND ast.step_seq    = ai.current_step_seq;

PROMPT
PROMPT === views done -- verifying ===

SELECT view_name, status FROM all_objects o
  JOIN (SELECT 'DCT_WF_INBOX_V' AS view_name FROM dual
        UNION ALL SELECT 'DCT_WF_CHAIN_V' FROM dual
        UNION ALL SELECT 'DCT_WF_PARITY_V' FROM dual) v
    ON o.object_name = v.view_name
 WHERE o.owner = 'PROD' AND o.object_type = 'VIEW'
 ORDER BY view_name;

PROMPT
PROMPT --- the WF legs must be EMPTY (nothing is routed to the new engine yet) ---

SELECT engine, COUNT(*) AS rows_ FROM prod.dct_wf_inbox_v GROUP BY engine ORDER BY engine;

SELECT COUNT(*) AS parity_rows FROM prod.dct_wf_parity_v;
