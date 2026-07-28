# Finance KPIs (App 213) — UX Redesign Plan

**Status: DRAFT — awaiting approval. No build starts before Phase 1 sign-off.**
Date: 2026-07-28 · Trigger: end-user review of v1.2.0 **failed** ("not clear, not simple").

---

## 1. Why the first version failed (root cause, honest)

The app was built **framework-out, not user-in**. The generic KPI engine (definitions,
score bands, calc methods, criteria, periods, AUTO/MANUAL provenance) leaked directly
into the screens, so an end user meets the *data model*, not their *job*:

| What the user needs to do | What the app made them do |
|---|---|
| "Submit this quarter's Cash figures" | Open **Results & Submissions** → pick a year → understand a KPI × period **matrix** → click the right cell |
| "Enter the number and attach the letter" | Parse one dense page: formula pills, band tables, AUTO/MANUAL badges, rubric grids, evidence, timeline |
| "Approve what's waiting for me" | Know that a separate **My Worklist** page exists |
| "How are we doing?" | Read a scorecard written in framework language (bands, weighted overall, provenance) |

Three review rounds (layout, then FPB skin) restyled the surface but kept the
framework-shaped structure — styling cannot fix an information-architecture problem.
Second process failure: **no end-user checkpoint before go-live.** The redesign fixes
both: task-first design, and a demo gate with the end user at every phase.

**What stays (unchanged, proven):** the whole server side — 9 `DCT_KPI_*` tables,
`DCT_KPI_PKG`, the DWP `KPI_RESULT_APPROVAL` chain, `/kpi/` ORDS, jobs, briefing-book
infra. This is a **UX rebuild over the same engine**, plus a thin API additive layer.

## 2. Design principles (the definition of "clear, simple, mature")

1. **Task-first, not data-first.** The home screen answers "what do I need to do now?"
   — never "here is the data model".
2. **One primary action per screen.** Everything else is secondary or hidden.
3. **Plain bilingual language.** No framework words in user-facing text: no
   "periods generation", "bands", "provenance", "instance", "matrix".
   Glossary approved by the business in Phase 0 (e.g. *Result %* → "Achievement",
   AUTO → "From GL", MANUAL → "Entered manually").
4. **Progressive disclosure.** Formula/bands live behind a small "How is this scored?"
   link; admins' complexity lives in an Administration area preparers never see.
5. **Guided, not open-ended.** Data entry is a short wizard with a review step, not a
   long form.
6. **Defaults everywhere.** Current year, current period, the user's own pending work.
7. **Checkpoint or it didn't happen.** Every phase ends with a live demo to the end
   user; their sign-off is the exit criterion.

## 3. Target experience (what we are building towards)

**Personas:** Preparer (finance analyst) · Approver (Section Head / Finance Director) ·
Executive viewer · KPI Admin (rare, power user).

**Navigation collapses to 4 items (+1 admin-only):**

| Nav | Replaces | Content |
|---|---|---|
| **Home** | (new) + myWorklist | Action inbox: *Due now* / *My drafts* / *Returned to me* / *Waiting for my approval* — each a card with one button. Zero-state = friendly 3-step "how this works". |
| **Scorecard** | dashboard | Executive view: one headline score in words + 4 KPI cards (score, vs target, vs last year) + trend. Click a KPI → its detail page. |
| **KPI pages** | results matrix + resultEntry (browse path) | One page per KPI: what it measures in plain words, this year's periods as a simple status list ("Q2 — due 15 Jul — Draft"), history, evidence. |
| **Reports** | reports | One-click Briefing Book + printable one-page scorecard. |
| **Administration** (admin) | kpiList/kpiEdit + calendar | KPI setup, score bands, criteria, targets, year calendar & due dates, role holders. |

