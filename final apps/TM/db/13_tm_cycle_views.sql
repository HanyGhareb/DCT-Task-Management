-- =============================================================================
-- Task Management Module (App 207) -- Cycle / Visibility / Exec read views
-- File    : 13_tm_cycle_views.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @13_tm_cycle_views.sql   (after 09_tm_cycle_ddl.sql)
-- Notes   : One read path per resource for the ORDS GET handlers. Names coalesced
--           for direct JET binding; dates left raw (ORDS formats to Asia/Dubai).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---- Team hierarchy (program -> sub-team) -----------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_team_tree_v AS
SELECT t.team_id, t.parent_team_id, t.team_code, t.team_name_en, t.team_name_ar,
       t.org_id, t.status, t.health_rag, t.leader_user_id,
       LEVEL AS depth,
       CONNECT_BY_ROOT t.team_id      AS root_team_id,
       CONNECT_BY_ROOT t.team_name_en AS root_team_name,
       SYS_CONNECT_BY_PATH(t.team_name_en, ' / ') AS name_path
FROM   prod.dct_tm_teams t
START WITH t.parent_team_id IS NULL
CONNECT BY NOCYCLE PRIOR t.team_id = t.parent_team_id;

-- ---- Reporting-cycle configuration ------------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_cycle_config_v AS
SELECT cf.cycle_config_id, cf.team_id, t.team_name_en, t.team_code,
       cf.cadence, cf.custom_days, cf.anchor_date,
       cf.submission_lead_days, cf.deadline_offset_days, cf.reminder_days_before,
       cf.escalate_after_days, cf.submitter_scope, cf.auto_close, cf.is_active,
       cf.created_at, cf.updated_at
FROM   prod.dct_tm_cycle_config cf
JOIN   prod.dct_tm_teams t ON t.team_id = cf.team_id;

-- ---- Reporting periods (with submission roll-up + sign-off) ------------------
CREATE OR REPLACE VIEW prod.dct_tm_period_v AS
SELECT p.period_id, p.team_id, t.team_name_en, t.team_code, p.cycle_config_id,
       p.period_label, p.period_start, p.period_end, p.open_date, p.due_date, p.status,
       CASE WHEN p.snapshot_json IS NULL THEN 'N' ELSE 'Y' END AS has_snapshot,
       CASE WHEN p.ai_summary    IS NULL THEN 'N' ELSE 'Y' END AS has_ai_summary,
       p.closed_at, p.created_at, p.updated_at,
       (SELECT COUNT(*) FROM prod.dct_tm_submissions s WHERE s.period_id = p.period_id) AS submitter_count,
       (SELECT COUNT(*) FROM prod.dct_tm_submissions s WHERE s.period_id = p.period_id
               AND s.status IN ('SUBMITTED','LATE')) AS submitted_count,
       (SELECT COUNT(*) FROM prod.dct_tm_submissions s WHERE s.period_id = p.period_id
               AND s.status = 'LATE') AS late_count,
       (SELECT COUNT(*) FROM prod.dct_tm_submissions s WHERE s.period_id = p.period_id
               AND s.status IN ('NOT_STARTED','DRAFT')) AS pending_count,
       sg.team_rag AS signoff_rag, sg.summary AS signoff_summary,
       sg.signed_at AS signoff_at, su.display_name AS signoff_by
FROM   prod.dct_tm_periods p
JOIN   prod.dct_tm_teams t ON t.team_id = p.team_id
LEFT JOIN prod.dct_tm_period_signoff sg ON sg.period_id = p.period_id
LEFT JOIN prod.dct_users su ON su.user_id = sg.leader_user_id;

-- ---- Member submissions (period status roster + my-updates) ------------------
CREATE OR REPLACE VIEW prod.dct_tm_submission_v AS
SELECT s.submission_id, s.period_id, s.team_id, t.team_name_en, t.team_code,
       p.period_label, p.period_start, p.period_end, p.due_date, p.status AS period_status,
       s.user_id, u.display_name AS member_name, u.email AS member_email,
       s.status, s.accomplishments, s.in_progress, s.pending, s.blockers, s.highlights,
       s.tasks_done, s.tasks_on_track, s.tasks_late, s.tasks_open, s.tasks_overdue,
       s.objective_progress, s.deliverables_done, s.new_raid_count,
       s.submitted_at, s.created_at, s.updated_at,
       CASE WHEN s.status = 'SUBMITTED' THEN 'Y'
            WHEN s.status = 'LATE'      THEN 'N'
            ELSE NULL END AS is_on_time
