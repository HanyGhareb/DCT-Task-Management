SET DEFINE OFF
SET SQLBLANKLINES ON

-- ============================================================================
-- 84_grn_gap_job.sql -- GRN gap-fill: surface receipts stuck UN-COSTED in
-- Fusion (present in Receiving, absent from Receipt Accounting) so they are
-- visible in the GRN table without moving any report figure.
--
-- Background (invoice DN-26-01-003166, receipt 4513074290, 2026-08-21):
-- the production analysis GRN_ALL_V4 keeps only COSTED rows -- its criteria
-- are Destination Type = EXPENSE, Accounting Line Type = EXPENSE and
-- Balance Type = A, all sourced from Receipt Accounting DISTRIBUTIONS. A
-- receiving transaction never transferred to costing has no distributions,
-- so it fails every one of those and the receipt vanishes from Budget
-- Utilization (its PO-matched AP is excluded from AP-Direct by design).
--
-- Design (user-approved, "blank amount / visibility only"):
--   1. table PROD.ATD_GRN_GAP -- same shape as ATD_GRN_ALL_V2.
--   2. job 'GRN Gap' -- a logical-SQL extract (the _atd_sql_chunks runner
--      directive, single chunk) with ONLY the wide criteria the user
--      validated by hand: the 3 platform BUs + Receipt Number not null.
--      No destination / distribution predicates, so un-costed legs flow.
--   3. prod.atd_grn_gap_merge -- inserts ONE row per receipt+line that is
--      absent from ATD_GRN_ALL_V2. The amount (user rule 2026-08-21 v2) is
--      the receipt-LINKED billed value: validated, non-reversed AP invoice
--      distributions carry the receipt number, and their functional-AED sum
--      (minus any GRN already costed on the receipt, floored at 0) goes on
--      the receipt's first missing line -- a billed-but-uncosted receipt
--      shows its real spend, an un-billed one stays at 0. PO-matched AP is
--      excluded from butil AP-Direct, so the value counts exactly ONCE.
--      The main job's TRUNCATE_INSERT wipes injected rows each load and the
--      merge re-inserts only what is STILL missing, re-deriving the amount
--      each time -- later costing swaps in the real row, no double count.
--   4. scheduler job ATD_GRN_GAP_MERGE_JOB every 15 minutes.
--
-- Notes for future readers:
--   * source_ref path GRN_GAP_SQL does not exist in the OTBI catalog -- for
--     a chunked job the extraction never reads it; only its /users/<login>/
--     prefix matters (db/62 permanent job-owner credential resolution).
--   * DISABLE_CACHE_HIT=1 is mandatory in every chunked job (db/83 rule).
--   * every amount inserted is NVL-guarded (never NULL) so consumer SUMs
--     stay NULL-safe; raw extract rows stay verbatim in ATD_GRN_GAP.
--   * deploy via python-oracledb (deploy_sql.py on a worker VM) -- the seed
--     blocks carry ~5KB q'[...]' literals Linux SQLcl may swallow.
-- ============================================================================

-- 1. gap table (guarded create; shape mirrors PROD.ATD_GRN_ALL_V2,
--    destination_type_meaning pre-widened for the receiving-leg values)
DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_tables
  WHERE owner = 'PROD' AND table_name = 'ATD_GRN_GAP';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.atd_grn_gap (
        receipt_number            NUMBER,
        receipt_line_number       NUMBER,
        transaction_date          DATE,
        po_header_id              NUMBER,
        po_line_id                NUMBER,
        po_distribution_id        NUMBER,
        invoice_id                VARCHAR2(40),
        project_id                NUMBER,
        task_id                   NUMBER,
        expenditure_type          VARCHAR2(150),
        expenditure_organization  VARCHAR2(100),
        created_by                VARCHAR2(60),
        creation_date             DATE,
        last_update_date          DATE,
        last_updated_by           VARCHAR2(60),
        transaction_amount        NUMBER,
        transaction_quantity      NUMBER,
        destination_type_meaning  VARCHAR2(40),
        shipment_line_number      NUMBER,
        transaction_type          VARCHAR2(60),
        posted_flag_2             VARCHAR2(10),
        receipt_routing_code      NUMBER,
        currency_code             VARCHAR2(10),
        conversion_rate           NUMBER,
        sla_ledger_amount         NUMBER,
        ledger_amount             NUMBER,
        load_ts                   TIMESTAMP(6) DEFAULT SYSTIMESTAMP,
        accounted_date            DATE,
        business_unit_name        VARCHAR2(60)
      )]';
  END IF;
