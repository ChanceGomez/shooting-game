local Explosion = {}
Explosion.__index = Explosion

function Explosion:new(handler,x,y,radius,damage,duration)
    local obj = setmetatable({},Explosion)

    obj.x = x or 0
    obj.y = y or 0
    obj.radius = radius or 5
    obj.damage = damage or 5
    obj.duration = duration or 1
    obj.handler = handler
    obj.timer = 0 

    return obj
end

function Explosion:delete()
    self.handler:removeExplosion(self)
end

function Explosion:update(dt)
    self.timer = self.timer + dt
    self.progress = self.timer / self.duration

    if self.timer >= self.duration then
        self:delete()
    end

    --Check for enemies in explosion
    for i, enemy in ipairs(self.handler.enemies) do
        if collision.circleRect(self,enemy) and enemy.currentExplosionDamage ~= self then
            enemy.currentExplosionDamage = self
            enemy:hit({damage = self.damage})
        end
    end
    --Check for parachutes
    for i, parachute in ipairs(self.handler.parachutes) do
        local crate = parachute.crate
        if collision.circleRect(self,crate) and crate.currentExplosionDamage ~= self then
            parachute.currentExplosionDamage = self
            parachute:hit({damage = self.damage})
        end
    end
end

function Explosion:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle("fill",self.x,self.y,math.min(self.progress * 2 * self.radius,self.radius))
end


return Explosion