define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function Teams() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.teams = ko.observableArray([]);

    self.fType = ko.observable(''); self.fClass = ko.observable('');
    self.fStatus = ko.observable(''); self.fSearch = ko.observable(''); self.fMine = ko.observable(false);

    self.types = ko.observableArray([]); self.classes = ko.observableArray([]);
    self.cats = ko.observableArray([]); self.statuses = ko.observableArray([]);

    self.showForm = ko.observable(false);
    self.fmName = ko.observable(''); self.fmNameAr = ko.observable('');
    self.fmType = ko.observable('INTERNAL'); self.fmClass = ko.observable('OPERATIONAL');
    self.fmCat = ko.observable(''); self.fmObj = ko.observable('');
    var myUid = null;

    function by(list, cat) { return (list || []).filter(function (l) { return l.category === cat; }); }

    tm.boot().then(function (b) {
      myUid = b.userId;
      self.types(by(b.lookups, 'TM_TEAM_TYPE'));
      self.classes(by(b.lookups, 'TM_TEAM_CLASS'));
      self.cats(by(b.lookups, 'TM_TEAM_CATEGORY'));
      self.statuses(by(b.lookups, 'TM_TEAM_STATUS'));
    }).catch(function () {});

    self.load = function () {
      self.loading(true);
      tm.listTeams({ type: self.fType(), 'class': self.fClass(), status: self.fStatus(),
                     search: self.fSearch(), mine: self.fMine() ? 'Y' : '', limit: 100 })
        .then(function (r) { self.teams(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

    self.open = function (team) { window._jetApp.navigate('teamDetail', { teamId: team.teamId, teamName: team.nameEn }); };

    self.newTeam = function () {
      self.fmName(''); self.fmNameAr(''); self.fmType('INTERNAL'); self.fmClass('OPERATIONAL');
      self.fmCat(''); self.fmObj(''); self.showForm(true);
    };
    self.cancel = function () { self.showForm(false); };
    self.save = function () {
      if (!self.fmName()) { toast.error('Name is required'); return; }
      tm.createTeam({ nameEn: self.fmName(), nameAr: self.fmNameAr(), type: self.fmType(),
                      'class': self.fmClass(), category: self.fmCat(), objective: self.fmObj(), leaderId: myUid })
        .then(function () { toast.success(self.t('tm.teams.title') + ' ✓'); self.showForm(false); self.load(); })
        .catch(function () {});
    };

    self.ragClass = function (rag) { return 'rag rag--' + String(rag || 'GREEN').toLowerCase(); };

    self.load();
  };
});
