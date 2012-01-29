#!/bin/sh
#
# Copyright (C) 2010, 2011, 2012 by Massimo Lauria <lauria.massimo@gmail.com>
#
# Created   : "2011-03-05, sabato 01:03 (CET) Massimo Lauria"
# Time-stamp: "2012-01-30, 00:17 (CET) Massimo Lauria"

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

# ------------------- Installation -------------------------

# Goto config folder.
cd $(dirname $0)

issue_warning_on_pwd "config"

echo "# 1. Check for the present of basic programs"
require_program $GIT
require_program $CUT
require_program $CP
require_program $LN
require_program $RM
require_program $MKDIR
echo ""
echo ""



echo "# 2. Check out all submodules"
#echo "# 2. Determines read/write privileges on the repo."
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

echo "# 5. Install other config files"
echo -n "# 5. backing up old config files..."

# GNUPG config file
backup_maybe $HOME/.gnupg/gpg.conf
# Python config files
backup_maybe $HOME/.sage/init.sage
backup_maybe $HOME/.sage/ipython/ipythonrc
backup_maybe $HOME/.sage/ipython/ipy_user_conf.py
backup_maybe $HOME/.ipython/ipythonrc
backup_maybe $HOME/.ipython/ipy_user_conf.py
backup_maybe $HOME/.ipython/profile_default/ipython_config.py
backup_maybe $HOME/.ipython/profile_default/ipython_qtconsole_config.py
# Matplotlib
backup_maybe $HOME/.matplotlib/matplotlibrc
# Other config files
backup_maybe $HOME/.mpdconf
backup_maybe $HOME/.muttrc
backup_maybe $HOME/.offlineimaprc
backup_maybe $HOME/.msmtprc
backup_maybe $HOME/.rsync-exclude
backup_maybe $HOME/.vimrc
backup_maybe $HOME/.jedrc
echo "OK."

# Do install
echo -n "# 5. installing new config files.."

# GNUPG
$RM -f $HOME/.gnupg/gpg.conf
$MKDIR -p $HOME/.gnupg/
$LN -s $PWD/gpg.conf $HOME/.gnupg/gpg.conf

# (I)PYTHON AND SAGEMATH
$RM -f $HOME/.ipython/ipythonrc
$RM -f $HOME/.ipython/ipy_user_conf.py
$RM -f $HOME/.sage/init.sage
$RM -f $HOME/.sage/ipython/ipythonrc
$RM -f $HOME/.sage/ipython/ipy_user_conf.py
$RM -f $HOME/.ipython/profile_default/ipython_config.py
$RM -f $HOME/.ipython/profile_default/ipython_qtconsole_config.py

$MKDIR -p $HOME/.ipython/profile_default/
$MKDIR -p $HOME/.sage/ipython/
$LN -s $PWD/pythonrc/ipythonrc $HOME/.ipython/ipythonrc
$LN -s $PWD/pythonrc/ipy_user_conf.py $HOME/.ipython/ipy_user_conf.py
$LN -s $PWD/pythonrc/init.sage        $HOME/.sage/init.sage
$LN -s $PWD/pythonrc/ipythonrc-sage   $HOME/.sage/ipython/ipythonrc
$LN -s $PWD/pythonrc/ipy_user_conf.py $HOME/.sage/ipython/ipy_user_conf.py
$LN -s $PWD/pythonrc/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py
$LN -s $PWD/pythonrc/ipython_qtconsole_config.py $HOME/.ipython/profile_default/ipython_qtconfig_config.py

# MATPLOTLIB
$RM -f $HOME/.matplotlib/matplotlibrc
$MKDIR -p $HOME/.matplotlib/
$LN -s $PWD/pythonrc/matplotlibrc $HOME/.matplotlib/matplotlibrc


# OTHERS

$RM -f $HOME/.mpdconf
$LN -s $PWD/mpdconf $HOME/.mpdconf

$RM -f $HOME/.muttrc
$LN -s $PWD/mutt/muttrc $HOME/.muttrc

$RM -f $HOME/.offlineimaprc
$LN -s $PWD/mail/offlineimaprc $HOME/.offlineimaprc

if [ -d $HOME/Library/LaunchAgents/ ]; then
    $RM $HOME/Library/LaunchAgents/offlineimap.daemon.plist
    $LN $PWD/mail/offlineimap.daemon.plist $HOME/Library/LaunchAgents/
fi

$RM -f $HOME/.msmtprc
$LN -s $PWD/mail/msmtprc $HOME/.msmtprc

$RM -f $HOME/.rsync-exclude
$LN -s $PWD/rsync-exclude.txt $HOME/.rsync-exclude

$RM -f $HOME/.vimrc
$LN -s $PWD/vimrc $HOME/.vimrc

$RM -f $HOME/.jedrc
$LN -s $PWD/jedrc $HOME/.jedrc

echo "OK"



# Local Variables:
# fill-column: 80
# End:
