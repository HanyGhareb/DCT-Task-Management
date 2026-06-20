define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function TeamCycle() {
    var self = this;
    self.t = i18n.t;
    var st = (window._jetApp && window._jetApp.getState()) || {};

    self.teamId = ko.observable(st.teamId || null);
    self.teamName = ko.observable('');
    self.loading = ko.observable(true);
    self.teams = ko.observableArray([]);        // team picker / parent picker
    self.periods = ko.observableArray([]);
    self.hasConfig = ko.observable(false);
    self.saving = ko.observable(false);
    self.parentTeamId = ko.observable(null);
    self.parentOptions = ko.computed(function () {
      var id = self.teamId();
      return self.teams().filter(function (t) { return t.teamId !== id; });
    });

    self.cadences = ['WEEKLY', 'BIWEEKLY', 'MONTHLY', 'QUARTERLY', 'CUSTOM'];
    self.scopes = ['ALL_MEMBERS', 'LEADS_ONLY', 'SELECTED'];

    self.c = {
      cadence: ko.observable('MONTHLY'), customDays: ko.observable(null), anchorDate: ko.observable(''),
      leadDays: ko.observable(3), deadlineOffset: ko.observable(0), reminderDays: ko.observable('3,1'),
      escalateAfter: ko.observable(1), submitterScope: ko.observable('ALL_MEMBERS'), autoClose: ko.observable('Y')
    };
    self.isCustom = ko.computed(function () { return self.c.cadence() === 'CUSTOM'; });

    // ---- roster modal ----
    self.roster = ko.observableArray([]);
    self.rosterPeriod = ko.observable(null);
    self.showRoster = ko.observable(false);
    self.signSummary = ko.observable('');
    self.signRag = ko.observable('GREEN');
    self.aiSummary = ko.observable('');
    self.aiBusy = ko.observable(false);

    self.pstatClass = function (s) { return 'pstat pstat--' + (s || 'PENDING'); };
    self.subStatClass = function (s) { return 'sub-stat sub-stat--' + (s || 'NOT_STARTED'); };

    function loadConfig() {
      tm.getCycleConfig(self.teamId()).then(function (d) {
        self.hasConfig(!!d.exists);
        if (d.exists) {
          self.c.cadence(d.cadence); self.c.customDays(d.customDays); self.c.anchorDate(d.anchorDate || '');
          self.c.leadDays(d.leadDays); self.c.deadlineOffset(d.deadlineOffset); self.c.reminderDays(d.reminderDays);
          self.c.escalateAfter(d.escalateAfter); self.c.submitterScope(d.submitterScope); self.c.autoClose(d.autoClose);
        }
      }).catch(function () {});
    }
    function loadPeriods() {
      tm.listPeriods({ teamId: self.teamId() }).then(function (r) { self.periods(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    }

    self.selectTeam = function (t) { self.teamId(t.teamId); self.teamName(t.nameEn); self.init(); };

    self.init = function () {
      tm.listTeams({ limit: 200 }).then(function (r) { self.teams(r.items || []); }).catch(function () {});
      if (!self.teamId()) { self.loading(false); return; }
      self.loading(true);
      tm.getTeam(self.teamId()).then(function (t) { self.teamName(t.nameEn); self.parentTeamId(t.parentTeamId || null); }).catch(function () {});
      loadConfig(); loadPeriods();
    };

    self.saveParent = function () {
      tm.setTeamParent(self.teamId(), self.parentTeamId() || null)
        .then(function () { toast.success('✓'); }).catch(function () {});
    };

    self.saveConfig = function () {
      self.saving(true);
      tm.saveCycleConfig({
        teamId: self.teamId(), cadence: self.c.cadence(), customDays: self.c.customDays(),
        anchorDate: self.c.anchorDate() || null, leadDays: self.c.leadDays(), deadlineOffset: self.c.deadlineOffset(),
        reminderDays: self.c.reminderDays(), escalateAfter: self.c.escalateAfter(),
        submitterScope: self.c.submitterScope(), autoClose: self.c.autoClose()
      }).then(function () {
        toast.success(self.t('tm.cyc.saved')); self.saving(false); self.hasConfig(true); loadPeriods();
      }).catch(function () { self.saving(false); });
    };

    self.generate = function () {
      tm.generatePeriods(self.teamId()).then(function () { toast.success('✓'); loadPeriods(); }).catch(function () {});
    };

    self.openRoster = function (p) {
      self.rosterPeriod(p); self.signSummary(p.signoffSummary || ''); self.signRag(p.signoffRag || 'GREEN'); self.aiSummary('');
      tm.periodStatus(p.periodId).then(function (r) { self.roster(r.items || []); self.showRoster(true); }).catch(function () {});
      tm.getAiSummary(p.periodId).then(function (r) { self.aiSummary(r.summary || ''); }).catch(function () {});
    };
    self.closeRoster = function () { self.showRoster(false); };
    self.genAi = function () {
      self.aiBusy(true);
      tm.generateAiSummary(self.rosterPeriod().periodId)
        .then(function (r) { self.aiSummary(r.summary || ''); self.aiBusy(false); })
        .catch(function () { self.aiBusy(false); });
    };

    self.closePeriod = function () {
      if (!window.confirm(self.t('tm.cyc.closeConfirm'))) return;
      tm.closePeriod(self.rosterPeriod().periodId).then(function () { toast.success('✓'); self.showRoster(false); loadPeriods(); }).catch(function () {});
    };
    self.lockPeriod = function () {
      tm.lockPeriod(self.rosterPeriod().periodId).then(function () { toast.success('✓'); self.showRoster(false); loadPeriods(); }).catch(function () {});
    };
    self.signoff = function () {
      tm.signoffPeriod({ periodId: self.rosterPeriod().periodId, summary: self.signSummary(), teamRag: self.signRag() })
        .then(function () { toast.success('✓'); loadPeriods(); }).catch(function () {});
    };

    self.back = function () { window._jetApp.navigate('teamDetail', { teamId: self.teamId() }); };

    self.init();
  };
});
