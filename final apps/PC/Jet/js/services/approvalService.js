/**
 * approvalService.js — Approval workflow for Petty Cash module.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY     = 'ifinance_pc_approvals';
  var _nextActionId = 10;

  function loadStore() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return {
      instances: JSON.parse(JSON.stringify(mockData.APPROVAL_INSTANCES)),
      actions:   JSON.parse(JSON.stringify(mockData.APPROVAL_ACTIONS)),
    };
  }
  function saveStore(s) { localStorage.setItem(STORE_KEY, JSON.stringify(s)); }

  // Determine which roles a given step requires
  function _stepRoles(step) {
    return [step.requiredRole];
  }

  // Get pending approvals for a user based on their roles
  return {

    getPendingForUser: function (user) {
      if (config.apiBase) return api.get('/approvals/pending');
      var s = loadStore();
      var pending = s.instances.filter(function(i){ return i.overallStatus === 'PENDING'; });
      return Promise.resolve(pending.filter(function(inst) {
        // Find the current step
        var tpl   = mockData.APPROVAL_TEMPLATES.find(function(t){ return t.templateId === inst.templateId; });
        var steps = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId; });
        var curStep = steps.find(function(st){ return st.stepSeq === inst.currentStepSeq; });
        if (!curStep) return false;
        // Does this user have the required role?
        var userRoles = user ? user.roles || [] : [];
        return userRoles.includes(curStep.requiredRole) || userRoles.includes('SYS_ADMIN');
      }).map(function(inst) {
        var steps   = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId; });
        var curStep = steps.find(function(st){ return st.stepSeq === inst.currentStepSeq; });
        var submitter = mockData.USERS.find(function(u){ return u.userId === inst.submittedBy; });
        // Get amount from source record
        var amount = null;
        var pcStore = null;
        try { var raw = localStorage.getItem('ifinance_pc_data'); if (raw) pcStore = JSON.parse(raw); } catch(e) {}
        var pcList  = pcStore ? pcStore.petty_cash   : mockData.PETTY_CASH;
        var reimbList = pcStore ? pcStore.reimbursements : mockData.REIMBURSEMENTS;
        var clearList = pcStore ? pcStore.clearings   : mockData.CLEARINGS;

        if (inst.sourceModule === 'PETTY_CASH') {
          var pc = pcList.find(function(r){ return r.pcId === inst.sourceRecordId; });
          if (pc) amount = pc.amount;
        } else if (inst.sourceModule === 'REIMBURSEMENT') {
          var rb = reimbList.find(function(r){ return r.reimbId === inst.sourceRecordId; });
          if (rb) amount = rb.amount;
        } else if (inst.sourceModule === 'CLEARING') {
          var cl = clearList.find(function(r){ return r.clearingId === inst.sourceRecordId; });
          if (cl) amount = cl.amountSpent;
        }

        return {
          instanceId:    inst.instanceId,
          requestRef:    inst.sourceRecordRef,
          requestType:   inst.sourceModule,
          submittedBy:   submitter ? submitter.displayName : '—',
          submittedAt:   inst.submittedAt,
          currentStep:   curStep ? curStep.stepName : '—',
          amount:        amount,
          overallStatus: inst.overallStatus,
          sourceRecordId:inst.sourceRecordId,
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
      var actions = s.actions.filter(function(a){ return a.instanceId === inst.instanceId; });
      return Promise.resolve(actions.sort(function(a,b){ return a.actionId - b.actionId; }));
    },

    submitAction: function (instanceId, action, comments, userId) {
      if (config.apiBase) return api.post('/approvals/' + instanceId + '/action', { action: action, comments: comments });
      var s = loadStore();
      var inst = s.instances.find(function(i){ return i.instanceId === instanceId; });
      if (!inst) return Promise.reject({ message: 'Instance not found' });

      var user = mockData.USERS.find(function(u){ return u.userId === userId; });
      var newAction = {
        actionId:     _nextActionId++,
        instanceId:   instanceId,
        stepSeq:      inst.currentStepSeq,
        actionedBy:   userId,
        actionedByName: user ? user.displayName : '—',
        action:       action,
        comments:     comments || '',
        actionedAt:   new Date().toISOString(),
      };
      s.actions.push(newAction);

      if (action === 'APPROVED') {
        // Find next step
        var steps = mockData.APPROVAL_STEPS.filter(function(st){ return st.templateId === inst.templateId && st.stepSeq > inst.currentStepSeq; });
        if (steps.length > 0) {
          inst.currentStepSeq = steps[0].stepSeq;
        } else {
          inst.overallStatus = 'APPROVED';
          inst.currentStepSeq = null;
          // Update source record status
          _updateSourceStatus(inst, 'APPROVED');
        }
      } else if (action === 'REJECTED' || action === 'RETURNED') {
        inst.overallStatus = 'REJECTED';
        inst.currentStepSeq = null;
        _updateSourceStatus(inst, 'REJECTED');
      }

      saveStore(s);
      return Promise.resolve(newAction);
    },

    getTemplates: function () {
      if (config.apiBase) return api.get('/approval-templates');
      return Promise.resolve(mockData.APPROVAL_TEMPLATES.slice());
    },

    getSteps: function (templateId) {
      if (config.apiBase) return api.get('/approval-templates/' + templateId + '/steps');
      return Promise.resolve(mockData.APPROVAL_STEPS.filter(function(s){ return s.templateId === templateId; }));
    },
  };

  function _updateSourceStatus(inst, status) {
    var pcStore = null;
    try { var raw = localStorage.getItem('ifinance_pc_data'); if (raw) pcStore = JSON.parse(raw); } catch(e) {}
    if (!pcStore) return;

    var newStatus = status === 'APPROVED' ? 'APPROVED' : 'REJECTED';

    if (inst.sourceModule === 'PETTY_CASH') {
      var idx = pcStore.petty_cash.findIndex(function(r){ return r.pcId === inst.sourceRecordId; });
      if (idx !== -1) pcStore.petty_cash[idx].status = newStatus;
    } else if (inst.sourceModule === 'REIMBURSEMENT') {
      var ri = pcStore.reimbursements.findIndex(function(r){ return r.reimbId === inst.sourceRecordId; });
      if (ri !== -1) pcStore.reimbursements[ri].status = newStatus;
    } else if (inst.sourceModule === 'CLEARING') {
      var ci = pcStore.clearings.findIndex(function(r){ return r.clearingId === inst.sourceRecordId; });
      if (ci !== -1) pcStore.clearings[ci].status = newStatus;
    }
    localStorage.setItem('ifinance_pc_data', JSON.stringify(pcStore));
  }
});
