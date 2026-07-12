define(['knockout'], function (ko) {
  'use strict';

  /** Home — intentionally blank for now; the content will be designed later. */
  function HomeViewModel() {
    var self = this;
    self.openDashboard = function () { window._jetApp.navigate('dashboard'); };
  }

  return HomeViewModel;
});
