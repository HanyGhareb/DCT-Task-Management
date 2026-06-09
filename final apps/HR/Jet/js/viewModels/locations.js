define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function LocationsViewModel() {
    var self = this;

    self.isAdmin   = authService.isHrAdmin();
    self.locations = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');
    self.saved     = ko.observable('');
    self.searchQ   = ko.observable('');
    self.selected  = ko.observable(null);

    // Modal
    self.showModal = ko.observable(false);
    self.editingId = ko.observable(null);
    self.saving    = ko.observable(false);
    self.formError = ko.observable('');
    self.form = {
      location_code:    ko.observable(''),
      location_name_en: ko.observable(''),
      location_name_ar: ko.observable(''),
      emirate:          ko.observable(''),
      city:             ko.observable(''),
      area:             ko.observable(''),
      building_name:    ko.observable(''),
      floor_no:         ko.observable(''),
      country_code:     ko.observable('AE'),
      is_active:        ko.observable('Y'),
    };

    self.filtered = ko.computed(function () {
      var q = (self.searchQ() || '').toUpperCase();
      return self.locations().filter(function (l) {
        return !q || (l.locationNameEn || '').toUpperCase().includes(q)
                  || (l.locationCode   || '').toUpperCase().includes(q)
                  || (l.emirate        || '').toUpperCase().includes(q);
      });
    });

    self.auditExpanded = ko.observable(false);
    self.toggleAudit   = function () { self.auditExpanded(!self.auditExpanded()); };

    self.fmtDateTime = function (dt) {
      if (!dt) return '—';
      var d = new Date(dt);
      if (isNaN(d.getTime())) return dt;
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear()
           + ' · ' + String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0');
    };

    self.select = function (loc) { self.selected(loc); self.auditExpanded(false); };

    self.typeClass = function (t) {
      var map = { HQ: 'badge--blue', BRANCH: 'badge--info', REMOTE: 'badge--pending', FIELD: 'badge--warning', DATA_CENTER: 'badge--settled' };
      return 'badge ' + (map[t] || 'badge--idle');
    };

    function _clearForm() {
      Object.keys(self.form).forEach(function (k) {
        self.form[k](k === 'is_active' ? 'Y' : k === 'country_code' ? 'AE' : '');
      });
      self.formError('');
      self.editingId(null);
    }

    self.openAdd = function () { _clearForm(); self.showModal(true); };

    self.openEdit = function (loc) {
      _clearForm();
      self.editingId(loc.locationId);
      self.form.location_code(loc.locationCode || '');
      self.form.location_name_en(loc.locationNameEn || '');
      self.form.location_name_ar(loc.locationNameAr || '');
      self.form.emirate(loc.emirate || '');
      self.form.city(loc.city || '');
      self.form.area(loc.area || '');
      self.form.building_name(loc.buildingName || '');
      self.form.floor_no(loc.floorNo || '');
      self.form.country_code(loc.countryCode || 'AE');
      self.form.is_active(loc.isActive || 'Y');
      self.showModal(true);
    };

    self.closeModal = function () { if (!self.saving()) self.showModal(false); };

    self.saveLocation = function () {
      var name = self.form.location_name_en().trim();
      var code = self.form.location_code().trim();
      if (!name) { self.formError('Location Name (EN) is required.'); return; }
      if (!self.editingId() && !code) { self.formError('Location Code is required.'); return; }

      var data = {
        location_code:    code,
        location_name_en: name,
        location_name_ar: self.form.location_name_ar(),
        emirate:          self.form.emirate(),
        city:             self.form.city(),
        area:             self.form.area(),
        building_name:    self.form.building_name(),
        floor_no:         self.form.floor_no(),
        country_code:     self.form.country_code() || 'AE',
        is_active:        self.form.is_active(),
      };

      self.saving(true);
      var op = self.editingId()
        ? hrService.updateLocation(self.editingId(), data)
        : hrService.createLocation(data);

      op.then(function () {
        self.saving(false);
        self.showModal(false);
        self.saved(self.editingId() ? 'Location updated.' : 'Location added.');
        setTimeout(function () { self.saved(''); }, 4000);
        _load();
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed.');
      });
    };

    function _load() {
      self.loading(true);
      hrService.getLocations().then(function (list) {
        self.locations(list);
        if (list.length && !self.selected()) self.selected(list[0]);
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
