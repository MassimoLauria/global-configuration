#!/bin/sh

#
# Install shell configuration for various remote machines.
#
DEFAULT_MACHINES="ml tera"
FILES="bashrc bash_profile bash_logout bash_aliases"

#  
# Requirements: a decent bash
# Features: emacs server running on the system
#
if (($# > 0)); then
    MACHINES="$@"
else
    MACHINES="$DEFAULT_MACHINES"
fi

for machine in ${MACHINES}; do
    for file in ${FILES}; do
        scp "$file" "$machine:~/.$file"
    done                
done
