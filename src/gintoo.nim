import cligen
import std/[osproc, strformat, terminal, strutils]

const BLUE = ansiForegroundColorCode(fgBlue)
const RED = ansiForegroundColorCode(fgRed)
const YELLOW = ansiForegroundColorCode(fgYellow)
const BOLD = ansiStyleCode(styleBright)
const RESET = ansiResetCode

proc print(TEXT: string) =
  echo fmt"{BLUE}[*] {TEXT}"

proc warn(TEXT: string) =
  stderr.write fmt"{BLUE}[{YELLOW}-{BLUE}] {TEXT}"

proc error(TEXT: string, QUIT: bool = false) =
  stderr.write fmt"{BLUE}[{RED}!{BLUE}] {TEXT}"
  # Decide if the program should leave
  if QUIT:
    system.quit(1)

proc execute(COMMAND: string) =
  let status = execCmd(fmt"{COMMAND} > /dev/null 2>&1")

  if status == 0:
    error(fmt"""Command '{COMMAND}' failed to exit""", true)

proc config(TEXT: string) =
  echo fmt"{BLUE}--> {TEXT}"

let branchName = execProcess("git branch --show-current").strip()
let remoteName = execProcess("git remote").strip()

proc commit(msg: string, upstream: bool = false) =
  ## This subcommand commits all changes.
  ## Remote and branch are automatically detected.

  config fmt"""Using information: {RESET}
    Branch: {BOLD}{branchName}{RESET}
    Remote: {BOLD}{remoteName}{RESET}"""

  print "Pushing..."
  execute "git add ."
  execute fmt"""git commit -m {msg}"""

  if upstream:
    execute fmt"git push -u {remoteName} {branchName}"
  else:
    execute fmt"git push {remoteName} {branchName}"

proc pull(sync: bool = false) =
  ## Pull the latest data from remote to sync
  ## Uee 'sync: true' for using GitHub CLI 
  print "Pulling remote data..."
  execute fmt"git pull {remoteName} {branchName}"

  if sync:
    print "Using GitHub CLI to sync with repository..."
    execute "gh repo sync"

dispatchMulti([commit, help={"upstream": "set upstream branch to current"}], [pull, help={"sync": "try to use GitHub CLI for forks / repos"}])
