define(['knockout', 'services/tmService', 'shared/i18n'],
function (ko, tm, i18n) {
  'use strict';
  return function Library() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.docs = ko.observableArray([]);
    self.search = ko.observable('');
    self.load = function () {
      self.loading(true);
      tm.listDocuments({ search: self.search() })
        .then(function (r) { self.docs(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };
    self.fmtSize = function (b) { return b ? (Math.round(b / 1024) + ' KB') : '—'; };
    self.load();
  };
});
