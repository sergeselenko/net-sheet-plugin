#!/bin/bash
# E4 — "Is this skill worth having, or is it decoration?"   COST: ~$0.90
cd "$(dirname "$0")" || exit 1
echo
echo "  The real question. Runs the case BOTH ways — with the skill and without —"
echo "  three times each. The difference between them is the only thing that means"
echo "  anything; the with-side score alone would tell you nothing."
echo
echo "  AFTERWARDS: run e1.sh again. Your new batch will be in it, and you can"
echo "  audit the number you just paid for."
echo
claude plugin eval . --case walks-away-with --no-publish --max-cost-usd 2
