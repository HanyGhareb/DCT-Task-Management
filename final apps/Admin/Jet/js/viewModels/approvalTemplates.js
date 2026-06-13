define(['knockout', 'services/auditService', 'shared/i18n', 'shared/toast'],
function (ko, auditService, i18n, toast) {
  'use strict';

  function ApprovalTemplatesViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.templates  = ko.observableArray([]);
    self.searchTerm = ko.observable('');
    self.busy       = ko.observable(false);

    function reload() {
      return auditService.getTemplates().then(function (items) {
        self.templates(items);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    reload();

    self.filtered = ko.computed(function () {
      var q = self.searchTerm().toLowerCase();
      return self.templates().filter(function (t) {
        // enh-6: archived versions live in the History modal, not the list
        if ((t.templateCode || '').indexOf('~V') >= 0) return false;
        if (!q) return true;
        return (t.templateName || '').toLowerCase().includes(q) ||
               (t.templateCode || '').toLowerCase().includes(q) ||
               (t.module       || '').toLowerCase().includes(q);
      });
    });

    /* ── Wave 4 (1.4): draft → activate lifecycle ─────────────────────────
       Drafts carry a '~D' code suffix + parentTemplateId; archived versions
       carry '~V<n>'. The live template is never edited in place. */
    self.statusOf = function (t) {
      var code = t.templateCode || '';
      if (code.indexOf('~D') >= 0 || t.parentTemplateId) return 'DRAFT';
      if (code.indexOf('~V') >= 0) return 'ARCHIVED';
      return t.isActive === 'Y' ? 'ACTIVE' : 'INACTIVE';
    };
    self.statusBadge = function (t) {
      return { ACTIVE: 'badge--active', DRAFT: 'badge--pending',
               ARCHIVED: 'badge--idle', INACTIVE: 'badge--inactive' }[self.statusOf(t)];
    };

    self.cloneDraft = function (t) {
      self.busy(true);
      auditService.cloneTemplate(t.templateId).then(function () {
        self.busy(false);
        toast.success(i18n.t('tmpl.draftCreated'));
        reload();
      }).catch(function (err) {
        self.busy(false);
        toast.error((err && err.message) || 'Clone failed');
      });
    };

    self.activate = function (t) {
      if (!window.confirm(i18n.t('tmpl.activateConfirm'))) return;
      self.busy(true);
      auditService.activateTemplate(t.templateId).then(function () {
        self.busy(false);
        toast.success(i18n.t('tmpl.activated'));
        reload();
      }).catch(function (err) {
        self.busy(false);
        toast.error((err && err.message) || 'Activation failed');
      });
    };

    /* ── detail modal (read-only for live; editable steps for drafts) ──── */
    self.selected   = ko.observable(null);
    self.showDetail = ko.observable(false);
    self.isDraft    = ko.observable(false);
    self.editSteps  = ko.observableArray([]);   // [{stepId, label: obs, slaHours: obs, roleCode}]
    self.stepsSaving = ko.observable(false);

    self.viewTemplate = function (t) {
      auditService.getTemplateById(t.templateId).then(function (template) {
        self.selected(template);
        self.isDraft(self.statusOf(t) === 'DRAFT');
        self.editSteps((template && template.steps || []).map(function (s) {
          return { stepId: s.stepId, roleCode: s.roleCode,
                   label: ko.observable(s.label),
                   slaHours: ko.observable(s.slaHours) };
        }));
        self.showDetail(!!template);
      });
    };
    self.closeDetail = function () { self.showDetail(false); self.selected(null); };

    self.moveStep = function (idx, dir) {
      var arr = self.editSteps();
      var j = idx + dir;
      if (j < 0 || j >= arr.length) return;
      var copy = arr.slice();
      copy[idx] = arr[j];
      copy[j]   = arr[idx];
      self.editSteps(copy);
    };

    self.saveSteps = function () {
      var sel = self.selected();
      if (!sel) return;
      self.stepsSaving(true);
      var payload = self.editSteps().map(function (s, i) {
        return { stepId: s.stepId, seq: i + 1,
                 label: s.label(), slaHours: Number(s.slaHours()) || 0 };
      });
      auditService.updateTemplateSteps(sel.templateId, payload).then(function () {
        self.stepsSaving(false);
        toast.success(i18n.t('toast.saved'));
        self.closeDetail();
        reload();
      }).catch(function (err) {
        self.stepsSaving(false);
        toast.error((err && err.message) || 'Save failed');
      });
    };

    self.toggleActive = function (t) {
      auditService.updateTemplate(t.templateId, { isActive: t.isActive === 'Y' ? 'N' : 'Y' })
        .then(reload);
    };

    /* ── enh-6: version history (live + ~V archives) with step diff ───────
       Restore = clone an archive's steps into a new ~D draft of the live
       template; the draft then follows the normal edit/activate lifecycle. */
    function baseCodeOf(t) {
      var code = t.templateCode || '';
      var i = code.indexOf('~');
      return i < 0 ? code : code.slice(0, i);
    }
    function stepKey(s) { return (s.label || '') + '|' + (s.roleCode || ''); }
    function diffVsLive(steps, liveSteps) {
      var live = (liveSteps || []).map(stepKey);
      var mine = (steps || []).map(stepKey);
      var added = mine.filter(function (k) { return live.indexOf(k) < 0; }).length;
      var removed = live.filter(function (k) { return mine.indexOf(k) < 0; }).length;
      var moved = 0;
      mine.forEach(function (k, i) {
        var j = live.indexOf(k);
        if (j >= 0 && j !== i) moved++;
      });
      return { added: added, removed: removed, moved: moved,
               same: !added && !removed && !moved };
    }

    self.historyBase     = ko.observable('');
    self.historyVersions = ko.observableArray([]);
    self.showHistory     = ko.observable(false);
    self.historyHasDraft = ko.observable(false);

    self.familyArchives = function (t) {
      var base = baseCodeOf(t);
      return self.templates().filter(function (x) {
        return (x.templateCode || '').indexOf(base + '~V') === 0;
      });
    };
    self.hasHistory = function (t) {
      return self.statusOf(t) === 'ACTIVE' && self.familyArchives(t).length > 0;
    };

    self.openHistory = function (t) {
      var base = baseCodeOf(t);
      var live = self.templates().find(function (x) {
        return x.templateCode === base && x.isActive === 'Y';
      });
      var fam = self.familyArchives(t);
      self.historyHasDraft(self.templates().some(function (x) {
        return x.templateCode === base + '~D';
      }));
      var rows = (live ? [live] : []).concat(fam).map(function (x) {
        return {
          templateId: x.templateId,
          code:       x.templateCode,
          versionNo:  x.versionNo || 1,
          isLive:     x.templateCode === base,
          steps:      x.steps || [],
          diff:       x.templateCode === base ? null
                        : diffVsLive(x.steps, live && live.steps),
        };
      }).sort(function (a, b) { return b.versionNo - a.versionNo; });
      self.historyBase(base);
      self.historyVersions(rows);
      self.showHistory(true);
    };
    self.closeHistory = function () { self.showHistory(false); };

    self.diffText = function (d) {
      if (!d) return '';
      if (d.same) return i18n.t('tmpl.histSame');
      var bits = [];
      if (d.added)   bits.push(i18n.t('tmpl.histAdded',   [d.added]));
      if (d.removed) bits.push(i18n.t('tmpl.histRemoved', [d.removed]));
      if (d.moved)   bits.push(i18n.t('tmpl.histMoved',   [d.moved]));
      return bits.join(' · ');
    };

    self.restoreVersion = function (v) {
      if (!window.confirm(i18n.t('tmpl.restoreConfirm', [v.code]))) return;
      self.busy(true);
      auditService.restoreTemplate(v.templateId).then(function () {
        self.busy(false);
        self.closeHistory();
        toast.success(i18n.t('tmpl.restored'));
        reload();
      }).catch(function (err) {
        self.busy(false);
        toast.error((err && err.message) || 'Restore failed');
      });
    };
  }

  return ApprovalTemplatesViewModel;
});
