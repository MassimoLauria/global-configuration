#/bin/sh

start-stop-daemon -b -o -c $USER -S -x ~/.dropbox-dist/dropboxd
