/**
 * settlementService.js — Travel settlement CRUD for Duty Travel module.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY     = 'ifinance_dt_data';
  var SETTLE_KEY    = 'ifinance_dt_settlements';
  var _nextSettleId = 10;
  var _nextLineId   = 10;

  function loadDtStore() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return { requests: JSON.parse(JSON.stringify(mockData.TRAVEL_REQUESTS)), destinations: JSON.parse(JSON.stringify(mockData.TRAVEL_DESTINATIONS)) };
  }

  function loadStore() {
    try { var r = localStorage.getItem(SETTLE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return {
      settlements: JSON.parse(JSON.stringify(mockData.SETTLEMENTS)),
      lines:       JSON.parse(JSON.stringify(mockData.SETTLEMENT_LINES)),
    };
  }
  function saveStore(s) { localStorage.setItem(SETTLE_KEY, JSON.stringify(s)); }

  function _statusLabel(s) {
    var map = { DRAFT:'Draft', SUBMITTED:'Submitted', APPROVED:'Approved', CLOSED:'Closed', REJECTED:'Rejected' };
    return map[s] || s;
  }
  function _statusClass(s) {
    var map = { DRAFT:'badge--draft', SUBMITTED:'badge--submitted', APPROVED:'badge--approved', CLOSED:'badge--closed', REJECTED:'badge--rejected' };
    return 'badge ' + (map[s] || 'badge--idle');
  }

  return {

    getMySettlements: function (userId) {
      if (config.apiBase) return api.get('/settlements/?mine=Y').then(function(d){ return d.items || []; });
      var dtStore = loadDtStore();
      var myReqIds = dtStore.requests.filter(function(r){ return r.userId === userId; }).map(function(r){ return r.reqId; });
      var s = loadStore();
      var list = s.settlements.filter(function(x){ return myReqIds.includes(x.reqId); });
      return Promise.resolve(list.map(function(x){ return Object.assign({}, x, { statusLabel: _statusLabel(x.status), statusClass: _statusClass(x.status) }); }).sort(function(a,b){ return b.settleId - a.settleId; }));
    },

    getAllSettlements: function (filters) {
      if (config.apiBase) return api.get('/settlements/').then(function(d){ return d.items || []; });
      var s = loadStore();
      var list = s.settlements.slice();
      if (filters && filters.status) list = list.filter(function(x){ return x.status === filters.status; });
      return Promise.resolve(list.map(function(x){ return Object.assign({}, x, { statusLabel: _statusLabel(x.status), statusClass: _statusClass(x.status) }); }).sort(function(a,b){ return b.settleId - a.settleId; }));
    },

    getSettlement: function (settleId) {
      if (config.apiBase) return api.get('/settlements/' + settleId);
      var s = loadStore();
      var rec = s.settlements.find(function(x){ return x.settleId === settleId; });
      if (!rec) return Promise.reject({ message: 'Settlement not found' });
      var lines = s.lines.filter(function(l){ return l.settleId === settleId; });
      return Promise.resolve(Object.assign({}, rec, { lines: lines, statusLabel: _statusLabel(rec.status), statusClass: _statusClass(rec.status) }));
    },

    getSettlementForRequest: function (reqId) {
      if (config.apiBase) return api.get('/settlements/?reqId=' + reqId).then(function(d){ return d.found ? d : null; });
      var s = loadStore();
      var rec = s.settlements.find(function(x){ return x.reqId === reqId; });
      return Promise.resolve(rec ? Object.assign({}, rec, { statusLabel: _statusLabel(rec.status), statusClass: _statusClass(rec.status) }) : null);
    },

    createSettlement: function (payload) {
      if (config.apiBase) return api.post('/settlements/', payload);
      var s = loadStore();
      var now = new Date().toISOString();
      var year = new Date().getFullYear();
      var seq  = String(s.settlements.length + 1).padStart(5, '0');
      var rec = Object.assign({}, payload, {
        settleId:     _nextSettleId++,
        settleNumber: 'DTS-' + year + '-' + seq,
        status:       payload.status || 'DRAFT',
        createdAt:    now,
      });
      s.settlements.push(rec);
      var lines = payload.lines || [];
      lines.forEach(function(l) {
        s.lines.push(Object.assign({}, l, { lineId: _nextLineId++, settleId: rec.settleId }));
      });
      saveStore(s);
      return Promise.resolve(rec);
    },

    updateSettlement: function (settleId, payload) {
      if (config.apiBase) return api.put('/settlements/' + settleId, payload);
      var s = loadStore();
      var idx = s.settlements.findIndex(function(x){ return x.settleId === settleId; });
      if (idx === -1) return Promise.reject({ message: 'Settlement not found' });
      s.settlements[idx] = Object.assign({}, s.settlements[idx], payload, { updatedAt: new Date().toISOString() });
      if (payload.lines) {
        s.lines = s.lines.filter(function(l){ return l.settleId !== settleId; });
        payload.lines.forEach(function(l) {
          s.lines.push(Object.assign({}, l, { lineId: _nextLineId++, settleId: settleId }));
        });
      }
      saveStore(s);
      return Promise.resolve(s.settlements[idx]);
    },

    submitSettlement: function (settleId) {
      if (config.apiBase) return api.post('/settlements/' + settleId + '/submit');
      return this.updateSettlement(settleId, { status: 'SUBMITTED', submittedAt: new Date().toISOString() });
    },

    closeSettlement: function (settleId, closedBy) {
      if (config.apiBase) return api.post('/settlements/' + settleId + '/close');
      var that = this;
      return that.updateSettlement(settleId, { status: 'CLOSED', closedAt: new Date().toISOString() }).then(function(rec) {
        // Mark source travel request as CLOSED
        var dtStore = loadDtStore();
        var rIdx = dtStore.requests.findIndex(function(r){ return r.reqId === rec.reqId; });
        if (rIdx !== -1) {
          dtStore.requests[rIdx].status = 'CLOSED';
          dtStore.requests[rIdx].closedAt = new Date().toISOString();
          localStorage.setItem(STORE_KEY, JSON.stringify(dtStore));
        }
        return rec;
      });
    },

    // Pending closure: settlements with status APPROVED
    getClosureQueue: function () {
      if (config.apiBase) return api.get('/settlements/?status=APPROVED').then(function(d){ return d.items || []; });
      var s = loadStore();
      var list = s.settlements.filter(function(x){ return x.status === 'APPROVED'; });
      return Promise.resolve(list.map(function(x){ return Object.assign({}, x, { statusLabel: _statusLabel(x.status), statusClass: _statusClass(x.status) }); }));
    },

    statusLabel: _statusLabel,
    statusClass: _statusClass,
  };
});
