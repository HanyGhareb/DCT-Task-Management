# General Ledger (App 210) — Functions List

User-facing functions by area. Each area = a `view()` section in `Jet/index.html`; each bullet is a
public method on the single KO viewModel in `Jet/js/app.js`. Mandatory maintenance artifact —
update on any view/method/endpoint change.

## Overview (`view()==='overview'`)
- coverage stats: `combinationCount`, `pctClassified`, per-dimension `valueCount` / `mappedSegments` (from `/boot`).

## Classifications (`view()==='classifications'`) — manage Sector/Chapter/Program master values
- `clsType` — dimension selector (drives `loadValues`).
- `loadValues()` — list values for the selected dimension.
- `addValue()` / `editValue(r)` / `saveValue()` — create/update (code, EN/AR name, **3 alt names**, tag, parent, order, active).
- `deleteValue(r)` — delete (blocked with a message if assignments reference it).

## Segment Mapping (`view()==='mapping'`) — date-tracked assignments
- `mapType` — dimension; `segSearch` + `segOptions` + `mapSegment` — real-data segment-value picker.
- `loadSegOptions()` / `loadMappings()` — picker + effective-history timeline (current + past).
- `addMapping()` / `editMapping(r)` / `saveMapping()` — create/update (value, start/end date, notes); overlap rejected server-side (toast).
- `deleteMapping(r)` — remove an assignment.

## Explorer (`view()==='explorer'`) — the unified COA view
- filters: `expSearch`, `fSector`, `fChapter`, `asOf` (date) → `loadCombos(offset)` (server-paginated).
- `comboRange` — “a–b / total”; `exportCsv()` — CSV of the current filtered set (≤500 rows).

## Shell
- `t()` / `toggleLang()` (EN/AR + RTL), `go(view)`, `signOut()` (→ Admin), `refreshFilters()`.

## API Endpoints (ORDS) — `db/05_gl_ords.sql`, base `/ords/admin/gl/`
| Method | Path | Purpose |
|---|---|---|
| GET | `/boot` | dimensions catalog + combination/classified counts |
| GET | `/class-types` | dimensions |
| GET/POST | `/class-values` | list (by `?type=`) / create classification value |
| PUT/DELETE | `/class-values/:id` | update / delete value |
| GET | `/segments/:key/values` | distinct segment values + description (picker; `?search=&limit=`) |
| GET/POST | `/mappings` | list (`?type=&segment=`) / create assignment (overlap-validated) |
| PUT/DELETE | `/mappings/:id` | update / delete assignment |
| GET | `/combinations` | unified COA view, paginated, `?search=&sector=&chapter=&program=&asof=` |
| GET | `/combinations/:ccId` | single combination |
| GET | `/balances` | budget balances enriched with Sector, `?asof=&sector=` |

## Data layer (PROD)
- Tables: `DCT_GL_CLASS_TYPE` → `DCT_GL_CLASS_VALUE` → `DCT_GL_SEG_CLASS_MAP`.
- Package: `DCT_GL_CLASS_PKG` (`norm`, `set_asof`/`clear_asof`/`get_asof`, `resolve_value_id`, `validate_map`); context `GL_CTX`.
- Views: `DCT_GL_COA_V` (+`GL_COA_V`), `DCT_GL_BALANCES_V`.
- Bridge synonyms: `GL_SRC_*` → `ATD_GL_*` (rename-insulation).
