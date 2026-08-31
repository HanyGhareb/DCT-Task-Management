# GL — Sector Financial Performance Report (Projects Budget Utilization, new layout)

**Status:** BUILDING — layers 1–3 (DB, ORDS, frontend) LIVE and verified 2026-08-19; layer 4 (Reporting-Platform pack) outstanding
**Author:** platform team · **Date:** 2026-08-19
**Source layout:** `docs/Reports/GL/Sector Report_October.pdf` (4-page Power BI pack, October-2025)
**Target:** new GL tab **Projects › Sector Performance** + a Reporting-Platform pack (PDF / XLSX / PPTX)

---

## 1. What the source pack contains

| # | Page | Content |
|---|---|---|
| 1 | **Business Overview** | 4×5 matrix — Revenue / Opex / Capex / Opex&Capex × (FY Budget, YTD Actual, YTD Plan, YTD Actual vs FY Budget %, Target [YTD Plan / FY Plan]). Revenue-to-Opex % (FY target vs YTD actual). Cumulative **Budget vs Actual** monthly bar chart. |
| 2 | **Budget Overview** | KPI band (Budget, Actual, Plan, Actual vs Budget %, Plan vs Budget %, Actual vs Plan %, Encumbrance, Funds Available + %). Opex & Capex **gauges** (Actual vs Budget) each with Budget/Actual/Plan chips. **Actual vs Plan YTD by Department** (sorted line/area vs a default-plan baseline) + Over/Under-Spend comment buttons. **YTD Actual vs Budget & Plan by Department** (Budget bar + Actual bar + Plan line). |
| 3 | **Budget Overview — Project Level** | Same KPI band + RAG legend, then the **sector table**, expandable (+) to project level: `Sector · Budget · Actual · YTD Actual vs Budget % (RAG dot) · Plan · Actual vs Plan in Amount · Encumbrance · Funds Available` with a Total row. Footnote: *filtered on CAPEX & OPEX only*. |
| 4 | **Revenue Overview** | Sovereign / Commercial / Total Actual-vs-Plan cards (+ achievement %), Revenue-to-Opex %, **MTD trend** bars, **Actual vs Plan by Type** (revenue category bar + plan line, `S-` sovereign / `C-` commercial prefixes). |

RAG bands on page 3: **0–33 % red · 33–67 % amber · 67–100 % green**.

---

## 2. Figure → platform source map

Everything on pages 1–3 except **Plan** already exists and reconciles today.

| Report figure | Platform source | Status |
|---|---|---|
| FY Budget | `DCT_BUDGET_UTILIZATION_V.BUDGET_ANNUAL` | ✅ |
| YTD Budget | `…BUDGET` (BUTIL_END period-aware) | ✅ |
| YTD Actual | `ACTUAL_AP + ACTUAL_GRN` | ✅ |
| Encumbrance | `COMMITMENT_PR + OBLIGATION_PO` | ✅ |
| Funds Available | `FUND_AVAILABLE` | ✅ |
| Opex / Capex split | `CHAPTER` → `DCT_GL_CLASS_VALUE.ALT_NAME1` (CH2=Opex, CH3=Capex, CH1=Payroll, CH4=Subsidy, CH5=Aids & Grants) | ✅ |
| Sector | `DCT_BUDGET_UTILIZATION_V.SECTOR` | ✅ |
| Department | `…DEPARTMENT` (GL cost-centre segment description) + `COST_CENTRE` | ✅ |
| Revenue **Actual** | `ATD_AR_INVOICE_DISTRIBUTION` where `ACCOUNTING_CLASS='Revenue'` (sign-flipped), sector via `DISTRIBUTION_COST_CENTER_C` → COA snap | ✅ (new view needed) |
| Revenue **FY Budget** | `GL_BALANCES_CC` ⋈ COA snap where `ACCOUNT_TYPE='Revenue'` | ✅ |
| **YTD Plan (Opex/Capex)** | — | ❌ **GAP 1** |
| **YTD Revenue Plan** | — | ❌ **GAP 2** |
| **Revenue category (S-/C- type)** | — | ❌ **GAP 3** |

**Live 2026 verification (this proposal was grounded on real PROD figures):**

