-- ===========================================================================
-- otbi-atd : 23 configurable Fusion invoice TYPE per source document
-- Maps (source_module, source_type) -> the Fusion AP invoice Type the action
-- must create. Configurable: change a row to change the behaviour, no code.
--   PC / PC_REIMB   -> Standard
--   PC / PC_CLEAR   -> Standard
--   PC / PC_ADVANCE -> Prepayment
-- Rerunnable (seed = MERGE, preserves edits). Schema-qualified PROD. CRLF/UTF-8.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.dct_fusion_doctype_map CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.dct_fusion_doctype_map (
  source_module  VARCHAR2(20)  NOT NULL,    -- PC | FL | ...
  source_type    VARCHAR2(30)  NOT NULL,    -- PC_REIMB | PC_CLEAR | PC_ADVANCE | ...
  invoice_type   VARCHAR2(40)  NOT NULL,    -- Standard | Prepayment | Credit Memo ...
  description    VARCHAR2(200),
  updated_by     VARCHAR2(120),
  updated_at     TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_dct_fusion_doctype PRIMARY KEY (source_module, source_type)
);

-- seed (MERGE so a re-run never clobbers an admin edit)
MERGE INTO prod.dct_fusion_doctype_map t
USING (SELECT 'PC' m, 'PC_REIMB' s, 'Standard' v, 'Petty cash reimbursement' d FROM dual
       UNION ALL SELECT 'PC','PC_CLEAR','Standard','Petty cash clearing' FROM dual
       UNION ALL SELECT 'PC','PC_ADVANCE','Prepayment','Petty cash advance (float)' FROM dual) s
ON (t.source_module = s.m AND t.source_type = s.s)
WHEN NOT MATCHED THEN
  INSERT (source_module, source_type, invoice_type, description)
  VALUES (s.m, s.s, s.v, s.d);
COMMIT;

CREATE OR REPLACE SYNONYM dct_fusion_doctype_map FOR prod.dct_fusion_doctype_map;

SET ECHO OFF
PROMPT otbi-atd 23 fusion doctype map : done
