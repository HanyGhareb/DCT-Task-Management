define(['knockout', 'services/ccService', 'shared/docUpload'],
function (ko, ccService, docUpload) {
  'use strict';

  var TYPES = [
    { code: 'NEW_CARD',       label: 'New Card',       icon: '\u{1F4B3}', desc: 'Apply for a new corporate credit card' },
    { code: 'INCREASE_LIMIT', label: 'Increase Limit', icon: '⬆',    desc: 'Raise the credit limit on your card' },
    { code: 'DECREASE_LIMIT', label: 'Decrease Limit', icon: '⬇',    desc: 'Lower the credit limit on your card' },
    { code: 'REPLACEMENT',    label: 'Replacement',    icon: '♻',    desc: 'Replace a damaged, lost or expiring card' },
    { code: 'CLOSE_CARD',     label: 'Close Card',     icon: '❌',    desc: 'Permanently close the card' }
  ];

  function RequestNewViewModel() {
    var self = this;

    self.step      = ko.observable(1);          // 1 type · 2 details · 3 documents
    self.types     = TYPES;
    self.selType   = ko.observable('');
    self.myCards   = ko.observableArray([]);
    self.saving    = ko.observable(false);
    self.error     = ko.observable('');

    // details
    self.ccId            = ko.observable('');
    self.requestedLimit  = ko.observable('');
    self.reason          = ko.observable('');
    self.replacementReason = ko.observable('');

    // created draft + docs
    self.requestId    = ko.observable(null);
    self.requestNumber = ko.observable('');
    self.docReqs      = ko.observableArray([]);

    ccService.getCards({ mine: 'Y' }).then(function (r) {
      self.myCards(r.items || []);
    }).catch(function () {});

    self.needsCard  = ko.computed(function () { return self.selType() && self.selType() !== 'NEW_CARD'; });
    self.needsLimit = ko.computed(function () { return ['NEW_CARD', 'INCREASE_LIMIT', 'DECREASE_LIMIT'].indexOf(self.selType()) >= 0; });
    self.needsReplReason = ko.computed(function () { return self.selType() === 'REPLACEMENT'; });

    self.pickType = function (t) { self.selType(t.code); };
    self.next = function () {
      self.error('');
      if (self.step() === 1) {
        if (!self.selType()) { self.error('Pick a request type.'); return; }
        self.step(2);
      }
    };
    self.back = function () { if (self.step() > 1) self.step(self.step() - 1); };

    // step 2 → create the DRAFT, then load the doc checklist
    self.createDraft = function () {
      self.error('');
      if (self.needsCard() && !self.ccId())   { self.error('Pick the card this request applies to.'); return; }
      if (self.needsLimit() && !self.requestedLimit()) { self.error('Enter the requested limit.'); return; }
      if (self.needsReplReason() && !self.replacementReason()) { self.error('Pick a replacement reason.'); return; }
      self.saving(true);
      ccService.createRequest({
        ccId:              self.needsCard() ? Number(self.ccId()) : null,
        requestType:       self.selType(),
        requestedLimit:    self.needsLimit() ? Number(self.requestedLimit()) : null,
        reason:            self.reason(),
        replacementReason: self.needsReplReason() ? self.replacementReason() : null
      }).then(function (r) {
        self.requestId(r.requestId);
        self.requestNumber(r.requestNumber);
        return ccService.getDocRequirements(self.selType());
      }).then(function (reqs) {
        self.docReqs(reqs.map(function (d) {
          d.uploaded = ko.observable(false);
          d.uploading = ko.observable(false);
          return d;
        }));
        self.saving(false);
        self.step(3);
      }).catch(function (err) {
        self.saving(false);
        self.error((err && err.message) || 'Could not create the request');
      });
    };

    self.pickFile = function (docReq) {
      // Raw-binary upload (no base64, no ~32 KB cap): pick → createDocument → putBinary.
      docUpload.choose({ accept: '.pdf,.jpg,.jpeg,.png', maxMb: 10 }).then(function (file) {
        if (!file) return;
        docReq.uploading(true);
        ccService.createDocument({
          sourceType: 'REQUEST',
          sourceId:   self.requestId(),
          docReqId:   docReq.docReqId,
          docTypeId:  docReq.docTypeId,
          fileName:   file.name,
          mimeType:   file.type || 'application/octet-stream',
          isRequired: docReq.isMandatory
        }).then(function (r) {
          return ccService.uploadDocumentFile(r.documentId, file);
        }).then(function () {
          docReq.uploading(false);
          docReq.uploaded(true);
        }).catch(function (err) {
          docReq.uploading(false);
          self.error((err && err.message) || 'Upload failed');
        });
      });
      return true;
    };

    self.allMandatoryUploaded = ko.computed(function () {
      return self.docReqs().every(function (d) { return d.isMandatory !== 'Y' || d.uploaded(); });
    });

    self.submit = function () {
      self.error('');
      self.saving(true);
      ccService.submitRequest(self.requestId()).then(function () {
        self.saving(false);
        if (window._jetApp) window._jetApp.navigate('requestDetail', { requestId: self.requestId() });
      }).catch(function (err) {
        self.saving(false);
        self.error((err && err.message) || 'Submit failed');
      });
    };

    self.saveDraftAndExit = function () {
      if (window._jetApp) window._jetApp.navigate('requests');
    };
  }

  return RequestNewViewModel;
});
