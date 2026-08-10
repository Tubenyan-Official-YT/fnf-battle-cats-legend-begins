local isWaterActive = false

function onCreatePost()
    -- 1. 모든 오브젝트 및 HUD 위에 덮일 0.4 알파 검은색 오버레이
    makeLuaSprite('waterBlackOverlay', '', 0, 0)
    makeGraphic('waterBlackOverlay', 1280, 720, '000000')
    setObjectCamera('waterBlackOverlay', 'other')
    setProperty('waterBlackOverlay.alpha', 0)
    addLuaSprite('waterBlackOverlay', true)

    -- 2. BlendMode 없이 행별 fillRect 계산으로 타원을 뚫는 파란색 마스크 생성
    runHaxeCode([[
        import openfl.display.BitmapData;
        import openfl.geom.Rectangle;
        import flixel.FlxSprite;

        // 0xCC = 알파 0.8, #030D22 = 어두운 남파랑
        var bmd = new BitmapData(1280, 720, true, 0xCC0058c4);

        var cx = 640.0; // 타원 중심 X
        var cy = 360.0; // 타원 중심 Y
        var rx = 500.0; // 가로 반지름 (전체 너비 1000)
        var ry = 300.0; // 세로 반지름 (전체 높이 600)

        // 타원 영역 내부만 투명(0x00000000)으로 채우기
        for (i in 0...600) {
            var y = 60 + i;
            var dy = (y - cy) / ry;
            var dx = rx * Math.sqrt(1.0 - (dy * dy));
            var xStart = cx - dx;
            var width = dx * 2.0;

            bmd.fillRect(new Rectangle(xStart, y, width, 1), 0x00000000);
        }

        var maskSprite = new FlxSprite(0, 0);
        maskSprite.pixels = bmd;
        maskSprite.cameras = [game.camOther]; // HUD 포함 최상단 카메라
        maskSprite.alpha = 0;
        game.add(maskSprite);
        setVar('waterBlueMask', maskSprite);
    ]])
end

function onEvent(eventName, value1, value2)
    if eventName == 'Water Submerge' or eventName == 'WaterSubmerge' then
        local duration = tonumber(value2) or 0.5
        
        if value1 == 'on' or value1 == '1' then
            doTweenAlpha('waterBlackFade', 'waterBlackOverlay', 0.4, duration, 'linear')
            runHaxeCode([[
                import flixel.tweens.FlxTween;
                var mask = getVar('waterBlueMask');
                if (mask != null) {
                    FlxTween.tween(mask, {alpha: 1.0}, ]] .. duration .. [[);
                }
            ]])
        elseif value1 == 'off' or value1 == '0' then
            doTweenAlpha('waterBlackFade', 'waterBlackOverlay', 0, duration, 'linear')
            runHaxeCode([[
                import flixel.tweens.FlxTween;
                var mask = getVar('waterBlueMask');
                if (mask != null) {
                    FlxTween.tween(mask, {alpha: 0.0}, ]] .. duration .. [[);
                }
            ]])
        end
    end
end