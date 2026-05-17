define(['knockout', 'services/authService', 'services/dtService', 'services/approvalService', 'services/settlementService'],
function (ko, authService, dtService, approvalService, settlementService) {
  'use strict';

  function RequestDetailViewModel() {
    var self = this;

    var user   = authService.getCurrentUser();
    var state  = window._dtApp ? window._dtApp.getState() : {};
    var reqId  = state.reqId;

    self.request     = ko.observable(null);
    self.destinations = ko.observableArray([]);
    self.history     = ko.observableArray([]);
    self.settlement  = ko.observable(null);
    self.loading     = ko.observable(true);
    self.error       = ko.observable('');
    self.actionMsg   = ko.observable('');

    // Approval modal
    self.showActionModal  = ko.observable(false);
    self.actionType       = ko.observable('');
    self.actionComments   = ko.observable('');
    self.currentInstanceId = ko.observable(null);
    self.submitting       = ko.observable(false);

    // Role flags
    self.isOwner    = ko.computed(function () { var r = self.request(); return r && r.userId === user.userId; });
    self.isApprover = authService.isApprover();
    self.isDtFinance = authService.isDtFinance();

    // Action availability
    self.canEdit     = ko.computed(function () { var r = self.request(); return r && self.isOwner() && r.status === 'DRAFT'; });
    self.canSubmit   = ko.computed(function () { var r = self.request(); return r && self.isOwner() && r.status === 'DRAFT'; });
    self.canCancel   = ko.computed(function () { var r = self.request(); return r && self.isOwner() && ['DRAFT','SUBMITTED'].includes(r.status); });
    self.canSettle   = ko.computed(function () { var r = self.request(); return r && self.isOwner() && ['ADVANCE_PAID','TRAVELLED'].includes(r.status) && !self.settlement(); });
    self.canApprove  = ko.computed(function () { var r = self.request(); return r && self.isApprover && r.status === 'SUBMITTED'; });
    self.canPayAdv   = ko.computed(function () { var r = self.request(); return r && self.isDtFinance && r.status === 'APPROVED' && r.advanceRequested === 'Y' && !r.advancePaidAt; });

    function _load() {
      if (!reqId) { self.loading(false); return; }
      dtService.getRequest(reqId).then(function (req) {
        self.request(req);
        self.destinations(req.destinations || []);
        return approvalService.getHistoryForRecord(reqId, 'TRAVEL_REQUEST');
      }).then(function (hist) {
        self.history(hist);
        return settlementService.getSettlementForRequest(reqId);
      }).then(function (settle) {
        self.settlement(settle);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    self.goBack = function () { if (window._dtApp) window._dtApp.navigate('myRequests'); };

    self.editRequest = function () {
      if (window._dtApp) window._dtApp.navigate('requestForm', { reqId: reqId });
    };

    self.cancelRequest = function () {
      if (!confirm('Cancel this travel request?')) return;
      dtService.cancelRequest(reqId).then(function () { _load(); });
    };

    self.payAdvance = function () {
      dtService.markAdvancePaid(reqId, user.userId).then(function () { _load(); });
    };

    self.startSettle = function () {
      if (window._dtApp) window._dtApp.navigate('settlementForm', { reqId: reqId });
    };

    // Approval actions
    self.openApproveModal  = function () { self.actionType('APPROVED');  self.actionComments(''); self.showActionModal(true); };
    self.openRejectModal   = function () { self.actionType('REJECTED');  self.actionComments(''); self.showActionModal(true); };
    self.openReturnModal   = function () { self.actionType('RETURNED');  self.actionComments(''); self.showActionModal(true); };
    self.closeActionModal  = function () { self.showActionModal(false); };

    self.submitAction = function () {
      if (!self.currentInstanceId()) return;
      self.submitting(true);
      approvalService.submitAction(self.currentInstanceId(), self.actionType(), self.actionComments(), user.userId)
        .then(function () {
          self.submitting(false);
          self.showActionModal(false);
          self.actionMsg('Action recorded.');
          _load();
        }).catch(function (e) {
          self.submitting(false);
          self.error(e && e.message ? e.message : 'Action failed.');
        });
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    // Resolve pending instance id for approval buttons
    approvalService.getPendingForUser(user).then(function (list) {
      var match = list.find(function (i) { return i.sourceRecordId === reqId && i.requestType === 'TRAVEL_REQUEST'; });
      if (match) self.currentInstanceId(match.instanceId);
    });

    _load();
  }

  return RequestDetailViewModel;
});
