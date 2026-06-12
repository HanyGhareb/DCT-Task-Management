define(['knockout', 'services/ccService', 'services/authService', 'shared/toast'],
function (ko, ccService, authService, toast) {
  'use strict';

  function RequestDetailViewModel() {
    var self = this;
    var state = (window._jetApp && window._jetApp.getState()) || {};
    var id = state.requestId;

    self.loading = ko.observable(true);
    self.data    = ko.observable(null);
    self.docs    = ko.observableArray([]);
    self.busy    = ko.observable(false);

    function load() {
      if (!id) { self.loading(false); return; }
      Promise.all([
        ccService.getRequest(id),
        ccService.getDocuments('REQUEST', id)
      ]).then(function (res) {
        self.data(res[0]);
        self.docs(res[1]);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    load();

    self.canSubmit = ko.computed(function () {
      var d = self.data();
      return d && (d.status === 'DRAFT' || d.status === 'RETURNED');
    });
    self.canWithdraw = ko.computed(function () {
      var d = self.data();
      var me = authService.getCurrentUser();
      if (!d || !me) return false;
      return (d.status === 'SUBMITTED' || d.status === 'UNDER_REVIEW')
          && (d.createdBy === me.username || authService.isCcAdmin());
    });

    self.submit = function () {
      self.busy(true);
      ccService.submitRequest(id).then(function () {
        self.busy(false);
        toast.success('Request submitted for approval.');
        load();
      }).catch(function () { self.busy(false); });
    };

    self.withdraw = function () {
      self.busy(true);
      ccService.withdrawRequest(id).then(function () {
        self.busy(false);
        toast.success('Request withdrawn.');
        load();
      }).catch(function () { self.busy(false); });
    };

    self.statusBadge = function (s) {
      var map = { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', UNDER_REVIEW: 'badge--underreview',
                  RETURNED: 'badge--returned', APPROVED: 'badge--approved', REJECTED: 'badge--rejected',
                  WITHDRAWN: 'badge--withdrawn' };
      return 'badge ' + (map[s] || 'badge--idle');
    };
    self.typeLabel = function (t) { return (t || '').replace(/_/g, ' '); };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('requests'); };
  }

  return RequestDetailViewModel;
});
