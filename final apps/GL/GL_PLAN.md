# General Ledger (App 210) — Module Plan

Date-tracked GL Chart-of-Accounts **classification** layer over the Fusion-loaded `ATD_GL_*`
tables, plus a Portal-style management UI. Approved approach: see the root plan
`~/.claude/plans/for-gl-data-model-witty-spark.md`.

## Identity

| Field | Value |
|---|---|
| App number | **210** |
| `module_code` | `GL` |
| App name | **General Ledger** |
| Brand colour | `#3F6F5F` (deep teal-green; configurable via `THEME_BRAND_COLOR`) |
| ORDS base | `/ords/admin/gl/` |
| Packages | `gl.rest` (thin ORDS) · `DCT_GL_CLASS_PKG` (logic) |
| Frontend | Portal-style single-file KO SPA (mirrors `final apps/FL/Portal/`) |

## Source data — verified on PROD (2026-06-28)

`ATD_GL_ACCOUNTS_COMBINATIONS` — 9,338 rows. Segments (all NUMBER) + `CC_ID` + `LOAD_TS`.
Ten `ATD_GL_*_LIST` description tables. `ATD_GL_BALANCES` — currently 1 empty/test row.

**Exact list-table columns** (code / description):

| Segment (combination col) | List table | Code col | Desc col | Pad width |
|---|---|---|---|---|
| `ENTITY_CODE` | `ATD_GL_ENTITY_CODES_LIST` | `VALUE` | `DESCRIPTION` | 3 |
| `COST_CENTER` | `ATD_GL_COST_CENTERS_LIST` | `COST_CENTER` | `COST_CENTER_DESCRIPTION` | **7** |
| `GL_ACCOUNT` | `ATD_GL_ACCOUNT_LIST` | `ACCOUNT_CODE` | `ACCOUNT_DESCRIPTION` | 6 |
| `APPROPRIATION` | `ATD_GL_APPROPRIATION_LIST` | `APPROPRIATION_CODE` | `APPROPRIATION_DESCRIPTION` | **6** |
| `BUDGET_GROUP` | `ATD_GL_BUDGET_GROUP_LIST` | `BUDGET_GROUP` | `BUDGET_GROUP_DESCRIPTION` | 1 |
| `ENTITY_SPECIFIC` | `ATD_GL_COST_ENTITY_SPECIFIC_LI` | `ENTITY_SPECIFIC` | `ENTITY_SPECIFIC_DESCRIPTIO` | 7 |
| `FUTURE_1` | `ATD_GL_FUTURE1_LIST` | `FUTURE_1` | `FUTURE_1_DESCRIPTION` | 1 |
| `FUTURE_2` | `ATD_GL_FUTURE2_LIST` | `FUTURE_2` | `FUTURE_2_DESCRIPTION` | 1 |
| `INTERCOMPANY` | `ATD_GL_INTERCOMPANY_LIST` | `INTERCOMPANY` | `INTERCOMPANY_DESCRIPTION` | 1 |
| `PROGRAM_CODE` | `ATD_GL_PROGRAM_LIST` | `PROGRAM_CODE` | `PROGRAM_DESCRIPTION` | **6** |

## Three classifications (confirmed)

- **Sector** ← `COST_CENTER` (e.g. 4510210 = "DCT - Finance Dept"). Source: *Cost Centers List 2026.csv*.
- **Chapter** ← `APPROPRIATION` (codes 100103/200104/438/502175 all in the appropriation list). Source: *Future 2 & Chapter Mapping.csv*.
- **DCT Program** ← `PROGRAM_CODE`. Source: *Updated PBB.csv* (P0701xx, 2-level hierarchy).

### Program reconciliation — corrected at build
Simple zero-padding does **not** bridge the program segment to PBB: program `10100` = "Support Services" = PBB `P070100` (codes differ, **descriptions match exactly**). The program list has 4,505 distinct values but combinations use only **35**. So:
- DCT Program **master** = PBB P-codes (hierarchical) from the CSV.
- **Mapping** = match `ATD_GL_PROGRAM_LIST.program_description` ↔ PBB name (trim/upper), seeded best-effort for the program codes actually used; unmatched codes reported for manual mapping on the page.
- `segment_value` stored = `LPAD(program_code, 6, '0')` (e.g. `70401` -> `070401`, `10100` -> `010100`).

## Objects (all PROD schema)

- **Bridge synonyms** `GL_SRC_*` → `ATD_GL_*` (prefix avoids collision with the future `GL_*` rename; repoint on rename). `01_gl_synonyms.sql`.
- **Tables** `DCT_GL_CLASS_TYPE` → `DCT_GL_CLASS_VALUE` → `DCT_GL_SEG_CLASS_MAP`. `02_gl_ddl.sql`.
- **Context** `GL_CTX` + **`DCT_GL_CLASS_PKG`** (`norm`, `resolve_value_id`, `validate_map`, `set_asof`/`clear_asof`). `03_gl_pkg.sql`.
- **Views** `DCT_GL_COA_V` (+ `GL_COA_V` synonym) and `DCT_GL_BALANCES_V`. `04_gl_views.sql`.
- **ORDS** module `gl` + ADMIN→PROD synonyms. `05_gl_ords.sql`.
- **Seed** classes + values + date-tracked mappings from the 3 CSVs. `06_gl_seed.sql`.

## Test strategy
PL/SQL asserts (overlap rejection, as-of resolution, hierarchy, norm padding); API pytest; Playwright E2E; UAT workbook (Admin layout). Cover Happy / Edge / Error(400/401/403/404/500) / Boundary — overlap rejection, open-ended ranges, as-of boundaries, unmapped segments.

## Deploy order
`01`(own fresh session, ORA-01471) → `02` → `03` → `04` → `05`(own fresh session) → `06`.
SET DEFINE OFF · SET SQLBLANKLINES ON · CRLF · UTF-8 (seed run with `-Dfile.encoding=UTF-8`).