```
butil 2026 : 1,739 lines · 17 sectors · 79 departments · 616 projects · 7,694.3M budget
by chapter : Opex 5,010.7M (act 1,665.3M, enc 1,379.3M) · Capex 2,222.7M (act 1,016.5M, enc 280.3M)
             Subsidy 310.1M · Aids & Grants 27.9M · Payroll 13.1M · unclassified 109.8M
revenue    : FY budget 656.0M (4 combinations, all in period 01-2026)
             AR actual 2026 = 753.3M — Support Service 460.8 · Tourism 152.5 · Culture 42.7
                                       ALC 7.6 · Executive Office 5.5 · unmapped 84.6
```

The pack's own arithmetic matches our definitions exactly — PDF page 3:
`4,989.6M budget − 3,009.0M actual − 1,344.4M encumbrance = 636.3M funds available`, which
is byte-for-byte the `FUND_AVAILABLE` formula in `DCT_BUDGET_UTILIZATION_V`. **So the new
report is the existing butil fact + a Plan column + Revenue.** No new actuals engine.

---

## 3. The three data gaps

### GAP 1 — Expenditure Plan (cashflow phasing)
The Fusion budget is **un-phased**: 1,736 of 1,779 FY2026 lines carry a single period row and
1,570 of those sit in `01-2026`. There is no monthly plan anywhere in Fusion. Two tables already
exist for exactly this (`db/v2/111`, built for the DOF submissions) and are **empty** (2 rows each):

* `DCT_GL_BUDGET_CASHFLOW` — 10-segment GL combination × year × period × `APPROVED|REVISED`
* `DCT_PROJECT_CASHFLOW` — project / task / expenditure type × year × period × `APPROVED|REVISED`

`DCT_PROJECT_CASHFLOW` is at the **exact butil grain**, so it is the plan carrier for this report.
The GL app already ships an upload UI (Cashflow tab) and, since v1.71.0, a **pre-filled
round-trip template** (`GET /gl/cashflow/projects/template`) that downloads every budget line
of a year with the saved monthly amounts. **Nothing new is needed for Finance to load the real
plan — the pipe is built and waiting for the file.**

> ⚠ Consumption rule (learned the hard way in `db/v2/37`): a plan row at a period where the
> budget has no row **must not be reached by joining from the budget table** — it is silently
> dropped. Aggregate plan rows in their **own** CTE and `FULL OUTER JOIN`/`UNION ALL` them onto
> the budget grain, the way `pb_src` does for budget changes.

### GAP 2 — Revenue Plan
No monthly revenue plan exists in any form. Proposed new table (mirrors the cashflow shape so
the same upload/purge/round-trip pattern applies):

```sql
prod.DCT_GL_REVENUE_PLAN
  ( plan_id            NUMBER IDENTITY PK
  , budget_year        NUMBER        NOT NULL
  , accounting_period  VARCHAR2(20)  NOT NULL   -- MM-YYYY
  , period_date        DATE
  , cost_center_code   VARCHAR2(7)   NOT NULL   -- sector derives from this (never stored twice)
  , account_code       VARCHAR2(6)   NOT NULL   -- the revenue natural account
  , plan_type          VARCHAR2(30)  NOT NULL   -- APPROVED | REVISED
  , plan_amount        NUMBER DEFAULT 0 NOT NULL
  , source_file        VARCHAR2(200)
  , loaded_by          VARCHAR2(100)
  , loaded_at          TIMESTAMP DEFAULT SYSTIMESTAMP
  , CONSTRAINT uq_glrevplan UNIQUE
      (budget_year, accounting_period, cost_center_code, account_code, plan_type) );
```

### GAP 3 — Revenue category (`S-` Sovereign / `C-` Commercial + type)
The pack breaks revenue into 28 named types (`S-Tourism …`, `C-Admission / Ticketing`,
`C-Museum Charge`, `S-Alcohol Fees` …). Our natural accounts cannot produce that: 621.1M of
2026 revenue sits on a single account, `328510 "Sales account (for Oracle system setup)"`, and
136.9M on `221390 "Other accrued expenses…"`. So the category is a **classification layer**, not
a source field:

```sql
prod.DCT_GL_REVENUE_CATEGORY      -- code, name_en, name_ar, stream (SOVEREIGN|COMMERCIAL), display_order, is_active
prod.DCT_GL_REVENUE_CAT_MAP       -- account_code [+ optional cost_center_code] -> category_code, effective-dated
```

