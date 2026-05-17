define(['knockout', 'services/authService'],
function (ko, authService) {
  'use strict';

  function LoginViewModel() {
    var self = this;

    self.username   = ko.observable('');
    self.password   = ko.observable('');
    self.error      = ko.observable('');
    self.loading    = ko.observable(false);
    self.quickLogins = authService.QUICK_LOGINS;

    self.login = function () {
      self.error('');
      if (!self.username() || !self.password()) { self.error('Please enter username and password.'); return; }
      self.loading(true);
      authService.login(self.username(), self.password()).then(function (user) {
        self.loading(false);
        if (!user) { self.error('Invalid credentials or account inactive.'); return; }
        if (window._dtApp) window._dtApp.onLogin(user);
      }).catch(function (e) {
        self.loading(false);
        self.error(e && e.message ? e.message : 'Login failed. Please try again.');
      });
    };

    self.quickLogin = function (ql) {
      self.username(ql.username);
      self.password(ql.password);
      self.login();
    };
  }

  return LoginViewModel;
});
