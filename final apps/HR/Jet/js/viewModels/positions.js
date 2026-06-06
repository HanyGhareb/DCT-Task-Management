define(['knockout', 'services/hrService'],
function (ko, hrService) {
  'use strict';

  function PositionsViewModel() {
    var self = this;

    self.positions  = ko.observableArray([]);
    self.orgs       = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.error      = ko.observable('');
    self.filterOrg  = ko.observable('');
    self.searchQ    = ko.observable('');
    self.filterVacancy = ko.observable('');

    self.filtered = ko.computed(function () {
      var q   = (self.searchQ() || '').toUpperCase();
      var org = self.filterOrg();
      var vac = self.filterVacancy();
      return self.positions().filter(function (p) {
        var matchQ   = !q   || (p.positionNameEn || '').toUpperCase().includes(q) || (p.positionCode || '').toUpperCase().includes(q);
        var matchOrg = !org || String(p.orgId) === String(org);
        var matchVac = !vac || (vac === 'vacant' ? p.vacancyCount > 0 : vac === 'full' ? p.vacancyCount <= 0 : true);
        return matchQ && matchOrg && matchVac;
      });
    });

    self.totalApproved = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.approvedHeadcount || 0); }, 0); });
    self.totalFilled   = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.filledCount       || 0); }, 0); });
    self.totalVacant   = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.vacancyCount      || 0); }, 0); });

    self.fillPct = function (pos) {
      if (!pos.approvedHeadcount) return 0;
      return Math.min(100, Math.round((pos.filledCount / pos.approvedHeadcount) * 100));
    };

    self.vacancyClass = function (pos) {
      if (pos.vacancyCount > 0) return 'badge badge--warning';
      return 'badge badge--approved';
    };

    function _load() {
      Promise.all([
        hrService.getPositions(),
        hrService.getOrgs(),
      ]).then(function (results) {
        self.positions(results[0]);
        self.orgs(results[1]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load positions.');
        self.loading(false);
      });
    }

    _load();
  }

  return PositionsViewModel;
});
