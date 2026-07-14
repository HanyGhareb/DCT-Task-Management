/**
 * lovInput.js — <lov-input> : a searchable, type-ahead LOV field.
 *
 *   <lov-input params="options: buProjects, value: projectNumber,
 *                      valueField: 'projectNumber', textField: 'label',
 *                      placeholder: 'Search project…', enable: editable,
 *                      onSearch: searchProjects"></lov-input>
 *
 * Renders a plain <input> backed by a native <datalist>, so the user can TYPE to
 * filter a long list (300 projects, 200 GL combinations) instead of scrolling a
 * <select>. The typed text is matched back to an option and the bound `value`
 * observable always holds the option's CODE — never the display text.
 *
 * params
 *   options      array/observableArray of option objects
 *   value        observable holding the selected code (null when nothing matches)
 *   valueField   option key holding the code            (default 'code')
 *   textField    option key holding the display text    (default 'label')
 *   placeholder  input placeholder
 *   enable       observable/boolean — false renders the input read-only
 *   onSearch     optional fn(term) for server-side search; called (debounced)
 *                as the user types so the parent can refresh `options`
 *
 * Matching order: exact display text (what a datalist pick produces) → exact
 * code → a single case-insensitive substring hit. Anything else leaves `value`
 * null and marks the field, so a half-typed entry can never be saved as a code.
 */
define(['knockout'], function (ko) {
  'use strict';

  var seq = 0;

  function LovInputVM(params) {
    var self = this;
    var vf = params.valueField || 'code';
    var tf = params.textField  || 'label';

    self.listId      = 'lov-' + (++seq);
    self.placeholder = params.placeholder || 'Type to search…';
    self.enable      = params.enable === undefined ? true : params.enable;
    self.options     = params.options;
    self.text        = ko.observable('');
    self.unmatched   = ko.observable(false);

    function opts() { return ko.unwrap(self.options) || []; }
    function textOf(code) {
      var hit = opts().filter(function (o) { return o[vf] === code; })[0];
      return hit ? String(hit[tf]) : '';
    }
    self.optionText = function (o) { return String(o[tf]); };

    // value (code) → input text. Runs on load, on an external set, and whenever
    // the options arrive late (async LOV fetch).
    var syncing = false;
    var typing  = false;     // guard: an onSearch refresh of `options` must not
                             // overwrite the text the user is still typing
    var settling = false;    // guard: our own write to `value` must not bounce
                             // back through the value subscription and wipe the
                             // text (or the "no match" state) we just set
    function syncText() {
      if (settling) return;
      var code = ko.unwrap(params.value);
      syncing = true;
      self.text(code ? (textOf(code) || String(code)) : '');
      self.unmatched(false);
      syncing = false;
    }
    function setValue(v) {
      settling = true;
      try { params.value(v); } finally { settling = false; }
    }
    syncText();
    if (ko.isObservable(params.value)) params.value.subscribe(syncText);
    if (ko.isObservable(self.options)) {
      self.options.subscribe(function () {
        if (typing) return;              // don't overwrite text mid-typing
        // Options just arrived — from the server search resolve() fired when it
        // couldn't match locally. Retry against them before giving up.
        if (self.unmatched()) { match(false); return; }
        syncText();
      });
    }

    var searchTimer = null;
    self.onInput = function () {
      typing = true;
      if (typeof params.onSearch === 'function') {
        clearTimeout(searchTimer);
        var term = self.text();
        searchTimer = setTimeout(function () { params.onSearch(term); }, 300);
      }
      return true;                       // let the input keep its keystroke
    };

    // Match the typed text against the options and write back the code.
    // allowSearch: when nothing matches locally, ask the parent to search the
    // server (the list may be capped) — the options subscription retries.
    function match(allowSearch) {
      var typed = (self.text() || '').trim();
      if (!typed) { self.unmatched(false); setValue(null); return; }

      var list = opts(), lo = typed.toLowerCase();
      var hit = list.filter(function (o) { return String(o[tf]) === typed; })[0]
             || list.filter(function (o) { return String(o[vf]) === typed; })[0];
      if (!hit) {
        var subs = list.filter(function (o) {
          return String(o[tf]).toLowerCase().indexOf(lo) >= 0 ||
                 String(o[vf]).toLowerCase().indexOf(lo) >= 0;
        });
        if (subs.length === 1) hit = subs[0];
      }
      if (hit) {
        self.unmatched(false);
        setValue(hit[vf]);
        syncing = true; self.text(String(hit[tf])); syncing = false;
        return;
      }
      self.unmatched(true);              // keep what they typed; value stays null
      setValue(null);
      if (allowSearch && typeof params.onSearch === 'function') params.onSearch(typed);
    }

    self.resolve = function () {
      if (syncing) return true;
      typing = false;
      clearTimeout(searchTimer);         // a pending search must not fire after we settle
      match(true);
      return true;
    };
  }

  if (!ko.components.isRegistered('lov-input')) {
    ko.components.register('lov-input', {
      viewModel: LovInputVM,
      template:
        '<input class="form-control lov-input" type="text" autocomplete="off"' +
        '       data-bind="attr: { list: listId, placeholder: placeholder },' +
        '                  value: text, valueUpdate: \'input\', enable: enable,' +
        '                  event: { input: onInput, change: resolve, blur: resolve },' +
        '                  css: { \'lov-input--unmatched\': unmatched }">' +
        '<datalist data-bind="attr: { id: listId }">' +
        '  <!-- ko foreach: options -->' +
        '  <option data-bind="attr: { value: $parent.optionText($data) }"></option>' +
        '  <!-- /ko -->' +
        '</datalist>' +
        '<!-- ko if: unmatched -->' +
        '<div class="form-hint lov-input__miss">No match — pick a value from the list.</div>' +
        '<!-- /ko -->'
    });
  }

  return {};
});
