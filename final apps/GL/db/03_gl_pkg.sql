-- ===========================================================================
-- General Ledger (App 210) - Layer 3a - DCT_GL_CLASS_PKG + GL_CTX context
-- ---------------------------------------------------------------------------
--  norm()            canonical zero-padded segment string (used in views/joins)
--  set_asof / clear_asof / get_asof  drive the as-of date for DCT_GL_COA_V
--  resolve_value_id  classification value effective on a given date
--  validate_map      overlap + dimension-consistency guard (raises -20090/-20001)
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- Application context driven by the package (namespace GL_CTX, key ASOF).
CREATE OR REPLACE CONTEXT gl_ctx USING prod.dct_gl_class_pkg;

CREATE OR REPLACE PACKAGE prod.dct_gl_class_pkg AS

  -- canonical padded segment code: prefix || LPAD(code, width, '0')
  FUNCTION norm (p_code IN VARCHAR2, p_width IN NUMBER, p_prefix IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 DETERMINISTIC;

  -- as-of date plumbing (SYS_CONTEXT('GL_CTX','ASOF'))
  PROCEDURE set_asof   (p_date IN DATE);
  PROCEDURE clear_asof;
  FUNCTION  get_asof   RETURN DATE;

  -- Budget Utilization YTD period-end (SYS_CONTEXT('GL_CTX','BUTIL_END')).
  -- When set, DCT_BUDGET_UTILIZATION_V facts include only transactions dated
  -- on or before this day (within the budget year); unset = full year.
  PROCEDURE set_butil_end   (p_date IN DATE);
  PROCEDURE clear_butil_end;

  -- value effective on p_date for a (dimension, segment value)
  FUNCTION resolve_value_id (p_type IN VARCHAR2, p_segment_value IN VARCHAR2,
                             p_date IN DATE DEFAULT SYSDATE) RETURN NUMBER;

  -- guard a create/update of a date-tracked assignment
  PROCEDURE validate_map (p_map_id         IN NUMBER,
                          p_type           IN VARCHAR2,
                          p_segment_value  IN VARCHAR2,
                          p_class_value_id IN NUMBER,
                          p_start          IN DATE,
                          p_end            IN DATE);

END dct_gl_class_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_gl_class_pkg AS

  c_hi CONSTANT DATE := DATE '4000-01-01';

  FUNCTION norm (p_code IN VARCHAR2, p_width IN NUMBER, p_prefix IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 DETERMINISTIC IS
  BEGIN
    IF p_code IS NULL THEN
      RETURN NULL;
    END IF;
    RETURN p_prefix || LPAD(TRIM(p_code), GREATEST(NVL(p_width,0), LENGTH(TRIM(p_code))), '0');
  END norm;

  PROCEDURE set_asof (p_date IN DATE) IS
  BEGIN
    DBMS_SESSION.set_context('GL_CTX', 'ASOF', TO_CHAR(p_date, 'YYYY-MM-DD'));
  END set_asof;

  PROCEDURE clear_asof IS
  BEGIN
    DBMS_SESSION.clear_context('GL_CTX', NULL, 'ASOF');
  END clear_asof;

  FUNCTION get_asof RETURN DATE IS
  BEGIN
    RETURN NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'), 'YYYY-MM-DD'), TRUNC(SYSDATE));
  END get_asof;

  PROCEDURE set_butil_end (p_date IN DATE) IS
  BEGIN
    DBMS_SESSION.set_context('GL_CTX', 'BUTIL_END', TO_CHAR(p_date, 'YYYY-MM-DD'));
  END set_butil_end;

  PROCEDURE clear_butil_end IS
  BEGIN
    DBMS_SESSION.clear_context('GL_CTX', NULL, 'BUTIL_END');
  END clear_butil_end;

  FUNCTION resolve_value_id (p_type IN VARCHAR2, p_segment_value IN VARCHAR2,
                             p_date IN DATE DEFAULT SYSDATE) RETURN NUMBER IS
    l_id NUMBER;
  BEGIN
    SELECT class_value_id INTO l_id FROM (
      SELECT m.class_value_id
      FROM   prod.dct_gl_seg_class_map m
      WHERE  m.class_type_code = p_type
      AND    m.segment_value   = p_segment_value
      AND    TRUNC(p_date) BETWEEN m.start_date AND NVL(m.end_date, c_hi)
      ORDER BY m.start_date DESC
    ) WHERE ROWNUM = 1;
    RETURN l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  END resolve_value_id;

  PROCEDURE validate_map (p_map_id         IN NUMBER,
                          p_type           IN VARCHAR2,
                          p_segment_value  IN VARCHAR2,
                          p_class_value_id IN NUMBER,
                          p_start          IN DATE,
                          p_end            IN DATE) IS
    n NUMBER;
  BEGIN
    IF p_segment_value IS NULL OR p_start IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Segment value and start date are required.');
    END IF;
    IF p_end IS NOT NULL AND p_end < p_start THEN
      RAISE_APPLICATION_ERROR(-20001, 'End date cannot be before start date.');
    END IF;

    -- value must belong to the dimension
    SELECT COUNT(*) INTO n FROM prod.dct_gl_class_value
     WHERE class_value_id = p_class_value_id AND class_type_code = p_type;
    IF n = 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Selected value does not belong to classification "' || p_type || '".');
    END IF;

    -- no overlapping effective period for the same (dimension, segment value)
    SELECT COUNT(*) INTO n
    FROM   prod.dct_gl_seg_class_map m
    WHERE  m.class_type_code = p_type
    AND    m.segment_value   = p_segment_value
    AND    (p_map_id IS NULL OR m.map_id <> p_map_id)
    AND    m.start_date <= NVL(p_end, c_hi)
    AND    NVL(m.end_date, c_hi) >= p_start;
    IF n > 0 THEN
      RAISE_APPLICATION_ERROR(-20090,
        'This period overlaps an existing assignment for ' || p_type ||
        ' / segment ' || p_segment_value || '. Close or adjust the existing one first.');
    END IF;
  END validate_map;

END dct_gl_class_pkg;
/

PROMPT DCT_GL_CLASS_PKG + GL_CTX context compiled.
