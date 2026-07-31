/**
 * myDelegations.js — Workspace → My Delegations (visible to EVERY user).
 *
 * The self-service vacation rule: delegate my own approval authority to a
 * colleague for a date window (everything or one module). The server enforces
 * self-service — a non-admin can only ever create/cancel their OWN delegations
 * (POST /dct/delegations 403s on someone else's behalf) — so this page is a
 * discoverable front door to rights users already have. The engine attaches
 * the delegate to open AND future tasks of the window (15-min sweep).
 *
 * The admin oversight view of everyone's delegations stays at System →
 * Delegations; this page is always scoped ?mine=Y.
 */
define(['knockout', 'services/authService', 'services/userService',
        'services/delegationService', 'shared/i18n'],
function (ko, authService, userService, delegationService, i18n) {
  'use strict';

  function MyDelegationsViewModel() {
    var self = this;
    var session = authService.getCurrentUser() || {};
    self.t = i18n.t;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);
    self.busy      = ko.observable(false);

    // outgoing = I delegated my authority; incoming = someone delegated to me
    self.outgoing = ko.pureComputed(function () {
      return self.items().filter(function (d) { return d.delegatorId === session.userId; });
    });
    self.incoming = ko.pureComputed(function () {
      return self.items().filter(function (d) { return d.delegatorId !== session.userId; });
    });

    self.reload = function () {
      self.loading(true); self.loadError(false);
      delegationService.getAll(true).then(function (items) {
        self.items(items); self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();

    /* ── create drawer ─────────────────────────────────────────────────── */
    self.showEdit  = ko.observable(false);
    self.editError = ko.observable('');
    self.dUsers    = ko.observableArray([]);
    self.dModules  = ko.observableArray([]);
    self.dDelegate = ko.observable('');
    self.dScope    = ko.observable('ALL_ROLES');
    self.dModule   = ko.observable('');
    self.dStart    = ko.observable('');
    self.dEnd      = ko.observable('');
    self.dReason   = ko.observable('');

    self.openNew = function () {
      self.editError('');
      Promise.all([
        userService.getAll(),
        new Promise(function (resolve) {
          require(['services/moduleService'], function (moduleService) {
            moduleService.getAccessibleForUser().then(resolve).catch(function () { resolve([]); });
          });
        })
      ]).then(function (res) {
        self.dUsers((res[0] || []).filter(function (u) {
          return u.userId !== session.userId && u.isActive !== 'N';
        }));
        self.dModules(res[1] || []);
        self.dDelegate(''); self.dScope('ALL_ROLES'); self.dModule('');
        self.dStart(''); self.dEnd(''); self.dReason('');
        self.showEdit(true);
      });
    };

    self.saveEdit = function () {
      self.editError('');
      if (!self.dDelegate()) { self.editError(i18n.t('vw.mydel.needDelegate')); return; }
      if (!self.dEnd())      { self.editError(i18n.t('vw.mydel.needEnd')); return; }
      if (self.dScope() === 'MODULE' && !self.dModule()) {
        self.editError(i18n.t('vw.mydel.needModule')); return;
      }
      self.busy(true);
      delegationService.create({
        delegateId: Number(self.dDelegate()),
        scope:      self.dScope(),
        moduleCode: self.dScope() === 'MODULE' ? self.dModule() : null,
        startDate:  self.dStart() || null,
        endDate:    self.dEnd(),
        reason:     self.dReason() || null
      }).then(function () {
        self.busy(false); self.showEdit(false); self.reload();
      }).catch(function (err) {
        self.busy(false);
        self.editError((err && err.message) || 'Could not create the delegation');
      });
    };

    self.cancel = function (d) {
      self.busy(true);
      delegationService.cancel(d.delegationId).then(function () {
        self.busy(false); self.reload();
      }).catch(function () { self.busy(false); });
    };

    self.scopeLabel = function (d) {
      if (d.scope === 'ALL_ROLES') return i18n.t('vw.mydel.scopeAll');
      if (d.scope === 'MODULE')    return i18n.t('vw.mydel.scopeModule') + ': ' + (d.moduleName || d.moduleCode);
      return (d.roleName || d.roleCode || d.scope);
    };
    self.statusBadge = function (s) {
      var map = { ACTIVE: 'badge--approved', CANCELLED: 'badge--idle', EXPIRED: 'badge--idle' };
      return 'badge ' + (map[s] || 'badge--pending');
    };
  }

  return MyDelegationsViewModel;
});
