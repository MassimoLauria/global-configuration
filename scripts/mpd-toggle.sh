#!/bin/sh

usage="usage: $0 -c {play|pause|toggle}"
command=
increment=5%
mixer=Master

while getopts h o
do case "$o" in
    h) echo "$usage"; exit 0;;
    ?) echo "$usage"; exit 0;;
esac
done

shift $(($OPTIND - 1))
command=$1


title_text="MPD"
icon_name=""
       

if [ "$command" = "play" ]; then
        icon_name="notification-audio-play"
        body_text="<i>playing<\i>"
        mpc play  2>&1 > /dev/null
fi

if [ "$command" = "pause" ]; then
        icon_name="notification-audio-pause"
        body_text="<i>paused<\i>"
        mpc pause 2>&1 > /dev/null
fi


if [ "$command" = "toggle" ]; then
    if mpc toggle | grep "\[playing\]"; then
        icon_name="notification-audio-play"
        body_text="<i>playing<\i>"
    else
        icon_name="notification-audio-pause"
        body_text="<i>paused<\i>"
    fi
fi

if [ "$command" = "" -o "$icon_name" = "" ]; then
    echo "usage: $0 {play|pause|toggle}"
    exit 0;
fi




notify-send "$title_text" "$body_text" -i $icon_name -t 1
