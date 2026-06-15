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
    self.counts = ko.observable({});             // per-tab counts (seeded from summary, refined on load)
    self.attention = ko.observableArray([]);     // overview: overdue tasks + open high-sev RAID
    self.upcoming = ko.observableArray([]);      // overview: soonest milestones/deliverables/meetings

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
    self.krDirections = ko.observableArray([]);  // TM_KR_DIRECTION
    self.krUnits = ko.observableArray([]);       // TM_KR_UNIT (suggestions)
    self.isTmAdmin = ko.observable(false);
    self.myUid = ko.observable(null);

    function by(list, cat) { return (list || []).filter(function (l) { return l.category === cat; }); }
    function numOrNull(v) { return (v === '' || v === null || v === undefined) ? null : Number(v); }

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
      self.krDirections(by(b.lookups, 'TM_KR_DIRECTION')); self.krUnits(by(b.lookups, 'TM_KR_UNIT'));
    }).catch(function () {});

    // who can edit team / manage members (TM admin or team leader)
    self.canEditTeam = ko.computed(function () {
      if (self.isTmAdmin()) return true;
      return !!self.team().leaderUserId && self.team().leaderUserId === self.myUid();
    });
    self.canManageMembers = self.canEditTeam;

    // overall task-completion % for the header band (0 when no tasks)
    self.taskPct = ko.computed(function () {
      var t = self.team(), tot = Number(t.taskCount) || 0;
      if (!tot) return 0;
      return Math.round((Number(t.taskDone) || 0) / tot * 100);
    });

    // ---- navigation ---------------------------------------------------------
    self.back = function () { window._jetApp.navigate('teams'); };
    self.setTab = function (k) { self.tab(k); self.adding(''); self.addingMember(false); self.addingDoc(false); self.loadTab(k); };
    self.tabClass = function (k) { return 'tm-tab' + (self.tab() === k ? ' tm-tab--on' : ''); };

    // E2: count pill per tab (null = no pill yet) + attention dot
    function setCount(k, n) { var c = self.counts(); c[k] = n; self.counts(c); }
    self.tabCount = function (k) {
      var c = self.counts();
      return (c[k] === undefined || c[k] === null) ? null : c[k];
    };
    self.tabAttn = function (k) {
      if (k === 'tasks') return (Number(self.team().taskOverdue) || 0) > 0;
      if (k === 'raid')  return (Number(self.team().openRisks)   || 0) > 0;
      return false;
    };

    self.loadTab = function (k) {
      var id = self.teamId;
      if (k === 'overview') self.loadOverview();
      else if (k === 'members') tm.listMembers(id).then(function (r) { self.members(r.items || []); setCount('members', (r.items || []).length); });
      else if (k === 'objectives') tm.listObjectives(id).then(function (r) { self.objectives(r.items || []); setCount('objectives', (r.items || []).length); });
      else if (k === 'tasks') tm.listTasks({ teamId: id, limit: 200 }).then(function (r) { self.tasks(r.items || []); setCount('tasks', (r.items || []).length); });
      else if (k === 'deliverables') tm.listDeliverables(id).then(function (r) { self.deliverables(r.items || []); setCount('deliverables', (r.items || []).length); });
      else if (k === 'raid') tm.listRaid(id, '').then(function (r) { self.raid(r.items || []); setCount('raid', (r.items || []).length); });
      else if (k === 'milestones') tm.listMilestones(id).then(function (r) { self.milestones(r.items || []); setCount('milestones', (r.items || []).length); });
      else if (k === 'meetings') tm.listMeetings(id).then(function (r) { self.meetings(r.items || []); setCount('meetings', (r.items || []).length); });
      else if (k === 'documents') tm.listDocuments({ sourceType: 'TEAM', sourceId: id }).then(function (r) { self.documents(r.items || []); setCount('documents', (r.items || []).length); });
    };

    // E3: overview command panel — build "needs attention" + "upcoming" from existing list endpoints
    self.loadOverview = function () {
      var id = self.teamId;
      Promise.all([
        tm.listTasks({ teamId: id, limit: 200 }).then(function (r) { return r.items || []; }).catch(function () { return []; }),
        tm.listRaid(id, '').then(function (r) { return r.items || []; }).catch(function () { return []; }),
        tm.listMilestones(id).then(function (r) { return r.items || []; }).catch(function () { return []; }),
        tm.listDeliverables(id).then(function (r) { return r.items || []; }).catch(function () { return []; }),
        tm.listMeetings(id).then(function (r) { return r.items || []; }).catch(function () { return []; })
      ]).then(function (res) {
        var tasks = res[0], raid = res[1], ms = res[2], dl = res[3], mt = res[4];
        // keep the tab pills accurate from this single fetch
        setCount('tasks', tasks.length); setCount('raid', raid.length);
        setCount('milestones', ms.length); setCount('deliverables', dl.length); setCount('meetings', mt.length);

        // ---- needs attention: overdue tasks first, then open high/critical RAID ----
        var attn = [];
        tasks.filter(function (t) { return t.isOverdue === 'Y'; })
          .sort(function (a, b) { return (a.dueDate || '').localeCompare(b.dueDate || ''); })
          .forEach(function (t) {
            attn.push({ tone: 'danger', icon: '⏰', title: t.title,
              sub: self.t('tm.tab.tasks') + ' · ' + (t.priority || '') + (t.assignees ? ' · ' + t.assignees : ''),
              when: self.daysLabel(t.dueDate, true), whenColor: 'var(--red)' });
          });
        raid.filter(function (r) { return r.status === 'OPEN' && (r.severity === 'HIGH' || r.severity === 'CRITICAL'); })
          .forEach(function (r) {
            attn.push({ tone: 'warn', icon: '⚠️', title: r.title,
              sub: (r.type || 'RISK') + ' · ' + (r.severity || '') + (r.ownerName ? ' · ' + r.ownerName : ''),
              when: self.t('tm.detail.openLabel'), whenColor: '#b05e1a' });
          });
        self.attention(attn.slice(0, 6));

        // ---- upcoming: future-dated milestones / deliverables / meetings, soonest first ----
        var up = [];
        ms.forEach(function (m) { if (m.dueDate) up.push({ date: m.dueDate, title: m.titleEn, sub: self.t('tm.tab.milestones') }); });
        dl.forEach(function (d) { if (d.dueDate) up.push({ date: d.dueDate, title: d.titleEn, sub: self.t('tm.tab.deliverables') }); });
        mt.forEach(function (m) { if (m.meetingDate) up.push({ date: m.meetingDate, title: m.title, sub: self.t('tm.tab.meetings') }); });
        var today = self.todayStr();
        self.upcoming(up.filter(function (x) { return x.date >= today; })
          .sort(function (a, b) { return a.date.localeCompare(b.date); })
          .slice(0, 5)
          .map(function (x) {
            var dd = self.daysFromNow(x.date);
            return { day: self.upDay(x.date), mon: self.upMon(x.date), title: x.title, sub: x.sub,
              days: self.daysLabel(x.date, false),
              badgeClass: dd <= 3 ? 'badge badge--warn' : 'badge badge--muted' };
          }));
      });
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

    // E4: semantic status / severity → platform badge classes
    self.statusBadge = function (code) {
      var c = String(code || '').toUpperCase();
      if (['DONE', 'ACCEPTED', 'ACHIEVED', 'COMPLETED', 'CLOSED', 'ACTIVE', 'APPROVED'].indexOf(c) >= 0) return 'badge badge--ok';
      if (['BLOCKED', 'CANCELLED', 'REJECTED', 'OVERDUE'].indexOf(c) >= 0) return 'badge badge--danger';
      if (['REVIEW', 'PENDING', 'AT_RISK', 'ON_HOLD', 'ONHOLD'].indexOf(c) >= 0) return 'badge badge--warn';
      if (['IN_PROGRESS', 'PLANNED', 'NOT_STARTED', 'TODO', 'DRAFT'].indexOf(c) >= 0) return 'badge badge--info';
      return 'badge badge--muted';
    };
    self.sevBadge = function (code) {
      var c = String(code || '').toUpperCase();
      if (c === 'CRITICAL' || c === 'HIGH') return 'badge badge--danger';
      if (c === 'MEDIUM') return 'badge badge--warn';
      if (c === 'LOW') return 'badge badge--info';
      return 'badge badge--muted';
    };

    // ---- date helpers (Latin digits) for overview "upcoming" / attention ----
    var MON = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    function pad2(n) { return (n < 10 ? '0' : '') + n; }
    self.todayStr = function () { var d = new Date(); return d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate()); };
    self.upDay = function (s) { return s ? String(Number(s.slice(8, 10))) : ''; };
    self.upMon = function (s) { return s ? (MON[Number(s.slice(5, 7)) - 1] || '') : ''; };
    self.daysFromNow = function (s) {
      if (!s) return 0;
      var a = new Date(s + 'T00:00:00'), b = new Date(self.todayStr() + 'T00:00:00');
      return Math.round((a - b) / 86400000);
    };
    // late=true → "N days late"; else → "today" / "in N days"
    self.daysLabel = function (s, late) {
      var d = self.daysFromNow(s);
      if (late) return Math.abs(d) <= 0 ? self.t('tm.teams.overdue') : (Math.abs(d) + ' ' + self.t('tm.detail.daysLate'));
      if (d <= 0) return self.t('tm.detail.dueToday');
      return d + ' ' + self.t('tm.detail.daysLeft');
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
    self.editId = ko.observable(null);   // record id when the drawer is in edit mode (null = create)
    self.fTitle = ko.observable(''); self.fDesc = ko.observable('');
    self.fStatus = ko.observable(''); self.fPriority = ko.observable('MEDIUM');
    self.fDue = ko.observable(''); self.fType = ko.observable(''); self.fLocation = ko.observable('');
    self.openAdd = function (kind) {
      self.editId(null);
      self.adding(kind); self.fTitle(''); self.fDesc(''); self.fDue(''); self.fLocation('');
      self.fPriority('MEDIUM');
      if (kind === 'task') self.fStatus('TODO');
      else if (kind === 'raid') self.fStatus('OPEN');
      else if (kind === 'milestone') self.fStatus('PENDING');
      else if (kind === 'meeting') self.fStatus('PLANNED');
      else self.fStatus('NOT_STARTED');
      self.fType(kind === 'raid' ? 'ISSUE' : 'DOCUMENT');
    };
    // open the same drawer pre-filled to UPDATE an existing row (deliverable/raid/milestone/meeting)
    self.openEdit = function (kind, row) {
      self.adding(kind);
      self.fTitle(''); self.fDesc(''); self.fDue(''); self.fLocation(''); self.fPriority('MEDIUM'); self.fType('');
      if (kind === 'deliverable') {
        self.fTitle(row.titleEn || ''); self.fDesc(row.description || ''); self.fType(row.type || 'DOCUMENT');
        self.fStatus(row.status || 'NOT_STARTED'); self.fDue(row.dueDate || ''); self.editId(row.deliverableId);
      } else if (kind === 'raid') {
        self.fTitle(row.title || ''); self.fDesc(row.description || ''); self.fType(row.type || 'ISSUE');
        self.fPriority(row.severity || 'MEDIUM'); self.fStatus(row.status || 'OPEN'); self.editId(row.logId);
      } else if (kind === 'milestone') {
        self.fTitle(row.titleEn || ''); self.fDue(row.dueDate || ''); self.fStatus(row.status || 'PENDING');
        self.editId(row.milestoneId);
      } else if (kind === 'meeting') {
        self.fTitle(row.title || ''); self.fDue(row.meetingDate || ''); self.fLocation(row.location || '');
        self.fDesc(row.agenda || ''); self.fStatus(row.status || 'PLANNED'); self.editId(row.meetingId);
      }
    };
    self.cancelAdd = function () { self.adding(''); self.editId(null); };
    // drawer open state for the generic add/edit form (writable so <edit-drawer> can close it)
    self.addOpen = ko.computed({
      read: function () { return !!self.adding(); },
      write: function (v) { if (!v) { self.adding(''); self.editId(null); } }
    });
    self.addTitle = ko.computed(function () {
      var addMap = {
        objective: 'tm.detail.addObjective', task: 'tm.detail.addTask',
        deliverable: 'tm.detail.addDeliverable', raid: 'tm.detail.addRaid',
        milestone: 'tm.detail.addMilestone', meeting: 'tm.detail.addMeeting'
      };
      var editMap = {
        deliverable: 'tm.detail.editDeliverable', raid: 'tm.detail.editRaid',
        milestone: 'tm.detail.editMilestone', meeting: 'tm.detail.editMeeting'
      };
      var k = self.adding();
      if (self.editId()) return self.t(editMap[k] || 'tm.action.edit');
      return self.t(addMap[k] || 'tm.action.add');
    });
    self.saveAdd = function () {
      var id = self.teamId, kind = self.adding(), eid = self.editId();
      if (!self.fTitle()) { toast.error(self.t('tm.detail.titleReq')); return; }
      var ok = function (tab) { return function () { toast.success(self.t('tm.common.saved')); self.adding(''); self.editId(null); self.loadTab(tab); self.refreshTeam(); }; };
      if (kind === 'objective')
        tm.saveObjective({ objectiveId: eid, teamId: id, titleEn: self.fTitle(), description: self.fDesc(), status: self.fStatus(), targetDate: self.fDue() }).then(ok('objectives')).catch(function () {});
      else if (kind === 'task')
        tm.saveTask({ taskId: eid, teamId: id, title: self.fTitle(), description: self.fDesc(), priority: self.fPriority(), status: self.fStatus(), dueDate: self.fDue() }).then(ok('tasks')).catch(function () {});
      else if (kind === 'deliverable')
        tm.saveDeliverable({ deliverableId: eid, teamId: id, titleEn: self.fTitle(), description: self.fDesc(), type: self.fType(), status: self.fStatus(), dueDate: self.fDue() }).then(ok('deliverables')).catch(function () {});
      else if (kind === 'raid')
        tm.saveRaid({ logId: eid, teamId: id, type: self.fType(), title: self.fTitle(), description: self.fDesc(), severity: self.fPriority(), status: self.fStatus() }).then(ok('raid')).catch(function () {});
      else if (kind === 'milestone')
        tm.saveMilestone({ milestoneId: eid, teamId: id, titleEn: self.fTitle(), dueDate: self.fDue(), status: self.fStatus() }).then(ok('milestones')).catch(function () {});
      else if (kind === 'meeting')
        tm.saveMeeting({ meetingId: eid, teamId: id, title: self.fTitle(), meetingDate: self.fDue(), location: self.fLocation(), agenda: self.fDesc(), status: self.fStatus() }).then(ok('meetings')).catch(function () {});
    };

    // ---- members ------------------------------------------------------------
    self.addingMember = ko.observable(false);
    self.memberEditId = ko.observable(null);   // userId being edited (null = add a new member)
    self.mUser = ko.observable(''); self.mRole = ko.observable('MEMBER'); self.mTitle = ko.observable('');
    self.mEditName = ko.observable('');         // display name of the member being edited
    self.openAddMember = function () {
      if (!self.allUsers().length) self.refreshUsers();
      self.memberEditId(null);
      self.mUser(''); self.mRole('MEMBER'); self.mTitle(''); self.mEditName(''); self.addingMember(true);
    };
    self.openEditMember = function (m) {
      self.mUser(m.userId); self.mRole(m.roleCode || 'MEMBER'); self.mTitle(m.title || '');
      self.mEditName(m.name || ''); self.memberEditId(m.userId); self.addingMember(true);
    };
    self.cancelAddMember = function () { self.addingMember(false); self.memberEditId(null); };
    self.memberOpen = ko.computed({
      read: function () { return self.addingMember(); },
      write: function (v) { if (!v) { self.addingMember(false); self.memberEditId(null); } }
    });
    self.memberDrawerTitle = ko.computed(function () {
      return self.t(self.memberEditId() ? 'tm.detail.editMember' : 'tm.detail.addMember');
    });
    self.memberSaveLabel = ko.computed(function () {
      return self.t(self.memberEditId() ? 'tm.action.saveChanges' : 'tm.action.add');
    });
    self.saveMember = function () {
      if (!self.mUser()) { toast.error(self.t('tm.detail.selectUser')); return; }
      var done = function () { toast.success(self.t('tm.common.saved')); self.addingMember(false); self.memberEditId(null); self.loadTab('members'); self.refreshTeam(); };
      if (self.memberEditId())
        tm.updateMember({ teamId: self.teamId, userId: self.memberEditId(), roleCode: self.mRole(), title: self.mTitle() }).then(done).catch(function () {});
      else
        tm.addMember({ teamId: self.teamId, userId: self.mUser(), roleCode: self.mRole(), title: self.mTitle() }).then(done).catch(function () {});
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
    self.docEditId = ko.observable(null);   // doc_id being edited (null = upload a new document)
    self.dFileName = ko.observable(''); self.dDocType = ko.observable('OTHER'); self.dNotes = ko.observable('');
    self._docB64 = null; self._docMime = null; self._docSize = null;
    self.openAddDoc = function () { self.docEditId(null); self.addingDoc(true); self.dFileName(''); self.dDocType('OTHER'); self.dNotes(''); self._docB64 = null; self._docMime = null; self._docSize = null; };
    self.openEditDoc = function (d) {
      self.docEditId(d.docId); self.dFileName(d.fileName || ''); self.dDocType(d.docTypeCode || 'OTHER'); self.dNotes(d.notes || '');
      self._docB64 = null; self._docMime = null; self._docSize = null; self.addingDoc(true);
    };
    self.cancelAddDoc = function () { self.addingDoc(false); self.docEditId(null); };
    self.docOpen = ko.computed({
      read: function () { return self.addingDoc(); },
      write: function (v) { if (!v) { self.addingDoc(false); self.docEditId(null); } }
    });
    self.docDrawerTitle = ko.computed(function () {
      return self.t(self.docEditId() ? 'tm.detail.editDocument' : 'tm.detail.addDocument');
    });
    self.docSaveLabel = ko.computed(function () {
      return self.t(self.docEditId() ? 'tm.action.saveChanges' : 'tm.action.upload');
    });
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
      var done = function () { toast.success(self.t('tm.common.saved')); self.addingDoc(false); self.docEditId(null); self.loadTab('documents'); };
      if (self.docEditId())
        tm.updateDocument({ docId: self.docEditId(), fileName: self.dFileName(), docTypeCode: self.dDocType(), notes: self.dNotes() }).then(done).catch(function () {});
      else
        tm.addDocument({
          teamId: self.teamId, sourceType: 'TEAM', sourceId: self.teamId,
          fileName: self.dFileName(), docTypeCode: self.dDocType(), notes: self.dNotes(),
          mimeType: self._docMime, fileSize: self._docSize, fileB64: self._docB64
        }).then(done).catch(function () {});
    };

    // ---- objectives: remove + measurable-objective drawer (key results) -----
    self.removeObjective = function (o) {
      if (!window.confirm(self.t('tm.detail.confirmRemove'))) return;
      tm.deleteObjective(o.objectiveId)
        .then(function () { toast.success(self.t('tm.common.removed')); self.loadTab('objectives'); self.refreshTeam(); }).catch(function () {});
    };

    self.selObj = ko.observable(null);
    self.keyResults = ko.observableArray([]);
    self.oTitle = ko.observable(''); self.oDesc = ko.observable(''); self.oStatus = ko.observable('NOT_STARTED');
    self.oTarget = ko.observable(''); self.oWeight = ko.observable(1);
    self.oMode = ko.observable('AUTO'); self.oProgress = ko.observable(0);

    self.openObjective = function (o) {
      self.selObj(o);
      self.oTitle(o.titleEn || ''); self.oDesc(o.description || ''); self.oStatus(o.status || 'NOT_STARTED');
      self.oTarget(o.targetDate || ''); self.oWeight(o.weight || 1);
      self.oMode(o.progressMode || 'AUTO'); self.oProgress(o.progress || 0);
      self.krFormOpen(false); self.editKrId(null);
      self.loadKrs(o.objectiveId);
    };
    self.closeObjective = function () { self.selObj(null); };
    self.loadKrs = function (objId) { tm.listKeyResults(objId).then(function (r) { self.keyResults(r.items || []); }).catch(function () {}); };

    // re-pull objectives and re-sync the open drawer's progress/mode after a KR change
    self.refreshObjAfterKr = function () {
      var o = self.selObj(); if (!o) return;
      tm.listObjectives(self.teamId).then(function (r) {
        self.objectives(r.items || []);
        var f = (r.items || []).filter(function (x) { return x.objectiveId === o.objectiveId; })[0];
        if (f) { self.selObj(f); self.oProgress(f.progress || 0); self.oMode(f.progressMode || 'AUTO'); }
      }).catch(function () {});
    };

    self.saveObjEdits = function () {
      if (!self.oTitle()) { toast.error(self.t('tm.detail.titleReq')); return; }
      var o = self.selObj();
      tm.saveObjective({
        teamId: self.teamId, objectiveId: o.objectiveId, titleEn: self.oTitle(), description: self.oDesc(),
        status: self.oStatus(), targetDate: self.oTarget(), weight: Number(self.oWeight()) || 1,
        progress: self.oMode() === 'MANUAL' ? Number(self.oProgress()) : null, progressMode: self.oMode()
      }).then(function () { toast.success(self.t('tm.common.saved')); self.refreshObjAfterKr(); self.refreshTeam(); }).catch(function () {});
    };

    // key-result add/edit form
    self.krFormOpen = ko.observable(false); self.editKrId = ko.observable(null);
    self.kTitle = ko.observable(''); self.kUnit = ko.observable(''); self.kDir = ko.observable('INCREASE');
    self.kBase = ko.observable(''); self.kTarget = ko.observable(''); self.kCurrent = ko.observable('');
    self.kWeight = ko.observable(1); self.kDue = ko.observable(''); self.kStatus = ko.observable('NOT_STARTED');
    self.openAddKr = function () {
      self.editKrId(null);
      self.kTitle(''); self.kUnit(''); self.kDir('INCREASE');
      self.kBase(''); self.kTarget(''); self.kCurrent(''); self.kWeight(1); self.kDue(''); self.kStatus('NOT_STARTED');
      self.krFormOpen(true);
    };
    self.editKr = function (kr) {
      self.editKrId(kr.krId);
      self.kTitle(kr.titleEn || ''); self.kUnit(kr.unit || ''); self.kDir(kr.direction || 'INCREASE');
      self.kBase(kr.baseline != null ? kr.baseline : ''); self.kTarget(kr.target != null ? kr.target : '');
      self.kCurrent(kr.current != null ? kr.current : ''); self.kWeight(kr.weight || 1);
      self.kDue(kr.targetDate || ''); self.kStatus(kr.status || 'NOT_STARTED');
      self.krFormOpen(true);
    };
    self.cancelKr = function () { self.krFormOpen(false); };
    self.saveKr = function () {
      if (!self.kTitle()) { toast.error(self.t('tm.detail.titleReq')); return; }
      if (self.kTarget() === '' || self.kTarget() === null) { toast.error(self.t('tm.detail.targetReq')); return; }
      tm.saveKeyResult({
        objectiveId: self.selObj().objectiveId, krId: self.editKrId() || null, titleEn: self.kTitle(),
        unit: self.kUnit(), direction: self.kDir(), baseline: numOrNull(self.kBase()),
        target: numOrNull(self.kTarget()), current: numOrNull(self.kCurrent()), weight: Number(self.kWeight()) || 1,
        targetDate: self.kDue(), status: self.kStatus()
      }).then(function () {
        toast.success(self.t('tm.common.saved')); self.krFormOpen(false);
        self.loadKrs(self.selObj().objectiveId); self.refreshObjAfterKr();
      }).catch(function () {});
    };
    self.recordKr = function (kr) {
      tm.recordKrValue(kr.krId, numOrNull(kr.current))
        .then(function () { toast.success(self.t('tm.common.saved')); self.loadKrs(self.selObj().objectiveId); self.refreshObjAfterKr(); })
        .catch(function () { self.loadKrs(self.selObj().objectiveId); });
    };
    self.removeKr = function (kr) {
      if (!window.confirm(self.t('tm.detail.confirmRemove'))) return;
      tm.deleteKeyResult(kr.krId)
        .then(function () { toast.success(self.t('tm.common.removed')); self.loadKrs(self.selObj().objectiveId); self.refreshObjAfterKr(); })
        .catch(function () {});
    };

    // ---- refreshers ---------------------------------------------------------
    self.refreshTeam = function () {
      tm.getTeam(self.teamId).then(function (t0) {
        self.team(t0);
        // seed tab-count pills from the summary (refined to real lengths as tabs load)
        var c = self.counts();
        if (t0.memberCount != null) c.members = t0.memberCount;
        if (t0.objectiveCount != null) c.objectives = t0.objectiveCount;
        if (t0.taskCount != null) c.tasks = t0.taskCount;
        if (t0.deliverableCount != null) c.deliverables = t0.deliverableCount;
        self.counts(c);
      }).catch(function () {});
    };
    self.refreshUsers = function () { tm.listUsers('').then(function (r) { self.allUsers(r.items || []); }).catch(function () {}); };

    // ---- boot ---------------------------------------------------------------
    self.refreshTeam();
    tm.listMembers(self.teamId).then(function (r) { self.members(r.items || []); }).catch(function () {});
    self.refreshUsers();
    self.loadTab(self.tab());
  };
});
