define(['knockout', 'services/authService', 'services/approvalService'],
function (ko, authService, approvalService) {
  'use strict';

  function ApprovalsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.items       = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.searchText  = ko.observable('');
    self.typeFilter  = ko.observable('');

    // Approval modal
    self.showModal    = ko.observable(false);
    self.selectedItem = ko.observable(null);
    self.actionType   = ko.observable('');
    self.comments     = ko.observable('');
    self.submitting   = ko.observable(false);
    self.error        = ko.observable('');

    self.filtered = ko.computed(function () {
      var q  = self.searchText().toLowerCase();
      var tf = self.typeFilter();
      return self.items().filter(function (i) {
        var matchQ = !q || i.requestRef.toLowerCase().includes(q) || i.submittedBy.toLowerCase().includes(q);
        var matchT = !tf || i.requestType === tf;
        return matchQ && matchT;
      });
    });

    self.openApprove = function (item) { self.selectedItem(item); self.actionType('APPROVED'); self.comments(''); self.error(''); self.showModal(true); };
    self.openReject  = function (item) { self.selectedItem(item); self.actionType('REJECTED'); self.comments(''); self.error(''); self.showModal(true); };
    self.openReturn  = function (item) { self.selectedItem(item); self.actionType('RETURNED'); self.comments(''); self.error(''); self.showModal(true); };
    self.closeModal  = function ()     { self.showModal(false); };

    self.viewDetail = function (item) {
      if (!window._dtApp) return;
      if (item.requestType === 'TRAVEL_REQUEST') {
        window._dtApp.navigate('requestDetail', { reqId: item.sourceRecordId });
      } else if (item.requestType === 'SETTLEMENT') {
        window._dtApp.navigate('settlementForm', { settleId: item.sourceRecordId });
      }
    };

    self.submitAction = function () {
      var item = self.selectedItem();
      if (!item) return;
      self.submitting(true);
      approvalService.submitAction(item.instanceId, self.actionType(), self.comments(), user.userId)
        .then(function () {
          self.submitting(false);
          self.showModal(false);
          _load();
        }).catch(function (e) {
          self.submitting(false);
          self.error(e && e.message ? e.message : 'Action failed.');
        });
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    function _load() {
      approvalService.getPendingForUser(user).then(function (list) {
        self.items(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    _load();
  }

  return ApprovalsViewModel;
});