END;
/

-- 2. job row 'GRN Gap' (count-then-insert; logical-SQL single-chunk extract)
DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_otbi_jobs WHERE job_name = 'GRN Gap';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_otbi_jobs
      (job_name, env_name, target_name, source_ref, output_format,
       params_json, stage_table, final_table, load_mode, key_columns,
       column_map_json, schedule, enabled, priority, run_order,
       run_status, frequency_minutes, schema_reviewed)
    VALUES
      ('GRN Gap', 'FUSION_ADGOV', 'ATD_LOCAL',
       '/users/haghareb@dctabudhabi.ae/Data/GRN/prod/final/GRN_GAP_SQL',
       'csv',
       q'[{"_atd_sql_chunks":{"sql":"SET VARIABLE DISABLE_CACHE_HIT=1, PREFERRED_CURRENCY='User Preferred Currency 1'; SELECT 0 s_0, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Receipt Number\" s_1, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Receipt Line Number\" s_2, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Transaction Date\" s_3, \"Costing - Receipt Accounting Real Time\".\"Purchase Order Header Details\".\"PO Header Id\" s_4, \"Costing - Receipt Accounting Real Time\".\"Purchase Order Line Details\".\"PO Line Id\" s_5, \"Costing - Receipt Accounting Real Time\".\"Purchase Order Distributions Details\".\"PO Distribution Id\" s_6, \"Costing - Receipt Accounting Real Time\".\"General Information\".\"Invoice Id\" s_7, \"Costing - Receipt Accounting Real Time\".\"Project\".\"Project Key\" s_8, \"Costing - Receipt Accounting Real Time\".\"Task\".\"Task Key\" s_9, \"Costing - Receipt Accounting Real Time\".\"Expenditure\".\"Expenditure Type\" s_10, \"Costing - Receipt Accounting Real Time\".\"Expenditure Organization\".\"Expenditure Organization Name\" s_11, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Created By\" s_12, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Creation Date\" s_13, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Last Update Date\" s_14, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Last Updated By\" s_15, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Distributions Details\".\"Event Unit Cost\"*IFNULL(\"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Distributions Details\".\"Accounted Quantity\",1) s_16, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transaction\".\"Transaction Quantity\" s_17, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Destination Type Meaning\" s_18, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Shipment Line Number\" s_19, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Transaction Type\" s_20, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Transactions Details\".\"Posted Flag\" s_21, \"Costing - Receipt Accounting Real Time\".\"Purchase Order Line Location Details\".\"Receipt Routing Code\" s_22, \"Costing - Receipt Accounting Real Time\".\"Purchase Order Common Details\".\"Currency Code\" s_23, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Distributions Details\".\"Conversion Rate\" s_24, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Distributions Details\".\"SLA Ledger Amount\" s_25, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Distributions Details\".\"Ledger Amount\" s_26, \"Costing - Receipt Accounting Real Time\".\"Receipt Accounting Distributions Details\".\"Accounted Date\" s_27, \"Costing - Receipt Accounting Real Time\".\"Business Unit\".\"Business Unit Name\" s_28 FROM \"Costing - Receipt Accounting Real Time\" WHERE ((DESCRIPTOR_IDOF(\"Costing - Receipt Accounting Real Time\".\"Business Unit\".\"Business Unit Name\") IN (300000002427529, 300000324906601, 300000034874765)) AND (\"Receipt Accounting Transactions Details\".\"Receipt Number\" IS NOT NULL))","chunks":["1"],"headers":{"#2":"Receipt Number","#3":"Receipt Line Number","#4":"Transaction Date","#5":"PO Header Id","#6":"PO Line Id","#7":"PO Distribution Id","#8":"Invoice Id","#9":"Project ID","#10":"Task ID","#11":"Expenditure Type","#12":"Expenditure Organization","#13":"Created By","#14":"Creation Date","#15":"Last Update Date","#16":"Last Updated By","#17":"Transaction Amount","#18":"Transaction Quantity","#19":"Destination Type Meaning","#20":"Shipment Line Number","#21":"Transaction Type","#22":"Posted Flag","#23":"Receipt Routing Code","#24":"Currency Code","#25":"Conversion Rate","#26":"SLA Ledger Amount","#27":"Ledger Amount","#28":"Accounted Date","#29":"Business Unit Name"},"min_rows":100,"retries":1}}]',
       'PROD.ATD_GRN_GAP', NULL, 'TRUNCATE_INSERT', NULL,
       q'[{"Receipt Number": "RECEIPT_NUMBER", "Receipt Line Number": "RECEIPT_LINE_NUMBER", "Transaction Date": "TRANSACTION_DATE", "PO Header Id": "PO_HEADER_ID", "PO Line Id": "PO_LINE_ID", "PO Distribution Id": "PO_DISTRIBUTION_ID", "Invoice Id": "INVOICE_ID", "Project ID": "PROJECT_ID", "Task ID": "TASK_ID", "Expenditure Type": "EXPENDITURE_TYPE", "Expenditure Organization": "EXPENDITURE_ORGANIZATION", "Created By": "CREATED_BY", "Creation Date": "CREATION_DATE", "Last Update Date": "LAST_UPDATE_DATE", "Last Updated By": "LAST_UPDATED_BY", "Transaction Amount": "TRANSACTION_AMOUNT", "Transaction Quantity": "TRANSACTION_QUANTITY", "Destination Type Meaning": "DESTINATION_TYPE_MEANING", "Shipment Line Number": "SHIPMENT_LINE_NUMBER", "Transaction Type": "TRANSACTION_TYPE", "Posted Flag": "POSTED_FLAG_2", "Receipt Routing Code": "RECEIPT_ROUTING_CODE", "Currency Code": "CURRENCY_CODE", "Conversion Rate": "CONVERSION_RATE", "SLA Ledger Amount": "SLA_LEDGER_AMOUNT", "Ledger Amount": "LEDGER_AMOUNT", "Accounted Date": "ACCOUNTED_DATE", "Business Unit Name": "BUSINESS_UNIT_NAME"}]',
       NULL, 'Y', 5, 100, 'READY', 1440, 'Y');
    COMMIT;
  END IF;
