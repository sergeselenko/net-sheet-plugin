#!/bin/bash
# E5 — "How do I know it isn't barging in where it shouldn't?"   COST: ~$0.63
cd "$(dirname "$0")" || exit 1
echo
echo "  The half of a suite that can deliver bad news. This case is one the skill"
echo "  should stay OUT of. Success here is a delta of ZERO."
echo
echo "  WATCH FOR: 'Skill called 0x (expected 0..0)' — passing, and scored in BOTH"
echo "  arms. That grader works because it sets min: 0, max: 0 AND arm: both."
echo "  Without arm: both it would score nothing and still look healthy."
echo
claude plugin eval . --case market-question --no-publish --max-cost-usd 2
