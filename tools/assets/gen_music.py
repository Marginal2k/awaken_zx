#!/usr/bin/env python3
"""assets/music/pt3player.bin + assets/music/station.pt3  ->  build/gen/MUZ1.C  (the station music bank file: player, then the module directly after it).
station.pt3 is a normal ProTracker 3.x module ("ProTracker 3.4 compilation of Virtual Agression by Mast/FtL 24.03.99") that any PT3 player plays.
pt3player.bin is the 3617-byte player "PT3 Player v1.0 by Nick of GDC" (code + its tables) as it was in the game, loaded at #DB00; its first instruction
is ld hl,#E921 = #DB00 + 3617: the module address is built into the player, so the module must follow the player directly (its size may change; it has to
fit below #FFFF)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
PLAYER_LEN = 3617
BASE = 0xDB00


def generate(root, outdir):
    d = os.path.join(root, 'assets', 'music')
    pl = open(os.path.join(d, 'pt3player.bin'), 'rb').read()
    mod = open(os.path.join(d, 'station.pt3'), 'rb').read()
    if len(pl) != PLAYER_LEN:
        raise SystemExit('pt3player.bin must be %d bytes (the module address #%04X is built into the player)' % (PLAYER_LEN, BASE + PLAYER_LEN))
    if not mod.startswith(b'ProTracker 3.'):
        raise SystemExit('station.pt3: not a ProTracker 3 module (header "ProTracker 3." expected)')
    if BASE + len(pl) + len(mod) > 0x10000:
        raise SystemExit('station.pt3 is too big: the player and the module must end below #FFFF (module at most %d bytes)' % (0x10000 - BASE - len(pl)))
    os.makedirs(outdir, exist_ok=True)
    open(os.path.join(outdir, 'MUZ1.C'), 'wb').write(pl + mod)
    return 1


if __name__ == '__main__':
    root = os.path.join(HERE, '..', '..')
    print('gen_music: %d file' % generate(root, os.path.join(root, 'build', 'gen')))
