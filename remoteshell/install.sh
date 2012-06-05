#!/bin/sh

# Shell
rm -f ~/.bashrc
ln -s ~/remoteshell/bashrc ~/.bashrc
rm -f ~/.bash_profile
ln -s ~/remoteshell/bash_profile ~/.bash_profile


# Mutt files
rm -f ~/.muttrc
rm -f ~/.mailcap
ln -s ~/remoteshell/muttrc ~/.muttrc
ln -s ~/remoteshell/mailcap ~/.mailcap
