-- =============================================================================
-- Accounts Receivable Module (App 206) — Reporting Views
-- File    : 04_ar_views.sql
-- Schema  : PROD
-- Run     : After 01_ar_ddl.sql + 02_ar_seed.sql
-- =============================================================================
-- Views:
--   1. DCT_AR_EVENT_PNL_V     — per event x basis totals (confirmed+included)
--   2. DCT_AR_CATEGORY_PNL_V  — event x category x type x basis sums
--   3. DCT_AR_FILE_STATUS_V   — per-event file processing progress (UI polling)
--   4. DCT_AR_COMPLETENESS_V  — required vs present doc categories per event
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DCT_AR_EVENT_PNL_V
--    One row per event x basis. Only CONFIRMED + included lines count.
-- =============================================================================
CREATE OR REPLACE VIEW dct_ar_event_pnl_v AS
SELECT e.event_id,
       e.event_code,
       e.event_name_en,
       e.event_type,
       e.status                                   AS event_status,
       e.start_date,
       e.end_date,
       e.organizer_name,
       l.basis,
       SUM(CASE WHEN l.line_type = 'REVENUE' THEN l.base_amount ELSE 0 END) AS total_revenue,
       SUM(CASE WHEN l.line_type = 'EXPENSE' THEN l.base_amount ELSE 0 END) AS total_expense,
       SUM(CASE WHEN l.line_type = 'REVENUE' THEN l.base_amount ELSE 0 END)
     - SUM(CASE WHEN l.line_type = 'EXPENSE' THEN l.base_amount ELSE 0 END) AS net_result,
       CASE WHEN SUM(CASE WHEN l.line_type = 'REVENUE' THEN l.base_amount ELSE 0 END) = 0 THEN NULL
            ELSE ROUND(
                 ( SUM(CASE WHEN l.line_type = 'REVENUE' THEN l.base_amount ELSE 0 END)
                 - SUM(CASE WHEN l.line_type = 'EXPENSE' THEN l.base_amount ELSE 0 END) )
                 / SUM(CASE WHEN l.line_type = 'REVENUE' THEN l.base_amount ELSE 0 END) * 100, 2)
       END                                        AS margin_pct,
       COUNT(*)                                   AS line_count
FROM   dct_ar_events e
JOIN   dct_ar_pnl_lines l
       ON  l.event_id      = e.event_id
       AND l.review_status = 'CONFIRMED'
       AND l.is_included   = 'Y'
WHERE  e.is_active = 'Y'
GROUP BY e.event_id, e.event_code, e.event_name_en, e.event_type,
         e.status, e.start_date, e.end_date, e.organizer_name, l.basis;

-- =============================================================================
-- 2. DCT_AR_CATEGORY_PNL_V
--    Event x category x line_type x basis sums — feeds charts and the
--    budget-vs-actual variance matrix.
-- =============================================================================
CREATE OR REPLACE VIEW dct_ar_category_pnl_v AS
SELECT l.event_id,
       e.event_code,
       e.event_name_en,
       l.line_type,
       l.basis,
       l.category_id,
       NVL(c.category_code, 'UNMAPPED')           AS category_code,
       NVL(c.category_name_en, 'Unmapped')        AS category_name_en,
       SUM(l.base_amount)                         AS total_amount,
       COUNT(*)                                   AS line_count,
       MIN(l.item_date)                           AS first_item_date,
       MAX(l.item_date)                           AS last_item_date
FROM   dct_ar_pnl_lines l
JOIN   dct_ar_events e ON e.event_id = l.event_id
LEFT   JOIN dct_ar_pnl_categories c ON c.category_id = l.category_id
WHERE  l.review_status = 'CONFIRMED'
AND    l.is_included   = 'Y'
GROUP BY l.event_id, e.event_code, e.event_name_en, l.line_type, l.basis,
         l.category_id, c.category_code, c.category_name_en;

-- =============================================================================
-- 3. DCT_AR_FILE_STATUS_V
--    Per-event processing progress. Polled by the JET aiProgress panel.
-- =============================================================================
CREATE OR REPLACE VIEW dct_ar_file_status_v AS
SELECT f.event_id,
       COUNT(*)                                                          AS total_files,
       SUM(CASE WHEN f.classification_status = 'PENDING'       THEN 1 ELSE 0 END) AS class_pending,
       SUM(CASE WHEN f.classification_status = 'AI_CLASSIFIED' THEN 1 ELSE 0 END) AS class_ai_done,
       SUM(CASE WHEN f.classification_status = 'CONFIRMED'     THEN 1 ELSE 0 END) AS class_confirmed,
       SUM(CASE WHEN f.classification_status = 'FAILED'        THEN 1 ELSE 0 END) AS class_failed,
       SUM(CASE WHEN f.classification_status = 'SKIPPED'       THEN 1 ELSE 0 END) AS class_skipped,
       SUM(CASE WHEN f.extraction_status = 'PENDING'   THEN 1 ELSE 0 END)         AS extract_pending,
       SUM(CASE WHEN f.extraction_status = 'EXTRACTED' THEN 1 ELSE 0 END)         AS extract_done,
       SUM(CASE WHEN f.extraction_status = 'CONFIRMED' THEN 1 ELSE 0 END)         AS extract_confirmed,
       SUM(CASE WHEN f.extraction_status = 'FAILED'    THEN 1 ELSE 0 END)         AS extract_failed,
       SUM(NVL(f.lines_extracted, 0))                                             AS total_lines_extracted,
       SUM(NVL(f.file_size_bytes, 0))                                             AS total_bytes
FROM   dct_ar_event_files f
WHERE  f.is_active = 'Y'
GROUP BY f.event_id;

-- =============================================================================
-- 4. DCT_AR_COMPLETENESS_V
--    Required vs present document categories per event. A category is required
--    when the event's type appears in its pipe-separated required_for_event_types.
-- =============================================================================
CREATE OR REPLACE VIEW dct_ar_completeness_v AS
SELECT e.event_id,
       e.event_code,
       dc.doc_cat_id,
       dc.doc_cat_code,
       dc.doc_cat_name_en,
       CASE WHEN EXISTS (
                SELECT 1 FROM dct_ar_event_files f
                WHERE  f.event_id   = e.event_id
                AND    f.doc_cat_id = dc.doc_cat_id
                AND    f.is_active  = 'Y'
            ) THEN 'Y' ELSE 'N'
       END AS is_present
FROM   dct_ar_events e
JOIN   dct_ar_doc_categories dc
       ON dc.is_active = 'Y'
       AND dc.required_for_event_types IS NOT NULL
       AND ('|' || dc.required_for_event_types || '|') LIKE '%|' || e.event_type || '|%'
WHERE  e.is_active = 'Y';

PROMPT === AR views complete: 4 views ===
