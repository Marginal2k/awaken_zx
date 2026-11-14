#!/usr/bin/env python
"""regress.py - full regression of the Awaken build in Xpeccy+ (coder).

    python tools/xp/regress.py                      # build + verify_original + all scenarios on both configs + stability
    python tools/xp/regress.py --conf pent128       # one config only (pent512 = work/xpconf, pent128 = work/xpconf128)
    python tools/xp/regress.py --only scr_,flight   # only tests whose name starts with one of the prefixes
    python tools/xp/regress.py --no-build --no-stab # reuse build/, skip the 12000-frame stability runs

Output: work/coder/reg/<conf>/ (PNG shots, .szx snapshots, _scen/ = the rewritten scenarios), the table in
work/coder/reg/REPORT.md (also printed).  Never kills processes by name; the emulator is run one at a time through tools/xp/run.py.

A test = a chain of scenario runs (tools/scen/*.txt, tools/xp/scen/*.txt), some with a RAM poke (tools/scen/szxpoke.py) in between,
plus automatic checks on the final snapshot / screenshots:
  pc      PC >= #4000 in the final snapshot (not in ROM = no reset / crash)      shot  picture is not blank
  station / flight   the button strip (cyan) / the green panel is visible       mem   a RAM value (credits ...)
  diff    the shot differs from a reference shot (a key has an effect, a window opened, ...)
"""
import argparse, glob, os, re, subprocess, sys, time
sys.path.insert(0, os.path.dirname(__file__))
import szxinfo
from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
PY = sys.executable
CONFS = {'pent512': 'work/xpconf', 'pent128': 'work/xpconf128'}
STATION_CREDITS = 0x984C          # TIME + #11 (station), little endian
START_CREDITS = 23930             # 24000 minus the 70 cr docking fee charged by the welcome window

# ---------------------------------------------------------------- helpers
def sh(cmd, **kw):
    return subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, **kw)

def png_stats(path):
    im = Image.open(path).convert('RGB'); px = im.load(); w, h = im.size
    nonblack = cyan = green = 0
    for y in range(h):
        for x in range(w):
            r, g, b = px[x, y]
            if r or g or b: nonblack += 1
            if y in range(224, 251) and (r, g, b) == (0, 187, 187): cyan += 1      # station button strip
            if 160 <= y <= 260 and g > 150 and r < 60 and b < 60: green += 1       # flight panel
    return dict(nonblack=nonblack, station=cyan > 4000, flight=green > 1500, cyan=cyan, green=green)

def png_same(a, b):
    return Image.open(a).convert('RGB').tobytes() == Image.open(b).convert('RGB').tobytes()

def snap(path):
    d, bl, pages = szxinfo.parse(path)
    r = szxinfo.regs(bl[b'Z80R']); p7 = bl[b'SPCR'][1]
    rd = szxinfo.cpu_mem(pages, p7)
    return dict(pc=r['PC'], sp=r['SP'], p7=p7, rd=rd, bl=bl)

def rd16(s, a): return s['rd'](a) | s['rd'](a + 1) << 8

class Ctx:
    def __init__(self, conf, outdir, a):
        self.conf, self.out, self.a = conf, outdir, a
        os.makedirs(os.path.join(outdir, '_scen'), exist_ok=True)
        self.log = []
    def p(self, name): return os.path.join(self.out, name)
    def rel(self, path): return os.path.relpath(path, ROOT).replace('\\', '/')

    def scen(self, path, subs=None, timeout=None, append=''):
        """run a scenario with path rewrites (work/xp_ours/ -> this out dir ...); returns (ok, text)"""
        txt = open(os.path.join(ROOT, path), encoding='utf8').read()
        out = self.rel(self.out)
        txt = txt.replace('work/xp_ours/', out + '/').replace('work/awaken_test_return.trd', 'build/awaken_test_return.trd')
        for k, v in (subs or {}).items(): txt = txt.replace(k, v)
        txt += append
        tmp = os.path.join(self.out, '_scen', os.path.basename(path))
        open(tmp, 'w', encoding='utf8').write(txt)
        cmd = [PY, 'tools/xp/run.py', self.rel(tmp), '-o', out, '--conf', CONFS[self.conf]]
        if timeout: cmd += ['--timeout', str(timeout)]
        r = sh(cmd)
        text = r.stdout + r.stderr
        self.log.append(f'$ run.py {path}\n{text}')
        bad = [l for l in text.splitlines() if re.search(r'TIMEOUT|not loaded', l)]
        nseg = len(re.findall(r'\[seg \d+\] run', text))
        okc = len(re.findall(r'rc=0', text))
        want = sum(1 for l in txt.splitlines() if l.split('#')[0].strip().startswith('run '))
        ok = r.returncode == 0 and okc == want
        return ok, (f'{okc}/{want} segments ok' + (f', {len(bad)} timeout retries' if bad else ''))

    def poke(self, a, b, *args):
        r = sh([PY, 'tools/scen/szxpoke.py', self.rel(self.p(a)), self.rel(self.p(b)), *args])
        return r.returncode == 0, (r.stdout + r.stderr).strip()

