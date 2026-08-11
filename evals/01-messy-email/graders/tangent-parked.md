---
type: llm
focus: last_message
weight: 1
---
The email mentions a dashboard showing stale numbers since roughly the 3rd. The
sender explicitly flags it "Not urgent".

PASS if the response does ONE of these:

- Omits the dashboard entirely.
- Names the dashboard in a single line, marked as separate, deferred, parked,
  or not urgent.

FAIL if the dashboard appears as an item in the main action list.
FAIL if the response analyses possible causes of the stale numbers.
FAIL if the dashboard gets more than two sentences of attention.
