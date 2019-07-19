#!/bin/bash

echo $(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}')
echo $(free | grep Mem | awk '{print $3/$2 * 100.0}')
