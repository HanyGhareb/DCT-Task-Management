/* ── shared/js/editDrawer.js ─────────────────────────────────────────────────
   <edit-drawer> — APEX-style right-edge slide-in record editor (Knockout
   custom component). The host view supplies the field markup as child nodes;
   those nodes are rendered via $componentTemplateNodes and REBOUND to the host
   ViewModel (params.vm), so the body keeps binding to the view's own
   observables (eName, types, t(...), …) while the drawer chrome below binds to
   the component VM. The .ed-* structural styles live in shared/css/platform.css.

   Register once at app boot by adding 'shared/editDrawer' to the app's
   js/main.js require([...]) array.

   Usage in a view:

     <edit-drawer params="open: showEdit, vm: $vm,
                          title: t('tm.detail.editTeam'),
                          saveLabel: t('tm.action.saveChanges'),
                          cancelLabel: t('tm.action.cancel'),
                          onSave: saveTeam, width: '640px'">
       <div class="form-grid"> …your existing form-groups… </div>
     </edit-drawer>

   Params:
     open        ko.observable(bool)  required — two-way; set false on close
     vm          object               required — host ViewModel for body bindings (pass $vm)
     onSave      function             required — invoked by the Save button
     title       string|observable    required — header title
     subtitle    string|observable    optional — html, e.g. record key
     dirty       ko.observable(bool)  optional — shows the pulsing unsaved dot
     onClose     function             optional — return false to veto close
     saveLabel   string|observable    optional — default 'Save'
     cancelLabel string|observable    optional — default 'Cancel'
     width       string               optional — default '560px'; any CSS width
                                       (e.g. '720px', '60vw') or 'auto' to size to
                                       content. Bounded by min/max in platform.css. */
define(['knockout'], function (ko) {
  'use strict';

  if (!ko.components.isRegistered('edit-drawer')) {

    function DrawerVM(params) {
      var self = this;
      self.open        = params.open;                 // ko.observable(bool), two-way
      self.vm          = params.vm || {};             // host ViewModel for body bindings
      self.title       = params.title || '';
      self.subtitle    = params.subtitle || null;     // optional (html)
      self.dirtyFlag   = params.dirty || null;        // optional ko.observable(bool)
      self.saveLabel   = params.saveLabel   || 'Save';
      self.cancelLabel = params.cancelLabel || 'Cancel';
      self.width       = params.width || '560px';

      self.save = function () {
        if (typeof params.onSave === 'function') params.onSave();
      };
      self.close = function () {
        if (typeof params.onClose === 'function' && params.onClose() === false) return;
        if (ko.isObservable(self.open)) self.open(false);
      };

      function onKey(e) {
        if (e.key === 'Escape' && ko.unwrap(self.open)) self.close();
      }
      document.addEventListener('keydown', onKey);
      self.dispose = function () { document.removeEventListener('keydown', onKey); };
    }

    ko.components.register('edit-drawer', {
      viewModel: { createViewModel: function (params) { return new DrawerVM(params); } },
      template:
        '<div class="ed-scrim" data-bind="css:{ \'ed-show\': open }, click: close"></div>' +
        '<aside class="ed-drawer" role="dialog" aria-modal="true" ' +
               'data-bind="css:{ \'ed-show\': open }, style:{ width: width }">' +
          '<header class="ed-drawer__header">' +
            '<div>' +
              '<!-- ko if: subtitle -->' +
                '<div class="ed-drawer__eyebrow" data-bind="html: subtitle"></div>' +
              '<!-- /ko -->' +
              '<div class="ed-drawer__title">' +
                '<span data-bind="text: title"></span>' +
                '<span class="ed-dirty" data-bind="css:{ on: dirtyFlag }"></span>' +
              '</div>' +
            '</div>' +
            '<div class="region-actions">' +
              '<button class="btn btn-sm" data-bind="click: close, text: cancelLabel"></button>' +
              '<button class="btn btn-sm btn-primary" data-bind="click: save, text: saveLabel"></button>' +
            '</div>' +
          '</header>' +
          '<div class="ed-drawer__body" ' +
               'data-bind="template:{ nodes: $componentTemplateNodes, data: vm }"></div>' +
        '</aside>'
    });
  }

  return { registered: true };
});
