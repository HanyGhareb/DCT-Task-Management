/**
 * clearService.js — Clearing request CRUD.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_pc_data';
  var _nextId  = 10;
  var _nextSeq = 2;
  var _nextLineId = 400;

  function loadStore() { try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e){} return null; }
  function getClearings() { var s = loadStore(); return s ? s.clearings : mockData.CLEARINGS.slice(); }
  function getClearLines() { var s = loadStore(); return s ? s.clear_lines : mockData.CLEAR_BUDGET_LINES.slice(); }
  function getPcList()   { var s = loadStore(); return s ? s.petty_cash : mockData.PETTY_CASH.slice(); }

  return {

    getMyClearings: function (userId) {
      if (config.apiBase) return api.get('/clearings?userId=' + userId);
      var pcList = getPcList().filter(function(p){ return p.userId === userId; });
      var pcIds  = pcList.map(function(p){ return p.pcId; });
      var list   = getClearings().filter(function(r){ return pcIds.includes(r.pcId); });
      return Promise.resolve(list.map(function(r) {
        var pc = pcList.find(function(p){ return p.pcId === r.pcId; });
        return Object.assign({}, r, { pcNumber: pc ? pc.pcNumber : '' });
      }).sort(function(a,b){ return b.clearingId - a.clearingId; }));
    },

    getAllClearings: function () {
      if (config.apiBase) return api.get('/clearings/all');
      var allPc = getPcList();
      return Promise.resolve(getClearings().map(function(r) {
        var pc  = allPc.find(function(p){ return p.pcId === r.pcId; });
        var usr = mockData.USERS.find(function(u){ return pc && u.userId === pc.userId; });
        return Object.assign({}, r, {
          pcNumber:       pc  ? pc.pcNumber     : '',
          pcType:         pc  ? pc.pcType       : '',
          advanceAmount:  pc  ? pc.amount       : 0,
          employeeName:   usr ? usr.displayName  : '',
          employeeNumber: usr ? usr.employeeNumber: '',
        });
      }).sort(function(a,b){ return b.clearingId - a.clearingId; }));
    },

    getById: function (clearingId) {
      if (config.apiBase) return api.get('/clearings/' + clearingId);
      var rec = getClearings().find(function(r){ return r.clearingId === clearingId; });
      return Promise.resolve(rec ? Object.assign({}, rec) : null);
    },

    getBudgetLines: function (clearingId) {
      if (config.apiBase) return api.get('/clearings/' + clearingId + '/lines');
      return Promise.resolve(getClearLines().filter(function(l){ return l.clearingId === clearingId; }));
    },

    create: function (data) {
      if (config.apiBase) return api.post('/clearings', data);
      var year = new Date().getFullYear();
      var newRec = Object.assign({}, data, {
        clearingId:     _nextId++,
        clearingNumber: 'CLR-' + year + '-' + String(_nextSeq++).padStart(5, '0'),
        status:         'SUBMITTED',
        submittedAt:    new Date().toISOString(),
        createdAt:      new Date().toISOString(),
      });
      var s = loadStore() || { clearings: getClearings(), clear_lines: getClearLines() };
      s.clearings.push(newRec);
      if (data.budgetLines) {
        data.budgetLines.forEach(function(l, i) {
          s.clear_lines.push(Object.assign({}, l, { lineId: _nextLineId++, clearingId: newRec.clearingId, lineNum: i + 1 }));
        });
      }
      localStorage.setItem(STORE_KEY, JSON.stringify(s));
      return Promise.resolve(newRec);
    },

    update: function (clearingId, data) {
      if (config.apiBase) return api.put('/clearings/' + clearingId, data);
      var s = loadStore() || { clearings: getClearings() };
      var idx = s.clearings.findIndex(function(r){ return r.clearingId === clearingId; });
      if (idx !== -1) Object.assign(s.clearings[idx], data, { updatedAt: new Date().toISOString() });
      localStorage.setItem(STORE_KEY, JSON.stringify(s));
      return Promise.resolve(s.clearings[idx]);
    },

    // On final approval: close the parent petty cash
    closeParentPc: function (pcId) {
      var s = loadStore() || {};
      if (!s.petty_cash) s.petty_cash = getPcList();
      var idx = s.petty_cash.findIndex(function(r){ return r.pcId === pcId; });
      if (idx !== -1) {
        Object.assign(s.petty_cash[idx], { status: 'CLOSED', closedDate: new Date().toISOString().split('T')[0] });
      }
      localStorage.setItem(STORE_KEY, JSON.stringify(s));
      return Promise.resolve(true);
    },
  };
});
