#!/bin/sh
#
# Copyright (C) 2013, 2021, 2022 by Massimo Lauria
#
# Created   : "2013-04-17, Wednesday 17:55 (CEST) Massimo Lauria"
# Time-stamp: "2022-01-07, 12:45 (CET) Massimo Lauria"
#
# Description::
#
# Desktop search tool built around recoll and dmenu
#

# Configuration
QUERY_TOOL="recoll -b -t"
#PROMPT_THEME='-nf #dcdcdc -nb #2f2f2f -sb #a6c292 -sf black'
PROMPT_THEME=Monokai

# Code::

# Use argument or query interactively.
if [ -z "$@" ]; then
    QUERY=`rofi -dmenu -l 0 -p "File search" -theme $PROMPT_THEME </dev/null`
else
    QUERY="$@"
fi

DOC=$($QUERY_TOOL "$QUERY"  | grep 'file://' \
      | sed -e 's|^ *file://||' | sed -e "s|$HOME/||" \
      | perl -e 'use URI::Escape; print uri_unescape(<STDIN>);' \
      | rofi -dmenu -p 'Choose file' \
              -l 30 -show-icons -theme $PROMPT_THEME )


if [ "x$DOC" != x ]; then
    xdg-open "$HOME/$DOC"
fi

# Local Variables:
# fill-column: 80
# End:
