define(['knockout', 'services/hrService'],
function (ko, hrService) {
  'use strict';

  function JobsViewModel() {
    var self = this;

    self.jobs       = ko.observableArray([]);
    self.families   = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.error      = ko.observable('');
    self.filterFam  = ko.observable('');
    self.searchQ    = ko.observable('');
    self.selected   = ko.observable(null);

    self.filtered = ko.computed(function () {
      var q   = (self.searchQ() || '').toUpperCase();
      var fam = self.filterFam();
      return self.jobs().filter(function (j) {
        var matchQ   = !q   || (j.jobNameEn || '').toUpperCase().includes(q) || (j.jobCode || '').toUpperCase().includes(q);
        var matchFam = !fam || String(j.jobFamilyId) === String(fam);
        return matchQ && matchFam;
      });
    });

    self.select = function (job) { self.selected(job); };
    self.clearSelection = function () { self.selected(null); };

    function _load() {
      Promise.all([
        hrService.getJobs(),
        hrService.getJobFamilies(),
      ]).then(function (results) {
        self.jobs(results[0]);
        self.families(results[1]);
        if (results[0].length) self.selected(results[0][0]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load jobs.');
        self.loading(false);
      });
    }

    _load();
  }

  return JobsViewModel;
});
