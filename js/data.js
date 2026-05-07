/* ================================================================
   data.js — Data models, constants, localStorage store, mock data
   ================================================================ */
'use strict';

// ── Users ──────────────────────────────────────────────────────────
const USERS = [
  { id: 'dir1',  name: 'Ahmed Al-Rashidi', initials: 'AR', role: 'director', title: 'Finance Director',             email: 'ahmed@finance.ae',   password: 'admin123', color: '#1e3a5f', section: 'Finance Division'    },
  { id: 'mgr1',  name: 'Sarah Johnson',    initials: 'SJ', role: 'manager',  title: 'Budgeting & Planning Manager', email: 'sarah@finance.ae',   password: 'pass123',  color: '#7c3aed', section: 'Budgeting & Planning' },
  { id: 'mgr2',  name: 'Michael Chen',     initials: 'MC', role: 'manager',  title: 'Accounts Payable Manager',     email: 'michael@finance.ae', password: 'pass123',  color: '#2563eb', section: 'Accounts Payable'     },
  { id: 'mgr3',  name: 'Emma Williams',    initials: 'EW', role: 'manager',  title: 'Financial Reporting Manager',  email: 'emma@finance.ae',    password: 'pass123',  color: '#059669', section: 'Financial Reporting'  },
  { id: 'mgr4',  name: 'Robert Brown',     initials: 'RB', role: 'manager',  title: 'Treasury Manager',             email: 'robert@finance.ae',  password: 'pass123',  color: '#d97706', section: 'Treasury'             },
  { id: 'mgr5',  name: 'Lisa Davis',       initials: 'LD', role: 'manager',  title: 'Compliance & Audit Manager',   email: 'lisa@finance.ae',    password: 'pass123',  color: '#dc2626', section: 'Compliance & Audit'   }
];

// ── Status config ──────────────────────────────────────────────────
const STATUSES = {
  'not-started': { label: 'Not Started', icon: 'fa-circle',       cssClass: 'not-started', badgeClass: 'badge-not-started', selectClass: 's-not-started' },
  'in-progress': { label: 'In Progress', icon: 'fa-spinner',      cssClass: 'in-progress', badgeClass: 'badge-in-progress', selectClass: 's-in-progress' },
  'completed':   { label: 'Completed',   icon: 'fa-check-circle', cssClass: 'completed',   badgeClass: 'badge-completed',   selectClass: 's-completed'   },
  'delayed':     { label: 'Delayed',     icon: 'fa-clock',        cssClass: 'delayed',     badgeClass: 'badge-delayed',     selectClass: 's-delayed'     },
  'blocked':     { label: 'Blocked',     icon: 'fa-ban',          cssClass: 'blocked',     badgeClass: 'badge-blocked',     selectClass: 's-blocked'     }
};

// ── Priority config ────────────────────────────────────────────────
const PRIORITIES = {
  high:   { label: 'High',   badgeClass: 'badge-priority-high',   color: '#dc2626' },
  medium: { label: 'Medium', badgeClass: 'badge-priority-medium', color: '#d97706' },
  low:    { label: 'Low',    badgeClass: 'badge-priority-low',    color: '#059669' }
};

// ── Task categories ────────────────────────────────────────────────
const CATEGORIES = [
  'Budget Review', 'Financial Report', 'Vendor Payment',
  'Audit & Compliance', 'Treasury Management', 'Cash Flow Analysis',
  'Financial Forecast', 'Meeting & Communication', 'System & Process',
  'Payroll Processing', 'Reconciliation', 'Risk Assessment', 'Other'
];

