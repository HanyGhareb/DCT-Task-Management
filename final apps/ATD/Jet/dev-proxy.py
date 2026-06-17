#!/usr/bin/env python3
"""
dev-proxy.py — i-Finance local dev server (Analytics Loader / App 208)
  - Serves static files from this directory (ATD/Jet) + sibling apps + /shared
  - Proxies /ords/ requests to ADB ORDS, adding CORS headers.

Usage:  python dev-proxy.py        (then open http://localhost:8080)
        python dev-proxy.py 8081   (alternate port)
"""
import http.server
import urllib.request
import urllib.error
import os
import sys

ORDS_ORIGIN = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com'
PORT = int(os.environ.get('DEV_PROXY_PORT')
           or (sys.argv[1] if len(sys.argv) > 1 and sys.argv[1].isdigit() else 8080))
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
APPS_ROOT  = os.path.normpath(os.path.join(SCRIPT_DIR, '..', '..'))   # 'final apps'
SHARED_DIR = os.path.join(APPS_ROOT, 'shared')
# Auto-derived: any folder under 'final apps' with a Jet/ subdir is a sibling app,
# so a NEW app is served by every proxy automatically (no edit here).
SIBLING_APPS = tuple(sorted(
    d for d in os.listdir(APPS_ROOT)
    if os.path.isdir(os.path.join(APPS_ROOT, d, 'Jet'))
)) if os.path.isdir(APPS_ROOT) else ()


class DevProxyHandler(http.server.SimpleHTTPRequestHandler):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=SCRIPT_DIR, **kwargs)

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

    def _cors(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.send_header('Access-Control-Max-Age', '86400')

    def do_OPTIONS(self):
        if self.path.startswith('/ords/'):
            self.send_response(200); self._cors(); self.end_headers()
        else:
            self.send_response(405); self.end_headers()

    def do_GET(self):
        if self.path.startswith('/ords/'): self._proxy('GET')
        else: super().do_GET()

    def do_POST(self):
        if self.path.startswith('/ords/'): self._proxy('POST')
        else: self.send_response(405); self.end_headers()

    def do_PUT(self):
        if self.path.startswith('/ords/'): self._proxy('PUT')
        else: self.send_response(405); self.end_headers()

    def do_DELETE(self):
        if self.path.startswith('/ords/'): self._proxy('DELETE')
        else: self.send_response(405); self.end_headers()

    def _proxy(self, method):
        target = ORDS_ORIGIN + self.path
        length = int(self.headers.get('Content-Length', 0) or 0)
        body = self.rfile.read(length) if length > 0 else None
        fwd_headers = {}
        for h in ('Content-Type', 'Authorization', 'Accept'):
            v = self.headers.get(h)
            if v: fwd_headers[h] = v
        req = urllib.request.Request(target, data=body, headers=fwd_headers, method=method)
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                body_out = resp.read()
                self.send_response(resp.status); self._cors()
                ct = resp.headers.get('Content-Type', 'application/json')
                self.send_header('Content-Type', ct)
                self.send_header('Content-Length', str(len(body_out)))
                self.end_headers(); self.wfile.write(body_out)
        except urllib.error.HTTPError as e:
            body_out = e.read()
            self.send_response(e.code); self._cors()
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body_out)))
            self.end_headers(); self.wfile.write(body_out)
        except Exception as ex:
            msg = str(ex).encode()
            self.send_response(502); self._cors()
            self.send_header('Content-Type', 'text/plain')
            self.send_header('Content-Length', str(len(msg)))
            self.end_headers(); self.wfile.write(msg)

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
