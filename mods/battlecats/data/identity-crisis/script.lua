local rewards = getVar('rewards')
table.insert(rewards, "LeaderShip + 2")
function onCreate()
	if (difficultyName == "chapter3") then
		addLS(2)
	else
		addLS(1)
	end
end