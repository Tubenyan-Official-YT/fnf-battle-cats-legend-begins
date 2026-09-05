setVar("pass10s", false)
trigger10 = getVar("pass10s")
howmuch = getVar("energyCost")
function onUpdate()
	if not trigger10 and songPosition >= 10000 then
		debugPrint("10초 지남")
		trigger10 = true
		setVar("pass10s", true)
		spendIt(howmuch)
	end
end