class Res:
    def __init__(self, name): self.name, self.ok, self.ev, self.shots = name, True, [], []
    def chk(self, cond, msg, shot=None):
        self.ev.append(('' if cond else 'FAIL: ') + msg); self.ok &= bool(cond)
        if shot: self.shots.append(shot)
    def note(self, msg, shot=None):
        self.ev.append(msg)
        if shot: self.shots.append(shot)

def check_snap(c, r, name, expect_pc_ram=True):
    s = snap(c.p(name + '.szx'))
    r.chk(s['pc'] >= 0x4000, f'{name}.szx PC={s["pc"]:04X} #7FFD={s["p7"]:02X}' + ('' if s['pc'] >= 0x4000 else ' (IN ROM: reset/crash)'))
    return s

def check_shot(c, r, name, kind=None, same_as=None, differs_from=None):
    pth = c.p(name + '.png')
    if not os.path.exists(pth): r.chk(False, f'{name}.png missing'); return None
    st = png_stats(pth)
    r.chk(st['nonblack'] > 2500, f'{name}.png nonblack={st["nonblack"]}', c.rel(pth))
    if kind == 'station': r.chk(st['station'], f'{name}.png station buttons visible (cyan={st["cyan"]})')
    if kind == 'flight': r.chk(st['flight'], f'{name}.png flight panel visible (green={st["green"]})')
    if differs_from:
        o = c.p(differs_from + '.png')
        r.chk(os.path.exists(o) and not png_same(pth, o), f'{name}.png differs from {differs_from}.png')
    return st

# ---------------------------------------------------------------- tests
def t_intro(c):
    r = Res('intro'); ok, m = c.scen('tools/scen/ours_intro.txt', timeout=180); r.chk(ok, m)
    check_shot(c, r, 'in_0800'); check_shot(c, r, 'in_1400'); s = check_snap(c, r, 'intro')
    st = png_stats(c.p('in_2000.png')); r.chk(not st['station'], 'in_2000.png: no station yet (closing picture of the intro)', c.rel(c.p('in_2000.png')))
    check_shot(c, r, 'in_3500', 'station'); check_shot(c, r, 'in_5000', 'station'); return r

def t_intro_skip(c):
    r = Res('intro_skip'); ok, m = c.scen('tools/xp/scen/ours_intro_skip.txt', timeout=180); r.chk(ok, m)
    check_shot(c, r, 'is_1000')
    r.chk(png_same(c.p('is_1060.png'), c.p('in_2000.png')), 'is_1060.png = the closing picture right after SPACE (identical to in_2000.png of the unskipped run; there the nebula (in_1400.png) still runs at 1400 and the closing picture appears only at ~2000)', c.rel(c.p('is_1060.png')))
    check_shot(c, r, 'is_3000', 'station')
    check_shot(c, r, 'is_4000', 'station'); check_snap(c, r, 'intro_skip'); return r

def t_station(c):
    r = Res('station_boot_map'); ok, m = c.scen('tools/scen/ours_station.txt', timeout=120); r.chk(ok, m)
    check_shot(c, r, 'station_boot', 'station'); check_shot(c, r, 'station_cursor', 'station')
    check_shot(c, r, 'station_click1', 'station', differs_from='station_cursor')
    check_shot(c, r, 'station_map', differs_from='station_back')
    check_shot(c, r, 'station_back', 'station'); check_shot(c, r, 'station_idle3000', 'station')
    s = check_snap(c, r, 'station_final'); r.chk(rd16(s, STATION_CREDITS) == START_CREDITS, f'credits {rd16(s, STATION_CREDITS)}'); return r

