#!/usr/bin/env python3
"""STORM assembler (type C, start #C00B) tokenized source -> text.
Python port of detokenizeStorm() from ZX-M8XXX core/asm-detok.js (algorithm after Dmitry Kozlov's FAR plugin)."""
import sys

T = ['ORG', 'EQU', 'DI', 'EI', 'EXA', 'NOP', 'CCF', 'SCF',
     'CPL', 'DAA', 'EXX', 'RLA', 'RRA', 'RLCA', 'RRCA', 'HALT',
     'LDI', 'LDD', 'LDIR', 'LDDR', 'CPI', 'CPD', 'CPIR', 'CPDR',
     'INI', 'IND', 'INIR', 'INDR', 'OUTI', 'OUTD', 'OTIR', 'OTDR',
     'NEG', 'RLD', 'RRD', 'INF', 'RETI', 'RETN', '', 'B',
     'C', 'D', 'E', 'H', 'L', '(HL)', 'A', 'HX',
     'LX', 'HY', 'LY', 'BC', 'DE', 'HL', 'SP', '',
     'DEFB', 'DEFW', 'DEFS', "AF'", 'XH', 'XL', 'YH', 'YL',
     '', 'LD', 'INC', 'DEC', 'EX', 'JR', 'DJNZ', 'JP',
     'CALL', 'RET', 'POP', 'PUSH', 'ADD', 'ADC', 'SUB', 'SBC',
     'AND', 'OR', 'XOR', 'CP', 'IN', 'OUT', 'BIT', 'RES',
     'SET', 'RLC', 'RRC', 'RL', 'RR', 'SLA', 'SRA', 'SLI',
     'SRL', 'IM', 'RST', 'DB', 'DW', 'DS', 'IX', 'IY',
     '(BC)', '(DE)', 'I', 'R', 'AF', '(SP)', '(C)', 'NZ',
     'Z', 'NC', 'C', 'PO', 'PE', 'P', 'M', 'INCL',
     'INCB', 'REPT', 'ENDR', 'IF', 'IFU', 'IFNU', 'IFD', 'IFND',
     'ELSE', 'EIF', 'ENDM']
AR = ['+', '-', '*', '/', '\\', '&', '!', '|', '<<', '>>', '<=', '>=', '<', '>', '=',
      '[', ']', '^', '`', '?', '~', '@', "'"]


def c866(b):
    return bytes([b]).decode('cp866')


