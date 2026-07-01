define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';

  // interval presets -> run frequency in minutes (CUSTOM = operator types the minutes)
  var PRESETS = [
    { code: 'EVERY_15M', min: 15 }, { code: 'EVERY_30M', min: 30 },
    { code: 'HOURLY', min: 60 },    { code: 'EVERY_2H', min: 120 },
    { code: 'EVERY_6H', min: 360 }, { code: 'DAILY', min: 1440 },
    { code: 'WEEKLY', min: 10080 }, { code: 'CUSTOM', min: null }
  ];
  var DOW = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  return function JobSets() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.sets = ko.observableArray([]);
    self.presets = PRESETS;
    self.days = DOW;

    // ---- create / edit drawer (flat fm* observables — never editTarget().field) ----
    self.showForm = ko.observable(false);
    self.editCode = ko.observable(null);          // set_code being edited; null = new
    self.fmSetCode  = ko.observable('');
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
    self.fmDow      = ko.observableArray([]);     // selected day codes
    self.fmNotify   = ko.observable(false);

    // when a preset (other than CUSTOM) is chosen, set the minutes for the operator
    self.fmPreset.subscribe(function (p) {
      var hit = PRESETS.filter(function (x) { return x.code === p; })[0];
      if (hit && hit.min != null) self.fmFreq(hit.min);
    });
    self.isCustom = ko.pureComputed(function () { return self.fmPreset() === 'CUSTOM'; });

    self.presetLabel = function (code) { return self.t('atd.set.preset.' + code); };
    self.dayLabel    = function (code) { return self.t('atd.day.' + code); };
    self.isDay = function (code) { return self.fmDow.indexOf(code) >= 0; };
    self.toggleDay = function (code) {
      var a = self.fmDow(); var i = a.indexOf(code);
      if (i >= 0) a.splice(i, 1); else a.push(code);
      self.fmDow(a.slice()); return true;
    };

    self.formTitle = ko.pureComputed(function () {
      return self.t(self.editCode() ? 'atd.set.editTitle' : 'atd.set.newTitle');
    });
    self.formSaveLabel = ko.pureComputed(function () {
      return self.t(self.editCode() ? 'atd.action.saveChanges' : 'atd.action.create');
    });
    self.showForm.subscribe(function (v) { if (!v) self.editCode(null); });

    self.presetFromFreq = function (min) {
      if (min === '' || min == null) return 'CUSTOM';
      var hit = PRESETS.filter(function (x) { return x.min === Number(min); })[0];
      return hit ? hit.code : 'CUSTOM';
    };

    self.load = function () {
      self.loading(true);
      atd.listJobSets().then(function (r) {
        self.sets((r && r.items) || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.load();

    self.open = function (row) { window._jetApp.navigate('jobSetDetail', { setCode: row.setCode }); };

    self.newSet = function () {
      self.editCode(null);
      self.fmSetCode(''); self.fmNameEn(''); self.fmNameAr(''); self.fmComments('');
      self.fmActive(true); self.fmPreset('HOURLY'); self.fmFreq(60);
      self.fmStartAt(''); self.fmEndAt(''); self.fmDailyStart(''); self.fmDailyEnd('');
      self.fmDow([]); self.fmNotify(false);
      self.showForm(true);
    };

    self.editSet = function (row) {
      atd.getJobSet(row.setCode).then(function (s) {
        self.editCode(s.setCode);
        self.fmSetCode(s.setCode); self.fmNameEn(s.nameEn); self.fmNameAr(s.nameAr || '');
        self.fmComments(s.comments || ''); self.fmActive((s.active || 'Y') === 'Y');
        self.fmFreq(s.frequencyMinutes === '' || s.frequencyMinutes == null ? '' : s.frequencyMinutes);
        self.fmPreset(s.intervalPreset || self.presetFromFreq(s.frequencyMinutes));
        self.fmStartAt(s.startAt || ''); self.fmEndAt(s.endAt || '');
        self.fmDailyStart(s.dailyStart || ''); self.fmDailyEnd(s.dailyEnd || '');
        self.fmDow(s.dowMask ? s.dowMask.split(',').map(function (d) { return d.trim(); }).filter(Boolean) : []);
        self.fmNotify((s.notifyOnFailure || 'N') === 'Y');
        self.showForm(true);
      }).catch(function () {});
    };

    function body() {
      return {
        nameEn: self.fmNameEn(), nameAr: self.fmNameAr(), comments: self.fmComments(),
        active: self.fmActive() ? 'Y' : 'N',
        intervalPreset: self.fmPreset(),
        frequencyMinutes: (self.fmFreq() === '' || self.fmFreq() == null) ? null : Number(self.fmFreq()),
        startAt: self.fmStartAt() || '', endAt: self.fmEndAt() || '',
        dailyStart: self.fmDailyStart() || '', dailyEnd: self.fmDailyEnd() || '',
        dowMask: self.fmDow().join(','),
        notifyOnFailure: self.fmNotify() ? 'Y' : 'N'
      };
    }

    self.save = function () {
      if (!self.fmNameEn()) { toast.error(self.t('atd.set.needName')); return; }
      if (self.editCode()) {
        atd.updateJobSet(self.editCode(), body()).then(function () {
          toast.success(self.t('atd.common.saved')); self.showForm(false); self.load();
        }).catch(function () {});
        return;
      }
      if (!self.fmSetCode()) { toast.error(self.t('atd.set.needCode')); return; }
      var b = body(); b.setCode = self.fmSetCode();
      atd.createJobSet(b).then(function () {
        toast.success(self.t('atd.set.created')); self.showForm(false); self.load();
      }).catch(function () {});
    };

    self.runSet = function (row) {
      if (!window.confirm(self.t('atd.set.confirmRun'))) return;
      atd.runJobSet(row.setCode).then(function (r) {
        toast.success(self.t('atd.set.ran').replace('{n}', (r && r.queued) || 0)); self.load();
      }).catch(function () {});
    };
    self.togglePause = function (row) {
      var next = row.paused !== 'Y';
      atd.pauseJobSet(row.setCode, next).then(function () {
        toast.success(self.t(next ? 'atd.set.paused' : 'atd.set.resumed')); self.load();
      }).catch(function () {});
    };
    self.del = function (row) {
      if (!window.confirm(self.t('atd.set.confirmDelete').replace('{name}', row.nameEn))) return;
      atd.deleteJobSet(row.setCode).then(function () {
        toast.success(self.t('atd.common.saved')); self.load();
      }).catch(function () {});
    };

    self.intervalText = function (row) {
      if (row.intervalPreset && row.intervalPreset !== 'CUSTOM') return self.presetLabel(row.intervalPreset);
      if (row.frequencyMinutes !== '' && row.frequencyMinutes != null) return row.frequencyMinutes + ' ' + self.t('atd.dur.m');
      return self.t('atd.field.auto');
    };
  };
});
