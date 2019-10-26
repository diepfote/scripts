#!/bin/bash

DIR=~/Documents
FILES="$@"

iterate_files()
{
  command="$1"

  for file in $FILES; do
    echo "$command $DIR/$file"
    $(echo "$command $DIR/$file")
  done

}


#asdf()
#{
  #echo blub
#}
#trap 'asdf' EXIT


trap 'echo; iterate_files "sudo chown -R root:root"; iterate_files "sudo chmod -R 000"' EXIT

iterate_files "sudo chown -R $USER:$USER"
iterate_files 'sudo chmod -R 700'

while (true); do
  sudo echo -en '\r...'
  sleep 60
done


sleep infinity

