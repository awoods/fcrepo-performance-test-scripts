#!/bin/bash

if [ "$1" == "" ]; then
    echo "There must be a exactly 1 argument!"
    echo "- number objects"
    exit 1;
fi

BASE=http://localhost:8080/rest/$RANDOM

curl -X PUT $BASE && echo

curl -X PUT -H "Content-Type: text/turtle" -d "
  @prefix test: <http://www.example.org/ns/test#> .
  <> a test:Container ." $BASE && echo

N=0
MAX=$1
while [ $N -lt $MAX ]; do

curl -s -X POST -H "Content-Type: text/turtle" -d "
  @prefix test: <http://www.example.org/ns/test#> .
  <> a test:Container ." $BASE/  > /dev/null

  N=$(( $N + 1 ))

  if [ $(( $N % 500 )) == 0 ]; then
    echo $N objects
  fi
done

echo retrieving $BASE to warm cache
time curl -s -H "Accept: application/n-triples" $BASE > /dev/null
echo retrieving $BASE
time curl -s -H "Accept: application/n-triples" $BASE > n-children.nt
CONTAINED=`grep -c 'ldp#contains' n-children.nt`
echo "Number of contained children: $CONTAINED"
