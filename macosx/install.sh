#!/bin/sh
#
# Copyright (C) 2016, 2017 by Massimo Lauria
#
# Created   : "2016-11-21, Monday 16:21 (CET) Massimo Lauria"
# Time-stamp: "2017-03-29, 03:15 (CEST) Massimo Lauria"
#
# Description::
#
# Installation and configuration of a basic MacOSX system
#

# Make shell more robust
# (see http://redsymbol.net/articles/unofficial-bash-strict-mode/#sourcing-nonconforming-document)
set -euo pipefail
IFS=$'\n\t'

# Code::

# -------------------- Env Variables ------------------------
GIT=git
CUT=cut
CP=cp
LN=ln
RM=rm
MKDIR=mkdir
CAT=cat
FILE_NOT_FOUND=127


# ------------------- Utilities -----------------------------
require_program()
{
    if [ $# -ne 1 ]; then echo "Wrong argument number."; exit 1; fi

    echo -n "Checking for '$1'... "
    which $1 2> /dev/null > /dev/null
    if [ $? -ne 0 ]; then
        echo "FAIL."
        exit_on_missing_program $1
    else
        echo "OK."
    fi
}

exit_on_missing_program() {
    echo ""
    echo "Unfortunately program \"$1\" is not present, or it is not executable."
    echo "Without this software, I can't finish the installation."
    echo ""
    echo "Bye bye."
    exit $FILE_NOT_FOUND
}

# Basic 
echo "# 1. Basic utilities"
xcode-select --install || echo "Already installed."

# Homebrew
echo "# 2. Setup Homebrew"
type brew >/dev/null && echo "Already installed." || \
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Taps
echo "# 3. Setup Homebrew Taps"
brew tap caskroom/cask
brew tap mht208/formal


# Homebrew packages
echo "# 4. Install packages"
# brew cask install skype
# brew cask install iterm2
# brew cask install quicksilver
# brew cask install amethist



# Fixing Keyboard (global)
#
# Syntax is
# defaults write <AppName> NSUserKeyEquivalents -dict-add "Menu Item" -string "@$~^k"
#
# where <AppName> is "-g" for global shortcuts
#
# Modifiers: @ -> Command ;  $ -> Shift ; ~ -> Alt ; ^ -> Control
#
echo "# 5. Fix keyboard"
# Cut and Paste
defaults -currentHost write -g NSUserKeyEquivalents -dict-add "Cut"   -string "^x"
defaults -currentHost write -g NSUserKeyEquivalents -dict-add "Copy"  -string "^c"
defaults -currentHost write -g NSUserKeyEquivalents -dict-add "Paste" -string "^v"
defaults -currentHost write -g NSUserKeyEquivalents -dict-add "Undo"  -string "^z"
defaults -currentHost write -g NSUserKeyEquivalents -dict-add "Redo"  -string "$^z"
# Local Variables:
# fill-column: 80
# End:
