define(['knockout', 'services/authService', 'services/reimbService', 'services/pcService'],
function (ko, authService, reimbService, pcService) {
  'use strict';

  function ReimbDetailViewModel() {
    var self = this;

    var user  = authService.getCurrentUser();
    var state = window._pcApp ? window._pcApp.getState() : {};
    var reimbId = state.reimbId || null;
    var pcId    = state.pcId    || null;
    self.isEdit = !!reimbId;

    self.reimbNumber = ko.observable('');
    self.pcRecord    = ko.observable(null);
    self.amount      = ko.observable('');
    self.purpose     = ko.observable('');
    self.codingType  = ko.observable('GL');
    self.status      = ko.observable('DRAFT');

    self.saving  = ko.observable(false);
    self.loading = ko.observable(true);
    self.error   = ko.observable('');
    self.success = ko.observable('');

    self.glCodes     = ko.observableArray([]);
    self.projectData = ko.observableArray([]);
    self.projectNumbers   = ko.observableArray([]);
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
        fundAvailable:   ko.observable(null),
        description:     ko.observable(''),
      };
    }

    self.addLine    = function () { self.budgetLines.push(makeLine()); };
    self.removeLine = function (l) { self.budgetLines.remove(l); };

    self.lineTotal = ko.computed(function () {
      return self.budgetLines().reduce(function(s,l){ return s + (parseFloat(l.amount()) || 0); }, 0);
    });
    self.amountMismatch = ko.computed(function () {
      var req = parseFloat(self.amount()) || 0;
      return req > 0 && Math.abs(self.lineTotal() - req) > 0.01;
    });

    self.fmtAmount = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };

    function _validate() {
      if (!self.amount() || parseFloat(self.amount()) <= 0) return 'Amount must be greater than 0.';
      if (!self.purpose()) return 'Purpose is required.';
      if (self.budgetLines().length === 0) return 'At least one budget line is required.';
      if (self.amountMismatch()) return 'Budget lines must sum to the reimbursement amount.';
      var pc = self.pcRecord();
      if (!pc || pc.status !== 'ACTIVE') return 'Parent petty cash must be Active.';
      if (parseFloat(self.amount()) > pc.currentFloatBalance) return 'Amount exceeds current float balance (' + self.fmtAmount(pc.currentFloatBalance) + ' AED).';
      return null;
    }

    self.saveForm = function () {
      self.error('');
      var err = _validate();
      if (err) { self.error(err); return; }
      self.saving(true);
      var payload = {
        pcId:       pcId || (self.pcRecord() && self.pcRecord().pcId),
        amount:     parseFloat(self.amount()),
        purpose:    self.purpose(),
        codingType: self.codingType(),
        budgetLines: self.budgetLines().map(function(l){
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
      var action = self.isEdit ? reimbService.update(reimbId, payload) : reimbService.create(payload);
      action.then(function (rec) {
        self.saving(false);
        self.success('Reimbursement ' + (self.isEdit ? 'updated' : 'submitted') + ' — ' + rec.reimbNumber);
        setTimeout(function () {
          if (window._pcApp) window._pcApp.navigate('reimbursements');
        }, 1500);
      }).catch(function (err) {
        self.saving(false);
        self.error((err && err.message) || 'Save failed.');
      });
    };

    self.cancel = function () { if (window._pcApp) window._pcApp.navigate('reimbursements'); };

    function _load() {
      pcService.getGlCodes().then(function (codes) { self.glCodes(codes); });
      pcService.getProjectBudget().then(function (data) {
        self.projectData(data);
        var projs = data.map(function(p){ return p.projectNumber; }).filter(function(v,i,a){ return a.indexOf(v) === i; }).sort();
        self.projectNumbers(projs);
      });

      var targetPcId = pcId;
      if (self.isEdit) {
        reimbService.getById(reimbId).then(function (rec) {
          if (rec) {
            self.reimbNumber(rec.reimbNumber);
            self.amount(rec.amount);
            self.purpose(rec.purpose);
            self.codingType(rec.codingType);
            self.status(rec.status);
            targetPcId = rec.pcId;
          }
        });
        reimbService.getBudgetLines(reimbId).then(function (lines) {
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

  return ReimbDetailViewModel;
});
