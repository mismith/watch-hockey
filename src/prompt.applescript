-- helper functions
to split(aString, delimiter)
	set retVal to {}
	set prevDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {delimiter}
	set retVal to every text item of aString
	set AppleScript's text item delimiters to prevDelimiter
	return retVal
end split
on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on run {input, parameters}
	
	set propertyListPath to "~/Library/Preferences/com.mismith.watchhockey.plist"
	set userFriendlyNames to {}
	set feedURLs to {}
	
	-- turn shell script output into applescript variables
	repeat with game in split(item 1 of input, "|")
		set pieces to split(game, ",")
		
		if (count of pieces) is 7 then
			--set t1code to item 6 of pieces
			--set t2code to item 4 of pieces
			
			set t1feed to item 7 of pieces
			set t2feed to item 5 of pieces
			
			set end of feedURLs to t1feed
			set end of feedURLs to t2feed
		end if
		
		set gametime to item 1 of pieces
		set t1name to item 2 of pieces
		set t2name to item 3 of pieces
		
		set userFriendlyName to gametime & " - " & t1name & " (@ " & t2name & ")"
		if (count of pieces) is not 7 then set userFriendlyName to "Available around " & userFriendlyName
		set end of userFriendlyNames to userFriendlyName
		
		set userFriendlyName to gametime & " - " & t2name & " (@ " & t1name & ")"
		if (count of pieces) is not 7 then set userFriendlyName to "Available around " & userFriendlyName
		set end of userFriendlyNames to userFriendlyName
	end repeat
	
	-- handle user interaction
	if (count of userFriendlyNames) is greater than 0 then
		
		-- prompt with list of available feeds
		set selectedFeeds to choose from list userFriendlyNames with prompt "Which feed(s) would you like to watch?" with multiple selections allowed
		if (count of selectedFeeds) is greater than 0 then
			
			-- prompt with list of available bitrates
			set defaultBitrate to "3000"
			try
				-- load default bitrate, if present
				tell application "System Events"
					tell property list file propertyListPath
						tell contents
							set defaultBitrate to value of property list item "defaultBitrate"
						end tell
					end tell
				end tell
			end try
			set selectedBitrate to choose from list {"400", "800", "1600", "3000", "4500"} with prompt "What bitrate do you want (kbps)?" default items {defaultBitrate}
			if (count of selectedBitrate) is 1 then
				
				-- save selected bitrate as default for next time
				tell application "System Events"
					-- create an empty property list dictionary item
					set the parent_dictionary to make new property list item with properties {kind:record}
					-- create new property list file using the empty dictionary list item as contents
					set this_plistfile to make new property list file with properties {contents:parent_dictionary, name:propertyListPath}
					-- add new property list items of each of the supported types
					make new property list item at end of property list items of contents of this_plistfile with properties {kind:string, name:"defaultBitrate", value:selectedBitrate}
				end tell
				
				-- open all the feeds in quicktime
				repeat with i from 1 to the length of userFriendlyNames
					if selectedFeeds contains item i of userFriendlyNames then
						if (count of feedURLs) is greater than or equal to i then
							set feedURL to item i of feedURLs
							set feedURL to replace_chars(feedURL, "_3000.", "_" & selectedBitrate & ".")
							
							tell application "QuickTime Player"
								activate
								open URL feedURL
							end tell
						end if
					end if
				end repeat
				
			end if
		end if
	else
		display alert "Either something went wrong or there aren't any games streaming right now. Check back up to 15 minutes before game time."
	end if
	
end run