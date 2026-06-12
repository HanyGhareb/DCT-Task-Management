/**
 * shared/js/auditInfo.js — <audit-info> Knockout component.
 * Standard audit region for every edit/view page or modal:
 *
 *   <audit-info params="data: auditData"></audit-info>
 *
 * params.data: plain object or observable holding createdBy / createdAt /
 * updatedBy / updatedAt (the standard JSON keys emitted by the ORDS detail
 * handlers). Renders nothing when no audit fields are present (e.g. new
 * records), so it is always safe to include.
 */
define(['knockout', 'shared/i18n'], function (ko, i18n) {
  'use strict';

  function AuditInfoVM(params) {
    var self = this;
    self.t = i18n.t;
    self.d = ko.pureComputed(function () { return ko.unwrap(params.data) || {}; });
    self.hasCreated = ko.pureComputed(function () {
      return !!(self.d().createdAt || self.d().createdBy);
    });
    self.hasUpdated = ko.pureComputed(function () {
      return !!(self.d().updatedAt || self.d().updatedBy);
    });
    self.visible = ko.pureComputed(function () {
      return self.hasCreated() || self.hasUpdated();
    });
    function fmt(by, at) {
      var parts = [];
      if (by) parts.push(by);
      if (at) {
        var s = String(at);
        /* Server sends display-ready 'DD-Mon-YYYY HH:MI AM'; only normalise
           raw ISO strings that may arrive from older endpoints */
        if (s.indexOf('T') > 0) s = s.replace('T', ' ').substring(0, 16);
        parts.push(s);
      }
      return parts.join(' · ');
    }
    self.createdText = ko.pureComputed(function () { return fmt(self.d().createdBy, self.d().createdAt); });
    self.updatedText = ko.pureComputed(function () { return fmt(self.d().updatedBy, self.d().updatedAt); });
  }

  if (!ko.components.isRegistered('audit-info')) {
    ko.components.register('audit-info', {
      viewModel: AuditInfoVM,
      template:
        '<div class="audit-info" data-bind="visible: visible">' +
        '  <span class="audit-info__icon">&#128337;</span>' +
        '  <!-- ko if: hasCreated() -->' +
        '  <span class="audit-info__item">' +
        '    <span class="audit-info__lbl" data-bind="text: t(\'audit.created\')"></span>' +
        '    <span data-bind="text: createdText"></span>' +
        '  </span>' +
        '  <!-- /ko -->' +
        '  <!-- ko if: hasUpdated() -->' +
        '  <span class="audit-info__item">' +
        '    <span class="audit-info__lbl" data-bind="text: t(\'audit.updated\')"></span>' +
        '    <span data-bind="text: updatedText"></span>' +
        '  </span>' +
        '  <!-- /ko -->' +
        '</div>'
    });
  }

  return {};
});