def detok(B):
    warnings = []
    lines = []
    p = len(B) - 1
    while p > 0:
        ln = B[p] & 0x3F
        lines.append((p - ln, ln))
        p -= ln + 1
    if p < -1:
        warnings.append('line table does not align')
    lines.reverse()
    result = []
    bail = [0]
    for start, ln in lines:
        if start < 0:
            continue
        out = []

        def o(s):
            out.append(s)

        def cur():
            return ''.join(out)
        i = start
        lend = start + ln

        def fill_to(n):
            s = cur()
            if len(s) < n:
                out.append(' ' * (n - len(s)))

        def print_string(j, comment):
            while j < len(B) and B[j]:
                b = B[j]
                if b <= 0x1f:
                    o(' ' * b)
                else:
                    o(c866(b) if comment else chr(b))
                j += 1
            return j + 1

        def print_label(j):
            b = B[j]
            if b == 0xDA:
                o('_')
            elif b > 0xDA:
                o('=')
            else:
                o(chr(b - 0x7F))
            while True:
                j += 1
                c = B[j]
                cc = c & 0x3F
                if cc <= 9:
                    o(chr(0x30 + cc))
                elif cc == 0x0B:
                    o('_')
                elif cc == 0x0A:
                    pass
                elif cc < 0x26:
                    o(chr(cc - 0x0C + 0x41))
                else:
                    o(chr(cc - 0x26 + 0x61))
                if not (j < len(B) and c < 0x80):
                    break
            return j + 1

        def print_expr(j, op, number, depth=0):
            if depth > 64:
                bail[0] += 1
                return j
            while True:
                if number:
                    k = op & 7
                    if k == 0:
                        o('(')
                        if j >= len(B):
                            bail[0] += 1
                            return j
                        b = B[j]
                        j += 1
                        j = print_expr(j, b, not (op & 0x10), depth + 1)
                        o(')')
                    elif k == 1:
                        o('#%02X' % B[j]); j += 1
                    elif k == 2:
                        o(str(B[j])); j += 1
                    elif k == 3:
                        if B[j] < 0xC0:
                            b = B[j]; j += 1
                            if b == 0:
                                o('$')
                            else:
                                o('=' + chr(0x30 + ((b - 1) & 7)))
                        else:
                            j = print_label(j)
                    elif k == 4:
                        o('"')
                        if B[j+1] != 0:
                            o(chr(B[j+1]))
                        o(chr(B[j])); j += 2
                        o('"')
                    elif k == 5:
                        o('#%02X%02X' % (B[j+1], B[j])); j += 2
                    elif k == 6:
                        o(str(256 * B[j+1] + B[j])); j += 2
                    elif k == 7:
                        o('%')
                        if B[j+1] != 0:
                            o(format(B[j+1], '08b'))
                        o(format(B[j], '08b')); j += 2
                    number = False
                    if op & 8:
                        break
                    if j >= len(B):
                        bail[0] += 1
                        return j
                    op = B[j]; j += 1
                else:
                    saved = op
                    if (op & 0xF0) != 0xF0:
                        o(AR[(op & 0xF0) >> 4]); op = saved; number = True
                    else:
                        o(AR[0x0F + (op & 7)]); number = False
                        if saved & 8:
                            break
                        if j >= len(B):
                            bail[0] += 1
                            return j
                        op = B[j]; j += 1
            return j

        def print_command(j, indent):
            if indent:
                fill_to(8)
            b = B[j]
            if 0x09 <= b < 0x2F:
                o(T[b-9]); j += 1
            elif 0x2F < b < 0x40:
                o('LD')
            elif 0x40 <= b < 0x6F:
                if b == 0x49:
                    idx = B[j+1] + 0x80 - 9
                    o(T[idx] if idx < len(T) and T[idx] else '?'); j += 2
                else:
                    o(T[b-9]); j += 1
            elif 0x6F <= b < 0x75:
                o('LD')
            elif 0x75 <= b < 0x77:
                o('EX')
            elif b == 0x77:
                o('OUT')
            elif 0x77 < b < 0x7C:
                o('JR')
            elif 0x7C <= b < 0x80:
                o('CALL')
            elif 0x80 <= b < 0xDC:
                o('LD' if b & 0x20 else 'JR')
            elif b == 0xDC:
                o('DB')
            elif b > 0xDC:
                o('JR')
            return j

        if ln == 0:
            result.append('')
            continue
        if B[i] == 0x2F:
            o(';'); print_string(i + 1, True)
            result.append(cur())
            continue
        indent = True
        b0 = B[i]
        if 0xC0 <= b0 < 0xDC:
            if B[i+1] & 0x40:
                i = print_label(i)
        elif b0 == 6:
            o('_'); i += 1; indent = False
        elif b0 == 7:
            o('.%d' % B[i+1]); i += 2
        done = lend - i <= 0
        while not done:
            i = print_command(i, indent)
            indent = False
            sep = ' '
            while True:
                if lend - i <= 0:
                    done = True; break
                if B[i] == 0x2F:
                    o(';'); print_string(i + 1, True); done = True; break
                if B[i] < 0x80:
                    m = B[i] & 0x3F
                    if 0x2A <= m < 0x2F:
                        o([':', ' :', ' : ', ' :  ', '  : '][m - 0x2A]); i += 1
                        break
                o(sep); sep = ','
                b = B[i]
                if b < 0x80:
                    o(T[b-9] if b-9 < len(T) and T[b-9] else '?'); i += 1
                elif b < 0xC0:
                    e = B[i]; i += 1
                    nb = bool(e & 0x20)
                    if nb:
                        o('(')
                    number = True
                    if not nb:
                        number = not (e & 0x10)
                        if not number:
                            e &= 0x1F
                    if nb and (e & 0x10):
                        o('I' + ('Y' if e & 8 else 'X'))
                        e &= 7
                        if not e:
                            o(')')
                            continue
                        if (e & 3) == 0:
                            e = B[i]; i += 1
                        else:
                            if e & 4:
                                e = (e & 3) | 0x10
                            e |= 8
                        number = False
                    elif not number:
                        e &= 0x1F
                    i = print_expr(i, e, number)
                    if nb:
                        o(')')
                elif b <= 0xDB:
                    i = print_label(i)
                elif b == 0xDC:
                    o('"'); i = print_string(i + 1, False); o('"')
                elif b <= 0xE6:
                    o(chr(b - 0xAD)); i += 1
                else:
                    o('$')
                    if b < 0xF3:
                        o('-%d' % (0xF3 - b))
                    elif b > 0xF3:
                        o('+%d' % (b - 0xF3))
                    i += 1
        result.append(cur())
    if bail[0]:
        warnings.append('expression decoding stopped early %d times' % bail[0])
    return '\n'.join(result) + '\n', warnings


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    t, w = detok(open(sys.argv[1], 'rb').read())
    sys.stdout.write(t)
    for x in w:
        sys.stderr.write(x + '\n')
