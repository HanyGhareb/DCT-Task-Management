-- ===========================================================================
-- otbi-atd : 36 job sub-categories  (hierarchical ATD_JOB_CATEGORY)
--   Adds ATD_JOB_CATEGORY.parent_code -> a category with parent_code = NULL is a
--   top-level category (e.g. Purchasing); one with parent_code set is a SUB-category
--   (e.g. PO / PR / REC under Purchasing). A job is tagged to any category (leaf or
--   parent); filtering the Jobs list by a parent includes all its children (db/13).
-- Additive + rerunnable (guards). The /categories handlers (parentCode in GET/POST/PUT)
-- live in db/32; the parent-includes-children Jobs filter lives in db/13.
-- Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- parent_code column (self-reference; NULL = top-level)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_job_category ADD (parent_code VARCHAR2(30))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- already exists
END;
/

-- self-referencing FK (a sub-category's parent must be a real category)
BEGIN
  EXECUTE IMMEDIATE q'[ALTER TABLE prod.atd_job_category
    ADD CONSTRAINT fk_atd_jobcat_parent FOREIGN KEY (parent_code)
        REFERENCES prod.atd_job_category (category_code)]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-2275, -2264, -955) THEN RAISE; END IF;
END;
/

-- a category cannot be its own parent
BEGIN
  EXECUTE IMMEDIATE q'[ALTER TABLE prod.atd_job_category
    ADD CONSTRAINT ck_atd_jobcat_parent_self CHECK (parent_code IS NULL OR parent_code <> category_code)]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-2264, -955) THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_atd_jobcat_parent ON prod.atd_job_category (parent_code)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

SET ECHO OFF
PROMPT otbi-atd 36 job sub-category : done
