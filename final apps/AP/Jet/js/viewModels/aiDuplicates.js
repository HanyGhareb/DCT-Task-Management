/**
 * aiDuplicates.js — AI Duplicate Check page (App 212).
 *
 * Full page over POST /ap/benef/dupcheck (run + persist), GET
 * /ap/benef/dupcheck/last (instant reload of the latest saved run) and GET
 * /ap/benef/dupinvoices (invoice drill behind every count — group, member,
 * shared account, shared-account vendor; invoice numbers deep-link to Fusion).
 * Generate-report buttons enqueue the Reporting-Platform definition
 * AP_BENEF_DUP_REGISTER via POST /ap/benef/dupreport (PDF book / Excel
 * register), polling until the file downloads — same pattern as the GL
 * Budget Utilization reports.
 */
define(['knockout', 'services/api', 'shared/i18n', 'shared/toast', 'shared/fusionLinks'],
function (ko, api, i18n, toast, fusion) {
  'use strict';

  var SUPPNUM = '26553';
  var FP = 'ap-';

  function AiDuplicatesViewModel() {
    var self = this;
    var lt = function (k, p) { return i18n.t(k, p); };
    self.t = lt;

    var NF2 = new Intl.NumberFormat('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    var NF0 = new Intl.NumberFormat('en-US');
    self.fmtAmt = function (v) { return v == null ? '' : NF2.format(v); };
    self.fmtInt = function (v) { return v == null ? '' : NF0.format(v); };
    function today() { return new Date().toISOString().slice(0, 10); }
    function downloadBlobUrl(url, name) {
      var a = document.createElement('a');
      a.href = url; a.download = name;
      document.body.appendChild(a); a.click(); a.remove();
      setTimeout(function () { try { URL.revokeObjectURL(url); } catch (e) {} }, 20000);
    }

    // ── analysis state ──────────────────────────────────────────────────
    self.aiLoading = ko.observable(false);      // AI run in flight
    self.loadingLast = ko.observable(true);     // initial GET .../last
    self.aiError   = ko.observable('');
    self.aiMeta    = ko.observable(null);
    self.aiGroups  = ko.observableArray([]);
    self.aiShared  = ko.observableArray([]);
    self.neverRan  = ko.observable(false);

    function applyResult(d) {
      var groups = (d.groups || []).slice()
        .sort(function (a, b) { return (b.totalAed || 0) - (a.totalAed || 0); });
      self.aiGroups(groups);
      self.aiShared(d.sharedAccounts || []);
      self.aiMeta({
        analyzed: d.analyzed, groupCount: d.groupCount,
        provider: d.provider, model: d.model,
        fellback: d.fellback === 'Y', elapsedSecs: d.elapsedSecs,
        sharedCount: d.sharedAccountCount || 0, sharedShown: d.sharedShown || 0,
        runId: d.runId, ranAt: d.ranAt, ranBy: d.ranBy
      });
      self.neverRan(false);
    }

    // last saved run loads instantly — the AI re-run is an explicit action
    api.get('/benef/dupcheck/last?suppnum=' + SUPPNUM).then(function (d) {
      self.loadingLast(false);
      if (!d || d.runId == null) { self.neverRan(true); return; }
      applyResult(d);
    }).catch(function (e) {
      self.loadingLast(false);
      self.aiError((e && e.message) || lt('msg.error'));
    });

    self.runAiDup = function () {
      if (self.aiLoading()) return;
      self.aiLoading(true); self.aiError('');
      api.post('/benef/dupcheck?suppnum=' + SUPPNUM, {}).then(function (d) {
        applyResult(d);
        self.aiLoading(false);
      }).catch(function (e) {
        self.aiLoading(false);
        self.aiError((e && e.message) || lt('msg.error'));
      });
    };

    self.aiConfCls = function (c) {
      return c >= 0.85 ? 'badge badge--success' : (c >= 0.6 ? 'badge badge--warn' : 'badge badge--idle');
    };
    self.aiConfTxt = function (c) { return Math.round((c || 0) * 100) + '%'; };
    self.aiMetaTxt = ko.pureComputed(function () {
      var m = self.aiMeta();
      if (!m) return '';
      return lt('ai.meta', [self.fmtInt(m.analyzed), self.fmtInt(m.groupCount)])
        + ' · ' + lt('ai.metaShared', [self.fmtInt(m.sharedCount)])
        + ' · ' + m.model + (m.fellback ? ' (' + lt('ai.fellback') + ')' : '')
        + ' · ' + m.elapsedSecs + 's';
    });
    self.aiRunTxt = ko.pureComputed(function () {
      var m = self.aiMeta();
      if (!m || !m.ranAt) return '';
      return lt('ai.lastRun', [m.ranAt, m.ranBy || '—']);
    });
    self.aiSharedTrunc = ko.pureComputed(function () {
      var m = self.aiMeta();
      return (m && m.sharedCount > m.sharedShown)
        ? lt('ai.sharedTrunc', [self.fmtInt(m.sharedShown), self.fmtInt(m.sharedCount)]) : '';
    });

    // ── invoice drill drawer (any count → the invoices behind it) ───────
    self.dwOpen    = ko.observable(false);
    self.dwLoading = ko.observable(false);
    self.dwTitle   = ko.observable('');
    self.dwSub     = ko.observable('');
    self.dwRows    = ko.observableArray([]);
    self.dwCount   = ko.observable(0);
    self.dwTotal   = ko.observable(0);
    self.invUrl    = fusion.invoice;   // Fusion deep link (invoiceId)

    function openDrill(qs, title, sub) {
      self.dwTitle(title); self.dwSub(sub || '');
      self.dwRows([]); self.dwCount(0); self.dwTotal(0);
      self.dwOpen(true); self.dwLoading(true);
      api.get('/benef/dupinvoices?' + qs).then(function (d) {
        self.dwRows(d.items || []);
        self.dwCount(d.count || 0);
        self.dwTotal(d.totalAed || 0);
        self.dwLoading(false);
      }).catch(function (e) {
        self.dwLoading(false);
        toast.error((e && e.message) || lt('msg.error'));
      });
    }
    self.closeDw = function () { self.dwOpen(false); };

    self.drillGroup = function (g) {
      var m = self.aiMeta() || {};
      openDrill('runid=' + m.runId + '&grp=' + g.groupNo + '&suppnum=' + SUPPNUM,
        lt('ai.dwGroup', [g.groupNo]), g.canonical);
    };
    self.drillMember = function (m) {
      openDrill('name=' + encodeURIComponent(m.name) + '&suppnum=' + SUPPNUM,
        lt('ai.dwVendor'), m.name);
    };
    self.drillAccount = function (a) {
      openDrill('bank=' + encodeURIComponent(a.bankAccount),
        lt('ai.dwAccount'), a.bankAccount + ' · ' + self.fmtInt(a.vendorCount) + ' ' + lt('ai.colVendors'));
    };
    self.drillVendorAccount = function (a, v) {
      openDrill('bank=' + encodeURIComponent(a.bankAccount) + '&name=' + encodeURIComponent(v.name),
        lt('ai.dwVendor'), v.name + ' · ' + a.bankAccount);
    };

    self.dwExportCsv = function () {
      var rows = self.dwRows();
      if (!rows.length) return;
      var esc = function (v) { return '"' + ('' + (v == null ? '' : v)).replace(/"/g, '""') + '"'; };
      var L = [[lt('tbl.invoiceNo'), lt('tbl.date'), lt('ai.colVendor'), lt('ben.suppNo'),
                lt('dr.site'), lt('f.bu'), lt('tbl.amountAed'), lt('tbl.paidAmt'),
                lt('tbl.status'), lt('ai.colAccounts')].map(esc).join(',')];
      rows.forEach(function (r) {
        L.push([r.invoiceNumber, r.invoiceDate, r.name, r.supplierNumber, r.site, r.businessUnit,
                r.amountAed, r.paymentStatus, r.invoiceStatus, r.bankAccounts].map(esc).join(','));
      });
      L.push([lt('dw.total'), '', '', '', '', '', self.dwTotal(), '', '', ''].map(esc).join(','));
      var blob = new Blob(['﻿' + L.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      downloadBlobUrl(URL.createObjectURL(blob), FP + 'dup-invoices-' + today() + '.csv');
    };

    // ── generate report (Reporting Platform, GL-butil pattern) ──────────
    self.rptBusy  = ko.observable('');          // '', 'PDF', 'XLSX'
    self.rptLabel = ko.observable('');
    var rptTimer = null;

    function pollReport(runId, fmt) {
      rptTimer = setTimeout(function () {
        api.get('/benef/dupreport/' + runId).then(function (st) {
          if (st.status === 'SUCCESS' && st.hasFile) {
            api.fetchBlobUrl('/benef/dupreport/' + runId + '/file').then(function (url) {
              downloadBlobUrl(url, FP + 'duplicate-vendors-' + today() + (fmt === 'PDF' ? '.pdf' : '.xlsx'));
              self.rptBusy(''); self.rptLabel('');
              toast.success(lt('ai.rptDone', [fmt]));
            });
          } else if (st.status === 'FAILED') {
            self.rptBusy(''); self.rptLabel('');
            toast.error(lt('ai.rptFailed', [(st.error || '').slice(0, 160)]));
          } else {
            pollReport(runId, fmt);
          }
        }).catch(function () { pollReport(runId, fmt); });
      }, 5000);
    }
    self.runReport = function (fmt) {
      if (self.rptBusy()) return;
      self.rptBusy(fmt); self.rptLabel(lt('ai.rptRunning', [fmt]));
      api.post('/benef/dupreport', { format: fmt, suppnum: SUPPNUM }).then(function (r) {
        pollReport(r.runId, fmt);
      }).catch(function (e) {
        self.rptBusy(''); self.rptLabel('');
        toast.error((e && e.message) || lt('msg.error'));
      });
    };
    self.runPdf  = function () { self.runReport('PDF'); };
    self.runXlsx = function () { self.runReport('XLSX'); };

    // ── CSV of the on-page results (groups + shared accounts) ───────────
    self.aiExportCsv = function () {
      var groups = self.aiGroups(), shared = self.aiShared();
      if (!groups.length && !shared.length) return;
      var esc = function (v) { return '"' + ('' + (v == null ? '' : v)).replace(/"/g, '""') + '"'; };
      var L = [[lt('ai.colGroup'), lt('ai.colCanonical'), lt('ai.colConf'), lt('ai.colReason'),
                lt('ben.name'), lt('dr.site'), lt('ai.colAccounts'), lt('ai.colInvs'),
                lt('tbl.amountAed'), lt('ai.colFirst'), lt('ai.colLast')].map(esc).join(',')];
      groups.forEach(function (g, gi) {
        (g.members || []).forEach(function (m) {
          L.push([gi + 1, g.canonical, self.aiConfTxt(g.confidence), g.reason,
                  m.name, m.site, m.bankAccounts, m.invoices, m.totalAed,
                  m.firstInvoice, m.lastInvoice].map(esc).join(','));
        });
      });
      if (shared.length) {
        L.push('');
        L.push(esc(lt('ai.sharedTitle')));
        L.push([lt('ai.colAccount'), lt('ai.colVendor'), lt('ben.suppNo'), lt('dr.site'),
                lt('ai.colInvs'), lt('tbl.amountAed'), lt('ai.colFirst'), lt('ai.colLast')]
               .map(esc).join(','));
        shared.forEach(function (a) {
          (a.vendors || []).forEach(function (v) {
            L.push([a.bankAccount, v.name, v.supplierNumber, v.site,
                    v.invoices, v.totalAed, v.firstInvoice, v.lastInvoice]
                   .map(esc).join(','));
          });
        });
      }
      var blob = new Blob(['﻿' + L.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      downloadBlobUrl(URL.createObjectURL(blob), FP + 'ai-duplicates-' + today() + '.csv');
    };

    // one document-level Esc handler; replace any previous mount's listener
    if (window.__apAiDupEsc) document.removeEventListener('keydown', window.__apAiDupEsc);
    window.__apAiDupEsc = function (e) {
      if (e.key === 'Escape' && self.dwOpen()) self.closeDw();
    };
    document.addEventListener('keydown', window.__apAiDupEsc);
  }

  return AiDuplicatesViewModel;
});