Mapping precedence: `(account, cost centre)` → `(account)` → `Uncategorised`. `Uncategorised` is
**shown on the report as its own bar**, never dropped — same rule as the pending page's
`unmatched` bucket. Managed from the GL **Settings** group like the existing COA-mapping tab.

Both new dimensions are ordinary data, so a category change is a data change with no deploy.

---

## 4. Sample data — generation and removal

Requirement: while the real plan files do not exist, the report must be demonstrable, and the
sample must be **removable in one call**.

### 4.1 Design

New package **`prod.DCT_GL_PLAN_SAMPLE_PKG`** (`db/v2/123`):

| Routine | Purpose |
|---|---|
| `generate_expenditure_plan(p_year, p_plan_type, p_batch)` | phases every `DCT_BUDGET_UTILIZATION_V` line of the year into 12 `DCT_PROJECT_CASHFLOW` rows |
| `generate_revenue_plan(p_year, p_plan_type, p_batch)` | phases the revenue FY budget into 12 `DCT_GL_REVENUE_PLAN` rows per cost centre × account |
| `generate_revenue_categories(p_batch)` | seeds the 28 PDF categories + a starter account→category map |
| **`purge(p_year, p_batch)`** | deletes **only** rows tagged as sample, across all three tables; returns per-table counts |
| `is_sample_active(p_year)` | `Y/N` — drives the on-screen and on-cover SAMPLE banner |

### 4.2 The removal guarantee (three independent locks)

1. **Tagging.** Every generated row is stamped `loaded_by = 'SAMPLE'` and
   `source_file = 'SAMPLE:'||p_batch` (a batch id like `SAMPLE:2026-PLAN-01`).
   `purge` deletes strictly `WHERE loaded_by='SAMPLE'` — a real uploaded row is
   *unreachable* by the purge because Finance uploads stamp the real filename and username.
2. **Refusal to overwrite.** `generate_*` raises `-20001` if the target year already holds a
   row **not** tagged `SAMPLE`. Sample data can never silently overwrite a real plan, and the
   moment Finance uploads the real file the generator locks itself out.
3. **Visibility.** Setting `FEATURE_PLAN_SAMPLE_DATA` (Y/N, ships **N**) plus an amber
   **“PLAN FIGURES ARE SAMPLE DATA”** banner on the page, a watermark line on the PDF cover, and
   a first-row note in the XLSX. Nobody can mistake a sample run for an issued pack.

Purge is also exposed as `DELETE /gl/plan/sample?year=` (GL_MANAGE_CASHFLOW gated) so it can be
removed from the UI without a DBA.

### 4.3 How the sample numbers are shaped

**Deterministic, not random** — seeded from `ORA_HASH(project||task||etype)`, so a re-run
reproduces identical figures and a screenshot taken today still matches tomorrow.

* **Expenditure plan** = `BUDGET_ANNUAL × plan_ratio × monthly_weight(chapter, month)`
  * `plan_ratio`: Opex 1.00, Capex 0.92, Subsidy 1.00 (Finance-adjustable constants)
  * monthly weights per chapter — Opex near-flat with a Q4 uplift; Capex back-loaded
    (mobilisation lag); both sum to 1.00
  * ±6 % deterministic jitter per line from the hash, so departments land on **both** sides of
    plan and the Actual-vs-Plan page has real signal rather than a flat 100 % line
* **Revenue plan** = FY revenue budget × tourism seasonality (Q1/Q4 peak, summer trough),
  split across categories by the category map's default share
* Calibration target: cumulative plan ≈ **63–64 % of FY budget at October**, matching the
  source pack's `Plan vs Budget 63.8 %` — so the demo looks like the real thing

Volume: 1,739 butil lines × 12 periods ≈ **20.9k plan rows** for FY2026 — trivial.

---

## 5. Report parameters

| Parameter | Type | Behaviour |
|---|---|---|
| **Budget Year** | single, **mandatory** | drives every figure; defaults to current FY |
| **Accounting Period** | single `MM-YYYY`, **mandatory** | the YTD cut-off. Sets `GL_CTX.BUTIL_END` so actuals, encumbrance and plan all cut at the same month — identical mechanism to the butil page's Period filter. Defaults to the current period. |
| **Sector** | **multi-select** (chips, any-of) | pipe-delimited exact any-of, same contract as the butil `chapter=` / `bu=` filters |
| **Department (Cost Centre)** | **multi-select** (chips, any-of) | matches on cost-centre code, labelled with the department description |
| *Chapter / Expenditure kind* | multi, optional | defaults to **Opex + Capex** — the source pack's own footnote (*“filtered only on CAPEX & OPEX”*). Payroll / Subsidy / Aids & Grants are selectable but off by default. |
| *Project Type* | multi, optional | defaults to `DCT OPEX Project Type` (platform default) |
| *Plan type* | single | `APPROVED` (default) or `REVISED` |
| *Figures in* | select | AED / K / M / B — the shared `buUnit` setting |