SCR = ['help', 'map', 'goods', 'abonent', 'news', 'contract', 'ship', 'skimmer', 'equip', 'equipskim']
def t_scr(c, n):
    r = Res('scr_' + n); ok, m = c.scen(f'tools/xp/scen/ours_scr_{n}.txt', timeout=120); r.chk(ok, m)
    b = f'scr_{n}_'
    check_shot(c, r, b + '0boot', 'station')
    check_shot(c, r, b + '2open', differs_from=b + '1cursor')
    if n == 'map':
        check_shot(c, r, b + '3page'); check_shot(c, r, b + '4cover', differs_from=b + '3page')
        r.note('the map is a full-screen window: M does nothing there; it is covered by clicking the station button visible at the right edge (Оснащение скиммера window opens)')
    else:
        check_shot(c, r, b + '4closed', 'station')
    s = check_snap(c, r, 'scr_' + n); return r

def t_flight(c):
    r = Res('flight_launch'); ok, m = c.scen('tools/scen/ours_flight.txt', timeout=120); r.chk(ok, m)
    check_shot(c, r, 'fl_station', 'station');  check_shot(c, r, 'fl_after2100', 'flight')
    check_snap(c, r, 'fl_state'); return r

def t_fkeys(c):
    """each key run is compared with the control run (no key, same frames) in RAM: flight state #9B00-#9BBC (angles/matrix/laser),
    object table #A200-#A23F (the station moves when the ship turns) and Speed #A88F (throttle)"""
    r = Res('flight_keys')
    ok, m = c.scen('tools/xp/scen/ours_fkey_ctrl.txt'); r.chk(ok, 'ctrl: ' + m)
    base = snap(c.p('fkey_ctrl.szx'))
    def n(sn, lo, hi): return sum(1 for a in range(lo, hi) if sn['rd'](a) != base['rd'](a))
    for k, label in [('a', 'A laser'), ('s', 'S pitch'), ('x', 'X pitch'), ('n', 'N roll'), ('m', 'M roll'), ('space', 'Space throttle')]:
        ok, m = c.scen(f'tools/xp/scen/ours_fkey_{k}.txt'); r.chk(ok, f'{k}: {m}')
        check_shot(c, r, f'fkey_{k}', 'flight'); sn = check_snap(c, r, f'fkey_{k}')
        st, ob, sp = n(sn, 0x9B00, 0x9BBD), n(sn, 0xA200, 0xA240), n(sn, 0xA88F, 0xA890)
        if k == 'space': r.chk(sp > 0, f'{label}: Speed #A88F {base["rd"](0xA88F):02X} -> {sn["rd"](0xA88F):02X}')
        else: r.chk(st + ob > 0, f'{label}: {st} state bytes / {ob} object bytes differ from the control run')
    return r

def t_dock(c):
    r = Res('dock_relaunch_dock2')
    ok, m = c.poke('fl_state.szx', 'fl_dock.szx', 'DOCK', '9BCE=217C', '9BD1=4D'); r.chk(ok, 'szxpoke DOCK + credits 31777')
    ok, m = c.scen('tools/scen/ours_dock.txt', timeout=120); r.chk(ok, m)
    check_shot(c, r, 'dk_c', 'station'); s = check_snap(c, r, 'dk_state')
    cr = rd16(s, STATION_CREDITS); r.chk(cr == 31777, f'credits after the 1st docking {cr} (expect 31777 = the value poked in flight, carried)')
    ok, m = c.scen('tools/scen/ours_relaunch.txt', timeout=120); r.chk(ok, m)
    check_shot(c, r, 'rl_flight', 'flight'); check_snap(c, r, 'rl_state')
    ok, m = c.poke('rl_state.szx', 'rl_dock.szx', 'DOCK'); r.chk(ok, 'szxpoke DOCK (2nd flight)')
    ok, m = c.scen('tools/scen/ours_dock2.txt', timeout=120, append='save dk2_state\n'); r.chk(ok, m)
    check_shot(c, r, 'dk2_b', 'station'); s = check_snap(c, r, 'dk2_state')
    cr = rd16(s, STATION_CREDITS); r.chk(cr == 31707, f'credits after the 2nd docking {cr} (expect 31707 = 31777 - 70 fee, ANALYSIS 13.1)')
    return r

