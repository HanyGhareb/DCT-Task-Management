# Search → Table Result (`Search-table-result-1`)

**Status:** 🟢 Ready — a **composition recipe**, not a new widget. Every structural
class it uses (`.view-toolbar`, `.search-box`, `.form-control--sm`, `.data-table`,
`.badge`, `.avatar`, `.rag`) **already lives in `final apps/shared/css/platform.css`**,
so there is nothing new to promote — adopt it by composing those classes the way
this mockup shows. Reference adopter (as-built): **TM `Teams`** (`views/teams.html`
+ `viewModels/teams.js`, APP_VERSION 4.5.5).

The canonical **list page** layout: a search/filter toolbar above a platform data
table whose rows are decorated with badges, RAG pills, count chips and inline
overdue markers. Replaces the older "card grid + bespoke `.filter-bar`/`.input`"
list, which diverged from the suite (the #1 visual-divergence cause per the root
`CLAUDE.md`).

`index.html` in this folder is the runnable mockup (TM-teal, vanilla JS filtering)
so you can feel the search/filter interaction before wiring it to a real service.

---

## Anatomy

```
.page
  .page-header-row            ← title (left) + .page-actions primary CTA (top-right)
  .view-toolbar               ← search + facets, one flex row
    .search-box               ← free-text search (Enter or live)
    select.form-control--sm × ← one per facet/lookup filter
    label.mine-toggle         ← optional "scope to me" checkbox
    .toolbar-spacer           ← pushes the count to the inline-end
    .result-count             ← "N items" live count
  .data-table-wrap > table.data-table
    thead th × n              ← column headers (i18n keys)
    tbody tr.r-row            ← whole row clickable → open detail
      code · name(+ar) · type·class · count-chip · metric(+overdue) · RAG · status-badge
  .empty-state                ← shown when the filtered result is empty
```

### Cell-decoration vocabulary (reused across columns)

| Cell | Markup | Class(es) |
|------|--------|-----------|
| Code | monospace muted | `.r-code` (app-scoped) |
| Name | bold EN + muted Arabic subline | `.r-name` / `.r-name-ar` (`dir="rtl"`) |
| Type · Class | joined display labels | `.r-tc` (app-scoped) |
| Count (members…) | soft-brand pill | `.avatar.avatar--sm.badge--brand` (platform) |
| Metric (tasks…) | number + red `(n over)` when > 0 | `.is-overdue` (platform) |
| Health | RAG dot + label | `.rag.rag--green/amber/red` (platform) |
| Status | pill | `.badge.badge--active/idle/warning/info` (platform) |

> The `.r-*` cell helpers are the only **app-scoped** styling — keep them in the
> module's `css/app.css` (a handful of lines). **Never** copy the platform
> structural classes into `app.css`.

---

## Reuse recipe (no promote needed)

### 1. View — `views/<list>.html`

```html
<div class="page">
  <div class="page-header-row">
    <h1 class="page-title" data-bind="text: t('mod.list.title')"></h1>
    <div class="page-actions">
      <button class="btn btn-primary" data-bind="click: newItem, text: '+ ' + t('mod.list.new')"></button>
    </div>
  </div>

  <div class="view-toolbar">
    <input class="search-box" type="text"
           data-bind="textInput: fSearch, attr:{placeholder: t('mod.list.search')},
                      event:{ keyup: function(d,e){ if(e.keyCode===13) load(); return true; } }">
    <select class="form-control form-control--sm" data-bind="value: fType, event:{change: load}">
      <option value="" data-bind="text: t('mod.list.allTypes')"></option>
      <!-- ko foreach: types --><option data-bind="value: code, text: nameEn"></option><!-- /ko -->
    </select>
    <!-- …more facet selects… -->
    <span class="toolbar-spacer"></span>
    <!-- ko ifnot: loading -->
    <span class="result-count" data-bind="text: items().length + ' ' + t('mod.list.results')"></span>
    <!-- /ko -->
  </div>

  <!-- ko if: loading --><div class="muted" data-bind="text: t('mod.common.loading')"></div><!-- /ko -->
  <!-- ko ifnot: loading -->
  <!-- ko if: items().length === 0 --><div class="empty-state" data-bind="text: t('mod.list.empty')"></div><!-- /ko -->
  <!-- ko if: items().length > 0 -->
  <div class="data-table-wrap">
    <table class="data-table">
      <thead><tr>
        <th data-bind="text: t('mod.col.code')"></th>
        <th data-bind="text: t('mod.col.name')"></th>
        <!-- …more columns… -->
        <th data-bind="text: t('mod.col.status')"></th>
      </tr></thead>
      <tbody data-bind="foreach: items">
        <tr class="r-row" data-bind="click: function(){ $vm.open($data); }">
          <td><span class="r-code" data-bind="text: $data.code || '—'"></span></td>
          <td><div class="r-name" data-bind="text: nameEn"></div>
              <!-- ko if: $data.nameAr --><div class="r-name-ar" dir="rtl" data-bind="text: $data.nameAr"></div><!-- /ko --></td>
          <td><span class="r-tc" data-bind="text: $data.typeClass || '—'"></span></td>
          <td><span class="avatar avatar--sm badge--brand" data-bind="text: $data.memberCount || 0"></span></td>
          <td><span data-bind="text: $data.taskCount || 0"></span>
              <!-- ko if: ($data.taskOverdue||0) > 0 --> <span class="is-overdue" data-bind="text:'('+$data.taskOverdue+' '+$vm.t('mod.over')+')'"></span><!-- /ko --></td>
          <td><span data-bind="css: $vm.ragClass(health), text: $data.healthLabel || $data.health || '—'"></span></td>
          <td><span class="badge" data-bind="css: $vm.statusClass($data.status), text: $data.statusName || $data.status || '—'"></span></td>
        </tr>
      </tbody>
    </table>
  </div>
  <!-- /ko --><!-- /ko -->
</div>
```

