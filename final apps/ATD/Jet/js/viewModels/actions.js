define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function Actions() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.rows = ko.observableArray([]);
    self.stats = ko.observable(null);
    self.statusFilter = ko.observable('');

    // server pagination (envelope {items,total,limit,offset}); 20 rows/page
    self.offset = ko.observable(0);
    self.limit = ko.observable(20);
    self.total = ko.observable(0);

    // detail modal
    self.detailOpen = ko.observable(false);
    self.detail = ko.observable(null);
    self.detailPayload = ko.observable('');

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    self.load = function () {
      self.loading(true);
      atd.getActionStats().then(function (s) { self.stats(s); }).catch(function () {});
      atd.listActions({ status: self.statusFilter() || undefined,
                        limit: self.limit(), offset: self.offset() })
        .then(function (r) {
          self.rows(r.items || []);
          self.total(r.total || (r.items || []).length);
          self.loading(false);
        })
        .catch(function () { self.loading(false); });
    };
    self.reload = self.load;                     // pager onChange
    self.load();

    self.setStatus = function (s) { self.statusFilter(s); self.offset(0); self.load(); };

    self.retry = function (row) {
      atd.retryAction(row.actionId)
        .then(function () { toast.success(self.t('atd.actions.retried')); self.load(); })
        .catch(function () {});
    };
    self.cancel = function (row) {
      atd.cancelAction(row.actionId)
        .then(function () { toast.success(self.t('atd.actions.cancelled')); self.load(); })
        .catch(function () {});
    };

    self.openDetail = function (row) {
      atd.getAction(row.actionId).then(function (d) {
        self.detail(d);
        var pretty = d.payloadJson || '';
        try { pretty = JSON.stringify(JSON.parse(d.payloadJson), null, 2); } catch (e) {}
        self.detailPayload(pretty);
        self.detailOpen(true);
      }).catch(function () {});
    };
    self.closeDetail = function () { self.detailOpen(false); self.detail(null); };
  };
});
