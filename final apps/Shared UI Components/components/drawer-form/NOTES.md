# Drawer Form — `<edit-drawer>`

**Status:** 🚀 Promoted (2026-06-15) — live in `shared/css/platform.css` (`.ed-*`) +
`shared/js/editDrawer.js` (`<edit-drawer>`); reference adopter = TM `teamDetail`
Edit-Team. This `index.html` remains the standalone demo. The "Promote path"
below is the as-built record.

An Oracle APEX-style **right-edge slide-in record editor**. Replaces a centred
modal for "edit a table row" flows: click a row's edit icon → a scrim fades in
and a 480 px drawer springs in from the inline-end edge. Keeps the table visible
underneath (edit-in-context).

`index.html` in this folder is the runnable mockup (a TM-teal Sprint Backlog
table + the drawer). It is a **demo** — the real component below carries the
field markup from the host view, not hard-coded fields.

---

## Why a drawer (not the existing modal)

- Table stays in view → better orientation while editing one record.
- Vertical space for many fields without a scrolling modal box.
- Natural home for the platform's **top-right header actions** (Save / Cancel).
- It is the pattern users already know from APEX drawer dialogs.

## Interaction spec

- **Open** from a row edit button; host populates field observables first.
- **Header (top-right actions):** `Cancel` (ghost) + primary `Save` — per the
  platform "action buttons top-right, never a bottom form bar" rule. Header fill
  uses the region-theme vars so it matches `.modal-header`.
- **Unsaved dot:** amber pulsing dot beside the title while the form is dirty.
- **Staggered field reveal** on open (`.form-group` cascade).
- **Close:** Cancel · scrim click · `Esc`.
- **RTL:** anchors to the inline-end edge and slides the correct way under
  `[dir="rtl"]`. Latin digits.

---

## Promote path

### 1. Styles → `shared/css/platform.css`

Append an `.ed-*` block (mockup CSS, retokenised to platform vars). Key classes:

| Class | Role |
|-------|------|
| `.ed-scrim` / `.ed-scrim.ed-show` | dim backdrop, fades in |
| `.ed-drawer` / `.ed-drawer.ed-show` | the panel; `transform:translateX(100%)` → `none` on show, with `[dir=rtl]` flip |
| `.ed-drawer::before` | brand accent rail (`--brand`) |
| `.ed-drawer__header` | themed header (`--region-hd-bg/-fg`), holds `.region-actions` |
| `.ed-drawer__eyebrow` / `.ed-drawer__title` | record key + title |
| `.ed-dirty` / `.ed-dirty.on` | unsaved-changes dot (pulse `@keyframes ed-pulse`) |
| `.ed-drawer__body` | scroll area; reuses platform `.form-grid`/`.form-group`/`.form-control` |

Reuses existing `.btn`/`.btn-primary`/`.region-actions` untouched.

### 2. Behaviour → `shared/js/editDrawer.js` (Knockout component)

Register an `edit-drawer` custom element. The host view supplies the **field
markup as child nodes**, rendered via `$componentTemplateNodes` and **rebound to
the host ViewModel** with `data: vm` — so fields keep binding to the view's own
observables (`eName`, `types`, …), while the drawer chrome binds to the
component VM.

