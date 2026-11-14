#!/usr/bin/env python3
"""List a ZX Spectrum BASIC program (TR-DOS 'B' file: program + 4 byte autostart/vars trailer) as text."""
import sys, struct
KW = ['SPECTRUM', 'PLAY', 'RND', 'INKEY$', 'PI', 'FN ', 'POINT ', 'SCREEN$ ', 'ATTR ', 'AT ', 'TAB ', 'VAL$ ', 'CODE ', 'VAL ', 'LEN ',
      'SIN ', 'COS ', 'TAN ', 'ASN ', 'ACS ', 'ATN ', 'LN ', 'EXP ', 'INT ', 'SQR ', 'SGN ', 'ABS ', 'PEEK ', 'IN ', 'USR ', 'STR$ ',
      'CHR$ ', 'NOT ', 'BIN ', ' OR ', ' AND ', '<=', '>=', '<>', ' LINE ', ' THEN ', ' TO ', ' STEP ', ' DEF FN ', ' CAT ', ' FORMAT ',
      ' MOVE ', ' ERASE ', ' OPEN #', ' CLOSE #', ' MERGE ', ' VERIFY ', ' BEEP ', ' CIRCLE ', ' INK ', ' PAPER ', ' FLASH ', ' BRIGHT ',
      ' INVERSE ', ' OVER ', ' OUT ', ' LPRINT ', ' LLIST ', ' STOP ', ' READ ', ' DATA ', ' RESTORE ', ' NEW ', ' BORDER ', ' CONTINUE ',
      ' DIM ', ' REM ', ' FOR ', ' GO TO ', ' GO SUB ', ' INPUT ', ' LOAD ', ' LIST ', ' LET ', ' PAUSE ', ' NEXT ', ' POKE ', ' PRINT ',
      ' PLOT ', ' RUN ', ' SAVE ', ' RANDOMIZE ', ' IF ', ' CLS ', ' DRAW ', ' CLEAR ', ' RETURN ', ' COPY ']

def listing(d):
    out = []
    i = 0
    while i + 4 <= len(d):
        ln = (d[i] << 8) | d[i+1]
        if d[i] == 0x80 or ln > 9999: break
        L = d[i+2] | d[i+3] << 8
        body = d[i+4:i+4+L]
        i += 4 + L
        s = ''
        j = 0
        while j < len(body):
            c = body[j]
            if c == 0x0e: j += 6; continue
            if c == 0x0d: break
            if c >= 0xa3: s += KW[c - 0xa3]
            elif c >= 0x20: s += chr(c) if c < 0x7f else {0x7f: '(c)', 0x60: 'GBP'}.get(c, '?')
            else: s += '{%02x}' % c
            j += 1
        out.append('%d%s' % (ln, (' ' if not s.startswith(' ') else '') + s.replace('  ', ' ')))
    return '\n'.join(out)

if __name__ == '__main__':
    d = open(sys.argv[1], 'rb').read()
    print(listing(d))
