#!/usr/bin/env uiua

┌─╴AoC ~ Fetch
  # Read session cookie from `.env`
  # Expects the file to exist
  ReadCookie ↚ ▽⊸(≠@\u{22}) antijoin"session="↘¯1 &fras ".env"
  
  # ? Year Day Filename
  Fetch ← (
    ⊙⊙ReadCookie
    $"GET /_/day/_/input HTTP/1.1\r\nHost: adventofcode.com\r\nConnection: close\r\nCookie: session=_\r\n\r\n"
    "adventofcode.com:443"
  
    ⍜&tlsc(&rs∞ ⊸&w:)
    ⊸⦷"\r\n\r\n"
    ▽¬⍜⇌\↥
    &fwa:?
  )
  Call ← Fetch
└─╴

+ 1 2
