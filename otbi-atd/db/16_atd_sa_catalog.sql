-- =============================================================================
-- ATD Loader (App 208) -- subject-area column catalog (picker cache + scrape queue)
-- File : 16_atd_sa_catalog.sql
-- One row per OTBI subject area. Serves BOTH as the discover queue and the cache
-- for the "Add New OTBI Analysis" column picker:
--   POST /atd/subject-areas/discover  -> upserts a QUEUED row
--   python runner.py --discover       -> drains QUEUED rows: drives the OTBI
--                                        Answers UI (create_analysis.discover_
--                                        subject_area), scrapes every folder's
--                                        columns into catalog_json, marks READY
--   GET  /atd/subject-areas           -> lists rows + status for the picker
--   GET  /atd/subject-areas/columns   -> returns catalog_json for one READY SA
-- Status: QUEUED -> SCRAPING -> READY | FAILED.
-- catalog_json shape: {"subject_area":..,"folders":[{"folder":..,"columns":[..]}]}
-- Run : sql -name prod_mcp @16_atd_sa_catalog.sql   (idempotent)
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.atd_sa_catalog (
      subject_area  VARCHAR2(256) PRIMARY KEY,
      catalog_json  CLOB,
      folder_count  NUMBER,
      column_count  NUMBER,
      status        VARCHAR2(20) DEFAULT 'QUEUED' NOT NULL,
      message       VARCHAR2(4000),
      requested_by  VARCHAR2(128),
      requested_at  TIMESTAMP DEFAULT SYSTIMESTAMP,
      scraped_at    TIMESTAMP
    )
  ]';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;   -- -955 = name already used; keep existing
END;
/

BEGIN
  EXECUTE IMMEDIATE
    'CREATE INDEX prod.ix_atd_sacat_status ON prod.atd_sa_catalog (status)';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE NOT IN (-955, -1408) THEN RAISE; END IF;   -- already exists / already indexed
END;
/

PROMPT 16_atd_sa_catalog : done
