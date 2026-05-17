define(['knockout', 'services/authService', 'services/settlementService'],
function (ko, authService, settlementService) {
  'use strict';

  function ClosureQueueViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.items     = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');
    self.actionMsg = ko.observable('');

    self.closeSettlement = function (settle) {
      if (!confirm('Close settlement ' + settle.settleNumber + '? This will mark the travel request as CLOSED.')) return;
      settlementService.closeSettlement(settle.settleId, user.userId).then(function () {
        self.actionMsg('Settlement ' + settle.settleNumber + ' closed.');
        _load();
      }).catch(function (e) { self.error(e && e.message ? e.message : 'Closure failed.'); });
    };

    self.viewDetail = function (settle) {
      if (window._dtApp) window._dtApp.navigate('settlementForm', { settleId: settle.settleId });
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    function _load() {
      self.loading(true);
      settlementService.getClosureQueue().then(function (list) {
        self.items(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    _load();
  }

  return ClosureQueueViewModel;
});
