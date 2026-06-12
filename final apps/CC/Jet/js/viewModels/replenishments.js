define(['knockout', 'services/ccService', 'services/authService', 'shared/toast'],
function (ko, ccService, authService, toast) {
  'use strict';

  function ReplenishmentsViewModel() {
    var self = this;

    self.isAdmin   = authService.isCcAdmin();
    self.scope     = ko.observable(self.isAdmin ? 'all' : 'mine');
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);
    self.total     = ko.observable(0);
    self.limit     = ko.observable(25);
    self.offset    = ko.observable(0);
    self.statusFilter = ko.observable('');

    // new-replenishment modal
    self.showNewModal = ko.observable(false);
    self.myCards      = ko.observableArray([]);
    self.newCcId      = ko.observable('');
    self.newMonth     = ko.observable(new Date().getMonth() + 1);
    self.newYear      = ko.observable(new Date().getFullYear());
    self.newError     = ko.observable('');
    self.creating     = ko.observable(false);
    self.months       = [1,2,3,4,5,6,7,8,9,10,11,12];

    self.reload = function (offset) {
      if (typeof offset === 'number') self.offset(offset);
      self.loading(true);
      self.loadError(false);
      ccService.getReplenishments({
        mine:   self.scope() === 'mine' ? 'Y' : '',
        status: self.statusFilter(),
        limit:  self.limit(),
        offset: self.offset()
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };

    self.statusFilter.subscribe(function () { self.reload(0); });
    self.setScope = function (s) { self.scope(s); self.reload(0); };

    self.openNew = function () {
      self.newError('');
      ccService.getCards({ mine: 'Y' }).then(function (r) {
        var cards = (r.items || []).filter(function (c) { return c.status === 'ACTIVE'; });
        self.myCards(cards);
        if (cards.length === 1) self.newCcId(cards[0].ccId);
        self.showNewModal(true);
      });
    };

    self.createNew = function () {
      self.newError('');
      if (!self.newCcId()) { self.newError('Pick a card.'); return; }
      self.creating(true);
      ccService.createReplenishment({
        ccId:        Number(self.newCcId()),
        periodMonth: Number(self.newMonth()),
        periodYear:  Number(self.newYear())
      }).then(function (r) {
        self.creating(false);
        self.showNewModal(false);
        toast.success('Replenishment ' + r.reimbNumber + ' created.');
        if (window._jetApp) window._jetApp.navigate('replenishmentDetail', { replenishmentId: r.replenishmentId });
      }).catch(function (err) {
        self.creating(false);
        self.newError((err && err.message) || 'Could not create the replenishment');
      });
    };

    self.openDetail = function (row) {
      if (window._jetApp) window._jetApp.navigate('replenishmentDetail', { replenishmentId: row.replenishmentId });
    };

    self.statusBadge = function (s) {
      var map = { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', UNDER_REVIEW: 'badge--underreview',
                  RETURNED: 'badge--returned', APPROVED: 'badge--approved', REJECTED: 'badge--rejected' };
      return 'badge ' + (map[s] || 'badge--idle');
    };

    self.reload();
  }

  return ReplenishmentsViewModel;
});
