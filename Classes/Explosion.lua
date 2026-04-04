local Explosion = {}
Explosion.__index = Explosion

function Explosion.new(handler,x,y,radius,damage,duration)
    local obj = setmetatable({},Explosion)

    obj.x = x or 0
    obj.y = y or 0
    obj.damage = damage or 5
    obj.duration = duration or 1
    obj.handler = handler
    obj.timer = 0 
    obj.radius = radius or 5
    obj.properties = {
        damage = {
        type = "Explosion",
        radius = obj.radius,
        damage = obj.damage,
        interval = 0,
        duration = 0,
        executable = function(self,enemy)
            enemy:damage(obj.damage)
        end
        },
    }

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
            enemy:hit(self.properties)
        end
    end
end

function Explosion:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle("fill",self.x,self.y,math.min(self.progress * 2 * self.radius,self.radius))
end


return Explosion