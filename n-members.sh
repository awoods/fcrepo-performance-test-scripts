#!/bin/bash

BASE=http://localhost:8080/rest/$RANDOM
COL=$BASE/memberCollection

curl -X PUT $BASE/objects && echo

# create a collection
curl -X PUT $COL && echo

# create indirect container for members
curl -X PUT -H "Content-Type: text/turtle" -d "
  @prefix ore: <http://www.openarchives.org/ore/terms/> .
  @prefix ldp: <http://www.w3.org/ns/ldp#> .
  @prefix pcdm: <http://pcdm.org/models#> .
  <> a ldp:IndirectContainer ;
       ldp:hasMemberRelation pcdm:hasMember ;
       ldp:insertedContentRelation ore:proxyFor ;
       ldp:membershipResource <$COL> ." $COL/members && echo

N=0
MAX=$1
while [ $N -lt $MAX ]; do
  # create an object
  OBJ=`curl -s -X POST -H "Content-Type: application/sparql-update" -d "
    prefix dc: <http://purl.org/dc/elements/1.1/>
    insert { <> dc:title \"this is object # $N\" } where { }" $BASE/objects`

  # add membership proxy
  curl -s -X POST -H "Content-type: text/turtle" --data-binary "
    @prefix ore: <http://www.openarchives.org/ore/terms/> .
    <> a ore:Proxy ;
         ore:proxyFor <$OBJ> ;
         ore:proxyIn <$COL> ." $COL/members > /dev/null

  N=$(( $N + 1 ))

  if [ $(( $N % 500 )) == 0 ]; then
    echo $N objects
  fi
done

echo retrieving $COL once to warm cache
time curl -H "Accept: application/n-triples" $COL | wc -l
echo "retrieving $COL (should be cached)" 
time curl -H "Accept: application/n-triples" $COL > n-members.nt
grep -c hasMember n-members.nt
