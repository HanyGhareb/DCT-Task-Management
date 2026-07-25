/* AR Invoice Rebill — submit and track Fusion rebill requests.
   Single-invoice form (with a repeating line grid) + two-sheet Excel bulk
   upload (SheetJS, parsed client-side) over POST /ar/rebill/requests; the
   worker fleet drains the queue and drives the Fusion Receivables UI.

   Each request runs a 9-stage saga in Fusion: credit the invoice off in full,
   duplicate it, correct the tax classification on the nominated memo lines,
   complete the duplicate, then set Project/Task on each line. The register
   shows both generated document numbers and the per-stage timeline. */
define(['knockout', 'services/rebillService', 'shared/i18n', 'shared/toast',
        'shared/docUpload'],
function (ko, rebill, i18n, toast, docUpload) {
  'use strict';

  var CHUNK = 100;   // requests per POST (server caps at 500)

  // ONE flat sheet, grouped by invoice number (user format 2026-07-26): each
  // row is a LINE; the MEMO LINE is the matching key (no line numbers). The
  // last two columns are RESULT columns — a row whose invoice already carries
  // a CM/new-invoice number is done and is skipped, so the same running
  // workbook can be re-uploaded as it fills up.
  var FLAT_HEADERS = {
    INVOICE_NO: 'invoiceNumber', INVOICE_NUMBER: 'invoiceNumber',
    MEMO_LINE: 'memoLine',
    PROJECT: 'projectNumber', PROJECT_NO: 'projectNumber',
    PROJECT_NUMBER: 'projectNumber',
    TASK: 'taskNumber', TASK_NO: 'taskNumber', TASK_NUMBER: 'taskNumber',
    VAT_RATE_CODE: 'taxClassification',
    TAX_CLASSIFICATION: 'taxClassification', TAX_CLASS: 'taxClassification',
    LINE: 'lineNumber', LINE_NO: 'lineNumber', LINE_NUMBER: 'lineNumber',
    CM_NUMBER: 'cmResult', NEW_INVOICE_NUMBER: 'invResult',
    // per-invoice header details (optional; read from the invoice's FIRST
    // non-empty cell, falling back to the on-page batch defaults)
    CM_TXN_NO: 'cmTransactionNumber', CM_TRANSACTION_NUMBER: 'cmTransactionNumber',
    CM_TXN_DATE: 'cmTransactionDate', CM_TRANSACTION_DATE: 'cmTransactionDate',
    CM_ACCT_DATE: 'cmAccountingDate', CM_ACCOUNTING_DATE: 'cmAccountingDate',
    CREDIT_REASON: 'creditReason',
    COMMENTS: 'comments',
    CM_FINISH: 'cmFinish', FINISH: 'cmFinish',
    DUP_SOURCE: 'dupSource', DUPLICATE_SOURCE: 'dupSource',
    TRANSACTION_SOURCE: 'dupSource',
    DUP_TXN_DATE: 'dupTransactionDate', DUPLICATE_TRANSACTION_DATE: 'dupTransactionDate',
    DUP_ACCT_DATE: 'dupAccountingDate', DUPLICATE_ACCOUNTING_DATE: 'dupAccountingDate'
  };
  var FLAT_TEMPLATE = ['Invoice Number', 'Memo Line', 'Project Number', 'Task',
                       'VAT Rate Code', 'CM Number', 'New Invoice Number',
                       'CM_TXN_NO', 'CM_TXN_DATE', 'CM_ACCT_DATE',
                       'CREDIT_REASON', 'COMMENTS', 'CM_FINISH',
                       'DUP_SOURCE', 'DUP_TXN_DATE', 'DUP_ACCT_DATE'];
  // keys the per-invoice header can override from the sheet
  var HDR_KEYS = ['cmTransactionNumber', 'cmTransactionDate', 'cmAccountingDate',
                  'creditReason', 'comments', 'cmFinish',
                  'dupSource', 'dupTransactionDate', 'dupAccountingDate'];

  function normHeader(h) {
    return String(h || '').toUpperCase().trim()
      .replace(/[^A-Z0-9]+/g, '_').replace(/^_+|_+$/g, '');
  }

  // Dates travel as ISO YYYY-MM-DD; the runner converts to Fusion's dd/mm/yyyy
  // at fill time. Excel may hand back a Date or a dd/mm/yyyy string.
  function toIso(v) {
    if (v === null || v === undefined || v === '') { return ''; }
    if (v instanceof Date && !isNaN(v)) {
      return v.getFullYear() + '-' +
             String(v.getMonth() + 1).padStart(2, '0') + '-' +
             String(v.getDate()).padStart(2, '0');
    }
    var s = String(v).trim();
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) { return s; }
    var m = s.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
    if (m) { return m[3] + '-' + m[2] + '-' + m[1]; }
    return s;                                   // let the server reject it
  }

  return function ArRebill() {
    var self = this;
    self.t = i18n.t;

    self.statusClass = function (s) {
      return 'rstat rstat--' + String(s || '').toUpperCase();
    };

    self.fmtDur = function (secs) {
      if (secs === null || secs === undefined || secs === '') { return '—'; }
      var s = Math.max(0, Math.round(Number(secs)));
      if (s < 60) { return s + 's'; }
      var m = Math.floor(s / 60);
      if (m < 60) { return m + 'm ' + (s % 60) + 's'; }
      return Math.floor(m / 60) + 'h ' + String(m % 60).padStart(2, '0') + 'm';
    };

    // ---------------- value sets (lookup-first; extend in Admin, no deploy) --
    self.creditReasons = ko.observableArray([]);
    self.taxClasses    = ko.observableArray([]);
    self.finishModes   = ko.observableArray([]);
    self.lovLabel = function (o) {
      return i18n.lang && i18n.lang() === 'ar' ? (o.nameAr || o.nameEn) : o.nameEn;
    };

    // ---------------- single request ----------------
    var today = new Date();
    var isoToday = today.getFullYear() + '-' +
                   String(today.getMonth() + 1).padStart(2, '0') + '-' +
                   String(today.getDate()).padStart(2, '0');

    self.fInvoice   = ko.observable('');
    self.fCmNumber  = ko.observable('');
    self.fCmTxnDate = ko.observable(isoToday);
    self.fCmAcctDate = ko.observable(isoToday);
    self.fCreditReason = ko.observable('');
    self.fComments  = ko.observable('');
    self.fCmFinish  = ko.observable('COMPLETE_AND_CLOSE');
    self.fDupSource = ko.observable('DCT Manual');
    self.fDupTxnDate = ko.observable(isoToday);
    self.fDupAcctDate = ko.observable(isoToday);
    self.singleBusy = ko.observable(false);

    // the CM number defaults to <invoice>CM but stays editable
    self.cmNumberPlaceholder = ko.computed(function () {
      var inv = (self.fInvoice() || '').trim();
      return inv ? inv + 'CM' : 'INV00583863CM';
    });

    self.lines = ko.observableArray([]);
    self.addLine = function () {
      self.lines.push({
        lineNumber: ko.observable(''),
        memoLine: ko.observable(''),
        taxClassification: ko.observable(''),
        projectNumber: ko.observable(''),
        taskNumber: ko.observable('')
      });
    };
    self.removeLine = function (row) { self.lines.remove(row); };
    self.addLine();

    function collectLines() {
      return self.lines().map(function (l) {
        return {
          lineNumber: (l.lineNumber() || '').toString().trim(),
          memoLine: (l.memoLine() || '').trim(),
          taxClassification: (l.taxClassification() || '').trim(),
          projectNumber: (l.projectNumber() || '').trim(),
          taskNumber: (l.taskNumber() || '').trim()
        };
      }).filter(function (l) {
        return l.lineNumber || l.memoLine || l.projectNumber || l.taskNumber;
      });
    }

    self.resetForm = function () {
      self.fInvoice(''); self.fCmNumber(''); self.fComments('');
      self.lines([]); self.addLine();
    };

    self.submitSingle = function () {
      var inv = (self.fInvoice() || '').trim();
      var lines = collectLines();
      if (!inv) { toast.error(self.t('ar.rebill.err.invoiceRequired')); return; }
      if (!lines.length) { toast.error(self.t('ar.rebill.err.linesRequired')); return; }
      for (var i = 0; i < lines.length; i++) {
        // memo line is the matching key; line number is optional
        if (!lines[i].memoLine || !lines[i].projectNumber ||
            !lines[i].taskNumber) {
          toast.error(self.t('ar.rebill.err.lineIncomplete', [i + 1]));
          return;
        }
      }
      self.singleBusy(true);
      rebill.enqueue([buildRow({
        invoiceNumber: inv,
        cmTransactionNumber: (self.fCmNumber() || '').trim(),
        cmTransactionDate: self.fCmTxnDate(),
        cmAccountingDate: self.fCmAcctDate(),
        creditReason: self.fCreditReason(),
        comments: self.fComments(),
        cmFinish: self.fCmFinish(),
        dupSource: self.fDupSource(),
        dupTransactionDate: self.fDupTxnDate(),
        dupAccountingDate: self.fDupAcctDate()
      }, lines)])
        .then(function (r) {
          var it = (r.items || [])[0] || {};
          if (it.status === 'ERROR') {
            toast.error(it.error || self.t('ar.rebill.err.failed'));
          } else {
            toast.success(self.t('ar.rebill.enqueuedOne', [it.actionId]));
            self.resetForm();
          }
          self.singleBusy(false);
          self.loadRegister();
        })
        .catch(function () { self.singleBusy(false); });
    };

    // header + lines -> the API row shape
    function buildRow(h, lines) {
      return {
        invoiceNumber: h.invoiceNumber,
        cm: {
          transactionNumber: h.cmTransactionNumber || (h.invoiceNumber + 'CM'),
          transactionDate: toIso(h.cmTransactionDate),
          accountingDate: toIso(h.cmAccountingDate),
          creditReason: h.creditReason || '',
          comments: h.comments || '',
          finish: (h.cmFinish || 'COMPLETE_AND_CLOSE').toUpperCase()
        },
        duplicate: {
          transactionSource: h.dupSource || 'DCT Manual',
          transactionDate: toIso(h.dupTransactionDate),
          accountingDate: toIso(h.dupAccountingDate)
        },
        lines: lines.map(function (l) {
          // the memo line is the matching key; lineNumber is an optional hint
          var out = {
            memoLine: l.memoLine,
            taxClassification: l.taxClassification || '',
            projectNumber: l.projectNumber,
            taskNumber: l.taskNumber
          };
          if (l.lineNumber) { out.lineNumber = Number(l.lineNumber); }
          return out;
        })
      };
    }

    // ---------------- bulk upload (ONE flat sheet, grouped by invoice) -----
    self.bulkRows = ko.observableArray([]);      // one entry per INVOICE
    self.bulkFileName = ko.observable('');
    self.bulkBusy = ko.observable(false);
    // Batch defaults applied to every uploaded invoice: the sheet carries only
    // the per-line data, so the CM/duplicate header comes from here (same date
    // on all four date fields, auto-generated comments, source DCT Manual).
    self.bulkDate   = ko.observable(isoToday);
    self.bulkReason = ko.observable('Tax rate error');
    self.bulkFinish = ko.observable('COMPLETE_AND_CLOSE');
    self.bulkValidCount = ko.computed(function () {
      return self.bulkRows().filter(function (r) { return !r.error && !r.done; }).length;
    });
    self.bulkErrorCount = ko.computed(function () {
      return self.bulkRows().filter(function (r) { return !!r.error; }).length;
    });
    self.bulkDoneCount = ko.computed(function () {
      return self.bulkRows().filter(function (r) { return !!r.done; }).length;
    });

    function sheetRows(XLSX, wb, map) {
      var name = wb.SheetNames[0];
      if (!name) { return null; }
      var aoa = XLSX.utils.sheet_to_json(wb.Sheets[name],
                  { header: 1, raw: false, defval: '' });
      if (!aoa.length) { return []; }
      var keys = aoa[0].map(function (h) { return map[normHeader(h)] || null; });
      if (keys.indexOf('invoiceNumber') < 0 || keys.indexOf('memoLine') < 0) {
        return null;                       // not the rebill sheet
      }
      var out = [];
      for (var i = 1; i < aoa.length; i++) {
        var src = aoa[i];
        if (!src.some(function (c) { return String(c || '').trim() !== ''; })) { continue; }
        var r = {};
        keys.forEach(function (k, j) {
          if (k && String(src[j] || '').trim() !== '') { r[k] = String(src[j]).trim(); }
        });
        if (Object.keys(r).length) { out.push(r); }
      }
      return out;
    }

    function parseWorkbook(XLSX, buf) {
      var wb = XLSX.read(buf, { type: 'array', cellDates: true });
      var lns = sheetRows(XLSX, wb, FLAT_HEADERS);
      if (lns === null) { throw new Error(self.t('ar.rebill.bulk.needCols')); }
      if (!lns.length) { return []; }

      // group rows by invoice, preserving first-seen order
      var byInv = {}, order = [];
      lns.forEach(function (l) {
        var k = (l.invoiceNumber || '').toUpperCase();
        if (!k) { return; }
        if (!byInv[k]) { byInv[k] = []; order.push(k); }
        byInv[k].push(l);
      });

      var iso = toIso(self.bulkDate());
      return order.map(function (key, idx) {
        var lines = byInv[key];
        var inv = lines[0].invoiceNumber;
        // result columns filled = this invoice is already done — skip it so
        // the running workbook can be re-uploaded whole
        var done = lines.some(function (l) { return l.cmResult || l.invResult; });
        var err = '';
        if (!done) {
          for (var i = 0; i < lines.length; i++) {
            if (!lines[i].memoLine || !lines[i].projectNumber ||
                !lines[i].taskNumber) {
              err = self.t('ar.rebill.bulk.lineIncomplete', [i + 1]);
              break;
            }
          }
        }
        // per-invoice header details: first non-empty cell in the group wins,
        // the batch defaults below fill whatever the sheet leaves blank
        var h = { invoiceNumber: inv };
        HDR_KEYS.forEach(function (k) {
          for (var j = 0; j < lines.length; j++) {
            if (lines[j][k]) { h[k] = lines[j][k]; return; }
          }
        });
        h.cmTransactionDate = toIso(h.cmTransactionDate) || iso;
        h.cmAccountingDate = toIso(h.cmAccountingDate) || iso;
        h.dupTransactionDate = toIso(h.dupTransactionDate) || iso;
        h.dupAccountingDate = toIso(h.dupAccountingDate) || iso;
        h.creditReason = h.creditReason || self.bulkReason() || '';
        h.comments = h.comments || ('Credit Inv# ' + inv + ' to correct TAX code');
        h.cmFinish = (h.cmFinish || self.bulkFinish() || 'COMPLETE_AND_CLOSE').toUpperCase();
        h.dupSource = h.dupSource || 'DCT Manual';
        return {
          row: idx + 1,
          invoiceNumber: inv,
          lineCount: lines.length,
          cmFinish: h.cmFinish,
          _h: h,
          _lines: lines,
          error: err, done: done, status: ''
        };
      });
    }

    self.chooseFile = function () {
      docUpload.choose({ accept: '.xlsx,.xls', maxMb: 10 }).then(function (file) {
        if (!file) { return; }
        file.arrayBuffer().then(function (buf) {
          require(['xlsx'], function (XLSX) {
            try {
              var rows = parseWorkbook(XLSX, buf);
              if (!rows.length) { toast.error(self.t('ar.rebill.bulk.noRows')); return; }
              self.bulkFileName(file.name);
              self.bulkRows(rows);
              toast.success(self.t('ar.rebill.bulk.parsed', [rows.length]));
            } catch (e) { toast.error(e.message || String(e)); }
          }, function () { toast.error(self.t('ar.rebill.bulk.libFail')); });
        });
      });
    };

    self.downloadTemplate = function () {
      require(['xlsx'], function (XLSX) {
        var wb = XLSX.utils.book_new();
        // one flat sheet, rows grouped by invoice. Columns 6-7 are RESULT
        // columns (filled once the request completes); the header-detail
        // columns after them are optional per-invoice overrides read from the
        // invoice's first row — blank cells fall back to the batch defaults.
        var ws = XLSX.utils.aoa_to_sheet([FLAT_TEMPLATE,
          ['INV00583863', 'Entertainer Permit', '4511000037',
           'Entertainer Permit', 'VAT OUTPUT - OSC', '', '',
           'INV00583863CM', '2026-02-28', '2026-02-28', 'Tax rate error',
           'Credit Inv# INV00583863 to correct TAX code', 'COMPLETE_AND_CLOSE',
           'DCT Manual', '2026-02-28', '2026-02-28'],
          ['INV00583863', 'Revenue fees from Urgent request', '4511000037',
           'Urgent requests', 'VAT OUTPUT - STD', '', '',
           '', '', '', '', '', '', '', '', '']]);
        ws['!cols'] = FLAT_TEMPLATE.map(function (h) {
          return { wch: Math.max(h.length + 2, 18) };
        });
        XLSX.utils.book_append_sheet(wb, ws, 'Rebill');
        XLSX.writeFile(wb, 'ar_invoice_rebill_template.xlsx');
      }, function () { toast.error(self.t('ar.rebill.bulk.libFail')); });
    };

    self.clearBulk = function () { self.bulkRows([]); self.bulkFileName(''); };

    self.submitBulk = function () {
      var all = self.bulkRows();
      var valid = all.filter(function (r) { return !r.error && !r.done; });
      if (!valid.length || self.bulkBusy()) { return; }
      self.bulkBusy(true);

      var chunks = [];
      for (var i = 0; i < valid.length; i += CHUNK) {
        chunks.push(valid.slice(i, i + CHUNK));
      }

      var done = 0, failed = 0;
      var seq = Promise.resolve();
      chunks.forEach(function (chunk) {
        seq = seq.then(function () {
          return rebill.enqueue(chunk.map(function (r) {
            return buildRow(r._h, r._lines);
          })).then(function (res) {
            (res.items || []).forEach(function (it, j) {
              // replace the row object — KO foreach skips re-render on an
              // identical reference, so in-place mutation never shows
              var r = chunk[j], upd;
              if (it.status === 'ERROR') {
                upd = Object.assign({}, r, { error: it.error || 'ERROR' });
                failed++;
              } else {
                upd = Object.assign({}, r, {
                  status: it.status + (it.actionId ? ' #' + it.actionId : '')
                });
                done++;
              }
              all[all.indexOf(r)] = upd;
              chunk[j] = upd;
            });
            self.bulkRows(all.slice());
          });
        });
      });
      seq.then(function () {
        self.bulkBusy(false);
        if (failed) { toast.error(self.t('ar.rebill.bulk.doneSome', [done, failed])); }
        else { toast.success(self.t('ar.rebill.bulk.doneAll', [done])); }
        self.loadRegister();
      }).catch(function () {
        self.bulkBusy(false);
        self.bulkRows(all.slice());
        self.loadRegister();
      });
    };

    // ---------------- register ----------------
    self.rows = ko.observableArray([]);
    self.loading = ko.observable(true);
    self.total = ko.observable(0);
    self.limit = ko.observable(25);
    self.offset = ko.observable(0);
    self.fStatus = ko.observable('');
    self.fSearch = ko.observable('');

    self.loadRegister = function () {
      self.loading(true);
      rebill.list({
        status: self.fStatus(), search: self.fSearch(),
        limit: self.limit(), offset: self.offset()
      }).then(function (r) {
        self.rows(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.applyFilters = function () { self.offset(0); self.loadRegister(); };
    self.nextPage = function () {
      if (self.offset() + self.limit() < self.total()) {
        self.offset(self.offset() + self.limit()); self.loadRegister();
      }
    };
    self.prevPage = function () {
      if (self.offset() > 0) {
        self.offset(Math.max(0, self.offset() - self.limit())); self.loadRegister();
      }
    };

    // ---------------- stage timeline (drawer) ----------------
    self.detail = ko.observable(null);
    self.detailOpen = ko.observable(false);
    self.detailLoading = ko.observable(false);
    self.openDetail = function (row) {
      self.detailOpen(true);
      self.detailLoading(true);
      self.detail(null);
      rebill.get(row.actionId).then(function (d) {
        self.detail(d);
        self.detailLoading(false);
      }).catch(function () { self.detailLoading(false); });
    };
    self.closeDetail = function () { self.detailOpen(false); self.detail(null); };
    self.stageLabel = function (s) {
      return i18n.lang && i18n.lang() === 'ar' ? (s.labelAr || s.labelEn) : s.labelEn;
    };

    // ---------------- init ----------------
    rebill.lovs().then(function (r) {
      self.creditReasons(r.creditReasons || []);
      self.taxClasses(r.taxClassifications || []);
      self.finishModes(r.cmFinish || []);
      var def = (r.creditReasons || []).filter(function (o) {
        return o.isDefault === 'Y';
      })[0];
      if (def && !self.fCreditReason()) { self.fCreditReason(def.code); }
    }).catch(function () {});

    self.loadRegister();
  };
});
