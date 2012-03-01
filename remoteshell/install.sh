#!/bin/sh

# Shell
rm -f ~/.bashrc
ln -s ~/remoteshell/bashrc ~/.bashrc

# Mutt files
rm -f ~/.muttrc
rm -f ~/.mailcap
ln -s ~/remoteshell/muttrc ~/.muttrc
ln -s ~/remoteshell/mailcap ~/.mailcap
