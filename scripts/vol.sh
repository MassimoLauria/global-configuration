#!/bin/sh

command=
increment=5%
mute_mixer=Master
 vol_mixer=PCM
hdmi_mixer=IEC958


while getopts i:m:h o
do case "$o" in
    i) increment=$OPTARG;;
    m) mixer=$OPTARG;;
    h) echo "$usage"; exit 0;;
    ?) echo "$usage"; exit 0;;
esac
done

shift $(($OPTIND - 1))
command=$1

if [ "$command" = "" ]; then
    echo "usage: $0 {up|down|mute|hdmi} [increment]"
    exit 0;
fi

display_volume=0
icon_name=""
text_string=" "

if [ "$command" = "up" ]; then
    amixer set $mute_mixer unmute
    display_volume=$(amixer set $vol_mixer $increment+ unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
fi

if [ "$command" = "down" ]; then
    amixer set $mute_mixer unmute
    display_volume=$(amixer set $vol_mixer $increment- unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
fi


if [ "$command" = "mute" ]; then
    if amixer get $mute_mixer | grep "\[on\]"; then
        display_volume=0
        icon_name="notification-audio-volume-muted"
        amixer set $mute_mixer mute
    else
        amixer set $mute_mixer unmute
        display_volume=$(amixer get $vol_mixer | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
    fi
fi

if [ "$command" = "hdmi" ]; then
    icon_name="display"
    if amixer get $hdmi_mixer | grep "\[on\]"; then
        display_volume=0
        amixer set $hdmi_mixer mute
    else
        display_volume=$(amixer get $vol_mixer | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
        amixer set $hdmi_mixer unmute
    fi
fi


if [ "$icon_name" = "" ]; then
    if [ "$display_volume" = "0" ]; then
        icon_name="notification-audio-volume-off"
    else
        if [ "$display_volume" -lt "33" ]; then
            icon_name="notification-audio-volume-low"
        else
            if [ "$display_volume" -lt "67" ]; then
                icon_name="notification-audio-volume-medium"
            else
                icon_name="notification-audio-volume-high"
            fi
        fi
    fi
fi
notify-send "$text_string" -i $icon_name -h int:value:$display_volume -h string:synchronous:volume
