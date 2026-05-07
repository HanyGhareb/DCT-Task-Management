/* ================================================================
   manager.js — Section Manager dashboard controller
   ================================================================ */
'use strict';

const Manager = {
  state: {
    user: null, week: 0, year: 0,
    tasks: [], filter: 'all', search: '',
    editId: null, pendingFiles: []
  },

  init() {
    DataStore.init();
    this.state.user = Auth.requireAuth('manager');
    if (!this.state.user) return;
    this.state.week = Utils.currentWeek();
    this.state.year = Utils.currentYear();
    this._setupNav();
    this._setupEventListeners();
    this.loadWeek(this.state.week, this.state.year);
    if (Utils.isLastWorkday()) this._showLastDayBanner();
  },

  // ── Navigation ────────────────────────────────────────────────────
  _setupNav() {
    const u = this.state.user;
    document.getElementById('navAvatar').textContent  = u.initials;
    document.getElementById('navAvatar').style.background = u.color;
    document.getElementById('navUserName').textContent = u.name;
    document.getElementById('navUserRole').textContent = u.section;
  },

  loadWeek(w, y) {
    this.state.week = w;
    this.state.year = y;
    this.state.filter = 'all';
    this.state.search = '';
    const lbl = document.getElementById('weekLabel');
    if (lbl) lbl.textContent = Utils.getWeekLabel(w, y);
    const isCur = Utils.isCurrentWeek(w, y);
    const badge = document.getElementById('weekBadge');
    if (badge) { badge.classList.toggle('hidden', !isCur); }
    this.refresh();
  },

  prevWeek() {
    let w = this.state.week - 1, y = this.state.year;
    if (w <= 0) { w = 52; y--; }
    this.loadWeek(w, y);
  },

  nextWeek() {
    const curW = Utils.currentWeek(), curY = Utils.currentYear();
    if (this.state.week >= curW && this.state.year >= curY) return;
    let w = this.state.week + 1, y = this.state.year;
    if (w > 52) { w = 1; y++; }
    this.loadWeek(w, y);
  },

  // ── Refresh all UI ────────────────────────────────────────────────
  refresh() {
    this.state.tasks = DataStore.getTasksByUser(this.state.user.id, this.state.week, this.state.year);
    this._renderStats();
    this._renderTaskList();
    this._renderSidebar();
    this._renderCharts();
    this._updateTabCounts();
  },

  // ── Stats cards ───────────────────────────────────────────────────
  _renderStats() {
    const t = this.state.tasks;
    const total     = t.length;
    const completed = t.filter(x => x.status === 'completed').length;
    const inProg    = t.filter(x => x.status === 'in-progress').length;
    const delayed   = t.filter(x => x.status === 'delayed' || x.status === 'blocked').length;
    const rate      = total ? Math.round(completed/total*100) : 0;
    this._setInner('statTotal',     total);
    this._setInner('statCompleted', completed);
    this._setInner('statInProgress',inProg);
    this._setInner('statDelayed',   delayed);
    this._setInner('statRate',      rate + '%');
  },

  // ── Task list ─────────────────────────────────────────────────────
  _filteredTasks() {
    let tasks = [...this.state.tasks];
    if (this.state.filter !== 'all') tasks = tasks.filter(t => t.status === this.state.filter);
    if (this.state.search) {
      const q = this.state.search.toLowerCase();
      tasks = tasks.filter(t =>
        t.title.toLowerCase().includes(q) ||
        (t.description||'').toLowerCase().includes(q) ||
        (t.category||'').toLowerCase().includes(q)
      );
    }
    // Sort: delayed/blocked first, then in-progress, then not-started, then completed
    const order = { blocked:0, delayed:1, 'in-progress':2, 'not-started':3, completed:4 };
    tasks.sort((a,b) => (order[a.status]??5)-(order[b.status]??5));
    return tasks;
  },

  _renderTaskList() {
    const tasks = this._filteredTasks();
    const el = document.getElementById('tasksList');
    if (!el) return;
    if (!tasks.length) {
      el.innerHTML = `<div class="empty-state">
        <i class="fas fa-clipboard-list"></i>
        <h3>${this.state.search ? 'No matching tasks' : 'No tasks this week'}</h3>
        <p>${this.state.search ? 'Try a different search term.' : 'Click the + button to add your first task for this week.'}</p>
      </div>`;
      return;
    }
    el.innerHTML = tasks.map(t => this._taskCardHTML(t)).join('');
  },

  _taskCardHTML(t) {
    const st   = STATUSES[t.status]  || STATUSES['not-started'];
    const pr   = PRIORITIES[t.priority] || PRIORITIES.medium;
    const pct  = t.completionPercentage || 0;
    const pcol = Utils.progressColor(pct);
    const attCount = (t.attachments||[]).length;
    const isComplete = t.status === 'completed';
    const tagsHTML = (t.tags||[]).map(tag =>
      `<span class="badge badge-tag"><i class="fas fa-tag"></i>${Utils.escHtml(tag)}</span>`
    ).join('');
    const desc = Utils.escHtml(t.description || '').replace(/\n/g,'<br>');

    return `
<div class="task-card priority-${t.priority} status-${t.status}" id="card-${t.id}">
  <div class="task-card-header">
    <div class="task-card-title-wrap">
      <div class="task-card-title${isComplete?' line-through':''}">${Utils.escHtml(t.title)}</div>
      <div class="task-card-meta">
        <span class="task-category-chip"><i class="fas fa-folder-open"></i>${Utils.escHtml(t.category||'General')}</span>
        ${t.dueDate ? `<span class="task-due-date${this._isOverdue(t)?' overdue':''}"><i class="fas fa-calendar-alt"></i>${Utils.formatDate(t.dueDate,'MMM DD')}</span>` : ''}
      </div>
    </div>
    <div class="task-card-badges">
      <span class="badge ${pr.badgeClass}">${pr.label}</span>
    </div>
  </div>
  <div class="task-card-body">
    ${desc ? `<div class="task-description">${desc}</div>` : ''}
    <div class="task-progress-row">
      <div class="task-progress-bar">
        <div class="task-progress-track">
          <div class="task-progress-fill ${pcol}" style="width:${pct}%"></div>
        </div>
      </div>
      <span class="task-progress-pct">${pct}%</span>
    </div>
    ${t.nextAction ? `
    <div class="task-next-action">
      <div class="task-next-action-label"><i class="fas fa-arrow-right"></i>Next Action</div>
      <div class="task-next-action-text">${Utils.escHtml(t.nextAction)}</div>
    </div>` : ''}
    ${tagsHTML ? `<div class="task-tags">${tagsHTML}</div>` : ''}
  </div>
  <div class="task-card-footer">
    <div class="task-footer-left">
      <select class="status-select ${st.selectClass}" onchange="Manager.quickStatus('${t.id}', this.value)">
        ${Object.entries(STATUSES).map(([k,v])=>`<option value="${k}"${k===t.status?' selected':''}>${v.label}</option>`).join('')}
      </select>
      ${attCount ? `<span class="task-attachments-count" onclick="Manager.openTask('${t.id}')"><i class="fas fa-paperclip"></i>${attCount} file${attCount!==1?'s':''}</span>` : ''}
    </div>
    <div class="task-footer-right">
      <button class="btn btn-ghost btn-icon btn-sm" data-tip="Edit task" onclick="Manager.openTask('${t.id}')"><i class="fas fa-edit"></i></button>
      <button class="btn btn-ghost btn-icon btn-sm" data-tip="Delete task" onclick="Manager.confirmDelete('${t.id}')"><i class="fas fa-trash"></i></button>
    </div>
  </div>
</div>`;
  },

  _isOverdue(t) {
    if (!t.dueDate || t.status === 'completed') return false;
    return t.dueDate < Utils.today();
  },

  // ── Tabs / filter ─────────────────────────────────────────────────
  setFilter(f) {
    this.state.filter = f;
    document.querySelectorAll('.tab-btn').forEach(b => {
      b.classList.toggle('active', b.dataset.filter === f);
    });
    this._renderTaskList();
  },

  _updateTabCounts() {
    const t = this.state.tasks;
    const counts = { all: t.length, ...Object.fromEntries(Object.keys(STATUSES).map(s=>[s,0])) };
    t.forEach(x => { if (counts[x.status]!==undefined) counts[x.status]++; });
    document.querySelectorAll('.tab-btn').forEach(b => {
      const cnt = b.querySelector('.tab-count');
      if (cnt) cnt.textContent = counts[b.dataset.filter] ?? 0;
    });
  },

  setSearch(q) {
    this.state.search = q;
    this._renderTaskList();
    const clr = document.getElementById('searchClear');
    if (clr) clr.classList.toggle('hidden', !q);
  },

  clearSearch() {
    document.getElementById('searchInput').value = '';
    this.setSearch('');
  },

  // ── Sidebar ───────────────────────────────────────────────────────
  _renderSidebar() {
    const t = this.state.tasks;
    const total = t.length;
    const done  = t.filter(x => x.status === 'completed').length;
    const inProg= t.filter(x => x.status === 'in-progress').length;
    const pct   = total ? Math.round(done/total*100) : 0;
    const color = Utils.completionRateColor(pct);

    const ring = Charts.progressRing(pct, 96, 8, color);
    const ringWrap = document.getElementById('wscRing');
    if (ringWrap) {
      ringWrap.innerHTML = `${ring}<div class="wsc-ring-text"><span class="wsc-ring-pct">${pct}%</span><span class="wsc-ring-label">Done</span></div>`;
    }
    this._setInner('wscTotal',     total);
    this._setInner('wscDone',      done);
    this._setInner('wscInProg',    inProg);
    this._setInner('wscDelayed',   t.filter(x=>x.status==='delayed'||x.status==='blocked').length);

    // Next actions panel
    const pending = t.filter(x => x.status !== 'completed' && x.nextAction)
                     .sort((a,b) => { const o={blocked:0,delayed:1,'in-progress':2,'not-started':3}; return (o[a.status]??4)-(o[b.status]??4); })
                     .slice(0, 5);
    const naEl = document.getElementById('nextActionsList');
    if (naEl) {
      if (!pending.length) {
        naEl.innerHTML = `<div class="empty-state" style="padding:1.5rem"><i class="fas fa-check-double" style="font-size:1.5rem"></i><p style="font-size:.8rem;margin-top:.5rem">All caught up!</p></div>`;
      } else {
        const dotColors = { blocked:'#dc2626', delayed:'#d97706', 'in-progress':'#2563eb', 'not-started':'#94a3b8' };
        naEl.innerHTML = pending.map(t => `
        <div class="next-action-item">
          <div class="nai-dot" style="background:${dotColors[t.status]||'#94a3b8'}"></div>
          <div class="nai-content">
            <div class="nai-title">${Utils.escHtml(t.title)}</div>
            <div class="nai-action">${Utils.escHtml(t.nextAction||'').slice(0,80)}</div>
          </div>
        </div>`).join('');
      }
    }
  },

  // ── Charts ────────────────────────────────────────────────────────
  _renderCharts() {
    Charts.statusDonut('statusDonutChart', this.state.tasks);
    const trend = DataStore.getWeeklyTrend(this.state.user.id, 6);
    Charts.weeklyBar('weeklyTrendChart', trend);
  },

  // ── Task modal ────────────────────────────────────────────────────
  openNew() {
    this.state.editId    = null;
    this.state.pendingFiles = [];
    document.getElementById('modalTitle').textContent = 'Add New Task';
    this._resetForm();
    const { start, end } = Utils.getWeekDates(this.state.week, this.state.year);
    document.getElementById('fStartDate').value = start;
    document.getElementById('fDueDate').value   = end;
    this._renderAttachments([]);
    this._openModal();
  },

  openTask(id) {
    const task = DataStore.getTask(id);
    if (!task) return;
    this.state.editId    = id;
    this.state.pendingFiles = [];
    document.getElementById('modalTitle').textContent = 'Edit Task';
    this._fillForm(task);
    this._renderAttachments(task.attachments || []);
    this._openModal();
  },

  _openModal()  { document.getElementById('taskModal').classList.add('active'); document.body.style.overflow='hidden'; },
  _closeModal() { document.getElementById('taskModal').classList.remove('active'); document.body.style.overflow=''; },

  _resetForm() {
    document.getElementById('taskForm').reset();
    document.getElementById('fTitle').value       = '';
    document.getElementById('fCategory').value    = 'Budget Review';
    document.getElementById('fStatus').value      = 'in-progress';
    document.getElementById('fDesc').value        = '';
    document.getElementById('fNextAction').value  = '';
    document.getElementById('fNADate').value      = '';
    document.getElementById('fNotes').value       = '';
    document.getElementById('fCompletion').value  = 0;
    document.getElementById('completionVal').textContent = '0%';
    document.querySelectorAll('input[name="priority"]').forEach(r => r.checked = r.value === 'medium');
    this._clearErrors();
  },

  _fillForm(t) {
    document.getElementById('fTitle').value       = t.title || '';
    document.getElementById('fCategory').value    = t.category || 'Other';
    document.getElementById('fStatus').value      = t.status || 'in-progress';
    document.getElementById('fDesc').value        = t.description || '';
    document.getElementById('fStartDate').value   = t.startDate || '';
    document.getElementById('fDueDate').value     = t.dueDate || '';
    document.getElementById('fNextAction').value  = t.nextAction || '';
    document.getElementById('fNADate').value      = t.nextActionDate || '';
    document.getElementById('fNotes').value       = t.notes || '';
    const pct = t.completionPercentage ?? 0;
    document.getElementById('fCompletion').value  = pct;
    document.getElementById('completionVal').textContent = pct + '%';
    document.querySelectorAll('input[name="priority"]').forEach(r => r.checked = r.value === t.priority);
    this._clearErrors();
  },

  updateCompletionDisplay(val) {
    document.getElementById('completionVal').textContent = val + '%';
    const auto = { 0:'not-started', 100:'completed' };
    if (auto[+val]) document.getElementById('fStatus').value = auto[+val];
  },

  saveTask() {
    if (!this._validate()) return;
    const priority = document.querySelector('input[name="priority"]:checked')?.value || 'medium';
    const pct      = parseInt(document.getElementById('fCompletion').value) || 0;

    const existing = this.state.editId ? DataStore.getTask(this.state.editId) : null;
    const existingAttachments = existing ? (existing.attachments || []) : [];

    const payload = {
      title:                document.getElementById('fTitle').value.trim(),
      category:             document.getElementById('fCategory').value,
      status:               document.getElementById('fStatus').value,
      priority,
      description:          document.getElementById('fDesc').value.trim(),
      startDate:            document.getElementById('fStartDate').value,
      dueDate:              document.getElementById('fDueDate').value,
      nextAction:           document.getElementById('fNextAction').value.trim(),
      nextActionDate:       document.getElementById('fNADate').value,
      notes:                document.getElementById('fNotes').value.trim(),
      completionPercentage: pct,
      assignedTo:           this.state.user.id,
      weekNumber:           this.state.week,
      year:                 this.state.year,
      tags:                 [],
      attachments:          [...existingAttachments, ...this.state.pendingFiles]
    };

    if (this.state.editId) {
      DataStore.updateTask(this.state.editId, payload);
      Toast.show('Task updated successfully', 'success');
    } else {
      DataStore.addTask(payload);
      Toast.show('Task added successfully', 'success');
    }
    this._closeModal();
    this.refresh();
  },

  _validate() {
    this._clearErrors();
    let ok = true;
    const title = document.getElementById('fTitle').value.trim();
    if (!title) { this._setError('fTitle', 'Task title is required'); ok = false; }
    const next  = document.getElementById('fNextAction').value.trim();
    if (!next)  { this._setError('fNextAction', 'Next action is required'); ok = false; }
    return ok;
  },

  _setError(id, msg) {
    const el = document.getElementById(id);
    if (!el) return;
    el.classList.add('error');
    const err = el.parentElement.querySelector('.form-error');
    if (err) err.textContent = msg;
  },

  _clearErrors() {
    document.querySelectorAll('.form-control.error').forEach(e => e.classList.remove('error'));
    document.querySelectorAll('.form-error').forEach(e => e.textContent = '');
  },

  // ── File attachments ──────────────────────────────────────────────
  handleDropZoneClick() { document.getElementById('fileInput').click(); },

  handleFileChange(input) { this._processFiles(Array.from(input.files)); input.value=''; },

  handleDrop(e) {
    e.preventDefault();
    document.getElementById('fileDropZone').classList.remove('drag-over');
    this._processFiles(Array.from(e.dataTransfer.files));
  },

  _processFiles(files) {
    const MAX = 2 * 1024 * 1024; // 2MB
    files.forEach(f => {
      if (f.size > MAX) { Toast.show(`"${f.name}" exceeds 2 MB limit`, 'error'); return; }
      const reader = new FileReader();
      reader.onload = e => {
        this.state.pendingFiles.push({ id: Utils.uid(), name:f.name, type:f.type, size:f.size, data:e.target.result, uploadedAt: new Date().toISOString() });
        this._renderAttachments([...(this.state.editId ? (DataStore.getTask(this.state.editId)?.attachments||[]) : []), ...this.state.pendingFiles]);
      };
      reader.readAsDataURL(f);
    });
  },

  _renderAttachments(attachments) {
    const el = document.getElementById('attachmentList');
    if (!el) return;
    if (!attachments.length) { el.innerHTML = ''; return; }
    el.innerHTML = attachments.map(a => {
      const { icon, color } = Utils.getFileIcon(a.type);
      const isPending = this.state.pendingFiles.some(p => p.id === a.id);
      return `
      <div class="file-item" id="att-${a.id}">
        <i class="fas ${icon} file-item-icon" style="color:${color}"></i>
        <div class="file-item-info">
          <div class="file-item-name">${Utils.escHtml(a.name)}</div>
          <div class="file-item-size">${Utils.formatFileSize(a.size)}${isPending ? ' · Pending' : ''}</div>
        </div>
        <div class="file-item-actions">
          ${!isPending && a.data ? `<button class="btn btn-ghost btn-icon btn-sm" data-tip="Download" onclick="Manager.downloadFile('${a.id}')"><i class="fas fa-download"></i></button>` : ''}
          <button class="btn btn-ghost btn-icon btn-sm" data-tip="Remove" onclick="Manager.removeFile('${a.id}', ${isPending})"><i class="fas fa-times"></i></button>
        </div>
      </div>`;
    }).join('');
  },

  removeFile(id, isPending) {
    if (isPending) {
      this.state.pendingFiles = this.state.pendingFiles.filter(f => f.id !== id);
    } else if (this.state.editId) {
      const task = DataStore.getTask(this.state.editId);
      if (task) {
        DataStore.updateTask(this.state.editId, { attachments: task.attachments.filter(a => a.id !== id) });
      }
    }
    const att = [...(this.state.editId ? (DataStore.getTask(this.state.editId)?.attachments||[]) : []), ...this.state.pendingFiles];
    this._renderAttachments(att);
  },

  downloadFile(id) {
    const task = this.state.editId ? DataStore.getTask(this.state.editId) : null;
    const att  = task?.attachments?.find(a => a.id === id);
    if (!att?.data) return;
    const a = document.createElement('a');
    a.href     = att.data;
    a.download = att.name;
    a.click();
  },

  // ── Delete ────────────────────────────────────────────────────────
  confirmDelete(id) {
    const task = DataStore.getTask(id);
    if (!task) return;
    document.getElementById('confirmTitle').textContent   = 'Delete Task?';
    document.getElementById('confirmMessage').textContent = `"${task.title}" will be permanently deleted.`;
    document.getElementById('confirmBtn').onclick = () => { this._doDelete(id); Confirm.close(); };
    Confirm.open();
  },

  _doDelete(id) {
    DataStore.deleteTask(id);
    Toast.show('Task deleted', 'warning');
    this.refresh();
  },

  // ── Quick status update ───────────────────────────────────────────
  quickStatus(id, status) {
    const updates = { status };
    if (status === 'completed') updates.completionPercentage = 100;
    if (status === 'not-started') updates.completionPercentage = 0;
    DataStore.updateTask(id, updates);
    this.refresh();
    Toast.show('Status updated', 'success');
  },

  // ── Alert banner ──────────────────────────────────────────────────
  _showLastDayBanner() {
    const el = document.getElementById('alertBanner');
    if (el) el.classList.remove('hidden');
  },

  // ── Event listeners ───────────────────────────────────────────────
  _setupEventListeners() {
    // Search
    const search = document.getElementById('searchInput');
    if (search) {
      search.addEventListener('input', Utils.debounce(e => this.setSearch(e.target.value), 200));
    }
    // Drag & drop
    const dz = document.getElementById('fileDropZone');
    if (dz) {
      dz.addEventListener('dragover',  e => { e.preventDefault(); dz.classList.add('drag-over'); });
      dz.addEventListener('dragleave', ()=> dz.classList.remove('drag-over'));
      dz.addEventListener('drop',      e => this.handleDrop(e));
    }
    // Completion slider
    const slider = document.getElementById('fCompletion');
    if (slider) slider.addEventListener('input', e => this.updateCompletionDisplay(e.target.value));
    // Close modal on overlay click
    const overlay = document.getElementById('taskModal');
    if (overlay) overlay.addEventListener('click', e => { if (e.target === overlay) this._closeModal(); });
  },

  // ── Helpers ───────────────────────────────────────────────────────
  _setInner(id, val) { const el=document.getElementById(id); if(el) el.textContent=val; }
};

// ── Toast ──────────────────────────────────────────────────────────
const Toast = {
  show(msg, type='info') {
    const c = document.getElementById('toastContainer');
    if (!c) return;
    const t = document.createElement('div');
    t.className = `toast ${type}`;
    const icons = { success:'fa-check-circle', error:'fa-exclamation-circle', warning:'fa-exclamation-triangle', info:'fa-info-circle' };
    t.innerHTML = `<i class="fas ${icons[type]||icons.info}"></i><span>${Utils.escHtml(msg)}</span>`;
    c.appendChild(t);
    setTimeout(() => { t.style.opacity='0'; t.style.transform='translateX(120%)'; setTimeout(()=>t.remove(),200); }, 3000);
  }
};

// ── Confirm dialog ─────────────────────────────────────────────────
const Confirm = {
  open()  { document.getElementById('confirmOverlay').classList.add('active'); },
  close() { document.getElementById('confirmOverlay').classList.remove('active'); }
};

document.addEventListener('DOMContentLoaded', () => Manager.init());
