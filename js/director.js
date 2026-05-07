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
    const avatarEl = document.getElementById('navAvatar');
    if (avatarEl) {
      avatarEl.outerHTML = Utils.avatarImg(u, 36, 'nav-avatar');
    }
    document.getElementById('navUserName').textContent = u.name;
    document.getElementById('navUserRole').textContent = u.title;
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
      ${Utils.avatarImg(m, 46, 'mgr-avatar')}
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
            ${mgr ? Utils.avatarImg(mgr, 26, 'avatar td-avatar avatar-sm') : '<div class="avatar avatar-sm" style="background:#94a3b8">?</div>'}
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

    const mdAv = document.getElementById('mdAvatar');
    if (mdAv) mdAv.outerHTML = Utils.avatarImg(mgr, 56, 'avatar mdh-avatar');
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
          return `<div class="detail-task-row" onclick="Director.openTaskDetail('${t.id}')" style="cursor:pointer">
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

  // ── KPI Drill-Down Modal ──────────────────────────────────────────
  openKPIDrill(filter) {
    const tasks = this.state.tasks;
    let filtered, title, sub;
    if (filter === 'all') {
      filtered = [...tasks];
      title = 'All Tasks';
      sub = `${tasks.length} task${tasks.length !== 1 ? 's' : ''} across all sections`;
    } else if (filter === 'risk') {
      filtered = tasks.filter(t => t.status === 'delayed' || t.status === 'blocked');
      title = 'At Risk Tasks';
      sub = `${filtered.length} delayed or blocked task${filtered.length !== 1 ? 's' : ''}`;
    } else if (filter === 'rate') {
      filtered = [...tasks];
      const done = tasks.filter(t => t.status === 'completed').length;
      const rate = tasks.length ? Math.round(done / tasks.length * 100) : 0;
      title = 'Completion Overview';
      sub = `${rate}% completion rate · ${done} of ${tasks.length} tasks completed`;
    } else if (filter === 'on-track') {
      const onTrackIds = this.state.managersData.filter(m => m.completionRate >= 60).map(m => m.id);
      filtered = tasks.filter(t => onTrackIds.includes(t.assignedTo));
      const onTrack = onTrackIds.length;
      title = `On-Track Sections (${onTrack} of ${this.state.managersData.length})`;
      sub = `Tasks from sections meeting ≥60% completion target`;
    } else {
      filtered = tasks.filter(t => t.status === filter);
      const label = STATUSES[filter]?.label || filter;
      title = `${label} Tasks`;
      sub = `${filtered.length} task${filtered.length !== 1 ? 's' : ''} across all sections`;
    }
    document.getElementById('kpiDrillTitle').textContent = title;
    document.getElementById('kpiDrillSub').textContent = sub + ' · ' + Utils.getWeekLabel(this.state.week, this.state.year);
    const list = document.getElementById('kpiDrillList');
    if (!list) return;
    const order = { blocked:0, delayed:1, 'in-progress':2, 'not-started':3, completed:4 };
    filtered.sort((a,b) => (order[a.status]??5)-(order[b.status]??5));
    if (!filtered.length) {
      list.innerHTML = `<div class="empty-state" style="padding:2rem"><i class="fas fa-clipboard-check" style="font-size:2rem;color:#059669"></i><h3>No tasks</h3><p>Nothing to show for this filter.</p></div>`;
    } else {
      list.innerHTML = filtered.map(t => {
        const mgr = USERS.find(u => u.id === t.assignedTo);
        const st  = STATUSES[t.status] || STATUSES['not-started'];
        const pr  = PRIORITIES[t.priority] || PRIORITIES.medium;
        const pct = t.completionPercentage || 0;
        return `<div class="detail-task-row" onclick="Director.openTaskDetail('${t.id}')" style="cursor:pointer">
          <div class="dtr-left">
            <div class="dtr-title">${Utils.escHtml(t.title)}</div>
            <div class="dtr-meta">${mgr ? `${Utils.escHtml(mgr.section)} · ` : ''}${Utils.escHtml(t.category||'')}${t.dueDate ? ' · Due ' + Utils.formatDate(t.dueDate) : ''}</div>
            ${t.nextAction ? `<div class="dtr-next"><i class="fas fa-arrow-right"></i> ${Utils.escHtml(t.nextAction.slice(0,100))}</div>` : ''}
          </div>
          <div class="dtr-right">
            <span class="badge ${st.badgeClass}">${st.label}</span>
            <span class="badge ${pr.badgeClass}">${pr.label}</span>
            <div style="font-size:.72rem;color:var(--text-3);text-align:right">${pct}% complete</div>
          </div>
        </div>`;
      }).join('');
    }
    document.getElementById('kpiDrillModal').classList.add('active');
    document.body.style.overflow = 'hidden';
  },

  closeKPIDrill() {
    document.getElementById('kpiDrillModal').classList.remove('active');
    document.body.style.overflow = '';
  },

  // ── Full Task Detail Modal ────────────────────────────────────────
  openTaskDetail(taskId) {
    const t = DataStore.getTask(taskId);
    if (!t) return;
    const mgr = USERS.find(u => u.id === t.assignedTo);

    // Header
    this._set('tdTitle', t.title);
    this._set('tdMeta', (t.category || '') + (t.dueDate ? ' · Due ' + Utils.formatDate(t.dueDate) : '') + ' · ' + Utils.getWeekLabel(t.weekNumber, t.year));

    // Manager strip
    const strip = document.getElementById('tdManagerStrip');
    if (strip && mgr) {
      strip.innerHTML = `
        ${Utils.avatarImg(mgr, 42, 'avatar')}
        <div>
          <div style="font-size:.9rem;font-weight:700;color:var(--text-1)">${Utils.escHtml(mgr.name)}</div>
          <div style="font-size:.75rem;color:var(--text-3)">${Utils.escHtml(mgr.title || mgr.section)}</div>
        </div>`;
    }

    // Badge row (status + priority)
    const badgeRow = document.getElementById('tdBadgeRow');
    if (badgeRow) {
      const st = STATUSES[t.status] || STATUSES['not-started'];
      const pr = PRIORITIES[t.priority] || PRIORITIES.medium;
      badgeRow.innerHTML = `
        <span class="badge ${st.badgeClass}" style="font-size:.82rem;padding:.3rem .75rem">${st.label}</span>
        <span class="badge ${pr.badgeClass}" style="font-size:.82rem;padding:.3rem .75rem">${pr.label}</span>`;
    }

    // Progress bar
    const pct = t.completionPercentage || 0;
    const pFill = document.getElementById('tdProgressFill');
    if (pFill) { pFill.style.width = pct + '%'; pFill.className = `task-progress-fill ${Utils.progressColor(pct)}`; }
    this._set('tdProgressPct', pct + '%');

    // Completion summary bar
    const compBar = document.getElementById('tdCompletionBar');
    if (compBar) compBar.innerHTML = t.status === 'completed' ? this._completionSummaryHTML(t) : '';

    // Description
    const descWrap = document.getElementById('tdDescWrap');
    const descEl   = document.getElementById('tdDesc');
    if (descEl) {
      if (t.description) {
        descEl.innerHTML = Utils.escHtml(t.description).replace(/\n/g,'<br>');
        if (descWrap) descWrap.style.display = '';
      } else {
        if (descWrap) descWrap.style.display = 'none';
      }
    }

    // Dates
    this._set('tdStartDate', Utils.formatDate(t.startDate, 'dddd, MMM DD, YYYY') || '—');
    this._set('tdDueDate',   Utils.formatDate(t.dueDate,   'dddd, MMM DD, YYYY') || '—');

    // Next action
    const nextWrap = document.getElementById('tdNextWrap');
    if (t.nextAction) {
      this._set('tdNextAction', t.nextAction);
      this._set('tdNextDate', t.nextActionDate ? 'Target: ' + Utils.formatDate(t.nextActionDate) : '');
      if (nextWrap) nextWrap.style.display = '';
    } else {
      if (nextWrap) nextWrap.style.display = 'none';
    }

    // Tags
    const tagsWrap = document.getElementById('tdTagsWrap');
    const tagsEl   = document.getElementById('tdTags');
    if (tagsEl) {
      const tags = t.tags || [];
      tagsEl.innerHTML = tags.map(tag => `<span class="badge badge-tag"><i class="fas fa-tag"></i>${Utils.escHtml(tag)}</span>`).join('');
      if (tagsWrap) tagsWrap.style.display = tags.length ? '' : 'none';
    }

    // Attachments
    const attList = document.getElementById('tdAttList');
    const noAtt   = document.getElementById('tdNoAtt');
    const atts = t.attachments || [];
    if (attList) {
      if (atts.length) {
        attList.innerHTML = atts.map(a => {
          const { icon, color } = Utils.getFileIcon(a.type);
          return `<div class="file-item">
            <i class="fas ${icon} file-item-icon" style="color:${color}"></i>
            <div class="file-item-info">
              <div class="file-item-name">${Utils.escHtml(a.name)}</div>
              <div class="file-item-size">${Utils.formatFileSize(a.size)}</div>
            </div>
            ${a.data ? `<div class="file-item-actions"><a class="btn btn-ghost btn-icon btn-sm" href="${a.data}" download="${Utils.escHtml(a.name)}" title="Download"><i class="fas fa-download"></i></a></div>` : ''}
          </div>`;
        }).join('');
        if (noAtt) noAtt.style.display = 'none';
      } else {
        attList.innerHTML = '';
        if (noAtt) noAtt.style.display = '';
      }
    }

    // Notes
    const notesWrap = document.getElementById('tdNotesWrap');
    const notesEl   = document.getElementById('tdNotes');
    if (notesEl) {
      if (t.notes) {
        notesEl.textContent = t.notes;
        if (notesWrap) notesWrap.style.display = '';
      } else {
        if (notesWrap) notesWrap.style.display = 'none';
      }
    }

    document.getElementById('taskDetailModal').classList.add('active');
    document.body.style.overflow = 'hidden';
  },

  closeTaskDetail() {
    document.getElementById('taskDetailModal').classList.remove('active');
    document.body.style.overflow = '';
  },

  // ── Completion summary bar ────────────────────────────────────────
  _completionSummaryHTML(t) {
    const completedDate = t.updatedAt ? t.updatedAt.slice(0, 10) : (t.dueDate || Utils.today());
    const startDate = t.startDate || (t.createdAt ? t.createdAt.slice(0, 10) : completedDate);
    const duration = Math.max(1, Math.round((Utils.parseDate(completedDate) - Utils.parseDate(startDate)) / 86400000));
    const onTime = !t.dueDate || completedDate <= t.dueDate;
    const dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    const d = Utils.parseDate(completedDate);
    const label = `${dayNames[d.getUTCDay()]} ${Utils.formatDate(completedDate, 'DD-MMM-YYYY')}`;
    return onTime
      ? `<div class="task-completion-bar ct-on-time" style="margin-bottom:1rem"><i class="fas fa-check-circle"></i> Completed on ${label} &nbsp;·&nbsp; Duration: ${duration} Day${duration !== 1 ? 's' : ''} &nbsp;·&nbsp; <strong>On-Time ✓</strong></div>`
      : `<div class="task-completion-bar ct-late" style="margin-bottom:1rem"><i class="fas fa-clock"></i> Completed on ${label} &nbsp;·&nbsp; Duration: ${duration} Day${duration !== 1 ? 's' : ''} &nbsp;·&nbsp; <strong>Late ✗</strong></div>`;
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
    const kpiDrillModal = document.getElementById('kpiDrillModal');
    if (kpiDrillModal) kpiDrillModal.addEventListener('click', e => { if(e.target===kpiDrillModal) this.closeKPIDrill(); });
    const taskDetailModal = document.getElementById('taskDetailModal');
    if (taskDetailModal) taskDetailModal.addEventListener('click', e => { if(e.target===taskDetailModal) this.closeTaskDetail(); });
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
