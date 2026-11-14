#!/usr/bin/env python3
"""python build.py  ->  build/awaken.trd  (plain TR-DOS image; boots with RUN / boot)"""
import os, sys, subprocess, shutil
ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, ROOT + '/tools')
from trd import Trd
SJ = shutil.which('sjasmplus') or r'C:\sjasmplus\sjasmplus.exe'
B = ROOT + '/build'


def die(msg):
    print('BUILD FAILED:', msg); sys.exit(1)


def asm(src, cwd, extra=()):
    r = subprocess.run([SJ, '--nologo', '--msg=err', '-I', ROOT + '/assets'] + list(extra) + [src], cwd=cwd, capture_output=True, text=True)
    if r.returncode != 0 or 'error' in (r.stdout + r.stderr).lower():
        print(r.stdout + r.stderr); die('sjasmplus failed on ' + src)


def main():
    if os.path.exists(B): shutil.rmtree(B)
    os.makedirs(B + '/flight'); os.makedirs(B + '/station'); os.makedirs(B + '/boot')
    # symbol files + listings go to build/ (used by tools/xp/szxinfo.py --sym)
    asm(ROOT + '/src/flight/flight.asm', B + '/flight', ['--sym=../flight.sym', '--lst=../flight.lst'])
    asm(ROOT + '/src/station/station.asm', B + '/station', ['--sym=../station.sym', '--lst=../station.lst'])
    asm(ROOT + '/src/boot/boot.asm', B + '/boot', ['--sym=../boot.sym', '--lst=../boot.lst'])
    d = Trd(label='AWAKEN')
    # boot (BASIC) first so that RUN / boot picks it up
    boot = open(B + '/boot/AWAKEN.B', 'rb').read()
    d.add_file('boot', 'B', boot, start=len(boot) - 4, length=len(boot) - 4)
    def code(path, name, start):
        data = open(path, 'rb').read()
        d.add_file(name, 'C', data, start=start, length=len(data))
    code(B + '/station/STATIONF.C', 'STATIONF', 0x6000)
    code(B + '/station/LANG.C', 'LANG', 0xC000)
    code(B + '/station/D3D.C', 'D3D', 0xC000)
    code(B + '/station/KARTA.C', 'KARTA', 0xC000)
    code(B + '/station/HELP.C', 'HELP', 0xDB00)
    code(ROOT + '/assets/MUZ1.C', 'MUZ1', 0xDB00)
    # stscr = 16 packed pictures one after another (239 sectors, SECTAB in station/LOADER.asm); like the demo the catalogue
    # length is that of the first picture only (3230) while the sector count covers the whole file.
    d.add_file('stscr', 'C', open(ROOT + '/assets/stscr.C', 'rb').read(), start=0xC000, length=3230)
    code(B + '/flight/ACTION.C', 'ACTION', 0x6000)
    code(B + '/flight/VOXAL0.C', 'VOXAL0', 0xC000)
    code(B + '/flight/VOXAL.C', 'VOXAL', 0xEC00)
    code(B + '/flight/CONTROL0.C', 'CONTROL0', 0xC000)
    code(B + '/flight/CONTROL.C', 'CONTROL', 0xE013)
    code(B + '/flight/OBJECT3D.C', 'OBJECT3D', 0xC000)
    code(ROOT + '/assets/PANEL.C', 'PANEL', 0x6373)
    d.save(B + '/awaken.trd')
    print('OK build/awaken.trd')


main()
