/* ================================================================
   data.js — Data models, constants, localStorage store, mock data
   ================================================================ */
'use strict';

// ── Users ──────────────────────────────────────────────────────────
const USERS = [
  { id: 'dir1', name: 'Hashem Al Kabbi',            initials: 'HK',  role: 'director', title: 'Finance Manager',                          email: 'hashem@finance.ae',   password: 'admin123', color: '#1e3a5f', gradient: 'linear-gradient(135deg,#0f2040,#1e3a5f)', section: 'Finance Division',               active: true },
  { id: 'mgr1', name: 'Naser Mohamed Al Khaja',     initials: 'NK',  role: 'manager',  title: 'Finance Operations Manager',               email: 'naser@finance.ae',    password: 'pass123',  color: '#7c3aed', gradient: 'linear-gradient(135deg,#5b21b6,#7c3aed)', section: 'Finance Operations',             active: true },
  { id: 'mgr2', name: 'Ayesha Abdul Kareem Ameri',  initials: 'AA',  role: 'manager',  title: 'Payables Operations Manager',              email: 'ayesha@finance.ae',   password: 'pass123',  color: '#2563eb', gradient: 'linear-gradient(135deg,#1d4ed8,#2563eb)', section: 'Payables Operations',            active: true },
  { id: 'mgr3', name: 'Shaikha Ghanem Al Ameri',    initials: 'SGA', role: 'manager',  title: 'Financial Planning & Budgeting Manager',   email: 'shaikha.g@finance.ae',password: 'pass123',  color: '#059669', gradient: 'linear-gradient(135deg,#065f46,#059669)', section: 'Financial Planning & Budgeting', active: true },
  { id: 'mgr4', name: 'Shaikha Ahmed Al Suwaidi',   initials: 'SA',  role: 'manager',  title: 'Revenue Assurance Manager',                email: 'shaikha.a@finance.ae',password: 'pass123',  color: '#d97706', gradient: 'linear-gradient(135deg,#92400e,#d97706)', section: 'Revenue Assurance',              active: true },
  { id: 'mgr5', name: 'Noora Saeed Al Ali',         initials: 'NS',  role: 'manager',  title: 'Receivables Operations Manager',           email: 'noora@finance.ae',    password: 'pass123',  color: '#dc2626', gradient: 'linear-gradient(135deg,#991b1b,#dc2626)', section: 'Receivables Operations',         active: true }
];

