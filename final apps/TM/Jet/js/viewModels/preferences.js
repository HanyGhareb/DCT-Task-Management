define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function Preferences() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.leadDays = ko.observable(2);
    self.remindOverdue = ko.observable(true);
    self.inapp = ko.observable(true);
    self.email = ko.observable(false);
    self.digest = ko.observable(false);
    self.digestHour = ko.observable(7);

    tm.getPrefs().then(function (p) {
      self.leadDays(p.leadDays); self.remindOverdue(p.remindOverdue === 'Y');
      self.inapp(p.channelInapp === 'Y'); self.email(p.channelEmail === 'Y');
      self.digest(p.dailyDigest === 'Y'); self.digestHour(p.digestHour);
      self.loading(false);
    }).catch(function () { self.loading(false); });

    self.save = function () {
      tm.savePrefs({
        leadDays: Number(self.leadDays()), remindOverdue: self.remindOverdue() ? 'Y' : 'N',
        channelInapp: self.inapp() ? 'Y' : 'N', channelEmail: self.email() ? 'Y' : 'N',
        dailyDigest: self.digest() ? 'Y' : 'N', digestHour: Number(self.digestHour())
      }).then(function () { toast.success(self.t('tm.prefs.saved')); }).catch(function () {});
    };
  };
});
