define(['knockout', 'services/authService', 'services/pcService', 'services/settingService'],
function (ko, authService, pcService, settingService) {
  'use strict';

  function PcRequestViewModel() {
    var self = this;

    var user   = authService.getCurrentUser();
    var state  = window._pcApp ? window._pcApp.getState() : {};
    var editId = state.pcId || null;
    self.isEdit = !!editId;

    // ── Form fields ───────────────────────────────────────────────────
    self.pcNumber    = ko.observable('');
    self.pcType      = ko.observable('TEMPORARY');
    self.amount      = ko.observable('');
    self.purpose     = ko.observable('');
    self.dueDate     = ko.observable('');
    self.codingType  = ko.observable('GL');
    self.status      = ko.observable('DRAFT');
    self.fiscalYear  = new Date().getFullYear();

    self.saving   = ko.observable(false);
    self.error    = ko.observable('');
    self.success  = ko.observable('');

    // ── GL Code cascades (simplified) ────────────────────────────────
    self.glCodes   = ko.observableArray([]);
    self.projectData = ko.observableArray([]);

    // Unique values for cascade selects
    self.entityCodes      = ko.observableArray([]);
    self.appropriations   = ko.observableArray([]);
    self.costCenters      = ko.observableArray([]);
    self.projectNumbers   = ko.observableArray([]);
    self.taskNumbers      = ko.observableArray([]);
    self.expenditureTypes = ko.observableArray([]);

    // ── Budget lines ──────────────────────────────────────────────────
    self.budgetLines = ko.observableArray([]);

    function makeLine() {
      return {
        lineId:         null,
        amount:         ko.observable(''),
        codingType:     ko.computed(function(){ return self.codingType(); }),
        // GL fields
        entityCode:       ko.observable(''),
        appropriation:    ko.observable(''),
        costCenter:       ko.observable(''),
        entitySpecific:   ko.observable(''),
        budgetGroupCode:  ko.observable(''),
        account:          ko.observable(''),
        ic:               ko.observable(''),
        // Project fields
        projectNumber:   ko.observable(''),
        taskNumber:      ko.observable(''),
        expenditureType: ko.observable(''),
        fundAvailable:   ko.observable(null),
        description:     ko.observable(''),
      };
    }

    self.addLine = function () { self.budgetLines.push(makeLine()); };
    self.removeLine = function (line) { self.budgetLines.remove(line); };

    self.lineTotal = ko.computed(function () {
      return self.budgetLines().reduce(function (s, l) { return s + (parseFloat(l.amount()) || 0); }, 0);
    });

    self.amountMismatch = ko.computed(function () {
      var req = parseFloat(self.amount()) || 0;
      return req > 0 && Math.abs(self.lineTotal() - req) > 0.01;
    });

    self.showDueDate = ko.computed(function () { return self.pcType() === 'TEMPORARY'; });
    self.isReadOnly  = ko.computed(function () {
      return self.status() !== 'DRAFT' && self.status() !== '' && self.isEdit;
    });

    // ── Cascade helpers ───────────────────────────────────────────────
    function _uniq(arr) { return arr.filter(function(v,i,a){ return a.indexOf(v) === i; }).sort(); }

    function _refreshEntityCodes() {
      var codes = _uniq(self.glCodes().filter(function(g){ return g.isActive === 'Y'; }).map(function(g){ return g.entityCode; }));
      self.entityCodes(codes);
    }

    self.refreshAppropriations = function (entityCode) {
      var codes = _uniq(self.glCodes().filter(function(g){ return g.entityCode === entityCode && g.isActive === 'Y'; }).map(function(g){ return g.appropriation; }));
      self.appropriations(codes);
    };

    self.refreshCostCenters = function (entityCode, approp) {
      var codes = _uniq(self.glCodes().filter(function(g){ return g.entityCode === entityCode && g.appropriation === approp && g.isActive === 'Y'; }).map(function(g){ return g.costCenter; }));
      self.costCenters(codes);
    };

    // Project cascades
    self.refreshTaskNumbers = function (projNum) {
      var tasks = _uniq(self.projectData().filter(function(p){ return p.projectNumber === projNum; }).map(function(p){ return p.taskNumber; }));
      self.taskNumbers(tasks);
    };

    self.refreshExpenditureTypes = function (projNum, taskNum) {
      var types = _uniq(self.projectData().filter(function(p){ return p.projectNumber === projNum && p.taskNumber === taskNum; }).map(function(p){ return p.expenditureType; }));
      self.expenditureTypes(types);
    };

    self.getFundAvailable = function (line) {
      var p = self.projectData().find(function(r){
        return r.projectNumber === line.projectNumber() && r.taskNumber === line.taskNumber() && r.expenditureType === line.expenditureType();
      });
      line.fundAvailable(p ? p.fundAvailable : null);
    };

    // ── Validation ────────────────────────────────────────────────────
    function _validate() {
      if (!self.pcType())    return 'PC Type is required.';
      if (!self.amount() || parseFloat(self.amount()) <= 0) return 'Amount must be greater than 0.';
      if (!self.purpose())   return 'Purpose is required.';
      if (self.pcType() === 'TEMPORARY' && !self.dueDate()) return 'Due Date is required for Temporary petty cash.';
      if (self.budgetLines().length === 0) return 'At least one budget line is required.';
      if (self.amountMismatch()) return 'Budget line amounts must sum to the requested amount.';
      var maxAmt = settingService.getValue('MAX_PC_AMOUNT');
      if (maxAmt && parseFloat(self.amount()) > parseFloat(maxAmt)) return 'Amount exceeds maximum allowed (' + maxAmt + ' AED).';
      return null;
    }

    // ── Save / Submit ─────────────────────────────────────────────────
    self.saveForm = function (submitForApproval) {
      self.error('');
      var err = _validate();
      if (err) { self.error(err); return; }

      self.saving(true);
      var payload = {
        userId:         user.userId,
        employeeName:   user.displayName,
        employeeNumber: user.employeeNumber,
        orgName:        user.orgName,
        pcType:         self.pcType(),
        amount:         parseFloat(self.amount()),
        purpose:        self.purpose(),
        dueDate:        self.dueDate() || null,
        codingType:     self.codingType(),
        fiscalYear:     self.fiscalYear,
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

      var action = self.isEdit ? pcService.update(editId, payload) : pcService.create(payload);
      action.then(function (rec) {
        self.saving(false);
        self.success('Petty cash request ' + (submitForApproval ? 'submitted for approval' : 'saved as draft') + ' — ' + rec.pcNumber);
        setTimeout(function () {
          if (window._pcApp) window._pcApp.navigate('myPettyCash');
        }, 1500);
      }).catch(function (err) {
        self.saving(false);
        self.error((err && err.message) || 'Save failed. Please try again.');
      });
    };

    self.saveDraft  = function () { self.saveForm(false); };
    self.submit     = function () { self.saveForm(true);  };
    self.cancel     = function () { if (window._pcApp) window._pcApp.navigate('myPettyCash'); };

    // ── Init ──────────────────────────────────────────────────────────
    pcService.getGlCodes().then(function (codes) {
      self.glCodes(codes);
      _refreshEntityCodes();
    });

    pcService.getProjectBudget().then(function (data) {
      self.projectData(data);
      var projs = data.map(function(p){ return p.projectNumber; }).filter(function(v,i,a){ return a.indexOf(v) === i; }).sort();
      self.projectNumbers(projs);
    });

    if (editId) {
      pcService.getById(editId).then(function (rec) {
        if (rec) {
          self.pcNumber(rec.pcNumber);
          self.pcType(rec.pcType);
          self.amount(rec.amount);
          self.purpose(rec.purpose);
          self.dueDate(rec.dueDate || '');
          self.codingType(rec.codingType);
          self.status(rec.status);
        }
      });
      pcService.getBudgetLines(editId).then(function (lines) {
        lines.forEach(function (l) {
          var line = makeLine();
          line.lineId   = l.lineId;
          line.amount(l.amount);
          line.description(l.description || '');
          if (l.codingType === 'GL') {
            line.entityCode(l.entityCode || '');
            line.appropriation(l.appropriation || '');
            line.costCenter(l.costCenter || '');
            line.entitySpecific(l.entitySpecific || '');
            line.budgetGroupCode(l.budgetGroupCode || '');
            line.account(l.account || '');
            line.ic(l.ic || '');
          } else {
            line.projectNumber(l.projectNumber || '');
            line.taskNumber(l.taskNumber || '');
            line.expenditureType(l.expenditureType || '');
          }
          self.budgetLines.push(line);
        });
      });
    } else {
      // Start with one empty line
      self.budgetLines.push(makeLine());
    }
  }

  return PcRequestViewModel;
});
