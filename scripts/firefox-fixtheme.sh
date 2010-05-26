#!/bin/sh

# This fixes the bad behaviour of Firefox with Darklooks theme

FALLBACK_THEME="New Wave Dark Menus"
#FALLBACK_THEME="Human"

env GTK2_RC_FILES="/usr/share/themes/$FALLBACK_THEME/gtk-2.0/gtkrc" firefox "$@"