def t_save(c):
    r = Res('save_load')
    ok, m = c.scen('tools/scen/ours_save1.txt', timeout=120); r.chk(ok, 'save1: ' + m)
    check_shot(c, r, 'sv_menu', 'station'); check_shot(c, r, 'sv_save_win', differs_from='sv_menu')
    ok, m = c.poke('sv_win.szx', 'sv_win2.szx', '984C=217C'); r.chk(ok, 'poke credits 31777')
    ok, m = c.scen('tools/scen/ours_save2.txt', timeout=120); r.chk(ok, 'save2: ' + m)
    check_shot(c, r, 'sv_item2'); check_shot(c, r, 'sv_saved', 'station')
    s = check_snap(c, r, 'sv_saved')
    # the written record is visible in the disk image inside the snapshot (BDSK chunk, zlib after a 7-byte header)
    import zlib
    raw = open(c.p('sv_saved.szx'), 'rb').read(); i = raw.index(b'BDSK'); l = int.from_bytes(raw[i+4:i+8], 'little')
    img = zlib.decompress(raw[i + 8 + 7:i + 8 + l])
    trd = open(os.path.join(ROOT, 'build/awaken_nointro.trd'), 'rb').read()
    cat = [trd[k*16:k*16+16] for k in range(128)]
    e = [x for x in cat if x[:5] == b'SAVE2'][0]; sec = e[15] * 16 + e[14]
    rec = trd[sec*256:sec*256+512]
    # the record header (clock) differs, credits are at +#11: compare from the credits on
    r.chk(img.count(b'!|' + rec[0x13:0x30]) == 1, 'SAVE2 record with credits 31777 (21 7C at +#11) was written into the snapshot disk image (SAVE0..5 initial records hold 25000)')
    # load: SAVE2 pre-filled with the saved record (harness limit: disk writes do not survive a segment boundary)
    import shutil
    b = bytearray(trd); b[sec*256 + 0x11:sec*256 + 0x13] = bytes([0x21, 0x7C])
    slot = c.p('slot2.trd'); open(slot, 'wb').write(b)
    ok, m = c.scen('tools/scen/ours_load.txt', subs={'work/awaken_slot2.trd': c.rel(slot)}, timeout=120); r.chk(ok, 'load: ' + m)
    check_shot(c, r, 'ld_win'); check_shot(c, r, 'ld_loaded', 'station'); s = check_snap(c, r, 'ld_loaded')
    cr = rd16(s, STATION_CREDITS); r.chk(cr == 30777, f'credits after load = {cr} (expect 30777 = 31777 loaded - 1000 fine of the "Внимание" start window, see ld_loaded.png)')
    r.note('save and load verified in two steps (known harness limit: disk writes do not cross an .szx segment)'); return r

def t_return(c):
    r = Res('test_return_build'); ok, m = c.scen('tools/scen/ours_return_test.txt', timeout=120); r.chk(ok, m)
    check_shot(c, r, 'rr_c', 'station'); check_snap(c, r, 'rr'); return r

def t_ending(c):
    r = Res('test_ending_build'); ok, m = c.scen('tools/scen/ours_ending_test.txt', timeout=120); r.chk(ok, m)
    check_shot(c, r, 'end_c'); check_snap(c, r, 'end')
    st = png_stats(c.p('end_c.png')); r.chk(not st['station'] and not st['flight'], 'end_c.png is neither station nor flight (ending screen)'); return r

def t_stab_st(c):
    r = Res('stab_station_12200f'); ok, m = c.scen('tools/xp/scen/ours_stab_station.txt', timeout=180); r.chk(ok, m)
    check_shot(c, r, 'stab_st_04'); check_shot(c, r, 'stab_st_09'); s = check_snap(c, r, 'stab_station')
    st = png_stats(c.p('stab_st_09.png')); r.note(f'final picture: station={st["station"]} flight={st["flight"]}'); return r

def t_stab_fl(c):
    r = Res('stab_flight_10000f'); ok, m = c.scen('tools/xp/scen/ours_stab_flight.txt', timeout=180); r.chk(ok, m)
    for n in ('stab_fl_02', 'stab_fl_05', 'stab_fl_09'): check_shot(c, r, n)
    check_snap(c, r, 'stab_flight')
    st = png_stats(c.p('stab_fl_09.png')); r.note(f'final picture: station={st["station"]} flight={st["flight"]}'); return r

