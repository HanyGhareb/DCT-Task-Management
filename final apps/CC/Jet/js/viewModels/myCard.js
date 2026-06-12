define(['knockout', 'services/ccService'],
function (ko, ccService) {
  'use strict';

  function MyCardViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.card         = ko.observable(null);
    self.history      = ko.observableArray([]);
    self.replDue      = ko.observable(false);

    ccService.getCards({ mine: 'Y' }).then(function (r) {
      var items = r.items || [];
      if (!items.length) { self.loading(false); return; }
      var ccId = items[0].ccId;
      return Promise.all([
        ccService.getCard(ccId),
        ccService.getLimitHistory(ccId),
        ccService.getReplenishments({ ccId: ccId, limit: 60 })
      ]).then(function (res) {
        self.card(res[0]);
        self.history(res[1]);
        var now = new Date();
        var hasThisMonth = (res[2].items || []).some(function (rep) {
          return rep.periodMonth === (now.getMonth() + 1)
              && rep.periodYear === now.getFullYear()
              && rep.status !== 'REJECTED';
        });
        self.replDue(res[0].status === 'ACTIVE' && !hasThisMonth);
        self.loading(false);
      });
    }).catch(function () { self.loading(false); });

    self.maskedNumber = ko.computed(function () {
      var c = self.card();
      return c ? c.ccNumber : '';
    });

    self.statusBadge = function (s) {
      var map = { ACTIVE: 'badge--active-st', INACTIVE: 'badge--inactive', CLOSED: 'badge--closed' };
      return 'badge ' + (map[s] || 'badge--idle');
    };

    self.changeBadge = function (t) {
      var map = { INITIAL: 'badge--info', INCREASE: 'badge--approved', DECREASE: 'badge--returned' };
      return 'badge ' + (map[t] || 'badge--idle');
    };

    self.newReplenishment = function () {
      if (window._jetApp) window._jetApp.navigate('replenishments');
    };
    self.newRequest = function () {
      if (window._jetApp) window._jetApp.navigate('requestNew');
    };
  }

  return MyCardViewModel;
});
