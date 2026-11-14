#!/usr/bin/env python3
"""ZASM 3.10 tokenized sources -> sjasmplus syntax (faithful phase-1 conversion).

usage: convert.py <disk> [outdir]       converts every ZASM 'a' file of work/extract/<disk>
Details in docs/ZASM_FORMAT.md and docs/ANALYSIS.md.
"""
import sys, os, re, json
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import zasm_parse as zp
from zasm_parse import TAB, REG_LO, REG_HI

REGS = {'a', 'b', 'c', 'd', 'e', 'h', 'l', 'i', 'r', 'af', 'bc', 'de', 'hl', 'ix', 'iy', 'sp', '(hl)', '(bc)', '(de)',
        '(sp)', "af'", '(c)', 'xh', 'xl', 'yh', 'yl', 'nz', 'z', 'nc', 'po', 'pe', 'p', 'm'}
REG_RENAME = {'xh': 'ixh', 'xl': 'ixl', 'yh': 'iyh', 'yl': 'iyl'}
CONDS = {'nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm'}
FUSED = {}   # token -> (base, cond)
for _b in ('ret', 'jp', 'call', 'jr'):
    for _c in ('z', 'nz', 'c', 'nc', 'm', 'p', 'po', 'pe'):
        if _b + _c in TAB.values():
            FUSED[_b + _c] = (_b, _c)
SINGLE_MULTI = {'inc', 'dec', 'push', 'pop'}      # "inc hl,de" = inc hl : inc de
Z80_MN = {'ld', 'ex', 'im', 'rst', 'ret', 'add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'push', 'pop', 'inc', 'dec',
          'in', 'out', 'jp', 'call', 'jr', 'djnz', 'rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'sli', 'srl', 'bit', 'res', 'set',
          'nop', 'halt', 'di', 'ei', 'rlca', 'rla', 'rrca', 'rra', 'exx', 'daa', 'cpl', 'ccf', 'scf', 'ldi', 'ldir', 'ldd',
          'lddr', 'cpi', 'cpir', 'cpd', 'cpdr', 'neg', 'ini', 'inir', 'ind', 'indr', 'outi', 'otir', 'outd', 'otdr', 'reti',
          'retn', 'rld', 'rrd', 'exa', 'inf'}
RESERVED = {  # labels that clash with sjasmplus keywords/registers -> renamed with a trailing underscore
    'high', 'low', 'abs', 'not', 'mod', 'shl', 'shr', 'a', 'b', 'c', 'd', 'e', 'h', 'l', 'i', 'r', 'af', 'bc', 'de', 'hl',
    'ix', 'iy', 'sp', 'ixh', 'ixl', 'iyh', 'iyl', 'z', 'nz', 'nc', 'po', 'pe', 'p', 'm', 'end', 'org', 'ds', 'db', 'dw',
    'include', 'if', 'else', 'endif', 'macro', 'endm', 'device', 'page', 'slot', 'align', 'dup', 'edup', 'rept', 'endr'}

STATE = {}
TEXT_ALIAS = {'incl': 'include', 'incb': 'insert', 'eif': 'endif', 'ifu': 'ifused', 'ifnu': 'ifnused', 'ifd': 'ifdef', 'ifnd': 'ifndef'}
MMARK = '@@M@@'
NL = chr(10)
IFP_MACROS = set()


def ident_fix(name):
    """ZASM label -> sjasmplus label"""
    m = re.fullmatch(r'\$([A-Za-z])(\d+)', name)
    if m:
        return 'Z%s%s' % (m.group(1).upper(), m.group(2))
    if name.lower() in RESERVED:
        return name + '_'
    return name


# ---------------------------------------------------------------- expressions
TEXT_KNOWN = (Z80_MN | set(FUSED) | {'org', 'equ', 'db', 'defb', 'dw', 'defw', 'ds', 'defs', 'dc', 'include', 'insert', 'incl', 'incb',
              'if', 'else', 'endif', 'eif', 'ifdef', 'ifndef', 'ifused', 'ifnused', 'ifu', 'ifnu', 'ifd', 'ifnd', 'rept', 'endr',
              'macro', 'endm', 'exitm', 'phase', 'unphase', 'ent', 'make', 'saveobj', 'dm'})


class ExprError(Exception):
    pass


NUM_RE = re.compile(r'#[0-9A-Fa-f]+|%[01]+|[0-9]+')
ID_RE = re.compile(r'[A-Za-z_@?][A-Za-z0-9_@?]*|\$[A-Za-z]\d+')


