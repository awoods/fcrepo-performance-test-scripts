#!/bin/bash

BASE=http://localhost:8080/rest/$RANDOM

curl -X PUT $BASE && echo

curl -X PUT -H "Content-Type: text/turtle" -d "
  @prefix ldp: <http://www.w3.org/ns/ldp#> .
  <> a ldp:Container ." $BASE && echo

N=0
MAX=$1
while [ $N -lt $MAX ]; do

curl -X PUT -H "Content-Type: text/turtle" -d "
  @prefix ldp: <http://www.w3.org/ns/ldp#> .
  <> a ldp:Container ." $BASE/$N  > /dev/null

  N=$(( $N + 1 ))

  if [ $(( $N % 500 )) == 0 ]; then
    echo $N objects
  fi
done

echo retrieving $BASE
time curl -H "Accept: application/n-triples" $BASE > n-children.nt
grep -c hasMember n-children.nt
