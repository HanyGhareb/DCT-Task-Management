/**
 * sessions.js — Active Sessions (enh-2 round, System > Sessions).
 * Lists sessions still inside the inactivity window; Revoke signs the user
 * out of ALL their devices (server closes every active session by username —
 * single-session revoke would mean shipping live bearer tokens to the client).
 */
define(['knockout', 'services/sessionService', 'services/authService',
        'shared/i18n', 'shared/toast'],
function (ko, sessionService, authService, i18n, toast) {
  'use strict';

  function SessionsViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading     = ko.observable(true);
    self.loadError   = ko.observable(false);
    self.items       = ko.observableArray([]);
    self.timeoutMins = ko.observable(480);
    self.busy        = ko.observable(false);

    // own token tail — highlights "this session" and drives the self-revoke warning
    var tok = authService.getToken() || '';
    self.ownTail = tok.slice(-6);

    self.isOwn = function (s) { return s.sidTail === self.ownTail; };

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      sessionService.getSessions().then(function (r) {
        self.timeoutMins(r.timeoutMins);
        self.items(r.items);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
    };

    self.sessionCount = ko.pureComputed(function () { return self.items().length; });

    self.userCount = ko.pureComputed(function () {
      var seen = {};
      self.items().forEach(function (s) { seen[s.username] = 1; });
      return Object.keys(seen).length;
    });

    self.fmt = function (iso) {
      return iso ? i18n.fmtDate(iso, {
        day: 'numeric', month: 'short',
        hour: '2-digit', minute: '2-digit', hour12: true
      }) : '—';
    };

    self.revoke = function (s) {
      var me  = authService.getCurrentUser() || {};
      var own = (s.username || '').toUpperCase() === (me.username || '').toUpperCase();
      var msg = own ? i18n.t('sess.revokeSelfConfirm', [s.username])
                    : i18n.t('sess.revokeConfirm', [s.username]);
      if (!window.confirm(msg)) return;
      self.busy(true);
      sessionService.revokeUser(s.username).then(function (r) {
        self.busy(false);
        toast.success(i18n.t('sess.revoked', [r.revoked, s.username]));
        if (own) {
          // our own token just died server-side — leave cleanly
          authService.logout();
          if (window._jetApp) window._jetApp.navigate('login');
          return;
        }
        self.reload();
      }).catch(function () { self.busy(false); });
    };

    self.reload();
  }

  return SessionsViewModel;
});
