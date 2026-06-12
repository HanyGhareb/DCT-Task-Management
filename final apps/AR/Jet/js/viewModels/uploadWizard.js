define(['knockout', 'services/arService', 'services/settingService', 'shared/i18n', 'shared/toast'],
function (ko, arService, settingService, i18n, toast) {
  'use strict';

  var MIME_BY_EXT = {
    pdf: 'application/pdf', png: 'image/png', jpg: 'image/jpeg', jpeg: 'image/jpeg',
    gif: 'image/gif', webp: 'image/webp',
    xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    xls: 'application/vnd.ms-excel',
    docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    doc: 'application/msword',
    pptx: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    pptm: 'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
    eml: 'message/rfc822', msg: 'application/vnd.ms-outlook',
    csv: 'text/csv', txt: 'text/plain',
  };

  function ext(name) {
    var m = (name || '').toLowerCase().match(/\.([a-z0-9]+)$/);
    return m ? m[1] : '';
  }

  function sha256Hex(buf) {
    return crypto.subtle.digest('SHA-256', buf).then(function (h) {
      return Array.from(new Uint8Array(h)).map(function (b) {
        return b.toString(16).padStart(2, '0');
      }).join('');
    });
  }

  /* ── client-side text renditions for formats Claude can't ingest ───── */
  function extractXlsx(file) {
    return new Promise(function (resolve) {
      require(['xlsx'], function (XLSX) {
        file.arrayBuffer().then(function (buf) {
          try {
            var wb = XLSX.read(buf, { type: 'array' });
            var out = [];
            wb.SheetNames.forEach(function (sn) {
              out.push('=== SHEET: ' + sn + ' ===');
              out.push(XLSX.utils.sheet_to_csv(wb.Sheets[sn], { blankrows: false }));
            });
            resolve(out.join('\n'));
          } catch (e) { resolve(null); }
        }).catch(function () { resolve(null); });
      }, function () { resolve(null); });
    });
  }

  function extractDocx(file) {
    return new Promise(function (resolve) {
      require(['mammoth'], function (mammoth) {
        file.arrayBuffer().then(function (buf) {
          mammoth.extractRawText({ arrayBuffer: buf })
            .then(function (res) { resolve(res.value || null); })
            .catch(function () { resolve(null); });
        }).catch(function () { resolve(null); });
      }, function () { resolve(null); });
    });
  }

  // pptx/pptm = zip of slide XML — strip tags (best effort)
  function extractPptx(file) {
    return new Promise(function (resolve) {
      require(['jszip'], function (JSZip) {
        file.arrayBuffer().then(function (buf) {
          JSZip.loadAsync(buf).then(function (zip) {
            var slides = Object.keys(zip.files)
              .filter(function (n) { return /^ppt\/slides\/slide\d+\.xml$/.test(n); })
              .sort();
            return Promise.all(slides.map(function (n) { return zip.file(n).async('string'); }));
          }).then(function (xmls) {
            var text = xmls.map(function (x, i) {
              var t = x.replace(/<a:t>([^<]*)<\/a:t>/g, '$1\n').replace(/<[^>]+>/g, ' ');
              return '=== SLIDE ' + (i + 1) + ' ===\n' + t.replace(/\s{3,}/g, '\n').trim();
            }).join('\n\n');
            resolve(text || null);
          }).catch(function () { resolve(null); });
        }).catch(function () { resolve(null); });
      }, function () { resolve(null); });
    });
  }

  function extractEml(file) {
    return file.text().then(function (t) {
      // strip base64 attachment bodies (long unbroken b64 runs)
      return t.replace(/(?:[A-Za-z0-9+/]{60,}\r?\n){5,}/g, '[attachment removed]\n');
    }).catch(function () { return null; });
  }

  function extractText(file, e) {
    if (e === 'xlsx' || e === 'xls')  return extractXlsx(file);
    if (e === 'docx')                 return extractDocx(file);
    if (e === 'pptx' || e === 'pptm') return extractPptx(file);
    if (e === 'eml')                  return extractEml(file);
    if (e === 'csv' || e === 'txt')   return file.text().catch(function () { return null; });
    return Promise.resolve(null);     // pdf/images: AI reads them natively; msg/doc: skipped
  }

  var MAX_TEXT_CHARS = 180000;

  function UploadWizardViewModel() {
    var self = this;
    self.t = i18n.t;

    var state = window._arApp.getState();
    self.eventId = state.eventId;

    self.step       = ko.observable(1);       // 1 pick → 2 preview → 3 uploading → 4 done
    self.files      = ko.observableArray([]); // { file, relPath, folder, name, ext, status }
    self.maxSizeMb  = ko.observable(25);
    self.autoRun    = ko.observable(true);
    self.uploadedOk = ko.observable(0);
    self.uploadedErr= ko.observable(0);
    self.currentMsg = ko.observable('');

    settingService.getValue('MAX_FILE_SIZE_MB').then(function (v) {
      if (v) self.maxSizeMb(parseInt(v, 10) || 25);
    });
    settingService.getValue('AUTO_CLASSIFY_ON_UPLOAD').then(function (v) {
      self.autoRun(v !== 'N');
    });

    self.folderTree = ko.computed(function () {
      var byDir = {};
      self.files().forEach(function (f) {
        (byDir[f.folder] = byDir[f.folder] || []).push(f);
      });
      return Object.keys(byDir).sort().map(function (d) {
        return { dir: d || '(root)', files: byDir[d] };
      });
    });

    self.pickFolder = function () {
      var inp = document.createElement('input');
      inp.type = 'file';
      inp.webkitdirectory = true;
      inp.multiple = true;
      inp.style.cssText = 'position:fixed;top:-9999px;left:-9999px';
      document.body.appendChild(inp);
      inp.addEventListener('change', function () {
        var list = Array.from(inp.files || []);
        document.body.removeChild(inp);
        if (!list.length) return;
        var maxBytes = self.maxSizeMb() * 1024 * 1024;
        var items = list
          .filter(function (f) { return !/(^|\/)(~\$|\.)/.test(f.webkitRelativePath); })
          .map(function (f) {
            var rel = f.webkitRelativePath || f.name;
            var parts = rel.split('/');
            parts.shift();                       // drop the picked root folder name
            var name = parts.pop() || f.name;
            return {
              file: f, name: name, ext: ext(name),
              folder: parts.join('/'),
              sizeKb: Math.round(f.size / 1024),
              tooBig: f.size > maxBytes,
              status: ko.observable(f.size > maxBytes ? 'too large — skipped' : 'ready'),
            };
          });
        self.files(items);
        self.step(2);
      });
      inp.click();
    };

    self.validCount = ko.computed(function () {
      return self.files().filter(function (f) { return !f.tooBig; }).length;
    });

    function uploadOne(f) {
      f.status('extracting…');
      return extractText(f.file, f.ext).then(function (text) {
        if (text && text.length > MAX_TEXT_CHARS) text = text.slice(0, MAX_TEXT_CHARS);
        f.status('hashing…');
        return f.file.arrayBuffer().then(function (buf) {
          return sha256Hex(buf).then(function (hash) {
            f.status('uploading…');
            return arService.createFileMeta(self.eventId, {
              folderPath: f.folder, fileName: f.name, ext: f.ext,
              mimeType: MIME_BY_EXT[f.ext] || 'application/octet-stream',
              sizeBytes: f.file.size, hash: hash,
              contentText: text || null,
            }).then(function (res) {
              if (res.duplicate) { f.status('duplicate ⚠'); }
              return arService.uploadFileContent(res.fileId, f.file).then(function () {
                if (!res.duplicate) f.status('done ✓');
                self.uploadedOk(self.uploadedOk() + 1);
              });
            });
          });
        });
      }).catch(function (err) {
        f.status('failed: ' + ((err && err.message) || 'error'));
        self.uploadedErr(self.uploadedErr() + 1);
      });
    }

    self.startUpload = function () {
      self.step(3);
      self.uploadedOk(0); self.uploadedErr(0);
      var queue = self.files().filter(function (f) { return !f.tooBig; });
      var idx = 0;
      function next() {
        if (idx >= queue.length) {
          self.step(4);
          if (self.autoRun() && self.uploadedOk() > 0) {
            self.currentMsg('Starting AI classification…');
            arService.startProcessing(self.eventId, 'BOTH').then(function () {
              toast.info('AI processing started');
            }).catch(function () {});
          }
          return;
        }
        var f = queue[idx++];
        self.currentMsg(f.name);
        uploadOne(f).then(next, next);
      }
      // two parallel lanes
      next(); if (queue.length > 1) next();
    };

    self.backToEvent = function () {
      window._arApp.navigate('eventDetail', { eventId: self.eventId, tab: 'files' });
    };
    self.reset = function () { self.files([]); self.step(1); };
  }

  return UploadWizardViewModel;
});
