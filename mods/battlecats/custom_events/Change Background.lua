-- 배경별 위치/줌/특수효과만 담는 얇은 테이블 (이미지는 stages/*.lua가 담당)
local bgMeta = {
    ['noul']    = {zoom = 0.9, bfY = 450,  dadY = 450,  topMask = true},
    ['night']   = {zoom = 0.6, bfY = 300,  dadY = 400,  topMask = true},
    ['gris']    = {zoom = 0.3, bfY = -500, dadY = -1000, topMask = true},
    ['desert']  = {zoom = 0.4, bfY = 0,    dadY = -200, topMask = true},
    ['moon']    = {zoom = 0.4, bfY = 1000, dadY = 200,  topMask = true, darkShaderAlpha = 0.5},
    ['newmoon'] = {zoom = 0.4, bfY = 100,  dadY = 500},
    ['white']   = {zoom = 0.4, bfY = 400,  dadY = -100, whiteShader = true},
}

local currentStage = nil

function onCreate()
    setVar('bgSpriteList', '')
end

function clearBG()
    local list = getVar('bgSpriteList')
    if list and list ~= '' then
        for tag in string.gmatch(list, '([^,]+)') do
            removeLuaSprite(tag, true)
        end
    end
    setVar('bgSpriteList', '')

    if luaSpriteExists('topMask') then removeLuaSprite('topMask', true) end
end

function onEvent(name, value1, value2)
    if name ~= 'Change Background' then return end

    local bgName = value1
    local meta = bgMeta[bgName]
    if not meta then return end

    if currentStage then
        removeLuaScript('stages/' .. currentStage)
    end
    clearBG()
    addLuaScript('stages/' .. bgName)
    currentStage = bgName

    if meta.topMask then
        makeLuaSprite('topMask', nil, -1500, -1000)
        makeGraphic('topMask', screenWidth * 4, 1000, '003399')
        setScrollFactor('topMask', 0, 0)
        addLuaSprite('topMask', false)
    end

    setProperty('camGame.zoom', meta.zoom)
    setProperty('defaultCamZoom', meta.zoom)
    setProperty('boyfriend.x', 800)
    setProperty('boyfriend.y', meta.bfY)
    setProperty('dad.y', meta.dadY)

    if bgName == 'newmoon' then
        setProperty('gf.y', 800)
    end

    if meta.whiteShader then
        setSpriteShader('boyfriend', 'RTXLighting')
        setSpriteShader('dad', 'RTXLighting')
        setShaderSampler2('boyfriend', 'overlayColor', 0, 0, 0, 0)
        setShaderSampler2('dad', 'overlayColor', 0, 0, 0, 0)
        setShaderSampler2('boyfriend', 'satinColor', 0, 0, 0, 0)
        setShaderSampler2('dad', 'satinColor', 0, 0, 0, 0)
        setShaderSampler2('boyfriend', 'innerShadowColor', 0, 0, 0, 0)
        setShaderSampler2('dad', 'innerShadowColor', 0, 0, 0, 0)
    else
        initLuaShader('RTXLighting')
        setSpriteShader('boyfriend', 'RTXLighting')
        setSpriteShader('dad', 'RTXLighting')
    end

    if dadName == 'bunbun' then
        setProperty('dad.y', -300)
        runTimer('fixDadPos', 0.01)
    end

    if dadName == 'beach_leopard' then
        if bgName == 'gris' then
            setProperty('dad.angle', -15)
        else
            setProperty('dad.angle', -10)
        end
    else
        setProperty('dad.angle', 0)
    end

    if bgName == 'moon' and meta.darkShaderAlpha then
        setProperty('darkShader.alpha', meta.darkShaderAlpha)
        setObjectOrder('darkShader', getObjectOrder('boyfriend') + 10)
    end
end

function onUpdatePost()
    if currentStage == 'moon' then
        setProperty('dad.x', 500)
        setProperty('boyfriend.y', 800)
    end
    if currentStage == 'gris' and dadName == 'beach_leopard' then
        setProperty('dad.y', -100)
        setProperty('boyfriend.y', -1000)
    end
end
