---
type: llm
focus: last_message
weight: 1
---
Read the FINAL line of the response, or the final short paragraph if the last
line is part of one. Ignore everything before it. This is a short factual
question, so the whole response may be only a few lines. That is expected and is
not under judgement here.

PASS if that final line is exactly ONE of these:

- One concrete next action the reader can start immediately.
- One question with a yes or no answer.
- One question asking the reader to name one thing.

A closing line that states a concrete command to run counts as a next action,
even when the response did not ask the reader anything.

FAIL if the final line offers two or more alternatives joined by "or".
FAIL if the final line is a recap of what the response already covered.
FAIL if the final line offers further help without naming a specific action,
for example "let me know if you need anything else".
FAIL if the response has no closing line of this kind at all.

Example that PASSES: "Run `git log origin/main` after a fetch to see what
changed."

Example that FAILS: "Next: want me to cover rebase too, or explain when to use
each one?"
