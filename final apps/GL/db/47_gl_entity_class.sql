-- =============================================================================
-- General Ledger (App 210) -- ENTITY as a data-driven classification -- GL/db/47
-- Run     : sql -name prod_mcp @47_gl_entity_class.sql  (ADMIN, fresh session)
-- Order   : 47 (this: tables/columns/seed)  ->  03 (package)  ->  04 (view + snapshot
--           columns)  ->  refresh the COA snapshot  ->  48 (ORDS)  ->  42/43 re-run,
--           37/45 + reporting/db/40 handler/section patches.
-- Why     : Entity (DCT / MSS / ALC / Masterpieces) was a hard-coded CASE in four
--           GL routes (appropriation 301439 -> Masterpieces, entity-specific
--           4510700 -> MSS, 4510600 -> ALC, else DCT). User 2026-09-04: make it a
--           4th date-tracked classification maintained in Chart of Accounts ->
--           Classification values, with rules on ANY of the 10 GL segments.
-- Model   : DCT_GL_SEGMENT = the 10 canonical segments (position + width);
--           DCT_GL_SEG_CLASS_MAP.SEGMENT_KEY = the segment a rule reads (NULL = the
--           dimension's own segment; only ENTITY rules may name another one);
--           DCT_GL_CLASS_VALUE.IS_DEFAULT = the value used when no rule matches
--           (one per dimension; seeded on DCT because Masterpieces lives INSIDE
--           DCT's entity-specific value 4510000, so an explicit "4510000 = DCT" rule
--           would overlap the Masterpieces rule -- and a combination may match ONE
--           Entity rule only). Un-flag the default to see gaps as Unclassified.
-- Seed    : type ENTITY + 4 values + the 3 rules above (from 2000-01-01, so any
--           as-of date resolves like the old CASE). Rerunnable, count-then-insert
--           (no MERGE: Linux SQLcl silently drops MERGE-bearing blocks).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_tables WHERE owner='PROD' AND table_name='DCT_GL_SEGMENT';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_gl_segment (
        segment_key  VARCHAR2(30)  NOT NULL,
        position     NUMBER(2)     NOT NULL,
        width        NUMBER(2)     NOT NULL,
        name_en      VARCHAR2(100) NOT NULL,
        name_ar      VARCHAR2(100),
        coa_column   VARCHAR2(40)  NOT NULL,
        CONSTRAINT pk_dct_gl_segment PRIMARY KEY (segment_key),
        CONSTRAINT ux_dct_gl_segment_pos UNIQUE (position)
      )]';
  END IF;
END;
/

DECLARE
  TYPE t_seg IS RECORD (k VARCHAR2(30), pos NUMBER, w NUMBER, en VARCHAR2(100), ar VARCHAR2(100), col VARCHAR2(40));
  TYPE t_segs IS TABLE OF t_seg;
  l_segs t_segs := t_segs();
  l_n NUMBER;
  PROCEDURE add(k VARCHAR2, pos NUMBER, w NUMBER, en VARCHAR2, ar VARCHAR2, col VARCHAR2) IS
  BEGIN l_segs.EXTEND; l_segs(l_segs.LAST).k := k; l_segs(l_segs.LAST).pos := pos; l_segs(l_segs.LAST).w := w;
        l_segs(l_segs.LAST).en := en; l_segs(l_segs.LAST).ar := ar; l_segs(l_segs.LAST).col := col; END;
BEGIN
  add('ENTITY',          1, 3, 'Entity',          'الكيان',           'ENTITY_CODE');
  add('PROGRAM_CODE',    2, 6, 'Program',         'البرنامج',         'PROGRAM_CODE');
  add('COST_CENTER',     3, 7, 'Cost Centre',     'مركز التكلفة',     'COST_CENTER_CODE');
  add('BUDGET_GROUP',    4, 1, 'Budget Group',    'مجموعة الموازنة',  'BUDGET_GROUP_CODE');
  add('ACCOUNT',         5, 6, 'Account',         'الحساب',           'ACCOUNT_CODE');
  add('ENTITY_SPECIFIC', 6, 7, 'Entity Specific', 'خاص بالكيان',      'ENTITY_SPECIFIC_CODE');
  add('APPROPRIATION',   7, 6, 'Appropriation',   'الاعتماد',         'APPROPRIATION_CODE');
  add('INTERCOMPANY',    8, 3, 'Intercompany',    'ما بين الشركات',   'INTERCOMPANY_CODE');
  add('FUTURE1',         9, 6, 'Future 1',        'مستقبلي 1',        'FUTURE1_CODE');
  add('FUTURE2',        10, 6, 'Future 2',        'مستقبلي 2',        'FUTURE2_CODE');
  FOR i IN 1 .. l_segs.COUNT LOOP
    SELECT COUNT(*) INTO l_n FROM prod.dct_gl_segment WHERE segment_key = l_segs(i).k;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_gl_segment (segment_key, position, width, name_en, name_ar, coa_column)
      VALUES (l_segs(i).k, l_segs(i).pos, l_segs(i).w, l_segs(i).en, l_segs(i).ar, l_segs(i).col);
    ELSE
      UPDATE prod.dct_gl_segment SET position = l_segs(i).pos, width = l_segs(i).w, name_en = l_segs(i).en,
             name_ar = l_segs(i).ar, coa_column = l_segs(i).col WHERE segment_key = l_segs(i).k;
    END IF;
  END LOOP;
  COMMIT;
