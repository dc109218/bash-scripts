#!/usr/bin/bash

#echo "alias c='clear'" >> 'C:\Program Files\Git\etc\profile.d\aliases.sh'
#echo "alias k='kubectl'" >> 'C:\Program Files\Git\etc\profile.d\aliases.sh'
#echo "alias d='docker'" >> 'C:\Program Files\Git\etc\profile.d\aliases.sh'

#create file
filename='alias_command.sh'
if [ -f $filename ]; then
   rm $filename
   echo "$filename is removed"
fi

