define(['knockout', 'services/ccService', 'shared/toast'],
function (ko, ccService, toast) {
  'use strict';

  function ProxiesViewModel() {
    var self = this;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);

    // new proxy modal
    self.showNew  = ko.observable(false);
    self.cards    = ko.observableArray([]);
    self.users    = ko.observableArray([]);
    self.newCcId  = ko.observable('');
    self.newUser  = ko.observable('');
    self.newStart = ko.observable('');
    self.newEnd   = ko.observable('');
    self.newError = ko.observable('');
    self.busy     = ko.observable(false);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      ccService.getProxies().then(function (items) {
        self.items(items);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();

    self.openNew = function () {
      self.newError('');
      Promise.all([
        ccService.getCards({ status: 'ACTIVE', limit: 200 }),
        ccService.getLookups()
      ]).then(function (res) {
        self.cards(res[0].items || []);
        self.users(res[1].users || []);
        self.showNew(true);
      });
    };

    self.createProxy = function () {
      self.newError('');
      if (!self.newCcId() || !self.newUser()) { self.newError('Card and proxy user are required.'); return; }
      self.busy(true);
      ccService.createProxy({
        ccId:        Number(self.newCcId()),
        proxyUserId: Number(self.newUser()),
        startDate:   self.newStart() || null,
        endDate:     self.newEnd() || null
      }).then(function () {
        self.busy(false);
        self.showNew(false);
        self.newCcId(''); self.newUser(''); self.newStart(''); self.newEnd('');
        toast.success('Proxy created.');
        self.reload();
      }).catch(function (err) {
        self.busy(false);
        self.newError((err && err.message) || 'Could not create the proxy');
      });
    };

    self.deactivate = function (row) {
      self.busy(true);
      ccService.updateProxy(row.proxyId, { isActive: 'N' }).then(function () {
        self.busy(false);
        toast.success('Proxy deactivated.');
        self.reload();
      }).catch(function () { self.busy(false); });
    };
  }

  return ProxiesViewModel;
});
