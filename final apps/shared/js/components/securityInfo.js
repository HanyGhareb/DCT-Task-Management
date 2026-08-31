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
define(['knockout', 'shared/api', 'shared/i18n',
        'shared/components/interactiveReport'], function (ko, api, i18n) {
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
    self.irData     = ko.observable(null);
    self.irSection  = ko.computed(function () {
      return (self.module() || '') + '_' + (self.page() || '');
    });

    self.t = function (k) { return i18n.t(k); };

    self.typeLabel = function (type) {
      var k = i18n.t('si.type.' + String(type || '').toLowerCase());
      return k.indexOf('si.type.') === 0 ? type : k;
    };

    /* the artifact register renders in the shared <interactive-report> */
    function buildIr(arts) {
      var cols = [
        { key: 'type',      label: self.t('si.col.type'),      type: 'text' },
        { key: 'label',     label: self.t('si.col.artifact'),  type: 'text' },
        { key: 'code',      label: self.t('si.col.key'),       type: 'text' },
        { key: 'privCode',  label: self.t('si.col.privilege'), type: 'text' },
        { key: 'privName',  label: self.t('si.col.privName'),  type: 'text' },
        { key: 'grantedTo', label: self.t('si.col.grantedTo'), type: 'text' },
        { key: 'notes',     label: self.t('si.col.notes'),     type: 'text' }
      ];
      var rows = (arts || []).map(function (a) {
        return {
          type: self.typeLabel(a.type),
          label: a.label || a.code,
          code: a.code,
          privCode: a.privCode || self.t('si.unguarded'),
          privName: a.privName || '',
          grantedTo: (a.grantedTo || []).map(function (g) {
            return g.name || g.code;
          }).join(', ') || (a.privCode ? self.t('si.noRoles') : ''),
          notes: a.notes || ''
        };
      });
      self.irData({ columns: cols, items: rows, total: rows.length,
                    truncated: false, maxRows: rows.length });
    }

    self.show = function () {
      self.open(true);
      self.loading(true);
      self.notFound(false);
      api.get('/sec/pageinfo?module=' + encodeURIComponent(self.module() || '') +
              '&page=' + encodeURIComponent(self.page() || ''), { base: 'auth' })
        .then(function (r) {
          self.info(r);
          self.artifacts(r.artifacts || []);
          buildIr(r.artifacts || []);
        })
        .catch(function (e) {
          self.info(null);
          self.artifacts([]);
          self.irData(null);
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
             'data-bind="css:{ \'ed-show\': open }, style:{ width: \'820px\' }, event:{ keydown: onKey }">' +
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
          '<!-- ko if: artifacts().length > 0 -->' +
          '<div class="si-ir">' +
            '<interactive-report params="reportCode: \'SEC_PAGEINFO\', section: irSection, ' +
                                        'data: irData, isAdmin: false, layoutsApi: null"></interactive-report>' +
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
