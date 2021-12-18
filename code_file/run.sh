#!/bin/bash
while true
do

for i in {1..100000}
do
  echo $i
  echo $i > $i
done

for i in {1..100000}
do
    rm -f $i
done

done
