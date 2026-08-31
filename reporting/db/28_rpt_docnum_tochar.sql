-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 28 document numbers as TEXT (TO_CHAR)
-- File   : reporting/db/28_rpt_docnum_tochar.sql
-- Purpose: PO / PR document-number columns in the Budget Utilization reports
--          were selected as raw NUMBER (po_headers.order_number,
--          dct_open_po_lines_v.po_number/po_line, dct_reserved_pr_lines_v.
--          pr_number). openpyxl then renders a NUMBER cell with the amount
--          format (#,##0.00), so a real PO document number like 451102006818
--          shows as "451,102,007,724.00" -- it LOOKS like an internal id / an
--          amount. (project_number never had this because the SQL already
--          TO_CHAR-wrapped it.) These are the REAL document numbers, not the
--          internal po_header_id (300000000000+) -- only the presentation was
--          wrong. Wrapping them in TO_CHAR makes them arrive as TEXT, so every
--          output format (Excel, PDF, PowerPoint, CSV) renders a clean,
--          left-aligned document number with no separators or decimals.
-- Scope  : BUDGET_UTIL_BOOK (reporting/db/21) + BUDGET_UTIL_REGISTER (db/25),
--          in lock-step with those seed sources (which carry the same edit).
--          The pending reports (ENC_PENDING_BOOK/REGISTER) already use the
--          VARCHAR doc_number column; the GL page handlers already TO_CHAR
--          their doc numbers (GL/db/07/10/12/13); no other report is affected.
-- Method : surgical REPLACE on the stored source_ref CLOB (does NOT re-run the
--          MERGE-bearing seeds, so it is safe under Linux SQLcl and independent
--          of any other in-flight change to db/21/25). Idempotent: the search
--          strings cannot occur after the wrap, so re-running is a no-op.
-- Run    : sql -name prod_mcp @28_rpt_docnum_tochar.sql   (fresh session)
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

UPDATE prod.dct_rpt_definition
   SET source_ref = REPLACE(REPLACE(REPLACE(source_ref,
         'h.order_number AS po_number, pl.line AS po_line, h.supplier_name',
         'TO_CHAR(h.order_number) AS po_number, TO_CHAR(pl.line) AS po_line, h.supplier_name'),
         'x.po_number, x.po_line, x.budget_date, x.supplier_name, x.funds_status',
         'TO_CHAR(x.po_number) AS po_number, TO_CHAR(x.po_line) AS po_line, x.budget_date, x.supplier_name, x.funds_status'),
         'x.pr_number, x.description, x.budget_date, x.currency_code',
         'TO_CHAR(x.pr_number) AS pr_number, x.description, x.budget_date, x.currency_code'),
       updated_by = 'DOCNUM_FIX',
       updated_at = SYSTIMESTAMP
 WHERE report_code IN ('BUDGET_UTIL_BOOK', 'BUDGET_UTIL_REGISTER');

COMMIT;

PROMPT === verify: source_ref still valid JSON, and NO un-wrapped id strings remain ===
SELECT report_code,
       CASE WHEN source_ref IS JSON THEN 'JSON OK' ELSE 'JSON BAD' END AS json_ok,
       (SELECT COUNT(*) FROM dual WHERE INSTR(d.source_ref, 'h.order_number AS po_number') > 0
                                     OR INSTR(d.source_ref, 'x.po_number, x.po_line, x.budget_date') > 0
                                     OR INSTR(d.source_ref, 'x.pr_number, x.description') > 0) AS unwrapped_left,
       (SELECT COUNT(*) FROM dual WHERE INSTR(d.source_ref, 'TO_CHAR(h.order_number) AS po_number') > 0) AS grn_wrapped,
       (SELECT COUNT(*) FROM dual WHERE INSTR(d.source_ref, 'TO_CHAR(x.po_number) AS po_number') > 0) AS po_wrapped,
       (SELECT COUNT(*) FROM dual WHERE INSTR(d.source_ref, 'TO_CHAR(x.pr_number) AS pr_number') > 0) AS pr_wrapped
FROM prod.dct_rpt_definition d
WHERE report_code IN ('BUDGET_UTIL_BOOK', 'BUDGET_UTIL_REGISTER')
ORDER BY report_code;

PROMPT 28_rpt_docnum_tochar.sql complete (PO/PR document numbers now render as text).
