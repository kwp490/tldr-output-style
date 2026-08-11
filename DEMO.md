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

Abridged. Full text in the collapsed blocks.

**Without TLDR**, the answer opened by describing the email:

> This email has six separate threads tangled together. Here's the breakdown and a drafted reply:

**With TLDR**, it opened by telling you what to do:

> **Next action:** Decide these 3 things, then I can draft your reply.

<details>
<summary>Without TLDR — full answer</summary>

The reply listed **4 action items**, then **2 lower-priority items**, then **3
open questions** — nine entries across three overlapping lists, where the open
questions restate items already in the first list. It then produced an
unrequested draft reply containing a bracketed placeholder:

> **The 22nd**: [confirm or correct — I don't have that on my side either, want to double check before marketing's campaign emails go out on a date we didn't actually commit to]

and closed with a compound offer:

> Want me to adjust tone/content, or help you actually track down the search latency regression or the "22nd" commitment?

</details>

<details>
<summary>With TLDR — full answer</summary>

Split into **3 decisions needed from you** and **3 FYI, no reply needed**. The
dashboard tangent was parked in the FYI group, marked as the sender's own "not
urgent." It closed with a single question:

> Want me to draft a reply email covering all 3 decisions once you tell me your answers?

</details>

## What to look for

Not exact wording — the wording changes every run. These are the durable
differences:

1. **Does the first line tell you what to do,** or describe what you are looking at?
2. **Is there one list or three?** The default answer tends to produce overlapping
   groups — action items, then open questions that repeat them. Anything you have
   to reconcile across lists costs working memory.
3. **Where did the tangent go?** The sender's own "not urgent" dashboard note
   should be parked, not expanded.
4. **Does the closing ask for one thing or several?** A compound closing question
   is a decision you have to make before you can act.
5. **Did it pre-write a draft you did not ask for,** with blanks you still have to
   fill? That is the gap between knowing the answer and doing it — the thing
   these rules exist to close.

## An honest caveat

Model output varies between runs. I ran this pair twice while writing the demo.
The first run is recorded above and the contrast was stark. On the second run the
gap was **narrower**: the default answer was already fairly well-structured, and
the TLDR answer did not lead with "Next action." The differences in items 3, 4
and 5 above held in both runs; item 1 held in one of two.

This is exactly why the script ships alongside this page. A recorded before/after
is a claim. Run it on your own machine and judge for yourself.

## In the Claude chat app

Output styles are a Claude Code feature. The chat app has no plugin to toggle, so
the script does not apply — but you can still run the same comparison by hand:

1. Paste [the style body](plugins/tldr/output-styles/tldr.md) (everything below
   the `---` frontmatter) into a Claude Project's custom instructions.
2. Paste [`demo/prompt.md`](demo/prompt.md) into that Project.
3. Paste the same email into an ordinary chat with no custom instructions.
4. Compare, using the five checks above.
