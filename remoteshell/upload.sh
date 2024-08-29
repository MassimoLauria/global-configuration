#!/bin/bash

#
# Install shell configuration for various remote machines.
#
# FILES are installed on the remote
#
# When installing <filename> on <machine>, the file <filename>.<machine>
# is appended (if such file exists)
#
DEFAULT_MACHINES="ml tera repo"

#
# Requirements: a decent bash
if (($# > 0)); then
    MACHINES="$@"
else
    MACHINES="$DEFAULT_MACHINES"
fi

for machine in ${MACHINES}; do
    echo "Upload files to host:$machine"
    # shell
    scp "profile" "$machine:~/.profile"
    scp "bashrc"  "$machine:~/.bashrc"
    [ -f bashrc.$machine ] && scp "bashrc.$machine" "$machine:~/.bashrc.local"
    # editors
    scp "nanorc" "$machine:~/.nanorc"
    ssh $machine 'mkdir -p ~/.emacs.d/'
    scp "emacs" "$machine:~/.emacs.d/init.el"
done
