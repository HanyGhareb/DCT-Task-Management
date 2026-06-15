-- =============================================================================
-- Task Management Module (App 207) -- Read views for ORDS GET handlers
-- File    : 02_tm_views.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @02_tm_views.sql   (after 01_tm_ddl.sql)
-- Notes   : One read path per resource. Display/name fields coalesced so the
--           JET layer can bind them directly. Dates left raw; ORDS formats to
--           Asia/Dubai. Counts/roll-ups computed via scalar subqueries.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---- Teams (with leader, org, counts, health) -------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_team_v AS
SELECT t.team_id, t.team_code, t.team_name_en, t.team_name_ar, t.objective, t.purpose,
       t.team_type, t.team_class, t.team_category, t.status, t.health_rag,
       t.leader_user_id, lu.display_name AS leader_name,
       t.org_id, o.org_name_en AS org_name,
       t.start_date, t.end_date, t.is_active, t.created_at, t.updated_at,
       (SELECT COUNT(*) FROM prod.dct_tm_members m WHERE m.team_id = t.team_id AND m.is_active = 'Y') AS member_count,
       (SELECT COUNT(*) FROM prod.dct_tm_objectives ob WHERE ob.team_id = t.team_id) AS objective_count,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = t.team_id) AS task_count,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = t.team_id AND tk.status = 'DONE') AS task_done_count,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = t.team_id
               AND tk.due_date < TRUNC(SYSDATE) AND tk.status NOT IN ('DONE','CANCELLED')) AS task_overdue_count,
       (SELECT COUNT(*) FROM prod.dct_tm_deliverables d WHERE d.team_id = t.team_id) AS deliverable_count,
       (SELECT COUNT(*) FROM prod.dct_tm_log_items l WHERE l.team_id = t.team_id
               AND l.item_type IN ('ISSUE','RISK') AND l.status = 'OPEN') AS open_risk_count
FROM   prod.dct_tm_teams t
LEFT JOIN prod.dct_users lu        ON lu.user_id = t.leader_user_id
LEFT JOIN prod.dct_organizations o ON o.org_id   = t.org_id;

-- ---- Members (with user + role) ---------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_member_v AS
SELECT m.member_id, m.team_id, m.user_id,
       u.display_name AS member_name, u.email AS member_email, u.username,
       m.tm_role_id, r.role_code, r.role_name_en AS role_name, r.role_name_ar, r.is_leader_role,
       m.title, m.join_date, m.leave_date, m.is_active, m.created_at
FROM   prod.dct_tm_members m
JOIN   prod.dct_users    u ON u.user_id    = m.user_id
JOIN   prod.dct_tm_roles r ON r.tm_role_id = m.tm_role_id;

-- ---- Objectives (with owner + task + key-result roll-up) --------------------
CREATE OR REPLACE VIEW prod.dct_tm_objective_v AS
SELECT ob.objective_id, ob.team_id, ob.title_en, ob.title_ar, ob.description,
       ob.owner_user_id, ou.display_name AS owner_name,
       ob.weight, ob.progress_pct, ob.progress_mode, ob.target_date, ob.status, ob.display_order,
       ob.created_at, ob.updated_at,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.objective_id = ob.objective_id) AS task_count,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.objective_id = ob.objective_id AND tk.status = 'DONE') AS task_done_count,
       (SELECT COUNT(*) FROM prod.dct_tm_key_results kr WHERE kr.objective_id = ob.objective_id) AS kr_count,
       (SELECT COUNT(*) FROM prod.dct_tm_key_results kr WHERE kr.objective_id = ob.objective_id AND kr.status = 'ACHIEVED') AS kr_achieved_count
FROM   prod.dct_tm_objectives ob
LEFT JOIN prod.dct_users ou ON ou.user_id = ob.owner_user_id;

