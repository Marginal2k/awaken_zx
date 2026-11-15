import zlib from 'node:zlib';
const crcT = (() => { const t = []; for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; t[n] = c >>> 0; } return t; })();
const crc = (b) => { let c = 0xFFFFFFFF; for (const x of b) c = crcT[(c ^ x) & 255] ^ (c >>> 8); return (c ^ 0xFFFFFFFF) >>> 0; };
const chunk = (t, d) => { const b = Buffer.concat([Buffer.from(t), d]); const l = Buffer.alloc(4); l.writeUInt32BE(d.length); const c = Buffer.alloc(4); c.writeUInt32BE(crc(b)); return Buffer.concat([l, b, c]); };
// rgb: Uint8Array w*h*3
export function png(w, h, rgb) {
  const raw = Buffer.alloc((w * 3 + 1) * h);
  for (let y = 0; y < h; y++) { raw[y * (w * 3 + 1)] = 0; Buffer.from(rgb.buffer, rgb.byteOffset + y * w * 3, w * 3).copy(raw, y * (w * 3 + 1) + 1); }
  const ihdr = Buffer.alloc(13); ihdr.writeUInt32BE(w, 0); ihdr.writeUInt32BE(h, 4); ihdr[8] = 8; ihdr[9] = 2;
  return Buffer.concat([Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]), chunk('IHDR', ihdr), chunk('IDAT', zlib.deflateSync(raw)), chunk('IEND', Buffer.alloc(0))]);
}
// bitmaps: array of {w,h,get(x,y)->0/1 lit} placed side by side with a gap, scale s
export function sheet(items, s = 4, gap = 4) {
  const H = Math.max(...items.map((i) => i.h)), W = items.reduce((a, i) => a + i.w + gap, 0);
  const rgb = new Uint8Array(W * s * H * s * 3).fill(60);
  let ox = 0;
  for (const it of items) {
    for (let y = 0; y < it.h; y++) for (let x = 0; x < it.w; x++) {
      const v = it.get(x, y); const col = v === 2 ? [255, 0, 0] : v ? [0, 187, 187] : [0, 0, 0];
      for (let dy = 0; dy < s; dy++) for (let dx = 0; dx < s; dx++) { const p = (((y * s + dy) * W * s) + (ox + x) * s + dx) * 3; rgb[p] = col[0]; rgb[p + 1] = col[1]; rgb[p + 2] = col[2]; }
    }
    ox += it.w + gap;
  }
  return png(W * s, H * s, rgb);
}
