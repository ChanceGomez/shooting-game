local DamagePopup = {
    duration = 2,
}
DamagePopup.__index = DamagePopup



function DamagePopup:new(handler,x,y,damage)
    local obj = setmetatable({},DamagePopup)

    obj.timer = 0
    obj.x = x or 0
    obj.y = y or 0
    obj.damage = damage or 0
    obj.handler = handler

    return obj
end

function DamagePopup:delete()
    self.handler:deletePopup(self)
end

function DamagePopup:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.duration then
        self:delete()
    end
end

function DamagePopup:draw()
    love.graphics.setColor(.6,0,0,1)
    love.graphics.setFont(dogica_8)
    love.graphics.print(self.damage,self.x,self.y)
end

return DamagePopup