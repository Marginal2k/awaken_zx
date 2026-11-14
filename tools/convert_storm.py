#!/usr/bin/env python3
"""STORM (decoded text, as written by tools/storm_detok.py or the awk4 plain-text exports) -> sjasmplus 1.23.

Library + CLI:
    convert_storm.py IN.asm OUT.asm [--names NAME=file,...] [--prec]
STORM dialect features handled (see docs/STORM.md):
  * expressions: ! = OR, | = XOR, \\ = remainder, = = equality, postfix  [ = high byte, ] = low byte,
    ^ = round up to the next 256 boundary, ` = round down (page floor), ' = low byte shifted left 8;
    evaluation order: usual precedence (* / remainder, then + -, << >>, &, ! |, comparisons); --ltr = strict left to right
  * '.N' at the start of a line = repeat the whole rest of the line N times  ->  DUP N ... EDUP
  * '_' prefix = 'not tabulated' instruction;  ORG a,b = run address a, load address b  ->  ORG b + DISP a (ENT at next ORG)
  * multi operand PUSH/POP/INC/DEC, LD r,r,r,r pairs, LD rr,rr', EX HL,DE, ADD DE,HL, OUT (n), register halves HX LX ...
  * INCL "X" -> INCLUDE, INCB "X" -> INCBIN, EIF -> ENDIF, IFD/IFND -> IFDEF/IFNDEF (IFU/IFNU kept as IFUSED/IFNUSED)
"""
import sys, os, re

# ---------------------------------------------------------------------------------------------------------- tables
RESERVED = set('''a b c d e h l i r af bc de hl sp ix iy ixh ixl iyh iyl z nz nc po pe p m end org ds db dw dd dg dh dz dm
defb defw defs defm defd byte word block align assert display define dup edup rept endr endm macro if ifn ifdef ifndef ifused
ifnused else elseif endif include incbin incl incb insert device output page slot map module endmodule struct ends savebin
savesna savetrd savehob savetap savenex save include end disp ent phase dephase unphase low high abs not mod shl shr and or
xor exa exd exx ex ld inc dec push pop jp jr jr call ret rst nop halt di ei im in out cp sub sbc add adc neg cpl daa ccf scf
rlca rrca rla rra rlc rrc rl rr sla sra sll sli srl bit res set ldi ldd ldir lddr cpi cpd cpir cpd cpdr ini ind inir indr
outi outd otir otdr reti retn rld rrd lua endlua label equ defl size unphase textarea endt encoding opt fpos limit
slot slotname'''.split())

MN0 = set('''NOP HALT DI EI EXX DAA CPL CCF SCF RLCA RRCA RLA RRA NEG RLD RRD LDI LDD LDIR LDDR CPI CPD CPIR CPDR INI IND INIR INDR
OUTI OUTD OTIR OTDR RETI RETN EXA'''.split())
MNALL = MN0 | set('''LD INC DEC EX JR DJNZ JP CALL RET POP PUSH ADD ADC SUB SBC AND OR XOR CP IN OUT BIT RES SET RLC RRC RL RR SLA SRA
SLI SRL IM RST INF DB DW DS DEFB DEFW DEFS ORG EQU INCL INCB IF IFU IFNU IFD IFND ELSE EIF ENDM REPT ENDR'''.split())
REG8 = {'A', 'B', 'C', 'D', 'E', 'H', 'L', 'I', 'R'}
HALF = {'HX': 'IXH', 'LX': 'IXL', 'HY': 'IYH', 'LY': 'IYL', 'XH': 'IXH', 'XL': 'IXL', 'YH': 'IYH', 'YL': 'IYL'}
REG16 = {'BC', 'DE', 'HL', 'SP', 'AF', 'IX', 'IY'}
COND = {'NZ', 'Z', 'NC', 'C', 'PO', 'PE', 'P', 'M'}
PAIRS = {'BC': ('B', 'C'), 'DE': ('D', 'E'), 'HL': ('H', 'L'), 'IX': ('IXH', 'IXL'), 'IY': ('IYH', 'IYL')}

NAMEMAP = {}      # label rename map (reserved words)


def lab(name):
    """label name -> sjasmplus label name"""
    if name.lower() in RESERVED or name[0].isdigit():
        return name + '_'
    return name


# ------------------------------------------------------------------------------------------------ expression parser
class Ex:  # tiny AST
    def __init__(self, kind, a=None, b=None, c=None):
        self.k, self.a, self.b, self.c = kind, a, b, c


