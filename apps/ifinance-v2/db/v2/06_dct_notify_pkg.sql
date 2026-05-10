-- =============================================================================
-- i-Finance V2 — Notification Package
-- File    : 06_dct_notify_pkg.sql
-- Schema  : PROD
-- Sprint  : 1 — Foundation
-- =============================================================================
-- Prerequisite: 01_dct_ddl.sql (dct_notifications, dct_users tables)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE dct_notify AS

    -- -------------------------------------------------------------------------
    -- Count unread notifications for a user.
    -- Called from the APEX Global Process "Refresh Notification Count":
    --   APEX_UTIL.SET_SESSION_STATE(
    --     'UNREAD_NOTIFICATIONS',
    --     dct_notify.get_unread_count(TO_NUMBER(:USER_ID))
    --   );
    -- Returns 0 (not NULL) when the user has no unread notifications or
    -- when p_user_id is NULL, so the APEX badge always has a numeric value.
    -- -------------------------------------------------------------------------
    FUNCTION get_unread_count (
        p_user_id IN NUMBER
    ) RETURN NUMBER;

    -- -------------------------------------------------------------------------
    -- Send a notification to a single recipient.
    -- module_code, link_url, title_ar, body_ar are optional.
    -- -------------------------------------------------------------------------
    PROCEDURE send (
        p_recipient_user_id IN NUMBER,
        p_notification_type IN VARCHAR2,
        p_title_en          IN VARCHAR2,
        p_body_en           IN VARCHAR2          DEFAULT NULL,
        p_title_ar          IN VARCHAR2          DEFAULT NULL,
        p_body_ar           IN VARCHAR2          DEFAULT NULL,
        p_module_code       IN VARCHAR2          DEFAULT NULL,
        p_link_url          IN VARCHAR2          DEFAULT NULL,
        p_expires_at        IN TIMESTAMP         DEFAULT NULL
    );

    -- -------------------------------------------------------------------------
    -- Mark a single notification as read.
    -- Only the owning user can mark their own notification read.
    -- -------------------------------------------------------------------------
    PROCEDURE mark_read (
        p_notification_id IN NUMBER,
        p_user_id         IN NUMBER
    );

    -- -------------------------------------------------------------------------
    -- Mark all unread notifications for a user as read.
    -- -------------------------------------------------------------------------
    PROCEDURE mark_all_read (
        p_user_id IN NUMBER
    );

    -- -------------------------------------------------------------------------
    -- Delete expired notifications (called from a scheduled DBMS_SCHEDULER job).
    -- -------------------------------------------------------------------------
    PROCEDURE purge_expired;

END dct_notify;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY dct_notify AS

    -- -------------------------------------------------------------------------
    FUNCTION get_unread_count (
        p_user_id IN NUMBER
    ) RETURN NUMBER IS
        l_count NUMBER;
    BEGIN
        IF p_user_id IS NULL THEN
            RETURN 0;
        END IF;

        SELECT COUNT(*)
          INTO l_count
          FROM dct_notifications
         WHERE recipient_user_id = p_user_id
           AND is_read           = 'N'
           AND (expires_at IS NULL OR expires_at > SYSTIMESTAMP);

        RETURN NVL(l_count, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;   -- never break APEX page rendering over a badge count
    END get_unread_count;

    -- -------------------------------------------------------------------------
    PROCEDURE send (
        p_recipient_user_id IN NUMBER,
        p_notification_type IN VARCHAR2,
        p_title_en          IN VARCHAR2,
        p_body_en           IN VARCHAR2          DEFAULT NULL,
        p_title_ar          IN VARCHAR2          DEFAULT NULL,
        p_body_ar           IN VARCHAR2          DEFAULT NULL,
        p_module_code       IN VARCHAR2          DEFAULT NULL,
        p_link_url          IN VARCHAR2          DEFAULT NULL,
        p_expires_at        IN TIMESTAMP         DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO dct_notifications (
            recipient_user_id,
            module_code,
            notification_type,
            title_en,
            title_ar,
            body_en,
            body_ar,
            link_url,
            expires_at
        ) VALUES (
            p_recipient_user_id,
            p_module_code,
            p_notification_type,
            p_title_en,
            p_title_ar,
            p_body_en,
            p_body_ar,
            p_link_url,
            p_expires_at
        );
    END send;

    -- -------------------------------------------------------------------------
    PROCEDURE mark_read (
        p_notification_id IN NUMBER,
        p_user_id         IN NUMBER
    ) IS
    BEGIN
        UPDATE dct_notifications
           SET is_read = 'Y',
               read_at = SYSTIMESTAMP
         WHERE notification_id   = p_notification_id
           AND recipient_user_id = p_user_id
           AND is_read            = 'N';
    END mark_read;

    -- -------------------------------------------------------------------------
    PROCEDURE mark_all_read (
        p_user_id IN NUMBER
    ) IS
    BEGIN
        UPDATE dct_notifications
           SET is_read = 'Y',
               read_at = SYSTIMESTAMP
         WHERE recipient_user_id = p_user_id
           AND is_read            = 'N';
    END mark_all_read;

    -- -------------------------------------------------------------------------
    PROCEDURE purge_expired IS
    BEGIN
        DELETE FROM dct_notifications
         WHERE expires_at IS NOT NULL
           AND expires_at < SYSTIMESTAMP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Purged ' || SQL%ROWCOUNT || ' expired notifications.');
    END purge_expired;

END dct_notify;
/

-- =============================================================================
-- VERIFY
-- =============================================================================
PROMPT
PROMPT Verifying DCT_NOTIFY package...

SELECT object_name, object_type, status
FROM   user_objects
WHERE  object_name = 'DCT_NOTIFY'
ORDER  BY object_type;

PROMPT
PROMPT Quick smoke test — get_unread_count(NULL) should return 0:

DECLARE
    l_n NUMBER := dct_notify.get_unread_count(NULL);
BEGIN
    DBMS_OUTPUT.PUT_LINE('get_unread_count(NULL) = ' || l_n);
    IF l_n != 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Expected 0, got ' || l_n);
    END IF;
    DBMS_OUTPUT.PUT_LINE('DCT_NOTIFY smoke test PASSED.');
END;
/

PROMPT ============================================================
PROMPT  Done. APEX wiring:
PROMPT
PROMPT  Global Application Process "Refresh Notification Count"
PROMPT  (already in 05b_apex_200_shared_components.sql):
PROMPT
PROMPT    APEX_UTIL.SET_SESSION_STATE(
PROMPT      'UNREAD_NOTIFICATIONS',
PROMPT      dct_notify.get_unread_count(TO_NUMBER(:USER_ID))
PROMPT    );
PROMPT
PROMPT  Nav-bar badge expression: &UNREAD_NOTIFICATIONS.
PROMPT ============================================================
