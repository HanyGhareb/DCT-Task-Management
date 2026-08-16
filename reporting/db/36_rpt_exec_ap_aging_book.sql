-- Executive AP Aging Briefing Book (dashboard companion)
SET DEFINE OFF
SET SQLBLANKLINES ON
DECLARE
  l_scope VARCHAR2(4000);
  l_src   CLOB;
BEGIN
  l_scope := q'! FROM (SELECT h.invoice_number, CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END supplier, h.business_unit, h.invoice_date, h.due_date, h.payment_status, h.validation_status, h.approval_status, NVL(h.balance_due,0)*NVL(h.invoice_amount_aed/NULLIF(h.invoice_amount,0),1) balance_aed, CASE WHEN h.due_date>=TRUNC(SYSDATE) THEN 'CURRENT' WHEN TRUNC(SYSDATE)-h.due_date<=30 THEN 'D1_30' WHEN TRUNC(SYSDATE)-h.due_date<=60 THEN 'D31_60' WHEN TRUNC(SYSDATE)-h.due_date<=90 THEN 'D61_90' WHEN TRUNC(SYSDATE)-h.due_date<=180 THEN 'D91_180' ELSE 'D180P' END aging_bucket FROM prod.ap_invoices_header_v h WHERE h.invoice_status<>'Cancelled') x WHERE ABS(balance_aed)>0.005 AND ([COLON]bu IS NULL OR business_unit=[COLON]bu) AND ([COLON]supplier IS NULL OR UPPER(supplier) LIKE '%'||UPPER([COLON]supplier)||'%') AND ([COLON]aging IS NULL OR aging_bucket=UPPER([COLON]aging))!';
  l_src := '{"orientation":"landscape","sections":['||
    '{"key":"overview","title":"Executive Summary","layout":"kv","sql":"SELECT COUNT(CASE WHEN balance_aed>0.005 THEN 1 END) open_invoices, SUM(CASE WHEN balance_aed>0.005 THEN balance_aed ELSE 0 END) gross_outstanding_aed, COUNT(CASE WHEN balance_aed>0.005 AND due_date<TRUNC(SYSDATE) THEN 1 END) overdue_invoices, SUM(CASE WHEN balance_aed>0.005 AND due_date<TRUNC(SYSDATE) THEN balance_aed ELSE 0 END) overdue_aed, COUNT(CASE WHEN balance_aed< -0.005 THEN 1 END) credit_documents, SUM(CASE WHEN balance_aed< -0.005 THEN balance_aed ELSE 0 END) supplier_credits_aed, SUM(balance_aed) net_exposure_aed'||l_scope||'"},'||
    '{"key":"aging","title":"AP Aging Exposure","layout":"table","sql":"SELECT aging_bucket, COUNT(*) invoice_count, SUM(balance_aed) amount_aed, ROUND(100*SUM(balance_aed)/NULLIF(SUM(SUM(balance_aed)) OVER(),0),1) amount_pct'||l_scope||' AND balance_aed>0.005 GROUP BY aging_bucket ORDER BY MIN(CASE aging_bucket WHEN ''CURRENT'' THEN 1 WHEN ''D1_30'' THEN 2 WHEN ''D31_60'' THEN 3 WHEN ''D61_90'' THEN 4 WHEN ''D91_180'' THEN 5 ELSE 6 END)"},'||
    '{"key":"suppliers","title":"Overdue Supplier Concentration","layout":"table","sql":"SELECT supplier, COUNT(*) invoice_count, SUM(balance_aed) amount_aed, ROUND(100*SUM(balance_aed)/NULLIF(SUM(SUM(balance_aed)) OVER(),0),1) amount_pct'||l_scope||' AND balance_aed>0.005 AND due_date<TRUNC(SYSDATE) GROUP BY supplier ORDER BY amount_aed DESC FETCH FIRST 10 ROWS ONLY"},'||
    '{"key":"attention","title":"Executive Attention Register","layout":"table","sql":"SELECT invoice_number, supplier, business_unit, invoice_date, due_date, TRUNC(SYSDATE)-due_date days_overdue, aging_bucket, balance_aed, payment_status, validation_status, approval_status'||l_scope||' AND balance_aed>0.005 AND due_date<TRUNC(SYSDATE) ORDER BY balance_aed DESC FETCH FIRST 100 ROWS ONLY"}'||
    ']}';
  l_src := REPLACE(l_src,'[COLON]',CHR(58));
  MERGE INTO prod.dct_rpt_definition t USING (SELECT 'EXEC_AP_AGING_BOOK' report_code FROM dual) s
  ON (t.report_code=s.report_code)
  WHEN MATCHED THEN UPDATE SET t.name_en='Executive AP Aging Briefing Report',t.description='Filtered executive AP aging summary, aging exposure, supplier concentration and attention register.',t.source_type='MULTI',t.source_ref=l_src,t.engine='PYTHON',t.default_formats='PDF',t.params_json='{"bu":null,"supplier":null,"aging":null}',t.enabled='Y',t.updated_by='SETUP',t.updated_at=SYSTIMESTAMP
  WHEN NOT MATCHED THEN INSERT (report_code,name_en,name_ar,description,category,source_type,source_ref,engine,default_formats,params_json,enabled,created_by,updated_by)
  VALUES ('EXEC_AP_AGING_BOOK','Executive AP Aging Briefing Report',UNISTR('\062A\0642\0631\064A\0631 \0625\062D\0627\0637\0629 \062A\0642\0627\062F\0645 \0627\0644\0630\0645\0645 \0627\0644\062F\0627\0626\0646\0629'),'Filtered executive AP aging summary, aging exposure, supplier concentration and attention register.','Accounts Payable','MULTI',l_src,'PYTHON','PDF','{"bu":null,"supplier":null,"aging":null}','Y','SETUP','SETUP');
  COMMIT;
END;
/
PROMPT 36_rpt_exec_ap_aging_book.sql complete

DECLARE
  l_handler CLOB;
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'rpt.rest',p_pattern=>'executive-aging/briefing');
  l_handler := q'~
DECLARE
  l_user VARCHAR2(100):=dct_rest.validate_session;
  l_run NUMBER; l_params CLOB;
  PROCEDURE put(p_name VARCHAR2) IS l_v VARCHAR2(4000):=APEX_JSON.get_varchar2(p_path=>p_name); BEGIN IF l_v IS NOT NULL THEN APEX_JSON.write(p_name,l_v); END IF; END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN dct_rest.err(403,'BI access required'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  APEX_JSON.initialize_clob_output; APEX_JSON.open_object; put('bu'); put('supplier'); put('aging'); APEX_JSON.close_object;
  l_params:=APEX_JSON.get_clob_output; APEX_JSON.free_output;
  l_run:=dct_rpt_pkg.enqueue(p_report_code=>'EXEC_AP_AGING_BOOK',p_params=>l_params,p_trigger=>'ONDEMAND',p_requested_by=>l_user,p_formats=>'PDF');
  COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('runId',l_run); APEX_JSON.write('status','QUEUED'); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM);
END;~';
  l_handler := REPLACE(l_handler,'[COLON]',CHR(58));
  ORDS.DEFINE_HANDLER(p_module_name=>'rpt.rest',p_pattern=>'executive-aging/briefing',p_method=>'POST',p_source_type=>ORDS.source_type_plsql,p_source=>l_handler);
  COMMIT;
END;
/
