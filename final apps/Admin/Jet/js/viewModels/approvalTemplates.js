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
      if (!q) return self.templates();
      return self.templates().filter(function (t) {
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
  }

  return ApprovalTemplatesViewModel;
});
