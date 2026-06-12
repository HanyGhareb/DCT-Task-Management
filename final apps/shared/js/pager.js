/**
 * shared/js/pager.js — <list-pager> Knockout component (Phase 3).
 * The single pagination control for every server-paged list.
 *
 * Envelope mode (Admin users/audit, PC all, DT all — {items,total,limit,offset}):
 *   <list-pager params="offset: offset, limit: limit, total: total,
 *                       onChange: reload"></list-pager>
 *
 * hasMore mode (HR employees — ORDS-native {items,hasMore,offset,limit}):
 *   <list-pager params="offset: offset, limit: limit, hasMore: hasMore,
 *                       onChange: reload"></list-pager>
 *
 * params.offset/.limit are ko.observables owned by the host VM; the pager
 * mutates them then calls onChange(). Page-size choices: 25 / 50 / 100.
 */
define(['knockout', 'shared/i18n'], function (ko, i18n) {
  'use strict';

  function PagerVM(params) {
    var self = this;
    self.t       = i18n.t;
    self.offset  = params.offset;
    self.limit   = params.limit;
    self.total   = params.total   || null;   // observable or absent (hasMore mode)
    self.hasMore = params.hasMore || null;
    var onChange = params.onChange || function () {};

    self.page = ko.pureComputed(function () {
      return Math.floor(ko.unwrap(self.offset) / Math.max(1, ko.unwrap(self.limit))) + 1;
    });
    self.pages = ko.pureComputed(function () {
      if (!self.total) return null;
      return Math.max(1, Math.ceil(ko.unwrap(self.total) / Math.max(1, ko.unwrap(self.limit))));
    });
    self.rangeText = ko.pureComputed(function () {
      var off = ko.unwrap(self.offset), lim = ko.unwrap(self.limit);
      if (self.total) {
        var tot = ko.unwrap(self.total);
        var from = tot ? off + 1 : 0;
        var to = Math.min(off + lim, tot);
        return i18n.t('pager.range', [from, to, tot]);
      }
      return i18n.t('pager.rangeOpen', [off + 1, off + lim]);
    });
    self.numText = ko.pureComputed(function () {
      return self.pages() ? self.page() + ' / ' + self.pages() : String(self.page());
    });
    self.prevDisabled = ko.pureComputed(function () { return ko.unwrap(self.offset) <= 0; });
    self.nextDisabled = ko.pureComputed(function () {
      if (self.total)   return ko.unwrap(self.offset) + ko.unwrap(self.limit) >= ko.unwrap(self.total);
      if (self.hasMore) return !ko.unwrap(self.hasMore);
      return false;
    });

    self.prev = function () {
      if (self.prevDisabled()) return;
      self.offset(Math.max(0, ko.unwrap(self.offset) - ko.unwrap(self.limit)));
      onChange();
    };
    self.next = function () {
      if (self.nextDisabled()) return;
      self.offset(ko.unwrap(self.offset) + ko.unwrap(self.limit));
      onChange();
    };
    /* String proxy for the <select> — KO's value binding selects the matching
       <option>; the old attr:{value} wrote a dead attribute so the dropdown
       always DISPLAYED "25" regardless of the real page size. */
    self.limitSel = ko.pureComputed({
      read:  function ()  { return String(ko.unwrap(self.limit)); },
      write: function (v) {
        var n = parseInt(v, 10) || 50;
        if (n === ko.unwrap(self.limit)) return;
        self.limit(n);
        self.offset(0);
        onChange();
      }
    });
  }

  if (!ko.components.isRegistered('list-pager')) {
    ko.components.register('list-pager', {
      viewModel: PagerVM,
      template:
        '<div class="pager">' +
        '  <span class="pager__info" data-bind="text: rangeText"></span>' +
        '  <span class="pager__grow"></span>' +
        '  <label class="pager__size-lbl" data-bind="text: t(\'pager.perPage\')"></label>' +
        '  <select data-bind="value: limitSel">' +
        '    <option value="25">25</option><option value="50">50</option><option value="100">100</option>' +
        '  </select>' +
        '  <button class="pager__btn" data-bind="click: prev, disable: prevDisabled"><span>&#8249;</span></button>' +
        '  <span class="pager__num" data-bind="text: numText"></span>' +
        '  <button class="pager__btn" data-bind="click: next, disable: nextDisabled"><span>&#8250;</span></button>' +
        '</div>'
    });
  }

  return {};
});
