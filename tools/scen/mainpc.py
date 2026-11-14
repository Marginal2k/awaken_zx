import sys,re
sys.path.insert(0,'tools/xp')
import szxinfo as S
syms=S.load_sym(sys.argv[1])
import re
STK7=[int(m.group(1),16) for l in open(sys.argv[1]) for m in [re.match(r'STK7: EQU 0x0000(\w+)',l)] if m][0]+1
for f in sys.argv[2:]:
    d,bl,pages=S.parse(f); r=S.regs(bl[b'Z80R']); p7=bl[b'SPCR'][1]; rd=S.cpu_mem(pages,p7)
    stk7=rd(STK7)|rd(STK7+1)<<8
    mp=rd(stk7)|rd(stk7+1)<<8
    print(f, 'PC=%04X SP=%04X mainSP=%04X mainPC=%04X %s'%(r['PC'],r['SP'],stk7,mp,S.name(syms,mp)), '#7FFD=%02X'%p7)