END;
/

DECLARE l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_tab_columns WHERE owner='PROD' AND table_name='DCT_GL_SEG_CLASS_MAP' AND column_name='SEGMENT_KEY';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_gl_seg_class_map ADD (segment_key VARCHAR2(30))';
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_gl_seg_class_map ADD CONSTRAINT fk_dct_gl_map_segment FOREIGN KEY (segment_key) REFERENCES prod.dct_gl_segment(segment_key)';
  END IF;
  SELECT COUNT(*) INTO l_n FROM all_tab_columns WHERE owner='PROD' AND table_name='DCT_GL_CLASS_VALUE' AND column_name='IS_DEFAULT';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_gl_class_value ADD (is_default VARCHAR2(1) DEFAULT 'N' NOT NULL)]';
    EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_gl_class_value ADD CONSTRAINT chk_dct_gl_cv_default CHECK (is_default IN ('Y','N'))]';
  END IF;
  SELECT COUNT(*) INTO l_n FROM all_indexes WHERE owner='PROD' AND index_name='UX_DCT_GL_CV_DEFAULT';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE UNIQUE INDEX prod.ux_dct_gl_cv_default ON prod.dct_gl_class_value (CASE WHEN is_default = 'Y' THEN class_type_code END)]';
  END IF;
END;
/

PROMPT == ENTITY dimension, values and the three seeded rules ==
DECLARE
  l_n NUMBER;
  l_dct NUMBER; l_mss NUMBER; l_alc NUMBER; l_mp NUMBER;
  PROCEDURE val(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_alt VARCHAR2, p_ord NUMBER, p_def VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_gl_class_value WHERE class_type_code='ENTITY' AND value_code=p_code;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_gl_class_value (class_type_code, value_code, name_en, name_ar, alt_name1, display_order, is_active, is_default, created_by)
      VALUES ('ENTITY', p_code, p_en, p_ar, p_alt, p_ord, 'Y', p_def, 'GL/db/47');
    END IF;
    SELECT class_value_id INTO p_id FROM prod.dct_gl_class_value WHERE class_type_code='ENTITY' AND value_code=p_code;
  END;
  PROCEDURE rule(p_key VARCHAR2, p_val VARCHAR2, p_cv NUMBER, p_note VARCHAR2) IS
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_gl_seg_class_map
     WHERE class_type_code='ENTITY' AND segment_key=p_key AND segment_value=p_val AND class_value_id=p_cv;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_gl_seg_class_map (class_type_code, segment_key, segment_value, class_value_id, start_date, end_date, notes, created_by)
      VALUES ('ENTITY', p_key, p_val, p_cv, DATE '2000-01-01', NULL, p_note, 'GL/db/47');
    END IF;
  END;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.dct_gl_class_type WHERE class_type_code='ENTITY';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_gl_class_type (class_type_code, name_en, name_ar, segment_key, seg_pad_width, is_hierarchical, display_order, is_active, created_by)
    VALUES ('ENTITY', 'Entity', 'الجهة', 'ENTITY_SPECIFIC', 7, 'N', 40, 'Y', 'GL/db/47');
  END IF;
  val('DCT',          'DCT',          'دائرة الثقافة والسياحة',       'Department of Culture and Tourism', 10, 'Y', l_dct);
  val('MUSEUMS',      'MSS',          'الخدمات المشتركة للمتاحف',     'Museums',                          20, 'N', l_mss);
  val('ALC',          'ALC',          'مركز أبوظبي للغة العربية',     'Abu Dhabi Arabic Language Centre', 30, 'N', l_alc);
  val('MASTERPIECES', 'Masterpieces', 'المقتنيات الفنية',             'Art collectibles fund (FA1439)',   40, 'N', l_mp);
  rule('ENTITY_SPECIFIC', '4510700', l_mss, 'Seeded from the former hard-coded rule (GL/db/42+37): entity-specific 4510700 = MSS');
  rule('ENTITY_SPECIFIC', '4510600', l_alc, 'Seeded from the former hard-coded rule: entity-specific 4510600 = ALC');
  rule('APPROPRIATION',   '301439',  l_mp,  'Seeded from the former hard-coded rule: appropriation 301439 (FA1439 art collectibles) = Masterpieces');
  COMMIT;
  DBMS_OUTPUT.put_line('ENTITY seeded: values DCT=' || l_dct || ' MSS=' || l_mss || ' ALC=' || l_alc || ' MASTERPIECES=' || l_mp);
END;
/

PROMPT == GL/db/47 done ==
SELECT segment_key, position, width FROM prod.dct_gl_segment ORDER BY position;
SELECT m.map_id, m.segment_key, m.segment_value, v.value_code, v.is_default
  FROM prod.dct_gl_seg_class_map m JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
 WHERE m.class_type_code = 'ENTITY' ORDER BY m.map_id;
