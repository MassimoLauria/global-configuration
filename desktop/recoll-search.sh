#!/bin/sh
#
# Copyright (C) 2013 by Massimo Lauria
#
# Created   : "2013-04-17, Wednesday 17:55 (CEST) Massimo Lauria"
# Time-stamp: "2013-04-17, 18:22 (CEST) Massimo Lauria"
#
# Description::
#
# Desktop search tool built around recoll and dmenu
#

# Configuration
QUERY_TOOL="recoll -b -t"
PROMPT_THEME='-nf #dcdcdc -nb #2f2f2f -sb #a6c292 -sf black'

# Code::

# Use argument or query interactively.
if [ -z "$@" ]; then
    QUERY=`dmenu $PROMPT_THEME -p "Search in documents:" </dev/null` 
else
    QUERY="$@"
fi

DOC=$($QUERY_TOOL "$QUERY"  | grep 'file://' \
      | sed -e 's|^ *file://||' | sed -e "s|$HOME/||" \
      | perl -e 'use URI::Escape; print uri_unescape(<STDIN>);' \
      | dmenu -p 'Choose file:' \
              -i $PROMPT_THEME -l 30)


if [ "x$DOC" != x ]; then
    xdg-open "$HOME/$DOC"
fi

# Local Variables:
# fill-column: 80
# End:
