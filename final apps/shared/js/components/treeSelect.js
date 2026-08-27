/* ── shared/js/components/treeSelect.js ──────────────────────────────────────
   <tree-select> — Oracle-JET-tree-view-style multi-select tree (Knockout
   custom component, no JET runtime). Renders a hierarchy with expand/collapse
   arrows and TRI-STATE checkboxes (a parent check selects every descendant
   leaf; partial selections show the indeterminate dash), plus a type-to-filter
   box that auto-expands to the matches. Only LEAF nodes enter the selection;
   group nodes exist to select their leaves in one click. The flattened-row
   renderer keeps it fast and RTL-safe (logical padding). Structural styles =
   .tv-* in shared/css/platform.css.

   Register at boot by requiring 'shared/components/treeSelect'.

   Usage:
     <tree-select params="nodes: gsNodes, selected: gsPicked,
                          filterPh: t('gsFilter'), emptyText: t('noData')">
     </tree-select>

   Params:
     nodes     ko.observableArray|array  required — root nodes. Node shape:
               { key:'unique', label:'text', sub:'muted suffix (optional)',
                 has:bool (optional recipient flag — false shows an amber dot),
                 children:[...] (present = group node, absent = LEAF) }
     selected  ko.observableArray        required — LEAF keys, two-way
     filterPh  string|observable         optional — filter placeholder
     emptyText string|observable         optional — no-rows text                */
define(['knockout'], function (ko) {
  'use strict';

  if (!ko.components.isRegistered('tree-select')) {

    function leafKeys(node, out) {
      if (node.children && node.children.length) {
        for (var i = 0; i < node.children.length; i++) leafKeys(node.children[i], out);
      } else if (!node.children) {
        out.push(node.key);
      }
      return out;
    }

    function TreeSelectVM(params) {
      var self = this;
      self.nodes = ko.isObservable(params.nodes) ? params.nodes : ko.observableArray(params.nodes || []);
      self.selected = params.selected;                       // observableArray of leaf keys
      self.filter = ko.observable('');
      self.filterPh = params.filterPh || 'Filter…';
      self.emptyText = params.emptyText || 'No data';
      self._exp = {};                                        // key -> expanded?
      self._bump = ko.observable(0);                         // expansion version

      function isExpanded(node, depth, filtering) {
        if (filtering) return true;                          // filter shows its matches
        var v = self._exp[node.key];
        return v === undefined ? depth === 0 : v;            // roots start open
      }

      function matches(node, f) {
        if (!f) return true;
        if ((String(node.label || '') + ' ' + String(node.sub || '')).toLowerCase().indexOf(f) >= 0) return true;
        if (node.children) {
          for (var i = 0; i < node.children.length; i++) if (matches(node.children[i], f)) return true;
        }
        return false;
      }

      self.rows = ko.computed(function () {
        self._bump();
        var f = (self.filter() || '').trim().toLowerCase();
        var sel = {};
        (self.selected() || []).forEach(function (k) { sel[k] = 1; });
        var out = [];
        function walk(node, depth) {
          if (!matches(node, f)) return;
          var isLeaf = !node.children;
          var state;
          if (isLeaf) {
            state = sel[node.key] ? 'on' : 'off';
          } else {
            var lk = leafKeys(node, []), n = 0;
            for (var i = 0; i < lk.length; i++) if (sel[lk[i]]) n++;
            state = n === 0 ? 'off' : (n === lk.length && lk.length > 0 ? 'on' : 'part');
          }
          var exp = isExpanded(node, depth, !!f);
          out.push({ n: node, key: node.key, label: node.label, sub: node.sub || '',
                     depth: depth, isLeaf: isLeaf, exp: exp, state: state,
                     noRcpt: node.has === false });
          if (!isLeaf && exp) {
            for (var j = 0; j < node.children.length; j++) walk(node.children[j], depth + 1);
          }
        }
        (self.nodes() || []).forEach(function (r) { walk(r, 0); });
        return out;
      });

      self.selCount = ko.computed(function () { return (self.selected() || []).length; });

      self.toggleExp = function (row) {
        if (row.isLeaf) return true;
        self._exp[row.key] = !row.exp;
        self._bump(self._bump() + 1);
        return false;
      };

      self.toggleCheck = function (row) {
        var keys = row.isLeaf ? [row.key] : leafKeys(row.n, []);
        var cur = self.selected() || [], have = {};
        cur.forEach(function (k) { have[k] = 1; });
        if (row.state === 'on') {
          var drop = {};
          keys.forEach(function (k) { drop[k] = 1; });
          self.selected(cur.filter(function (k) { return !drop[k]; }));
        } else {
          var add = keys.filter(function (k) { return !have[k]; });
          self.selected(cur.concat(add));
        }
        return false;
      };
    }

    ko.components.register('tree-select', {
      viewModel: TreeSelectVM,
      template:
        '<div class="tv">' +
        '  <input class="form-control tv-filter" type="text"' +
        '         data-bind="textInput: filter, attr: { placeholder: filterPh }">' +
        '  <div class="tv-body" data-bind="foreach: { data: rows, as: \'row\' }">' +
        '    <div class="tv-row" data-bind="click: function () { return $parent.toggleCheck(row); }, clickBubble: false,' +
        '                                   css: { \'tv-on\': row.state === \'on\', \'tv-leaf\': row.isLeaf },' +
        '                                   style: { paddingInlineStart: (row.depth * 22 + 6) + \'px\' }">' +
        '      <span class="tv-tg" data-bind="click: function () { return $parent.toggleExp(row); }, clickBubble: false,' +
        '                                     css: { open: row.exp, blank: row.isLeaf }">▸</span>' +
        '      <span class="tv-cb" data-bind="css: { on: row.state === \'on\', part: row.state === \'part\' }"></span>' +
        '      <span class="tv-ic" data-bind="css: row.isLeaf ? \'tv-ic--doc\' : \'tv-ic--folder\'"></span>' +
        '      <span class="tv-lb"><span data-bind="text: row.label"></span>' +
        '        <!-- ko if: row.sub --><small class="tv-sub" data-bind="text: row.sub"></small><!-- /ko -->' +
        '        <!-- ko if: row.noRcpt --><span class="tv-nr" title="No recipient list">!</span><!-- /ko -->' +
        '      </span>' +
        '    </div>' +
        '  </div>' +
        '  <!-- ko if: rows().length === 0 -->' +
        '  <div class="tv-empty" data-bind="text: emptyText"></div>' +
        '  <!-- /ko -->' +
        '  <div class="tv-foot"><span data-bind="text: selCount()"></span> ✓</div>' +
        '</div>'
    });
  }

  return {};
});
