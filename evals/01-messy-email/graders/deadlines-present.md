---
type: regex
target: last_message
match: contains
flags: i
weight: 0.5
---
(?=[\s\S]*\b22nd\b)(?=[\s\S]*\bFriday\b)(?=[\s\S]*(?:end of (?:the )?month|\bEOM\b))[\s\S]
