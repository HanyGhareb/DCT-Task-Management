define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';

  var PRESETS = [
    { code: 'EVERY_15M', min: 15 }, { code: 'EVERY_30M', min: 30 },
    { code: 'HOURLY', min: 60 },    { code: 'EVERY_2H', min: 120 },
    { code: 'EVERY_6H', min: 360 }, { code: 'DAILY', min: 1440 },
    { code: 'WEEKLY', min: 10080 }, { code: 'CUSTOM', min: null }
  ];
  var DOW = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  return function JobSetDetail() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.set = ko.observable({});
    self.members = ko.observableArray([]);
    self.runs = ko.observableArray([]);
    self.candidates = ko.observableArray([]);   // jobs not in any set
    self.pickJob = ko.observable('');
    self.presets = PRESETS;
    self.days = DOW;
    var code = (window._jetApp.getState() || {}).setCode;

    self.presetLabel = function (c) { return self.t('atd.set.preset.' + c); };
    self.dayLabel    = function (c) { return self.t('atd.day.' + c); };
    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    self.dowList = ko.pureComputed(function () {
      var m = self.set().dowMask;
      if (!m) return [];
      return m.split(',').map(function (d) { return self.dayLabel(d.trim()); });
    });
    self.intervalText = ko.pureComputed(function () {
      var s = self.set();
      if (s.intervalPreset && s.intervalPreset !== 'CUSTOM') return self.presetLabel(s.intervalPreset);
      if (s.frequencyMinutes !== '' && s.frequencyMinutes != null) return s.frequencyMinutes + ' ' + self.t('atd.dur.m');
      return self.t('atd.field.auto');
    });

    self.back = function () { window._jetApp.navigate('jobSets'); };

    self.loadCandidates = function () {
      return atd.listSetCandidates().then(function (r) {
        self.candidates(((r && r.items) || []).filter(function (j) { return !j.setCode; }));
      }).catch(function () {});
    };

    self.refresh = function () {
      atd.getJobSet(code).then(function (s) {
        self.set(s);
        self.members((s.members || []).map(function (m) {
          return {
            jobName: m.jobName,
            enabledInSet: ko.observable(m.enabledInSet),
            memberOrder: ko.observable(m.memberOrder),
            jobEnabled: m.jobEnabled, runStatus: m.runStatus,
            nextRun: m.nextRun, lastFinished: m.lastFinished
          };
        }));
        self.runs(s.runs || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
      self.loadCandidates();
    };
    self.refresh();

    // ---- members ----------------------------------------------------------
    self.addMember = function () {
      if (!self.pickJob()) return;
      atd.addSetMembers(code, { jobName: self.pickJob() }).then(function () {
        toast.success(self.t('atd.set.memberAdded')); self.pickJob(''); self.refresh();
      }).catch(function () {});
    };
    self.removeMember = function (m) {
      if (!window.confirm(self.t('atd.set.confirmRemove').replace('{job}', m.jobName))) return;
      atd.removeSetMember(code, m.jobName).then(function () {
        toast.success(self.t('atd.common.saved')); self.refresh();
      }).catch(function () {});
    };
    self.toggleMember = function (m) {
      var next = m.enabledInSet() === 'Y' ? 'N' : 'Y';
      atd.updateSetMember(code, m.jobName, { enabledInSet: next }).then(function () {
        m.enabledInSet(next);
      }).catch(function () {});
      return true;
    };
    self.saveOrder = function (m) {
      atd.updateSetMember(code, m.jobName, { memberOrder: Number(m.memberOrder()) })
        .then(function () { toast.success(self.t('atd.common.saved')); }).catch(function () {});
    };

    // ---- set-level operations --------------------------------------------
    self.runSet = function () {
      if (!window.confirm(self.t('atd.set.confirmRun'))) return;
      atd.runJobSet(code).then(function (r) {
        toast.success(self.t('atd.set.ran').replace('{n}', (r && r.queued) || 0)); self.refresh();
      }).catch(function () {});
    };
    self.togglePause = function () {
      var next = self.set().paused !== 'Y';
      atd.pauseJobSet(code, next).then(function () {
        toast.success(self.t(next ? 'atd.set.paused' : 'atd.set.resumed')); self.refresh();
      }).catch(function () {});
    };
    self.del = function () {
      if (!window.confirm(self.t('atd.set.confirmDelete').replace('{name}', self.set().nameEn || code))) return;
      atd.deleteJobSet(code).then(function () { toast.success(self.t('atd.common.saved')); self.back(); }).catch(function () {});
    };

    // ---- edit-schedule drawer (flat fm* observables) ----------------------
    self.showForm = ko.observable(false);
    self.fmNameEn   = ko.observable('');
    self.fmNameAr   = ko.observable('');
    self.fmComments = ko.observable('');
    self.fmActive   = ko.observable(true);
    self.fmPreset   = ko.observable('HOURLY');
    self.fmFreq     = ko.observable(60);
    self.fmStartAt  = ko.observable('');
    self.fmEndAt    = ko.observable('');
    self.fmDailyStart = ko.observable('');
    self.fmDailyEnd   = ko.observable('');
    self.fmDow      = ko.observableArray([]);
    self.fmNotify   = ko.observable(false);

    self.fmPreset.subscribe(function (p) {
      var hit = PRESETS.filter(function (x) { return x.code === p; })[0];
      if (hit && hit.min != null) self.fmFreq(hit.min);
    });
    self.isCustom = ko.pureComputed(function () { return self.fmPreset() === 'CUSTOM'; });
    self.isDay = function (c) { return self.fmDow.indexOf(c) >= 0; };
    self.toggleDay = function (c) {
      var a = self.fmDow(); var i = a.indexOf(c);
      if (i >= 0) a.splice(i, 1); else a.push(c);
      self.fmDow(a.slice()); return true;
    };
    function presetFromFreq(min) {
      if (min === '' || min == null) return 'CUSTOM';
      var hit = PRESETS.filter(function (x) { return x.min === Number(min); })[0];
      return hit ? hit.code : 'CUSTOM';
    }

    self.openEdit = function () {
      var s = self.set();
      self.fmNameEn(s.nameEn); self.fmNameAr(s.nameAr || ''); self.fmComments(s.comments || '');
      self.fmActive((s.active || 'Y') === 'Y');
      self.fmFreq(s.frequencyMinutes === '' || s.frequencyMinutes == null ? '' : s.frequencyMinutes);
      self.fmPreset(s.intervalPreset || presetFromFreq(s.frequencyMinutes));
      self.fmStartAt(s.startAt || ''); self.fmEndAt(s.endAt || '');
      self.fmDailyStart(s.dailyStart || ''); self.fmDailyEnd(s.dailyEnd || '');
      self.fmDow(s.dowMask ? s.dowMask.split(',').map(function (d) { return d.trim(); }).filter(Boolean) : []);
      self.fmNotify((s.notifyOnFailure || 'N') === 'Y');
      self.showForm(true);
    };
    self.save = function () {
      if (!self.fmNameEn()) { toast.error(self.t('atd.set.needName')); return; }
      var b = {
        nameEn: self.fmNameEn(), nameAr: self.fmNameAr(), comments: self.fmComments(),
        active: self.fmActive() ? 'Y' : 'N', intervalPreset: self.fmPreset(),
        frequencyMinutes: (self.fmFreq() === '' || self.fmFreq() == null) ? null : Number(self.fmFreq()),
        startAt: self.fmStartAt() || '', endAt: self.fmEndAt() || '',
        dailyStart: self.fmDailyStart() || '', dailyEnd: self.fmDailyEnd() || '',
        dowMask: self.fmDow().join(','), notifyOnFailure: self.fmNotify() ? 'Y' : 'N'
      };
      atd.updateJobSet(code, b).then(function () {
        toast.success(self.t('atd.common.saved')); self.showForm(false); self.refresh();
      }).catch(function () {});
    };
  };
});
