#!/bin/sh

USER=`whoami`
WINEPREFIX="$HOME/.wine" 
RUNNING_PATH="$HOME/.wine/drive_c/users/$USER/Application Data/Spotify"
PROGRAM_PATH="C:\\users\\$USER\\Application Data\\Spotify\\Spotify.exe"

cd "$RUNNING_PATH"
nohup wine "$PROGRAM_PATH" >$HOME/.spotify.wine.log 2>&1 &

