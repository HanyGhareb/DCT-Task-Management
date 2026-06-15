# Form Layout — unified create/edit form page (`fl-*`)

**Status:** 🚀 Promoted (2026-06-15) — the `.fl-*` block is live in
`final apps/shared/css/platform.css` (additive; overrides no existing class).
Adopters (FL `APP_VERSION` 4.5.5 → 4.5.6): **FL `registrationEdit`** (required-fields
legend only — page had in-flight WIP) and **FL `contractEdit`** (the full
**review-mode** showcase: a submitted/active contract renders clean read-only
value rows via `css:{ 'fl-review': !editable() }` + `.fl-readonly` twins, instead
of greyed-out disabled inputs). The "Promote path" below is now the as-built record.
Modelled on the Oracle JET Cookbook *Form Layout (Job Application Form)* sample
(`formLayoutCorepack` / `jobapplicationform`), retargeted to i-Finance domain data
and built **entirely on platform.css token names + existing form atoms**.

> **As-built notes vs. this mockup:** (1) review mode ships namespaced as
> **`.fl-review`** on any ancestor — *not* the demo's `body.review` (avoids any
> collision with a generic `.review` class). (2) A "section" reuses the existing
> `.card` + `.section-heading-row`; `.fl-section` is an **optional add-on class**
> (`class="card fl-section"`) that only adds the staggered reveal + scroll anchor.
> The muted helper line under a header is `.fl-section-intro`. (3) FL
> `registrationEdit` had heavy in-flight edits at promote time, so its adoption was
> kept to the additive legend; the full review-mode field-twin swap (recipe below)
> is ready to apply once that WIP lands.

`index.html` in this folder is the runnable mockup. The sticky **lab control bar**
at the top (brand cube + segmented toggles) is **demo chrome only** — it is NOT
part of the promoted component; it exists so you can feel every variant before
rollout: **label-edge** (Top / Start), **columns** (1 / 2 / 3), **density**
(Cozy / Compact), **mode** (Edit / Review), **direction** (LTR / RTL), **theme**
(Light / Dark), plus live required-field validation and a save toast.

