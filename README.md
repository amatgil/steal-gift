# AoCFetch

## Usage
**IMPORTANT**: You must place your session cookie inside a `.env` file, like such:
```sh
# In .env
session="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
The `session` cookie must be the first line in the file (for now).

To get it, log into your account at adventofcode.com and use the DevTools to find it.

Then, in your code, you may run:
```
AoC 2023 2 "input.txt" # Year, Date, where you want it to get saved/read from
```
