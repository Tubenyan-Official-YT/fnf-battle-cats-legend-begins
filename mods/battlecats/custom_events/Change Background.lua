local currentBg = ''

local bgConfigs = {
    ['noul'] = {scale = 6, x = -300, y = -300, scroll = 0.9, zoom = 0.9, bfY = 450, dadY = 450},
    ['night'] = {scale = 4, x = -1100, y = -800, scroll = 0.5, zoom = 0.6, bfY = 300, dadY = 400},
    -- gris 배경에서 보프는 삼각형 위(높은 곳), 바다레오파드는 바닥(낮은 곳)으로 설정
    ['gris'] = {scale = 5, x = -1550, y = -1300, scroll = 1.0, zoom = 0.3, bfY = -500, dadY = -1000},
	['desert'] = {scale = 2.5, x = -1700, y = -2000, scroll = 0.5, zoom = 0.4, bfY = 0, dadY = -200},
	['moon'] = {scale = 1.8, x = -1100, y = -2000, scroll = 0.5, zoom = 0.4, bfY = 1000, dadY = 200},
	['newmoon'] = {scale = 2.5, x = -1000, y = -600, scroll = 1.2, zoom = 0.4, bfY = 1000, dadY=500},
	['white'] = {scale = 1, x = -500, y = 0, scroll = 1, zoom = 0.4,bfY =400,dadY = -100}
}

function onCreate()
    -- 화면 전체를 덮는 검은 상자 (쉐이더 대용)
    makeLuaSprite('darkShader', nil, -500, -500)
    makeGraphic('darkShader', screenWidth * 2, screenHeight * 2, '000000')
	setObjectCamera('darkShader', 'hud')
    setScrollFactor('darkShader', 0, 0)
    setProperty('darkShader.alpha', 0) -- 처음엔 투명하게
    addLuaSprite('darkShader', true) -- true: 캐릭터보다 앞에 배치
end

function onEvent(name, value1, value2)
    if name == 'Change Background' then
		currentBg = value1
        local bgName = value1
        local config = bgConfigs[bgName]
		if value1 == "noul" or value1 == "night" or value1=="gris" or value1=="desert" or value1=="moon" then
			makeLuaSprite('topMask', nil, -1500, -1000) -- 아주 위쪽에 배치
			makeGraphic('topMask', screenWidth * 4, 1000, '003399') -- 넓고 두꺼운 검은색 바
			setScrollFactor('topMask', 0, 0) -- 카메라 움직임에 따라가지 않게 고정
			addLuaSprite('topMask', false) -- 캐릭터보다 뒤, 배경보다는 앞에 배치
		end
        if config then
            local tag = 'bgTag_' .. bgName 
            makeLuaSprite(tag, bgName, config.x, config.y)
            scaleObject(tag, config.scale, config.scale)
            addLuaSprite(tag, false)
			
			if value1 == 'white' then
				setSpriteShader('boyfriend', 'RTXLighting')
				setSpriteShader('dad', 'RTXLighting')
				setShaderSampler2('boyfriend', 'overlayColor', 0, 0, 0, 0)
				setShaderSampler2('dad', 'overlayColor', 0, 0, 0, 0)
				setShaderSampler2('boyfriend', 'satinColor', 0, 0, 0, 0)
				setShaderSampler2('dad', 'satinColor', 0, 0, 0, 0)
				setShaderSampler2('boyfriend', 'innerShadowColor', 0, 0, 0, 0)
				setShaderSampler2('dad', 'innerShadowColor', 0, 0, 0, 0)
			else
        -- 다른 배경일 때는 기존처럼 배경에 rtx 라이팅 적용
				initLuaShader('RTXLighting')
				setSpriteShader('boyfriend', 'RTXLighting')
				setSpriteShader('dad', 'RTXLighting')
				setSpriteShader(tag, 'RTXLighting')
			end
            -- 1. 줌 설정
            setProperty('camGame.zoom', config.zoom)
            setProperty('defaultCamZoom', config.zoom)

            -- 2. 보프 위치 (삼각형 위치에 맞춤)
			if boyfriendName == 'bf-back' then
				setProperty('boyfriend.x', 800)
				setProperty('boyfriend.y', config.bfY)
			else
				setProperty('boyfriend.x', 1100)
				setProperty('boyfriend.y', config.bfY)
			end
            
			if value1 == "newmoon" then
				setProperty('gf.y', 800)
			end
			
            -- 3. 적 위치
			if dadName == 'bunbun' then
				setProperty('dad.y', -300)
				runTimer('fixDadPos', 0.01)
			end
			
			if dadName == 'beach_leopard' then
                if bgName == 'gris' then
                    setProperty('dad.angle', -15) -- gris 배경에서 15도 기울임
                else
                    setProperty('dad.angle', -10)  -- 다른 배경에선 살짝만 기울임
                end
            else
				-- 바다레오파드가 아니면(돼지 등) 무조건 정자세
                setProperty('dad.angle', 0)
            end

            if lastBgTag and lastBgTag ~= tag then
                removeLuaSprite(lastBgTag, true)
            end
            lastBgTag = tag
			
        end
		if value1 == 'moon' then
            setProperty('darkShader.alpha', 0.5) -- 0.5만큼 어둡게 (숫자 키울수록 더 어두움)
			setObjectOrder('darkShader', getObjectOrder('boyfriend') + 10)
        else
            setProperty('darkShader.alpha', 0) -- 다른 배경에선 다시 밝게
        end
    end
end

function onUpdatePost()
	if lastBgTag == 'bgTag_moon' then
        setProperty('dad.x', 500) -- 이 수치를 조절해서 중앙을 맞추세요
		setProperty('boyfriend.y', 800)
    end
    -- lastBgTag가 'bgTag_gris'일 때 (즉, 현재 배경이 gris일 때)
    if lastBgTag == 'bgTag_gris' then
        -- 바다레오파드(beach_leopard)일 때만 Y 좌표를 강제로 -1000으로 고정합니다.
        if dadName == 'beach_leopard' then
            setProperty('dad.y', -100)
            setProperty('boyfriend.y', -1000)
        end
    end
end