#!/bin/bash
set -e

DATE=`date '+%Y.%m.%d %H.%M.%S'`

OLDEST=`tarsnap --list-archives | sort | head --lines=1`

echo -n $DATE >> ~/backup-log.txt

echo -n ' ' >> ~/backup-log.txt

tarsnap -c --quiet -f "full@$DATE" \
--exclude dev --exclude proc --exclude sys --exclude tmp --exclude run --exclude mnt \
--exclude media --exclude lost+found \
--exclude home/tyler/torrent --exclude home/tyler/tmp --exclude home/tyler/Downloads \
--exclude var/lib/pacman/sync/* --exclude var/log/journal/* / \
2>&1 | awk 'BEGIN{ORS=""}$1$2=="Newdata"{print $5$6 " "}' >> ~/backup-log.txt \
|| echo -n "error " >> ~/backup-log.txt

date +%H.%M.%S >> ~/backup-log.txt

if (( $(tarsnap --list-archives | wc -l) >=3 )); then tarsnap -df "$OLDEST"; fi
