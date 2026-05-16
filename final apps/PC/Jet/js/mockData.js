/**
 * mockData.js — Petty Cash module mock data mirroring DCT_PC_* tables.
 * Production: replace service calls with ORDS REST endpoints.
 */
define([], function () {
  'use strict';

  // ── Users ──────────────────────────────────────────────────────────────
  const USERS = [
    { userId: 1,  username: 'ADMIN',              displayName: 'System Administrator',       displayNameAr: 'مدير النظام',           email: 'admin@dct.gov.ae',           phone: '+971-2-400-0001', isActive: 'Y', orgId: 1,  orgName: 'Finance Division',              employeeNumber: 'ADM001', roles: ['SYS_ADMIN', 'AP_PETTY_CASH_ADMIN'],                     color: '#C74634', password: 'iFinance@2026' },
    { userId: 2,  username: 'HASHEM.ALKABBI',     displayName: 'Hashem Al Kabbi',            displayNameAr: 'هاشم الكعبي',           email: 'h.alkabbi@dct.gov.ae',       phone: '+971-2-400-0002', isActive: 'Y', orgId: 1,  orgName: 'Finance Division',              employeeNumber: 'EMP001', roles: ['TASK_DIRECTOR', 'MANAGER'],                             color: '#0572CE', password: 'Director@2026' },
    { userId: 3,  username: 'NASER.ALKHAJA',      displayName: 'Naser Mohamed Al Khaja',     displayNameAr: 'ناصر محمد الخاجة',     email: 'n.alkhaja@dct.gov.ae',       phone: '+971-2-400-0003', isActive: 'Y', orgId: 2,  orgName: 'Finance Operations',            employeeNumber: 'EMP002', roles: ['MANAGER', 'EMPLOYEE'],                                  color: '#2E7D32', password: 'Manager@2026' },
    { userId: 4,  username: 'AYESHA.AMERI',       displayName: 'Ayesha Abdul Kareem Ameri',  displayNameAr: 'عائشة عبد الكريم العامري', email: 'a.ameri@dct.gov.ae',    phone: '+971-2-400-0004', isActive: 'Y', orgId: 3,  orgName: 'Payables Operations',           employeeNumber: 'EMP003', roles: ['MANAGER', 'AP_PETTY_CASH_ADMIN', 'EMPLOYEE'],           color: '#8B0000', password: 'Manager@2026' },
    { userId: 5,  username: 'SHAIKHA.GALAMERI',   displayName: 'Shaikha Ghanem Al Ameri',    displayNameAr: 'شيخة غانم العامري',     email: 's.galameri@dct.gov.ae',     phone: '+971-2-400-0005', isActive: 'Y', orgId: 4,  orgName: 'Financial Planning & Budgeting', employeeNumber: 'EMP004', roles: ['MANAGER', 'EMPLOYEE'],                                 color: '#6A1B9A', password: 'Manager@2026' },
    { userId: 6,  username: 'SHAIKHA.ALSUWAIDI',  displayName: 'Shaikha Ahmed Al Suwaidi',   displayNameAr: 'شيخة أحمد السويدي',    email: 's.alsuwaidi@dct.gov.ae',    phone: '+971-2-400-0006', isActive: 'Y', orgId: 5,  orgName: 'Revenue Assurance',             employeeNumber: 'EMP005', roles: ['MANAGER', 'EMPLOYEE'],                                  color: '#00695C', password: 'Manager@2026' },
    { userId: 7,  username: 'NOORA.ALALI',        displayName: 'Noora Saeed Al Ali',         displayNameAr: 'نورة سعيد العلي',       email: 'n.alali@dct.gov.ae',         phone: '+971-2-400-0007', isActive: 'Y', orgId: 6,  orgName: 'Receivables Operations',        employeeNumber: 'EMP006', roles: ['MANAGER', 'EMPLOYEE'],                                  color: '#E65100', password: 'Manager@2026' },
    { userId: 8,  username: 'AHMED.HASSAN',       displayName: 'Ahmed Hassan Al Zaabi',      displayNameAr: 'أحمد حسن الزعابي',      email: 'a.hassan@dct.gov.ae',        phone: '+971-2-400-0008', isActive: 'Y', orgId: 2,  orgName: 'Finance Operations',            employeeNumber: 'EMP007', roles: ['EMPLOYEE'],                                             color: '#1565C0', password: 'Employee@2026' },
    { userId: 9,  username: 'MARIAM.KHALID',      displayName: 'Mariam Khalid Al Mansoori',  displayNameAr: 'مريم خالد المنصوري',   email: 'm.khalid@dct.gov.ae',        phone: '+971-2-400-0009', isActive: 'Y', orgId: 3,  orgName: 'Payables Operations',           employeeNumber: 'EMP008', roles: ['EMPLOYEE'],                                             color: '#00796B', password: 'Employee@2026' },
    { userId: 10, username: 'KHALID.RASHID',      displayName: 'Khalid Rashid Al Qubaisi',   displayNameAr: 'خالد راشد القبيسي',    email: 'k.rashid@dct.gov.ae',        phone: '+971-2-400-0010', isActive: 'Y', orgId: 4,  orgName: 'Financial Planning & Budgeting', employeeNumber: 'EMP009', roles: ['EMPLOYEE'],                                            color: '#5D4037', password: 'Employee@2026' },
  ];

  // ── GL Code Combinations ───────────────────────────────────────────────
  const GL_CODES = [
    { ccId: 1,  entityCode: '001', appropriation: 'ADMIN', costCenter: 'CC01', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 2,  entityCode: '001', appropriation: 'ADMIN', costCenter: 'CC01', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5200', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 3,  entityCode: '001', appropriation: 'ADMIN', costCenter: 'CC02', entitySpecific: 'ES02', budgetGroupCode: 'BG02', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 4,  entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 5,  entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5300', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 6,  entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC04', entitySpecific: 'ES02', budgetGroupCode: 'BG02', account: '5200', ic: '001', future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 7,  entityCode: '002', appropriation: 'PAYABLES', costCenter: 'CC05', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 8,  entityCode: '002', appropriation: 'PAYABLES', costCenter: 'CC05', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5400', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 9,  entityCode: '002', appropriation: 'REVENUE', costCenter: 'CC06', entitySpecific: 'ES03', budgetGroupCode: 'BG03', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 10, entityCode: '003', appropriation: 'BUDGET', costCenter: 'CC07', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
    { ccId: 11, entityCode: '003', appropriation: 'BUDGET', costCenter: 'CC07', entitySpecific: 'ES01', budgetGroupCode: 'BG02', account: '5200', ic: null, future1: null, future2: null, isActive: 'N', startDate: '2025-01-01', endDate: '2025-12-31' },
    { ccId: 12, entityCode: '003', appropriation: 'PLANNING', costCenter: 'CC08', entitySpecific: 'ES04', budgetGroupCode: 'BG01', account: '5100', ic: null, future1: null, future2: null, isActive: 'Y', startDate: '2026-01-01', endDate: null },
  ];

  // ── Petty Cash Records ─────────────────────────────────────────────────
  const PETTY_CASH = [
    {
      pcId: 1, pcNumber: 'PC-2026-00001', userId: 3, employeeName: 'Naser Mohamed Al Khaja',
      employeeNumber: 'EMP002', orgName: 'Finance Operations',
      pcType: 'TEMPORARY', amount: 5000, purpose: 'Office supplies and stationery for Finance Operations Q1 2026',
      status: 'ACTIVE', codingType: 'GL', fiscalYear: 2026,
      requestDate: '2026-01-15', dueDate: '2026-06-30',
      submittedAt: '2026-01-15T09:00:00', approvedDate: '2026-01-20',
      disbursedDate: '2026-01-22', disbursedBy: 4,
      totalReimbursed: 1800, currentFloatBalance: 3200, clearedAmount: 0, refundedAmount: 0,
      createdAt: '2026-01-15T09:00:00',
    },
    {
      pcId: 2, pcNumber: 'PC-2026-00002', userId: 5, employeeName: 'Shaikha Ghanem Al Ameri',
      employeeNumber: 'EMP004', orgName: 'Financial Planning & Budgeting',
      pcType: 'TEMPORARY', amount: 3000, purpose: 'Budget planning workshop expenses and team coordination costs',
      status: 'PENDING_APPROVAL', codingType: 'GL', fiscalYear: 2026,
      requestDate: '2026-05-10', dueDate: '2026-12-31',
      submittedAt: '2026-05-10T10:30:00', approvedDate: null,
      disbursedDate: null, disbursedBy: null,
      totalReimbursed: 0, currentFloatBalance: 3000, clearedAmount: 0, refundedAmount: 0,
      createdAt: '2026-05-10T10:30:00',
    },
    {
      pcId: 3, pcNumber: 'PC-2026-00003', userId: 6, employeeName: 'Shaikha Ahmed Al Suwaidi',
      employeeNumber: 'EMP005', orgName: 'Revenue Assurance',
      pcType: 'PERMANENT', amount: 25000, purpose: 'Revenue monitoring field operations and audit travel expenses (permanent float)',
      status: 'PENDING_APPROVAL', codingType: 'PROJECT', fiscalYear: 2026,
      requestDate: '2026-05-12', dueDate: null,
      submittedAt: '2026-05-12T14:00:00', approvedDate: null,
      disbursedDate: null, disbursedBy: null,
      totalReimbursed: 0, currentFloatBalance: 25000, clearedAmount: 0, refundedAmount: 0,
      createdAt: '2026-05-12T14:00:00',
    },
    {
      pcId: 4, pcNumber: 'PC-2025-00015', userId: 3, employeeName: 'Naser Mohamed Al Khaja',
      employeeNumber: 'EMP002', orgName: 'Finance Operations',
      pcType: 'TEMPORARY', amount: 2000, purpose: 'Year-end reconciliation expenses and documentation',
      status: 'CLOSED', codingType: 'GL', fiscalYear: 2025,
      requestDate: '2025-10-01', dueDate: '2025-12-31',
      submittedAt: '2025-10-01T08:00:00', approvedDate: '2025-10-05',
      disbursedDate: '2025-10-07', disbursedBy: 4,
      totalReimbursed: 1200, currentFloatBalance: 0, clearedAmount: 800, refundedAmount: 0,
      closedDate: '2025-12-20', createdAt: '2025-10-01T08:00:00',
    },
    {
      pcId: 5, pcNumber: 'PC-2026-00004', userId: 7, employeeName: 'Noora Saeed Al Ali',
      employeeNumber: 'EMP006', orgName: 'Receivables Operations',
      pcType: 'TEMPORARY', amount: 1500, purpose: 'Receivables audit documentation and external audit support',
      status: 'ACTIVE', codingType: 'GL', fiscalYear: 2026,
      requestDate: '2026-03-01', dueDate: '2026-06-30',
      submittedAt: '2026-03-01T09:30:00', approvedDate: '2026-03-05',
      disbursedDate: '2026-03-07', disbursedBy: 4,
      totalReimbursed: 500, currentFloatBalance: 1000, clearedAmount: 0, refundedAmount: 0,
      createdAt: '2026-03-01T09:30:00',
    },
    {
      pcId: 6, pcNumber: 'PC-2026-00005', userId: 8, employeeName: 'Ahmed Hassan Al Zaabi',
      employeeNumber: 'EMP007', orgName: 'Finance Operations',
      pcType: 'TEMPORARY', amount: 800, purpose: 'Training materials and certification exam fees',
      status: 'APPROVED', codingType: 'GL', fiscalYear: 2026,
      requestDate: '2026-05-05', dueDate: '2026-09-30',
      submittedAt: '2026-05-05T11:00:00', approvedDate: '2026-05-10',
      disbursedDate: null, disbursedBy: null,
      totalReimbursed: 0, currentFloatBalance: 800, clearedAmount: 0, refundedAmount: 0,
      createdAt: '2026-05-05T11:00:00',
    },
  ];

  // ── Budget Lines ───────────────────────────────────────────────────────
  const PC_BUDGET_LINES = [
    { lineId: 1, pcId: 1, lineNum: 1, codingType: 'GL', amount: 3000, ccId: 4, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', description: 'Office supplies' },
    { lineId: 2, pcId: 1, lineNum: 2, codingType: 'GL', amount: 2000, ccId: 5, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5300', description: 'Stationery' },
    { lineId: 3, pcId: 2, lineNum: 1, codingType: 'GL', amount: 3000, ccId: 10, entityCode: '003', appropriation: 'BUDGET', costCenter: 'CC07', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', description: 'Workshop expenses' },
    { lineId: 4, pcId: 3, lineNum: 1, codingType: 'PROJECT', amount: 25000, projectNumber: 'PRJ-2026-001', taskNumber: 'TASK-001', expenditureType: 'TRAVEL', description: 'Revenue audit travel' },
    { lineId: 5, pcId: 5, lineNum: 1, codingType: 'GL', amount: 1500, ccId: 9, entityCode: '002', appropriation: 'REVENUE', costCenter: 'CC06', entitySpecific: 'ES03', budgetGroupCode: 'BG03', account: '5100', description: 'Audit documentation' },
    { lineId: 6, pcId: 6, lineNum: 1, codingType: 'GL', amount: 800, ccId: 4, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', description: 'Training & certification' },
  ];

  // ── Reimbursements ─────────────────────────────────────────────────────
  const REIMBURSEMENTS = [
    {
      reimbId: 1, reimbNumber: 'RMB-2026-00001', pcId: 1,
      amount: 1200, purpose: 'Office supply purchases — January batch', codingType: 'GL',
      status: 'APPROVED', submittedAt: '2026-02-10T09:00:00', approvedAt: '2026-02-12T14:00:00',
      createdAt: '2026-02-10T09:00:00',
    },
    {
      reimbId: 2, reimbNumber: 'RMB-2026-00002', pcId: 1,
      amount: 600, purpose: 'Stationery and printing — March batch', codingType: 'GL',
      status: 'APPROVED', submittedAt: '2026-03-15T10:00:00', approvedAt: '2026-03-17T11:30:00',
      createdAt: '2026-03-15T10:00:00',
    },
    {
      reimbId: 3, reimbNumber: 'RMB-2026-00003', pcId: 5,
      amount: 500, purpose: 'External auditor liaison costs', codingType: 'GL',
      status: 'PENDING_APPROVAL', submittedAt: '2026-05-14T08:30:00', approvedAt: null,
      createdAt: '2026-05-14T08:30:00',
    },
  ];

  const REIMB_BUDGET_LINES = [
    { lineId: 1, reimbId: 1, lineNum: 1, codingType: 'GL', amount: 800, ccId: 4, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', description: 'Supplies Jan' },
    { lineId: 2, reimbId: 1, lineNum: 2, codingType: 'GL', amount: 400, ccId: 5, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5300', description: 'Stationery Jan' },
    { lineId: 3, reimbId: 2, lineNum: 1, codingType: 'GL', amount: 600, ccId: 5, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5300', description: 'Stationery Mar' },
    { lineId: 4, reimbId: 3, lineNum: 1, codingType: 'GL', amount: 500, ccId: 9, entityCode: '002', appropriation: 'REVENUE', costCenter: 'CC06', entitySpecific: 'ES03', budgetGroupCode: 'BG03', account: '5100', description: 'Auditor costs' },
  ];

  // ── Clearings ──────────────────────────────────────────────────────────
  const CLEARINGS = [
    {
      clearingId: 1, clearingNumber: 'CLR-2025-00001', pcId: 4,
      amountSpent: 2000, amountRefunded: 0, codingType: 'GL',
      status: 'APPROVED', submittedAt: '2025-12-15T09:00:00', approvedAt: '2025-12-20T10:00:00',
      createdAt: '2025-12-15T09:00:00',
    },
  ];

  const CLEAR_BUDGET_LINES = [
    { lineId: 1, clearingId: 1, lineNum: 1, codingType: 'GL', amount: 1200, ccId: 4, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5100', description: 'Office supplies' },
    { lineId: 2, clearingId: 1, lineNum: 2, codingType: 'GL', amount: 800,  ccId: 5, entityCode: '001', appropriation: 'FINANCE', costCenter: 'CC03', entitySpecific: 'ES01', budgetGroupCode: 'BG01', account: '5300', description: 'Stationery' },
  ];

  // ── Approval Templates ─────────────────────────────────────────────────
  const APPROVAL_TEMPLATES = [
    { templateId: 1, templateCode: 'PC_ADVANCE',   templateName: 'Petty Cash Advance Approval',    requestType: 'PETTY_CASH',    isSequential: 'Y', autoApproveDays: 3, isActive: 'Y' },
    { templateId: 2, templateCode: 'PC_REIMB',     templateName: 'Reimbursement Approval',          requestType: 'REIMBURSEMENT', isSequential: 'Y', autoApproveDays: 2, isActive: 'Y' },
    { templateId: 3, templateCode: 'PC_CLEARING',  templateName: 'Clearing Request Approval',       requestType: 'CLEARING',      isSequential: 'Y', autoApproveDays: 3, isActive: 'Y' },
  ];

  const APPROVAL_STEPS = [
    // Advance workflow
    { stepId: 1, templateId: 1, stepSeq: 1, stepName: 'Manager Approval',         requiredRole: 'MANAGER',            conditionType: 'ALWAYS',      amountOperator: null, amountThreshold: null, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 3, isActive: 'Y' },
    { stepId: 2, templateId: 1, stepSeq: 2, stepName: 'AP Admin Approval',         requiredRole: 'AP_PETTY_CASH_ADMIN', conditionType: 'AMOUNT',      amountOperator: '>=', amountThreshold: 5000, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
    { stepId: 3, templateId: 1, stepSeq: 3, stepName: 'Finance Director Approval', requiredRole: 'TASK_DIRECTOR',      conditionType: 'AMOUNT',      amountOperator: '>=', amountThreshold: 20000, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 3, isActive: 'Y' },
    { stepId: 4, templateId: 1, stepSeq: 4, stepName: 'AP Admin Final (Permanent)',requiredRole: 'AP_PETTY_CASH_ADMIN', conditionType: 'TYPE_FILTER', amountOperator: null, amountThreshold: null, typeFilter: 'PERMANENT', isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
    // Reimbursement workflow
    { stepId: 5, templateId: 2, stepSeq: 1, stepName: 'Manager Approval',         requiredRole: 'MANAGER',            conditionType: 'ALWAYS',      amountOperator: null, amountThreshold: null, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
    { stepId: 6, templateId: 2, stepSeq: 2, stepName: 'AP Admin Approval',         requiredRole: 'AP_PETTY_CASH_ADMIN', conditionType: 'ALWAYS',     amountOperator: null, amountThreshold: null, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
    // Clearing workflow
    { stepId: 7, templateId: 3, stepSeq: 1, stepName: 'Manager Approval',         requiredRole: 'MANAGER',            conditionType: 'ALWAYS',      amountOperator: null, amountThreshold: null, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
    { stepId: 8, templateId: 3, stepSeq: 2, stepName: 'AP Admin Approval',         requiredRole: 'AP_PETTY_CASH_ADMIN', conditionType: 'ALWAYS',     amountOperator: null, amountThreshold: null, typeFilter: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
  ];

  // ── Approval Instances ─────────────────────────────────────────────────
  const APPROVAL_INSTANCES = [
    { instanceId: 1, templateId: 1, sourceModule: 'PETTY_CASH',    sourceRecordId: 2, sourceRecordRef: 'PC-2026-00002', submittedBy: 5, submittedAt: '2026-05-10T10:30:00', currentStepSeq: 1, overallStatus: 'PENDING' },
    { instanceId: 2, templateId: 1, sourceModule: 'PETTY_CASH',    sourceRecordId: 3, sourceRecordRef: 'PC-2026-00003', submittedBy: 6, submittedAt: '2026-05-12T14:00:00', currentStepSeq: 2, overallStatus: 'PENDING' },
    { instanceId: 3, templateId: 2, sourceModule: 'REIMBURSEMENT', sourceRecordId: 3, sourceRecordRef: 'RMB-2026-00003', submittedBy: 7, submittedAt: '2026-05-14T08:30:00', currentStepSeq: 1, overallStatus: 'PENDING' },
    { instanceId: 4, templateId: 1, sourceModule: 'PETTY_CASH',    sourceRecordId: 6, sourceRecordRef: 'PC-2026-00005', submittedBy: 8, submittedAt: '2026-05-05T11:00:00', currentStepSeq: 2, overallStatus: 'PENDING' },
    // Completed instances
    { instanceId: 5, templateId: 1, sourceModule: 'PETTY_CASH',    sourceRecordId: 1, sourceRecordRef: 'PC-2026-00001', submittedBy: 3, submittedAt: '2026-01-15T09:00:00', currentStepSeq: null, overallStatus: 'APPROVED' },
    { instanceId: 6, templateId: 1, sourceModule: 'PETTY_CASH',    sourceRecordId: 5, sourceRecordRef: 'PC-2026-00004', submittedBy: 7, submittedAt: '2026-03-01T09:30:00', currentStepSeq: null, overallStatus: 'APPROVED' },
  ];

  const APPROVAL_ACTIONS = [
    { actionId: 1, instanceId: 1, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',   action: 'APPROVED',  comments: 'Approved. Reasonable amount for office supplies.', actionedAt: '2026-01-16T10:00:00' },
    { actionId: 2, instanceId: 5, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',   action: 'APPROVED',  comments: 'Approved.', actionedAt: '2026-01-16T10:00:00' },
    { actionId: 3, instanceId: 5, stepSeq: 2, actionedBy: 4, actionedByName: 'Ayesha Ameri',      action: 'APPROVED',  comments: 'Amount >= 5,000 AED — reviewed and approved.', actionedAt: '2026-01-20T09:00:00' },
    { actionId: 4, instanceId: 6, stepSeq: 1, actionedBy: 7, actionedByName: 'Noora Saeed Al Ali', action: 'APPROVED', comments: 'Approved.', actionedAt: '2026-03-03T11:00:00' },
    { actionId: 5, instanceId: 6, stepSeq: 2, actionedBy: 4, actionedByName: 'Ayesha Ameri',      action: 'APPROVED',  comments: 'Reviewed. Amount within policy limits.', actionedAt: '2026-03-05T14:00:00' },
  ];

  // ── Module Settings ────────────────────────────────────────────────────
  const MODULE_SETTINGS = [
    { settingId: 1, settingKey: 'BUDGET_VALIDATION_MODE',     settingLabel: 'Budget Validation Mode',       settingDescription: 'HARD = block submission if over budget / SOFT = warn only', valueType: 'SELECT', allowedValues: 'HARD|SOFT', defaultValue: 'SOFT', settingValue: 'SOFT', effectiveDate: '2026-01-01' },
    { settingId: 2, settingKey: 'ALLOW_MULTIPLE_PC',           settingLabel: 'Allow Multiple Active PCs',    settingDescription: 'Allow employees to have more than one active petty cash',     valueType: 'BOOLEAN', allowedValues: 'Y|N',       defaultValue: 'N',    settingValue: 'N',    effectiveDate: '2026-01-01' },
    { settingId: 3, settingKey: 'MAX_PC_PER_EMPLOYEE',         settingLabel: 'Max Active PCs per Employee',  settingDescription: 'Maximum number of active petty cash allowed per employee',     valueType: 'NUMBER',  allowedValues: null,        defaultValue: '1',    settingValue: '1',    effectiveDate: '2026-01-01' },
    { settingId: 4, settingKey: 'MAX_PC_AMOUNT',               settingLabel: 'Maximum PC Advance Amount',    settingDescription: 'Maximum allowed advance amount in AED (blank = no limit)',     valueType: 'NUMBER',  allowedValues: null,        defaultValue: null,   settingValue: null,   effectiveDate: '2026-01-01' },
    { settingId: 5, settingKey: 'FISCAL_YEAR_START_MONTH',     settingLabel: 'Fiscal Year Start Month',      settingDescription: 'Month number when fiscal year starts (1 = January)',           valueType: 'NUMBER',  allowedValues: null,        defaultValue: '1',    settingValue: '1',    effectiveDate: '2026-01-01' },
    { settingId: 6, settingKey: 'SHOW_CLOSING_BANNER',         settingLabel: 'Show Closing Deadline Banner', settingDescription: 'Show fiscal year closing deadline banner on dashboard',         valueType: 'BOOLEAN', allowedValues: 'Y|N',       defaultValue: 'Y',    settingValue: 'Y',    effectiveDate: '2026-01-01' },
    { settingId: 7, settingKey: 'TEMP_PC_CLOSING_DEADLINE_MSG',settingLabel: 'Closing Deadline Message',     settingDescription: 'Banner message shown to employees with active Temporary PC',   valueType: 'TEXT',    allowedValues: null,        defaultValue: '',     settingValue: 'Reminder: All Temporary Petty Cash advances must be cleared before 31 December 2026. Please submit your clearing request at least 2 weeks before the deadline.', effectiveDate: '2026-01-01' },
  ];

  // ── Notifications ──────────────────────────────────────────────────────
  const NOTIFICATIONS = [
    { notifId: 1, type: 'APPROVAL', titleEn: 'Approval Required — PC-2026-00002', bodyEn: 'Shaikha Ghanem Al Ameri has submitted a petty cash advance request of 3,000 AED for your approval.', isRead: 'N', targetUserId: 2, createdAt: '2026-05-10T10:30:00' },
    { notifId: 2, type: 'APPROVAL', titleEn: 'Approval Required — RMB-2026-00003', bodyEn: 'Noora Saeed Al Ali has submitted a reimbursement request of 500 AED for your approval.', isRead: 'N', targetUserId: 7, createdAt: '2026-05-14T08:30:00' },
    { notifId: 3, type: 'INFO',    titleEn: 'Petty Cash Disbursed — PC-2026-00001', bodyEn: 'Your petty cash advance of 5,000 AED (PC-2026-00001) has been approved and disbursed. Your float is now active.', isRead: 'Y', targetUserId: 3, createdAt: '2026-01-22T10:00:00' },
    { notifId: 4, type: 'INFO',    titleEn: 'Reimbursement Approved — RMB-2026-00001', bodyEn: 'Your reimbursement request of 1,200 AED has been approved. Your float balance has been updated.', isRead: 'Y', targetUserId: 3, createdAt: '2026-02-12T14:00:00' },
    { notifId: 5, type: 'WARNING', titleEn: 'Year-End Closing Reminder', bodyEn: 'Reminder: All Temporary Petty Cash advances must be cleared before 31 December 2026.', isRead: 'N', targetUserId: 3, createdAt: '2026-05-01T08:00:00' },
    { notifId: 6, type: 'WARNING', titleEn: 'Year-End Closing Reminder', bodyEn: 'Reminder: All Temporary Petty Cash advances must be cleared before 31 December 2026.', isRead: 'N', targetUserId: 7, createdAt: '2026-05-01T08:00:00' },
  ];

  // ── Project Budget (mock view) ─────────────────────────────────────────
  const PROJECT_BUDGET = [
    { projectNumber: 'PRJ-2026-001', taskNumber: 'TASK-001', expenditureType: 'TRAVEL',    budget: 50000, actual: 22000, encumbrance: 5000, fundAvailable: 23000 },
    { projectNumber: 'PRJ-2026-001', taskNumber: 'TASK-001', expenditureType: 'SUPPLIES',  budget: 10000, actual: 3000,  encumbrance: 0,    fundAvailable: 7000  },
    { projectNumber: 'PRJ-2026-001', taskNumber: 'TASK-002', expenditureType: 'TRAVEL',    budget: 20000, actual: 8000,  encumbrance: 2000, fundAvailable: 10000 },
    { projectNumber: 'PRJ-2026-002', taskNumber: 'TASK-001', expenditureType: 'EQUIPMENT', budget: 80000, actual: 40000, encumbrance: 10000,fundAvailable: 30000 },
    { projectNumber: 'PRJ-2026-002', taskNumber: 'TASK-002', expenditureType: 'TRAVEL',    budget: 15000, actual: 6000,  encumbrance: 0,    fundAvailable: 9000  },
  ];

  return {
    USERS,
    GL_CODES,
    PETTY_CASH,
    PC_BUDGET_LINES,
    REIMBURSEMENTS,
    REIMB_BUDGET_LINES,
    CLEARINGS,
    CLEAR_BUDGET_LINES,
    APPROVAL_TEMPLATES,
    APPROVAL_STEPS,
    APPROVAL_INSTANCES,
    APPROVAL_ACTIONS,
    MODULE_SETTINGS,
    NOTIFICATIONS,
    PROJECT_BUDGET,
  };
});
