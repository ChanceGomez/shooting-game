local Report = {}
Report.__index = Report

function Report:new()
    local obj = setmetatable({},Report)

    obj.enemyKilled = 0
    obj.loadedBullet = 0
    obj.discardedBullet = 0
    obj.shotFired = 0
    obj.shotHit = 0
    obj.damageDealt = 0

    return obj
end

function Report:action(action,info)
    local info = info or 1
    if self[action] then
        self[action] = self[action] + info
    end
end

return Report