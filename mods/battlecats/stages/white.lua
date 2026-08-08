function onCreate()
    makeLuaSprite('whiteBG', nil, -2000, -2000)
    makeGraphic('whiteBG', screenWidth * 6, screenHeight * 6, 'FFFFFF')
    setScrollFactor('whiteBG', 0, 0)
    addLuaSprite('whiteBG', false)
end
