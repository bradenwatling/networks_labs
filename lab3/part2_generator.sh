#!/bin/bash

java PoissonTrafficGenerator localhost &
java MovieTrafficGenerator localhost &

wait %1 %2
