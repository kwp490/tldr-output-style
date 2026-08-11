---
type: regex
target: last_message
match: contains
flags: m
weight: 1
---
^(?:#{1,6} \S|\*\*[^*\n]{3,60}\*\*\s*$)
