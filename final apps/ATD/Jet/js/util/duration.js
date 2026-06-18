/**
 * duration.js — format a run duration (in seconds) as adaptive-compact text.
 *   47       -> "47s"
 *   110      -> "1m 50s"
 *   4810     -> "1h 20m 10s"
 * Lower units are zero-padded once a higher unit is shown. Unit labels are i18n
 * (atd.dur.h/m/s — EN h/m/s, AR س/د/ث); digits stay Latin (JS number rendering).
 * Returns '' for a missing/blank/NaN value (jobs that never ran).
 */
define(['shared/i18n'], function (i18n) {
  'use strict';
  function pad(n) { return n < 10 ? '0' + n : '' + n; }
  return function fmtDuration(sec) {
    if (sec === null || sec === undefined || sec === '' || isNaN(sec)) return '';
    sec = Math.round(Number(sec));
    if (sec < 0) sec = 0;
    var h = Math.floor(sec / 3600),
        m = Math.floor((sec % 3600) / 60),
        s = sec % 60,
        t = i18n.t, H = t('atd.dur.h'), M = t('atd.dur.m'), S = t('atd.dur.s');
    if (h > 0) return h + H + ' ' + pad(m) + M + ' ' + pad(s) + S;
    if (m > 0) return m + M + ' ' + pad(s) + S;
    return s + S;
  };
});
