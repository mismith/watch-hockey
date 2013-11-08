to split(aString, delimiter)
	set retVal to {}
	set prevDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {delimiter}
	set retVal to every text item of aString
	set AppleScript's text item delimiters to prevDelimiter
	return retVal
end split
on list_position(this_item, this_list)
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then return i
	end repeat
	return 0
end list_position
on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on run {input, parameters}
	
	set userFriendlyNames to {}
	set feedURLs to {}
	
	repeat with game in split(item 1 of input, ",")
		set pieces to split(game, " ")
		set gametime to item 1 of pieces
		set t1loc to item 2 of pieces
		set t1name to item 3 of pieces
		set t1feed to item 4 of pieces
		set t2loc to item 5 of pieces
		set t2name to item 6 of pieces
		set t2feed to item 7 of pieces
		
		set loc to "v"
		set loc2 to "@"
		if t1loc is not "Home" then
			set loc to "@"
			set loc2 to "v"
		end if
		set end of userFriendlyNames to gametime & " - " & t1name & " (" & loc & " " & t2name & ")"
		set end of feedURLs to t1feed
		set end of userFriendlyNames to gametime & " - " & t2name & " (" & loc2 & " " & t1name & ")"
		set end of feedURLs to t2feed
	end repeat
	
	set selectedFeeds to choose from list userFriendlyNames with prompt "Which feed(s) would you like to watch?" with multiple selections allowed
	if (count of selectedFeeds) is greater than 0 then
		set selectedBitrate to choose from list {"400", "800", "1600", "3000", "4500"} with prompt "What bitrate do you want (kbps)?" default items {"800"}
		if (count of selectedBitrate) is 1 then
			repeat with i from 1 to the length of userFriendlyNames
				if selectedFeeds contains item i of userFriendlyNames then
					set feedURL to item i of feedURLs
					set feedURL to replace_chars(feedURL, "_3000.", "_" & selectedBitrate & ".")
					
					tell application "QuickTime Player"
						activate
						open URL feedURL
					end tell
				end if
			end repeat
		end if
	end if
	
end run