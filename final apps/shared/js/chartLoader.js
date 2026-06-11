/**
 * shared/js/chartLoader.js — Chart.js glue for all dashboards (Phase 3).
 *
 * Chart.js MUST be loaded through RequireJS (paths: { chartjs: <CDN umd> })
 * — a plain <script> tag throws "Mismatched anonymous define" because the
 * UMD calls define() while RequireJS is present.
 *
 *   define(['shared/chartLoader'], function (charts) {
 *     charts.makeChart(canvasEl, { type:'bar', data:{...}, options:{...} });
 *   });
 *
 * makeChart():
 *  - merges theme-aware defaults (CSS-var palette, Outfit/Plex-Arabic font,
 *    RTL legend+tooltip when lang=ar, Latin digits via en-AE locale)
 *  - registers a KO dispose callback that destroys the chart when the custom
 *    `module` binding cleans the route's DOM — prevents leaked canvases.
 */
define(['chartjs', 'knockout', 'shared/i18n'], function (Chart, ko, i18n) {
  'use strict';

  function cssVar(name) {
    return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
  }
  function alpha(hex, a) {
    var h = hex.replace('#', '');
    if (h.length === 3) h = h.replace(/./g, '$&$&');
    var n = parseInt(h, 16);
    return 'rgba(' + (n >> 16 & 255) + ',' + (n >> 8 & 255) + ',' + (n & 255) + ',' + a + ')';
  }

  /** Theme palette read live from the CSS custom properties. */
  function palette() {
    return {
      brand:  cssVar('--brand')  || '#C74634',
      amber:  cssVar('--amber')  || '#F0883E',
      green:  cssVar('--green')  || '#2DA44E',
      red:    cssVar('--red')    || '#D1242F',
      blue:   cssVar('--blue')   || '#0969DA',
      text2:  cssVar('--text-2') || '#5B6573',
      text3:  cssVar('--text-3') || '#8A93A2',
      border: cssVar('--border') || '#E3E6EB',
      alpha:  alpha
    };
  }

  function baseOptions() {
    var rtl = i18n.lang() === 'ar';
    Chart.defaults.font.family = rtl
      ? "'IBM Plex Sans Arabic', sans-serif"
      : "'Outfit', sans-serif";
    Chart.defaults.font.size   = 12;
    Chart.defaults.color       = palette().text2;
    Chart.defaults.borderColor = palette().border;
    return {
      responsive: true,
      maintainAspectRatio: false,
      locale: 'en-AE',                                /* Latin digits always */
      plugins: {
        legend:  { rtl: rtl, textDirection: rtl ? 'rtl' : 'ltr',
                   labels: { usePointStyle: true, boxHeight: 7 } },
        tooltip: { rtl: rtl, textDirection: rtl ? 'rtl' : 'ltr' }
      },
      animation: { duration: 550, easing: 'easeOutQuart' }
    };
  }

  function deepMerge(dst, src) {
    Object.keys(src || {}).forEach(function (k) {
      if (src[k] && typeof src[k] === 'object' && !Array.isArray(src[k]) &&
          dst[k] && typeof dst[k] === 'object' && !Array.isArray(dst[k])) {
        deepMerge(dst[k], src[k]);
      } else {
        dst[k] = src[k];
      }
    });
    return dst;
  }

  /** Create a chart bound to the canvas lifecycle (auto-destroy on route change). */
  function makeChart(canvas, cfg) {
    if (!canvas) return null;
    cfg.options = deepMerge(baseOptions(), cfg.options || {});
    var chart = new Chart(canvas.getContext('2d'), cfg);
    ko.utils.domNodeDisposal.addDisposeCallback(canvas, function () {
      try { chart.destroy(); } catch (e) {}
    });
    return chart;
  }

  return { makeChart: makeChart, palette: palette, alpha: alpha };
});
