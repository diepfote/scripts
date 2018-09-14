#!/bin/bash

TMP_DIR=$(mktemp -d)
TMP_FILE=$TMP_DIR/tmp_rk_form.html
trap "rm -rf $TMP_DIR" EXIT

user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

dir=$user_dir/Documents/passwds

if [ ! -d $dir ]; then
  dir=$user_dir/Dokumente/passwds
fi

PASSPHRASE=$1
PASS_FILE=$(find $dir -name 'rk*.txt.gpg' 2>/dev/null)

PASS=`echo $PASSPHRASE | gpg -d --batch --passphrase-fd 0 $PASS_FILE 2>/dev/null | head -n 1`

HTML="<html><body><form id="rk_form" action="https://kurse.***REMOVED***/login/index.php" method="post"><input name="username" value='LVREDCROSS\\***REMOVED***'><input name="password" value='"$PASS"'></form><script>rk_form = document.forms['rk_form']; rk_form.submit(); </script></body></html>"

echo -e $HTML

# write html to file
echo $HTML > $TMP_FILE

# call chrome
vivaldi-stable $TMP_FILE 2> /dev/null 1> /dev/null &

if [ "$?" -eq 127 ]; then # chromium not found
  chromium-browser $TMP_FILE 2> /dev/null 1> /dev/null
fi

sleep 1.1

