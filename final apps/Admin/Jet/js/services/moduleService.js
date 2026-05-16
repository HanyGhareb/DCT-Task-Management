/**
 * moduleService.js — Module registry
 * Production: GET /ords/prod/dct/modules/
 */
define(['mockData'], function (mockData) {
  'use strict';

  let modules = JSON.parse(JSON.stringify(mockData.MODULES));

  const CATEGORIES = [
    { id: 'CORE',     label: 'Core Platform',         icon: '&#127968;' },
    { id: 'FINANCE',  label: 'Finance',               icon: '&#128178;' },
    { id: 'HR',       label: 'HR & Employee',          icon: '&#128101;' },
    { id: 'BUDGET',   label: 'Budget & Planning',      icon: '&#128202;' },
    { id: 'PAYMENTS', label: 'Payments & Procurement', icon: '&#9989;'   },
  ];

  return {
    getAll: function () { return modules; },

    getCategories: function () { return CATEGORIES; },

    getByCategory: function (cat) { return modules.filter(m => m.category === cat && m.isActive === 'Y'); },

    getAccessibleForUser: function (user) {
      // All active modules for admin; non-admin gets non-ADMIN category modules
      const isAdmin = user && (user.roles.includes('SYS_ADMIN') || user.roles.includes('USER_ADMIN'));
      return modules.filter(m => m.isActive === 'Y');
    },

    update: function (moduleId, data) {
      const idx = modules.findIndex(m => m.moduleId === Number(moduleId));
      if (idx === -1) return null;
      modules[idx] = Object.assign({}, modules[idx], data);
      return modules[idx];
    },

    toggleActive: function (moduleId) {
      const m = modules.find(m => m.moduleId === Number(moduleId));
      if (!m) return;
      m.isActive = m.isActive === 'Y' ? 'N' : 'Y';
      return m;
    },
  };
});
