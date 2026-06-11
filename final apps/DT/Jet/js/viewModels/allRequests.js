define(['knockout', 'services/authService', 'services/dtService', 'shared/i18n'],
function (ko, authService, dtService, i18n) {
  'use strict';

  function AllRequestsViewModel() {
    var self = this;
    self.t = i18n.t;

    // ── tri-state + server paging (Phase 3) ──────────────────────────────
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.requests  = ko.observableArray([]);

    self.searchText   = ko.observable('');
    self.statusFilter = ko.observable('');
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      dtService.getAllPage({
        limit:  self.limit(),
        offset: self.offset(),
        search: self.searchText().trim() || null,
        status: self.statusFilter() || null
      }).then(function (r) {
        self.requests(r.items);
        self.total(r.total);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
    };

    self.searchText.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.searchText.subscribe(function () { self.offset(0); self.reload(); });
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.openDetail = function (req) {
      if (window._dtApp) window._dtApp.navigate('requestDetail', { reqId: req.reqId });
    };

    self.fmt = function (n) { return i18n.fmtNum(n || 0, 2); };

    self.reload();
  }

  return AllRequestsViewModel;
});
