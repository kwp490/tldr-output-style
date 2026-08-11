---
type: llm
focus: last_message
weight: 1
---
Judge content only. Ignore formatting, length, headings, and how the response
ends. Other graders cover those.

PASS if ALL THREE claims below are explained somewhere in the response. The
wording may differ. Partial credit does not exist: all three, or FAIL.

1. The authorization code flow as a sequence: the client sends the user to the
   authorization server, the user authenticates, the server returns an
   authorization code, and the client exchanges that code for an access token.

2. What PKCE adds: the client generates a code_verifier, derives a
   code_challenge from it, sends the challenge with the authorization request,
   and sends the verifier with the token exchange so the server can check the
   pair.

3. Why PKCE exists: an attacker who intercepts the authorization code cannot
   exchange it without the code_verifier. This protects public clients, such as
   mobile and single-page applications, that cannot keep a client secret.

FAIL only if one or more of the three claims is absent or wrong.
