define(['knockout', 'services/tmService', 'shared/i18n'],
function (ko, tm, i18n) {
  'use strict';
  return function TeamRoles() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.roles = ko.observableArray([]);
    self.role = ko.observable('');
    self.perms = ko.observableArray([]);

    self.loadPerms = function () {
      if (!self.role()) return;
      tm.getPerms('', self.role()).then(function (r) { self.perms(r.items || []); }).catch(function () {});
    };
    self.role.subscribe(function () { self.loadPerms(); });

    tm.boot().then(function (b) {
      self.roles(b.roles || []);
      if (b.roles && b.roles.length) { self.role(b.roles[0].code); }
      self.loading(false);
    }).catch(function () { self.loading(false); });

    self.yn = function (v) { return v === 'Y' ? '✓' : '·'; };
  };
});
