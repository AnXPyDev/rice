#!/bin/sh

sequence=$(echo "$2" | sed "s/;/\n/g")

found_current=
next=$(echo $2 | sed "1p")

current=

echo $sequence | while read current; do
    echo $current
done
