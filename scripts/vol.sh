#!/bin/bash

# This script is to control volume
#
# Unfortunately the weird behaviour of my system requires two
# different utilities to control volume.
#
# `pacmd` is required to toggle mute/unmute
# `amixer` is required to control the volume (of the 'PCM') channel
#
# Furthermore, since the audio goes throught HDMI output, I need
# a different command to mute the monitor (in case I use headphones)
#
# Oh, and of course the volume managing does not work for headphones.

# Save the notification ID for later use.
NOTIFICATION_ID_FILE_NAME=~/.id_volume_notification_awesome

# Command parameters
command=
increment=5%
mute_mixer=Master
 vol_mixer=PCM
hdmi_mixer=IEC958

# Determine if I should use 'Master' or 'PCM' to control volume
# it is an heuristic working on my machines.
amixer get $vol_mixer >/dev/null || vol_mixer="Master"


# Output text patterns
text_vol__change=' Volume %3d '
text_snd___muted=' Sound  OFF '
text_snd_unmuted=' Sound   ON '
text_mon___muted=' Speaker OFF'
text_mon_unmuted=' Speaker ON '


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
    pacmd set-sink-mute 0 0 >/dev/null
    display_volume=$(amixer set $vol_mixer $increment+ unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
    output_string=`printf "$text_vol__change" "$display_volume"`
fi

if [ "$command" = "down" ]; then
    pacmd set-sink-mute 0 0 >/dev/null
    display_volume=$(amixer set $vol_mixer $increment- unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
    output_string=`printf "$text_vol__change" "$display_volume"`
fi


if [ "$command" = "mute" ]; then
    if amixer get $mute_mixer | grep "\[on\]"; then
        display_volume=0
        pacmd set-sink-mute 0 1 >/dev/null
        #amixer set $mute_mixer mute
        output_string=$text_snd___muted
    else
        pacmd set-sink-mute 0 0 >/dev/null
        #amixer set $mute_mixer unmute
        display_volume=$(amixer get $vol_mixer | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
        output_string=$text_snd_unmuted
    fi
fi

if [ "$command" = "hdmi" ]; then
    icon_name="display"
    if amixer get $hdmi_mixer | grep "\[on\]"; then
        display_volume=0
        amixer set $hdmi_mixer mute
        output_string=$text_mon___muted
    else
        display_volume=$(amixer get $vol_mixer | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
        amixer set $hdmi_mixer unmute
        output_string=$text_mon_unmuted
    fi
fi


if [ "$icon_name" = "" ]; then
    if [ "$display_volume" = "0" ]; then
        icon_name="audio-volume-muted"
    else
        if [ "$display_volume" -lt "33" ]; then
            icon_name="audio-volume-low"
        else
            if [ "$display_volume" -lt "67" ]; then
                icon_name="audio-volume-medium"
            else
                icon_name="audio-volume-high"
            fi
        fi
    fi
fi


## Recover the id of the last volume notification (check if it is a number)
LAST_ID=`cat "$NOTIFICATION_ID_FILE_NAME" 2>/dev/null |cut -d' ' -f5 2>/dev/null`
case $LAST_ID in
    ''|*[!0-9]*) LAST_ID="nil" ;;
    *)  ;;
esac


# Notify the volume setting changes
awesome-client > $NOTIFICATION_ID_FILE_NAME <<EOF
notification=naughty.notify({ text="$output_string", timeout=1.5, replaces_id=$LAST_ID , icon="$icon_name"});
return notification.id
EOF

