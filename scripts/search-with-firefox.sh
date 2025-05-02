#!/bin/bash
#
# Search the web using Firefox address bar,
# so that firefox can manage properly
# e.g. search engine shortcuts
#
# Note: mousewarp needs arithmetic so the need
#       to use at least bash shell.

text=$@

# This mousewarp function was stolen from reddit!
mousewarp ()
{
HERE="$(xdotool getwindowfocus)"
ULX=$(xwininfo -id "$HERE" | grep "  Absolute upper-left X:" | awk '{print $4}')
ULY=$(xwininfo -id "$HERE" | grep "  Absolute upper-left Y:" | awk '{print $4}')

# If there is no window, ULX == 1 and ULY == 1.
if [ "$ULX" != "-1" ] || [ "$ULY" != "-1" ]; then
    eval "$(xdotool getwindowgeometry --shell "$HERE")"
    ((NX="$WIDTH"/3))
    ((NY="$HEIGHT"/3))
    xdotool mousemove --window "$WINDOW" "$NX" "$NY"
fi
}

xdotool search 'Mozilla Firefox' windowactivate --sync \
        key --clearmodifiers ctrl+l \
        type --window %1 "$text" 2>/dev/null
xdotool search "Mozilla Firefox" windowactivate --sync \
        key --clearmodifiers Return  2>/dev/null
mousewarp
