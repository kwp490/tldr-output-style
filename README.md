# TLDR — an ADHD-shaped output style for Claude Code

Claude Code, rewritten to answer the way an ADHD brain can actually act on: **the next action first, numbered steps, no preamble, no closing pleasantries**, and all prose in [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/).

Before:

> Great question! Let me take a look at your auth flow. There are a few moving pieces here, and I want to make sure I understand the context before diving in...

After:

> Run `npm install jsonwebtoken`, then edit `src/auth.ts:42`.

---

## Install

Two commands:

```bash
claude plugin marketplace add kwp490/tldr-output-style
```

```bash
claude plugin install tldr@tldr-plugins
```

Then restart Claude Code, or run `/clear`. That is it — the style applies itself on install.

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

Claude can run both commands itself.

## Uninstall

```bash
claude plugin disable tldr@tldr-plugins
```

Your previous output style returns on the next session. To remove it completely:

```bash
claude plugin uninstall tldr@tldr-plugins
```

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
- **Claude Code only.** The Claude chat apps do not support output styles. Paste the [style body](plugins/tldr/output-styles/tldr.md) into Settings → Profile, or into a Project's custom instructions, to get most of the effect.

## Repository layout

```
.claude-plugin/marketplace.json     the catalog
plugins/tldr/
  .claude-plugin/plugin.json        the plugin manifest
  output-styles/tldr.md             the style itself
```

## Credit

Adapted from the [`tldr` skill by r13i](https://github.com/r13i/skills/tree/main/tldr), which originated these rules. This repository repackages them as an output style so they apply unconditionally, and adds the plugin and marketplace scaffolding.

MIT licensed. See [LICENSE](LICENSE).
