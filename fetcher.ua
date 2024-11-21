#!/usr/bin/env uiua

Cookie ← ▽⊸(≠@\u{22}) ↘⧻"session="↘¯1 &fras ".env"

&args
=3⊸⧻
⍤"Usage: fetcher.ua YEAR DAY\nExample: uiua run fetcher.ua 2024 1"
⍣(∩◇⋕°⊟)"Year and day must both be numbers" ↘1

⊙⊙Cookie
$"GET /_/day/_/input HTTP/1.1\r\nHost: adventofcode.com\r\nConnection: close\r\nCookie: session=_\r\n\r\n"
"adventofcode.com:443"
⍜&tlsc(&rs∞ ⊸&w:)

⊸⦷"\r\n\r\n"
▽¬⍜⇌\↥
&fwa "input.txt"
