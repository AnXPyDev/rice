#!/bin/sh

find ~/.wallpapers/ -type f | shuf -n 1 | xargs feh --bg-scale
