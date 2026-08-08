define(['knockout', 'services/payService', 'shared/i18n'],
function (ko, payService, i18n) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading = ko.observable(true);
    self.stats   = ko.observable({ companies: 0, supplierRefs: 0, activeContracts: 0,
                                   draftContracts: 0, expiringContracts: 0, banks: 0, expiring: [] });
    self.quality = ko.observableArray([]);
    self.renewals = ko.observableArray([]);
    self.headcount    = ko.observable(0);
    self.expiringDocs = ko.observableArray([]);

    self.regionCollapsed = ko.observable(false);
    self.regionMax       = ko.observable(false);
    self.toggleRegion    = function () { self.regionCollapsed(!self.regionCollapsed()); };
    self.toggleRegionMax = function () { self.regionMax(!self.regionMax()); };

    self.refresh = function () {
      self.loading(true);
      Promise.all([payService.stats(), payService.getDataQuality(), payService.getRenewals(),
                   payService.getEmployees({ active: 'Y', limit: 1 }), payService.getExpiringDocs(30)]).then(function (all) {
        var d=all[0]; d.expiring = d.expiring || []; self.stats(d);
        self.quality(all[1].items || []); self.renewals(all[2].items || []);
        self.headcount(all[3].total || 0);
        self.expiringDocs(all[4].items || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    function exportRows(name, rows, cols) {
      var lines=[cols.join(',')]; rows.forEach(function(r){lines.push(cols.map(function(c){return '"'+String(r[c]===null||r[c]===undefined?'':r[c]).replace(/"/g,'""')+'"';}).join(','));});
      var a=document.createElement('a');a.href=URL.createObjectURL(new Blob(['﻿'+lines.join('\n')],{type:'text/csv;charset=utf-8'}));a.download=name;a.click();
    }
    self.exportQuality=function(){exportRows('pay-data-quality.csv',self.quality(),['companyId','companyCode','name','missingContact','missingSupplier','expiredCompliance','contractsWithoutMargin','missingOwner']);};
    self.exportRenewals=function(){exportRows('pay-renewals.csv',self.renewals(),['contractNo','companyCode','company','dateTo','daysLeft','renewalStatus','ownerId']);};

    self.go = function (route) { if (window._jetApp) window._jetApp.navigate(route); };
    self.openContract = function (row) {
      if (window._jetApp) window._jetApp.navigate('contracts', { openContractId: row.contractId });
    };
    self.openEmployee = function (row) {
      if (window._jetApp) window._jetApp.navigate('employees', { openPersonId: row.personId });
    };

    self.refresh();
  }

  return DashboardViewModel;
});
