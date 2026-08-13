---
type: llm
focus: last_message
weight: 1
---
Read the FINAL line of the response, or the final short paragraph if the last
line is part of one. Ignore everything before it. This is an explain request, so
the body is long and has headed sections. None of that is under judgement here.

Break-glass relaxes length and requires headers. It does NOT relax the closing
rule: "Still no preamble, still no closer."

PASS if that final line is exactly ONE of these:

- One concrete next action the reader can start immediately.
- One question with a yes or no answer.
- One question asking the reader to name one thing.

FAIL if the final line offers two or more alternatives joined by "or".
FAIL if the final line is a recap of what the response already covered.
FAIL if the final line offers further help without naming a specific action,
for example "let me know if you need anything else".
FAIL if the response has no closing line of this kind at all.

Example that PASSES: "Next: want a sequence diagram of this flow? Yes or no."

Example that FAILS, observed from the real style at 1.2.1: "Next: tell me if you
want a sequence diagram of this flow, or a code sample in a specific language."
