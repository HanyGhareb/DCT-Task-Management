-- ===========================================================================
-- Drop orphan ATD_AP_INVOICE_HEADER (db/v2/44)
-- ---------------------------------------------------------------------------
-- Housekeeping approved 2026-07-11. The table was a vestige of the 2026-06-21
-- loader fleet-validation test: 0 rows since the 2026-07-02 truncate, NO
-- loader job in ATD_OTBI_JOBS targets it, and its 9 columns all duplicate
-- ATD_AP_INVOICES (the real invoice header source, used by
-- AP_INVOICES_HEADER_V in db/v2/43).
--
-- Removes: the AP_INVOICE_HEADER pass-through view + the table itself.
-- Companion edits (same change): db/v2/32 no longer creates the pass-through;
-- db/v2/38 rebuild list no longer includes it (RE-RUN 38 after this script).
-- Rerunnable: already-missing objects are skipped.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW prod.ap_invoice_header';
  DBMS_OUTPUT.put_line('Dropped view PROD.AP_INVOICE_HEADER');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -942 THEN
    DBMS_OUTPUT.put_line('View PROD.AP_INVOICE_HEADER already absent');
  ELSE RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_ap_invoice_header PURGE';
  DBMS_OUTPUT.put_line('Dropped table PROD.ATD_AP_INVOICE_HEADER');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -942 THEN
    DBMS_OUTPUT.put_line('Table PROD.ATD_AP_INVOICE_HEADER already absent');
  ELSE RAISE; END IF;
END;
/

PROMPT 44_drop_ap_invoice_header.sql complete. Now re-run db/v2/38.
