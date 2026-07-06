-- =============================================================================
-- 42_apex_211_dct_items.sql -- App 211 (BI - Reporting): standard DCT app items
--
-- App 211 was created as a headless shell for the NATIVE report engine and
-- never got the platform shared components. After subscribing it to App 200's
-- DCT Custom Auth scheme (done in Builder 2026-07-07), login failed with
-- ERR-1002 "Unable to find item USER_ID" because dct_auth.post_login populates
-- the 14 standard USER_* application items, which App 211 lacked.
--
-- Creates the same 14 items as db/v2/05b did for App 200 (ids 21101-21114).
-- 'S' = Checksum Required | 'N' = Unrestricted.  Run as ADMIN via SQLcl.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON

BEGIN
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd     => '2024.05.31',
        p_release                => '24.2.15',
        p_default_workspace_id   => 9249752073687531,
        p_default_application_id => 211,
        p_default_id_offset      => 0,
        p_default_owner          => 'PROD'
    );
    DBMS_OUTPUT.PUT_LINE('import_begin OK');
END;
/

PROMPT Creating 14 Application Items in App 211...
BEGIN
    wwv_flow_imp_shared.create_flow_item(p_id=>21101, p_flow_id=>211, p_name=>'USER_ID',               p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>21102, p_flow_id=>211, p_name=>'USER_DISPLAY_NAME',     p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21103, p_flow_id=>211, p_name=>'USER_DISPLAY_NAME_AR',  p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21104, p_flow_id=>211, p_name=>'USER_EMAIL',            p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21105, p_flow_id=>211, p_name=>'USER_LANGUAGE',         p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21106, p_flow_id=>211, p_name=>'USER_COLOR',            p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21107, p_flow_id=>211, p_name=>'USER_PHOTO_URL',        p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21108, p_flow_id=>211, p_name=>'USER_ORG_ID',           p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>21109, p_flow_id=>211, p_name=>'USER_ORG_IDS',          p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>21110, p_flow_id=>211, p_name=>'USER_ROLES',            p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>21111, p_flow_id=>211, p_name=>'IS_ADMIN',              p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>21112, p_flow_id=>211, p_name=>'IS_EXTERNAL',           p_protection_level=>'S');
    wwv_flow_imp_shared.create_flow_item(p_id=>21113, p_flow_id=>211, p_name=>'UNREAD_NOTIFICATIONS',  p_protection_level=>'N');
    wwv_flow_imp_shared.create_flow_item(p_id=>21114, p_flow_id=>211, p_name=>'ACTIVE_DELEGATION_FOR', p_protection_level=>'N');
    DBMS_OUTPUT.PUT_LINE('14 Application Items created in App 211.');
END;
/

COMMIT;

PROMPT Verify

SELECT item_name
FROM   apex_application_items
WHERE  application_id = 211
ORDER  BY item_name;

PROMPT 42_apex_211_dct_items.sql complete
