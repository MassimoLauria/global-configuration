#!/bin/sh
#
# Copyright (C) 2016 by Massimo Lauria
#
# Created   : "2016-11-21, Monday 16:21 (CET) Massimo Lauria"
# Time-stamp: "2016-11-21, 16:45 (CET) Massimo Lauria"
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
xcode-select --install

# Homebrew
echo "# 2. Setup Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Taps
brew tap caskroom/cask
brew tap mht208/formal


# Homebrew packages
brew cask install skype
brew cask install iterm2
brew cask install quicksilver
brew cask install amethist



# Local Variables:
# fill-column: 80
# End:
