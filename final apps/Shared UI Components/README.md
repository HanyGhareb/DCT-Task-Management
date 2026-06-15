# Shared UI Components — reference gallery

A living catalogue of **reusable interface patterns** for the i-Finance JET apps.

Each entry is a **self-contained, runnable mockup** — design and validate the
interaction in isolation here, then **promote it once** into
`final apps/shared/` so every module (Admin, PC, DT, HR, FL, CC, AR, TM)
inherits it. This folder is **reference only** — it is *not* served by any
`dev-proxy`; open the HTML files directly in a browser.

> This is the "design lab". The source of truth for shipped UI stays
> `final apps/shared/css/platform.css` + `final apps/shared/js/*`. A mockup here
> is a proposal until it is promoted.

---

## Layout

```
Shared UI Components/
  index.html                     ← the gallery (open this first)
  README.md                      ← you are here
  components/
    drawer-form/
      index.html                 ← the runnable mockup
      NOTES.md                   ← spec + promote path (params, classes, wiring)
    <next-component>/
      index.html
      NOTES.md
```

## Status legend

| Badge | Meaning |
|-------|---------|
| 🟢 **Ready**   | Mockup complete; spec written; awaiting approval to promote |
| 🟡 **Draft**   | Still being designed |
| ⚪ **Planned** | Placeholder card / roadmap only |
| 🚀 **Promoted**| Lives in `shared/` and is wired into ≥1 app (update the badge + link to the shared file) |

## Components

| Component | Status | What it is |
|-----------|--------|------------|
| [Drawer Form](components/drawer-form/index.html) | 🚀 Promoted | APEX-style right-edge slide-in record editor for "edit table row". Live in `shared/` (`.ed-*` + `<edit-drawer>`); adopted by TM `teamDetail`. |
| [Search → Table Result](components/search-table-result-1/index.html) | 🟢 Ready | Canonical list page: search + facet toolbar above a platform `.data-table` with badge / RAG / count-chip / overdue row decoration. A **composition recipe** over classes already in `platform.css` (nothing to promote); reference adopter = TM `Teams`. |
| Stepper / Wizard | ⚪ Planned | Multi-step create flow with progress rail + per-step validation. |
| Filter Bar | ⚪ Planned | Heavier toolbar — facet chips + saved-view selector above any `.data-table` (the Search → Table Result entry covers the simple inline-facets case). |
| Detail Drawer (read) | ⚪ Planned | Read-only inspector with status timeline + activity feed. |

---

## Adding a component

1. Create `components/<name>/index.html` — one self-contained, runnable mockup.
   Link Google Fonts, inline the CSS/JS, and **use the `platform.css` token
   names** (`--brand`, `--surface`, `--border`, `--text`, `--text-2`, `--radius`,
   the `--region-hd-*` header vars …) so it ports with near-zero rework.
2. Copy the **Drawer Form** card in `index.html`; repoint its `href` and preview
   `iframe` at your new folder and set the status badge.
3. Add a `NOTES.md` beside the mockup (see `components/drawer-form/NOTES.md` for
   the template): purpose, **params / classes**, KO wiring sketch, and the exact
   **promote path** into `shared/`.

## Promote path (mockup → real platform)

When a component is approved:

1. **Styles** → append the `.<prefix>-*` block to `final apps/shared/css/platform.css`
   (one structural stylesheet — never copy into a module's `app.css`).
2. **Behaviour** → `final apps/shared/js/<name>.js`. For interactive widgets,
   register a **Knockout component** (`ko.components.register('<tag>', …)`); the
   host view drops in `<tag params="…">` and supplies field markup that binds to
   **its own ViewModel**.
3. **Wiring** → add `'shared/<name>'` to each app's `js/main.js` `require([...])`
   boot array (so the component registers before the first route renders).
4. **Cache** → per the project rule, a change under `final apps/shared/` requires
   bumping `window.APP_VERSION` in **every** app's `Jet/index.html`. (Additive new
   classes only affect an app once it actually adopts the component, so practical
   minimum = bump each app as it adopts.)
5. Update each adopting app's `docs/deployment-notes.md` and, if a view/VM method
   or ORDS endpoint changed, its `docs/functions_list.md`.

See `final apps/SHARED_JET_ARCHITECTURE.md` for the shell / i18n / KO-binding
contract these components must honour (RTL, Latin digits, `$vm` in `foreach`,
APEX_JSON-skips-NULL → bind optional fields as `$data.field`, action buttons
top-right, never `<script>`-tag Chart.js, etc.).
