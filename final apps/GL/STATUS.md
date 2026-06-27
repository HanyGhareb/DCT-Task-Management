# General Ledger (App 210) — STATUS

Date-tracked Chart-of-Accounts classification layer (Sector / Chapter / DCT Program)
over the Fusion-loaded `ATD_GL_*` tables + a Portal-style management UI.

| Layer | State |
|---|---|
| DB tables (`DCT_GL_CLASS_TYPE/_VALUE/_SEG_CLASS_MAP`) | ✅ Deployed PROD (2026-06-28) — all VALID; +`alt_name1/2/3` |
| Bridge synonyms (`GL_SRC_*`) | ✅ Deployed — insulate the planned `ATD_GL_* → GL_*` rename |
| Package `DCT_GL_CLASS_PKG` + context `GL_CTX` | ✅ Deployed — norm / set_asof / resolve_value_id / validate_map |
| Views `DCT_GL_COA_V` (+`GL_COA_V`) / `DCT_GL_BALANCES_V` | ✅ Deployed — COA view = 9,338 rows (no fan-out), 8,485 (91%) have a Sector |
| Seed | ✅ 21 Sectors / 7 Chapters / 41 PBB Programs; 109 sector + 74 chapter + 33 program mappings |
| ORDS `gl.rest` (`/ords/admin/gl/`) | ✅ Deployed — 8 route groups; auth + overlap-guard + as-of verified |
| Frontend (Portal-style KO SPA, `Jet/`) | ✅ Live — Overview / Classifications / Mapping / Explorer; EN-AR-RTL; E2E passed |
| Registration | ✅ shell switcher + common i18n + proxies (auto-derived) + CLAUDE.md Module Status |
| APEX pages | ⬜ N/A (JET only) |

## Deployment log
- **2026-06-28** — Initial build, all layers deployed to PROD and verified end-to-end.
  Brand `#3F6F5F`. `APP_VERSION` 1.0.0. Source CSVs preserved in `db/source/`.

## Known follow-ups
- **DCT Program mappings cover 33 of 35** used program codes (matched to PBB by description);
  the 2 unmatched can be mapped manually on the Mapping page.
- **`DCT_GL_BALANCES_V`** enriches Sector only (the `ATD_GL_BALANCES` feed is currently empty;
  Chapter/Program enrichment to be added once it carries parseable segments).
- **Sector seed** uses the latest cost-center column with a `2024-01-01` baseline start; historical
  closed ranges (2018–2023) can be added on the Mapping page when needed.