END;
/

-- 3. job-set membership: run inside the daily GRN window, after the main job
DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_job_set_member
  WHERE job_name = 'GRN Gap' AND set_code = 'GL_GRN_DAILY';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_job_set_member
      (job_name, set_code, enabled_in_set, member_order, added_at, added_by)
    VALUES
      ('GRN Gap', 'GL_GRN_DAILY', 'Y', 30, SYSTIMESTAMP, 'CLAUDE');
    COMMIT;
  END IF;
END;
/

-- 4. merge: one row per receipt+line still missing from the main GRN table,
--    valued at the receipt's billed (validated AP) amount, remainder-guarded.
--    Self-healing by construction: the main extract's TRUNCATE_INSERT wipes
--    injected rows every load, and NOT EXISTS blocks re-insertion the moment
--    the costed row arrives.
CREATE OR REPLACE PROCEDURE prod.atd_grn_gap_merge AS
BEGIN
  -- refresh own injections first: only injected rows carry a non-deliver
  -- transaction type (the main extract loads ONLY the two deliver types),
  -- so this removes nothing the extract owns; the re-insert below then
  -- re-derives every amount fresh in the SAME transaction.
  DELETE FROM prod.atd_grn_all_v2
  WHERE transaction_type NOT IN
        ('Deliver To Expense Destination', 'Correction To Deliver');

  INSERT INTO prod.atd_grn_all_v2
    (receipt_number, receipt_line_number, transaction_date, po_header_id,
     po_line_id, po_distribution_id, invoice_id, project_id, task_id,
     expenditure_type, expenditure_organization, created_by, creation_date,
     last_update_date, last_updated_by, transaction_amount,
     transaction_quantity, destination_type_meaning, shipment_line_number,
     transaction_type, posted_flag_2, receipt_routing_code, currency_code,
     conversion_rate, sla_ledger_amount, ledger_amount, load_ts,
     accounted_date, business_unit_name)
  SELECT z.receipt_number, z.receipt_line_number, z.transaction_date,
         z.po_header_id, z.po_line_id, z.po_distribution_id, z.invoice_id,
         z.project_id, z.task_id, z.expenditure_type,
         z.expenditure_organization, z.created_by, z.creation_date,
         z.last_update_date, z.last_updated_by,
         CASE WHEN z.line_rank = 1 THEN z.gap_amt ELSE 0 END,
         NVL(z.transaction_quantity, 0),
         z.destination_type_meaning, z.shipment_line_number,
         z.transaction_type, z.posted_flag_2, z.receipt_routing_code,
         z.currency_code, z.conversion_rate, 0,
         CASE WHEN z.line_rank = 1 THEN z.gap_amt ELSE 0 END,
         SYSTIMESTAMP, z.accounted_date, z.business_unit_name
  FROM (
    SELECT y.*,
           ROW_NUMBER() OVER (PARTITION BY y.receipt_number
                              ORDER BY y.receipt_line_number) line_rank,
           GREATEST(NVL(ap.billed_amt, 0) - NVL(mg.costed_amt, 0), 0) gap_amt
    FROM (
           SELECT x.* FROM (
             SELECT g.*,
                    ROW_NUMBER() OVER (
                      PARTITION BY g.receipt_number, g.receipt_line_number
                      ORDER BY CASE WHEN UPPER(g.destination_type_meaning)
                                         LIKE 'EXPENSE%' THEN 0 ELSE 1 END,
                               g.transaction_date DESC, g.transaction_type
                    ) rn
             FROM prod.atd_grn_gap g
             WHERE g.receipt_number IS NOT NULL
           ) x
           WHERE x.rn = 1
             AND NOT EXISTS (
                   SELECT 1 FROM prod.atd_grn_all_v2 m
                   WHERE m.receipt_number = x.receipt_number
                     AND NVL(m.receipt_line_number, -1)
                         = NVL(x.receipt_line_number, -1)
                 )
         ) y
    LEFT JOIN (
           SELECT d.receipt_number,
                  SUM(NVL(d.distribution_amount_functi,
                          d.distribution_amount)) billed_amt
           FROM prod.ap_invoice_distributions d
           JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
           WHERE d.receipt_number IS NOT NULL
             AND NVL(d.reversal_indicator, 'N') <> 'Y'
             AND i.validation_status IN ('Validated', 'Unpaid', 'Available')
           GROUP BY d.receipt_number
         ) ap ON ap.receipt_number = y.receipt_number
    LEFT JOIN (
           SELECT m.receipt_number, SUM(m.ledger_amount) costed_amt
           FROM prod.atd_grn_all_v2 m
           GROUP BY m.receipt_number
         ) mg ON mg.receipt_number = y.receipt_number
  ) z;
  COMMIT;
