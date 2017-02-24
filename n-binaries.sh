#!/bin/bash

BASE=http://localhost:8080/rest/$RANDOM

# create a collection
curl -X PUT $BASE  && echo

BEGIN=$(date +%s)
N=0
MAX=$1
while [ $N -lt $MAX ]; do
  # add a binary
  curl -i -X POST --data-binary "@picture-128KB.jpg" $BASE

  N=$(( $N + 1 ))

  if [ $(( $N % 10 )) == 0 ]; then
    echo $N binaries 
  fi
done


NOW=$(date +%s)
DIFF=$(($NOW - $BEGIN))
MINS=$(($DIFF / 60))
SECS=$(($DIFF % 60))
HOURS=$(($DIFF / 3600))
DAYS=$(($DIFF / 86400))
echo \n
echo "Test: Upload $MAX 128K binary files"
printf "\rTotal Elapsed Time: %3d Days, %02d:%02d:%02d" $DAYS $HOURS $MINS $SECS
