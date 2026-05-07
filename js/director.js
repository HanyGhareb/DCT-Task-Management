/* ================================================================
   director.js — Finance Director dashboard controller
   ================================================================ */
'use strict';

const Director = {
  state: { user:null, week:0, year:0, tasks:[], managersData:[], sortCol:'section', sortDir:1, page:1, pageSize:8 },

  init() {
    DataStore.init();
    this.state.user = Auth.requireAuth('director');
    if (!this.state.user) return;
    this.state.week = Utils.currentWeek();
    this.state.year = Utils.currentYear();
    this._setupNav();
    this._setupEvents();
    this.loadWeek(this.state.week, this.state.year);
  },

  _setupNav() {
    const u = this.state.user;
    document.getElementById('navAvatar').textContent      = u.initials;
    document.getElementById('navAvatar').style.background = u.color;
    document.getElementById('navUserName').textContent    = u.name;
    document.getElementById('navUserRole').textContent    = u.title;
  },

  loadWeek(w, y) {
    this.state.week = w; this.state.year = y; this.state.page = 1;
    const lbl = document.getElementById('weekLabel');
    if (lbl) lbl.textContent = Utils.getWeekLabel(w, y);
    const badge = document.getElementById('weekBadge');
    if (badge) badge.classList.toggle('hidden', !Utils.isCurrentWeek(w,y));
    this.refresh();
  },

  prevWeek() {
    let w=this.state.week-1, y=this.state.year;
    if (w<=0) { w=52; y--; }
    this.loadWeek(w,y);
  },

  nextWeek() {
    if (this.state.week>=Utils.currentWeek()&&this.state.year>=Utils.currentYear()) return;
    let w=this.state.week+1, y=this.state.year;
    if (w>52) { w=1; y++; }
    this.loadWeek(w,y);
  },

  refresh() {
    this.state.tasks        = DataStore.getTasksByWeek(this.state.week, this.state.year);
    this.state.managersData = DataStore.getManagerStats(this.state.week, this.state.year);
    this._renderKPIs();
    this._renderCharts();
    this._renderManagerCards();
    this._renderTable();
  },

  // ── KPI cards ─────────────────────────────────────────────────────
  _renderKPIs() {
    const t   = this.state.tasks;
    const mds = this.state.managersData;
    const total      = t.length;
    const completed  = t.filter(x=>x.status==='completed').length;
    const inProgress = t.filter(x=>x.status==='in-progress').length;
    const delayed    = t.filter(x=>x.status==='delayed'||x.status==='blocked').length;
    const rate       = total ? Math.round(completed/total*100) : 0;
    const onTrack    = mds.filter(m=>m.completionRate>=60).length;

    this._set('kpiTotal',      total);
    this._set('kpiCompleted',  completed);
    this._set('kpiInProgress', inProgress);
    this._set('kpiDelayed',    delayed);
    this._set('kpiRate',       rate+'%');
    this._set('kpiSections',   mds.length);
    this._set('kpiOnTrack',    onTrack + ' of ' + mds.length);

    // Trend sub-labels
    this._set('kpiRateSub', rate>=70?'On track':'Needs attention');
    this._set('kpiDelaySub', delayed?`${delayed} require${delayed===1?'s':''} attention`:'None delayed');
  },

  // ── Charts ────────────────────────────────────────────────────────
  _renderCharts() {
    Charts.statusDonut('overallStatusChart',  this.state.tasks);
    Charts.managersBar('managersBarChart',    this.state.managersData);
    Charts.completionTrend('completionTrendChart');
    Charts.completionBar('completionRateChart', this.state.managersData);
    Charts.priorityDonut('priorityChart',     this.state.tasks);
  },

  // ── Manager cards ─────────────────────────────────────────────────
  _renderManagerCards() {
    const el = document.getElementById('managersGrid');
    if (!el) return;
    el.innerHTML = this.state.managersData.map(m => this._managerCardHTML(m)).join('');
  },

  _managerCardHTML(m) {
    const color  = m.color;
    const rate   = m.completionRate;
    const rcolor = Utils.completionRateColor(rate);
    const ring   = Charts.progressRing(rate, 58, 6, rcolor);
    const delayed= (m.byStatus?.delayed||0)+(m.byStatus?.blocked||0);
    const rateClass = rate>=70?'badge-completed':rate>=40?'badge-delayed':'badge-blocked';
    const dotCls    = delayed>0?'bg-delayed':'bg-completed';
    void dotCls;

    return `
<div class="mgr-card" onclick="Director.openManagerDetail('${m.id}')" style="--accent-color:${color}">
  <div class="mgr-card-top">
    <div class="mgr-avatar-wrap">
      <div class="mgr-avatar" style="background:${color}">${m.initials}</div>
      <div class="mgr-status-dot" style="background:${delayed>0?'#d97706':'#059669'}"></div>
    </div>
    <div class="mgr-info">
      <div class="mgr-name">${Utils.escHtml(m.name)}</div>
      <div class="mgr-section">${Utils.escHtml(m.section)}</div>
    </div>
    <span class="badge ${rateClass} mgr-kpi-badge">${rate}%</span>
  </div>

  <div class="mgr-progress-row">
    <div class="mgr-progress-ring">
      ${ring}
      <div class="ring-pct-text">${rate}%</div>
    </div>
    <div class="mgr-progress-info">
      <div class="mgr-prog-label">Weekly Completion</div>
      <div class="mgr-prog-bar-track">
        <div class="mgr-prog-bar-fill" style="width:${rate}%;background:${rcolor}"></div>
      </div>
    </div>
  </div>

  <div class="mgr-stats-mini">
    <div class="mgr-stat-mini">
      <span class="mgr-stat-mini-val">${m.total}</span>
      <span class="mgr-stat-mini-lbl">Total</span>
    </div>
    <div class="mgr-stat-mini">
      <span class="mgr-stat-mini-val" style="color:#059669">${m.byStatus?.completed||0}</span>
      <span class="mgr-stat-mini-lbl">Done</span>
    </div>
    <div class="mgr-stat-mini">
      <span class="mgr-stat-mini-val" style="color:#2563eb">${m.byStatus?.['in-progress']||0}</span>
      <span class="mgr-stat-mini-lbl">Active</span>
    </div>
    <div class="mgr-stat-mini">
      <span class="mgr-stat-mini-val" style="color:${delayed>0?'#dc2626':'#94a3b8'}">${delayed}</span>
      <span class="mgr-stat-mini-lbl">At Risk</span>
    </div>
  </div>

  <div class="mgr-card-footer">
    <div class="mgr-view-detail"><i class="fas fa-expand-alt"></i> View Details</div>
    <div class="mgr-last-updated">W${this.state.week}</div>
  </div>
</div>`;
  },

  // ── Summary table ─────────────────────────────────────────────────
  _renderTable() {
    const tasks = [...this.state.tasks];
    const col   = this.state.sortCol;
    const dir   = this.state.sortDir;
    tasks.sort((a,b) => {
      let va='', vb='';
      if (col==='section') { va=USERS.find(u=>u.id===a.assignedTo)?.section||''; vb=USERS.find(u=>u.id===b.assignedTo)?.section||''; }
      else { va=a[col]||''; vb=b[col]||''; }
      return typeof va==='string' ? va.localeCompare(vb)*dir : (va-vb)*dir;
    });

    const total = tasks.length;
    const start = (this.state.page-1)*this.state.pageSize;
    const paged = tasks.slice(start, start+this.state.pageSize);
    const pages = Math.ceil(total/this.state.pageSize);

    const tbody = document.getElementById('tasksTableBody');
    if (!tbody) return;

    if (!paged.length) {
      tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;padding:2rem;color:var(--text-3)">No tasks found for this week</td></tr>`;
    } else {
      tbody.innerHTML = paged.map(t => {
        const mgr = USERS.find(u=>u.id===t.assignedTo);
        const st  = STATUSES[t.status]||STATUSES['not-started'];
        const pr  = PRIORITIES[t.priority]||PRIORITIES.medium;
        return `<tr>
          <td class="td-title">${Utils.escHtml(t.title)}</td>
          <td><div class="td-manager">
            <div class="avatar td-avatar avatar-sm" style="background:${mgr?.color||'#64748b'}">${mgr?.initials||'?'}</div>
            <span>${Utils.escHtml(mgr?.section||'—')}</span>
          </div></td>
          <td><span class="badge ${st.badgeClass}">${st.label}</span></td>
          <td><span class="badge ${pr.badgeClass}">${pr.label}</span></td>
          <td>
            <div class="task-progress-track" style="height:6px;width:80px">
              <div class="task-progress-fill ${Utils.progressColor(t.completionPercentage||0)}" style="height:100%;border-radius:9999px;width:${t.completionPercentage||0}%"></div>
            </div>
            <span style="font-size:.72rem;color:var(--text-3)">${t.completionPercentage||0}%</span>
          </td>
          <td style="font-size:.78rem;color:var(--text-3)">${Utils.formatDate(t.dueDate)}</td>
        </tr>`;
      }).join('');
    }

    // Pagination
    this._set('pageInfo', `${Math.min(start+1,total)}–${Math.min(start+this.state.pageSize,total)} of ${total}`);
    const pg = document.getElementById('pagination');
    if (pg) {
      let btns = `<button class="pg-btn" onclick="Director.goPage(${this.state.page-1})" ${this.state.page<=1?'disabled':''}><i class="fas fa-chevron-left"></i></button>`;
      for (let i=1;i<=pages;i++) {
        if (pages>7&&Math.abs(i-this.state.page)>2&&i!==1&&i!==pages) { if (i===2||i===pages-1) btns+='<span style="padding:0 .25rem;color:var(--text-3)">…</span>'; continue; }
        btns+=`<button class="pg-btn${i===this.state.page?' active':''}" onclick="Director.goPage(${i})">${i}</button>`;
      }
      btns+=`<button class="pg-btn" onclick="Director.goPage(${this.state.page+1})" ${this.state.page>=pages?'disabled':''}><i class="fas fa-chevron-right"></i></button>`;
      pg.innerHTML = btns;
    }
  },

  goPage(p) {
    const pages = Math.ceil(this.state.tasks.length/this.state.pageSize);
    if (p<1||p>pages) return;
    this.state.page = p;
    this._renderTable();
  },

  sortTable(col) {
    if (this.state.sortCol===col) this.state.sortDir *= -1;
    else { this.state.sortCol=col; this.state.sortDir=1; }
    this.state.page=1;
    this._renderTable();
  },

  // ── Manager detail modal ──────────────────────────────────────────
  openManagerDetail(mgrId) {
    const mgr   = USERS.find(u => u.id===mgrId);
    const tasks = DataStore.getTasksByUser(mgrId, this.state.week, this.state.year);
    const stats = DataStore.getWeekStats(this.state.week, this.state.year, mgrId);
    if (!mgr) return;

    document.getElementById('mdAvatar').textContent      = mgr.initials;
    document.getElementById('mdAvatar').style.background = mgr.color;
    document.getElementById('mdName').textContent        = mgr.name;
    document.getElementById('mdSection').textContent     = mgr.section + ' · ' + Utils.getWeekLabel(this.state.week, this.state.year);
    document.getElementById('mdTotal').textContent       = stats.total;
    document.getElementById('mdDone').textContent        = stats.completed;
    document.getElementById('mdRate').textContent        = stats.completionRate + '%';

    const list = document.getElementById('mdTasksList');
    if (list) {
      if (!tasks.length) {
        list.innerHTML = `<div class="empty-state" style="padding:2rem"><i class="fas fa-clipboard-list"></i><p>No tasks this week</p></div>`;
      } else {
        const order = {blocked:0,delayed:1,'in-progress':2,'not-started':3,completed:4};
        const sorted= [...tasks].sort((a,b)=>(order[a.status]??5)-(order[b.status]??5));
        list.innerHTML = sorted.map(t => {
          const st  = STATUSES[t.status]||STATUSES['not-started'];
          const pr  = PRIORITIES[t.priority]||PRIORITIES.medium;
          const pct = t.completionPercentage||0;
          return `<div class="detail-task-row">
            <div class="dtr-left">
              <div class="dtr-title">${Utils.escHtml(t.title)}</div>
              <div class="dtr-meta">${Utils.escHtml(t.category||'')}${t.dueDate?' · Due '+Utils.formatDate(t.dueDate):''}</div>
              ${t.nextAction?`<div class="dtr-next"><i class="fas fa-arrow-right"></i> ${Utils.escHtml(t.nextAction.slice(0,100))}</div>`:''}
            </div>
            <div class="dtr-right">
              <span class="badge ${st.badgeClass}">${st.label}</span>
              <span class="badge ${pr.badgeClass}">${pr.label}</span>
              <div style="font-size:.72rem;color:var(--text-3);text-align:right">${pct}% complete</div>
            </div>
          </div>`;
        }).join('');
      }
    }

    document.getElementById('detailModal').classList.add('active');
    document.body.style.overflow='hidden';
  },

  closeDetail() {
    document.getElementById('detailModal').classList.remove('active');
    document.body.style.overflow='';
  },

  // ── Export ────────────────────────────────────────────────────────
  exportCSV() {
    const tasks = this.state.tasks;
    if (!tasks.length) { Toast.show('No tasks to export','warning'); return; }
    const headers = ['Manager','Section','Task Title','Category','Status','Priority','Completion %','Due Date','Next Action'];
    const rows = tasks.map(t => {
      const mgr = USERS.find(u=>u.id===t.assignedTo);
      return [
        mgr?.name||'', mgr?.section||'',
        `"${(t.title||'').replace(/"/g,'""')}"`,
        t.category||'', STATUSES[t.status]?.label||t.status,
        PRIORITIES[t.priority]?.label||t.priority,
        t.completionPercentage||0,
        t.dueDate||'',
        `"${(t.nextAction||'').replace(/"/g,'""')}"`
      ].join(',');
    });
    const csv  = [headers.join(','),...rows].join('\n');
    const blob = new Blob([csv],{type:'text/csv'});
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href=url; a.download=`finance-tasks-w${this.state.week}-${this.state.year}.csv`; a.click();
    URL.revokeObjectURL(url);
    Toast.show('Report exported successfully','success');
  },

  // ── Events ────────────────────────────────────────────────────────
  _setupEvents() {
    const detailModal = document.getElementById('detailModal');
    if (detailModal) detailModal.addEventListener('click', e => { if(e.target===detailModal) this.closeDetail(); });
  },

  // ── Helpers ───────────────────────────────────────────────────────
  _set(id, val) { const el=document.getElementById(id); if(el) el.textContent=val; }
};

// Toast (shared with manager.js — included on director page too)
const Toast = {
  show(msg, type='info') {
    const c = document.getElementById('toastContainer');
    if (!c) return;
    const el = document.createElement('div');
    el.className = `toast ${type}`;
    const icons = { success:'fa-check-circle', error:'fa-exclamation-circle', warning:'fa-exclamation-triangle', info:'fa-info-circle' };
    el.innerHTML = `<i class="fas ${icons[type]||icons.info}"></i><span>${Utils.escHtml(msg)}</span>`;
    c.appendChild(el);
    setTimeout(()=>{ el.style.opacity='0'; el.style.transform='translateX(120%)'; setTimeout(()=>el.remove(),200); },3500);
  }
};

document.addEventListener('DOMContentLoaded', ()=> Director.init());
