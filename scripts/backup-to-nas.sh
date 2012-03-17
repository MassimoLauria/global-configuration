#!/bin/sh

# Script for regular backups on disk

RDIFF="rdiff-backup"
#DRYRUN="--compare"  #No dry run for rdiff-backup
OPT="-v5 --create-full-path"

INCLUDE_FILE="~/.rdiff-backup-include"

USAGE="\n
\n
Usage: $0\n
\n
This will backup the home directory in the backup location by\n
using \`rdiff-backup\' copying method.\n
\n
      <home> --> NAS:~/backup/<hostname>/<home>\n
\n
No argument required, just call the command from anywhere.\n"


######### Messages and error checking
if [ $# -gt 0 ]; then
    echo $USAGE
    exit 1
fi

if [ -f "$INCLUDE_FILE" ]; then
    INCOPT=" --include-globbing-filelist \"$INCLUDE_FILE\""
else
    INCOPT=""
fi

$RDIFF $DRYRUN $OPT $INCOPT $HOME nas::backup/`hostname`/$USER
