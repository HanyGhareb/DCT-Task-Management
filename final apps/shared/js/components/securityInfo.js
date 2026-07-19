/**
 * shared/js/components/securityInfo.js — <security-info> Knockout component.
 *
 * The SYS_ADMIN-only "Security Info" link every page can carry. Opens a drawer
 * showing everything security knows about the page: its view privilege, every
 * registered artifact (nav item, button, field, tab, report, endpoint) with the
 * privilege that guards it, and which duty/job/abstract roles currently grant
 * each privilege (rolled up from the Security Console's privilege closure).
 *
 * Renders NOTHING for non-SYS_ADMIN users. Data comes from the page registry
 * (DCT_SEC_PAGE / DCT_SEC_PAGE_ARTIFACT) via GET /dct/sec/pageinfo — pages are
 * registered by each module's security seed script, so the drawer is always
 * the same artifact the enforcement uses, never a hand-maintained copy.
 *
 * Usage (any shared-shell app):
 *   <security-info params="module: 'GL', page: 'butil'"></security-info>
 */
define(['knockout', 'shared/api', 'shared/i18n'], function (ko, api, i18n) {
  'use strict';

  function isSysAdmin() {
    try {
      var raw = localStorage.getItem('ifinance_jet_session');
      if (!raw) return false;
      var roles = (JSON.parse(raw).rolesCsv || '').split(',');
      return roles.indexOf('SYS_ADMIN') >= 0;
    } catch (e) { return false; }
  }

  function SecurityInfoVM(params) {
    var self = this;
    params = params || {};

    self.module = ko.isObservable(params.module) ? params.module : ko.observable(params.module);
    self.page   = ko.isObservable(params.page) ? params.page : ko.observable(params.page);

    self.visible    = ko.observable(isSysAdmin());
    self.open       = ko.observable(false);
    self.loading    = ko.observable(false);
    self.notFound   = ko.observable(false);
    self.info       = ko.observable(null);
    self.artifacts  = ko.observableArray([]);

    self.t = function (k) { return i18n.t(k); };

    self.typeLabel = function (type) {
      var k = i18n.t('si.type.' + String(type || '').toLowerCase());
      return k.indexOf('si.type.') === 0 ? type : k;
    };

    self.show = function () {
      self.open(true);
      self.loading(true);
      self.notFound(false);
      api.get('/sec/pageinfo?module=' + encodeURIComponent(self.module() || '') +
              '&page=' + encodeURIComponent(self.page() || ''), { base: 'auth' })
        .then(function (r) {
          self.info(r);
          self.artifacts(r.artifacts || []);
        })
        .catch(function (e) {
          self.info(null);
          self.artifacts([]);
          self.notFound(true);
        })
        .then(function () { self.loading(false); });
    };

    self.close = function () { self.open(false); };

    self.onKey = function (d, e) {
      if (e.key === 'Escape') { self.close(); return false; }
      return true;
    };
  }

  ko.components.register('security-info', {
    viewModel: { createViewModel: function (params) { return new SecurityInfoVM(params); } },
    template:
      '<!-- ko if: visible -->' +
      '<button type="button" class="si-link" data-bind="click: show">' +
        '<span aria-hidden="true">&#128737;</span> ' +
        '<span data-bind="text: t(\'si.link\')"></span>' +
      '</button>' +
      '<div class="ed-scrim" data-bind="css:{ \'ed-show\': open }, click: close"></div>' +
      '<aside class="ed-drawer si-drawer" role="dialog" aria-modal="true" ' +
             'data-bind="css:{ \'ed-show\': open }, style:{ width: \'640px\' }, event:{ keydown: onKey }">' +
        '<header class="ed-drawer__header">' +
          '<div>' +
            '<div class="ed-drawer__eyebrow" data-bind="text: (module() || \'\') + \' / \' + (page() || \'\')"></div>' +
            '<div class="ed-drawer__title" data-bind="text: t(\'si.title\')"></div>' +
          '</div>' +
          '<div class="region-actions">' +
            '<button class="btn btn-sm" data-bind="click: close, text: t(\'si.close\')"></button>' +
          '</div>' +
        '</header>' +
        '<div class="ed-drawer__body">' +
          '<!-- ko if: loading --><div class="si-loading" data-bind="text: t(\'si.loading\')"></div><!-- /ko -->' +
          '<!-- ko if: notFound() && !loading() -->' +
            '<div class="si-empty" data-bind="text: t(\'si.notRegistered\')"></div>' +
          '<!-- /ko -->' +
          '<!-- ko if: info() && !loading() -->' +
          '<div class="si-head">' +
            '<div class="si-page-name" data-bind="text: info().name"></div>' +
            '<!-- ko if: info().viewPriv -->' +
            '<div class="si-kv">' +
              '<span data-bind="text: t(\'si.viewPriv\')"></span> ' +
              '<code class="si-code" data-bind="text: info().viewPriv"></code>' +
              '<span data-bind="text: \' — \' + (info().viewPrivName || \'\')"></span>' +
            '</div>' +
            '<!-- /ko -->' +
            '<!-- ko ifnot: info().viewPriv -->' +
            '<div class="si-kv" data-bind="text: t(\'si.noViewPriv\')"></div>' +
            '<!-- /ko -->' +
          '</div>' +
          '<!-- ko foreach: artifacts -->' +
          '<div class="si-art">' +
            '<div class="si-art-head">' +
              '<span class="si-type" data-bind="text: $component.typeLabel(type)"></span>' +
              '<span class="si-art-label" data-bind="text: $data.label || code"></span>' +
              '<code class="si-code" data-bind="text: code"></code>' +
            '</div>' +
            '<!-- ko if: $data.privCode -->' +
            '<div class="si-kv">' +
              '<span data-bind="text: $component.t(\'si.guardedBy\')"></span> ' +
              '<code class="si-code" data-bind="text: privCode"></code>' +
              '<span data-bind="text: \' — \' + ($data.privName || \'\')"></span>' +
            '</div>' +
            '<div class="si-roles">' +
              '<span class="si-kv" data-bind="text: $component.t(\'si.grantedTo\')"></span>' +
              '<!-- ko foreach: grantedTo -->' +
              '<span class="si-role" data-bind="text: name || code, attr:{ title: category }"></span>' +
              '<!-- /ko -->' +
              '<!-- ko if: (grantedTo || []).length === 0 -->' +
              '<span class="si-kv si-warn" data-bind="text: $component.t(\'si.noRoles\')"></span>' +
              '<!-- /ko -->' +
            '</div>' +
            '<!-- /ko -->' +
            '<!-- ko ifnot: $data.privCode -->' +
            '<div class="si-kv si-warn" data-bind="text: $component.t(\'si.unguarded\')"></div>' +
            '<!-- /ko -->' +
            '<!-- ko if: $data.notes --><div class="si-kv" data-bind="text: notes"></div><!-- /ko -->' +
          '</div>' +
          '<!-- /ko -->' +
          '<!-- ko if: info() && artifacts().length === 0 -->' +
          '<div class="si-empty" data-bind="text: t(\'si.noArtifacts\')"></div>' +
          '<!-- /ko -->' +
          '<!-- /ko -->' +
        '</div>' +
      '</aside>' +
      '<!-- /ko -->'
  });

  return { registered: true };
});
