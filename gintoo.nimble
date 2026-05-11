# Package

version       = "0.1.3"
author        = "jordan15citizen"
description   = "A CLI tool"
license       = "MIT"
srcDir        = "src"
bin           = @["gintoo"]

# Dependencies

requires "nim >= 2.2.6"
requires "cligen"

# Task

task make, "Make the release binary":
  exec "nimble build -d:danger --opt:speed -d:strip && mv gintoo bin"
