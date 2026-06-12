/**
 * userService.js — Users CRUD (ORDS live mode only)
 *
 * All methods return Promises.
 * ORDS endpoints: /dct/users/
 */
define(['services/api'], function (api) {
  'use strict';

  function norm(u) {
    u.roles = (u.rolesCsv || '').split(',').filter(Boolean);
    /* Display names (e.g. "Section Manager") — fall back to codes so the
       list never regresses if roleNamesCsv is absent */
    u.roleNames = (u.roleNamesCsv || u.rolesCsv || '').split(',').filter(Boolean);
    return u;
  }

  return {

    getAll: function () {
      return api.get('/users/?limit=200').then(function (r) { return r.items.map(norm); });
    },

    /**
     * Phase 3 server-side pagination.
     * opts: { limit, offset, search, status ('Y'|'N'|null) }
     * Resolves { items, total, limit, offset } (items normalised).
     */
    getPage: function (opts) {
      opts = opts || {};
      var q = '?limit=' + (opts.limit || 50) + '&offset=' + (opts.offset || 0);
      if (opts.search) q += '&search=' + encodeURIComponent(opts.search);
      if (opts.status) q += '&status=' + encodeURIComponent(opts.status);
      return api.get('/users/' + q, { silent: opts.silent }).then(function (r) {
        r.items = (r.items || []).map(norm);
        return r;
      });
    },

    getById: function (id) {
      return api.get('/users/' + id).then(norm);
    },

    search: function (term) {
      if (!term) return this.getAll();
      return api.get('/users/?q=' + encodeURIComponent(term)).then(function (r) { return r.items.map(norm); });
    },

    create: function (data) {
      return api.post('/users/', data);
    },

    update: function (id, data) {
      return api.put('/users/' + id, data);
    },

    /**
     * Upload a profile photo. Downscales via canvas so the base64 payload
     * stays under the ORDS 32k VARCHAR2 bind limit, then PUTs
     * { photo_data_b64, mime_type } to /users/:id/photo (HR photo pattern).
     * Resolves { photoUrl }.
     */
    uploadPhoto: function (id, file) {
      var MAX_B64 = 30000;
      return new Promise(function (resolve, reject) {
        if (!file || !/^image\//.test(file.type)) {
          reject({ message: 'Please choose an image file' });
          return;
        }
        var url = URL.createObjectURL(file);
        var img = new Image();
        img.onload = function () {
          URL.revokeObjectURL(url);
          var side = 512;
          var quality = 0.85;
          var b64 = null;
          while (side >= 96) {
            var scale  = Math.min(1, side / Math.max(img.width, img.height));
            var canvas = document.createElement('canvas');
            canvas.width  = Math.max(1, Math.round(img.width  * scale));
            canvas.height = Math.max(1, Math.round(img.height * scale));
            canvas.getContext('2d').drawImage(img, 0, 0, canvas.width, canvas.height);
            b64 = canvas.toDataURL('image/jpeg', quality).split(',')[1];
            if (b64.length <= MAX_B64) break;
            if (quality > 0.6) { quality -= 0.1; } else { side -= 96; quality = 0.85; }
          }
          if (!b64 || b64.length > MAX_B64) {
            reject({ message: 'Could not compress the image enough — try a smaller photo' });
            return;
          }
          api.put('/users/' + id + '/photo', { photo_data_b64: b64, mime_type: 'image/jpeg' })
            .then(function (r) { resolve({ photoUrl: (r && r.photoUrl) || ('/ords/admin/dct/users/' + id + '/photo') }); })
            .catch(reject);
        };
        img.onerror = function () {
          URL.revokeObjectURL(url);
          reject({ message: 'Could not read the image file' });
        };
        img.src = url;
      });
    },

    remove: function (id) {
      return api.delete('/users/' + id);
    },

    getOrgOptions: function () {
      return api.get('/orgs/').then(function (r) {
        return r.items.map(function (o) { return { value: o.orgId, label: o.nameEn }; });
      });
    },

    getRoleOptions: function () {
      return api.get('/roles/').then(function (r) {
        return (r.items || [])
          .filter(function (role) { return role.isActive === 'Y'; })
          .map(function (role) { return { value: role.roleCode, label: role.roleName }; });
      });
    },

    reset: function () {}, // no-op in ORDS mode
  };
});
