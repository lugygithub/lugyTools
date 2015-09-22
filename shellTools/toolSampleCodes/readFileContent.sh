#!/bin/bash
# read a file line-by-line

filename="$1"

#IFS=''
count=0

while read -r line || [[ -n "$line" ]] # until \n or \r\n
#while read -r line                    # until null EOF, ex: `echo -e -n "line1\nline2\nsample">filename`
do
    name=$line
    echo -e "${count}:\t$name"
    count=`expr $count + 1`
done < "$filename"
