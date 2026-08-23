-- Event by Stinko
function onCreatePost()
	luaDebugMode = true;
------------------------------------------------BG
	makeLuaSprite('BG', image, 0, 500)
	makeGraphic('BG', 400, 75, '000000')
	setProperty('BG.alpha', 1)
	addLuaSprite('BG', true)
	setObjectCamera('BG', 'camHUD')
	setProperty('BG.visible', false)
	screenCenter('BG', 'x')
	setObjectOrder('BG', 20)
	setProperty('BG.alpha', 0.65)
------------------------------------------------Text
	makeLuaText('subText', '', 0, 0, 550)
    setObjectCamera('subText', 'camHUD')
	screenCenter('subText', 'x')
	addLuaText('subText')
	setObjectOrder('subText', 21)
	setProperty('subText.visible', false)
	setTextFont('subText', 'subtitle.ttf')
	setTextBorder('subText', 0, 'black')
	setTextSize('subText', 32)
	setTextWidth('subText', 400)
	--setTextHeight('subText', 150)
end

function onEvent(name, value1, value2, strumTime)
	if name == 'show subtitle' then
		if value1 == '' then
			setProperty('BG.visible', false)
			setProperty('subText.visible', false)
			setProperty("subText.y", getProperty("BG.y") + (getProperty("BG.height") - getProperty("subText.height")) / 2)
			doTweenColor('TextColor', 'subText', '' .. value2 .. '', 0.001)
		else
			setProperty('BG.visible', true)
			setProperty('subText.visible', true)
			-- 번역: lang 파일에 키가 있으면 번역, 없으면 원문 그대로
			setProperty('subText.text', getTranslationPhrase(value1, value1))
			screenCenter('subText', 'x')
			setProperty("subText.y", getProperty("BG.y") + (getProperty("BG.height") - getProperty("subText.height")) / 2)
			doTweenColor('TextColor', 'subText', '' .. value2 .. '', 0.001)
		end
	end

end
