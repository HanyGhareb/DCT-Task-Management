/**
 * irExpr.js — safe expression engine for Interactive Report calculated columns.
 *
 * Compiles a small Oracle-flavoured formula language into an AST evaluated per
 * row. NO eval / new Function — safe by construction (no property access, no
 * globals; identifiers resolve ONLY against known column keys).
 *
 * Grammar:
 *   expr   := term (('+' | '-' | '||') term)*
 *   term   := factor (('*' | '/' | '%') factor)*
 *   factor := NUMBER | 'STRING' | COLUMN | FUNC '(' expr [, expr]* ')'
 *           | '(' expr ')' | '-' factor
 * Functions: ROUND(x[,n]) ABS(x) NVL(x,y) UPPER(s) LOWER(s)
 * Strings use single quotes with '' as the escape. Column names match
 * case-insensitively. Arithmetic on null / non-numeric yields null; '||'
 * treats null as ''.
 *
 * compile(src, columns) -> { eval(row) -> value, type: 'num'|'text' }
 * columns: [{key, type, label?}] — throws Error(message) on any syntax/name
 * problem. When a label is supplied, its identifier form (spaces → '_') is
 * accepted as an alias for the key, so users can type what the header shows
 * ("Budget Ytd" → BUDGET_YTD, and renamed headers too). Unknown-column errors
 * include a closest-match suggestion.
 */
