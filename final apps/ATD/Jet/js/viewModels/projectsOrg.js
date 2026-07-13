/* Manage Projects Org — enqueue PPM_TASK_ADDL_INFO Fusion actions (update a
   financial-plan task's Additional Information / Organization Reference).
   Single-row form + Excel bulk upload (SheetJS, parsed client-side) over
   POST /atd/actions/enqueue; the runner's --actions sweep performs them. */
define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'shared/docUpload'],
function (ko, atd, i18n, toast, docUpload) {
  'use strict';

  // Excel header -> payload key (headers normalized: upper, non-alnum -> _)
  var HEADER_MAP = {
    PROJECT_NUMBER: 'projectNumber', PROJECT: 'projectNumber',
    TASK_NUMBER: 'taskNumber', TASK: 'taskNumber',
    ORG_REFERENCE: 'orgReference', ORGANIZATION_REFERENCE: 'orgReference',
    COST_CENTRE: 'orgReference', COST_CENTER: 'orgReference', CC: 'orgReference',
    ENTITY_SPECIFIC: 'entitySpecific',
    APPROPRIATION: 'appropriation',
    PROGRAM: 'program',
    BG_OVERRIDE: 'bgOverride',
    REVENUE_ACCOUNT_OVERRIDE: 'revenueAccountOverride'
  };
  var TEMPLATE_HEADERS = ['PROJECT_NUMBER', 'TASK_NUMBER', 'ORG_REFERENCE',
                          'ENTITY_SPECIFIC', 'APPROPRIATION', 'PROGRAM',
                          'BG_OVERRIDE', 'REVENUE_ACCOUNT_OVERRIDE'];
  var OPTIONAL_KEYS = ['entitySpecific', 'appropriation', 'program',
                       'bgOverride', 'revenueAccountOverride'];
  var CHUNK = 200;   // rows per POST (server caps at 500)

  return function ProjectsOrg() {
    var self = this;
    self.t = i18n.t;

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    // durationSecs -> '45s' / '4m 12s' / '1h 03m' ('—' when never started)
    self.fmtDur = function (secs) {
      if (secs === null || secs === undefined || secs === '') { return '—'; }
      var s = Math.max(0, Math.round(Number(secs)));
      if (s < 60) { return s + 's'; }
      var m = Math.floor(s / 60);
      if (m < 60) { return m + 'm ' + (s % 60) + 's'; }
      var h = Math.floor(m / 60);
      return h + 'h ' + String(m % 60).padStart(2, '0') + 'm';
    };

    // ---------------- single update ----------------
    self.fProject = ko.observable('');
    self.fTask    = ko.observable('');
    self.fOrg     = ko.observable('');

    // LOV suggestion lists (datalists) from the Fusion-loaded extract tables.
    // SUGGESTIONS ONLY — the extract is a snapshot, so the inputs stay free
    // text (a task created in Fusion today may not be in the extract yet).
    self.lovProjects = ko.observableArray([]);   // {code, name, status}
    self.lovTasks    = ko.observableArray([]);   // {code, name} for fProject
    self.lovCcs      = ko.observableArray([]);   // {code, name}
    atd.ppmLov('project').then(function (r) { self.lovProjects(r.items || []); })
       .catch(function () {});
    atd.ppmLov('cc').then(function (r) { self.lovCcs(r.items || []); })
       .catch(function () {});
    var taskLovTimer = null;
    self.fProject.subscribe(function (v) {
      v = (v || '').trim();
      self.lovTasks([]);
      if (!v) { return; }
      clearTimeout(taskLovTimer);
      taskLovTimer = setTimeout(function () {
        atd.ppmLov('task', { project: v })
          .then(function (r) { self.lovTasks(r.items || []); })
          .catch(function () {});   // unknown project number = just no suggestions
      }, 400);
    });
    self.moreOpen = ko.observable(false);
    self.fEntity  = ko.observable('');
    self.fAppr    = ko.observable('');
    self.fProgram = ko.observable('');
    self.fBg      = ko.observable('');
    self.fRev     = ko.observable('');
    self.singleBusy = ko.observable(false);

    self.submitSingle = function () {
      var row = {
        projectNumber: (self.fProject() || '').trim(),
        taskNumber:    (self.fTask() || '').trim(),
        orgReference:  (self.fOrg() || '').trim(),
        entitySpecific: (self.fEntity() || '').trim() || undefined,
        appropriation:  (self.fAppr() || '').trim() || undefined,
        program:        (self.fProgram() || '').trim() || undefined,
        bgOverride:     (self.fBg() || '').trim() || undefined,
        revenueAccountOverride: (self.fRev() || '').trim() || undefined
      };
      if (!row.projectNumber || !row.taskNumber || !row.orgReference) {
        toast.error(self.t('atd.porg.requiredMsg'));
        return;
      }
      self.singleBusy(true);
      atd.enqueuePpmActions([row])
        .then(function (r) {
          var it = (r.items || [])[0] || {};
          if (it.status === 'ERROR') { toast.error(it.error || self.t('atd.porg.failed')); }
          else {
            toast.success(self.t('atd.porg.enqueuedOne', [it.actionId, it.status]));
            self.fProject(''); self.fTask(''); self.fOrg('');
            self.fEntity(''); self.fAppr(''); self.fProgram(''); self.fBg(''); self.fRev('');
          }
          self.singleBusy(false);
          self.loadRecent();
        })
        .catch(function () { self.singleBusy(false); });
    };

    // ---------------- bulk upload (Excel) ----------------
    self.bulkRows = ko.observableArray([]);
    self.bulkFileName = ko.observable('');
    self.bulkBusy = ko.observable(false);
    self.bulkValidCount = ko.computed(function () {
      return self.bulkRows().filter(function (r) { return !r.error; }).length;
    });
    self.bulkErrorCount = ko.computed(function () {
      return self.bulkRows().filter(function (r) { return !!r.error; }).length;
    });

    function normHeader(h) {
      return String(h || '').toUpperCase().trim().replace(/[^A-Z0-9]+/g, '_').replace(/^_+|_+$/g, '');
    }

    function parseWorkbook(XLSX, buf) {
      var wb = XLSX.read(buf, { type: 'array' });
      var ws = wb.Sheets[wb.SheetNames[0]];
      var aoa = XLSX.utils.sheet_to_json(ws, { header: 1, raw: false, defval: '' });
      if (!aoa.length) return [];
      var keys = aoa[0].map(function (h) { return HEADER_MAP[normHeader(h)] || null; });
      if (keys.indexOf('projectNumber') < 0 || keys.indexOf('taskNumber') < 0 ||
          keys.indexOf('orgReference') < 0) {
        throw new Error(self.t('atd.porg.bulk.badHeaders'));
      }
      var rows = [];
      for (var i = 1; i < aoa.length; i++) {
        var src = aoa[i];
        if (!src.some(function (c) { return String(c || '').trim() !== ''; })) continue; // blank line
        var r = { row: rows.length + 1 };
        keys.forEach(function (k, j) {
          if (k && String(src[j] || '').trim() !== '') r[k] = String(src[j]).trim();
        });
        r.segments = OPTIONAL_KEYS.filter(function (k) { return r[k]; })
                                  .map(function (k) { return k + '=' + r[k]; }).join(', ');
        r.error = (!r.projectNumber || !r.taskNumber || !r.orgReference)
                  ? self.t('atd.porg.requiredMsg') : '';
        r.status = '';
        rows.push(r);
      }
      return rows;
    }

    self.chooseFile = function () {
      docUpload.choose({ accept: '.xlsx,.xls,.csv', maxMb: 10 }).then(function (file) {
        if (!file) return;
        file.arrayBuffer().then(function (buf) {
          require(['xlsx'], function (XLSX) {
            try {
              var rows = parseWorkbook(XLSX, buf);
              if (!rows.length) { toast.error(self.t('atd.porg.bulk.noRows')); return; }
              self.bulkFileName(file.name);
              self.bulkRows(rows);
              toast.success(self.t('atd.porg.bulk.parsed', [rows.length]));
            } catch (e) { toast.error(e.message || String(e)); }
          }, function () { toast.error(self.t('atd.porg.bulk.libFail')); });
        });
      });
    };

    self.downloadTemplate = function () {
      require(['xlsx'], function (XLSX) {
        var aoa = [TEMPLATE_HEADERS,
                   ['4511000682', 'Annual Reports', '4510195', '', '', '', '', '']];
        var ws = XLSX.utils.aoa_to_sheet(aoa);
        ws['!cols'] = TEMPLATE_HEADERS.map(function (h) { return { wch: Math.max(h.length + 2, 16) }; });
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, 'ProjectsOrg');
        XLSX.writeFile(wb, 'projects_org_template.xlsx');
      }, function () { toast.error(self.t('atd.porg.bulk.libFail')); });
    };

    self.clearBulk = function () { self.bulkRows([]); self.bulkFileName(''); };

    self.submitBulk = function () {
      var all = self.bulkRows();
      var valid = all.filter(function (r) { return !r.error; });
      if (!valid.length || self.bulkBusy()) return;
      self.bulkBusy(true);

      var chunks = [];
      for (var i = 0; i < valid.length; i += CHUNK) chunks.push(valid.slice(i, i + CHUNK));

      var done = 0, failed = 0;
      var seq = Promise.resolve();
      chunks.forEach(function (chunk) {
        seq = seq.then(function () {
          return atd.enqueuePpmActions(chunk.map(function (r) {
            return {
              projectNumber: r.projectNumber, taskNumber: r.taskNumber,
              orgReference: r.orgReference,
              entitySpecific: r.entitySpecific, appropriation: r.appropriation,
              program: r.program, bgOverride: r.bgOverride,
              revenueAccountOverride: r.revenueAccountOverride
            };
          })).then(function (res) {
            (res.items || []).forEach(function (it, j) {
              // replace the row object — KO foreach skips re-render on an
              // identical reference, so in-place mutation never shows
              var r = chunk[j], upd;
              if (it.status === 'ERROR') { upd = Object.assign({}, r, { error: it.error || 'ERROR' }); failed++; }
              else {
                upd = Object.assign({}, r, { status: it.status + (it.actionId ? ' #' + it.actionId : '') });
                done++;
              }
              all[all.indexOf(r)] = upd;
              chunk[j] = upd;
            });
            self.bulkRows(all.slice());          // refresh the table
          });
        });
      });
      seq.then(function () {
        self.bulkBusy(false);
        if (failed) toast.error(self.t('atd.porg.bulk.doneSome', [done, failed]));
        else toast.success(self.t('atd.porg.bulk.doneAll', [done]));
        self.loadRecent();
      }).catch(function () {
        self.bulkBusy(false);
        self.bulkRows(all.slice());
        self.loadRecent();
      });
    };

    // ---------------- recent PPM actions ----------------
    self.recent = ko.observableArray([]);
    self.recentLoading = ko.observable(true);
    self.loadRecent = function () {
      self.recentLoading(true);
      atd.listActions({ type: 'PPM_TASK_ADDL_INFO', limit: 20, offset: 0 })
        .then(function (r) { self.recent(r.items || []); self.recentLoading(false); })
        .catch(function () { self.recentLoading(false); });
    };
    self.retry = function (row) {
      atd.retryAction(row.actionId)
        .then(function () { toast.success(self.t('atd.actions.retried')); self.loadRecent(); })
        .catch(function () {});
    };
    self.cancel = function (row) {
      atd.cancelAction(row.actionId)
        .then(function () { toast.success(self.t('atd.actions.cancelled')); self.loadRecent(); })
        .catch(function () {});
    };
    self.loadRecent();
  };
});