def lex(s):
    toks = []
    i = 0
    n = len(s)
    while i < n:
        c = s[i]
        if c == ' ':
            i += 1; continue
        if c == "'" and STATE.get('storm') and toks and (toks[-1][0] in ('id', 'num') or toks[-1] == ('op', ')')):
            toks.append(('suf', 'e')); i += 1; continue
        if c == '"' or c == "'":
            j = s.find(c, i + 1)
            if j < 0: raise ExprError('unterminated string ' + s)
            toks.append(('str', s[i:j+1])); i = j + 1; continue
        m = NUM_RE.match(s, i)
        if m and (c.isdigit() or c in '#%'):
            toks.append(('num', m.group())); i = m.end(); continue
        if c == '=' and i + 1 < n and s[i+1].isdigit():
            toks.append(('id', 'par' + s[i+1])); i += 2; continue
        m = ID_RE.match(s, i)
        if m:
            w = m.group()
            if w in ('(ix', '(iy'): pass
            toks.append(('id', w)); i = m.end(); continue
        if c == '(' and s[i:i+3].lower() in ('(ix', '(iy') and not (i + 3 < n and (s[i+3].isalnum() or s[i+3] == '_')):
            toks.append(('idx', s[i+1:i+3].lower())); i += 3; continue
        if c == '$':
            toks.append(('id', '$')); i += 1; continue
        if c == '.' and i + 1 < n and s[i+1] in 'hbe' and not (i + 2 < n and (s[i+2].isalnum() or s[i+2] == '_')):
            toks.append(('suf', s[i+1])); i += 2; continue
        if c in '[]^`' and STATE.get('storm'):
            toks.append(('suf', {'[': 'h', ']': 'b', '^': 'u', '`': 'f'}[c])); i += 1; continue
        if c in '+-*/(),':
            toks.append(('op', c)); i += 1; continue
        raise ExprError('bad char %r in %r' % (c, s))
    return toks


def conv_str(s, notes):
    """string literal, keep ascii; non-ascii (cp866 text decoded earlier) -> numeric bytes"""
    q = s[0]
    body = s[1:-1]
    if all(ord(ch) < 128 for ch in body):
        return s
    # split into ascii runs and byte values
    parts = []; cur = ''
    for ch in body:
        if ord(ch) < 128: cur += ch
        else:
            if cur: parts.append('"%s"' % cur); cur = ''
            parts.append('%d' % ch.encode('cp866')[0])
    if cur: parts.append('"%s"' % cur)
    notes.append(body)
    return ','.join(parts)


class Parser:
    def __init__(self, toks, notes):
        self.t = toks; self.i = 0; self.notes = notes

    def peek(self):
        return self.t[self.i] if self.i < len(self.t) else (None, None)

    def take(self):
        x = self.peek(); self.i += 1; return x

    def parse_expr(self, endset=(',',)):
        """returns string; strict left-to-right evaluation (ZASM has no operator precedence)"""
        terms = []     # list of (opbefore, text, compound)
        op = ''
        while True:
            k, v = self.peek()
            neg = ''
            if k == 'op' and v in '+-' and not terms:
                neg = v; self.take()
            text, comp = self.parse_primary()
            if neg == '-': text = '-' + text; comp = True
            terms.append((op, text, comp))
            k, v = self.peek()
            if k == 'op' and v in '+-*/':
                op = v; self.take()
                continue
            break
        return self.assemble(terms)

    @staticmethod
    def assemble(terms):
        if len(terms) == 1:
            return terms[0][1]
        acc = terms[0][1] if not terms[0][2] else '(' + terms[0][1] + ')'
        last = None
        for op, text, comp in terms[1:]:
            p = 1 if op in '+-' else 2
            if last is not None and p > last:
                acc = '(' + acc + ')'
            acc = acc + op + (('(' + text + ')') if comp else text)
            last = p
        return acc

    def parse_primary(self):
        k, v = self.take()
        comp = False
        if k == 'op' and v == '(':
            e = self.parse_expr()
            k2, v2 = self.take()
            if (k2, v2) != ('op', ')'): raise ExprError('missing )')
            text = '(' + e + ')'
        elif k == 'num':
            text = v
        elif k == 'str':
            text = conv_str(v, self.notes)
        elif k == 'id':
            text = ident_fix(v) if v != '$' else '$'
        else:
            raise ExprError('unexpected %r %r' % (k, v))
        while self.peek()[0] == 'suf':
            _, s = self.take()
            if s == 'h': text = 'high(%s)' % text; comp = False
            elif s == 'b': text = 'low(%s)' % text; comp = False
            elif s == 'u': text = '((%s+255)/256*256)' % text; comp = False
            elif s == 'f': text = '(%s/256*256)' % text; comp = False
            else: text = 'low(%s)*256' % text; comp = True
        return text, comp


