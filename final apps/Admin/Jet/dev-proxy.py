#!/usr/bin/env python3
"""
dev-proxy.py — i-Finance local dev server
  - Serves static files from this directory (Admin/Jet)
  - Proxies /ords/ requests to ADB ORDS, adding CORS headers
    so the browser on localhost:8080 can call the live DB.

Usage:  python dev-proxy.py
        then open http://localhost:8080
"""
import http.server
import urllib.request
import urllib.error
import os
import sys
import time

ORDS_ORIGIN = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com'
PORT = 8080
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
APPS_ROOT  = os.path.normpath(os.path.join(SCRIPT_DIR, '..', '..'))   # 'final apps'
SHARED_DIR = os.path.join(APPS_ROOT, 'shared')
SIBLING_APPS = ('Admin', 'PC', 'DT', 'HR', 'FL', 'CC', 'AR')


class DevProxyHandler(http.server.SimpleHTTPRequestHandler):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=SCRIPT_DIR, **kwargs)

    # -- /shared/* -> 'final apps/shared'; /<App>/Jet/* -> sibling app folders
    #    (the top-bar module switcher uses root-absolute /PC/Jet/... URLs) --
    def translate_path(self, path):
        clean = path.split('?', 1)[0].split('#', 1)[0]
        if clean.startswith('/shared/'):
            parts = [p for p in clean[len('/shared/'):].split('/') if p and p != '..']
            return os.path.join(SHARED_DIR, *parts)
        seg = [p for p in clean.split('/') if p]
        if len(seg) >= 2 and seg[0] in SIBLING_APPS and seg[1] == 'Jet':
            parts = [p for p in seg if p != '..']
            return os.path.join(APPS_ROOT, *parts)
        return super().translate_path(path)
    # ── CORS headers added to every proxy response ──────────────────────
    def _cors(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.send_header('Access-Control-Max-Age', '86400')

    # ── Preflight (OPTIONS) ─────────────────────────────────────────────
    def do_OPTIONS(self):
        if self.path.startswith('/ords/'):
            self.send_response(200)
            self._cors()
            self.end_headers()
        else:
            self.send_response(405)
            self.end_headers()

    # ── HTTP verbs — proxy /ords/, serve static otherwise ───────────────
    def do_GET(self):
        if self.path.startswith('/ords/'):
            self._proxy('GET')
        else:
            super().do_GET()

    def do_POST(self):
        if self.path.startswith('/ords/'):
            self._proxy('POST')
        else:
            self.send_response(405)
            self.end_headers()

    def do_PUT(self):
        if self.path.startswith('/ords/'):
            self._proxy('PUT')
        else:
            self.send_response(405)
            self.end_headers()

    def do_DELETE(self):
        if self.path.startswith('/ords/'):
            self._proxy('DELETE')
        else:
            self.send_response(405)
            self.end_headers()

    # ── Core proxy logic ────────────────────────────────────────────────
    def _proxy(self, method):
        target = ORDS_ORIGIN + self.path

        # Read request body if present
        length = int(self.headers.get('Content-Length', 0) or 0)
        body = self.rfile.read(length) if length > 0 else None

        # Forward only safe headers
        fwd_headers = {}
        for h in ('Content-Type', 'Authorization', 'Accept'):
            v = self.headers.get(h)
            if v:
                fwd_headers[h] = v

        req = urllib.request.Request(target, data=body, headers=fwd_headers, method=method)
        try:
            # transient ADB hiccups (reset/timeout) surface as random 502s
            # mid-suite — retry idempotent GETs twice before giving up
            attempts = 3 if method == 'GET' else 1
            resp = None
            for i in range(attempts):
                try:
                    resp = urllib.request.urlopen(req, timeout=30)
                    break
                except urllib.error.HTTPError:
                    raise                      # real HTTP status — pass through
                except Exception:
                    if i == attempts - 1:
                        raise
                    time.sleep(0.5 * (i + 1))
            with resp:
                body_out = resp.read()
                self.send_response(resp.status)
                self._cors()
                ct = resp.headers.get('Content-Type', 'application/json')
                self.send_header('Content-Type', ct)
                self.send_header('Content-Length', str(len(body_out)))
                self.end_headers()
                self.wfile.write(body_out)

        except urllib.error.HTTPError as e:
            body_out = e.read()
            self.send_response(e.code)
            self._cors()
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body_out)))
            self.end_headers()
            self.wfile.write(body_out)

        except Exception as ex:
            msg = str(ex).encode()
            self.send_response(502)
            self._cors()
            self.send_header('Content-Type', 'text/plain')
            self.send_header('Content-Length', str(len(msg)))
            self.end_headers()
            self.wfile.write(msg)

    def log_message(self, fmt, *args):
        tag = '[PROXY]' if self.path.startswith('/ords/') else '[STATIC]'
        print(f"{tag} {self.address_string()} {fmt % args}")


if __name__ == '__main__':
    os.chdir(SCRIPT_DIR)
    print(f"Static files : {SCRIPT_DIR}")
    print(f"ORDS proxy   : {ORDS_ORIGIN}")
    print(f"Listening on : http://localhost:{PORT}")
    with http.server.ThreadingHTTPServer(('', PORT), DevProxyHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nStopped.")
