-- =============================================================================
-- i-Finance V2 - Excel integration layer (part 3): VB template repository
-- File    : 108_xl_templates.sql
-- Schema  : PROD (run as ADMIN, objects schema-qualified)
-- Date    : 2026-07-27
-- =============================================================================
-- Requirement: one repository for ALL Visual Builder Add-in workbook templates
-- (any process, not just budget override). Each template (process) has
-- versions; a version carries BOTH files - the unpublished master (Designer
-- editable, admin-only) and the published end-user copy - and ONLY ONE version
-- per template can be active. End users may download only the ACTIVE
-- version's PUBLISHED file; masters and inactive versions are admin-only.
-- Served by the xl.rest ORDS module (107) with Bearer-session auth.
-- Rerunnable. No MERGE keyword (Linux SQLcl swallowing gotcha).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 108.1 tables ===

DECLARE
    l_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_cnt
    FROM   all_tables WHERE owner = 'PROD' AND table_name = 'DCT_XL_TEMPLATE';
    IF l_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE prod.dct_xl_template (
                template_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                template_code    VARCHAR2(40)  NOT NULL,
                template_name    VARCHAR2(120) NOT NULL,
                template_name_ar VARCHAR2(240),
                description      VARCHAR2(1000),
                module_code      VARCHAR2(20),
                created_by       VARCHAR2(100),
                created_at       TIMESTAMP DEFAULT SYSTIMESTAMP,
                updated_by       VARCHAR2(100),
                updated_at       TIMESTAMP,
                CONSTRAINT uq_dct_xl_tpl_code UNIQUE (template_code)
            )]';
    END IF;

    SELECT COUNT(*) INTO l_cnt
    FROM   all_tables WHERE owner = 'PROD' AND table_name = 'DCT_XL_TEMPLATE_VERSION';
    IF l_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE prod.dct_xl_template_version (
                version_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                template_id        NUMBER        NOT NULL,
                version_no         NUMBER        NOT NULL,
                is_active          VARCHAR2(1)   DEFAULT 'N' NOT NULL,
                notes              VARCHAR2(1000),
                master_blob        BLOB,
                master_filename    VARCHAR2(255),
                master_mime        VARCHAR2(100),
                master_uploaded_by VARCHAR2(100),
                master_uploaded_at TIMESTAMP,
                pub_blob           BLOB,
                pub_filename       VARCHAR2(255),
                pub_mime           VARCHAR2(100),
                pub_uploaded_by    VARCHAR2(100),
                pub_uploaded_at    TIMESTAMP,
                created_by         VARCHAR2(100),
                created_at         TIMESTAMP DEFAULT SYSTIMESTAMP,
                CONSTRAINT fk_dct_xl_tplv FOREIGN KEY (template_id)
                    REFERENCES prod.dct_xl_template (template_id),
                CONSTRAINT uq_dct_xl_tplv UNIQUE (template_id, version_no),
                CONSTRAINT chk_dct_xl_tplv_act CHECK (is_active IN ('Y','N'))
            )]';
        EXECUTE IMMEDIATE q'[
            CREATE UNIQUE INDEX prod.uq_dct_xl_tplv_active
            ON prod.dct_xl_template_version
               (CASE WHEN is_active = 'Y' THEN template_id END)]';
    END IF;
END;
/

PROMPT === 108.2 package DCT_XL_TPL ===

CREATE OR REPLACE PACKAGE prod.dct_xl_tpl AS
    PROCEDURE emit_list;
    PROCEDURE save_template  (p_user IN VARCHAR2, p_body IN BLOB);
    PROCEDURE new_version    (p_user IN VARCHAR2, p_body IN BLOB);
    PROCEDURE activate       (p_user IN VARCHAR2, p_body IN BLOB);
    PROCEDURE delete_version (p_user IN VARCHAR2, p_body IN BLOB);
    PROCEDURE upload_file (
        p_user        IN VARCHAR2,
        p_template_id IN VARCHAR2,
        p_ver         IN VARCHAR2,
        p_kind        IN VARCHAR2,
        p_filename    IN VARCHAR2,
        p_body        IN BLOB
    );
    -- admin: any version, any kind
    PROCEDURE stream_file (
        p_template_id IN VARCHAR2,
        p_ver         IN VARCHAR2,
        p_kind        IN VARCHAR2
    );
    -- end user: the ACTIVE version's PUBLISHED file only
    PROCEDURE stream_active (p_code IN VARCHAR2);
