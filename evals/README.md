# Evals

Three cases that measure whether the TLDR output style changes the answer, and
whether it relaxes when it is supposed to.

Every case runs twice: once with the plugin loaded, once without. The headline
number is the delta between the two arms. A case that scores well in both arms
measures nothing about this plugin.

## Run the suite

```bash
CLAUDE_CODE_WALNUT_SPIRE=1 claude plugin eval . --ablation with-without --judge-model sonnet --no-publish
```

PowerShell:

```powershell
$env:CLAUDE_CODE_WALNUT_SPIRE = "1"; claude plugin eval . --ablation with-without --judge-model sonnet --no-publish
```

Four parts of that command are deliberate. Do not drop them.

| Flag | Why |
|---|---|
| `CLAUDE_CODE_WALNUT_SPIRE=1` | `claude plugin eval` is in early access. Without this the command exits 1 with "`plugin eval` is currently in early access". Remove it once the feature is generally available. |
| `--ablation with-without` | Runs the no-plugin baseline arm. Without it there is no delta and the suite only measures the model. |
| `--judge-model sonnet` | The default judge is haiku. Haiku is too small for these rubrics, and the judge must not be the agent model. |
| `--no-publish` | Reports publish to claude.ai by default. This repository is public and the report embeds full model outputs, so keep them local. |

Run output lands in `evals/results/<timestamp>/`, which is gitignored.

**Read `report.html`, not the JSON.** The HTML report embeds every model output
and every judge verdict. `aggregate-result.json` and `--json` carry scores only.
Debugging a grader without the outputs is guesswork.

## Current baseline

Measured with `--runs 3`, sonnet judge, against the style at the state of this
commit. Reproduce before trusting any comparison.

```
CASE                     WITH  WITHOUT   Δ
01-messy-email           0.90   0.56   +0.33
02-casual-question       0.95   0.71   +0.24
03-explain-break-glass   0.85   0.69   +0.15
                                mean Δ +0.24
```

`no-contractions` carries most of the delta. It passes 3 of 3 in the plugin arm
on every case and 0 of 3 in the baseline arm on every case. It is free and
deterministic. If only one grader survives a future cleanup, keep that one.

## Known failure: break-glass closes with a menu

`single-closing-ask` was originally wired to case 01 only. Cases 02 and 03
therefore scored 1.00 while breaking rule 3, because nothing looked at the shape
of their closing line. `no-closer` is a different check — it catches pleasantries
like "hope this helps", not menus.

With the grader wired to all three cases, the plugin arm fails it **3 of 3 on
case 03**, every run, and 1 of 3 on case 02. Observed closing:

> Next: tell me if you want a sequence diagram of this flow, or a code sample in
> a specific language.

Rule 3 forbids exactly that: "One thing. Not two options joined by 'or'."
Break-glass relaxes length and requires headers. It does not relax the closing.

This is a real defect in the style, not a grader artefact. Case 03's score fell
from 1.00 to 0.85 when the grader was added, and its delta fell from +0.18 to
+0.15 — the plugin arm and the baseline arm now fail this check equally, so the
style earns no uplift on it here.

Adding the grader raised case 02's delta (+0.17 to +0.24) because the baseline
fails the check 3 of 3 while the plugin arm fails it only 1 of 3. Wiring a
grader to more cases can move a delta in either direction. That is the grader
measuring more, not the style changing.

Case 1 is the only case below 1.00. Three graders score 2 of 3 there
(`deadlines-present`, `single-closing-ask`, `tangent-parked`). Those are real
intermittent behaviours in the style, not grader faults. Case 1 is the hardest
input in the suite and is expected to stay imperfect.

## What a run costs

The runner prints a `costUsd` figure. It is computed from token counts at API
list prices and is printed whether or not an API key is involved. On a Claude
Code login nothing is billed. The real cost is your plan's usage allowance.

For scale: a full pass of all three cases at `runs: 3` reports about $1.85 of
equivalent token spend across 18 agent runs. A `--runs 1` smoke pass reports
about $0.60.

## Do not run this in CI

There is no eval job in `.github/workflows/validate.yml`, on purpose. A GitHub
runner has nobody logged in, so it would need an `ANTHROPIC_API_KEY` secret in a
public repository. CI checks that the eval files exist, that every case still
declares `plugins:`, and that the email fixture has not drifted. It never
executes a case.

## The cases

| Case | Prompt | Measures |
|---|---|---|
| `01-messy-email` | The rambling work email from `demo/prompt.md` | Nothing lost, tangent parked, one closing ask, deadlines surfaced |
| `02-casual-question` | "What is the difference between git fetch and git pull?" | Brevity without loss of correctness |
| `03-explain-break-glass` | "Walk me through ... OAuth 2.0 ... PKCE ..." | That the style **relaxes** when the user asks to be walked through something |

Case 3 is the important one and the one most eval suites skip. A suite that only
rewards terseness trains the style toward always-terse and silently breaks its
own escape hatch. Case 3 exists to hold that floor.

**Case 3's delta comes from the style graders, not the content graders.** Default
Claude also explains at length, so `covers-the-mechanism` and `long-enough` pass
in both arms. A near-zero delta on case 3 is healthy. A negative one means
break-glass has regressed.

## The email fixture is duplicated on purpose

