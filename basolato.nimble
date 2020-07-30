# Package

version       = "0.5.5" # https://github.com/itsumura-h/nim-basolato/issues/87
author        = "Hidenobu Itsumura @dumblepytech1 as 'medy'"
description   = "A full-stack web framework library for Nim"
license       = "MIT"
srcDir        = "src"
backend       = "c"
bin           = @["basolato/cli/ducere"]
binDir        = "src/bin"
installExt    = @["nim"]
skipDirs      = @["basolato/cli"]

# Dependencies

requires "nim >= 1.0.0"
requires "cligen >= 0.9.41"
requires "httpbeast >= 0.2.2"
requires "templates >= 0.5"
requires "bcrypt >= 0.2.1"
requires "nimAES >= 0.1.2"
requires "flatdb >= 0.2.4"
requires "allographer >= 0.12.2"
requires "faker >= 0.13.2"

# import strformat
# from os import `/`

# task docs, "Generate API documents":
#   let
#     deployDir = "deploy" / "docs"
#     pkgDir = srcDir / "basolato"
#     srcFiles = @[
#       "base","controller","logger","middleware","routing","view"
#     ]

#   if existsDir(deployDir):
#     rmDir deployDir
#   for f in srcFiles:
#     let srcFile = pkgDir / f & ".nim"
#     exec &"nim doc --hints:off --project --out:{deployDir} --index:on {srcFile}"
task toc, "Generate TOC":
  exec "wget https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc"
  exec "chmod +x gh-md-toc"
  exec "./gh-md-toc --insert *.md documents/*.md"
  rmFile "gh-md-toc"

task install, "install":
  discard
after install:
  echo ""
  echo "|\\ |  |  |\\  /|"
  echo "| \\|  |  | \\/ |"
  echo " __        __   __           ___  __"
  echo "|__)  /\\  (__  /  \\ |    /\\   |  /  \\"
  echo "|__) /--\\  __) \\__/ |__ /--\\  |  \\__/"
  echo " __   __                  __           __    __"
  echo "|__  |__)   /\\   |\\  /|  |__  \\    /  /  \\  |__)  |_／"
  echo "|    |  \\  /--\\  | \\/ |  |__   \\/\\/   \\__/  |  \\  | ＼"
  echo ""
