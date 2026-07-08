local Explosion = {}
Explosion.__index = Explosion

function Explosion.new(handler,x,y,radius,damage,duration)
    local obj = setmetatable({},Explosion)

    obj.x = x or 0
    obj.y = y or 0
    obj.damage = damage or 5
    obj.duration = duration or .7
    obj.handler = handler
    obj.timer = 0 
    obj.radius = radius or 5
    obj.properties = {
        damage = {
        type = "Explosion",
        radius = deepCopy(obj.radius),
        damage = deepCopy(obj.damage),
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
        if enemy.currentExplosionDamage ~= self and enemy:checkCircleCollision(self,self.properties) then
            --Get bullets properties
            local properties = self.properties
            
            --Calculate all the effects
            for i, effect in pairs(properties) do 
                effect.damage = game.Affector:trigger(effect.type .. " Damage")
                effect.duration = game.Affector:trigger(effect.type .. " Duration")
            end

            --Send each effect to the enemy
            game.lookouts[1].handler:checkHit(properties)
        
            enemy.currentExplosionDamage = self
            enemy:hit(properties)
        end
    end

end

function Explosion:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle("fill",self.x,self.y,math.min(self.progress * 2 * self.radius,self.radius))
end


return Explosion