```js
define(['knockout'], function (ko) {
  'use strict';
  if (ko.components.isRegistered('edit-drawer')) return;

  function DrawerVM(params) {
    var self = this;
    self.open        = params.open;                 // ko.observable(bool), two-way
    self.vm          = params.vm || {};             // host ViewModel for body bindings
    self.title       = params.title || '';
    self.subtitle    = params.subtitle || null;     // optional (html) — e.g. record key
    self.dirtyFlag   = params.dirty || null;        // optional ko.observable(bool)
    self.saveLabel   = params.saveLabel   || 'Save';
    self.cancelLabel = params.cancelLabel || 'Cancel';
    self.width       = params.width || '480px';

    self.save  = function () { if (typeof params.onSave === 'function') params.onSave(); };
    self.close = function () {
      if (typeof params.onClose === 'function' && params.onClose() === false) return;
      if (ko.isObservable(self.open)) self.open(false);
    };
    function onKey(e){ if (e.key === 'Escape' && ko.unwrap(self.open)) self.close(); }
    document.addEventListener('keydown', onKey);
    self.dispose = function(){ document.removeEventListener('keydown', onKey); };
  }

  ko.components.register('edit-drawer', {
    viewModel: { createViewModel: function (p) { return new DrawerVM(p); } },
    template:
      '<div class="ed-scrim" data-bind="css:{\'ed-show\':open}, click: close"></div>' +
      '<aside class="ed-drawer" role="dialog" aria-modal="true" data-bind="css:{\'ed-show\':open}, style:{maxWidth:width}">' +
        '<header class="ed-drawer__header">' +
          '<div>' +
            '<!-- ko if: subtitle --><div class="ed-drawer__eyebrow" data-bind="html: subtitle"></div><!-- /ko -->' +
            '<div class="ed-drawer__title"><span data-bind="text: title"></span>' +
              '<span class="ed-dirty" data-bind="css:{on: dirtyFlag}"></span></div>' +
          '</div>' +
          '<div class="region-actions">' +
            '<button class="btn btn-sm" data-bind="click: close, text: cancelLabel"></button>' +
            '<button class="btn btn-sm btn-primary" data-bind="click: save, text: saveLabel"></button>' +
          '</div>' +
        '</header>' +
        '<div class="ed-drawer__body" data-bind="template:{nodes: $componentTemplateNodes, data: vm}"></div>' +
      '</aside>'
  });
});
```

> **Binding-context note (the crux):** child markup passed to a KO component is
> exposed as `$componentTemplateNodes`. Rendering it with
> `template:{ nodes: $componentTemplateNodes, data: vm }` rebinds `$data` to the
> host ViewModel passed in `params.vm`, so the body fields resolve `eName`,
> `types`, `t(...)`, etc. against the view — exactly as they did inside the old
> `<!-- ko if: showEdit -->` modal. Pass `vm: $vm` from the view (the module
> binding injects `$vm` = the view's own VM).

### 3. Wiring → host view (reference conversion: TM `teamDetail`)

Replace the Edit-Team modal block (`teamDetail.html`, the `<!-- ko if: showEdit -->`
`.modal-overlay`/`.modal-box`) with:

```html
<edit-drawer params="open: showEdit, vm: $vm,
                     title: t('tm.detail.editTeam'),
                     saveLabel: t('tm.action.saveChanges'),
                     cancelLabel: t('tm.action.cancel'),
                     onSave: saveTeam">
  <div class="form-grid">
    <div class="form-group"><label class="form-label" data-bind="text: t('tm.field.nameEn')"></label>
      <input class="form-control" data-bind="textInput: eName"></div>
    <!-- …the existing Edit-Team form-groups, unchanged… -->
  </div>
</edit-drawer>
```

No ViewModel change required — `showEdit`, `eName…`, `saveTeam` already exist.
Add `'shared/editDrawer'` to `TM/Jet/js/main.js` `require([...])`, then bump
`TM/Jet/index.html` `APP_VERSION` (4.5.1 → 4.5.2). Roll to other apps by adding
the same one `require` line + the field markup per form, and bumping each.

### Params reference

| Param | Type | Req | Notes |
|-------|------|-----|-------|
| `open` | `ko.observable(bool)` | ✓ | two-way; component sets `false` on close |
| `vm` | object | ✓ | host ViewModel for body bindings — pass `$vm` |
| `onSave` | function | ✓ | called by the Save button |
| `title` | string/obs | ✓ | header title |
| `subtitle` | string/obs (html) | – | e.g. record key `TM-1042` |
| `dirty` | `ko.observable(bool)` | – | shows the pulsing unsaved dot |
| `onClose` | function | – | return `false` to veto close (e.g. confirm discard) |
| `saveLabel` / `cancelLabel` | string/obs | – | default `Save` / `Cancel` |
| `width` | string | – | default `560px`. Any CSS width (`720px`, `60vw`) or `auto` to size to content. Bounded by `min-width: min(380px,100vw)` / `max-width: min(100vw,920px)` in platform.css (so it's never wider than the screen, full-width on phones). Bound to real `width` — not `max-width`. |
