-- =============================================================================
-- Freelancers Module (App 203) -- Contract document checklist: provenance
-- File    : 33_fl_contract_reqs.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @33_fl_contract_reqs.sql  (ANY session -- this
--           REDEFINES one existing handler on fl.rest via DEFINE_HANDLER; no
--           synonyms, no module rebuild. Safe to re-run; re-run after any
--           08_fl_ords.sql or 28_fl_contract_phase2_ords.sql re-run.)
-- Purpose : GET /fl/contracts/:id/requirements now says WHERE each required
--           document comes from, so the checklist can show the freelancer's own
--           record instead of just "Missing":
--             satisfiedBy  CONTRACT | PROFILE | ''      (unchanged semantics)
--             docId        the satisfying document (contract copy wins)
--             fileName / expiryDate / expiryStatus  VALID | EXPIRING_SOON | EXPIRED
--             profileExpired  'Y' when the freelancer HAS this document on their
--                             record but it has expired -- the one case where a
--                             profile document does not satisfy the requirement,
--                             and the user must upload a current copy.
--           The rule itself is unchanged and matches the submit gate in
--           DCT_FL_PKG: a requirement is satisfied by a contract document OR by
--           an UNEXPIRED document on the freelancer's record.
-- Source  : synced into 28_fl_contract_phase2_ords.sql.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'fl.rest',
    p_pattern     => 'contracts/' || CHR(58) || 'id/requirements',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_frl  NUMBER;
  l_alert NUMBER := NVL(TO_NUMBER(dct_fl_pkg.get_setting('DOC_EXPIRY_ALERT_DAYS')
                        DEFAULT NULL ON CONVERSION ERROR), 30);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT freelancer_id INTO l_frl FROM dct_fl_contracts WHERE contract_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Contract not found'); RETURN; END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT dr.doc_type_id, dt.doc_type_code, dt.doc_type_name_en, dt.doc_type_name_ar,
           dr.is_mandatory, dr.display_seq,
           -- a document uploaded on THIS contract
           (SELECT MAX(d.doc_id) FROM dct_documents d
            WHERE d.source_module = 'FL' AND d.source_type = 'CONTRACT'
              AND d.source_id = [COLON]id AND d.doc_type_id = dr.doc_type_id
              AND d.is_active = 'Y' AND d.status = 'ACTIVE'
              AND d.file_blob IS NOT NULL) AS con_doc,
           -- an UNEXPIRED document on the freelancer's own record
           (SELECT MAX(d.doc_id) FROM dct_documents d
            WHERE d.source_module = 'FL' AND d.reference_id = l_frl
              AND d.doc_type_id = dr.doc_type_id
              AND d.is_active = 'Y' AND d.status = 'ACTIVE'
              AND d.file_blob IS NOT NULL
              AND (d.expiry_date IS NULL OR d.expiry_date >= SYSDATE)) AS prof_doc,
           -- the freelancer HAS it, but it has expired
           (SELECT MAX(d.expiry_date) FROM dct_documents d
            WHERE d.source_module = 'FL' AND d.reference_id = l_frl
              AND d.doc_type_id = dr.doc_type_id
              AND d.is_active = 'Y' AND d.status = 'ACTIVE'
              AND d.file_blob IS NOT NULL
              AND d.expiry_date < SYSDATE) AS prof_expired_on
    FROM   dct_doc_requirements dr
    JOIN   dct_document_types   dt ON dt.doc_type_id = dr.doc_type_id
    WHERE  dr.source_module = 'FL' AND dr.context_code = 'CONTRACT'
    AND    dr.is_active = 'Y'
    ORDER BY dr.display_seq
  ) LOOP
    DECLARE
      -- The freelancer's own record is the source of truth: an UNEXPIRED profile
      -- document satisfies the requirement and is what we show. A contract-only
      -- copy is the fallback for types the profile does not carry.
      v_doc     NUMBER := NVL(r.prof_doc, r.con_doc);
      v_name    dct_documents.file_name%TYPE;
      v_exp     DATE;
      v_status  VARCHAR2(20);
    BEGIN
      IF v_doc IS NOT NULL THEN
        SELECT file_name, expiry_date INTO v_name, v_exp
        FROM   dct_documents WHERE doc_id = v_doc;
        v_status := CASE
                      WHEN v_exp IS NULL                     THEN 'VALID'
                      WHEN v_exp < SYSDATE                   THEN 'EXPIRED'
                      WHEN v_exp <= SYSDATE + l_alert        THEN 'EXPIRING_SOON'
                      ELSE 'VALID' END;
      END IF;

      APEX_JSON.open_object;
      APEX_JSON.write('docTypeId', r.doc_type_id);
      APEX_JSON.write('code',      r.doc_type_code);
      APEX_JSON.write('name',      r.doc_type_name_en);
      APEX_JSON.write('nameAr',    NVL(r.doc_type_name_ar, r.doc_type_name_en));
      APEX_JSON.write('mandatory', r.is_mandatory);
      APEX_JSON.write('satisfiedBy',
        CASE WHEN r.prof_doc IS NOT NULL THEN 'PROFILE'
             WHEN r.con_doc  IS NOT NULL THEN 'CONTRACT'
             ELSE '' END);
      APEX_JSON.write('docId',    NVL(v_doc, 0));
      APEX_JSON.write('fileName', NVL(v_name, ''));
      APEX_JSON.write('expiryDate',
        CASE WHEN v_exp IS NULL THEN '' ELSE TO_CHAR(v_exp, 'YYYY-MM-DD') END);
      APEX_JSON.write('expiryStatus', NVL(v_status, ''));
      APEX_JSON.write('profileExpired',
        CASE WHEN r.prof_doc IS NULL AND r.prof_expired_on IS NOT NULL THEN 'Y' ELSE 'N' END);
      APEX_JSON.write('profileExpiredOn',
        CASE WHEN r.prof_doc IS NULL AND r.prof_expired_on IS NOT NULL
             THEN TO_CHAR(r.prof_expired_on, 'YYYY-MM-DD') ELSE '' END);
      APEX_JSON.close_object;
    END;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 33_fl_contract_reqs.sql complete ===
