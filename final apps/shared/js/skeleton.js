/**
 * shared/js/skeleton.js — <list-skeleton> Knockout component (Phase 3).
 * Shimmer placeholder rows for the loading leg of the tri-state pattern.
 *
 *   <list-skeleton params="rows: 8"></list-skeleton>
 *   <list-skeleton params="rows: 5, avatar: true"></list-skeleton>
 *   <div class="skeleton sk-block"></div>      <!-- chart/card placeholder -->
 *
 * Styles in shared/css/platform.css (.skeleton / .sk-row / .sk-block).
 */
define(['knockout'], function (ko) {
  'use strict';

  function widths(i) {
    /* deterministic variety so rows don't look stamped */
    var w = [78, 62, 90, 55, 84, 70, 95, 60];
    return w[i % w.length];
  }

  if (!ko.components.isRegistered('list-skeleton')) {
    ko.components.register('list-skeleton', {
      viewModel: function (params) {
        var n = ko.unwrap(params && params.rows) || 6;
        var rows = [];
        for (var i = 0; i < n; i++) rows.push({ w1: widths(i), w2: widths(i + 3), w3: widths(i + 5) });
        this.rows   = rows;
        this.avatar = !!(params && ko.unwrap(params.avatar));
      },
      template:
        '<div class="sk-table" data-bind="foreach: rows">' +
        '  <div class="sk-row">' +
        '    <!-- ko if: $parent.avatar --><div class="skeleton sk-cir"></div><!-- /ko -->' +
        '    <div class="skeleton" data-bind="style: { maxWidth: w1 + \'%\' }"></div>' +
        '    <div class="skeleton" data-bind="style: { maxWidth: w2 + \'%\' }"></div>' +
        '    <div class="skeleton" data-bind="style: { maxWidth: w3 + \'%\' }"></div>' +
        '  </div>' +
        '</div>'
    });
  }

  return {};
});
