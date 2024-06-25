#! /usr/bin/bash

echo "hello hum ok" > test.txt
filename='test.txt'

echo "hello hum ok" > test1.txt
filename='test1.txt'

files=""
space=" "

# Check the multiple filenames are given or not
if [ $# > 2 ]; then
    # Reading argument values using loop
    for argval in "$@"
    do
      if [ -f $argval ]; then
            files+=$argval$space
      else
         echo "$argval does not exist"
      fi
    done

   # Remove files
   rm -rf $files
   echo "files are removed."
else
   echo "Filenames are not provided, or filename does not exist"
fi