This is the missing twin of the two existing entries: *Search → Table Result* is
the canonical **list** page; *Drawer Form* is the inline **row editor**; **Form
Layout** is the canonical **full-page create / edit** form (the "look different /
fields misaligned" defect class the root `CLAUDE.md` calls out as the #1 visual
divergence cause — every module's create/edit page should be this one scaffold).

---

## Why this exists

Modules currently hand-roll create/edit pages with slightly different headers,
section treatments, label placement, column counts and action-button positions.
The JET Cookbook form-layout pattern fixes that with **one responsive, sectioned
scaffold** whose only per-page input is the field markup. This component codifies
it for the suite:

- grouped **sections** (a `.card` per fieldset with a themed region header);
- responsive **multi-column** field grid (1 / 2 / 3, collapses to 1 on mobile);
- configurable **label-edge** — `top` (default) or `start` (inline label), the
  Cookbook's headline toggle;
- **required** markers, **hints**, inline **validation** errors;
- a built-in **read-only / review** mode (controls flip to value rows) so the same
  markup renders the create form, the edit form, and the confirm/print view;
- **top-right** action bar (Save / Cancel) per the platform rule — never a bottom
  form bar;
- EN/AR + RTL, Latin digits, light/dark — all from platform tokens.

---

## Anatomy

```
form.fl-page
  .page-header-row          ← title + .page-sub + .fl-legend (left) · .page-actions (top-right: Cancel + Save)
  nav.fl-rail               ← section jump-chips (orientation for long forms)
  section.fl-section  × n    ← a card per fieldset
    .section-heading-row     ← themed region header (.section-heading + optional .region-actions)
    .fl-section__intro       ← optional one-line helper under the header
    .fl-section__body
      .form-grid             ← (+ --1 / --3, --label-start, --compact)
        .form-group          ← (+ --full / --span2 / .invalid)
          .form-label (+ .required / .opt)
          .form-control      ← input / select / textarea  (edit mode)
          .form-hint         ← optional helper
          .field-error       ← shown when .form-group.invalid
          .fl-readonly       ← the value shown in review mode (.fl-review ancestor)
  .fl-toast                  ← save / validation feedback (demo)
```

### Class inventory

| Already in `platform.css` (reuse as-is) | NEW — the promote delta (`.fl-*` block) |
|---|---|
| `.page-header-row` · `.page-title` · `.page-actions` · `.region-actions` | `.fl-page` (page wrapper / max-width) |
| `.card` · `.section-heading-row` · `.section-heading` | `.fl-section` (card + section reveal) · `.fl-section__intro` · `.fl-section__body` |
| `.form-grid` · `.form-grid--3` · `.form-group` · `.form-group--full` | `.form-grid--1` · `.form-grid--label-start` (label-edge=start) · `.form-grid--compact` (density) · `.form-group--span2` |
| `.form-label` · `.required` · `.form-control` · `.form-hint` · `.field-error` · `.form-control--error` | `.form-label .opt` (optional tag) · `.fl-readonly` + `.fl-review` review mode · `.fl-section` / `.fl-section-intro` · `.fl-rail` (section nav) · `.fl-legend` |
| `.btn` / `.btn-primary` / `.btn-sm` · `.docup*` | — |

So the genuinely new CSS is small and **additive**: the section card wrapper, the
inline-label (`--label-start`) and compact (`--compact`) grid modifiers, the
review-mode value rows, and the section rail. Everything else is composition over
classes the suite already ships.

---

## Promote path (mockup → real platform)

### 1. Styles → `final apps/shared/css/platform.css`
Append the `.fl-*` block (the NEW column above), retokenised to the live platform
vars (`--region-hd-*`, `--brand-soft`, `--radius-lg`, `--shadow`, …). Do **not**
re-declare the existing `.form-*` atoms — extend them. Honour `prefers-reduced-motion`
on the `fl-rise` / `fl-shake` keyframes.

### 2. Behaviour → mostly none (CSS-driven)
The variants are pure CSS class toggles, so a host view rarely needs JS. Two thin,
optional helpers belong in `shared/js/` if we want them reusable:
- a **review-mode** flag the host VM owns (`ko.observable(reviewMode)`) → bind
  `css:{ 'fl-review': reviewMode }` on the `<form>` (or a wrapper); the `.fl-readonly`
  rows bind their text to the same observables the inputs use.
- a tiny **validate(formEl)** util (required + email/regex) returning `bool`,
  mirrored by per-`.form-group` `invalid` classes — or keep validation in each VM.

No Knockout custom element is required (unlike `<edit-drawer>`); this is a
**layout recipe + CSS block**, closer to *Search → Table Result* than to a widget.
If we later want a true `<form-section>` element it can wrap `.fl-section`, but
start with the recipe.

### 3. Wiring → host view (`views/<entity>Edit.html`)
Compose the anatomy above, binding `.form-control`s to the view's own observables
and the matching `.fl-readonly` to the same value (`text: $data.field || ''`).
Pick the variant per page with static classes:
`form-grid` (2-col, default) · add `form-grid--label-start` for dense settings
forms · `form-grid--3` for short-field grids. **As-built reference adopter for
review mode: FL `contractEdit`** — `class="card fl-section" data-bind="css:{ 'fl-review': !editable() }"`,
each field gets a `.fl-readonly` twin (selects resolve their ID→label via a small
`ko.computed` display helper in the VM; e.g. `freelancerDisp`, `glDisp`).

### 4. Cache + docs
Per the shared-change rule, adopting it in an app needs an `APP_VERSION` bump in
that app's `Jet/index.html`; a change to the shared `.fl-*` block itself = bump
**all** apps as they adopt. Update each adopting app's `docs/deployment-notes.md`
and (if a view/VM method changed) `docs/functions_list.md`.

---

## Gotchas (honour these — each has bitten the suite)

- **APEX_JSON skips NULL keys** → bind every optional field and every `.fl-readonly`
  value as `$data.field || ''`, never a bare `text: field` (throws `ReferenceError`
  and blanks the row).
- **`$vm.` for VM calls** inside `foreach`/`with`; `$root` is the shell AppController
  (`t` / `lang` / `setLang` only).
- **Action buttons top-right** in `.page-header-row .page-actions` (or the section's
  `.region-actions`) — never a `.form-actions` bottom bar (deprecated; modal footers
  only).
- **Never wrap a KO-bound input/checkbox in `<label>`** (double-toggle); the
  `.form-label` here is a sibling, `for=`-linked — keep it that way.
- **RTL + Latin digits** come from platform tokens; the Arabic name field needs
  `dir="rtl"` on the control (and its `.fl-readonly`).
- **`--label-start` likes fewer columns.** Inline labels eat ~140px per field, so
  it reads best at 1–2 columns (the fixed `140px` label track collapses to a
  stacked label under 680px). Prefer single-column `--label-start` for dense
  settings forms; don't pair it with `--3`.
- Region header fill/border come from the `THEME_REGION_*` settings via
  `shared/js/shell.js` — **never hard-code** header colors on `.section-heading-row`.

---

## When (not) to use

| Use it for | Reach elsewhere |
|------------|-----------------|
| Any full-page **create / edit** form with grouped fields | A single-record **row edit** in a table → `<edit-drawer>` |
| Forms that also need a **read-only review / confirm** view (same markup) | A **multi-step** create flow → *Stepper / Wizard* (planned) |
| Settings pages, registration, request intake, profile edit | A **list / search** result → *Search → Table Result* |
