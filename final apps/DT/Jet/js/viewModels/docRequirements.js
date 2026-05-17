define(['knockout', 'services/config', 'services/api', 'mockData'],
function (ko, config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_doc_reqs';

  function loadDocs() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.DOC_REQUIREMENTS));
  }
  function saveDocs(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  // Map mock shape (docId/docCode/requestType/isRequired) or ORDS shape to a
  // consistent normalised object the view can bind to.
  function _norm(r) {
    var appliesToSource = r.appliesToSource
      || (r.requestType === 'TRAVEL_REQUEST' ? 'REQUEST' : r.requestType)
      || '';
    var appliesToSourceLabel = r.appliesToSourceLabel
      || (appliesToSource === 'REQUEST' ? 'Travel Request' : appliesToSource === 'SETTLEMENT' ? 'Settlement' : appliesToSource === 'BOTH' ? 'Both' : appliesToSource);
    return {
      docReqId:            r.docReqId || r.docId,
      docCode:             r.docCode  || '',
      docName:             r.docName  || r.documentTypeName || '',
      missionType:         r.missionType      || 'ALL',
      missionTypeLabel:    r.missionTypeLabel  || r.missionType || 'All',
      tripType:            r.tripType          || 'ALL',
      tripTypeLabel:       r.tripTypeLabel     || r.tripType || 'All',
      appliesToSource:     appliesToSource,
      appliesToSourceLabel:appliesToSourceLabel,
      isMandatory:         r.isMandatory || r.isRequired || 'N',
      displaySeq:          r.displaySeq  || 0,
      isActive:            r.isActive,
    };
  }

  function DocRequirementsViewModel() {
    var self = this;

    self.docs        = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.typeFilter  = ko.observable('');
    self.editRow     = ko.observable(null);
    self.saving      = ko.observable(false);
    self.successMsg  = ko.observable('');
    self.error       = ko.observable('');

    self.filtered = ko.computed(function () {
      var tf = self.typeFilter();
      return self.docs().filter(function(d) {
        if (!tf) return true;
        // 'BOTH' applies to both REQUEST and SETTLEMENT filters
        return d.appliesToSource === tf || d.appliesToSource === 'BOTH';
      });
    });

    self.startEdit = function (doc) {
      self.editRow({
        docReqId:        doc.docReqId,
        docCode:         doc.docCode,
        docName:         doc.docName,               // display-only in edit heading
        isMandatory:     ko.observable(doc.isMandatory),
        appliesToSource: ko.observable(doc.appliesToSource),
        displaySeq:      ko.observable(doc.displaySeq),
        isActive:        ko.observable(doc.isActive),
      });
    };
    self.cancelEdit = function () { self.editRow(null); };

    self.saveEdit = function () {
      var e = self.editRow();
      if (!e) return;
      self.saving(true);
      self.error('');
      var payload = {
        isMandatory:     e.isMandatory(),
        appliesToSource: e.appliesToSource(),
        displaySeq:      parseInt(e.displaySeq()) || 0,
        isActive:        e.isActive(),
      };
      if (config.apiBase) {
        api.put('/doc-requirements/' + e.docReqId, payload)
          .then(function() {
            return api.get('/doc-requirements/').then(function(d) {
              self.docs((d.items || []).map(_norm));
            });
          })
          .then(function() {
            self.editRow(null);
            self.saving(false);
            self.successMsg('Document requirement updated.');
          })
          .catch(function(err) {
            self.saving(false);
            self.error(err && err.message ? err.message : 'Save failed.');
          });
        return;
      }
      // Mock mode
      var list = loadDocs();
      var idx  = list.findIndex(function(d){ return d.docId === e.docReqId; });
      if (idx !== -1) {
        if (payload.isMandatory)     list[idx].isRequired      = payload.isMandatory;
        if (payload.appliesToSource) list[idx].requestType     = payload.appliesToSource === 'REQUEST' ? 'TRAVEL_REQUEST' : payload.appliesToSource;
        list[idx].isActive = payload.isActive;
      }
      saveDocs(list);
      self.docs(list.map(_norm));
      self.editRow(null);
      self.saving(false);
      self.successMsg('Document requirement updated.');
    };

    // Load
    if (config.apiBase) {
      api.get('/doc-requirements/').then(function(d) {
        self.docs((d.items || []).map(_norm));
        self.loading(false);
      }).catch(function(err) {
        self.error(err && err.message ? err.message : 'Failed to load doc requirements.');
        self.loading(false);
      });
    } else {
      self.docs(loadDocs().map(_norm));
      self.loading(false);
    }
  }

  return DocRequirementsViewModel;
});
