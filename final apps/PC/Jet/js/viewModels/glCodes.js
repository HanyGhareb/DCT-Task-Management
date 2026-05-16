define(['knockout', 'services/pcService'],
function (ko, pcService) {
  'use strict';

  function GlCodesViewModel() {
    var self = this;

    self.records  = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.search   = ko.observable('');
    self.error    = ko.observable('');
    self.success  = ko.observable('');

    // Inline edit
    self.editingId = ko.observable(null);
    self.editRow   = ko.observable(null);

    self.filtered = ko.computed(function () {
      var q = self.search().toLowerCase();
      return self.records().filter(function (r) {
        return !q || Object.values(r).some(function(v){ return v && String(v).toLowerCase().includes(q); });
      });
    });

    function makeEditable(r) {
      return {
        ccId:             r.ccId,
        entityCode:       ko.observable(r.entityCode     || ''),
        appropriation:    ko.observable(r.appropriation  || ''),
        costCenter:       ko.observable(r.costCenter     || ''),
        entitySpecific:   ko.observable(r.entitySpecific || ''),
        budgetGroupCode:  ko.observable(r.budgetGroupCode || ''),
        account:          ko.observable(r.account        || ''),
        ic:               ko.observable(r.ic             || ''),
        future1:          ko.observable(r.future1        || ''),
        future2:          ko.observable(r.future2        || ''),
        isActive:         ko.observable(r.isActive       || 'Y'),
        startDate:        ko.observable(r.startDate      || ''),
        endDate:          ko.observable(r.endDate        || ''),
      };
    }

    self.startEdit = function (rec) {
      self.editingId(rec.ccId);
      self.editRow(makeEditable(rec));
    };

    self.cancelEdit = function () {
      self.editingId(null);
      self.editRow(null);
    };

    self.saveEdit = function () {
      var ed = self.editRow();
      if (!ed) return;
      var data = {
        ccId:            ed.ccId,
        entityCode:      ed.entityCode(),
        appropriation:   ed.appropriation(),
        costCenter:      ed.costCenter(),
        entitySpecific:  ed.entitySpecific(),
        budgetGroupCode: ed.budgetGroupCode(),
        account:         ed.account(),
        ic:              ed.ic(),
        future1:         ed.future1(),
        future2:         ed.future2(),
        isActive:        ed.isActive(),
        startDate:       ed.startDate(),
        endDate:         ed.endDate(),
      };
      pcService.saveGlCode(data).then(function () {
        self.success('GL Code updated.');
        self.cancelEdit();
        _load();
      }).catch(function (err) { self.error((err && err.message) || 'Save failed.'); });
    };

    self.addRow = function () {
      var newRec = { ccId: null, entityCode:'', appropriation:'', costCenter:'', entitySpecific:'', budgetGroupCode:'', account:'', ic:'', future1:'', future2:'', isActive:'Y', startDate:'', endDate:'' };
      self.editingId('__new__');
      self.editRow(makeEditable(newRec));
    };

    self.saveNew = function () {
      var ed = self.editRow();
      if (!ed) return;
      if (!ed.entityCode() || !ed.account()) { self.error('Entity Code and Account are required.'); return; }
      pcService.saveGlCode({
        entityCode: ed.entityCode(), appropriation: ed.appropriation(), costCenter: ed.costCenter(),
        entitySpecific: ed.entitySpecific(), budgetGroupCode: ed.budgetGroupCode(), account: ed.account(),
        ic: ed.ic(), future1: ed.future1(), future2: ed.future2(), isActive: ed.isActive(),
        startDate: ed.startDate(), endDate: ed.endDate(),
      }).then(function () {
        self.success('GL Code added.');
        self.cancelEdit();
        _load();
      }).catch(function (err) { self.error((err && err.message) || 'Add failed.'); });
    };

    self.deleteRow = function (rec) {
      if (!confirm('Delete GL Code ' + rec.entityCode + ' / ' + rec.account + '?')) return;
      pcService.deleteGlCode(rec.ccId).then(function () {
        self.success('GL Code deleted.');
        _load();
      }).catch(function (err) { self.error((err && err.message) || 'Delete failed.'); });
    };

    function _load() {
      pcService.getGlCodes().then(function (list) {
        self.records(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return GlCodesViewModel;
});
