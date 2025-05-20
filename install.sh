#!/bin/sh
#
# Copyright (C) 2010, 2011, 2012, 2014, 2015, 2016, 2017, 2020, 2023, 2025 by Massimo Lauria <lauria.massimo@gmail.com>
#
# Created   : "2011-03-05, sabato 01:03 (CET) Massimo Lauria"
# Time-stamp: "2025-05-20, 09:33 (CEST) Massimo Lauria"

# Description::
#
# This file will try to setup my configuration in a usable status.
# it relies on the presence of other subconfigurations

CONF=$HOME/config
PERSONAL=$HOME/personal

MYREPO=$PERSONAL/myrepositories

if [ -f "$MYREPO" ]; then
    # try to download missing repos
    $MYREPO clone
fi


#  Emacs and Vim/Nano/GDB
echo "Editor config files"
mkdir -p $HOME/.emacs.d
ln -sf $CONF/emacs/init.el $HOME/.emacs.d/init.el
ln -sf $CONF/vimrc $HOME/.vimrc
ln -sf $CONF/nanorc $HOME/.nanorc
ln -sf $CONF/gdbinit $HOME/.gdbinit


# Terminals
echo "Terminal config files"
ln -sf $CONF/alacritty $HOME/.config/
ln -sf $CONF/ghostty $HOME/.config/
ln -sf $CONF/mc $HOME/.config/

# Shell stuff
echo "Shell config files"
if [ -f $CONF/shell ]; then
    ln -sf $CONF/shell/zshrc   $HOME/.zshrc
    ln -sf $CONF/shell/bashrc  $HOME/.bashrc
    ln -sf $CONF/shell/profile $HOME/.profile
    ln -sf $CONF/shell/inputrc $HOME/.inputrc
fi

# X session stuff
echo "Xsession config files"
if [ -d $CONF/xsession ]; then
    ln -sf $CONF/xsession/xsession    $HOME/.xsession
    ln -sf $CONF/xsession/autostart/*.desktop   $HOME/.config/autostart
    mkdir -p $HOME/.config/i3
    mkdir -p $HOME/.config/i3status
    ln -sf $CONF/xsession/i3-config $HOME/.config/i3/config
    ln -sf $CONF/xsession/i3status-config $HOME/.config/i3status/config
    mkdir -p $HOME/.config/gtk-3.0/
    ln -sf $CONF/xsession/gtk3-settings.ini $HOME/.config/gtk-3.0/settings.ini
    ln -sf $CONF/xsession/mimeapps.list $HOME/.config/mimeapps.list
    ln -sf $CONF/xsession/user-dirs.dirs $HOME/.config/user-dirs.dirs
    mkdir -p $HOME/.config/flashfocus
    ln -sf $CONF/xsession/flashfocus.yml $HOME/.config/flashfocus/flashfocus.yml
fi

# GNUPG/SSH/GIT personal config files
echo "GNUPG/SSH/GIT config files"
if [ -d $PERSONAL ]; then
    mkdir -p $HOME/.gnupg/
    ln -sf $CONF/gpg.conf $HOME/.gnupg/gpg.conf
    ln -sf $PERSONAL/keys/private-keys-v1.d/ $HOME/.gnupg/
    mkdir -p $HOME/.ssh/
    ln -sf $PERSONAL/conf/sshconfig $HOME/.ssh/config
    ln -sf $PERSONAL/conf/gitconfig $HOME/.gitconfig
fi

# Python stuff
echo "Python stuff"
rm -fr $HOME/.ipython
rm -fr $HOME/.matplotlib
ln -s $CONF/python/ipython     $HOME/.ipython
ln -s $CONF/python/matplotlib  $HOME/.matplotlib
mkdir -p $HOME/.config/pip
ln -fs $CONF/python/pip.conf $HOME/.config/pip/pip.conf
if [ -d $PERSONAL ]; then
    ln -sf $PERSONAL/conf/pypirc $HOME/.pypirc
fi

# Latexmk
mkdir -p $HOME/.config/latexmk
ln -fs $CONF/latexmkrc  $HOME/.config/latexmk/

# Other apps and games
if [ -d $PERSONAL ]; then
    cp -rf $PERSONAL/conf/calibre $HOME/.config/
fi
if [ -d $HOME/games/ ]; then
    ln -sf $HOME/games/retroarch/ $HOME/.config/
    ln -sf $HOME/games/c64/vice/  $HOME/.config/
    ln -sf $HOME/games/scummvm/scummvmrc  $HOME/.scummvmrc
fi


# Local Variables:
# fill-column: 80
# End:
