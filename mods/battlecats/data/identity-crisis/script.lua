function onEndSong()
	local isFirstClear = getVar("isFirst")
	if (isFirstClear) then
		local rewards = getVar('rewards')
		if (difficultyName == "chapter3") then
			addLS(2)
			table.insert(rewards, "LeaderShip + 2")
		else
			addLS(1)
			table.insert(rewards, "LeaderShip + 1")
		end
		setVar('rewards', rewards)
	end
end