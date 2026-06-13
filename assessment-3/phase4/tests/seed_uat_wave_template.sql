-- =============================================================================
-- UAT seed: disposable approval template for the Wave UAT lifecycle cases
-- (clone as draft, edit draft steps, activate). Engines resolve templates by
-- exact code, so UAT_WAVE_FLOW is inert for real approvals.
-- Idempotent: skipped when an ACTIVE UAT_WAVE_FLOW row already exists.
-- Run: sql -name prod_mcp @seed_uat_wave_template.sql   (fresh session)
-- =============================================================================
SET DEFINE OFF
WHENEVER SQLERROR CONTINUE

DECLARE
  l_cnt  NUMBER;
  l_tid  NUMBER;
  l_role NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_cnt
  FROM   prod.dct_approval_templates
  WHERE  template_code = 'UAT_WAVE_FLOW' AND is_active = 'Y';
  IF l_cnt > 0 THEN
    DBMS_OUTPUT.put_line('UAT_WAVE_FLOW already active - seed skipped');
    RETURN;
  END IF;

  INSERT INTO prod.dct_approval_templates (
    template_code, template_name, template_name_ar, request_type,
    description_en, is_sequential, is_active, created_by)
  VALUES (
    'UAT_WAVE_FLOW', 'UAT Wave Test Flow', NULL, 'UAT_TEST',
    'Disposable template used only by the automated Wave UAT (clone/edit/activate). Safe to delete.',
    'Y', 'Y', 'UAT_SEED')
  RETURNING template_id INTO l_tid;

  SELECT role_id INTO l_role
  FROM prod.dct_roles WHERE role_code = 'MANAGER' AND ROWNUM = 1;
  INSERT INTO prod.dct_approval_steps (
    template_id, step_seq, step_name, step_type, required_role_id,
    escalation_days, created_by)
  VALUES (l_tid, 1, 'UAT Line Manager Review', 'ROLE_BASED', l_role, 2, 'UAT_SEED');

  SELECT role_id INTO l_role
  FROM prod.dct_roles WHERE role_code = 'SYS_ADMIN' AND ROWNUM = 1;
  INSERT INTO prod.dct_approval_steps (
    template_id, step_seq, step_name, step_type, required_role_id,
    escalation_days, created_by)
  VALUES (l_tid, 2, 'UAT Final Approval', 'ROLE_BASED', l_role, 3, 'UAT_SEED');

  COMMIT;
  DBMS_OUTPUT.put_line('UAT_WAVE_FLOW seeded, template_id=' || l_tid);
END;
/

SET SERVEROUTPUT ON
SELECT template_id, template_code, is_active, version_no, parent_template_id
FROM   prod.dct_approval_templates
WHERE  template_code LIKE 'UAT_WAVE_FLOW%'
ORDER  BY template_id;