**Guided measurement wizard** (replaces the resultEntry page) — 3–4 short steps:
1. *Figures* — one question per figure in plain words ("What was total revenue in
   2026?"), the GL suggestion shown as "System figure: 12,345,000 — **Use it** / enter
   different (why?)". Rubric KPIs get one clean criterion-at-a-time assessment instead.
2. *Evidence* — a checklist of the expected documents, drag-drop upload.
3. *Review & submit* — the computed achievement and score **in words**
   ("Score 4 of 5 — above target"), who will approve next, then one Submit button.

**Approval screen** (from Home, replaces the raw worklist): one review page — summary
card (score, target, prior period), the figures with their source, evidence, preparer
notes — and the server-driven action buttons (Approve / Return with comment). Backed by
the same `/wf/` API; no hard-coded verbs (platform rule).

## 4. Phases

> Sequential, each with **deliverables · exit gate**. Phases 2–6 each end with a
> 30-minute demo to the end user; failing a gate loops the phase, never patches forward.

### Phase 0 — Prerequisites & discovery (before any design)
- **Structured feedback session** on v1.2.0 with the end user(s): walk their real
  monthly/quarterly routine, record where the app lost them (navigation, words, entry,
  approvals). Output: prioritized pain-point list.
- **Business confirmations** (the open list, now blocking):
  - Section Head step = line manager or a fixed role? Who exactly?
  - The real KPI_FIN_DIRECTOR holder (ADMIN is a placeholder today).
  - Revenue account scope for the KPI-1 GL suggestion.
  - Inter-KPI scorecard weights (currently 25% each) and KPI-4 cadence.
  - **Submission due dates** per period (drives the whole task-first Home).
  - Expected-evidence checklist per KPI (drives the wizard's evidence step).
- **Role & user matrix**: named preparers/approvers per KPI, granted in Admin.
- **Bilingual glossary** (one page, business-approved) — the single source for every
  label in the new UI.
- Exit gate: confirmations documented in STATUS.md; glossary signed off.

### Phase 1 — UX blueprint (design before build)
- Clickable HTML mockups (dev-proxy, real ORDS data, throwaway code) for the 6 core
  screens: Home, wizard steps, approval review, Scorecard, KPI page, Reports.
- Walk the end user through their own scenario on the mockups; iterate (expect 2–3
  rounds — cheap here, expensive later).
- Exit gate: **end-user sign-off on the blueprint. Nothing is built before this.**

### Phase 2 — Data & API groundwork (small, additive)
- `db/08`: `DCT_KPI_PERIODS.due_date` (+ seed confirmed 2026/2027 deadlines);
  reminder job re-pointed at due dates (T-7/T-1/overdue).
- `GET /kpi/mytasks` — one call returning the four Home buckets (due / drafts /
  returned / my approvals) so Home renders from a single request; additive handler in
  `db/06` pattern (re-run safe).
- Optional plain-language figure "question" labels — reuse the existing
  `figure_x_label` columns via seed update only.
- Exit gate: API tests green; no regression on existing 56 API checks.

### Phase 3 — Core flow: Home + guided wizard
- New `home` view (task inbox, role-aware, zero-state onboarding) as the landing route.
- Wizard rebuild of measurement entry (figures/assessment → evidence → review-submit),
  glossary language only, band/formula behind "How is this scored?".
- Old views stay routable during transition; nav switches at cutover.
- Exit gate: end-user demo — a preparer completes a real draft **unassisted in under
  5 minutes**; browser tests for the flow.

### Phase 4 — Approvals experience
- Approval review screen fed from Home; Approve/Return with mandatory return comment;
  outcomes remain server-driven from the DWP outcome set.
- Exit gate: end-user (approver persona) demo — approve and return a real submission
  unassisted; the return lands back in the preparer's Home.

### Phase 5 — Scorecard & KPI pages
- Scorecard rewrite in glossary language (score in words, vs-target, vs-last-year,
  trend); KPI detail pages replace the matrix as the browse path.
- Exit gate: executive-persona demo ("how are we doing on Cash?" answered in ≤2 clicks).

### Phase 6 — Reports
- Briefing Book template refreshed to the new language/visuals; add a **one-page
  printable scorecard** (Reporting Platform definition or print CSS — decide in
  Phase 1).
- Exit gate: end user accepts both outputs against a real period's data.

### Phase 7 — Hardening, UAT round 2, training, cutover
- Rebuild the browser suite + UAT runner for the new IA; full regression
  (unit 36 / API 56+ / browser / UAT) — **UAT round 2 driven by the end user**, not by
  the automated runner alone.
- Quick-reference guide (`guides/GUIDE_KPI_round1-…` convention, screenshots per step).
- Cutover: remove old views/routes, APP_VERSION 2.0.0, webtier deploy; retire unused
  i18n keys.
- Exit gate: UAT round 2 signed; go-live note in deployment-notes.

## 5. Out of scope (unchanged)
DB engine & tables · DWP process/chain (only role holders change via Phase 0) ·
`/kpi/` existing handlers (additive only) · Reporting control plane · module access
gate · mobile.

## 6. Risks
- **Phase 0 answers don't arrive** → Home due-dates degrade to period end-dates;
  flagged, not blocking.
- **Skipping checkpoints under time pressure** → that is how v1 failed; gates are the
  plan.
- **Glossary churn after build** → all labels via i18n keys only; churn = translation
  edit, not code.