define([], function () {
  'use strict';

  var FUNCS = {
    ROUND: { min: 1, max: 2, type: 'num' },
    ABS:   { min: 1, max: 1, type: 'num' },
    NVL:   { min: 2, max: 2, type: 'arg1' },
    UPPER: { min: 1, max: 1, type: 'text' },
    LOWER: { min: 1, max: 1, type: 'text' }
  };
  /* autocomplete metadata for the calc dialog */
  var FUNC_LIST = [
    { name: 'ROUND', sig: 'ROUND(x, n)' },
    { name: 'ABS',   sig: 'ABS(x)' },
    { name: 'NVL',   sig: 'NVL(x, y)' },
    { name: 'UPPER', sig: 'UPPER(s)' },
    { name: 'LOWER', sig: 'LOWER(s)' }
  ];

  function labelAlias(label) {
    if (!label) return null;
    var a = String(label).trim().replace(/\s+/g, '_');
    return /^[A-Za-z_][A-Za-z0-9_]*$/.test(a) ? a.toLowerCase() : null;
  }

  function levenshtein(a, b) {
    var m = a.length, n = b.length, i, j, prev, tmp;
    if (Math.abs(m - n) > 3) return 99;
    var row = [];
    for (j = 0; j <= n; j++) row[j] = j;
    for (i = 1; i <= m; i++) {
      prev = row[0];
      row[0] = i;
      for (j = 1; j <= n; j++) {
        tmp = row[j];
        row[j] = Math.min(row[j] + 1, row[j - 1] + 1,
                          prev + (a.charAt(i - 1) === b.charAt(j - 1) ? 0 : 1));
        prev = tmp;
      }
    }
    return row[n];
  }

  function closest(word, columns) {
    var w = word.toLowerCase(), best = null, bestScore = 99;
    (columns || []).forEach(function (c) {
      var k = String(c.key).toLowerCase();
      var score;
      if (k.indexOf(w) === 0 || w.indexOf(k) === 0) score = 1;
      else if (k.indexOf(w) !== -1 || w.indexOf(k) !== -1) score = 2;
      else score = levenshtein(w, k);
      if (score < bestScore) { bestScore = score; best = c.key; }
    });
    return bestScore <= 3 ? best : null;
  }

  function tokenize(src) {
    var toks = [], i = 0, n = src.length, c, j, buf;
    while (i < n) {
      c = src.charAt(i);
      if (c === ' ' || c === '\t' || c === '\n' || c === '\r') { i++; continue; }
      if ((c >= '0' && c <= '9') ||
          (c === '.' && i + 1 < n && src.charAt(i + 1) >= '0' && src.charAt(i + 1) <= '9')) {
        j = i;
        while (j < n && /[0-9.]/.test(src.charAt(j))) j++;
        buf = src.slice(i, j);
        if ((buf.match(/\./g) || []).length > 1) throw new Error('bad number: ' + buf);
        toks.push({ t: 'num', v: parseFloat(buf) });
        i = j; continue;
      }
      if (c === "'") {
        buf = ''; j = i + 1;
        for (;;) {
          if (j >= n) throw new Error('unterminated string');
          if (src.charAt(j) === "'" && src.charAt(j + 1) === "'") { buf += "'"; j += 2; continue; }
          if (src.charAt(j) === "'") { j++; break; }
          buf += src.charAt(j); j++;
        }
        toks.push({ t: 'str', v: buf });
        i = j; continue;
      }
      if (/[A-Za-z_]/.test(c)) {
        j = i;
        while (j < n && /[A-Za-z0-9_]/.test(src.charAt(j))) j++;
        toks.push({ t: 'ident', v: src.slice(i, j) });
        i = j; continue;
      }
      if (c === '|' && src.charAt(i + 1) === '|') { toks.push({ t: 'op', v: '||' }); i += 2; continue; }
      if ('+-*/%(),'.indexOf(c) !== -1) { toks.push({ t: 'op', v: c }); i++; continue; }
      throw new Error('unexpected character: ' + c);
    }
    return toks;
  }

  function toNum(v) {
    if (v === null || v === undefined || v === '') return null;
    var n = Number(v);
    return isNaN(n) ? null : n;
  }

  function compile(src, columns) {
    if (!src || !String(src).trim()) throw new Error('expression is empty');
    var colMap = {};
    (columns || []).forEach(function (c) { colMap[c.key.toLowerCase()] = c; });
    // header labels double as aliases (never shadowing a real key)
    (columns || []).forEach(function (c) {
      var a = labelAlias(c.label);
      if (a && !colMap[a]) colMap[a] = c;
    });

    var toks = tokenize(String(src));
    var pos = 0;

    function peek() { return toks[pos] || null; }
    function next() { return toks[pos++] || null; }
    function isOp(tok, v) { return tok && tok.t === 'op' && tok.v === v; }

    function parseExpr() {
      var node = parseTerm(), tok;
      for (;;) {
        tok = peek();
        if (isOp(tok, '+') || isOp(tok, '-') || isOp(tok, '||')) {
          next();
          node = { k: 'bin', op: tok.v, a: node, b: parseTerm() };
        } else { return node; }
      }
    }
    function parseTerm() {
      var node = parseFactor(), tok;
      for (;;) {
        tok = peek();
        if (isOp(tok, '*') || isOp(tok, '/') || isOp(tok, '%')) {
          next();
          node = { k: 'bin', op: tok.v, a: node, b: parseFactor() };
        } else { return node; }
      }
    }
    function parseFactor() {
      var tok = next();
      if (!tok) throw new Error('unexpected end of expression');
      if (tok.t === 'num') return { k: 'num', v: tok.v };
      if (tok.t === 'str') return { k: 'str', v: tok.v };
      if (isOp(tok, '-')) return { k: 'un', a: parseFactor() };
      if (isOp(tok, '(')) {
        var inner = parseExpr();
        if (!isOp(next(), ')')) throw new Error('missing )');
        return inner;
      }
      if (tok.t === 'ident') {
        var up = tok.v.toUpperCase();
        if (FUNCS[up] && isOp(peek(), '(')) {
          next();
          var args = [];
          if (!isOp(peek(), ')')) {
            args.push(parseExpr());
            while (isOp(peek(), ',')) { next(); args.push(parseExpr()); }
          }
          if (!isOp(next(), ')')) throw new Error('missing ) after ' + up);
          if (args.length < FUNCS[up].min || args.length > FUNCS[up].max) {
            throw new Error(up + ' takes ' + FUNCS[up].min +
                            (FUNCS[up].max > FUNCS[up].min ? '-' + FUNCS[up].max : '') + ' argument(s)');
          }
          return { k: 'fn', fn: up, args: args };
        }
        var col = colMap[tok.v.toLowerCase()];
        if (!col) {
          var hint = closest(tok.v, columns);
          throw new Error('unknown column: ' + tok.v +
                          (hint ? ' — did you mean ' + hint + '?' : ''));
        }
        return { k: 'col', key: col.key, ctype: col.type };
      }
      throw new Error('unexpected token: ' + (tok.v !== undefined ? tok.v : tok.t));
    }

    var ast = parseExpr();
    if (pos < toks.length) throw new Error('unexpected trailing input');

    function typeOf(node) {
      switch (node.k) {
        case 'num': return 'num';
        case 'str': return 'text';
        case 'un':  return 'num';
        case 'col': return (node.ctype === 'money' || node.ctype === 'num') ? 'num' : 'text';
        case 'bin': return node.op === '||' ? 'text' : 'num';
        case 'fn':
          if (FUNCS[node.fn].type === 'arg1') return typeOf(node.args[0]);
          return FUNCS[node.fn].type;
        default: return 'text';
      }
    }

    function ev(node, row) {
      switch (node.k) {
        case 'num': return node.v;
        case 'str': return node.v;
        case 'col': return row[node.key];
        case 'un': {
          var u = toNum(ev(node.a, row));
          return u === null ? null : -u;
        }
        case 'bin': {
          if (node.op === '||') {
            var l = ev(node.a, row), r = ev(node.b, row);
            return (l === null || l === undefined ? '' : String(l)) +
                   (r === null || r === undefined ? '' : String(r));
          }
          var x = toNum(ev(node.a, row)), y = toNum(ev(node.b, row)), out;
          if (x === null || y === null) return null;
          if (node.op === '+') out = x + y;
          else if (node.op === '-') out = x - y;
          else if (node.op === '*') out = x * y;
          else if (node.op === '/') out = (y === 0 ? null : x / y);
          else out = (y === 0 ? null : x % y);
          return (out === null || !isFinite(out)) ? null : out;
        }
        case 'fn': {
          var a0 = ev(node.args[0], row), a1, f;
          switch (node.fn) {
            case 'ROUND':
              a0 = toNum(a0);
              if (a0 === null) return null;
              a1 = node.args[1] ? toNum(ev(node.args[1], row)) : 0;
              f = Math.pow(10, a1 || 0);
              return Math.round(a0 * f) / f;
            case 'ABS':
              a0 = toNum(a0);
              return a0 === null ? null : Math.abs(a0);
            case 'NVL':
              return (a0 === null || a0 === undefined || a0 === '')
                ? ev(node.args[1], row) : a0;
            case 'UPPER':
              return (a0 === null || a0 === undefined) ? null : String(a0).toUpperCase();
            case 'LOWER':
              return (a0 === null || a0 === undefined) ? null : String(a0).toLowerCase();
          }
          return null;
        }
        default: return null;
      }
    }

    return {
      type: typeOf(ast),
      eval: function (row) {
        try { return ev(ast, row); } catch (e) { return null; }
      }
    };
  }

  return { compile: compile, functions: FUNC_LIST };
});
