#!/bin/bash

i=0;
games="";
game="";

for str in $(curl -s http://dnalloheoj.com/nhl/log.txt);
do
	j=$((i%14));
	
	case $j in
		2) game="$str";;
		5 | 10) str=$(sed "s/://" <<< $str); game="$game $str";;
		6 | 8 | 11) game="$game $str";;
		13) game="$game $str";
			if [ "$games" == "" ]; then
				games="$game"
			else
				games="$games,$game"
			fi
			;;
	esac;
	
	let i=i+1;
done

echo $games