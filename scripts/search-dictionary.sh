#!/bin/sh
#
# Massimo Lauria, 2020-2025
#
# Shell utilities for dictionaries
#
# Requirements:
#
# - fzf         fuzzy finder   (https://github.com/junegunn/fzf)
# - sdcv        StarDict Console Version

WORDFILE=$HOME/personal/dictionaries/wordlists/english_and_italian.txt

_d_check_runtime() {
    local fail=0
    type fzf >/dev/null 2>&1 ||
        { echo >&2 "Required 'fzf' command is missing."; fail=1; }
    type sdcv >/dev/null 2>&1 ||
        { echo >&2 "Required 'sdcv' command is missing."; fail=1; }
    return $fail
}

_d_check_runtime || exit 1

args=""
query=""q

if [ "$#" -ge 1 ]; then
    query="-q"
    args=$@
fi

cat $WORDFILE |
    fzf -i --print0  \
        $query $args \
        --prompt "Cerca: " \
        --preview "sdcv -enc0 {}" \
        --preview-window wrap  --bind '?:toggle-preview' | xargs -0 -n 1 sdcv -enc0 2>/dev/null
