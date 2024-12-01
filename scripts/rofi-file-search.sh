#!/bin/sh
#
# Copyright (C) 2013, 2021, 2022, 2024 by Massimo Lauria
#
# Created   : "2013-04-17, Wednesday 17:55 (CEST) Massimo Lauria"
# Time-stamp: "2024-12-01, 15:47 (CET) Massimo Lauria"
#
# Description::
#
# Desktop search tool built around rofi and fd-find
#

#PROMPT_THEME='-nf #dcdcdc -nb #2f2f2f -sb #a6c292 -sf black'
PROMPT_THEME=Monokai

# Code::

# Use argument or query interactively.
if [ -z "$@" ]; then
    QUERY=`rofi -dmenu -l 0 -p "File search" -theme $PROMPT_THEME </dev/null`
else
    QUERY="$@"
fi

DOC=$(fdfind --type f "$QUERY" $HOME \
    | rofi -keep-right -i -dmenu -p 'Choose file' \
           -l 30 -show-icons -theme $PROMPT_THEME)


if [ "x$DOC" != x ]; then
    xdg-open "$DOC"
fi

# Local Variables:
# fill-column: 80
# End:
