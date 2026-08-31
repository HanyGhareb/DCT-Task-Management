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

    // ── run criteria (applied to the NEXT run; defaults = the strict run) ─
    self.critFab  = ko.observable(false);       // include FAB DEBIT CARD vendors
    self.critCxl  = ko.observable(false);       // include cancelled invoices
    self.critFrom = ko.observable('');          // invoice created from (YYYY-MM-DD)
    self.critTo   = ko.observable('');          // invoice created to
    self.toggleCritFab = function () { self.critFab(!self.critFab()); return true; };
    self.toggleCritCxl = function () { self.critCxl(!self.critCxl()); return true; };

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
        runId: d.runId, ranAt: d.ranAt, ranBy: d.ranBy,
        inclFab: d.inclFab === 'Y', inclCxl: d.inclCxl === 'Y',
        createdFrom: d.createdFrom || '', createdTo: d.createdTo || ''
      });
      // reflect the loaded run's criteria in the criteria controls
      self.critFab(d.inclFab === 'Y');
      self.critCxl(d.inclCxl === 'Y');
      self.critFrom(d.createdFrom || '');
      self.critTo(d.createdTo || '');
      self.neverRan(false);
    }

    // "FAB card vendors excluded · Cancelled excluded · Created 2026-01-01 → …"
    self.critLine = ko.pureComputed(function () {
      var m = self.aiMeta();
      if (!m) return '';
      var parts = [
        lt('ai.critFab')  + ' ' + lt(m.inclFab ? 'ai.included' : 'ai.excluded'),
        lt('ai.critCxl')  + ' ' + lt(m.inclCxl ? 'ai.included' : 'ai.excluded')
      ];
      if (m.createdFrom || m.createdTo) {
        parts.push(lt('ai.critCreated') + ' ' + (m.createdFrom || '…') + ' → ' + (m.createdTo || '…'));
      }
      return lt('ai.criteria') + ': ' + parts.join(' · ');
    });

    // ── reason-category sections (user 2026-08-12: related cases with the
    //    same kind of reason are grouped together under their own section).
    //    reasonType comes from the server (dct_ap_ai_pkg.reason_type — the
    //    single source of truth); the client mirror below only covers a
    //    stale pre-deploy envelope that lacks the field.
    var RT_ORDER = ['SPELLING', 'TRANSLITERATION', 'SPACING', 'CAPITALISATION',
                    'WORD_ORDER', 'TYPO', 'ABBREVIATION', 'PARTIAL_NAME',
                    'COMPANY_SUFFIX', 'NAME_VARIATION', 'SHARED_ACCOUNT', 'OTHER'];
    function classifyReason(t) {
      var r = (t || '').toLowerCase();
      if (!r) return 'OTHER';
      if (r.indexOf('translit') >= 0) return 'TRANSLITERATION';
      if (r.indexOf('spell') >= 0) return 'SPELLING';
      if (r.indexOf('space') >= 0 || r.indexOf('spacing') >= 0) return 'SPACING';
      if (r.indexOf('capitalis') >= 0 || r.indexOf('capitaliz') >= 0 || r.indexOf('case') >= 0) return 'CAPITALISATION';
      if (r.indexOf('order') >= 0 || r.indexOf('swap') >= 0 || r.indexOf('reversed') >= 0) return 'WORD_ORDER';
      if (r.indexOf('typo') >= 0) return 'TYPO';
      if (r.indexOf('abbrev') >= 0 || r.indexOf('initial') >= 0 || r.indexOf('acronym') >= 0) return 'ABBREVIATION';
      if (r.indexOf('missing') >= 0 || r.indexOf('partial') >= 0 || r.indexOf('middle name') >= 0 ||
          r.indexOf('truncat') >= 0 || r.indexOf('subset') >= 0 || r.indexOf('shortened') >= 0) return 'PARTIAL_NAME';
      if (r.indexOf('suffix') >= 0 || r.indexOf('llc') >= 0 || r.indexOf('l.l.c') >= 0) return 'COMPANY_SUFFIX';
      if (r.indexOf('variation') >= 0 || r.indexOf('variant') >= 0 ||
          r.indexOf('duplicate') >= 0 || r.indexOf('identical') >= 0 ||
          r.indexOf('same name') >= 0) return 'NAME_VARIATION';
      if (r.indexOf('account') >= 0 || r.indexOf('iban') >= 0 || r.indexOf('bank') >= 0) return 'SHARED_ACCOUNT';
      return 'OTHER';
    }
    self.rtLabel = function (code) { return lt('ai.rt.' + code); };
    self.dupSections = ko.pureComputed(function () {
      var by = {};
      self.aiGroups().forEach(function (g) {
        var code = g.reasonType || classifyReason(g.reason);
        if (RT_ORDER.indexOf(code) < 0) code = 'OTHER';
        if (!by[code]) by[code] = { code: code, groups: [], invoices: 0, totalAed: 0 };
        by[code].groups.push(g);
        by[code].invoices += g.invoices || 0;
        by[code].totalAed += g.totalAed || 0;
      });
      // sections in the fixed vocabulary order; groups inside keep the
      // amount-desc sort applied in applyResult
      return RT_ORDER.filter(function (c) { return by[c]; })
                     .map(function (c) { return by[c]; });
    });

    // ── short explanation per finding ───────────────────────────────────
    self.groupWhy = function (g) {
      return lt('ai.why') + ' ' + (g.reason || lt('ai.whyFallback', [self.aiConfTxt(g.confidence)]));
    };
    self.sharedWhy = function (a) {
      return lt('ai.why') + ' ' + lt('ai.sharedWhy',
        [self.fmtInt(a.vendorCount), self.fmtInt(a.invoices)]);
    };

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
      var qs = '/benef/dupcheck?suppnum=' + SUPPNUM
             + '&inclfab=' + (self.critFab() ? 'Y' : 'N')
             + '&inclcxl=' + (self.critCxl() ? 'Y' : 'N')
             + (self.critFrom() ? '&createdfrom=' + encodeURIComponent(self.critFrom()) : '')
             + (self.critTo()   ? '&createdto='   + encodeURIComponent(self.critTo())   : '');
      api.post(qs, {}).then(function (d) {
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
      var L = [[lt('ai.colGroup'), lt('ai.colType'), lt('ai.colCanonical'), lt('ai.colConf'),
                lt('ai.colReason'), lt('ben.name'), lt('dr.site'), lt('ai.colAccounts'),
                lt('ai.colInvs'), lt('tbl.amountAed'), lt('ai.colFirst'), lt('ai.colLast')]
               .map(esc).join(',')];
      groups.forEach(function (g, gi) {
        var rt = self.rtLabel(g.reasonType || classifyReason(g.reason));
        (g.members || []).forEach(function (m) {
          L.push([gi + 1, rt, g.canonical, self.aiConfTxt(g.confidence), g.reason,
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
