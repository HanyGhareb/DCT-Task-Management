'use strict';

const CDN = 'https://static.oracle.com/cdn/jet/17.0.0';

requirejs.config({
  baseUrl: 'js',
  urlArgs: 'v=' + Date.now(),
  paths: {
    'knockout': CDN + '/3rdparty/knockout/knockout-3.5.1',
    'jquery':   CDN + '/3rdparty/jquery/jquery-3.7.1.min',
    'text':     CDN + '/3rdparty/require/text',
    // Phase 3 — shared asset layer ('/shared' is served by dev-proxy from final apps/shared)
    'shared':   '/shared/js',
    // Chart.js MUST load via RequireJS (its UMD calls define(); a <script> tag breaks)
    'chartjs':  'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min',
  }
});

require(
  ['appController', 'knockout', 'shared/i18n', 'shared/skeleton', 'shared/pager', 'shared/auditInfo'],
  function (AppController, ko, i18n) {

  // Custom KO binding: swaps a view+viewModel pair into the host container.
  // Only clean child nodes — cleaning `element` itself removes KO's own
  // subscription and breaks re-rendering on navigation.
  ko.bindingHandlers.module = {
    init: function () { return { controlsDescendantBindings: true }; },
    update: function (element, valueAccessor, allBindings, viewModel, bindingContext) {
      const config = ko.unwrap(valueAccessor());
      while (element.firstChild) {
        ko.cleanNode(element.firstChild);
        element.removeChild(element.firstChild);
      }
      if (!config) return;
      element.innerHTML = config.view;
      const childCtx = bindingContext.createChildContext(
        config.viewModel, null,
        function (ctx) { ctx.$vm = config.viewModel; });
      ko.applyBindingsToDescendants(childCtx, element);
    }
  };

  function init() {
    const app = new AppController();
    window._dtApp = {
      navigate: app.navigate.bind(app),
      onLogin:  app.onLogin.bind(app),
      getState: function () { return app._state; },
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
