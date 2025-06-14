#!/bin/sh

tmpfile=$(mktemp -u --suffix ".txt")

/home/${USER}/bin/sshattempts.sh	 | sort | uniq -c | sort -rn >> $tmpfile;

kdialog --textbox $tmpfile --geometry 500x350+500+500 --title "Recent ssh attempts by country"

rm $tmpfile
