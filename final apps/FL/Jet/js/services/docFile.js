/**
 * docFile.js — view / download the bytes of a FL document.
 *
 * The file streams from the ORDS media handler GET /fl/documents/:id/file and
 * is fetched with the session Bearer token via api.fetchBlobUrl, so it works
 * behind the web tier (same-origin proxy). Never point a link at the ADB host
 * directly — that bypasses the proxy and sends no token.
 *
 * A document row carries bytes only when hasFile === 'Y' (fileSize > 0);
 * metadata-only rows must not offer View/Download.
 */
define(['services/api'], function (api) {
  'use strict';

  function idOf(doc) {
    if (doc === null || doc === undefined) return null;
    if (typeof doc === 'number' || typeof doc === 'string') return doc;
    return doc.documentId || doc.docId || null;
  }

  function nameOf(doc) {
    return (doc && (doc.documentName || doc.fileName)) || ('document-' + idOf(doc));
  }

  function hasFile(doc) {
    if (!doc) return false;
    if (doc.hasFile !== undefined && doc.hasFile !== null) return doc.hasFile === 'Y';
    return Number(doc.fileSize || 0) > 0;
  }

  function release(url) { setTimeout(function () { URL.revokeObjectURL(url); }, 60000); }

  // Only these render inline in a browser tab; anything else (Word, Excel, zip)
  // would leave the tab blank, so View just downloads it instead.
  function inlineViewable(doc) {
    var m = ((doc && doc.mimeType) || '').toLowerCase();
    if (!m) return true;                    // unknown -> let the browser decide
    return m.indexOf('pdf') >= 0 || m.indexOf('image/') === 0 ||
           m.indexOf('text/') === 0 || m.indexOf('html') >= 0;
  }

  /* Opens the file in a new tab. The tab is opened synchronously on the click —
     a window.open() issued later, inside the fetch's .then(), is swallowed by
     the pop-up blocker. */
  function view(doc) {
    var id = idOf(doc);
    if (!id) return Promise.resolve();
    if (!inlineViewable(doc)) return download(doc);
    var win = window.open('', '_blank');
    return api.fetchBlobUrl('/documents/' + id + '/file').then(function (url) {
      if (win) { win.location.href = url; } else { window.open(url, '_blank'); }
      release(url);
    }, function () {
      if (win) win.close();          // api.fetchBlobUrl already toasted the error
    });
  }

  function download(doc) {
    var id = idOf(doc);
    if (!id) return Promise.resolve();
    return api.fetchBlobUrl('/documents/' + id + '/file').then(function (url) {
      var a = document.createElement('a');
      a.href = url;
      a.download = nameOf(doc);
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      release(url);
    }, function () { /* toasted by api */ });
  }

  return { view: view, download: download, hasFile: hasFile };
});
