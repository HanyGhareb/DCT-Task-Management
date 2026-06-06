/**
 * mockData.js — HR module mock data for development / offline testing.
 * All writes in mock services persist to localStorage so state survives refresh.
 */
define([], function () {
  'use strict';

  return {

    USERS: [
      { userId: 1, username: 'ADMIN',            password: 'iFinance@2026', displayName: 'System Administrator', email: 'admin@dct.gov.ae',            color: '#C74634', roles: ['SYS_ADMIN','HR_ADMIN'],    isActive: 'Y', orgId: 1, orgName: 'Finance Division' },
      { userId: 2, username: 'HASHEM.ALKABBI',   password: 'Director@2026', displayName: 'Hashem Al Kabbi',      email: 'hashem.alkabbi@dct.gov.ae',   color: '#0572CE', roles: ['HR_MANAGER'],               isActive: 'Y', orgId: 1, orgName: 'Finance Division' },
      { userId: 3, username: 'NASER.ALKHAJA',    password: 'Manager@2026',  displayName: 'Naser Al Khaja',       email: 'naser.alkhaja@dct.gov.ae',    color: '#2E7D32', roles: ['HR_VIEWER'],                isActive: 'Y', orgId: 2, orgName: 'Finance Operations' },
      { userId: 4, username: 'AYESHA.AMERI',     password: 'Manager@2026',  displayName: 'Ayesha Ameri',         email: 'ayesha.ameri@dct.gov.ae',     color: '#6A1B9A', roles: ['HR_VIEWER'],                isActive: 'Y', orgId: 3, orgName: 'Payables Operations' },
      { userId: 5, username: 'HR.OFFICER',       password: 'HR@2026',       displayName: 'HR Officer',           email: 'hr.officer@dct.gov.ae',       color: '#1a7f5a', roles: ['HR_ADMIN'],                 isActive: 'Y', orgId: 1, orgName: 'Finance Division' },
    ],

    NOTIFICATIONS: [
      { notifId: 1, targetUserId: 1, title: 'Passport Expiring', body: 'Hashem Al Kabbi — passport expires in 28 days', isRead: 'N', createdAt: '2026-06-04T09:00:00Z', notifType: 'DOC_EXPIRY' },
      { notifId: 2, targetUserId: 1, title: 'Contract Renewal',  body: 'Naser Al Khaja contract expires in 45 days',    isRead: 'N', createdAt: '2026-06-03T14:00:00Z', notifType: 'CONTRACT'   },
      { notifId: 3, targetUserId: 5, title: 'New Assignment',    body: 'Ayesha Ameri assigned to Payables Manager role', isRead: 'Y', createdAt: '2026-06-01T11:00:00Z', notifType: 'ASSIGNMENT' },
    ],

    ORGS: [
      { orgId: 1,  orgCode: 'FIN-DIV',  orgNameEn: 'Finance Division',        orgType: 'DIVISION',   parentOrgId: null, levelNo: 1, isActive: 'Y', headcountCeiling: 50, costCenterCode: 'CC-FIN' },
      { orgId: 2,  orgCode: 'FIN-OPS',  orgNameEn: 'Finance Operations',      orgType: 'SECTION',    parentOrgId: 1,    levelNo: 2, isActive: 'Y', headcountCeiling: 10, costCenterCode: 'CC-OPS' },
      { orgId: 3,  orgCode: 'PAY-OPS',  orgNameEn: 'Payables Operations',     orgType: 'SECTION',    parentOrgId: 1,    levelNo: 2, isActive: 'Y', headcountCeiling: 8,  costCenterCode: 'CC-PAY' },
      { orgId: 4,  orgCode: 'FP-BUD',   orgNameEn: 'Financial Planning & Budgeting', orgType: 'SECTION', parentOrgId: 1, levelNo: 2, isActive: 'Y', headcountCeiling: 8, costCenterCode: 'CC-BUD' },
      { orgId: 5,  orgCode: 'REV-ASR',  orgNameEn: 'Revenue Assurance',       orgType: 'SECTION',    parentOrgId: 1,    levelNo: 2, isActive: 'Y', headcountCeiling: 6,  costCenterCode: 'CC-REV' },
      { orgId: 6,  orgCode: 'REC-OPS',  orgNameEn: 'Receivables Operations',  orgType: 'SECTION',    parentOrgId: 1,    levelNo: 2, isActive: 'Y', headcountCeiling: 8,  costCenterCode: 'CC-REC' },
    ],

    LOCATIONS: [
      { locationId: 1, locationCode: 'HQ-ABU', locationNameEn: 'DCT HQ — Abu Dhabi',      locationType: 'HQ',     emirate: 'Abu Dhabi', city: 'Abu Dhabi', isActive: 'Y' },
      { locationId: 2, locationCode: 'OFF-DXB', locationNameEn: 'DCT Office — Dubai',     locationType: 'BRANCH', emirate: 'Dubai',     city: 'Dubai',     isActive: 'Y' },
    ],

    JOB_FAMILIES: [
      { jobFamilyId: 1, familyCode: 'FIN',  familyNameEn: 'Finance',             isActive: 'Y', displayOrder: 1 },
      { jobFamilyId: 2, familyCode: 'HR',   familyNameEn: 'HR & Administration', isActive: 'Y', displayOrder: 2 },
      { jobFamilyId: 3, familyCode: 'IT',   familyNameEn: 'IT & Systems',        isActive: 'Y', displayOrder: 3 },
      { jobFamilyId: 4, familyCode: 'LEG',  familyNameEn: 'Legal & Compliance',  isActive: 'Y', displayOrder: 4 },
      { jobFamilyId: 5, familyCode: 'OPS',  familyNameEn: 'Operations',          isActive: 'Y', displayOrder: 5 },
      { jobFamilyId: 6, familyCode: 'RISK', familyNameEn: 'Risk & Audit',        isActive: 'Y', displayOrder: 6 },
    ],

    JOBS: [
      { jobId: 1,  jobCode: 'FIN-DIR',   jobNameEn: 'Finance Director',          jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G15', maxGradeCode: 'G16', isActive: 'Y' },
      { jobId: 2,  jobCode: 'PAY-MGR',   jobNameEn: 'Payables Manager',          jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G12', maxGradeCode: 'G14', isActive: 'Y' },
      { jobId: 3,  jobCode: 'BUD-MGR',   jobNameEn: 'Budget Manager',            jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G12', maxGradeCode: 'G14', isActive: 'Y' },
      { jobId: 4,  jobCode: 'REV-MGR',   jobNameEn: 'Revenue Assurance Manager', jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G12', maxGradeCode: 'G14', isActive: 'Y' },
      { jobId: 5,  jobCode: 'REC-MGR',   jobNameEn: 'Receivables Manager',       jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G12', maxGradeCode: 'G14', isActive: 'Y' },
      { jobId: 6,  jobCode: 'FIN-ANLT',  jobNameEn: 'Financial Analyst',         jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G8',  maxGradeCode: 'G11', isActive: 'Y' },
      { jobId: 7,  jobCode: 'PAY-SPEC',  jobNameEn: 'Accounts Payable Specialist', jobFamilyId: 1, jobFamily: 'Finance', minGradeCode: 'G6',  maxGradeCode: 'G9',  isActive: 'Y' },
      { jobId: 8,  jobCode: 'BUD-ANLT',  jobNameEn: 'Budget Analyst',            jobFamilyId: 1, jobFamily: 'Finance',   minGradeCode: 'G8',  maxGradeCode: 'G11', isActive: 'Y' },
      { jobId: 9,  jobCode: 'RISK-ANLT', jobNameEn: 'Risk Analyst',              jobFamilyId: 6, jobFamily: 'Risk & Audit', minGradeCode: 'G8', maxGradeCode: 'G11', isActive: 'Y' },
    ],

    POSITIONS: [
      { positionId: 1, positionCode: 'POS-2026-00001', positionNameEn: 'Finance Director',        jobId: 1, jobNameEn: 'Finance Director',    orgId: 1, orgNameEn: 'Finance Division',              gradeCode: 'G15', approvedHeadcount: 1, filledCount: 1, vacancyCount: 0, positionType: 'PERMANENT', isActive: 'Y' },
      { positionId: 2, positionCode: 'POS-2026-00002', positionNameEn: 'Payables Manager',        jobId: 2, jobNameEn: 'Payables Manager',     orgId: 3, orgNameEn: 'Payables Operations',          gradeCode: 'G13', approvedHeadcount: 1, filledCount: 1, vacancyCount: 0, positionType: 'PERMANENT', isActive: 'Y' },
      { positionId: 3, positionCode: 'POS-2026-00003', positionNameEn: 'Budget Manager',          jobId: 3, jobNameEn: 'Budget Manager',       orgId: 4, orgNameEn: 'Financial Planning & Budgeting', gradeCode: 'G13', approvedHeadcount: 1, filledCount: 1, vacancyCount: 0, positionType: 'PERMANENT', isActive: 'Y' },
      { positionId: 4, positionCode: 'POS-2026-00004', positionNameEn: 'Financial Analyst I',     jobId: 6, jobNameEn: 'Financial Analyst',    orgId: 2, orgNameEn: 'Finance Operations',            gradeCode: 'G9',  approvedHeadcount: 2, filledCount: 1, vacancyCount: 1, positionType: 'PERMANENT', isActive: 'Y' },
      { positionId: 5, positionCode: 'POS-2026-00005', positionNameEn: 'AP Specialist',           jobId: 7, jobNameEn: 'AP Specialist',        orgId: 3, orgNameEn: 'Payables Operations',          gradeCode: 'G7',  approvedHeadcount: 3, filledCount: 2, vacancyCount: 1, positionType: 'PERMANENT', isActive: 'Y' },
    ],

    EMPLOYEES: [
      {
        personId: 1, employeeNumber: 'EMP-0001', fullNameEn: 'Hashem Al Kabbi', firstNameEn: 'Hashem', lastNameEn: 'Al Kabbi',
        email: 'hashem.alkabbi@dct.gov.ae', mobile: '+971501234567', gender: 'M', hireDate: '2015-03-01',
        gradeCode: 'G15', gradeNameEn: 'Grade 15', orgId: 1, orgNameEn: 'Finance Division',
        jobTitleEn: 'Finance Director', nationalId: '784-1975-1234567-1', nationalityCode: 'ARE', nationalityEn: 'Emirati',
        isActive: 'Y', photoUrl: null, maritalStatus: 'Married',
        positionId: 1, positionNameEn: 'Finance Director', assignmentStatus: 'ACTIVE',
        basicSalary: 55000, salaryCurrency: 'AED',
      },
      {
        personId: 2, employeeNumber: 'EMP-0002', fullNameEn: 'Naser Al Khaja', firstNameEn: 'Naser', lastNameEn: 'Al Khaja',
        email: 'naser.alkhaja@dct.gov.ae', mobile: '+971502345678', gender: 'M', hireDate: '2017-06-15',
        gradeCode: 'G13', gradeNameEn: 'Grade 13', orgId: 2, orgNameEn: 'Finance Operations',
        jobTitleEn: 'Finance Operations Manager', nationalId: '784-1980-2345678-1', nationalityCode: 'ARE', nationalityEn: 'Emirati',
        isActive: 'Y', photoUrl: null, maritalStatus: 'Married',
        positionId: null, positionNameEn: null, assignmentStatus: 'ACTIVE',
        basicSalary: 35000, salaryCurrency: 'AED',
      },
      {
        personId: 3, employeeNumber: 'EMP-0003', fullNameEn: 'Ayesha Ameri', firstNameEn: 'Ayesha', lastNameEn: 'Ameri',
        email: 'ayesha.ameri@dct.gov.ae', mobile: '+971503456789', gender: 'F', hireDate: '2018-09-01',
        gradeCode: 'G13', gradeNameEn: 'Grade 13', orgId: 3, orgNameEn: 'Payables Operations',
        jobTitleEn: 'Payables Operations Manager', nationalId: '784-1985-3456789-1', nationalityCode: 'ARE', nationalityEn: 'Emirati',
        isActive: 'Y', photoUrl: null, maritalStatus: 'Single',
        positionId: 2, positionNameEn: 'Payables Manager', assignmentStatus: 'ACTIVE',
        basicSalary: 32000, salaryCurrency: 'AED',
      },
      {
        personId: 4, employeeNumber: 'EMP-0004', fullNameEn: 'Shaikha Al Ameri', firstNameEn: 'Shaikha', lastNameEn: 'Al Ameri',
        email: 'shaikha.galameri@dct.gov.ae', mobile: '+971504567890', gender: 'F', hireDate: '2019-01-15',
        gradeCode: 'G13', gradeNameEn: 'Grade 13', orgId: 4, orgNameEn: 'Financial Planning & Budgeting',
        jobTitleEn: 'Budget Manager', nationalId: '784-1988-4567890-1', nationalityCode: 'ARE', nationalityEn: 'Emirati',
        isActive: 'Y', photoUrl: null, maritalStatus: 'Married',
        positionId: 3, positionNameEn: 'Budget Manager', assignmentStatus: 'ACTIVE',
        basicSalary: 32000, salaryCurrency: 'AED',
      },
      {
        personId: 5, employeeNumber: 'EMP-0005', fullNameEn: 'Shaikha Al Suwaidi', firstNameEn: 'Shaikha', lastNameEn: 'Al Suwaidi',
        email: 'shaikha.alsuwaidi@dct.gov.ae', mobile: '+971505678901', gender: 'F', hireDate: '2020-03-01',
        gradeCode: 'G12', gradeNameEn: 'Grade 12', orgId: 5, orgNameEn: 'Revenue Assurance',
        jobTitleEn: 'Revenue Assurance Manager', nationalId: '784-1990-5678901-1', nationalityCode: 'ARE', nationalityEn: 'Emirati',
        isActive: 'Y', photoUrl: null, maritalStatus: 'Single',
        positionId: null, positionNameEn: null, assignmentStatus: 'ACTIVE',
        basicSalary: 30000, salaryCurrency: 'AED',
      },
      {
        personId: 6, employeeNumber: 'EMP-0006', fullNameEn: 'Noora Al Ali', firstNameEn: 'Noora', lastNameEn: 'Al Ali',
        email: 'noora.alali@dct.gov.ae', mobile: '+971506789012', gender: 'F', hireDate: '2021-07-01',
        gradeCode: 'G12', gradeNameEn: 'Grade 12', orgId: 6, orgNameEn: 'Receivables Operations',
        jobTitleEn: 'Receivables Operations Manager', nationalId: '784-1992-6789012-1', nationalityCode: 'ARE', nationalityEn: 'Emirati',
        isActive: 'Y', photoUrl: null, maritalStatus: 'Married',
        positionId: null, positionNameEn: null, assignmentStatus: 'ACTIVE',
        basicSalary: 30000, salaryCurrency: 'AED',
      },
    ],

    DOCUMENTS: [
      { docId: 1, personId: 1, fullNameEn: 'Hashem Al Kabbi',   orgNameEn: 'Finance Division',    docType: 'Passport',    docNumber: 'A1234567', issueDate: '2020-07-01', expiryDate: '2026-07-04', daysUntilExpiry: 28,   expiryAlert: 'CRITICAL', docStatus: 'Valid' },
      { docId: 2, personId: 2, fullNameEn: 'Naser Al Khaja',    orgNameEn: 'Finance Operations',  docType: 'Emirates ID', docNumber: '784-1980-2345678-1', issueDate: '2022-01-15', expiryDate: '2026-08-15', daysUntilExpiry: 70, expiryAlert: 'WARNING',  docStatus: 'Valid' },
      { docId: 3, personId: 3, fullNameEn: 'Ayesha Ameri',      orgNameEn: 'Payables Operations', docType: 'Passport',    docNumber: 'B2345678', issueDate: '2019-09-01', expiryDate: '2026-09-01', daysUntilExpiry: 87,   expiryAlert: 'UPCOMING', docStatus: 'Valid' },
      { docId: 4, personId: 4, fullNameEn: 'Shaikha Al Ameri',  orgNameEn: 'Financial Planning',  docType: 'Visa',        docNumber: 'V9012345', issueDate: '2025-01-15', expiryDate: '2026-06-10', daysUntilExpiry: 4,    expiryAlert: 'CRITICAL', docStatus: 'Valid' },
    ],

  };
});
