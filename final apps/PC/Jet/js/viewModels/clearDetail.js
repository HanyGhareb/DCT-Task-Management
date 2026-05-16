define(['knockout', 'services/authService', 'services/clearService', 'services/pcService', 'services/reimbService'],
function (ko, authService, clearService, pcService, reimbService) {
  'use strict';

  function ClearDetailViewModel() {
    var self = this;

    var user      = authService.getCurrentUser();
    var state     = window._pcApp ? window._pcApp.getState() : {};
    var clearingId = state.clearingId || null;
    var pcId       = state.pcId || null;
    self.isEdit    = !!clearingId;

    self.clearingNumber = ko.observable('');
    self.pcRecord       = ko.observable(null);
    self.amountRefunded = ko.observable('0');
    self.codingType     = ko.observable('GL');
    self.status         = ko.observable('DRAFT');

    self.saving  = ko.observable(false);
    self.loading = ko.observable(true);
    self.error   = ko.observable('');
    self.success = ko.observable('');

    self.glCodes     = ko.observableArray([]);
    self.projectData = ko.observableArray([]);
    self.projectNumbers = ko.observableArray([]);
    self.budgetLines = ko.observableArray([]);

    self.isReadOnly = ko.computed(function () { return self.isEdit && self.status() !== 'DRAFT'; });

    function makeLine() {
      return {
        amount:          ko.observable(''),
        entityCode:      ko.observable(''),
        appropriation:   ko.observable(''),
        costCenter:      ko.observable(''),
        entitySpecific:  ko.observable(''),
        budgetGroupCode: ko.observable(''),
        account:         ko.observable(''),
        ic:              ko.observable(''),
        projectNumber:   ko.observable(''),
        taskNumber:      ko.observable(''),
        expenditureType: ko.observable(''),
        description:     ko.observable(''),
      };
    }

    self.addLine    = function () { self.budgetLines.push(makeLine()); };
    self.removeLine = function (l) { self.budgetLines.remove(l); };

    // Amount spent = sum of budget lines
    self.amountSpent = ko.computed(function () {
      return self.budgetLines().reduce(function(s,l){ return s + (parseFloat(l.amount()) || 0); }, 0);
    });

    self.totalCheck = ko.computed(function () {
      var pc = self.pcRecord();
      if (!pc) return null;
      return self.amountSpent() + (parseFloat(self.amountRefunded()) || 0);
    });

    self.totalMismatch = ko.computed(function () {
      var pc = self.pcRecord();
      if (!pc) return false;
      var total = self.totalCheck();
      return total !== null && Math.abs(total - pc.amount) > 0.01;
    });

    self.fmtAmount = function (n) { return n != null ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };

    function _validate() {
      var pc = self.pcRecord();
      if (!pc || pc.status !== 'ACTIVE') return 'Parent petty cash must be Active.';
      if (self.budgetLines().length === 0) return 'At least one expense line is required.';
      if (parseFloat(self.amountRefunded()) < 0) return 'Refund amount cannot be negative.';
      if (self.totalMismatch()) return 'Amount Spent + Amount Refunded must equal the advance amount (' + self.fmtAmount(pc.amount) + ' AED).';
      return null;
    }

    self.saveForm = function () {
      self.error('');
      var err = _validate();
      if (err) { self.error(err); return; }
      self.saving(true);
      var payload = {
        pcId:           pcId || (self.pcRecord() && self.pcRecord().pcId),
        amountSpent:    self.amountSpent(),
        amountRefunded: parseFloat(self.amountRefunded()) || 0,
        codingType:     self.codingType(),
        budgetLines:    self.budgetLines().map(function(l){
          return {
            codingType: self.codingType(),
            amount: parseFloat(l.amount()) || 0,
            entityCode: l.entityCode(), appropriation: l.appropriation(), costCenter: l.costCenter(),
            entitySpecific: l.entitySpecific(), budgetGroupCode: l.budgetGroupCode(), account: l.account(), ic: l.ic(),
            projectNumber: l.projectNumber(), taskNumber: l.taskNumber(), expenditureType: l.expenditureType(),
            description: l.description(),
          };
        }),
      };
      var action = self.isEdit ? clearService.update(clearingId, payload) : clearService.create(payload);
      action.then(function (rec) {
        self.saving(false);
        self.success('Clearing request ' + (self.isEdit ? 'updated' : 'submitted') + ' — ' + rec.clearingNumber);
        setTimeout(function () { if (window._pcApp) window._pcApp.navigate('clearing'); }, 1500);
      }).catch(function (err) {
        self.saving(false);
        self.error((err && err.message) || 'Save failed.');
      });
    };

    self.cancel = function () { if (window._pcApp) window._pcApp.navigate('clearing'); };

    function _load() {
      pcService.getGlCodes().then(function (codes) { self.glCodes(codes); });
      pcService.getProjectBudget().then(function (data) {
        self.projectData(data);
        var projs = data.map(function(p){ return p.projectNumber; }).filter(function(v,i,a){ return a.indexOf(v) === i; }).sort();
        self.projectNumbers(projs);
      });

      var targetPcId = pcId;
      if (self.isEdit) {
        clearService.getById(clearingId).then(function (rec) {
          if (rec) {
            self.clearingNumber(rec.clearingNumber);
            self.amountRefunded(rec.amountRefunded);
            self.codingType(rec.codingType);
            self.status(rec.status);
            targetPcId = rec.pcId;
          }
        });
        clearService.getBudgetLines(clearingId).then(function (lines) {
          lines.forEach(function(l) {
            var line = makeLine();
            line.amount(l.amount); line.description(l.description || '');
            if (l.codingType === 'GL') {
              line.entityCode(l.entityCode||''); line.appropriation(l.appropriation||'');
              line.costCenter(l.costCenter||''); line.entitySpecific(l.entitySpecific||'');
              line.budgetGroupCode(l.budgetGroupCode||''); line.account(l.account||''); line.ic(l.ic||'');
            } else {
              line.projectNumber(l.projectNumber||''); line.taskNumber(l.taskNumber||''); line.expenditureType(l.expenditureType||'');
            }
            self.budgetLines.push(line);
          });
        });
      } else {
        self.budgetLines.push(makeLine());
      }

      if (targetPcId) {
        pcService.getById(targetPcId).then(function (rec) {
          self.pcRecord(rec);
          if (rec) self.codingType(rec.codingType);
          self.loading(false);
        });
      } else {
        self.loading(false);
      }
    }

    _load();
  }

  return ClearDetailViewModel;
});
