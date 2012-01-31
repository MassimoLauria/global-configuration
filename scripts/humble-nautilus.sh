#!/bin/sh

# Humble Nautilus, i.e. make nautilus less annoying.  Just in case
# some random app calls on Nautilus, let's set some safeguards to
# minimize the impact.

# Run this once for all!

if [ -x /usr/bin/gconftool-2 ]; then
# Disable Nautilus desktop, because we really really do not want it!
    gconftool-2 -s -t bool /apps/nautilus/preferences/show_desktop false
# Do not let Nautilus set the background, because we really really do not want this either.
    gconftool-2 -s -t bool /desktop/gnome/background/draw_background false
# Make Nautilus use spatial mode, this should make start-up quicker (not enforced).
    gconftool-2 -s -t bool /apps/nautilus/preferences/always_use_browser true
# Make Nautilus show the advanced permissions dialog -- if it has to start, lets at least make it usable :)
    gconftool-2 -s -t bool /apps/nautilus/preferences/show_advanced_permissions true
fi

if [ -f /usr/bin/gsettings ]; then
    gsettings set org.gnome.desktop.background show-desktop-icons false
fi
