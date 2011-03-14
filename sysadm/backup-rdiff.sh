#!/bin/sh

# Script for regular backups on disk

RDIFF="rdiff-backup"
DRYRUN="--compare"  #No dry run for rdiff-backup
OPT="-v3"

BACKUPSRCS=""
BACKUPTRGT=""
HOSTNAME=""
#BACKUPTRGT="/media/disk/"`hostname`"-backup.rdiff"
INCLUDE_FILE=".rdiff-backup-include"

USAGE="\n
\n
Usage: $0\n
\n
This will backup home directories on the relative backup location by\n
using rsync copying method.  The environment variable BACKUPSRCS in\n
file ~/personal/conf/shenv-personal determines what directories to\n
backup For each dir D in BACKUPSRCS, the file D/$INCLUDE_FILE\n
determines what subfolder of D should be included/excluded from the backup.\n
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
    echo "Sorry, no backup sources configured in BACKUPSRCS env. variable."
    echo ""
    exit 1
fi

if [ "x$BACKUPTRGT" = "x" ]; then
    echo ""
    echo "Sorry, no backup target directory configured BACKUPTRGT env. variable."
    echo ""
    exit 1
fi


###### Actual backup

echo "You'll may be requested for a SUDO authentication."

for src_dir in $BACKUPSRCS; do

    n=$(basename $src_dir)
    echo "START-----<$n>--------------------"

    if [ -f $src_dir/$INCLUDE_FILE ]; then
        INCOPT=" --include-globbing-filelist $src_dir/$INCLUDE_FILE"
    else
        INCOPT=""
    fi

    $RDIFF $DRYRUN $OPT $INCOPT $src_dir $BACKUPTRGT/`hostname`/$n

    echo "END------<$n>--------------------"
done