BINOPS = ['<<', '>>', '<=', '>=', '+', '-', '*', '/', '\\', '&', '!', '|', '<', '>', '=']
PREC = {'*': 5, '/': 5, '\\': 5, '+': 4, '-': 4, '<<': 3, '>>': 3, '&': 2, '|': 1, '!': 1,
        '<': 0, '>': 0, '<=': 0, '>=': 0, '=': 0}
OPMAP = {'\\': '%', '!': '|', '|': '^', '=': '==', '<<': '<<', '>>': '>>'}
POST = '[]^`\'?~@'


class ExprError(Exception):
    pass


def tokenize(s):
    t = []
    i = 0
    n = len(s)
    while i < n:
        ch = s[i]
        if ch.isspace():
            i += 1
        elif ch == '"':
            j = s.index('"', i + 1)
            t.append(('str', s[i + 1:j])); i = j + 1
        elif ch == '#' and i + 1 < n and re.match(r'[0-9A-Fa-f]', s[i + 1]):
            m = re.match(r'#[0-9A-Fa-f]+', s[i:]); t.append(('num', int(m.group()[1:], 16), m.group())); i += len(m.group())
        elif ch == '%' and i + 1 < n and s[i + 1] in '01':
            m = re.match(r'%[01]+', s[i:]); t.append(('num', int(m.group()[1:], 2), m.group())); i += len(m.group())
        elif ch.isdigit():
            m = re.match(r'\d+', s[i:]); t.append(('num', int(m.group()), m.group())); i += len(m.group())
        elif ch.isalpha() or ch in '_':
            m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", s[i:]); t.append(('id', m.group())); i += len(m.group())
        elif ch == '$':
            t.append(('dollar',)); i += 1
        elif ch == '=' and i + 1 < n and (s[i + 1].isdigit()):
            m = re.match(r'=\d+', s[i:]); t.append(('lref', m.group())); i += len(m.group())
        elif s[i:i + 2] in ('<<', '>>', '<=', '>='):
            t.append(('op', s[i:i + 2])); i += 2
        elif ch in '+-*/\\&!|<>=':
            t.append(('op', ch)); i += 1
        elif ch in POST:
            t.append(('post', ch)); i += 1
        elif ch in '()':
            t.append((ch,)); i += 1
        else:
            raise ExprError('bad char %r in %r' % (ch, s))
    return t


class Parser:
    def __init__(self, toks, prec):
        self.t, self.i, self.prec = toks, 0, prec

    def peek(self):
        return self.t[self.i] if self.i < len(self.t) else None

    def parse(self):
        e = self.expr(0) if self.prec else self.expr_ltr()
        if self.i != len(self.t):
            raise ExprError('trailing tokens %r' % (self.t[self.i:],))
        return e

    def primary(self):
        tk = self.peek()
        if tk is None:
            raise ExprError('unexpected end')
        self.i += 1
        if tk[0] == 'op' and tk[1] in '-+':
            x = self.primary()
            return Ex('neg' if tk[1] == '-' else 'pos', x)
        if tk[0] == '(':
            e = self.expr(0) if self.prec else self.expr_ltr()
            if self.peek() != (')',):
                raise ExprError('missing )')
            self.i += 1
            x = Ex('paren', e)
        elif tk[0] == 'num':
            x = Ex('num', tk[1], tk[2])
        elif tk[0] == 'str':
            x = Ex('str', tk[1])
        elif tk[0] == 'id':
            x = Ex('id', tk[1])
        elif tk[0] == 'dollar':
            x = Ex('dollar')
        elif tk[0] == 'lref':
            x = Ex('lref', tk[1])
        else:
            raise ExprError('unexpected %r' % (tk,))
        while self.peek() and self.peek()[0] == 'post':
            x = Ex('post', self.peek()[1], x); self.i += 1
        return x

    def expr_ltr(self):
        l = self.primary()
        while self.peek() and self.peek()[0] == 'op':
            op = self.peek()[1]; self.i += 1
            r = self.primary()
            l = Ex('bin', op, l, r)
        return l

    def expr(self, minp):
        l = self.primary()
        while self.peek() and self.peek()[0] == 'op' and PREC[self.peek()[1]] >= minp:
            op = self.peek()[1]; self.i += 1
            r = self.expr(PREC[op] + 1)
            l = Ex('bin', op, l, r)
        return l


