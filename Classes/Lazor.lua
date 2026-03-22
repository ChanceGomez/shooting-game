local Lazor = {}
Lazor.__index = Lazor

function Lazor:new(x,y,time,size)
    local obj = setmetatable({},Lazor)

    obj.aliveTimer = time or 1
    obj.timer = 0
    obj.x = x or 0
    obj.y = y or 0
    obj.size = size or 4



    return obj
end

function Lazor:delete()

end

function Lazor:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.aliveTimer then
        self:delete()
    end
end

function Lazor:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill",self.x,self.y,Width,size)
end

return Lazor