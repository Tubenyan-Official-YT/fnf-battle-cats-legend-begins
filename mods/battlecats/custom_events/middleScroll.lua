function onEvent(name, value1, value2)
	if name == "middleScroll" then
		if value1 == "true" or value1 == "1" then
			-- 미들스크롤 켜기: 상대 스트럼을 내 스트럼 위치로 겹침
			for i = 0, 3 do
				local px = getProperty('playerStrums.members[' .. i .. '].x')
				setProperty('opponentStrums.members[' .. i .. '].x', px)
			end
		else
			-- 미들스크롤 끄기: 원래 위치로 복구
			for i = 0, 3 do
				local ox = getVar('defaultOpponentStrumX' .. i)
				setProperty('opponentStrums.members[' .. i .. '].x', ox)
			end
		end
	end
end
