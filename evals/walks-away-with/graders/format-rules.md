---
type: llm
weight: 1
---
Two format rules, both required:
1. The breakdown lists sale price, commission, title, escrow, prorations and net proceeds, in
   that order, each on its own line.
2. The answer does NOT lead with a bare bottom-line number before the breakdown.

Fails if the order is scrambled, if items are missing, or if a single net figure is given up
front with the breakdown only afterwards.
