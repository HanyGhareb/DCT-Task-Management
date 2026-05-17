define(['knockout', 'mockData'],
function (ko, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_doc_reqs';

  function loadDocs() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.DOC_REQUIREMENTS));
  }
  function saveDocs(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  function DocRequirementsViewModel() {
    var self = this;

    self.docs        = ko.observableArray([]);
    self.typeFilter  = ko.observable('');
    self.editRow     = ko.observable(null);
    self.saving      = ko.observable(false);
    self.successMsg  = ko.observable('');

    self.filtered = ko.computed(function () {
      var tf = self.typeFilter();
      return self.docs().filter(function(d){ return !tf || d.requestType === tf; });
    });

    self.startEdit = function (doc) {
      self.editRow({
        docId:       doc.docId,
        docCode:     doc.docCode,
        docName:     ko.observable(doc.docName),
        requestType: doc.requestType,
        isRequired:  ko.observable(doc.isRequired),
        isActive:    ko.observable(doc.isActive),
      });
    };
    self.cancelEdit = function () { self.editRow(null); };

    self.saveEdit = function () {
      var e = self.editRow();
      if (!e) return;
      var list = loadDocs();
      var idx  = list.findIndex(function(d){ return d.docId === e.docId; });
      if (idx !== -1) {
        list[idx].docName   = e.docName();
        list[idx].isRequired = e.isRequired();
        list[idx].isActive  = e.isActive();
      }
      saveDocs(list);
      self.docs(list);
      self.editRow(null);
      self.successMsg('Document requirement updated.');
    };

    self.docs(loadDocs());
  }

  return DocRequirementsViewModel;
});
