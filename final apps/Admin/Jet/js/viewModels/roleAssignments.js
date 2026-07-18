/**
 * roleAssignments.js — Admin → Role Assignments (WF_ADMIN / SYS_ADMIN).
 *
 * Date-tracked assignment of users to workflow roles (FBP, PBP, Approver,
 * Planner, FYI Group…) against business objects (Project, Task, Cost Center,
 * Sector, Department…). The workflow engine resolves these at runtime as of
 * each request's SUBMISSION date, so this page is where the business changes
 * who approves what — with full history, nothing is ever deleted.
 *
 * Tab 1: assignments — filter, create (object picker per type), end, replace,
 *        timeline; a live preview shows who holds the role before saving.
 * Tab 2: audit — every create/end/replace/void with search criteria + CSV.
 */
define(['knockout', 'shared/api', 'shared/wfService', 'shared/i18n'],
function (ko, api, wf, i18n) {
  'use strict';

  function today() {
    var d = new Date();
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0')
         + '-' + String(d.getDate()).padStart(2, '0');
  }

  function RoleAssignmentsViewModel() {
    var self = this;
    self.t = i18n.t;

    self.tab     = ko.observable('list');
    self.loading = ko.observable(true);
    self.error   = ko.observable(null);

    /* ── metadata ──────────────────────────────────────────────────────── */
    self.objTypes = ko.observableArray([]);
    self.roles    = ko.observableArray([]);
    self.users    = ko.observableArray([]);
    self.typeName = function (code) {
      var t = self.objTypes().filter(function (x) { return x.code === code; })[0];
      if (!t) return code;
      return (i18n.lang() === 'ar' && t.nameAr) ? t.nameAr : t.nameEn;
    };
    self.roleName = function (code) {
      var r = self.roles().filter(function (x) { return x.roleCode === code; })[0];
      if (!r) return code;
      return (i18n.lang() === 'ar' && r.nameAr) ? r.nameAr : r.nameEn;
    };
    self.typeMeta = function (code) {
      return self.objTypes().filter(function (x) { return x.code === code; })[0] || null;
    };

    /* ── tab 1: the assignment list ────────────────────────────────────── */
    self.fType     = ko.observable('');
    self.fKey      = ko.observable('');
    self.fRole     = ko.observable('');
    self.fStatus   = ko.observable('');
    self.fActiveOn = ko.observable('');
    self.rows   = ko.observableArray([]);
    self.total  = ko.observable(0);
    self.limit  = 50;
    self.offset = ko.observable(0);

    self.search = function () { self.offset(0); self.loadList(); };
    self.resetFilters = function () {
      self.fType(''); self.fKey(''); self.fRole(''); self.fStatus(''); self.fActiveOn('');
      self.search();
    };
    self.loadList = function () {
      self.loading(true); self.error(null);
      return wf.assignList({
        type: self.fType(), key: self.fKey(), role: self.fRole(),
        status: self.fStatus(), activeon: self.fActiveOn(),
        limit: self.limit, offset: self.offset()
      }).then(function (r) {
        self.rows((r && r.items) || []);
        self.total((r && r.total) || 0);
        self.loading(false);
      }).catch(function (e) {
        self.error(e && e.message); self.loading(false);
      });
    };
    self.pageInfo = ko.pureComputed(function () {
      var from = self.total() ? self.offset() + 1 : 0;
      return from + '–' + Math.min(self.offset() + self.limit, self.total())
           + ' / ' + self.total();
    });
    self.nextPage = function () {
      if (self.offset() + self.limit < self.total()) {
        self.offset(self.offset() + self.limit); self.loadList();
      }
    };
    self.prevPage = function () {
      if (self.offset() > 0) {
        self.offset(Math.max(0, self.offset() - self.limit)); self.loadList();
      }
    };
    self.statusClass = function (s) {
      return { ACTIVE: 'badge-success', FUTURE: 'badge-info',
               ENDED: 'badge-muted', VOID: 'badge-danger' }[s] || '';
    };

    /* ── create drawer ─────────────────────────────────────────────────── */
    self.showEdit   = ko.observable(false);
    self.editError  = ko.observable(null);
    self.saving     = ko.observable(false);
    self.cType      = ko.observable('');
    self.cRole      = ko.observable('');
    self.cUserId    = ko.observable('');
    self.cStart     = ko.observable(today());
    self.cEnd       = ko.observable('');
    self.cNotes     = ko.observable('');
    self.cObjSearch = ko.observable('');
    self.cObjOptions = ko.observableArray([]);   // { key, label, depth }
    self.cObjKey    = ko.observable('');
    self.cParentSearch  = ko.observable('');
    self.cParentOptions = ko.observableArray([]);
    self.cParentKey = ko.observable('');
    self.cPreview   = ko.observable(null);

    self.cTwoPart = ko.pureComputed(function () {
      var t = self.typeMeta(self.cType()); return !!(t && t.twoPart === 'Y');
    });
    self.cKey2Label = ko.pureComputed(function () {
      var t = self.typeMeta(self.cType());
      if (!t) return '';
      return (i18n.lang() === 'ar' && t.key2LabelAr) ? t.key2LabelAr : (t.key2LabelEn || '');
    });

    // org LOVs return the tree; indent children so the picker reads as one
    function indent(items) {
      var byKey = {}, out = [];
      items.forEach(function (i) { byKey[i.key] = i; });
      items.forEach(function (i) {
        var d = 0, p = i.parent;
        while (p && byKey[p] && d < 8) { d += 1; p = byKey[p].parent; }
        out.push({ key: i.key, depth: d,
                   label: new Array(d + 1).join(' ') + i.label });
      });
      return out;
    }

    self.searchObjects = function () {
      var type = self.cType(); if (!type) return;
      if (self.cTwoPart()) {
        // two-part: the FIRST key comes from the parent picker; this lists key2
        if (!self.cParentKey()) { self.cObjOptions([]); return; }
        wf.assignLov(type, self.cObjSearch(), self.cParentKey()).then(function (items) {
          self.cObjOptions(items.map(function (i) { return { key: i.key, label: i.key + ' — ' + (i.label || '') }; }));
        });
      } else {
        wf.assignLov(type, self.cObjSearch()).then(function (items) {
          var t = self.typeMeta(type);
          self.cObjOptions(t && t.hierarchy === 'ORG'
            ? indent(items)
            : items.map(function (i) { return { key: i.key, label: i.key + ' — ' + (i.label || '') }; }));
        });
      }
    };
    // TASK's parent list is the PROJECT LOV (the only two-part type today)
    self.searchParents = function () {
      wf.assignLov('PROJECT', self.cParentSearch()).then(function (items) {
        self.cParentOptions(items.map(function (i) { return { key: i.key, label: i.key + ' — ' + (i.label || '') }; }));
      });
    };

    self.refreshPreview = function () {
      var type = self.cType(), role = self.cRole();
      var key  = self.cTwoPart() ? self.cParentKey() : self.cObjKey();
      var key2 = self.cTwoPart() ? self.cObjKey() : null;
      if (!type || !role || !key) { self.cPreview(null); return; }
      wf.assignPreview(type, key, key2, role).then(function (r) {
        self.cPreview(r || { users: [], count: 0 });
      }).catch(function () { self.cPreview(null); });
    };
    [self.cObjKey, self.cRole, self.cParentKey].forEach(function (o) {
      o.subscribe(self.refreshPreview);
    });
    self.cType.subscribe(function () {
      self.cObjKey(''); self.cObjOptions([]); self.cObjSearch('');
      self.cParentKey(''); self.cParentOptions([]); self.cParentSearch('');
      self.cPreview(null);
    });

    self.openNew = function () {
      self.editError(null); self.cType(''); self.cRole(''); self.cUserId('');
      self.cStart(today()); self.cEnd(''); self.cNotes('');
      self.showEdit(true);
    };
    self.closeEdit = function () { self.showEdit(false); };
    self.saveEdit = function () {
      var type = self.cType(), role = self.cRole();
      var key  = self.cTwoPart() ? self.cParentKey() : self.cObjKey();
      var key2 = self.cTwoPart() ? self.cObjKey() : null;
      if (!type || !role || !key || !self.cUserId()) {
        self.editError(i18n.t('vw.ra.needAll')); return;
      }
      self.saving(true); self.editError(null);
      wf.assignCreate({
        objectType: type, objectKey: key, objectKey2: key2, roleCode: role,
        userId: Number(self.cUserId()), startDate: self.cStart() || null,
        endDate: self.cEnd() || null, notes: self.cNotes() || null
      }).then(function () {
        self.saving(false); self.showEdit(false); self.loadList();
      }).catch(function (e) {
        self.saving(false); self.editError((e && e.message) || 'Error');
      });
    };

    /* ── end / replace / void dialogs ──────────────────────────────────── */
    self.actTarget = ko.observable(null);   // the row being acted on
    self.actKind   = ko.observable('');     // 'end' | 'replace' | 'void'
    self.actDate   = ko.observable(today());
    self.actUserId = ko.observable('');
    self.actNote   = ko.observable('');
    self.actError  = ko.observable(null);

    self.openAct = function (row, kind) {
      self.actTarget(row); self.actKind(kind);
      self.actDate(today()); self.actUserId(''); self.actNote('');
      self.actError(null);
    };
    self.closeAct = function () { self.actTarget(null); };
    self.saveAct = function () {
      var row = self.actTarget(); if (!row) return;
      var p;
      if (self.actKind() === 'end') {
        p = wf.assignAct(row.assignmentId, { op: 'end', endDate: self.actDate(), note: self.actNote() || null });
      } else if (self.actKind() === 'void') {
        if (!self.actNote()) { self.actError(i18n.t('vw.ra.needReason')); return; }
        p = wf.assignAct(row.assignmentId, { op: 'void', reason: self.actNote() });
      } else {
        if (!self.actUserId()) { self.actError(i18n.t('vw.ra.needUser')); return; }
        p = wf.assignReplace(row.assignmentId, Number(self.actUserId()), self.actDate());
      }
      p.then(function () { self.closeAct(); self.loadList(); })
       .catch(function (e) { self.actError((e && e.message) || 'Error'); });
    };

    /* ── role policies modal (single-assignee vs group, per role) ──────── */
    self.polOpen = ko.observable(false);
    self.polMsg  = ko.observable(null);   // { warn: bool, text }
    self.polBusy = ko.observable(false);
    self.openPolicies = function () { self.polMsg(null); self.polOpen(true); };
    self.togglePolicy = function (role) {
      if (self.polBusy()) return;
      var toSingle = role.singleAssignee !== 'Y';
      self.polBusy(true); self.polMsg(null);
      wf.assignSetPolicy(role.roleCode, toSingle).then(function (r) {
        // refresh the roles list so every consumer sees the new policy
        return wf.assignMeta().then(function (m) {
          self.roles((m && m.roles) || []);
          if (toSingle && r && r.overlapGroups > 0) {
            // flipping to single grandfathers existing overlaps -- say so
            self.polMsg({ warn: true,
              text: i18n.t('vw.ra.polOverlapWarn') + ' ' + r.overlapGroups });
          } else {
            self.polMsg({ warn: false, text: i18n.t('vw.ra.polSaved') });
          }
        });
      }).catch(function (e) {
        self.polMsg({ warn: true, text: (e && e.message) || 'Error' });
      }).then(function () { self.polBusy(false); });
    };

    /* ── timeline modal ────────────────────────────────────────────────── */
    self.tlItems = ko.observableArray([]);
    self.tlOpen  = ko.observable(false);
    self.tlTitle = ko.observable('');
    self.openTimeline = function (row) {
      self.tlTitle((row.objectLabel || row.objectKey) + ' · ' + self.roleName(row.roleCode));
      var key2 = row.objectKey2 || null;
      wf.assignTimeline(row.objectType, row.objectKey, key2, row.roleCode)
        .then(function (items) { self.tlItems(items); self.tlOpen(true); });
    };

    /* ── tab 2: audit ──────────────────────────────────────────────────── */
    self.aFrom = ko.observable(''); self.aTo = ko.observable('');
    self.aActor = ko.observable(''); self.aType = ko.observable('');
    self.aKey = ko.observable(''); self.aRole = ko.observable('');
    self.aAction = ko.observable('');
    self.aRows = ko.observableArray([]);
    self.aTotal = ko.observable(0);
    self.aOffset = ko.observable(0);
    self.ACTIONS = ['ASSIGN_CREATE', 'ASSIGN_END', 'ASSIGN_REPLACE', 'ASSIGN_UPDATE', 'ASSIGN_VOID'];

    self.auditFilters = function () {
      return { fromdt: self.aFrom(), todt: self.aTo(), actor: self.aActor(),
               type: self.aType(), key: self.aKey(), role: self.aRole(),
               action: self.aAction() };
    };
    self.loadAudit = function () {
      self.loading(true);
      var f = self.auditFilters();
      f.limit = self.limit; f.offset = self.aOffset();
      wf.assignAudit(f).then(function (r) {
        self.aRows((r && r.items) || []);
        self.aTotal((r && r.total) || 0);
        self.loading(false);
      }).catch(function (e) { self.error(e && e.message); self.loading(false); });
    };
    self.auditSearch = function () { self.aOffset(0); self.loadAudit(); };
    self.aPageInfo = ko.pureComputed(function () {
      var from = self.aTotal() ? self.aOffset() + 1 : 0;
      return from + '–' + Math.min(self.aOffset() + self.limit, self.aTotal())
           + ' / ' + self.aTotal();
    });
    self.aNext = function () {
      if (self.aOffset() + self.limit < self.aTotal()) {
        self.aOffset(self.aOffset() + self.limit); self.loadAudit();
      }
    };
    self.aPrev = function () {
      if (self.aOffset() > 0) {
        self.aOffset(Math.max(0, self.aOffset() - self.limit)); self.loadAudit();
      }
    };
    self.exportCsv = function () {
      wf.assignAuditCsv(self.auditFilters()).then(function (url) {
        var a = document.createElement('a');
        a.href = url; a.download = 'role-assignments-audit.csv';
        document.body.appendChild(a); a.click(); a.remove();
      });
    };
    // the same audit as a BI Interactive Report (column chooser, control
    // breaks, saved layouts, XLSX). Root-absolute so webtier + dev-proxy
    // sibling apps both serve it; the hash suffix preselects and auto-runs.
    self.openBiReport = function () {
      window.open('/BI/Jet/index.html#irViewer/WF_ROLE_ASSIGN_AUDIT', '_blank');
    };

    self.setTab = function (t) {
      self.tab(t);
      if (t === 'audit' && !self.aRows().length) self.loadAudit();
    };

    /* ── boot ──────────────────────────────────────────────────────────── */
    wf.assignMeta().then(function (m) {
      self.objTypes((m && m.items) || []);
      self.roles((m && m.roles) || []);
    }).catch(function (e) { self.error(e && e.message); });
    api.get('/users?limit=500').then(function (r) {
      var items = (r && (r.items || r.users)) || [];
      self.users(items.filter(function (u) {
        return (u.isActive === undefined || u.isActive === 'Y' || u.isActive === true);
      }).map(function (u) {
        return { id: u.userId || u.id, name: u.displayName || u.username };
      }));
    }).catch(function () { self.users([]); });
    self.loadList();
  }

  return RoleAssignmentsViewModel;
});
