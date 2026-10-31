#!/bin/bash
# E3 — "Can I run one of these myself?"   COST: ~$0.11
cd "$(dirname "$0")" || exit 1
echo
echo "  One case, one run, with-skill only. The cheapest real thing this can do."
echo "  A cost ceiling of \$0.50 is set: it stops itself rather than surprising you."
echo
echo "  WATCH FOR: if the score is 0.00, check for an ERROR line before believing it."
echo "  A run that fails to sign in scores exactly like a useless skill."
echo
claude plugin eval . --case walks-away-with --runs 1 --ablation none --no-publish --max-cost-usd 0.50
