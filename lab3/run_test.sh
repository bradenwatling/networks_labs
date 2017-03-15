#!/bin/bash

javac *.java
java part2_4 &
TBCHILD=$!
cd TokenBucket
javac *.java
java TrafficSink &
SINKCHILD=$!
java ReferenceTrafficGenerator localhost

sleep 1

kill $TBCHILD $SINKCHILD

echo "Killed $TBCHILD, $SINKCHILD"
