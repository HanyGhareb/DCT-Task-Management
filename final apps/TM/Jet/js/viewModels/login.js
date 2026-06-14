define(['knockout', 'services/authService'],
function (ko, authService) {
  'use strict';

  function LoginViewModel() {
    var self = this;

    self.username = ko.observable('');
    self.password = ko.observable('');
    self.error    = ko.observable('');
    self.loading  = ko.observable(false);

    self.quickLogins = authService.QUICK_LOGINS;

    self.doLogin = function () {
      self.error('');
      var u = (self.username() || '').trim();
      var p = self.password();
      if (!u || !p) { self.error('Please enter username and password.'); return; }
      self.loading(true);
      authService.login(u, p).then(function (user) {
        self.loading(false);
        if (!user) { self.error('Invalid credentials. Please try again.'); return; }
        if (window._jetApp) window._jetApp.onLogin(user);
      }).catch(function () {
        self.loading(false);
        self.error('Login failed. Please try again.');
      });
    };

    self.quickLogin = function (ql) {
      self.username(ql.username);
      self.password(ql.password);
      self.doLogin();
    };
  }

  return LoginViewModel;
});