STAT = {'ops': {}}
ROUNDUP = 'plain'     # '^' semantics; 'plain' = (x+255)&#FF00 ; 'always' = (x&#FF00)+256


def emit(e, top=False):
    k = e.k
    if k == 'num':
        return e.b
    if k == 'str':
        s = e.a
        if len(s) == 1:
            return '"%s"' % s
        if len(s) == 2:
            return str(ord(s[0].encode('cp866')) * 256 + ord(s[1].encode('cp866')))
        return '"%s"' % s
    if k == 'id':
        return lab(e.a)
    if k == 'dollar':
        return '$'
    if k == 'lref':
        raise ExprError('local ref %s' % e.a)
    if k == 'paren':
        return '(' + emit(e.a, True) + ')'
    if k == 'neg':
        return '-' + emit_atom(e.a)
    if k == 'pos':
        return '+' + emit_atom(e.a)
    if k == 'post':
        op = e.a
        STAT['ops'][op] = STAT['ops'].get(op, 0) + 1
        x = emit(e.b, True)
        if op == '[':
            return 'high(%s)' % x
        if op == ']':
            return 'low(%s)' % x
        if op == '^':
            return ('((%s+255)&#FF00)' if ROUNDUP == 'plain' else '(((%s)&#FF00)+256)') % x
        if op == '`':
            return '((%s)&#FF00)' % x
        if op == "'":
            return '(low(%s)*256)' % x
        raise ExprError('postfix %s' % op)
    if k == 'bin':
        op = e.a
        STAT['ops'][op] = STAT['ops'].get(op, 0) + 1
        s = emit_operand(e.b) + OPMAP.get(op, op) + emit_operand(e.c)
        return s if top else '(' + s + ')'
    raise ExprError(k)


def emit_atom(e):
    s = emit(e)
    return s if e.k in ('num', 'id', 'dollar', 'paren', 'str') else '(' + s + ')'


def emit_operand(e):
    if e.k == 'bin':
        return '(' + emit(e, True) + ')'
    return emit(e)


def conv_expr(s, prec=False):
    """STORM expression text -> sjasmplus text (top-level, no outer parentheses added)"""
    p = Parser(tokenize(s), prec)
    return emit(p.parse(), True), p


def conv_operand(s, prec=False, instr=False):
    """immediate/memory expression operand.  A top-level '(x)' stays a memory reference; an immediate expression that
    merely starts with '(' gets a leading '+' so that sjasmplus does not mistake it for a memory reference."""
    ast = Parser(tokenize(s), prec).parse()
    out = emit(ast, True)
    if instr and ast.k != 'paren' and out.startswith('('):
        out = '+' + out
    return out


# --------------------------------------------------------------------------------------------------- statements
def split_top(s, sep):
    """split on top-level sep (outside quotes and parentheses)"""
    out, cur, depth, q = [], '', 0, None
    for ch in s:
        if q:
            cur += ch
            if ch == q: q = None
            continue
        if ch == '"':
            q = ch; cur += ch; continue
        if ch == '(': depth += 1
        elif ch == ')': depth -= 1
        if ch == sep and depth == 0:
            out.append(cur); cur = ''
        else:
            cur += ch
    out.append(cur)
    return out


def split_comment(s):
    q = None
    for i, ch in enumerate(s):
        if q:
            if ch == q: q = None
            continue
        if ch == '"': q = ch; continue
        if ch == ';': return s[:i], s[i:]
    return s, ''


def reg_op(o):
    """normalise register spelling; returns upper-case sjasmplus text or None if not a register/condition token"""
    u = o.strip().upper()
    if u in HALF: return HALF[u]
    if u in REG8 or u in REG16 or u in COND or u == "AF'" or u in ('(HL)', '(BC)', '(DE)', '(SP)', '(C)'):
        return u
    m = re.match(r'^\(\s*(IX|IY)\s*([+-].*)?\)$', u)
    return None


def conv_arg(o, prec, instr=True):
    o = o.strip()
    r = reg_op(o)
    if r is not None:
        return r
    m = re.match(r'^\(\s*(IX|IY)\s*(?:([+-])(.*))?\)$', o, re.I)
    if m:
        if m.group(2) is None:
            return '(%s)' % m.group(1).upper()
        # keep sign; wrap compound expressions
        ast = Parser(tokenize(m.group(3)), prec).parse()
        inner = emit(ast, True)
        if ast.k == 'bin' or ast.k == 'post' and False:
            inner = '(' + inner + ')'
        return '(%s%s%s)' % (m.group(1).upper(), m.group(2), inner)
    return conv_operand(o, prec, instr)


