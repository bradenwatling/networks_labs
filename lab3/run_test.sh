#!/bin/bash

javac *.java
java part2_4 &
TBCHILD=$!
cd TokenBucket
javac *.java
java TrafficSink &
SINKCHILD=$!
java ReferenceTrafficGenerator localhost

sleep 2

kill $TBCHILD $SINKCHILD

wc -l ../bucket_2.4.txt
wc -l ../trafficsink_2.4.data

echo "Killed $TBCHILD, $SINKCHILD"
