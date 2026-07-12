-- =============================================================================
-- i-Finance V2 -- AR Customer -- DoF Fusion Receivables SOAP client package
-- File    : 09_ar_customer_ws_pkg.sql
-- Schema  : PROD (run as ADMIN: sql -name prod_mcp)
-- Run     : after 08_ar_customer_ddl.sql
-- Spec    : final apps/AR/docs/ws/receivables-customer-ws.md
-- =============================================================================
-- DCT_AR_WS_PKG -- envelope builder + gateway client + response parsing for the
-- generic ADG SOAP wrapper (operation CreateCustomers / getEntityCustomerDtls).
-- AR_WS_LIVE=N -> mock mode: no outbound call, simulated wrapper response.
-- Wire values, required set and LOVs per the docs/ws spec (SoapUI-derived).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_ar_ws_pkg AS

    -- submit a DRAFT/ERROR row to Fusion (CreateCustomers, TRX_OPER from row)
    PROCEDURE submit_customer (p_customer_id IN NUMBER, p_user IN VARCHAR2);

    -- live customer search / status query (getEntityCustomerDtls);
    -- returns the raw SOAP response XML (mock sample when AR_WS_LIVE=N)
    FUNCTION ws_query (
        p_customer_code IN VARCHAR2 DEFAULT NULL,
        p_cust_name     IN VARCHAR2 DEFAULT NULL,
        p_vat_number    IN VARCHAR2 DEFAULT NULL,
        p_iden_num      IN VARCHAR2 DEFAULT NULL,
        p_cr_number     IN VARCHAR2 DEFAULT NULL,
        p_from_date     IN VARCHAR2 DEFAULT NULL,   -- DD-MM-YYYY
        p_to_date       IN VARCHAR2 DEFAULT NULL,   -- DD-MM-YYYY
        p_status        IN VARCHAR2 DEFAULT NULL,   -- e.g. PROCESSED
        p_page_no       IN NUMBER   DEFAULT NULL
    ) RETURN CLOB;

    -- poll Fusion for a SENT row; capture fusion_customer_code when PROCESSED
    PROCEDURE sync_status (p_customer_id IN NUMBER, p_user IN VARCHAR2);

    -- generic row extraction: repeating leaf-only elements -> JSON {rows:[{...}]}
    FUNCTION response_rows_json (p_resp IN CLOB) RETURN CLOB;

    -- exposed for SQL/handler use
    FUNCTION get_ws_setting (p_key IN VARCHAR2) RETURN VARCHAR2;

