define(['knockout', 'services/authService'], function (ko, authService) {
  'use strict';

  function LoginViewModel() {
    var self = this;

    self.username    = ko.observable('');
    self.password    = ko.observable('');
    self.error       = ko.observable('');
    self.loading     = ko.observable(false);
    self.quickLogins = authService.QUICK_LOGINS;

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
          if (!user) { self.error('Invalid username or password.'); return; }
          if (window._pcApp) window._pcApp.onLogin(user);
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
