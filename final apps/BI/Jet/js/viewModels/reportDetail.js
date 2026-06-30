define(['knockout', 'services/rptService', 'shared/toast'], function (ko, rpt, toast) {
  'use strict';

  function ReportDetailViewModel() {
    var self = this;
    var st = (window._jetApp && window._jetApp.getState()) || {};
    self.reportCode = st.reportCode || '';

    self.loading    = ko.observable(true);
    self.report     = ko.observable(null);
    self.schedules  = ko.observableArray([]);
    self.recipients = ko.observableArray([]);
    self.recipientTypes = ['EMAIL', 'USER', 'ROLE', 'ORG', 'SELF'];
    self.channels       = ['EMAIL', 'INAPP', 'PUSH', 'WEBHOOK'];

    self.back   = function () { window._jetApp.navigate('reports'); };
    self.runNow = function () {
      rpt.runReport(self.reportCode).then(function (r) {
        toast.success('Queued run #' + r.runId); window._jetApp.navigate('runs');
      }).catch(function () {});
    };
    self.syncSched = function () {
      rpt.syncSchedules().then(function () { toast.success('Scheduler jobs rebuilt'); }).catch(function () {});
    };

    self.loadAll = function () {
      self.loading(true);
      rpt.getReport(self.reportCode).then(function (d) { self.report(d); }).catch(function () {});
      rpt.getSchedules(self.reportCode).then(function (r) { self.schedules(r.items || []); }).catch(function () {});
      rpt.getRecipients(self.reportCode).then(function (r) { self.recipients(r.items || []); })
        .catch(function () {}).then(function () { self.loading(false); });
    };

    // ── schedule modal ──────────────────────────────────────────────────
    self.schEditing = ko.observable(false);
    self.schIsNew   = ko.observable(false);
    self.schSaving  = ko.observable(false);
    self.schId      = ko.observable(null);
    self.schName    = ko.observable('');
    self.schInterval = ko.observable('FREQ=DAILY;BYHOUR=7;BYMINUTE=0');
    self.schTz      = ko.observable('Asia/Dubai');
    self.schCriteria = ko.observable('');
    self.schEnabled = ko.observable(true);

    self.openSchNew = function () {
      self.schIsNew(true); self.schId(null); self.schName(''); self.schInterval('FREQ=DAILY;BYHOUR=7;BYMINUTE=0');
      self.schTz('Asia/Dubai'); self.schCriteria(''); self.schEnabled(true); self.schEditing(true);
    };
    self.openSchEdit = function (row) {
      self.schIsNew(false); self.schId(row.scheduleId); self.schName(row.scheduleName || '');
      self.schInterval(row.repeatInterval || ''); self.schTz(row.timezone || 'Asia/Dubai');
      self.schCriteria(row.criteriaJson || ''); self.schEnabled((row.enabled || 'Y') === 'Y'); self.schEditing(true);
    };
    self.saveSch = function () {
      if (self.schSaving()) return;
      if (!self.schInterval()) { toast.error('Repeat interval is required'); return; }
      var payload = { reportCode: self.reportCode, scheduleName: self.schName(),
        repeatInterval: self.schInterval(), timezone: self.schTz(),
        criteriaJson: self.schCriteria() || null, enabled: self.schEnabled() ? 'Y' : 'N' };
      self.schSaving(true);
      var p = self.schIsNew() ? rpt.createSchedule(payload) : rpt.updateSchedule(self.schId(), payload);
      p.then(function () {
        self.schSaving(false); self.schEditing(false); toast.success('Schedule saved'); self.loadAll();
      }).catch(function () { self.schSaving(false); });
    };
    self.removeSch = function (row) {
      if (!window.confirm('Delete this schedule?')) return;
      rpt.deleteSchedule(row.scheduleId).then(function () { toast.success('Deleted'); self.loadAll(); }).catch(function () {});
    };

    // ── recipient modal ─────────────────────────────────────────────────
    self.rcEditing = ko.observable(false);
    self.rcIsNew   = ko.observable(false);
    self.rcSaving  = ko.observable(false);
    self.rcId      = ko.observable(null);
    self.rcType    = ko.observable('EMAIL');
    self.rcRef     = ko.observable('');
    self.rcChannel = ko.observable('EMAIL');
    self.rcEnabled = ko.observable(true);
    self.rcNeedsRef = ko.computed(function () { return self.rcType() !== 'SELF'; });

    self.openRcNew = function () {
      self.rcIsNew(true); self.rcId(null); self.rcType('EMAIL'); self.rcRef(''); self.rcChannel('EMAIL');
      self.rcEnabled(true); self.rcEditing(true);
    };
    self.openRcEdit = function (row) {
      self.rcIsNew(false); self.rcId(row.recipientId); self.rcType(row.recipientType);
      self.rcRef(row.recipientRef || ''); self.rcChannel(row.channel || 'EMAIL');
      self.rcEnabled((row.enabled || 'Y') === 'Y'); self.rcEditing(true);
    };
    self.saveRc = function () {
      if (self.rcSaving()) return;
      var payload = { reportCode: self.reportCode, recipientType: self.rcType(),
        recipientRef: self.rcNeedsRef() ? self.rcRef() : null, channel: self.rcChannel(),
        enabled: self.rcEnabled() ? 'Y' : 'N' };
      if (self.rcNeedsRef() && !self.rcRef()) { toast.error('Recipient value is required'); return; }
      self.rcSaving(true);
      var p = self.rcIsNew() ? rpt.createRecipient(payload) : rpt.updateRecipient(self.rcId(), payload);
      p.then(function () {
        self.rcSaving(false); self.rcEditing(false); toast.success('Recipient saved'); self.loadAll();
      }).catch(function () { self.rcSaving(false); });
    };
    self.removeRc = function (row) {
      if (!window.confirm('Delete this recipient?')) return;
      rpt.deleteRecipient(row.recipientId).then(function () { toast.success('Deleted'); self.loadAll(); }).catch(function () {});
    };

    self.refHint = ko.computed(function () {
      return { EMAIL: 'email@dct.gov.ae', USER: 'user_id (number)', ROLE: 'role_code (e.g. SYS_ADMIN)',
               ORG: 'org_id (number)', SELF: '(the requester)' }[self.rcType()] || '';
    });

    if (!self.reportCode) { self.loading(false); } else { self.loadAll(); }
  }

  return ReportDetailViewModel;
});
