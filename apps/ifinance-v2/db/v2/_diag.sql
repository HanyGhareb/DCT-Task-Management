set serveroutput on
set feedback off
BEGIN
    DBMS_OUTPUT.PUT_LINE('SESSION_USER  = ' || SYS_CONTEXT('USERENV','SESSION_USER'));
    DBMS_OUTPUT.PUT_LINE('CURRENT_SCHEMA = ' || SYS_CONTEXT('USERENV','CURRENT_SCHEMA'));
END;
/

SELECT object_name, object_type, status
FROM   user_objects
WHERE  object_name IN ('DCT_AUTH','DCT_NOTIFY','DCT_USERS_API','DCT_APPROVAL',
                       'DCT_USERS','DCT_APPROVAL_STEPS','DCT_APPROVAL_INSTANCES')
ORDER BY object_type, object_name;
