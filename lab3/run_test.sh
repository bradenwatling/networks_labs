#!/bin/bash

javac *.java
java part4 & > /dev/null
TBCHILD=$!
cd TokenBucket
javac *.java
java TrafficSink &
SINKCHILD=$!
java MovieTrafficGenerator localhost

sleep 2

kill $TBCHILD $SINKCHILD

wc -l ../bucket_4.txt
wc -l ../trafficsink_4.data

echo "Killed $TBCHILD, $SINKCHILD"
