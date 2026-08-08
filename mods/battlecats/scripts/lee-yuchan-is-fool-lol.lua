function onUpdate(elapsed)
    local bfAnim = getProperty('boyfriend.animation.curAnim.name')
    local bfFinished = getProperty('boyfriend.animation.curAnim.finished')
    
    if bfAnim == 'SingLeft' and not bfFinished then
        setProperty('boyfriend.animation.curAnim.looped', true)
    elseif bfAnim == 'SingDown' and not bfFinished then
        setProperty('boyfriend.animation.curAnim.looped', true)
    elseif bfAnim == 'SingUp' and not bfFinished then
        setProperty('boyfriend.animation.curAnim.looped', true)
    elseif bfAnim == 'SingRight' and not bfFinished then
        setProperty('boyfriend.animation.curAnim.looped', true)
    end
end