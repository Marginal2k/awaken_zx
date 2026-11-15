#!/usr/bin/env python3
"""png_to_frame.py SHOT.png FRAME.json - replace the 72x72 viewer window (screen x 176, y 16) of FRAME.json's screen bitmap by the pixels of the emulator screenshot
(Pentagon screenshot: 2 image pixels per screen pixel horizontally, border 144 px left / 80 px top at that scale; cyan = lit).
Used when the SZX holds a frame that is not drawn yet (the viewer double-buffers) but the screenshot of the last frame is complete."""
import json, sys
import numpy as np
from PIL import Image
im = np.array(Image.open(sys.argv[1]).convert('RGB'))
lit = (im[:, :, 1] > 100).astype(np.uint8)
win = lit[80:80 + 72, 496:496 + 144:2]
fr = json.load(open(sys.argv[2]))
for y in range(72):
    for x in range(72):
        fr['screen'][16 + y][176 + x] = 1 - int(win[y, x])
json.dump(fr, open(sys.argv[2], 'w'))
print('window pixels lit:', int(win.sum()))
