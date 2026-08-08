function onCreate()
    makeLuaSprite('stageBackground2', 'moon', -1600, -2000)
    scaleObject('stageBackground2', 1.8, 1.8)
    setScrollFactor('stageBackground2', 0.5, 0.5)
    addLuaSprite('stageBackground2', false)

    makeLuaSprite('darkShader', nil, -500, -500)
    makeGraphic('darkShader', screenWidth * 2, screenHeight * 2, '000000')
    setObjectCamera('darkShader', 'hud')
    setScrollFactor('darkShader', 0, 0)
    setProperty('darkShader.alpha', 0.5)
    addLuaSprite('darkShader', true)
end