// ── DataStore ──────────────────────────────────────────────────────
const DataStore = {
  KEYS: { TASKS: 'ftm_tasks', SESSION: 'ftm_session', SEEDED: 'ftm_seeded' },

  init() {
    if (!localStorage.getItem(this.KEYS.SEEDED)) {
      this._generateMockData();
      localStorage.setItem(this.KEYS.SEEDED, '1');
    }
  },

  resetData() {
    localStorage.removeItem(this.KEYS.TASKS);
    localStorage.removeItem(this.KEYS.SEEDED);
    this.init();
  },

  // ── CRUD ─────────────────────────────────────────────────────────
  getAllTasks() {
    try { return JSON.parse(localStorage.getItem(this.KEYS.TASKS) || '[]'); }
    catch { return []; }
  },
  _saveTasks(tasks) { localStorage.setItem(this.KEYS.TASKS, JSON.stringify(tasks)); },

  getTask(id) { return this.getAllTasks().find(t => t.id === id) || null; },

  getTasksByUser(userId, weekNum, year) {
    return this.getAllTasks().filter(t =>
      t.assignedTo === userId &&
      (weekNum == null || (t.weekNumber === weekNum && t.year === year))
    );
  },

  getTasksByWeek(weekNum, year) {
    return this.getAllTasks().filter(t => t.weekNumber === weekNum && t.year === year);
  },

  addTask(payload) {
    const tasks = this.getAllTasks();
    const task = {
      ...payload,
      id: 'task_' + Date.now() + '_' + Math.random().toString(36).substr(2,8),
      attachments: payload.attachments || [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    tasks.push(task);
    this._saveTasks(tasks);
    return task;
  },

  updateTask(id, updates) {
    const tasks = this.getAllTasks();
    const idx = tasks.findIndex(t => t.id === id);
    if (idx === -1) return null;
    tasks[idx] = { ...tasks[idx], ...updates, updatedAt: new Date().toISOString() };
    this._saveTasks(tasks);
    return tasks[idx];
  },

  deleteTask(id) {
    const tasks = this.getAllTasks();
    const next  = tasks.filter(t => t.id !== id);
    this._saveTasks(next);
    return next.length < tasks.length;
  },

  // ── Stats ─────────────────────────────────────────────────────────
  getWeekStats(weekNum, year, userId = null) {
    let tasks = this.getTasksByWeek(weekNum, year);
    if (userId) tasks = tasks.filter(t => t.assignedTo === userId);
    const byStatus = Object.fromEntries(Object.keys(STATUSES).map(s => [s, 0]));
    tasks.forEach(t => { if (byStatus[t.status] !== undefined) byStatus[t.status]++; });
    const total          = tasks.length;
    const completed      = byStatus.completed;
    const completionRate = total ? Math.round((completed / total) * 100) : 0;
    const overdue        = tasks.filter(t => t.status === 'delayed' || t.status === 'blocked').length;
    return { total, byStatus, completed, completionRate, overdue };
  },

  getManagerStats(weekNum, year) {
    return USERS
      .filter(u => u.role === 'manager')
      .map(m => ({ ...m, ...this.getWeekStats(weekNum, year, m.id) }));
  },

  getWeeklyTrend(userId, numWeeks = 6) {
    const today = new Date();
    const curW  = Utils.getISOWeek(today);
    const curY  = today.getFullYear();
    return Array.from({ length: numWeeks }, (_, i) => {
      let w = curW - (numWeeks - 1 - i), y = curY;
      if (w <= 0) { w += 52; y--; }
      return { week: w, year: y, label: `W${w}`, ...this.getWeekStats(w, y, userId) };
    });
  },

  // ── Mock data ─────────────────────────────────────────────────────
  _generateMockData() {
    const curW = Utils.getISOWeek(new Date(2026, 4, 7));
    const curY = 2026;

    const templates = {
      mgr1: [
        { title:'Q2 Budget Variance Analysis',      category:'Budget Review',          priority:'high',   status:'in-progress', pct:65, next:'Compile department responses and finalize variance report for director review',    tags:['Q2','Variance','Critical'] },
        { title:'FY2026 Mid-Year Budget Revision',  category:'Financial Forecast',     priority:'high',   status:'in-progress', pct:40, next:'Consolidate all department inputs by Thursday EOD',                                 tags:['FY2026','Budget'] },
        { title:'Department Cost Center Review',    category:'Budget Review',          priority:'medium', status:'completed',   pct:100, next:'Distribute finalized report to all department heads',                              tags:['Monthly','Cost Control'] },
        { title:'Capital Expenditure Planning',     category:'Meeting & Communication',priority:'medium', status:'not-started', pct:0,  next:'Send meeting invites to IT and Operations and prepare agenda',                     tags:['CapEx','Planning'] },
        { title:'Budget KPI Dashboard Update',      category:'System & Process',       priority:'low',    status:'delayed',     pct:20, next:'Obtain missing headcount data from HR and update dashboard',                        tags:['KPI','Dashboard'] }
      ],
      mgr2: [
        { title:'Vendor Invoice Processing — Batch #47',   category:'Vendor Payment',  priority:'high',   status:'in-progress', pct:55, next:'Process remaining 38 invoices and submit batch for payment authorization',        tags:['Invoices','AED 2.4M'] },
        { title:'Supplier Payment Run — May 2026',         category:'Vendor Payment',  priority:'high',   status:'in-progress', pct:80, next:'Obtain final authorization from Finance Director before executing payment',         tags:['Payment Run','Monthly'] },
        { title:'Accounts Payable Aging Report',           category:'Financial Report',priority:'medium', status:'completed',   pct:100, next:'Present AP aging findings in Monday weekly review meeting',                       tags:['AP Aging','Report'] },
        { title:'Supplier Onboarding — 3 New Vendors',     category:'System & Process',priority:'medium', status:'blocked',     pct:30, next:'Chase legal team for contract finalization before proceeding',                     tags:['New Vendor','Onboarding'] },
        { title:'Month-End AP Reconciliation',             category:'Reconciliation',  priority:'high',   status:'not-started', pct:0,  next:'Request vendor statements from top 20 suppliers immediately',                     tags:['Month-End','Reconciliation'] }
      ],
      mgr3: [
        { title:'April 2026 Monthly Financial Statements', category:'Financial Report',  priority:'high',   status:'in-progress', pct:75, next:'Complete balance sheet notes and submit consolidated statements for review',    tags:['Monthly','IFRS','Statements'] },
        { title:'Management Reporting Pack — Week 19',     category:'Financial Report',  priority:'high',   status:'completed',   pct:100, next:'Distribute approved reporting pack to senior management team',               tags:['Weekly','Management'] },
        { title:'IFRS 16 Lease Accounting Update',         category:'Audit & Compliance',priority:'medium', status:'in-progress', pct:50, next:'Review ROU asset calculations with external auditors on Thursday',            tags:['IFRS 16','Leases'] },
        { title:'Intercompany Reconciliation',             category:'Reconciliation',    priority:'medium', status:'delayed',     pct:25, next:'Follow up with subsidiary finance teams for outstanding confirmations',        tags:['Intercompany','Group'] },
        { title:'External Audit Support — Q1 Review',     category:'Audit & Compliance',priority:'high',   status:'in-progress', pct:60, next:'Submit remaining PBC items to external auditors by Friday 5pm',               tags:['Audit','Q1 Review'] }
      ],
      mgr4: [
        { title:'Daily Cash Position Report',          category:'Treasury Management', priority:'high',   status:'completed',   pct:100, next:'Continue daily monitoring and escalate if balance drops below AED 5M threshold', tags:['Daily','Cash Position'] },
        { title:'FX Hedging Strategy Review',          category:'Treasury Management', priority:'high',   status:'in-progress', pct:45, next:'Obtain bank FX quotations and finalize Q3 hedging proposal',                     tags:['FX','Hedging','Risk'] },
        { title:'Short-Term Investment Review',        category:'Cash Flow Analysis',  priority:'medium', status:'in-progress', pct:60, next:'Present AED 5M idle cash investment options to Finance Director',                tags:['Investment','Cash Management'] },
        { title:'13-Week Cash Flow Forecast',          category:'Cash Flow Analysis',  priority:'high',   status:'in-progress', pct:70, next:'Incorporate HR payroll forecast and finalize rolling cash flow model',           tags:['Cash Flow','Forecast'] },
        { title:'Bank Facility Renewal — Emirates NBD',category:'Treasury Management', priority:'medium', status:'blocked',     pct:35, next:'Await legal review of amended facility agreement terms',                         tags:['Bank','Credit Facility'] }
      ],
      mgr5: [
        { title:'Internal Audit — Procurement Process',    category:'Audit & Compliance',priority:'high',   status:'in-progress', pct:55, next:'Complete fieldwork documentation and draft initial audit observations report', tags:['Internal Audit','Procurement'] },
        { title:'Regulatory Compliance Checklist — Q2',   category:'Audit & Compliance',priority:'high',   status:'in-progress', pct:70, next:'Review completed checklist with legal counsel and submit to director for sign-off', tags:['Regulatory','Q2','Compliance'] },
        { title:'AML Awareness Training — Finance Dept',  category:'Audit & Compliance',priority:'medium', status:'completed',   pct:100, next:'Submit signed attendance register and completion certificates to HR',          tags:['AML','Training','Compliance'] },
        { title:'Risk Register Update — Finance Division',category:'Risk Assessment',   priority:'medium', status:'not-started', pct:0,  next:'Schedule risk identification workshop with all section managers',               tags:['Risk','Register'] },
        { title:'VAT Return Preparation — April 2026',    category:'Audit & Compliance',priority:'high',   status:'delayed',     pct:40, next:'Obtain missing purchase invoices from AP and finalize input VAT calculations',  tags:['VAT','Tax Filing','Urgent'] }
      ]
    };

    const tasks = [];
    for (let offset = 0; offset <= 5; offset++) {
      let w = curW - offset, y = curY;
      if (w <= 0) { w += 52; y--; }
      const { start, end } = Utils.getWeekDates(w, y);
      const isCurrent = offset === 0;

      Object.entries(templates).forEach(([mgrId, tmps]) => {
        tmps.forEach((t, i) => {
          let status = t.status, pct = t.pct;
          if (!isCurrent) {
            const r = Math.random();
            if (offset >= 3)       { status = 'completed'; pct = 100; }
            else if (r < .65)      { status = 'completed'; pct = 100; }
            else if (r < .80)      { status = 'in-progress'; pct = 75; }
            else                   { status = 'delayed'; pct = 50; }
          }
          tasks.push({
            id: `seed_${mgrId}_w${w}_${i}`,
            title: t.title, category: t.category,
            description: _desc(t.title, t.category),
            assignedTo: mgrId, weekNumber: w, year: y,
            status, priority: t.priority, completionPercentage: pct,
            nextAction: isCurrent ? t.next : (status === 'completed' ? 'Task completed — no further actions required.' : t.next),
            nextActionDate: end, startDate: start, dueDate: end,
            attachments: [], tags: t.tags || [], notes: '',
            createdAt: new Date(start).toISOString(),
            updatedAt: new Date().toISOString()
          });
        });
      });
    }
    this._saveTasks(tasks);
  }
};

function _desc(title, cat) {
  const map = {
    'Budget Review':          `Comprehensive review of ${title.toLowerCase()} covering YTD actuals, variances against approved budget, and detailed commentary for senior management.`,
    'Financial Report':       `Preparation and delivery of ${title.toLowerCase()} ensuring full compliance with IFRS standards and internal reporting requirements.`,
    'Vendor Payment':         `Processing and verification of ${title.toLowerCase()} including PO matching, three-way reconciliation, and authorization workflow.`,
    'Audit & Compliance':     `${title} — ensuring full regulatory compliance and adherence to internal policies and external regulatory requirements.`,
    'Treasury Management':    `${title} — monitoring and optimizing the organization's financial assets, liquidity position, and risk exposure.`,
    'Cash Flow Analysis':     `Detailed analysis and forecasting of cash flow positions to ensure adequate liquidity for operational and strategic requirements.`,
    'Financial Forecast':     `Development of forward-looking financial projections incorporating latest actuals and revised business assumptions.`,
    'Meeting & Communication':`Coordination and facilitation of ${title.toLowerCase()} to align stakeholders and drive decision-making.`,
    'System & Process':       `Review and improvement of ${title.toLowerCase()} to enhance operational efficiency and control effectiveness.`,
    'Reconciliation':         `Systematic reconciliation of financial records to ensure accuracy, completeness, and consistency across all accounts.`,
    'Risk Assessment':        `Identification, assessment, and documentation of financial and operational risks with recommended mitigation strategies.`,
    'Payroll Processing':     `End-to-end processing of payroll ensuring accuracy, timeliness, and compliance with labor regulations.`
  };
  return map[cat] || `${title}: detailed execution and completion of assigned task within the approved scope and timeline.`;
}
