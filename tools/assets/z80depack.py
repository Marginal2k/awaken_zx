"""Runs the REAL game depacker (station DEPACK, bytes in depack.bin) in the `zx` Z80 core: reference decoder for tools/assets/hrust.py."""
import os, warnings
warnings.filterwarnings('ignore')
HERE = os.path.dirname(os.path.abspath(__file__))


def depack(packed, load=0x9FF7, src=0x6000, dst=0x4000):
    import zx
    s = zx.Spectrum()
    s.reset_and_wait()
    s.write(load, open(os.path.join(HERE, 'depack.bin'), 'rb').read())
    s.write(src, bytes(packed))
    s.write(0xB000, bytes([0x18, 0xFE]))
    s.iff1 = False; s.iff2 = False
    s.sp = 0xBF00
    s.write(0xBF00, bytes([0x00, 0xB0]))
    s.hl = src; s.de = dst; s.pc = load
    s.run(duration=0.6, fast_forward=True)
    n = packed[2] | packed[3] << 8
    return s.read(dst, n)
