#!/bin/bash

output="$(acpi)"

if [[ -z "$(acpi 2> /dev/null)" ]]; then
    echo "noBattery"
    exit
fi

echo $(echo "$output" | sed -e 's/, /\n/g' | grep % | sed -e 's/%//g')

if echo $output | grep -q "Not charging"; then
		echo "charged"
elif echo $output | grep -q "Charging"; then
		echo "charging"
else
		echo "depleting"
fi
