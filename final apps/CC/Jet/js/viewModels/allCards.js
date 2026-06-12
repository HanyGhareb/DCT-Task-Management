define(['knockout', 'services/ccService', 'shared/toast'],
function (ko, ccService, toast) {
  'use strict';

  function AllCardsViewModel() {
    var self = this;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);
    self.total     = ko.observable(0);
    self.limit     = ko.observable(25);
    self.offset    = ko.observable(0);
    self.search    = ko.observable('');
    self.statusFilter = ko.observable('');

    // register drawer
    self.showRegister = ko.observable(false);
    self.approvedNewCardReqs = ko.observableArray([]);
    self.lookups   = ko.observable({ users: [], orgs: [] });
    self.regError  = ko.observable('');
    self.regBusy   = ko.observable(false);
    self.reg = {
      requestId:    ko.observable(''),
      holderUserId: ko.observable(''),
      motherName:   ko.observable(''),
      nationality:  ko.observable(''),
      creditLimit:  ko.observable(''),
      expiryDate:   ko.observable(''),
      email:        ko.observable(''),
      orgId:        ko.observable(''),
      costCenter:   ko.observable('')
    };

    self.reload = function (offset) {
      if (typeof offset === 'number') self.offset(offset);
      self.loading(true);
      self.loadError(false);
      ccService.getCards({
        search: self.search(),
        status: self.statusFilter(),
        limit:  self.limit(),
        offset: self.offset()
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };

    var searchTimer = null;
    self.search.subscribe(function () {
      clearTimeout(searchTimer);
      searchTimer = setTimeout(function () { self.reload(0); }, 400);
    });
    self.statusFilter.subscribe(function () { self.reload(0); });

    self.openRegister = function () {
      self.regError('');
      Promise.all([
        ccService.getRequests({ type: 'NEW_CARD', status: 'APPROVED', limit: 100 }),
        ccService.getLookups()
      ]).then(function (res) {
        // only approved NEW_CARD requests without a card yet
        self.approvedNewCardReqs((res[0].items || []).filter(function (r) { return !r.ccId; }));
        self.lookups({ users: res[1].users || [], orgs: res[1].orgs || [] });
        self.showRegister(true);
      });
    };

    self.registerCard = function () {
      self.regError('');
      var r = self.reg;
      if (!r.requestId() || !r.holderUserId() || !r.motherName() || !r.nationality()
          || !r.creditLimit() || !r.expiryDate() || !r.email() || !r.orgId()) {
        self.regError('All fields except cost center are required.');
        return;
      }
      self.regBusy(true);
      ccService.registerCard({
        requestId:    Number(r.requestId()),
        holderUserId: Number(r.holderUserId()),
        motherName:   r.motherName(),
        nationality:  r.nationality(),
        creditLimit:  Number(r.creditLimit()),
        expiryDate:   r.expiryDate(),
        email:        r.email(),
        orgId:        Number(r.orgId()),
        costCenter:   r.costCenter()
      }).then(function (res) {
        self.regBusy(false);
        self.showRegister(false);
        toast.success('Card registered (ccId ' + res.ccId + ').');
        Object.keys(self.reg).forEach(function (k) { self.reg[k](''); });
        self.reload(0);
      }).catch(function (err) {
        self.regBusy(false);
        self.regError((err && err.message) || 'Registration failed');
      });
    };

    self.statusBadge = function (s) {
      var map = { ACTIVE: 'badge--active-st', INACTIVE: 'badge--inactive', CLOSED: 'badge--closed' };
      return 'badge ' + (map[s] || 'badge--idle');
    };

    self.reload();
  }

  return AllCardsViewModel;
});
