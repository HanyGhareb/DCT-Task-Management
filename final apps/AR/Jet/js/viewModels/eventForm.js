define(['knockout', 'services/arService', 'shared/i18n', 'shared/toast'],
function (ko, arService, i18n, toast) {
  'use strict';

  function EventFormViewModel() {
    var self = this;
    self.t = i18n.t;

    var state   = window._arApp.getState();
    var eventId = state.eventId || null;
    self.isEdit = !!eventId;

    self.saving     = ko.observable(false);
    self.eventTypes = ko.observableArray([]);
    self.currencies = ko.observableArray(['AED']);

    self.nameEn         = ko.observable('');
    self.nameAr         = ko.observable('');
    self.eventType      = ko.observable('OTHER');
    self.venue          = ko.observable('');
    self.organizer      = ko.observable('');
    self.contractNumber = ko.observable('');
    self.startDate      = ko.observable('');
    self.endDate        = ko.observable('');
    self.expectedAttendance = ko.observable(null);
    self.revSharePct    = ko.observable(null);
    self.currency       = ko.observable('AED');
    self.description    = ko.observable('');

    arService.getLookups().then(function (lk) {
      self.eventTypes(lk.AR_EVENT_TYPE || []);
      self.currencies(lk.currencies || ['AED']);
    }).catch(function () {});

    if (eventId) {
      arService.getEvent(eventId).then(function (e) {
        self.nameEn(e.nameEn);          self.nameAr(e.nameAr || '');
        self.eventType(e.eventType || 'OTHER');
        self.venue(e.venue || '');      self.organizer(e.organizer || '');
        self.contractNumber(e.contractNumber || '');
        self.startDate(e.startDate || ''); self.endDate(e.endDate || '');
        self.expectedAttendance(e.expectedAttendance);
        self.revSharePct(e.revSharePct);
        self.currency(e.currency || 'AED');
        self.description(e.description || '');
      });
    }

    self.save = function () {
      if (!self.nameEn()) { toast.error('Event name is required'); return; }
      self.saving(true);
      var payload = {
        nameEn: self.nameEn(), nameAr: self.nameAr() || null,
        eventType: self.eventType(), venue: self.venue() || null,
        organizer: self.organizer() || null,
        contractNumber: self.contractNumber() || null,
        startDate: self.startDate() || null, endDate: self.endDate() || null,
        expectedAttendance: self.expectedAttendance() || null,
        revSharePct: self.revSharePct() || null,
        currency: self.currency(), description: self.description() || null,
      };
      var p = eventId ? arService.updateEvent(eventId, payload)
                      : arService.createEvent(payload);
      p.then(function (res) {
        toast.success(eventId ? 'Event updated' : 'Event ' + (res.eventCode || '') + ' created');
        window._arApp.navigate('eventDetail', { eventId: eventId || res.eventId });
      }).catch(function (err) {
        self.saving(false);
        toast.error((err && err.message) || 'Save failed');
      });
    };

    self.cancel = function () {
      if (eventId) { window._arApp.navigate('eventDetail', { eventId: eventId }); }
      else { window._arApp.navigate('events'); }
    };
  }

  return EventFormViewModel;
});