FROM   prod.dct_tm_submissions s
JOIN   prod.dct_tm_periods p ON p.period_id = s.period_id
JOIN   prod.dct_tm_teams   t ON t.team_id   = s.team_id
JOIN   prod.dct_users      u ON u.user_id   = s.user_id;

-- ---- Visibility grants (admin list) -----------------------------------------
CREATE OR REPLACE VIEW prod.dct_tm_visibility_grant_v AS
SELECT g.grant_id, g.grantee_user_id, gu.display_name AS grantee_name, gu.email AS grantee_email,
       g.scope, g.team_id, t.team_name_en AS team_name,
       g.org_id, o.org_name_en AS org_name,
       g.access_level, g.granted_by, bu.display_name AS granted_by_name,
       g.start_date, g.end_date, g.status, g.reason, g.created_at
FROM   prod.dct_tm_visibility_grant g
JOIN   prod.dct_users gu ON gu.user_id = g.grantee_user_id
LEFT JOIN prod.dct_tm_teams t      ON t.team_id = g.team_id
LEFT JOIN prod.dct_organizations o ON o.org_id  = g.org_id
LEFT JOIN prod.dct_users bu        ON bu.user_id = g.granted_by;

-- ---- Executive per-team scorecard (cross-DCT roll-up source) -----------------
CREATE OR REPLACE VIEW prod.dct_tm_exec_team_v AS
SELECT t.team_id, t.team_code, t.team_name_en, t.team_name_ar, t.parent_team_id,
       t.team_class, t.status, t.health_rag,
       t.org_id, o.org_name_en AS org_name, o.parent_org_id,
       t.leader_user_id, lu.display_name AS leader_name,
       (SELECT COUNT(*) FROM prod.dct_tm_members m WHERE m.team_id = t.team_id AND m.is_active = 'Y') AS member_count,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = t.team_id
               AND tk.status NOT IN ('DONE','CANCELLED')) AS open_tasks,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = t.team_id AND tk.status = 'DONE') AS done_tasks,
       (SELECT COUNT(*) FROM prod.dct_tm_tasks tk WHERE tk.team_id = t.team_id
               AND tk.due_date < TRUNC(SYSDATE) AND tk.status NOT IN ('DONE','CANCELLED')) AS overdue_tasks,
       (SELECT COUNT(*) FROM prod.dct_tm_log_items l WHERE l.team_id = t.team_id
               AND l.item_type IN ('ISSUE','RISK') AND l.status = 'OPEN'
               AND NVL(l.severity,'LOW') IN ('HIGH','CRITICAL')) AS high_risks,
       (SELECT ROUND(AVG(ob.progress_pct), 1) FROM prod.dct_tm_objectives ob WHERE ob.team_id = t.team_id) AS objective_progress,
       (SELECT ROUND(100 * SUM(CASE WHEN s.status = 'SUBMITTED' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 0)
          FROM prod.dct_tm_submissions s
          JOIN prod.dct_tm_periods p ON p.period_id = s.period_id
         WHERE s.team_id = t.team_id AND p.status IN ('DUE','CLOSED','LOCKED')) AS on_time_rate,
       (SELECT MAX(p2.period_label) KEEP (DENSE_RANK LAST ORDER BY p2.period_start)
          FROM prod.dct_tm_periods p2 WHERE p2.team_id = t.team_id) AS latest_period,
       (SELECT MAX(p3.status) KEEP (DENSE_RANK LAST ORDER BY p3.period_start)
          FROM prod.dct_tm_periods p3 WHERE p3.team_id = t.team_id) AS latest_period_status
FROM   prod.dct_tm_teams t
LEFT JOIN prod.dct_organizations o ON o.org_id   = t.org_id
LEFT JOIN prod.dct_users lu        ON lu.user_id = t.leader_user_id;

PROMPT
PROMPT === 13_tm_cycle_views.sql complete ===
PROMPT Views: dct_tm_team_tree_v, dct_tm_cycle_config_v, dct_tm_period_v,
PROMPT        dct_tm_submission_v, dct_tm_visibility_grant_v, dct_tm_exec_team_v
