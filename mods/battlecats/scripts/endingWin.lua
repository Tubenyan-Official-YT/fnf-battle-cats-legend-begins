setVar('rewards', [])

local rewards = getVar("rewards")
local rewardTxt = ""
function onSongEnd()
	makeLuaSprite('mySprite', 'endsong/win', x, y)  -- 완전승리
	addLuaSprite('mySprite')
	if rewards != [] then
		local step = 0
		for reward in rewards then -- 두 개마다 줄바꿈
			rewardTxt += reward
			step += 1
			if step = 2 then
				step = 0
				rewardTxt += "\n"
			end
		end
		makeLuaSprite('mySprite', 'endsong/rewards', 0, 0)  -- 리워드를 담는 창
		screenCenter('mySprite', 'x')
		local h = getProperty('mySprite.height')
		setProperty('mySprite.y', FlxG.height * 0.75 - h / 2) -- 화면 2분할 중 아래쪽의 중간에 오게하기위함
		addLuaSprite('mySprite')
		
		makeLuaText('myText', rewardTxt, 600, 0, 300)  -- 리워드 텍스트
		setTextSize('myText', 20)
		setTextFont('myText', 'title.otf')
		setTextAlignment('myText', 'center')
		
		addLuaText('myText')
	end
end
--기준오브젝트 좌표 + (기준오브젝트 크기 − 내 크기) ÷ 2