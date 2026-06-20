define(['knockout', 'services/tmService', 'shared/i18n'],
function (ko, tm, i18n) {
  'use strict';
  function d(s) { return s ? new Date(s + 'T00:00:00') : null; }
  return function Timeline() {
    var self = this;
    self.t = i18n.t;
    var st = (window._jetApp && window._jetApp.getState()) || {};
    self.teamId = st.teamId;
    self.teamName = ko.observable('');
    self.loading = ko.observable(true);
    self.rows = ko.observableArray([]);
    self.months = ko.observableArray([]);   // axis labels

    self.back = function () { window._jetApp.navigate('teamDetail', { teamId: self.teamId }); };

    function build(tasks, milestones, deliverables) {
      var items = [];
      (tasks || []).forEach(function (x) {
        if (x.startDate || x.dueDate) items.push({ kind: 'task', label: x.title, status: x.status,
          start: d(x.startDate) || d(x.dueDate), end: d(x.dueDate) || d(x.startDate), point: false }); });
      (deliverables || []).forEach(function (x) {
        if (x.dueDate) items.push({ kind: 'deliverable', label: x.titleEn, status: x.status,
          start: d(x.dueDate), end: d(x.dueDate), point: true }); });
      (milestones || []).forEach(function (x) {
        if (x.dueDate) items.push({ kind: 'milestone', label: x.titleEn, status: x.status,
          start: d(x.dueDate), end: d(x.dueDate), point: true }); });
      if (!items.length) { self.rows([]); self.months([]); return; }

      var min = items[0].start, max = items[0].end;
      items.forEach(function (i) { if (i.start < min) min = i.start; if (i.end > max) max = i.end; });
      // pad to month boundaries
      min = new Date(min.getFullYear(), min.getMonth(), 1);
      max = new Date(max.getFullYear(), max.getMonth() + 1, 0);
      var span = Math.max(1, (max - min));

      // month axis
      var mo = [], cur = new Date(min);
      while (cur <= max) {
        var next = new Date(cur.getFullYear(), cur.getMonth() + 1, 1);
        mo.push({ label: cur.toLocaleString('en', { month: 'short' }) + " '" + String(cur.getFullYear()).slice(2),
                  w: ((Math.min(next, max) - cur) / span * 100) });
        cur = next;
      }
      self.months(mo);

      self.rows(items.map(function (i) {
        var left = (i.start - min) / span * 100;
        var width = Math.max(i.point ? 0 : 1.5, (i.end - i.start) / span * 100);
        return { label: i.label, kind: i.kind, status: i.status, point: i.point,
                 barStyle: 'left:' + left + '%;width:' + width + '%' };
      }));
    }

    self.barClass = function (r) {
      if (r.kind === 'milestone') return 'gantt-bar gantt-bar--ms';
      if (r.kind === 'deliverable') return 'gantt-bar gantt-bar--dl';
      return 'gantt-bar gantt-bar--task tstat--' + (r.status || '');
    };

    if (!self.teamId) { self.loading(false); return; }
    tm.getTeam(self.teamId).then(function (t) { self.teamName(t.nameEn); }).catch(function () {});
    Promise.all([
      tm.listTasks({ teamId: self.teamId, limit: 200 }).then(function (r) { return r.items || []; }).catch(function () { return []; }),
      tm.listMilestones(self.teamId).then(function (r) { return r.items || []; }).catch(function () { return []; }),
      tm.listDeliverables(self.teamId).then(function (r) { return r.items || []; }).catch(function () { return []; })
    ]).then(function (res) { build(res[0], res[1], res[2]); self.loading(false); });
  };
});
