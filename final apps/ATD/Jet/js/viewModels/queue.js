define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'util/filterStore'],
function (ko, atd, i18n, toast, filterStore) {
  'use strict';
  return function Queue() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.jobs = ko.observableArray([]);
    self.lease = ko.observable(30);
    self.statuses = ['READY', 'CLAIMED', 'DONE', 'FAILED'];

    // filters (remembered across refresh)
    self.fSearch = ko.observable('');
    self.fStatus = ko.observable('');
    self.fCategory = ko.observable('');
    self.fSubCategory = ko.observable('');
    self.categories = ko.observableArray([]);

    // server pagination (envelope {items,total,limit,offset}); 20 rows/page
    self.offset = ko.observable(0);
    self.limit = ko.observable(20);
    self.total = ko.observable(0);

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    self.catLabel = function (c) {
      var ar = (i18n.lang && i18n.lang() === 'ar');
      return (ar ? (c.nameAr || c.name) : (c.nameEn || c.name)) || c.code;
    };
    self.activeCategories = ko.computed(function () {
      return self.categories().filter(function (c) { return c.active === 'Y'; });
    });
    self.topCategories = ko.computed(function () {
      return self.activeCategories().filter(function (c) { return !c.parentCode; });
    });
    self.subCategories = ko.computed(function () {
      var p = self.fCategory();
      return p ? self.activeCategories().filter(function (c) { return c.parentCode === p; }) : [];
    });

    self.load = function () {
      self.loading(true);
      var cat = self.fSubCategory() || self.fCategory();
      atd.listJobs({ search: self.fSearch(), status: self.fStatus(), category: cat,
                     limit: self.limit(), offset: self.offset() })
        .then(function (r) {
          self.jobs(r.items || []);
          self.total(r.total || (r.items || []).length);
          self.loading(false);
        })
        .catch(function () { self.loading(false); });
    };
    self.reload = self.load;                     // pager onChange

    self.search = function () { self.offset(0); self.load(); };
    self.clearFilters = function () {
      self._resetSub = true;
      self.fSearch(''); self.fStatus(''); self.fCategory(''); self.fSubCategory('');
      self._resetSub = false;
      self._filterStore.clear(); self.offset(0); self.load();
    };

    // restore saved criteria BEFORE wiring reload subscriptions + the initial load
    self._filterStore = filterStore.bind('queue', {
      search: self.fSearch, status: self.fStatus, category: self.fCategory, sub: self.fSubCategory
    });
    self.fStatus.subscribe(function () { self.offset(0); self.load(); });
    self.fCategory.subscribe(function () {
      self._resetSub = true; self.fSubCategory(''); self._resetSub = false;
      self.offset(0); self.load();
    });
    self.fSubCategory.subscribe(function () { if (self._resetSub) return; self.offset(0); self.load(); });

    atd.listCategories().then(function (r) { self.categories((r && r.items) || []); }).catch(function () {});
    self.load();

    self.enqueueAll = function () {
      atd.enqueueAll().then(function (r) {
        toast.success((r.queued || 0) + ' ' + self.t('atd.queue.enqueued')); self.load();
      }).catch(function () {});
    };
    self.reap = function () {
      atd.reap(Number(self.lease())).then(function (r) {
        toast.success((r.reaped || 0) + ' ' + self.t('atd.queue.reaped')); self.load();
      }).catch(function () {});
    };
    self.enqueueOne = function (row) {
      atd.enqueueJob(row.jobName).then(function () { toast.success(self.t('atd.jobs.enqueued')); self.load(); }).catch(function () {});
    };
  };
});
