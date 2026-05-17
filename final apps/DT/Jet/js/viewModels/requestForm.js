define(['knockout', 'services/authService', 'services/dtService', 'services/approvalService', 'mockData'],
function (ko, authService, dtService, approvalService, mockData) {
  'use strict';

  function RequestFormViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.user = user;

    var editReqId = window._dtApp && window._dtApp.getState().reqId;
    self.isEdit   = ko.observable(!!editReqId);
    self.reqNumber = ko.observable('');

    // ── Header fields ───────────────────────────────────────────────────────
    self.travelPurpose    = ko.observable('');
    self.missionType      = ko.observable('BUSINESS_MISSION');
    self.tripType         = ko.observable('EXTERNAL');
    self.departureDate    = ko.observable('');
    self.returnDate       = ko.observable('');
    self.advanceRequested = ko.observable('Y');
    self.notes            = ko.observable('');

    // ── UI state ─────────────────────────────────────────────────────────────
    self.saving    = ko.observable(false);
    self.error     = ko.observable('');
    self.successMsg = ko.observable('');

    // ── Destinations ─────────────────────────────────────────────────────────
    self.destinations = ko.observableArray([]);
    self.countries    = ko.observableArray([]);

    // Prevent circular sync between header dates and destination dates
    var _syncing = false;

    // ── Header → first destination arrival date ───────────────────────────
    self.departureDate.subscribe(function (dt) {
      if (_syncing) return;
      _syncing = true;
      var dests = self.destinations();
      if (dests.length > 0) {
        dests[0].fromDate(dt);
      }
      _syncing = false;
    });

    // Header → last destination departure date
    self.returnDate.subscribe(function (dt) {
      if (_syncing) return;
      _syncing = true;
      var dests = self.destinations();
      if (dests.length > 0) {
        dests[dests.length - 1].toDate(dt);
      }
      _syncing = false;
    });

    // ── Computed totals ───────────────────────────────────────────────────────
    self.totalEstimatedPerDiem = ko.computed(function () {
      return self.destinations().reduce(function (s, d) { return s + (parseFloat(d.amount()) || 0); }, 0);
    });
    self.totalTripDays = ko.computed(function () {
      return self.destinations().reduce(function (s, d) { return s + (parseInt(d.days()) || 0); }, 0);
    });
    self.estimatedAdvance = ko.computed(function () {
      return self.advanceRequested() === 'Y' ? self.totalEstimatedPerDiem() : 0;
    });

    // ── Countries ─────────────────────────────────────────────────────────────
    dtService.getCountries().then(function (list) { self.countries(list); });

    // ── Destination row factory ───────────────────────────────────────────────
    function _makeDestRow(d, defaultFromDate) {
      var row = {
        destId:       d ? d.destId : null,
        countryCode:  ko.observable(d ? (d.countryCode || '') : ''),
        countryName:  ko.observable(d ? (d.countryName  || '') : ''),
        fromDate:     ko.observable(d ? (d.fromDate     || '') : (defaultFromDate || '')),
        toDate:       ko.observable(d ? (d.toDate       || '') : ''),
        dailyRateAed: ko.observable(d ? (d.dailyRateAed || 0)  : 0),
        days:         ko.observable(d ? (d.days         || 0)  : 0),
        amount:       ko.observable(d ? (d.amount       || 0)  : 0),
      };

      function _recalc() {
        var from = row.fromDate();
        var to   = row.toDate();
        if (from && to && to >= from) {
          var d1   = new Date(from);
          var d2   = new Date(to);
          var days = Math.max(1, Math.round((d2 - d1) / 86400000) + 1);
          row.days(days);
          row.amount(days * (parseFloat(row.dailyRateAed()) || 0));
        } else {
          row.days(0);
          row.amount(0);
        }
      }

      // ── First destination fromDate → header departureDate ────────────────
      row.fromDate.subscribe(function (dt) {
        _recalc();
        if (_syncing) return;
        var dests = self.destinations();
        if (dests.length > 0 && dests[0] === row) {
          _syncing = true;
          self.departureDate(dt);
          _syncing = false;
        }
      });

      // ── Last destination toDate → header returnDate ───────────────────────
      row.toDate.subscribe(function (dt) {
        _recalc();
        if (_syncing) return;
        var dests = self.destinations();
        if (dests.length > 0 && dests[dests.length - 1] === row) {
          _syncing = true;
          self.returnDate(dt);
          _syncing = false;
        }
      });

      // ── Country change → load per diem rate ──────────────────────────────
      row.countryCode.subscribe(function (code) {
        if (!code) return;
        var c = self.countries().find(function (x) { return x.countryCode === code; });
        if (c) row.countryName(c.countryName);
        var travelDate = row.fromDate() || self.departureDate() || new Date().toISOString().slice(0, 10);
        dtService.getPerDiemRate(code, user.gradeCode || 'ALL', travelDate).then(function (rate) {
          row.dailyRateAed(rate ? (rate.dailyRateAed || rate.per_diem_daily_aed || 0) : 0);
          _recalc();
        });
      });

      return row;
    }

    // ── Add / remove destination ──────────────────────────────────────────────
    self.addDest = function () {
      var dests = self.destinations();
      var lastDest = dests.length > 0 ? dests[dests.length - 1] : null;
      // New leg starts where the previous leg ends (sequential, non-overlapping)
      var newFromDate = (lastDest && lastDest.toDate()) ? lastDest.toDate()
                        : (self.departureDate() || '');
      self.destinations.push(_makeDestRow(null, newFromDate));
    };

    self.removeDest = function (row) {
      if (self.destinations().length > 1) {
        self.destinations.remove(row);
        // Re-sync last destination's toDate → returnDate
        var dests = self.destinations();
        if (dests.length > 0) {
          _syncing = true;
          self.returnDate(dests[dests.length - 1].toDate());
          _syncing = false;
        }
      }
    };

    // ── Load for edit ─────────────────────────────────────────────────────────
    if (editReqId) {
      dtService.getRequest(editReqId).then(function (req) {
        self.reqNumber(req.reqNumber);
        self.travelPurpose(req.travelPurpose || '');
        self.missionType(req.missionType  || 'BUSINESS_MISSION');
        self.tripType(req.tripType        || 'EXTERNAL');
        self.departureDate(req.departureDate || '');
        self.returnDate(req.returnDate    || '');
        self.advanceRequested(req.advanceRequested || 'Y');
        self.notes(req.notes              || '');
        var dests = (req.destinations || []).map(function (d) { return _makeDestRow(d); });
        self.destinations(dests);
      });
    } else {
      self.destinations.push(_makeDestRow(null));
    }

    // ── Validation ────────────────────────────────────────────────────────────
    function _validate() {
      self.error('');
      if (!self.travelPurpose().trim()) {
        self.error('Travel purpose is required.'); return false;
      }
      if (!self.departureDate()) {
        self.error('Departure date is required.'); return false;
      }
      if (!self.returnDate()) {
        self.error('Return date is required.'); return false;
      }
      if (self.returnDate() < self.departureDate()) {
        self.error('Return date must be on or after departure date.'); return false;
      }
      var dests = self.destinations();
      if (dests.length === 0) {
        self.error('At least one destination is required.'); return false;
      }
      for (var i = 0; i < dests.length; i++) {
        var d = dests[i];
        if (!d.countryCode()) {
          self.error('Please select a country for destination ' + (i + 1) + '.'); return false;
        }
        if (!d.fromDate() || !d.toDate()) {
          self.error('Please set arrival and departure dates for destination ' + (i + 1) + '.'); return false;
        }
        if (d.toDate() < d.fromDate()) {
          self.error('Destination ' + (i + 1) + ' departure date must be on or after its arrival date.'); return false;
        }
        // Sequential check — each leg must start on or after the previous leg ends
        if (i > 0) {
          var prev = dests[i - 1];
          if (d.fromDate() < prev.toDate()) {
            self.error(
              'Destination ' + (i + 1) + ' (' + (d.countryCode() || '—') + ') arrival date (' + d.fromDate() +
              ') overlaps with destination ' + i + ' (' + (prev.countryCode() || '—') + ') which ends on ' + prev.toDate() + '.'
            );
            return false;
          }
        }
      }
      return true;
    }

    // ── Build payload ─────────────────────────────────────────────────────────
    function _buildPayload(status) {
      var dests = self.destinations().map(function (d, i) {
        return {
          seqNum:      i + 1,
          countryCode: d.countryCode(),
          countryName: d.countryName(),
          fromDate:    d.fromDate(),
          toDate:      d.toDate(),
          dailyRateAed: parseFloat(d.dailyRateAed()) || 0,
          days:         parseInt(d.days())            || 0,
          amount:       parseFloat(d.amount())        || 0,
        };
      });
      var totalPD = dests.reduce(function (s, d) { return s + d.amount; }, 0);
      return {
        userId:           user.userId,
        employeeName:     user.displayName,
        gradeCode:        user.gradeCode || 'ALL',
        orgId:            user.orgId,
        travelPurpose:    self.travelPurpose(),
        missionType:      self.missionType(),
        tripType:         self.tripType(),
        departureDate:    self.departureDate(),
        returnDate:       self.returnDate(),
        advanceRequested: self.advanceRequested(),
        advanceAmount:    self.advanceRequested() === 'Y' ? totalPD : 0,
        estimatedPerDiem: totalPD,
        notes:            self.notes(),
        status:           status,
        destinations:     dests,
      };
    }

    // ── Actions ───────────────────────────────────────────────────────────────
    self.saveDraft = function () {
      self.error(''); self.successMsg('');
      if (!self.travelPurpose().trim()) { self.error('Travel purpose is required.'); return; }
      self.saving(true);
      var payload = _buildPayload('DRAFT');
      var promise = self.isEdit() ? dtService.updateRequest(editReqId, payload)
                                  : dtService.createRequest(payload);
      promise.then(function () {
        self.saving(false);
        self.successMsg('Draft saved successfully.');
        if (window._dtApp) window._dtApp.navigate('myRequests');
      }).catch(function (e) {
        self.saving(false);
        self.error(e && e.message ? e.message : 'Save failed.');
      });
    };

    self.submit = function () {
      self.error(''); self.successMsg('');
      if (!_validate()) return;
      self.saving(true);
      var payload = _buildPayload('SUBMITTED');
      var promise = self.isEdit() ? dtService.updateRequest(editReqId, payload)
                                  : dtService.createRequest(payload);
      promise.then(function (req) {
        return approvalService.startWorkflow(
          'DT_TRAVEL_ADVANCE', 'TRAVEL_REQUEST', req.reqId, req.reqNumber, user.userId
        );
      }).then(function () {
        self.saving(false);
        self.successMsg('Request submitted successfully.');
        if (window._dtApp) window._dtApp.navigate('myRequests');
      }).catch(function (e) {
        self.saving(false);
        self.error(e && e.message ? e.message : 'Submit failed.');
      });
    };

    self.cancel = function () {
      if (window._dtApp) window._dtApp.navigate('myRequests');
    };
  }

  return RequestFormViewModel;
});
