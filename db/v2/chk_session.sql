BEGIN
  ORDS.DELETE_TEMPLATE(p_module_name => 'dct.admin', p_pattern => 'debug/auth');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('debug/auth removed');
EXCEPTION WHEN OTHERS THEN NULL;
END;
/