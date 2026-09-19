-- 'Change Character' 이벤트(내장 이벤트)가 보프/댐 오브젝트를 교체하면서
-- 위치가 스테이지 기본값으로 리셋되는 문제 보정.
-- Change Background.lua가 setVar로 저장해둔 현재 배경의 bfY/dadY를 다시 적용해줌.

function onEvent(name, value1, value2)
    if name ~= 'Change Character' then return end

    local target = (value1 or ''):lower()

    if target == 'bf' or target == 'boyfriend' or target == '0' then
        local bfY = tonumber(getVar('curBfY'))
        if bfY then
            setProperty('boyfriend.y', bfY)
            setProperty('boyfriend.x', 800)
        end
    elseif target == 'dad' or target == 'opponent' or target == '1' then
        local dadY = tonumber(getVar('curDadY'))
        if dadY then
            setProperty('dad.y', dadY)
        end
    end
end
