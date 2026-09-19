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
		import flixel.FlxSprite;

		var W = 1280, H = 720;
		var baseColor:UInt = 0x0058c4;
		var baseAlpha:Int = 0xCC;

		var bmd = new BitmapData(W, H, true, (baseAlpha << 24) | baseColor);

		var cx = 640.0, cy = 360.0;
		var rx = 500.0, ry = 300.0;
		var featherNorm = 0.08; // 타원 경계 안쪽 8% 구간에서 부드럽게 페이드

		var minX = Std.int(Math.max(0, cx - rx - 20));
		var maxX = Std.int(Math.min(W - 1, cx + rx + 20));
		var minY = Std.int(Math.max(0, cy - ry - 20));
		var maxY = Std.int(Math.min(H - 1, cy + ry + 20));
		var innerEdge = 1.0 - featherNorm;

		for (py in minY...maxY + 1) {
			for (px in minX...maxX + 1) {
				var dx = (px - cx) / rx;
				var dy = (py - cy) / ry;
				var dist = Math.sqrt(dx * dx + dy * dy);

				var alphaFactor:Float;
				if (dist <= innerEdge) alphaFactor = 0.0;
				else if (dist >= 1.0) alphaFactor = 1.0;
				else {
					var t = (dist - innerEdge) / featherNorm;
					alphaFactor = t * t * (3 - 2 * t); // smoothstep
				}

				var a = Std.int(baseAlpha * alphaFactor);
				bmd.setPixel32(px, py, (a << 24) | baseColor);
			}
		}

		var maskSprite = new FlxSprite(0, 0);
		maskSprite.pixels = bmd;
		maskSprite.cameras = [game.camOther];
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