def expr_str(s, notes):
    toks = lex(s)
    p = Parser(toks, notes)
    e = p.parse_expr()
    if p.i != len(toks): raise ExprError('trailing tokens in %r' % s)
    return e


def split_commas(s):
    out = []; depth = 0; q = None; cur = ''
    for ch in s:
        if q:
            cur += ch
            if ch == q: q = None
            continue
        if ch in '"\'': q = ch; cur += ch; continue
        if ch == '(': depth += 1
        elif ch == ')': depth -= 1
        if ch == ',' and depth == 0:
            out.append(cur); cur = ''
        else:
            cur += ch
    out.append(cur)
    return [o.strip() for o in out]


def conv_operand(op, notes):
    t = op.strip()
    lo = t.lower()
    if lo in REGS:
        return REG_RENAME.get(lo, lo)
    if lo == 'c' or lo == 'af':
        return lo
    # (ix+d) forms
    m = re.match(r"^\((ix|iy)(.*)\)$", t, re.I)
    if m and (len(m.group(2)) == 0 or m.group(2)[0] in '+-'):
        rest = m.group(2).strip()
        if not rest: return '(%s)' % m.group(1).lower()
        e = expr_str(rest, notes)
        if e[0] not in '+-': e = '+' + e
        return '(%s%s)' % (m.group(1).lower(), e)
    return expr_str(t, notes)


# ---------------------------------------------------------------- statement conversion
class Stmt:
    def __init__(self, mn, ops, macro=False):
        self.mn = mn; self.ops = ops; self.macro = macro   # mn: str (lowercase token text) or macro name


def stmt_of(items):
    """item list -> (mn, opstring, is_macro) or None if empty"""
    items = [it for it in items]
    # strip leading pads/blanks
    while items and (items[0][0] == 'P' or (items[0] == ('C', 0x20))): items.pop(0)
    if not items: return None
    k, v = items[0]
    rest = items[1:]
    if k == 'T':
        mn = TAB[v]
        macro = False
    else:
        # macro call / unknown word
        name = ''
        j = 0
        while j < len(items) and items[j][0] == 'C' and (chr(items[j][1]).isalnum() or chr(items[j][1]) in '_$@?'):
            name += chr(items[j][1]); j += 1
        mn = name; macro = True; rest = items[j:]
        if not name:
            return ('?', zp.render_items(items).decode('cp866'), True)
    txt = ''
    for k, v in rest:
        if k == 'T': txt += TAB[v]
        elif k == 'P': txt += ' ' * v
        else: txt += bytes([v]).decode('cp866')
    return (mn, txt.strip(), macro)


