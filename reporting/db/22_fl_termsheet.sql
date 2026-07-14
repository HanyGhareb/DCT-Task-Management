SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- =============================================================================
-- Reporting Platform -- FL Contract Termsheet definition
-- File    : 22_fl_termsheet.sql
-- Schema  : run as ADMIN (objects in PROD). Idempotent.
-- Purpose : FL_CONTRACT_TERMSHEET -- the Legal Affairs "New Contract/New MOU
--           Approval Form and Termsheet" rendered from a freelancer contract
--           (FL Contract Phase 2, decisions D1 Word template / D3 replace
--           Mersal). MULTI source: section 'con' = the termsheet row from
--           dct_fl_contract_v, section 'steps' = the 7-step endorsement chain
--           with per-step named approvers. PDF via the DB-stored Word template
--           fl_contract_termsheet.docx (docxtpl -> LibreOffice on the fleet).
--           Run on demand from the FL app through the fl.rest bridge
--           (final apps/FL/db/29) -- not scheduled, no recipients.
-- CHAIN   : the Endorsement Chain section reads prod.DCT_WF_CHAIN_V (db/v2/64),
--           NOT the legacy approval tables. Two reasons:
--
--           1. It was the last undocumented consumer of dct_approval_instances /
--              _steps / _actions. Migrating FL_CONTRACT to the workflow engine
--              would have silently emptied this table in a LEGAL DOCUMENT.
--
--           2. IT WAS ALREADY WRONG. The old query did
--                 ROW_NUMBER() OVER (PARTITION BY aa.step_id ORDER BY ...)
--              -- partitioned by step_id ALONE, not by instance. Contracts on the
--              same template SHARE step_ids, so only the globally-latest action on
--              each step survived rn=1; if it belonged to another contract, the
--              join to THIS instance missed and the step printed as "-" with no
--              approver. Verified on PROD 2026-07-14: FL-CON-000028 was fully
--              approved through all 7 steps, and its termsheet rendered SIX of the
--              seven as blank. The view partitions by (instance_id, step_id).
--
--           So this rewrite CHANGES OUTPUT -- it fixes it. Column names are
--           identical, so fl_contract_termsheet.docx is untouched.
--           The :MI phantom-bind workaround (CHR(58)) is preserved.
--
-- Deploy  : contains a MERGE -- deploy via python-oracledb (worker VM), never
--           Linux SQLcl.
-- =============================================================================

DECLARE
    l_src CLOB;
BEGIN
    l_src := q'{{"required":["contract_id"],"orientation":"portrait","sections":[
{"key":"con","title":"Contract","layout":"table","sql":"SELECT c.contract_number, c.termsheet_ref, c.title, c.status, c.contract_type_name, c.initiative, c.contract_manager_name, c.description, c.total_amount, c.currency_code, c.payment_terms, c.advance_payment, c.retention_terms, c.performance_bond, c.parent_co_guarantee, c.insurance_details, TO_CHAR(c.start_date,'YYYY-MM-DD') AS start_date, TO_CHAR(c.end_date,'YYYY-MM-DD') AS end_date, c.procurement_involved, c.procurement_why, c.fte_conversion_name, c.services_summary, c.notes, c.freelancer_name, c.org_name, c.line_manager_name, c.memo_from_name, c.memo_to_name, c.created_by, c.created_by_name, TO_CHAR(prod.dct_to_local(c.created_at),'YYYY-MM-DD') AS prepared_date FROM prod.dct_fl_contract_v c WHERE c.contract_id = :contract_id"},
{"key":"steps","title":"Endorsement Chain","layout":"table","sql":"SELECT cv.step_seq, cv.step_name, cv.approver, cv.status, cv.actioned_by, CASE WHEN cv.actioned_at IS NULL THEN NULL ELSE TO_CHAR(prod.dct_to_local(cv.actioned_at),'YYYY-MM-DD HH')||CHR(58)||TO_CHAR(prod.dct_to_local(cv.actioned_at),'MI AM') END AS actioned_at, cv.comments FROM prod.dct_wf_chain_v cv WHERE cv.source_module = 'FL_CONTRACT' AND cv.source_record_id = :contract_id AND cv.is_current = 'Y' ORDER BY cv.step_seq"}
]}}';

    MERGE INTO prod.dct_rpt_definition t
    USING (SELECT 'FL_CONTRACT_TERMSHEET' AS report_code FROM dual) s
    ON (t.report_code = s.report_code)
    WHEN NOT MATCHED THEN INSERT
        (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
         default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
         param_spec_json, enabled, created_by, updated_by)
    VALUES
        ('FL_CONTRACT_TERMSHEET',
         'Freelancer Contract Termsheet',
         UNISTR('\0645\0644\062E\0635 \0639\0642\062F \0627\0644\0645\062A\0639\0627\0642\062F'),
         'Legal Affairs New Contract/New MOU Approval Form and Termsheet rendered from a freelancer contract, including the 7-step endorsement chain with named approvers and decisions. Run on demand from the Freelancers app (contract detail page).',
         'Freelancers', 'MULTI', l_src, 'PYTHON', 'PDF',
         'fl_contract_termsheet.docx',
         'Freelancer Contract Termsheet - {{ params.contract_id }}',
         'Attached: the contract termsheet PDF.',
         '{"contract_id":null}',
         '{"contract_id":{"label":"Contract ID","label_ar":"رقم العقد","hint":"Internal dct_fl_contracts id","required":true}}',
         'Y', 'SETUP', 'SETUP')
    WHEN MATCHED THEN UPDATE SET
         source_type   = 'MULTI',
         source_ref    = l_src,
         engine        = 'PYTHON',
         default_formats = 'PDF',
         pdf_template  = 'fl_contract_termsheet.docx',
         enabled       = 'Y',
         updated_by    = 'SETUP';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FL_CONTRACT_TERMSHEET definition merged.');
END;
/

PROMPT === 22_fl_termsheet.sql complete ===
