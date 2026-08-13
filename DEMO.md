# See it working, and not working

The fastest way to judge an output style is to watch the same prompt go through
it twice — once with the style off, once on.

The test prompt is [`demo/prompt.md`](demo/prompt.md): a long, rambling work
email that buries five action items, three deadlines, two direct questions, a
technical regression, and one tangent the sender flags as "not urgent." It is
deliberately not a coding question, so it works the same way in Claude Code and
in the Claude chat app.

## Run it yourself

Clone the repo. You do **not** need to install the plugin — the script loads the
style straight from the clone with `--plugin-dir`.

```bash
bash demo/demo.sh
```

On Windows:

```powershell
powershell -ExecutionPolicy Bypass -File demo\demo.ps1
```

The script prints the default answer and the TLDR answer one after the other.

If you already have the plugin installed and enabled, the script disables it for
the duration so the "off" arm is genuinely off, then restores it. The restore is
in a `finally` block (PowerShell) and an `EXIT` trap (bash), so your setup is put
back even if you Ctrl-C out.

## A recorded run

Abridged, recorded against v1.2.1. The sharpest difference is the **last line**,
so start there.

**Without TLDR**, the answer closed by offering a menu:

> Want me to tighten/send this, or adjust tone/decisions first?

and then, after a draft reply, asked again:

> Let me know if you want me to change who's doing what (especially the Sam ping and the latency investigation) before treating this as final.

**With TLDR**, it closed with one action and a yes-or-no:

> Next: I draft a reply covering items 1 to 4. Yes or no?

<details>
<summary>Without TLDR — full answer</summary>

Opened with "Here's the signal extracted from that wall of text — 6 threads
tangled together," then rendered a **six-row table** with an Owner column, then
a dependency analysis, then an unrequested draft reply containing bracketed
blanks you still have to fill:

> **Search latency:** Let's get eyes on the p95 regression before we talk promotion — I'll [take it / ask X] to check whether it's the analyzer or cold caches.

It ended with two separate asks, quoted above. Nothing here is wrong. It is
simply more than you can act on, and it hands back decisions dressed as a draft.

</details>

<details>
<summary>With TLDR — full answer</summary>

Split into **4 that need your decision now** and **3 FYI, no action required**.
The dashboard tangent went to the FYI group, carrying the sender's own "not
urgent." The deadline was resolved to an absolute date — "due Friday, August 14,
2026" — rather than left as "Friday."

It closed with a single yes-or-no, quoted above.

</details>

That closing line is not a coincidence. The [eval suite](evals/README.md) caught
the old version offering a menu instead of one action, and the style file was
changed in response. `plugins/tldr/output-styles/tldr.md` now says outright:

> Bad: "Next: tell me which item to start with, or say the word and I will draft the reply."
> Good: "Next: I draft the reply covering all four items. Yes or no?"

## What to look for

Not exact wording — the wording changes every run. These are the durable
differences:

1. **Does the closing ask for one thing, or offer a menu?** This is the most
   reliable difference. A menu is a decision you must make before you can act.
2. **Is the answer split by what it needs from you,** or by topic? "Decide these
   4, ignore these 3" is actionable. A six-row table with an Owner column is a
   document.
3. **Where did the tangent go?** The sender's own "not urgent" dashboard note
   should be parked, not expanded.
4. **Did it pre-write a draft you did not ask for,** with blanks you still have to
   fill? That is the gap between knowing the answer and doing it — the thing
   these rules exist to close.
5. **Are deadlines resolved to dates?** "Due Friday" is a lookup. "Due Friday,
   August 14, 2026" is not.

Note what is *not* on this list: which answer opens with an action. That one
varies too much between runs to rely on.

## How much does it actually change?

A single recorded pair is an anecdote. The [eval suite](evals/README.md) is the
measurement. Three cases, each run with the plugin and without it, three runs per
case, scored by a sonnet judge:

```
CASE                     WITH  WITHOUT   Δ
01-messy-email           0.87   0.54   +0.33
02-casual-question       1.00   0.83   +0.17
03-explain-break-glass   1.00   0.82   +0.18
                                mean Δ +0.23
```

Case 3 is the one worth noticing. It rewards the style for **relaxing** — the
break-glass rules say explain-this-to-me requests should get a full, headed
explanation, not a terse list. A suite that only rewarded brevity would train the
style into always-terse and quietly break its own escape hatch.

The suite also found three real defects in the style and drove the fixes now
shipping in 1.2.1, including the single-closing-action rule visible in the
recording above. Details and reproduction steps are in
[`evals/README.md`](evals/README.md).

Numbers still beat anecdotes only if you can reproduce them. Run the script, or
run the suite.

## In the Claude chat app

Output styles are a Claude Code feature. The chat app has no plugin to toggle, so
the script does not apply — but you can still run the same comparison by hand:

1. Paste [the style body](plugins/tldr/output-styles/tldr.md) (everything below
   the `---` frontmatter) into a Claude Project's custom instructions.
2. Paste [`demo/prompt.md`](demo/prompt.md) into that Project.
3. Paste the same email into an ordinary chat with no custom instructions.
4. Compare, using the five checks above.

The scored [eval suite](evals/README.md) does not apply here — it drives the
Claude Code CLI. The five checks are the portable part.
