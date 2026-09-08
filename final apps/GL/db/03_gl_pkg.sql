-- ===========================================================================
-- General Ledger (App 210) - Layer 3a - DCT_GL_CLASS_PKG + GL_CTX context
-- ---------------------------------------------------------------------------
--  norm()            canonical zero-padded segment string (used in views/joins)
--  set_asof / clear_asof / get_asof  drive the as-of date for DCT_GL_COA_V
--  resolve_value_id  classification value effective on a given date
--  validate_map      overlap + dimension-consistency guard (raises -20090/-20001);
--                    + segment_key / one-Entity-rule-per-combination (GL/db/47)
--  segment_value_of  one padded segment of a canonical combination string
--  entity_of         Entity code of a combination string (rules -> default -> NULL)
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

  -- Budget Utilization "Select to include Budget Override" flag
  -- (SYS_CONTEXT('GL_CTX','BUTIL_OVR')). When 'Y', the pb CTE of
  -- DCT_BUDGET_UTILIZATION_V ADDS the signed budget change to the budget
  -- (db/v2/106 v2: budget + NVL(budget_change,0); a negative change subtracts),
  -- so every budget-derived figure (annual, YTD, fund available, utilization)
  -- and every consuming report reflects it. A change counts in YTD from its own
  -- accounting period onward. Unset/other = Fusion budget as before.
  PROCEDURE set_butil_ovr   (p_flag IN VARCHAR2);
  PROCEDURE clear_butil_ovr;

  -- value effective on p_date for a (dimension, segment value)
  FUNCTION resolve_value_id (p_type IN VARCHAR2, p_segment_value IN VARCHAR2,
                             p_date IN DATE DEFAULT SYSDATE) RETURN NUMBER;

  -- guard a create/update of a date-tracked assignment. p_segment_key (GL/db/47,
  -- 2026-09-04): the GL segment the rule reads -- NULL = the dimension's own
  -- segment; only ENTITY rules may name another one (any of the 10 segments).
  -- ENTITY rules must never overlap on a real combination: a combination may
  -- match ONE Entity rule only (checked against DCT_GL_COA_SNAP, raises -20090).
  PROCEDURE validate_map (p_map_id         IN NUMBER,
                          p_type           IN VARCHAR2,
                          p_segment_value  IN VARCHAR2,
                          p_class_value_id IN NUMBER,
                          p_start          IN DATE,
                          p_end            IN DATE,
                          p_segment_key    IN VARCHAR2 DEFAULT NULL);

  -- the padded value of one segment (by DCT_GL_SEGMENT position) of a canonical
  -- 10-segment combination string; NULL for an unknown key
  FUNCTION segment_value_of (p_cc_string IN VARCHAR2, p_segment_key IN VARCHAR2) RETURN VARCHAR2;

  -- Entity code for a canonical combination string on p_date (default = the
  -- GL_CTX as-of date): the matching ENTITY rule, else the flagged default
  -- value, else NULL (= Unclassified). Row-by-row fallback for strings that
  -- are not in the COA snapshot (plan uploads); page-scale reads join the
  -- snapshot's entity_class_code instead.
  -- RESULT_CACHE: page-scale SQL calls it once per row (tens of thousands of
  -- rows) -- the cache turns that into one rule lookup per distinct
  -- (string, date) and is invalidated automatically when a rule or value
  -- changes, so every surface sees a rule edit at once. SQL callers pass an
  -- explicit date (TRUNC(SYSDATE)); entity_asof() is the GL_CTX-aware wrapper.
  FUNCTION entity_of (p_cc_string IN VARCHAR2, p_date IN DATE) RETURN VARCHAR2 RESULT_CACHE;
  FUNCTION entity_asof (p_cc_string IN VARCHAR2) RETURN VARCHAR2;

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

  PROCEDURE set_butil_ovr (p_flag IN VARCHAR2) IS
  BEGIN
    IF UPPER(NVL(p_flag,'N')) = 'Y' THEN
      DBMS_SESSION.set_context('GL_CTX', 'BUTIL_OVR', 'Y');
    ELSE
      DBMS_SESSION.clear_context('GL_CTX', NULL, 'BUTIL_OVR');
    END IF;
  END set_butil_ovr;

  PROCEDURE clear_butil_ovr IS
  BEGIN
    DBMS_SESSION.clear_context('GL_CTX', NULL, 'BUTIL_OVR');
  END clear_butil_ovr;

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

  FUNCTION segment_value_of (p_cc_string IN VARCHAR2, p_segment_key IN VARCHAR2) RETURN VARCHAR2 IS
    l_pos NUMBER; l_w NUMBER;
  BEGIN
    IF p_cc_string IS NULL OR p_segment_key IS NULL THEN RETURN NULL; END IF;
    SELECT position, width INTO l_pos, l_w FROM prod.dct_gl_segment WHERE segment_key = UPPER(p_segment_key);
    RETURN norm(REGEXP_SUBSTR(p_cc_string, '[^.]+', 1, l_pos), l_w);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END segment_value_of;

  FUNCTION entity_of (p_cc_string IN VARCHAR2, p_date IN DATE) RETURN VARCHAR2 RESULT_CACHE IS
    l_d    DATE := TRUNC(NVL(p_date, SYSDATE));
    l_code VARCHAR2(60);
  BEGIN
    IF p_cc_string IS NULL THEN RETURN NULL; END IF;
    SELECT value_code INTO l_code FROM (
      SELECT v.value_code
        FROM prod.dct_gl_seg_class_map m
        JOIN prod.dct_gl_class_type  t ON t.class_type_code = m.class_type_code
        JOIN prod.dct_gl_segment     g ON g.segment_key = NVL(m.segment_key, t.segment_key)
        JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
       WHERE m.class_type_code = 'ENTITY'
         AND l_d BETWEEN m.start_date AND NVL(m.end_date, c_hi)
         AND m.segment_value = norm(REGEXP_SUBSTR(p_cc_string, '[^.]+', 1, g.position), g.width)
       ORDER BY m.start_date, m.map_id
    ) WHERE ROWNUM = 1;
    RETURN l_code;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    BEGIN
      SELECT value_code INTO l_code FROM prod.dct_gl_class_value
       WHERE class_type_code = 'ENTITY' AND is_default = 'Y' AND is_active = 'Y' AND ROWNUM = 1;
      RETURN l_code;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;
  END entity_of;

  FUNCTION entity_asof (p_cc_string IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN entity_of(p_cc_string, get_asof);
  END entity_asof;

  PROCEDURE validate_map (p_map_id         IN NUMBER,
                          p_type           IN VARCHAR2,
                          p_segment_value  IN VARCHAR2,
                          p_class_value_id IN NUMBER,
                          p_start          IN DATE,
                          p_end            IN DATE,
                          p_segment_key    IN VARCHAR2 DEFAULT NULL) IS
    n       NUMBER;
    l_tkey  VARCHAR2(30);
    l_key   VARCHAR2(30);
    l_pos   NUMBER;
    l_w     NUMBER;
    l_val   VARCHAR2(60);
    l_other VARCHAR2(400);
  BEGIN
    IF p_segment_value IS NULL OR p_start IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Segment value and start date are required.');
    END IF;
    IF p_end IS NOT NULL AND p_end < p_start THEN
      RAISE_APPLICATION_ERROR(-20001, 'End date cannot be before start date.');
    END IF;

    -- which segment does this rule read? (only ENTITY may pick one)
    BEGIN
      SELECT segment_key INTO l_tkey FROM prod.dct_gl_class_type WHERE class_type_code = p_type;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Unknown classification "' || p_type || '".');
    END;
    l_key := UPPER(NVL(p_segment_key, l_tkey));
    IF p_type <> 'ENTITY' AND l_key <> l_tkey THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Only Entity rules may read another GL segment; ' || p_type || ' rules read ' || l_tkey || '.');
    END IF;
    BEGIN
      SELECT position, width INTO l_pos, l_w FROM prod.dct_gl_segment WHERE segment_key = l_key;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Unknown GL segment "' || l_key || '".');
    END;
    l_val := norm(p_segment_value, l_w);

    -- value must belong to the dimension
    SELECT COUNT(*) INTO n FROM prod.dct_gl_class_value
     WHERE class_value_id = p_class_value_id AND class_type_code = p_type;
    IF n = 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Selected value does not belong to classification "' || p_type || '".');
    END IF;

    -- no overlapping effective period for the same (dimension, segment, segment value)
    SELECT COUNT(*) INTO n
    FROM   prod.dct_gl_seg_class_map m
    JOIN   prod.dct_gl_class_type t ON t.class_type_code = m.class_type_code
    WHERE  m.class_type_code = p_type
    AND    NVL(m.segment_key, t.segment_key) = l_key
    AND    m.segment_value   = l_val
    AND    (p_map_id IS NULL OR m.map_id <> p_map_id)
    AND    m.start_date <= NVL(p_end, c_hi)
    AND    NVL(m.end_date, c_hi) >= p_start;
    IF n > 0 THEN
      RAISE_APPLICATION_ERROR(-20090,
        'This period overlaps an existing assignment for ' || p_type ||
        ' / ' || l_key || ' ' || l_val || '. Close or adjust the existing one first.');
    END IF;

    -- ENTITY: a GL combination may match ONE rule only. Any combination in the
    -- chart that this rule matches must not also match another active Entity
    -- rule (on any segment) in an overlapping period.
    IF p_type = 'ENTITY' THEN
      SELECT COUNT(DISTINCT s.cc_id),
             MIN(NVL(m.segment_key, t.segment_key) || ' ' || m.segment_value || ' = ' || v.value_code || ' (rule #' || m.map_id || ')')
        INTO n, l_other
        FROM prod.dct_gl_coa_snap s
        JOIN prod.dct_gl_seg_class_map m ON m.class_type_code = 'ENTITY'
                                        AND (p_map_id IS NULL OR m.map_id <> p_map_id)
                                        AND m.start_date <= NVL(p_end, c_hi)
                                        AND NVL(m.end_date, c_hi) >= p_start
        JOIN prod.dct_gl_class_type  t ON t.class_type_code = m.class_type_code
        JOIN prod.dct_gl_segment     g ON g.segment_key = NVL(m.segment_key, t.segment_key)
        JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
       WHERE norm(REGEXP_SUBSTR(s.cc_string, '[^.]+', 1, l_pos), l_w) = l_val
         AND m.segment_value = norm(REGEXP_SUBSTR(s.cc_string, '[^.]+', 1, g.position), g.width);
      IF n > 0 THEN
        RAISE_APPLICATION_ERROR(-20090,
          'A GL combination may match only ONE Entity rule: this rule overlaps ' || l_other ||
          ' on ' || n || ' combination(s). End or narrow that rule first.');
      END IF;
    END IF;
  END validate_map;

END dct_gl_class_pkg;
/

PROMPT DCT_GL_CLASS_PKG + GL_CTX context compiled.
