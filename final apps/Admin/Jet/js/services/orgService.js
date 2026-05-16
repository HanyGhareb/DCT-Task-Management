/**
 * orgService.js — Organisation hierarchy
 * Production: GET /ords/prod/dct/organizations/
 */
define(['mockData'], function (mockData) {
  'use strict';

  let orgs = JSON.parse(JSON.stringify(mockData.ORGS));

  function buildTree(parentId) {
    return orgs
      .filter(o => o.parentOrgId === parentId)
      .map(o => ({ ...o, children: buildTree(o.orgId) }));
  }

  return {
    getAll: function () { return orgs; },
    getTree: function () { return buildTree(null); },
    getById: function (id) { return orgs.find(o => o.orgId === Number(id)) || null; },
    getOptions: function () { return orgs.map(o => ({ value: o.orgId, label: o.nameEn })); },
  };
});
