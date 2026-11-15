#!/usr/bin/env python3
"""serve.py - localhost server for the Awaken model editor.

    python tools/model_editor/serve.py [--port 8765] [--open]

* serves tools/model_editor/ (the editor, static files) at /
* serves assets/models/ at /models/ (the editor loads the models from here automatically)
* PUT / DELETE /models/{flight,station}/NAME.txt|index.txt: lets the editor's Save write into assets/models
  (bound to 127.0.0.1 only; requires the header X-Model-Editor, accepts only those file names)
* GET /api/refs?name=NAME: where NAME occurs in src/**/*.asm (used by the delete warning)
Picks the first free port from --port upwards (default 8765).  The ports 8000, 8090, 8095, 8851 are never used (taken by other tools).
"""
import argparse, http.server, json, os, re, socket, sys, urllib.parse, webbrowser

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
MODELS = os.path.join(ROOT, 'assets', 'models')
RESERVED = {8000, 8090, 8095, 8851}
NAME_RE = re.compile(r'^(flight|station)/([A-Za-z_][A-Za-z0-9_]*|index)\.txt$')


def free_port(start):
    for p in range(start, start + 200):
        if p in RESERVED:
            continue
        s = socket.socket()
        try:
            s.bind(('127.0.0.1', p)); s.close(); return p
        except OSError:
            s.close()
    raise SystemExit('no free port found')


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {**http.server.SimpleHTTPRequestHandler.extensions_map, '.js': 'text/javascript', '.mjs': 'text/javascript', '.txt': 'text/plain; charset=utf-8'}

    def translate_path(self, path):
        path = urllib.parse.unquote(urllib.parse.urlsplit(path).path)
        if path.startswith('/models/'):
            base, rel = MODELS, path[len('/models/'):]
        else:
            base, rel = HERE, path.lstrip('/')
        full = os.path.abspath(os.path.join(base, rel))
        if not (full == base or full.startswith(base + os.sep)):
            return os.path.join(HERE, 'nonexistent')
        return full

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

    def log_message(self, fmt, *a):
        sys.stderr.write('[model_editor] ' + fmt % a + '\n')

    def _model_target(self):
        p = urllib.parse.unquote(urllib.parse.urlsplit(self.path).path)
        if not p.startswith('/models/') or not NAME_RE.match(p[len('/models/'):]):
            return None
        if self.headers.get('X-Model-Editor') != '1':
            return None
        return os.path.join(MODELS, *p[len('/models/'):].split('/'))

    def do_PUT(self):
        t = self._model_target()
        if not t:
            return self.send_error(403)
        n = int(self.headers.get('Content-Length', 0))
        data = self.rfile.read(n)
        os.makedirs(os.path.dirname(t), exist_ok=True)
        with open(t, 'wb') as f:
            f.write(data)
        self.send_response(204); self.end_headers()

    def do_DELETE(self):
        t = self._model_target()
        if not t or t.endswith('index.txt'):
            return self.send_error(403)
        try:
            os.remove(t)
        except FileNotFoundError:
            pass
        self.send_response(204); self.end_headers()

    def do_GET(self):
        u = urllib.parse.urlsplit(self.path)
        if u.path == '/api/refs':
            name = urllib.parse.parse_qs(u.query).get('name', [''])[0]
            refs = []
            if re.fullmatch(r'\w+', name):
                rx = re.compile(r'\b' + re.escape(name) + r'\b', re.I)
                for dp, dn, fn in os.walk(os.path.join(ROOT, 'src')):
                    if os.sep + 'legacy' in dp:
                        continue
                    for f in fn:
                        if f.lower().endswith(('.asm', '.inc')):
                            fp = os.path.join(dp, f)
                            try:
                                for i, l in enumerate(open(fp, encoding='utf-8', errors='replace'), 1):
                                    if rx.search(l):
                                        refs.append('%s:%d  %s' % (os.path.relpath(fp, ROOT).replace(os.sep, '/'), i, l.strip()[:80]))
                            except OSError:
                                pass
            body = json.dumps({'name': name, 'refs': refs}).encode()
            self.send_response(200); self.send_header('Content-Type', 'application/json'); self.send_header('Content-Length', str(len(body))); self.end_headers()
            self.wfile.write(body)
            return
        super().do_GET()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', type=int, default=8765)
    ap.add_argument('--open', action='store_true', help='open the editor in the default browser')
    a = ap.parse_args()
    port = free_port(a.port)
    srv = http.server.ThreadingHTTPServer(('127.0.0.1', port), Handler)
    url = 'http://localhost:%d/' % port
    print('Awaken model editor: %s   (models: %s)   Ctrl+C to stop' % (url, MODELS), flush=True)
    if a.open:
        webbrowser.open(url)
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
