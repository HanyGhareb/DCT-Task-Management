'use strict';

const CDN = 'https://static.oracle.com/cdn/jet/17.0.0';

requirejs.config({
  baseUrl: 'js',
  urlArgs: 'v=' + Date.now(), // cache-buster for dev
  paths: {
    'knockout':       CDN + '/3rdparty/knockout/knockout-3.5.1',
    'jquery':         CDN + '/3rdparty/jquery/jquery-3.7.1.min',
    'hammerjs':       CDN + '/3rdparty/hammerjs/hammer-2.0.8.min',
    'signals':        CDN + '/3rdparty/js-signals/signals.min',
    'text':           CDN + '/3rdparty/require/text',
    // Phase 3 — shared asset layer ('/shared' is served by dev-proxy from final apps/shared)
    'shared':         '/shared/js',
    // Chart.js MUST load via RequireJS (its UMD calls define(); a <script> tag breaks)
    'chartjs':        'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min',
  },
  shim: {
    'hammerjs': { exports: 'Hammer' }
  }
});

require(
  ['appController', 'knockout', 'shared/i18n', 'shared/skeleton', 'shared/pager', 'shared/auditInfo'],
  function (AppController, ko, i18n) {

  // Custom KO binding: swaps a view+viewModel pair into a container element.
  // IMPORTANT: clean only child nodes — cleaning `element` itself would remove
  // KO's own subscription that re-runs this update when moduleConfig changes.
  ko.bindingHandlers.module = {
    init: function () { return { controlsDescendantBindings: true }; },
    update: function (element, valueAccessor, allBindings, viewModel, bindingContext) {
      const config = ko.unwrap(valueAccessor());
      // Dispose KO bindings on existing children before replacing them
      while (element.firstChild) {
        ko.cleanNode(element.firstChild);
        element.removeChild(element.firstChild);
      }
      if (!config) return;
      element.innerHTML = config.view;
      // $vm = the view's own viewModel at ANY nesting depth (inherited by all
      // descendant contexts). $root is the AppController (shell: t/lang/nav);
      // views call their own methods via $vm.x — Phase 3 made $root the shell
      // controller, which silently broke legacy `$root.<vmMethod>` references.
      const childCtx = bindingContext.createChildContext(
        config.viewModel, null,
        function (ctx) { ctx.$vm = config.viewModel; });
      ko.applyBindingsToDescendants(childCtx, element);
    }
  };

  function init() {
    const app = new AppController();
    window._jetApp = {
      navigate: app.navigate.bind(app),
      onLogin:  app.onLogin.bind(app),
    };
    ko.applyBindings(app, document.getElementById('globalBody'));
  }

  function boot() {
    // Translations must be ready before the first route renders
    i18n.init().then(init, init);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
});
