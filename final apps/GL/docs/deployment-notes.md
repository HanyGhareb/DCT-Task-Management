# General Ledger (App 210) — Deployment Notes

Canonical platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md §2`.
This file holds GL-specific deploy steps, history, and gotchas. **Update on every deploy.**

## Deploy checklist
1. **DB scripts** via SQLcl `sql -name prod_mcp` (CRLF, UTF-8 no BOM, `SET DEFINE OFF`, `SET SQLBLANKLINES ON`):
   - `01_gl_synonyms.sql` — **own fresh session** (ORA-01471 rule).
   - `02_gl_ddl.sql` → `03_gl_pkg.sql` → `04_gl_views.sql`.
   - `06_gl_seed.sql` — run with `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` (Arabic class-type names);
     regenerate from CSVs first with `python db/gen_seed.py` if `db/source/*.csv` changed.
   - `05_gl_ords.sql` — **own fresh session**.
2. **Frontend** — bump `window.APP_VERSION` in `Jet/index.html`. A change under `final apps/shared/`
   requires bumping `APP_VERSION` in ALL apps (cache-bust).
3. **Smoke** — `python Jet/dev-proxy.py` (DEV_PROXY_PORT=8090), quick-login via Admin, load
   `/GL/Jet/index.html`; check Overview counts, Classifications CRUD, a Mapping with start/end
   (overlap → toast), Explorer as-of + CSV.

## History
- **2026-07-02 — Actuals: 3-figure Commitment/Obligation + Open Encumbrance + Funds calc (v1.5.0, Batch B).**
  Real requisitions now drive Commitment; PO obligation split into three funds-status buckets with a
  GRN-netted Open Obligation. Grouped-cell display.
  - DB: `db/v2/36` `DCT_PR_COMMITMENT_PERIOD_V` → 3 figures (`pr_total_ytd`=Reserved+Liquidated,
    `pr_open_commitment_ytd`=Reserved, `pr_pipeline_ytd`=Not-reserved, `pr_count`). `db/v2/34`
    rewritten: PO de-duped by `po_distribution_id` → `total_po_ytd` (all except Failed/Passed),
    `open_obligation_ytd` = (Reserved+Partially Liquidated) **netted by GRN** `GREATEST(amt−Σgrn,0)`
    (grn via `grn_all_v2.po_distribution_id`), `po_pipeline_ytd` (Failed/Passed); LEFT JOIN the PR
    view; `open_encumbrance_ytd` = open commitment + open obligation; `funds_available_calc_ytd` =
    Budget − Open PO − Open PR − GRN − AP Direct (GL `funds_available_ytd` kept as the 2nd figure).
  - ORDS (`05_gl_ords.sql`, whole module, fresh session — **no new synonyms**, all `prod.`-qualified):
    `/actuals` emits prTotal/openCommitment/commitmentPipeline/totalPo/openObligation/poPipeline/
    openEncumbrance/fundsAvailable/fundsAvailableCalc; `/actuals/lines` — commitment/openCommitment/
    **commitmentPipeline** → real PR lines (`pr_distributions`+`pr_headers`, AED via `DCT_CURRENCY_CODES`),
    obligation/**poPipeline** → PO lines, openObligation → GRN-netted (Ordered/Received/Open columns).
  - Frontend v1.5.0: **grouped cells** — Commitment & Obligation each show Total/Open/Pipeline stacked
    (count on the Total row), Funds Available cell shows GL/Calc; +Open Encumbrance column; 14 KPI cards.
  - Verified: view VALID + figures reconcile (PR 1.89B/412.7M/4.71B, PO 1.52B/474.0M/2.1M, OpenEnc
    886.7M); drill queries ran live; `node --check`; Playwright mock-render (0 console errors).
    Deploy order: `db/v2/36` → `db/v2/34` → `05_gl_ords.sql` (fresh session).
  - **Currency caveat:** non-AED PR distributions are converted via the `DCT_CURRENCY_CODES` snapshot
    (manual ISO master, single RATE_DATE 19-May-2026) — the only rate source (PR tables carry none).
    Pending user check of whether PR line details include a rate.
- **2026-07-01 — PR reporting views created (Batch B step 1 — DB only, not yet integrated).**
  New `db/v2/36_dct_pr_views.sql`: base pass-throughs `prod.pr_headers`/`pr_lines`/`pr_distributions`
  (over the `ATD_PR_*` tables) + **`DCT_PR_COMMITMENT_PERIOD_V`** (per GL combination × period,
  YTD via `BUDGET_DATE<period-end`, AED via the `DCT_CURRENCY_CODES` snapshot rate — the PR tables
  carry NO transaction rate). Measures (06-2026): `pr_commitment_ytd` = `FUNDS_STATUS='Reserved'`
  (currently-reserved requisitions) = 412.7M; `pr_open_commitment_ytd` = Reserved & PR line has no
  PO (disjoint from Open PO) = 369.4M; `pr_count`/`open_pr_count` = distinct PR headers. Excludes
  `'Not reserved'` drafts (4.75B) AND `'Liquidated'` (already POs → shown under Obligation). All VALID.
  **NOT yet wired into `DCT_BUDGET_ACTUAL_PERIOD_V` / ORDS / frontend** — next step: #3 repoint the
  commitment source, #4 Encumbrance = Open PR + Open PO, #6b calculated Funds Available.
- **2026-07-01 — Actuals: AP Direct redefine + SLA Actual + PO/PR counts (v1.4.0).** (User comments
  batch A of 6; #3/#4/#6b pending the user's PR_HEADER/PR_LINES/PR_DISTRIBUTIONS tables.)
  - **#1 AP Direct** now = AP distribution lines with **`po_number IS NULL`** (true direct AP, no PO
    reference), replacing the old "unmatched-to-`po_distributions`" logic (dropped the `ap_po_match`
    CTE in `db/v2/34` `ap_ytd` + the inline match subquery in the `apdirect` drill). Live impact:
    06-2026 YTD AP Direct 1.322B → **1.292B** (the delta = AP lines that carry a po_number but don't
    match a PO distribution — now excluded).
  - **#2 SLA Actual** ("Subledger Actuals") = GRN Actual + AP Direct (≈ 2.27B). Emitted by `/actuals`
    (`slaActual` in totals + items); new KPI card + non-drillable table column + ⓘ hint.
  - **#5 PO/PR counts:** `DCT_BUDGET_ACTUAL_PERIOD_V` gained `po_count` (distinct po_header_id) +
    `pr_count` (distinct pr_number) per combination; `/actuals` items emit `poCount`/`prCount`; the
    Obligation/Commitment cells show the amount with a count sub-line ("N POs" / "N PRs"). PR count is
    interim from `po_distributions` until the dedicated PR_* tables arrive (#3).
  - Deploy order: `db/v2/34` → `05_gl_ords.sql` (fresh session, no new synonyms). Verified: view VALID,
    AP Direct drill query ran live (no ORA errors), `node --check`, Playwright mock-render (0 errors).
- **2026-06-30 — Actuals report: Open Commitment / Open Obligation + visible hint (v1.3.0).**
  - DB: added `open_commitment_ytd` + `open_obligation_ytd` to `DCT_BUDGET_ACTUAL_PERIOD_V`
    (`db/v2/34`) — the **unliquidated** subset of obligation/commitment = PO distribution lines
    whose budget is still encumbered (`FUNDS_STATUS IN ('Reserved','Partially Liquidated')`),
    de-duped per natural key (the amount/`SCHEDULE_UNBILLED_AMOUNT` columns are unreliable in
    this Fusion load, so "open" is driven by FUNDS_STATUS, not ordered−billed). Verified VALID;
    06-2026 open = 723.08M (both), ⊆ commitment 1.504B ⊆ obligation 1.510B.
  - ORDS (`05_gl_ords.sql`, whole module, fresh session — no new synonyms): `/actuals` emits
    `openCommitment`/`openObligation` in `totals` + `items` and accepts them as `source` filter
    values; `/actuals/lines` gains `openCommitment` (→ open PR lines) and `openObligation`
    (→ open PO lines) drill metrics (same columns as commitment/obligation, FUNDS_STATUS-filtered).
  - Frontend (v1.3.0): 2 new KPI cards (Open Commitment / Open Obligation) + 2 new drillable
    table columns; the four PO-derived headers (Commitment/Obligation/Open Commitment/Open
    Obligation) now show a **visible ⓘ hint marker** (`.hint-i`) carrying the explanatory tooltip
    (kept the existing "Commitment (PR)" / "Obligation (PO)" wording); 2 new source-filter options;
    CSV includes the open columns.
  - Verified: view VALID + open figures match probe; all new handler queries executed live against
    PROD (no ORA errors); `node --check`; Playwright mock-render of Actuals + Open-Obligation drill
    + Dashboard (0 console/binding errors). Deploy order: `db/v2/34` → `05_gl_ords.sql` (fresh session).
- **2026-06-30 — Actuals report: Commitment/Obligation + extra filters + full width (v1.2.0).**
  - DB: added `commitment_ytd` (PR-backed PO distribution lines) + `obligation_ytd` (all PO
    distribution lines) to `DCT_BUDGET_ACTUAL_PERIOD_V` (`db/v2/34`), read live from
    `po_distributions` (de-duped per natural key; `gl_balances.OBLIGATIONS` is 0 in this Fusion
    config so POs come from `po_distributions`; commitment = the PR-backed subset of obligation).
  - ORDS (`05_gl_ords.sql`, re-run whole module, fresh session — no new synonyms):
    `/actuals/filters` now also returns `accounts` + `costCenters` LOVs; `/actuals` gains
    `account`/`costcenter`/`source` filters and emits `commitment`/`obligation` in totals + items;
    `/actuals/lines` gains `commitment` (→ PR lines) and `obligation` (→ PO lines) drill metrics.
  - Frontend (v1.2.0): Actuals + Dashboard pages now use the full viewport width (`.wrap.wide`);
    3 new search criteria (Account, Cost center, Transaction source); 2 new KPI cards + 2 new
    drillable table columns (Commitment / Obligation) with header hints; CSV includes them.
  - Verified: view VALID + commitment⊆obligation (1.504B ⊆ 1.510B, 06-2026); all new handler
    queries executed live against PROD (no ORA errors); `node --check` + KO comment balance.
    Deploy order: `db/v2/34` → `05_gl_ords.sql` (fresh session).
- **2026-06-30 — Actuals reporting + Executive dashboard (v1.1.0).** New **Actuals** (Budget vs
  Actual) and **Dashboard** pages over the actuals reporting layer (`db/v2/32–35`):
  - DB: added `appropriation_code`/`_desc` to `DCT_BUDGET_ACTUAL_PERIOD_V` (`db/v2/34`); new hourly
    job `DCT_ACTUALS_REFRESH_JOB` for `prod.dct_actuals_refresh` (`db/v2/35`).
  - ORDS (`05_gl_ords.sql`, re-run whole module, fresh session): `/actuals/filters`, `/actuals`,
    `/actuals/lines`, `/dashboard`, `POST /actuals/refresh` + 9 new ADMIN→PROD synonyms
    (period view, snapshot, refresh proc, base AP/PO/GRN/GL views).
  - Frontend: Actuals report (mandatory period + Sector/Chapter/DCT-Program/Appropriation filters,
    business-question answer cards, full-width table with header hints + combination tooltip + row
    hover, per-figure drill-down modal, Search/Reset, CSV); Executive dashboard (utilisation gauge,
    period-over-period trend, by sector/program/appropriation bars, auto-insights — all hand-built
    SVG/CSS, no chart lib); **Refresh actuals** button on Overview/Actuals/Dashboard.
  - Verified: live SQL probes + handler JSON harness against PROD; Playwright mock-render of both
    pages + drill (0 console/binding errors). Deploy order: `db/v2/33` (snapshot, if not present) →
    `db/v2/32` → `db/v2/34` → `db/v2/35` → `05_gl_ords.sql`.
- **2026-06-28 — Initial release (v1.0.0).** All layers deployed + verified end-to-end (Playwright).
  COA view 9,338 rows (no fan-out), 91% sector-classified. Registered in switcher + i18n.

## Gotchas (GL-specific)
- **`GL_SRC_*` synonyms** are the only thing that knows the base table is `ATD_GL_*`. On the
  planned rename to `GL_*`, re-run `01_gl_synonyms.sql` with the new targets — nothing else changes.
- **Description-list fan-out:** the Fusion list tables contain duplicate codes (e.g. program `0` =
  "Unspecified"/"Un specified", used by 5,605 combinations). `DCT_GL_COA_V` de-duplicates every
  description join with `GROUP BY` — never join the raw list tables 1:1 or the grain explodes.
- **Segment widths (zero-pad):** entity 3, cost-center 7, account 6, appropriation 6, **program 6**.
  Segments are stored `NUMBER` (lossy) so the view/map normalize via `DCT_GL_CLASS_PKG.norm`.
- **Program ↔ PBB:** codes differ (`10100` vs PBB `070100`); mappings are matched by *description*,
  not arithmetic. 33 of 35 used program codes matched.
- **Parallel DML:** the seed sets `ALTER SESSION DISABLE PARALLEL DML` (consecutive MERGEs on a
  parallel-enabled table → ORA-12839).
- **As-of:** `DCT_GL_CLASS_PKG.set_asof(date)` then SELECT the view; the `/combinations?asof=` and
  `/balances?asof=` handlers set/clear the `GL_CTX` context per request.
