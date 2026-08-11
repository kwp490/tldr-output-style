---
type: llm
focus: last_message
weight: 1
---
Judge padding only. Do NOT judge length, and do NOT count lines. A separate
free grader already enforces a hard character ceiling.

Line breaks, bullet lists, bold labels, and short one-sentence paragraphs are
formatting for a reader with ADHD. They are correct. Never treat them as
padding or as evidence that the response is long.

PASS unless the response contains one or more of these:

- A sentence that restates the question before answering it.
- A sentence that announces what the response is about to do.
- A paragraph of background that arrives before the answer.
- A sentence offering further help without naming a specific action. A closing
  line that names one concrete command to run is NOT padding, and PASSES.
- Hedging filler that carries no information, such as "it really depends" with
  nothing following it.

FAIL only if at least one of the above is present. Quote it in your reasoning.