class Conv:
    def __init__(self, names=None, prec=True, warn=None):
        self.names = names or {}
        self.prec = prec
        self.warn = warn if warn is not None else (lambda m: None)
        self.disp = False
        self.lineno = 0

    # instruction -> list of sjasmplus instruction strings
    def instr(self, mn, ops):
        U = mn.upper()
        P = self.prec
        parts = [x for x in split_top(ops, ',')] if ops.strip() else []
        if U == 'EXA': return ["EX AF,AF'"]
        if U == 'INF': return ['IN F,(C)']
        if U == 'SLI': U = 'SLL'
        if U in ('DEFB',): U = 'DB'
        if U in ('DEFW',): U = 'DW'
        if U in ('DEFS',): U = 'DS'
        if U in ('DB', 'DW', 'DS'):
            return ['%s %s' % (U, ', '.join(self.data_arg(p) for p in parts))]
        if U in ('PUSH', 'POP', 'INC', 'DEC') and len(parts) > 1:
            return ['%s %s' % (U, conv_arg(p, P)) for p in parts]
        # STORM shorthand: OUT r = OUT (C),r ; IN r = IN r,(C)   (verified: LAND AY-port code, awk4 text export uses it too)
        if U == 'OUT' and len(parts) == 1 and parts[0].strip().upper() in REG8:
            return ['OUT (C),%s' % parts[0].strip().upper()]
        if U == 'IN' and len(parts) == 1 and parts[0].strip().upper() in REG8:
            return ['IN %s,(C)' % parts[0].strip().upper()]
        if U == 'OUT' and len(parts) == 1 and parts[0].strip().startswith('('):
            return ['OUT %s,A' % conv_arg(parts[0], P)]
        if U == 'IN' and len(parts) == 1 and parts[0].strip().startswith('('):
            return ['IN A,%s' % conv_arg(parts[0], P)]
        if U == 'EX' and len(parts) == 2 and parts[0].strip().upper() == 'HL' and parts[1].strip().upper() == 'DE':
            return ['EX DE,HL']
        if U == 'ADD' and len(parts) == 2 and parts[0].strip().upper() == 'DE' and parts[1].strip().upper() == 'HL':
            return ['EX DE,HL', 'ADD HL,DE', 'EX DE,HL']
        PAIRED = ('LD', 'ADD', 'ADC', 'SUB', 'SBC', 'AND', 'OR', 'XOR', 'CP')
        if U in PAIRED and len(parts) > 2:
            if len(parts) % 2:
                raise ExprError('odd operand count for %s' % U)
            return [self.single(U, parts[k:k + 2]) for k in range(0, len(parts), 2)]
        if U == 'LD' and len(parts) == 2:
            d, s = parts[0].strip().upper(), parts[1].strip().upper()
            if d in PAIRS and s in PAIRS and d != s:
                (dh, dl), (sh, sl) = PAIRS[d], PAIRS[s]
                return ['LD %s,%s' % (dh, sh), 'LD %s,%s' % (dl, sl)]
        return [self.single(U, parts)]

    def single(self, U, parts):
        P = self.prec
        a = [conv_arg(p, P) for p in parts]
        return U + (' ' + ','.join(a) if a else '')

    def data_arg(self, p):
        p = p.strip()
        if p.startswith('"'):
            s = p[1:p.rindex('"')]
            if len(s) > 2 or len(s) == 0:
                return p
        return conv_operand(p, self.prec)

    # statement list of one line -> text lines
    def statements(self, body):
        """return list of converted statements (strings) for one line body (without comment)"""
        out = []
        for st in split_top(body, ':'):
            s = st.strip()
            if not s:
                continue
            m = re.match(r"^(_?)([A-Za-z]+)(?:\s+(.*))?$", s)
            if not m:
                raise ExprError('cannot parse statement %r' % s)
            mn = m.group(2)
            ops = m.group(3) or ''
            if m.group(1) and mn.upper() not in MNALL:
                raise ExprError('bad _ statement %r' % s)
            out.extend(self.stat1(mn, ops))
        return out

    def stat1(self, mn, ops):
        U = mn.upper()
        if U == 'ORG':
            parts = split_top(ops, ',')
            res = []
            if self.disp:
                res.append('ENT'); self.disp = False
            if len(parts) == 2:
                res.append('ORG ' + conv_operand(parts[1], self.prec))
                res.append('DISP ' + conv_operand(parts[0], self.prec))
                self.disp = True
            else:
                res.append('ORG ' + conv_operand(parts[0], self.prec))
            return res
        if U == 'INCL' or U == 'INCB':
            nm = ops.strip().strip('"')
            f = self.names.get(('L' if U == 'INCL' else 'B') + nm) or (nm + '.asm' if U == 'INCL' else nm + '.bin')
            return ['%s "%s"' % ('INCLUDE' if U == 'INCL' else 'INCBIN', f)]
        if U == 'EIF': return ['ENDIF']
        if U == 'IFD': return ['IFDEF ' + conv_operand(ops, self.prec)]
        if U == 'IFND': return ['IFNDEF ' + conv_operand(ops, self.prec)]
        if U == 'IFU': return ['IFUSED ' + conv_operand(ops, self.prec)]
        if U == 'IFNU': return ['IFNUSED ' + conv_operand(ops, self.prec)]
        if U == 'IF': return ['IF ' + conv_operand(ops, self.prec)]
        if U == 'ELSE': return ['ELSE']
        if U in ('REPT',): return ['DUP ' + conv_operand(ops, self.prec)]
        if U in ('ENDR',): return ['EDUP']
        return self.instr(mn, ops)

    def line(self, raw):
        """convert one source line -> list of output lines"""
        self.lineno += 1
        raw = raw.rstrip('\r\n')
        if not raw.strip():
            return ['']
        if raw[0] == ';':
            return [raw]
        body, com = split_comment(raw)
        label = None
        rep = None
        if not body[0].isspace():
            m = re.match(r'[^\s:]+', body)
            tok = m.group()
            rest = body[m.end():]
            mrep = re.match(r'^\.(\d+)$', tok)
            mu = re.match(r'^_([A-Za-z]+)(?=[:]|$)', tok)
            if mrep:
                rep = int(mrep.group(1)); body = rest
            elif mu and mu.group(1).upper() in MNALL and not rest.lstrip().upper().startswith('EQU'):
                body = ' ' + body[1:]          # '_' = not tabulated instruction
            else:
                label = tok; body = rest
                mrep = re.match(r'^\s+\.(\d+)\s', body)
        indent = '        '
        if label is not None:
            lbl = lab(label)
            m = re.match(r'^\s*EQU\s+(.*)$', body, re.I)
            if m:
                e = conv_operand(m.group(1), self.prec)
                return ['%-8sEQU %s%s' % (lbl, e, (' ' + com) if com else '')]
            m = re.match(r'^\s*=\s+(.*)$', body)
        sts = self.statements(body)
        if rep is not None:
            res = ['%sDUP %d' % (indent, rep)] + [indent + '    ' + s for s in sts] + [indent + 'EDUP']
            if com: res[0] += ' ' + com
            return res
        if label is not None:
            lbl = lab(label)
            if not sts:
                return [lbl + (' ' + com if com else '')]
            first = sts[0]
            if ' ' not in lbl and len(lbl) < 8 and not first.startswith(('DISP', 'ENT', 'ORG', 'INCLUDE', 'INCBIN')):
                res = ['%-8s%s' % (lbl, first)]
            else:
                res = [lbl, indent + first]
            res += [indent + s for s in sts[1:]]
            if com: res[-1] += ' ' + com
            return res
        if not sts:
            return [com]
        res = [indent + s for s in sts]
        if com: res[-1] += ' ' + com
        return res

    def convert(self, text):
        out = []
        for ln in text.split('\n'):
            try:
                out.extend(self.line(ln))
            except ExprError as ex:
                self.warn('line %d: %s : %s' % (self.lineno, ex, ln))
                out.append('; !!STORM-UNCONVERTED: ' + ln)
        if self.disp:
            out.append('        ENT'); self.disp = False
        while out and out[-1] == '':
            out.pop()
        return '\n'.join(out) + '\n'


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('inp'); ap.add_argument('out')
    ap.add_argument('--ltr', action='store_true')
    a = ap.parse_args()
    ws = []
    text = open(a.inp, encoding='utf8').read()
    c = Conv(prec=not a.ltr, warn=ws.append)
    open(a.out, 'w', encoding='utf8', newline='\n').write(c.convert(text))
    for w in ws: print('WARN', w)


if __name__ == '__main__':
    main()
