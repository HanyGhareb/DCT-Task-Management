/**
 * approvalService.js — Approval workflow for Duty Travel module.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY     = 'ifinance_dt_approvals';
  var _nextActionId = 20;

  function loadStore() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return {
      instances: JSON.parse(JSON.stringify(mockData.APPROVAL_INSTANCES)),
      actions:   JSON.parse(JSON.stringify(mockData.APPROVAL_ACTIONS)),
    };
  }
  function saveStore(s) { localStorage.setItem(STORE_KEY, JSON.stringify(s)); }

  function _getAmount(inst) {
    // Read from dt data stores
    var dtRaw = null; var stRaw = null;
    try { dtRaw = localStorage.getItem('ifinance_dt_data'); } catch(e) {}
    try { stRaw = localStorage.getItem('ifinance_dt_settlements'); } catch(e) {}
    var requests     = dtRaw ? JSON.parse(dtRaw).requests     : mockData.TRAVEL_REQUESTS;
    var settlements  = stRaw ? JSON.parse(stRaw).settlements  : mockData.SETTLEMENTS;

    if (inst.sourceModule === 'TRAVEL_REQUEST') {
      var req = requests.find(function(r){ return r.reqId === inst.sourceRecordId; });
      return req ? (req.advanceAmount || req.estimatedPerDiem || 0) : null;
    }
    if (inst.sourceModule === 'SETTLEMENT') {
      var set = settlements.find(function(x){ return x.settleId === inst.sourceRecordId; });
      return set ? set.totalSettlement : null;
    }
    return null;
  }

  return {

    getPendingForUser: function (user) {
      if (config.apiBase) return api.get('/approvals/pending').then(function(d){ return d.items || []; });
      var s = loadStore();
      var pending = s.instances.filter(function(i){ return i.overallStatus === 'PENDING'; });
      return Promise.resolve(pending.filter(function(inst) {
        var steps   = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId; });
        var curStep = steps.find(function(st){ return st.stepSeq === inst.currentStepSeq; });
        if (!curStep) return false;
        var userRoles = user ? user.roles || [] : [];
        return userRoles.includes(curStep.requiredRole) || userRoles.includes('SYS_ADMIN');
      }).map(function(inst) {
        var steps   = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId; });
        var curStep = steps.find(function(st){ return st.stepSeq === inst.currentStepSeq; });
        var submitter = mockData.USERS.find(function(u){ return u.userId === inst.submittedBy; });
        return {
          instanceId:    inst.instanceId,
          requestRef:    inst.sourceRecordRef,
          requestType:   inst.sourceModule,
          submittedBy:   submitter ? submitter.displayName : '—',
          submittedAt:   inst.submittedAt,
          currentStep:   curStep ? curStep.stepName : '—',
          amount:        _getAmount(inst),
          overallStatus: inst.overallStatus,
          sourceRecordId: inst.sourceRecordId,
        };
      }));
    },

    getPendingCountForUser: function (user) {
      var s = loadStore();
      var pending = s.instances.filter(function(i){ return i.overallStatus === 'PENDING'; });
      return pending.filter(function(inst) {
        var steps   = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId; });
        var curStep = steps.find(function(st){ return st.stepSeq === inst.currentStepSeq; });
        if (!curStep) return false;
        var userRoles = user ? user.roles || [] : [];
        return userRoles.includes(curStep.requiredRole) || userRoles.includes('SYS_ADMIN');
      }).length;
    },

    getHistoryForRecord: function (sourceRecordId, sourceModule) {
      var s = loadStore();
      var inst = s.instances.find(function(i){ return i.sourceRecordId === sourceRecordId && i.sourceModule === sourceModule; });
      if (!inst) return Promise.resolve([]);
      var actions = s.actions.filter(function(a){ return a.instanceId === inst.instanceId && a.action !== 'PENDING'; });
      return Promise.resolve(actions.sort(function(a,b){ return a.actionId - b.actionId; }));
    },

    submitAction: function (instanceId, action, comments, userId) {
      if (config.apiBase) return api.post('/approvals/' + instanceId + '/action', { action: action, comments: comments });
      var s = loadStore();
      var inst = s.instances.find(function(i){ return i.instanceId === instanceId; });
      if (!inst) return Promise.reject({ message: 'Instance not found' });

      var user = mockData.USERS.find(function(u){ return u.userId === userId; });
      var newAction = {
        actionId:       _nextActionId++,
        instanceId:     instanceId,
        stepSeq:        inst.currentStepSeq,
        actionedBy:     userId,
        actionedByName: user ? user.displayName : '—',
        action:         action,
        comments:       comments || '',
        actionedAt:     new Date().toISOString(),
      };
      s.actions.push(newAction);

      if (action === 'APPROVED') {
        // Check conditional steps
        var allSteps = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId && st.stepSeq > inst.currentStepSeq; });
        var amount = _getAmount(inst);
        var nextStep = null;
        for (var i = 0; i < allSteps.length; i++) {
          var st = allSteps[i];
          if (st.conditionType === 'ALWAYS') { nextStep = st; break; }
          if (st.conditionType === 'AMOUNT' && amount !== null) {
            var ok = (st.amountOperator === '>='  && amount >= st.amountThreshold) ||
                     (st.amountOperator === '>'   && amount >  st.amountThreshold) ||
                     (st.amountOperator === '<='  && amount <= st.amountThreshold);
            if (ok) { nextStep = st; break; }
          }
        }
        if (nextStep) {
          inst.currentStepSeq = nextStep.stepSeq;
        } else {
          inst.overallStatus = 'APPROVED';
          inst.currentStepSeq = null;
          _updateSourceStatus(inst, 'APPROVED');
        }
      } else if (action === 'REJECTED' || action === 'RETURNED') {
        inst.overallStatus = action === 'RETURNED' ? 'RETURNED' : 'REJECTED';
        inst.currentStepSeq = null;
        _updateSourceStatus(inst, action === 'RETURNED' ? 'RETURNED' : 'REJECTED');
      }

      saveStore(s);
      return Promise.resolve(newAction);
    },

    // Create a new approval instance when a request is submitted
    startWorkflow: function (templateCode, sourceModule, sourceRecordId, sourceRecordRef, submittedBy) {
      if (config.apiBase) return api.post('/approvals/start', { templateCode: templateCode, sourceModule: sourceModule, sourceRecordId: sourceRecordId, sourceRecordRef: sourceRecordRef });
      var s = loadStore();
      var tpl = mockData.APPROVAL_TEMPLATES.find(function(t){ return t.templateCode === templateCode; });
      if (!tpl) return Promise.reject({ message: 'Template not found: ' + templateCode });
      var steps = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === tpl.templateId; }).sort(function(a,b){ return a.stepSeq - b.stepSeq; });
      if (!steps.length) return Promise.reject({ message: 'No steps found for template' });
      var maxId = s.instances.reduce(function(m,i){ return Math.max(m, i.instanceId); }, 0);
      var newInst = {
        instanceId:      maxId + 1,
        templateId:      tpl.templateId,
        sourceModule:    sourceModule,
        sourceRecordId:  sourceRecordId,
        sourceRecordRef: sourceRecordRef,
        submittedBy:     submittedBy,
        submittedAt:     new Date().toISOString(),
        currentStepSeq:  steps[0].stepSeq,
        overallStatus:   'PENDING',
      };
      s.instances.push(newInst);
      saveStore(s);
      return Promise.resolve(newInst);
    },

    getTemplates: function () {
      if (config.apiBase) return api.get('/approval-templates/').then(function(d){ return d.items || []; });
      return Promise.resolve(mockData.APPROVAL_TEMPLATES.slice());
    },

    getSteps: function (templateId) {
      if (config.apiBase) return api.get('/approval-templates/' + templateId + '/steps').then(function(d){ return d.items || []; });
      return Promise.resolve(mockData.APPROVAL_STEPS.filter(function(s){ return s.templateId === templateId; }));
    },
  };

  function _updateSourceStatus(inst, status) {
    var dtRaw = null; var stRaw = null;
    try { dtRaw = localStorage.getItem('ifinance_dt_data'); } catch(e) {}
    try { stRaw = localStorage.getItem('ifinance_dt_settlements'); } catch(e) {}

    if (inst.sourceModule === 'TRAVEL_REQUEST' && dtRaw) {
      var dtStore = JSON.parse(dtRaw);
      var idx = dtStore.requests.findIndex(function(r){ return r.reqId === inst.sourceRecordId; });
      if (idx !== -1) {
        dtStore.requests[idx].status = (status === 'APPROVED') ? 'APPROVED' : status;
        localStorage.setItem('ifinance_dt_data', JSON.stringify(dtStore));
      }
    }
    if (inst.sourceModule === 'SETTLEMENT' && stRaw) {
      var stStore = JSON.parse(stRaw);
      var si = stStore.settlements.findIndex(function(x){ return x.settleId === inst.sourceRecordId; });
      if (si !== -1) {
        stStore.settlements[si].status = (status === 'APPROVED') ? 'APPROVED' : status;
        if (status === 'APPROVED') stStore.settlements[si].approvedAt = new Date().toISOString();
        localStorage.setItem('ifinance_dt_settlements', JSON.stringify(stStore));
      }
    }
  }
});
