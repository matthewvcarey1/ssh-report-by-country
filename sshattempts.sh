#!/usr/bin/env bash

enable -f /usr/lib/bash/csv csv

declare -A countryArray

countrycodefile="countrycodes.csv"



if [[ ! -f $countrycodefile ]]; then
   curl https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/refs/heads/master/all/all.csv > $countrycodefile
fi

while IFS= read -r line;do
    csv -a aVar "$line"
	countryArray[${aVar[1]}]="${aVar[0]}"
done < $countrycodefile


# We create an associative array so that we only call ipinfo.io for new
# ip addresses

declare -A ip_array
for i in $(tail -n 500 /var/log/auth.log | grep 'sshd' | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}' )
do
	if [[ -n "${ip_array[$i]}" ]]
	then
		echo ${ip_array[${i}]}
	else
	    country=$(curl 'https://ipinfo.io/'$i 2>/dev/null | jq '.country' | sed 's/"//g')
		countryName=${countryArray[${country}]}
		ip_array[${i}]=${countryName}
		echo ${countryName}
	fi	
done 
# run it like this to get a report by country
# ./sshattempts.sh | sort | uniq -c