-- ---- Key Results (measurable targets per objective; progress computed 0-100) -
CREATE OR REPLACE VIEW prod.dct_tm_key_result_v AS
SELECT kr.kr_id, kr.objective_id, ob.team_id, ob.title_en AS objective_title,
       kr.title_en, kr.title_ar, kr.unit, kr.direction,
       kr.baseline_value, kr.target_value, kr.current_value,
       kr.weight, kr.target_date, kr.status, kr.display_order,
       kr.created_at, kr.updated_at,
       ROUND(
         GREATEST(0, LEAST(100,
           CASE kr.direction
             WHEN 'DECREASE' THEN
               (NVL(kr.baseline_value,0) - NVL(kr.current_value, kr.baseline_value))
               / NULLIF(NVL(kr.baseline_value,0) - kr.target_value, 0) * 100
             WHEN 'MAINTAIN' THEN
               CASE WHEN NVL(kr.current_value,0) >= kr.target_value THEN 100
                    ELSE NVL(kr.current_value,0) / NULLIF(kr.target_value,0) * 100 END
             ELSE  -- INCREASE
               (NVL(kr.current_value, kr.baseline_value) - NVL(kr.baseline_value,0))
               / NULLIF(kr.target_value - NVL(kr.baseline_value,0), 0) * 100
           END
         )), 1) AS progress_pct
FROM   prod.dct_tm_key_results kr
JOIN   prod.dct_tm_objectives ob ON ob.objective_id = kr.objective_id;

-- ---- Tasks (with objective, team, assignee names) ---------------------------
CREATE OR REPLACE VIEW prod.dct_tm_task_v AS
SELECT tk.task_id, tk.task_code, tk.team_id, te.team_name_en AS team_name,
       tk.objective_id, ob.title_en AS objective_title,
       tk.parent_task_id, tk.title, tk.description, tk.priority, tk.status,
       tk.progress_pct, tk.start_date, tk.due_date, tk.completed_date,
       tk.est_hours, tk.actual_hours, tk.is_recurring,
       CASE WHEN tk.due_date < TRUNC(SYSDATE) AND tk.status NOT IN ('DONE','CANCELLED') THEN 'Y' ELSE 'N' END AS is_overdue,
       (SELECT LISTAGG(au.display_name, ', ') WITHIN GROUP (ORDER BY au.display_name)
        FROM prod.dct_tm_task_assignees a JOIN prod.dct_users au ON au.user_id = a.user_id
        WHERE a.task_id = tk.task_id) AS assignees,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks c WHERE c.parent_task_id = tk.task_id) AS subtask_count,
       tk.created_at, tk.updated_at
FROM   prod.dct_tm_tasks tk
JOIN   prod.dct_tm_teams te ON te.team_id = tk.team_id
LEFT JOIN prod.dct_tm_objectives ob ON ob.objective_id = tk.objective_id;

-- ---- My Work: one row per (task, assignee) for cross-team personal board -----
CREATE OR REPLACE VIEW prod.dct_tm_my_task_v AS
SELECT a.user_id, tk.task_id, tk.task_code, tk.team_id, te.team_name_en AS team_name,
       tk.title, tk.priority, tk.status, tk.progress_pct, tk.due_date, a.is_primary,
       CASE WHEN tk.due_date < TRUNC(SYSDATE) AND tk.status NOT IN ('DONE','CANCELLED') THEN 'Y' ELSE 'N' END AS is_overdue,
       tk.objective_id, ob.title_en AS objective_title
FROM   prod.dct_tm_task_assignees a
JOIN   prod.dct_tm_tasks tk ON tk.task_id = a.task_id
JOIN   prod.dct_tm_teams te ON te.team_id = tk.team_id
LEFT JOIN prod.dct_tm_objectives ob ON ob.objective_id = tk.objective_id;

-- ---- Deliverables -----------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_deliverable_v AS
SELECT d.deliverable_id, d.deliverable_code, d.team_id, te.team_name_en AS team_name,
       d.objective_id, ob.title_en AS objective_title, d.milestone_id,
       d.title_en, d.title_ar, d.description,
       d.owner_user_id, ou.display_name AS owner_name,
       d.deliverable_type, d.status, d.progress_pct,
       d.due_date, d.submitted_date, d.accepted_date, d.acceptance_criteria, d.rejection_reason,
       CASE WHEN d.due_date < TRUNC(SYSDATE) AND d.status NOT IN ('ACCEPTED') THEN 'Y' ELSE 'N' END AS is_overdue,
       d.created_at, d.updated_at
