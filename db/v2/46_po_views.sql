-- ===========================================================================
-- PO document views - all four document levels (db/v2/46)
-- ---------------------------------------------------------------------------
-- End-user-friendly views over the Fusion-loaded purchase order tables
-- (via the db/v2/32 pass-throughs po_headers / po_lines / po_schedules /
-- po_distributions), enriched with COA classification, project costing,
-- requisition (PR), receiving (GRN) and payables (AP) rollups:
--
--   PO_HEADER_V        one row per purchase order (grain po_header_id) with
--                      full descriptive info + statistics: line / schedule /
--                      distribution counts, project + task counts and lists,
--                      PR count + numbers (two sources - see below), AP
--                      invoice count / amount / paid amount + per-invoice
--                      payment-status counts, GRN receipt count + amount,
--                      GRN-netted open obligation, %-received / %-invoiced /
--                      %-paid.
--   PO_LINES_V         one row per PO line (grain po_line_id) + per-line
--                      schedule/distribution counts and AED rollups.
--   PO_SCHEDULES_V     one row per PO schedule (grain line_location_id) +
--                      per-schedule distribution and AP rollups.
--   PO_DISTRIBUTIONS_V one row per PO distribution (grain po_distribution_id)
--                      with charge-account classification (Sector / Chapter /
--                      DCT Program via prod.dct_gl_coa_snap), project / task /
--                      expenditure type names, backing PR reference, GRN
--                      received and AP invoiced amounts, open obligation.
--
-- Model rules (all inherited from the deployed actuals layer, db/v2/32-40):
--   * De-dup guards: the ATD extracts can carry physical duplicate rows after
--     reloads (po_lines does today: 3,011 rows / 2,935 unique line ids), so
--     every view keeps only the newest row per natural key (highest load_ts).
--   * AED amounts:  PO  = distribution_amount x NVL(rate,1)  (doc currency x
--                   the distribution's own FX-to-AED rate);
--                   GRN = ledger_amount, NEVER x conversion_rate (the extract
--                   amount is already AED-converted; see 2026-07-10 fix);
--                   AP  = NVL(distribution_amount_functi, distribution_amount)
--                   (FUNCTI is populated only for non-AED invoices).
--   * AP amounts attributed to a PO use the MATCHED portion only: an invoice
--     can carry lines that belong to no PO (live example: LV-AUH-INV/2026/0016
--     is a 49.7M invoice of which only 12.4M is matched to its PO), so
--     ap_invoiced_amount_aed sums the matched distributions, and
--     ap_paid_amount_aed pro-rates it by the invoice's paid ratio
--     (invoice_amount_paid / invoice_amount, capped to 0..1). The linked
--     invoices' full header totals are still shown separately as
--     ap_invoice_gross_amount_aed.
--   * Open obligation = per distribution GREATEST(amount_aed - GRN_aed, 0)
--     for funds_status Reserved / Partially Liquidated, and 0 for orders whose
--     header status is Finally Closed (final close releases the remainder).
--   * Reversed AP distributions (reversal_indicator = Y) are excluded, so a
--     cancelled invoice drops out of the links naturally; invoice-grain stats
--     additionally skip validation_status Canceled.
--   * Charge-account joins to the COA snapshot go through prod.dct_cc_canon
--     (db/v2/40) - never join charge_account text directly.
--   * PR references come from TWO sources, both exposed on PO_HEADER_V:
--       pr_count / pr_numbers                   backing requisitions carried on
--                                               the PO distributions themselves
--                                               (pr_number, 99.5% populated);
--       invoiced_pr_count / invoiced_pr_numbers requisitions referenced by the
--                                               matched AP invoice
--                                               distributions (requisition).
--
-- These are plain views - rerunnable, no data copied. Run as ADMIN with the
-- prod. prefix (no current_schema switch). Depends on: db/v2/32 pass-through
-- views, db/v2/33 dct_gl_coa_snap, db/v2/40 dct_cc_canon.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---------------------------------------------------------------------------
-- 1. PO_DISTRIBUTIONS_V - one row per PO distribution
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.po_distributions_v AS
WITH dist AS (
  SELECT * FROM (
    SELECT d0.*,
           ROW_NUMBER() OVER (PARTITION BY d0.po_distribution_id
                              ORDER BY d0.load_ts DESC NULLS LAST) AS rn
    FROM prod.po_distributions d0
  ) WHERE rn = 1
),
hdr AS (
  SELECT * FROM (
    SELECT h0.*,
           ROW_NUMBER() OVER (PARTITION BY h0.po_header_id
                              ORDER BY h0.load_ts DESC NULLS LAST) AS rn
    FROM prod.po_headers h0
  ) WHERE rn = 1
),
lin AS (
  SELECT po_line_id, MAX(line) AS line, MAX(item_description) AS item_description
  FROM prod.po_lines GROUP BY po_line_id
),
grn_dist AS (
  SELECT po_distribution_id,
         SUM(ledger_amount) AS grn_aed,
         COUNT(*)           AS grn_lines
  FROM prod.grn_all_v2
  GROUP BY po_distribution_id
),
apd AS (
  SELECT d.po_number, d.po_line, d.po_distribution_line,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS inv_aed,
         COUNT(DISTINCT d.invoice_id)                                  AS inv_count
  FROM prod.ap_invoice_distributions d
  WHERE d.po_number IS NOT NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY d.po_number, d.po_line, d.po_distribution_line
),
proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number, MAX(task_name) AS task_name
  FROM prod.tasks GROUP BY task_id
)
SELECT
  h.order_number,
  h.supplier_name,
  h.status                                   AS po_status,
  l.line                                     AS line_number,
  l.item_description,
  d.schedule                                 AS schedule_number,
  d.distribution_number,
  d.status                                   AS distribution_status,
  d.funds_status,
  d.budget_date,
  d.destination_type,
  d.location_name,
  -- charge account and its classification. ALWAYS the canonical segment order
  -- (entity.cc.account.appr.bg.es.f1.f2.ic.program) even though the ATD feed
  -- arrives re-ordered - platform rule 2026-07-13: never expose a raw feed string.
  prod.dct_cc_canon(d.charge_account)        AS charge_account,
  prod.dct_cc_canon(d.charge_account)        AS cc_string,
  coa.account_code,        coa.account_desc,
  coa.cost_center_code,    coa.cost_center_desc,
  coa.appropriation_code,  coa.appropriation_desc,
  coa.sector_code,         coa.sector_name,
  coa.chapter_code,        coa.chapter_name,
  coa.program_code,        coa.program_name,
  -- project costing
  pj.project_number,
  pj.project_name,
  tk.task_number,
  tk.task_name,
  d.expenditure_type_name                    AS expenditure_type,
  d.expenditure_organization,
  -- backing requisition reference
  d.pr_number,
  d.pr_line,
  d.pr_description,
  d.requestor_name,
  d.requestor_email,
  -- amounts (doc currency + AED)
  h.currency,
  d.distribution_amount,
  NVL(d.rate,1)                              AS fx_rate_to_aed,
  ROUND(d.distribution_amount * NVL(d.rate,1), 2)                    AS amount_aed,
  ROUND(NVL(g.grn_aed,0), 2)                                         AS grn_amount_aed,
  NVL(g.grn_lines,0)                                                 AS grn_line_count,
  ROUND(NVL(a.inv_aed,0), 2)                                         AS invoiced_amount_aed,
  NVL(a.inv_count,0)                                                 AS ap_invoice_count,
  CASE WHEN d.funds_status IN ('Reserved','Partially Liquidated')
        AND NVL(h.status,'x') <> 'Finally Closed'
       THEN ROUND(GREATEST(d.distribution_amount * NVL(d.rate,1) - NVL(g.grn_aed,0), 0), 2)
       ELSE 0 END                                                    AS open_obligation_aed,
  d.received_amount,
  d.received_quantity,
  d.schedule_unbilled_amount,
  d.last_updated_by,
  d.last_updated_date,
  -- technical keys (joins across the PO_*_V family)
  d.po_header_id,
  d.po_line_id,
  d.po_distribution_id
