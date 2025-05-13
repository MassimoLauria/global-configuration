#!/bin/bash

CFG=$HOME/config/python

mkdir -p $HOME/.config/

echo "Installing basic python config files"
rm -f $HOME/.pythonrc.py
ln -s $CFG/pythonrc.py $HOME/.pythonrc.py
rm -f $HOME/.pdbrc
ln -s $CFG/pdbrc $HOME/.pdbrc
rm -f $HOME/.config/pip/pip.conf
mkdir -p $HOME/.config/pip
ln -s $CFG/pip.conf $HOME/.config/pip/pip.conf
rm -f $HOME/.pylintrc
ln -s $CFG/pylintrc $HOME/.pylintrc
rm -f $HOME/.config/flake8
ln -s $CFG/flake8 $HOME/.config/flake8

# Update pip and install all packages
python -m ensurepip --upgrade 2>&1 >/dev/null
python -m pip install -U pip
python -m pip install -U -r requirements.txt
