define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function RunnerSettings() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.items = ko.observableArray([]);
    self.saving = ko.observable(false);

    function decorate(it) {
      it.val = ko.observable(it.value || '');
      it.enumList = it.enumValues ? it.enumValues.split(',') : [];
      return it;
    }

    self.load = function () {
      self.loading(true);
      atd.getConfig().then(function (r) {
        self.items((r.items || []).map(decorate));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.load();

    self.save = function () {
      self.saving(true);
      var payload = self.items().map(function (it) {
        return { key: it.key, value: it.val() };
      });
      atd.saveConfig(payload).then(function () {
        toast.success(self.t('atd.rs.saved')); self.saving(false); self.load();
      }).catch(function () { self.saving(false); });
    };
  };
});
