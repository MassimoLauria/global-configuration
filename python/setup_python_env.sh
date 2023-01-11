#!/bin/bash

CFG=$HOME/config/python
PYENV_ROOT="$HOME/.pyenv"


echo "Installing basic python config files"
rm -f $HOME/.pythonrc.py
ln -s $CFG/pythonrc.py $HOME/.pythonrc.py
rm -f $HOME/.pdbrc
ln -s $CFG/pdbrc $HOME/.pdbrc


echo "Installing checker config files"
mkdir -p $HOME/.config/

rm -f $HOME/.pylintrc
ln -s $CFG/pylintrc $HOME/.pylintrc
rm -f $HOME/.config/flake8
ln -s $CFG/flake8 $HOME/.config/flake8

# Install pyenv if necessary
if [ ! -d $PYENV_ROOT ]; then
    echo "Pyenv not found: installing"
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    echo "$(pyenv root)"
fi

# Install pyenv support for virtual environments
if [ ! -d $(pyenv root)/plugins/pyenv-virtualenv ];then
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    eval "$(pyenv virtualenv-init -)"
fi

# Install pyenv support for updating
if [ ! -d $(pyenv root)/plugins/pyenv-update ];then
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
fi


# Update the system
pyenv update
#PYENV_PYVERSION=$(pyenv install -l | grep '[[:space:]]3.[[:digit:]]*.[[:digit:]]*$' | grep -v 'rc\|dev' | tail -1)
PYENV_PYVERSION=$(pyenv install -l | grep '[[:space:]]3.10.[[:digit:]]*$' | grep -v 'rc\|dev' | tail -1)
echo "Maybe install release $PYENV_PYVERSION in pyenv"
yes n | pyenv install $PYENV_PYVERSION
pyenv local $PYENV_PYVERSION

# Update pip and install all packages
pip install -U pip
pip install -U -r requirements.txt
