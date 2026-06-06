/**
 * hrService.js — HR module data service.
 * Dual-mode: mock (localStorage) and ORDS (/ords/admin/hr/).
 * All mock writes persist to localStorage; init from localStorage on load.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_hr_data';
  var _nextId = { employee: 100, position: 100, assignment: 100, contract: 100, salary: 100, doc: 100 };

  function loadStore() {
    try {
      var raw = localStorage.getItem(STORE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (e) {}
    return {
      employees:   JSON.parse(JSON.stringify(mockData.EMPLOYEES)),
      orgs:        JSON.parse(JSON.stringify(mockData.ORGS)),
      locations:   JSON.parse(JSON.stringify(mockData.LOCATIONS)),
      jobFamilies: JSON.parse(JSON.stringify(mockData.JOB_FAMILIES)),
      jobs:        JSON.parse(JSON.stringify(mockData.JOBS)),
      positions:   JSON.parse(JSON.stringify(mockData.POSITIONS)),
      assignments: [],
      contracts:   [],
      salaries:    [],
      documents:   JSON.parse(JSON.stringify(mockData.DOCUMENTS)),
    };
  }
  function saveStore(s) { localStorage.setItem(STORE_KEY, JSON.stringify(s)); }

  // Field name normaliser — ORDS returns snake_case, mock uses camelCase
  function _norm(mock, ords) { return config.apiBase ? ords : mock; }

  function _emp(e) {
    return {
      personId:        _norm(e.personId,        e.person_id),
      employeeNumber:  _norm(e.employeeNumber,   e.employee_number),
      fullNameEn:      _norm(e.fullNameEn,       e.full_name_en),
      email:           _norm(e.email,            e.email),
      mobile:          _norm(e.mobile,           e.mobile),
      gender:          _norm(e.gender,           e.gender),
      hireDate:        _norm(e.hireDate,         e.hire_date),
      gradeCode:       _norm(e.gradeCode,        e.grade_code),
      gradeNameEn:     _norm(e.gradeNameEn,      e.grade_name_en),
      orgId:           _norm(e.orgId,            e.org_id),
      orgNameEn:       _norm(e.orgNameEn,        e.org_name_en),
      jobTitleEn:      _norm(e.jobTitleEn,       e.job_title_en),
      positionId:      _norm(e.positionId,       e.position_id),
      positionNameEn:  _norm(e.positionNameEn,   e.position_name_en),
      assignmentStatus:_norm(e.assignmentStatus, e.assignment_status),
      isActive:        _norm(e.isActive,         e.is_active),
      nationalityEn:   _norm(e.nationalityEn,    e.nationality_en),
      maritalStatus:   _norm(e.maritalStatus,    e.marital_status),
      photoUrl:        _norm(e.photoUrl,         e.photo_url),
      basicSalary:     _norm(e.basicSalary,      e.basic_salary),
      salaryCurrency:  _norm(e.salaryCurrency,   e.salary_currency),
    };
  }

  function _pos(p) {
    return {
      positionId:       _norm(p.positionId,       p.position_id),
      positionCode:     _norm(p.positionCode,     p.position_code),
      positionNameEn:   _norm(p.positionNameEn,   p.position_name_en),
      jobId:            _norm(p.jobId,            p.job_id),
      jobNameEn:        _norm(p.jobNameEn,        p.job_name_en),
      jobFamily:        _norm(p.jobFamily,        p.job_family),
      orgId:            _norm(p.orgId,            p.org_id),
      orgNameEn:        _norm(p.orgNameEn,        p.org_name_en),
      gradeCode:        _norm(p.gradeCode,        p.grade_code),
      gradeNameEn:      _norm(p.gradeNameEn,      p.grade_name_en),
      approvedHeadcount:_norm(p.approvedHeadcount,p.approved_headcount),
      filledCount:      _norm(p.filledCount,      p.filled_count),
      vacancyCount:     _norm(p.vacancyCount,     p.vacancy_count),
      positionType:     _norm(p.positionType,     p.position_type),
      isActive:         _norm(p.isActive,         p.is_active),
    };
  }

  function _doc(d) {
    return {
      docId:           _norm(d.docId,           d.doc_id),
      personId:        _norm(d.personId,         d.person_id),
      fullNameEn:      _norm(d.fullNameEn,       d.full_name_en),
      orgNameEn:       _norm(d.orgNameEn,        d.org_name_en),
      docType:         _norm(d.docType,          d.doc_type),
      docNumber:       _norm(d.docNumber,        d.doc_number),
      issueDate:       _norm(d.issueDate,        d.issue_date),
      expiryDate:      _norm(d.expiryDate,       d.expiry_date),
      daysUntilExpiry: _norm(d.daysUntilExpiry,  d.days_until_expiry),
      expiryAlert:     _norm(d.expiryAlert,      d.expiry_alert),
      docStatus:       _norm(d.docStatus,        d.doc_status),
    };
  }

  return {

    // ── Dashboard ──────────────────────────────────────────────────────
    getDashboardStats: function () {
      if (config.apiBase) {
        return Promise.all([
          api.get('/reports/headcount/'),
          api.get('/reports/expiry-alerts/?days=30'),
          api.get('/employees/?active=Y'),
        ]).then(function (results) {
          var hc    = results[0].items || [];
          var docs  = results[1].items || [];
          var emps  = results[2].items || [];
          var total  = hc.reduce(function (a, r) { return a + (r.total_approved || 0); }, 0);
          var filled = hc.reduce(function (a, r) { return a + (r.total_filled   || 0); }, 0);
          return { totalEmployees: emps.length, totalPositions: total, filledPositions: filled, vacancies: total - filled, expiringDocs: docs.length };
        });
      }
      var s = loadStore();
      var totalHc   = s.positions.reduce(function (a, p) { return a + (p.approvedHeadcount || 0); }, 0);
      var filledHc  = s.positions.reduce(function (a, p) { return a + (p.filledCount       || 0); }, 0);
      var expiringDocs = s.documents.filter(function (d) { return d.daysUntilExpiry != null && d.daysUntilExpiry <= 30; }).length;
      return Promise.resolve({
        totalEmployees: s.employees.filter(function (e) { return e.isActive === 'Y'; }).length,
        totalPositions: totalHc,
        filledPositions: filledHc,
        vacancies: totalHc - filledHc,
        expiringDocs: expiringDocs,
      });
    },

    // ── Employees ──────────────────────────────────────────────────────
    getEmployees: function (filters) {
      filters = filters || {};
      if (config.apiBase) {
        var qs = '?';
        if (filters.q)       qs += 'q='       + encodeURIComponent(filters.q)       + '&';
        if (filters.orgId)   qs += 'org_id='  + filters.orgId  + '&';
        if (filters.grade)   qs += 'grade='   + filters.grade  + '&';
        if (filters.active)  qs += 'active='  + filters.active + '&';
        return api.get('/employees/' + qs).then(function (d) { return (d.items || []).map(_emp); });
      }
      var s = loadStore();
      var list = s.employees.slice();
      if (filters.orgId)  list = list.filter(function (e) { return e.orgId === parseInt(filters.orgId); });
      if (filters.active) list = list.filter(function (e) { return e.isActive === filters.active; });
      if (filters.q) {
        var q = filters.q.toUpperCase();
        list = list.filter(function (e) {
          return (e.fullNameEn || '').toUpperCase().includes(q) ||
                 (e.employeeNumber || '').toUpperCase().includes(q) ||
                 (e.email || '').toUpperCase().includes(q);
        });
      }
      return Promise.resolve(list.map(_emp));
    },

    getEmployee: function (personId) {
      if (config.apiBase) return api.get('/employees/' + personId).then(_emp);
      var s = loadStore();
      var e = s.employees.find(function (x) { return x.personId === parseInt(personId); });
      if (!e) return Promise.reject({ message: 'Employee not found' });
      return Promise.resolve(_emp(e));
    },

    // ── Orgs ──────────────────────────────────────────────────────────
    getOrgTree: function () {
      if (config.apiBase) return api.get('/orgs/tree/').then(function (d) { return d.items || []; });
      var s = loadStore();
      return Promise.resolve(s.orgs.map(function (o) {
        return {
          orgId: o.orgId, orgCode: o.orgCode, orgNameEn: o.orgNameEn,
          orgType: o.orgType, parentOrgId: o.parentOrgId, levelNo: o.levelNo,
          isActive: o.isActive, headcountCeiling: o.headcountCeiling,
          costCenterCode: o.costCenterCode, isLeaf: !s.orgs.some(function (c) { return c.parentOrgId === o.orgId; }) ? 'Y' : 'N',
        };
      }));
    },

    getOrgs: function () {
      if (config.apiBase) return api.get('/orgs/').then(function (d) { return d.items || []; });
      return loadStore().orgs ? Promise.resolve(loadStore().orgs) : Promise.resolve([]);
    },

    // ── Positions ──────────────────────────────────────────────────────
    getPositions: function (orgId) {
      if (config.apiBase) {
        var qs = orgId ? '?org_id=' + orgId : '';
        return api.get('/positions/' + qs).then(function (d) { return (d.items || []).map(_pos); });
      }
      var s = loadStore();
      var list = orgId ? s.positions.filter(function (p) { return p.orgId === parseInt(orgId); }) : s.positions;
      return Promise.resolve(list.map(_pos));
    },

    getHeadcountSummary: function () {
      if (config.apiBase) return api.get('/reports/headcount/').then(function (d) { return d.items || []; });
      var s = loadStore();
      var byOrg = {};
      s.positions.forEach(function (p) {
        if (!byOrg[p.orgId]) byOrg[p.orgId] = { orgId: p.orgId, orgNameEn: p.orgNameEn, totalApproved: 0, totalFilled: 0, totalVacancies: 0 };
        byOrg[p.orgId].totalApproved  += p.approvedHeadcount || 0;
        byOrg[p.orgId].totalFilled    += p.filledCount       || 0;
        byOrg[p.orgId].totalVacancies += p.vacancyCount      || 0;
      });
      return Promise.resolve(Object.values(byOrg));
    },

    // ── Jobs ──────────────────────────────────────────────────────────
    getJobs: function (familyId) {
      if (config.apiBase) {
        var qs = familyId ? '?family_id=' + familyId : '';
        return api.get('/jobs/' + qs).then(function (d) { return d.items || []; });
      }
      var s = loadStore();
      var list = familyId ? s.jobs.filter(function (j) { return j.jobFamilyId === parseInt(familyId); }) : s.jobs;
      return Promise.resolve(list);
    },

    getJobFamilies: function () {
      if (config.apiBase) return api.get('/job-families/').then(function (d) { return d.items || []; });
      return Promise.resolve(loadStore().jobFamilies);
    },

    // ── Locations ──────────────────────────────────────────────────────
    getLocations: function () {
      if (config.apiBase) return api.get('/locations/').then(function (d) { return d.items || []; });
      return Promise.resolve(loadStore().locations.filter(function (l) { return l.isActive === 'Y'; }));
    },

    // ── Assignments ────────────────────────────────────────────────────
    getAssignments: function (personId) {
      if (config.apiBase) return api.get('/assignments/' + personId).then(function (d) { return d.items || []; });
      var s = loadStore();
      return Promise.resolve(s.assignments.filter(function (a) { return a.personId === parseInt(personId); }));
    },

    // ── Contracts ──────────────────────────────────────────────────────
    getContracts: function (personId) {
      if (config.apiBase) return api.get('/contracts/' + personId).then(function (d) { return d.items || []; });
      return Promise.resolve(loadStore().contracts.filter(function (c) { return c.personId === parseInt(personId); }));
    },

    // ── Salary ────────────────────────────────────────────────────────
    getSalaryHistory: function (personId) {
      if (config.apiBase) return api.get('/salary/' + personId).then(function (d) { return d.items || []; });
      return Promise.resolve(loadStore().salaries.filter(function (s) { return s.personId === parseInt(personId); }));
    },

    // ── Documents ──────────────────────────────────────────────────────
    getDocuments: function (personId) {
      if (config.apiBase) return api.get('/documents/' + personId).then(function (d) { return (d.items || []).map(_doc); });
      return Promise.resolve(loadStore().documents.filter(function (d) { return d.personId === parseInt(personId); }).map(_doc));
    },

    getExpiringDocs: function (days) {
      days = days || 90;
      if (config.apiBase) return api.get('/reports/expiry-alerts/?days=' + days).then(function (d) { return (d.items || []).map(_doc); });
      var list = loadStore().documents.filter(function (d) { return d.daysUntilExpiry != null && d.daysUntilExpiry <= days; });
      list.sort(function (a, b) { return (a.daysUntilExpiry || 0) - (b.daysUntilExpiry || 0); });
      return Promise.resolve(list.map(_doc));
    },

    reset: function () { localStorage.removeItem(STORE_KEY); },
  };
});
