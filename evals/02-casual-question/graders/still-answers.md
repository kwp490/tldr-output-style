---
type: llm
focus: last_message
weight: 1
---
Brevity must not cost correctness. This grader is the counterweight to
is-brief. Judge only whether the answer is right and usable.

PASS only if ALL of these hold:

- The response states that `git fetch` downloads remote commits and updates the
  remote-tracking branches, and that it does not change the working tree or the
  current branch.
- The response states that `git pull` runs a fetch and then merges or rebases
  the remote changes into the current branch.
- A reader who knew neither command could now choose between them.

FAIL if either mechanism is missing.
FAIL if the response only names the two commands without explaining what each
one changes.
FAIL if any claim about either command is factually wrong.