END atd_grn_gap_merge;
/

-- 5. scheduler: sweep every 15 minutes (idempotent drop-then-create)
DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_scheduler_jobs
  WHERE owner = 'PROD' AND job_name = 'ATD_GRN_GAP_MERGE_JOB';
  IF l_n > 0 THEN
    DBMS_SCHEDULER.drop_job('PROD.ATD_GRN_GAP_MERGE_JOB');
  END IF;
  DBMS_SCHEDULER.create_job(
    job_name        => 'PROD.ATD_GRN_GAP_MERGE_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.atd_grn_gap_merge; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=15',
    enabled         => TRUE,
    comments        => 'Inserts 0-amount gap rows (un-costed Fusion receipts) into ATD_GRN_ALL_V2; see otbi-atd/db/84');
END;
/

-- verify
SELECT job_name, enabled, load_mode, stage_table, frequency_minutes
FROM prod.atd_otbi_jobs WHERE job_name = 'GRN Gap';

SELECT job_name, set_code, member_order FROM prod.atd_job_set_member
WHERE job_name = 'GRN Gap';

SELECT object_name, object_type, status FROM all_objects
WHERE owner = 'PROD'
  AND object_name IN ('ATD_GRN_GAP', 'ATD_GRN_GAP_MERGE', 'ATD_GRN_GAP_MERGE_JOB');
