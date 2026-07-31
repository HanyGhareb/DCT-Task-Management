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
define(['knockout', 'shared/api', 'shared/wfService', 'shared/i18n',
        'services/authService'],
function (ko, api, wf, i18n, auth) {
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

    // Manage Objects is SYS_ADMIN-only (the registry names DB views/columns)
    self.isSysAdmin = (function () {
      var u = auth.getCurrentUser();
      return !!(u && u.roles && u.roles.indexOf('SYS_ADMIN') >= 0);
    })();

    /* ── role policies drawer (single-assignee vs group, per role) ─────── */
    self.polOpen = ko.observable(false);
    self.polMsg  = ko.observable(null);   // { warn: bool, text }
    self.polBusy = ko.observable(false);
    self.openPolicies = function () { self.polMsg(null); self.polOpen(true); };
    self.closePolicies = function () { self.polOpen(false); };
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

    // refresh the picker metadata after any role/object-type change so the
    // create drawer + filters see the new definitions immediately
    function refreshMeta() {
      return wf.assignMeta().then(function (m) {
        self.objTypes((m && m.items) || []);
        self.roles((m && m.roles) || []);
      });
    }

    /* ── Manage Roles drawer (WF_ADMIN) ────────────────────────────────── */
    self.mrOpen    = ko.observable(false);
    self.mrRows    = ko.observableArray([]);
    self.mrMsg     = ko.observable(null);     // { warn: bool, text }
    self.mrBusy    = ko.observable(false);
    self.mrEditing = ko.observable(false);    // the inline form is showing
    self.mrIsNew   = ko.observable(true);
    self.mrCode    = ko.observable('');
    self.mrNameEn  = ko.observable('');
    self.mrNameAr  = ko.observable('');
    self.mrSingle  = ko.observable(false);
    self.mrActive  = ko.observable(true);

    // the drawer's primary button doubles as Close when no form is open
    self.mrSaveLabel = ko.pureComputed(function () {
      return self.mrEditing() ? i18n.t('vw.ra.save') : i18n.t('vw.ra.close');
    });

    self.mrLoad = function () {
      return wf.manageRoles().then(function (items) { self.mrRows(items); })
        .catch(function (e) { self.mrMsg({ warn: true, text: (e && e.message) || 'Error' }); });
    };
    self.openManageRoles = function () {
      self.mrMsg(null); self.mrEditing(false);
      self.mrLoad(); self.mrOpen(true);
    };
    self.mrNew = function () {
      self.mrIsNew(true); self.mrCode(''); self.mrNameEn(''); self.mrNameAr('');
      self.mrSingle(false); self.mrActive(true); self.mrMsg(null);
      self.mrEditing(true);
    };
    self.mrEdit = function (row) {
      self.mrIsNew(false); self.mrCode(row.roleCode);
      self.mrNameEn(row.nameEn || ''); self.mrNameAr(row.nameAr || '');
      self.mrSingle(row.singleAssignee === 'Y');
      self.mrActive(row.isActive === 'Y');
      self.mrMsg(null); self.mrEditing(true);
    };
    // the drawer's Save button: saves the form when it is open, else closes
    self.mrSave = function () {
      if (!self.mrEditing()) { self.mrOpen(false); return; }
      if (!self.mrCode() || !self.mrNameEn()) {
        self.mrMsg({ warn: true, text: i18n.t('vw.ra.needAll') }); return;
      }
      self.mrBusy(true); self.mrMsg(null);
      wf.saveRole({
        roleCode: self.mrCode(), nameEn: self.mrNameEn(),
        nameAr: self.mrNameAr() || null,
        singleAssignee: self.mrSingle() ? 'Y' : 'N',
        isActive: self.mrActive() ? 'Y' : 'N'
      }).then(function (r) {
        self.mrEditing(false);
        if (r && r.activeAssignments > 0) {
          // deactivated a role that still has active assignments -- warn
          self.mrMsg({ warn: true,
            text: i18n.t('vw.ra.mrInUseWarn') + ' ' + r.activeAssignments });
        } else {
          self.mrMsg({ warn: false, text: i18n.t('vw.ra.saved') });
        }
        return self.mrLoad().then(refreshMeta);
      }).catch(function (e) {
        self.mrMsg({ warn: true, text: (e && e.message) || 'Error' });
      }).then(function () { self.mrBusy(false); });
    };

    /* ── Manage Objects drawer (SYS_ADMIN) ─────────────────────────────── */
    self.moOpen    = ko.observable(false);
    self.moRows    = ko.observableArray([]);
    self.moMsg     = ko.observable(null);
    self.moBusy    = ko.observable(false);
    self.moEditing = ko.observable(false);
    self.moIsNew   = ko.observable(true);
    self.moCode    = ko.observable('');
    self.moNameEn  = ko.observable('');
    self.moNameAr  = ko.observable('');
    self.moView    = ko.observable('');
    self.moViewSearch  = ko.observable('');
    self.moViewOptions = ko.observableArray([]);
    self.moCols    = ko.observableArray([]);   // columns of the chosen view
    self.moKeyCol   = ko.observable('');
    self.moLabelCol = ko.observable('');
    self.moKey2Col  = ko.observable('');
    self.moParentCol = ko.observable('');
    self.moKey2En  = ko.observable('');
    self.moKey2Ar  = ko.observable('');
    self.moNumeric = ko.observable(false);
    self.moHier    = ko.observable('NONE');
    self.moValidate = ko.observable(true);
    self.moActive  = ko.observable(true);
    self.moOrder   = ko.observable('');

    self.moSaveLabel = ko.pureComputed(function () {
      return self.moEditing() ? i18n.t('vw.ra.save') : i18n.t('vw.ra.close');
    });

    self.moLoad = function () {
      return wf.manageObjectTypes().then(function (items) { self.moRows(items); })
        .catch(function (e) { self.moMsg({ warn: true, text: (e && e.message) || 'Error' }); });
    };
    self.openManageObjects = function () {
      self.moMsg(null); self.moEditing(false);
      self.moLoad(); self.moOpen(true);
    };
    self.moSearchViews = function () {
      wf.dictViews(self.moViewSearch()).then(function (views) {
        self.moViewOptions(views);
      }).catch(function () { self.moViewOptions([]); });
    };
    // choosing a view loads its columns so every column field is a dropdown --
    // nothing free-typed ever reaches the registry
    self.moLoadCols = function () {
      var v = self.moView();
      if (!v) { self.moCols([]); return; }
      wf.dictColumns(v).then(function (cols) {
        self.moCols(cols.map(function (c) { return c.name; }));
      }).catch(function () { self.moCols([]); });
    };
    self.moView.subscribe(self.moLoadCols);

    self.moNew = function () {
      self.moIsNew(true); self.moCode(''); self.moNameEn(''); self.moNameAr('');
      self.moView(''); self.moViewSearch(''); self.moViewOptions([]); self.moCols([]);
      self.moKeyCol(''); self.moLabelCol(''); self.moKey2Col(''); self.moParentCol('');
      self.moKey2En(''); self.moKey2Ar(''); self.moNumeric(false); self.moHier('NONE');
      self.moValidate(true); self.moActive(true); self.moOrder('');
      self.moMsg(null); self.moEditing(true);
    };
    self.moEdit = function (row) {
      self.moIsNew(false); self.moCode(row.code);
      self.moNameEn(row.nameEn || ''); self.moNameAr(row.nameAr || '');
      self.moViewSearch(''); self.moViewOptions([row.lovView]);
      self.moView(row.lovView);
      self.moKeyCol(row.keyCol || ''); self.moLabelCol(row.labelCol || '');
      self.moKey2Col(row.key2Col || ''); self.moParentCol(row.parentCol || '');
      self.moKey2En(row.key2LabelEn || ''); self.moKey2Ar(row.key2LabelAr || '');
      self.moNumeric(row.keyIsNumeric === 'Y'); self.moHier(row.hierarchy || 'NONE');
      self.moValidate(row.validateKey !== 'N'); self.moActive(row.isActive === 'Y');
      self.moOrder(row.displayOrder == null ? '' : row.displayOrder);
      self.moMsg(null); self.moEditing(true);
    };
    self.moSave = function () {
      if (!self.moEditing()) { self.moOpen(false); return; }
      if (!self.moCode() || !self.moNameEn() || !self.moView()
          || !self.moKeyCol() || !self.moLabelCol()) {
        self.moMsg({ warn: true, text: i18n.t('vw.ra.needAll') }); return;
      }
      self.moBusy(true); self.moMsg(null);
      wf.saveObjectType({
        code: self.moCode(), nameEn: self.moNameEn(), nameAr: self.moNameAr() || null,
        lovView: self.moView(), keyCol: self.moKeyCol(), labelCol: self.moLabelCol(),
        key2Col: self.moKey2Col() || null, parentCol: self.moParentCol() || null,
        key2LabelEn: self.moKey2En() || null, key2LabelAr: self.moKey2Ar() || null,
        keyIsNumeric: self.moNumeric() ? 'Y' : 'N', hierarchy: self.moHier(),
        validateKey: self.moValidate() ? 'Y' : 'N',
        isActive: self.moActive() ? 'Y' : 'N',
        displayOrder: self.moOrder() === '' ? null : Number(self.moOrder())
      }).then(function (r) {
        self.moEditing(false);
        if (r && r.activeAssignments > 0) {
          self.moMsg({ warn: true,
            text: i18n.t('vw.ra.moInUseWarn') + ' ' + r.activeAssignments });
        } else {
          self.moMsg({ warn: false, text: i18n.t('vw.ra.saved') });
        }
        return self.moLoad().then(refreshMeta);
      }).catch(function (e) {
        self.moMsg({ warn: true, text: (e && e.message) || 'Error' });
      }).then(function () { self.moBusy(false); });
    };

    /* ── Level Priority drawer (WF_ADMIN) ──────────────────────────────── */
    self.lpOpen   = ko.observable(false);
    self.lpMsg    = ko.observable(null);
    self.lpBusy   = ko.observable(false);
    self.lpTypes  = ko.observableArray([]);   // available levels {code, nameEn, nameAr, factPath}
    self.lpDefault   = ko.observableArray([]);
    self.lpOverrides = ko.observableArray([]); // [{roleCode, levels}]
    self.lpScope  = ko.observable('');         // '' = the platform default
    self.lpLevels = ko.observableArray([]);    // the ordered list being edited
    self.lpAddType = ko.observable('');

    self.lpTypeName = function (code) {
      var t = self.lpTypes().filter(function (x) { return x.code === code; })[0];
      if (!t) return code;
      return (i18n.lang() === 'ar' && t.nameAr) ? t.nameAr : t.nameEn;
    };
    self.lpLoad = function () {
      return wf.getPriority().then(function (r) {
        self.lpDefault((r && r.defaultLevels) || []);
        self.lpOverrides((r && r.overrides) || []);
        self.lpTypes((r && r.types) || []);
        self.lpSelectScope(self.lpScope());
      });
    };
    self.lpSelectScope = function (scope) {
      if (!scope) { self.lpLevels(self.lpDefault().slice()); return; }
      var ov = self.lpOverrides().filter(function (o) { return o.roleCode === scope; })[0];
      self.lpLevels(ov ? ov.levels.slice() : []);
    };
    self.lpScope.subscribe(self.lpSelectScope);
    self.lpHasOverride = ko.pureComputed(function () {
      var s = self.lpScope();
      return !!self.lpOverrides().filter(function (o) { return o.roleCode === s; }).length;
    });
    self.openPriority = function () {
      self.lpMsg(null); self.lpScope('');
      self.lpLoad().then(function () { self.lpOpen(true); })
        .catch(function (e) { self.error((e && e.message) || 'Error'); });
    };
    self.lpUp = function (i) {
      if (i <= 0) return;
      var a = self.lpLevels();
      self.lpLevels(a.slice(0, i - 1).concat([a[i], a[i - 1]]).concat(a.slice(i + 1)));
    };
    self.lpDown = function (i) {
      var a = self.lpLevels();
      if (i >= a.length - 1) return;
      self.lpLevels(a.slice(0, i).concat([a[i + 1], a[i]]).concat(a.slice(i + 2)));
    };
    self.lpRemove = function (i) {
      var a = self.lpLevels().slice(); a.splice(i, 1); self.lpLevels(a);
    };
    self.lpAdd = function () {
      var c = self.lpAddType();
      if (!c || self.lpLevels().indexOf(c) >= 0) return;
      self.lpLevels.push(c); self.lpAddType('');
    };
    self.lpStartFromDefault = function () { self.lpLevels(self.lpDefault().slice()); };
    self.lpSave = function () {
      self.lpBusy(true); self.lpMsg(null);
      wf.setPriority(self.lpScope() || null, self.lpLevels()).then(function () {
        self.lpMsg({ warn: false, text: i18n.t('vw.ra.saved') });
        return self.lpLoad();
      }).catch(function (e) {
        self.lpMsg({ warn: true, text: (e && e.message) || 'Error' });
      }).then(function () { self.lpBusy(false); });
    };

    /* ── Import Matrix drawer (WF_ADMIN) ───────────────────────────────── */
    // the manual approval-matrix workbook: one row per cost centre carrying
    // the people per role. Parse client-side (SheetJS), dry-run on the
    // server (exception report; unmatched emails NEVER auto-create users —
    // W0 decision), then apply date-tracked (create / replace / skip).
    self.imOpen    = ko.observable(false);
    self.imBusy    = ko.observable(false);
    self.imMsg     = ko.observable(null);
    self.imEff     = ko.observable(today());
    self.imSheets  = ko.observableArray([]);
    self.imSheet   = ko.observable('');
    self.imEntries = ko.observableArray([]);   // parsed {row, cc, role, email}
    self.imResults = ko.observableArray([]);
    self.imSummary = ko.observable(null);
    self.imApplied = ko.observable(false);
    self._imWb = null;

    // header-synonym map: a role column's PEOPLE come from the email column
    // that FOLLOWS the matching name column ('FBP -UH' has no email column
    // in the workbook, so FBP Unit Head stays a manual assignment)
    var IM_ROLES = [
      { role: 'WF_PBP',      name: /pbp/i },
      { role: 'WF_FBP',      name: /fbp\s*emp/i },
      { role: 'WF_AP_CONTACT', name: /^ap\s*name/i },
      { role: 'WF_DIRECTOR', name: /director/i },
      { role: 'WF_KEY_USER', name: /key\s*users?\s*name/i }
    ];

    self.openImport = function () {
      self.imMsg(null); self.imEntries([]); self.imResults([]);
      self.imSummary(null); self.imSheets([]); self.imSheet('');
      self.imApplied(false); self._imWb = null; self.imEff(today());
      self.imOpen(true);
    };
    self.imPickFile = function () {
      require(['shared/docUpload', 'xlsx'], function (docUpload, XLSX) {
        docUpload.choose({ accept: '.xlsx,.xls', maxMb: 20 }).then(function (file) {
          if (!file) return;
          file.arrayBuffer().then(function (buf) {
            self._imWb = XLSX.read(buf, { type: 'array' });
            self.imSheets(self._imWb.SheetNames.slice());
            // default to the newest 'Director & ED' style sheet when present
            var guess = self._imWb.SheetNames.filter(function (n) { return /director/i.test(n); });
            self.imSheet(guess.length ? guess[guess.length - 1] : self._imWb.SheetNames[0]);
            self.imParse();
          });
        });
      });
    };
    self.imParse = function () {
      if (!self._imWb || !self.imSheet()) return;
      require(['xlsx'], function (XLSX) {
        var rows = XLSX.utils.sheet_to_json(self._imWb.Sheets[self.imSheet()],
                                            { header: 1, defval: '' });
        // find the header row: the one naming a cost-center column
        var hIdx = -1, headers = [];
        for (var i = 0; i < Math.min(rows.length, 5); i++) {
          if ((rows[i] || []).some(function (c) { return /cost\s*cent/i.test(String(c)); })) {
            hIdx = i; headers = rows[i].map(function (c) { return String(c || '').trim(); });
            break;
          }
        }
        if (hIdx < 0) {
          self.imMsg({ warn: true, text: i18n.t('vw.ra.imNoHeader') });
          self.imEntries([]); return;
        }
        var ccCol = -1;
        headers.forEach(function (h, ci) {
          if (/new\s*cost\s*cent/i.test(h)) ccCol = ci;
        });
        if (ccCol < 0) headers.forEach(function (h, ci) {
          if (ccCol < 0 && /cost\s*cent/i.test(h)) ccCol = ci;
        });
        // per role: name column, then the FIRST 'email' header to its right
        var roleCols = [];
        IM_ROLES.forEach(function (rc) {
          for (var ci = 0; ci < headers.length; ci++) {
            if (rc.name.test(headers[ci])) {
              for (var cj = ci; cj < Math.min(ci + 3, headers.length); cj++) {
                if (/email/i.test(headers[cj])) {
                  roleCols.push({ role: rc.role, col: cj }); return;
                }
              }
              return;
            }
          }
        });
        var entries = [];
        for (var r = hIdx + 1; r < rows.length; r++) {
          var cc = String((rows[r] || [])[ccCol] || '').trim();
          if (!/^\d{5,}$/.test(cc)) continue;   // not a data row
          roleCols.forEach(function (rc) {
            var cell = String((rows[r] || [])[rc.col] || '');
            // a cell may carry SEVERAL people (key users) — split on
            // commas/spaces, keep the @-bearing tokens
            cell.split(/[,;\s]+/).forEach(function (tok) {
              tok = tok.trim().toLowerCase();
              if (tok.indexOf('@') > 0) {
                entries.push({ row: r + 1, cc: cc, role: rc.role, email: tok });
              }
            });
          });
        }
        self.imEntries(entries);
        self.imResults([]); self.imSummary(null); self.imApplied(false);
        self.imMsg(entries.length
          ? { warn: false, text: i18n.t('vw.ra.imParsed') + ' ' + entries.length }
          : { warn: true, text: i18n.t('vw.ra.imNoRows') });
      });
    };
    self.imSheet.subscribe(function () { if (self._imWb) self.imParse(); });

    function imRun(mode) {
      var entries = self.imEntries();
      if (!entries.length) return;
      self.imBusy(true); self.imMsg(null);
      var chunks = [];
      for (var i = 0; i < entries.length; i += 150) chunks.push(entries.slice(i, i + 150));
      var all = [], sum = { created: 0, replaced: 0, skipped: 0, errors: 0 };
      var p = Promise.resolve();
      chunks.forEach(function (chunk) {
        p = p.then(function () {
          return wf.importMatrix({ mode: mode, effectiveDate: self.imEff() || null,
                                   entries: chunk })
            .then(function (r) {
              all = all.concat((r && r.results) || []);
              sum.created  += (r && r.created)  || 0;
              sum.replaced += (r && r.replaced) || 0;
              sum.skipped  += (r && r.skipped)  || 0;
              sum.errors   += (r && r.errors)   || 0;
            });
        });
      });
      p.then(function () {
        self.imResults(all); self.imSummary(sum);
        self.imApplied(mode === 'apply');
        self.imBusy(false);
        if (mode === 'apply') { self.loadList(); }
      }).catch(function (e) {
        self.imBusy(false);
        self.imMsg({ warn: true, text: (e && e.message) || 'Error' });
      });
    }
    self.imDryRun = function () { imRun('dryrun'); };
    self.imApply  = function () { imRun('apply'); };
    self.imExceptions = ko.pureComputed(function () {
      return self.imResults().filter(function (r) {
        return r.status !== 'CREATED' && r.status !== 'REPLACED' && r.status !== 'SKIPPED';
      });
    });
    self.imStatusClass = function (s) {
      return { CREATED: 'badge-success', REPLACED: 'badge-info',
               SKIPPED: 'badge-muted' }[s] || 'badge-danger';
    };
    // the exception list doubles as the W0 provisioning worklist
    self.imExportExceptions = function () {
      var rows = [['row', 'cc', 'role', 'email', 'status', 'detail']];
      self.imExceptions().forEach(function (r) {
        rows.push([r.row, r.cc, r.role, r.email, r.status, r.detail || '']);
      });
      var csv = '﻿' + rows.map(function (r) {
        return r.map(function (c) {
          c = String(c == null ? '' : c);
          return /[",\n]/.test(c) ? '"' + c.replace(/"/g, '""') + '"' : c;
        }).join(',');
      }).join('\n');
      var a = document.createElement('a');
      a.href = URL.createObjectURL(new Blob([csv], { type: 'text/csv;charset=utf-8' }));
      a.download = 'matrix-import-exceptions.csv';
      document.body.appendChild(a); a.click(); a.remove();
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
