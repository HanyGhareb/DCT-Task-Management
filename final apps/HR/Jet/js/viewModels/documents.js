define(['knockout', 'services/hrService'],
function (ko, hrService) {
  'use strict';

  function DocumentsViewModel() {
    var self = this;

    self.documents   = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.error       = ko.observable('');
    self.filterAlert = ko.observable('');
    self.filterDays  = ko.observable(90);
    self.searchQ     = ko.observable('');

    self.filtered = ko.computed(function () {
      var q     = (self.searchQ() || '').toUpperCase();
      var alert = self.filterAlert();
      return self.documents().filter(function (d) {
        var matchQ  = !q     || (d.fullNameEn || '').toUpperCase().includes(q) || (d.docType || '').toUpperCase().includes(q);
        var matchAl = !alert || d.expiryAlert === alert;
        return matchQ && matchAl;
      });
    });

    self.counts = ko.computed(function () {
      var all = self.documents();
      return {
        expired:  all.filter(function (d) { return d.expiryAlert === 'EXPIRED';  }).length,
        critical: all.filter(function (d) { return d.expiryAlert === 'CRITICAL'; }).length,
        warning:  all.filter(function (d) { return d.expiryAlert === 'WARNING';  }).length,
        upcoming: all.filter(function (d) { return d.expiryAlert === 'UPCOMING'; }).length,
      };
    });

    self.alertClass = function (alert) {
      var map = { EXPIRED: 'badge--rejected', CRITICAL: 'badge--advance_paid', WARNING: 'badge--warning', UPCOMING: 'badge--info' };
      return 'badge ' + (map[alert] || 'badge--idle');
    };

    self.setFilter = function (alert) {
      self.filterAlert(self.filterAlert() === alert ? '' : alert);
    };

    self.openEmployee = function (doc) {
      if (window._hrApp) window._hrApp.navigate('employeeDetail', { personId: doc.personId });
    };

    self.refresh = function () {
      self.loading(true);
      hrService.getExpiringDocs(self.filterDays()).then(function (list) {
        self.documents(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    self.refresh();
  }

  return DocumentsViewModel;
});
