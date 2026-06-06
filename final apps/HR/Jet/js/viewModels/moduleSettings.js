define(['knockout', 'services/authService', 'services/hrService', 'services/notificationService'],
function (ko, authService, hrService, notifService) {
  'use strict';

  function ModuleSettingsViewModel() {
    var self = this;

    self.isAdmin = authService.isHrAdmin();
    self.saved   = ko.observable(false);
    self.error   = ko.observable('');

    self.apiMode = ko.observable(!!window._hrConfig_apiBase);

    self.resetData = function () {
      if (!confirm('Reset all mock HR data to defaults?')) return;
      hrService.reset();
      notifService.reset();
      self.saved(true);
      setTimeout(function () { self.saved(false); }, 3000);
    };

    self.moduleInfo = {
      name:    'Human Resources (App 205)',
      version: '1.0.0',
      ords:    '/ords/admin/hr/',
      schema:  'PROD',
      tables:  8,
      views:   6,
    };
  }

  return ModuleSettingsViewModel;
});
