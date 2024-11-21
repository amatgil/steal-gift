#!/usr/bin/env uiua

┌─╴AoCFetch
  # Read session cookie from `.env`
  # Expects the file to exist
  ReadCookie ↚ ▽⊸(≠@\u{22}) ⍣(⌝⊂"session="↘¯1|⍤".env file does not start with `session=`"0) ⍣(&fras ".env"|⍤".env file does not exist"0)

  # Input ? Year Day Filename
  # Expects a file called `.env` to exist in the directory
  # containing the session cookie. If Filename does not exist,
  # it will be downloaded; otherwise it is simply read
  Call ← (
    ⍣(&fras ◌◌
    | (⊙⊙ReadCookie
       $"GET /_/day/_/input HTTP/1.1\r\nHost: adventofcode.com\r\nConnection: close\r\nCookie: session=_\r\n\r\n"
       "adventofcode.com:443"
       ⍜&tlsc(&rs∞ ⊸&w:)                                                                 # Fetch input
       ⍣⌝⊂(⍤"Server did not return 200, is the session cookie correct?"0) "HTTP/1.1 200" # Make sure it's 200 OK
       ▽¬⍜⇌\↥ ⊸⦷"\r\n\r\n"                                                               # Remove fluff
       ⟜&fwa:
       &fras
      ))
  )
└─╴

↙100 AoCFetch 2023 3 "input.txt"
