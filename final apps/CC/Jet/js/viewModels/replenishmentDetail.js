define(['knockout', 'services/ccService', 'shared/toast'],
function (ko, ccService, toast) {
  'use strict';

  function LineRow(src) {
    src = src || {};
    this.expenseDate     = ko.observable(src.expenseDate || '');
    this.merchantName    = ko.observable(src.merchantName || '');
    this.amount          = ko.observable(src.amount || '');
    this.description     = ko.observable(src.description || '');
    this.codingType      = ko.observable(src.codingType || 'GL');
    this.ccIdGl          = ko.observable(src.ccIdGl || '');
    this.projectNumber   = ko.observable(src.projectNumber || '');
    this.taskNumber      = ko.observable(src.taskNumber || '');
    this.expenditureType = ko.observable(src.expenditureType || '');
    this.receiptAttached = ko.observable(src.receiptAttached === 'Y');
  }

  function ReplenishmentDetailViewModel() {
    var self = this;
    var state = (window._jetApp && window._jetApp.getState()) || {};
    var id = state.replenishmentId;

    self.loading = ko.observable(true);
    self.data    = ko.observable(null);
    self.lines   = ko.observableArray([]);
    self.glCodes = ko.observableArray([]);
    self.busy    = ko.observable(false);
    self.dirty   = ko.observable(false);

    function load() {
      if (!id) { self.loading(false); return; }
      Promise.all([
        ccService.getReplenishment(id),
        ccService.getGlCodes().catch(function () { return []; })
      ]).then(function (res) {
        self.data(res[0]);
        self.glCodes((res[1] || []).filter(function (g) { return g.isActive === 'Y'; }));
        self.lines((res[0].lines || []).map(function (l) { return new LineRow(l); }));
        self.dirty(false);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    load();

    self.editable = ko.computed(function () {
      var d = self.data();
      return d && (d.status === 'DRAFT' || d.status === 'RETURNED');
    });

    self.linesTotal = ko.computed(function () {
      return self.lines().reduce(function (sum, l) { return sum + (Number(l.amount()) || 0); }, 0);
    });

    self.addLine = function () {
      var d = self.data() || {};
      self.lines.push(new LineRow({
        codingType:      d.codingType || 'GL',
        ccIdGl:          d.ccIdGl || '',
        projectNumber:   d.projectNumber || '',
        taskNumber:      d.taskNumber || '',
        expenditureType: d.expenditureType || ''
      }));
      self.dirty(true);
    };
    self.removeLine = function (line) { self.lines.remove(line); self.dirty(true); };
    self.markDirty  = function () { self.dirty(true); return true; };

    self.saveLines = function () {
      var payload = [];
      var rows = self.lines();
      for (var i = 0; i < rows.length; i++) {
        var l = rows[i];
        if (!l.merchantName() || !l.amount() || !l.expenseDate()) {
          toast.error('Line ' + (i + 1) + ': date, merchant and amount are required.');
          return;
        }
        if (l.codingType() === 'GL' && !l.ccIdGl()) {
          toast.error('Line ' + (i + 1) + ': pick a GL code combination.');
          return;
        }
        if (l.codingType() === 'PROJECT' && !l.projectNumber()) {
          toast.error('Line ' + (i + 1) + ': enter a project number.');
          return;
        }
        payload.push({
          expenseDate:     l.expenseDate(),
          merchantName:    l.merchantName(),
          amount:          Number(l.amount()),
          description:     l.description(),
          codingType:      l.codingType(),
          ccIdGl:          l.codingType() === 'GL' ? Number(l.ccIdGl()) : null,
          projectNumber:   l.codingType() === 'PROJECT' ? l.projectNumber() : null,
          taskNumber:      l.codingType() === 'PROJECT' ? l.taskNumber() : null,
          expenditureType: l.codingType() === 'PROJECT' ? l.expenditureType() : null,
          receiptAttached: l.receiptAttached() ? 'Y' : 'N'
        });
      }
      self.busy(true);
      ccService.saveReplenishmentLines(id, payload).then(function (r) {
        self.busy(false);
        self.dirty(false);
        toast.success('Saved ' + r.lineCount + ' line(s) — total AED ' + (r.totalAmount || 0).toLocaleString());
        load();
      }).catch(function () { self.busy(false); });
    };

    self.submit = function () {
      if (self.dirty()) { toast.error('Save the lines before submitting.'); return; }
      self.busy(true);
      ccService.submitReplenishment(id).then(function () {
        self.busy(false);
        toast.success('Replenishment submitted for approval.');
        load();
      }).catch(function () { self.busy(false); });
    };

    self.statusBadge = function (s) {
      var map = { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', UNDER_REVIEW: 'badge--underreview',
                  RETURNED: 'badge--returned', APPROVED: 'badge--approved', REJECTED: 'badge--rejected' };
      return 'badge ' + (map[s] || 'badge--idle');
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('replenishments'); };
  }

  return ReplenishmentDetailViewModel;
});
