#!/bin/bash

server="192.168.4.182:8080"
tmp=~/.cache/getbooks
path="/"
echo $path > $tmp
while true; 
do
	input="$(curl -s "$server$path" | dmenu)"
	# Found pdf
	if $(echo "$input" | grep -q .pdf); then
		break
	fi
	if [[ $input == "" ]]; then
		if [ "$(wc -l $tmp | awk '{ print $1 }')" -eq 1 ]; then 
			exit 1
		fi
		sed -i $(($(wc -l $tmp | awk '{ print $1 }') - 1))q $tmp
		path=$(tail -n 1 $tmp)
	else
		path=$path$input
		echo $path >> $tmp
	fi
done
curl "$server$path$input" | zathura -

