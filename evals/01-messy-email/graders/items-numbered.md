---
type: llm
focus: last_message
weight: 1
---
The email bundles six threads. This grader checks that none of them is lost and
that the response uses a numbered list. It does NOT check who owns each thread.

PASS only if BOTH of these hold:

A. The response contains at least one numbered list.

B. All five topics below are surfaced somewhere in the response. Wording and
   ordering may differ. Judge meaning, not phrasing.

   1. The p95 latency rise on /api/search, tied to the production promotion.
   2. Whether the 22nd is really the agreed promotion date.
   3. Telling Sam, or the mobile team, about the session token rotation and the
      30 day refresh assumption.
   4. The feature flag, which the sender proposes keeping through the next
      release.
   5. The infra section of the Q3 planning doc, due Friday.

A topic counts as surfaced whether the response treats it as the reader's
action, as somebody else's action, or as explicitly no action needed. Triage is
not under judgement here. Splitting the topics into groups such as "needs your
decision" and "FYI" is correct behaviour and must not be penalised.

A topic counts even if it sits outside the numbered list.

FAIL if the response contains no numbered list anywhere.
FAIL if any of the five topics is absent entirely.
