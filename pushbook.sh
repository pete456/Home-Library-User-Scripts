#!/bin/bash

server="192.168.4.182"
port=":8080"
tmp=~/.cache/getbooks
spath="/"
echo $spath > $tmp
while true; 
do
	input="$(printf "Save\n$(curl -s "$server$port$spath" | grep -e / )" | dmenu)"
	if [[ "$input" == "Save" ]]; then
		break
	fi
	if [[ $input == "" ]]; then
		if [ "$(wc -l $tmp | awk '{ print $1 }')" -eq 1 ]; then 
			exit 1
		fi
		sed -i $(($(wc -l $tmp | awk '{ print $1 }') - 1))q $tmp
		spath=$(tail -n 1 $tmp)
	else
		spath=$spath$input
		echo $spath >> $tmp
	fi
done
rsync -z -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" $1 book@$server:media/$(printf "$spath" | sed 's/^\///')
