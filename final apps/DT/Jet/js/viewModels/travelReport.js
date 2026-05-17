define(['knockout', 'services/authService', 'services/dtService', 'services/settlementService', 'mockData'],
function (ko, authService, dtService, settlementService, mockData) {
  'use strict';

  function TravelReportViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.yearFilter   = ko.observable(new Date().getFullYear());
    self.statusFilter = ko.observable('');

    // Summary stats
    self.totalRequests  = ko.observable(0);
    self.totalApproved  = ko.observable(0);
    self.totalAdvance   = ko.observable('0.00');
    self.totalSettled   = ko.observable('0.00');

    // By-employee breakdown
    self.byEmployee = ko.observableArray([]);

    // Destinations breakdown
    self.byCountry = ko.observableArray([]);

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    function _load() {
      self.loading(true);
      Promise.all([
        dtService.getAllRequests({}),
        settlementService.getAllSettlements({}),
      ]).then(function (results) {
        var reqs    = results[0];
        var settles = results[1];
        var year    = parseInt(self.yearFilter());

        // Filter by year
        var filteredReqs = reqs.filter(function(r) {
          return new Date(r.createdAt || r.submittedAt || '').getFullYear() === year;
        });

        self.totalRequests(filteredReqs.length);
        self.totalApproved(filteredReqs.filter(function(r){ return ['APPROVED','ADVANCE_PAID','TRAVELLED','SETTLED','CLOSED'].includes(r.status); }).length);
        self.totalAdvance(self.fmt(filteredReqs.reduce(function(s,r){ return s + (r.advanceAmount || 0); }, 0)));
        self.totalSettled(self.fmt(settles.reduce(function(s,x){ return s + (x.totalSettlement || 0); }, 0)));

        // By employee
        var empMap = {};
        filteredReqs.forEach(function(r) {
          if (!empMap[r.userId]) empMap[r.userId] = { name: r.employeeName, count: 0, advance: 0, trips: [] };
          empMap[r.userId].count++;
          empMap[r.userId].advance += (r.advanceAmount || 0);
          empMap[r.userId].trips.push(r.status);
        });
        self.byEmployee(Object.values(empMap).sort(function(a,b){ return b.count - a.count; }));

        // By country (from mock destinations, simplified)
        var cntMap = {};
        mockData.TRAVEL_DESTINATIONS.forEach(function(d) {
          var req = filteredReqs.find(function(r){ return r.reqId === d.reqId; });
          if (!req) return;
          if (!cntMap[d.countryCode]) cntMap[d.countryCode] = { country: d.countryName, trips: 0, totalAed: 0 };
          cntMap[d.countryCode].trips++;
          cntMap[d.countryCode].totalAed += (d.amount || 0);
        });
        self.byCountry(Object.values(cntMap).sort(function(a,b){ return b.trips - a.trips; }));

        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    self.refresh = _load;
    _load();
  }

  return TravelReportViewModel;
});
