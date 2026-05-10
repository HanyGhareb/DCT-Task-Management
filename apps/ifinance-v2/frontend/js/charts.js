/* ================================================================
   charts.js — Chart.js wrapper for all dashboard charts
   ================================================================ */
'use strict';

const Charts = {
  _reg: {},

  destroy(id) {
    if (this._reg[id]) { this._reg[id].destroy(); delete this._reg[id]; }
  },
  destroyAll() { Object.keys(this._reg).forEach(id => this.destroy(id)); },

  _make(id, cfg) {
    this.destroy(id);
    const el = document.getElementById(id);
    if (!el) return null;
    this._reg[id] = new Chart(el.getContext('2d'), cfg);
    return this._reg[id];
  },

  // ── Status donut ──────────────────────────────────────────────────
  statusDonut(canvasId, tasks) {
    const counts = Object.fromEntries(Object.keys(STATUSES).map(s => [s,0]));
    tasks.forEach(t => { if (counts[t.status] !== undefined) counts[t.status]++; });
    const labels = Object.values(STATUSES).map(s => s.label);
    const data   = Object.keys(STATUSES).map(s => counts[s]);
    const colors = ['#94a3b8','#3b82f6','#10b981','#f59e0b','#ef4444'];

    return this._make(canvasId, {
      type: 'doughnut',
      data: { labels, datasets: [{ data, backgroundColor: colors, borderWidth: 0, hoverOffset: 6 }] },
      options: {
        responsive: true, maintainAspectRatio: false, cutout: '70%',
        plugins: {
          legend: { position:'bottom', labels:{ padding:12, font:{ size:11, family:'Inter' }, usePointStyle:true, pointStyleWidth:8 } },
          tooltip: { callbacks: { label: c => ` ${c.label}: ${c.raw}` } }
        },
        animation: { duration:600 }
      }
    });
  },

  // ── Weekly stacked bar (manager trend) ────────────────────────────
  weeklyBar(canvasId, trendData) {
    const ds = [
      { label:'Completed',  key:'completed',   color:'#10b981' },
      { label:'In Progress',key:'in-progress', color:'#3b82f6' },
      { label:'Delayed',    key:'delayed',      color:'#f59e0b' },
      { label:'Blocked',    key:'blocked',      color:'#ef4444' },
      { label:'Not Started',key:'not-started', color:'#94a3b8' }
    ];
    return this._make(canvasId, {
      type: 'bar',
      data: {
        labels: trendData.map(d => d.label),
        datasets: ds.map(d => ({
          label: d.label,
          data: trendData.map(t => t.byStatus ? (t.byStatus[d.key] || 0) : 0),
          backgroundColor: d.color,
          borderRadius: 4, borderSkipped: false, stack: 'stack'
        }))
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        scales: {
          x: { stacked:true, grid:{ display:false }, ticks:{ font:{size:11,family:'Inter'}, color:'#64748b' } },
          y: { stacked:true, beginAtZero:true, grid:{ color:'#f1f5f9' }, ticks:{ stepSize:1, font:{size:11,family:'Inter'}, color:'#64748b' } }
        },
        plugins: {
          legend: { position:'bottom', labels:{ padding:10, font:{size:11,family:'Inter'}, usePointStyle:true, pointStyleWidth:8 } }
        },
        animation: { duration:600 }
      }
    });
  },

  // ── Priority donut ────────────────────────────────────────────────
  priorityDonut(canvasId, tasks) {
    const c = { high:0, medium:0, low:0 };
    tasks.forEach(t => { if (c[t.priority] !== undefined) c[t.priority]++; });
    return this._make(canvasId, {
      type: 'doughnut',
      data: {
        labels: ['High','Medium','Low'],
        datasets: [{ data:[c.high,c.medium,c.low], backgroundColor:['#ef4444','#f59e0b','#10b981'], borderWidth:0, hoverOffset:6 }]
      },
      options: {
        responsive:true, maintainAspectRatio:false, cutout:'70%',
        plugins: {
          legend:{ position:'bottom', labels:{ padding:12, font:{size:11,family:'Inter'}, usePointStyle:true, pointStyleWidth:8 } }
        },
        animation:{ duration:600 }
      }
    });
  },

  // ── Manager stacked bar (director view) ───────────────────────────
  managersBar(canvasId, managersData) {
    const ds = [
      { label:'Completed',  key:'completed',   color:'#10b981' },
      { label:'In Progress',key:'in-progress', color:'#3b82f6' },
      { label:'Not Started',key:'not-started', color:'#94a3b8' },
      { label:'Delayed',    key:'delayed',      color:'#f59e0b' },
      { label:'Blocked',    key:'blocked',      color:'#ef4444' }
    ];
    const labels = managersData.map(m => m.section.split(' & ')[0].split(' ').slice(0,2).join(' '));
    return this._make(canvasId, {
      type: 'bar',
      data: {
        labels,
        datasets: ds.map(d => ({
          label: d.label,
          data: managersData.map(m => m.byStatus ? (m.byStatus[d.key]||0) : 0),
          backgroundColor: d.color,
          borderRadius: 4, borderSkipped: false, stack:'stack'
        }))
      },
      options: {
        responsive:true, maintainAspectRatio:false,
        scales: {
          x:{ stacked:true, grid:{ display:false }, ticks:{ font:{size:11,family:'Inter'}, color:'#64748b' } },
          y:{ stacked:true, beginAtZero:true, grid:{ color:'#f1f5f9' }, ticks:{ stepSize:1, font:{size:11,family:'Inter'}, color:'#64748b' } }
        },
        plugins: {
          legend:{ position:'bottom', labels:{ padding:10, font:{size:11,family:'Inter'}, usePointStyle:true, pointStyleWidth:8 } }
        },
        animation:{ duration:600 }
      }
    });
  },

  // ── Completion trend — multi-line (director view) ─────────────────
  completionTrend(canvasId, numWeeks = 6) {
    const curW = Utils.getISOWeek(new Date());
    const curY = new Date().getFullYear();
    const weeks = Array.from({ length: numWeeks }, (_, i) => {
      let w = curW - (numWeeks-1-i), y = curY;
      if (w <= 0) { w += 52; y--; }
      return { w, y, label: `W${w}` };
    });
    const managers = USERS.filter(u => u.role === 'manager');
    const colors = ['#7c3aed','#2563eb','#059669','#d97706','#dc2626'];
    const datasets = managers.map((m, i) => ({
      label: m.section.split(' & ')[0].split(' ')[0],
      data: weeks.map(wk => DataStore.getWeekStats(wk.w, wk.y, m.id).completionRate),
      borderColor: colors[i], backgroundColor: colors[i]+'20',
      borderWidth: 2.5, pointBackgroundColor: colors[i],
      pointRadius: 4, pointHoverRadius: 6, tension: 0.4, fill: false
    }));
    return this._make(canvasId, {
      type:'line',
      data:{ labels: weeks.map(w => w.label), datasets },
      options:{
        responsive:true, maintainAspectRatio:false,
        scales:{
          x:{ grid:{ display:false }, ticks:{ font:{size:11,family:'Inter'}, color:'#64748b' } },
          y:{ beginAtZero:true, max:100, grid:{ color:'#f1f5f9' }, ticks:{ font:{size:11,family:'Inter'}, color:'#64748b', callback:v=>v+'%' } }
        },
        plugins:{
          legend:{ position:'bottom', labels:{ padding:10, font:{size:11,family:'Inter'}, usePointStyle:true, pointStyleWidth:8 } },
          tooltip:{ callbacks:{ label:c=>` ${c.dataset.label}: ${c.raw}%` } }
        },
        animation:{ duration:600 }
      }
    });
  },

  // ── Horizontal bar — overall completion rate per manager ──────────
  completionBar(canvasId, managersData) {
    const labels = managersData.map(m => m.section.split(' & ')[0].split(' ').slice(0,2).join(' '));
    const data   = managersData.map(m => m.completionRate);
    const colors = managersData.map(m => Utils.completionRateColor(m.completionRate));
    return this._make(canvasId, {
      type: 'bar',
      data: {
        labels,
        datasets:[{
          label:'Completion Rate (%)',
          data, backgroundColor: colors,
          borderRadius:6, borderSkipped:false
        }]
      },
      options:{
        indexAxis:'y',
        responsive:true, maintainAspectRatio:false,
        scales:{
          x:{ beginAtZero:true, max:100, grid:{ color:'#f1f5f9' }, ticks:{ font:{size:11,family:'Inter'}, color:'#64748b', callback:v=>v+'%' } },
          y:{ grid:{ display:false }, ticks:{ font:{size:11,family:'Inter'}, color:'#64748b' } }
        },
        plugins:{
          legend:{ display:false },
          tooltip:{ callbacks:{ label:c=>` ${c.raw}% completion` } }
        },
        animation:{ duration:600 }
      }
    });
  },

  // SVG progress ring helper (used for manager cards)
  progressRing(pct, size=56, stroke=5, color='#2563eb') {
    const r   = (size-stroke*2)/2;
    const circ= 2*Math.PI*r;
    const off = circ - (pct/100)*circ;
    return `<svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
      <circle cx="${size/2}" cy="${size/2}" r="${r}" fill="none" stroke="#f1f5f9" stroke-width="${stroke}"/>
      <circle cx="${size/2}" cy="${size/2}" r="${r}" fill="none" stroke="${color}" stroke-width="${stroke}"
        stroke-dasharray="${circ}" stroke-dashoffset="${off}"
        stroke-linecap="round" transform="rotate(-90 ${size/2} ${size/2})"/>
    </svg>`;
  }
};
