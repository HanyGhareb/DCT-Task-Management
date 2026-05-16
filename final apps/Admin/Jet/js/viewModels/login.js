define(['knockout', 'services/authService'], function (ko, authService) {
  'use strict';

  function LoginViewModel(params) {
    const self = this;

    self.username  = ko.observable('');
    self.password  = ko.observable('');
    self.error     = ko.observable('');
    self.loading   = ko.observable(false);
    self.quickLogins = authService.QUICK_LOGINS;

    self.doLogin = function () {
      self.error('');
      if (!self.username() || !self.password()) {
        self.error('Please enter your username and password.');
        return;
      }
      self.loading(true);
      // Simulate async call
      setTimeout(() => {
        const user = authService.login(self.username(), self.password());
        self.loading(false);
        if (!user) {
          self.error('Invalid username or password.');
          return;
        }
        if (params && params.onLogin) params.onLogin(user);
        else if (window._jetApp && window._jetApp.onLogin) window._jetApp.onLogin(user);
      }, 400);
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
