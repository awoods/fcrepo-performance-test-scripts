#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "There must be exactly 2 arguments!"
    echo " - number objects"
    echo " - binary size in bytes"
    exit 1;
fi

BASE=http://localhost:8080/rest/$RANDOM

# create a collection
curl -X PUT $BASE  && echo


FILE_SIZE_IN_KB=$2

BINARY_FILE=binary
dd if=/dev/zero of=$BINARY_FILE bs=1000 count=$FILE_SIZE_IN_KB

BEGIN=$(date +%s)
N=0
MAX=$1
while [ $N -lt $MAX ]; do
  # add a binary
  # change the binary file temptlate
  newBinary=${BINARY_FILE}_${N}.dat
  cp $BINARY_FILE $newBinary
  echo $N >> $newBinary
  MD5=`md5sum $newBinary | cut -f 1 -d ' '`
  echo MD5 of $newBinary is $MD5
  curl -i -X POST --data-binary "@$newBinary" -H"digest: md5=$MD5" $BASE
  rm $newBinary

  N=$(( $N + 1 ))

  if [ $(( $N % 10 )) == 0 ]; then
    echo $N binaries 
  fi
done

rm $BINARY_FILE

NOW=$(date +%s)
DIFF=$(($NOW - $BEGIN))
MINS=$(($DIFF / 60))
SECS=$(($DIFF % 60))
HOURS=$(($DIFF / 3600))
DAYS=$(($DIFF / 86400))
echo "Test: Upload $MAX unique $FILE_SIZE_IN_KB KB  binary files"
printf "\rTotal Elapsed Time: %3d Days, %02d:%02d:%02d" $DAYS $HOURS $MINS $SECS