// Available avatar color presets for new managers
const USER_COLOR_PRESETS = [
  { color: '#7c3aed', gradient: 'linear-gradient(135deg,#5b21b6,#7c3aed)',  label: 'Purple'  },
  { color: '#2563eb', gradient: 'linear-gradient(135deg,#1d4ed8,#2563eb)',  label: 'Blue'    },
  { color: '#059669', gradient: 'linear-gradient(135deg,#065f46,#059669)',  label: 'Green'   },
  { color: '#d97706', gradient: 'linear-gradient(135deg,#92400e,#d97706)',  label: 'Amber'   },
  { color: '#dc2626', gradient: 'linear-gradient(135deg,#991b1b,#dc2626)',  label: 'Red'     },
  { color: '#0891b2', gradient: 'linear-gradient(135deg,#0e7490,#0891b2)',  label: 'Cyan'    },
  { color: '#db2777', gradient: 'linear-gradient(135deg,#9d174d,#db2777)',  label: 'Pink'    },
  { color: '#65a30d', gradient: 'linear-gradient(135deg,#3f6212,#65a30d)',  label: 'Lime'    },
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
  KEYS: { TASKS: 'ftm_tasks', SESSION: 'ftm_session', SEEDED: 'ftm_seeded_v2', USERS: 'ftm_users' },

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
    return this.getUsers()
      .filter(u => u.role === 'manager' && u.active !== false)
      .map(m => ({ ...m, ...this.getWeekStats(weekNum, year, m.id) }));
  },

  // ── User management ───────────────────────────────────────────────
  getUsers() {
    const { overrides, custom } = this._getUserData();
    return [...USERS, ...custom].map(u => ({
      ...u,
      active: overrides.hasOwnProperty(u.id) ? overrides[u.id] : (u.active !== false)
    }));
  },

  addUser(payload) {
    const data = this._getUserData();
    const user = {
      ...payload,
      id: 'mgr_' + Date.now() + '_' + Math.random().toString(36).substr(2, 5),
      role: 'manager',
      active: true,
      createdAt: new Date().toISOString()
    };
    data.custom.push(user);
    this._saveUserData(data);
    return user;
  },

  toggleUserActive(id) {
    const user = this.getUsers().find(u => u.id === id);
    if (!user) return;
    const data = this._getUserData();
    data.overrides[id] = !user.active;
    this._saveUserData(data);
  },

  _getUserData() {
    try { return JSON.parse(localStorage.getItem(this.KEYS.USERS) || '{"overrides":{},"custom":[]}'); }
    catch { return { overrides: {}, custom: [] }; }
  },

  _saveUserData(d) { localStorage.setItem(this.KEYS.USERS, JSON.stringify(d)); },

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
      mgr1: [ // Finance Operations — Naser Mohamed Al Khaja
        { title:'Q2 Finance Operations Review',             category:'Financial Report',        priority:'high',   status:'in-progress', pct:65,  next:'Compile department responses and finalize operations review for Finance Manager',  tags:['Q2','Operations','Critical'] },
        { title:'Staff Performance KPI Tracking',           category:'System & Process',        priority:'high',   status:'in-progress', pct:40,  next:'Consolidate all team KPI data and prepare performance summary by Thursday EOD',   tags:['KPI','Performance'] },
        { title:'Monthly Operations Cost Review',           category:'Budget Review',           priority:'medium', status:'completed',   pct:100, next:'Distribute finalized cost report to Finance Manager',                             tags:['Monthly','Cost Control'] },
        { title:'Finance Team Capacity Planning',           category:'Meeting & Communication', priority:'medium', status:'not-started', pct:0,   next:'Send meeting invites and prepare workforce planning agenda',                      tags:['Capacity','Planning'] },
        { title:'Finance Systems Access Audit',             category:'Audit & Compliance',      priority:'low',    status:'delayed',     pct:20,  next:'Obtain access log reports from IT and complete audit checklist',                  tags:['Systems','Audit'] }
      ],
      mgr2: [ // Payables Operations — Ayesha Abdul Kareem Ameri
        { title:'Vendor Invoice Processing — Batch #47',    category:'Vendor Payment',          priority:'high',   status:'in-progress', pct:55,  next:'Process remaining 38 invoices and submit batch for payment authorization',       tags:['Invoices','AED 2.4M'] },
        { title:'Supplier Payment Run — May 2026',          category:'Vendor Payment',          priority:'high',   status:'in-progress', pct:80,  next:'Obtain final authorization from Finance Manager before executing payment run',    tags:['Payment Run','Monthly'] },
        { title:'Accounts Payable Aging Report',            category:'Financial Report',        priority:'medium', status:'completed',   pct:100, next:'Present AP aging findings in weekly review meeting',                             tags:['AP Aging','Report'] },
        { title:'Supplier Onboarding — 3 New Vendors',      category:'System & Process',        priority:'medium', status:'blocked',     pct:30,  next:'Chase legal team for contract finalization before proceeding',                   tags:['New Vendor','Onboarding'] },
        { title:'Month-End AP Reconciliation',              category:'Reconciliation',          priority:'high',   status:'not-started', pct:0,   next:'Request vendor statements from top 20 suppliers immediately',                    tags:['Month-End','Reconciliation'] }
      ],
      mgr3: [ // Financial Planning & Budgeting — Shaikha Ghanem Al Ameri
        { title:'FY2026 Mid-Year Budget Revision',          category:'Financial Forecast',      priority:'high',   status:'in-progress', pct:75,  next:'Consolidate all department inputs and submit revised budget for review',          tags:['FY2026','Budget','Mid-Year'] },
        { title:'Q2 Budget Variance Analysis Report',       category:'Budget Review',           priority:'high',   status:'completed',   pct:100, next:'Distribute approved variance report to senior management team',                  tags:['Q2','Variance','Report'] },
        { title:'Capital Expenditure Planning — H2 2026',  category:'Financial Forecast',      priority:'medium', status:'in-progress', pct:50,  next:'Review CapEx requests from IT and Operations divisions',                         tags:['CapEx','H2 2026'] },
        { title:'Department Budget Utilization Review',     category:'Budget Review',           priority:'medium', status:'delayed',     pct:25,  next:'Follow up with department heads for outstanding budget clarifications',           tags:['Utilization','Monthly'] },
        { title:'3-Year Financial Plan Update',             category:'Financial Forecast',      priority:'high',   status:'in-progress', pct:60,  next:'Incorporate macroeconomic assumptions and finalize projections by Friday',       tags:['Strategic','3-Year Plan'] }
      ],
      mgr4: [ // Revenue Assurance — Shaikha Ahmed Al Suwaidi
        { title:'Monthly Revenue Reconciliation — April',   category:'Reconciliation',          priority:'high',   status:'completed',   pct:100, next:'Continue monitoring and escalate revenue variances above AED 100K threshold',   tags:['Revenue','Monthly'] },
        { title:'Revenue Leakage Analysis — Q2',            category:'Audit & Compliance',      priority:'high',   status:'in-progress', pct:45,  next:'Complete analysis of billing discrepancies and prepare recommendations',         tags:['Leakage','Q2','Critical'] },
        { title:'Customer Billing Review — Key Accounts',   category:'Financial Report',        priority:'medium', status:'in-progress', pct:60,  next:'Present billing discrepancy findings and recovery plan to Finance Manager',      tags:['Billing','Key Accounts'] },
        { title:'Revenue KPI Dashboard — Week 19',          category:'System & Process',        priority:'high',   status:'in-progress', pct:70,  next:'Finalize dashboard data inputs and publish weekly revenue KPI report',           tags:['KPI','Dashboard','Revenue'] },
        { title:'Contract Revenue Recognition Review',      category:'Audit & Compliance',      priority:'medium', status:'blocked',     pct:35,  next:'Await legal sign-off on revenue recognition policy amendments',                  tags:['Contracts','IFRS 15'] }
      ],
      mgr5: [ // Receivables Operations — Noora Saeed Al Ali
        { title:'Customer Outstanding AR Collection Drive',  category:'Reconciliation',         priority:'high',   status:'in-progress', pct:55,  next:'Follow up with top 10 overdue customers and escalate accounts above 90 days',   tags:['AR','Collections','Overdue'] },
        { title:'Accounts Receivable Aging Report — April', category:'Financial Report',        priority:'high',   status:'in-progress', pct:70,  next:'Review AR aging report with Finance Manager and agree collection targets',      tags:['AR Aging','April','Report'] },
        { title:'Customer Credit Assessment — 5 Accounts',  category:'Risk Assessment',         priority:'medium', status:'completed',   pct:100, next:'Submit credit assessment recommendations to Finance Manager for approval',       tags:['Credit','Risk'] },
        { title:'Receivables Process Improvement',          category:'System & Process',        priority:'medium', status:'not-started', pct:0,   next:'Schedule workshop with operations team to map current AR collection process',    tags:['Process','Improvement'] },
        { title:'Month-End AR Reconciliation',              category:'Reconciliation',          priority:'high',   status:'delayed',     pct:40,  next:'Obtain customer remittance advices and complete sub-ledger reconciliation',      tags:['Month-End','AR','Urgent'] }
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
