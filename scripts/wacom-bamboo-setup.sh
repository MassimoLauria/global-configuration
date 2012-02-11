#!/bin/sh

# For LEFT handed users, buttons are (from top to bottom)
#
# 1, 9 , 8, 3
#   _________      ___
#  |      | 1|    |
# #|      | 9|____|
# #|      | 8|
#  |______|_3|
#

DEVNAME="Wacom BambooPT 2FG 4x5"

TOUCH_ACTIVE=no  # Unfortunately it does not work perfectly with linux.
LEFT_HANDED=yes  # The clever side of the world ;-)


# Device names
STYLUS="$DEVNAME Pen stylus"
ERASER="$DEVNAME Pen eraser"
TOUCH="$DEVNAME Finger touch"
PAD="$DEVNAME Finger pad"

# List of buttons from top to bottom
BUTTON_HH=3
BUTTON_HL=8
BUTTON_LH=9
BUTTON_LL=1


if [ "x$LEFT_HANDED" = "xyes" ]; then
    # Rotate the tablet
    xsetwacom set "$STYLUS" Rotate "HALF"
    xsetwacom set "$ERASER" Rotate "HALF"
    xsetwacom set "$TOUCH"  Rotate "HALF"
    xsetwacom set "$PAD"    Rotate "HALF"
    # Rotate button sequence
    BUTTON_HH=1
    BUTTON_HL=9
    BUTTON_LH=8
    BUTTON_LL=3
fi


## Stylus settings

# TODO: lighten the pressure-sensitivity



## Eraser settings

# TODO: lighten the pressure-sensitivity




## Touch settings

if [ "x$TOUCH_ACTIVE" = "xyes" ]; then
    xsetwacom set "$TOUCH" touch on
    xsetwacom set "$TOUCH" gesture on
else
    xsetwacom set "$TOUCH" touch off
    xsetwacom set "$TOUCH" gesture off
fi


## Buttons settings

xsetwacom set "$PAD" Button $BUTTON_HH 'key +ctrl z'        # undo
xsetwacom set "$PAD" Button $BUTTON_HL 'key +shift +ctrl z' # redo
xsetwacom set "$PAD" Button $BUTTON_LH 'key +ctrl'
xsetwacom set "$PAD" Button $BUTTON_LL 'key +shift'
