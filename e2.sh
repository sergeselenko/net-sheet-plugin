#!/bin/bash
# E2 — "What do I actually get at the end of one of these?"   COST: $0.00
cd "$(dirname "$0")" || exit 1
R=$(ls -td evals/results/*/ 2>/dev/null | head -1)
[ -z "$R" ] && { echo "No results on disk yet. Run e3.sh first."; exit 1; }
echo
echo "  Opening the most recent eval report — a self-contained page, already paid for."
echo "  $R"
echo
echo "  While it loads, notice one thing: this report PUBLISHES to claude.ai by"
echo "  default. Every script here passes --no-publish so it stays on your machine."
echo
open "${R}report.html"