class Converter:
    def __init__(self, disk, name, data, namemap, lines=None):
        self.disk = disk; self.name = name
        if lines is not None:
            self.lines = lines
        else:
            self.lines = zp.parse_bytes(data)
            if data.endswith(b'\r'): self.lines.pop()
        self.namemap = namemap
        self.out = []
        self.notes = []
        self.warn = []
        self.in_macro = None
        self.macro_buf = []
        self.makes = []       # (file, startexpr)
        self.mk_n = 0
        self.textmode = lines is not None

    def emit(self, s=''):
        self.out.append(s)

    def comment_text(self, L):
        c = L.comment
        c = ''.join(ch for ch in c if ch >= ' ' or ch == '\t')
        return c.rstrip()

    def convert(self):
        for ln, L in enumerate(self.lines, 1):
            self.cur_ln = ln
            if L.kind == 'empty':
                self.emit(); continue
            if L.kind == 'comment':
                self.emit('; ' + self.comment_text(L) if L.bare else ';' + self.comment_text(L)
                          if L.cmark == ';' else ';' + self.comment_text(L))
                continue
            self.code_line(L)
        return '\n'.join(self.out) + '\n'

    def fmt(self, label, text, comment):
        s = (label + (':' if label else '')) if label else ''
        s = s.ljust(12) if label is not None and label != '' else ' ' * 12
        if label and len(label) >= 11: s = label + ':' + ' '
        s += text
        if comment:
            s = s.rstrip().ljust(36) + ';' + comment
        return s.rstrip()

    def code_line(self, L):
        stmts = zp.split_statements(L.code)
        label = ident_fix(L.label) if L.label else None
        comment = self.comment_text(L) if L.comment is not None else None
        # build list of converted text lines
        lines = []
        parsed = []
        for st in stmts:
            r = stmt_of(st)
            if r is not None: parsed.append(r)
        if not parsed:
            if label:
                self.emit(label + ':' + ((' ;' + comment) if comment else ''))
            elif comment is not None:
                self.emit(' ' * 12 + ';' + comment)
            return
        first = True
        pending_label = label
        for idx, (mn, ops, ismacro) in enumerate(parsed):
            try:
                outl = self.stmt(mn, ops, ismacro, pending_label)
            except ExprError as e:
                self.warn.append('%s:%d: %s' % (self.name, self.cur_ln, e))
                outl = ['; ERROR %s: %s %s' % (e, mn, ops)]
            for k, ol in enumerate(outl):
                if k == 0 and pending_label is not None and not ol.startswith(('MACRO', 'EQU')) and not ol.lstrip().startswith(';'):
                    pass
            lines.extend(outl)
            pending_label = None if outl else pending_label
        # attach label and comment
        if not lines:
            if label: self.emit(label + ':')
            return
        for k, ol in enumerate(lines):
            self.emit(ol)
        if comment:
            # append the comment to the last emitted line
            last = self.out.pop()
            self.emit(last.rstrip().ljust(36) + ';' + comment if not last.strip().startswith(';') else last + ' ;' + comment)

    # one statement -> list of text lines (first line may carry label)
    def stmt(self, mn, ops, ismacro, label):
        notes = self.notes
        lab = (label + ':').ljust(12) if label else ' ' * 12
        if len(lab.rstrip()) >= 12: lab = lab.rstrip() + ' '
        mnl = mn.lower()
        if ismacro and self.textmode and mnl in TEXT_KNOWN:
            ismacro = False
        mnl = TEXT_ALIAS.get(mnl, mnl) if self.textmode else mnl
        # ---- directives
        if not ismacro:
            if mnl == 'macro':
                self.in_macro = label
                self.macro_open = len(self.out)
                return [MMARK + '            MACRO ' + ident_fix(label)]   # patched in fix_macros (params)
            if mnl == 'endm':
                return ['            ENDM']
            if mnl in ('equ',):
                return [lab + 'equ  ' + expr_str(ops, notes)]
            if mnl == 'org':
                return [lab + 'org  ' + expr_str(ops, notes)]
            if mnl in ('db', 'defb', 'dw', 'defw'):
                parts = split_commas(ops)
                kw = 'db' if mnl in ('db', 'defb') else 'dw'
                conv = []
                for p in parts:
                    conv.append(expr_str(p, notes))
                return [lab + kw.ljust(5) + ','.join(conv)]
            if mnl in ('ds', 'defs'):
                parts = split_commas(ops)
                return [lab + 'ds   ' + ','.join(expr_str(p, notes) for p in parts)]
            if mnl == 'dc':
                return [lab + 'dc   ' + ','.join(expr_str(p, notes) for p in split_commas(ops))]
            if mnl in ('include', 'insert'):
                m = re.fullmatch(r'"([^"]*)"', ops.strip())
                if not m: raise ExprError('bad %s operand %r' % (mnl, ops))
                fn = m.group(1)
                if mnl == 'include':
                    f2 = self.namemap.get(fn.rstrip(), None)
                    if f2 is None: self.warn.append('%s:%d: include "%s" not found' % (self.name, self.cur_ln, fn)); f2 = fn + '.asm'
                    return [lab + 'include "%s"' % f2]
                base, _, ext = fn.rpartition('.')
                key = '@%s.%s' % (base, ext[:1])
                if not base:
                    key = '@' + fn          # STORM style: no extension
                if key not in self.namemap:
                    self.warn.append('%s:%d: insert "%s" blob not found' % (self.name, self.cur_ln, fn))
                return [lab + 'incbin "%s"' % self.namemap.get(key, fn)]
            if mnl in ('if', 'ifdef', 'ifndef', 'ifused', 'ifnused'):
                if mnl == 'if':
                    return [lab + 'if   ' + expr_str(ops, notes)]
                return [lab + mnl.ljust(5) + ident_fix(ops.strip())]
            if mnl == 'else': return [lab + 'else']
            if mnl == 'endif': return [lab + 'endif']
            if mnl == 'ifp': return [lab + 'ifp   ; ZASM: if macro parameter present']
            if mnl == 'exitm': return [lab + 'exitm']
            if mnl == 'rept': return [lab + 'rept ' + expr_str(ops, notes)]
            if mnl == 'endr': return [lab + 'endr']
            if mnl == 'phase': return [lab + 'disp ' + expr_str(ops, notes)]
            if mnl == 'unphase': return [lab + 'ent']
            if mnl == 'ent': return [lab + '; ent ' + ops + '   (ZASM entry point marker)']
            if mnl == 'create':
                return [lab + '; create ' + ops + '   (ZASM auto-label family)']
            if mnl == 'makelab': return [lab + '; makelab ' + ops]
            if mnl == 'saveobj':
                parts = split_commas(ops)
                f = parts[0].strip('"')
                return [lab + 'savebin "%s",%s,%s' % (f, expr_str(parts[1], notes), expr_str(parts[2], notes))]
            if mnl == 'make':
                parts = split_commas(ops)
                f = parts[0].strip('"')
                a = expr_str(parts[1], notes)
                res = []
                if self.makes:
                    pf, ps = self.makes[-1]
                    res.append('            savebin "%s",MAKE_%d,$-MAKE_%d' % (pf, len(self.makes) - 1, len(self.makes) - 1))
                n = len(self.makes)
                res.append('MAKE_%d' % n + ':'.ljust(11) + 'equ  ' + a)
                res.append('            org  MAKE_%d' % n)
                self.makes.append((f, a))
                return res
            if mnl in ('loadtab', 'ifp'):
                return [lab + '; ' + mnl + ' ' + ops]
        # ---- Z80 instruction
        if not ismacro and mnl in Z80_MN | set(FUSED):
            return self.z80(mnl, ops, lab)
        if ismacro:
            if mnl == '?': return [lab + '; ??? ' + ops]
            args = split_commas(ops) if ops else []
            conv = [conv_operand_any(a, notes) for a in args] if args else []
            nm = ident_fix(mn)
            if not conv and mn in IFP_MACROS: nm += '__NOARG'
            return [lab + nm + ((' ' + ','.join(conv)) if conv else '')]
        raise ExprError('unknown mnemonic ' + mn)

    def z80(self, mnl, ops, lab):
        notes = self.notes
        base = mnl; cond = None
        if mnl in FUSED:
            base, cond = FUSED[mnl]
        args = split_commas(ops) if ops else []
        if mnl == 'exa': return [lab + "ex   af,af'"]
        if mnl == 'inf': return [lab + 'in   f,(c)']
        conv = [conv_operand(a, notes) for a in args]
        if cond:
            conv = [cond] + conv
        mn_out = base
        if mnl in SINGLE_MULTI and len(conv) > 1:
            res = []
            for k, c in enumerate(conv):
                res.append((lab if k == 0 else ' ' * 12) + mnl.ljust(5) + c)
            return res
        return [lab + mn_out.ljust(5) + ','.join(conv)]


