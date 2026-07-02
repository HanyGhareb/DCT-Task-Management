define(['knockout', 'services/rptService', 'shared/toast', 'shared/i18n'], function (ko, rpt, toast, i18n) {
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

    // ── run with parameters ─────────────────────────────────────────────
    // The param spec (labels/hints/required/LOVs) comes from
    // GET /reports/:code/params; no params declared → queue immediately.
    self.runEditing = ko.observable(false);
    self.runSaving  = ko.observable(false);
    self.runParams  = ko.observableArray([]);   // spec rows + value: ko.observable

    self.runNow = function () {
      rpt.getReportParams(self.reportCode).then(function (d) {
        var spec = (d && d.params) || [];
        if (!spec.length) { self.queueRun(null); return; }
        self.runParams(spec.map(function (p) { p.value = ko.observable(''); return p; }));
        self.runEditing(true);
      }).catch(function () {});
    };

    self.queueRun = function (params) {
      if (self.runSaving()) return;
      self.runSaving(true);
      rpt.runReport(self.reportCode, null, params).then(function (r) {
        self.runSaving(false); self.runEditing(false);
        toast.success('Queued run #' + r.runId); window._jetApp.navigate('runs');
      }).catch(function () { self.runSaving(false); });
    };

    self.submitRun = function () {
      var params = {}, missing = [];
      self.runParams().forEach(function (p) {
        var v = (p.value() || '').trim();
        if (v === '') { if (p.required) missing.push(p.label || p.name); return; }
        params[p.name] = /^-?\d+(\.\d+)?$/.test(v) ? Number(v) : v;
      });
      if (missing.length) { toast.error(i18n.t('det.paramRequired') + ' ' + missing.join(', ')); return; }
      self.queueRun(Object.keys(params).length ? params : null);
    };
    self.syncSched = function () {
      rpt.syncSchedules().then(function () { toast.success('Scheduler jobs rebuilt'); }).catch(function () {});
    };

    // ── run-parameter spec editor (labels / hints / required / LOV SQL) ─
    // Edits PARAM_SPEC_JSON via GET/PUT ir/reports/:code/paramspec; the
    // Test button runs a draft lov_sql through POST ir/lov/preview (cap 50).
    self.psEditing = ko.observable(false);
    self.psSaving  = ko.observable(false);
    self.psRows    = ko.observableArray([]);

    self.openParamSpec = function () {
      rpt.getParamSpec(self.reportCode).then(function (d) {
        var spec = {}, defaults = {};
        try { spec = JSON.parse(d.paramSpec || '{}') || {}; } catch (e) { spec = {}; }
        try { defaults = JSON.parse(d.paramsJson || '{}') || {}; } catch (e) { defaults = {}; }
        var names = Object.keys(defaults);
        Object.keys(spec).forEach(function (k) {
          var hit = names.some(function (n) { return n.toLowerCase() === k.toLowerCase(); });
          if (!hit) names.push(k);
        });
        self.psRows(names.map(function (n) {
          var e = spec[n] || spec[n.toLowerCase()] || {};
          return {
            name: n,
            label:      ko.observable(e.label || ''),
            labelAr:    ko.observable(e.label_ar || ''),
            hint:       ko.observable(e.hint || ''),
            hintAr:     ko.observable(e.hint_ar || ''),
            required:   ko.observable(e.required === true),
            lovSql:     ko.observable(e.lov_sql || ''),
            testResult: ko.observable(''),
            testBusy:   ko.observable(false)
          };
        }));
        self.psEditing(true);
      }).catch(function () {});
    };

    self.testLov = function (row) {
      var sql = (row.lovSql() || '').trim();
      if (!sql) { row.testResult(''); return; }
      row.testBusy(true);
      rpt.previewLov(sql).then(function (r) {
        var vals = (r.items || []).map(function (x) { return x.label || x.value; });
        row.testResult(i18n.t('det.psTestOk', [r.total]) + ' ' +
                       vals.slice(0, 8).join(', ') + (vals.length > 8 ? ' …' : ''));
      }).catch(function () {
        row.testResult(i18n.t('det.psTestFail'));
      }).then(function () { row.testBusy(false); });
    };

    self.saveParamSpec = function () {
      if (self.psSaving()) return;
      var spec = {};
      self.psRows().forEach(function (r) {
        var e = {};
        if ((r.label()   || '').trim()) e.label    = r.label().trim();
        if ((r.labelAr() || '').trim()) e.label_ar = r.labelAr().trim();
        if ((r.hint()    || '').trim()) e.hint     = r.hint().trim();
        if ((r.hintAr()  || '').trim()) e.hint_ar  = r.hintAr().trim();
        if (r.required()) e.required = true;
        if ((r.lovSql()  || '').trim()) e.lov_sql  = r.lovSql().trim();
        if (Object.keys(e).length) spec[r.name.toLowerCase()] = e;
      });
      self.psSaving(true);
      rpt.putParamSpec(self.reportCode, spec).then(function () {
        self.psSaving(false); self.psEditing(false);
        toast.success(i18n.t('det.psSaved'));
      }).catch(function () { self.psSaving(false); });
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