`evals/01-messy-email/prompt.md` carries the same email as `demo/prompt.md`.
Cases run in a sandbox working directory and cannot read the repository, so the
text has to live inside the case.

CI diffs the two copies and fails on drift. **Edit `demo/prompt.md` and copy the
change across, or CI will stop you.**

## Every case must declare `plugins:`

```yaml
plugins: ["../../plugins/tldr"]
```

The path is relative to the **case directory**, not the repository root.

Without this line the runner refuses to run at all:

> ablation requested but no plugin resolved for this case: auto-detection found
> no plugin.json ... The with and without arms would run identical configs, so Δ
> would measure nothing.

Auto-detection walks from the case directory up to the discovery root looking for
a `plugin.json`. Because `evals/` sits at the repository root and the plugin
lives under `plugins/tldr/`, it never finds one. CI asserts the line is present.

## Graders

Free graders cost nothing per run and are deterministic. Paid graders call the
judge model. Free graders carry the backbone here; the judge covers only what a
regex cannot see.

| Grader | Type | Cases | Weight |
|---|---|---|---|
| `no-contractions` | regex | 1, 2, 3 | 1 |
| `no-preamble` | regex | 1, 2, 3 | 1 |
| `no-closer` | regex | 1, 2, 3 | 1 |
| `deadlines-present` | regex | 1 | 0.5 |
| `stays-short` | regex | 2 | 1 |
| `has-skimmable-headers` | regex | 3 | 1 |
| `long-enough` | regex | 3 | 0.5 |
| `items-numbered` | llm | 1 | 1 |
| `tangent-parked` | llm | 1 | 1 |
| `single-closing-ask` | llm | 1 | 1 |
| `no-padding` | llm | 2 | 1 |
| `still-answers` | llm | 2 | 1 |
| `covers-the-mechanism` | llm | 3 | 1 |

`stays-short` and `still-answers` are deliberately opposed. If a future edit
makes answers short and useless, `stays-short` passes and `still-answers` fails.
Terseness alone cannot score.

Graders that pass in both arms dilute the delta, because the score is a weighted
average. `deadlines-present` and `long-enough` sit at weight 0.5 for that reason.
Their job is regression detection, not measurement. **Do not add more graders
that both arms pass without lowering their weight.**

## Rules learned from writing these graders

Every one of these came from a grader that scored a good answer as a failure.
Read them before adding a grader.

1. **Never ask a judge to count lines.** An early `is-brief` grader capped the
   answer at eight lines. The style writes short paragraphs with blank lines
   between them, so it scored 0 of 3, while the wordier baseline scored 3 of 3
   because its text sat in two dense blocks. The grader rewarded the exact
   opposite of the thing being tested. Length belongs to `stays-short`, which
   counts characters and cannot be fooled by formatting.
2. **Do not encode a debatable reading as a hard requirement.** An early
   `items-numbered` demanded that the feature flag be treated as the reader's
   action item. Whether it is one is genuinely arguable. The grader was measuring
   agreement with the author, not the style. It now checks only that the topic is
   surfaced.
3. **One grader, one thing.** `covers-the-mechanism` originally judged content
   *and* form. It failed a 2751 character answer with four headers and complete
   coverage, almost certainly on the form clauses. Form now belongs to
   `has-skimmable-headers` and `long-enough`.
4. **Anchor the judge's attention explicitly.** `single-closing-ask` said "look at
   how the response ends" and the judge read the whole response. It now names the
   final line, and carries a worked PASS example and a worked FAIL example.
5. **Write the regex against real output, not the spec.** `has-skimmable-headers`
   required `##`; the style wrote `#`. `deadlines-present` required "end of
   month"; the style wrote "EOM". Both failed correct answers.

## Known limits

1. **The contraction regex cannot see code fences.** Rule 10 exempts code and
   quoted output from Simplified Technical English. A regex on the last message
   cannot tell prose from a fenced block. A contraction inside a code sample
   would score as a failure. No case currently produces one.
2. **A single run proves very little.** Two `--runs 1` pilots of these same three
   cases produced materially different outputs from identical inputs. Use the
   default of three runs before drawing any conclusion.
3. **No threshold is wired in.** `--threshold` defaults to 1.0, which demands a
   perfect score on every case and would fail on case 1 today. If you want a gate,
   `--threshold 0.8` matches the current baseline with a little headroom.

## Defects this suite has already caught

Each of these was found by the suite and then fixed in
`plugins/tldr/output-styles/tldr.md`.

| Defect | Caught by | Evidence | Status |
|---|---|---|---|
| Contractions leaked into short summaries and list items | `no-contractions` | `doesn't touch your working files`, `Say who's doing it.` | Fixed. 3 of 3 in the plugin arm on every case. |
| The closing line offered a menu instead of one action | `single-closing-ask` | `Next: tell me which of items 1-4 you want handled first, or say "draft a reply" ...` | Fixed. 2 of 3, up from 0 of 3. |
| Break-glass produced no headers and a compressed explanation | `has-skimmable-headers` | One pilot gave four headers, the next gave zero, on the same prompt | Fixed. 3 of 3, and case 3 now scores 1.00. |

**Still open:** a contraction can survive inside suggested phrasing, for example
`say "I'll do it" or "you do it."` The style authors that quoted text, so it is a
real violation rather than quoted input. It is intermittent and did not appear in
the latest full run.
