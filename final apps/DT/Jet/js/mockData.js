/**
 * mockData.js — Duty Travel module mock data mirroring DT_* tables.
 * Production: replace service calls with ORDS REST endpoints (/ords/admin/dt/).
 */
define([], function () {
  'use strict';

  // ── Users (includes gradeCode for per diem lookup) ─────────────────
  const USERS = [
    { userId: 1,  username: 'ADMIN',            displayName: 'System Administrator',       displayNameAr: 'مدير النظام',              email: 'admin@dct.gov.ae',           phone: '+971-2-400-0001', isActive: 'Y', orgId: 1,  orgName: 'Finance Division',               employeeNumber: 'ADM001', gradeCode: 'E1', roles: ['SYS_ADMIN', 'DT_ADMIN'],                  color: '#C74634', password: 'iFinance@2026' },
    { userId: 2,  username: 'HASHEM.ALKABBI',   displayName: 'Hashem Al Kabbi',            displayNameAr: 'هاشم الكعبي',              email: 'h.alkabbi@dct.gov.ae',       phone: '+971-2-400-0002', isActive: 'Y', orgId: 1,  orgName: 'Finance Division',               employeeNumber: 'EMP001', gradeCode: 'E2', roles: ['DT_MANAGER'],                             color: '#0572CE', password: 'Director@2026' },
    { userId: 3,  username: 'NASER.ALKHAJA',    displayName: 'Naser Mohamed Al Khaja',     displayNameAr: 'ناصر محمد الخاجة',        email: 'n.alkhaja@dct.gov.ae',       phone: '+971-2-400-0003', isActive: 'Y', orgId: 2,  orgName: 'Finance Operations',             employeeNumber: 'EMP002', gradeCode: 'E3', roles: ['DT_EMPLOYEE'],                            color: '#2E7D32', password: 'Manager@2026' },
    { userId: 4,  username: 'AYESHA.AMERI',     displayName: 'Ayesha Abdul Kareem Ameri',  displayNameAr: 'عائشة عبد الكريم العامري', email: 'a.ameri@dct.gov.ae',         phone: '+971-2-400-0004', isActive: 'Y', orgId: 3,  orgName: 'Payables Operations',            employeeNumber: 'EMP003', gradeCode: 'E3', roles: ['DT_FINANCE'],                             color: '#8B0000', password: 'Manager@2026' },
    { userId: 5,  username: 'SHAIKHA.GALAMERI', displayName: 'Shaikha Ghanem Al Ameri',    displayNameAr: 'شيخة غانم العامري',        email: 's.galameri@dct.gov.ae',     phone: '+971-2-400-0005', isActive: 'Y', orgId: 4,  orgName: 'Financial Planning & Budgeting', employeeNumber: 'EMP004', gradeCode: 'E4', roles: ['DT_EMPLOYEE'],                            color: '#6A1B9A', password: 'Manager@2026' },
    { userId: 6,  username: 'NOORA.ALALI',      displayName: 'Noora Saeed Al Ali',         displayNameAr: 'نورة سعيد العلي',          email: 'n.alali@dct.gov.ae',         phone: '+971-2-400-0007', isActive: 'Y', orgId: 6,  orgName: 'Receivables Operations',         employeeNumber: 'EMP006', gradeCode: 'E3', roles: ['DT_EMPLOYEE'],                            color: '#E65100', password: 'Manager@2026' },
  ];

  // ── Countries ──────────────────────────────────────────────────────
  const COUNTRIES = [
    { countryCode: 'AE', countryName: 'United Arab Emirates', region: 'GULF',  tier: 'HOME',  isActive: 'Y' },
    { countryCode: 'SA', countryName: 'Saudi Arabia',          region: 'GULF',  tier: 'GULF',  isActive: 'Y' },
    { countryCode: 'OM', countryName: 'Oman',                  region: 'GULF',  tier: 'GULF',  isActive: 'Y' },
    { countryCode: 'BH', countryName: 'Bahrain',               region: 'GULF',  tier: 'GULF',  isActive: 'Y' },
    { countryCode: 'KW', countryName: 'Kuwait',                region: 'GULF',  tier: 'GULF',  isActive: 'Y' },
    { countryCode: 'QA', countryName: 'Qatar',                 region: 'GULF',  tier: 'GULF',  isActive: 'Y' },
    { countryCode: 'US', countryName: 'United States',         region: 'AMER',  tier: 'HIGH',  isActive: 'Y' },
    { countryCode: 'GB', countryName: 'United Kingdom',        region: 'EUR',   tier: 'HIGH',  isActive: 'Y' },
    { countryCode: 'FR', countryName: 'France',                region: 'EUR',   tier: 'HIGH',  isActive: 'Y' },
    { countryCode: 'DE', countryName: 'Germany',               region: 'EUR',   tier: 'HIGH',  isActive: 'Y' },
    { countryCode: 'JP', countryName: 'Japan',                 region: 'ASIA',  tier: 'HIGH',  isActive: 'Y' },
    { countryCode: 'SG', countryName: 'Singapore',             region: 'ASIA',  tier: 'HIGH',  isActive: 'Y' },
    { countryCode: 'JO', countryName: 'Jordan',                region: 'MENA',  tier: 'MED',   isActive: 'Y' },
    { countryCode: 'EG', countryName: 'Egypt',                 region: 'MENA',  tier: 'MED',   isActive: 'Y' },
    { countryCode: 'TR', countryName: 'Turkey',                region: 'MENA',  tier: 'MED',   isActive: 'Y' },
    { countryCode: 'IN', countryName: 'India',                 region: 'ASIA',  tier: 'LOW',   isActive: 'Y' },
    { countryCode: 'PH', countryName: 'Philippines',           region: 'ASIA',  tier: 'LOW',   isActive: 'Y' },
  ];

  // ── Country Groups ─────────────────────────────────────────────────
  const COUNTRY_GROUPS = [
    { groupId: 1, groupCode: 'GULF',    groupName: 'GCC Countries',           isActive: 'Y' },
    { groupId: 2, groupCode: 'EUR',     groupName: 'Europe',                  isActive: 'Y' },
    { groupId: 3, groupCode: 'AMER',    groupName: 'Americas',                isActive: 'Y' },
    { groupId: 4, groupCode: 'ASIA',    groupName: 'Asia Pacific',            isActive: 'Y' },
    { groupId: 5, groupCode: 'MENA',    groupName: 'Middle East & North Africa (non-GCC)', isActive: 'Y' },
  ];

  const COUNTRY_GROUP_MEMBERS = [
    { groupId: 1, countryCode: 'SA' }, { groupId: 1, countryCode: 'OM' }, { groupId: 1, countryCode: 'BH' },
    { groupId: 1, countryCode: 'KW' }, { groupId: 1, countryCode: 'QA' },
    { groupId: 2, countryCode: 'GB' }, { groupId: 2, countryCode: 'FR' }, { groupId: 2, countryCode: 'DE' },
    { groupId: 3, countryCode: 'US' },
    { groupId: 4, countryCode: 'JP' }, { groupId: 4, countryCode: 'SG' }, { groupId: 4, countryCode: 'IN' }, { groupId: 4, countryCode: 'PH' },
    { groupId: 5, countryCode: 'JO' }, { groupId: 5, countryCode: 'EG' }, { groupId: 5, countryCode: 'TR' },
  ];

  // ── Per Diem Rates (per country per grade, AED/day) ────────────────
  // rateStructure = PER_COUNTRY; dailyRate covers meals + accommodation allowance
  const PER_DIEM_RATES = [
    // GCC — Grade E1/E2/E3/E4/E5
    { rateId:  1, countryCode: 'SA', gradeCode: 'E1', dailyRateAed: 1200, mealAed: 200, incidentalsAed: 100, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  2, countryCode: 'SA', gradeCode: 'E2', dailyRateAed: 1000, mealAed: 180, incidentalsAed:  80, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  3, countryCode: 'SA', gradeCode: 'E3', dailyRateAed:  800, mealAed: 150, incidentalsAed:  60, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  4, countryCode: 'SA', gradeCode: 'E4', dailyRateAed:  650, mealAed: 130, incidentalsAed:  50, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  5, countryCode: 'SA', gradeCode: 'E5', dailyRateAed:  500, mealAed: 100, incidentalsAed:  40, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    // US
    { rateId:  6, countryCode: 'US', gradeCode: 'E1', dailyRateAed: 2200, mealAed: 350, incidentalsAed: 150, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  7, countryCode: 'US', gradeCode: 'E2', dailyRateAed: 1900, mealAed: 300, incidentalsAed: 120, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  8, countryCode: 'US', gradeCode: 'E3', dailyRateAed: 1600, mealAed: 250, incidentalsAed: 100, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId:  9, countryCode: 'US', gradeCode: 'E4', dailyRateAed: 1350, mealAed: 200, incidentalsAed:  80, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 10, countryCode: 'US', gradeCode: 'E5', dailyRateAed: 1100, mealAed: 170, incidentalsAed:  60, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    // GB
    { rateId: 11, countryCode: 'GB', gradeCode: 'E1', dailyRateAed: 2400, mealAed: 380, incidentalsAed: 150, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 12, countryCode: 'GB', gradeCode: 'E2', dailyRateAed: 2000, mealAed: 320, incidentalsAed: 130, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 13, countryCode: 'GB', gradeCode: 'E3', dailyRateAed: 1700, mealAed: 270, incidentalsAed: 110, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 14, countryCode: 'GB', gradeCode: 'E4', dailyRateAed: 1400, mealAed: 220, incidentalsAed:  90, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 15, countryCode: 'GB', gradeCode: 'E5', dailyRateAed: 1150, mealAed: 180, incidentalsAed:  70, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    // India
    { rateId: 16, countryCode: 'IN', gradeCode: 'E1', dailyRateAed:  900, mealAed: 150, incidentalsAed:  80, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 17, countryCode: 'IN', gradeCode: 'E2', dailyRateAed:  750, mealAed: 130, incidentalsAed:  60, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 18, countryCode: 'IN', gradeCode: 'E3', dailyRateAed:  600, mealAed: 110, incidentalsAed:  50, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 19, countryCode: 'IN', gradeCode: 'E4', dailyRateAed:  500, mealAed:  90, incidentalsAed:  40, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 20, countryCode: 'IN', gradeCode: 'E5', dailyRateAed:  400, mealAed:  75, incidentalsAed:  30, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    // Jordan
    { rateId: 21, countryCode: 'JO', gradeCode: 'E1', dailyRateAed: 1000, mealAed: 170, incidentalsAed:  80, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 22, countryCode: 'JO', gradeCode: 'E2', dailyRateAed:  850, mealAed: 150, incidentalsAed:  65, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 23, countryCode: 'JO', gradeCode: 'E3', dailyRateAed:  700, mealAed: 120, incidentalsAed:  55, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 24, countryCode: 'JO', gradeCode: 'E4', dailyRateAed:  580, mealAed: 100, incidentalsAed:  45, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
    { rateId: 25, countryCode: 'JO', gradeCode: 'E5', dailyRateAed:  450, mealAed:  85, incidentalsAed:  35, effectiveFrom: '2026-01-01', effectiveTo: null, isActive: 'Y' },
  ];

  // ── Document Requirements ──────────────────────────────────────────
  const DOC_REQUIREMENTS = [
    { docId: 1,  requestType: 'TRAVEL_REQUEST',  docCode: 'INVITATION',    docName: 'Official Invitation / Conference Registration', isRequired: 'Y', isActive: 'Y' },
    { docId: 2,  requestType: 'TRAVEL_REQUEST',  docCode: 'APPROVAL_MEMO', docName: 'Director Approval Memo',                        isRequired: 'N', isActive: 'Y' },
    { docId: 3,  requestType: 'TRAVEL_REQUEST',  docCode: 'AGENDA',        docName: 'Meeting / Conference Agenda',                    isRequired: 'N', isActive: 'Y' },
    { docId: 4,  requestType: 'SETTLEMENT',      docCode: 'BOARDING_PASS', docName: 'Boarding Pass (Departure & Return)',             isRequired: 'Y', isActive: 'Y' },
    { docId: 5,  requestType: 'SETTLEMENT',      docCode: 'HOTEL_INVOICE', docName: 'Hotel Invoice',                                 isRequired: 'Y', isActive: 'Y' },
    { docId: 6,  requestType: 'SETTLEMENT',      docCode: 'RECEIPTS',      docName: 'Expense Receipts',                              isRequired: 'N', isActive: 'Y' },
    { docId: 7,  requestType: 'SETTLEMENT',      docCode: 'REPORT',        docName: 'Post-Travel Report',                            isRequired: 'N', isActive: 'Y' },
  ];

  // ── Travel Requests ────────────────────────────────────────────────
  const TRAVEL_REQUESTS = [
    {
      reqId: 1, reqNumber: 'DT-2026-00001', userId: 3,
      employeeName: 'Naser Mohamed Al Khaja', employeeNumber: 'EMP002', gradeCode: 'E3',
      orgName: 'Finance Operations', tripType: 'OFFICIAL',
      travelPurpose: 'Attend the GCC Finance Sector Digital Transformation Conference 2026 in Riyadh',
      departureDate: '2026-04-10', returnDate: '2026-04-13', estimatedDays: 4,
      estimatedPerDiem: 3200, advanceRequested: 'Y', advanceAmount: 3200,
      status: 'ADVANCE_PAID', submittedAt: '2026-03-20T09:00:00', approvedAt: '2026-03-25T11:00:00',
      advancePaidAt: '2026-03-28T10:00:00', advancePaidBy: 4,
      returnedAt: '2026-04-14', closedAt: null, notes: null, createdAt: '2026-03-20T09:00:00',
    },
    {
      reqId: 2, reqNumber: 'DT-2026-00002', userId: 6,
      employeeName: 'Noora Saeed Al Ali', employeeNumber: 'EMP006', gradeCode: 'E3',
      orgName: 'Receivables Operations', tripType: 'OFFICIAL',
      travelPurpose: 'Training on Oracle Fusion Financials — Receivables module — London',
      departureDate: '2026-03-01', returnDate: '2026-03-05', estimatedDays: 5,
      estimatedPerDiem: 8500, advanceRequested: 'Y', advanceAmount: 8500,
      status: 'CLOSED', submittedAt: '2026-02-10T10:00:00', approvedAt: '2026-02-15T14:00:00',
      advancePaidAt: '2026-02-20T09:00:00', advancePaidBy: 4,
      returnedAt: '2026-03-06', closedAt: '2026-03-15T10:00:00', notes: null, createdAt: '2026-02-10T10:00:00',
    },
    {
      reqId: 3, reqNumber: 'DT-2026-00003', userId: 5,
      employeeName: 'Shaikha Ghanem Al Ameri', employeeNumber: 'EMP004', gradeCode: 'E4',
      orgName: 'Financial Planning & Budgeting', tripType: 'OFFICIAL',
      travelPurpose: 'Budget Planning Workshop — Ministry of Finance — Abu Dhabi (local)',
      departureDate: '2026-05-20', returnDate: '2026-05-20', estimatedDays: 1,
      estimatedPerDiem: 0, advanceRequested: 'N', advanceAmount: 0,
      status: 'SUBMITTED', submittedAt: '2026-05-15T11:00:00', approvedAt: null,
      advancePaidAt: null, advancePaidBy: null,
      returnedAt: null, closedAt: null, notes: 'Same-day trip — no advance needed', createdAt: '2026-05-15T11:00:00',
    },
    {
      reqId: 4, reqNumber: 'DT-2026-00004', userId: 3,
      employeeName: 'Naser Mohamed Al Khaja', employeeNumber: 'EMP002', gradeCode: 'E3',
      orgName: 'Finance Operations', tripType: 'OFFICIAL',
      travelPurpose: 'Bilateral coordination meeting — Ministry of Finance Jordan — Amman',
      departureDate: '2026-05-25', returnDate: '2026-05-27', estimatedDays: 3,
      estimatedPerDiem: 2100, advanceRequested: 'Y', advanceAmount: 2100,
      status: 'DRAFT', submittedAt: null, approvedAt: null,
      advancePaidAt: null, advancePaidBy: null,
      returnedAt: null, closedAt: null, notes: null, createdAt: '2026-05-16T08:30:00',
    },
    {
      reqId: 5, reqNumber: 'DT-2026-00005', userId: 6,
      employeeName: 'Noora Saeed Al Ali', employeeNumber: 'EMP006', gradeCode: 'E3',
      orgName: 'Receivables Operations', tripType: 'OFFICIAL',
      travelPurpose: 'ACCA Finance Leadership Forum — Singapore',
      departureDate: '2026-06-10', returnDate: '2026-06-14', estimatedDays: 5,
      estimatedPerDiem: 8500, advanceRequested: 'Y', advanceAmount: 8500,
      status: 'APPROVED', submittedAt: '2026-05-10T09:00:00', approvedAt: '2026-05-14T15:00:00',
      advancePaidAt: null, advancePaidBy: null,
      returnedAt: null, closedAt: null, notes: null, createdAt: '2026-05-10T09:00:00',
    },
  ];

  // ── Travel Destinations ────────────────────────────────────────────
  const TRAVEL_DESTINATIONS = [
    { destId: 1, reqId: 1, seqNum: 1, countryCode: 'SA', countryName: 'Saudi Arabia', fromDate: '2026-04-10', toDate: '2026-04-13', dailyRateAed: 800, days: 4, amount: 3200 },
    { destId: 2, reqId: 2, seqNum: 1, countryCode: 'GB', countryName: 'United Kingdom', fromDate: '2026-03-01', toDate: '2026-03-05', dailyRateAed: 1700, days: 5, amount: 8500 },
    { destId: 3, reqId: 4, seqNum: 1, countryCode: 'JO', countryName: 'Jordan', fromDate: '2026-05-25', toDate: '2026-05-27', dailyRateAed: 700, days: 3, amount: 2100 },
    { destId: 4, reqId: 5, seqNum: 1, countryCode: 'SG', countryName: 'Singapore', fromDate: '2026-06-10', toDate: '2026-06-14', dailyRateAed: 1700, days: 5, amount: 8500 },
  ];

  // ── Settlements ────────────────────────────────────────────────────
  const SETTLEMENTS = [
    {
      settleId: 1, settleNumber: 'DTS-2026-00001', reqId: 2,
      actualDeparture: '2026-03-01', actualReturn: '2026-03-05', actualDays: 5,
      actualPerDiemTotal: 8500, additionalExpenses: 420, totalSettlement: 8920,
      advanceAmount: 8500, netRefund: 0, netPayable: 420,
      status: 'APPROVED', submittedAt: '2026-03-10T09:00:00', approvedAt: '2026-03-14T14:00:00',
      closedAt: null, notes: 'Additional taxi receipts included', createdAt: '2026-03-10T09:00:00',
    },
  ];

  // ── Settlement Lines ───────────────────────────────────────────────
  const SETTLEMENT_LINES = [
    { lineId: 1, settleId: 1, lineType: 'PERDIEM', destId: 2, description: 'Per diem — United Kingdom × 5 days', amount: 8500 },
    { lineId: 2, settleId: 1, lineType: 'EXPENSE', destId: null, description: 'Airport taxi', amount: 120 },
    { lineId: 3, settleId: 1, lineType: 'EXPENSE', destId: null, description: 'Visa fees', amount: 300 },
  ];

  // ── Approval Templates ─────────────────────────────────────────────
  const APPROVAL_TEMPLATES = [
    { templateId: 1, templateCode: 'DT_TRAVEL_ADVANCE', templateName: 'Travel Request Approval',    requestType: 'TRAVEL_REQUEST', isSequential: 'Y', autoApproveDays: 3, isActive: 'Y' },
    { templateId: 2, templateCode: 'DT_SETTLEMENT',     templateName: 'Travel Settlement Approval', requestType: 'SETTLEMENT',     isSequential: 'Y', autoApproveDays: 3, isActive: 'Y' },
  ];

  const APPROVAL_STEPS = [
    // Travel request workflow
    { stepId: 1, templateId: 1, stepSeq: 1, stepName: 'Manager Approval',    requiredRole: 'DT_MANAGER', conditionType: 'ALWAYS', amountOperator: null, amountThreshold: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 3, isActive: 'Y' },
    { stepId: 2, templateId: 1, stepSeq: 2, stepName: 'DT Admin Approval',   requiredRole: 'DT_ADMIN',   conditionType: 'AMOUNT', amountOperator: '>=', amountThreshold: 5000, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
    // Settlement workflow
    { stepId: 3, templateId: 2, stepSeq: 1, stepName: 'Manager Approval',    requiredRole: 'DT_MANAGER', conditionType: 'ALWAYS', amountOperator: null, amountThreshold: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 3, isActive: 'Y' },
    { stepId: 4, templateId: 2, stepSeq: 2, stepName: 'Finance Approval',    requiredRole: 'DT_FINANCE', conditionType: 'ALWAYS', amountOperator: null, amountThreshold: null, isMandatory: 'Y', allowSkip: 'N', escalationDays: 2, isActive: 'Y' },
  ];

  const APPROVAL_INSTANCES = [
    // Active (pending) instances
    { instanceId: 1, templateId: 1, sourceModule: 'TRAVEL_REQUEST', sourceRecordId: 3, sourceRecordRef: 'DT-2026-00003', submittedBy: 5, submittedAt: '2026-05-15T11:00:00', currentStepSeq: 1, overallStatus: 'PENDING' },
    { instanceId: 2, templateId: 2, sourceModule: 'SETTLEMENT',     sourceRecordId: 1, sourceRecordRef: 'DTS-2026-00001', submittedBy: 6, submittedAt: '2026-03-10T09:00:00', currentStepSeq: null, overallStatus: 'APPROVED' },
    // Completed instances
    { instanceId: 3, templateId: 1, sourceModule: 'TRAVEL_REQUEST', sourceRecordId: 1, sourceRecordRef: 'DT-2026-00001', submittedBy: 3, submittedAt: '2026-03-20T09:00:00', currentStepSeq: null, overallStatus: 'APPROVED' },
    { instanceId: 4, templateId: 1, sourceModule: 'TRAVEL_REQUEST', sourceRecordId: 2, sourceRecordRef: 'DT-2026-00002', submittedBy: 6, submittedAt: '2026-02-10T10:00:00', currentStepSeq: null, overallStatus: 'APPROVED' },
    { instanceId: 5, templateId: 1, sourceModule: 'TRAVEL_REQUEST', sourceRecordId: 5, sourceRecordRef: 'DT-2026-00005', submittedBy: 6, submittedAt: '2026-05-10T09:00:00', currentStepSeq: null, overallStatus: 'APPROVED' },
  ];

  const APPROVAL_ACTIONS = [
    { actionId: 1, instanceId: 1, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',  action: 'PENDING', comments: null, actionedAt: null },
    { actionId: 2, instanceId: 3, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',  action: 'APPROVED', comments: 'Approved. Conference is relevant to division goals.', actionedAt: '2026-03-22T10:00:00' },
    { actionId: 3, instanceId: 4, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',  action: 'APPROVED', comments: 'Approved.', actionedAt: '2026-02-12T14:00:00' },
    { actionId: 4, instanceId: 4, stepSeq: 2, actionedBy: 1, actionedByName: 'System Administrator', action: 'APPROVED', comments: 'Amount >= 5,000 AED — reviewed and approved.', actionedAt: '2026-02-15T14:00:00' },
    { actionId: 5, instanceId: 2, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',  action: 'APPROVED', comments: 'Approved.', actionedAt: '2026-03-12T09:00:00' },
    { actionId: 6, instanceId: 2, stepSeq: 2, actionedBy: 4, actionedByName: 'Ayesha Abdul Kareem Ameri', action: 'APPROVED', comments: 'Settlement reviewed. Additional expenses documented.', actionedAt: '2026-03-14T14:00:00' },
    { actionId: 7, instanceId: 5, stepSeq: 1, actionedBy: 2, actionedByName: 'Hashem Al Kabbi',  action: 'APPROVED', comments: 'Approved. Singapore forum aligns with ACCA CPD goals.', actionedAt: '2026-05-12T11:00:00' },
    { actionId: 8, instanceId: 5, stepSeq: 2, actionedBy: 1, actionedByName: 'System Administrator', action: 'APPROVED', comments: 'Reviewed and approved.', actionedAt: '2026-05-14T15:00:00' },
  ];

  // ── Module Settings ────────────────────────────────────────────────
  const MODULE_SETTINGS = [
    { settingId: 1, settingKey: 'RATE_STRUCTURE',              settingLabel: 'Per Diem Rate Structure',       settingDescription: 'PER_COUNTRY = rate per country per grade. TIER_BASED = rate by tier. REGION_BASED = rate by region.', valueType: 'SELECT', allowedValues: 'PER_COUNTRY|TIER_BASED|REGION_BASED', defaultValue: 'PER_COUNTRY', settingValue: 'PER_COUNTRY', effectiveDate: '2026-01-01' },
    { settingId: 2, settingKey: 'ADVANCE_REQUIRED',            settingLabel: 'Advance Payment Required',      settingDescription: 'Whether advance payment is mandatory for all approved travel requests', valueType: 'BOOLEAN', allowedValues: 'Y|N', defaultValue: 'N', settingValue: 'N', effectiveDate: '2026-01-01' },
    { settingId: 3, settingKey: 'SETTLEMENT_DAYS_LIMIT',       settingLabel: 'Settlement Submission Days',    settingDescription: 'Number of calendar days after return to submit settlement', valueType: 'NUMBER', allowedValues: null, defaultValue: '14', settingValue: '14', effectiveDate: '2026-01-01' },
    { settingId: 4, settingKey: 'ALLOW_PARTIAL_DAY',           settingLabel: 'Allow Partial Day Per Diem',   settingDescription: 'Allow half-day per diem for travel days (departure/return)', valueType: 'BOOLEAN', allowedValues: 'Y|N', defaultValue: 'Y', settingValue: 'Y', effectiveDate: '2026-01-01' },
    { settingId: 5, settingKey: 'MAX_ADVANCE_PERCENT',         settingLabel: 'Maximum Advance Percentage',   settingDescription: 'Maximum % of estimated per diem allowed as advance (blank = 100%)', valueType: 'NUMBER', allowedValues: null, defaultValue: '100', settingValue: '100', effectiveDate: '2026-01-01' },
    { settingId: 6, settingKey: 'REQUIRE_POST_TRAVEL_REPORT',  settingLabel: 'Require Post-Travel Report',   settingDescription: 'Require employees to submit a post-travel report before settlement closure', valueType: 'BOOLEAN', allowedValues: 'Y|N', defaultValue: 'N', settingValue: 'N', effectiveDate: '2026-01-01' },
    { settingId: 7, settingKey: 'CURRENCY_DISPLAY',            settingLabel: 'Display Currency',             settingDescription: 'Currency shown in all amounts', valueType: 'SELECT', allowedValues: 'AED|USD|EUR', defaultValue: 'AED', settingValue: 'AED', effectiveDate: '2026-01-01' },
  ];

  // ── Notifications ──────────────────────────────────────────────────
  const NOTIFICATIONS = [
    { notifId: 1, type: 'APPROVAL', titleEn: 'Approval Required — DT-2026-00003', bodyEn: 'Shaikha Ghanem Al Ameri has submitted a travel request for your approval (Abu Dhabi, 20 May 2026).', isRead: 'N', targetUserId: 2, createdAt: '2026-05-15T11:00:00' },
    { notifId: 2, type: 'INFO',     titleEn: 'Advance Paid — DT-2026-00001',      bodyEn: 'Your travel advance of 3,200 AED (DT-2026-00001) has been disbursed. Safe travels!', isRead: 'Y', targetUserId: 3, createdAt: '2026-03-28T10:00:00' },
    { notifId: 3, type: 'INFO',     titleEn: 'Travel Request Approved — DT-2026-00005', bodyEn: 'Your travel request to Singapore (10–14 Jun 2026) has been approved.', isRead: 'N', targetUserId: 6, createdAt: '2026-05-14T15:00:00' },
    { notifId: 4, type: 'WARNING',  titleEn: 'Settlement Due — DT-2026-00001',    bodyEn: 'You returned from Riyadh on 14 Apr 2026. Please submit your settlement within 14 days (by 28 Apr 2026).', isRead: 'N', targetUserId: 3, createdAt: '2026-04-14T08:00:00' },
    { notifId: 5, type: 'INFO',     titleEn: 'Settlement Approved — DTS-2026-00001', bodyEn: 'Your travel settlement of 8,920 AED has been approved. Finance will process the net payable of 420 AED shortly.', isRead: 'Y', targetUserId: 6, createdAt: '2026-03-14T14:00:00' },
  ];

  return {
    USERS,
    COUNTRIES,
    COUNTRY_GROUPS,
    COUNTRY_GROUP_MEMBERS,
    PER_DIEM_RATES,
    DOC_REQUIREMENTS,
    TRAVEL_REQUESTS,
    TRAVEL_DESTINATIONS,
    SETTLEMENTS,
    SETTLEMENT_LINES,
    APPROVAL_TEMPLATES,
    APPROVAL_STEPS,
    APPROVAL_INSTANCES,
    APPROVAL_ACTIONS,
    MODULE_SETTINGS,
    NOTIFICATIONS,
  };
});
