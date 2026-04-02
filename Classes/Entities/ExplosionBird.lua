local ExplosionBird = {}
ExplosionBird.__index = ExplosionBird

setmetatable(ExplosionBird,{__index = Bird})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_explosionbird_flying")

function ExplosionBird:new(x,y,handler,difficulty,facing)
    local obj = Enemies.Bird:new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.health = 30 * (math.max(difficulty/2,1))
    obj.speed = 15 * (math.max(difficulty/6,1))
    obj.explosionRadius = 25
    obj.explosionDamage = 25
    obj.explosionDuration = .5
    obj.resources = 5

    obj.animations = {
        flying = flyingAnimation,
    }

    return obj
end

function ExplosionBird:escape()
    Enemy.escape(self)
end

function ExplosionBird:die()
    Enemy.die(self)
    game:getHandler():newExplosion(self.x+self.width/2,self.y+self.height/2,self.explosionRadius,self.explosionDamage,self.explosionDuration)
    Enemy.delete(self)
end

function ExplosionBird:hit(damage)
    Enemies.Bird.hit(self, damage)
end

function ExplosionBird:hitColor(dt)
    Enemies.Bird.hitColor(self,dt)
end

function ExplosionBird:isCollision()
    return Enemies.Bird.isCollision(self)
end

function ExplosionBird:update(dt)
    Enemies.Bird.update(self,dt)
end

function ExplosionBird:draw()
    Enemies.Bird.draw(self)
end

return ExplosionBird