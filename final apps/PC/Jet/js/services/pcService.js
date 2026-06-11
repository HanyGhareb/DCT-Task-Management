/**
 * pcService.js — Petty Cash CRUD (mock + real API dual-mode).
 * All writes persist to localStorage in mock mode.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_pc_data';

  // ── In-memory store ────────────────────────────────────────────────────
  function loadStore() {
    try {
      var raw = localStorage.getItem(STORE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (e) {}
    return {
      petty_cash:       JSON.parse(JSON.stringify(mockData.PETTY_CASH)),
      budget_lines:     JSON.parse(JSON.stringify(mockData.PC_BUDGET_LINES)),
      reimbursements:   JSON.parse(JSON.stringify(mockData.REIMBURSEMENTS)),
      reimb_lines:      JSON.parse(JSON.stringify(mockData.REIMB_BUDGET_LINES)),
      clearings:        JSON.parse(JSON.stringify(mockData.CLEARINGS)),
      clear_lines:      JSON.parse(JSON.stringify(mockData.CLEAR_BUDGET_LINES)),
      gl_codes:         JSON.parse(JSON.stringify(mockData.GL_CODES)),
    };
  }

  var _store = loadStore();

  function saveStore() {
    localStorage.setItem(STORE_KEY, JSON.stringify(_store));
  }

  var _nextPcId     = Math.max.apply(null, _store.petty_cash.map(function(r){ return r.pcId; })) + 1;
  var _nextLineId   = 200;
  var _nextSeq      = 6;  // next PC number suffix

  function _fmtAmount(n) {
    return n ? n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '0.00';
  }

  // ── Public API ─────────────────────────────────────────────────────────
  return {

    // Petty Cash list for the logged-in user
    getMyPettyCash: function (userId) {
      if (config.apiBase) return api.get('/pc?userId=' + userId);
      return Promise.resolve(
        _store.petty_cash
          .filter(function (r) { return r.userId === userId; })
          .sort(function (a, b) { return b.pcId - a.pcId; })
      );
    },

    // All petty cash (admin view) — legacy full-list call
    getAllPettyCash: function (filters) {
      if (config.apiBase) {
        return api.get('/pc/all?limit=200').then(function (d) {
          return Array.isArray(d) ? d : (d.items || []);   // shim: tolerate both shapes
        });
      }
      var list = _store.petty_cash.slice().sort(function (a, b) { return b.pcId - a.pcId; });
      if (filters) {
        if (filters.status)  list = list.filter(function (r) { return r.status === filters.status; });
        if (filters.pcType)  list = list.filter(function (r) { return r.pcType === filters.pcType; });
        if (filters.orgName) list = list.filter(function (r) { return r.orgName.includes(filters.orgName); });
      }
      return Promise.resolve(list);
    },

    /**
     * Phase 3 server-side pagination over /pc/all.
     * opts: { limit, offset, search, status }
     * Resolves { items, total, limit, offset } — shimmed if the pre-Phase-3
     * handler (raw array) is still deployed.
     */
    getAllPage: function (opts) {
      opts = opts || {};
      var q = '?limit=' + (opts.limit || 50) + '&offset=' + (opts.offset || 0);
      if (opts.search) q += '&search=' + encodeURIComponent(opts.search);
      if (opts.status) q += '&status=' + encodeURIComponent(opts.status);
      return api.get('/pc/all' + q).then(function (d) {
        if (Array.isArray(d)) return { items: d, total: d.length, limit: d.length, offset: 0 };
        return d;
      });
    },

    /* Phase 3: PC dashboard chart series (GET /pc/charts) */
    getCharts: function () {
      return api.get('/pc/charts');
    },

    // Single record
    getById: function (pcId) {
      if (config.apiBase) return api.get('/pc/' + pcId);
      var rec = _store.petty_cash.find(function (r) { return r.pcId === pcId; });
      return Promise.resolve(rec ? Object.assign({}, rec) : null);
    },

    // Budget lines for a PC
    getBudgetLines: function (pcId) {
      if (config.apiBase) return api.get('/pc/' + pcId + '/lines');
      return Promise.resolve(_store.budget_lines.filter(function (l) { return l.pcId === pcId; }));
    },

    // Submit new request
    create: function (data) {
      if (config.apiBase) return api.post('/pc', data);
      var year = new Date().getFullYear();
      var newRec = Object.assign({}, data, {
        pcId:              _nextPcId++,
        pcNumber:          'PC-' + year + '-' + String(_nextSeq++).padStart(5, '0'),
        status:            'SUBMITTED',
        submittedAt:       new Date().toISOString(),
        totalReimbursed:   0,
        clearedAmount:     0,
        refundedAmount:    0,
        currentFloatBalance: data.amount,
        createdAt:         new Date().toISOString(),
      });
      _store.petty_cash.push(newRec);
      // Save budget lines
      if (data.budgetLines) {
        data.budgetLines.forEach(function (l, i) {
          _store.budget_lines.push(Object.assign({}, l, { lineId: _nextLineId++, pcId: newRec.pcId, lineNum: i + 1 }));
        });
      }
      saveStore();
      return Promise.resolve(newRec);
    },

    // Update (draft save)
    update: function (pcId, data) {
      if (config.apiBase) return api.put('/pc/' + pcId, data);
      var idx = _store.petty_cash.findIndex(function (r) { return r.pcId === pcId; });
      if (idx === -1) return Promise.reject({ message: 'Not found' });
      Object.assign(_store.petty_cash[idx], data, { updatedAt: new Date().toISOString() });
      saveStore();
      return Promise.resolve(_store.petty_cash[idx]);
    },

    // Disburse (admin action — sets status to ACTIVE)
    disburse: function (pcId, adminUserId) {
      if (config.apiBase) return api.post('/pc/' + pcId + '/disburse', { adminUserId: adminUserId });
      var idx = _store.petty_cash.findIndex(function (r) { return r.pcId === pcId; });
      if (idx === -1) return Promise.reject({ message: 'Not found' });
      Object.assign(_store.petty_cash[idx], {
        status:        'ACTIVE',
        disbursedDate: new Date().toISOString().split('T')[0],
        disbursedBy:   adminUserId,
      });
      saveStore();
      return Promise.resolve(_store.petty_cash[idx]);
    },

    // GL Codes
    getGlCodes: function () {
      if (config.apiBase) return api.get('/gl-codes');
      return Promise.resolve(_store.gl_codes.slice());
    },

    saveGlCode: function (data) {
      if (config.apiBase) return data.ccId ? api.put('/gl-codes/' + data.ccId, data) : api.post('/gl-codes', data);
      if (data.ccId) {
        var idx = _store.gl_codes.findIndex(function (r) { return r.ccId === data.ccId; });
        if (idx !== -1) Object.assign(_store.gl_codes[idx], data);
      } else {
        var newId = Math.max.apply(null, _store.gl_codes.map(function(r){ return r.ccId; })) + 1;
        _store.gl_codes.push(Object.assign({ ccId: newId }, data));
      }
      saveStore();
      return Promise.resolve(true);
    },

    deleteGlCode: function (ccId) {
      if (config.apiBase) return api.delete('/gl-codes/' + ccId);
      _store.gl_codes = _store.gl_codes.filter(function (r) { return r.ccId !== ccId; });
      saveStore();
      return Promise.resolve(true);
    },

    // Summary stats for dashboard
    getDashboardStats: function (userId) {
      if (config.apiBase) return api.get('/pc/stats?userId=' + userId);
      var myPc  = _store.petty_cash.filter(function (r) { return r.userId === userId; });
      var active = myPc.filter(function (r) { return r.status === 'ACTIVE'; });
      var pending = _store.petty_cash.filter(function (r) { return r.status === 'PENDING_APPROVAL'; });
      var reimbPending = _store.reimbursements.filter(function (r) { return r.status === 'PENDING_APPROVAL'; });
      var totalFloat = active.reduce(function (s, r) { return s + (r.currentFloatBalance || 0); }, 0);
      return Promise.resolve({
        activePc:          active.length,
        pendingPc:         myPc.filter(function (r) { return r.status === 'PENDING_APPROVAL'; }).length,
        totalFloat:        totalFloat,
        totalFloatFormatted: _fmtAmount(totalFloat),
        reimbPending:      _store.reimbursements.filter(function (r) {
          var pc = _store.petty_cash.find(function (p) { return p.pcId === r.pcId; });
          return pc && pc.userId === userId && r.status === 'PENDING_APPROVAL';
        }).length,
        activeRecord:      active[0] || null,
        // Admin stats
        orgActivePc:       pending.length,
        orgPendingApprovals: pending.length + reimbPending.length,
      });
    },

    // Recent activity for dashboard
    getRecentActivity: function (userId) {
      if (config.apiBase) return api.get('/pc/activity?userId=' + userId);
      var actions = mockData.APPROVAL_ACTIONS
        .filter(function (a) {
          var inst = mockData.APPROVAL_INSTANCES.find(function (i) { return i.instanceId === a.instanceId; });
          return inst && inst.submittedBy === userId;
        })
        .sort(function (a, b) { return b.actionId - a.actionId; })
        .slice(0, 8);
      return Promise.resolve(actions.map(function (a) {
        var inst = mockData.APPROVAL_INSTANCES.find(function (i) { return i.instanceId === a.instanceId; });
        return {
          requestRef:   inst ? inst.sourceRecordRef : '',
          requestType:  inst ? inst.sourceModule : '',
          action:       a.action,
          comments:     a.comments,
          actionDate:   a.actionedAt,
          actionedBy:   a.actionedByName,
        };
      }));
    },

    getProjectBudget: function () {
      return Promise.resolve(mockData.PROJECT_BUDGET.slice());
    },

    reset: function () {
      localStorage.removeItem(STORE_KEY);
      _store = loadStore();
    },

    // Expose formatting helper
    fmtAmount: _fmtAmount,
  };
});
