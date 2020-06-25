#!/bin/bash
FILES=../data

for file in $FILES
do
    python3 ./build_plot.py file
done
