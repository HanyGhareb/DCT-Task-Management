/**
 * dtService.js — Travel request + destination CRUD for Duty Travel module.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_data';
  var _nextReqId  = 10;
  var _nextDestId = 10;

  function loadStore() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return {
      requests:     JSON.parse(JSON.stringify(mockData.TRAVEL_REQUESTS)),
      destinations: JSON.parse(JSON.stringify(mockData.TRAVEL_DESTINATIONS)),
    };
  }
  function saveStore(s) { localStorage.setItem(STORE_KEY, JSON.stringify(s)); }

  function fmt(n) { return parseFloat(n || 0).toFixed(2); }
  function _statusLabel(s) {
    var map = { DRAFT:'Draft', SUBMITTED:'Submitted', APPROVED:'Approved',
                ADVANCE_PAID:'Advance Paid', TRAVELLED:'Travelled',
                SETTLED:'Settled', CLOSED:'Closed', REJECTED:'Rejected',
                RETURNED:'Returned', CANCELLED:'Cancelled' };
    return map[s] || s;
  }
  function _statusClass(s) {
    var map = { DRAFT:'badge--draft', SUBMITTED:'badge--submitted', APPROVED:'badge--approved',
                ADVANCE_PAID:'badge--advance_paid', TRAVELLED:'badge--travelled',
                SETTLED:'badge--settled', CLOSED:'badge--closed', REJECTED:'badge--rejected',
                RETURNED:'badge--returned', CANCELLED:'badge--cancelled' };
    return 'badge ' + (map[s] || 'badge--idle');
  }

  // Lookup per diem rate: match countryCode + gradeCode on given date
  function getPerDiemRate(countryCode, gradeCode, travelDate) {
    if (config.apiBase) return api.get('/perdiem-rates/lookup?country=' + countryCode + '&grade=' + gradeCode + '&date=' + travelDate);
    var date = travelDate || new Date().toISOString().slice(0,10);
    var rate = mockData.PER_DIEM_RATES.find(function(r) {
      return r.countryCode === countryCode && r.gradeCode === gradeCode &&
             r.isActive === 'Y' && r.effectiveFrom <= date && (!r.effectiveTo || r.effectiveTo >= date);
    });
    return Promise.resolve(rate || null);
  }

  return {

    getPerDiemRate: getPerDiemRate,

    getCountries: function () {
      if (config.apiBase) return api.get('/countries/').then(function(d){ return d.items || []; });
      return Promise.resolve(mockData.COUNTRIES.filter(function(c){ return c.isActive === 'Y' && c.tier !== 'HOME'; }));
    },

    getDashboardStats: function (userId) {
      if (config.apiBase) return api.get('/dashboard/');
      var s = loadStore();
      var mine = s.requests.filter(function(r){ return r.userId === userId; });
      var active = mine.filter(function(r){ return ['SUBMITTED','APPROVED','ADVANCE_PAID','TRAVELLED'].includes(r.status); });
      var draft  = mine.filter(function(r){ return r.status === 'DRAFT'; });
      var needSettle = mine.filter(function(r){ return r.status === 'ADVANCE_PAID' || r.status === 'TRAVELLED'; });
      return Promise.resolve({
        activeRequests:    active.length,
        draftRequests:     draft.length,
        needSettlement:    needSettle.length,
        totalAdvance:      mine.filter(function(r){ return r.status === 'ADVANCE_PAID'; }).reduce(function(a,r){ return a + (r.advanceAmount||0); }, 0),
        recentRequests:    mine.slice(-3).reverse().map(function(r){ return Object.assign({}, r, { statusLabel: _statusLabel(r.status), statusClass: _statusClass(r.status) }); }),
      });
    },

    getMyRequests: function (userId) {
      if (config.apiBase) return api.get('/requests/?mine=Y').then(function(d){ return d.items || []; });
      var s = loadStore();
      var list = s.requests.filter(function(r){ return r.userId === userId; });
      return Promise.resolve(list.map(function(r){ return Object.assign({}, r, { statusLabel: _statusLabel(r.status), statusClass: _statusClass(r.status) }); }).sort(function(a,b){ return b.reqId - a.reqId; }));
    },

    getAllRequests: function (filters) {
      if (config.apiBase) return api.get('/requests/').then(function(d){ return d.items || []; });
      var s = loadStore();
      var list = s.requests.slice();
      if (filters && filters.status) list = list.filter(function(r){ return r.status === filters.status; });
      if (filters && filters.userId) list = list.filter(function(r){ return r.userId === filters.userId; });
      return Promise.resolve(list.map(function(r){ return Object.assign({}, r, { statusLabel: _statusLabel(r.status), statusClass: _statusClass(r.status) }); }).sort(function(a,b){ return b.reqId - a.reqId; }));
    },

    getRequest: function (reqId) {
      if (config.apiBase) return api.get('/requests/' + reqId);
      var s = loadStore();
      var r = s.requests.find(function(x){ return x.reqId === reqId; });
      if (!r) return Promise.reject({ message: 'Request not found' });
      var dests = s.destinations.filter(function(d){ return d.reqId === reqId; });
      return Promise.resolve(Object.assign({}, r, {
        destinations: dests,
        statusLabel: _statusLabel(r.status),
        statusClass: _statusClass(r.status),
      }));
    },

    getDestinations: function (reqId) {
      if (config.apiBase) return api.get('/requests/' + reqId + '/destinations').then(function(d){ return d.items || []; });
      var s = loadStore();
      return Promise.resolve(s.destinations.filter(function(d){ return d.reqId === reqId; }));
    },

    createRequest: function (payload) {
      if (config.apiBase) {
        if (payload.status === 'SUBMITTED') {
          // Create as DRAFT first, then use the /submit endpoint which starts the
          // approval workflow server-side.
          var draftPayload = Object.assign({}, payload, { status: 'DRAFT' });
          return api.post('/requests/', draftPayload).then(function(req) {
            return api.post('/requests/' + req.reqId + '/submit');
          });
        }
        return api.post('/requests/', payload);
      }
      var s = loadStore();
      var now = new Date().toISOString();
      var year = new Date().getFullYear();
      var seq  = String(s.requests.length + 1).padStart(5, '0');
      var req = Object.assign({}, payload, {
        reqId:     _nextReqId++,
        reqNumber: 'DT-' + year + '-' + seq,
        status:    payload.status || 'DRAFT',
        createdAt: now,
      });
      s.requests.push(req);
      // Save destinations
      var dests = payload.destinations || [];
      dests.forEach(function(d) {
        var dest = Object.assign({}, d, { destId: _nextDestId++, reqId: req.reqId });
        s.destinations.push(dest);
      });
      saveStore(s);
      return Promise.resolve(req);
    },

    updateRequest: function (reqId, payload) {
      if (config.apiBase) {
        if (payload.status === 'SUBMITTED') {
          // Save edits on the DRAFT, then submit through the dedicated endpoint.
          return api.put('/requests/' + reqId, Object.assign({}, payload, { status: 'DRAFT' }))
            .then(function() { return api.post('/requests/' + reqId + '/submit'); });
        }
        return api.put('/requests/' + reqId, payload);
      }
      var s = loadStore();
      var idx = s.requests.findIndex(function(r){ return r.reqId === reqId; });
      if (idx === -1) return Promise.reject({ message: 'Request not found' });
      s.requests[idx] = Object.assign({}, s.requests[idx], payload, { updatedAt: new Date().toISOString() });
      // Replace destinations if provided
      if (payload.destinations) {
        s.destinations = s.destinations.filter(function(d){ return d.reqId !== reqId; });
        payload.destinations.forEach(function(d) {
          s.destinations.push(Object.assign({}, d, { destId: _nextDestId++, reqId: reqId }));
        });
      }
      saveStore(s);
      return Promise.resolve(s.requests[idx]);
    },

    submitRequest: function (reqId) {
      if (config.apiBase) return api.post('/requests/' + reqId + '/submit');
      return this.updateRequest(reqId, { status: 'SUBMITTED', submittedAt: new Date().toISOString() });
    },

    cancelRequest: function (reqId) {
      if (config.apiBase) return api.post('/requests/' + reqId + '/cancel');
      return this.updateRequest(reqId, { status: 'CANCELLED' });
    },

    markAdvancePaid: function (reqId, paidBy) {
      if (config.apiBase) return api.post('/requests/' + reqId + '/pay-advance');
      return this.updateRequest(reqId, { status: 'ADVANCE_PAID', advancePaidAt: new Date().toISOString(), advancePaidBy: paidBy });
    },

    markTravelled: function (reqId, returnedAt) {
      if (config.apiBase) return api.post('/requests/' + reqId + '/mark-travelled');
      return this.updateRequest(reqId, { status: 'TRAVELLED', returnedAt: returnedAt || new Date().toISOString().slice(0,10) });
    },

    // Pending disbursements: APPROVED with advanceRequested = Y
    getDisbursementQueue: function () {
      if (config.apiBase) return api.get('/requests/?advancePending=Y').then(function(d){ return d.items || []; });
      var s = loadStore();
      var list = s.requests.filter(function(r){ return r.status === 'APPROVED' && r.advanceRequested === 'Y' && !r.advancePaidAt; });
      return Promise.resolve(list.map(function(r){ return Object.assign({}, r, { statusLabel: _statusLabel(r.status), statusClass: _statusClass(r.status) }); }));
    },

    statusLabel: _statusLabel,
    statusClass: _statusClass,
    fmt: fmt,
  };
});