FROM dist d
LEFT JOIN hdr  h ON h.po_header_id = d.po_header_id
LEFT JOIN lin  l ON l.po_line_id   = d.po_line_id
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = prod.dct_cc_canon(d.charge_account)
LEFT JOIN grn_dist g ON g.po_distribution_id = d.po_distribution_id
LEFT JOIN apd  a ON a.po_number = h.order_number
               AND a.po_line   = l.line
               AND a.po_distribution_line = d.distribution_number
LEFT JOIN proj pj ON pj.project_id = d.project_id
LEFT JOIN tsk  tk ON tk.task_id    = d.task_id;

PROMPT PO_DISTRIBUTIONS_V created.

-- ---------------------------------------------------------------------------
-- 2. PO_SCHEDULES_V - one row per PO schedule (line location)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.po_schedules_v AS
WITH sch AS (
  SELECT * FROM (
    SELECT s0.*,
           ROW_NUMBER() OVER (PARTITION BY s0.line_location_id
                              ORDER BY s0.load_ts DESC NULLS LAST) AS rn
    FROM prod.po_schedules s0
  ) WHERE rn = 1
),
hdr AS (
  SELECT * FROM (
    SELECT h0.*,
           ROW_NUMBER() OVER (PARTITION BY h0.po_header_id
                              ORDER BY h0.load_ts DESC NULLS LAST) AS rn
    FROM prod.po_headers h0
  ) WHERE rn = 1
),
lin AS (
  SELECT po_line_id, MAX(line) AS line, MAX(item_description) AS item_description
  FROM prod.po_lines GROUP BY po_line_id
),
dist_sch AS (
  SELECT po_header_id, po_line_id, schedule,
         COUNT(DISTINCT po_distribution_id)            AS distribution_count,
         SUM(distribution_amount)                      AS scheduled_amount,
         SUM(distribution_amount * NVL(rate,1))        AS scheduled_amount_aed
  FROM (
    SELECT * FROM (
      SELECT d0.*,
             ROW_NUMBER() OVER (PARTITION BY d0.po_distribution_id
                                ORDER BY d0.load_ts DESC NULLS LAST) AS rn
      FROM prod.po_distributions d0
    ) WHERE rn = 1
  )
  GROUP BY po_header_id, po_line_id, schedule
),
aps AS (
  SELECT d.po_number, d.po_line, d.po_schedule,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS inv_aed,
         COUNT(DISTINCT d.invoice_id)                                  AS inv_count
  FROM prod.ap_invoice_distributions d
  WHERE d.po_number IS NOT NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY d.po_number, d.po_line, d.po_schedule
)
SELECT
  h.order_number,
  h.supplier_name,
  h.status                                   AS po_status,
  h.currency,
  l.line                                     AS line_number,
  l.item_description,
  s.schedule                                 AS schedule_number,
  s.schedule_status,
  s.schedule_type,
  s.shipment_type,
  s.schedule_description,
  s.business_unit,
  s.organization_name,
  s.location_name,
  s.destination_lookup_code                  AS destination_type,
  s.schedule_quantity,
  s.accepted_quantity,
  NVL(d.distribution_count,0)                AS distribution_count,
  d.scheduled_amount,
  ROUND(d.scheduled_amount_aed, 2)           AS scheduled_amount_aed,
  s.billed_amount,
  s.unbilled_amount,
  s.received_amount,
  s.retainage_amount,
  s.retainage_released_amount,
  ROUND(NVL(a.inv_aed,0), 2)                 AS invoiced_amount_aed,
  NVL(a.inv_count,0)                         AS ap_invoice_count,
  s.invoice_match_option,
  s.tax_classification_code,
  s.requested_delivery_date,
  s.promised_delivery_date,
  s.original_promised_delivery               AS original_promised_date,
  s.last_acceptable_delivery_d               AS last_acceptable_delivery_date,
  s.closed_for_invoicing_date,
  s.closed_for_receiving_date,
  s.shipment_closed_date,
  s.canceled_date                            AS cancelled_date,
  s.schedule_last_updated_by                 AS last_updated_by,
  s.schedule_last_updated_date               AS last_updated_date,
  -- technical keys
  s.po_header_id,
  s.po_line_id,
  s.line_location_id
