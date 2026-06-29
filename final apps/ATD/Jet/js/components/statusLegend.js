// <status-legend> — shared, professionally-grouped legend for the status pills.
// Used at the bottom of Jobs / Run Logs / Queue. Single source of truth for the
// status copy (atd.legend.<CODE>) so the three pages never drift.
define(['knockout', 'shared/i18n'], function (ko, i18n) {
  'use strict';

  // two semantic groups, matching the two columns users actually see:
  //   • Queue status  → the STATUS column (where the job is in the run queue)
  //   • Run result    → the LAST RUN / Run Logs status (how the run ended)
  var GROUPS = [
    { titleKey: 'atd.legend.group.queue',  codes: ['READY', 'CLAIMED', 'DONE', 'FAILED'] },
    { titleKey: 'atd.legend.group.result', codes: ['RUNNING', 'SUCCESS', 'HELD', 'REQUEUED', 'WARNING'] }
  ];

  ko.components.register('status-legend', {
    viewModel: function () {
      this.t = i18n.t;
      this.groups = GROUPS;
      this.open = ko.observable(false);   // collapsed by default — keep the page tidy
      this.toggle = function () { this.open(!this.open()); }.bind(this);
      this.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    },
    template:
      '<section class="status-legend" data-bind="css: { \'status-legend--open\': open }">' +
        '<header class="status-legend__head" data-bind="click: toggle" ' +
                'role="button" tabindex="0" title="Status legend">' +
          '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" ' +
               'stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' +
            '<circle cx="12" cy="12" r="10"></circle><path d="M12 16v-4"></path>' +
            '<path d="M12 8h.01"></path></svg>' +
          '<span data-bind="text: t(\'atd.legend.title\')"></span>' +
          '<span class="status-legend__chev" aria-hidden="true">&#9656;</span>' +
        '</header>' +
        '<div class="status-legend__cols" data-bind="visible: open">' +
          '<!-- ko foreach: groups -->' +
          '<div class="status-legend__col">' +
            '<div class="status-legend__group" data-bind="text: $component.t($data.titleKey)"></div>' +
            '<!-- ko foreach: codes -->' +
            '<div class="status-legend__row">' +
              '<span data-bind="css: $component.statusClass($data), text: $data"></span>' +
              '<span class="status-legend__desc" data-bind="text: $component.t(\'atd.legend.\' + $data)"></span>' +
            '</div>' +
            '<!-- /ko -->' +
          '</div>' +
          '<!-- /ko -->' +
        '</div>' +
      '</section>'
  });

  return true;
});
