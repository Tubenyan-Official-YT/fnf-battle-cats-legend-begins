function onEndSong()
	local id = loadedSongPath .. difficultyPath
	
	if (id == "identity-crisis-chapter1") then
		unlockState("mission")
	end
	
	if (id == "identity-crisis-chapter2") then
		unlockState("freeplay")
	end
	
	if (id == "identity-crisis-chapter3") then
		unlockState("charselect")
	end
end