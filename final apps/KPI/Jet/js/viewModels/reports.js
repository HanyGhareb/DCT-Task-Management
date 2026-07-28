define(['knockout', 'shared/i18n', 'shared/toast', 'services/kpiService'],
function (ko, i18n, toast, kpi) {
  'use strict';

  function ReportsViewModel() {
    var self = this;
    self.t = i18n.t;

    var thisYear = new Date().getFullYear();
    self.years = [];
    for (var y = thisYear + 1; y >= thisYear - 4; y--) self.years.push(y);

    self.year       = ko.observable(thisYear);
    self.running    = ko.observable(false);
    self.runId      = ko.observable(null);
    self.statusLine = ko.observable('');
    self.lastError  = ko.observable('');
    self.pdfReady   = ko.observable(false);

    var pollTimer = null;
    function stopPoll() { if (pollTimer) { clearTimeout(pollTimer); pollTimer = null; } }

    function poll(tries) {
      kpi.bookStatus(self.runId()).then(function (d) {
        self.statusLine('#' + d.runId + ' — ' + d.status +
          (d.finishedAt ? ' · ' + d.finishedAt : ''));
        if (d.status === 'SUCCESS' && d.hasPdf === 'Y') {
          self.running(false); self.pdfReady(true);
          toast.success(self.t('rep.ready'));
          self.download();
          return;
        }
        if (d.status === 'FAILED') {
          self.running(false); self.lastError(d.error || 'Failed');
          toast.error(self.t('rep.failed'));
          return;
        }
        if (tries <= 0) { self.running(false); self.lastError(self.t('rep.timeout')); return; }
        pollTimer = setTimeout(function () { poll(tries - 1); }, 6000);
      }).catch(function () {
        pollTimer = setTimeout(function () { poll(tries - 1); }, 6000);
      });
    }

    self.run = function () {
      stopPoll();
      self.lastError(''); self.pdfReady(false);
      self.running(true);
      kpi.runBook(self.year()).then(function (d) {
        self.runId(d.runId);
        self.statusLine('#' + d.runId + ' — QUEUED');
        poll(60);
      }).catch(function (err) {
        self.running(false);
        toast.error((err && err.message) || self.t('rep.failed'));
      });
    };

    self.download = function () {
      kpi.bookPdfUrl(self.runId()).then(function (url) {
        var a = document.createElement('a');
        a.href = url; a.download = 'kpi_briefing_book_' + self.year() + '.pdf';
        document.body.appendChild(a); a.click(); a.remove();
        setTimeout(function () { URL.revokeObjectURL(url); }, 20000);
      });
    };
  }

  return ReportsViewModel;
});
