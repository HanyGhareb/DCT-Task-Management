define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function MyUpdates() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.rows = ko.observableArray([]);

    // ---- check-in editor (modal) ----
    self.editing = ko.observable(false);
    self.saving  = ko.observable(false);
    self.cur = {
      periodId: ko.observable(null), label: ko.observable(''), dueDate: ko.observable(''),
      status: ko.observable(''), periodStatus: ko.observable(''),
      accomplishments: ko.observable(''), inProgress: ko.observable(''),
      pending: ko.observable(''), blockers: ko.observable(''), highlights: ko.observable(''),
      tasksDone: ko.observable(0), tasksOnTrack: ko.observable(0), tasksLate: ko.observable(0),
      tasksOverdue: ko.observable(0), kpi: ko.observable(0)
    };
    self.readOnly = ko.computed(function () {
      return ['CLOSED', 'LOCKED'].indexOf(self.cur.periodStatus()) >= 0;
    });

    self.load = function () {
      self.loading(true);
      tm.mySubmissions().then(function (r) { self.rows(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

    self.statClass = function (s) { return 'sub-stat sub-stat--' + (s || 'NOT_STARTED'); };

    self.open = function (row) {
      tm.getSubmission(row.periodId).then(function (d) {
        self.cur.periodId(row.periodId);
        self.cur.label(d.label || row.label);
        self.cur.dueDate(d.dueDate || row.dueDate);
        self.cur.status(d.status || row.status);
        self.cur.periodStatus(d.periodStatus || row.periodStatus);
        self.cur.accomplishments(d.accomplishments || '');
        self.cur.inProgress(d.inProgress || '');
        self.cur.pending(d.pending || '');
        self.cur.blockers(d.blockers || '');
        self.cur.highlights(d.highlights || '');
        self.cur.tasksDone(d.tasksDone || 0);
        self.cur.tasksOnTrack(d.tasksOnTrack || 0);
        self.cur.tasksLate(d.tasksLate || 0);
        self.cur.tasksOverdue(d.tasksOverdue || 0);
        self.cur.kpi(d.objectiveProgress || 0);
        self.editing(true);
      }).catch(function () {});
    };
    self.close = function () { self.editing(false); };

    function payload() {
      return {
        periodId: self.cur.periodId(),
        accomplishments: self.cur.accomplishments(), inProgress: self.cur.inProgress(),
        pending: self.cur.pending(), blockers: self.cur.blockers(), highlights: self.cur.highlights()
      };
    }

    self.saveDraft = function () {
      self.saving(true);
      tm.saveSubmission(payload()).then(function () {
        toast.success(self.t('tm.upd.savedDraft')); self.saving(false); self.editing(false); self.load();
      }).catch(function () { self.saving(false); });
    };

    self.submit = function () {
      if (!window.confirm(self.t('tm.upd.submitConfirm'))) return;
      self.saving(true);
      tm.saveSubmission(payload())
        .then(function () { return tm.submitSubmission(self.cur.periodId()); })
        .then(function () {
          toast.success(self.t('tm.upd.submitted')); self.saving(false); self.editing(false); self.load();
        }).catch(function () { self.saving(false); });
    };

    self.load();
  };
});
