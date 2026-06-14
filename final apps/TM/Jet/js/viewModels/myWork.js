define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function MyWork() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.tasks = ko.observableArray([]);

    self.load = function () {
      self.loading(true);
      tm.myTasks('').then(function (r) { self.tasks(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };
    self.markDone = function (tk) {
      tm.setTaskStatus({ taskId: tk.taskId, status: 'DONE' })
        .then(function () { toast.success('✓'); self.load(); }).catch(function () {});
    };
    self.open = function (tk) { window._jetApp.navigate('teamDetail', { teamId: tk.teamId, tab: 'tasks' }); };
    self.prioClass = function (p) { return 'prio prio--' + p; };
    self.statClass = function (s) { return 'tstat tstat--' + s; };
    self.load();
  };
});
