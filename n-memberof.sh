#!/bin/bash

BASE=http://localhost:8080/rest/$RANDOM
COL=$BASE/collection

curl -X PUT $BASE/objects && echo

# create a collection
curl -X PUT $COL && echo

N=0
MAX=$1
while [  $N -lt $MAX  ]; do
  # create an object
  OBJ=`curl -s -X POST -H "Content-Type: application/sparql-update" -d "
    prefix dc: <http://purl.org/dc/elements/1.1/>
    insert { <> dc:title \"this is object # $N\" } where { }" $BASE/objects`

  # create indirect container for members
  curl -s -X PUT -H "Content-Type: text/turtle" -d "
    @prefix ore: <http://www.openarchives.org/ore/terms/> .
    @prefix ldp: <http://www.w3.org/ns/ldp#> .
    @prefix pcdm: <http://pcdm.org/models#> .
    <> a ldp:IndirectContainer ;
         ldp:hasMemberRelation pcdm:memberOf ;
         ldp:insertedContentRelation ore:proxyIn ;
         ldp:membershipResource <$OBJ> ." $OBJ/membership > /dev/null

  # add membership proxy
  curl -s -X POST -H "Content-type: text/turtle" --data-binary "
    @prefix ore: <http://www.openarchives.org/ore/terms/> .
    <> a ore:Proxy ;
         ore:proxyFor <$OBJ> ;
         ore:proxyIn <$COL> ." $OBJ/membership > /dev/null

  N=$(( $N + 1 ))

  if [ $(( $N % 100 )) = 0 ]; then
    echo $N objects created
  fi
done

echo retrieving $COL without members
time curl -H "Accept: application/n-triples" $COL > n-members.nt
grep -c memberOf n-members.nt

echo "retrieving $COL with members (inbound links) once to warm cache"
time curl -H "Accept: application/n-triples" -H "Prefer: return=representation; include=\"http://fedora.info/definitions/v4/repository#InboundReferences\"" $COL 
echo "retrieving $COL with members (inbound links) from cache"
time curl -H "Accept: application/n-triples" -H "Prefer: return=representation; include=\"http://fedora.info/definitions/v4/repository#InboundReferences\"" $COL > n-members.nt
grep -c memberOf n-members.nt