Sector and Department are **AND**-ed with each other and **OR**-ed within themselves
(“and/or” as requested: pick sectors, pick departments, or narrow to specific departments
inside chosen sectors). Selecting a department outside a chosen sector returns nothing rather
than silently widening — the applied-filters tray shows exactly what was scoped.

---

## 6. Delivery plan (layer by layer)

| # | Layer | Artefact | Notes |
|---|---|---|---|
| 1 | ✅ DB | `db/v2/123_gl_sector_perf.sql` | revenue category + map + revenue plan tables; `DCT_GL_REVENUE_FACT_V`; **`DCT_SECTOR_PERF_V`** (year × period × sector × department × chapter-kind, budget/actual/plan/encumbrance/funds); `DCT_GL_PLAN_SAMPLE_PKG` |
| 2 | ✅ DB | `db/v2/123t` — **29/29** | PL/SQL assert harness — parity vs `/gl/butil` at every filter combination |
| 3 | ✅ ORDS | `final apps/GL/db/24_gl_sector_perf_ords.sql` — 8 handlers, API smoke **70/70** | ADDITIVE. `GET /gl/sectorperf` (all four pages in one envelope: matrix, KPIs, gauges, dept series, sector table, revenue) · `/sectorperf/filters` · `/sectorperf/lines` (drill) · `/sectorperf/notes` (variance commentary) · `POST /sectorperf/book`⁄`/xlsx`⁄`/ppt` · `DELETE /gl/plan/sample`. **GL post-05 re-run list becomes 07..24.** |
| 4 | ⬜ Reporting | `reporting/db/38_rpt_sector_perf.sql` | `SECTOR_PERF_BOOK` (MULTI/PYTHON, PDF via new `sector_perf_book.html.j2` + PPTX) and `SECTOR_PERF_REGISTER` (XLSX). Section SQLs **lock-step** with the handler. MERGE-bearing ⇒ deploy via python-oracledb on a worker VM, never Linux SQLcl. |
| 5 | ✅ Frontend | `final apps/GL/Jet/` — v1.72.0, browser smoke **47/47** | new `sectorperf` tab in the **Projects** nav group; 4 regions mirroring the 4 pages; shared `<interactive-report>` for the sector/project table (expand-to-project via control break); Chart.js via `shared/chartLoader`; drill drawers reuse `/butil/lines` so a tile total and its documents can never disagree; EN + AR/RTL |
| 6 | ✅ Tests | `GL/tests/sectorperf_*` | API smoke + Playwright browser smoke (EN + AR), plus the **reconciliation suite**: every figure must tie to `/gl/butil` for the same filters |
| 7 | ✅ Docs | `GL/docs/deployment-notes.md`, `GL/docs/functions_list.md`, `CLAUDE.md` Module Status | mandatory in the same change |

**Hard acceptance rule:** for any parameter set, `Budget`, `Actual`, `Encumbrance` and
`Funds Available` on this report must equal `/gl/butil` for the same scope, to the fils.
Plan and Revenue are additive columns only.

---

## 7. Proposed enhancements

Beyond a like-for-like rebuild. Numbered so they can be accepted or dropped individually.

**Closing real gaps in the source pack**

1. **Variance commentary that is actually captured.** The pack's *Over Spend / Under Spend
   Comments* are static buttons. Make them a persisted, per-row commentary (reuse the
   `DCT_GL_DOF_NOTE` pattern) that **pre-fills on every future run**, and make a comment
   *mandatory* when `|Actual − Plan|` exceeds a configurable threshold — with an optional DWP
   sign-off chain (`SECTOR_HEAD → FIN_DIRECTOR`) before the pack can be issued.
2. **Published-month snapshot.** Today every figure is live and a pack re-run next week returns
   different numbers than the one that was issued. Add a *Publish* action that freezes the
   month's figures, so a re-print of “October” always reproduces October as issued — with a
   live-vs-published delta view for anyone who wants to see what moved.