END dct_xl_tpl;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_xl_tpl AS

    c_max_mb CONSTANT NUMBER := 30;

    PROCEDURE stream (
        p_blob  IN BLOB,
        p_fname IN VARCHAR2,
        p_mime  IN VARCHAR2
    ) IS
        c_col CONSTANT VARCHAR2(1) := CHR(58);
        l_b   BLOB := p_blob;
    BEGIN
        OWA_UTIL.mime_header(NVL(p_mime,
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'), FALSE);
        HTP.p('Content-Disposition' || c_col || ' attachment; filename="' ||
              REPLACE(NVL(p_fname, 'template.xlsx'), '"') || '"');
        HTP.p('Content-Length' || c_col || ' ' || DBMS_LOB.getlength(l_b));
        OWA_UTIL.http_header_close;
        WPG_DOCLOAD.download_file(l_b);
    END stream;

    PROCEDURE emit_list IS
    BEGIN
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.open_array('items');
        FOR t IN (SELECT * FROM dct_xl_template ORDER BY template_code) LOOP
            APEX_JSON.open_object;
            APEX_JSON.write('templateId',   t.template_id);
            APEX_JSON.write('code',         t.template_code);
            APEX_JSON.write('name',         t.template_name);
            APEX_JSON.write('nameAr',       t.template_name_ar,  p_write_null => TRUE);
            APEX_JSON.write('description',  t.description,       p_write_null => TRUE);
            APEX_JSON.write('module',       t.module_code,       p_write_null => TRUE);
            APEX_JSON.open_array('versions');
            FOR v IN (SELECT * FROM dct_xl_template_version
                      WHERE template_id = t.template_id
                      ORDER BY version_no DESC) LOOP
                APEX_JSON.open_object;
                APEX_JSON.write('versionNo',    v.version_no);
                APEX_JSON.write('isActive',     v.is_active);
                APEX_JSON.write('notes',        v.notes, p_write_null => TRUE);
                APEX_JSON.write('masterFile',   v.master_filename, p_write_null => TRUE);
                APEX_JSON.write('masterSizeKb',
                    CASE WHEN v.master_blob IS NULL THEN NULL
                         ELSE ROUND(DBMS_LOB.getlength(v.master_blob)/1024) END,
                    p_write_null => TRUE);
                APEX_JSON.write('masterBy', v.master_uploaded_by, p_write_null => TRUE);
                APEX_JSON.write('masterAt',
                    CASE WHEN v.master_uploaded_at IS NULL THEN NULL
                         ELSE TO_CHAR(dct_to_local(v.master_uploaded_at),'YYYY-MM-DD HH:MI AM') END,
                    p_write_null => TRUE);
                APEX_JSON.write('pubFile',      v.pub_filename, p_write_null => TRUE);
                APEX_JSON.write('pubSizeKb',
                    CASE WHEN v.pub_blob IS NULL THEN NULL
                         ELSE ROUND(DBMS_LOB.getlength(v.pub_blob)/1024) END,
                    p_write_null => TRUE);
                APEX_JSON.write('pubBy', v.pub_uploaded_by, p_write_null => TRUE);
                APEX_JSON.write('pubAt',
                    CASE WHEN v.pub_uploaded_at IS NULL THEN NULL
                         ELSE TO_CHAR(dct_to_local(v.pub_uploaded_at),'YYYY-MM-DD HH:MI AM') END,
                    p_write_null => TRUE);
                APEX_JSON.close_object;
            END LOOP;
            APEX_JSON.close_array;
            APEX_JSON.close_object;
        END LOOP;
        APEX_JSON.close_array;
        APEX_JSON.close_object;
    END emit_list;

    PROCEDURE save_template (p_user IN VARCHAR2, p_body IN BLOB) IS
        l_id   NUMBER;
        l_code VARCHAR2(40);
    BEGIN
        dct_rest.parse_body(p_body);
        l_id := APEX_JSON.get_number('templateId');
        IF l_id IS NULL THEN
            l_code := UPPER(TRIM(APEX_JSON.get_varchar2('code')));
            IF l_code IS NULL OR APEX_JSON.get_varchar2('name') IS NULL THEN
                dct_rest.err(400, 'code and name are required');
                RETURN;
            END IF;
            INSERT INTO dct_xl_template
                   (template_code, template_name, template_name_ar,
                    description, module_code, created_by)
            VALUES (l_code,
                    APEX_JSON.get_varchar2('name'),
                    APEX_JSON.get_varchar2('nameAr'),
                    APEX_JSON.get_varchar2('description'),
                    UPPER(APEX_JSON.get_varchar2('module')),
                    p_user)
            RETURNING template_id INTO l_id;
        ELSE
            UPDATE dct_xl_template
            SET    template_name    = NVL(APEX_JSON.get_varchar2('name'), template_name),
                   template_name_ar = CASE WHEN APEX_JSON.does_exist('nameAr')
                                           THEN APEX_JSON.get_varchar2('nameAr')
                                           ELSE template_name_ar END,
                   description      = CASE WHEN APEX_JSON.does_exist('description')
                                           THEN APEX_JSON.get_varchar2('description')
                                           ELSE description END,
                   module_code      = CASE WHEN APEX_JSON.does_exist('module')
                                           THEN UPPER(APEX_JSON.get_varchar2('module'))
                                           ELSE module_code END,
                   updated_by = p_user, updated_at = SYSTIMESTAMP
            WHERE  template_id = l_id;
            IF SQL%ROWCOUNT = 0 THEN
                dct_rest.err(404, 'Template not found');
                RETURN;
            END IF;
        END IF;
        COMMIT;
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.write('templateId', l_id);
        APEX_JSON.close_object;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dct_rest.err(400, 'Template code already exists');
    END save_template;

    PROCEDURE new_version (p_user IN VARCHAR2, p_body IN BLOB) IS
        l_id  NUMBER;
        l_ver NUMBER;
    BEGIN
        dct_rest.parse_body(p_body);
        l_id := APEX_JSON.get_number('templateId');
        SELECT COUNT(*) INTO l_ver FROM dct_xl_template WHERE template_id = l_id;
        IF l_ver = 0 THEN
            dct_rest.err(404, 'Template not found');
            RETURN;
        END IF;
        SELECT NVL(MAX(version_no), 0) + 1 INTO l_ver
        FROM   dct_xl_template_version WHERE template_id = l_id;
        INSERT INTO dct_xl_template_version
               (template_id, version_no, notes, created_by)
        VALUES (l_id, l_ver, APEX_JSON.get_varchar2('notes'), p_user);
        COMMIT;
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.write('versionNo', l_ver);
        APEX_JSON.close_object;
    END new_version;

    PROCEDURE activate (p_user IN VARCHAR2, p_body IN BLOB) IS
        l_id  NUMBER;
        l_ver NUMBER;
        l_ok  NUMBER;
    BEGIN
        dct_rest.parse_body(p_body);
        l_id  := APEX_JSON.get_number('templateId');
        l_ver := APEX_JSON.get_number('versionNo');
        SELECT COUNT(*) INTO l_ok
        FROM   dct_xl_template_version
        WHERE  template_id = l_id AND version_no = l_ver AND pub_blob IS NOT NULL;
        IF l_ok = 0 THEN
            dct_rest.err(400, 'Version not found or has no published file - upload the published workbook first');
            RETURN;
        END IF;
        UPDATE dct_xl_template_version SET is_active = 'N'
        WHERE  template_id = l_id AND is_active = 'Y';
        UPDATE dct_xl_template_version SET is_active = 'Y'
        WHERE  template_id = l_id AND version_no = l_ver;
        UPDATE dct_xl_template SET updated_by = p_user, updated_at = SYSTIMESTAMP
        WHERE  template_id = l_id;
        COMMIT;
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.write('ok', 1);
        APEX_JSON.close_object;
    END activate;

    PROCEDURE delete_version (p_user IN VARCHAR2, p_body IN BLOB) IS
        l_id  NUMBER;
        l_ver NUMBER;
    BEGIN
        dct_rest.parse_body(p_body);
        l_id  := APEX_JSON.get_number('templateId');
        l_ver := APEX_JSON.get_number('versionNo');
        DELETE FROM dct_xl_template_version
        WHERE  template_id = l_id AND version_no = l_ver AND is_active = 'N';
        IF SQL%ROWCOUNT = 0 THEN
            dct_rest.err(400, 'Version not found or is the ACTIVE version (deactivate first)');
            RETURN;
        END IF;
        COMMIT;
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.write('ok', 1);
        APEX_JSON.close_object;
    END delete_version;

    PROCEDURE upload_file (
        p_user        IN VARCHAR2,
        p_template_id IN VARCHAR2,
        p_ver         IN VARCHAR2,
        p_kind        IN VARCHAR2,
        p_filename    IN VARCHAR2,
        p_body        IN BLOB
    ) IS
        l_blob BLOB := p_body;
        l_kind VARCHAR2(20) := LOWER(TRIM(p_kind));
    BEGIN
        IF l_kind NOT IN ('master', 'published') THEN
            dct_rest.err(400, 'kind must be master or published');
            RETURN;
        END IF;
        IF l_blob IS NULL OR DBMS_LOB.getlength(l_blob) = 0 THEN
            dct_rest.err(400, 'Empty file');
            RETURN;
        END IF;
        IF DBMS_LOB.getlength(l_blob) > c_max_mb * 1024 * 1024 THEN
            dct_rest.err(413, 'File exceeds ' || c_max_mb || ' MB');
            RETURN;
        END IF;
        IF l_kind = 'master' THEN
            UPDATE dct_xl_template_version
            SET    master_blob = l_blob, master_filename = p_filename,
                   master_mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                   master_uploaded_by = p_user, master_uploaded_at = SYSTIMESTAMP
            WHERE  template_id = TO_NUMBER(p_template_id)
              AND  version_no  = TO_NUMBER(p_ver);
        ELSE
            UPDATE dct_xl_template_version
            SET    pub_blob = l_blob, pub_filename = p_filename,
                   pub_mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                   pub_uploaded_by = p_user, pub_uploaded_at = SYSTIMESTAMP
            WHERE  template_id = TO_NUMBER(p_template_id)
              AND  version_no  = TO_NUMBER(p_ver);
        END IF;
        IF SQL%ROWCOUNT = 0 THEN
            dct_rest.err(404, 'Template version not found');
            RETURN;
        END IF;
        COMMIT;
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.write('ok', 1);
        APEX_JSON.close_object;
    END upload_file;

    PROCEDURE stream_file (
        p_template_id IN VARCHAR2,
        p_ver         IN VARCHAR2,
        p_kind        IN VARCHAR2
    ) IS
        v dct_xl_template_version%ROWTYPE;
    BEGIN
        SELECT * INTO v FROM dct_xl_template_version
        WHERE  template_id = TO_NUMBER(p_template_id)
          AND  version_no  = TO_NUMBER(p_ver);
        IF LOWER(p_kind) = 'master' THEN
            IF v.master_blob IS NULL THEN
                dct_rest.err(404, 'No master file on this version');
                RETURN;
            END IF;
            stream(v.master_blob, v.master_filename, v.master_mime);
        ELSE
            IF v.pub_blob IS NULL THEN
                dct_rest.err(404, 'No published file on this version');
                RETURN;
            END IF;
            stream(v.pub_blob, v.pub_filename, v.pub_mime);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dct_rest.err(404, 'Template version not found');
    END stream_file;

    PROCEDURE stream_active (p_code IN VARCHAR2) IS
        v dct_xl_template_version%ROWTYPE;
    BEGIN
        SELECT v2.* INTO v
        FROM   dct_xl_template t
        JOIN   dct_xl_template_version v2 ON v2.template_id = t.template_id
        WHERE  t.template_code = UPPER(TRIM(p_code))
          AND  v2.is_active = 'Y';
        IF v.pub_blob IS NULL THEN
            dct_rest.err(404, 'Active version has no published file');
            RETURN;
        END IF;
        stream(v.pub_blob, v.pub_filename, v.pub_mime);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dct_rest.err(404, 'No active template for this code');
    END stream_active;

END dct_xl_tpl;
/

PROMPT === 108.3 seed the budget override process row ===

DECLARE
    l_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_cnt FROM prod.dct_xl_template
    WHERE  template_code = 'BUDGET_OVERRIDE';
    IF l_cnt = 0 THEN
        INSERT INTO prod.dct_xl_template
               (template_code, template_name, template_name_ar, description,
                module_code, created_by)
        VALUES ('BUDGET_OVERRIDE',
                'Project Budget Override',
                UNISTR('\062A\0639\062F\064A\0644 \0645\064A\0632\0627\0646\064A\0629 \0627\0644\0645\0634\0627\0631\064A\0639'),
                'Excel workbook (Visual Builder Add-in) for entering the end-user BUDGET_USER override per project budget line.',
                'GL', 'SYSTEM');
    END IF;
    COMMIT;
END;
/

PROMPT === 108.4 compile check ===
SELECT object_name, object_type, status FROM all_objects
WHERE  owner = 'PROD' AND object_name IN ('DCT_XL_TPL','DCT_XL_TEMPLATE','DCT_XL_TEMPLATE_VERSION')
ORDER  BY object_name, object_type;
