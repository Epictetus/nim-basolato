# Package
version       = "0.1.0"
author        = "Anonymous"
description   = "A new awesome basolato package"
license       = "MIT"
srcDir        = "."
bin           = @["main"]
backend       = "c"
# Dependencies
requires "nim >= 1.2.6"
requires "https://github.com/itsumura-h/nim-basolato >= 0.6.1"
requires "cligen >= 0.9.41"
requires "templates >= 0.5"
requires "bcrypt >= 0.2.1"
requires "nimAES >= 0.1.2"
requires "flatdb >= 0.2.5"
# requires "allographer >= 0.9.0"
requires "allographer#head"
requires "faker >= 0.12.1"
