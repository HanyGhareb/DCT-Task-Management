/**
 * reimbService.js — Reimbursement requests CRUD.
 */
define(['services/config', 'services/api', 'services/pcService', 'mockData'],
function (config, api, pcService, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_pc_data';
  var _nextReimbId  = 10;
  var _nextReimbSeq = 4;
  var _nextLineId   = 300;

  function loadStore() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return null;
  }
  function getList() { var s = loadStore(); return s ? s.reimbursements : mockData.REIMBURSEMENTS.slice(); }
  function getLines() { var s = loadStore(); return s ? s.reimb_lines : mockData.REIMB_BUDGET_LINES.slice(); }
  function getPcList() { var s = loadStore(); return s ? s.petty_cash : mockData.PETTY_CASH.slice(); }

  function saveReimbs(list) {
    var s = loadStore() || {};
    s.reimbursements = list;
    localStorage.setItem(STORE_KEY, JSON.stringify(s));
  }

  return {

    getMyReimbursements: function (userId) {
      if (config.apiBase) return api.get('/reimbursements?userId=' + userId);
      var pcList = getPcList().filter(function(p){ return p.userId === userId; });
      var pcIds  = pcList.map(function(p){ return p.pcId; });
      var list   = getList().filter(function(r){ return pcIds.includes(r.pcId); });
      // Enrich with pcNumber
      return Promise.resolve(list.map(function(r) {
        var pc = pcList.find(function(p){ return p.pcId === r.pcId; });
        return Object.assign({}, r, { pcNumber: pc ? pc.pcNumber : '' });
      }).sort(function(a,b){ return b.reimbId - a.reimbId; }));
    },

    getAllReimbursements: function (filters) {
      if (config.apiBase) return api.get('/reimbursements/all');
      var allPc  = getPcList();
      var list   = getList().sort(function(a,b){ return b.reimbId - a.reimbId; });
      return Promise.resolve(list.map(function(r) {
        var pc  = allPc.find(function(p){ return p.pcId === r.pcId; });
        var usr = mockData.USERS.find(function(u){ return pc && u.userId === pc.userId; });
        return Object.assign({}, r, {
          pcNumber:       pc  ? pc.pcNumber       : '',
          employeeName:   usr ? usr.displayName    : '',
          employeeNumber: usr ? usr.employeeNumber : '',
          orgName:        pc  ? pc.orgName         : '',
        });
      }));
    },

    getById: function (reimbId) {
      if (config.apiBase) return api.get('/reimbursements/' + reimbId);
      var rec = getList().find(function(r){ return r.reimbId === reimbId; });
      return Promise.resolve(rec ? Object.assign({}, rec) : null);
    },

    getBudgetLines: function (reimbId) {
      if (config.apiBase) return api.get('/reimbursements/' + reimbId + '/lines');
      return Promise.resolve(getLines().filter(function(l){ return l.reimbId === reimbId; }));
    },

    create: function (data) {
      if (config.apiBase) return api.post('/reimbursements', data);
      var year = new Date().getFullYear();
      var newRec = Object.assign({}, data, {
        reimbId:     _nextReimbId++,
        reimbNumber: 'RMB-' + year + '-' + String(_nextReimbSeq++).padStart(5, '0'),
        status:      'SUBMITTED',
        submittedAt: new Date().toISOString(),
        createdAt:   new Date().toISOString(),
      });
      var s = loadStore() || { reimbursements: getList(), reimb_lines: getLines() };
      s.reimbursements.push(newRec);
      if (data.budgetLines) {
        data.budgetLines.forEach(function(l, i) {
          s.reimb_lines.push(Object.assign({}, l, { lineId: _nextLineId++, reimbId: newRec.reimbId, lineNum: i + 1 }));
        });
      }
      localStorage.setItem(STORE_KEY, JSON.stringify(s));
      return Promise.resolve(newRec);
    },

    update: function (reimbId, data) {
      if (config.apiBase) return api.put('/reimbursements/' + reimbId, data);
      var s = loadStore() || { reimbursements: getList() };
      var idx = s.reimbursements.findIndex(function(r){ return r.reimbId === reimbId; });
      if (idx !== -1) Object.assign(s.reimbursements[idx], data, { updatedAt: new Date().toISOString() });
      localStorage.setItem(STORE_KEY, JSON.stringify(s));
      return Promise.resolve(s.reimbursements[idx]);
    },
  };
});
