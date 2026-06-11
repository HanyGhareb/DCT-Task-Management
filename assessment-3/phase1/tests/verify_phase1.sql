SET DEFINE OFF
SET PAGESIZE 100
SET LINESIZE 160
COLUMN object_name FORMAT A28
COLUMN object_type FORMAT A14
COLUMN status FORMAT A8
COLUMN job_name FORMAT A28
COLUMN state FORMAT A12
COLUMN name FORMAT A12
COLUMN uri_prefix FORMAT A10

PROMPT === 1. Package validity (PROD) ===
SELECT object_name, object_type, status
FROM   all_objects
WHERE  owner = 'PROD'
AND    object_name IN ('DCT_CC_PKG','DCT_APPROVAL_PKG','DCT_REST','DCT_PC_PKG','DCT_PC_AI_PKG')
ORDER  BY object_name, object_type;

PROMPT === 2. Scheduler jobs ===
SELECT job_name, enabled, state, TO_CHAR(next_run_date,'YYYY-MM-DD HH24:MI') AS next_run
FROM   all_scheduler_jobs
WHERE  owner = 'PROD'
AND    job_name IN ('JOB_CC_REPL_REMINDER','JOB_DCT_APPROVAL_SWEEP',
                    'JOB_DT_SET_TRAVELLED','JOB_DT_AUTO_CLOSE','JOB_DT_STL_ALERTS');

PROMPT === 3. ORDS modules (ADMIN schema) ===
SELECT name, uri_prefix, status, items_per_page
FROM   user_ords_modules
ORDER  BY name;

PROMPT === 4. New sequences ===
SELECT sequence_name, last_number
FROM   all_sequences
WHERE  sequence_owner = 'PROD'
AND    sequence_name IN ('SEQ_PC_NUMBER','SEQ_PC_REIMB_NUMBER','SEQ_PC_CLEAR_NUMBER',
                         'SEQ_CC_REQUEST_NUM','SEQ_CC_CARD_NUM','SEQ_CC_REIMB_NUM');

PROMPT === 5. Sweep dry-run: escalation candidates right now ===
SELECT COUNT(*) AS escalation_candidates
FROM   prod.dct_approval_instances ai
JOIN   prod.dct_approval_steps ast ON ast.template_id = ai.template_id
                                  AND ast.step_seq    = ai.current_step_seq
WHERE  ai.overall_status = 'PENDING'
AND    NVL(ast.escalation_days,0) > 0
AND    ast.escalate_role_id IS NOT NULL
AND    TRUNC(SYSDATE) - TRUNC(CAST(NVL(ai.last_action_at, ai.submitted_at) AS DATE)) >= ast.escalation_days;

PROMPT === 6. Sweep dry-run: auto-approve candidates right now ===
SELECT COUNT(*) AS auto_approve_candidates
FROM   prod.dct_approval_instances ai
JOIN   prod.dct_approval_templates at ON at.template_id = ai.template_id
WHERE  ai.overall_status = 'PENDING'
AND    NVL(at.auto_approve_days,0) > 0
AND    TRUNC(SYSDATE) - TRUNC(CAST(NVL(ai.last_action_at, ai.submitted_at) AS DATE)) >= at.auto_approve_days;

PROMPT === 7. CC package callable (read-only function) ===
SELECT prod.dct_cc_pkg.get_setting('BANK_NAME') AS cc_bank_name FROM dual;

PROMPT === 8. Smoke-test record final state ===
SELECT pc_id, pc_number, status, amount, purpose
FROM   prod.dct_petty_cash
WHERE  pc_number = 'PC-2026-00002';

exit