3. **Auto-generated insights** (the butil briefing book already does this): top 5 over- and
   under-spending departments with the driver behind each (single large PO, GRN timing,
   unspent plan), so the reader is not left to derive it from a 60-bar chart.
4. **Data-quality badges instead of silent drops.** Show plan coverage %, unmapped-sector
   lines (**today: 73 lines ≈ 371.7M**), unmapped revenue (**84.6M in 2026**) and uncategorised
   revenue right on the page. A number that cannot be attributed should be visible, not missing.

**Decision-grade additions**

5. **Full-year landing forecast**: `Actual YTD + remaining plan`, with variance to FY budget and
   a run-rate alternative — the single figure a sector head actually needs in October.
6. **Elapsed-time RAG.** `Actual vs FY Budget %` marks *everyone* red early in the year. Add a
   second traffic light against **elapsed plan** (`Actual ÷ Plan-to-date`), and make the
   0–33/33–67/67–100 bands configurable settings rather than hard-coded.
7. **Approval-pipeline overlay.** Join the existing `/gl/pending` snapshot so Funds Available can
   be shown *net of what is already in the approval queue* — the true forward position.
   Procash inclusion (`procash=Y`) available as the same opt-in checkbox as on butil.
8. **Drill everywhere, to the document.** Every tile, bar and cell opens the shared drill drawer
   over `/butil/lines`, ending on the actual AP invoice / GRN / PR / PO line, with the existing
   Fusion deep-links. Nothing on the page should be a dead number.
9. **Revenue-to-Opex % as a governed KPI.** Register it in the Finance KPIs module (App 213)
   with its FY target and score bands, so the sustainability ratio is tracked and approved
   rather than merely displayed.

**Distribution**

10. **Per-sector automated distribution.** Schedule the pack monthly through the Reporting
    Platform with `ROLE`/`ORG` recipient resolution, so each sector head is emailed **their own
    sector's** pack automatically after period close.
11. **Bilingual + RTL** (the source pack is EN-only) and **PPTX** for the exec readout — both
    renderers already exist on the fleet.
12. **Excel register companion** — sheet-per-section with the full line detail behind every
    figure, so Finance can pivot without asking for a data pull.

---

## 8. Test strategy

| Tier | Coverage |
|---|---|
| Unit (PL/SQL asserts) | plan phasing sums to the annual figure per line; purge removes 100 % of sample rows and 0 real rows; generator refuses when real data present; category mapping precedence; period cut-off arithmetic |
| API (pytest) | every route, all parameter combinations, 400/401/403/404, boundary (no sectors selected, department outside sector, period outside year, year with zero plan) |
| **Reconciliation** | budget / actual / encumbrance / funds tie to `/gl/butil` across full-year, period-cut, sector-filtered and department-filtered scopes — zero difference |
| Browser (Playwright) | EN + AR/RTL, every region, drill drawers, export buttons, sample banner visible when sample data active |
| Regression | butil, encumbrances, pending, DOF and the cashflow upload unaffected (additive scripts only) |
| UAT | `GL/UAT/UAT_GL_round<N>-dd-mm-yyyy/` per the platform convention |

---

## 9. Open questions for Finance

1. **Plan ownership** — will Finance upload the real monthly plan via the existing Cashflow
   round-trip template, and for which year(s)? Sample data is a stop-gap, not a destination.
2. **`APPROVED` vs `REVISED`** — which does the pack's *Plan* column mean? (Proposed default:
   `APPROVED`, with `REVISED` selectable.)
3. **The 28 revenue categories** — please confirm the list and the account → category mapping;
   the sample map is a starting point only.
4. **Revenue actual basis** — AR *invoiced* revenue (proposed, 753.3M for 2026) or *received*
   cash? There is no receipts extract today; a cash basis needs one.
5. **Default chapter scope** — confirm Opex + Capex only, matching the source pack's footnote.
6. **Sector list** — our 2026 data carries 17 sectors, including `Executive Office` and
   `TeamLab` which do not appear in the October-2025 pack. Include all, or restrict to the
   pack's 11?
7. **`Target [YTD Plan / FY Plan]`** on page 1 — confirm the denominator is FY **plan**, not FY
   budget (they differ once `plan_ratio` ≠ 1).
