---
type: llm
weight: 1
---
Every money figure in the answer must be labelled either QUOTED (the person supplied it) or
ESTIMATED (the assistant assumed it), and every ESTIMATED figure must state the assumption
behind it.

Fails if: any figure is unlabelled, or an ESTIMATED figure appears with no assumption given,
or the answer gives a bottom-line number with no breakdown above it.
