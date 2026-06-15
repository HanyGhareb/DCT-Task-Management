/* ── shared/js/docUpload.js ──────────────────────────────────────────────────
   Shared document-upload primitives for every JET app. Pairs with the binary
   transport in shared/js/api.js (api.putBinary / api.fetchBlobUrl) — files go
   up as raw bytes (NO base64, NO ~32 KB cap); the ORDS handler reads :body.

   Exposes TWO things:

   1) choose(opts) -> Promise<File|null>
      Opens a native file dialog, validates size/type, resolves the File (or
      null if cancelled / rejected). Lets an existing custom layout (e.g. the FL
      registration document checklist) swap its bespoke base64 plumbing for a
      one-liner without changing its markup:
          docUpload.choose({ accept:'image/*,application/pdf', maxMb:10 })
            .then(function (file) { if (file) uploadIt(file); });

   2) <doc-upload> Knockout component
      A self-contained, platform-styled upload control (drop-zone + file chip +
      Replace / View / Remove) for new views (CC / TM document pages, etc.).
      The .docup-* structural styles live in shared/css/platform.css; EN/AR
      labels come from shared/i18n (docup.* keys in common.<lang>.json).

      Register once at app boot: add 'shared/docUpload' to js/main.js require([]).

      Usage:
        <doc-upload params="fileName: doc.fileName, busy: uploadBusy,
                            accept: 'image/*,application/pdf', maxMb: 10,
                            onPick: function (f) { $vm.uploadDoc(f); },
                            onView: function () { $vm.viewDoc(doc); },
                            onRemove: function () { $vm.removeDoc(doc); }"></doc-upload>

      Params:
        fileName  observable|string  current attached file name ('' = none)
        onPick    function(File)     REQUIRED — receives the validated File
        accept    string             input accept attr (default image/*,application/pdf)
        maxMb     number             client size guard (default 10)
        busy      observable(bool)   optional — host sets true during upload
        disabled  observable|bool    optional
        onView    function           optional — shows View when present & file set
        onRemove  function           optional — shows Remove when present & file set
        hint      string|observable  optional — overrides the default size/type hint
*/
define(['knockout', 'shared/toast', 'shared/i18n'], function (ko, toast, i18n) {
  'use strict';

  var seq = 0;

  /** Returns an error message string, or null when the file is acceptable. */
  function validateFile(file, accept, maxMb) {
    if (!file) return null;
    if (maxMb && file.size > maxMb * 1024 * 1024) {
      return i18n.t('docup.tooLarge', [maxMb]);
    }
    // Light type guard. The dialog's `accept` attr already filters, and some
    // browsers report an empty file.type, so only reject an UNAMBIGUOUS mismatch
    // (never block when accept has a wildcard or the browser gave no type).
    if (accept && file.type && accept.indexOf('*') === -1) {
      var ok = accept.split(',').some(function (a) {
        a = a.trim().toLowerCase();
        return a.charAt(0) === '.'
          ? (file.name || '').toLowerCase().slice(-a.length) === a
          : file.type.toLowerCase() === a;
      });
      if (!ok) return i18n.t('docup.badType');
    }
    return null;
  }

  /** Programmatic picker: opens a dialog, validates, resolves File|null. */
  function choose(opts) {
    opts = opts || {};
    var accept = opts.accept || 'image/*,application/pdf';
    var maxMb  = opts.maxMb || 10;
    return new Promise(function (resolve) {
      var input = document.createElement('input');
      input.type = 'file';
      input.accept = accept;
      input.style.position = 'fixed';
      input.style.left = '-9999px';
      var done = false;
      function finish(val) { if (done) return; done = true;
        try { document.body.removeChild(input); } catch (e) {}
        resolve(val);
      }
      input.addEventListener('change', function () {
        var f = input.files && input.files[0];
        if (!f) { finish(null); return; }
        var err = validateFile(f, accept, maxMb);
        if (err) { toast.error(err); finish(null); return; }
        finish(f);
      });
      // Cancelled dialogs fire no 'change' — clean up on the next focus.
      window.addEventListener('focus', function onFocus() {
        window.removeEventListener('focus', onFocus);
        setTimeout(function () { finish(null); }, 400);
      }, { once: true });
      document.body.appendChild(input);
      input.click();
    });
  }

  if (!ko.components.isRegistered('doc-upload')) {

    function UploadVM(params) {
      var self = this;
      self.t        = i18n.t;
      self.inputId  = 'docup-' + (++seq);
      self.fileName = params.fileName;                 // observable | string
      self.accept   = params.accept || 'image/*,application/pdf';
      self.maxMb    = params.maxMb || 10;
      self.busy     = params.busy || ko.observable(false);
      self.disabled = params.disabled;
      self.dragOver = ko.observable(false);
      self.showView   = typeof params.onView   === 'function';
      self.showRemove = typeof params.onRemove === 'function';

      self.hasFile = ko.pureComputed(function () { return !!ko.unwrap(self.fileName); });
      self.isDisabled = function () { return !!ko.unwrap(self.disabled) || !!ko.unwrap(self.busy); };
      self.hintText = ko.pureComputed(function () {
        if (params.hint !== undefined && params.hint !== null) return ko.unwrap(params.hint);
        return self.t('docup.hint', [self.maxMb]);
      });

      function deliver(file) {
        if (!file) return;
        var err = validateFile(file, self.accept, self.maxMb);
        if (err) { toast.error(err); return; }
        if (typeof params.onPick === 'function') params.onPick(file);
      }

      self.openPicker = function () {
        if (self.isDisabled()) return false;
        var el = document.getElementById(self.inputId);
        if (el) el.click();
        return false;
      };
      self.onInputChange = function (vm, ev) {
        var f = ev.target.files && ev.target.files[0];
        ev.target.value = '';                          // allow re-picking same file
        deliver(f);
        return true;
      };
      self.onDragOver  = function () { if (self.isDisabled()) return false; self.dragOver(true);  return false; };
      self.onDragLeave = function () { self.dragOver(false); return true; };
      self.onDrop      = function (vm, ev) {
        self.dragOver(false);
        if (self.isDisabled()) return false;
        var f = ev.dataTransfer && ev.dataTransfer.files && ev.dataTransfer.files[0];
        deliver(f);
        return false;
      };
      self.doView   = function () { if (params.onView)   params.onView();   return false; };
      self.doRemove = function () { if (params.onRemove) params.onRemove(); return false; };

      self.dispose = function () {
        if (self.hasFile.dispose)  self.hasFile.dispose();
        if (self.hintText.dispose) self.hintText.dispose();
      };
    }

    ko.components.register('doc-upload', {
      viewModel: { createViewModel: function (params) { return new UploadVM(params); } },
      template:
        '<div class="docup" data-bind="css:{ \'docup--over\': dragOver, \'docup--busy\': busy, \'docup--disabled\': isDisabled() }">' +
          '<input type="file" class="docup-input" tabindex="-1" ' +
                 'data-bind="attr:{ id: inputId, accept: accept }, event:{ change: onInputChange }">' +

          '<!-- ko if: busy -->' +
            '<div class="docup-state"><span class="docup-spinner"></span>' +
              '<span data-bind="text: t(\'docup.uploading\')"></span></div>' +
          '<!-- /ko -->' +

          '<!-- ko ifnot: busy -->' +
            '<!-- ko if: hasFile -->' +
              '<div class="docup-chip">' +
                '<span class="docup-chip-ic">&#128196;</span>' +
                '<span class="docup-chip-name" data-bind="text: fileName, attr:{ title: fileName }"></span>' +
                '<span class="docup-chip-actions">' +
                  '<!-- ko if: showView -->' +
                    '<button type="button" class="btn btn-sm" data-bind="click: doView, text: t(\'docup.view\'), disable: isDisabled()"></button>' +
                  '<!-- /ko -->' +
                  '<button type="button" class="btn btn-sm" data-bind="click: openPicker, text: t(\'docup.replace\'), disable: isDisabled()"></button>' +
                  '<!-- ko if: showRemove -->' +
                    '<button type="button" class="btn btn-sm btn-danger" data-bind="click: doRemove, text: t(\'docup.remove\'), disable: isDisabled()"></button>' +
                  '<!-- /ko -->' +
                '</span>' +
              '</div>' +
            '<!-- /ko -->' +

            '<!-- ko ifnot: hasFile -->' +
              '<div class="docup-zone" tabindex="0" role="button" ' +
                   'data-bind="click: openPicker, event:{ dragover: onDragOver, dragleave: onDragLeave, drop: onDrop }">' +
                '<span class="docup-zone-ic">&#8682;</span>' +
                '<span class="docup-zone-main" data-bind="text: t(\'docup.choose\')"></span>' +
                '<span class="docup-zone-hint" data-bind="text: hintText"></span>' +
              '</div>' +
            '<!-- /ko -->' +
          '<!-- /ko -->' +
        '</div>'
    });
  }

  return { choose: choose, validateFile: validateFile, registered: true };
});