def conv_operand_any(a, notes):
    a = a.strip()
    try:
        return conv_operand(a, notes)
    except ExprError:
        return a


def build_namemap(disk):
    cat = json.load(open(ROOT + '/work/catalogue.json'))
    nm = {}
    for c in cat[disk]['files']:
        if c['type'] == 'a':
            nm[c['name'].rstrip()] = None
    return nm


def safe(s):
    return ''.join(ch if (ch.isalnum() or ch in '._-') else '_%02x' % ord(ch) for ch in s)


def split_ifp(body):
    """macro body with 'ifp [else] endif' -> (body_with_param, body_without_param)"""
    withp, without = [], []
    state = None
    for ln in body:
        w = ln.strip().split(';')[0].strip().lower()
        if state is None and w == 'ifp':
            state = 'then'; continue
        if state is not None and w == 'else':
            state = 'else'; continue
        if state is not None and w == 'endif':
            state = None; continue
        if state == 'then': withp.append(ln)
        elif state == 'else': without.append(ln)
        else: withp.append(ln); without.append(ln)
    return withp, without


def fix_macros(text):
    """second pass: macro parameter lists (parN used in the body); 'ifp' macros are split into two macros"""
    lines = text.split(NL)
    out = []
    i = 0
    while i < len(lines):
        ln = lines[i]
        if ln.startswith(MMARK):
            j = i + 1
            body = []
            while j < len(lines) and not lines[j].strip().lower().startswith('endm'):
                body.append(lines[j]); j += 1
            hdr = ln[len(MMARK):]
            name = hdr.split()[1]
            variants = [(hdr, body)]
            if any(b.strip().split(';')[0].strip().lower() == 'ifp' for b in body):
                wp, wo = split_ifp(body)
                variants = [(hdr, wp), (hdr.replace('MACRO ' + name, 'MACRO ' + name + '__NOARG'), wo)]
            for h, b in variants:
                used = sorted({int(m) for x in b for m in re.findall(r'\bpar(\d)\b', x)})
                if used: h += ' ' + ','.join('par%d' % k for k in range(1, max(used) + 1))
                out.append(h); out.extend(b); out.append(lines[j] if j < len(lines) else '            ENDM')
            i = j + 1
            continue
        out.append(ln); i += 1
    return NL.join(out)


