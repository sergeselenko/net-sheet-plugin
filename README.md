# Net sheet plugin

A small Claude plugin with one skill. The skill writes a seller net sheet for a residential sale: what the seller walks away with after commission, title, escrow, and prorations.

It was written for real estate agents who need to send a seller a clear breakdown the same day they are asked, without sending a number they cannot explain.

Plugin name: `net-sheet`. Version: 0.1.0.

## What the skill does

Every net sheet comes out as a line-item breakdown, one item per line, in this fixed order:

- Sale price
- Commission
- Title
- Escrow
- Prorations
- Seller net proceeds

## The two hard rules

1. Every figure is labelled **QUOTED** if the person supplied it, or **ESTIMATED** if the skill assumed it, and every ESTIMATED figure states the assumption behind it on the same line.
2. Never a bare bottom line. No single net number is given without the full breakdown above it.

The arithmetic is the easy part. These two rules are the skill.

## What is in this repository

- `.claude-plugin/plugin.json` — the plugin package.
- `skills/net-sheet/SKILL.md` — the skill itself.
- `evals/walks-away-with/` — the positive test case, with three graders: one checks the QUOTED and ESTIMATED labels and assumptions, one checks the line order and that the answer does not lead with a bottom line, and one checks that the skill actually fired.
- `evals/market-question/` — the negative test case, with two graders: one checks that the answer stays on the pricing question asked, and one checks that the skill does not fire at all.
- `evals/results/` — three result batches from the runs described below.
- `e1.sh` to `e5.sh` — five small scripts that run and audit the evals. They are part of the point: they show the eval method, not just the skill.

The test cases use a fictional placeholder property, 412 Oak. No real person and no real sale is in this repository.

## Measured results

The skill was tested with `claude plugin eval` on September 2, 2026, running each case with the skill and without it, three runs per side.

On the positive case, walks-away-with:

- With the skill: **1.00**
- Without the skill: **0.00 to 0.50**

Without the skill, the answers dropped the labels, the stated assumptions, or the line order. With the skill, they held all three.

On the negative case, market-question, the skill stays out. The question is about pricing against comparable sales, not about proceeds, so the skill does not fire and the answer stays on pricing. The dedicated run for this case scored the same on both sides, a difference of 0.00, which is the correct result there.

### The result batches in this repository

Three batches are included under `evals/results/`:

- `2026-09-02T19-39-37-922Z` — walks-away-with: with the skill 1.00, without 0.00, difference +1.00.
- `2026-09-02T19-43-18-851Z` — walks-away-with, a second separate batch: with the skill 1.00, without 0.00, difference +1.00.
- `2026-09-02T19-37-03-041Z` — market-question: with the skill 1.00, without 1.00, difference 0.00. The skill stayed out, as it should.

Two batches making the same +1.00 point are included on purpose, so the result can be checked for repeatability and not just read once. Both also hold under the leave-one-run-out audit in `e1.sh`: dropping any single run from either batch still leaves the difference at +1.00.

One early batch from the same day was a sign-in failure (an authentication error, not an answer) and scored 0.00 for that reason. It is excluded from these results entirely. A run that fails to sign in scores exactly like a useless skill, and the scripts below say so.

Machine paths in the included result files were normalized: the home folder in the run paths is shown as `~`.

Each batch folder holds `aggregate-result.json` (the scores) and `report.html` (the readable report).

## How to run the evals

You need Claude Code with the plugin eval command. The scripts run from the repository root, and each one states its cost in its header.

- `e1.sh` — Cost: $0.00. Audits results already on disk and spends nothing. It drops one run at a time from each batch and checks whether the difference survives. A difference that moves when one run is removed is not a result.
- `e2.sh` — Cost: $0.00. Opens the most recent report in `evals/results/`.
- `e3.sh` — Cost: about $0.11. The cheapest real run: one case, one run, with the skill only, with a cost ceiling of $0.50 so it stops itself rather than surprising you.
- `e4.sh` — Cost: about $0.90. The full positive case, run both ways, three runs per side, with a cost ceiling of $2. Run `e1.sh` afterwards to audit the number you just paid for.
- `e5.sh` — Cost: about $0.63. The negative case, market-question, with a cost ceiling of $2. Success here is a difference of zero.

All five scripts pass the no-publish flag, so reports stay on your own machine.

## License

Code in this repository (the shell scripts and the plugin configuration) is under the MIT License. See `LICENSE`.

Prose in this repository (the skill text, the eval prompts and graders, and this README) is under the Creative Commons Attribution 4.0 International License, CC BY 4.0. See `LICENSE-PROSE.md`.
