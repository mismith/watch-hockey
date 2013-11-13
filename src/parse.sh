#!/bin/bash

curl -s http://dnalloheoj.com/nhl/log.txt | sed -E "s/^.*\. $|^\/\/ [^ ]+ | ET \/\/$//g; s/ @ |: /,/g" | tr '\n' ',' | sed -E 's/^,*//g; s/,*$//g; s/,,,/|/g'


## Turns a file like this:
#	URLs will appear 15min prior to start time. 
#	
#	// 11/08/2013 19:30 ET //
#	New Jersey Devils @ Toronto Maple Leafs
#	TOR: http://nlds138.cdnak.neulion.com/nlds/nhl/mapleleafs/as/live/mapleleafs_hd_3000.m3u8
#	NJD: http://nlds145.cdnak.neulion.com/nlds/nhl/devils/as/live/devils_hd_3000.m3u8
#	
#	
#	// 11/08/2013 20:00 ET //
#	Nashville Predators @ Winnipeg Jets
#	WPG: http://nlds135.cdnak.neulion.com/nlds/nhl/jets/as/live/jets_hd_3000.m3u8
#	NSH: http://nlds141.cdnak.neulion.com/nlds/nhl/predators/as/live/predators_hd_3000.m3u8
#	
#	
#	// 11/08/2013 21:00 ET //
#	Calgary Flames @ Colorado Avalanche
#	
#	
#	// 11/08/2013 22:00 ET //
#	Buffalo Sabres @ Anaheim Ducks
#	
#	
#


## Into a string like this:
# 11/08/2013 19:30,New Jersey Devils,Toronto Maple Leafs,TOR,http://nlds138.cdnak.neulion.com/nlds/nhl/mapleleafs/as/live/mapleleafs_hd_3000.m3u8,NJD,http://nlds145.cdnak.neulion.com/nlds/nhl/devils/as/live/devils_hd_3000.m3u8|11/08/2013 20:00,Nashville Predators,Winnipeg Jets,WPG,http://nlds135.cdnak.neulion.com/nlds/nhl/jets/as/live/jets_hd_3000.m3u8,NSH,http://nlds141.cdnak.neulion.com/nlds/nhl/predators/as/live/predators_hd_3000.m3u8|11/08/2013 21:00,Calgary Flames,Colorado Avalanche|11/08/2013 22:00,Buffalo Sabres,Anaheim Ducks