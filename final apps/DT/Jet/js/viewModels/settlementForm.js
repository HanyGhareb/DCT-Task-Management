define(['knockout', 'services/authService', 'services/dtService', 'services/settlementService', 'services/approvalService'],
function (ko, authService, dtService, settlementService, approvalService) {
  'use strict';

  function SettlementFormViewModel() {
    var self = this;

    var user     = authService.getCurrentUser();
    var state    = window._dtApp ? window._dtApp.getState() : {};
    var reqId    = state.reqId;
    var settleId = state.settleId;
    var isView   = !!settleId && !reqId;

    self.isView      = ko.observable(isView);
    self.request     = ko.observable(null);
    self.settleNumber = ko.observable('');
    self.loading     = ko.observable(true);
    self.saving      = ko.observable(false);
    self.error       = ko.observable('');
    self.successMsg  = ko.observable('');

    // Fields
    self.actualDeparture     = ko.observable('');
    self.actualReturn        = ko.observable('');
    self.actualDays          = ko.observable(0);
    self.actualPerDiemTotal  = ko.observable(0);
    self.additionalExpenses  = ko.observable(0);
    self.advanceAmount       = ko.observable(0);
    self.notes               = ko.observable('');

    // Extra expense lines
    self.expenseLines = ko.observableArray([]);

    // Computed totals
    self.totalSettlement = ko.computed(function () {
      return parseFloat(self.actualPerDiemTotal()) + parseFloat(self.additionalExpenses());
    });
    self.netPayable = ko.computed(function () {
      var diff = self.totalSettlement() - parseFloat(self.advanceAmount());
      return diff > 0 ? diff : 0;
    });
    self.netRefund = ko.computed(function () {
      var diff = parseFloat(self.advanceAmount()) - self.totalSettlement();
      return diff > 0 ? diff : 0;
    });

    // Recalculate per diem from actual days and request rate
    self.actualReturn.subscribe(function (val) {
      var from = self.actualDeparture(); var to = val;
      if (from && to && self.request()) {
        var days = Math.max(0, Math.round((new Date(to) - new Date(from)) / 86400000) + 1);
        self.actualDays(days);
        // Use estimated daily rate from request destinations
        var dests = self.request().destinations || [];
        var avgRate = dests.length ? dests.reduce(function(s,d){ return s + d.dailyRateAed; }, 0) / dests.length : 0;
        self.actualPerDiemTotal(Math.round(days * avgRate));
      }
    });

    self.addExpenseLine = function () {
      self.expenseLines.push({ description: ko.observable(''), amount: ko.observable(0) });
    };
    self.removeExpenseLine = function (line) { self.expenseLines.remove(line); };

    // Watch expense lines total
    self.expenseLines.subscribe(function () {
      var total = self.expenseLines().reduce(function(s,l){ return s + (parseFloat(l.amount()) || 0); }, 0);
      self.additionalExpenses(total);
    });

    function _load() {
      if (settleId) {
        settlementService.getSettlement(settleId).then(function (settle) {
          self.settleNumber(settle.settleNumber);
          self.actualDeparture(settle.actualDeparture);
          self.actualReturn(settle.actualReturn);
          self.actualDays(settle.actualDays);
          self.actualPerDiemTotal(settle.actualPerDiemTotal);
          self.additionalExpenses(settle.additionalExpenses);
          self.advanceAmount(settle.advanceAmount);
          self.notes(settle.notes || '');
          // Load expense lines
          var expLines = (settle.lines || []).filter(function(l){ return l.lineType === 'EXPENSE'; });
          self.expenseLines(expLines.map(function(l){ return { description: ko.observable(l.description), amount: ko.observable(l.amount) }; }));
          return dtService.getRequest(settle.reqId);
        }).then(function (req) {
          self.request(req);
          self.loading(false);
        }).catch(function () { self.loading(false); });
      } else if (reqId) {
        dtService.getRequest(reqId).then(function (req) {
          self.request(req);
          self.advanceAmount(req.advanceAmount || 0);
          self.actualDeparture(req.departureDate || '');
          self.actualReturn(req.returnDate || '');
          self.loading(false);
        }).catch(function () { self.loading(false); });
      }
    }

    function _buildPayload(status) {
      var lines = [];
      // Per diem lines from destinations
      var dests = self.request() ? (self.request().destinations || []) : [];
      dests.forEach(function(d) {
        lines.push({ lineType: 'PERDIEM', destId: d.destId || null, description: 'Per diem — ' + d.countryName + ' × ' + d.days + ' days', amount: d.amount });
      });
      // Expense lines
      self.expenseLines().forEach(function(l) {
        if (l.description() && l.amount()) lines.push({ lineType: 'EXPENSE', destId: null, description: l.description(), amount: parseFloat(l.amount()) });
      });
      return {
        reqId:               reqId || (self.request() ? self.request().reqId : null),
        actualDeparture:     self.actualDeparture(),
        actualReturn:        self.actualReturn(),
        actualDays:          parseInt(self.actualDays()) || 0,
        actualPerDiemTotal:  parseFloat(self.actualPerDiemTotal()) || 0,
        additionalExpenses:  parseFloat(self.additionalExpenses()) || 0,
        totalSettlement:     self.totalSettlement(),
        advanceAmount:       parseFloat(self.advanceAmount()) || 0,
        netRefund:           self.netRefund(),
        netPayable:          self.netPayable(),
        notes:               self.notes(),
        status:              status,
        lines:               lines,
      };
    }

    self.saveDraft = function () {
      self.error(''); self.saving(true);
      var payload = _buildPayload('DRAFT');
      var p = settleId ? settlementService.updateSettlement(settleId, payload) : settlementService.createSettlement(payload);
      p.then(function () { self.saving(false); if (window._dtApp) window._dtApp.navigate('mySettlements'); })
       .catch(function(e){ self.saving(false); self.error(e && e.message ? e.message : 'Save failed.'); });
    };

    self.submit = function () {
      self.error(''); self.saving(true);
      var payload = _buildPayload('SUBMITTED');
      var p = settleId ? settlementService.updateSettlement(settleId, payload) : settlementService.createSettlement(payload);
      p.then(function (settle) {
        return approvalService.startWorkflow('DT_SETTLEMENT', 'SETTLEMENT', settle.settleId, settle.settleNumber, user.userId);
      }).then(function () {
        // Mark request as SETTLED
        var rId = reqId || (self.request() ? self.request().reqId : null);
        if (rId) return dtService.updateRequest(rId, { status: 'SETTLED' });
      }).then(function () {
        self.saving(false);
        if (window._dtApp) window._dtApp.navigate('mySettlements');
      }).catch(function(e){ self.saving(false); self.error(e && e.message ? e.message : 'Submit failed.'); });
    };

    self.goBack = function () { if (window._dtApp) window._dtApp.navigate('mySettlements'); };
    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    _load();
  }

  return SettlementFormViewModel;
});
