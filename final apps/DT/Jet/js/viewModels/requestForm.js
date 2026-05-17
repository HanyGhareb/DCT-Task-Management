define(['knockout', 'services/authService', 'services/dtService', 'services/approvalService', 'mockData'],
function (ko, authService, dtService, approvalService, mockData) {
  'use strict';

  function RequestFormViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.user = user;

    // Edit mode if state has reqId
    var editReqId = window._dtApp && window._dtApp.getState().reqId;
    self.isEdit   = ko.observable(!!editReqId);
    self.reqNumber = ko.observable('');

    // Form fields
    self.travelPurpose     = ko.observable('');
    self.tripType          = ko.observable('OFFICIAL');
    self.advanceRequested  = ko.observable('Y');
    self.notes             = ko.observable('');
    self.saving            = ko.observable(false);
    self.error             = ko.observable('');
    self.successMsg        = ko.observable('');

    // Destinations
    self.destinations = ko.observableArray([]);
    self.countries    = ko.observableArray([]);

    // Computed totals
    self.totalEstimatedPerDiem = ko.computed(function () {
      return self.destinations().reduce(function (s, d) { return s + (parseFloat(d.amount()) || 0); }, 0);
    });
    self.estimatedAdvance = ko.computed(function () {
      return self.advanceRequested() === 'Y' ? self.totalEstimatedPerDiem() : 0;
    });

    // Load countries
    dtService.getCountries().then(function (list) { self.countries(list); });

    // Load for edit
    if (editReqId) {
      dtService.getRequest(editReqId).then(function (req) {
        self.reqNumber(req.reqNumber);
        self.travelPurpose(req.travelPurpose);
        self.tripType(req.tripType);
        self.advanceRequested(req.advanceRequested);
        self.notes(req.notes || '');
        var dests = (req.destinations || []).map(function (d) { return _makeDestRow(d); });
        self.destinations(dests);
      });
    } else {
      self.destinations.push(_makeDestRow(null));
    }

    function _makeDestRow(d) {
      var row = {
        destId:      d ? d.destId : null,
        countryCode: ko.observable(d ? d.countryCode : ''),
        countryName: ko.observable(d ? d.countryName : ''),
        fromDate:    ko.observable(d ? d.fromDate : ''),
        toDate:      ko.observable(d ? d.toDate : ''),
        dailyRateAed: ko.observable(d ? d.dailyRateAed : 0),
        days:        ko.observable(d ? d.days : 0),
        amount:      ko.observable(d ? d.amount : 0),
      };
      // Auto-calculate days & amount when dates or country change
      function _recalc() {
        var from = row.fromDate(); var to = row.toDate();
        if (from && to) {
          var d1 = new Date(from); var d2 = new Date(to);
          var days = Math.max(0, Math.round((d2 - d1) / 86400000) + 1);
          row.days(days);
          row.amount(days * (parseFloat(row.dailyRateAed()) || 0));
        }
      }
      // Load rate when country selected
      row.countryCode.subscribe(function (code) {
        if (!code) return;
        var c = self.countries().find(function(x){ return x.countryCode === code; });
        if (c) row.countryName(c.countryName);
        dtService.getPerDiemRate(code, user.gradeCode, row.fromDate() || new Date().toISOString().slice(0,10)).then(function (rate) {
          row.dailyRateAed(rate ? rate.dailyRateAed : 0);
          _recalc();
        });
      });
      row.fromDate.subscribe(_recalc);
      row.toDate.subscribe(_recalc);
      return row;
    }

    self.addDest = function () { self.destinations.push(_makeDestRow(null)); };
    self.removeDest = function (row) { if (self.destinations().length > 1) self.destinations.remove(row); };

    function _buildPayload(status) {
      var dests = self.destinations().map(function (d, i) {
        return {
          seqNum:      i + 1,
          countryCode: d.countryCode(),
          countryName: d.countryName(),
          fromDate:    d.fromDate(),
          toDate:      d.toDate(),
          dailyRateAed: parseFloat(d.dailyRateAed()) || 0,
          days:        parseInt(d.days()) || 0,
          amount:      parseFloat(d.amount()) || 0,
        };
      });
      var totalDays  = dests.reduce(function(s,d){ return s + d.days; }, 0);
      var totalPD    = dests.reduce(function(s,d){ return s + d.amount; }, 0);
      return {
        userId:             user.userId,
        employeeName:       user.displayName,
        employeeNumber:     user.employeeNumber,
        gradeCode:          user.gradeCode,
        orgName:            user.orgName,
        travelPurpose:      self.travelPurpose(),
        tripType:           self.tripType(),
        advanceRequested:   self.advanceRequested(),
        advanceAmount:      self.advanceRequested() === 'Y' ? totalPD : 0,
        departureDate:      dests[0] ? dests[0].fromDate : '',
        returnDate:         dests[dests.length - 1] ? dests[dests.length - 1].toDate : '',
        estimatedDays:      totalDays,
        estimatedPerDiem:   totalPD,
        notes:              self.notes(),
        status:             status,
        destinations:       dests,
      };
    }

    function _validate() {
      if (!self.travelPurpose().trim()) { self.error('Travel purpose is required.'); return false; }
      var dests = self.destinations();
      for (var i = 0; i < dests.length; i++) {
        if (!dests[i].countryCode()) { self.error('Please select a country for destination ' + (i+1) + '.'); return false; }
        if (!dests[i].fromDate() || !dests[i].toDate()) { self.error('Please set dates for destination ' + (i+1) + '.'); return false; }
      }
      return true;
    }

    self.saveDraft = function () {
      self.error(''); self.successMsg('');
      if (!self.travelPurpose().trim()) { self.error('Travel purpose is required.'); return; }
      self.saving(true);
      var payload = _buildPayload('DRAFT');
      var promise = self.isEdit() ? dtService.updateRequest(editReqId, payload) : dtService.createRequest(payload);
      promise.then(function () {
        self.saving(false);
        self.successMsg('Draft saved successfully.');
        if (window._dtApp) window._dtApp.navigate('myRequests');
      }).catch(function (e) { self.saving(false); self.error(e && e.message ? e.message : 'Save failed.'); });
    };

    self.submit = function () {
      self.error(''); self.successMsg('');
      if (!_validate()) return;
      self.saving(true);
      var payload = _buildPayload('SUBMITTED');
      var promise = self.isEdit() ? dtService.updateRequest(editReqId, payload) : dtService.createRequest(payload);
      promise.then(function (req) {
        // Start approval workflow
        return approvalService.startWorkflow('DT_TRAVEL_ADVANCE', 'TRAVEL_REQUEST', req.reqId, req.reqNumber, user.userId);
      }).then(function () {
        self.saving(false);
        self.successMsg('Request submitted successfully.');
        if (window._dtApp) window._dtApp.navigate('myRequests');
      }).catch(function (e) { self.saving(false); self.error(e && e.message ? e.message : 'Submit failed.'); });
    };

    self.cancel = function () {
      if (window._dtApp) window._dtApp.navigate('myRequests');
    };
  }

  return RequestFormViewModel;
});
