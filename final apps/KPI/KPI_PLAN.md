# Finance KPI Management Module (App 213) — Build Plan

**Status: APPROVED 2026-07-28** (user approved the end-to-end plan; scope decisions confirmed below).

## Purpose

Automate the full management cycle of the DOF "ADGEs Unified Financials KPIs" circular (July 2026):
definition registry → periodic result capture (auto-suggested from GL data where possible) → evidence →
internal approval (Workflow Platform) → scorecard dashboard → executive briefing-book report.

## Confirmed scope decisions

| Decision | Choice |
|---|---|
| Framework | **Generic configurable KPI framework** — definitions, score bands, weighted criteria, targets, frequencies are data; the 4 circular KPIs are seed content |
| Capture | **Hybrid** — system suggests figures from GL/ATD data where a source is mapped; preparer confirms/adjusts; AUTO/MANUAL provenance kept per figure |
| Approval | **DWP** process `KPI_RESULT_APPROVAL`: Preparer → Section Head (line manager) → Finance Director (role `KPI_FIN_DIRECTOR`); editable later in Workflow Designer |
| Packaging | **New shared-shell module App 213**, key `kpi`, code `KP`, module_code `KPI_MGMT`, ORDS `/ords/admin/kpi/`, brand `#8C6D1F`, roles `KPI_ADMIN` / `KPI_USER` / `KPI_FIN_DIRECTOR` |

## The 4 seeded KPIs (from the circular)

1. **REV_GROWTH** — Revenue Growth: (Actual CY / Actual PY)×100, ANNUAL, RATIO_A_OVER_B.
   Bands: 1 <90 · 2 ≥90 · 3 =100 · 4 >100 · 5 ≥108. Targets 2025/26/27 = 107/108/109.
2. **OPT_PLAN** — Optimization Plan (Ch 1,2,3): WEIGHTED_CRITERIA maturity rubric —
   Data Quality 20 / Approval Status 10 / Execution Plan 20 / Results Achieved 50, each 1–5 with level
   descriptions. Bands: 1 >0 · 2 ≥20 · 3 ≥40 · 4 ≥60 · 5 ≥80. ANNUAL, evidence required. Targets 75/80/90.
3. **CASH_MGMT** — Cash Management & Financial Planning (excl. capital projects): ABS_VARIANCE
   Abs(1−Actual/Forecast)×100 per QUARTER. Bands (descending): 1 >12.5 · 2 ≤12.5 · 3 ≤10 · 4 ≤7.5 · 5 ≤5.
   Target ±5 all years.
4. **FIN_LAW_COMP** — Compliance with Financial Law: WEIGHTED_CRITERIA 8-item checklist —
   budget prep 20 / execution 20 / monthly closure 10 / payment policy 10 / direct-invoice-vs-3-way 10 /
   audited FS 5 / semi-annual FS 5 / tax reports 20 (each 0–100%). Bands: 1 <60 · 2 ≥60 · 3 ≥70 · 4 ≥80 · 5 ≥90.
   ANNUAL result with per-item entry (item frequencies kept as notes). Target 100 all years.

## Architecture (see the full approved plan for detail)

- **db/01** DDL — 9 tables: DCT_KPI_DEFINITIONS, DCT_KPI_SCORE_BANDS (5→1 first-match eval),
  DCT_KPI_CRITERIA (unified rubric+checklist via entry_type), DCT_KPI_CRITERIA_LEVELS, DCT_KPI_TARGETS,
  DCT_KPI_PERIODS, DCT_KPI_RESULTS (kpi×period unique; wf_instance_id nullable no-FK),
  DCT_KPI_RESULT_CRITERIA, DCT_KPI_SOURCES (declarative registry — executable SQL lives ONLY in
  DCT_KPI_PKG.suggest_value as static-SQL CASE; zero dynamic SQL). Lookup-first, no status CHECKs.
- **db/02** views — DCT_KPI_DEFINITION_V / RESULT_V / RESULT_CRIT_V / SCORECARD_V / WF_FACT_V.
- **db/03** seed — lookups, module row 213, roles+permissions, sources, full 4-KPI content EN+AR
  (guarded INSERT/UPDATE upserts — **no MERGE**, Linux SQLcl swallows it).
- **db/04** DCT_KPI_PKG — ensure_periods, admin CRUD, suggest_value, init_result, compute_result,
  score_of, save_result(+criterion), submit_result → dct_wf_engine.start_process, wf_on_complete /
  wf_on_reject hooks (4-arg CTX signature).
- **db/05** DWP seed — fact schema KPI_RES_SCH over DCT_KPI_WF_FACT_V, process KPI_RESULT_APPROVAL
  v1 PUBLISHED, steps SECTION_HEAD (LINE_MANAGER, fallback ANY_ROLE_HOLDER KPI_ADMIN) →
  FIN_DIRECTOR (ROLE KPI_FIN_DIRECTOR, final gate), hooks ON_COMPLETE/ON_REJECT, route KPI_MGMT→WF.
- **db/06** ORDS `kpi.rest` `/kpi/` — registry/periods/results/evidence/scorecard/lovs + report bridge;
  plus db/v2/50 CASE map `WHEN 'kpi' THEN 'KPI_MGMT'` synced into db/v2/11.
- **db/07** jobs — yearly period generation + submission reminder sweep.
- **Jet/** — dashboard (scorecard), kpiList, kpiEdit, results (KPI×period matrix), resultEntry,
  myWorklist (`<wf-worklist>`/`<wf-action-bar>`), reports, notifications, preferences.
- **Report** — KPI_BRIEFING_BOOK (reporting/db/29, MULTI/PYTHON, kpi_briefing_book.html.j2).

## Functional test strategy

| Tier | Coverage |
|---|---|
| Unit (PL/SQL assert harness, db/test) | score_of band edges (89.9/90/100/100.1/108 asc; 5/7.5/10/12.5/12.6 desc), compute_result all 3 methods, weight-sum validation, submit validations (criteria complete, evidence, wrong status) |
| API (pytest, tests/) | every route Happy + Error 400/401/403/404 + boundary (paging limits, replace-set empty arrays, oversize upload 413) |
| System (Playwright) | EN + AR/RTL: dashboard render, admin edit KPI, enter+submit result, worklist approve, report download |
| Regression | /wf/worklist unaffected for other modules; 0 INVALID objects after each deploy |
| UAT | UAT_KPI_TestScript.xlsx + round folders + evidence per Admin convention |

## Deployment order

01 → 02 → 03 → 04 (fresh checks 0 INVALID) → 05 (simulate + live cycle) → 06 in fresh session +
db/v2/50 edit synced into 11 (then re-run 49 + 101) → frontend (+ shell/i18n + APP_VERSION bump ALL apps)
→ reporting/db/29 + template upload → 07 jobs → docs/UAT.

## Open items to confirm with business during UAT

- Section Head = preparer's line manager (seeded) vs a fixed role.
- Who holds KPI_FIN_DIRECTOR.
- Revenue account scope for the KPI 1 auto-suggestion (source registry is configurable).
- Inter-KPI scorecard weights (defaulted 25% each).
- KPI 4 collection cadence (annual with per-item entry assumed).
