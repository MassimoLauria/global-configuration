#!/bin/sh

# Script for regular backups on disk

RSYNC="rsync"
OPT="-aHAX --progress"
#DRYRUN="--dry-run"
AUXOPT=" "

BACKUPSRCS=""
HOSTNAME=""
BACKUPTRGT="/media/disk/"`hostname`"-backup/"
EXCLUDE_FILE=".rsync-exclude"

USAGE="\n
\n
Usage: $0\n
\n
This will backup home directories on the relative backup location by\n
using rsync copying method.  The environment variable BACKUPSRCS in\n
file ~/personal/conf/shenv-personal determines what directories to\n
backup For each dir D in BACKUPSRCS, the file D/$EXCLUDE_FILE\n
determines what subfolder of D should be excluded from the backup.\n
\n
"

# Load backup srcs from common 
[ -f ~/personal/conf/shenv-personal ] && . ~/personal/conf/shenv-personal

######### Messages and error checking 
if [ $# -gt 0 ]; then
    echo $USAGE
    exit 1
fi


if [ "x$BACKUPSRCS" = "x" ]; then
    echo ""
    echo "Sorry, no directory configured for backup in BACKUPSRCS env. variable."
    echo ""
    exit 1
fi

###### Actual backup

echo "You'll may be requested for a SUDO authentication."

for src_dir in $BACKUPSRCS; do
    echo "----------<$n>--------------------"

    if [ -f $src_dir/$EXCLUDE_FILE ]; then
        AUXOPT=$AUXOPT" --exclude-from=$src_dir/$EXCLUDE_FILE"
    fi

    sudo $RSYNC $DRYRUN $OPT $AUXOPT $src_dir $BACKUPTRGT

    echo "----------<$n>--------------------"
    AUXOPT=""
done