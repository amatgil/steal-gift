#!/usr/bin/env uiua

┌─╴AoCGet
  # Read `.env` file and return the corresponding map
  # Map ?
  GetMap ↚ map°⊟⍉ ⊜(⍜(°□⊡1|▽⊸≠@\u{22}) ⊜□ ⊸≠@=)⊸≠@\n ⍣(&fras ".env"|⍤".env file does not exist"0)

  # Read session cookie from `.env`
  # Expects the file to exist
  ReadCookie ↚ ▽⊸(≠@\u{22}) ⍣(get"session"|⍤".env file does not contain with `session`"0) GetMap

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
       ↘¯1 &fras # Drop ending newline
      ))
  )
└─╴
