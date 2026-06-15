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
    self.editId = ko.observable(null);   // teamId when editing (null = create)
    self.fmName = ko.observable(''); self.fmNameAr = ko.observable('');
    self.fmType = ko.observable('INTERNAL'); self.fmClass = ko.observable('OPERATIONAL');
    self.fmCat = ko.observable(''); self.fmObj = ko.observable(''); self.fmStatus = ko.observable('');
    var myUid = null;

    self.formTitle = ko.computed(function () {
      return self.t(self.editId() ? 'tm.detail.editTeam' : 'tm.teams.new');
    });
    self.formSaveLabel = ko.computed(function () {
      return self.t(self.editId() ? 'tm.action.saveChanges' : 'tm.action.create');
    });
    // clear edit state whenever the drawer closes (Esc / scrim / cancel)
    self.showForm.subscribe(function (v) { if (!v) self.editId(null); });

    function by(list, cat) { return (list || []).filter(function (l) { return l.category === cat; }); }

    // code -> display name from a loaded lookup array; falls back to the code itself
    function labelOf(list, code) {
      if (!code) return '';
      var hit = (list() || []).filter(function (l) { return l.code === code; })[0];
      return hit ? hit.nameEn : code;
    }
    function titleCase(s) {
      if (!s) return '';
      return String(s).charAt(0).toUpperCase() + String(s).slice(1).toLowerCase();
    }

    // enrich a team row with display labels for the table cells
    function decorate(team) {
      var tc = labelOf(self.types, team.type);
      var cl = labelOf(self.classes, team['class']);
      var ct = team.category ? labelOf(self.cats, team.category) : '';
      team.typeClass = [tc, cl, ct].filter(function (x) { return x; }).join(' · ');
      team.statusName = labelOf(self.statuses, team.status);
      team.healthLabel = titleCase(team.health);
      return team;
    }

    self.load = function () {
      self.loading(true);
      tm.listTeams({ type: self.fType(), 'class': self.fClass(), status: self.fStatus(),
                     search: self.fSearch(), mine: self.fMine() ? 'Y' : '', limit: 100 })
        .then(function (r) { self.teams((r.items || []).map(decorate)); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

    // load lookups first so rows can be decorated with display names, then list teams
    tm.boot().then(function (b) {
      myUid = b.userId;
      self.types(by(b.lookups, 'TM_TEAM_TYPE'));
      self.classes(by(b.lookups, 'TM_TEAM_CLASS'));
      self.cats(by(b.lookups, 'TM_TEAM_CATEGORY'));
      self.statuses(by(b.lookups, 'TM_TEAM_STATUS'));
    }).catch(function () {}).then(function () { self.load(); });

    // RAG/status badge classes
    self.statusClass = function (code) {
      var c = String(code || '').toUpperCase();
      if (c === 'ACTIVE') return 'badge--active';
      if (c === 'ARCHIVED' || c === 'INACTIVE' || c === 'CLOSED') return 'badge--idle';
      if (c === 'ONHOLD' || c === 'ON_HOLD' || c === 'PAUSED') return 'badge--warning';
      return 'badge--info';
    };

    self.open = function (team) { window._jetApp.navigate('teamDetail', { teamId: team.teamId, teamName: team.nameEn }); };

    self.newTeam = function () {
      self.editId(null);
      self.fmName(''); self.fmNameAr(''); self.fmType('INTERNAL'); self.fmClass('OPERATIONAL');
      self.fmCat(''); self.fmObj(''); self.fmStatus(''); self.showForm(true);
    };
    // open the same drawer pre-filled to UPDATE an existing team (loads the full record)
    self.editTeam = function (team) {
      tm.getTeam(team.teamId).then(function (t) {
        self.editId(t.teamId);
        self.fmName(t.nameEn || ''); self.fmNameAr(t.nameAr || '');
        self.fmType(t.type || 'INTERNAL'); self.fmClass(t['class'] || 'OPERATIONAL');
        self.fmCat(t.category || ''); self.fmObj(t.objective || ''); self.fmStatus(t.status || '');
        self.showForm(true);
      }).catch(function () {});
    };
    self.cancel = function () { self.showForm(false); self.editId(null); };
    self.save = function () {
      if (!self.fmName()) { toast.error('Name is required'); return; }
      var body = { nameEn: self.fmName(), nameAr: self.fmNameAr(), type: self.fmType(),
                   'class': self.fmClass(), category: self.fmCat(), objective: self.fmObj() };
      var done = function () { toast.success(self.t('tm.common.saved')); self.showForm(false); self.editId(null); self.load(); };
      if (self.editId()) {
        body.status = self.fmStatus();
        tm.updateTeam(self.editId(), body).then(done).catch(function () {});
      } else {
        body.leaderId = myUid;
        tm.createTeam(body).then(done).catch(function () {});
      }
    };

    self.ragClass = function (rag) { return 'rag rag--' + String(rag || 'GREEN').toLowerCase(); };
  };
});
