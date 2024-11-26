#!/usr/bin/env uiua

┌─╴AoCGet
  # Read `.env` file and return the corresponding map
  # Map ?
  GetEnvMap ↚ map°⊟⍉ ⊜(⍜(°□⊡1|▽⊸≠@\u{22}) ⊜□ ⊸≠@=)⊸≠@\n ⍣(&fras ".env"|⍤".env file does not exist"0)

  # Read session cookie from `.env`
  # Expects the file to exist
  ReadCookie ↚ ▽⊸(≠@\u{22}) ⍣(°□get"session"|⍤".env file does not contain required `session`"0) GetEnvMap

  # Path ? Year Day
  # Reads from .env to find full path
  InputDestPath ↚ |2 (
    GetEnvMap
    ⍣(°□get"cachedInputsPath"|⍤".env file does not contain required `cachedInputsPath`"0)
    ⍣⍜⇌(⌝⊂@/)∘     # Trim trailing backslash (no rsync cosplay here)
    ⊙⊙(⬚@0↙ ¯2 °⋕) # Pad day
    $"_/_-_.txt"
  )

  # ? Filepath Contents
  # Write contents to file, creating its parent directories if they doesn't exist
  MkdirAndWrite ↚ |2.0 (
    ⊸(≠@/)
    ⊸(▽¬⍜⇌\↧)
    &fmd
    &fwa
  )

  # url ? Year Day Cookie
  CreateUrl ↚ |3 $"GET /_/day/_/input HTTP/1.1\r\nHost: adventofcode.com\r\nConnection: close\r\nCookie: session=_\r\n\r\n"

  # Input ? Year Day
  # Expects a file called `.env` to exist in the directory
  # containing the session cookie. If Filename does not exist,
  # it will be downloaded; otherwise it is simply read
  Call ← |2 (
    ⍣(&p "Found local input, reading from disk" &fras InputDestPath
    | (&p "No local input found, fetching from server"
       ⊙⊙ReadCookie
       ⊃(CreateUrl|⊙⊙◌)
       "adventofcode.com:443"
       ⍜&tlsc(&rs∞ ⊸&w:) # Fetch input
       # dump(↙100)
       # TODO: Display return string if it's not 200 OK
       ⍣⌝⊂(⍤"Server did not return 200, is the session cookie correct?"0) "HTTP/1.1 200" # Make sure it's 200 OK
       ▽⍜⇌\↧ ¬⊸⦷"\r\n\r\n"                                                               # Remove http fluff
       ↘¯1                                                                               # And trailing newline
       ⊙InputDestPath                                                                    # Save after padding day number
       ⊸(MkdirAndWrite):
      ))
  )
└─╴