### 2. ViewModel — `viewModels/<list>.js`

Three small helpers do the work; the table cells stay plain so they never throw:

```js
// code -> display name from a loaded lookup array, with code fallback
function labelOf(list, code){
  if(!code) return '';
  var hit=(list()||[]).filter(function(l){return l.code===code;})[0];
  return hit ? hit.nameEn : code;
}
function titleCase(s){ return s ? s.charAt(0).toUpperCase()+s.slice(1).toLowerCase() : ''; }

// decorate each row with display labels for the table cells
function decorate(it){
  it.typeClass  = [labelOf(self.types,it.type), labelOf(self.classes,it['class']),
                   it.category ? labelOf(self.cats,it.category) : ''].filter(Boolean).join(' · ');
  it.statusName = labelOf(self.statuses, it.status);
  it.healthLabel= titleCase(it.health);
  return it;
}

self.load = function(){
  self.loading(true);
  svc.list({ /* filters */ }).then(function(r){ self.items((r.items||[]).map(decorate)); self.loading(false); })
                             .catch(function(){ self.loading(false); });
};

// IMPORTANT: load lookups BEFORE the first list call so codes map to names
svc.boot().then(function(b){ self.types(by(b.lookups,'…')); /* … */ })
          .catch(function(){})
          .then(function(){ self.load(); });

self.ragClass    = function(r){ return 'rag rag--'+String(r||'GREEN').toLowerCase(); };
self.statusClass = function(c){ c=String(c||'').toUpperCase();
  if(c==='ACTIVE') return 'badge--active';
  if(c==='ARCHIVED'||c==='INACTIVE'||c==='CLOSED') return 'badge--idle';
  if(c==='ONHOLD'||c==='PAUSED') return 'badge--warning';
  return 'badge--info'; };
```

### 3. `css/app.css` (app-scoped, ~6 lines)

```css
.r-row{cursor:pointer}
.r-code{font-family:monospace;font-size:12px;color:var(--text-2)}
.r-name{font-weight:700;color:var(--text)}
.r-name-ar{font-size:11px;color:var(--text-3);margin-top:2px}
.r-tc{color:var(--text-2);font-size:12.5px}
```

### 4. i18n

Add the column-header + `results`/`over` keys to **both** `app.en.json` and
`app.ar.json` (a missing key renders the raw key to users).

---

## Gotchas (honour these — each has bitten the suite)

- **Lookups before list:** load lookups first (chain `load()` off the boot promise)
  or `labelOf` falls back to raw codes on the first paint.
- **APEX_JSON skips NULL keys** → bind every optional field as `$data.field`
  (a bare `text: field` throws `ReferenceError` and blanks the whole row).
- **`$vm.` for VM calls inside `foreach`** (`$vm.open`, `$vm.ragClass`,
  `$vm.statusClass`) — `$root` is the shell AppController.
- **Action button top-right** in `.page-header-row` / `.page-actions` — never a
  bottom form bar.
- **Latin digits + RTL** come free from platform.css; the Arabic name subline
  needs `dir="rtl"`.
- This is a **list/result** pattern. The neighbouring **Filter Bar** planned entry
  (facet chips + saved-view selector) is the heavier toolbar; reach for that only
  when simple inline facets aren't enough.

---

## When (not) to use

| Use it for | Reach elsewhere |
|------------|-----------------|
| Any entity list with search + a few facet filters and a tabular result | Card/board views where visual grouping matters → keep cards |
| Rows that open a detail page on click | Heavy faceting / saved views → **Filter Bar** (planned) |
| ≤ a few hundred rows (client filter) or server-paged lists | Inline-editable grids → add `<edit-drawer>` per row |
