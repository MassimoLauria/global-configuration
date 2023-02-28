#!/bin/sh
#
# Copyright (C) 2010, 2011, 2012, 2014, 2015, 2016, 2017, 2020, 2023 by Massimo Lauria <lauria.massimo@gmail.com>
#
# Created   : "2011-03-05, sabato 01:03 (CET) Massimo Lauria"
# Time-stamp: "2023-02-28, 23:11 (CET) Massimo Lauria"

# Description::
#
# My configuration files are rich and require some software to be
# present.  In some cases the configuration would gracefully ignore
# the missing software. Sometimes it is useless and inappropriate to
# force the installation of a software.
#
# This file will try to setup the configuration in a usable status.


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

backup_maybe() {
# Check backup possibility.
    if [ $# -ne 1 ]; then echo "Wrong argument number."; exit 1; fi
    if [ -e $1 ]; then
        $CP -af $1 $1.bak.`date +%Y-%m-%d.%H.%M.%S`
    fi
}

issue_warning_on_pwd() {
    if [ $# -ne 1 ]; then echo "Wrong argument number."; exit 1; fi
    if [ "$PWD" != "$HOME/$1" ]; then
        echo ""
        echo "WARNING: you are installing in a wrong path."
        echo "WARNING: the right path should be ~/$1."
        echo "WARNING: installation would go on, but something may not work properly."
        echo "WARNING: remember that moving folder requires running this script again."
        echo ""
    fi
}

# First we define the function
ConfirmOrExit() {
    while true
    do
        echo -n "Please confirm (y or n) : "
        read CONFIRM
        case $CONFIRM in
            y|Y|YES|yes|Yes) break ;;
            n|N|no|NO|No)
                echo Aborting - you entered $CONFIRM
                exit 1
                ;;
            *)
        esac
    done
    echo You entered $CONFIRM. Continuing ...
}


# ------------------- Installation -------------------------
clear 2>/dev/null

# Goto config folder.
cd $(dirname $0)

issue_warning_on_pwd "config"


echo "# 1. Check for the presence of basic programs"
require_program $GIT
require_program $CUT
require_program $CP
require_program $LN
require_program $RM
require_program $MKDIR
echo ""
echo ""

# Query for the optional programs
echo "The following list of optional program are required to install"
echo "all the features of this configuration.  Even if none of  them"
echo "is present a basic configuration will be installed anyway."
echo ""
echo "Many  other  programs  may be needed  to effectively  use this"
echo "configuration.  Nevertheless such  programs are  not needed to"
echo "complete the setup."
echo ""
echo "Please check whether the programs are present before proceeding."

echo "------------------------------------------------------------------------"
$CAT docs/optional_conf_requirements.txt
echo "------------------------------------------------------------------------"

echo "\nDo you want to proceed with the setup of the configuration? [y/n] "

ConfirmOrExit



echo "# 2. Check out all submodules"
$GIT submodule init
$GIT submodule update
echo ""
echo ""

SUBMODULES=`$GIT submodule|$CUT -d' ' -f3`

echo "# 3. Put all submodules to master branch"
for SUBM in $SUBMODULES; do
    if [ ! -d "$SUBM" ]; then
        echo "# 3. Oops! Something in wrong with the submodules list."
        echo "# 3. Please do not run the install script in a non clean installation."
        echo ""
    else
        echo "# 3. checking out $SUBM master branch"
        cd $SUBM
        $GIT checkout master
        cd ..
        echo "# 3. $SUBM master branch cheched out"
        echo ""
    fi
done
echo ""

echo "# 4. Recursively setup all submodules"
for SUBM in $SUBMODULES; do
    if [ ! -d "$SUBM" ]; then
        echo "# 4. oops! something wrong in the submodules list."
        echo "# 4. do not run install script in a non clean installation."
    else
        if [ -x $SUBM/install.sh ]; then
            echo "# 4. $SUBM module requires an install procedure"
            $SUBM/install.sh
            echo "# 4. $SUBM module installed"
        fi
    fi
done
echo ""
echo ""

# Do install
echo "# 5. installing new config files.."



# GNUPG config file
# backup_maybe $HOME/.gnupg/gpg.conf
# $RM -f  $HOME/.gnupg/gpg.conf
# $RM -fr $HOME/.gnupg/private-keys-v1.d/
# $MKDIR -p $HOME/.gnupg/private-keys-v1.d/
# $LN -s $PWD/gpg.conf $HOME/.gnupg/gpg.conf
# $LN -s $HOME/personal/keys/private-keys-v1.d/ $HOME/.gnupg/


# ipython
$RM -fr $HOME/.ipython
$LN -s $PWD/python/ipython $HOME/.ipython

# matplotlib
$RM -fr $HOME/.matplotlib
$LN -s $PWD/python/matplotlib $HOME/.matplotlib

# sagemath
$RM -f $HOME/.sage/init.sage
$MKDIR -p $HOME/.sage/
$LN -s $PWD/python/init.sage        $HOME/.sage/init.sage

# Vim
$RM -f $HOME/.vimrc
$LN -s $PWD/vimrc $HOME/.vimrc

# GDB
$RM -f $HOME/.gdbinit
$LN -s $PWD/gdbinit $HOME/.gdbinit

# TMUX
$RM -f $HOME/.tmux.conf
$LN -s $PWD/tmux.conf $HOME/.tmux.conf

echo "OK"



# Local Variables:
# fill-column: 80
# End:
