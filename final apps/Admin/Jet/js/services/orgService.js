/**
 * orgService.js — Organisation hierarchy
 * ORDS: GET /orgs/ — flat list of org nodes
 *
 * All methods return Promises.
 */
define(['services/api'], function (api) {
  'use strict';

  function buildTree(orgs, parentId) {
    return orgs
      .filter(function (o) { return o.parentOrgId === parentId; })
      .map(function (o) {
        return Object.assign({}, o, { children: buildTree(orgs, o.orgId) });
      });
  }

  return {

    getAll: function () {
      return api.get('/orgs/').then(function (r) {
        return (r.items || []).map(function (o) {
          /* APEX_JSON omits NULL keys — root nodes arrive WITHOUT parentOrgId,
             and undefined !== null broke buildTree (empty tree). Normalise. */
          if (o.parentOrgId === undefined) o.parentOrgId = null;
          return o;
        });
      });
    },

    create: function (data) {
      return api.post('/orgs/', data);
    },

    update: function (id, data) {
      return api.put('/orgs/' + id, data);
    },

    getTree: function () {
      return this.getAll().then(function (orgs) { return buildTree(orgs, null); });
    },

    getById: function (id) {
      return this.getAll().then(function (orgs) {
        return orgs.find(function (o) { return o.orgId === Number(id); }) || null;
      });
    },

    getOptions: function () {
      return this.getAll().then(function (orgs) {
        return orgs.map(function (o) { return { value: o.orgId, label: o.nameEn }; });
      });
    },
  };
});
