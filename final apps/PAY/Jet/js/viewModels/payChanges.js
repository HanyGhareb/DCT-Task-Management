/**
 * payChanges.js — Employee Change Control register (Phase 3.1).
 * Month-to-month diff of every payroll-relevant employee attribute with a
 * dual confirmation trail: HR confirms each change first, then Payroll, and
 * each side signs the register off before the payroll run.
 */
define(['knockout', 'services/payService', 'services/api', 'shared/i18n',
        'shared/docUpload', 'shared/components/interactiveReport'],
function (ko, payService, api, i18n, docUpload) {
  'use strict';

  function PayChangesViewModel() {
    var self = this;
    self.t = i18n.t;

    self.money = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US');
    };

    // ── Criteria ────────────────────────────────────────────────────────
    self.payrolls   = ko.observableArray([]);
    self.selPayroll = ko.observable('');
    self.periods    = ko.observableArray([]);
    self.selPeriod  = ko.observable('');
    self.booting    = ko.observable(true);
    self.busy       = ko.observable(false);
    self.error      = ko.observable('');

    // ── Register head ───────────────────────────────────────────────────
    self.reg     = ko.observable(null);   // null = not captured yet
    self.canCapture   = ko.observable(true);   // server capture-guard verdict
    self.captureBlock = ko.observable('');     // LATER_REGISTER:<p> | TOO_OLD:<d>
    self.canHr   = ko.observable(false);
    self.canPay  = ko.observable(false);
    self.loading = ko.observable(false);

    // ── Items (changes tab) ─────────────────────────────────────────────
    self.mode     = ko.observable('changes');     // changes | all
    self.items    = ko.observableArray([]);
    self.itemsLoading = ko.observable(false);
    self.fKind    = ko.observable('');
    self.fGrp     = ko.observable('');
    self.fPending = ko.observable('');
    self.fFlagged = ko.observable(false);
    self.search   = ko.observable('');
    self.reportBusy = ko.observable('');

    // ── All-values tab (shared interactive report) ──────────────────────
    self.allEnv     = ko.observable(null);
    self.allLoading = ko.observable(false);
    self.allChangedOnly = ko.observable(false);

    // ── History ─────────────────────────────────────────────────────────
    self.history = ko.observableArray([]);
    self.histOpen = ko.observable(false);
    self.toggleHist = function () { self.histOpen(!self.histOpen()); };

    function normHist(items) {
      return (items || []).map(function (x) {
        return {
          registerId: x.registerId, period: x.period, status: x.status,
          empCount: x.empCount || 0, changeCount: x.changeCount || 0,
          capturedAt: x.capturedAt || '', capturedBy: x.capturedBy || '',
          hrDoneAt: x.hrDoneAt || '', payDoneAt: x.payDoneAt || ''
        };
      });
    }

    self.statusClass = function (s) {
      return 'chg-pill chg-pill--' + String(s || '').toLowerCase();
    };

    self.isWorkflow = ko.computed(function () {
      var r = self.reg();
      return !!r && r.signoffMode === 'WORKFLOW';
    });
    self.isLocked = ko.computed(function () {
      var r = self.reg();
      return !!r && (r.status === 'CONFIRMED' || r.status === 'IN_APPROVAL');
    });
    self.flagList = function (flags) {
      return String(flags || '').split(',').filter(Boolean);
    };
    self.flagLabel = function (f) {
      var k = 'chg.flag.' + f;
      var v = i18n.t(k);
      return v === k ? f : v;
    };

    self.attrLabel = function (code) {
      if (!code) return '';
      if (code.indexOf('ENTRY_') === 0) {
        return i18n.t('chg.attr.ENTRY') + ' · ' + code.substring(6);
      }
      var k = 'chg.attr.' + code;
      var v = i18n.t(k);
      return v === k ? code : v;
    };
    self.grpLabel = function (g) {
      var k = 'chg.grp.' + g;
      var v = i18n.t(k);
      return v === k ? g : v;
    };

    // pretty signed impact for the KPI band
    self.impactTxt = ko.computed(function () {
      var r = self.reg();
      if (!r || r.grossImpact === undefined || r.grossImpact === null) return '—';
      var n = Number(r.grossImpact);
      return (n > 0 ? '+' : '') + self.money(n);
    });

    // group flat items by employee for the confirm grid
    self.groups = ko.computed(function () {
      var out = [], map = {};
      self.items().forEach(function (it) {
        var g = map[it.personId];
        if (!g) {
          g = { personId: it.personId, name: it.name, empNo: it.empNo,
                kind: it.kind, items: [] };
          map[it.personId] = g; out.push(g);
        }
        if (it.kind !== 'CHANGE') g.kind = it.kind;
        g.items.push(it);
      });
      return out;
    });

    // ── Boot: payrolls + optional deep-link state from the runs page ────
    var st = (window._jetApp && window._jetApp.getState()) || {};
    var wantPayroll = st.chgPayroll; var wantPeriod = st.chgPeriod;
    delete st.chgPayroll; delete st.chgPeriod;

    payService.paysetupBoot().then(function (d) {
      self.payrolls((d.payrolls || []).filter(function (p) { return p.isActive === 'Y'; }));
      self.booting(false);
      if (wantPayroll) { self.selPayroll(wantPayroll); }
      else if (self.payrolls().length) { self.selPayroll(self.payrolls()[0].payrollId); }
    }).catch(function (e) { self.error(e.message || String(e)); self.booting(false); });

    self.selPayroll.subscribe(function (pid) {
      self.reg(null); self.items([]); self.allEnv(null); self.periods([]); self.selPeriod('');
      self.history([]);
      if (!pid) return;
      payService.getPeriods(pid).then(function (d) {
        self.periods(d.items || []);
        if (wantPeriod) {
          self.selPeriod(wantPeriod); wantPeriod = null;
        } else if (d.items && d.items.length) {
          var withRun = d.items.filter(function (x) { return x.runId; });
          self.selPeriod(withRun.length ? withRun[0].period : d.items[0].period);
        }
      });
      payService.chgRegisters(pid).then(function (d) { self.history(normHist(d.items)); });
    });

    self.periodRow = function () {
      return self.periods().filter(function (x) { return x.period === self.selPeriod(); })[0] || null;
    };

    self.selPeriod.subscribe(function () {
      self.reg(null); self.items([]); self.allEnv(null);
      var row = self.periodRow();
      if (row) { self.loadRegister(); }
    });

    self.loadRegister = function () {
      var row = self.periodRow();
      if (!row) return Promise.resolve();
      self.loading(true); self.error('');
      return payService.chgRegister(self.selPayroll(), row.periodId).then(function (d) {
        self.canHr(d.canHr === 'Y');
        self.canPay(d.canPay === 'Y');
        self.canCapture(d.canCapture !== 'N');
        self.captureBlock(d.captureBlock || '');
        self.reg(d.exists === 'Y' ? d : null);
        if (d.exists === 'Y') {
          return self.mode() === 'all' ? self.loadAll() : self.loadItems();
        }
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.loading(false); });
    };

    self.captureBlockMsg = ko.computed(function () {
      var b = self.captureBlock();
      if (!b) return '';
      var i = b.indexOf(':');
      var code = i > 0 ? b.substring(0, i) : b;
      var val = i > 0 ? b.substring(i + 1) : '';
      if (code === 'LATER_REGISTER') return i18n.t('chg.capBlockLater').replace('{p}', val);
      if (code === 'TOO_OLD') return i18n.t('chg.capBlockOld').replace('{d}', val);
      return '';
    });

    self.capture = function () {
      var row = self.periodRow();
      if (!row || !self.canCapture()) return;
      if (self.reg() && !window.confirm(i18n.t('chg.confirmRecapture'))) return;
      self.busy(true); self.error('');
      payService.chgCapture(self.selPayroll(), row.periodId)
        .then(function () {
          return payService.chgRegisters(self.selPayroll())
            .then(function (d) { self.history(normHist(d.items)); });
        })
        .then(function () { return self.loadRegister(); })
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    self.loadItems = function () {
      var r = self.reg();
      if (!r) return Promise.resolve();
      self.itemsLoading(true);
      return payService.chgItems(r.registerId, {
        kind: self.fKind(), grp: self.fGrp(),
        pending: self.fPending(), search: self.search(),
        flagged: self.fFlagged() ? 'Y' : ''
      }).then(function (d) {
        // APEX_JSON omits NULL keys — normalise so foreach bindings never
        // hit an undefined identifier (platform KO gotcha)
        self.items((d.items || []).map(function (x) {
          return {
            itemId: x.itemId, personId: x.personId,
            empNo: x.empNo || '', name: x.name || '',
            kind: x.kind, grp: x.grp, attr: x.attr,
            oldValue: x.oldValue || '', newValue: x.newValue || '',
            delta: (x.delta === undefined ? null : x.delta),
            flags: x.flags || '', note: x.note || '',
            noteReq: x.noteReq || 'N', docCount: x.docCount || 0,
            hrStatus: x.hrStatus, hrBy: x.hrBy || '', hrAt: x.hrAt || '',
            payStatus: x.payStatus, payBy: x.payBy || '', payAt: x.payAt || ''
          };
        }));
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.itemsLoading(false); });
    };

    var searchTimer = null;
    self.search.subscribe(function () {
      if (searchTimer) clearTimeout(searchTimer);
      searchTimer = setTimeout(function () {
        if (self.mode() === 'changes') { self.loadItems(); } else { self.loadAll(); }
      }, 350);
    });
    self.fKind.subscribe(function () { self.loadItems(); });
    self.fGrp.subscribe(function () {
      if (self.mode() === 'changes') { self.loadItems(); } else { self.loadAll(); }
    });
    self.fPending.subscribe(function () { self.loadItems(); });
    self.fFlagged.subscribe(function () { self.loadItems(); });
    self.allChangedOnly.subscribe(function () { self.loadAll(); });

    self.setMode = function (m) {
      if (self.mode() === m) return;
      self.mode(m);
      if (!self.reg()) return;
      if (m === 'all') { self.loadAll(); } else { self.loadItems(); }
    };

    // ── All-values matrix on the shared interactive report ──────────────
    self.loadAll = function () {
      var r = self.reg();
      if (!r) return Promise.resolve();
      self.allLoading(true);
      return payService.chgAll(r.registerId, {
        grp: self.fGrp(), search: self.search(),
        changed: self.allChangedOnly() ? 'Y' : ''
      }).then(function (d) {
        var rows = (d.items || []).map(function (x) {
          return { empNo: x.empNo, name: x.name,
                   grp: self.grpLabel(x.grp), attr: self.attrLabel(x.attr),
                   prevValue: x.prevValue || '', curValue: x.curValue || '',
                   changed: x.changed };
        });
        self.allEnv({
          reportCode: 'PAY_CHG_ALL', section: 'all',
          columns: [
            { key: 'empNo',     label: i18n.t('chg.colEmpNo'),   type: 'text' },
            { key: 'name',      label: i18n.t('chg.colName'),    type: 'text' },
            { key: 'grp',       label: i18n.t('chg.colGroup'),   type: 'text' },
            { key: 'attr',      label: i18n.t('chg.colAttr'),    type: 'text' },
            { key: 'prevValue', label: i18n.t('chg.colPrev'),    type: 'text' },
            { key: 'curValue',  label: i18n.t('chg.colCur'),     type: 'text' },
            { key: 'changed',   label: i18n.t('chg.colChanged'), type: 'text' }
          ],
          items: rows, total: rows.length,
          truncated: d.truncated === 'Y', maxRows: 10000
        });
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.allLoading(false); });
    };

    // ── Confirmations ───────────────────────────────────────────────────
    function refreshAfterConfirm() {
      var row = self.periodRow();
      return payService.chgRegister(self.selPayroll(), row.periodId).then(function (d) {
        if (d.exists === 'Y') { self.reg(d); }
        return self.loadItems();
      });
    }

    self.confirmOne = function (item, side) {
      var r = self.reg();
      if (!r) return;
      var confirmed = side === 'HR' ? item.hrStatus === 'Y' : item.payStatus === 'Y';
      self.busy(true); self.error('');
      payService.chgConfirm(r.registerId, side,
                            confirmed ? 'UNCONFIRM' : 'CONFIRM', String(item.itemId))
        .then(refreshAfterConfirm)
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    self.confirmAll = function (side) {
      var r = self.reg();
      if (!r) return;
      if (!window.confirm(i18n.t(side === 'HR' ? 'chg.confirmAllHr' : 'chg.confirmAllPay'))) return;
      self.busy(true); self.error('');
      payService.chgConfirm(r.registerId, side, 'CONFIRM', 'ALL')
        .then(refreshAfterConfirm)
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    self.signOff = function (side) {
      var r = self.reg();
      if (!r) return;
      var signed = side === 'HR' ? !!r.hrDoneAt : !!r.payDoneAt;
      var msgKey = signed ? 'chg.confirmUnsign'
                          : (side === 'HR' ? 'chg.confirmSignHr' : 'chg.confirmSignPay');
      if (!window.confirm(i18n.t(msgKey))) return;
      self.busy(true); self.error('');
      payService.chgSignoff(r.registerId, side, signed ? 'UNSIGN' : 'SIGN')
        .then(refreshAfterConfirm)
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    // justification note (enhancement 5): prompt-based inline editor
    self.editNote = function (item) {
      var r = self.reg();
      if (!r || self.isLocked()) return;
      var note = window.prompt(i18n.t('chg.notePrompt'), item.note || '');
      if (note === null) return;
      self.busy(true); self.error('');
      payService.chgSetNote(r.registerId, item.itemId, note)
        .then(self.loadItems)
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    // evidence documents on the shared DCT_DOCUMENTS store
    self.attachEvidence = function (item) {
      var r = self.reg();
      if (!r || self.isLocked()) return;
      docUpload.choose({ maxMb: 10 }).then(function (file) {
        if (!file) return;
        self.busy(true); self.error('');
        payService.chgEvidence(r.registerId, item.itemId, file)
          .then(self.loadItems)
          .catch(function (e) { self.error(e.message || String(e)); })
          .finally(function () { self.busy(false); });
      });
    };
    self.openEvidence = function (item) {
      var r = self.reg();
      if (!r || !item.docCount) return;
      payService.chgEvidenceList(r.registerId, item.itemId).then(function (d) {
        var doc = (d.items || [])[0];
        if (!doc) return;
        return api.fetchBlobUrl('/docs/' + doc.docId + '/file').then(function (url) {
          var a = document.createElement('a');
          a.href = url; a.download = doc.fileName || 'evidence';
          a.click();
          setTimeout(function () { URL.revokeObjectURL(url); }, 4000);
        });
      }).catch(function (e) { self.error(e.message || String(e)); });
    };

    // workflow sign-off (enhancement 3)
    self.canSubmit = ko.computed(function () {
      var r = self.reg();
      return !!r && self.isWorkflow()
        && (r.status === 'OPEN' || r.status === 'HR_CONFIRMED')
        && (r.pendHr || 0) === 0 && (r.pendPay || 0) === 0
        && (self.canHr() || self.canPay());
    });
    self.submitSignoff = function () {
      var r = self.reg();
      if (!r || !self.canSubmit()) return;
      if (!window.confirm(i18n.t('chg.confirmSubmit'))) return;
      self.busy(true); self.error('');
      payService.chgSubmit(r.registerId)
        .then(function () { return self.loadRegister(); })
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    // briefing report (enhancement 4): enqueue, poll, download
    self.runReport = function (format) {
      var r = self.reg();
      if (!r || self.reportBusy()) return;
      self.reportBusy(format); self.error('');
      payService.chgReport(r.registerId, format).then(function (d) {
        var tries = 0;
        function poll() {
          tries += 1;
          return payService.chgReportStatus(d.runId).then(function (st) {
            if (st.status === 'SUCCESS') {
              return payService.chgReportFileUrl(d.runId).then(function (url) {
                var a = document.createElement('a');
                a.href = url;
                a.download = 'pay-changes-' + (self.selPeriod() || 'register') + '.' + format.toLowerCase();
                a.click();
                setTimeout(function () { URL.revokeObjectURL(url); }, 4000);
                self.reportBusy('');
              });
            }
            if (st.status === 'FAILED') {
              self.error(i18n.t('chg.reportFailed') + (st.error ? ': ' + st.error : ''));
              self.reportBusy('');
              return;
            }
            if (tries < 45) { setTimeout(poll, 4000); }
            else { self.error(i18n.t('chg.reportFailed')); self.reportBusy(''); }
          });
        }
        setTimeout(poll, 4000);
      }).catch(function (e) { self.error(e.message || String(e)); self.reportBusy(''); });
    };

    // per-side progress for the tracker cards
    self.prog = function (side) {
      var r = self.reg();
      if (!r) return { done: 0, total: 0, pct: 0 };
      var total = r.changeCount || 0;
      var pend = side === 'HR' ? (r.pendHr || 0) : (r.pendPay || 0);
      var done = total - pend;
      return { done: done, total: total, pct: total ? Math.round(done * 100 / total) : 100 };
    };
    self.progTxt = function (side) {
      var p = self.prog(side);
      return p.done + ' / ' + p.total;
    };
    self.progW = function (side) { return self.prog(side).pct + '%'; };

    // ── CSV export of the current items ─────────────────────────────────
    self.exportCsv = function () {
      var rows = self.items();
      if (!rows.length) return;
      var head = ['Employee No','Employee','Kind','Group','Attribute',
                  'Old Value','New Value','Delta','HR','HR By','HR At','Payroll','Payroll By','Payroll At'];
      var csv = head.join(',') + '\r\n';
      rows.forEach(function (x) {
        csv += [x.empNo, x.name, x.kind, x.grp, x.attr,
                x.oldValue || '', x.newValue || '',
                (x.delta === null || x.delta === undefined) ? '' : x.delta,
                x.hrStatus, x.hrBy || '', x.hrAt || '',
                x.payStatus, x.payBy || '', x.payAt || ''
        ].map(function (v) { return '"' + String(v).replace(/"/g, '""') + '"'; }).join(',') + '\r\n';
      });
      var blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'pay-changes-' + (self.selPeriod() || 'register') + '.csv';
      a.click();
      setTimeout(function () { URL.revokeObjectURL(a.href); }, 4000);
    };
  }

  return PayChangesViewModel;
});
