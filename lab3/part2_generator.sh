#!/bin/bash

cleanup() { kill $POISSON $MOVIE; }

trap cleanup SIGINT SIGTERM

java PoissonTrafficGenerator localhost &
POISSON=$!
java MovieTrafficGenerator localhost &
MOVIE=$!

wait %1 %2
