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
  },
  shim: {
    'hammerjs': { exports: 'Hammer' }
  }
});

require(['appController', 'knockout'], function (AppController, ko) {

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
      const childCtx = bindingContext.createChildContext(config.viewModel);
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

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
});
