'use strict';

const CDN = 'https://static.oracle.com/cdn/jet/17.0.0';

requirejs.config({
  baseUrl: 'js',
  // localhost: bust on every load (dev). Deployed: cache by APP_VERSION
  // (set in index.html, bumped per deploy) so the ~40-file boot hits cache.
  urlArgs: 'v=' + ((!window.APP_VERSION || /^(localhost|127\.0\.0\.1)$/.test(location.hostname))
                   ? Date.now() : window.APP_VERSION),
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

  // Wave 2 (a11y): modal behavior in one binding — focus moves into the
  // dialog on open, Tab cycles inside it, Escape calls the close handler.
  //   <div class="modal-box" data-bind="modalTrap: closeModal">
  ko.bindingHandlers.modalTrap = {
    init: function (element, valueAccessor) {
      const close = valueAccessor();
      element.setAttribute('role', 'dialog');
      element.setAttribute('aria-modal', 'true');
      if (element.tabIndex < 0) element.tabIndex = -1;
      const SEL = 'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])';
      function focusables() {
        return Array.prototype.filter.call(element.querySelectorAll(SEL), function (el) {
          return !el.disabled && el.offsetParent !== null;
        });
      }
      const restoreTo = document.activeElement;
      setTimeout(function () {
        const f = focusables();
        (f.length ? f[0] : element).focus();
      }, 0);
      function onKey(e) {
        if (e.key === 'Escape' && typeof close === 'function') {
          e.stopPropagation();
          close();
        } else if (e.key === 'Tab') {
          const f = focusables();
          if (!f.length) return;
          const first = f[0], last = f[f.length - 1];
          if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
          else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
        }
      }
      element.addEventListener('keydown', onKey);
      ko.utils.domNodeDisposal.addDisposeCallback(element, function () {
        element.removeEventListener('keydown', onKey);
        if (restoreTo && document.contains(restoreTo)) {
          try { restoreTo.focus(); } catch (e) {}
        }
      });
    }
  };

  function init() {
    const app = new AppController();
    window._jetApp = {
      navigate: app.navigate.bind(app),
      onLogin:  app.onLogin.bind(app),
      route:    function () { return app.currentNavItem(); },
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
