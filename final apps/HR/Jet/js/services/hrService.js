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
    var fresh = {
      employees:   JSON.parse(JSON.stringify(mockData.EMPLOYEES)),
      orgs:        JSON.parse(JSON.stringify(mockData.ORGS)),
      locations:   JSON.parse(JSON.stringify(mockData.LOCATIONS)),
      grades:      JSON.parse(JSON.stringify(mockData.GRADES || [])),
      jobFamilies: JSON.parse(JSON.stringify(mockData.JOB_FAMILIES)),
      jobs:        JSON.parse(JSON.stringify(mockData.JOBS)),
      positions:   JSON.parse(JSON.stringify(mockData.POSITIONS)),
      assignments: [],
      contracts:   [],
      salaries:    [],
      documents:   JSON.parse(JSON.stringify(mockData.DOCUMENTS)),
    };
    try {
      var raw = localStorage.getItem(STORE_KEY);
      if (raw) {
        var stored = JSON.parse(raw);
        // Back-fill audit fields on cached locations that predate the audit columns
        var auditFields = ['created_by','created_at','updated_by','updated_at'];
        var seedMap = {};
        fresh.locations.forEach(function (l) { seedMap[l.locationId] = l; });
        if (stored.locations) {
          stored.locations = stored.locations.map(function (l) {
            var seed = seedMap[l.locationId] || {};
            auditFields.forEach(function (f) {
              if (!l[f] && seed[f]) l[f] = seed[f];
            });
            return l;
          });
        }
        return stored;
      }
    } catch (e) {}
    return fresh;
  }
  function saveStore(s) { localStorage.setItem(STORE_KEY, JSON.stringify(s)); }

  // Field name normaliser — ORDS returns snake_case, mock uses camelCase
  function _norm(mock, ords) { return config.apiBase ? ords : mock; }

  function _emp(e) {
    return {
      personId:        _norm(e.personId,        e.person_id),
      employeeNumber:  _norm(e.employeeNumber,   e.employee_number),
      fullNameEn:      _norm(e.fullNameEn,       e.full_name_en),
      firstNameEn:     _norm(e.firstNameEn,      e.first_name_en),
      lastNameEn:      _norm(e.lastNameEn,       e.last_name_en),
      firstNameAr:     _norm(e.firstNameAr,      e.first_name_ar),
      lastNameAr:      _norm(e.lastNameAr,       e.last_name_ar),
      fullNameAr: (function () {
        var fa = _norm(e.firstNameAr, e.first_name_ar);
        var la = _norm(e.lastNameAr,  e.last_name_ar);
        return ((fa || '') + ' ' + (la || '')).trim() || _norm(e.fullNameAr, e.full_name_ar) || '';
      }()),
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
      photoUrl: (function () {
        var raw = _norm(e.photoUrl, e.photo_url);
        if (!raw) return null;
        // When ORDS stores relative path (/ords/admin/hr/...) make it absolute
        if (config.apiBase && /^\/ords\/.+\/employees\/\d+\/photo$/.test(raw)) {
          var pid = _norm(e.personId, e.person_id);
          return config.apiBase + '/employees/' + pid + '/photo';
        }
        return raw;
      }()),
      basicSalary:     _norm(e.basicSalary,      e.basic_salary),
      salaryCurrency:  _norm(e.salaryCurrency,   e.salary_currency),
      createdBy:       _norm(e.createdBy,        e.created_by),
      createdAt:       _norm(e.createdAt,        e.created_at),
      updatedBy:       _norm(e.updatedBy,        e.updated_by),
      updatedAt:       _norm(e.updatedAt,        e.updated_at),
    };
  }

  function _pos(p) {
    return {
      positionId:       _norm(p.positionId,       p.position_id),
      positionCode:     _norm(p.positionCode,     p.position_code),
      positionNameEn:   _norm(p.positionNameEn,   p.position_name_en),
      positionNameAr:   _norm(p.positionNameAr,   p.position_name_ar),
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
      createdBy:        _norm(p.createdBy,        p.created_by),
      createdAt:        _norm(p.createdAt,        p.created_at),
      updatedBy:        _norm(p.updatedBy,        p.updated_by),
      updatedAt:        _norm(p.updatedAt,        p.updated_at),
    };
  }

  function _org(o) {
    return {
      orgId:            _norm(o.orgId,            o.org_id),
      orgCode:          _norm(o.orgCode,          o.org_code),
      orgNameEn:        _norm(o.orgNameEn,        o.org_name_en),
      orgNameAr:        _norm(o.orgNameAr,        o.org_name_ar),
      orgType:          _norm(o.orgType,          o.org_type),
      orgTypeLabel:     _norm(o.orgTypeLabel,     o.org_type_label),
      parentOrgId:      _norm(o.parentOrgId,      o.parent_org_id),
      levelNo:          _norm(o.levelNo,          o.level_no),
      fullPath:         _norm(o.fullPath,         o.full_path),
      isActive:         _norm(o.isActive,         o.is_active),
      headcountCeiling: _norm(o.headcountCeiling, o.headcount_ceiling),
      costCenterCode:   _norm(o.costCenterCode,   o.cost_center_code),
      locationNameEn:   _norm(o.locationNameEn,   o.location_name_en),
      isLeaf:           _norm(o.isLeaf,           o.is_leaf),
    };
  }

  function _job(j) {
    return {
      jobId:              _norm(j.jobId,              j.job_id),
      jobCode:            _norm(j.jobCode,            j.job_code),
      jobNameEn:          _norm(j.jobNameEn,          j.job_name_en),
      jobNameAr:          _norm(j.jobNameAr,          j.job_name_ar),
      jobFamilyId:        _norm(j.jobFamilyId,        j.job_family_id),
      jobFamily:          _norm(j.jobFamily,          j.job_family),
      minGradeCode:       _norm(j.minGradeCode,       j.min_grade_code),
      maxGradeCode:       _norm(j.maxGradeCode,       j.max_grade_code),
      minExperienceYears: _norm(j.minExperienceYears, j.min_experience_years),
      descriptionEn:      _norm(j.descriptionEn,      j.description_en),
      isActive:           _norm(j.isActive,           j.is_active),
      effectiveFrom:      _norm(j.effectiveFrom,      j.effective_from),
      effectiveTo:        _norm(j.effectiveTo,        j.effective_to),
      createdBy:          _norm(j.createdBy,          j.created_by),
      createdAt:          _norm(j.createdAt,          j.created_at),
      updatedBy:          _norm(j.updatedBy,          j.updated_by),
      updatedAt:          _norm(j.updatedAt,          j.updated_at),
    };
  }

  function _jobFamily(f) {
    return {
      jobFamilyId:   _norm(f.jobFamilyId,   f.job_family_id),
      familyCode:    _norm(f.familyCode,    f.family_code),
      familyNameEn:  _norm(f.familyNameEn,  f.family_name_en),
      familyNameAr:  _norm(f.familyNameAr,  f.family_name_ar),
      descriptionEn: _norm(f.descriptionEn, f.description_en),
      isActive:      _norm(f.isActive,      f.is_active),
    };
  }

  function _loc(l) {
    return {
      locationId:     _norm(l.locationId,     l.location_id),
      locationCode:   _norm(l.locationCode,   l.location_code),
      locationNameEn: _norm(l.locationNameEn, l.location_name_en),
      locationNameAr: _norm(l.locationNameAr, l.location_name_ar),
      locationType:   _norm(l.locationType,   l.location_type),
      orgId:          _norm(l.orgId,          l.org_id),
      orgNameEn:      _norm(l.orgNameEn,      l.org_name_en),
      countryCode:    _norm(l.countryCode,    l.country_code),
      countryNameEn:  _norm(l.countryNameEn,  l.country_name_en),
      emirate:        _norm(l.emirate,        l.emirate),
      city:           _norm(l.city,           l.city),
      area:           _norm(l.area,           l.area),
      buildingName:   _norm(l.buildingName,   l.building_name),
      floorNo:        _norm(l.floorNo,        l.floor_no),
      isActive:       _norm(l.isActive,       l.is_active),
      createdBy:      _norm(l.createdBy,      l.created_by),
      createdAt:      _norm(l.createdAt,      l.created_at),
      updatedBy:      _norm(l.updatedBy,      l.updated_by),
      updatedAt:      _norm(l.updatedAt,      l.updated_at),
    };
  }

  function _grade(g) {
    return {
      gradeCode:      _norm(g.gradeCode,      g.grade_code),
      gradeNameEn:    _norm(g.gradeNameEn,    g.grade_name_en),
      gradeNameAr:    _norm(g.gradeNameAr,    g.grade_name_ar),
      gradeLevel:     _norm(g.gradeLevel,     g.grade_level),
      gradeCategory:  _norm(g.gradeCategory,  g.grade_category),
      salaryBandMin:  _norm(g.salaryBandMin,  g.salary_band_min),
      salaryBandMax:  _norm(g.salaryBandMax,  g.salary_band_max),
      displayOrder:   _norm(g.displayOrder,   g.display_order),
      isActive:       _norm(g.isActive,       g.is_active),
      headcount:      _norm(g.headcount,      g.headcount),
      createdBy:      _norm(g.createdBy,      g.created_by),
      createdAt:      _norm(g.createdAt,      g.created_at),
      updatedBy:      _norm(g.updatedBy,      g.updated_by),
      updatedAt:      _norm(g.updatedAt,      g.updated_at),
    };
  }

  function _docType(dt) {
    return {
      docTypeId:      _norm(dt.docTypeId,      dt.doc_type_id),
      docTypeCode:    _norm(dt.docTypeCode,    dt.doc_type_code),
      docTypeNameEn:  _norm(dt.docTypeNameEn,  dt.doc_type_name_en),
      docCategory:    _norm(dt.docCategory,    dt.doc_category),
      hasExpiry:      _norm(dt.hasExpiry,      dt.has_expiry),
      expiryAlertDays:_norm(dt.expiryAlertDays,dt.expiry_alert_days),
      isActive:       _norm(dt.isActive,       dt.is_active),
    };
  }

  function _doc(d) {
    return {
      docId:            _norm(d.docId,            d.doc_id),
      personId:         _norm(d.personId,          d.person_id),
      fullNameEn:       _norm(d.fullNameEn,        d.full_name_en),
      orgNameEn:        _norm(d.orgNameEn,         d.org_name_en),
      docType:          _norm(d.docType,           d.doc_type_name_en || d.doc_type),
      docNumber:        _norm(d.docNumber,         d.doc_number),
      issueDate:        _norm(d.issueDate,         d.issue_date),
      expiryDate:       _norm(d.expiryDate,        d.expiry_date),
      daysUntilExpiry:  _norm(d.daysUntilExpiry,   d.days_until_expiry),
      expiryAlert:      _norm(d.expiryAlert,       d.expiry_alert),
      docStatus:        _norm(d.docStatus,         d.doc_status),
      issuingAuthority: _norm(d.issuingAuthority,  d.issuing_authority),
      notes:            _norm(d.notes,             d.notes),
      fileName:         _norm(d.fileName,          d.file_name),
      fileMimeType:     _norm(d.fileMimeType,      d.file_mime_type),
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
        if (filters.q)       qs += 'search='  + encodeURIComponent(filters.q)       + '&';
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

    createEmployee: function (data) {
      if (config.apiBase) return api.post('/employees/', data);
      var s = loadStore();
      _nextId.employee++;
      var newEmp = Object.assign({
        personId: _nextId.employee,
        isActive: 'Y',
        fullNameEn: ((data.first_name_en || '') + ' ' + (data.last_name_en || '')).trim(),
      }, data);
      s.employees.push(newEmp);
      saveStore(s);
      return Promise.resolve(_emp(newEmp));
    },

    updateEmployee: function (personId, data) {
      if (config.apiBase) return api.put('/employees/' + personId, data);
      var s = loadStore();
      var idx = s.employees.findIndex(function (e) { return e.personId === parseInt(personId); });
      if (idx >= 0) {
        s.employees[idx] = Object.assign({}, s.employees[idx], data,
          { fullNameEn: ((data.first_name_en || s.employees[idx].first_name_en || '') + ' ' + (data.last_name_en || s.employees[idx].last_name_en || '')).trim() });
        saveStore(s);
        return Promise.resolve(_emp(s.employees[idx]));
      }
      return Promise.reject({ message: 'Employee not found' });
    },

    uploadEmployeePhoto: function (personId, file) {
      if (config.apiBase) {
        return new Promise(function (resolve, reject) {
          var reader = new FileReader();
          reader.onload = function (evt) {
            var b64 = evt.target.result.split(',')[1];
            api.put('/employees/' + personId + '/photo', {
              photo_data_b64: b64,
              mime_type: file.type || 'image/jpeg',
            }).then(function () {
              resolve({ photoUrl: config.apiBase + '/employees/' + personId + '/photo' });
            }).catch(reject);
          };
          reader.onerror = function () { reject({ message: 'Failed to read photo' }); };
          reader.readAsDataURL(file);
        });
      }
      // mock: store as data URL in localStorage and update employee record
      return new Promise(function (resolve, reject) {
        var reader = new FileReader();
        reader.onload = function (e) {
          var dataUrl = e.target.result;
          var s = loadStore();
          var idx = s.employees.findIndex(function (emp) { return emp.personId === parseInt(personId); });
          if (idx >= 0) {
            s.employees[idx].photoUrl = dataUrl;
            s.employees[idx].photo_url = dataUrl;
            saveStore(s);
          }
          resolve({ photoUrl: dataUrl });
        };
        reader.onerror = function () { reject({ message: 'Failed to read photo' }); };
        reader.readAsDataURL(file);
      });
    },

    // ── Orgs ──────────────────────────────────────────────────────────
    getOrgTree: function () {
      if (config.apiBase) return api.get('/orgs/tree/').then(function (d) { return (d.items || []).map(_org); });
      var s = loadStore();
      return Promise.resolve(s.orgs.map(function (o) {
        return _org(Object.assign({}, o, {
          isLeaf: !s.orgs.some(function (c) { return c.parentOrgId === o.orgId; }) ? 'Y' : 'N',
        }));
      }));
    },

    getOrgs: function () {
      if (config.apiBase) return api.get('/orgs/').then(function (d) { return (d.items || []).map(_org); });
      var s = loadStore();
      return Promise.resolve((s.orgs || []).map(_org));
    },

    createOrg: function (data) {
      if (config.apiBase) return api.post('/orgs/', data);
      var s = loadStore();
      var newOrg = Object.assign({ orgId: Date.now(), isActive: 'Y', levelNo: 1 }, data);
      s.orgs.push(newOrg);
      saveStore(s);
      return Promise.resolve(_org(newOrg));
    },

    updateOrg: function (orgId, data) {
      if (config.apiBase) return api.put('/orgs/' + orgId, data);
      var s = loadStore();
      var idx = s.orgs.findIndex(function (o) { return o.orgId === parseInt(orgId); });
      if (idx >= 0) { s.orgs[idx] = Object.assign({}, s.orgs[idx], data); saveStore(s); return Promise.resolve(_org(s.orgs[idx])); }
      return Promise.reject({ message: 'Org not found' });
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

    createPosition: function (data) {
      if (config.apiBase) return api.post('/positions/', data);
      var s = loadStore();
      var newPos = Object.assign({ positionId: Date.now(), isActive: 'Y', filledCount: 0, vacancyCount: data.approved_headcount || 1 }, data);
      s.positions.push(newPos);
      saveStore(s);
      return Promise.resolve(_pos(newPos));
    },

    updatePosition: function (positionId, data) {
      if (config.apiBase) return api.put('/positions/' + positionId, data);
      var s = loadStore();
      var idx = s.positions.findIndex(function (p) { return p.positionId === parseInt(positionId); });
      if (idx >= 0) { s.positions[idx] = Object.assign({}, s.positions[idx], data); saveStore(s); return Promise.resolve(_pos(s.positions[idx])); }
      return Promise.reject({ message: 'Position not found' });
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
        return api.get('/jobs/' + qs).then(function (d) { return (d.items || []).map(_job); });
      }
      var s = loadStore();
      var list = familyId ? s.jobs.filter(function (j) { return j.jobFamilyId === parseInt(familyId); }) : s.jobs;
      return Promise.resolve(list.map(_job));
    },

    getJobFamilies: function () {
      if (config.apiBase) return api.get('/job-families/').then(function (d) { return (d.items || []).map(_jobFamily); });
      return Promise.resolve(loadStore().jobFamilies.map(_jobFamily));
    },

    createJob: function (data) {
      if (config.apiBase) return api.post('/jobs/', data);
      var s = loadStore();
      var newJob = Object.assign({ jobId: Date.now(), isActive: 'Y' }, data);
      s.jobs.push(newJob);
      saveStore(s);
      return Promise.resolve(_job(newJob));
    },

    updateJob: function (jobId, data) {
      if (config.apiBase) return api.put('/jobs/' + jobId, data);
      var s = loadStore();
      var idx = s.jobs.findIndex(function (j) { return j.jobId === parseInt(jobId); });
      if (idx >= 0) { s.jobs[idx] = Object.assign({}, s.jobs[idx], data); saveStore(s); return Promise.resolve(_job(s.jobs[idx])); }
      return Promise.reject({ message: 'Job not found' });
    },

    // ── Grades ────────────────────────────────────────────────────────
    getGrades: function () {
      if (config.apiBase) return api.get('/grades/').then(function (d) { return (d.items || []).map(_grade); });
      var s = loadStore();
      return Promise.resolve((s.grades || []).map(_grade));
    },

    createGrade: function (data) {
      if (config.apiBase) return api.post('/grades/', data);
      var s = loadStore();
      if (!s.grades) s.grades = [];
      var now  = new Date().toISOString();
      var user = (window._hrCurrentUser && window._hrCurrentUser.displayName) || 'System Administrator';
      var newGrade = Object.assign({ isActive: 'Y', headcount: 0, created_by: user, created_at: now, updated_by: user, updated_at: now }, data);
      s.grades.push(newGrade);
      saveStore(s);
      return Promise.resolve(_grade(newGrade));
    },

    updateGrade: function (gradeCode, data) {
      if (config.apiBase) return api.put('/grades/' + gradeCode, data);
      var s = loadStore();
      if (!s.grades) s.grades = [];
      var idx = s.grades.findIndex(function (g) { return (g.gradeCode || g.grade_code) === gradeCode; });
      if (idx >= 0) {
        var now  = new Date().toISOString();
        var user = (window._hrCurrentUser && window._hrCurrentUser.displayName) || 'System Administrator';
        s.grades[idx] = Object.assign({}, s.grades[idx], data, { updated_by: user, updated_at: now });
        saveStore(s);
        return Promise.resolve(_grade(s.grades[idx]));
      }
      return Promise.reject({ message: 'Grade not found' });
    },

    // ── Locations ──────────────────────────────────────────────────────
    getLocations: function () {
      if (config.apiBase) return api.get('/locations/').then(function (d) { return (d.items || []).map(_loc); });
      return Promise.resolve(loadStore().locations.filter(function (l) { return l.isActive === 'Y'; }).map(_loc));
    },

    createLocation: function (data) {
      if (config.apiBase) return api.post('/locations/', data);
      var s = loadStore();
      var now = new Date().toISOString();
      var user = (window._hrCurrentUser && window._hrCurrentUser.displayName) || 'System Administrator';
      var newLoc = Object.assign({ locationId: Date.now(), isActive: 'Y', created_by: user, created_at: now, updated_by: user, updated_at: now }, data);
      s.locations.push(newLoc);
      saveStore(s);
      return Promise.resolve(_loc(newLoc));
    },

    updateLocation: function (locationId, data) {
      if (config.apiBase) return api.put('/locations/' + locationId, data);
      var s = loadStore();
      var idx = s.locations.findIndex(function (l) { return l.locationId === parseInt(locationId); });
      if (idx >= 0) {
        var now = new Date().toISOString();
        var user = (window._hrCurrentUser && window._hrCurrentUser.displayName) || 'System Administrator';
        s.locations[idx] = Object.assign({}, s.locations[idx], data, { updated_by: user, updated_at: now });
        saveStore(s);
        return Promise.resolve(_loc(s.locations[idx]));
      }
      return Promise.reject({ message: 'Location not found' });
    },

    // ── Assignments ────────────────────────────────────────────────────
    getAssignments: function (personId) {
      if (config.apiBase) return api.get('/assignments/' + personId).then(function (d) { return d.items || []; });
      var s = loadStore();
      return Promise.resolve(s.assignments.filter(function (a) { return a.personId === parseInt(personId); }));
    },

    createAssignment: function (data) {
      if (config.apiBase) return api.post('/assignments/', data);
      var s = loadStore();
      var rec = Object.assign({ assignmentId: Date.now(), assignmentNumber: 'ASGN-MOCK-' + Date.now(), assignmentStatus: 'ACTIVE' }, data);
      s.assignments.push(rec);
      saveStore(s);
      return Promise.resolve(rec);
    },

    endAssignment: function (id, data) {
      if (config.apiBase) return api.put('/assignments/' + id + '/end/', data);
      var s = loadStore();
      var idx = s.assignments.findIndex(function (a) { return (a.assignmentId || a.assignment_id) === parseInt(id); });
      if (idx >= 0) {
        s.assignments[idx] = Object.assign({}, s.assignments[idx], { assignmentStatus: 'ENDED', end_date: data.end_date });
        saveStore(s);
        return Promise.resolve({});
      }
      return Promise.reject({ message: 'Assignment not found' });
    },

    // ── Contracts ──────────────────────────────────────────────────────
    getContracts: function (personId) {
      if (config.apiBase) return api.get('/contracts/' + personId).then(function (d) { return d.items || []; });
      return Promise.resolve(loadStore().contracts.filter(function (c) { return c.personId === parseInt(personId); }));
    },

    createContract: function (data) {
      if (config.apiBase) return api.post('/contracts/', data);
      var s = loadStore();
      var rec = Object.assign({ contractId: Date.now(), contractStatus: 'ACTIVE' }, data);
      s.contracts.push(rec);
      saveStore(s);
      return Promise.resolve(rec);
    },

    updateContract: function (id, data) {
      if (config.apiBase) return api.put('/contracts/update/' + id, data);
      var s = loadStore();
      var idx = s.contracts.findIndex(function (c) { return (c.contractId || c.contract_id) === parseInt(id); });
      if (idx >= 0) { s.contracts[idx] = Object.assign({}, s.contracts[idx], data); saveStore(s); return Promise.resolve({}); }
      return Promise.reject({ message: 'Contract not found' });
    },

    // ── Salary ────────────────────────────────────────────────────────
    getSalaryHistory: function (personId) {
      if (config.apiBase) return api.get('/salary/' + personId).then(function (d) { return d.items || []; });
      return Promise.resolve(loadStore().salaries.filter(function (s) { return s.personId === parseInt(personId); }));
    },

    addSalaryEntry: function (data) {
      if (config.apiBase) return api.post('/salary/', data);
      var s = loadStore();
      var rec = Object.assign({ salaryId: Date.now() }, data);
      s.salaries.push(rec);
      saveStore(s);
      return Promise.resolve(rec);
    },

    // ── Document Types ─────────────────────────────────────────────────
    getDocTypes: function () {
      if (config.apiBase) return api.get('/doc-types/').then(function (d) { return (d.items || []).map(_docType); });
      return Promise.resolve([]);
    },

    // ── Documents ──────────────────────────────────────────────────────
    getDocuments: function (personId) {
      if (config.apiBase) return api.get('/documents/' + personId).then(function (d) { return (d.items || []).map(_doc); });
      return Promise.resolve(loadStore().documents.filter(function (d) { return d.personId === parseInt(personId); }).map(_doc));
    },

    addDocument: function (data) {
      if (config.apiBase) return api.post('/documents/', data);
      var s = loadStore();
      var newDoc = Object.assign({ docId: Date.now() }, data);
      s.documents.push(newDoc);
      saveStore(s);
      return Promise.resolve(_doc(newDoc));
    },

    updateDocument: function (docId, data) {
      if (config.apiBase) return api.put('/documents/update/' + docId, data);
      var s = loadStore();
      var idx = s.documents.findIndex(function (d) { return d.docId === parseInt(docId); });
      if (idx >= 0) { s.documents[idx] = Object.assign({}, s.documents[idx], data); saveStore(s); return Promise.resolve(_doc(s.documents[idx])); }
      return Promise.reject({ message: 'Document not found' });
    },

    uploadDocFile: function (docId, file) {
      if (config.apiBase) {
        return file.arrayBuffer().then(function (buf) {
          var url = config.apiBase + '/documents/file/' + docId
            + '?file_name='      + encodeURIComponent(file.name)
            + '&file_mime_type=' + encodeURIComponent(file.type || 'application/octet-stream');
          return fetch(url, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/octet-stream' },
            body: buf,
          }).then(function (r) {
            if (!r.ok) return Promise.reject({ status: r.status, message: 'File upload failed' });
            return {};
          });
        });
      }
      // mock: store as data URL in localStorage
      return new Promise(function (resolve, reject) {
        var reader = new FileReader();
        reader.onload = function (e) {
          var key = 'hr_doc_file_' + docId;
          try {
            localStorage.setItem(key, JSON.stringify({ name: file.name, type: file.type, data: e.target.result }));
          } catch (ex) { /* storage full — silently skip */ }
          resolve({});
        };
        reader.onerror = function () { reject({ message: 'Failed to read file' }); };
        reader.readAsDataURL(file);
      });
    },

    getDocFileUrl: function (docId, fileName) {
      if (config.apiBase) {
        return config.apiBase + '/documents/file/' + docId;
      }
      // mock: return data URL from localStorage
      var raw = localStorage.getItem('hr_doc_file_' + docId);
      if (!raw) return null;
      try { return JSON.parse(raw).data; } catch (e) { return null; }
    },

    getExpiringDocs: function (days) {
      days = days || 90;
      if (config.apiBase) return api.get('/reports/expiry-alerts/?days=' + days).then(function (d) { return (d.items || []).map(_doc); });
      var list = loadStore().documents.filter(function (d) { return d.daysUntilExpiry != null && d.daysUntilExpiry <= days; });
      list.sort(function (a, b) { return (a.daysUntilExpiry || 0) - (b.daysUntilExpiry || 0); });
      return Promise.resolve(list.map(_doc));
    },

    // ── Lookups ────────────────────────────────────────────────────────
    getLookupCategories: function () {
      if (config.apiBase) return api.get('/lookups/').then(function (d) { return d.items || []; });
      return Promise.resolve([
        { category_code: 'HR_GENDER',      category_name_en: 'Gender' },
        { category_code: 'HR_MARITAL',     category_name_en: 'Marital Status' },
        { category_code: 'HR_DOC_TYPE',    category_name_en: 'Document Type' },
        { category_code: 'HR_DOC_STATUS',  category_name_en: 'Document Status' },
        { category_code: 'HR_ORG_TYPE',    category_name_en: 'Org Type' },
        { category_code: 'HR_GRADE',       category_name_en: 'Employee Grade' },
        { category_code: 'HR_CONTRACT',    category_name_en: 'Contract Type' },
        { category_code: 'HR_ASSIGNMENT',  category_name_en: 'Assignment Type' },
        { category_code: 'HR_END_REASON',  category_name_en: 'End Reason' },
        { category_code: 'HR_LOCATION',    category_name_en: 'Location Type' },
      ]);
    },

    getLookupValues: function (categoryCode) {
      if (config.apiBase) return api.get('/lookups/' + categoryCode).then(function (d) { return d.items || []; });
      var mock = {
        HR_GRADE_CATEGORY: [
          { value_id: 50, value_code: 'SUPPORT',      value_name_en: 'Support',      display_order: 10 },
          { value_id: 51, value_code: 'TECHNICAL',    value_name_en: 'Technical',    display_order: 20 },
          { value_id: 52, value_code: 'PROFESSIONAL', value_name_en: 'Professional', display_order: 30 },
          { value_id: 53, value_code: 'EXECUTIVE',    value_name_en: 'Executive',    display_order: 40 },
        ],
        HR_ASSIGNMENT_TYPE: [
          { value_id: 1, value_code: 'PRIMARY',    value_name_en: 'Primary' },
          { value_id: 2, value_code: 'ACTING',     value_name_en: 'Acting' },
          { value_id: 3, value_code: 'SECONDMENT', value_name_en: 'Secondment' },
          { value_id: 4, value_code: 'DUAL',       value_name_en: 'Dual Role' },
        ],
        HR_END_REASON: [
          { value_id: 10, value_code: 'TRANSFER',        value_name_en: 'Transfer' },
          { value_id: 11, value_code: 'PROMOTION',       value_name_en: 'Promotion' },
          { value_id: 12, value_code: 'RESIGNATION',     value_name_en: 'Resignation' },
          { value_id: 13, value_code: 'RETIREMENT',      value_name_en: 'Retirement' },
          { value_id: 14, value_code: 'TERMINATION',     value_name_en: 'Termination' },
          { value_id: 15, value_code: 'CONTRACT_END',    value_name_en: 'Contract End' },
          { value_id: 16, value_code: 'RESTRUCTURING',   value_name_en: 'Restructuring' },
        ],
        HR_CONTRACT_TYPE: [
          { value_id: 20, value_code: 'PERMANENT',  value_name_en: 'Permanent' },
          { value_id: 21, value_code: 'FIXED_TERM', value_name_en: 'Fixed Term' },
          { value_id: 22, value_code: 'SECONDMENT', value_name_en: 'Secondment' },
          { value_id: 23, value_code: 'INTERNSHIP', value_name_en: 'Internship' },
          { value_id: 24, value_code: 'CONSULTANT', value_name_en: 'Consultant' },
        ],
        HR_SALARY_REASON: [
          { value_id: 30, value_code: 'HIRE',             value_name_en: 'Initial Hire' },
          { value_id: 31, value_code: 'PROMOTION',        value_name_en: 'Promotion' },
          { value_id: 32, value_code: 'ANNUAL_INCREMENT', value_name_en: 'Annual Increment' },
          { value_id: 33, value_code: 'MARKET_ADJUSTMENT',value_name_en: 'Market Adjustment' },
          { value_id: 34, value_code: 'ACTING_ALLOWANCE', value_name_en: 'Acting Allowance' },
          { value_id: 35, value_code: 'CORRECTION',       value_name_en: 'Correction' },
        ],
      };
      return Promise.resolve(mock[categoryCode] || []);
    },

    createLookupCategory: function (data) {
      if (config.apiBase) return api.post('/lookups/category/', data);
      return Promise.resolve(data);
    },

    createLookupValue: function (data) {
      if (config.apiBase) return api.post('/lookups/', data);
      return Promise.resolve(data);
    },

    updateLookupValue: function (valueId, data) {
      if (config.apiBase) return api.put('/lookups/value/' + valueId, data);
      return Promise.resolve(data);
    },

    reset: function () { localStorage.removeItem(STORE_KEY); },
  };
});
