define(['knockout', 'services/payService', 'services/authService', 'shared/i18n', 'shared/docUpload'],
function (ko, payService, authService, i18n, docUpload) {
  'use strict';

  function EmployeesViewModel() {
    var self = this;
    self.t = i18n.t;

    // role flags refined from /pay/lov/masters (server truth)
    self.canHr      = ko.observable(authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN'));
    self.canPayroll = ko.observable(authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN'));

    // ── Lookups ─────────────────────────────────────────────────────────
    self.buLov       = ko.observableArray([]);
    self.asgTypeLov  = ko.observableArray([]);
    self.pgLov       = ko.observableArray([]);
    self.reasonLov   = ko.observableArray([]);
    self.maxUploadMb = 10;

    self.companies     = ko.observableArray([]);
    self.contracts     = ko.observableArray([]);
    self.departments   = ko.observableArray([]);
    self.jobs          = ko.observableArray([]);
    self.grades        = ko.observableArray([]);
    self.positions     = ko.observableArray([]);
    self.locations     = ko.observableArray([]);
    self.nationalities = ko.observableArray([]);
    self.docTypes      = ko.observableArray([]);

    function lov(boot, cat) {
      return (boot.lookups || []).filter(function (l) { return l.category === cat; })
        .map(function (l) { return { code: l.code, name: i18n.lang() === 'ar' && l.nameAr ? l.nameAr : l.nameEn }; });
    }

    // ── Register state ──────────────────────────────────────────────────
    self.loading = ko.observable(true);
    self.rows    = ko.observableArray([]);
    self.total   = ko.observable(0);
    self.limit   = ko.observable(50);
    self.offset  = ko.observable(0);

    self.search   = ko.observable('');
    self.fCompany = ko.observable('');
    self.fBu      = ko.observable('');
    self.fActive  = ko.observable('Y');

    self.tableCollapsed = ko.observable(false);
    self.tableMax       = ko.observable(false);
    self.toggleTable    = function () { self.tableCollapsed(!self.tableCollapsed()); };
    self.toggleTableMax = function () { self.tableMax(!self.tableMax()); };

    self.asgBadge = function (s) {
      if (s === 'ACTIVE') return 'badge badge--success';
      if (s === 'SUSPENDED') return 'badge badge--warn';
      if (s === 'UNASSIGNED') return 'badge';
      return 'badge badge--danger';
    };

    self.load = function () {
      self.loading(true);
      payService.getEmployees({
        search: self.search(), companyid: self.fCompany(), bu: self.fBu(),
        active: self.fActive(), limit: self.limit(), offset: self.offset()
      }).then(function (d) {
        self.rows(d.items || []);
        self.total(d.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.onPage = function () { self.load(); };

    var reload = function () { self.offset(0); self.load(); };
    self.search.subscribe(function () { clearTimeout(self._st); self._st = setTimeout(reload, 350); });
    self.fCompany.subscribe(reload);
    self.fBu.subscribe(reload);
    self.fActive.subscribe(reload);

    self.exportCsv = function () {
      var cols = ['employeeNumber', 'nameEn', 'email', 'mobile', 'emiratesId', 'fusionPersonNumber',
                  'company', 'buCode', 'department', 'job', 'gradeCode', 'assignmentStatus', 'hireDate', 'isActive'];
      var lines = [cols.join(',')];
      self.rows().forEach(function (r) {
        lines.push(cols.map(function (c) {
          return '"' + String(r[c] === undefined || r[c] === null ? '' : r[c]).replace(/"/g, '""') + '"';
        }).join(','));
      });
      var blob = new Blob(['﻿' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'pay-employees.csv';
      a.click();
    };

    // ── Drawer state ────────────────────────────────────────────────────
    self.dwOpen  = ko.observable(false);
    self.dwMax   = ko.observable(false);
    self.dwError = ko.observable('');
    self.dwOk    = ko.observable('');
    self.saving  = ko.observable(false);
    self.tab     = ko.observable('profile');
    self.toggleDwMax = function () { self.dwMax(!self.dwMax()); };

    self.form = {
      personId: ko.observable(null), employeeNumber: ko.observable(''),
      firstNameEn: ko.observable(''), lastNameEn: ko.observable(''),
      firstNameAr: ko.observable(''), lastNameAr: ko.observable(''),
      dateOfBirth: ko.observable(''), gender: ko.observable(''),
      nationalityCode: ko.observable(''), emiratesId: ko.observable(''),
      passportNumber: ko.observable(''), email: ko.observable(''), mobile: ko.observable(''),
      fusionPersonNumber: ko.observable(''), hireDate: ko.observable(''), isActive: ko.observable('Y')
    };
    self.dwTitle = ko.computed(function () {
      return self.form.personId()
        ? (self.form.employeeNumber() + ' — ' + self.form.firstNameEn() + ' ' + self.form.lastNameEn())
        : i18n.t('emp.drawerNew');
    });

    self.assignments = ko.observableArray([]);
    self.banks       = ko.observableArray([]);
    self.events      = ko.observableArray([]);
    self.empDocs     = ko.observableArray([]);
    self.checklist   = ko.observableArray([]);

    function fillForm(d) {
      self.form.personId(d.personId || null);
      self.form.employeeNumber(d.employeeNumber || '');
      self.form.firstNameEn(d.firstNameEn || ''); self.form.lastNameEn(d.lastNameEn || '');
      self.form.firstNameAr(d.firstNameAr || ''); self.form.lastNameAr(d.lastNameAr || '');
      self.form.dateOfBirth(d.dateOfBirth || ''); self.form.gender(d.gender || '');
      self.form.nationalityCode(d.nationalityCode || '');
      self.form.emiratesId(d.emiratesId || ''); self.form.passportNumber(d.passportNumber || '');
      self.form.email(d.email || ''); self.form.mobile(d.mobile || '');
      self.form.fusionPersonNumber(d.fusionPersonNumber || '');
      self.form.hireDate(d.hireDate || ''); self.form.isActive(d.isActive || 'Y');
      self.assignments(d.assignments || []);
      self.banks(d.banks || []);
      self.events(d.events || []);
      if (d.canPayroll !== undefined) self.canPayroll(!!d.canPayroll);
      if (d.canHr !== undefined) self.canHr(!!d.canHr);
    }

    self.openNew = function () {
      fillForm({}); self.empDocs([]); self.checklist([]);
      self.tab('profile'); self.dwError(''); self.dwOk('');
      self.asgEditing(false); self.bankEditing(false); self.lcOpen(false);
      self.dwOpen(true);
    };

    self.openEdit = function (row) {
      self.dwError(''); self.dwOk(''); self.tab('profile');
      self.asgEditing(false); self.bankEditing(false); self.lcOpen(false);
      self.reloadEmp(row.personId, true);
    };

    self.reloadEmp = function (personId, openDrawer) {
      return payService.getEmployee(personId).then(function (d) {
        fillForm(d);
        if (openDrawer) self.dwOpen(true);
        self.loadEmpDocs();
        self.load();
      }).catch(function () { self.dwError(i18n.t('err.load')); if (openDrawer) self.dwOpen(true); });
    };

    self.closeDw = function () { self.dwOpen(false); self.dwMax(false); };

    self.save = function () {
      self.dwError(''); self.dwOk(''); self.saving(true);
      var body = {
        firstNameEn: self.form.firstNameEn(), lastNameEn: self.form.lastNameEn(),
        firstNameAr: self.form.firstNameAr(), lastNameAr: self.form.lastNameAr(),
        dateOfBirth: self.form.dateOfBirth(), gender: self.form.gender(),
        nationalityCode: self.form.nationalityCode(),
        emiratesId: self.form.emiratesId(), passportNumber: self.form.passportNumber(),
        email: self.form.email(), mobile: self.form.mobile(),
        fusionPersonNumber: self.form.fusionPersonNumber(), hireDate: self.form.hireDate()
      };
      var p = self.form.personId()
        ? payService.updateEmployee(self.form.personId(), body)
        : payService.createEmployee(body);
      p.then(function (d) {
        self.saving(false);
        if (d && d.personId) { self.form.personId(d.personId); self.form.employeeNumber(d.employeeNumber || ''); }
        self.dwOk(i18n.t('dr.saved'));
        self.load();
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Assignments sub-editor ──────────────────────────────────────────
    self.asgEditing = ko.observable(false);
    self.asgForm = {
      assignmentId: ko.observable(null), companyId: ko.observable(''), contractId: ko.observable(''),
      buCode: ko.observable(''), orgId: ko.observable(''), jobId: ko.observable(''),
      gradeCode: ko.observable(''), positionId: ko.observable(''), locationId: ko.observable(''),
      managerPersonId: ko.observable(null), managerName: ko.observable(''),
      peopleGroup: ko.observable(''), assignmentType: ko.observable('PRIMARY'),
      status: ko.observable('ACTIVE'), effectiveFrom: ko.observable(''), effectiveTo: ko.observable(''),
      notes: ko.observable(''),
      // Phase 2.1 enrichment (real payroll-sheet attributes)
      companyRef: ko.observable(''), jobTitle: ko.observable(''),
      sector: ko.observable(''), departmentName: ko.observable(''),
      costCenter: ko.observable(''), basicSalary: ko.observable(''),
      allowance: ko.observable(''), grossSalary: ko.observable('')
    };
    self.companyContracts = ko.computed(function () {
      var cid = Number(self.asgForm.companyId() || 0);
      return self.contracts().filter(function (c) { return c.companyId === cid; });
    });

    // manager type-ahead
    self.mgrSearch = ko.observable('');
    self.mgrLov    = ko.observableArray([]);
    self.mgrSearch.subscribe(function (v) {
      clearTimeout(self._mt);
      if (!v || v.length < 2) { self.mgrLov([]); return; }
      self._mt = setTimeout(function () {
        payService.lovEmployees(v).then(function (d) { self.mgrLov(d.items || []); });
      }, 300);
    });
    self.mgrPick = function (m) {
      self.asgForm.managerPersonId(m.personId);
      self.asgForm.managerName(m.name + ' (' + m.employeeNumber + ')');
      self.mgrLov([]); self.mgrSearch('');
    };
    self.mgrClear = function () { self.asgForm.managerPersonId(null); self.asgForm.managerName(''); };

    function fillAsgForm(a) {
      self.asgForm.assignmentId(a.assignmentId || null);
      self.asgForm.companyId(a.companyId || ''); self.asgForm.contractId(a.contractId || '');
      self.asgForm.buCode(a.buCode || ''); self.asgForm.orgId(a.orgId || '');
      self.asgForm.jobId(a.jobId || ''); self.asgForm.gradeCode(a.gradeCode || '');
      self.asgForm.positionId(a.positionId || ''); self.asgForm.locationId(a.locationId || '');
      self.asgForm.managerPersonId(a.managerPersonId || null);
      self.asgForm.managerName(a.manager ? a.manager : '');
      self.asgForm.peopleGroup(a.peopleGroup || '');
      self.asgForm.assignmentType(a.assignmentType || 'PRIMARY');
      self.asgForm.status(a.status || 'ACTIVE');
      self.asgForm.effectiveFrom(a.effectiveFrom || '');
      self.asgForm.effectiveTo(a.effectiveTo || '');
      self.asgForm.notes(a.notes || '');
      self.asgForm.companyRef(a.companyRef || '');
      self.asgForm.jobTitle(a.jobTitle || '');
      self.asgForm.sector(a.sector || '');
      self.asgForm.departmentName(a.departmentName || '');
      self.asgForm.costCenter(a.costCenter || '');
      self.asgForm.basicSalary(a.basicSalary != null ? a.basicSalary : '');
      self.asgForm.allowance(a.allowance != null ? a.allowance : '');
      self.asgForm.grossSalary(a.grossSalary != null ? a.grossSalary : '');
      self.mgrSearch(''); self.mgrLov([]);
    }
    self.asgNew    = function () { fillAsgForm({}); self.asgEditing(true); };
    self.asgEdit   = function (a) { if (!self.canHr()) return; fillAsgForm(a); self.asgEditing(true); };
    self.asgCancel = function () { self.asgEditing(false); };
    self.asgSave = function () {
      self.dwError(''); self.saving(true);
      var f = self.asgForm;
      var body = {
        companyId: Number(f.companyId()) || null, contractId: Number(f.contractId()) || null,
        buCode: f.buCode() || null, orgId: Number(f.orgId()) || null,
        jobId: Number(f.jobId()) || null, gradeCode: f.gradeCode() || null,
        positionId: Number(f.positionId()) || null, locationId: Number(f.locationId()) || null,
        managerPersonId: f.managerPersonId() || null, peopleGroup: f.peopleGroup() || null,
        assignmentType: f.assignmentType(), status: f.status(),
        effectiveFrom: f.effectiveFrom() || null, effectiveTo: f.effectiveTo() || null,
        notes: f.notes() || null,
        companyRef: f.companyRef() || null, jobTitle: f.jobTitle() || null,
        sector: f.sector() || null, departmentName: f.departmentName() || null,
        costCenter: f.costCenter() || null,
        basicSalary: f.basicSalary() === '' ? null : Number(f.basicSalary()),
        allowance: f.allowance() === '' ? null : Number(f.allowance()),
        grossSalary: f.grossSalary() === '' ? null : Number(f.grossSalary())
      };
      var p = f.assignmentId()
        ? payService.updateAssignment(f.assignmentId(), body)
        : payService.addAssignment(self.form.personId(), body);
      p.then(function () {
        self.saving(false); self.asgEditing(false);
        self.reloadEmp(self.form.personId(), false);
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Bank sub-editor (PAY_PAYROLL_ENTRY / PAY_ADMIN only) ────────────
    self.bankEditing = ko.observable(false);
    self.bankForm = {
      empBankId: ko.observable(null), bankName: ko.observable(''), iban: ko.observable(''),
      accountNumber: ko.observable(''), branch: ko.observable(''), currency: ko.observable('AED'),
      isPrimary: ko.observable('Y'), isActive: ko.observable('Y')
    };
    function fillBankForm(b) {
      self.bankForm.empBankId(b.empBankId || null);
      self.bankForm.bankName(b.bankName || ''); self.bankForm.iban(b.iban || '');
      self.bankForm.accountNumber(b.accountNumber || ''); self.bankForm.branch(b.branch || '');
      self.bankForm.currency(b.currency || 'AED');
      self.bankForm.isPrimary(b.isPrimary || 'Y'); self.bankForm.isActive(b.isActive || 'Y');
    }
    self.bankNew    = function () { fillBankForm({}); self.bankEditing(true); };
    self.bankEdit   = function (b) { if (!self.canPayroll()) return; fillBankForm(b); self.bankEditing(true); };
    self.bankCancel = function () { self.bankEditing(false); };
    self.bankTogglePrimary = function () { self.bankForm.isPrimary(self.bankForm.isPrimary() === 'Y' ? 'N' : 'Y'); };
    self.bankSave = function () {
      self.dwError(''); self.saving(true);
      var f = self.bankForm;
      var body = {
        bankName: f.bankName(), iban: f.iban(), accountNumber: f.accountNumber(),
        branch: f.branch(), currency: f.currency(), isPrimary: f.isPrimary(), isActive: f.isActive()
      };
      var p = f.empBankId()
        ? payService.updateEmpBank(f.empBankId(), body)
        : payService.addEmpBank(self.form.personId(), body);
      p.then(function () {
        self.saving(false); self.bankEditing(false);
        self.reloadEmp(self.form.personId(), false);
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Lifecycle actions ───────────────────────────────────────────────
    self.lcOpen   = ko.observable(false);
    self.lcAction = ko.observable('');
    self.lcForm = {
      effectiveDate: ko.observable(''), reason: ko.observable(''), notes: ko.observable(''),
      companyId: ko.observable(''), buCode: ko.observable('')
    };
    self.lcNeedsCompany = ko.computed(function () {
      return self.lcAction() === 'TRANSFER' || self.lcAction() === 'REHIRE';
    });
    self.lcStart = function (action) {
      self.lcAction(action);
      var today = new Date().toISOString().slice(0, 10);
      self.lcForm.effectiveDate(today); self.lcForm.reason(''); self.lcForm.notes('');
      self.lcForm.companyId(''); self.lcForm.buCode('');
      self.lcOpen(true);
    };
    self.lcCancel = function () { self.lcOpen(false); };
    self.lcTitle = ko.computed(function () {
      return self.lcAction() ? i18n.t('emp.lc.' + self.lcAction().toLowerCase()) : '';
    });
    self.lcSubmit = function () {
      self.dwError(''); self.saving(true);
      payService.lifecycle(self.form.personId(), {
        action: self.lcAction(),
        effectiveDate: self.lcForm.effectiveDate(),
        reason: self.lcForm.reason() || null,
        notes: self.lcForm.notes() || null,
        companyId: Number(self.lcForm.companyId()) || null,
        buCode: self.lcForm.buCode() || null
      }).then(function () {
        self.saving(false); self.lcOpen(false);
        self.dwOk(i18n.t('dr.saved'));
        self.reloadEmp(self.form.personId(), false);
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };
    // which lifecycle actions apply to the current record state
    self.lcAvailable = ko.computed(function () {
      if (!self.form.personId()) return [];
      var active = self.form.isActive() === 'Y';
      if (!active) return ['REHIRE'];
      var open = (self.assignments() || []).filter(function (a) { return a.status !== 'ENDED'; });
      var suspended = open.some(function (a) { return a.status === 'SUSPENDED'; });
      var acts = [];
      if (open.length && !suspended) acts.push('TRANSFER', 'SUSPEND');
      if (suspended) acts.push('RESUME');
      acts.push('TERMINATE');
      return acts;
    });

    // ── Documents tab ───────────────────────────────────────────────────
    self.docTypeSel  = ko.observable('');
    self.docExpiry   = ko.observable('');
    self.docTypeHasExpiry = ko.computed(function () {
      var c = self.docTypeSel();
      var m = self.docTypes().filter(function (d) { return d.code === c; })[0];
      return !!(m && m.hasExpiry === 'Y');
    });
    self.loadEmpDocs = function () {
      if (!self.form.personId()) { self.empDocs([]); self.checklist([]); return; }
      payService.getEmpDocs(self.form.personId()).then(function (d) {
        self.empDocs(d.items || []);
        self.checklist(d.checklist || []);
      });
    };
    self.fmtSize = function (b) {
      if (!b) return '';
      if (b < 1024) return b + ' B';
      if (b < 1048576) return Math.round(b / 1024) + ' KB';
      return (b / 1048576).toFixed(1) + ' MB';
    };
    self.docUpload = function () {
      docUpload.choose({ maxMb: self.maxUploadMb }).then(function (file) {
        if (!file) return;
        self.dwError('');
        payService.uploadEmpDoc(self.form.personId(), file, self.docTypeSel(), self.docExpiry())
          .then(function () { self.docExpiry(''); self.loadEmpDocs(); })
          .catch(function (e) { self.dwError((e && e.message) || i18n.t('err.save')); });
      });
    };
    self.docView = function (doc) {
      var w = window.open('', '_blank');
      payService.docFileUrl(doc.docId).then(function (url) { w.location = url; })
        .catch(function () { w.close(); });
    };
    self.docDelete = function (doc) {
      if (!window.confirm(i18n.t('doc.confirmDelete'))) return;
      payService.deleteDoc(doc.docId).then(self.loadEmpDocs);
    };

    // ── Bulk upload (SheetJS, full upsert) ──────────────────────────────
    self.bulkCollapsed = ko.observable(true);
    self.toggleBulk    = function () { self.bulkCollapsed(!self.bulkCollapsed()); };
    self.bulkBusy      = ko.observable(false);
    self.bulkResults   = ko.observableArray([]);
    self.bulkSummary   = ko.observable('');
    self.bulkError     = ko.observable('');

    var BULK_COLS = ['employeeNumber', 'firstNameEn', 'lastNameEn', 'firstNameAr', 'lastNameAr',
                     'email', 'mobile', 'gender', 'dateOfBirth', 'nationalityCode',
                     'emiratesId', 'passportNumber', 'fusionPersonNumber', 'hireDate',
                     'companyCode', 'companyRef', 'buCode', 'sector', 'department', 'job', 'jobTitle',
                     'gradeCode', 'position', 'location', 'managerEmployeeNumber', 'peopleGroup',
                     'costCenter', 'basicSalary', 'allowance', 'grossSalary',
                     'bankName', 'iban', 'bankAccountNo', 'effectiveFrom'];

    self.bulkTemplate = function () {
      require(['xlsx'], function (XLSX) {
        var sample = {
          employeeNumber: '', firstNameEn: 'Ahmed', lastNameEn: 'Ali', firstNameAr: '', lastNameAr: '',
          email: 'ahmed.ali@example.com', mobile: '0501234567', gender: 'M', dateOfBirth: '1990-01-15',
          nationalityCode: 'EG', emiratesId: '784-1990-1234567-1', passportNumber: 'A12345678',
          fusionPersonNumber: '2000123', hireDate: '2026-08-01', companyCode: '', companyRef: '02-0288',
          buCode: 'DCT', sector: 'Support Services', department: 'Supply Management',
          job: '', jobTitle: 'Administrative Officer', gradeCode: '4A', position: '', location: '',
          managerEmployeeNumber: '', peopleGroup: 'GENERAL', costCenter: '4510240',
          basicSalary: '8400', allowance: '12600', grossSalary: '21000',
          bankName: '', iban: '', bankAccountNo: '', effectiveFrom: '2026-08-01'
        };
        var ws = XLSX.utils.json_to_sheet([sample], { header: BULK_COLS });
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, 'Employees');
        XLSX.writeFile(wb, 'pay-employees-template.xlsx');
      });
    };

    self.bulkChoose = function () {
      var input = document.createElement('input');
      input.type = 'file';
      input.accept = '.xlsx,.xls,.csv';
      input.onchange = function () {
        var file = input.files && input.files[0];
        if (file) self._bulkParse(file);
      };
      input.click();
    };

    self._bulkParse = function (file) {
      self.bulkError(''); self.bulkResults([]); self.bulkSummary(''); self.bulkBusy(true);
      require(['xlsx'], function (XLSX) {
        var reader = new FileReader();
        reader.onload = function (e) {
          var rows;
          try {
            var wb = XLSX.read(new Uint8Array(e.target.result), { type: 'array' });
            var ws = wb.Sheets[wb.SheetNames[0]];
            rows = XLSX.utils.sheet_to_json(ws, { raw: false, defval: '' });
          } catch (ex) {
            self.bulkBusy(false);
            self.bulkError(i18n.t('emp.bulk.parseError'));
            return;
          }
          rows = (rows || []).map(function (r) {
            var o = {};
            BULK_COLS.forEach(function (c) {
              var v = (r[c] === undefined || r[c] === null) ? '' : String(r[c]).trim();
              if (v !== '') o[c] = v;
            });
            return o;
          }).filter(function (o) { return Object.keys(o).length > 0; });
          if (!rows.length) {
            self.bulkBusy(false);
            self.bulkError(i18n.t('emp.bulk.noRows'));
            return;
          }
          self._bulkSend(rows);
        };
        reader.readAsArrayBuffer(file);
      });
    };

    self._bulkSend = function (rows) {
      var CHUNK = 500;
      var chunks = [];
      for (var i = 0; i < rows.length; i += CHUNK) chunks.push(rows.slice(i, i + CHUNK));
      var all = [];
      var created = 0, updated = 0, failed = 0;
      var seq = Promise.resolve();
      chunks.forEach(function (chunk, ci) {
        seq = seq.then(function () {
          return payService.bulkEmployees(chunk).then(function (d) {
            (d.results || []).forEach(function (r) {
              r.row = r.row + ci * CHUNK;
              if (r.status === 'CREATED') created++;
              else if (r.status === 'UPDATED') updated++;
              else failed++;
              all.push(r);
            });
          });
        });
      });
      seq.then(function () {
        self.bulkResults(all);
        self.bulkSummary(i18n.t('emp.bulk.summary')
          .replace('{c}', created).replace('{u}', updated).replace('{f}', failed));
        self.bulkBusy(false);
        self.load();
      }).catch(function (e) {
        self.bulkBusy(false);
        self.bulkError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Boot ────────────────────────────────────────────────────────────
    payService.boot().then(function (b) {
      self.buLov(lov(b, 'PAY_BU'));
      self.asgTypeLov(lov(b, 'PAY_ASSIGNMENT_TYPE'));
      self.pgLov(lov(b, 'PAY_PEOPLE_GROUP'));
      self.reasonLov(lov(b, 'PAY_EVENT_REASON'));
      self.maxUploadMb = b.maxUploadMb || 10;
    });
    payService.lovMasters().then(function (m) {
      self.canHr(!!m.canHr);
      self.canPayroll(!!m.canPayroll);
      self.companies(m.companies || []);
      self.contracts(m.contracts || []);
      self.departments(m.departments || []);
      self.jobs(m.jobs || []);
      self.grades(m.grades || []);
      self.positions(m.positions || []);
      self.locations(m.locations || []);
      self.nationalities(m.nationalities || []);
      self.docTypes(m.docTypes || []);
    });
    self.load();

    // deep-link: dashboard expiring-doc row opens the employee drawer
    var st = window._jetApp && window._jetApp.getState ? window._jetApp.getState() : {};
    if (st && st.openPersonId) {
      var pid = st.openPersonId;
      delete st.openPersonId;
      self.openEdit({ personId: pid });
    }
  }

  return EmployeesViewModel;
});
