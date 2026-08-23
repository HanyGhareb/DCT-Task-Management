# Projects Budget Utilization Comments (GL v1.82.0) — approved plan

Approved 2026-08-23, deployed same day. Mirrors the Costing Adjustments pattern
(db/v2/124 + GL/db/25 + GL/db/21) end to end.

## Context
Finance (Finance Business Partner) justifies risks / challenges / requirements on the
Budget Utilization report with threaded, attachable comments at eight levels — Sector /
Cost Center / Project / Task / budget line (project × task × etype) / PO / PR /
AP Invoice — per budget year + accounting period (MM-YYYY). Other roles reply. Rows with
comments show `(**)` + a Comments (💬) column. Role permissions and period-close each get
their own admin page. A CLOSED period freezes every comment in it (no add / edit / reply /
attach) until reopened.

**User decisions (2026-08-23):**
- entry = split by context — grid column for lines, 💬 icon on the AP/PR/PO drill rows,
  register tab for Sector/CC + the full review list;
- close = fully frozen, reopen allowed;
- seed the 7 named roles now (PLATFORM-WIDE, common `dct_roles`, module_id NULL);
- `(**)` marker = line-level comments only;
- capabilities live on the COMMON role/permission tables — NO private mapping table.

## 1. DB — `db/v2/125_gl_butil_comments.sql`
- `DCT_GL_BUTIL_COMMENT`: identity PK, `BUC-#####` ref (seq, formatted in handler),
  entity_level (8 values), budget_year + accounting_period NOT NULL (regex CHECK), named
  keys project/task/etype (level-dependent CHECKs) + `entity_key` for
  SECTOR/CC/PO/PR/AP_INVOICE (+`entity_name` display snapshot), `parent_comment_id`
  self-FK (single-level threading — parent must be root, handler-enforced),
  `comment_text` VARCHAR2(4000 CHAR), status ACTIVE/DELETED (soft delete), audit quad.
- `DCT_GL_BUTIL_PERIOD`: (budget_year, accounting_period) UNIQUE, status OPEN/CLOSED,
  closed_by/at + reopened_by/at + remarks; **no row = OPEN**.
- View `DCT_GL_BUTIL_CMT_V`: ACTIVE BUTIL_LINE counts per (year, project, task, etype, period).
- **Capabilities = 4 privileges in the common `dct_permissions`** (GL_ADD_BUTIL_COMMENT /
  GL_REPLY_BUTIL_COMMENT / GL_CLOSE_BUTIL_PERIOD / GL_MANAGE_CMT_ROLES); grants in the
  common `dct_role_permissions`; runtime check `prod.dct_sec.has_priv` (SYS_ADMIN always
  TRUE; the flat closure is built FROM dct_role_permissions — db/v2/100:294);
  `dct_sec.refresh_flat` after every mutation.
- Seeds: lookups GL_CMT_LEVEL / GL_CMT_STATUS / GL_BUTIL_PERIOD_STATUS; 7 platform-wide
  roles FIN_BP / FBP_UNIT_HEAD / PBP_UNIT_HEAD / FBP_SECTION_HEAD / PROJECT_PLANNER /
  SECTOR_PLANNER / DEPT_PLANNER (+ existing FIN_DIRECTOR); default grants FIN_BP →
  ADD+REPLY, the rest + FIN_DIRECTOR → REPLY, FIN_DIRECTOR → CLOSE_PERIOD; doc type
  GL_CMT_ATTACH + DOC_SOURCE_TYPE value BUTIL_COMMENT + **MAX_UPLOAD_MB module setting
  for GL** (was missing). ADMIN synonyms in a fresh-session final section.

