#!/bin/bash

BASE=http://localhost:8080/rest/$RANDOM
OBJ=$BASE/propsCollection

# create a collection
curl -X PUT $OBJ && echo

N=0
MAX=$1
while [ $N -lt $MAX ]; do
  # add a property
  curl -X PATCH -H "Content-Type: application/sparql-update" -d "
    prefix dc: <http://purl.org/dc/elements/1.1/>
    insert { <> dc:title \"this is object # $N\" } where { }" $OBJ

  N=$(( $N + 1 ))

  if [ $(( $N % 500 )) == 0 ]; then
    echo $N props
  fi
done

echo retrieving object
time curl -H "Accept: application/n-triples" $OBJ > 10k-props.nt
grep -c title 10k-props.nt
