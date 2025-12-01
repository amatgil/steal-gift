#!/usr/bin/env uiua

┌─╴AoCGet
  # The literal quote character, typing it literally makes my lsp freak out
  Quote ↚ @\u{22}

  # [key value] ? Key="Value"
  # Takes a single string of the form `Key="Value"` and splits into a key
  # and value (with included error checking)
  ParseKeyValue ← (
    Trim ← ▽¬ ↧1+⊃(⍜⇌\×|\×)⊸=@\s
    ParseKey ← Trim
    ParseValue ← (
      Trim
      ⍥↘₁≍Quote⊸⊢
      ⍥↘₋₁ ≍Quote⊸⊣
    )

    ⊜□⊸≠@=
    ⍣(⍜(°□⊡0)ParseKey|˜⍤0$"Invalid/missing key in .env file: '_' (_)")
    ⍣(⍜(°□⊡1)ParseValue|˜⍤0$"Invalid/missing value in .env file: '_' (_)")
  )

  # Read `.env` file and return the corresponding map
  # Map ?
  GetEnvMap ↚ memo(
    ⍣(&fras ".env"|&fras "../.env"|⍤".env (or ../.env) file does not exist"0)
    map°⊟⍉ ⊜ParseKeyValue ⊸≠@\n
  )

  # Read session cookie from `.env`
  # Expects the file to exist
  # Cookie ?
  ReadCookie ↚ |0 ⍣(°□get"session"|⍤".env file does not contain required `session`"⋅0) GetEnvMap

  # Read the `$contact` information from `.env`
  # Aoc guidelines ask that, if one is using an automated method to obtain
  # input, that the User-Agent contain a way to contact the user (otherwise,
  # they'll get immediately IP-Banned)
  #
  # Errors if it doesn't exist
  ReadContactInfo ↚ ⍣(°□get"contact"|⍤".env file does not contain non-required `contact`"⋅0) GetEnvMap

  # Path ? Year Day
  # Reads from .env to find full path
  InputDestPath ↚ |2 (
    GetEnvMap
    ⍣(°□get"cachedInputsPath"|⍤".env file does not contain required `cachedInputsPath`"⋅0)
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

  # Is debug on <=> DEBUG="literally anything"
  IsDebugOn ↚ ⍣(1◌get"debug"|0)GetEnvMap

  # url ? Year Day Cookie UserAgent
  CreateUrl ↚ |4 $"GET /_/day/_/input HTTP/1.1\r\nHost: adventofcode.com\r\nConnection: close\r\nCookie: session=_\r\nUser-Agent: _\r\n\r\n"

  # is ? X Y
  # Returns whether Y is before X.
  # They must both be [Year Month Day]
  IsBefore ↚ ≍⊙◌⊸⍜{⊙∘}⍆

  # This is here for mnemonics
  CurrDate ↚ ↙₃datetimenow

  # has ? Year Day
  # Equivalent to the question: Is the requested date before the current date?
  HasDateArrived ↚ |2 IsBefore CurrDate ⊟₃⊙12

  # has ? Year Day
  # OPPOSITE to the question: Is the requested date before december 2015?
  HasDateAfterEpoch ↚ |2 ¬IsBefore [2015 12 1] ⊟₃⊙12

  # ? Year Day
  # Errors if the date has not arrived
  AssertHasArrived ↚ |2.0 ˜⍤⊙$"The year/day \"_/_\" still hasn't arrived!" ◡HasDateArrived

  # ? Year Day
  # Errors if the date is before 2015/12/1
  AssertAfterEpoch ↚ |2.0 ˜⍤⊙$"The year/day \"_/_\" means before the very first aoc problem! (Which was on 2015) " ◡HasDateAfterEpoch

  # ? Year Day
  # Errors if date is invalid
  AssertDateIsValid ↚ |2.0 ⊃(AssertHasArrived|AssertAfterEpoch)

  # ? HttpResponse
  # Checks that the response is 200 and drops that part of the response
  CleanInput ← (
    "HTTP/1.1 200"
    ⍣⌝⊂(˜⍤0 $"Server did not return 200, are the session cookie and Year/Day correct? (Returned: _)" /◇⊂₃@\s↙₂⊜□ ⊸≠@\s◌)
  )

  # Input ? Year Day
  FetchInput ← (
    (|2 CreateUrl ⊙⊙⊃(ReadCookie|ReadContactInfo)) # Get the url
    (|1 ⍜&tlsc˜(&rs∞ ⊸&w) "adventofcode.com:443")  # Actual fetching
  )

  # ? x ValueName
  # Errors if x is not a positive integer greater than 0.
  AssertPositiveInteger ← |2.0 (
    ⟜˜$"Given _ (value '_') is not a positive integer"
    ◡(˜⍤ ≍0type)
    ˜⍤ ×⊃(≥1|≍⊸⌊)
  )

  # Input ? Year Day
  # Expects a file called `.env` to exist in the directory containing the session
  # cookie. If Filename does not exist, it will be downloaded; otherwise it is simply read
  Call ← |2 (
    ◡(|2.0 ⊓(˜AssertPositiveInteger"Year"|˜AssertPositiveInteger"Day"))
    ⍣(⍥(&p"Found local input, reading from disk")IsDebugOn &fras InputDestPath
    | (⍥(&p"No local input found, fetching from server")IsDebugOn
       ◡(|2.0 AssertDateIsValid)
       ◡(|2 FetchInput)                   # Input Year Day <- Year Day
       (|1 CleanInput)                    # Errors if not 200
       (|1 ↘¯1▽⍜⇌\↧ ¬⊸⦷"\r\n\r\n")        # Drop http fluff
       (|3 ⟜˜MkdirAndWrite⊙InputDestPath) # Save after padding day number
      ))
  )
  # This function was stressing me out (because it's time sensitive) so
  # i'm writing explicit tests for it
  ┌─╴test
    ⍤⤙≍1 IsBefore[2025 0 0] [2024 0 0]
    ⍤⤙≍1 IsBefore[2025 12 1] [2024 11 30]
    ⍤⤙≍0 IsBefore[2024 11 30] [2025 12 1]
    ⍤⤙≍0 IsBefore[2025 12 1] [2025 12 2]
    ⍤⤙≍1 IsBefore[2025 12 2] [2025 12 1]
    ⍤⤙≍0 IsBefore[2025 11 1] [2025 11 2]
    ⍤⤙≍1 IsBefore[2025 11 2] [2025 11 1]
    ⍤⤙≍0 IsBefore[2024 12 5] [2025 12 5]
    ⍤⤙≍1 IsBefore[2025 12 5] [2024 12 5]
  └─╴
└─╴
