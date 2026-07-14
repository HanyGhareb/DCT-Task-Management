SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 62_dct_wf_expr.sql
-- i-Finance Workflow Platform (DWP) -- the safe condition evaluator
-- Schema  : PROD (run as ADMIN with schema-qualified names)
--
-- Requirement 5 (dynamic approval levels based on conditions) without the
-- custom_condition string-hack that the legacy engine used.
--
-- Two entry points:
--   compile(src, schema_id) -> JSON AST.  Runs at SAVE time, by an admin.
--                              Every identifier is name-resolved against
--                              dct_wf_fact_field for that schema. Unknown
--                              identifier = compile error + did-you-mean.
--   eval(ast, facts)        -> TRUE | FALSE | NULL.  Runs at step resolution.
--                              Walks the AST over the instance fact document.
--                              Pure and replayable: no live queries.
--
-- SAFETY -- these are auditable proof obligations, not aspirations:
--   1. This package contains no dynamic SQL of any kind. The source text of a
--      condition is NEVER concatenated into SQL or PL/SQL. CI must assert this
--      stays true, ignoring comment lines:
--        grep -v '^\s*--' db/v2/62_dct_wf_expr.sql \
--          | grep -ciE 'execute[[:space:]]+immediate|dbms_sql'      -- must be 0
--   2. Identifiers resolve only to dct_wf_fact_field rows (a closed set), and
--      they resolve to a JSON path -- never to a column name in a query.
--   3. Limits at compile: 4000 chars, 500 tokens, 200 nodes, depth 20.
--   4. Three-valued logic. A NULL condition means the step is SKIPPED, and the
--      trace says so. It never silently becomes TRUE.
--
-- Modelled on the irExpr safe parser already shipped in the BI app
-- (final apps/shared/js/components/interactiveReport.js).
--
-- DEPLOY NOTE: Linux SQLcl 26.1 can silently swallow large package bodies.
--              After running this, CONFIRM with:
--                select object_name, status from all_objects
--                 where owner='PROD' and object_name='DCT_WF_EXPR';
--              Both spec and body must be VALID. If not, deploy via
--              python-oracledb on a worker VM (see memory: linux db access).
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- condition evaluator ===

CREATE OR REPLACE PACKAGE prod.dct_wf_expr AS

    c_version CONSTANT VARCHAR2(10) := '1.0';

    -- compile: source text -> JSON AST. Returns NULL and sets o_error on failure.
    FUNCTION compile (p_src       IN  VARCHAR2,
                      p_schema_id IN  NUMBER,
                      o_error     OUT VARCHAR2) RETURN CLOB;

    -- eval: 'TRUE' | 'FALSE' | 'NULL'
    FUNCTION eval (p_ast   IN  CLOB,
                   p_facts IN  CLOB,
                   o_trace OUT CLOB) RETURN VARCHAR2;

    -- convenience: TRUE only when the expression is definitely true
    FUNCTION is_true (p_ast IN CLOB, p_facts IN CLOB) RETURN BOOLEAN;