FROM sch s
LEFT JOIN hdr h ON h.po_header_id = s.po_header_id
LEFT JOIN lin l ON l.po_line_id   = s.po_line_id
LEFT JOIN dist_sch d ON d.po_header_id = s.po_header_id
                    AND d.po_line_id   = s.po_line_id
                    AND d.schedule     = s.schedule
LEFT JOIN aps a ON a.po_number  = h.order_number
               AND a.po_line     = l.line
               AND a.po_schedule = s.schedule;

PROMPT PO_SCHEDULES_V created.

-- ---------------------------------------------------------------------------
-- 3. PO_LINES_V - one row per PO line
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.po_lines_v AS
WITH lin AS (
  SELECT * FROM (
    SELECT l0.*,
           ROW_NUMBER() OVER (PARTITION BY l0.po_line_id
                              ORDER BY l0.load_ts DESC NULLS LAST,
                                       l0.updated_on DESC NULLS LAST) AS rn
    FROM prod.po_lines l0
  ) WHERE rn = 1
),
hdr AS (
  SELECT * FROM (
    SELECT h0.*,
           ROW_NUMBER() OVER (PARTITION BY h0.po_header_id
                              ORDER BY h0.load_ts DESC NULLS LAST) AS rn
    FROM prod.po_headers h0
  ) WHERE rn = 1
),
grn_dist AS (
  SELECT po_distribution_id, SUM(ledger_amount) AS grn_aed
  FROM prod.grn_all_v2 GROUP BY po_distribution_id
),
grn_line AS (
  SELECT po_line_id,
         SUM(ledger_amount) AS grn_aed,
         COUNT(*)           AS grn_lines
  FROM prod.grn_all_v2
  GROUP BY po_line_id
),
dist_line AS (
  SELECT d.po_line_id,
         COUNT(DISTINCT d.po_distribution_id)             AS distribution_count,
         SUM(d.distribution_amount)                       AS distributed_amount,
         SUM(d.distribution_amount * NVL(d.rate,1))       AS distributed_amount_aed,
         COUNT(DISTINCT d.pr_number)                      AS pr_count,
         LISTAGG(DISTINCT TO_CHAR(d.pr_number), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(d.pr_number))   AS pr_numbers,
         SUM(CASE WHEN d.funds_status IN ('Reserved','Partially Liquidated')
                  THEN GREATEST(d.distribution_amount * NVL(d.rate,1) - NVL(g.grn_aed,0), 0)
                  END)                                    AS open_oblig_raw
  FROM (
    SELECT * FROM (
      SELECT d0.*,
             ROW_NUMBER() OVER (PARTITION BY d0.po_distribution_id
                                ORDER BY d0.load_ts DESC NULLS LAST) AS rn
      FROM prod.po_distributions d0
    ) WHERE rn = 1
  ) d
  LEFT JOIN grn_dist g ON g.po_distribution_id = d.po_distribution_id
  GROUP BY d.po_line_id
),
sch_line AS (
  SELECT po_line_id,
         COUNT(DISTINCT line_location_id) AS schedule_count,
         SUM(billed_amount)               AS billed_amount,
         SUM(unbilled_amount)             AS unbilled_amount,
         SUM(received_amount)             AS received_amount
  FROM prod.po_schedules
  GROUP BY po_line_id
),
apl AS (
  SELECT d.po_number, d.po_line,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS inv_aed,
         COUNT(DISTINCT d.invoice_id)                                  AS inv_count
  FROM prod.ap_invoice_distributions d
  WHERE d.po_number IS NOT NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY d.po_number, d.po_line
),
proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number, MAX(task_name) AS task_name
  FROM prod.tasks GROUP BY task_id
)
SELECT
  l.order_number,
  h.supplier_name,
  h.status                                   AS po_status,
  l.line                                     AS line_number,
  l.line_type,
  l.item_name,
  l.item_description,
  l.category_name,
  l.category_description,
  l.line_status,
  l.funds_status,
  l.currency_code                            AS currency,
  l.price,
  l.base_price,
  l.uom,
  l.pricing_uom,
  l.revision,
  l.supplier_item,
  l.line_amount,
  TO_NUMBER(l.advance_amount DEFAULT NULL ON CONVERSION ERROR) AS advance_amount,
  pj.project_number,
  pj.project_name,
  tk.task_number,
  tk.task_name,
  l.expenditure_type,
  NVL(s.schedule_count,0)                    AS schedule_count,
  NVL(d.distribution_count,0)                AS distribution_count,
  d.distributed_amount,
  ROUND(d.distributed_amount_aed, 2)         AS distributed_amount_aed,
  NVL(d.pr_count,0)                          AS pr_count,
  d.pr_numbers,
  ROUND(NVL(g.grn_aed,0), 2)                 AS grn_amount_aed,
  NVL(g.grn_lines,0)                         AS grn_line_count,
  ROUND(NVL(a.inv_aed,0), 2)                 AS invoiced_amount_aed,
  NVL(a.inv_count,0)                         AS ap_invoice_count,
  CASE WHEN NVL(h.status,'x') = 'Finally Closed' THEN 0
       ELSE ROUND(NVL(d.open_oblig_raw,0), 2) END AS open_obligation_aed,
  s.billed_amount,
  s.unbilled_amount,
  s.received_amount,
  l.creation_date,
  l.submit_date,
  l.approved_date,
  l.open_date,
  l.close_date,
  l.cancelled_date,
  l.cancellation_reason,
  l.line_cancelled_by,
  l.update_by                                AS last_updated_by,
  l.updated_on                               AS last_updated_date,
  -- technical keys
  l.po_header_id,
  l.po_line_id