def tests(a):
    T = [t_intro, t_intro_skip, t_station] + [(lambda c, n=n: t_scr(c, n)) for n in SCR] + [t_flight, t_fkeys, t_dock, t_save, t_return, t_ending]
    names = ['intro', 'intro_skip', 'station_boot_map'] + ['scr_' + n for n in SCR] + ['flight_launch', 'flight_keys', 'dock_relaunch_dock2', 'save_load', 'test_return_build', 'test_ending_build']
    if not a.no_stab: T += [t_stab_st, t_stab_fl]; names += ['stab_station_12200f', 'stab_flight_10000f']
    return list(zip(names, T))

# ---------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--conf', default='both'); ap.add_argument('--only', default='')
    ap.add_argument('--no-build', action='store_true'); ap.add_argument('--no-stab', action='store_true')
    ap.add_argument('--out', default='work/coder/reg'); a = ap.parse_args()
    t0 = time.time(); rows = []; head = []
    if not a.no_build:
        for args in ([], ['--test-return'], ['--test-ending']):
            r = sh([PY, 'build.py'] + args); head.append((f'build.py {" ".join(args)}'.strip(), r.returncode == 0, (r.stdout.strip().splitlines() or [''])[-1]))
        r = sh([PY, 'tools/verify_original.py', 'all']); n = r.stdout.count('BYTE-EXACT')
        head.append(('verify_original.py all', r.returncode == 0 and n == 11 and 'DIFF' not in r.stdout, f'{n} x BYTE-EXACT (expect 11)'))
    for h in head: print(('PASS ' if h[1] else 'FAIL ') + h[0] + ' - ' + h[2], flush=True)
    only = [x for x in a.only.split(',') if x]
    for conf in (CONFS if a.conf == 'both' else [a.conf]):
        out = os.path.join(ROOT, a.out, conf); c = Ctx(conf, out, a)
        for name, fn in tests(a):
            if only and not any(name.startswith(o) for o in only): continue
            t1 = time.time()
            try: r = fn(c)
            except Exception as e:
                r = Res(name); r.chk(False, f'exception {type(e).__name__}: {e}')
            rows.append((name, conf, r)); print(f'{"PASS" if r.ok else "FAIL"} {conf:8} {name}  ({time.time()-t1:.0f}s)', flush=True)
            for e in r.ev:
                if e.startswith('FAIL'): print('     ', e, flush=True)
        open(os.path.join(out, 'regress.log'), 'w', encoding='utf8').write('\n'.join(c.log))
    # merge with the previous results (a partial --only run updates its rows only), write the report
    import json
    jp = os.path.join(ROOT, a.out, 'results.json')
    old = json.load(open(jp, encoding='utf8')) if os.path.exists(jp) else {'head': [], 'rows': {}}
    if head: old['head'] = head
    for name, conf, r in rows: old['rows'][f'{conf}|{name}'] = dict(name=name, conf=conf, ok=r.ok, ev=r.ev)
    json.dump(old, open(jp, 'w', encoding='utf8'), ensure_ascii=False, indent=1)
    head = old['head']; allrows = sorted(old['rows'].values(), key=lambda x: (list(CONFS).index(x['conf']), x['name']))
    order = [n for n, _ in tests(a)]
    allrows.sort(key=lambda x: (list(CONFS).index(x['conf']), order.index(x['name']) if x['name'] in order else 99))
    L = ['| step | result | evidence |', '|---|---|---|']
    for h in head: L.append(f'| {h[0]} | {"PASS" if h[1] else "FAIL"} | {h[2]} |')
    L += ['', '| scenario | config | result | evidence (shots under work/coder/reg/<config>/) |', '|---|---|---|---|']
    def brief(ev):
        keep = [e for e in ev if not re.search(r'nonblack=\d+$|visible \(cyan|visible \(green|segments ok$|differs from', e) or e.startswith('FAIL')]
        nshot = sum(1 for e in ev if 'nonblack=' in e)
        return '; '.join(e.replace('|', '/') for e in keep) + f'; {nshot} shots checked'
    for x in allrows:
        L.append(f'| {x["name"]} | {x["conf"]} | {"PASS" if x["ok"] else "FAIL"} | ' + brief(x['ev']) + ' |')
    L.append(''); L.append(f'{sum(x["ok"] for x in allrows)}/{len(allrows)} scenarios PASS (this invocation {time.time()-t0:.0f}s)')
    open(os.path.join(ROOT, a.out, 'REPORT.md'), 'w', encoding='utf8').write(chr(10).join(L) + chr(10))
    print(chr(10).join(L))
    return 0 if all(x['ok'] for x in allrows) and all(h[1] for h in head) else 1

if __name__ == '__main__':
    sys.exit(main())