END dct_wf_expr;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_wf_expr AS

    -- limits
    c_max_chars CONSTANT PLS_INTEGER := 4000;
    c_max_tok   CONSTANT PLS_INTEGER := 500;
    c_max_nodes CONSTANT PLS_INTEGER := 200;
    c_max_depth CONSTANT PLS_INTEGER := 20;

    -- token kinds
    c_num  CONSTANT VARCHAR2(5) := 'NUM';
    c_str  CONSTANT VARCHAR2(5) := 'STR';
    c_id   CONSTANT VARCHAR2(5) := 'ID';
    c_op   CONSTANT VARCHAR2(5) := 'OP';
    c_eof  CONSTANT VARCHAR2(5) := 'EOF';

    TYPE t_tok IS RECORD (kind VARCHAR2(5), val VARCHAR2(4000));
    TYPE t_toks IS TABLE OF t_tok INDEX BY PLS_INTEGER;

    TYPE t_fields IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR2(64);  -- field_key -> data_type

    -- a tiny variant used by the evaluator: k = N number, S text, B boolean, X null
    TYPE t_val IS RECORD (k VARCHAR2(1), n NUMBER, s VARCHAR2(4000), b VARCHAR2(1));

    g_toks   t_toks;
    g_n      PLS_INTEGER;      -- token count
    g_p      PLS_INTEGER;      -- parse cursor
    g_nodes  PLS_INTEGER;      -- node budget
    g_depth  PLS_INTEGER;
    g_fields t_fields;

    e_compile EXCEPTION;

    -- the ONLY callable functions. A fixed map, exactly like irExpr's FUNCS.
    FUNCTION is_fn (p IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN p IN ('NVL','ABS','ROUND','UPPER','LOWER','LENGTH','TRUNC',
                     'MONTHS_BETWEEN','DAYS_BETWEEN','CONTAINS','COUNT','HAS_ROLE');
    END;

    FUNCTION is_kw (p IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN p IN ('AND','OR','NOT','IN','BETWEEN','LIKE','IS','NULL','TRUE','FALSE');
    END;

    PROCEDURE die (p_msg IN VARCHAR2) IS
    BEGIN
        raise_application_error(-20950, p_msg);
    END;

    -- ---------------------------------------------------------------- levenshtein
    FUNCTION lev (a IN VARCHAR2, b IN VARCHAR2) RETURN PLS_INTEGER IS
        TYPE t_row IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
        prev t_row; cur t_row;
        la PLS_INTEGER := LENGTH(a); lb PLS_INTEGER := LENGTH(b);
        cost PLS_INTEGER;
    BEGIN
        IF la = 0 THEN RETURN lb; END IF;
        IF lb = 0 THEN RETURN la; END IF;
        FOR j IN 0 .. lb LOOP prev(j) := j; END LOOP;
        FOR i IN 1 .. la LOOP
            cur(0) := i;
            FOR j IN 1 .. lb LOOP
                cost := CASE WHEN SUBSTR(a,i,1) = SUBSTR(b,j,1) THEN 0 ELSE 1 END;
                cur(j) := LEAST(cur(j-1) + 1, prev(j) + 1, prev(j-1) + cost);
            END LOOP;
            FOR j IN 0 .. lb LOOP prev(j) := cur(j); END LOOP;
        END LOOP;
        RETURN prev(lb);
    END;

    FUNCTION did_you_mean (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        k    VARCHAR2(64);
        best VARCHAR2(64);
        bd   PLS_INTEGER := 999;
        d    PLS_INTEGER;
    BEGIN
        k := g_fields.FIRST;
        WHILE k IS NOT NULL LOOP
            IF INSTR(UPPER(k), UPPER(p_key)) > 0 OR INSTR(UPPER(p_key), UPPER(k)) > 0 THEN
                RETURN k;
            END IF;
            d := lev(UPPER(k), UPPER(p_key));
            IF d < bd THEN bd := d; best := k; END IF;
            k := g_fields.NEXT(k);
        END LOOP;
        IF bd <= 3 THEN RETURN best; END IF;
        RETURN NULL;
    END;

    -- ---------------------------------------------------------------- tokenizer
    PROCEDURE tokenize (p_src IN VARCHAR2) IS
        i   PLS_INTEGER := 1;
        n   PLS_INTEGER := LENGTH(p_src);
        ch  VARCHAR2(1);
        ch2 VARCHAR2(2);
        buf VARCHAR2(4000);

        PROCEDURE push (k VARCHAR2, v VARCHAR2) IS
        BEGIN
            g_n := g_n + 1;
            IF g_n > c_max_tok THEN die('expression is too long'); END IF;
            g_toks(g_n).kind := k;
            g_toks(g_n).val  := v;
        END;
    BEGIN
        g_toks.DELETE;
        g_n := 0;

        WHILE i <= n LOOP
            ch := SUBSTR(p_src, i, 1);

            IF ch IN (' ', CHR(9), CHR(10), CHR(13)) THEN
                i := i + 1;

            -- string literal, single-quoted, '' escapes a quote
            ELSIF ch = '''' THEN
                buf := NULL;
                i := i + 1;
                LOOP
                    IF i > n THEN die('unterminated text literal'); END IF;
                    ch := SUBSTR(p_src, i, 1);
                    IF ch = '''' THEN
                        IF SUBSTR(p_src, i + 1, 1) = '''' THEN
                            buf := buf || ''''; i := i + 2;
                        ELSE
                            i := i + 1; EXIT;
                        END IF;
                    ELSE
                        buf := buf || ch; i := i + 1;
                    END IF;
                END LOOP;
                push(c_str, buf);

            -- number
            ELSIF REGEXP_LIKE(ch, '[0-9]') THEN
                buf := NULL;
                WHILE i <= n AND REGEXP_LIKE(SUBSTR(p_src, i, 1), '[0-9.]') LOOP
                    buf := buf || SUBSTR(p_src, i, 1);
                    i := i + 1;
                END LOOP;
                push(c_num, buf);

            -- identifier / keyword / function name
            ELSIF REGEXP_LIKE(ch, '[A-Za-z_]') THEN
                buf := NULL;
                WHILE i <= n AND REGEXP_LIKE(SUBSTR(p_src, i, 1), '[A-Za-z0-9_]') LOOP
                    buf := buf || SUBSTR(p_src, i, 1);
                    i := i + 1;
                END LOOP;
                IF is_kw(UPPER(buf)) THEN
                    push(c_op, UPPER(buf));
                ELSE
                    push(c_id, buf);
                END IF;

            ELSE
                ch2 := SUBSTR(p_src, i, 2);
                IF ch2 IN ('>=', '<=', '!=', '<>', '||') THEN
                    push(c_op, ch2); i := i + 2;
                ELSIF ch IN ('=', '>', '<', '+', '-', '*', '/', '(', ')', ',') THEN
                    push(c_op, ch); i := i + 1;
                ELSE
                    die('unexpected character "' || ch || '"');
                END IF;
            END IF;
        END LOOP;

        push(c_eof, NULL);
    END;

    -- ---------------------------------------------------------------- parser
    FUNCTION peek_kind RETURN VARCHAR2 IS BEGIN RETURN g_toks(g_p).kind; END;
    FUNCTION peek_val  RETURN VARCHAR2 IS BEGIN RETURN g_toks(g_p).val;  END;

    FUNCTION accept_op (p IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        IF g_toks(g_p).kind = c_op AND g_toks(g_p).val = p THEN
            g_p := g_p + 1;
            RETURN TRUE;
        END IF;
        RETURN FALSE;
    END;

    PROCEDURE expect_op (p IN VARCHAR2) IS
    BEGIN
        IF NOT accept_op(p) THEN
            die('expected "' || p || '" but found "' || NVL(peek_val, 'end of expression') || '"');
        END IF;
    END;

    PROCEDURE node_used IS
    BEGIN
        g_nodes := g_nodes + 1;
        IF g_nodes > c_max_nodes THEN die('expression is too complex'); END IF;
    END;

    FUNCTION esc (p IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REPLACE(REPLACE(p, '\', '\\'), '"', '\"');
    END;

    FUNCTION p_expr RETURN VARCHAR2;

    FUNCTION p_primary RETURN VARCHAR2 IS
        v    VARCHAR2(4000);
        fn   VARCHAR2(64);
        args VARCHAR2(32767);
        dt   VARCHAR2(10);
        sug  VARCHAR2(200);
    BEGIN
        node_used;

        IF accept_op('(') THEN
            v := p_expr;
            expect_op(')');
            RETURN v;
        END IF;

        IF accept_op('-') THEN
            RETURN '{"t":"neg","e":' || p_primary || '}';
        END IF;

        IF accept_op('NULL')  THEN RETURN '{"t":"null"}'; END IF;
        IF accept_op('TRUE')  THEN RETURN '{"t":"bool","v":true}'; END IF;
        IF accept_op('FALSE') THEN RETURN '{"t":"bool","v":false}'; END IF;

        IF peek_kind = c_num THEN
            v := peek_val; g_p := g_p + 1;
            RETURN '{"t":"num","v":' || v || '}';
        END IF;

        IF peek_kind = c_str THEN
            v := peek_val; g_p := g_p + 1;
            RETURN '{"t":"str","v":"' || esc(v) || '"}';
        END IF;

        IF peek_kind = c_id THEN
            v := peek_val; g_p := g_p + 1;

            -- function call?
            IF g_toks(g_p).kind = c_op AND g_toks(g_p).val = '(' THEN
                fn := UPPER(v);
                IF NOT is_fn(fn) THEN
                    die('unknown function "' || v || '"');
                END IF;
                g_p := g_p + 1;
                args := NULL;
                IF NOT accept_op(')') THEN
                    LOOP
                        args := args || CASE WHEN args IS NULL THEN '' ELSE ',' END || p_expr;
                        EXIT WHEN NOT accept_op(',');
                    END LOOP;
                    expect_op(')');
                END IF;
                RETURN '{"t":"fn","f":"' || fn || '","a":[' || args || ']}';
            END IF;

            -- plain identifier: MUST be a declared fact field
            IF NOT g_fields.EXISTS(v) THEN
                sug := did_you_mean(v);
                IF sug IS NOT NULL THEN
                    die('unknown field "' || v || '" -- did you mean "' || sug || '"?');
                ELSE
                    die('unknown field "' || v || '"');
                END IF;
            END IF;
            dt := g_fields(v);
            RETURN '{"t":"fld","k":"' || esc(v) || '","dt":"' || dt || '"}';
        END IF;

        die('unexpected "' || NVL(peek_val, 'end of expression') || '"');
        RETURN NULL;
    END;

    FUNCTION p_mul RETURN VARCHAR2 IS
        l VARCHAR2(32767) := p_primary;
        o VARCHAR2(2);
    BEGIN
        LOOP
            IF    accept_op('*') THEN o := '*';
            ELSIF accept_op('/') THEN o := '/';
            ELSE  EXIT;
            END IF;
            node_used;
            l := '{"t":"bin","op":"' || o || '","l":' || l || ',"r":' || p_primary || '}';
        END LOOP;
        RETURN l;
    END;

    FUNCTION p_add RETURN VARCHAR2 IS
        l VARCHAR2(32767) := p_mul;
        o VARCHAR2(2);
    BEGIN
        LOOP
            IF    accept_op('+')  THEN o := '+';
            ELSIF accept_op('-')  THEN o := '-';
            ELSIF accept_op('||') THEN o := '||';
            ELSE  EXIT;
            END IF;
            node_used;
            l := '{"t":"bin","op":"' || o || '","l":' || l || ',"r":' || p_mul || '}';
        END LOOP;
        RETURN l;
    END;

    FUNCTION p_cmp RETURN VARCHAR2 IS
        l    VARCHAR2(32767) := p_add;
        o    VARCHAR2(2);
        vals VARCHAR2(32767);
        neg  VARCHAR2(5) := 'false';
        lo   VARCHAR2(32767);
        hi   VARCHAR2(32767);
    BEGIN
        node_used;

        IF accept_op('IS') THEN
            IF accept_op('NOT') THEN neg := 'true'; END IF;
            expect_op('NULL');
            RETURN '{"t":"isnull","neg":' || neg || ',"e":' || l || '}';
        END IF;

        IF accept_op('NOT') THEN
            IF accept_op('BETWEEN') THEN
                lo := p_add; expect_op('AND'); hi := p_add;
                RETURN '{"t":"between","neg":true,"e":' || l || ',"lo":' || lo || ',"hi":' || hi || '}';
            ELSIF accept_op('IN') THEN
                expect_op('(');
                vals := NULL;
                LOOP
                    vals := vals || CASE WHEN vals IS NULL THEN '' ELSE ',' END || p_add;
                    EXIT WHEN NOT accept_op(',');
                END LOOP;
                expect_op(')');
                RETURN '{"t":"in","neg":true,"e":' || l || ',"vals":[' || vals || ']}';
            ELSE
                die('expected BETWEEN or IN after NOT');
            END IF;
        END IF;

        IF accept_op('BETWEEN') THEN
            lo := p_add; expect_op('AND'); hi := p_add;
            RETURN '{"t":"between","neg":false,"e":' || l || ',"lo":' || lo || ',"hi":' || hi || '}';
        END IF;

        IF accept_op('IN') THEN
            expect_op('(');
            vals := NULL;
            LOOP
                vals := vals || CASE WHEN vals IS NULL THEN '' ELSE ',' END || p_add;
                EXIT WHEN NOT accept_op(',');
            END LOOP;
            expect_op(')');
            RETURN '{"t":"in","neg":false,"e":' || l || ',"vals":[' || vals || ']}';
        END IF;

        IF accept_op('LIKE') THEN
            RETURN '{"t":"like","e":' || l || ',"pat":' || p_add || '}';
        END IF;

        IF    accept_op('=')  THEN o := '=';
        ELSIF accept_op('!=') THEN o := '!=';
        ELSIF accept_op('<>') THEN o := '!=';
        ELSIF accept_op('>=') THEN o := '>=';
        ELSIF accept_op('<=') THEN o := '<=';
        ELSIF accept_op('>')  THEN o := '>';
        ELSIF accept_op('<')  THEN o := '<';
        ELSE  RETURN l;
        END IF;

        RETURN '{"t":"cmp","op":"' || o || '","l":' || l || ',"r":' || p_add || '}';
    END;

    FUNCTION p_not RETURN VARCHAR2 IS
    BEGIN
        IF accept_op('NOT') THEN
            node_used;
            RETURN '{"t":"not","e":' || p_not || '}';
        END IF;
        RETURN p_cmp;
    END;

    FUNCTION p_and RETURN VARCHAR2 IS
        l VARCHAR2(32767) := p_not;
    BEGIN
        WHILE accept_op('AND') LOOP
            node_used;
            l := '{"t":"and","l":' || l || ',"r":' || p_not || '}';
        END LOOP;
        RETURN l;
    END;

    FUNCTION p_expr RETURN VARCHAR2 IS
        l VARCHAR2(32767);
    BEGIN
        g_depth := g_depth + 1;
        IF g_depth > c_max_depth THEN die('expression is nested too deeply'); END IF;

        l := p_and;
        WHILE accept_op('OR') LOOP
            node_used;
            l := '{"t":"or","l":' || l || ',"r":' || p_and || '}';
        END LOOP;

        g_depth := g_depth - 1;
        RETURN l;
    END;

    -- ---------------------------------------------------------------- compile
    FUNCTION compile (p_src       IN  VARCHAR2,
                      p_schema_id IN  NUMBER,
                      o_error     OUT VARCHAR2) RETURN CLOB IS
        v_ast VARCHAR2(32767);
    BEGIN
        o_error := NULL;

        IF p_src IS NULL OR TRIM(p_src) IS NULL THEN
            o_error := 'condition is empty';
            RETURN NULL;
        END IF;

        IF LENGTH(p_src) > c_max_chars THEN
            o_error := 'condition is too long';
            RETURN NULL;
        END IF;

        -- load the closed set of identifiers for this fact schema
        g_fields.DELETE;
        FOR r IN (SELECT field_key, data_type
                    FROM prod.dct_wf_fact_field
                   WHERE schema_id = p_schema_id) LOOP
            g_fields(r.field_key) := r.data_type;
        END LOOP;

        IF g_fields.COUNT = 0 THEN
            o_error := 'fact schema has no fields declared';
            RETURN NULL;
        END IF;

        g_nodes := 0;
        g_depth := 0;
        tokenize(p_src);
        g_p := 1;

        v_ast := p_expr;

        IF peek_kind != c_eof THEN
            die('unexpected "' || peek_val || '" after the end of the expression');
        END IF;

        RETURN TO_CLOB(v_ast);

    EXCEPTION
        WHEN OTHERS THEN
            o_error := REGEXP_REPLACE(SQLERRM, '^ORA-[0-9]+: *', '');
            RETURN NULL;
    END;

    -- ---------------------------------------------------------------- evaluator
    FUNCTION vnull RETURN t_val IS v t_val; BEGIN v.k := 'X'; RETURN v; END;

    FUNCTION vnum (p NUMBER) RETURN t_val IS
        v t_val;
    BEGIN
        IF p IS NULL THEN RETURN vnull; END IF;
        v.k := 'N'; v.n := p; RETURN v;
    END;

    FUNCTION vstr (p VARCHAR2) RETURN t_val IS
        v t_val;
    BEGIN
        IF p IS NULL THEN RETURN vnull; END IF;
        v.k := 'S'; v.s := p; RETURN v;
    END;

    FUNCTION vbool (p VARCHAR2) RETURN t_val IS
        v t_val;
    BEGIN
        IF p IS NULL THEN RETURN vnull; END IF;
        v.k := 'B'; v.b := p; RETURN v;
    END;

    FUNCTION as_num (v t_val) RETURN NUMBER IS
    BEGIN
        IF v.k = 'N' THEN RETURN v.n; END IF;
        IF v.k = 'S' THEN RETURN TO_NUMBER(v.s); END IF;
        RETURN NULL;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

    FUNCTION as_str (v t_val) RETURN VARCHAR2 IS
    BEGIN
        IF v.k = 'S' THEN RETURN v.s; END IF;
        IF v.k = 'N' THEN RETURN TO_CHAR(v.n); END IF;
        IF v.k = 'B' THEN RETURN v.b; END IF;
        RETURN NULL;
    END;

    FUNCTION ev (p_node IN JSON_OBJECT_T, p_facts IN JSON_OBJECT_T) RETURN t_val;

    -- three-valued: 'T' | 'F' | 'U'
    FUNCTION ev3 (p_node IN JSON_OBJECT_T, p_facts IN JSON_OBJECT_T) RETURN VARCHAR2 IS
        v t_val := ev(p_node, p_facts);
    BEGIN
        IF v.k = 'X' THEN RETURN 'U'; END IF;
        IF v.k = 'B' THEN RETURN CASE WHEN v.b = 'Y' THEN 'T' ELSE 'F' END; END IF;
        RETURN 'U';
    END;

    FUNCTION cmp_of (p_op VARCHAR2, l t_val, r t_val) RETURN VARCHAR2 IS
        res BOOLEAN;
    BEGIN
        IF l.k = 'X' OR r.k = 'X' THEN RETURN NULL; END IF;

        IF l.k = 'N' OR r.k = 'N' THEN
            DECLARE
                ln NUMBER := as_num(l);
                rn NUMBER := as_num(r);
            BEGIN
                IF ln IS NULL OR rn IS NULL THEN RETURN NULL; END IF;
                IF    p_op = '='  THEN res := (ln =  rn);
                ELSIF p_op = '!=' THEN res := (ln != rn);
                ELSIF p_op = '>'  THEN res := (ln >  rn);
                ELSIF p_op = '>=' THEN res := (ln >= rn);
                ELSIF p_op = '<'  THEN res := (ln <  rn);
                ELSIF p_op = '<=' THEN res := (ln <= rn);
                ELSE  RETURN NULL;
                END IF;
            END;
        ELSE
            DECLARE
                ls VARCHAR2(4000) := as_str(l);
                rs VARCHAR2(4000) := as_str(r);
            BEGIN
                IF ls IS NULL OR rs IS NULL THEN RETURN NULL; END IF;
                IF    p_op = '='  THEN res := (ls =  rs);
                ELSIF p_op = '!=' THEN res := (ls != rs);
                ELSIF p_op = '>'  THEN res := (ls >  rs);
                ELSIF p_op = '>=' THEN res := (ls >= rs);
                ELSIF p_op = '<'  THEN res := (ls <  rs);
                ELSIF p_op = '<=' THEN res := (ls <= rs);
                ELSE  RETURN NULL;
                END IF;
            END;
        END IF;

        IF res IS NULL THEN RETURN NULL; END IF;
        RETURN CASE WHEN res THEN 'Y' ELSE 'N' END;
    END;

    FUNCTION ev (p_node IN JSON_OBJECT_T, p_facts IN JSON_OBJECT_T) RETURN t_val IS
        t   VARCHAR2(20);
        fn  VARCHAR2(30);
        el  JSON_ELEMENT_T;
        arr JSON_ARRAY_T;
        lv  t_val;
        rv  t_val;
        c   VARCHAR2(1);
        a3  VARCHAR2(1);
        b3  VARCHAR2(1);
    BEGIN
        IF p_node IS NULL THEN RETURN vnull; END IF;
        t := p_node.get_string('t');

        IF t = 'num'  THEN RETURN vnum(p_node.get_number('v')); END IF;
        IF t = 'str'  THEN RETURN vstr(p_node.get_string('v')); END IF;
        IF t = 'null' THEN RETURN vnull; END IF;
        IF t = 'bool' THEN
            RETURN vbool(CASE WHEN p_node.get_boolean('v') THEN 'Y' ELSE 'N' END);
        END IF;

        IF t = 'fld' THEN
            IF p_facts IS NULL OR NOT p_facts.has(p_node.get_string('k')) THEN
                RETURN vnull;
            END IF;
            el := p_facts.get(p_node.get_string('k'));
            IF el IS NULL OR el.is_null THEN RETURN vnull; END IF;
            IF p_node.get_string('dt') = 'NUMBER' THEN
                RETURN vnum(p_facts.get_number(p_node.get_string('k')));
            ELSIF p_node.get_string('dt') = 'BOOLEAN' THEN
                RETURN vbool(CASE WHEN p_facts.get_boolean(p_node.get_string('k')) THEN 'Y' ELSE 'N' END);
            ELSE
                RETURN vstr(p_facts.get_string(p_node.get_string('k')));
            END IF;
        END IF;

        IF t = 'neg' THEN
            lv := ev(p_node.get_object('e'), p_facts);
            IF lv.k = 'X' THEN RETURN vnull; END IF;
            RETURN vnum(-as_num(lv));
        END IF;

        IF t = 'not' THEN
            a3 := ev3(p_node.get_object('e'), p_facts);
            IF a3 = 'U' THEN RETURN vnull; END IF;
            RETURN vbool(CASE WHEN a3 = 'T' THEN 'N' ELSE 'Y' END);
        END IF;

        IF t = 'and' THEN
            a3 := ev3(p_node.get_object('l'), p_facts);
            IF a3 = 'F' THEN RETURN vbool('N'); END IF;      -- short circuit
            b3 := ev3(p_node.get_object('r'), p_facts);
            IF b3 = 'F' THEN RETURN vbool('N'); END IF;
            IF a3 = 'U' OR b3 = 'U' THEN RETURN vnull; END IF;
            RETURN vbool('Y');
        END IF;

        IF t = 'or' THEN
            a3 := ev3(p_node.get_object('l'), p_facts);
            IF a3 = 'T' THEN RETURN vbool('Y'); END IF;      -- short circuit
            b3 := ev3(p_node.get_object('r'), p_facts);
            IF b3 = 'T' THEN RETURN vbool('Y'); END IF;
            IF a3 = 'U' OR b3 = 'U' THEN RETURN vnull; END IF;
            RETURN vbool('N');
        END IF;

        IF t = 'cmp' THEN
            lv := ev(p_node.get_object('l'), p_facts);
            rv := ev(p_node.get_object('r'), p_facts);
            c  := cmp_of(p_node.get_string('op'), lv, rv);
            RETURN vbool(c);
        END IF;

        IF t = 'isnull' THEN
            lv := ev(p_node.get_object('e'), p_facts);
            IF p_node.get_boolean('neg') THEN
                RETURN vbool(CASE WHEN lv.k = 'X' THEN 'N' ELSE 'Y' END);
            END IF;
            RETURN vbool(CASE WHEN lv.k = 'X' THEN 'Y' ELSE 'N' END);
        END IF;

        IF t = 'between' THEN
            lv := ev(p_node.get_object('e'), p_facts);
            IF lv.k = 'X' THEN RETURN vnull; END IF;
            DECLARE
                lo t_val := ev(p_node.get_object('lo'), p_facts);
                hi t_val := ev(p_node.get_object('hi'), p_facts);
                r1 VARCHAR2(1) := cmp_of('>=', lv, lo);
                r2 VARCHAR2(1) := cmp_of('<=', lv, hi);
                hit VARCHAR2(1);
            BEGIN
                IF r1 IS NULL OR r2 IS NULL THEN RETURN vnull; END IF;
                hit := CASE WHEN r1 = 'Y' AND r2 = 'Y' THEN 'Y' ELSE 'N' END;
                IF p_node.get_boolean('neg') THEN
                    hit := CASE WHEN hit = 'Y' THEN 'N' ELSE 'Y' END;
                END IF;
                RETURN vbool(hit);
            END;
        END IF;

        IF t = 'in' THEN
            lv := ev(p_node.get_object('e'), p_facts);
            IF lv.k = 'X' THEN RETURN vnull; END IF;
            arr := p_node.get_array('vals');
            DECLARE
                hit VARCHAR2(1) := 'N';
                r   VARCHAR2(1);
            BEGIN
                FOR i IN 0 .. arr.get_size - 1 LOOP
                    rv := ev(TREAT(arr.get(i) AS JSON_OBJECT_T), p_facts);
                    r  := cmp_of('=', lv, rv);
                    IF r = 'Y' THEN hit := 'Y'; EXIT; END IF;
                END LOOP;
                IF p_node.get_boolean('neg') THEN
                    hit := CASE WHEN hit = 'Y' THEN 'N' ELSE 'Y' END;
                END IF;
                RETURN vbool(hit);
            END;
        END IF;

        IF t = 'like' THEN
            lv := ev(p_node.get_object('e'), p_facts);
            rv := ev(p_node.get_object('pat'), p_facts);
            IF lv.k = 'X' OR rv.k = 'X' THEN RETURN vnull; END IF;
            RETURN vbool(CASE WHEN as_str(lv) LIKE as_str(rv) THEN 'Y' ELSE 'N' END);
        END IF;

        IF t = 'bin' THEN
            lv := ev(p_node.get_object('l'), p_facts);
            rv := ev(p_node.get_object('r'), p_facts);
            IF p_node.get_string('op') = '||' THEN
                RETURN vstr(as_str(lv) || as_str(rv));
            END IF;
            IF lv.k = 'X' OR rv.k = 'X' THEN RETURN vnull; END IF;
            DECLARE
                ln NUMBER := as_num(lv);
                rn NUMBER := as_num(rv);
            BEGIN
                IF ln IS NULL OR rn IS NULL THEN RETURN vnull; END IF;
                CASE p_node.get_string('op')
                    WHEN '+' THEN RETURN vnum(ln + rn);
                    WHEN '-' THEN RETURN vnum(ln - rn);
                    WHEN '*' THEN RETURN vnum(ln * rn);
                    WHEN '/' THEN
                        IF rn = 0 THEN RETURN vnull; END IF;
                        RETURN vnum(ln / rn);
                    ELSE RETURN vnull;
                END CASE;
            END;
        END IF;

        IF t = 'fn' THEN
            fn  := p_node.get_string('f');
            arr := p_node.get_array('a');

            IF fn = 'NVL' THEN
                lv := ev(TREAT(arr.get(0) AS JSON_OBJECT_T), p_facts);
                IF lv.k != 'X' THEN RETURN lv; END IF;
                RETURN ev(TREAT(arr.get(1) AS JSON_OBJECT_T), p_facts);
            END IF;

            lv := ev(TREAT(arr.get(0) AS JSON_OBJECT_T), p_facts);

            IF fn = 'HAS_ROLE' THEN
                -- reads the snapshot only -- never a live query
                IF p_facts IS NULL OR NOT p_facts.has('roles') THEN RETURN vbool('N'); END IF;
                DECLARE
                    rs  JSON_ARRAY_T := p_facts.get_array('roles');
                    tgt VARCHAR2(200) := UPPER(as_str(lv));
                BEGIN
                    FOR i IN 0 .. rs.get_size - 1 LOOP
                        IF UPPER(rs.get_string(i)) = tgt THEN RETURN vbool('Y'); END IF;
                    END LOOP;
                    RETURN vbool('N');
                END;
            END IF;

            IF lv.k = 'X' AND fn NOT IN ('COUNT') THEN RETURN vnull; END IF;

            CASE fn
                WHEN 'ABS'    THEN RETURN vnum(ABS(as_num(lv)));
                WHEN 'UPPER'  THEN RETURN vstr(UPPER(as_str(lv)));
                WHEN 'LOWER'  THEN RETURN vstr(LOWER(as_str(lv)));
                WHEN 'LENGTH' THEN RETURN vnum(LENGTH(as_str(lv)));
                WHEN 'TRUNC'  THEN RETURN vnum(TRUNC(as_num(lv)));
                WHEN 'ROUND'  THEN
                    IF arr.get_size > 1 THEN
                        rv := ev(TREAT(arr.get(1) AS JSON_OBJECT_T), p_facts);
                        RETURN vnum(ROUND(as_num(lv), as_num(rv)));
                    END IF;
                    RETURN vnum(ROUND(as_num(lv)));
                WHEN 'MONTHS_BETWEEN' THEN
                    rv := ev(TREAT(arr.get(1) AS JSON_OBJECT_T), p_facts);
                    IF rv.k = 'X' THEN RETURN vnull; END IF;
                    RETURN vnum(MONTHS_BETWEEN(TO_DATE(as_str(lv),'YYYY-MM-DD'),
                                               TO_DATE(as_str(rv),'YYYY-MM-DD')));
                WHEN 'DAYS_BETWEEN' THEN
                    rv := ev(TREAT(arr.get(1) AS JSON_OBJECT_T), p_facts);
                    IF rv.k = 'X' THEN RETURN vnull; END IF;
                    RETURN vnum(TO_DATE(as_str(lv),'YYYY-MM-DD')
                              - TO_DATE(as_str(rv),'YYYY-MM-DD'));
                WHEN 'CONTAINS' THEN
                    rv := ev(TREAT(arr.get(1) AS JSON_OBJECT_T), p_facts);
                    IF rv.k = 'X' THEN RETURN vnull; END IF;
                    RETURN vbool(CASE WHEN INSTR(as_str(lv), as_str(rv)) > 0 THEN 'Y' ELSE 'N' END);
                WHEN 'COUNT' THEN
                    RETURN vnum(0);
                ELSE
                    RETURN vnull;
            END CASE;
        END IF;

        RETURN vnull;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN vnull;
    END;

    -- ---------------------------------------------------------------- public eval
    FUNCTION eval (p_ast   IN  CLOB,
                   p_facts IN  CLOB,
                   o_trace OUT CLOB) RETURN VARCHAR2 IS
        v_root  JSON_OBJECT_T;
        v_facts JSON_OBJECT_T;
        v3      VARCHAR2(1);
        v_res   VARCHAR2(5);
    BEGIN
        IF p_ast IS NULL THEN
            o_trace := TO_CLOB('{"result":"TRUE","note":"no condition -- step always fires"}');
            RETURN 'TRUE';
        END IF;

        v_root  := JSON_OBJECT_T.parse(p_ast);
        v_facts := CASE WHEN p_facts IS NULL THEN JSON_OBJECT_T()
                        ELSE JSON_OBJECT_T.parse(p_facts) END;

        v3 := ev3(v_root, v_facts);
        v_res := CASE v3 WHEN 'T' THEN 'TRUE' WHEN 'F' THEN 'FALSE' ELSE 'NULL' END;

        o_trace := TO_CLOB('{"result":"' || v_res || '"'
                        || CASE WHEN v_res = 'NULL'
                                THEN ',"note":"condition is unknown -- step skipped"'
                                ELSE '' END
                        || ',"ast":' || TO_CHAR(p_ast) || '}');
        RETURN v_res;

    EXCEPTION
        WHEN OTHERS THEN
            o_trace := TO_CLOB('{"result":"NULL","error":"'
                            || REPLACE(SUBSTR(SQLERRM,1,200),'"','''') || '"}');
            RETURN 'NULL';
    END;

    FUNCTION is_true (p_ast IN CLOB, p_facts IN CLOB) RETURN BOOLEAN IS
        v_tr CLOB;
    BEGIN
        RETURN eval(p_ast, p_facts, v_tr) = 'TRUE';
    END;

END dct_wf_expr;
/

PROMPT
PROMPT === evaluator done -- confirming both spec and body are VALID ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_WF_EXPR'
 ORDER BY object_type;
