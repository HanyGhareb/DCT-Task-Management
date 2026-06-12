define(['knockout', 'services/ccService', 'services/authService'],
function (ko, ccService, authService) {
  'use strict';

  function RequestsViewModel() {
    var self = this;

    self.isAdmin   = authService.isCcAdmin();
    self.scope     = ko.observable(self.isAdmin ? 'all' : 'mine');
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);
    self.total     = ko.observable(0);
    self.limit     = ko.observable(25);
    self.offset    = ko.observable(0);
    self.statusFilter = ko.observable('');
    self.typeFilter   = ko.observable('');

    self.reload = function (offset) {
      if (typeof offset === 'number') self.offset(offset);
      self.loading(true);
      self.loadError(false);
      ccService.getRequests({
        mine:   self.scope() === 'mine' ? 'Y' : '',
        status: self.statusFilter(),
        type:   self.typeFilter(),
        limit:  self.limit(),
        offset: self.offset()
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };

    self.statusFilter.subscribe(function () { self.reload(0); });
    self.typeFilter.subscribe(function () { self.reload(0); });
    self.setScope = function (s) { self.scope(s); self.reload(0); };

    self.newRequest = function () {
      if (window._jetApp) window._jetApp.navigate('requestNew');
    };
    self.openDetail = function (row) {
      if (window._jetApp) window._jetApp.navigate('requestDetail', { requestId: row.requestId });
    };

    self.statusBadge = function (s) {
      var map = { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', UNDER_REVIEW: 'badge--underreview',
                  RETURNED: 'badge--returned', APPROVED: 'badge--approved', REJECTED: 'badge--rejected',
                  WITHDRAWN: 'badge--withdrawn' };
      return 'badge ' + (map[s] || 'badge--idle');
    };
    self.typeLabel = function (t) { return (t || '').replace(/_/g, ' '); };

    self.reload();
  }

  return RequestsViewModel;
});
