#!/bin/bash

output="$(nmcli con show --active | sed -n '2p')"
name="$(echo "$output" | awk -F'  +' '{print $1}')"
isWifi=false
signal=0
isConnected=false

if ! echo "$output" | grep -q "ethernet" && [ -n "$name" ]; then
    isWifi=true
    signal="$(nmcli dev wifi | grep "$name" | sed -n '1p' | awk -F'  +' '{print $6}')"
fi

if ping -c 3 google.com 2> /dev/null | grep -q "64 bytes"; then
    isConnected=true
fi

printf "$name\n$isWifi\n$signal\n$isConnected"
