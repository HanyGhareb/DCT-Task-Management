'use strict';

const CDN = 'https://static.oracle.com/cdn/jet/17.0.0';

requirejs.config({
  baseUrl: 'js',
  urlArgs: 'v=' + Date.now(),
  paths: {
    'knockout': CDN + '/3rdparty/knockout/knockout-3.5.1',
    'jquery':   CDN + '/3rdparty/jquery/jquery-3.7.1.min',
    'text':     CDN + '/3rdparty/require/text',
  }
});

require(['appController', 'knockout'], function (AppController, ko) {

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
      const childCtx = bindingContext.createChildContext(config.viewModel);
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

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
});