END dct_ar_ws_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_ar_ws_pkg AS

    c_ns CONSTANT VARCHAR2(200) :=
        'http://xmlns.oracle.com/ADGGenericSoapWrapperApplication/ADGGenericSoapWrapperProcess';

    -- ordered tag list of postCustomerData (spec section 4); values that are
    -- dates in ISO form are converted to the gateway DD-MM-YYYY format
    TYPE t_taglist IS TABLE OF VARCHAR2(60);
    c_tags CONSTANT t_taglist := t_taglist(
        'TRX_OPER','CUSTOMER_TYPE','CUSTOMER_NAME','CUSTOMER_CATEGORY_NAME',
        'CUSTOMER_CLASS_NAME','COUNTRY_CODE','CITY','ADDRESS1','ADDRESS2','ADDRESS3',
        'ADDRESS4','POSTAL_CODE','SITE_NAME','SITE_CODE','PO_BOX_NUMBER','AREA',
        'SITE_END_DATE','PAYMENT_TERMS','TRADE_LICENSE_NUM','LEGACY_CUSTOMER_NUMBER',
        'LEGACY_CUSTOMER_SITE_NUMBER','CONTACT_PERSON','CONTACT_NUMBER','EMAIL_ADDRESS',
        'COLLECTOR_NAME','SOURCE_SYSTEM','PERSON_IDEN_TYPE','PERSON_IDENTIFIER',
        'VAT_NUMBER','VAT_REGISTERATION_TYPE','VAT_REG_START_DATE','VAT_REG_END_DATE',
        'TAX_REGIME_CODE','EMIRATE','ATTRIBUTE10','CUSTOMER_NAME_AR','CUST_SITE_PURPOSE',
        'ACCT_CONTACT_RESP_TYPE','PARENT_CUST_ACCT_NO','CHILD_CUST_ACCT_NO',
        'ACC_REL_ADDR_SET','RECIPROCAL_RELATIONSHIP','REL_START_DATE','CONTEXT_VALUE',
        'ORG_CODE','SITE_NUMBER','TAX_REG_NUM_FLAG','TAX_REG_NUM_REASON','ACCT_ESTD_DATE',
        'PREF_DELIVERY_METHOD','GENERATE_BILL_FLAG','BANK_ACCT_NAME','ACCT_PRIMARY_IND',
        'BANK_FROM_DATE','BANK_ACCT_NUMBER','BANK_ACCT_CURRENCY','BANK_NAME','BRANCH_NAME',
        'BANK_HOME_COUNTRY_CODE','BANK_ACCT_COUNTRY_CODE','PRIMARY_OWNER','IBAN',
        'SEND_STATEMENT','STATEMENT_CYCLE','SEND_CREDIT_BALANCE','SEND_DUNNING_LETTERS',
        'PREF_CONTACT_METHOD','STATEMENT_PREF_DELIVERY_METHOD','CUSTOMER_PROFILE'
    );

    ----------------------------------------------------------------------------
    PROCEDURE clob_append (p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
    BEGIN
        IF p_text IS NOT NULL THEN
            dbms_lob.writeappend(p_clob, LENGTH(p_text), p_text);
        END IF;
    END clob_append;

    ----------------------------------------------------------------------------
    FUNCTION get_ws_setting (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v_val VARCHAR2(1000);
    BEGIN
        BEGIN
            SELECT s.setting_value INTO v_val
            FROM   dct_module_settings s
            JOIN   dct_modules m ON m.module_id = s.module_id
            WHERE  m.module_code = 'ACCOUNTS_RECEIVABLE'
            AND    s.setting_key = p_key;
            RETURN v_val;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            NULL;
        END;
        SELECT ss.setting_value INTO v_val
        FROM   dct_system_settings ss
        WHERE  ss.setting_key = p_key;
        RETURN v_val;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END get_ws_setting;

    ----------------------------------------------------------------------------
    FUNCTION is_live RETURN BOOLEAN IS
    BEGIN
        RETURN NVL(get_ws_setting('AR_WS_LIVE'), 'N') = 'Y';
    END is_live;

    ----------------------------------------------------------------------------
    FUNCTION env_suffix RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN NVL(get_ws_setting('AR_WS_ENV'), 'STAGE') = 'PROD'
                    THEN 'PROD' ELSE 'STAGE' END;
    END env_suffix;

    ----------------------------------------------------------------------------
    FUNCTION xesc (p_val IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN dbms_xmlgen.convert(p_val, dbms_xmlgen.entity_encode);
    END xesc;

    ----------------------------------------------------------------------------
    -- ISO date (YYYY-MM-DD[...]) -> gateway DD-MM-YYYY; anything else passes through
    FUNCTION fmt_ws_date (p_val IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF REGEXP_LIKE(p_val, '^\d{4}-\d{2}-\d{2}') THEN
            RETURN TO_CHAR(TO_DATE(SUBSTR(p_val, 1, 10), 'YYYY-MM-DD'), 'DD-MM-YYYY');
        END IF;
        RETURN p_val;
    END fmt_ws_date;

    ----------------------------------------------------------------------------
    -- build <postCustomerData> from the row payload_json (tag order = c_tags);
    -- ORG_CODE / SOURCE_SYSTEM always stamped from settings
    FUNCTION build_customer_xml (p_payload IN CLOB) RETURN CLOB IS
        v_xml   CLOB;
        v_val   VARCHAR2(4000);
        v_tag   VARCHAR2(60);
        v_dates CONSTANT VARCHAR2(200) :=
            '|SITE_END_DATE|VAT_REG_START_DATE|VAT_REG_END_DATE|ACCT_ESTD_DATE|REL_START_DATE|BANK_FROM_DATE|';
    BEGIN
        APEX_JSON.parse(p_payload);
        dbms_lob.createtemporary(v_xml, TRUE);
        clob_append(v_xml, '<postCustomerData>');
        FOR i IN 1 .. c_tags.COUNT LOOP
            v_tag := c_tags(i);
            IF v_tag = 'ORG_CODE' THEN
                v_val := NVL(get_ws_setting('AR_WS_ORG_CODE'), 'DCT');
            ELSIF v_tag = 'SOURCE_SYSTEM' THEN
                v_val := NVL(get_ws_setting('AR_WS_SOURCE_SYSTEM'), 'DCT_SYSTEM');
            ELSE
                v_val := APEX_JSON.get_varchar2(p_path => v_tag);
            END IF;
            IF v_val IS NOT NULL THEN
                IF INSTR(v_dates, '|' || v_tag || '|') > 0 THEN
                    v_val := fmt_ws_date(v_val);
                END IF;
                clob_append(v_xml,
                    '<' || v_tag || '>' || xesc(v_val) || '</' || v_tag || '>');
            END IF;
        END LOOP;
        clob_append(v_xml, '</postCustomerData>');
        RETURN v_xml;
    END build_customer_xml;

    ----------------------------------------------------------------------------
    FUNCTION build_envelope (p_operation IN VARCHAR2, p_inner IN CLOB) RETURN CLOB IS
        v_env CLOB;
    BEGIN
        dbms_lob.createtemporary(v_env, TRUE);
        clob_append(v_env,
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'
            || ' xmlns:adg="' || c_ns || '">'
            || '<soapenv:Header/><soapenv:Body>'
            || '<adg:ADGRequestPayload>'
            || '<adg:OperationName>' || p_operation || '</adg:OperationName>'
            || '<adg:InputPayload>');
        clob_append(v_env, p_inner);
        clob_append(v_env,
            '</adg:InputPayload></adg:ADGRequestPayload>'
            || '</soapenv:Body></soapenv:Envelope>');
        RETURN v_env;
    END build_envelope;

    ----------------------------------------------------------------------------
    FUNCTION call_gateway (p_envelope IN CLOB, o_http_status OUT NUMBER) RETURN CLOB IS
        v_env  VARCHAR2(10)   := env_suffix;
        v_url  VARCHAR2(500)  := get_ws_setting('AR_WS_URL_' || v_env);
        v_key  VARCHAR2(200)  := get_ws_setting('AR_WS_APIKEY_' || v_env);
        v_user VARCHAR2(200)  := get_ws_setting('AR_WS_USER');
        v_pwd  VARCHAR2(200)  := get_ws_setting('AR_WS_PASSWORD_' || v_env);
        v_resp CLOB;
    BEGIN
        IF v_url IS NULL OR v_key IS NULL OR v_user IS NULL OR v_pwd IS NULL
           OR v_pwd = 'CHANGE_ME' THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Gateway credentials incomplete for environment ' || v_env ||
                ' - set the AR_WS_* module settings.');
        END IF;
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name  := 'x-CentraSite-APIKey';
        apex_web_service.g_request_headers(1).value := v_key;
        apex_web_service.g_request_headers(2).name  := 'SOAPAction';
        apex_web_service.g_request_headers(2).value := 'ADGSoapWraperProcess';
        apex_web_service.g_request_headers(3).name  := 'Content-Type';
        apex_web_service.g_request_headers(3).value := 'text/xml;charset=UTF-8';
        v_resp := apex_web_service.make_rest_request(
            p_url         => v_url,
            p_http_method => 'POST',
            p_username    => v_user,
            p_password    => v_pwd,
            p_body        => p_envelope);
        o_http_status := apex_web_service.g_status_code;
        RETURN v_resp;
    END call_gateway;

    ----------------------------------------------------------------------------
    FUNCTION extract_fault (p_resp IN CLOB) RETURN VARCHAR2 IS
        v_fault VARCHAR2(2000);
    BEGIN
        IF p_resp IS NULL OR dbms_lob.getlength(p_resp) = 0 THEN
            RETURN 'Empty response from gateway';
        END IF;
        BEGIN
            SELECT XMLCAST(
                       XMLQUERY('//*[local-name()="faultstring"]/text()'
                                PASSING xmltype(p_resp) RETURNING CONTENT)
                       AS VARCHAR2(2000))
            INTO   v_fault FROM dual;
        EXCEPTION WHEN OTHERS THEN
            RETURN 'Unparseable response: ' || dbms_lob.substr(p_resp, 500, 1);
        END;
        RETURN v_fault;  -- NULL when no fault
    END extract_fault;

    ----------------------------------------------------------------------------
    -- pull the first element with the given local-name out of a response
    FUNCTION extract_node (p_resp IN CLOB, p_name IN VARCHAR2) RETURN VARCHAR2 IS
        v_val VARCHAR2(1000);
    BEGIN
        SELECT XMLCAST(
                   XMLQUERY('(//*[local-name()=$n]/text())[1]'
                            PASSING xmltype(p_resp), p_name AS "n"
                            RETURNING CONTENT)
                   AS VARCHAR2(1000))
        INTO   v_val FROM dual;
        RETURN v_val;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END extract_node;

    ----------------------------------------------------------------------------
    -- generic rows -> JSON: any element whose children are all leaves and that
    -- has more than one child is treated as one row. NOTE: heuristic parser --
    -- refine against the first captured live response if the shape differs.
    FUNCTION response_rows_json (p_resp IN CLOB) RETURN CLOB IS
        v_out CLOB;
    BEGIN
        APEX_JSON.initialize_clob_output;
        APEX_JSON.open_object;
        APEX_JSON.open_array('rows');
        FOR r IN (
            SELECT COLUMN_VALUE AS node
            FROM   XMLTABLE('//*[count(*) > 1 and count(*//*[*]) = 0]'
                            PASSING xmltype(p_resp))
        ) LOOP
            APEX_JSON.open_object;
            FOR leaf IN (
                SELECT x.tag, x.val
                FROM   XMLTABLE('/*/*' PASSING r.node
                       COLUMNS tag VARCHAR2(100)  PATH 'local-name(.)',
                               val VARCHAR2(4000) PATH 'text()') x
            ) LOOP
                APEX_JSON.write(leaf.tag, leaf.val);
            END LOOP;
            APEX_JSON.close_object;
        END LOOP;
        APEX_JSON.close_array;
        APEX_JSON.close_object;
        v_out := APEX_JSON.get_clob_output;
        APEX_JSON.free_output;
        RETURN v_out;
    EXCEPTION WHEN OTHERS THEN
        BEGIN APEX_JSON.free_output; EXCEPTION WHEN OTHERS THEN NULL; END;
        RETURN '{"rows":[]}';
    END response_rows_json;

    ----------------------------------------------------------------------------
    FUNCTION mock_create_response (p_id IN NUMBER) RETURN CLOB IS
    BEGIN
        RETURN '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
            || '<soapenv:Body><ADGResponsePayload xmlns="' || c_ns || '">'
            || '<OutputPayload><CreateCustomersResponse><return>'
            || '<STATUS>SUCCESS</STATUS>'
            || '<MESSAGE>MOCK - record accepted into customer interface</MESSAGE>'
            || '</return></CreateCustomersResponse></OutputPayload>'
            || '</ADGResponsePayload></soapenv:Body></soapenv:Envelope>';
    END mock_create_response;

    ----------------------------------------------------------------------------
    FUNCTION mock_query_response (p_id IN NUMBER, p_legacy IN VARCHAR2) RETURN CLOB IS
    BEGIN
        RETURN '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
            || '<soapenv:Body><ADGResponsePayload xmlns="' || c_ns || '">'
            || '<OutputPayload><getEntityCustomerDtlsResponse><return>'
            || '<customerRow>'
            || '<CUSTOMER_CODE>MOCK-' || TO_CHAR(p_id) || '</CUSTOMER_CODE>'
            || '<CUSTOMER_NAME>Mock Customer</CUSTOMER_NAME>'
            || '<LEGACY_CUSTOMER_NUMBER>' || xesc(p_legacy) || '</LEGACY_CUSTOMER_NUMBER>'
            || '<SITE_NUMBER>MOCK-SITE-' || TO_CHAR(p_id) || '</SITE_NUMBER>'
            || '<STATUS>PROCESSED</STATUS>'
            || '</customerRow>'
            || '</return></getEntityCustomerDtlsResponse></OutputPayload>'
            || '</ADGResponsePayload></soapenv:Body></soapenv:Envelope>';
    END mock_query_response;

    ----------------------------------------------------------------------------
    PROCEDURE submit_customer (p_customer_id IN NUMBER, p_user IN VARCHAR2) IS
        v_row     dct_ar_customers%ROWTYPE;
        v_inner   CLOB;
        v_env     CLOB;
        v_resp    CLOB;
        v_http    NUMBER;
        v_fault   VARCHAR2(2000);
        v_ws_env  VARCHAR2(10);
    BEGIN
        BEGIN
            SELECT * INTO v_row FROM dct_ar_customers
            WHERE  customer_id = p_customer_id AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Customer submission not found');
        END;
        IF v_row.ws_status NOT IN ('DRAFT', 'ERROR') THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Only DRAFT or ERROR submissions can be submitted (current: '
                || v_row.ws_status || ')');
        END IF;
        IF v_row.payload_json IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Submission has no payload');
        END IF;

        v_inner := build_customer_xml(v_row.payload_json);
        v_inner := '<CreateCustomers><arg0>' || v_inner || '</arg0></CreateCustomers>';
        v_env   := build_envelope('CreateCustomers', v_inner);

        IF NOT is_live THEN
            v_ws_env := 'MOCK';
            v_resp   := mock_create_response(p_customer_id);
            v_http   := 200;
            v_fault  := NULL;
        ELSE
            v_ws_env := env_suffix;
            v_resp   := call_gateway(v_env, v_http);
            v_fault  := extract_fault(v_resp);
        END IF;

        IF v_http = 200 AND v_fault IS NULL THEN
            UPDATE dct_ar_customers
            SET    ws_status       = 'SENT',
                   ws_env          = v_ws_env,
                   ws_request_xml  = v_env,
                   ws_response_xml = v_resp,
                   error_message   = NULL,
                   submitted_at    = SYSTIMESTAMP,
                   updated_by      = p_user,
                   updated_at      = SYSTIMESTAMP
            WHERE  customer_id = p_customer_id;
        ELSE
            UPDATE dct_ar_customers
            SET    ws_status       = 'ERROR',
                   ws_env          = v_ws_env,
                   ws_request_xml  = v_env,
                   ws_response_xml = v_resp,
                   error_message   = SUBSTR(NVL(v_fault, 'HTTP ' || v_http), 1, 4000),
                   submitted_at    = SYSTIMESTAMP,
                   updated_by      = p_user,
                   updated_at      = SYSTIMESTAMP
            WHERE  customer_id = p_customer_id;
        END IF;
        COMMIT;
    END submit_customer;

    ----------------------------------------------------------------------------
    FUNCTION ws_query (
        p_customer_code IN VARCHAR2 DEFAULT NULL,
        p_cust_name     IN VARCHAR2 DEFAULT NULL,
        p_vat_number    IN VARCHAR2 DEFAULT NULL,
        p_iden_num      IN VARCHAR2 DEFAULT NULL,
        p_cr_number     IN VARCHAR2 DEFAULT NULL,
        p_from_date     IN VARCHAR2 DEFAULT NULL,
        p_to_date       IN VARCHAR2 DEFAULT NULL,
        p_status        IN VARCHAR2 DEFAULT NULL,
        p_page_no       IN NUMBER   DEFAULT NULL
    ) RETURN CLOB IS
        v_inner CLOB;
        v_env   CLOB;
        v_resp  CLOB;
        v_http  NUMBER;
        v_fault VARCHAR2(2000);
    BEGIN
        IF NOT is_live THEN
            RETURN mock_query_response(0, NVL(p_customer_code, NVL(p_cust_name, '-')));
        END IF;
        v_inner := '<getEntityCustomerDtls><arg0>'
            || '<CUSTOMER_CODE>'     || xesc(p_customer_code) || '</CUSTOMER_CODE>'
            || '<CUSTOMER_TYPE>ORGANIZATION</CUSTOMER_TYPE>'
            || '<CUST_UNIQUE_NUMBER/>'
            || '<CUST_VAT_NUMBER>'   || xesc(p_vat_number)    || '</CUST_VAT_NUMBER>'
            || '<PERSON_IDEN_NUM>'   || xesc(p_iden_num)      || '</PERSON_IDEN_NUM>'
            || '<CR_NUMBER>'         || xesc(p_cr_number)     || '</CR_NUMBER>'
            || '<CUST_NAME>'         || xesc(p_cust_name)     || '</CUST_NAME>'
            || '<ORG_CODE>' || xesc(NVL(get_ws_setting('AR_WS_ORG_CODE'), 'DCT')) || '</ORG_CODE>'
            || '<CUST_SOURCE_SYSTEM/>'
            || CASE WHEN p_from_date IS NOT NULL
                    THEN '<P_FROM_DATE>' || fmt_ws_date(p_from_date) || '</P_FROM_DATE>' END
            || CASE WHEN p_to_date IS NOT NULL
                    THEN '<P_TO_DATE>'   || fmt_ws_date(p_to_date)   || '</P_TO_DATE>' END
            || '<PAGE_NO>' || CASE WHEN p_page_no IS NULL THEN '' ELSE TO_CHAR(p_page_no) END || '</PAGE_NO>'
            || CASE WHEN p_status IS NOT NULL
                    THEN '<STATUS>' || xesc(p_status) || '</STATUS>' END
            || '</arg0></getEntityCustomerDtls>';
        v_env  := build_envelope('getEntityCustomerDtls', v_inner);
        v_resp := call_gateway(v_env, v_http);
        v_fault := extract_fault(v_resp);
        IF v_http <> 200 OR v_fault IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Gateway query failed: ' || NVL(v_fault, 'HTTP ' || v_http));
        END IF;
        RETURN v_resp;
    END ws_query;

    ----------------------------------------------------------------------------
    PROCEDURE sync_status (p_customer_id IN NUMBER, p_user IN VARCHAR2) IS
        v_row   dct_ar_customers%ROWTYPE;
        v_resp  CLOB;
        v_code  VARCHAR2(1000);
        v_site  VARCHAR2(1000);
    BEGIN
        BEGIN
            SELECT * INTO v_row FROM dct_ar_customers
            WHERE  customer_id = p_customer_id AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Customer submission not found');
        END;
        IF v_row.ws_status <> 'SENT' THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Only SENT submissions can be status-checked (current: '
                || v_row.ws_status || ')');
        END IF;

        IF NOT is_live THEN
            v_resp := mock_query_response(p_customer_id, v_row.legacy_customer_number);
        ELSE
            v_resp := ws_query(
                p_cust_name => v_row.customer_name,
                p_status    => 'PROCESSED');
        END IF;

        v_code := extract_node(v_resp, 'CUSTOMER_CODE');
        v_site := extract_node(v_resp, 'SITE_NUMBER');

        IF v_code IS NOT NULL THEN
            UPDATE dct_ar_customers
            SET    ws_status            = 'PROCESSED',
                   fusion_customer_code = SUBSTR(v_code, 1, 100),
                   fusion_site_number   = SUBSTR(v_site, 1, 100),
                   processed_at         = SYSTIMESTAMP,
                   updated_by           = p_user,
                   updated_at           = SYSTIMESTAMP
            WHERE  customer_id = p_customer_id;
            COMMIT;
        END IF;
        -- no match yet -> stays SENT (Fusion has not processed the record)
    END sync_status;

END dct_ar_ws_pkg;
/

SHOW ERRORS PACKAGE prod.dct_ar_ws_pkg
SHOW ERRORS PACKAGE BODY prod.dct_ar_ws_pkg

SELECT object_name, object_type, status FROM all_objects
WHERE  owner = 'PROD' AND object_name = 'DCT_AR_WS_PKG';

PROMPT 09_ar_customer_ws_pkg.sql complete
EXIT
