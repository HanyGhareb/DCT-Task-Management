/* ================================================================
   utils.js — Date/week utilities, formatting helpers
   ================================================================ */
'use strict';

const Utils = {
  // ISO week number (week starts Monday)
  getISOWeek(date) {
    const d    = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    const day  = d.getUTCDay() || 7;
    d.setUTCDate(d.getUTCDate() + 4 - day);
    const yr   = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    return Math.ceil((((d - yr) / 86400000) + 1) / 7);
  },

  // Start (Mon) and end (Sun) dates for a given ISO week
  getWeekDates(weekNum, year) {
    const jan4    = new Date(Date.UTC(year, 0, 4));
    const jan4Day = jan4.getUTCDay() || 7;
    const start   = new Date(jan4);
    start.setUTCDate(jan4.getUTCDate() - jan4Day + 1 + (weekNum - 1) * 7);
    const end = new Date(start);
    end.setUTCDate(start.getUTCDate() + 6);
    return {
      start: start.toISOString().slice(0, 10),
      end:   end.toISOString().slice(0, 10)
    };
  },

  getWeekLabel(weekNum, year) {
    const { start, end } = this.getWeekDates(weekNum, year);
    const s = this.parseDate(start);
    const e = this.parseDate(end);
    const mo = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const sm = mo[s.getUTCMonth()];
    const em = mo[e.getUTCMonth()];
    const same = s.getUTCMonth() === e.getUTCMonth();
    return same
      ? `Week ${weekNum}: ${sm} ${s.getUTCDate()} – ${e.getUTCDate()}, ${year}`
      : `Week ${weekNum}: ${sm} ${s.getUTCDate()} – ${em} ${e.getUTCDate()}, ${year}`;
  },

  getWeekShort(weekNum, year) {
    const { start } = this.getWeekDates(weekNum, year);
    const d  = this.parseDate(start);
    const mo = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return `${mo[d.getUTCMonth()]} ${d.getUTCDate()}`;
  },

  parseDate(str) { return new Date(str + 'T00:00:00Z'); },

  formatDate(str, format = 'MMM D, YYYY') {
    if (!str) return '—';
    const d   = this.parseDate(str);
    const mo  = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const mos = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    const dys = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
    return format
      .replace('MMMM', mos[d.getUTCMonth()])
      .replace('MMM',  mo[d.getUTCMonth()])
      .replace('MM',   String(d.getUTCMonth()+1).padStart(2,'0'))
      .replace('DD',   String(d.getUTCDate()).padStart(2,'0'))
      .replace('D',    d.getUTCDate())
      .replace('YYYY', d.getUTCFullYear())
      .replace('dddd', dys[d.getUTCDay()]);
  },

  today() {
    return new Date().toISOString().slice(0, 10);
  },

  currentWeek()   { return this.getISOWeek(new Date()); },
  currentYear()   { return new Date().getFullYear(); },

  isCurrentWeek(w, y) {
    return w === this.currentWeek() && y === this.currentYear();
  },

  // UAE work week ends Thursday (gov) or Friday
  isLastWorkday() {
    const day = new Date().getDay(); // 0=Sun … 6=Sat
    return day === 4 || day === 5;   // Thu or Fri
  },

  formatFileSize(bytes) {
    if (!bytes) return '0 B';
    const units = ['B','KB','MB','GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return `${(bytes / 1024**i).toFixed(1)} ${units[i]}`;
  },

  getFileIcon(type = '') {
    if (type.startsWith('image/'))               return { icon: 'fa-file-image',       color: '#8b5cf6' };
    if (type === 'application/pdf')              return { icon: 'fa-file-pdf',         color: '#dc2626' };
    if (type.match(/word|document/))             return { icon: 'fa-file-word',        color: '#2563eb' };
    if (type.match(/excel|sheet|csv/))           return { icon: 'fa-file-excel',       color: '#059669' };
    if (type.match(/powerpoint|presentation/))   return { icon: 'fa-file-powerpoint',  color: '#d97706' };
    if (type.match(/zip|rar|7z|compressed/))     return { icon: 'fa-file-archive',     color: '#64748b' };
    if (type.startsWith('text/'))                return { icon: 'fa-file-alt',         color: '#2563eb' };
    return { icon: 'fa-file', color: '#64748b' };
  },

  progressColor(pct) {
    if (pct >= 80) return 'success';
    if (pct >= 50) return 'info';
    if (pct >= 25) return 'warning';
    return 'danger';
  },

  completionRateColor(rate) {
    if (rate >= 80) return '#059669';
    if (rate >= 50) return '#2563eb';
    if (rate >= 25) return '#d97706';
    return '#dc2626';
  },

  escHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
  },

  debounce(fn, ms = 250) {
    let t;
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), ms); };
  },

  uid() { return '_' + Math.random().toString(36).substr(2,9); },

  // Gradient avatar SVG data-URI — looks like a profile photo placeholder
  avatarDataUri(user, size = 48) {
    const gradient = user.gradient || `linear-gradient(135deg,${user.color},${user.color}cc)`;
    // Parse gradient colors for SVG
    const m = gradient.match(/#[0-9a-f]{6}/gi) || [user.color, user.color];
    const c1 = m[0] || '#1e3a5f', c2 = m[1] || c1;
    const initials = user.initials || '?';
    const fs = initials.length > 2 ? Math.round(size * 0.28) : Math.round(size * 0.36);
    const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
      <defs>
        <linearGradient id="ag" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stop-color="${c1}"/>
          <stop offset="100%" stop-color="${c2}"/>
        </linearGradient>
        <clipPath id="cc"><circle cx="${size/2}" cy="${size/2}" r="${size/2}"/></clipPath>
      </defs>
      <circle cx="${size/2}" cy="${size/2}" r="${size/2}" fill="url(#ag)"/>
      <circle cx="${size/2}" cy="${size/2}" r="${size/2 - 1.5}" fill="none" stroke="rgba(255,255,255,0.25)" stroke-width="1.5"/>
      <text x="50%" y="50%" dy=".36em" text-anchor="middle"
        font-family="Inter,Arial,sans-serif" font-size="${fs}" font-weight="700"
        letter-spacing="0.5" fill="white" clip-path="url(#cc)">${escSvg(initials)}</text>
    </svg>`;
    return 'data:image/svg+xml,' + encodeURIComponent(svg);
  },

  // Renders an <img> tag that looks like a profile photo
  avatarImg(user, size = 40, cssClass = 'nav-avatar') {
    const src = this.avatarDataUri(user, size * 2); // 2× for retina
    return `<img src="${src}" width="${size}" height="${size}" alt="${this.escHtml(user.name)}" class="${cssClass}" style="border-radius:50%;object-fit:cover">`;
  }
};

function escSvg(str) {
  return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