def main():
    disk = sys.argv[1]
    outdir = sys.argv[2] if len(sys.argv) > 2 else '%s/work/phase1_src/%s' % (ROOT, disk)
    os.makedirs(outdir, exist_ok=True)
    cat = json.load(open(ROOT + '/work/catalogue.json'))
    files = [c for c in cat[disk]['files'] if c['type'] == 'a']
    blobs = []
    namemap = {}
    used = set()
    for c in files:
        fn = safe(c['name'].rstrip()) + '.asm'
        if fn.lower() in used:
            fn = safe(c['name'].rstrip()) + '~%d.asm' % c['idx']
        used.add(fn.lower())
        namemap[c['name'].rstrip()] = fn
    for c in cat[disk]['files']:
        if c['type'] != 'a':
            namemap['@' + c['name'].rstrip() + ('.' + c['type'])] = 'assets/' + c['file']
            blobs.append((disk, c))
    # blobs that only exist on the other developer disks (e.g. cv1.C on awk2): copied in under 'assets/<disk>_<file>'
    for od in ('awk1', 'awk2', 'awk3', 'awk4', 'awk5', 'awk6'):
        if od == disk: continue
        for c in cat[od]['files']:
            key = '@' + c['name'].rstrip() + ('.' + c['type'])
            if c['type'] != 'a' and key not in namemap:
                c2 = dict(c); c2['file'] = '%s_%s' % (od, c['file'])
                namemap[key] = 'assets/' + c2['file']
                blobs.append((od, c, c2['file']))
    # prescan: macros containing 'ifp'
    for c in files:
        data = open('%s/work/extract/%s/%s' % (ROOT, disk, c['file']), 'rb').read()[:c['length']]
        cur = None
        for L in zp.parse_bytes(data):
            if L.kind != 'code': continue
            for st in zp.split_statements(L.code):
                r = stmt_of(st)
                if not r: continue
                if r[0].lower() == 'macro' and not r[2]: cur = L.label
                elif r[0].lower() == 'endm': cur = None
                elif r[0].lower() == 'ifp' and cur: IFP_MACROS.add(cur)
    total_warn = 0
    os.makedirs(outdir + '/assets', exist_ok=True)
    import shutil
    for b in blobs:
        od, c = b[0], b[1]
        dst = b[2] if len(b) > 2 else c['file']
        shutil.copyfile('%s/work/extract/%s/%s' % (ROOT, od, c['file']), '%s/assets/%s' % (outdir, dst))
    for c in files:
        data = open('%s/work/extract/%s/%s' % (ROOT, disk, c['file']), 'rb').read()[:c['length']]
        cv = Converter(disk, c['name'].rstrip(), data, namemap)
        text = cv.convert()
        if cv.makes or 'savebin' in text:
            text = '            DEVICE ZXSPECTRUM128' + chr(10) + text
        if cv.makes:
            f, a = cv.makes[-1]
            n = len(cv.makes) - 1
            text += '            savebin "%s",MAKE_%d,$-MAKE_%d\n' % (f, n, n)
        text = fix_macros(text)
        open('%s/%s' % (outdir, namemap[c['name'].rstrip()]), 'w', encoding='utf-8', newline='\n').write(text)
        for w in cv.warn: print('WARN', w); total_warn += 1
    print(disk, len(files), 'files converted;', total_warn, 'warnings')


if __name__ == '__main__':
    main()
