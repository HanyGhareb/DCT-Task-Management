define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function TeamDetail() {
    var self = this;
    self.t = i18n.t;
    var st = (window._jetApp && window._jetApp.getState()) || {};
    self.teamId = st.teamId;
    self.tab = ko.observable(st.tab || 'overview');

    self.tabs = [
      { key: 'overview',     label: 'tm.tab.overview' },
      { key: 'members',      label: 'tm.tab.members' },
      { key: 'objectives',   label: 'tm.tab.objectives' },
      { key: 'tasks',        label: 'tm.tab.tasks' },
      { key: 'deliverables', label: 'tm.tab.deliverables' },
      { key: 'raid',         label: 'tm.tab.raid' },
      { key: 'milestones',   label: 'tm.tab.milestones' },
      { key: 'meetings',     label: 'tm.tab.meetings' },
      { key: 'documents',    label: 'tm.tab.documents' }
    ];

    // ---- data ---------------------------------------------------------------
    self.team = ko.observable({});
    self.members = ko.observableArray([]);
    self.objectives = ko.observableArray([]);
    self.tasks = ko.observableArray([]);
    self.deliverables = ko.observableArray([]);
    self.raid = ko.observableArray([]);
    self.milestones = ko.observableArray([]);
    self.meetings = ko.observableArray([]);
    self.documents = ko.observableArray([]);
    self.allUsers = ko.observableArray([]);      // active users for pickers

    // ---- lookups / refs -----------------------------------------------------
    self.priorities = ko.observableArray([]); self.taskStatuses = ko.observableArray([]);
    self.objStatuses = ko.observableArray([]); self.delivTypes = ko.observableArray([]);
    self.delivStatuses = ko.observableArray([]); self.logTypes = ko.observableArray([]);
    self.severities = ko.observableArray([]); self.logStatuses = ko.observableArray([]);
    self.msStatuses = ko.observableArray([]);
    self.types = ko.observableArray([]); self.classes = ko.observableArray([]);
    self.cats = ko.observableArray([]); self.statuses = ko.observableArray([]);
    self.teamRoles = ko.observableArray([]);     // team-scoped roles (Leader/Member…)
    self.docTypes = ko.observableArray([]);
    self.isTmAdmin = ko.observable(false);
    self.myUid = ko.observable(null);

    function by(list, cat) { return (list || []).filter(function (l) { return l.category === cat; }); }

    // members usable as new members = active users not already on the team
    self.assignableUsers = ko.computed(function () {
      var have = {}; self.members().forEach(function (m) { have[m.userId] = 1; });
      return self.allUsers().filter(function (u) { return !have[u.userId]; });
    });

    tm.boot().then(function (b) {
      self.myUid(b.userId); self.isTmAdmin(b.isTmAdmin === 'Y' || b.isTmAdmin === true);
      self.priorities(by(b.lookups, 'TM_TASK_PRIORITY')); self.taskStatuses(by(b.lookups, 'TM_TASK_STATUS'));
      self.objStatuses(by(b.lookups, 'TM_OBJECTIVE_STATUS')); self.delivTypes(by(b.lookups, 'TM_DELIVERABLE_TYPE'));
      self.delivStatuses(by(b.lookups, 'TM_DELIVERABLE_STATUS')); self.logTypes(by(b.lookups, 'TM_LOG_ITEM_TYPE'));
      self.severities(by(b.lookups, 'TM_LOG_SEVERITY')); self.logStatuses(by(b.lookups, 'TM_LOG_STATUS'));
      self.msStatuses(by(b.lookups, 'TM_OBJECTIVE_STATUS')); // milestones share the objective-status set
      self.types(by(b.lookups, 'TM_TEAM_TYPE')); self.classes(by(b.lookups, 'TM_TEAM_CLASS'));
      self.cats(by(b.lookups, 'TM_TEAM_CATEGORY')); self.statuses(by(b.lookups, 'TM_TEAM_STATUS'));
      self.teamRoles(b.roles || []);
      self.docTypes(b.docTypes || []);
    }).catch(function () {});

    // who can edit team / manage members (TM admin or team leader)
    self.canEditTeam = ko.computed(function () {
      if (self.isTmAdmin()) return true;
      return !!self.team().leaderUserId && self.team().leaderUserId === self.myUid();
    });
    self.canManageMembers = self.canEditTeam;

    // ---- navigation ---------------------------------------------------------
    self.back = function () { window._jetApp.navigate('teams'); };
    self.setTab = function (k) { self.tab(k); self.adding(''); self.addingMember(false); self.addingDoc(false); self.loadTab(k); };
    self.tabClass = function (k) { return 'tm-tab' + (self.tab() === k ? ' tm-tab--on' : ''); };

    self.loadTab = function (k) {
      var id = self.teamId;
      if (k === 'members') tm.listMembers(id).then(function (r) { self.members(r.items || []); });
      else if (k === 'objectives') tm.listObjectives(id).then(function (r) { self.objectives(r.items || []); });
      else if (k === 'tasks') tm.listTasks({ teamId: id, limit: 200 }).then(function (r) { self.tasks(r.items || []); });
      else if (k === 'deliverables') tm.listDeliverables(id).then(function (r) { self.deliverables(r.items || []); });
      else if (k === 'raid') tm.listRaid(id, '').then(function (r) { self.raid(r.items || []); });
      else if (k === 'milestones') tm.listMilestones(id).then(function (r) { self.milestones(r.items || []); });
      else if (k === 'meetings') tm.listMeetings(id).then(function (r) { self.meetings(r.items || []); });
      else if (k === 'documents') tm.listDocuments({ sourceType: 'TEAM', sourceId: id }).then(function (r) { self.documents(r.items || []); });
    };

    // ---- display helpers ----------------------------------------------------
    self.prioClass = function (p) { return 'prio--' + p; };
    self.ragClass = function (rag) { return 'rag rag--' + String(rag || 'GREEN').toLowerCase(); };
    self.initials = function (name) {
      if (!name) return '?';
      var p = String(name).trim().split(/\s+/);
      return ((p[0] || '')[0] || '' + (p.length > 1 ? (p[p.length - 1][0] || '') : '')).toUpperCase().slice(0, 2) ||
             String(name)[0].toUpperCase();
    };
    self.statusLabel = function (code) {
      var f = self.taskStatuses().filter(function (s) { return s.code === code; })[0];
      return f ? f.nameEn : code;
    };

    // ---- Kanban -------------------------------------------------------------
    self.KANBAN = ['TODO', 'IN_PROGRESS', 'BLOCKED', 'REVIEW', 'DONE'];
    self.colTasks = function (status) {
      return self.tasks().filter(function (tk) { return tk.status === status; });
    };
    self._drag = null;
    self.onDragStart = function (tk, e) { self._drag = tk.taskId; if (e.dataTransfer) e.dataTransfer.effectAllowed = 'move'; return true; };
    self.onDragOver = function (status, e) { e.preventDefault(); return false; };
    self.onDrop = function (status, e) {
      e.preventDefault();
      if (self._drag) {
        tm.setTaskStatus({ taskId: self._drag, status: status })
          .then(function () { self._drag = null; self.loadTab('tasks'); }).catch(function () {});
      }
      return false;
    };

    // ---- generic add-forms (objective/task/deliverable/raid/milestone/meeting)
    self.adding = ko.observable('');
    self.fTitle = ko.observable(''); self.fDesc = ko.observable('');
    self.fStatus = ko.observable(''); self.fPriority = ko.observable('MEDIUM');
    self.fDue = ko.observable(''); self.fType = ko.observable(''); self.fLocation = ko.observable('');
    self.openAdd = function (kind) {
      self.adding(kind); self.fTitle(''); self.fDesc(''); self.fDue(''); self.fLocation('');
      self.fPriority('MEDIUM');
      if (kind === 'task') self.fStatus('TODO');
      else if (kind === 'raid') self.fStatus('OPEN');
      else if (kind === 'milestone') self.fStatus('PENDING');
      else if (kind === 'meeting') self.fStatus('PLANNED');
      else self.fStatus('NOT_STARTED');
      self.fType(kind === 'raid' ? 'ISSUE' : 'DOCUMENT');
    };
    self.cancelAdd = function () { self.adding(''); };
    self.saveAdd = function () {
      var id = self.teamId, kind = self.adding();
      if (!self.fTitle()) { toast.error(self.t('tm.detail.titleReq')); return; }
      var ok = function (tab) { return function () { toast.success(self.t('tm.common.saved')); self.adding(''); self.loadTab(tab); self.refreshTeam(); }; };
      if (kind === 'objective')
        tm.saveObjective({ teamId: id, titleEn: self.fTitle(), description: self.fDesc(), status: self.fStatus(), targetDate: self.fDue() }).then(ok('objectives')).catch(function () {});
      else if (kind === 'task')
        tm.saveTask({ teamId: id, title: self.fTitle(), description: self.fDesc(), priority: self.fPriority(), status: self.fStatus(), dueDate: self.fDue() }).then(ok('tasks')).catch(function () {});
      else if (kind === 'deliverable')
        tm.saveDeliverable({ teamId: id, titleEn: self.fTitle(), description: self.fDesc(), type: self.fType(), status: self.fStatus(), dueDate: self.fDue() }).then(ok('deliverables')).catch(function () {});
      else if (kind === 'raid')
        tm.saveRaid({ teamId: id, type: self.fType(), title: self.fTitle(), description: self.fDesc(), severity: self.fPriority(), status: self.fStatus() }).then(ok('raid')).catch(function () {});
      else if (kind === 'milestone')
        tm.saveMilestone({ teamId: id, titleEn: self.fTitle(), dueDate: self.fDue(), status: self.fStatus() }).then(ok('milestones')).catch(function () {});
      else if (kind === 'meeting')
        tm.saveMeeting({ teamId: id, title: self.fTitle(), meetingDate: self.fDue(), location: self.fLocation(), agenda: self.fDesc(), status: self.fStatus() }).then(ok('meetings')).catch(function () {});
    };

    // ---- members ------------------------------------------------------------
    self.addingMember = ko.observable(false);
    self.mUser = ko.observable(''); self.mRole = ko.observable('MEMBER'); self.mTitle = ko.observable('');
    self.openAddMember = function () {
      if (!self.allUsers().length) self.refreshUsers();
      self.mUser(''); self.mRole('MEMBER'); self.mTitle(''); self.addingMember(true);
    };
    self.cancelAddMember = function () { self.addingMember(false); };
    self.saveMember = function () {
      if (!self.mUser()) { toast.error(self.t('tm.detail.selectUser')); return; }
      tm.addMember({ teamId: self.teamId, userId: self.mUser(), roleCode: self.mRole(), title: self.mTitle() })
        .then(function () { toast.success(self.t('tm.common.saved')); self.addingMember(false); self.loadTab('members'); self.refreshTeam(); })
        .catch(function () {});
    };
    self.changeRole = function (m) {
      tm.setMemberRole({ teamId: self.teamId, userId: m.userId, roleCode: m.roleCode })
        .then(function () { toast.success(self.t('tm.common.saved')); self.loadTab('members'); }).catch(function () { self.loadTab('members'); });
    };
    self.removeMember = function (m) {
      if (!window.confirm(self.t('tm.detail.confirmRemove'))) return;
      tm.removeMember({ teamId: self.teamId, userId: m.userId })
        .then(function () { toast.success(self.t('tm.common.removed')); self.loadTab('members'); self.refreshTeam(); }).catch(function () {});
    };

    // ---- edit team ----------------------------------------------------------
    self.showEdit = ko.observable(false);
    self.eName = ko.observable(''); self.eNameAr = ko.observable('');
    self.eType = ko.observable(''); self.eClass = ko.observable(''); self.eCat = ko.observable('');
    self.eStatus = ko.observable(''); self.eLeader = ko.observable('');
    self.eStart = ko.observable(''); self.eEnd = ko.observable('');
    self.eObj = ko.observable(''); self.ePurpose = ko.observable('');
    self.editTeam = function () {
      if (!self.allUsers().length) self.refreshUsers();
      var t = self.team();
      self.eName(t.nameEn || ''); self.eNameAr(t.nameAr || '');
      self.eType(t.type || ''); self.eClass(t['class'] || ''); self.eCat(t.category || '');
      self.eStatus(t.status || ''); self.eLeader(t.leaderUserId || '');
      self.eStart(t.startDate || ''); self.eEnd(t.endDate || '');
      self.eObj(t.objective || ''); self.ePurpose(t.purpose || '');
      self.showEdit(true);
    };
    self.saveTeam = function () {
      if (!self.eName()) { toast.error(self.t('tm.detail.nameReq')); return; }
      tm.updateTeam(self.teamId, {
        nameEn: self.eName(), nameAr: self.eNameAr(), type: self.eType(), 'class': self.eClass(),
        category: self.eCat(), status: self.eStatus(), leaderId: self.eLeader() || null,
        objective: self.eObj(), purpose: self.ePurpose()
      }).then(function () { toast.success(self.t('tm.common.saved')); self.showEdit(false); self.refreshTeam(); }).catch(function () {});
    };

    // ---- task drawer --------------------------------------------------------
    self.selTask = ko.observable(null);
    self.taskAssignees = ko.observableArray([]);
    self.taskUpdates = ko.observableArray([]);
    self.tStatus = ko.observable(''); self.tProgress = ko.observable(0);
    self.assignUser = ko.observable(''); self.newComment = ko.observable('');
    self.openTask = function (task) {
      self.selTask(task); self.tStatus(task.status); self.tProgress(task.progress || 0);
      self.assignUser(''); self.newComment('');
      if (!self.members().length) tm.listMembers(self.teamId).then(function (r) { self.members(r.items || []); });
      self.loadTaskPanel(task.taskId);
    };
    self.closeTask = function () { self.selTask(null); };
    self.loadTaskPanel = function (taskId) {
      tm.taskAssignees(taskId).then(function (r) { self.taskAssignees(r.items || []); }).catch(function () {});
      tm.taskUpdates(taskId).then(function (r) { self.taskUpdates(r.items || []); }).catch(function () {});
    };
    self.doAssign = function (primary) {
      if (!self.assignUser()) { toast.error(self.t('tm.detail.selectMember')); return; }
      tm.assignTask({ taskId: self.selTask().taskId, userId: self.assignUser(), primary: primary ? 'Y' : 'N' })
        .then(function () { toast.success(self.t('tm.common.saved')); self.assignUser(''); self.loadTaskPanel(self.selTask().taskId); self.loadTab('tasks'); }).catch(function () {});
    };
    self.makePrimary = function (a) {
      tm.assignTask({ taskId: self.selTask().taskId, userId: a.userId, primary: 'Y' })
        .then(function () { toast.success(self.t('tm.common.saved')); self.loadTaskPanel(self.selTask().taskId); self.loadTab('tasks'); }).catch(function () {});
    };
    self.unassign = function (a) {
      tm.assignTask({ taskId: self.selTask().taskId, userId: a.userId, remove: 'Y' })
        .then(function () { toast.success(self.t('tm.common.removed')); self.loadTaskPanel(self.selTask().taskId); self.loadTab('tasks'); }).catch(function () {});
    };
    self.saveTaskStatus = function () {
      tm.setTaskStatus({ taskId: self.selTask().taskId, status: self.tStatus(), progress: Number(self.tProgress()) })
        .then(function () { toast.success(self.t('tm.common.saved')); self.loadTaskPanel(self.selTask().taskId); self.loadTab('tasks'); }).catch(function () {});
    };
    self.addComment = function () {
      if (!self.newComment()) return;
      tm.addTaskUpdate({ taskId: self.selTask().taskId, body: self.newComment(), type: 'COMMENT' })
        .then(function () { self.newComment(''); self.loadTaskPanel(self.selTask().taskId); }).catch(function () {});
    };

    // ---- documents ----------------------------------------------------------
    self.addingDoc = ko.observable(false);
    self.dFileName = ko.observable(''); self.dDocType = ko.observable('OTHER'); self.dNotes = ko.observable('');
    self._docB64 = null; self._docMime = null; self._docSize = null;
    self.openAddDoc = function () { self.addingDoc(true); self.dFileName(''); self.dDocType('OTHER'); self.dNotes(''); self._docB64 = null; self._docMime = null; self._docSize = null; };
    self.cancelAddDoc = function () { self.addingDoc(false); };
    self.onFilePick = function (e) {
      var f = e.target.files && e.target.files[0];
      if (!f) return true;
      if (f.size > 24000) { toast.error(self.t('tm.detail.fileTooBig')); e.target.value = ''; return true; }
      self.dFileName(f.name); self._docMime = f.type || 'application/octet-stream'; self._docSize = f.size;
      var reader = new FileReader();
      reader.onload = function () { self._docB64 = String(reader.result).split(',').pop(); };
      reader.readAsDataURL(f);
      return true;
    };
    self.saveDoc = function () {
      if (!self.dFileName()) { toast.error(self.t('tm.detail.fileNameReq')); return; }
      tm.addDocument({
        teamId: self.teamId, sourceType: 'TEAM', sourceId: self.teamId,
        fileName: self.dFileName(), docTypeCode: self.dDocType(), notes: self.dNotes(),
        mimeType: self._docMime, fileSize: self._docSize, fileB64: self._docB64
      }).then(function () { toast.success(self.t('tm.common.saved')); self.addingDoc(false); self.loadTab('documents'); }).catch(function () {});
    };

    // ---- refreshers ---------------------------------------------------------
    self.refreshTeam = function () { tm.getTeam(self.teamId).then(function (t0) { self.team(t0); }).catch(function () {}); };
    self.refreshUsers = function () { tm.listUsers('').then(function (r) { self.allUsers(r.items || []); }).catch(function () {}); };

    // ---- boot ---------------------------------------------------------------
    self.refreshTeam();
    tm.listMembers(self.teamId).then(function (r) { self.members(r.items || []); }).catch(function () {});
    self.refreshUsers();
    self.loadTab(self.tab());
  };
});
