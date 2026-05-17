define(['knockout', 'services/authService', 'services/dtService'],
function (ko, authService, dtService) {
  'use strict';

  function DisbursementQueueViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.items     = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');
    self.actionMsg = ko.observable('');

    self.payAdvance = function (req) {
      if (!confirm('Confirm advance payment of ' + self.fmt(req.advanceAmount) + ' AED for ' + req.reqNumber + '?')) return;
      dtService.markAdvancePaid(req.reqId, user.userId).then(function () {
        self.actionMsg('Advance marked as paid for ' + req.reqNumber + '.');
        _load();
      }).catch(function (e) { self.error(e && e.message ? e.message : 'Payment failed.'); });
    };

    self.viewDetail = function (req) {
      if (window._dtApp) window._dtApp.navigate('requestDetail', { reqId: req.reqId });
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    function _load() {
      self.loading(true);
      dtService.getDisbursementQueue().then(function (list) {
        self.items(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    _load();
  }

  return DisbursementQueueViewModel;
});
