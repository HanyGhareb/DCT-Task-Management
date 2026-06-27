-- ===========================================================================
-- General Ledger (App 210) - Layer 2 - classification tables (PROD schema)
-- ---------------------------------------------------------------------------
-- Generic, dimension-driven, date-tracked classification of GL segment values.
--   DCT_GL_CLASS_TYPE   (dimension catalog: SECTOR / CHAPTER / DCT_PROGRAM)
--     -> DCT_GL_CLASS_VALUE  (the Sector / Chapter / Program master values)
--        -> DCT_GL_SEG_CLASS_MAP (date-tracked segment-value -> class-value map)
-- No FK to the ATD-loaded base tables - the map links by normalized segment
-- code only, so periodic reloads and the rename never break integrity.
-- Re-runnable: drops are guarded; create-if-not-exists pattern via plsql.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---------------------------------------------------------------------------
-- DCT_GL_CLASS_TYPE - dimension catalog
-- ---------------------------------------------------------------------------
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables WHERE owner='PROD' AND table_name='DCT_GL_CLASS_TYPE';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_gl_class_type (
        class_type_code  VARCHAR2(30)  NOT NULL,
        name_en          VARCHAR2(200) NOT NULL,
        name_ar          VARCHAR2(200),
        segment_key      VARCHAR2(30)  NOT NULL,
        seg_pad_width    NUMBER        DEFAULT 0 NOT NULL,
        seg_prefix       VARCHAR2(4),
        is_hierarchical  VARCHAR2(1)   DEFAULT 'N' NOT NULL,
        display_order    NUMBER        DEFAULT 0,
        is_active        VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
        created_by       VARCHAR2(100),
        created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        updated_by       VARCHAR2(100),
        updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT pk_dct_gl_ctype PRIMARY KEY (class_type_code),
        CONSTRAINT ck_dct_gl_ctype_hier   CHECK (is_hierarchical IN ('Y','N')),
        CONSTRAINT ck_dct_gl_ctype_active CHECK (is_active IN ('Y','N'))
      )]';
  END IF;
END;
/

-- ---------------------------------------------------------------------------
-- DCT_GL_CLASS_VALUE - the master values per dimension (hierarchical)
-- ---------------------------------------------------------------------------
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables WHERE owner='PROD' AND table_name='DCT_GL_CLASS_VALUE';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_gl_class_value (
        class_value_id   NUMBER GENERATED ALWAYS AS IDENTITY,
        class_type_code  VARCHAR2(30)  NOT NULL,
        value_code       VARCHAR2(60)  NOT NULL,
        name_en          VARCHAR2(300) NOT NULL,
        name_ar          VARCHAR2(300),
        alt_name1        VARCHAR2(300),
        alt_name2        VARCHAR2(300),
        alt_name3        VARCHAR2(300),
        parent_value_id  NUMBER,
        tag              VARCHAR2(60),
        display_order    NUMBER        DEFAULT 0,
        is_active        VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
        created_by       VARCHAR2(100),
        created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        updated_by       VARCHAR2(100),
        updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT pk_dct_gl_cval PRIMARY KEY (class_value_id),
        CONSTRAINT uq_dct_gl_cval_code UNIQUE (class_type_code, value_code),
        CONSTRAINT uq_dct_gl_cval_tv   UNIQUE (class_type_code, class_value_id),
        CONSTRAINT fk_dct_gl_cval_type FOREIGN KEY (class_type_code)
                   REFERENCES prod.dct_gl_class_type(class_type_code),
        CONSTRAINT fk_dct_gl_cval_parent FOREIGN KEY (parent_value_id)
                   REFERENCES prod.dct_gl_class_value(class_value_id),
        CONSTRAINT ck_dct_gl_cval_active CHECK (is_active IN ('Y','N'))
      )]';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_gl_cval_type   ON prod.dct_gl_class_value(class_type_code, display_order)';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_gl_cval_parent ON prod.dct_gl_class_value(parent_value_id)';
  END IF;
END;
/

-- Up to 3 user-defined alternative names / aliases per classification value
-- (idempotent: adds the columns to an already-created table).
DECLARE
  n NUMBER;
BEGIN
  FOR c IN (SELECT 'ALT_NAME1' cn FROM dual UNION ALL
            SELECT 'ALT_NAME2' FROM dual UNION ALL
            SELECT 'ALT_NAME3' FROM dual) LOOP
    SELECT COUNT(*) INTO n FROM all_tab_columns
     WHERE owner='PROD' AND table_name='DCT_GL_CLASS_VALUE' AND column_name=c.cn;
    IF n = 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_gl_class_value ADD ' || c.cn || ' VARCHAR2(300)';
    END IF;
  END LOOP;
END;
/

-- ---------------------------------------------------------------------------
-- DCT_GL_SEG_CLASS_MAP - the date-tracked assignment (heart of the model)
-- ---------------------------------------------------------------------------
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables WHERE owner='PROD' AND table_name='DCT_GL_SEG_CLASS_MAP';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_gl_seg_class_map (
        map_id           NUMBER GENERATED ALWAYS AS IDENTITY,
        class_type_code  VARCHAR2(30)  NOT NULL,
        segment_value    VARCHAR2(60)  NOT NULL,
        class_value_id   NUMBER        NOT NULL,
        start_date       DATE          NOT NULL,
        end_date         DATE,
        notes            VARCHAR2(1000),
        created_by       VARCHAR2(100),
        created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        updated_by       VARCHAR2(100),
        updated_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT pk_dct_gl_map PRIMARY KEY (map_id),
        CONSTRAINT fk_dct_gl_map_tv FOREIGN KEY (class_type_code, class_value_id)
                   REFERENCES prod.dct_gl_class_value(class_type_code, class_value_id),
        CONSTRAINT fk_dct_gl_map_type FOREIGN KEY (class_type_code)
                   REFERENCES prod.dct_gl_class_type(class_type_code),
        CONSTRAINT ck_dct_gl_map_dates CHECK (end_date IS NULL OR end_date >= start_date)
      )]';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_gl_map_seg ON prod.dct_gl_seg_class_map(class_type_code, segment_value, start_date)';
  END IF;
END;
/

PROMPT GL classification tables ready (DCT_GL_CLASS_TYPE / _VALUE / _SEG_CLASS_MAP).
