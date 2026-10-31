#!/bin/bash
# E1 — "How do I know a number is real and not just noise?"   COST: $0.00
# Reads results already on disk. Runs nothing, spends nothing, writes nothing.
cd "$(dirname "$0")" || exit 1
python3 - <<'PY'
import json, glob, os

print()
print("  THE QUESTION:  I ran a test and got a number. Is the number real?")
print("  THE METHOD:    drop each run in turn and see whether the answer survives.")
print("  COST:          $0.00 — every one of these was already paid for.")
print()

rows = []
for f in sorted(glob.glob('evals/results/*/aggregate-result.json')):
    d = json.load(open(f))
    for c in d.get('cases', []):
        if c.get('name') != 'walks-away-with':
            continue
        arms = c.get('arms', {})
        w  = [r.get('score') for r in arms.get('with', [])    if r.get('score') is not None]
        wo = [r.get('score') for r in arms.get('without', []) if r.get('score') is not None]
        if len(w) == 3 and len(wo) == 3:
            rows.append((os.path.basename(os.path.dirname(f))[:19], w, wo, d.get('costUsd', 0)))

if not rows:
    print("  No three-run batches of 'walks-away-with' found. Nothing to audit.")
    raise SystemExit

def avg(x): return sum(x) / len(x)

print("  Each batch below is the SAME case, the SAME graders, the SAME settings.")
print("  Nothing was changed between them. Only chance differs.")
print()
print("  batch                with-skill        without-skill     delta")
print("  " + "-" * 62)
for i, (name, w, wo, cost) in enumerate(rows):
    print(f"  {chr(65+i)}  {name}   {str(w):16}  {str(wo):16}  {avg(w)-avg(wo):+.2f}")

print()
print("  NOW THE AUDIT — drop one run from each side and recompute:")
print()
verdict = []
for i, (name, w, wo, cost) in enumerate(rows):
    full = avg(w) - avg(wo)
    drops = []
    for k in range(3):
        w2  = [x for j, x in enumerate(w)  if j != k]
        wo2 = [x for j, x in enumerate(wo) if j != k]
        drops.append(avg(w2) - avg(wo2))
    moved = any(abs(d - full) > 1e-9 for d in drops)
    verdict.append(moved)
    tag = "MOVES  -> NOT A RESULT" if moved else "HOLDS  -> trustworthy"
    print(f"  batch {chr(65+i)}   full {full:+.2f}   drop-one: " +
          " / ".join(f"{d:+.2f}" for d in drops) + f"   {tag}")

print()
print("  " + "=" * 62)
held  = sum(1 for m in verdict if not m)
moved = sum(1 for m in verdict if m)
print(f"  {held} of {len(verdict)} batches survive the audit; {moved} do not.")
print()
print("  THE RULE:  a delta that changes when you remove any one run is not a result.")
print("  Notice what just happened: every batch LOOKS like a clean win.")
print("  The audit separates them without you spending a cent.")
print()
PY
