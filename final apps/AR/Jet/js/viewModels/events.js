define(['knockout', 'services/arService', 'shared/i18n'],
function (ko, arService, i18n) {
  'use strict';

  function EventsViewModel() {
    var self = this;
    self.t = i18n.t;
    self.fmt = function (n) { return i18n.fmtNum ? i18n.fmtNum(n || 0, 0) : String(n || 0); };

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.events    = ko.observableArray([]);

    self.total  = ko.observable(0);
    self.limit  = ko.observable(25);
    self.offset = ko.observable(0);

    self.searchText   = ko.observable('');
    self.statusFilter = ko.observable('');

    self.statusClass = function (s) {
      var map = {
        NEW: 'badge badge--neutral', FILES_UPLOADED: 'badge badge--info',
        AI_PROCESSING: 'badge badge--warning', UNDER_REVIEW: 'badge badge--warning',
        CONFIRMED: 'badge badge--success', CLOSED: 'badge badge--neutral',
      };
      return map[s] || 'badge badge--neutral';
    };

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      arService.getEvents({
        search: self.searchText() || null,
        status: self.statusFilter() || null,
        limit:  self.limit(),
        offset: self.offset(),
      }).then(function (res) {
        self.total(res.total || 0);
        self.events(res.items || []);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
    };

    var _t = null;
    self.searchText.subscribe(function () {
      clearTimeout(_t);
      _t = setTimeout(function () { self.offset(0); self.reload(); }, 350);
    });
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.openDetail = function (ev) {
      window._arApp.navigate('eventDetail', { eventId: ev.eventId });
    };
    self.newEvent = function () { window._arApp.navigate('eventForm', { eventId: null }); };

    self.reload();
  }

  return EventsViewModel;
});
