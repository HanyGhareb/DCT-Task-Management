-- ============================================================================
-- PAY Phase 3.1 -- Employee Change Control ORDS routes (/pay/changes/*)
-- ADDITIVE on pay.rest -- re-run after any 04_pay_ords.sql re-run.
-- Fresh SQLcl session required (synonym rule: never after CURRENT_SCHEMA=PROD)
-- Run as ADMIN (sql -name prod_mcp). Requires 19 + 21 (pkg v2).
-- v2 (2026-08-11): notes + evidence per change, variance flags, workflow
-- submit, report bridge (PAY_CHG_REGISTER), gate + sign-off modes exposed.
-- ============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE SYNONYM dct_pay_chg_pkg      FOR prod.dct_pay_chg_pkg;
CREATE OR REPLACE SYNONYM dct_pay_chg_register FOR prod.dct_pay_chg_register;
CREATE OR REPLACE SYNONYM dct_pay_chg_snap     FOR prod.dct_pay_chg_snap;
CREATE OR REPLACE SYNONYM dct_pay_chg_item     FOR prod.dct_pay_chg_item;

CREATE OR REPLACE PROCEDURE setup_pay_chg_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30):='pay.rest';
  PROCEDURE tpl(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
  PROCEDURE h(p VARCHAR2,m VARCHAR2,s CLOB) IS BEGIN
    ORDS.DEFINE_HANDLER(p_module_name=>c_mod,p_pattern=>REPLACE(p,'[COLON]',CHR(58)),p_method=>m,
      p_source_type=>ORDS.source_type_plsql,p_source=>REPLACE(s,'[COLON]',CHR(58)));
  END;
BEGIN

  -- ------------------------------------------------- register head + KPIs
  tpl('changes/register');
  h('changes/register','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_hr CHAR(1); l_pay CHAR(1);
 l_id NUMBER; l_status VARCHAR2(20); l_capat DATE; l_capby VARCHAR2(100);
 l_emp NUMBER; l_chg NUMBER; l_prior VARCHAR2(7); l_wf NUMBER;
 l_hrby VARCHAR2(100); l_hrat DATE; l_payby VARCHAR2(100); l_payat DATE;
 l_nh NUMBER:=0; l_ex NUMBER:=0; l_ch NUMBER:=0; l_fl NUMBER:=0;
 l_phr NUMBER:=0; l_ppay NUMBER:=0; l_imp NUMBER:=0;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT dct_pay_chg_pkg.can_view(l_user) THEN dct_rest.err(403,'Not allowed');RETURN;END IF;
 l_hr :=CASE WHEN dct_pay_chg_pkg.can_hr(l_user)  THEN 'Y' ELSE 'N' END;
 l_pay:=CASE WHEN dct_pay_chg_pkg.can_pay(l_user) THEN 'Y' ELSE 'N' END;
 BEGIN
  SELECT r.register_id, r.status, r.captured_at, r.captured_by,
         r.emp_count, r.change_count, r.hr_done_by, r.hr_done_at,
         r.pay_done_by, r.pay_done_at, r.wf_instance_id,
         (SELECT pe2.period_code FROM dct_pay_chg_register r2
          JOIN prod.dct_pay_period pe2 ON pe2.period_id=r2.period_id
          WHERE r2.register_id=r.prior_register_id)
    INTO l_id,l_status,l_capat,l_capby,l_emp,l_chg,l_hrby,l_hrat,l_payby,l_payat,l_wf,l_prior
  FROM dct_pay_chg_register r
  WHERE r.payroll_id=TO_NUMBER([COLON]payrollid) AND r.period_id=TO_NUMBER([COLON]periodid);
 EXCEPTION WHEN NO_DATA_FOUND THEN l_id:=NULL;
 END;
 IF l_id IS NOT NULL THEN
  SELECT COUNT(CASE WHEN change_kind='NEW_HIRE' THEN 1 END),
         COUNT(CASE WHEN change_kind='EXIT' THEN 1 END),
         COUNT(CASE WHEN change_kind='CHANGE' THEN 1 END),
         COUNT(CASE WHEN hr_status='N' THEN 1 END),
         COUNT(CASE WHEN pay_status='N' THEN 1 END),
         COUNT(CASE WHEN flags IS NOT NULL THEN 1 END),
         NVL(SUM(CASE WHEN attr_code IN('GROSS','EMPLOYEE') THEN delta END),0)
    INTO l_nh,l_ex,l_ch,l_phr,l_ppay,l_fl,l_imp
  FROM dct_pay_chg_item WHERE register_id=l_id;
 END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('canHr',l_hr);APEX_JSON.write('canPay',l_pay);
 APEX_JSON.write('signoffMode',NVL(dct_pay_chg_pkg.get_setting('CHG_SIGNOFF_MODE','INLINE'),'INLINE'));
 APEX_JSON.write('gateMode',NVL(dct_pay_chg_pkg.get_setting('CHG_GATE_MODE','OFF'),'OFF'));
 APEX_JSON.write('exists',CASE WHEN l_id IS NULL THEN 'N' ELSE 'Y' END);
 IF l_id IS NOT NULL THEN
  APEX_JSON.write('registerId',l_id);APEX_JSON.write('status',l_status);
  APEX_JSON.write('capturedAt',TO_CHAR(dct_to_local(l_capat),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.write('capturedBy',NVL(l_capby,''));
  APEX_JSON.write('priorPeriod',NVL(l_prior,''));
  APEX_JSON.write('wfInstanceId',l_wf);
  APEX_JSON.write('empCount',NVL(l_emp,0));APEX_JSON.write('changeCount',NVL(l_chg,0));
  APEX_JSON.write('newHires',l_nh);APEX_JSON.write('exits',l_ex);APEX_JSON.write('changes',l_ch);
  APEX_JSON.write('flagged',l_fl);
  APEX_JSON.write('pendHr',l_phr);APEX_JSON.write('pendPay',l_ppay);
  APEX_JSON.write('grossImpact',l_imp);
  APEX_JSON.write('hrDoneBy',NVL(l_hrby,''));
  APEX_JSON.write('hrDoneAt',CASE WHEN l_hrat IS NULL THEN '' ELSE TO_CHAR(dct_to_local(l_hrat),'YYYY-MM-DD HH:MI AM') END);
  APEX_JSON.write('payDoneBy',NVL(l_payby,''));
  APEX_JSON.write('payDoneAt',CASE WHEN l_payat IS NULL THEN '' ELSE TO_CHAR(dct_to_local(l_payat),'YYYY-MM-DD HH:MI AM') END);
 END IF;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- ------------------------------------------------- capture / recapture
  tpl('changes/capture');
  h('changes/capture','POST',q'!
DECLARE l_user VARCHAR2(100); l_id NUMBER;
 l_status VARCHAR2(20); l_emp NUMBER; l_chg NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_chg_pkg.capture(APEX_JSON.get_number('payrollId'),
                         APEX_JSON.get_number('periodId'), l_user, l_id);
 COMMIT;
 SELECT status, emp_count, change_count INTO l_status,l_emp,l_chg
 FROM dct_pay_chg_register WHERE register_id=l_id;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('registerId',l_id);APEX_JSON.write('status',l_status);
 APEX_JSON.write('empCount',NVL(l_emp,0));APEX_JSON.write('changeCount',NVL(l_chg,0));
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ------------------------------------------------- confirmable findings
  tpl('changes/[COLON]id/items');
  h('changes/[COLON]id/items','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_pay BOOLEAN; l_total NUMBER;
 l_limit NUMBER; l_offset NUMBER;
 l_bankreq CHAR(1); l_flagreq CHAR(1); l_min NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT dct_pay_chg_pkg.can_view(l_user) THEN dct_rest.err(403,'Not allowed');RETURN;END IF;
 l_pay:=dct_pay_chg_pkg.can_pay(l_user);
 l_limit :=LEAST(NVL(TO_NUMBER([COLON]limit),2000),5000);
 l_offset:=NVL(TO_NUMBER([COLON]offset),0);
 l_bankreq:=CASE WHEN NVL(dct_pay_chg_pkg.get_setting('CHG_BANK_NOTE_REQ','Y'),'Y')='Y' THEN 'Y' ELSE 'N' END;
 l_flagreq:=CASE WHEN NVL(dct_pay_chg_pkg.get_setting('CHG_FLAG_NOTE_REQ','N'),'N')='Y' THEN 'Y' ELSE 'N' END;
 SELECT NVL(TO_NUMBER(dct_pay_chg_pkg.get_setting('CHG_NOTE_MIN_AED','0') DEFAULT NULL ON CONVERSION ERROR),0)
   INTO l_min FROM dual;
 SELECT COUNT(*) INTO l_total FROM dct_pay_chg_item i
 WHERE i.register_id=TO_NUMBER([COLON]id)
   AND ([COLON]kind IS NULL OR i.change_kind=[COLON]kind)
   AND ([COLON]grp IS NULL OR i.attr_group=[COLON]grp)
   AND ([COLON]flagged IS NULL OR [COLON]flagged='N' OR i.flags IS NOT NULL)
   AND ([COLON]pending IS NULL
        OR ([COLON]pending='hr' AND i.hr_status='N')
        OR ([COLON]pending='pay' AND i.pay_status='N'))
   AND ([COLON]search IS NULL
        OR UPPER(i.full_name) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(i.employee_number) LIKE '%'||UPPER([COLON]search)||'%'
        OR UPPER(i.attr_code) LIKE '%'||UPPER([COLON]search)||'%');
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('total',l_total);
 APEX_JSON.open_array('items');
 FOR r IN(SELECT i.*,
                 (SELECT COUNT(*) FROM dct_documents d
                  WHERE d.source_module='PAY' AND d.source_type='PAY_CHANGE'
                    AND d.source_id=i.item_id AND d.is_active='Y') doc_count,
                 CASE WHEN i.note IS NOT NULL THEN 'N'
                      WHEN l_bankreq='Y' AND i.attr_group='BANK' AND i.change_kind='CHANGE' THEN 'Y'
                      WHEN l_flagreq='Y' AND i.flags IS NOT NULL THEN 'Y'
                      WHEN l_min>0 AND ABS(NVL(i.delta,0))>=l_min THEN 'Y'
                      ELSE 'N' END note_req
          FROM dct_pay_chg_item i
          WHERE i.register_id=TO_NUMBER([COLON]id)
            AND ([COLON]kind IS NULL OR i.change_kind=[COLON]kind)
            AND ([COLON]grp IS NULL OR i.attr_group=[COLON]grp)
            AND ([COLON]flagged IS NULL OR [COLON]flagged='N' OR i.flags IS NOT NULL)
            AND ([COLON]pending IS NULL
                 OR ([COLON]pending='hr' AND i.hr_status='N')
                 OR ([COLON]pending='pay' AND i.pay_status='N'))
            AND ([COLON]search IS NULL
                 OR UPPER(i.full_name) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(i.employee_number) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(i.attr_code) LIKE '%'||UPPER([COLON]search)||'%')
          ORDER BY i.full_name, i.person_id,
                   CASE i.change_kind WHEN 'NEW_HIRE' THEN 1 WHEN 'EXIT' THEN 2 ELSE 3 END,
                   i.attr_group, i.attr_code
          OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('itemId',r.item_id);APEX_JSON.write('personId',r.person_id);
  APEX_JSON.write('empNo',NVL(r.employee_number,''));APEX_JSON.write('name',NVL(r.full_name,''));
  APEX_JSON.write('kind',r.change_kind);APEX_JSON.write('grp',r.attr_group);
  APEX_JSON.write('attr',r.attr_code);
  IF r.attr_group='BANK' AND NOT l_pay THEN
   APEX_JSON.write('oldValue',CASE WHEN r.old_value IS NULL THEN '' ELSE '****'||SUBSTR(r.old_value,-4) END);
   APEX_JSON.write('newValue',CASE WHEN r.new_value IS NULL THEN '' ELSE '****'||SUBSTR(r.new_value,-4) END);
  ELSE
   APEX_JSON.write('oldValue',NVL(r.old_value,''));
   APEX_JSON.write('newValue',NVL(r.new_value,''));
  END IF;
  APEX_JSON.write('delta',r.delta);
  APEX_JSON.write('flags',NVL(r.flags,''));
  APEX_JSON.write('note',NVL(r.note,''));
  APEX_JSON.write('noteReq',r.note_req);
  APEX_JSON.write('docCount',r.doc_count);
  APEX_JSON.write('hrStatus',r.hr_status);APEX_JSON.write('hrBy',NVL(r.hr_by,''));
  APEX_JSON.write('hrAt',CASE WHEN r.hr_at IS NULL THEN '' ELSE TO_CHAR(dct_to_local(r.hr_at),'YYYY-MM-DD HH:MI AM') END);
  APEX_JSON.write('payStatus',r.pay_status);APEX_JSON.write('payBy',NVL(r.pay_by,''));
  APEX_JSON.write('payAt',CASE WHEN r.pay_at IS NULL THEN '' ELSE TO_CHAR(dct_to_local(r.pay_at),'YYYY-MM-DD HH:MI AM') END);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- ------------------------------------------------- note per finding
  tpl('changes/[COLON]id/items/[COLON]iid');
  h('changes/[COLON]id/items/[COLON]iid','PUT',q'!
DECLARE l_user VARCHAR2(100);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_chg_pkg.set_note(TO_NUMBER([COLON]id),TO_NUMBER([COLON]iid),
   APEX_JSON.get_varchar2('note'), l_user);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('ok','Y');APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ------------------------------------------------- evidence per finding
  tpl('changes/[COLON]id/items/[COLON]iid/evidence');
  h('changes/[COLON]id/items/[COLON]iid/evidence','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT dct_pay_chg_pkg.can_view(l_user) THEN dct_rest.err(403,'Not allowed');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR r IN(SELECT d.doc_id, d.file_name, d.mime_type, d.file_size_bytes, d.created_at
          FROM dct_documents d
          WHERE d.source_module='PAY' AND d.source_type='PAY_CHANGE'
            AND d.source_id=TO_NUMBER([COLON]iid) AND d.is_active='Y'
          ORDER BY d.doc_id DESC) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('docId',r.doc_id);APEX_JSON.write('fileName',NVL(r.file_name,''));
  APEX_JSON.write('mimeType',NVL(r.mime_type,''));
  APEX_JSON.write('fileSize',NVL(r.file_size_bytes,0));
  APEX_JSON.write('uploadedAt',TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');
  h('changes/[COLON]id/items/[COLON]iid/evidence','PUT',q'!
DECLARE
 l_user VARCHAR2(100); l_uid NUMBER; v_blob BLOB; v_len NUMBER; v_max NUMBER;
 l_status VARCHAR2(20); l_n NUMBER; l_type NUMBER; l_doc NUMBER;
BEGIN
 v_blob := [COLON]body;
 l_user := dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT (dct_pay_chg_pkg.can_hr(l_user) OR dct_pay_chg_pkg.can_pay(l_user)) THEN
  dct_rest.err(403,'Not allowed');RETURN;END IF;
 BEGIN
  SELECT status INTO l_status FROM dct_pay_chg_register
  WHERE register_id=TO_NUMBER([COLON]id);
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Register not found');RETURN;END;
 IF l_status IN('CONFIRMED','IN_APPROVAL') THEN
  dct_rest.err(400,'Register is locked');RETURN;END IF;
 SELECT COUNT(*) INTO l_n FROM dct_pay_chg_item
 WHERE register_id=TO_NUMBER([COLON]id) AND item_id=TO_NUMBER([COLON]iid);
 IF l_n=0 THEN dct_rest.err(404,'Change item not found');RETURN;END IF;
 IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob)=0 THEN
  dct_rest.err(400,'Request body (file bytes) is required');RETURN;END IF;
 IF [COLON]file_name IS NULL THEN
  dct_rest.err(400,'file_name query parameter is required');RETURN;END IF;
 v_len := DBMS_LOB.GETLENGTH(v_blob);
 BEGIN
  SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO v_max
  FROM dct_module_settings ms JOIN dct_modules m ON m.module_id=ms.module_id
  WHERE m.module_code='PAY' AND ms.setting_key='MAX_UPLOAD_MB';
 EXCEPTION WHEN NO_DATA_FOUND THEN v_max:=NULL;END;
 v_max := NVL(v_max,10);
 IF v_len > v_max*1024*1024 THEN
  dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB');RETURN;END IF;
 l_uid := dct_auth.get_user_id(l_user);
 SELECT doc_type_id INTO l_type FROM dct_document_types WHERE doc_type_code='PAY_DOCUMENT';
 INSERT INTO dct_documents
        (source_module, source_type, source_id, doc_type_id,
         file_name, mime_type, file_size_bytes, file_blob, created_by, created_at)
 VALUES ('PAY','PAY_CHANGE',TO_NUMBER([COLON]iid),l_type,
         [COLON]file_name, NVL([COLON]mime_type,'application/octet-stream'),
         v_len, v_blob, l_uid, SYSTIMESTAMP)
 RETURNING doc_id INTO l_doc;
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('docId',l_doc);APEX_JSON.write('fileSize',v_len);
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;dct_rest.err(500,SQLERRM);END;!');

  -- ------------------------------------------------- full value matrix
  tpl('changes/[COLON]id/all');
  h('changes/[COLON]id/all','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_pay BOOLEAN; l_prior NUMBER; l_n NUMBER:=0;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT dct_pay_chg_pkg.can_view(l_user) THEN dct_rest.err(403,'Not allowed');RETURN;END IF;
 l_pay:=dct_pay_chg_pkg.can_pay(l_user);
 BEGIN
  SELECT prior_register_id INTO l_prior FROM dct_pay_chg_register
  WHERE register_id=TO_NUMBER([COLON]id);
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Register not found');RETURN;
 END;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR r IN(SELECT c.employee_number, c.full_name, c.attr_group, c.attr_code,
                 p.attr_value prev_value, c.attr_value cur_value,
                 CASE WHEN l_prior IS NULL THEN 'N'
                      WHEN DECODE(c.attr_value,p.attr_value,1,0)=0 THEN 'Y' ELSE 'N' END chgd
          FROM dct_pay_chg_snap c
          LEFT JOIN dct_pay_chg_snap p
            ON p.register_id=l_prior AND p.person_id=c.person_id AND p.attr_code=c.attr_code
          WHERE c.register_id=TO_NUMBER([COLON]id)
            AND ([COLON]grp IS NULL OR c.attr_group=[COLON]grp)
            AND ([COLON]changed IS NULL OR [COLON]changed='N'
                 OR (l_prior IS NOT NULL AND DECODE(c.attr_value,p.attr_value,1,0)=0))
            AND ([COLON]search IS NULL
                 OR UPPER(c.full_name) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(c.employee_number) LIKE '%'||UPPER([COLON]search)||'%'
                 OR UPPER(c.attr_code) LIKE '%'||UPPER([COLON]search)||'%')
          ORDER BY c.full_name, c.person_id, c.attr_group, c.attr_code
          FETCH FIRST 10000 ROWS ONLY) LOOP
  l_n:=l_n+1;
  APEX_JSON.open_object;
  APEX_JSON.write('empNo',NVL(r.employee_number,''));APEX_JSON.write('name',NVL(r.full_name,''));
  APEX_JSON.write('grp',r.attr_group);APEX_JSON.write('attr',r.attr_code);
  IF r.attr_group='BANK' AND NOT l_pay THEN
   APEX_JSON.write('prevValue',CASE WHEN r.prev_value IS NULL THEN '' ELSE '****'||SUBSTR(r.prev_value,-4) END);
   APEX_JSON.write('curValue',CASE WHEN r.cur_value IS NULL THEN '' ELSE '****'||SUBSTR(r.cur_value,-4) END);
  ELSE
   APEX_JSON.write('prevValue',NVL(r.prev_value,''));
   APEX_JSON.write('curValue',NVL(r.cur_value,''));
  END IF;
  APEX_JSON.write('changed',r.chgd);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;
 APEX_JSON.write('shown',l_n);
 APEX_JSON.write('truncated',CASE WHEN l_n>=10000 THEN 'Y' ELSE 'N' END);
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- ------------------------------------------------- confirmations
  tpl('changes/[COLON]id/confirm');
  h('changes/[COLON]id/confirm','POST',q'!
DECLARE l_user VARCHAR2(100); l_n NUMBER; l_status VARCHAR2(20);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_chg_pkg.confirm_items(TO_NUMBER([COLON]id),
   APEX_JSON.get_varchar2('side'), APEX_JSON.get_varchar2('action'),
   NVL(APEX_JSON.get_varchar2('items'),'ALL'), l_user, l_n);
 COMMIT;
 SELECT status INTO l_status FROM dct_pay_chg_register WHERE register_id=TO_NUMBER([COLON]id);
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('updated',l_n);APEX_JSON.write('status',l_status);
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ------------------------------------------------- register attestation
  tpl('changes/[COLON]id/signoff');
  h('changes/[COLON]id/signoff','POST',q'!
DECLARE l_user VARCHAR2(100); l_status VARCHAR2(20);
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_chg_pkg.sign_off(TO_NUMBER([COLON]id),
   APEX_JSON.get_varchar2('side'), APEX_JSON.get_varchar2('action'), l_user);
 COMMIT;
 SELECT status INTO l_status FROM dct_pay_chg_register WHERE register_id=TO_NUMBER([COLON]id);
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('status',l_status);
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ------------------------------------------------- workflow submission
  tpl('changes/[COLON]id/submit');
  h('changes/[COLON]id/submit','POST',q'!
DECLARE l_user VARCHAR2(100); l_inst NUMBER; l_status VARCHAR2(20);
BEGIN
 l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 dct_pay_chg_pkg.submit_signoff(TO_NUMBER([COLON]id), l_user, l_inst);
 COMMIT;
 SELECT status INTO l_status FROM dct_pay_chg_register WHERE register_id=TO_NUMBER([COLON]id);
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('instanceId',l_inst);APEX_JSON.write('status',l_status);
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
 ELSIF SQLCODE IN(-20001,-20090) THEN dct_rest.err(400,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  -- ------------------------------------------------- briefing report bridge
  tpl('changes/[COLON]id/report');
  h('changes/[COLON]id/report','POST',q'!
DECLARE
 l_user VARCHAR2(100); l_format VARCHAR2(10); l_run NUMBER; l_n NUMBER;
BEGIN
 dct_rest.parse_body([COLON]body);l_user:=dct_rest.validate_session;
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT dct_pay_chg_pkg.can_view(l_user) THEN dct_rest.err(403,'Not allowed');RETURN;END IF;
 l_format := UPPER(NVL(APEX_JSON.get_varchar2('format'),'PDF'));
 IF l_format NOT IN('PDF','XLSX') THEN dct_rest.err(400,'format must be PDF or XLSX');RETURN;END IF;
 SELECT COUNT(*) INTO l_n FROM dct_pay_chg_register WHERE register_id=TO_NUMBER([COLON]id);
 IF l_n=0 THEN dct_rest.err(404,'Register not found');RETURN;END IF;
 l_run := dct_rpt_pkg.enqueue(p_report_code=>'PAY_CHG_REGISTER',
            p_params=>'{"registerid"[COLON]"'||TO_NUMBER([COLON]id)||'"}',
            p_trigger=>'ONDEMAND', p_requested_by=>l_user, p_formats=>l_format);
 COMMIT;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('runId',l_run);APEX_JSON.write('format',l_format);
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
 IF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);ELSE dct_rest.err(500,SQLERRM);END IF;END;!');

  tpl('changes/report/[COLON]rid');
  h('changes/report/[COLON]rid','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_file NUMBER; l_format VARCHAR2(10);
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at, formats
           FROM dct_rpt_run
           WHERE run_id=[COLON]rid AND report_code='PAY_CHG_REGISTER') LOOP
  SELECT COUNT(*), MAX(format) INTO l_file, l_format
  FROM dct_rpt_output WHERE run_id=c.run_id;
  dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
  APEX_JSON.write('runId',c.run_id);APEX_JSON.write('status',c.status);
  APEX_JSON.write('rowCount',c.row_count);
  APEX_JSON.write('error',NVL(DBMS_LOB.SUBSTR(c.error_msg,500,1),''));
  APEX_JSON.write('hasFile',l_file>0);APEX_JSON.write('format',NVL(l_format,c.formats));
  APEX_JSON.close_object;
  RETURN;
 END LOOP;
 dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  tpl('changes/report/[COLON]rid/file');
  h('changes/report/[COLON]rid/file','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 BEGIN
  SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
    SELECT o.file_blob, o.file_name, o.mime_type
    FROM dct_rpt_output o
    JOIN dct_rpt_run r ON r.run_id=o.run_id
    WHERE o.run_id=[COLON]rid AND r.report_code='PAY_CHG_REGISTER'
    ORDER BY o.output_id DESC) o WHERE ROWNUM=1;
 EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found');RETURN;END;
 OWA_UTIL.mime_header(NVL(l_mime,'application/octet-stream'),FALSE);
 HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'pay_changes')||'"');
 OWA_UTIL.http_header_close;
 WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- ------------------------------------------------- run-console readiness
  tpl('changes/status');
  h('changes/status','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_id NUMBER; l_status VARCHAR2(20); l_chg NUMBER; l_phr NUMBER; l_ppay NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 BEGIN
  SELECT r.register_id, r.status, r.change_count INTO l_id,l_status,l_chg
  FROM dct_pay_chg_register r
  WHERE r.payroll_id=TO_NUMBER([COLON]payrollid) AND r.period_id=TO_NUMBER([COLON]periodid);
 EXCEPTION WHEN NO_DATA_FOUND THEN l_id:=NULL;
 END;
 IF l_id IS NOT NULL THEN
  SELECT COUNT(CASE WHEN hr_status='N' THEN 1 END),
         COUNT(CASE WHEN pay_status='N' THEN 1 END)
    INTO l_phr,l_ppay FROM dct_pay_chg_item WHERE register_id=l_id;
 END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.write('gateMode',NVL(dct_pay_chg_pkg.get_setting('CHG_GATE_MODE','OFF'),'OFF'));
 APEX_JSON.write('exists',CASE WHEN l_id IS NULL THEN 'N' ELSE 'Y' END);
 IF l_id IS NOT NULL THEN
  APEX_JSON.write('registerId',l_id);APEX_JSON.write('status',l_status);
  APEX_JSON.write('changeCount',NVL(l_chg,0));
  APEX_JSON.write('pendHr',NVL(l_phr,0));APEX_JSON.write('pendPay',NVL(l_ppay,0));
 END IF;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  -- ------------------------------------------------- register history
  tpl('changes/registers');
  h('changes/registers','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized');RETURN;END IF;
 IF NOT dct_pay_chg_pkg.can_view(l_user) THEN dct_rest.err(403,'Not allowed');RETURN;END IF;
 dct_rest.json_header;APEX_JSON.initialize_output;APEX_JSON.open_object;
 APEX_JSON.open_array('items');
 FOR r IN(SELECT r.*, pe.period_code, pe.date_from
          FROM dct_pay_chg_register r
          JOIN prod.dct_pay_period pe ON pe.period_id=r.period_id
          WHERE r.payroll_id=TO_NUMBER([COLON]payrollid)
          ORDER BY pe.date_from DESC FETCH FIRST 24 ROWS ONLY) LOOP
  APEX_JSON.open_object;
  APEX_JSON.write('registerId',r.register_id);APEX_JSON.write('period',r.period_code);
  APEX_JSON.write('status',r.status);
  APEX_JSON.write('capturedAt',CASE WHEN r.captured_at IS NULL THEN '' ELSE TO_CHAR(dct_to_local(r.captured_at),'YYYY-MM-DD HH:MI AM') END);
  APEX_JSON.write('capturedBy',NVL(r.captured_by,''));
  APEX_JSON.write('empCount',NVL(r.emp_count,0));APEX_JSON.write('changeCount',NVL(r.change_count,0));
  APEX_JSON.write('hrDoneAt',CASE WHEN r.hr_done_at IS NULL THEN '' ELSE TO_CHAR(dct_to_local(r.hr_done_at),'YYYY-MM-DD HH:MI AM') END);
  APEX_JSON.write('payDoneAt',CASE WHEN r.pay_done_at IS NULL THEN '' ELSE TO_CHAR(dct_to_local(r.pay_done_at),'YYYY-MM-DD HH:MI AM') END);
  APEX_JSON.close_object;
 END LOOP;APEX_JSON.close_array;APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);END;!');

  COMMIT;
END setup_pay_chg_ords_tmp;
/
BEGIN setup_pay_chg_ords_tmp;END;
/
DROP PROCEDURE setup_pay_chg_ords_tmp;

SELECT t.uri_template, h.method, LENGTH(h.source) src_len
FROM user_ords_templates t
JOIN user_ords_handlers h ON h.template_id = t.id
WHERE t.uri_template LIKE 'changes%' ORDER BY 1,2;

PROMPT === PAY change-control ORDS complete ===
EXIT
