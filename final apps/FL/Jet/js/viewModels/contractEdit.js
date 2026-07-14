define(['knockout', 'services/flService', 'services/docFile', 'shared/formGuard', 'shared/docUpload'], function (ko, flService, docFile, formGuard, docUpload) {
  'use strict';

  function ContractEditViewModel() {
    var self = this;

    var editId = sessionStorage.getItem('flEditContractId') || 'new';
    self.isNew      = editId === 'new';
    self.contractId = ko.observable(self.isNew ? null : Number(editId));
    // observable twin of isNew: late-set after the first save so KO sections
    // depending on record existence (docs checklist) re-render
    self.hasRecord  = ko.observable(!self.isNew);
    self.loading    = ko.observable(true);
    self.saving     = ko.observable(false);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.audit      = ko.observable(null);

    self.contractNumber = ko.observable('');
    self.status         = ko.observable('DRAFT');
    self.freelancerId   = ko.observable(null);
    self.title          = ko.observable('');
    self.startDate      = ko.observable('');
    self.endDate        = ko.observable('');
    self.totalAmount    = ko.observable('');
    self.billingMethod  = ko.observable('MONTHLY');
    self.billingUnitId  = ko.observable(null);
    self.billingUnitAmount = ko.observable('');
    self.orgId          = ko.observable(null);
    self.codingType     = ko.observable('PROJECT');   // Budget Allocation defaults to Project
    self.ccIdGl         = ko.observable(null);
    self.projectNumber  = ko.observable('');
    self.taskNumber     = ko.observable('');
    self.expenditureType = ko.observable('');
    self.notes          = ko.observable('');

    // ── Phase 2 termsheet fields (Legal Affairs form parity) ────────────────
    self.contractType        = ko.observable('');
    self.initiative          = ko.observable('');
    self.contractManagerEmail  = ko.observable('');
    self.contractManagerUserId = ko.observable(null);
    self.contractManagerName   = ko.observable('');
    self.contractManagerHint   = ko.observable('Enter the manager’s work email');
    self.description         = ko.observable('');
    self.servicesSummary     = ko.observable('');
    self.fteConversion       = ko.observable('');
    self.paymentTerms        = ko.observable('');
    self.advancePayment      = ko.observable('');
    self.retentionTerms      = ko.observable('');
    self.performanceBond     = ko.observable('');
    self.parentCoGuarantee   = ko.observable('');
    self.insuranceDetails    = ko.observable('');
    self.procurementInvolved = ko.observable('');
    self.procurementWhy      = ko.observable('');
    self.lineManagerEmail    = ko.observable('');
    self.lineManagerName     = ko.observable('');
    self.lineManagerHint     = ko.observable('The line manager opens the endorsement chain');
    self.memoFromEmail       = ko.observable('');
    self.memoFromUserId      = ko.observable(null);
    self.memoFromName        = ko.observable('');
    self.memoFromHint        = ko.observable('Printed on the termsheet');
    self.memoToEmail         = ko.observable('');
    self.memoToUserId        = ko.observable(null);
    self.memoToName          = ko.observable('');
    self.memoToHint          = ko.observable('Printed on the termsheet');
    self.requirements        = ko.observableArray([]);

    self.freelancerOptions = ko.observableArray([]);
    self.orgOptions        = ko.observableArray([]);
    self.billingUnits      = ko.observableArray([]);
    self.glOptions         = ko.observableArray([]);
    self.contractTypes     = ko.observableArray([]);
    self.fteOptions        = ko.observableArray([]);

    // ── Budget Allocation (FL/db/31) ─────────────────────────────────────
    // Title + Terms of Payment are lookup-driven (Admin → Lookups); the project
    // side is a dependent LOV chain over the project balances view, scoped to
    // the contract's budget year (= the year of its start date).
    self.titleOptions       = ko.observableArray([]);
    self.paymentTermOptions = ko.observableArray([]);
    self.buProjects = ko.observableArray([]);
    self.buTasks    = ko.observableArray([]);
    self.buEtypes   = ko.observableArray([]);
    self.fund       = ko.observable(null);
    self.fundBusy   = ko.observable(false);
    self.glEntity    = ko.observable('');
    self.glCostCentre = ko.observable('');
    self.glAccount   = ko.observable('');
    self.glEntities    = ko.observableArray([]);
    self.glCostCentres = ko.observableArray([]);
    self.glAccounts    = ko.observableArray([]);
    self.glCombos      = ko.observableArray([]);
    self.glComboHint   = ko.observable('');
    self.buHint        = ko.observable('');
    self.buProjectChosen = ko.computed(function () { return !!self.projectNumber(); });

    self.editable = ko.computed(function () { return self.isNew || self.status() === 'DRAFT'; });
    self.isPerCount = ko.computed(function () { return self.billingMethod() === 'PER_COUNT'; });

    // ── Review-mode display helpers (used by the .fl-readonly value twins when
    //    a submitted/active contract renders read-only via the form-layout scaffold)
    function lookupText(arr, keyField, valObs, textField) {
      var v = valObs(); if (v === null || v === undefined || v === '') return '';
      var hit = (arr() || []).filter(function (o) { return o[keyField] === v; })[0];
      return hit ? hit[textField] : '';
    }
    function aed(v) { return (v || v === 0) && v !== '' ? 'AED ' + Number(v).toLocaleString('en-US') : ''; }

    self.freelancerDisp  = ko.computed(function () { return lookupText(self.freelancerOptions, 'id', self.freelancerId, 'label') || '—'; });
    self.orgDisp         = ko.computed(function () { return lookupText(self.orgOptions, 'orgId', self.orgId, 'name') || '—'; });
    self.glDisp          = ko.computed(function () { return lookupText(self.glOptions, 'ccId', self.ccIdGl, 'ccCode') || '—'; });
    self.totalAmountDisp = ko.computed(function () { return aed(self.totalAmount()) || '—'; });
    self.endDateDisp     = ko.computed(function () { return self.endDate() || 'Open-ended'; });
    self.billingComboDisp = ko.computed(function () {
      var unit = lookupText(self.billingUnits, 'valueId', self.billingUnitId, 'name');
      var amt  = aed(self.billingUnitAmount()) || 'auto';
      return (unit ? unit + ' · ' : '') + amt;
    });
    self.contractTypeDisp = ko.computed(function () { return lookupText(self.contractTypes, 'code', self.contractType, 'name') || '—'; });
    self.fteDisp          = ko.computed(function () { return lookupText(self.fteOptions, 'code', self.fteConversion, 'name') || '—'; });
    self.procurementDisp  = ko.computed(function () {
      return { Y: 'Yes', N: 'No' }[self.procurementInvolved()] || '—';
    });
    self.titleDisp        = ko.computed(function () { return lookupText(self.titleOptions, 'code', self.title, 'name') || self.title() || '—'; });
    self.paymentTermsDisp = ko.computed(function () { return lookupText(self.paymentTermOptions, 'code', self.paymentTerms, 'name') || self.paymentTerms() || '—'; });

    // ── Budget Allocation: year, dependent LOVs, fund check ────────────────
    // The budget year is the contract's start-date year (the year its spend is
    // booked against); with no start date yet, the current year.
    // A <input type=date> happily stores a 2-digit year as year 26 (0026) when
    // the user types "01/03/26" — that would ask the balances view for budget
    // year 26 and come back empty. Normalise, and fall back to the current year
    // for anything still outside a sane range.
    self.budgetYear = ko.computed(function () {
      var y = Number((self.startDate() || '').slice(0, 4));
      if (y > 0 && y < 100) y += 2000;
      return (y >= 2000 && y <= 2100) ? y : new Date().getFullYear();
    });

    self.money = function (v) {
      return (v || v === 0) ? Number(v).toLocaleString('en-US', { maximumFractionDigits: 0 }) : '0';
    };
    self.fundBreakdown = function (f) {
      if (!f) return '';
      return ' (Budget ' + self.money(f.budget) + ' · Actual ' + self.money(f.actual) +
             ' · Commitment ' + self.money(f.commitment) + ' · Obligation ' + self.money(f.obligation) + ')';
    };
    self.fundShortMsg = function (f) {
      if (!f) return '';
      if (f.found !== 'Y') {
        return 'this project/task/expenditure-type line carries no budget in ' + f.year + '.';
      }
      return 'only AED ' + self.money(f.fundAvailable) + ' remains on this budget line for ' + f.year +
             ', against a contract of AED ' + self.money(f.required) +
             ' — short by AED ' + self.money(f.shortfall) + '.';
    };

    /* A KO `options:` select silently writes undefined into its value when the
       current value is absent from the list — which would wipe a stored code
       that no longer exists in the LOV (a legacy free-text title, a budget line
       retired from the balances view). Keep such a value visible instead. */
    function keepCurrent(list, keyField, current, label) {
      if (!current) return list;
      var there = list.some(function (o) { return o[keyField] === current; });
      if (there) return list;
      var extra = { label: label || (current + '  (not in the current budget)') };
      extra[keyField] = current;
      return [extra].concat(list);
    }

    // The task / expenditure-type type-aheads only make sense once a project is
    // chosen (their LOVs are scoped to it).
    self.buTaskEnabled = ko.computed(function () {
      return self.editable() && !!self.projectNumber();
    });

    // Server-side search behind the type-aheads whose lists are capped
    // (projects 300, GL combinations 200) — typing narrows the list at source.
    self.searchBuProjects = function (term) { loadBuProjects(term); };
    self.searchGlCombos   = function (term) { loadGlCombos(term); };

    function loadBuProjects(search) {
      self.buHint('');
      return flService.getBudgetProjects(self.budgetYear(), search || null)
        .then(function (items) {
          self.buProjects(keepCurrent(items.map(function (p) {
            return { projectNumber: p.projectNumber,
                     label: p.projectNumber + ' — ' + p.projectName };
          }), 'projectNumber', self.projectNumber()));
          if (!items.length && !search) {
            self.buHint('No project budgets are loaded for budget year ' + self.budgetYear() +
                        ' — check the contract start date, or use the GL level instead.');
          }
        }).catch(function () {
          self.buProjects([]);
          self.buHint('Could not load the project budgets for ' + self.budgetYear() + '.');
        });
    }
    function loadBuTasks() {
      if (!self.projectNumber()) { self.buTasks([]); return Promise.resolve(); }
      return flService.getBudgetTasks(self.budgetYear(), self.projectNumber())
        .then(function (items) {
          self.buTasks(keepCurrent(items.map(function (t) {
            return { taskNumber: t.taskNumber,
                     label: t.taskNumber + '  (fund ' + self.money(t.fundAvailable) + ')' };
          }), 'taskNumber', self.taskNumber()));
        }).catch(function () { self.buTasks([]); });
    }
    function loadBuEtypes() {
      if (!self.projectNumber()) { self.buEtypes([]); return Promise.resolve(); }
      return flService.getBudgetEtypes(self.budgetYear(), self.projectNumber(), self.taskNumber())
        .then(function (items) {
          self.buEtypes(keepCurrent(items.map(function (e) {
            return { expenditureType: e.expenditureType,
                     label: e.expenditureType + '  (fund ' + self.money(e.fundAvailable) + ')' };
          }), 'expenditureType', self.expenditureType()));
        }).catch(function () { self.buEtypes([]); });
    }

    var fundTimer = null;
    function refreshFund() {
      if (self.codingType() !== 'PROJECT' || !self.projectNumber()) { self.fund(null); return; }
      clearTimeout(fundTimer);
      self.fundBusy(true);
      fundTimer = setTimeout(function () {
        flService.checkBudgetFund({
          year: self.budgetYear(), project: self.projectNumber(),
          task: self.taskNumber() || null, etype: self.expenditureType() || null,
          amount: Number(self.totalAmount()) || 0
        }).then(function (r) { self.fund(r); self.fundBusy(false); })
          .catch(function () { self.fund(null); self.fundBusy(false); });
      }, 250);
    }

    self.budgetYear.subscribe(function () {
      loadBuProjects();
      if (self.projectNumber()) { loadBuTasks(); loadBuEtypes(); refreshFund(); }
    });
    self.projectNumber.subscribe(function () {
      self.taskNumber(''); self.expenditureType('');
      loadBuTasks(); loadBuEtypes(); refreshFund();
    });
    self.taskNumber.subscribe(function () {
      self.expenditureType('');
      loadBuEtypes(); refreshFund();
    });
    self.expenditureType.subscribe(refreshFund);
    self.totalAmount.subscribe(refreshFund);
    self.codingType.subscribe(function (v) {
      if (v === 'PROJECT') { if (!self.buProjects().length) loadBuProjects(); refreshFund(); }
      else { self.fund(null); if (!self.glEntities().length) loadGlSegments('entity'); }
    });

    // ── GL level: cascading segment LOVs over the GL combinations ──────────
    function loadGlSegments(seg) {
      var opts = { entity: self.glEntity() || null, costCentre: self.glCostCentre() || null };
      return flService.getGlSegments(seg, opts).then(function (items) {
        var mapped = items.map(function (s) { return { code: s.code, label: s.code + ' — ' + s.name }; });
        if (seg === 'entity')          self.glEntities(mapped);
        else if (seg === 'costcenter') self.glCostCentres(mapped);
        else                           self.glAccounts(mapped);
      }).catch(function () {});
    }
    function loadGlCombos(search) {
      return flService.getGlCombinations({
        entity: self.glEntity() || null, costCentre: self.glCostCentre() || null,
        account: self.glAccount() || null, search: search || null
      }).then(function (r) {
        var items = r.items || [];
        self.glCombos(items.map(function (c) {
          return { ccId: c.ccId, label: c.ccCode + (c.acctDesc ? '  —  ' + c.acctDesc : '') };
        }));
        self.glComboHint(items.length
          ? ((r.total > items.length)
              ? 'Showing the first ' + items.length + ' of ' + r.total + ' combinations — narrow the segments above.'
              : items.length + ' combination' + (items.length === 1 ? '' : 's') + ' match the selected segments.')
          : 'No combination matches the selected segments.');
      }).catch(function () { self.glCombos([]); });
    }
    self.glEntity.subscribe(function () {
      self.glCostCentre(''); self.glAccount(''); self.ccIdGl(null);
      loadGlSegments('costcenter'); loadGlSegments('account'); loadGlCombos();
    });
    self.glCostCentre.subscribe(function () {
      self.glAccount(''); self.ccIdGl(null);
      loadGlSegments('account'); loadGlCombos();
    });
    self.glAccount.subscribe(function () { self.ccIdGl(null); loadGlCombos(); });

    // ── Email → DCT-user resolution (Phase 1 lookupUser pattern) ────────────
    function wireLookup(emailObs, hintObs, idObs, nameObs, defaultHint) {
      return function () {
        var em = (emailObs() || '').trim();
        if (idObs) idObs(null);
        if (nameObs) nameObs('');
        if (!em) { hintObs(defaultHint); return; }
        flService.lookupUser(em).then(function (r) {
          if (r && r.found) {
            if (idObs) idObs(r.userId);
            if (nameObs) nameObs(r.name);
            hintObs('✓ ' + r.name);
          } else {
            hintObs('⚠ No active DCT user with this email');
          }
        }).catch(function () { hintObs('⚠ Lookup failed'); });
      };
    }
    self.lookupContractManager = wireLookup(self.contractManagerEmail, self.contractManagerHint,
      self.contractManagerUserId, self.contractManagerName, 'Enter the manager’s work email');
    self.lookupLineManager = wireLookup(self.lineManagerEmail, self.lineManagerHint,
      null, self.lineManagerName, 'The line manager opens the endorsement chain');
    self.lookupMemoFrom = wireLookup(self.memoFromEmail, self.memoFromHint,
      self.memoFromUserId, self.memoFromName, 'Printed on the termsheet');
    self.lookupMemoTo = wireLookup(self.memoToEmail, self.memoToHint,
      self.memoToUserId, self.memoToName, 'Printed on the termsheet');

    // ── Required-documents checklist (contract uploads + profile satisfy) ───
    self.refreshRequirements = function () {
      if (self.isNew || !self.contractId()) return;
      flService.getContractRequirements(self.contractId())
        .then(function (items) { self.requirements(items); })
        .catch(function () {});
    };
    // A required document belongs to the FREELANCER, not to one contract: file it
    // on their record (source_type FREELANCER, reference_id = freelancer_id) so
    // it satisfies this contract and every future one, until it expires. The
    // checklist and the submit gate both read the freelancer's record first.
    self.uploadRequirement = function (req) {
      if (!self.freelancerId()) {
        self.errorMsg('Choose the freelancer first — documents are filed on their record.');
        return;
      }
      docUpload.choose({ accept: '.pdf,.jpg,.jpeg,.png', maxMb: 10 }).then(function (file) {
        if (!file) return;
        // Documents that expire (passport, visa, EID…) need their expiry, or the
        // renewal alerts and the expired-document gate can't see them.
        var exp = window.prompt(
          'Expiry date for ' + req.name + ' (YYYY-MM-DD) — leave empty if it does not expire:', '');
        if (exp !== null) { exp = (exp || '').trim(); }
        if (exp && !/^\d{4}-\d{2}-\d{2}$/.test(exp)) {
          self.errorMsg('Expiry date must be YYYY-MM-DD.');
          return;
        }
        return flService.createDocument({
          sourceType: 'FREELANCER',
          sourceId: self.freelancerId(),
          freelancerId: self.freelancerId(),
          docTypeId: req.docTypeId,
          documentName: file.name,
          mimeType: file.type || 'application/octet-stream',
          expiryDate: exp || null,
          isRequired: 'Y'
        }).then(function (r) {
          return flService.uploadDocumentFile(r.documentId, file);
        }).then(function () {
          flash(req.name + ' filed on the freelancer’s record.');
          self.refreshRequirements();
        });
      }).catch(function (err) {
        self.errorMsg((err && err.message) || 'Upload failed');
      });
    };

    // View / download the document satisfying a checklist row (profile copy first)
    self.viewDoc     = function (req) { docFile.view({ documentId: req.docId, documentName: req.fileName }); };
    self.downloadDoc = function (req) { docFile.download({ documentId: req.docId, documentName: req.fileName }); };

    Promise.all([
      flService.getLookups(),
      flService.getGlCodes(),
      flService.getFreelancers({ status: 'ACTIVE', limit: 200 }),
      flService.getLookupValues('FL_CONTRACT_TITLE').catch(function () { return []; }),
      flService.getLookupValues('FL_PAYMENT_TERMS').catch(function () { return []; })
    ]).then(function (rs) {
      self.billingUnits(rs[0].billingUnits || []);
      self.orgOptions(rs[0].orgs || []);
      self.contractTypes(rs[0].contractTypes || []);
      self.fteOptions(rs[0].fteConversion || []);
      self.glOptions(rs[1] || []);
      self.titleOptions(rs[3] || []);
      self.paymentTermOptions(rs[4] || []);
      loadBuProjects();
      self.freelancerOptions((rs[2].items || []).map(function (f) {
        return { id: f.freelancerId, label: f.fullNameEn + ' (' + (f.vendorNumber || '-') + ')' };
      }));
      if (!self.isNew) {
        return flService.getContract(self.contractId()).then(function (c) {
          self.audit(c);
          self.contractNumber(c.contractNumber || '');
          self.status(c.status || 'DRAFT');
          self.freelancerId(c.freelancerId);
          self.title(c.title || '');
          self.startDate(c.startDate || '');
          self.endDate(c.endDate || '');
          self.totalAmount(c.totalAmount);
          self.billingMethod(c.billingMethod || 'MONTHLY');
          self.billingUnitId(c.billingUnitId);
          self.billingUnitAmount(c.billingUnitAmount);
          self.orgId(c.orgId);
          self.codingType(c.codingType || 'PROJECT');
          self.projectNumber(c.projectNumber || '');
          self.taskNumber(c.taskNumber || '');
          self.expenditureType(c.expenditureType || '');
          // GL: seed the combination select with the stored combination so it
          // renders before the user touches the segment cascade (the full COA is
          // 9k+ rows — the cascade, not a mega-select, is how you pick another).
          self.ccIdGl(c.ccIdGl);
          if (c.ccIdGl) {
            var hit = (self.glOptions() || []).filter(function (o) { return o.ccId === c.ccIdGl; })[0];
            self.glCombos([{ ccId: c.ccIdGl, label: (hit && hit.ccCode) || ('#' + c.ccIdGl) }]);
            self.glComboHint('Pick an entity / cost centre / account above to choose a different combination.');
          }
          self.notes(c.notes || '');
          self.contractType(c.contractType || '');
          self.initiative(c.initiative || '');
          self.contractManagerUserId(c.contractManagerUserId || null);
          self.contractManagerName(c.contractManagerName || '');
          if (c.contractManagerName) self.contractManagerHint('✓ ' + c.contractManagerName);
          self.description(c.description || '');
          self.servicesSummary(c.servicesSummary || '');
          self.fteConversion(c.fteConversion || '');
          self.paymentTerms(c.paymentTerms || '');
          self.advancePayment(c.advancePayment || '');
          self.retentionTerms(c.retentionTerms || '');
          self.performanceBond(c.performanceBond || '');
          self.parentCoGuarantee(c.parentCoGuarantee || '');
          self.insuranceDetails(c.insuranceDetails || '');
          self.procurementInvolved(c.procurementInvolved || '');
          self.procurementWhy(c.procurementWhy || '');
          self.lineManagerEmail(c.lineManagerEmail || '');
          self.lineManagerName(c.lineManagerName || '');
          if (c.lineManagerName) self.lineManagerHint('✓ ' + c.lineManagerName);
          self.memoFromUserId(c.memoFromUserId || null);
          self.memoFromName(c.memoFromName || '');
          if (c.memoFromName) self.memoFromHint('✓ ' + c.memoFromName);
          self.memoToUserId(c.memoToUserId || null);
          self.memoToName(c.memoToName || '');
          if (c.memoToName) self.memoToHint('✓ ' + c.memoToName);

          // Contracts written before the lookups existed carry free text —
          // surface it as its own option rather than letting KO blank the select.
          function keepLegacy(optsObs, code) {
            if (!code) return;
            var there = (optsObs() || []).some(function (o) { return o.code === code; });
            if (!there) optsObs([{ code: code, name: code }].concat(optsObs() || []));
          }
          keepLegacy(self.titleOptions, self.title());
          keepLegacy(self.paymentTermOptions, self.paymentTerms());
          // Re-run the dependent LOVs now that project/task/etype are populated,
          // so a stored line that no longer appears in the balances view survives.
          loadBuProjects(); loadBuTasks(); loadBuEtypes(); refreshFund();

          self.refreshRequirements();
        });
      }
    }).then(function () { self.loading(false); initGuard(); })
      .catch(function () { self.loading(false); initGuard(); });

    function initGuard() {
      self._guard = formGuard.track([
        self.freelancerId, self.title, self.startDate, self.endDate,
        self.totalAmount, self.billingMethod, self.billingUnitId, self.billingUnitAmount,
        self.orgId, self.codingType, self.ccIdGl,
        self.projectNumber, self.taskNumber, self.expenditureType, self.notes,
        self.contractType, self.initiative, self.contractManagerEmail,
        self.description, self.servicesSummary, self.fteConversion,
        self.paymentTerms, self.advancePayment, self.retentionTerms,
        self.performanceBond, self.parentCoGuarantee, self.insuranceDetails,
        self.procurementInvolved, self.procurementWhy,
        self.lineManagerEmail, self.memoFromEmail, self.memoToEmail
      ]);
    }

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }

    function payload() {
      return {
        freelancerId: self.freelancerId(),
        title: (self.title() || '').trim() || null,
        startDate: self.startDate(),
        endDate: self.endDate() || null,
        totalAmount: Number(self.totalAmount()),
        billingMethod: self.billingMethod(),
        billingUnitId: self.billingUnitId() || null,
        billingUnitAmount: self.billingUnitAmount() ? Number(self.billingUnitAmount()) : null,
        orgId: self.orgId(),
        codingType: self.codingType(),
        ccIdGl: self.codingType() === 'GL' ? self.ccIdGl() : null,
        projectNumber: self.codingType() === 'PROJECT' ? (self.projectNumber() || '').trim() : null,
        taskNumber: self.codingType() === 'PROJECT' ? (self.taskNumber() || '').trim() : null,
        expenditureType: self.codingType() === 'PROJECT' ? (self.expenditureType() || '').trim() : null,
        notes: self.notes().trim(),
        contractType: self.contractType() || null,
        initiative: self.initiative().trim() || null,
        contractManagerUserId: self.contractManagerUserId(),
        description: self.description().trim() || null,
        servicesSummary: self.servicesSummary().trim() || null,
        fteConversion: self.fteConversion() || null,
        paymentTerms: (self.paymentTerms() || '').trim() || null,
        advancePayment: self.advancePayment().trim() || null,
        retentionTerms: self.retentionTerms().trim() || null,
        performanceBond: self.performanceBond().trim() || null,
        parentCoGuarantee: self.parentCoGuarantee().trim() || null,
        insuranceDetails: self.insuranceDetails().trim() || null,
        procurementInvolved: self.procurementInvolved() || null,
        procurementWhy: self.procurementWhy().trim() || null,
        lineManagerEmail: self.lineManagerEmail().trim() || null,
        lineManagerName: self.lineManagerName() || null,
        memoFromUserId: self.memoFromUserId(),
        memoToUserId: self.memoToUserId()
      };
    }

    function validate() {
      self.errorMsg('');
      if (!self.freelancerId()) { self.errorMsg('Freelancer is required.'); return false; }
      if (!self.startDate())    { self.errorMsg('Start date is required.'); return false; }
      // A 2-digit year typed into the date field lands as year 0026 — catch it
      // here rather than booking the contract against budget year 26.
      if (!/^(19|20)\d{2}-/.test(self.startDate())) {
        self.errorMsg('The start date year looks wrong (' + self.startDate().slice(0, 4) +
                      ') — enter the full 4-digit year.'); return false;
      }
      if (self.endDate() && !/^(19|20)\d{2}-/.test(self.endDate())) {
        self.errorMsg('The expected completion date year looks wrong (' + self.endDate().slice(0, 4) +
                      ') — enter the full 4-digit year.'); return false;
      }
      if (!Number(self.totalAmount()) || Number(self.totalAmount()) <= 0) {
        self.errorMsg('A positive total amount is required.'); return false;
      }
      if (!self.orgId())        { self.errorMsg('Organisation is required.'); return false; }
      if (self.codingType() === 'GL' && !self.ccIdGl()) {
        self.errorMsg('A GL code combination is required.'); return false;
      }
      if (self.codingType() === 'PROJECT' && !(self.projectNumber() || '').trim()) {
        self.errorMsg('A project number is required for PROJECT coding.'); return false;
      }
      return true;
    }

    self.saveDraft = function () {
      if (!validate()) return null;
      self.saving(true);
      var op = self.isNew
        ? flService.createContract(payload()).then(function (r) {
            self.isNew = false;
            self.hasRecord(true);
            self.contractId(r.contractId);
            self.contractNumber(r.contractNumber);
            sessionStorage.setItem('flEditContractId', String(r.contractId));
            return r;
          })
        : flService.updateContract(self.contractId(), payload());
      return op.then(function (r) {
        self.saving(false);
        flash('Saved.');
        if (self._guard) self._guard.reset();
        self.refreshRequirements();
        return r;
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed');
        throw err;
      });
    };

    // Submit-time termsheet completeness (mirrors DCT_FL_PKG.submit_contract
    // -20150/-20151/-20153; the server stays the enforcement point)
    function validateTermsheet() {
      var missing = [];
      if (!self.contractType())              missing.push('Contract type');
      if (!self.contractManagerUserId())     missing.push('Contract manager / end user');
      if (!self.description().trim())        missing.push('Contract description');
      if (!(self.paymentTerms() || '').trim())       missing.push('Terms of payment');
      if (!self.endDate())                   missing.push('Expected completion date');
      if (!self.procurementInvolved())       missing.push('Procurement involvement');
      if (!self.fteConversion())             missing.push('FTE conversion answer');
      if (!self.servicesSummary().trim())    missing.push('Summary of services');
      if (missing.length) {
        self.errorMsg('Required before submission: ' + missing.join(', ') + '.');
        return false;
      }
      if (self.procurementInvolved() === 'N' && !self.procurementWhy().trim()) {
        self.errorMsg('Please explain why the Procurement Department is not involved.');
        return false;
      }
      if (!self.lineManagerEmail().trim()) {
        self.errorMsg('A line manager email is required before submission.');
        return false;
      }
      return true;
    }

    self.submit = function () {
      if (!validateTermsheet()) return;
      var save = self.saveDraft();
      if (!save) return;
      save.then(function () {
        return flService.submitContract(self.contractId());
      }).then(function () {
        self.status('SUBMITTED');
        flash('Submitted for approval.');
        setTimeout(function () {
          sessionStorage.setItem('flContractId', String(self.contractId()));
          if (window._jetApp) window._jetApp.navigate('contractDetail');
        }, 800);
      }).catch(function (err) {
        if (err && err.message) self.errorMsg(err.message);
      });
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('contracts'); };
  }

  return ContractEditViewModel;
});
