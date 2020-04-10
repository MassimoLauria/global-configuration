#!/bin/sh

#
# Install shell configuration for various remote machines.
#
# FILES are installed on the remote
#
# When installing <filename> on <machine>, the file <filename>.<machine> 
# is appended (if such file exists)
#
DEFAULT_MACHINES="ml tera"
FILES="bashrc bash_profile bash_logout bash_aliases emacs"

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
        tmpfile=`mktemp`
        if [ -f "$file" ]; then
            cat "$file" >> $tmpfile
        fi
        if [ -f "$file.$machine" ]; then
            cat "$file.$machine" >> "$tmpfile"
        fi
        scp "$tmpfile" "$machine:~/.$file"
        rm -f $tmpfile
    done                
done
