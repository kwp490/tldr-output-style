# TLDR — an ADHD-shaped output style for Claude Code

Claude Code, rewritten to answer the way an ADHD brain can actually act on: **the next action first, numbered steps, no preamble, no closing pleasantries**, and all prose in [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/).

> ### Credit
>
> The twelve rules are not mine. They originate in the **[`tldr` skill by r13i](https://github.com/r13i/skills/tree/main/tldr)**, released under MIT with the invitation to "use, copy, adapt freely." All twelve rules, the break-glass section, and the pre-send check are theirs, unchanged in substance.
>
> The prose standard is **[ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/)**, maintained by the AeroSpace and Defence Industries Association of Europe.
>
> What this repository adds is packaging, not ideas: conversion from a skill to an output style so the rules apply unconditionally, plus the plugin manifest, marketplace, [demo](DEMO.md), and CI.

Before:

> Great question! Let me take a look at your auth flow. There are a few moving pieces here, and I want to make sure I understand the context before diving in...

After:

> Run `npm install jsonwebtoken`, then edit `src/auth.ts:42`.

Want proof before you install? **[See it working, and not working](DEMO.md)** — a
recorded before/after on a rambling work email, plus a script that runs the
comparison on your own machine straight from a clone.

---

## Install

Two commands:

```bash
claude plugin marketplace add kwp490/tldr-output-style
```

```bash
claude plugin install tldr@tldr-plugins
```

Then restart Claude Code, or run `/clear`. That is it.

> [!IMPORTANT]
> **There is no third step. Do not turn the style on.**
>
> - Do **not** add `outputStyle` to `settings.json`.
> - Do **not** run `claude config set outputStyle tldr`. That subcommand does not exist. `claude config ...` passes the words to Claude as a prompt, so it answers with a clarifying question instead of failing.
>
> The style sets `force-for-plugin: true`, so it applies itself whenever the plugin is enabled. See [Design notes](#design-notes).

<details>
<summary>Prefer the interactive UI?</summary>

```
/plugin marketplace add kwp490/tldr-output-style
/plugin install tldr@tldr-plugins
```
</details>

### Just hand this repo to Claude

Paste this to any Claude Code session:

> Install the plugin at https://github.com/kwp490/tldr-output-style

Claude can run both commands itself. Read the callout above first — the common failure is an agent adding a manual `outputStyle` step that this plugin does not need.

## Verify

Output style is read once at session start, so check from a **new** session:

```bash
claude -p "Reply with only the name of the active output style, or NONE"
```

Expected output:

```
tldr:TLDR
```

If you get `NONE`, the plugin is disabled or the session predates the install. Confirm with `claude plugin list` — status should read `enabled`.

> [!WARNING]
> Do not use `claude plugin details tldr` to verify. It reports `Skills (0)`, `Agents (0)`, `Hooks (0)` and `Always-on: ~0 tok`, because that inventory does not count output styles. The plugin is working; the command simply does not measure this kind of content.

## Update

```bash
claude plugin update tldr@tldr-plugins
```

Restart Claude Code to apply.

## Uninstall

```bash
claude plugin disable tldr@tldr-plugins
```

Your previous output style returns on the next session. To remove it completely:

```bash
claude plugin uninstall tldr@tldr-plugins
```

## One project only, without the plugin

The plugin is global. To scope TLDR to a single codebase instead, copy [the style file](plugins/tldr/output-styles/tldr.md) to `<project>/.claude/output-styles/tldr.md` and commit it. The style then travels with that repo and applies only inside it.

This path has no plugin to set `force-for-plugin`, so it is the one case where you *do* select the style yourself — via `/output-style` in an interactive session.

---

## The twelve rules

| # | Rule | In short |
|---|---|---|
| 1 | Lead with the next action | First line is something you can *do* |
| 2 | Number multi-step tasks | One bounded action per step |
| 3 | End with one concrete next action | Under two minutes, always |
| 4 | Suppress tangents | Finish issue one before naming issue two |
| 5 | Restate state every turn | "Step 3 of 5 done" — never assume recall |
| 6 | Give specific time estimates | "15 minutes," not "some work" |
| 7 | Make completed work visible | Show what works now, concretely |
| 8 | Matter-of-fact tone for errors | No "Uh oh." Cause, then fix |
| 9 | Cap lists at 5 items | Five ranked beats ten unranked |
| 10 | Write in ASD-STE100 | Active voice, ≤20 words, no contractions |
| 11 | No preamble, no recap, no closers | Start with the answer, stop when done |
| 12 | Verify state before instructing | Run `git status`; never instruct from memory |

Each rule exists because of a specific fact about ADHD cognition — small working memory, the gap between knowing and doing, the cost of starting, uniform-feeling time estimates, and scarce dopamine. The [style file](plugins/tldr/output-styles/tldr.md) states the reasoning in full.

The style also defines **when to break its own rules**: on "explain this to me" requests, before destructive actions, during a debug spiral, and when the request is genuinely ambiguous.

## Design notes

**It is an output style, not a skill.** Skills load when the model judges them relevant; output styles load every turn, unconditionally, welded into the system prompt at session start. A response-shaping rule that fires *sometimes* is worse than no rule, because you cannot tell which mode you are in.

**`keep-coding-instructions: true`.** Claude Code's built-in software-engineering instructions stay on. TLDR changes how Claude talks, not whether it codes. Rule 12 in particular depends on that built-in behavior existing.

**`force-for-plugin: true`.** The style applies automatically whenever the plugin is enabled, overriding the `outputStyle` setting. Installing a plugin whose only content is an output style should not require a second manual step to turn it on. Disable the plugin to opt out.

## Known limits

- **Subagents ignore it.** Each subagent runs its own system prompt. Only `fork` inherits the parent's.
- **Changes need a restart.** Output style is read once at session start. `/clear` or a new session.
- **Rule 12 costs tool calls.** Verifying git state before instructing means extra `git status` runs. That is the intent, not a bug.
- **Claude Code only.** The Claude chat apps do not support output styles. Paste the [style body](plugins/tldr/output-styles/tldr.md) into Settings → Profile, or into a Project's custom instructions, to get most of the effect — [DEMO.md](DEMO.md#in-the-claude-chat-app) walks through it and gives you a prompt to compare against.

## Repository layout

```
.claude-plugin/marketplace.json     the catalog
plugins/tldr/
  .claude-plugin/plugin.json        the plugin manifest
  output-styles/tldr.md             the style itself
DEMO.md                             recorded before/after, and how to run it
demo/
  prompt.md                         the test email both arms are given
  demo.sh, demo.ps1                 run the comparison locally
evals/
  README.md                         how to run the suite, and what it measures
  01-*, 02-*, 03-*                  three scored cases and their graders
```

## Credit

The rules in this repository were created by **[r13i](https://github.com/r13i)** as the [`tldr` skill](https://github.com/r13i/skills/tree/main/tldr). That work is MIT licensed, stated in [their repository's README](https://github.com/r13i/skills#license) as "use, copy, adapt freely."

This repository contributes the conversion and the packaging: the skill becomes an output style so the rules load every turn instead of when the model judges them relevant, and it gains a plugin manifest, a marketplace, a [runnable demo](DEMO.md), and CI. The twelve rules, the break-glass section, and the pre-send check are r13i's, unchanged in substance. What changed in the conversion is set out in [Design notes](#design-notes).

The prose standard is [ASD-STE100](https://www.asd-ste100.org/), maintained by the AeroSpace and Defence Industries Association of Europe. It is an external standard, referenced here rather than reproduced.

This repository is itself MIT licensed — see [LICENSE](LICENSE) — which is a separate grant from the upstream one above.
