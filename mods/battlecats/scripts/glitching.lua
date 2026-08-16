local totalTime = 0

function onCreatePost()
    runHaxeCode([[
        if (!ClientPrefs.data.shaders) return;

        var glitchShader = game.createRuntimeShader('glitch');
        if (glitchShader != null) {
            glitchShader.setFloat('iTime', 0.0);
            glitchShader.setFloat('uIntensity', 0.0); // 기본값 0.0 (꺼짐)

            var filter = new openfl.filters.ShaderFilter(glitchShader);
            
            game.camGame.setFilters([filter]);
            game.camHUD.setFilters([filter]);
            if (game.camOther != null) {
                game.camOther.setFilters([filter]);
            }

            setVar('glitchShaderObj', glitchShader);
        }
    ]])
end

function onUpdate(elapsed)
    totalTime = totalTime + elapsed
    
    runHaxeCode([[
        var shader = getVar('glitchShaderObj');
        if (shader != null) {
            shader.setFloat('iTime', ]] .. totalTime .. [[);
        }
    ]])
end

-- 이벤트 트리거 처리
function onEvent(name, value1, value2)
    if name == 'glitch' or name == 'Glitch' then
        -- value1 문자열을 float로 변환 (비어있거나 숫자가 아니면 0.0 처리)
        local intensity = tonumber(value1) or 0.0
        
        runHaxeCode([[
            var shader = getVar('glitchShaderObj');
            if (shader != null) {
                shader.setFloat('uIntensity', ]] .. intensity .. [[);
            }
        ]])
    end
end