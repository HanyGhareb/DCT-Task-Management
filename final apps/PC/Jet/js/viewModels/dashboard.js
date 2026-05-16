define(['knockout', 'services/authService', 'services/pcService', 'services/settingService'],
function (ko, authService, pcService, settingService) {
  'use strict';

  function DashboardViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.user = user;

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
    });
    self.todayDate = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    // Stats
    self.stats = {
      activePc:            ko.observable(0),
      pendingPc:           ko.observable(0),
      totalFloat:          ko.observable('0.00'),
      reimbPending:        ko.observable(0),
      orgPendingApprovals: ko.observable(0),
    };

    self.activeRecord   = ko.observable(null);
    self.recentActivity = ko.observableArray([]);
    self.loading        = ko.observable(true);
    self.closingMsg     = ko.observable('');
    self.showClosingBanner = ko.observable(false);

    self.isApprover = authService.isApprover();
    self.isPcAdmin  = authService.isPcAdmin();

    // Quick actions
    self.newRequest = function () { if (window._pcApp) window._pcApp.navigate('pcRequest'); };
    self.newReimb   = function () { if (window._pcApp) window._pcApp.navigate('reimbDetail'); };
    self.newClear   = function () { if (window._pcApp) window._pcApp.navigate('clearDetail'); };
    self.viewMy     = function () { if (window._pcApp) window._pcApp.navigate('myPettyCash'); };
    self.viewApprovals = function() { if (window._pcApp) window._pcApp.navigate('approvals'); };

    self.hasActivePc = ko.computed(function() {
      return self.activeRecord() !== null;
    });

    function _statusClass(s) {
      var map = { ACTIVE:'badge--active', PENDING_APPROVAL:'badge--pending', APPROVED:'badge--info',
                  SUBMITTED:'badge--pending', CLOSED:'badge--inactive', REJECTED:'badge--rejected' };
      return 'badge ' + (map[s] || 'badge--info');
    }
    self.statusClass = _statusClass;

    function _load() {
      pcService.getDashboardStats(user.userId).then(function(stats) {
        self.stats.activePc(stats.activePc);
        self.stats.pendingPc(stats.pendingPc);
        self.stats.totalFloat(stats.totalFloatFormatted);
        self.stats.reimbPending(stats.reimbPending);
        self.stats.orgPendingApprovals(stats.orgPendingApprovals || 0);
        if (stats.activeRecord) self.activeRecord(stats.activeRecord);
        self.loading(false);
      }).catch(function() { self.loading(false); });

      pcService.getRecentActivity(user.userId).then(function(list) {
        self.recentActivity(list);
      });

      // Closing banner
      var msg  = settingService.getValue('TEMP_PC_CLOSING_DEADLINE_MSG');
      var show = settingService.getValue('SHOW_CLOSING_BANNER');
      if (show === 'Y' && msg) {
        self.closingMsg(msg);
        self.showClosingBanner(true);
      }
    }

    _load();
  }

  return DashboardViewModel;
});
