---
type: llm
focus: last_message
weight: 1
---
Read the FINAL line of the response, or the final short paragraph if the last
line is part of one. Ignore everything before it. The body may contain lists,
groups, and many items. None of that is under judgement here.

PASS if that final line is exactly ONE of these:

- One concrete next action the reader can start immediately.
- One question with a yes or no answer.
- One question asking the reader to name one thing.

FAIL if the final line offers two or more alternatives joined by "or".
FAIL if the final line is a recap of what the response already covered.
FAIL if the final line offers further help without naming a specific action,
for example "let me know if you need anything else".
FAIL if the response has no closing line of this kind at all.

Example that PASSES: "Next: want me to draft a reply covering the 4 decisions
above? Yes or no."

Example that FAILS: "Next: tell me which item to start with, or say the word and
I will draft a reply."
