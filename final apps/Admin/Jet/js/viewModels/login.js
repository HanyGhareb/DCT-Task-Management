define(['knockout', 'services/authService', 'services/config'], function (ko, authService, config) {
  'use strict';

  function LoginViewModel(params) {
    var self = this;

    self.username   = ko.observable('');
    self.password   = ko.observable('');
    self.error      = ko.observable('');
    self.loading    = ko.observable(false);
    self.quickLogins = authService.QUICK_LOGINS;

    // Settings-driven branding (APP_NAME / APP_TAGLINE in DCT_SYSTEM_SETTINGS).
    // /branding is the only public endpoint — plain fetch, no Authorization;
    // the view falls back to the static title / i18n subtitle until it loads.
    self.appName   = ko.observable('');
    self.appNameAr = ko.observable('');
    self.tagline   = ko.observable('');
    self.taglineAr = ko.observable('');
    if (config.apiBase) {
      fetch(config.apiBase + '/branding')
        .then(function (r) { return r.ok ? r.json() : null; })
        .then(function (b) {
          if (!b) return;
          self.appName(b.appName || '');
          self.appNameAr(b.appNameAr || '');
          self.tagline(b.tagline || '');
          self.taglineAr(b.taglineAr || '');
          if (b.appName) document.title = b.appName + ' — Admin Portal';
        })
        .catch(function () {});
    }

    self.doLogin = function () {
      self.error('');
      if (!self.username() || !self.password()) {
        self.error('Please enter your username and password.');
        return;
      }
      self.loading(true);
      authService.login(self.username(), self.password())
        .then(function (user) {
          self.loading(false);
          if (!user) {
            self.error('Invalid username or password.');
            return;
          }
          if (params && params.onLogin) params.onLogin(user);
          else if (window._jetApp) window._jetApp.onLogin(user);
        })
        .catch(function (err) {
          self.loading(false);
          self.error((err && err.message) || 'Login failed. Please try again.');
        });
    };

    self.quickLogin = function (item) {
      self.username(item.username);
      self.password(item.password);
      self.doLogin();
    };

    self.onKeyDown = function (vm, event) {
      if (event.key === 'Enter') self.doLogin();
      return true;
    };
  }

  return LoginViewModel;
});
