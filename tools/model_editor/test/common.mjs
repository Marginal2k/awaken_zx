import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import * as F from '../js/format.js';

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..', '..');
export const MODELS = path.join(ROOT, 'assets', 'models');

export function loadAll(root = MODELS) {
  const res = [];
  for (const kind of ['flight', 'station']) {
    const d = path.join(root, kind);
    const ixText = fs.readFileSync(path.join(d, 'index.txt'), 'utf8');
    const ix = F.parseIndex(ixText);
    res.push({ kind, ixText, ix, models: ix.sections.flatMap((s) => s.models.map((n) => {
      const file = path.join(d, n + '.txt');
      const text = fs.readFileSync(file, 'utf8');
      return { kind, section: s.name, name: n, file, text, model: F.parse(text, n) };
    })) });
  }
  return res;
}