## 2. ORDS — `GL/db/26_butil_comments_ords.sql` (additive on gl.rest, NO DELETE_MODULE)
13 handlers: `butilcmt` GET (thread mode incl. the row's TASK/PROJECT sections +
closedPeriods[], or paged register mode) / POST (root needs ADD, reply needs REPLY,
parent must be root) · `butilcmt/:id` PUT/DELETE (author-or-SYS_ADMIN; roots with active
replies refuse delete) · `butilcmt/meta/caps` · `butilcmt/:id/docs` GET/PUT (raw-binary
`v_blob := :body` FIRST statement, MAX_UPLOAD_MB→413, shared dct_documents
GL/BUTIL_COMMENT/comment_id, created_by = NUMBER user_id) · `butilcmt/docs/:docid`
media GET / DELETE · `butilcmt/admin/roles` GET/POST (common dct_role_permissions +
refresh_flat; gate GL_MANAGE_CMT_ROLES/SYS_ADMIN) · `butilcmt/admin/periods` GET/POST
(CLOSE|REOPEN; gate GL_CLOSE_BUTIL_PERIOD). **Every write checks the period status first
— CLOSED → 403.** Reads gate = GL_VIEW_BUDGET_UTILIZATION (NULL legacy).

## 3. Butil flag — `GL/db/21` re-run (sole owner of GET /gl/butil)
INLINE aggregate join over the view in BOTH the totals SELECT and the rows cursor
(`(l_period IS NULL OR accounting_period = l_period)` — a bare view join would fan out
on a full-year run). Per-row `hasCmt`/`cmtCount`, totals `cmtCount`, top-level echo
`commentsEnabled='Y'`. **GL post-05 re-run list = 07..26.**

## 4. Frontend — GL Jet v1.82.0
`(**)` star beside `(*)` + Comments column (chat button + count badge), both gated on the
`commentsEnabled` echo; comments drawer `.dw-cmt` (LAST drawer in the DOM — z-71 stacking
is DOM order, it must open above the drill drawer): sectioned threads, reply box,
edit/delete own, per-comment attachments, closed-period banner/locks; 💬 icons on the
AP/PR/PO drill rows (synthetic `_cmt` column via `cmtDecorateDrill`); new tab **Projects ›
Comments** (register on the shared IR + Sector/CC entry bar); two Settings pages —
**Comment Roles** (capability checkboxes) + **Reporting Periods** (12 rows, Close/Reopen +
remarks), tabs hidden unless the caps allow (NAV `hidden` now accepts a function).

## 5. Deploy order (all executed 2026-08-23)
1. db/v2/125 (SQLcl prod_mcp; no MERGE — Linux-SQLcl-safe; verify seed counts)
2. GL/db/26 (fresh session; verify handler LENGTHs)
3. GL/db/21 re-run (self-check prints CMT WIRED)
4. GL Jet overlay release to the webtier (copy-of-live + GL/Jet)

## 6. Tests
- `tests/butilcmt_api_smoke.py` — **68/68** (caps, threading, butil reflection
  period-aware, register, edit/delete rules, attachments incl. media download, role
  grants round-trip, close → all writes 403 → reopen, negatives).
- `tests/butilcmt_browser_smoke.py` — **31/31 EN+AR/RTL** (column/star/note/badge, drawer
  add/reply, drill 💬 stacking, register + Sector entry, admin pages).

## Feedback round (v1.83.0, same day)
User asks after hands-on testing: labelled amber period chip · author profile photos
(authId/hasPhoto → authed `/dct/users/:id/photo` blob, initials fallback) · roots newest
first · collapsed drawer Search region (Posted by + Accounting Period) filtering a
YEAR-WIDE thread, period filter defaulting to the dashboard parameter · NEW "Display
Comments" LOV (None/Selected period/All → `/butil?cmtdisp=` per-row `commentsText`,
Comments column in results + CSV) · Excel register sheet-1 comments column + sheet 7
"Comments - Other Levels" behind `cmtmode` (reporting/db/25 + GL/db/11). Also FIXED the
pre-existing Portfolio-page period select that silently reverted every dashboard period
pick (shared-observable KO write-back — see deployment-notes 2026-08-23 (2)).
Tests now API 75/75 + browser 41/41.

## Gotchas found while building
- **`NVL(x,'')` is still NULL in Oracle → APEX_JSON drops the key**: the periods page's
  bare-name bindings (closedBy/remarks/…) silently aborted the KO foreach after row 1 —
  and the error was swallowed by the VM's own `.catch` (toast), so no pageerror surfaced.
  Fix = normalise the rows in the VM (the PAY pattern). Rule: NVL-to-empty-string in a
  handler does NOT guarantee the JSON key exists.
- The comments drawer must be the LAST `.dw-drawer` in the DOM or it opens under the
  drill drawer.
