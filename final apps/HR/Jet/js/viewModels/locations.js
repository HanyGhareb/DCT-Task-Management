define(['knockout', 'services/hrService'],
function (ko, hrService) {
  'use strict';

  function LocationsViewModel() {
    var self = this;

    self.locations = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');
    self.searchQ   = ko.observable('');
    self.selected  = ko.observable(null);

    self.filtered = ko.computed(function () {
      var q = (self.searchQ() || '').toUpperCase();
      return self.locations().filter(function (l) {
        return !q || (l.locationNameEn || '').toUpperCase().includes(q)
                  || (l.locationCode   || '').toUpperCase().includes(q)
                  || (l.emirate        || '').toUpperCase().includes(q);
      });
    });

    self.select = function (loc) { self.selected(loc); };

    self.typeClass = function (t) {
      var map = { HQ: 'badge--blue', BRANCH: 'badge--info', REMOTE: 'badge--pending', FIELD: 'badge--warning', DATA_CENTER: 'badge--settled' };
      return 'badge ' + (map[t] || 'badge--idle');
    };

    function _load() {
      hrService.getLocations().then(function (list) {
        self.locations(list);
        if (list.length) self.selected(list[0]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load locations.');
        self.loading(false);
      });
    }

    _load();
  }

  return LocationsViewModel;
});
