local function parseCoord(text, key)
    local pattern = '"' .. key .. '"%s*:%s*%[%s*(%-?[%d%.]+)%s*,%s*(%-?[%d%.]+)%s*%]'
    local x, y = text:match(pattern)
    if x and y then
        return tonumber(x), tonumber(y)
    end
    return nil, nil
end

local function parseNumber(text, key)
    local pattern = '"' .. key .. '"%s*:%s*(%-?[%d%.]+)'
    local v = text:match(pattern)
    return tonumber(v)
end

local lastBgScript = nil

function onEvent(name, value1, value2)
    if name == 'ChangeBG' then
        local bgName = value1
        local scriptPath = 'stages/' .. bgName

        addLuaScript(scriptPath, true)

        local jsonText = getTextFromFile('stages/' .. bgName .. '.json')
        if jsonText then
            local bfX, bfY = parseCoord(jsonText, 'boyfriend')
            local dadX, dadY = parseCoord(jsonText, 'opponent')
            local zoom = parseNumber(jsonText, 'defaultZoom')

            if zoom then
                setProperty('camGame.zoom', zoom)
                setProperty('defaultCamZoom', zoom)
            end
            if bfX and bfY then
                setProperty('boyfriend.x', bfX)
                setProperty('boyfriend.y', bfY)
            end
            if dadX and dadY then
                setProperty('dad.x', dadX)
                setProperty('dad.y', dadY)
            end
        end

        lastBgScript = scriptPath
    end
end

function onCreate()
    makeLuaSprite('darkShader', nil, -500, -500)
    makeGraphic('darkShader', screenWidth * 2, screenHeight * 2, '000000')
    setObjectCamera('darkShader', 'hud')
    setScrollFactor('darkShader', 0, 0)
    setProperty('darkShader.alpha', 0)
    addLuaSprite('darkShader', true)
end