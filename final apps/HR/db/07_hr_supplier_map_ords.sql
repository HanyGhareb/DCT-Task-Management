-- =============================================================================
-- HR Module — Employee↔Fusion supplier mapping endpoints  (ADDITIVE to hr.rest)
-- File    : 07_hr_supplier_map_ords.sql
-- Base URL: /ords/admin/hr/
-- Run     : sql -name prod_mcp @07_hr_supplier_map_ords.sql   (FRESH session)
-- =============================================================================
-- Adds GET/PUT employees/:id/supplier-map to the EXISTING hr.rest module
-- (DEFINE_TEMPLATE/HANDLER only — no DELETE_MODULE, live API untouched).
-- The HR Employee screen edits the employee's Fusion AP supplier identity
-- (DCT_EMP_SUPPLIER_MAP, source_module='PC', party_key = employee_number),
-- which the Petty Cash write-back actions consume.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE SYNONYM dct_emp_supplier_map FOR prod.dct_emp_supplier_map;

CREATE OR REPLACE PROCEDURE setup_hr_supmap_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'hr.rest';
BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'employees/:id/supplier-map');

    -- GET — the employee's current mapping (NULLs when none yet)
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod, p_pattern => 'employees/:id/supplier-map', p_method => 'GET',
        p_source_type => ORDS.source_type_query_one_row,
        p_source => q'[
            SELECT e.employee_number, e.full_name_en,
                   m.supplier_number, m.supplier_name, m.supplier_site, m.business_unit,
                   m.payment_method, m.pay_group, m.payment_terms, m.currency_code,
                   NVL(m.is_active,'Y') AS is_active, m.notes
            FROM   dct_employees e
            LEFT JOIN dct_emp_supplier_map m
                   ON m.source_module = 'PC' AND m.party_key = e.employee_number
            WHERE  e.person_id = :id ]');

    -- PUT — upsert the mapping (keyed by the employee_number of person :id)
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod, p_pattern => 'employees/:id/supplier-map', p_method => 'PUT',
        p_source_type => ORDS.source_type_plsql,
        p_source => q'[
DECLARE
  v_emp VARCHAR2(50);
BEGIN
  SELECT employee_number INTO v_emp FROM dct_employees WHERE person_id = :id;
  MERGE INTO dct_emp_supplier_map t
  USING (SELECT 'PC' source_module, v_emp party_key FROM dual) s
  ON (t.source_module = s.source_module AND t.party_key = s.party_key)
  WHEN MATCHED THEN UPDATE SET
     supplier_number = :supplier_number, supplier_name = :supplier_name,
     supplier_site = :supplier_site, business_unit = :business_unit,
     payment_method = :payment_method, pay_group = :pay_group,
     payment_terms = :payment_terms, currency_code = :currency_code,
     is_active = NVL(:is_active,'Y'), notes = :notes,
     updated_by = 'HR_EMP_SCREEN', updated_at = SYSTIMESTAMP
  WHEN NOT MATCHED THEN INSERT
     (source_module, party_key, supplier_number, supplier_name, supplier_site,
      business_unit, payment_method, pay_group, payment_terms, currency_code,
      is_active, notes, created_by)
     VALUES ('PC', v_emp, :supplier_number, :supplier_name, :supplier_site,
      :business_unit, :payment_method, :pay_group, :payment_terms, :currency_code,
      NVL(:is_active,'Y'), :notes, 'HR_EMP_SCREEN');
  :status_code := 200;
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN :status_code := 404;
END; ]');
END setup_hr_supmap_ords_tmp;
/

BEGIN
  setup_hr_supmap_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_hr_supmap_ords_tmp;

PROMPT HR 07 supplier-map ORDS : done
