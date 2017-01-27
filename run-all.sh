#!/bin/bash
for i in `ls n-*.sh`; 
do echo running $i with $1 items; 
. $i $1;
done;
