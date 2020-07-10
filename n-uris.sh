#!/bin/bash

if [ "$1" == "" ]; then
    echo "There must be a exactly 1 argument!"
    echo "- number objects"
    exit 1;
fi

BASE=http://localhost:8080/rest/$RANDOM
COL=$BASE/uriCollection

# create a collection
curl -X PUT $COL && echo

N=0
MAX=$1
while [ $N -lt $MAX ]; do
  # add a property
  curl -X PATCH -H "Content-Type: application/sparql-update" -d "
    prefix dc: <http://purl.org/dc/elements/1.1/>
    insert { <> dc:relation <http://example.org/uri/$N> } where { }" $COL

  N=$(( $N + 1 ))

  if [ $(( $N % 500 )) == 0 ]; then
    echo $N properties
  fi
done

echo retrieving $COL
time curl -s -H "Accept: application/n-triples" $COL > n-uris.nt
URIS=`grep -c relation n-uris.nt`
echo "Number of URI references from resource: $URIS"
