-- ===========================================================================
-- DCT Actuals Reporting - performance layer (db/v2/33)
-- ---------------------------------------------------------------------------
-- DCT_GL_COA_SNAP : current-effective INDEXED SNAPSHOT of the date-tracked
--                   DCT_GL_COA_V, so the actuals fact views join it as fast
--                   indexed look-ups instead of re-computing + hash-joining the
--                   heavy COA view per branch (the unindexed cc_string hash
--                   joins spilled to TEMP and raised ORA-01652 on filtered scans).
--
-- Implemented as a TABLE (CTAS) + refresh proc rather than a MATERIALIZED VIEW:
-- creating an MV in the PROD schema from ADMIN needs CREATE ANY TABLE (the MV's
-- container) granted directly, a broad privilege we deliberately avoid. ADMIN
-- can already CTAS a single table into PROD, and an indexed table is functionally
-- identical for query performance (the MV's only extra is auto-refresh, which
-- prod.dct_actuals_refresh replicates).
--
-- WHY a snapshot, not the date-tracked view itself:
--   DCT_GL_COA_V resolves Sector/Chapter/DCT-Program as-of
--   SYS_CONTEXT('GL_CTX','ASOF') (default TRUNC(SYSDATE)). A snapshot is built
--   once, freezing to CURRENT-date classification (GL_CTX must be UNSET during
--   build/refresh - it is, in a normal job/SQLcl session). The actuals fact
--   never sets GL_CTX, so current-date classification is exactly what it needs.
--   The date-tracked DCT_GL_COA_V is left UNTOUCHED for the GL app (App 210).
--
-- REFRESH after every ATD load and after any GL classification edit:
--   EXEC prod.dct_actuals_refresh;
--
-- DEPLOY ORDER: run this BEFORE re-running 32 (the fact views reference SNAP).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- rerunnable: drop the snapshot if it already exists
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.dct_gl_coa_snap PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE prod.dct_gl_coa_snap AS SELECT * FROM prod.dct_gl_coa_v;

CREATE INDEX prod.ix_dct_coa_snap_ccid  ON prod.dct_gl_coa_snap(cc_id);
CREATE INDEX prod.ix_dct_coa_snap_ccstr ON prod.dct_gl_coa_snap(cc_string);

PROMPT DCT_GL_COA_SNAP created (CTAS) + indexed on cc_id / cc_string.

-- Atomic refresh: DELETE + INSERT in one transaction (9k rows; no empty window
-- as TRUNCATE would cause). Call from the ATD loader / a scheduler job.
CREATE OR REPLACE PROCEDURE prod.dct_actuals_refresh AS
BEGIN
  DELETE FROM prod.dct_gl_coa_snap;
  INSERT INTO prod.dct_gl_coa_snap SELECT * FROM prod.dct_gl_coa_v;
  COMMIT;
  DBMS_STATS.GATHER_TABLE_STATS('PROD','DCT_GL_COA_SNAP');
END;
/

PROMPT prod.dct_actuals_refresh created.

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS('PROD','DCT_GL_COA_SNAP');
END;
/

PROMPT DCT_GL_COA_SNAP stats gathered.