FROM lin l
LEFT JOIN hdr h  ON h.po_header_id = l.po_header_id
LEFT JOIN dist_line d ON d.po_line_id = l.po_line_id
LEFT JOIN sch_line  s ON s.po_line_id = l.po_line_id
LEFT JOIN grn_line  g ON g.po_line_id = l.po_line_id
LEFT JOIN apl a ON a.po_number = l.order_number AND a.po_line = l.line
LEFT JOIN proj pj ON pj.project_id = l.project_id
LEFT JOIN tsk  tk ON tk.task_id    = l.task_id;

PROMPT PO_LINES_V created.

-- ---------------------------------------------------------------------------
-- 4. PO_HEADER_V - one row per purchase order with full statistics
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.po_header_v AS
WITH hdr AS (
  SELECT * FROM (
    SELECT h0.*,
           ROW_NUMBER() OVER (PARTITION BY h0.po_header_id
                              ORDER BY h0.load_ts DESC NULLS LAST) AS rn
    FROM prod.po_headers h0
  ) WHERE rn = 1
),
lin_agg AS (
  SELECT po_header_id,
         COUNT(*)         AS line_count,
         SUM(line_amount) AS line_amount_total
  FROM (
    SELECT * FROM (
      SELECT l0.po_header_id, l0.po_line_id, l0.line_amount,
             ROW_NUMBER() OVER (PARTITION BY l0.po_line_id
                                ORDER BY l0.load_ts DESC NULLS LAST,
                                         l0.updated_on DESC NULLS LAST) AS rn
      FROM prod.po_lines l0
    ) WHERE rn = 1
  )
  GROUP BY po_header_id
),
sch_agg AS (
  SELECT po_header_id,
         COUNT(DISTINCT line_location_id) AS schedule_count,
         SUM(billed_amount)               AS schedule_billed_amount,
         SUM(unbilled_amount)             AS schedule_unbilled_amount,
         SUM(received_amount)             AS schedule_received_amount,
         SUM(retainage_amount)            AS retainage_amount
  FROM prod.po_schedules
  GROUP BY po_header_id
),
grn_dist AS (
  SELECT po_distribution_id, SUM(ledger_amount) AS grn_aed
  FROM prod.grn_all_v2 GROUP BY po_distribution_id
),
proj AS (
  SELECT project_id, MAX(project_number) AS project_number
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number
  FROM prod.tasks GROUP BY task_id
),
dist_agg AS (
  SELECT d.po_header_id,
         COUNT(DISTINCT d.po_distribution_id)            AS distribution_count,
         SUM(d.distribution_amount * NVL(d.rate,1))      AS po_amount_aed,
         COUNT(DISTINCT d.project_id)                    AS project_count,
         LISTAGG(DISTINCT TO_CHAR(pj.project_number), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(pj.project_number)) AS project_numbers,
         COUNT(DISTINCT COALESCE(TO_CHAR(tk.task_number), '#'||TO_CHAR(d.task_id))) AS task_count,
         LISTAGG(DISTINCT COALESCE(TO_CHAR(tk.task_number), '#'||TO_CHAR(d.task_id)), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY COALESCE(TO_CHAR(tk.task_number), '#'||TO_CHAR(d.task_id))) AS task_numbers,
         COUNT(DISTINCT d.pr_number)                     AS pr_count,
         LISTAGG(DISTINCT TO_CHAR(d.pr_number), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(d.pr_number))  AS pr_numbers,
         LISTAGG(DISTINCT d.requestor_name, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY d.requestor_name)      AS requestor_names,
         SUM(CASE WHEN d.funds_status IN ('Reserved','Partially Liquidated')
                  THEN GREATEST(d.distribution_amount * NVL(d.rate,1) - NVL(g.grn_aed,0), 0)
                  END)                                   AS open_oblig_raw
  FROM (
    SELECT * FROM (
      SELECT d0.*,
             ROW_NUMBER() OVER (PARTITION BY d0.po_distribution_id
                                ORDER BY d0.load_ts DESC NULLS LAST) AS rn
      FROM prod.po_distributions d0
    ) WHERE rn = 1
  ) d
  LEFT JOIN grn_dist g ON g.po_distribution_id = d.po_distribution_id
  LEFT JOIN proj    pj ON pj.project_id = d.project_id
  LEFT JOIN tsk     tk ON tk.task_id    = d.task_id
  GROUP BY d.po_header_id
),
grn_hdr AS (
  SELECT po_header_id,
         COUNT(DISTINCT receipt_number) AS grn_receipt_count,
         COUNT(*)                       AS grn_line_count,
         SUM(ledger_amount)             AS grn_amount_aed,
         MAX(transaction_date)          AS last_receipt_date,
         LISTAGG(DISTINCT TO_CHAR(receipt_number), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(receipt_number)) AS grn_receipt_numbers
  FROM prod.grn_all_v2
  GROUP BY po_header_id
),
inv_link AS (
  SELECT d.po_number, d.invoice_id,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS matched_aed
  FROM prod.ap_invoice_distributions d
  WHERE d.po_number IS NOT NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY d.po_number, d.invoice_id
),
inv AS (
  SELECT invoice_id,
         MAX(invoice_number)            AS invoice_number,
         MAX(invoice_date)              AS invoice_date,
         MAX(invoice_amount)            AS invoice_amount,
         MAX(invoice_amount_paid)       AS invoice_amount_paid,
         MAX(invoice_amount_functional) AS invoice_amount_functional,
         MAX(validation_status)         AS validation_status
  FROM prod.ap_invoices
  GROUP BY invoice_id
),
inv_agg AS (
  SELECT il.po_number,
         COUNT(*)                                              AS ap_invoice_count,
         SUM(il.matched_aed)                                   AS ap_invoiced_amount_aed,
         SUM(NVL(i.invoice_amount_functional, i.invoice_amount)) AS ap_invoice_gross_amount_aed,
         SUM(il.matched_aed * LEAST(1, GREATEST(0,
             CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 0
                  ELSE NVL(i.invoice_amount_paid,0) / i.invoice_amount END))) AS ap_paid_amount_aed,
         SUM(CASE WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005
                  THEN 1 ELSE 0 END)                           AS paid_invoice_count,
         SUM(CASE WHEN ABS(NVL(i.invoice_amount_paid,0)) <  ABS(NVL(i.invoice_amount,0)) - 0.005
                   AND NVL(i.invoice_amount_paid,0) <> 0
                  THEN 1 ELSE 0 END)                           AS partially_paid_invoice_count,
         SUM(CASE WHEN NVL(i.invoice_amount_paid,0) = 0
                   AND ABS(NVL(i.invoice_amount,0)) > 0.005
                  THEN 1 ELSE 0 END)                           AS unpaid_invoice_count,
         MAX(i.invoice_date)                                   AS last_invoice_date,
         LISTAGG(DISTINCT i.invoice_number, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY i.invoice_number)            AS ap_invoice_numbers
  FROM inv_link il
  JOIN inv i ON i.invoice_id = il.invoice_id
  WHERE NVL(i.validation_status,'x') <> 'Canceled'
  GROUP BY il.po_number
),
invpr AS (
  SELECT d.po_number,
         COUNT(DISTINCT d.requisition) AS invoiced_pr_count,
         LISTAGG(DISTINCT TO_CHAR(d.requisition), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(d.requisition)) AS invoiced_pr_numbers
  FROM prod.ap_invoice_distributions d
  WHERE d.po_number IS NOT NULL
    AND d.requisition IS NOT NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY d.po_number
)
SELECT
  -- identity and status
  h.order_number,
  h.status                                   AS po_status,
  h.funds_status,
  h.order_type,
  h.po_type,
  h.document_style,
  h.order_description,
  -- parties
  h.supplier_number,
  h.supplier_name,
  h.supplier_site,
  h.buyer,
  da.requestor_names,
  h.cost_center,
  h.procurement_bu,
  h.requisitioning_bu,
  -- order amounts
  h.currency,
  TO_NUMBER(h.rate DEFAULT NULL ON CONVERSION ERROR)           AS fx_rate_to_aed,
  TO_NUMBER(h.ordered_amount DEFAULT NULL ON CONVERSION ERROR) AS ordered_amount,
  ROUND(NVL(da.po_amount_aed,0), 2)          AS po_amount_aed,
  la.line_amount_total,
  -- document statistics
  NVL(la.line_count,0)                       AS line_count,
  NVL(sa.schedule_count,0)                   AS schedule_count,
  NVL(da.distribution_count,0)               AS distribution_count,
  NVL(da.project_count,0)                    AS project_count,
  da.project_numbers,
  NVL(da.task_count,0)                       AS task_count,
  da.task_numbers,
  -- backing requisitions (carried on the PO distributions)
  NVL(da.pr_count,0)                         AS pr_count,
  da.pr_numbers,
  -- requisitions referenced by the matched AP invoice distributions
  NVL(ip.invoiced_pr_count,0)                AS invoiced_pr_count,
  ip.invoiced_pr_numbers,
  -- payables (matched-to-this-PO portion; cancelled invoices excluded)
  NVL(ia.ap_invoice_count,0)                 AS ap_invoice_count,
  ROUND(NVL(ia.ap_invoiced_amount_aed,0), 2) AS ap_invoiced_amount_aed,
  ROUND(NVL(ia.ap_invoice_gross_amount_aed,0), 2) AS ap_invoice_gross_amount_aed,
  ROUND(NVL(ia.ap_paid_amount_aed,0), 2)     AS ap_paid_amount_aed,
  NVL(ia.paid_invoice_count,0)               AS paid_invoice_count,
  NVL(ia.partially_paid_invoice_count,0)     AS partially_paid_invoice_count,
  NVL(ia.unpaid_invoice_count,0)             AS unpaid_invoice_count,
  ia.last_invoice_date,
  ia.ap_invoice_numbers,
  -- receiving (GRN; ledger_amount is already AED)
  NVL(gh.grn_receipt_count,0)                AS grn_receipt_count,
  NVL(gh.grn_line_count,0)                   AS grn_line_count,
  ROUND(NVL(gh.grn_amount_aed,0), 2)         AS grn_amount_aed,
  gh.last_receipt_date,
  gh.grn_receipt_numbers,
  -- open obligation (GRN-netted; zero once the order is finally closed)
  CASE WHEN NVL(h.status,'x') = 'Finally Closed' THEN 0
       ELSE ROUND(NVL(da.open_oblig_raw,0), 2) END             AS open_obligation_aed,
  -- schedule money rollups (doc currency, from the Fusion schedule figures)
  sa.schedule_billed_amount,
  sa.schedule_unbilled_amount,
  sa.schedule_received_amount,
  sa.retainage_amount,
  -- progress ratios
  ROUND(NVL(gh.grn_amount_aed,0)        / NULLIF(da.po_amount_aed,0)          * 100, 1) AS received_pct,
  ROUND(NVL(ia.ap_invoiced_amount_aed,0)/ NULLIF(da.po_amount_aed,0)          * 100, 1) AS invoiced_pct,
  ROUND(NVL(ia.ap_paid_amount_aed,0)    / NULLIF(ia.ap_invoiced_amount_aed,0) * 100, 1) AS paid_pct,
  -- terms and references
  h.payment_terms,
  h.reference_number,
  h.performance_bond,
  h.vendor_quote_reference,
  h.procurement_contract_admin,
  h.savings_amount,
  h.savings_reason,
  h.close_release_amount,
  -- lifecycle dates
  h.creation_date,
  TO_DATE(h.submit_date DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD') AS submitted_date,
  h.approved_date,
  h.closed_date,
  h.cancelled_date,
  h.cancelled_by,
  h.actual_start_date,
  h.actual_end_date,
  h.updated_by                               AS last_updated_by,
  h.updated_date                             AS last_updated_date,
  -- technical key
  h.po_header_id
FROM hdr h
LEFT JOIN lin_agg la ON la.po_header_id = h.po_header_id
LEFT JOIN sch_agg sa ON sa.po_header_id = h.po_header_id
LEFT JOIN dist_agg da ON da.po_header_id = h.po_header_id
LEFT JOIN grn_hdr gh ON gh.po_header_id = h.po_header_id
LEFT JOIN inv_agg ia ON ia.po_number = h.order_number
LEFT JOIN invpr   ip ON ip.po_number = h.order_number;

PROMPT PO_HEADER_V created.

PROMPT Done - PO_HEADER_V / PO_LINES_V / PO_SCHEDULES_V / PO_DISTRIBUTIONS_V.