FROM   prod.dct_tm_deliverables d
JOIN   prod.dct_tm_teams te ON te.team_id = d.team_id
LEFT JOIN prod.dct_tm_objectives ob ON ob.objective_id = d.objective_id
LEFT JOIN prod.dct_users ou ON ou.user_id = d.owner_user_id;

-- ---- RAID log ---------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_log_v AS
SELECT l.log_id, l.log_code, l.team_id, te.team_name_en AS team_name,
       l.objective_id, l.task_id, l.item_type, l.title, l.description,
       l.owner_user_id, ou.display_name AS owner_name,
       l.severity, l.likelihood, l.impact, l.status, l.mitigation,
       l.due_date, l.resolved_date, l.created_at, l.updated_at
FROM   prod.dct_tm_log_items l
JOIN   prod.dct_tm_teams te ON te.team_id = l.team_id
LEFT JOIN prod.dct_users ou ON ou.user_id = l.owner_user_id;

-- ---- Milestones -------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_milestone_v AS
SELECT ms.milestone_id, ms.team_id, te.team_name_en AS team_name,
       ms.objective_id, ob.title_en AS objective_title,
       ms.title_en, ms.title_ar, ms.description, ms.due_date, ms.achieved_date,
       ms.status, ms.display_order, ms.created_at
FROM   prod.dct_tm_milestones ms
JOIN   prod.dct_tm_teams te ON te.team_id = ms.team_id
LEFT JOIN prod.dct_tm_objectives ob ON ob.objective_id = ms.objective_id;

-- ---- Meetings ---------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_meeting_v AS
SELECT mt.meeting_id, mt.meeting_code, mt.team_id, te.team_name_en AS team_name,
       mt.title, mt.meeting_date, mt.location, mt.agenda, mt.minutes, mt.attendees,
       mt.status, mt.created_at, mt.updated_at
FROM   prod.dct_tm_meetings mt
JOIN   prod.dct_tm_teams te ON te.team_id = mt.team_id;

-- ---- Task activity feed -----------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_task_update_v AS
SELECT up.update_id, up.task_id, up.update_type, up.body, up.old_status, up.new_status,
       up.progress_pct, up.mentions, up.created_by_id, cu.display_name AS author_name,
       up.created_at
FROM   prod.dct_tm_task_updates up
LEFT JOIN prod.dct_users cu ON cu.user_id = up.created_by_id;

-- ---- Effective role-permission matrix (template default + per-team override) -
CREATE OR REPLACE VIEW prod.dct_tm_role_perm_v AS
SELECT r.tm_role_id, r.role_code, r.role_name_en, p.team_id, p.artifact_type,
       p.can_create, p.can_read, p.can_update, p.can_delete
FROM   prod.dct_tm_roles r
JOIN   prod.dct_tm_role_perms p ON p.tm_role_id = r.tm_role_id;

-- ---- Documents library (TM-scoped slice of unified DCT_DOCUMENTS) ------------
CREATE OR REPLACE VIEW prod.dct_tm_document_v AS
SELECT d.doc_id, d.source_type, d.source_id, d.reference_id,
       d.doc_type_id, dt.doc_type_name_en AS doc_type_name,
       d.file_name, d.mime_type, d.file_size_bytes, d.expiry_date, d.status,
       d.notes, d.created_by, cu.display_name AS uploaded_by_name, d.created_at
FROM   prod.dct_documents d
LEFT JOIN prod.dct_document_types dt ON dt.doc_type_id = d.doc_type_id
LEFT JOIN prod.dct_users cu ON cu.user_id = d.created_by
WHERE  d.source_module = 'TM' AND d.is_active = 'Y';

PROMPT
PROMPT === 02_tm_views.sql complete -- 12 views created ===
